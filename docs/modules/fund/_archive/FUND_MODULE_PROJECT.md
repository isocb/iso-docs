# FUND Module Project Plan

**Date Created:** 9 June 2026  
**Status:** Ready for phased build  
**Owner:** Chris (isocb)  
**Module slug:** `fund`  
**Successor to:** AMOW planning scaffold  
**AI Context:** Complete — use this document to resume safely at any phase

---

## 1. Project Goal

Build **FUND** as a reusable IsoStack module for fundraising, e-commerce, project lifecycle management, organiser engagement, commission distribution, and production coordination.

FUND replaces the earlier AMOW-specific planning scaffold. AMOW remains important as the founding use case / potential production partner, but the module itself must not be AMOW-specific.

FUND should support:

- Schools
- PTAs
- Football clubs
- Football leagues
- Community organisations
- Charities
- Membership bodies
- Future fundraising or production partners

---

## 2. Source Documents

Read these before implementation:

1. `docs/2026-IsoStack-Docs/Module Building/01-functional-specification-FUND.md`
2. `docs/2026-IsoStack-Docs/Module Building/any-new-module-architecture.md`
3. `docs/2026-IsoStack-Docs/Module Building/MODULE_STARTER_KIT_PROJECT.md`
4. `src/modules/fund/docs/fund-tool-selection-thoughts.md`
5. `docs/00-READ_THIS/COMMIT_CHECKLIST.md`

---

## 3. Architectural Position

FUND is a switchable IsoStack module. It consumes platform services and owns only fundraising-specific domain logic.

### Platform Provides

- Organisations and tenancy
- Authentication and roles
- Audit logging
- Email delivery
- File/media storage
- Stripe integration primitives
- Branding
- Tooltip/help system
- Module catalogue and product/package allocation
- Metric limits and bundle enforcement framework

### FUND Owns

- Fundraising product catalogues
- Events / campaign windows
- Projects
- Store generation and store lifecycle
- Orders and order lines within FUND context
- Organiser workflows
- Production workflow
- Commission rules and commission reporting
- Production partner coordination
- FUND dashboards and portal views

---

## 4. Non-Negotiable Rules

1. **Every FUND model must have `organizationId` unless it is a global template/reference row.**
2. **Every query must be scoped by `organizationId`.**
3. **Every significant mutation must write an `AuditLog`.**
4. **All table CRUD UI must follow the row-click modal pattern.**
5. **All DB changes go through Prisma migrations — never `db:push`.**
6. **FUND must stay reusable — do not hardcode AMOW into table names, enum values, routes, or business rules.**
7. **AMOW-specific behaviour belongs in seed/config rows, not FUND core code.**

---

## 5. Proposed Module Structure

```text
src/modules/fund/
├── module.config.ts
├── docs/
│   ├── README.md
│   └── fund-tool-selection-thoughts.md
├── routers/
│   ├── index.ts
│   ├── products.router.ts
│   ├── events.router.ts
│   ├── projects.router.ts
│   ├── stores.router.ts
│   ├── orders.router.ts
│   ├── commissions.router.ts
│   └── production.router.ts
├── schemas/
│   ├── products.schema.ts
│   ├── events.schema.ts
│   ├── projects.schema.ts
│   └── orders.schema.ts
├── services/
│   ├── products.service.ts
│   ├── lifecycle.service.ts
│   ├── checkout.service.ts
│   ├── commission.service.ts
│   └── production.service.ts
├── components/
│   ├── FundDashboard.tsx
│   ├── ProductsTable.tsx
│   ├── EventsTable.tsx
│   ├── ProjectsTable.tsx
│   └── StoresTable.tsx
└── lib/
    ├── lifecycle.ts
    ├── permissions.ts
    └── types.ts

src/app/(app)/app/fund/
├── page.tsx
├── products/page.tsx
├── events/page.tsx
├── projects/page.tsx
├── stores/page.tsx
├── orders/page.tsx
└── settings/page.tsx
```

---

## 6. Data Model Roadmap

### Phase 1 Models — MVP Foundation

Create these first:

- `FundProduct`
- `FundProductCategory`
- `FundEvent`
- `FundProject`
- `FundStore`
- `FundOrder`
- `FundOrderLine`
- `FundSettings`

