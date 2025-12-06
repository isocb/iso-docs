
---
title: IsoStack Core Architecture
version: 1.4.0
status: stable
description: Source-of-truth architecture and design principles for the IsoStack multi-tenant SaaS framework
---

# IsoStack — Core Architecture

IsoStack is a multi-tenant, modular SaaS foundation built on:

- **Next.js 15 (App Router)**
- **Mantine 7.13.2 (pinned UI framework)**
- **TypeScript 5.x**
- **tRPC 11** for API transport
- **Zod** for validation
- **Prisma 5.x** ORM
- **Neon PostgreSQL (multi-schema)**
- **NextAuth v5** (magic link)
- **Cloudflare R2** (optional)
- **Resend** (email delivery)

This document is the single source of truth for IsoStack Core.

IsoStack is not a product — it is the **platform Isoblue uses to build products**, including:
Bedrock, TailorAid, Emberbox, APIKeyChain, LMSPro, and bespoke client modules.

---

# 1. Architectural Principles

1. **Modularity**  
   - Modules are independent functional apps.  
   - Core contains no app-specific logic — only orchestration.

2. **Multi-Schema PostgreSQL**  
   - `public` schema = tenancy, users, auth, modules, features, search settings.  
   - Each module may create its own schema (e.g. `bedrock`).  
   - Core never writes to module schemas; modules never write to each other’s schemas.

3. **Predictable UX Through Common Structures**  
   Every module inherits:
   - Core AppShell  
   - Core navigation  
   - Platform/Tenant/User dashboards  
   - Module Switcher  
   - Tooltip system  
   - Standard table/search controls  

4. **Strict Version Pinning**  
   Mantine **7.13.2** is chosen and fixed.  
   - We avoid breaking changes introduced in later v7 releases.  
   - We keep UI behaviour stable for AI-generated components.

5. **Cascading Configuration**  
   - Platform → Organisation → Module override hierarchy.  
   - Search/fuzzy settings and other behaviours follow this cascade.  
   - Platform Owner remains in control; overrides are explicit.

---

# 2. Core Domain Model Overview

## 2.1 Multi-Tenant Objects (public schema)

Core entities:

- `User`  
- `Organisation` (Tenant / Client)  
- `OrganisationUser` (roles, permissions)  
- `ModuleCatalogue` (list of available modules)  
- `OrganisationModule` (module enablement per tenant)  
- `PlatformFeatureFlag`  
- `OrganisationFeatureFlag` (optional, future)  
- `AuditLog`  
- `Tooltip` (global → owner → tenant inheritance)  
- `Branding` (per tenant)

### 2.1.1 Search & Fuzzy Logic Settings (public schema)

New entities to support universal fuzzy search:

- `PlatformSearchSettings`
  - Singleton record for global defaults
  - Fields (conceptual):
    - `enabled`
    - `mode` (`fuzzy` | `exact` | `hybrid`)
    - `sensitivity`
    - `maxResults`

- `OrganisationSearchSettings`
  - Scoped by `organisationId`
  - Fields:
    - `useCustomSettings` (boolean)
    - `mode`, `sensitivity`, `maxResults`

- `OrganisationModuleSearchSettings`
  - Scoped by `organisationId` and `moduleId`
  - Fields:
    - `useCustomSettings` (boolean)
    - `mode`, `sensitivity`, `maxResults`

- `ModuleSearchPolicy`
  - Scoped by `moduleId`
  - Fields:
    - `allowTenantOverrides` (boolean)

**Precedence:**

For any table or list, effective settings are:

> `OrganisationModuleSearchSettings` → `OrganisationSearchSettings` → `PlatformSearchSettings`

This is resolved centrally in Core; modules do not invent their own precedence.

## 2.2 Module Schemas (per module)

Each module may have its own schema, e.g.:

- `bedrock.projects`  
- `bedrock.sheets`  
- `bedrock.columns`  

