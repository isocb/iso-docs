Absolutely — here is a **fresh, clean, fully renumbered project specification** with **no references to your previous phase numbers**.
This is now a **self-contained project document** for implementing:

* **Branded authentication pages**
* **White label custom domains**
* **Per-module auth flows**
* **Middleware-based branding + routing**

Everything is rewritten as a **new project with its own numbering**, logically grouped and easy for devs to follow.

---

# **IsoStack White Label Authentication & Custom Domain Project**

### *Core Specification — Clean Numbering*

**Version:** 1.0
**Date:** 9 December 2025
**Status:** Design Phase
**Scope:** IsoStack Core (branding, auth, domains, middleware)

---

# **1. Project Objectives**

IsoStack must support:

### **1. Branded Authentication Pages**

* Per-organisation branding (logos, colours, favicon)
* Per-module authentication flows
* Unified white-label auth templates (Standard / Premium / Enterprise)
* Full branding across:

  * Signup
  * Login
  * Password reset
  * Email verification
  * Magic link flows

### **2. Custom Domain Access (White Labelling)**

* Tenants can use their own domain:
  `portal.acmehealth.co.uk → IsoStack`
* DNS verification (TXT + CNAME)
* SSL readiness checks
* Hostname → organisation → module resolution

### **3. Middleware-Based Branding & Routing**

Middleware must determine:

* Whether hostname is a platform domain or client domain
* Which organisation is being accessed
* Which module the user should see
* What branding to load

**Both features must work seamlessly together.**

---

# **2. Architecture Overview**