### Phase 2 Models — Production + Files

- `FundArtworkSubmission`
- `FundPdfTemplate`
- `FundGeneratedDocument`
- `FundProductionBatch`
- `FundProductionTask`
- `FundDeliveryRecord`

### Phase 3 Models — Commissions

- `FundCommissionRule`
- `FundCommissionRun`
- `FundCommissionLine`
- `FundPayoutRecord`

### Phase 4 Models — Configurable Workflow

- `FundLifecycleTemplate`
- `FundLifecycleState`
- `FundLifecycleTransition`
- `FundAutomationRule`

---

## 7. Suggested Core Enums

Keep enum values generic and reusable:

```text
FundProjectStatus:
DRAFT, CREATED, CONFIGURING, STORE_OPEN, SELLING, CLOSING_SOON,
CLOSED, ARTWORK_RECEIVED, VALIDATED, PRODUCTION, DISPATCHED,
COMMISSION_READY, COMPLETE, CANCELLED

FundStoreStatus:
DRAFT, OPEN, PAUSED, CLOSED, ARCHIVED

FundOrderStatus:
PENDING_PAYMENT, PAID, CANCELLED, REFUNDED, IN_PRODUCTION,
DISPATCHED, COMPLETE

FundProductType:
STANDARD, ARTWORK_REQUIRED, PERSONALISED, DIGITAL

FundProductionPartnerType:
INTERNAL, EXTERNAL_VENDOR, TENANT_MANAGED
```

Do not add AMOW-specific states unless they are inserted as configurable labels/settings.

---

## 8. Build Phases

## Phase 0 — Replace AMOW Planning Scaffold

**Goal:** Make FUND the active module project identity.

Deliverables:

- `src/modules/fund/module.config.ts`
- `src/modules/fund/docs/README.md`
- `src/modules/fund/docs/fund-tool-selection-thoughts.md`
- This central project plan
- Remove the old `src/modules/amow/` planning scaffold

Acceptance criteria:

- No active source references to `src/modules/amow`
- FUND docs clearly state that AMOW is now a founding use case, not the module name

---

## Phase 1 — Database Foundation

**Goal:** Add FUND schema and MVP models.

Steps:

1. Add FUND models to `prisma/schema.prisma` under `@@schema("fund")`
2. Ensure tenant-scoped models include `organizationId`
3. Add relationships to `Organization`, `User`, and `MediaFile` where needed
4. Create migration with `npm run db:migrate:dev -- --name fund_foundation`
5. Review generated SQL for unsafe operations
6. Seed module catalogue row for FUND if needed

Acceptance criteria:

- Prisma validates
- Migration applies locally
- FUND tables exist under `fund` schema
- No destructive DB operations

---

## Phase 2 — Router + Service Layer

**Goal:** Add tRPC routes using service-layer domain logic.

Routers:

- `fund.products`
- `fund.events`
- `fund.projects`
- `fund.stores`
- `fund.orders`
- `fund.settings`

Rules:

- Routers validate with Zod
- Services perform DB operations
- Every query is organization-scoped
- Mutations audit significant actions
- Permission checks are explicit

Acceptance criteria:

- CRUD works for products/events/projects/stores
- No unscoped `findMany` queries
- TypeScript passes

---

## Phase 3 — Platform Admin + Tenant UI

**Goal:** Build usable management screens following IsoStack UI standards.

Initial pages:

- `/app/fund` dashboard
- `/app/fund/products`
- `/app/fund/events`
- `/app/fund/projects`
- `/app/fund/stores`
- `/app/fund/orders`
- `/app/fund/settings`

UI standards:

- Mantine components
- DataTable row-click opens modal
- Delete button in modal footer, bottom-left
- No table actions column
- Tooltips added to key configuration fields

Acceptance criteria:

- Admin can configure products, event, project, store
- UX matches Table CRUD Pattern
- Empty states explain next step

---

## Phase 4 — Store + Checkout Flow

**Goal:** Enable a FUND store to collect paid orders.

Steps:

1. Define public store route pattern
2. Generate store URL from project/store record
3. Add product selection/order basket flow
4. Create Stripe Checkout Session
5. Add webhook handling for payment success/failure
6. Update order/store/project lifecycle after payment

Acceptance criteria:

- Test order can be paid in Stripe test mode
- Payment success updates `FundOrder.status`
- Audit logs record payment lifecycle
- Store cannot accept orders after close date

---

## Phase 5 — Artwork / Data / PDF Pipeline

**Goal:** Support production-ready outputs.

Steps:

1. Add upload flows for artwork and personalisation data
2. Link uploads via `MediaFile`
3. Spike PDF generation approach using one real template
4. Store generated PDF as `MediaFile`
5. Link output to project/order/production batch

Acceptance criteria:

- Admin can upload source artwork/data
- Admin can generate or attach output PDF
- Output is visible in project/order context

---

## Phase 6 — Production Workflow

**Goal:** Track work from validation to dispatch.

Steps:

1. Add production batch creation
2. Assign projects/orders to batch
3. Track production states
4. Record dispatch/delivery details
5. Add exception handling

Acceptance criteria:

- Admin can see production pipeline
- Orders/projects move through production states
- Delivery status visible to tenant/organiser

---

## Phase 7 — Commission Engine

**Goal:** Calculate revenue splits and payout reporting.

Steps:

1. Define commission rules by tenant/event/product/project
2. Calculate commission lines from paid orders
3. Add commission run workflow
4. Export/report commission statements
5. Support AMOW/founding production partner margin as config, not hardcode

Acceptance criteria:

- Paid orders produce commission lines
- Admin can run and review commission batches
- Rules are configurable per tenant/event/product

---

## Phase 8 — Metrics, Limits, and Product Packages

**Goal:** Make FUND commercially manageable through IsoStack product packages.

Candidate metrics:

- `fund_projects`
- `fund_active_stores`
- `fund_orders`
- `fund_products`
- `fund_organisers`

Steps:

1. Add `MetricDefinition` rows through P1 Metric Library
2. Assign metrics to FUND module
3. Add counters to `src/server/core/metricCounters.ts`
4. Add enforcement gates in create mutations
5. Add dashboard usage indicators if useful

Acceptance criteria:

- P1 can set package limits for FUND metrics
- Creating resources respects configured limits
- Unlimited remains default when no limit row exists

---

## 9. MVP Definition

The MVP is production-useful when a tenant admin can:

1. Create products
2. Create an event/campaign
3. Create a project
4. Generate/open a store
5. Take a paid order through Stripe test/live flow
6. View orders and project status
7. Upload/attach production files
8. Mark fulfilment/dispatch complete

Commission automation and full workflow configurability can follow after MVP if necessary.

---

## 10. AI Resume Prompts

### Start Phase 1

```text
Continue FUND module build. Read:
- docs/2026-IsoStack-Docs/Module Building/FUND_MODULE_PROJECT.md
- docs/2026-IsoStack-Docs/Module Building/01-functional-specification-FUND.md

Start Phase 1: Database Foundation.
Update prisma/schema.prisma with fund schema MVP models only.
Do not run db:push. Use Prisma migrations only.
```

### Start Phase 2

```text
Continue FUND module build. Phase 1 database foundation is complete.
Start Phase 2: Router + Service Layer.
Create src/modules/fund/routers and services for products/events/projects/stores.
Ensure every query is organizationId-scoped and every mutation audits.
```

### Start Phase 3

```text
Continue FUND module build. Start Phase 3: Platform/Tenant UI.
Build /app/fund pages using Mantine and the Table CRUD Pattern.
Use row-click modals and delete button bottom-left.
```

---

## 11. Open Questions

- Which PDF engine should be selected after first real template spike?
- Is the first public store route branded under tenant domain or central IsoStack route?
- Are organisers platform users, external contacts, or both?
- Should customers be persisted as users, contacts, or order-only records?
- What is the first AMOW/FUND product set for MVP validation?
- Should commission rules be fixed for MVP or configurable from day one?

---

## 12. Current Status

- Functional specification exists
- AMOW planning scaffold has been superseded
- FUND project plan exists
- FUND code implementation has not started
- No FUND database models/migrations have been created yet

```