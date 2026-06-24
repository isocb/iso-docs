# IsoStack Module Architecture Template

## Current Relevance Review - 2026-06-24

Status: **current as a conceptual template, with important implementation updates below.**

This document still describes the broad architecture expected of new IsoStack modules: module boundaries, tRPC APIs, Prisma schema discipline, audit logging, UI structure and activation planning. Some paths and assumptions in the original template are now legacy or too generic for the current app.

Current implementation guidance:

- app routes live under `src/app/(app)/app/<module>/`;
- module code lives under `src/modules/<module>/`;
- module routers live under `src/modules/<module>/routers/` and are registered into the app router;
- validation uses Zod, usually under `src/modules/<module>/lib/validation/`;
- service/domain logic lives under `src/modules/<module>/services/`;
- Prisma module models use explicit `@@schema("<module_schema>")`;
- tenant-owned rows use required `organizationId`;
- meaningful mutations write `AuditLog`;
- UI follows the current IsoStack UX/UI standard and table CRUD / child-page rules.

Current product-led module access model:

```text
ModuleCatalogue
  -> ProductModule
  -> ProductPackage
  -> OrganizationProduct
  -> getFeaturesAsFlags()
  -> module registry / navigation / route access
```

For a new routable module, implementation is not complete until these identifiers align:

- `src/modules/<module>/module.config.ts` `id`;
- `src/modules/<module>/module.config.ts` `featureFlag`;
- `ModuleCatalogue.slug`;
- Product Package module allocation through `ProductModule`;
- navigation registry key;
- route prefix under `/app/<module>`.

Recent example:

```text
fix(platform): add fund to module catalogue defaults
```

FUND already existed in code with:

```text
id = fund
featureFlag = fund
route = /app/fund
```

However, P1 could not allocate FUND to a Product Package until a matching `ModuleCatalogue` row existed. The platform fix adds an idempotent create-if-missing default for `fund` in the Module Catalogue list path and adds FUND to seed data for fresh development/demo environments. This makes FUND selectable in the P1 Product Package module picker without schema changes, migrations, `db:push`, seed or reset in existing environments.

---

# ✅ **IsoStack Module Architecture Template**

*(Use this as the baseline architecture for any new module — Bedrock, Tooltips, Support Desk, Billing, Connectors, etc.)*

```md
---
title: <Module Name> – Module Architecture
description: Technical and functional architecture for the <Module Name> IsoStack module
status: draft
version: 0.1.0
---

# <Module Name> — Module Architecture

This document defines the architecture, domain boundaries, data structures, user flows, and integration layers for the **<Module Name> module** within IsoStack.

Modules are self-contained, multi-schema features that plug into the platform through a unified mechanism:
- Platform services (auth, organisation system, R2 storage, tenant branding)
- tRPC server under `/server`
- Prisma multi-schema migration model
- Feature flags
- Contextual help & tooltip engine
- Settings engine
- Tenant-level module activation

---

# 1. Position in the IsoStack Ecosystem

<Module Name> is a switchable module integrated into IsoStack’s multi-tenant architecture. It inherits the platform's:

- **Authentication** (NextAuth v5 Magic Link)
- **Authorisation** (tenant_user roles + internal policies)
- **Branding system** (tenant logos, colour themes, display name)
- **Tooltip engine** (hierarchical: Global → App Owner → Tenant)
- **Settings engine** (schema-based configuration)
- **Feature flag system**
- **Audit logging**

Each module operates within its own Postgres schema:

```

public            → Platform tables
tenant_<id>       → Tenant isolation layer (future)
<module_schema>   → Domain tables for this module

```

---

# 2. Domain Model

## 2.1 Core Domain Objects
*(Replace with module-specific entities)*

Example:
- `Project`
- `Item`
- `Result`
- `Attachment`

Each object is:
- Represented as a **Prisma model** under the module schema  
- Isolated from other modules  
- Mapped via Zod into tRPC routers  
- Referenced via IDs only (no cross-module leakage)

## 2.2 Supporting Entities
Examples:
- Audit events  
- Module settings  
- Module-specific permissions  
- R2 assets (images, JSON, PDFs)  
- Cached external data (optional)

---

# 3. Database Schema (Neon + Prisma)

## 3.1 Multi-schema layout
```

schema.prisma
├ public                 → platform models (users, orgs, branding)
├ <module_schema>        → <Module Name> models

