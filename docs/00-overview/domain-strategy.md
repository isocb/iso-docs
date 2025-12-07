Here’s a draft you can drop in as `docs/core/multi-tenant-domains.md`:

````md
---
title: Multi-Tenant Domains
description: How IsoStack maps hostnames to organisations, branding, and modules
status: draft
version: 0.1.0
---

# Multi-Tenant Domains

IsoStack supports **multi-tenant, multi-domain** access to the same platform runtime.

This document defines:

- How domains are mapped to organisations (tenants)
- How branding and default modules are derived from the hostname
- The expected DNS and Cloudflare configuration
- Security considerations for host-based tenancy

It is the **source of truth** for domain handling across IsoStack Core and all modules.

---

## 1. High-level goals

1. A single IsoStack Core deployment can serve many tenants.
2. Each tenant can have one or more domains, e.g.:
   - `acme.isostack.app`
   - `portal.acmehealth.co.uk`
3. The **hostname** determines:
   - Which organisation the request belongs to
   - Tenant branding (logos, colours)
   - Enabled modules and the **default module**
4. Single login:
   - Users log in once and can move between modules without re-authentication.
   - Single-module tenants feel like they have a dedicated app.
   - Multi-module tenants see an app switcher and module-sensitive branding.
5. Cloudflare provides DNS, TLS, WAF, and DDoS protection for all tenant domains.

---

## 2. DNS and Cloudflare model

### 2.1 Core hostnames

Recommended baseline:

- `isostack.app`
  - Marketing site or redirect.
- `core.isostack.app`
  - IsoStack Core application (Next.js App Router).
- `api.isostack.app` (optional)
  - Separate API service if required.

Cloudflare DNS:

- `core.isostack.app` → CNAME → `<isostack-bedrock>.onrender.com` (proxied, TTL Auto).
- Optionally:
  - `api.isostack.app` → CNAME → `<isostack-api>.onrender.com` (proxied).

### 2.2 Wildcard tenant domains

To support tenant-specific subdomains:

- `*.isostack.app` → CNAME → `app.isostack.app` (proxied).

This means:

- Any `tenant.isostack.app` will route to the same Render app.
- The **`Host` header** is used inside IsoStack to resolve the tenant.

### 2.3 External custom domains

For a tenant’s own domain, e.g. `portal.acmehealth.co.uk`:

- The client points `portal.acmehealth.co.uk` to Cloudflare (nameservers or CNAME).
- Cloudflare DNS:
  - `portal.acmehealth.co.uk` → CNAME → `app.isostack.app` (proxied).

IsoStack treats this exactly like `acme.isostack.app` – the hostname is simply another `organisation_domain`.

### 2.4 Cloudflare TLS and security

- SSL/TLS mode: **Full (strict)**.
- Proxied (orange cloud) for:
  - `app.isostack.app`
  - `*.isostack.app`
  - Any tenant custom domains.
- WAF enabled with appropriate rulesets.
- Optional:
  - Rate limiting on login/API endpoints.
  - Bot mitigation as needed.

---

## 3. Data model

All domain → organisation resolution is handled via the database.

### 3.1 Organisation

Represents a tenant (client):

```ts
model Organisation {
  id               String   @id @default(uuid())
  name             String
  defaultModuleId  String?  // FK → Module.id
  isActive         Boolean  @default(true)
  requiresWhiteLabel Boolean @default(false) // NEW


  domains          OrganisationDomain[]
  branding         OrganisationBranding?
  modules          OrganisationModule[] // feature flags / entitlements
}
````

### 3.2 OrganisationDomain

Maps hostnames to organisations:

```ts
model OrganisationDomain {
  id             String  @id @default(uuid())
  organisationId String
  hostname       String  @unique // e.g. "acme.isostack.app"
  isPrimary      Boolean @default(false)
  isActive       Boolean @default(true)

  organisation   Organisation @relation(fields: [organisationId], references: [id])
}
```

Rules:

* `hostname` is unique across the platform.
* `isActive = false` → hostname should not resolve to a tenant (404 / “tenant not found”).
* Each organisation **must** have at least one active domain.

### 3.3 OrganisationBranding

Stores tenant branding (used in client admin and some shared areas):

```ts
model OrganisationBranding {
  id               String  @id @default(uuid())
  organisationId   String  @unique

  lightLogoUrl     String?
  darkLogoUrl      String?
  faviconUrl       String?

  primaryColour    String? // hex
  secondaryColour  String? // hex
  typographyColour String? // hex

  organisation     Organisation @relation(fields: [organisationId], references: [id])
}
```

Module branding is defined separately at **module** level and combined with tenant branding in the UI.

---

## 4. Request flow and tenant resolution

### 4.1 Source of truth: `Host` header

Every incoming request carries a `Host` header:

* Example: `Host: acme.isostack.app`
* Example: `Host: portal.acmehealth.co.uk`

IsoStack uses this value to resolve:

1. `organisation_domain.hostname`
2. `organisation`
3. `organisation_branding`
4. `organisation_module` (enabled modules, default module, etc.)

### 4.2 Middleware (Next.js)

The resolution should happen as early as possible, ideally in `middleware.ts`.

**Responsibilities of middleware:**

1. Read `Host` header and normalise (strip port).
2. Bypass for public/core hosts if needed:

   * `isostack.app`, `www.isostack.app`, `docs.isostack.app`, etc.
3. Look up `organisation_domain` where `hostname = Host`.
4. If no active match:

   * Rewrite to `/tenant-not-found` or similar.
5. If match:

   * Attach `organisation_id` (and hostname) to the request, e.g.:

     * As internal headers: `x-organisation-id`, `x-organisation-hostname`; and/or
     * As a secure, HTTP-only cookie.

Downstream code (tRPC context, route handlers, server components) can rely on this context.

### 4.3 tRPC / server context

The tRPC context should read the organisation from the request (header or cookie):

* If missing:

  * Reject requests that require tenancy.
* If present:

  * Use `organisationId` for:

    * Data scoping
    * RLS filters (via Neon)
    * Feature/plan checks
    * Loading branding and module configuration

This ensures every authenticated request is evaluated **within** a tenant boundary.

---

## 5. Branding and default module behaviour

Once `organisation` is known:

1. **Branding:**

   * Load `OrganisationBranding` for tenant.
   * Load module branding for the current module (if the user is in a module context).
   * Apply the branding rules:

     * Tenant branding is primary in client admin and shared platform areas.
     * Module branding dominates in client user interfaces, with tenant branding used sympathetically.

2. **Default module:**

   * Read `organisation.defaultModuleId`.
   * For single-module tenants:

     * Redirect `/` → that module’s home route (e.g. `/bedrock`).
   * For multi-module tenants:

     * Show app switcher and open the default module by default.

This logic is implemented in the root app layout / shell components, not in DNS.
3. **Branded Authentication URLs**

For tenants with White Label enabled:

- Standard: `https://acme.isostack.app/auth/signin`
- Branded: `https://acme.isostack.app/login` (custom slug)
- Custom domain: `https://portal.acmehealth.co.uk/login`

