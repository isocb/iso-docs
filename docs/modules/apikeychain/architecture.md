
---

# 📘 **APIKeyChain — Module Architecture**

**Status:** Draft v1.0
**Module:** APIKeyChain
**Maintainer:** Isoblue / IsoStack
**Purpose:** Define the domain model, architecture, UI design, API routes, security posture, multi-tenant behaviour, and integration points for the APIKeyChain module within the IsoStack platform.

---

# 1. **Position in the IsoStack Ecosystem**

APIKeyChain is a **first-class IsoStack module** that enables tenants to:

* Securely store API credentials
* Create per-project API proxies
* Restrict usage to authorised domains
* Transform and sanitise API responses
* Serve tenant-specific JS and CSS assets
* Hide API keys from public sites (Squarespace, Shopify, Webflow, etc.)

APIKeyChain integrates with **IsoStack Core** for:

* Authentication (NextAuth Magic Links)
* Branding (tenant themes)
* Tooltip system
* Feature flags
* R2 asset storage
* Audit logging
* Organisation-level tenancy
* Global / App Owner / Tenant UX inheritance

APIKeyChain is a **module**, not part of core, but uses core infrastructure.

---

# 2. **Module Capabilities (High-Level)**

### ✔ Per-tenant proxy projects

Each project defines:

* Allowed request domains
* Target provider (Knack, REST, Shopify, Custom)
* API keys (public + private)
* Routes (GET / POST / PATCH)
* Transform logic
* Rate limits
* Public JS/CSS assets

---

### ✔ Secure API Proxy Execution (Provider Adapters)

Support for:

* Knack (first provider)
* Generic REST
* Future providers (Stripe, Airtable, HubSpot, etc.)

Each provider adapter handles:

* URL construction
* Parameter validation
* Response mapping
* Error formatting

---

### ✔ Public Asset Serving via R2

Projects can upload:

* JS widgets (gallery, widgets, embeds)
* CSS themes

Assets are served at:

```
/api/apikeychain/[projectId]/js
/api/apikeychain/[projectId]/css
```

---

### ✔ Full Multi-Tenant Isolation

* Separate `apikeychain` schema
* Tenant ID on every table
* RLS enforcement
* R2 folder partitioning per tenant/project

---

# 3. **Domain Model**

APIKeyChain lives within the **`apikeychain` Prisma schema**.

### 3.1 **proxy_project**

Represents a proxy configuration owned by a tenant.

| Field             | Type      | Notes               |
| ----------------- | --------- | ------------------- |
| id                | UUID      | PK                  |
| tenant_id         | UUID      | FK → organisation   |
| name              | string    | User-friendly label |
| description       | string?   | Optional            |
| allowed_origins   | string[]  | CORS whitelist      |
| provider          | enum      | e.g. "knack"        |
| base_url          | string    | Provider endpoint   |
| encrypted_app_id  | string    | AES-256 encrypted   |
| encrypted_api_key | string    | AES-256 encrypted   |
| encrypted_secret  | string?   | Optional secret     |
| js_asset_key      | string?   | R2 pointer          |
| css_asset_key     | string?   | R2 pointer          |
| created_at        | timestamp |                     |
| updated_at        | timestamp |                     |

---

### 3.2 **proxy_route**

Defines individual endpoints for a proxy project.

| Field          | Type    | Notes                  |
| -------------- | ------- | ---------------------- |
| id             | UUID    | PK                     |
| project_id     | UUID    | FK → proxy_project     |
| method         | string  | GET/POST/PATCH         |
| path           | string  | e.g. `/records`        |
| param_schema   | JSON    | Zod schema definition  |
| transform_type | enum    | raw, mapped, custom_js |
| transform_js   | string? | Stored transformation  |
| enabled        | boolean |                        |

---

### 3.3 **proxy_key**

Used for key rotation, auditability.

| Field                | Type      |
| -------------------- | --------- |
| id                   | UUID      |
| project_id           | UUID      |
| public_key           | string    |
| encrypted_secret_key | string    |
| active               | boolean   |
| expires_at           | timestamp |

---

### 3.4 **proxy_event_log**

(Asynchronous event ledger.)

| Field       | Type                    |
| ----------- | ----------------------- |
| id          | UUID                    |
| project_id  | UUID                    |
| route_id    | UUID                    |
| timestamp   | ts                      |
| origin      | string                  |
| status_code | int                     |
| duration_ms | int                     |
| error       | string?                 |
| hash        | string (tamper-evident) |

---

# 4. **API Routes (Next.js App Router)**

APIKeyChain exposes the following server routes:

```
/api/apikeychain
    GET — list projects (platform owner)

/api/apikeychain/[projectId]
    GET — project info
    PATCH — update settings
    DELETE — archive project

/api/apikeychain/[projectId]/proxy
    GET — execute provider request
    POST — execute provider request

/api/apikeychain/[projectId]/js
    GET — serve tenant JS asset

/api/apikeychain/[projectId]/css
    GET — serve tenant CSS asset
```