Every module owns its own schema.  
No module writes to another module’s schema.

---

# 3. Platform / Tenant / User Scopes

IsoStack introduces three explicit scopes.

| Scope     | Colour (sidebar tint) | Purpose                                                |
|-----------|------------------------|--------------------------------------------------------|
| Platform  | Green                  | Manage tenants, modules, features, impersonation      |
| Tenant    | Purple                 | Tenant admin tasks, module setup, user management     |
| User      | Orange                 | End-user experience inside modules                    |

These scopes:

- Define permission boundaries  
- Drive sidebar tint and badges in the UX  
- Control which routes and modules a user may access  

---

# 4. Core AppShell (Shared Layout)

All IsoStack pages and all modules use the same AppShell layout:

- **Mantine Header (neutral)**  
  - Breadcrumbs / titles  
  - User menu  
  - Environment badges (DEV / STAGE / PROD)

- **Sidebar / Navbar (context-aware)**  
  - Context badge (Platform / Tenant / User)  
  - Impersonation badge (if active)  
  - Module switcher  
  - Optional tenant logo  

- **Main Content Area**  
  - Tabs  
  - Dashboards  
  - Lists/tables (with universal search + sort controls)  
  - Child pages  
  - Modals  

> Earlier drafts used a “top context bar”.  
> The final architecture uses **sidebar tint + badges** to signal context, because Mantine AppShell does not support components above the Header without layout hacks.

Mantine AppShell gives:

- Responsive left navigation  
- Collapsible sidebar on mobile  
- Standardised layout across modules  

---

# 5. Standard Dashboards (Core)

Every IsoStack deployment includes three core dashboards.

## 5.1 Platform Home (`/platform`)

- List of all tenants (searchable with fuzzy search)  
- Module catalogue overview  
- Feature status and health indicators  
- Tenant context switch  
- Access to Platform Settings (Section 8)

## 5.2 Tenant Home (`/tenant/[tenantId]`)

- Tenant KPIs  
- Modules enabled for this tenant  
- Quick actions (invite user, configure domain, branding)  
- Recently active users  

## 5.3 User Home (`/me` or `/app`)

- Modules the user can access  
- Personal tasks/alerts (future)  
- Profile summary  

Modules may inject dashboard cards into all three dashboards.

---

# 6. Module Switcher (Core)

Left navigation (sidebar) is populated dynamically:

- Based on `OrganisationModule`  
- Filtered by the current user’s roles and permissions  
- Different base routes per scope:
  - Platform → `/platform/<module>`  
  - Tenant → `/tenant/[id]/<module>`  
  - User → `/app/<module>`  

Modules register:

 
id
label
icon
platformRoute?
tenantRoute?
userRoute?


This eliminates bespoke navigation and ensures fast, predictable module creation.

---

# 7. Modules vs Features

## 7.1 Modules

Modules are functional apps:

* Bedrock (analytics from Sheets)
* TailorAid (AI-assisted reporting)
* Emberbox (life and estate planning)
* APIKeyChain (API key proxy)
* LMSPro (league management)
* etc.

Stored primarily in:

* `ModuleCatalogue`
* `OrganisationModule`

## 7.2 Features

Features are platform-level capabilities:

* Tooltip engine
* AI helpers
* R2 storage
* Branding engine
* Fuzzy search engine (itself a feature of Core)

Stored in:

* `PlatformFeatureFlag`
* `OrganisationFeatureFlag` (optional future)

Modules ≠ Features:

* Modules are apps
* Features are behaviours of Core that modules may rely on

---

# 8. Platform Settings Architecture

Platform Settings is the configuration hub for IsoStack. UX is defined in the UX standard, but the architecture is:

* Route: `/platform?tab=settings`
* Visibility: Platform Owner only
* Layout: Mantine `Accordion` with logical groups:

  * Branding & Identity
  * Email & Notifications
  * Security & Access
  * Search & Fuzzy Logic
  * Banding, Currency & Billing
  * APIs & Integrations