Schema addition:
```typescript
model OrganisationBranding {
  // ...existing fields
  customAuthSlug String? // e.g., "login", "portal", "access"
}


---

## 6. Security considerations

1. **Do not trust arbitrary hostnames**

   * Only hostnames present and active in `organisation_domain` may resolve to tenants.
   * Any other host returning to the platform should show:

     * 404
     * or a dedicated “tenant not found / misconfigured domain” page.

2. **Reserved hostnames**

   * Certain hostnames are reserved for core services and must never be treated as tenants:

     * `isostack.app`
     * `www.isostack.app`
     * `app.isostack.app`
     * `api.isostack.app`
   * These are excluded or handled separately in middleware.

3. **RLS and authorisation**

   * All tenant-sensitive data access must continue to enforce:

     * Row Level Security (RLS) in Neon where applicable.
     * Application-level checks using `organisationId` in queries.

4. **Session and SSO**

   * Authentication cookies/tokens must be scoped correctly:

     * If using a parent domain cookie (e.g. `.isostack.app`), ensure proper SameSite and security flags.
     * If using JWT hand-off to modules, validate tokens with shared keys and short expiries.

5. **Cloudflare configuration**

   * Only Cloudflare should terminate TLS for public hostnames.
   * Unknown or misconfigured hostnames should not leak internal infrastructure details.
   * 
6. **Subdomain Enumeration Protection**

To prevent discovery of tenant names via `*.isostack.app`:

1. **Rate limit** hostname lookups in middleware
2. **Generic error pages** - never reveal if a subdomain exists but is inactive
3. **Consider:** Whitelist mode where only explicitly created subdomains resolve
4. **Monitor:** Log failed hostname resolutions for security analysis

---

## 7. Examples

### 7.1 Example 1 – IsoStack tenant subdomain

* Request: `https://acme.isostack.app/dashboard`
* `Host` header: `acme.isostack.app`
* `organisation_domain.hostname = "acme.isostack.app"` → `organisation_id = org_acme`
* Load:

  * `OrganisationBranding` for `org_acme`
  * Modules enabled for `org_acme`
* Shell renders Acme branding and their default module.

### 7.2 Example 2 – Client’s own domain

* Request: `https://portal.acmehealth.co.uk/login`
* `Host` header: `portal.acmehealth.co.uk`
* `organisation_domain.hostname = "portal.acmehealth.co.uk"` → `organisation_id = org_acme`
* Same organisation, same modules, same branding:

  * The user perceives this as “Acme Health’s own portal”.

### 7.3 Example 3 – Unknown tenant

* Request: `https://foo-bar-baz.isostack.app/`
* `Host` header: `foo-bar-baz.isostack.app`
* No matching active `organisation_domain`.
* Middleware rewrites to `/tenant-not-found`.
* Response: 404 or explanatory page.

---

## 8. Implementation notes

* Middleware must remain **lightweight**: keep DB lookups efficient (caching recommended).
* Consider:

  * In-memory / Redis cache for `hostname → organisation_id`.
  * Periodic invalidation or cache busting on domain changes.
* Document the onboarding flow for new tenants:

  1. Create `Organisation`.
  2. Create `OrganisationDomain` with hostname.
  3. Configure DNS (either `*.isostack.app` or client CNAME to `app.isostack.app`).
  4. Configure branding and modules.
* All modules and shared UI components should treat `organisationId` and `currentHostname` as **first-class context** values.

### 9. Custom Domain Verification

Before activating a custom domain:

1. **TXT record verification**
   - Tenant adds: `TXT _isostack-verify.portal.acmehealth.co.uk` → `verify-token-xyz`
   - System validates before setting `isActive = true`

2. **CNAME validation**
   - Check `portal.acmehealth.co.uk` resolves to `app.isostack.app`
   - Retry mechanism with clear error messages

3. **SSL readiness check**
   - Ensure Cloudflare has provisioned TLS before marking domain active

Schema:
```typescript
model OrganisationDomain {
  // ...existing fields
  verificationToken String? @unique
  verifiedAt        DateTime?
  sslReady          Boolean @default(false)
}
---


```
::contentReference[oaicite:0]{index=0}
```