Incoming Request
↓
**Middleware (domain & branding resolution)**
↓
**Auth Pages (/auth/[moduleSlug]/**) with correct branding
↓
IsoStack App Shell (module context + branding)
↓
Tenant experience

---

# **3. Domain Handling Model**

Based on the Domain Strategy documents:



### **3.1 Reserved Platform Hostnames**

These *must not* trigger organisation lookup:

* `*.isostack.app`
* `isostack.app`
* `*.onrender.com`
* `*.vercel.app`
* `*.netlify.app`
* `localhost`

The middleware tests these patterns programmatically (see cited documents).

### **3.2 Custom Domains**

Anything not listed above is treated as a **potential tenant domain**:

```
portal.acmehealth.co.uk
my.app-for-clients.eu
members.whatever.org
```

Middleware must:

1. Look up domain in `organisation_domain.hostname`
2. Reject if not found or inactive
3. Load organisation context
4. Load branding context
5. Allow flow to continue into auth or app

### **3.3 Branding Hierarchy**

### Module Selection on Custom Domains

**Priority Logic:**
Note: Organisations have default modules. Client Admins and Client users inherit the first module by default. They can each set their default module is the organisation has more than one module.
1. If URL contains module slug (`/bedrock/signup`) → Use that module
2. If user has `defaultModuleSlug` preference → Use that module - The user sets a default in their profile, this is set by the first module.
3. If org has single enabled module → Use that module
4. If org has multiple modules → Show module switcher on auth page
5. Fallback → First alphabetically enabled module

**Signup Flow:**
- Custom domain signup → Enable **primary module** (org setting)
- User can switch modules post-signup via module switcher
- `defaultModuleSlug` set to primary module on account creation

1. **Custom domain + White Label tenant** → Org branding
2. **Custom domain + Standard tenant** → Module branding
3. **IsoStack subdomain** → Module branding
4. **Fallback** → IsoStack default branding

---

# **4. Data Model Requirements**

### **4.1 OrganisationDomain**

```ts
model OrganisationDomain {
  id               String   @id @default(uuid())
  organisationId   String
  hostname         String   @unique
  isPrimary        Boolean  @default(false)
  isActive         Boolean  @default(true)

  verificationToken String? @unique
  verifiedAt        DateTime?
  sslReady          Boolean @default(false)

  organisation     Organisation @relation(fields: [organisationId], references: [id])
}
```

### **4.2 Branding Fields**

Contained in `OrganisationBranding` (already part of your platform):

* Light logo
* Dark logo
* Favicon
* Primary colour
* Secondary colour
* Typography colour

Modules keep separate branding for module-default themes.

---

# **5. Middleware Responsibilities**

Middleware performs:

### **5.1 Hostname Classification**

Determine:

* **Reserved platform domain** → skip tenant lookup
* **Custom domain** → lookup tenant via `organisation_domain`

### **5.2 Tenant Lookup**

If hostname is custom:

1. Look up organisation
2. If not found → `tenant-not-found`
3. Attach request metadata:

   * `x-organisation-id`
   * `x-branding-context`
   * `x-module-context` (if resolvable)

### **5.3 Branding Resolution**

Middleware determines which branding rules apply and stores this in headers.

---

# **6. Branded Authentication System**

Authentication pages now exist **per module** with shared layout & branded content.
Overview:
Custom Branding and White Label, like Tooltips and Support Tickets are feature flags.
Each Module can have Pricing Tiers which are 'Bundles' of features and a price.
Custom Branding is a subset of 'White Label'
Custom Branding does not rename/rebrand Modules
Custom Branding does not allow access to a custom landing page
Custom Branding does not allow custom domain routing.
White Label allows renaming/branding of modules, a Custom landing page and custom domain routing in addition to custom branding login, and UI pages.



### **6.1 Required Auth Routes**

Modules must provide:

```
/auth/[moduleSlug]/signup
/auth/[moduleSlug]/login
/auth/[moduleSlug]/reset-password
/auth/[moduleSlug]/verify-email
/auth/[moduleSlug]/magic
```

### **6.2 Shared Auth Layout**

File: `app/auth/layout.tsx`

Responsibilities:

* Read branding context from headers
* Load template variant for Module - Bundle (eg standard/premium/enterprise)
* Display logos, colours, typography from organisation or module branding
* Provide layout wrapper for module pages

### **6.3 Module Auth Pages**

Examples:

`auth/bedrock/signup/page.tsx`
`auth/tailoraid/login/page.tsx`
`auth/emberbox/reset-password/page.tsx`

Rules:

* All use shared layout
* No module may override the auth layout
* No hard-coded colours or logos inside module pages

---

# **7. Signup Flow Requirements**

When a user signs up via a module:

1. Create **organisation**
2. Enable the module for that organisation
3. Set module as the **default**
4. Send a **branded** verification email
5. Redirect user to `/app/[moduleSlug]`
6. Create audit log entry

---

# **8. Security Requirements**

* CSRF protection
* bcrypt hashing with cost ≥ 12
* Rate limit (5 requests/min)
* Magic links expire after 1 hour
* Sessions expire after 7 days
* Prevent user enumeration
* Email verification mandatory

---

# **9. Developer Deliverables**

### **9.1 Custom Domain Subsystem**

* Database fields
* DNS verification
* CNAME checking
* SSL readiness workflow
* Domain activation UI
* Domain management API

#### DNS Verification Workflow

**Trigger:** User clicks "Verify Domain" button in Settings
**Process:**
1. Query DNS for TXT record (isostack-verification=<token>)
2. Query DNS for CNAME record (points to cname.isostack.app)
3. Update `verifiedAt` timestamp if either passes
4. Send email notification to org owner
5. Enable domain immediately upon verification

**Retry Logic:**
- Manual only (no background jobs initially)
- Max 5 verification attempts per hour per domain
- Rate limit enforced at API level

**Edge Cases:**
- If domain becomes unverified → redirect to domain-error page
- If SSL not ready → show warning but allow access
- If multiple domains verified → use `isPrimary` flag for canonical

### **9.2 Middleware Rewrite**

* Reserved domain handling
* Custom domain lookup
* Branding resolution
* Context injection
* Error handling

### **9.3 Branded Authentication Suite**

* Shared auth layout
* Branding utility
* Per-module auth pages
* Branded emails
* Templates for Standard/Premium/Enterprise

### **9.4 Documentation Updates**

* Module authoring guidelines
* Branding rules
* How to add new auth templates
* Domain onboarding instructions

---

# **10. Acceptance Criteria**

### **Custom Domains**

✓ Domain can be added
✓ TXT verification works
✓ CNAME resolves correctly
✓ SSL ready reported by Cloudflare
✓ Middleware routes correctly

### **Branding**

✓ White label branding appears on custom domains
✓ Module branding on IsoStack subdomains
✓ Auth pages use correct theme
✓ Branded email templates render correctly

### **Authentication**

✓ Signup → organisation + module created
✓ Login → correct module context
✓ Password reset branded
✓ Magic link branded
✓ No enumeration vulnerabilities

### **Documentation**

✓ Clear instructions for module developers
✓ Clear instructions for tenant onboarding
✓ Clear definition of branding inheritance