### 8.1 Search & Fuzzy Logic Settings (Architecture)

This group is backed by:

* `PlatformSearchSettings`
* `OrganisationSearchSettings`
* `ModuleSearchPolicy`

Platform Owner can:

* Set global defaults (platform level)
* Set organisation overrides
* Decide if each module may have module-level overrides at tenant level

Organisation-level override values for search live under the **Client Settings** (per-tenant management) page, backed by `OrganisationSearchSettings`.

Module-level overrides live under each module’s **Settings** tab, backed by `OrganisationModuleSearchSettings`, but only when `ModuleSearchPolicy.allowTenantOverrides` is `true`.

---

# 9. Search & List Behaviour (Core)

Search and list behaviour is a **first-class architectural concern**.

* All tables/lists must:

  * Use the shared list control bar:

    * Fuzzy search input
    * Sort dropdown
    * Sort direction toggle
  * Resolve effective settings via:

    * `OrganisationModuleSearchSettings` → `OrganisationSearchSettings` → `PlatformSearchSettings`

* Client-side lists (≈ up to 1,000 rows):

  * Use a shared fuzzy search implementation (for example, Fuse.js)
  * Honour sensitivity and max results from effective settings

* Server-side lists (large datasets):

  * Use appropriate PostgreSQL primitives, e.g. `pg_trgm`, `ILIKE`, or hybrid search depending on `mode`
  * Accept `searchTerm`, `mode`, `sensitivity`, `maxResults`, `sortField`, `sortDirection` as parameters

The architecture does **not** hard-code a specific library in this document, but requires that:

* Fuzzy search is the default
* Behaviour is consistent across modules
* Overrides are respected and audit-able

---

# 10. Tenant Context Switching & Impersonation

### 10.1 Tenant Switch

Platform Owner may:

* Select a tenant
* “Enter” its Tenant View (`/tenant/[id]`)

Sidebar tint becomes purple, context badge shows the tenant.

### 10.2 User Impersonation

From Tenant View, Platform Owner may:

* Select a tenant user
* Click “View as this user”

Sidebar remains purple (tenant context) but an orange **impersonation badge** is shown, plus:

> “Impersonating Alex Smith (Tenant: Derby Junior League)”

Audit logging always records:

* Real user
* Impersonated user
* Tenant ID
* Time and action

Impersonation is a support tool and must be designed safely in both architecture and UX.

---

# 11. Security Architecture

* Row-Level Security enforced per schema and per tenant
* Impersonation events fully logged in `AuditLog`
* Modules sandboxed in their own schemas
* Magic link via NextAuth v5; no passwords stored in Core
* Feature flags not exposed directly to client; only via tRPC-mediated responses
* Search configuration and overrides are treated as configuration data and are also subject to RLS where relevant

---

# 12. Developer Experience & AI Collaboration

Core is designed to be AI-friendly and developer-friendly:

* Predictable folder structure (`/app`, `/server`, `/docs`)
* Strict version pinning for key libraries
* Shared components for AppShell, tables, list controls, modals, tabs
* Dashboards and shells are reusable across modules
* **Clear contracts** for:

  * Module registration
  * Search and list behaviour
  * Settings hierarchy

AI assistants are expected to:

* Respect this architecture
* Use the shared patterns instead of inventing new ones
* Keep code changes incremental and testable

---

# 13. Summary

IsoStack Core provides:

* A multi-tenant, multi-schema foundation
* Clear Platform / Tenant / User scopes
* A shared AppShell with sidebar-based context signalling
* Standard dashboards and module switcher
* Cascading configuration via Platform → Organisation → Module
* A universal search & list control model with fuzzy search
* Strong security through RLS and audited impersonation
* A stable base for AI-assisted, pattern-driven development

All modules and future enhancements must align with this architecture.

  `

---