```

Usage:
- `@@schema("<module_schema>")` applied to every model  
- Strict foreign-key discipline  
- No circular references  
- Multi-schema preview flag ON in Prisma client

## 3.2 Migrations
- Each module change produces modular migration files
- Naming: `YYYYMMDDHHMM_<module>_<change>.sql`
- Safe for Dev → Staging → Prod pipelines

---

# 4. API Layer (tRPC)

Each module exposes its functionality exclusively through:

```

/server/api/routers/<module>/

```

Structure:
- `index.ts` — root export
- `{entity}.router.ts` — CRUD + actions
- `{entity}.schema.ts` — Zod input/output
- `{entity}.service.ts` — domain logic

Rules:
- No DB code in routers  
- All DB queries inside `service` files  
- All validations in Zod schemas  

---

# 5. UI Architecture (Next.js 15 + Mantine)

## 5.1 Directory Layout
```

src/app/(app)/<module>/
│  page.tsx
│  layout.tsx
│
└── entity/
├── page.tsx
├── [id]/
│   └── page.tsx
└── components/

```

## 5.2 UI Principles
- Minimalist Mantine UI
- Server Actions for mutations
- RSC for all reading where possible
- Feature flags wrapping UI sections
- Tooltip engine integrated via `<HelpTip />`
- All lists sortable, filterable, paginated

---

# 6. Permissions & Roles

Roles inherited from `tenant_user`:

- **Owner**  
- **Admin**  
- **Manager**  
- **Contributor**  
- **Viewer**

Each module additionally defines module-specific rules in:

```

/server/api/permissions/<module>.ts

```

Logic:
- Declarative permission maps
- Checked in tRPC middleware
- Optional resource-level rules (`isOwnerOfEntity`)

---

# 7. External Integrations

If the module integrates with external services:

- R2 → asset storage
- Resend → email notifications
- Google Sheets / Drive → Bedrock pattern
- Webhooks → inbound/outbound

Every external connector:
- Lives under `/server/services/<service>/`
- Must be stateless
- Must support tenant-level credentials (via encrypted store)

---

# 8. Settings Engine for the Module

`<module_schema>.module_settings` defines configuration:

- Toggles  
- Thresholds  
- Labels & naming  
- Default values  
- JSON config blocks  

Served via:

```

/server/api/routers/settings/<module>.router.ts

```

Displayed in UI as a dedicated settings panel:

```

/(app)/settings/<module>

```

---

# 9. Feature Flags

Module must define:

```

/config/feature-flags/<module>.ts

```

Example:
- `enableCharts`  
- `enableAdvancedTables`  
- `enableExport`  

Flags can be:
- Global default  
- Overridden per-tenant  
- Overridden per-user  

---

# 10. Lifecycle Events

Every module supports hook points:

### 10.1 Activation
- Create default settings
- Seed tooltips
- Emit audit log

### 10.2 Deactivation
- Disable routes
- Hide menu items
- Optionally archive data

### 10.3 Deletion (rare)
- Hard delete or archive schema  
- Requires platform owner permission  

---

# 11. Audit Logging

All important actions log events in:

`public.audit_log`

Events include:
- Record created/updated/deleted
- Export/download events
- Configuration changes
- Access attempts

---

# 12. Testing

Three layers:

### 12.1 Unit Tests  
Zod + service functions.

### 12.2 Integration Tests  
tRPC procedure-level tests.

### 12.3 E2E Tests  
Playwright tests for flows.

---

# 13. Deployment Pipeline

Standard IsoStack deployment:

1. Developer branch → Dev environment
2. Staging → data-separated Neon DB
3. Production → stable modules only
4. Automated migrations
5. Optional seed scripts per module

---

# 14. Seed Scripts

Each module may include:

```

prisma/seed/<module>.seed.ts

```

Seeds include:
- Default settings
- Default tooltips
- Sample demo data (optional)
- Platform-owned templates

Run via:

```

npm run seed:module <module>

```

---

# 15. Roadmap Template

- v0.1.0 — Base scaffolding  
- v0.2.0 — Settings engine integration  
- v0.3.0 — Tenant activation flow  
- v0.4.0 — Feature flags  
- v0.5.0 — Export/Import tools  
- v1.0.0 — Production-ready release  

---

# End of Document
```
