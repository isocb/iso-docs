# FUND Module — Phase 1 Implementation Backlog

**Scope:** Database Foundation + Core Admin Surface (review-only planning document)
**Created:** 2026-06-11
**Source:** `FUND_MODULE_BRIEF.md`

## 1) Goal of Phase 1
Deliver a stable, tenant-safe FOUNDATION for FUND with multi-schema placement (`fund`) and tenant isolation (`organizationId`), plus a minimal admin surface so Isoblue and AMOW can create and manage fundraising entities safely.

Phase 1 should prove that FUND is:
- routable as a module in the IsoStack app shell,
- data-modeled for Products/Catalogues/Events/Projects,
- scoped by tenant across all reads and writes,
- auditable for key changes.

## 2) What must be built
- Register FUND as a first-class module (module config + module registry + feature visibility + navigation).
- Add core Prisma models (Fund namespace) for:
  - Product
  - ProductCategory
  - Catalogue
  - CatalogueProduct (join)
  - Event
  - Project
  - ProjectProduct (join)
  - Store
  - ProjectType
- Create core tRPC routers for read/write APIs.
- Add app routes/pages for admin surfaces (products, catalogues, events, projects, stores, dashboard).
- Add server-side validation and tenant scope checks.
- Add audit logging on significant mutations.
- Add minimal seed/demo records for AMOW-path baseline.

## 3) Out of scope (explicitly)
- Full payment/checkout stack.
- Order/refund processing.
- Full commission payout logic.
- Lifecycle automation engine and scheduled communication sequences.
- Production/fulfilment workflows and dispatch tracking.
- AI assistants/automation.

## 4) Proposed Prisma models and relationships
Use PostgreSQL `fund` schema for module ownership separation, while keeping **tenanting explicit** via `organizationId`.

### Core entities
- `FundProduct`
  - Fields: `id`, `organizationId`, `name`, `description`, `price`, `currency`, `status`, `vatStatus`, `imageUrl` (optional), timestamps
- `FundProductCategory`
  - Fields: `id`, `organizationId`, `name`, `slug`, `description`
- `FundCatalogue`
  - Fields: `id`, `organizationId`, `name`, `description`, `status`, timestamps
- `FundCatalogueProduct`
  - Join: `fundCatalogueId`, `fundProductId`, optional overrides (price/active flags)
- `FundEvent`
  - Fields: `id`, `organizationId`, `name`, `eventDate`, `storeOpenDate`, `storeCloseDate`, `productionDeadline`, `status`, `terms`, timestamps
- `FundProjectType`
  - Fields: `id`, `organizationId`, `name`, `slug`, `isSeasonBased`
- `FundProject`
  - Fields: `id`, `organizationId`, `fundEventId`, `projectNumber`, `fundProjectTypeId`, `name`, `closingDate`, `status`, `organizerUserId?`, timestamps
- `FundProjectProduct`
  - Join: `fundProjectId`, `fundProductId`, optional `overridePrice`
- `FundStore`
  - Fields: `id`, `organizationId`, `fundProjectId`, `slug`, `status`, `openAt`, `closeAt`, `branding`, `terms`, timestamps

### Suggested relationships
- `FundProduct` ←→ `FundCatalogue` via `FundCatalogueProduct`
- `FundEvent` → many `FundProject`
- `FundProject` → many `FundProjectProduct` → `FundProduct`
- `FundProject` → one `FundStore`
- `FundProjectType` → many `FundProject`
- All tenant-owned records require `organizationId`.

### Suggested indexes
- `(organizationId, status)`
- `(organizationId, eventDate)`
- `(organizationId, fundEventId)`
- `(organizationId, projectNumber)` (or unique per event scope if preferred)

## 5) Tenant scoping approach
- Keep `organizationId` required on all tenant-owned FUND tables, even inside `fund` schema.
- Never rely on schema scoping for security.
- Every query/write must include `where: { organizationId: session.user.organizationId, ... }`.
- Use `protectedProcedure` and role/feature checks from core tRPC middleware.

## 6) Permissions / roles required
- `OWNER` / `ADMIN`: create, update, archive, and manage FUND entities.
- `MEMBER`: default read-only until future role model expansion.
- `withFeature('fund')` gate for module exposure/actions.
- `protectedProcedure` for all FUND endpoints.
- Audit and critical writes protected by `requireRole([Role.OWNER, Role.ADMIN])`.

