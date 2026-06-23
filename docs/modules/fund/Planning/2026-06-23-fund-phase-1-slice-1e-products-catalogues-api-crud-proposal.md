# FUND Phase 1 Slice 1E - Products and Catalogues API/CRUD Proposal

Date: 2026-06-23

Status: Planning only

This document proposes the tRPC, service and admin CRUD approach for tenant-owned FUND Products and Catalogues. It does not authorise code, Prisma schema, migration, router, service, UI, dashboard, seed, reset or `db:push` work.

Canonical inputs:

- `01-fund-module-brief.md`
- `02-fund-architecture-principles.md`
- `03-fund-functional-specification.md`
- `04-fund-phase-1-implementation-plan.md`
- `05-fund-open-questions.md`
- `Planning/2026-06-23-fund-phase-1-slice-1d-products-catalogues-schema-proposal.md`
- `implementation/2026-06-23-phase-1-slice-1d-products-catalogues-confirmation.md`

## Slice Goal

Slice 1E should add the controlled API and admin-management plan for Products and Catalogues created in Slice 1D.

This slice should prove:

- tenant-owned Product CRUD;
- tenant-owned Catalogue CRUD;
- same-tenant Catalogue/Product membership actions;
- workflow class selection from protected platform defaults;
- archive/restore instead of hard delete;
- audit logging for meaningful mutations;
- admin CRUD UI pattern for a future implementation.

This slice must not introduce Projects, Events, Stores, Orders, commerce, dashboards, SeasonPro integration or cross-tenant Product sharing.

## Current Implementation Context

Implemented in app repo:

- `FundProductWorkflowClass` platform defaults from Slice 1C.
- `fund.workflowClasses.list` read-only tRPC endpoint.
- `FundProductStatus`.
- `FundCatalogueStatus`.
- `FundProduct`.
- `FundCatalogue`.
- `FundCatalogueProduct`.
- required `organizationId` on all tenant-owned Product/Catalogue tables.
- composite same-tenant foreign keys on Catalogue/Product membership.

Important current limitation:

- direct `MediaFile` relations were deliberately deferred in Slice 1D.
- no Product/Catalogue routers, services or UI exist yet.

## 1. Products Router Design

Recommended router:

```text
src/modules/fund/routers/products.router.ts
```

Recommended registration:

```ts
export const fundRouter = createTRPCRouter({
  workflowClasses: workflowClassesRouter,
  products: productsRouter,
  catalogues: cataloguesRouter,
});
```

Recommended procedures:

- `list`
- `get`
- `create`
- `update`
- `archive`
- `restore`
- `activate`

Do not add hard delete in this slice.

### products.list

Purpose:

- list tenant-owned Products for admin management.

Input:

- optional `status`;
- optional `workflowClassId`;
- optional search string;
- optional `includeArchived`;
- optional pagination/sort if aligned with existing list-control pattern.

Rules:

- require authentication;
- require FUND feature access;
- filter by current `organizationId`;
- default to non-archived or all non-archived statuses, depending UI choice;
- include `workflowClass` for display.

Recommended sort:

- `sortOrder asc`;
- `name asc`.

### products.get

Purpose:

- get one tenant-owned Product for edit/detail modal.

Rules:

- `findFirst({ where: { id, organizationId } })`;
- include `workflowClass`;
- include `catalogueProducts.catalogue` if useful for admin context.

### products.create

Purpose:

- create Product in `DRAFT` by default.

Rules:

- require OWNER/ADMIN initially;
- require FUND feature access;
- validate workflow class exists and is active;
- create with current `organizationId`;
- no Product may be created without workflow class;
- audit `FUND_PRODUCT_CREATED`.

### products.update

Purpose:

- edit Product metadata and draft/active fields.

Rules:

- require OWNER/ADMIN initially;
- fetch existing Product by `id + organizationId`;
- if changing `workflowClassId`, validate active workflow class;
- validate tenant-unique code/slug if changed;
- update `updatedById`;
- audit `FUND_PRODUCT_UPDATED`;
- audit specialised events for workflow class or price changes where useful.

### products.activate

Purpose:

- move Product from `DRAFT` or `ARCHIVED` to `ACTIVE`.

Rules:

- require name, code, slug and workflow class;
- require `unitPriceNet` unless a reviewed decision allows no-price Products;
- validate `unitPriceNet >= 0`;
- validate `vatRate` between `0` and `100`;
- set status `ACTIVE`;
- clear archive metadata if restoring from archived;
- audit `FUND_PRODUCT_ACTIVATED`.

### products.archive

Purpose:

- retire Product from new use without deleting it.

Rules:

- set `status = ARCHIVED`;
- set `archivedAt`, `archivedById`, `archivedReason`;
- do not remove Catalogue membership rows;
- audit `FUND_PRODUCT_ARCHIVED`.

### products.restore

Purpose:

- restore archived Product back to `DRAFT` or `ACTIVE`.

Recommendation:

- restore to `DRAFT` by default unless explicitly activating.
- audit `FUND_PRODUCT_RESTORED`.

## 2. Catalogues Router Design

Recommended router:

```text
src/modules/fund/routers/catalogues.router.ts
```

Recommended procedures:

- `list`
- `get`
- `create`
- `update`
- `archive`
- `restore`
- `activate`
- `addProduct`
- `removeProduct`
- `reorderProducts`
- `setProductActive`

Do not add hard delete in this slice.

### catalogues.list

Purpose:

- list tenant-owned Catalogues for admin management.

Rules:

- require authentication;
- require FUND feature access;
- filter by `organizationId`;
- optional status/search filters;
- include count of active Product membership if useful.

### catalogues.get

Purpose:

- get one Catalogue with its Products.

Rules:

- `findFirst({ where: { id, organizationId } })`;
- include `catalogueProducts` ordered by `sortOrder`;
- include each Product and Product workflow class.

### catalogues.create

Purpose:

- create Catalogue in `DRAFT` by default.

Rules:

- require OWNER/ADMIN initially;
- create with current `organizationId`;
- audit `FUND_CATALOGUE_CREATED`.

### catalogues.update

Purpose:

- edit Catalogue metadata.

Rules:

- fetch by `id + organizationId`;
- validate tenant-unique code/slug if changed;
- update `updatedById`;
- audit `FUND_CATALOGUE_UPDATED`.

### catalogues.activate

Purpose:

- make Catalogue available for later Project/Event selection.

Rules:

- require name, code and slug;
- recommended: require at least one active Product before activation;
- optional rule: active Catalogue should not include archived Products;
- audit `FUND_CATALOGUE_ACTIVATED`.

### catalogues.archive

Purpose:

- retire Catalogue from new use.

Rules:

- set `status = ARCHIVED`;
- set `archivedAt`, `archivedById`, `archivedReason`;
- do not archive Products;
- do not remove membership rows;
- audit `FUND_CATALOGUE_ARCHIVED`.

### catalogues.restore

Purpose:

- restore archived Catalogue.

Recommendation:

- restore to `DRAFT` by default.
- audit `FUND_CATALOGUE_RESTORED`.

## 3. Catalogue/Product Join Actions

The database already prevents cross-tenant joins through composite foreign keys. The service/router layer should still validate explicitly for clearer errors and defence in depth.

### addProduct

Input:

- `catalogueId`
- `productId`
- optional `sortOrder`

Rules:

- fetch Catalogue by `catalogueId + organizationId`;
- fetch Product by `productId + organizationId`;
- reject if either is missing;
- reject if Catalogue is archived;
- reject if Product is archived unless explicitly allowed later;
- create membership with same `organizationId`;
- if duplicate membership exists, either return existing or raise `CONFLICT`;
- audit `FUND_CATALOGUE_PRODUCT_ADDED`.

### removeProduct

Input:

- `catalogueId`
- `productId`

Rules:

- find membership by `catalogueId + productId + organizationId`;
- delete membership or set `isActive = false`.

Recommendation:

- use `isActive = false` if historical Catalogue composition matters before Projects exist;
- hard delete may be acceptable pre-Project, but archive-style inactive membership is safer.

Audit:

- `FUND_CATALOGUE_PRODUCT_REMOVED`.

### reorderProducts

Input:

- `catalogueId`
- ordered array of membership ids or product ids.

Rules:

- verify Catalogue belongs to `organizationId`;
- verify every membership belongs to same `organizationId` and Catalogue;
- update `sortOrder` in transaction;
- audit `FUND_CATALOGUE_PRODUCT_REORDERED`.

### setProductActive

Purpose:

- hide/show a Product within a Catalogue without changing Product status.

Rules:

- update `FundCatalogueProduct.isActive`;
- audit `FUND_CATALOGUE_PRODUCT_UPDATED`.

## 4. Zod Validation Schemas

Recommended file:

```text
src/modules/fund/lib/validation/products-catalogues.ts
```

Alternative:

- keep schemas beside routers for first implementation, then extract if they grow.

Recommended shared validators:

```ts
const codeSchema = z.string().trim().min(1).max(64);
const slugSchema = z.string().trim().min(1).max(96).regex(/^[a-z0-9]+(?:-[a-z0-9]+)*$/);
const nameSchema = z.string().trim().min(1).max(160);
const moneySchema = z.number().min(0).max(999999.99);
const vatRateSchema = z.number().min(0).max(100);
const currencySchema = z.string().trim().length(3).default('GBP');
```

Product create:

- `workflowClassId` required;
- `code` required;
- `name` required;
- `slug` required;
- `description` optional;
- `shortDescription` optional;
- `unitPriceNet` optional;
- `vatRate` default `20`;
- `currency` default `GBP`;
- `pricingNotes` optional;
- `productionNotes` optional;
- `metadata` optional object if needed.

Product update:

- `id` required;
- all editable fields optional;
- `status` should not be directly mutable through general update if dedicated status actions exist.

Catalogue create:

- `code` required;
- `name` required;
- `slug` required;
- `description` optional;
- `metadata` optional.

Catalogue update:

- `id` required;
- all editable fields optional;
- `status` should not be directly mutable through general update if dedicated status actions exist.

Join actions:

- ids required;
- reorder array must be non-empty and same-catalogue validated server-side.

## 5. Tenant Scoping Rules

Every Product/Catalogue query must resolve current `organizationId`.

Recommended helper:

```ts
const user = await ctx.prisma.user.findUnique({
  where: { id: ctx.session!.user.id },
  select: { organizationId: true, role: true },
});
```

Every tenant-owned lookup must use:

```ts
where: {
  id: input.id,
  organizationId: user.organizationId,
}
```

Every create must set:

```ts
organizationId: user.organizationId
```

Never accept `organizationId` from client input.

## 6. Same-Tenant Validation For Joins

Even though the database has composite same-tenant foreign keys, routers/services should validate before writing:

```ts
const [catalogue, product] = await Promise.all([
  tx.fundCatalogue.findFirst({ where: { id: input.catalogueId, organizationId } }),
  tx.fundProduct.findFirst({ where: { id: input.productId, organizationId } }),
]);
```

If either record is missing, return `NOT_FOUND`.

If Product is archived, return `BAD_REQUEST` unless later rules allow archived Product membership.

If Catalogue is archived, return `BAD_REQUEST`.

## 7. Workflow Class Lookup And Use

Products must reference an active `FundProductWorkflowClass`.

Product create/update should validate:

```ts
const workflowClass = await ctx.prisma.fundProductWorkflowClass.findFirst({
  where: {
    id: input.workflowClassId,
    isActive: true,
  },
});
```

Workflow Classes remain platform-level protected defaults:

- no `organizationId`;
- no tenant-owned create/update/delete;
- Product queries may include workflow class for display;
- Product activation may use workflow class flags to explain missing requirements later.

## 8. Audit Logging Requirements

Audit logging should use existing `ctx.prisma.auditLog.create` conventions.

Product actions:

- `FUND_PRODUCT_CREATED`
- `FUND_PRODUCT_UPDATED`
- `FUND_PRODUCT_ACTIVATED`
- `FUND_PRODUCT_ARCHIVED`
- `FUND_PRODUCT_RESTORED`
- `FUND_PRODUCT_WORKFLOW_CLASS_CHANGED`
- `FUND_PRODUCT_PRICE_CHANGED`

Catalogue actions:

- `FUND_CATALOGUE_CREATED`
- `FUND_CATALOGUE_UPDATED`
- `FUND_CATALOGUE_ACTIVATED`
- `FUND_CATALOGUE_ARCHIVED`
- `FUND_CATALOGUE_RESTORED`
- `FUND_CATALOGUE_PRODUCT_ADDED`
- `FUND_CATALOGUE_PRODUCT_REMOVED`
- `FUND_CATALOGUE_PRODUCT_REORDERED`
- `FUND_CATALOGUE_PRODUCT_UPDATED`

Audit metadata should include:

- code;
- slug;
- previous status and new status;
- workflow class id/code when relevant;
- old/new price values when relevant;
- Catalogue/Product ids for join actions.

## 9. Product Archive And Restore Approach

Archive:

- set `status = ARCHIVED`;
- set `archivedAt = new Date()`;
- set `archivedById = current user id`;
- set optional `archivedReason`;
- leave Catalogue membership intact;
- prevent use in new Catalogue membership unless later approved.

Restore:

- set `status = DRAFT` by default;
- clear archive metadata;
- require explicit `activate` to make live.

Hard delete:

- out of scope.

## 10. Catalogue Archive And Restore Approach

Archive:

- set `status = ARCHIVED`;
- set `archivedAt`, `archivedById`, `archivedReason`;
- leave membership rows intact;
- do not archive Products.

Restore:

- set `status = DRAFT` by default;
- clear archive metadata.

Hard delete:

- out of scope.

## 11. Price And VAT Validation

Recommended rules:

- `unitPriceNet` may be nullable in `DRAFT`.
- `unitPriceNet` must be `>= 0` if supplied.
- `unitPriceNet` should be required before `ACTIVE` unless explicitly waived.
- `vatRate` must be between `0` and `100`.
- `currency` should be a 3-letter uppercase code, default `GBP`.
- use Prisma `Decimal` for writes if router input is numeric.
- return numeric values to UI by converting Decimal to `Number`.

Do not add:

- gross price storage;
- Stripe price ids;
- GoCardless fields;
- discounts;
- bundles;
- commission rates;
- per-catalogue price overrides.

## 12. MediaFile Validation If Used

Media is not recommended for Slice 1E implementation because Slice 1D deliberately deferred direct `MediaFile` relations.

If media is later introduced:

- never accept a `MediaFile` id without validating `organizationId`;
- verify file type for images/documents;
- create `MediaUsage` rows if following core usage pattern;
- audit media changes;
- consider `FundProductAsset` rather than direct fields if multiple files are needed.

Recommended for Slice 1E:

- keep media out of scope.

## 13. Admin UI Route/Page Proposal

Do not build UI yet. Proposed future route:

```text
/app/fund/products
```

Alternative:

```text
/app/fund/admin/products
```

Recommended first implementation:

- one admin management surface under `/app/fund/products`;
- tabs for Products and Catalogues;
- use the existing app shell and FUND module route;
- require FUND feature access;
- restrict create/update/archive actions to OWNER/ADMIN until FUND module-role strategy is decided.

Suggested page layout:

- header row with title and add button;
- tabs: `Products`, `Catalogues`;
- dense DataTable for each tab;
- row click opens edit modal;
- action icons for archive/restore;
- Catalogue detail/edit modal includes Product membership management.

## 14. Table CRUD Pattern

Follow existing Mantine/Mantine DataTable patterns:

- `DataTable` for list views;
- `Modal` for create/edit forms;
- `useForm` for form state;
- `notifications.show` for mutation feedback;
- `trpc.useContext()` invalidation after successful mutation;
- icon buttons with tooltips for actions;
- badges for status and workflow class;
- no nested cards inside cards.

Product table columns:

- Code
- Name
- Workflow Class
- Status
- Net Price
- VAT
- Currency
- Catalogue count
- Updated
- Actions

Catalogue table columns:

- Code
- Name
- Status
- Product count
- Updated
- Actions

Catalogue membership UI:

- product picker filtered to current tenant;
- only active Products by default;
- selected Products listed in sortable table;
- remove/deactivate action per membership.

## 15. Manual Test Scenarios

API/service tests:

- tenant with FUND enabled can list own Products.
- tenant without FUND enabled is forbidden.
- Tenant A cannot list Tenant B Products.
- Tenant A cannot get Tenant B Product by id.
- Product create rejects missing workflow class.
- Product create rejects inactive/missing workflow class.
- Product create sets current `organizationId`.
- Product code duplicate within tenant is rejected.
- same code in different tenants is allowed.
- Product activation rejects missing price if activation rule requires it.
- Product archive sets archive metadata.
- Product restore returns Product to draft.
- Catalogue create sets current `organizationId`.
- Catalogue code duplicate within tenant is rejected.
- Catalogue addProduct rejects Product from another tenant.
- Catalogue addProduct rejects Catalogue from another tenant.
- Catalogue addProduct rejects archived Product by default.
- Catalogue archive does not archive Products.
- all significant mutations write AuditLog rows.