All routes must:

* Validate tenant identity
* Load the project from `apikeychain.proxy_project`
* Apply RLS
* Enforce CORS
* Use provider adapters for remote API execution

---

# 5. **Provider Adapter Architecture**

Providers live under:

```
src/server/apikeychain/providers/
```

Each adapter exposes:

```ts
export interface ProviderAdapter {
  buildUrl(params): string;
  buildHeaders(project): Record<string,string>;
  validateParams(params): ParsedObject;
  transformResponse(data, routeConfig): any;
}
```

Examples:

```
knack.ts
generic-rest.ts
shopify.ts
```

---

# 6. **Security Architecture (Summary)**

(Full detail in security-architecture.md.)

### ✔ AES-256-GCM encryption

### ✔ Argon2id derived keys

### ✔ Tenant-specific salts

### ✔ Zero-secrets-ever-sent-to-browser

### ✔ No wildcard CORS

### ✔ Signed request support (HMAC)

### ✔ Optional ephemeral key rotation

### ✔ Tamper-evident logs (SHA-256 chain)

### ✔ Secure R2 asset bucket partitioning

---

# 7. **UI Architecture (Mantine 7)**

APIKeyChain follows IsoStack UI/UX principles:

### 7.1 **Navigation Location**

```
Sidebar → Modules → APIKeyChain
```

### 7.2 **Pages**

| Page                   | Purpose                            |
| ---------------------- | ---------------------------------- |
| `/apikeychain`         | List of proxy projects             |
| `/apikeychain/create`  | New project wizard                 |
| `[projectId]/`         | Project overview                   |
| `[projectId]/settings` | Allowed domains, provider settings |
| `[projectId]/keys`     | Key rotation, credential entry     |
| `[projectId]/assets`   | JS/CSS upload and management       |
| `[projectId]/routes`   | Route editor and transforms        |

---

### 7.3 **UI Components (reusable across modules)**

* `IsoFormSection`
* `IsoCard`
* `IsoTable`
* `IsoBadge`
* `IsoStatusDot`
* `IsoPermissionsGate`
* `IsoTooltip`
* `IsoModal`

---

### 7.4 **User Roles**

| Role           | Capability                               |
| -------------- | ---------------------------------------- |
| Platform Owner | View all tenants' projects, debug routes |
| Tenant Admin   | Full CRUD on projects                    |
| Tenant Member  | Read-only                                |
| Public User    | None                                     |

---

# 8. **Feature Flags**

Feature flags allow per-tenant enablement:

| Flag                        | Description                      |
| --------------------------- | -------------------------------- |
| apikeychain.enabled         | Turns module on/off              |
| apikeychain.custom-js       | Allows tenant JS uploads         |
| apikeychain.custom-css      | Allows tenant CSS                |
| apikeychain.providers.knack | Enables Knack adapter            |
| apikeychain.transform.js    | Enables custom transform scripts |
| apikeychain.key-rotation    | Enables automated key rotation   |

---

# 9. **R2 Storage Structure**

```
apikeychain/
    {tenantId}/
        {projectId}/
            js/
                latest.js
                version-<hash>.js
            css/
                latest.css
                version-<hash>.css
            uploads/
                raw/<timestamp>.js
```

Files are always accessed through secure API routes;
Direct public access to R2 is never allowed.

---

# 10. **Lifecycle of a Proxy Request**

### 1. Browser calls:

```
/api/apikeychain/<id>/proxy?route=records&page=1
```

### 2. IsoStack:

* validates session
* loads project
* checks domain
* checks feature flags
* loads provider adapter

### 3. Provider adapter:

* builds URL
* applies params
* applies API keys
* executes fetch

### 4. IsoStack:

* records event log
* applies transform
* returns response

---

# 11. **Integration With Other IsoStack Modules**

APIKeyChain integrates with:

### ✔ **Tooltip System**

Contextual explanations for every setting.

### ✔ **Tenant Branding**

Module UI adopts tenant-selected brand colours.

### ✔ **Audit Logger**

All sensitive actions automatically logged.

### ✔ **Settings Engine**

Tenant-level feature flags override module defaults.

---

# 12. **Non-Goals (What APIKeyChain Does Not Do)**

* Does not store user passwords
* Does not provide OAuth token refresh flows
* Does not allow arbitrary remote hosts
* Does not provide raw key exposure APIs
* Does not bypass provider rate limits
* Does not allow public reading of JS/CSS except through routed endpoints

---

# 13. **Future Enhancements**

* Provider marketplace
* No-code route builder
* Post-quantum hybrid encryption
* Device-bound admin approvals
* Automatic anomaly-driven key rotation
* JS/CSS versioning and rollback
* Interactive request debugger
* Live logs viewer

---

# END OF DOCUMENT