## 7) tRPC routers likely required
Under `src/modules/fund/routers`:
- `index.ts` with `fundRouter`
- `products.router.ts`
- `catalogues.router.ts`
- `events.router.ts`
- `projects.router.ts`
- `stores.router.ts`

Register this router in:
- `src/server/core/routers/index.ts` as `fund`

## 8) UI routes / pages likely required
Under `src/app/(app)/app/fund`:
- `dashboard/page.tsx`
- `products/page.tsx`
- `catalogues/page.tsx`
- `events/page.tsx`
- `projects/page.tsx`
- `stores/page.tsx`

Also add:
- `src/app/(app)/app/fund/layout.tsx` (module shell/billing guard if needed)
- module navigation entries so pages appear in sidebar

## 9) Seed/demo data required
- AMOW tenant context fixture (founding use case, not module identity)
- Demo products: Christmas Cards, Mugs, Tea Towels, Water Bottles
- Sample event: `Christmas 2026`
- Demo catalogue: `AMOW Christmas Catalogue 2026`
- Demo project linked to event and store
- Optional seed roles/demo users for Owner/Admin admin flow checks

## 10) Audit events required
Log to `AuditLog` on:
- `fund.product.created/updated`
- `fund.catalogue.created/updated`
- `fund.event.created/updated`
- `fund.project.created/updated`
- `fund.store.created/opened/closed`
- `fund.seed.demo.applied` (if desired for local/dev verification)

## 11) Validation rules
- All tenant writes require org match + membership checks.
- Project closing date must not exceed linked event production deadline.
- Store close date must not exceed project closing date and must be valid with open date.
- Event open/close/production timeline must be monotonic.
- Product price cannot be negative; currency/precision controlled.
- Catalogues/events/projects should have non-empty unique names per org context.

## 12) Risks or decisions needed before implementation
1. Project numbering strategy: global per tenant vs per event.
2. Store implementation depth: generated placeholder vs external commerce-ready structure.
3. How deeply to model product lifecycle metadata in v1.
4. Whether `FundProjectType` is fixed/static in v1 or configurable by tenant.
5. Minimum required product image/document handling in phase one (URL-only vs upload pipeline).

## 13) Suggested file-by-file task list
1. `src/modules/fund/module.config.ts` (align to `ModuleConfig` shape)
2. `src/modules/module.registry.ts`
3. `src/core/config/module-navigation.ts`
4. `prisma/schema.prisma` (add `fund` schema entry + models)
5. `src/modules/fund/routers/index.ts`
6. `src/modules/fund/routers/products.router.ts`
7. `src/modules/fund/routers/catalogues.router.ts`
8. `src/modules/fund/routers/events.router.ts`
9. `src/modules/fund/routers/projects.router.ts`
10. `src/modules/fund/routers/stores.router.ts`
11. `src/server/core/routers/index.ts` (mount router)
12. `src/app/(app)/app/fund/layout.tsx`
13. `src/app/(app)/app/fund/dashboard/page.tsx`
14. `src/app/(app)/app/fund/products/page.tsx`
15. `src/app/(app)/app/fund/catalogues/page.tsx`
16. `src/app/(app)/app/fund/events/page.tsx`
17. `src/app/(app)/app/fund/projects/page.tsx`
18. `src/app/(app)/app/fund/stores/page.tsx`
19. Seed fixture file/script update in `isodocs` planning cross-reference + implementation notes

## 14) Suggested order of implementation
1. Module registration + shell/nav wiring
2. Prisma models + enums + indexes
3. Routers + validation + tenant scoping
4. Core admin pages (CRUD views)
5. Audit hooks on writes
6. Seed/demo wiring
7. Manual verification pass against checklist

## 15) Manual test scenarios for Phase 1
- Create/read/update/archive a product.
- Build a catalogue and attach/remove products.
- Create an event and validate date rules.
- Create a project linked to event and verify close-date rule.
- Create/open a store for a project.
- Verify tenant isolation (tenant B cannot see tenant A records).
- Verify admin-only write access and MEMBER restrictions.
- Verify `fund` module visibility and route access follow feature entitlement.
- Verify audit events are emitted for key mutations.

## 16) Mapping to FUND documentation
- Canonical docs remain in `isodocs/docs/modules/fund/`
- This file is a phase-specific implementation plan for Phase 1 review.

---

## Notes for implementation reviews
- No code edits performed in this document step.
- No migrations generated in this planning step.
- No `db:push` to be used in implementation.