UI tests when built:

- Products tab loads.
- Catalogues tab loads.
- create/edit modals validate required fields.
- workflow class select shows A1/A2/B/C.
- status badges are readable.
- archive/restore actions are clear.
- membership management cannot select cross-tenant Products.

## 16. Files Likely To Change

API/service implementation:

- `src/modules/fund/routers/products.router.ts`
- `src/modules/fund/routers/catalogues.router.ts`
- `src/modules/fund/routers/index.ts`
- `src/modules/fund/lib/validation/products-catalogues.ts`
- `src/modules/fund/services/products.service.ts`
- `src/modules/fund/services/catalogues.service.ts`

UI implementation, when approved:

- `src/app/(app)/app/fund/products/page.tsx`
- `src/modules/fund/components/products/ProductModal.tsx`
- `src/modules/fund/components/products/ProductTable.tsx`
- `src/modules/fund/components/catalogues/CatalogueModal.tsx`
- `src/modules/fund/components/catalogues/CatalogueTable.tsx`
- `src/modules/fund/components/catalogues/CatalogueProductsManager.tsx`

Documentation:

- `isodocs/docs/modules/fund/implementation/2026-06-23-phase-1-slice-1e-products-catalogues-api-crud-confirmation.md`

## 17. Out Of Scope

Do not build in Slice 1E:

- Projects;
- Events;
- Stores;
- Orders;
- commerce;
- payments;
- commissions;
- dashboards;
- SeasonPro integration;
- cross-tenant Product sharing;
- AMOW marketplace exposure;
- Product asset/media library;
- public Store/Product pages;
- production batching;
- AI workflows;
- hard deletes.

Products and Catalogues remain strictly tenant-owned.

Workflow Classes remain platform-level protected defaults.

## 18. Confirmation Document Requirements

After implementation, create:

```text
isodocs/docs/modules/fund/implementation/2026-06-23-phase-1-slice-1e-products-catalogues-api-crud-confirmation.md
```

The confirmation document should include:

1. Slice name:
   - `Phase 1 Slice 1E - Products and Catalogues API/CRUD`
2. Date.
3. Implementation summary.
4. Files changed.
5. Routers/services created.
6. Procedures created.
7. Zod schemas created.
8. Access control and feature gating.
9. Tenant scoping strategy.
10. Same-tenant join validation.
11. Workflow class validation.
12. Audit events implemented.
13. Product/Catalogue archive and restore behaviour.
14. Price/VAT validation.
15. Media strategy and whether media stayed out of scope.
16. UI created, or confirmation that UI remained deferred.
17. What was deliberately not implemented.
18. Checks run and results.
19. Manual verification checklist.
20. Risks or follow-up issues.
21. Recommended next slice.
22. Suggested next Codex prompt.

## 19. Recommended Next Slice

Recommended next step:

```text
Phase 1 Slice 1E implementation - Products and Catalogues API/services only
```

Recommended implementation boundary:

- create routers/services and validation only;
- keep UI deferred if schema/API needs to land first;
- no Projects, Events, Stores, Orders, commerce, dashboards or sharing.

After API/services land cleanly, the next slice can be:

```text
Phase 1 Slice 1F - Products and Catalogues admin UI
```

Then:

```text
Phase 1 Slice 1G - Projects as mandatory operational entities schema proposal
```

## Suggested Next Codex Prompt

```text
Proceed with FUND Phase 1 Slice 1E implementation for Products and Catalogues API/services only.

Do not edit Prisma schema.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.
Do not create UI pages or dashboards.

Use:
- isodocs/docs/modules/fund/Planning/2026-06-23-fund-phase-1-slice-1e-products-catalogues-api-crud-proposal.md
- active FUND docs
- Slice 1D implementation confirmation

Implement only:
- Products router
- Catalogues router
- Product/Catalogue validation schemas
- service helpers if useful
- tenant-scoped CRUD
- same-tenant join validation
- workflow class validation
- archive/restore actions
- audit logging

Keep Products and Catalogues strictly tenant-owned.
Keep Workflow Classes as platform-level protected defaults.
Do not create Projects, Events, Stores, Orders, commerce, dashboards, SeasonPro integration, sharing or marketplace logic.

Run type-check and verify when complete.
Create the Slice 1E implementation confirmation document.
```
