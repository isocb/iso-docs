# Phase 1 Slice 1E - Products and Catalogues API/CRUD

Date: 2026-06-23

Status: Implemented on `isostack-bedrock` `dev`

## Implementation Summary

FUND Phase 1 Slice 1E adds API/service support for tenant-owned Products and Catalogues.

This slice is deliberately API-only:

- added Product validation schemas;
- added Catalogue validation schemas;
- added tenant-scoped Product service functions;
- added tenant-scoped Catalogue service functions;
- added Catalogue/Product membership service functions;
- added Product tRPC router;
- added Catalogue tRPC router;
- registered both routers under the existing FUND router;
- added audit logging for meaningful mutations.

No UI, dashboards, Prisma schema changes, migrations, seed/reset commands, `db:push`, Projects, Events, Stores, Orders, commerce, commissions, SeasonPro integration, AMOW marketplace exposure or media/asset workflows were created.

## Post-Review Corrections

After targeted pre-staging review, the following corrections were applied:

- nested Product `unitPriceNet` and `vatRate` values returned through `catalogues.get` are now serialised to the same API-safe numeric shape used by `products.list` and `products.get`;
- Prisma `P2002` unique constraint races in Product create/update, Catalogue create/update and Catalogue/Product membership add now return shaped `CONFLICT` errors instead of raw Prisma errors;
- Catalogue/Product reorder audit logging now records `FUND_CATALOGUE_PRODUCT_REORDERED` against the `FundCatalogue` entity with Catalogue id, membership ids, count and previous/new sort information, avoiding misleading empty Product metadata.

No schema, migration, UI, dashboard, Project, Event, Store, Order, commerce, commission, SeasonPro, sharing, marketplace or media work was added by these corrections.

## Files Changed

App repository:

- `src/modules/fund/lib/validation/products-catalogues.ts`
- `src/modules/fund/services/products.service.ts`
- `src/modules/fund/services/catalogues.service.ts`
- `src/modules/fund/routers/products.router.ts`
- `src/modules/fund/routers/catalogues.router.ts`
- `src/modules/fund/routers/index.ts`

Documentation repository:

- `docs/modules/fund/implementation/2026-06-23-phase-1-slice-1e-products-catalogues-api-crud-confirmation.md`

## Routers And Services Created

Routers:

- `fund.products`
- `fund.catalogues`

Services:

- Product service:
  - list/get/create/update/activate/archive/restore;
  - workflow class validation;
  - tenant uniqueness checks;
  - Product audit logging.
- Catalogue service:
  - list/get/create/update/activate/archive/restore;
  - same-tenant Catalogue/Product membership validation;
  - membership add/remove/reorder/set-active;
  - Catalogue and membership audit logging.

## Procedures Created

Product procedures:

- `fund.products.list`
- `fund.products.get`
- `fund.products.create`
- `fund.products.update`
- `fund.products.activate`
- `fund.products.archive`
- `fund.products.restore`

Catalogue procedures:

- `fund.catalogues.list`
- `fund.catalogues.get`
- `fund.catalogues.create`
- `fund.catalogues.update`
- `fund.catalogues.activate`
- `fund.catalogues.archive`
- `fund.catalogues.restore`
- `fund.catalogues.addProduct`
- `fund.catalogues.removeProduct`
- `fund.catalogues.reorderProducts`
- `fund.catalogues.setProductActive`

No hard delete procedures were added.

## Zod Schemas Created

Shared validation file:

```text
src/modules/fund/lib/validation/products-catalogues.ts
```

Schemas include:

- Product list/get/create/update inputs;
- Catalogue list/get/create/update inputs;
- archive input;
- id input;
- Catalogue/Product membership inputs;
- reorder input;
- set membership active input;
- shared code, slug, name, money, VAT, currency, metadata and archive reason validators.

Validation rules:

- `code`: required, trimmed, max 64;
- `slug`: required, lower-case URL-safe pattern, max 96;
- `name`: required, max 160;
- `unitPriceNet`: optional in draft, min 0, max 999999.99;
- `vatRate`: default 20, min 0, max 100;
- `currency`: 3-letter uppercase code, default GBP;
- archive reason: optional, max 500;
- metadata: optional object.

## Access Control And Feature Gating

All procedures use `withFeature('fund')`, which requires:

- authentication;
- active session;
- FUND feature access for the effective organisation.

Mutation procedures also require the effective user role to be:

- `OWNER`; or
- `ADMIN`.

This follows the active Phase 1 decision to use platform OWNER/ADMIN management before adding FUND-specific module roles.

## Tenant Scoping Strategy

The API never accepts `organizationId` from client input.

The routers resolve an actor from the effective session context:

- `effectiveUserId` where present;
- `effectiveOrgId` where present;
- otherwise the authenticated user's own organisation.

Every Product, Catalogue and Catalogue/Product membership read/write is scoped by the actor's `organizationId`.

Product and Catalogue create operations set `organizationId` server-side.

## Same-Tenant Join Validation

Catalogue/Product membership actions explicitly validate the Catalogue and Product both belong to the current tenant before writing.

This is done before database writes even though Slice 1D already added composite same-tenant foreign keys.

Membership actions reject:

- missing Catalogue;
- missing Product;
- archived Catalogue when adding/reactivating;
- archived Product when adding/reactivating;
- membership reorder inputs that do not all belong to the current Catalogue and tenant.

## Workflow Class Validation

Product create requires `workflowClassId`.

Product update validates a new `workflowClassId` when changed.

Product activation validates the existing workflow class still exists and is active.

Workflow Classes remain platform-level protected defaults. They are not copied into Product as text and are not tenant-editable in this slice.

## Audit Events Implemented

Product events:

- `FUND_PRODUCT_CREATED`
- `FUND_PRODUCT_UPDATED`
- `FUND_PRODUCT_ACTIVATED`
- `FUND_PRODUCT_ARCHIVED`
- `FUND_PRODUCT_RESTORED`
- `FUND_PRODUCT_WORKFLOW_CLASS_CHANGED`
- `FUND_PRODUCT_PRICE_CHANGED`

Catalogue events:

- `FUND_CATALOGUE_CREATED`
- `FUND_CATALOGUE_UPDATED`
- `FUND_CATALOGUE_ACTIVATED`
- `FUND_CATALOGUE_ARCHIVED`
- `FUND_CATALOGUE_RESTORED`

Membership events:

- `FUND_CATALOGUE_PRODUCT_ADDED`
- `FUND_CATALOGUE_PRODUCT_REMOVED`
- `FUND_CATALOGUE_PRODUCT_REORDERED`
- `FUND_CATALOGUE_PRODUCT_UPDATED`

Audit metadata includes entity identifiers, codes/slugs where relevant, status transitions, workflow class changes, price changes and Catalogue/Product membership context.

## Archive And Restore Behaviour

Product archive:

- sets status to `ARCHIVED`;
- sets `archivedAt`;
- sets `archivedById`;
- stores optional `archivedReason`;
- does not remove Catalogue membership rows;
- does not hard delete.

Product restore:

- restores to `DRAFT`;
- clears archive metadata;
- requires explicit activation to become active again.

Catalogue archive:

- sets status to `ARCHIVED`;
- sets `archivedAt`;
- sets `archivedById`;
- stores optional `archivedReason`;
- does not archive Products;
- does not remove membership rows;
- does not hard delete.

Catalogue restore:

- restores to `DRAFT`;
- clears archive metadata;
- requires explicit activation to become active again.

Membership remove:

- sets `FundCatalogueProduct.isActive = false`;
- does not hard delete membership.

## Price, VAT And Currency Validation

Products may be created in `DRAFT` without `unitPriceNet`.

Activation requires:

- `unitPriceNet` to be present;
- `unitPriceNet >= 0`;
- `vatRate >= 0`;
- `vatRate <= 100`;
- valid 3-letter uppercase currency.

The API stores monetary values using Prisma `Decimal` and returns numeric values for Product API consumers.

No gross price storage, Stripe price ids, GoCardless fields, discounts, bundles, commission rates or per-catalogue price overrides were added.

## Media Strategy

Media remains out of scope for Slice 1E.

No Product image/document fields, direct `MediaFile` relations, upload workflows, Product asset library, template PDF generation, proofing or production file storage were added.

This follows Slice 1D, where direct MediaFile relations were deliberately deferred until a dedicated asset/media slice can enforce same-tenant validation cleanly.

## UI Deferred

No UI files were created.

The following remain deferred to Slice 1F:

- `src/app/(app)/app/fund/products/page.tsx`
- `src/modules/fund/components/products/ProductModal.tsx`
- `src/modules/fund/components/products/ProductTable.tsx`
- `src/modules/fund/components/catalogues/CatalogueModal.tsx`
- `src/modules/fund/components/catalogues/CatalogueTable.tsx`
- `src/modules/fund/components/catalogues/CatalogueProductsManager.tsx`

## Future Slice 1F UI Note

The future Products/Catalogues admin UI must follow:

- `isostack-ux-ui-standard.md`;
- `table-crud-pattern.md` as the active implementation guide;
- `TABLE_CRUD_PATTERN_IMPLEMENTATION.md` as reference only.

Future UI must include:

- row click to CRUD modal;
- no edit/delete `ActionIcon` table rows;
- destructive actions in modal footer;
- universal fuzzy search and sort controls;
- sortable visible columns where practical;
- row-click payload normalisation with `params?.record ?? params`.

The recommended future management surface is one admin page under `/app/fund/products` with tabs for Products and Catalogues, unless active navigation standards recommend a better route at implementation time.

Catalogue Product membership management can start inside the Catalogue modal if it remains simple. If it becomes multi-section or operationally heavy, review whether it should become a child page rather than overloading the modal.

## Deliberately Not Implemented

This slice did not implement:

- UI pages or components;
- dashboards;
- Prisma schema changes;
- migrations;
- `db:push`;
- seed/reset commands;
- Projects;
- Events;
- Stores;
- Orders;
- commerce/payment logic;
- commission logic;
- SeasonPro integration;
- cross-tenant Product sharing;
- AMOW marketplace exposure;
- Product media/asset library;
- public Store/Product pages;
- production batching;
- AI workflows;
- hard delete endpoints.

## Checks Run And Results

Passed:

- `npm run type-check`
- `npm run verify`

Notes:

- The first `npm run verify` attempt failed inside the sandbox because `tsx` could not create its local IPC pipe under `/var/folders/...`.
- The same command passed when rerun with local execution permission.
- No FUND-specific automated tests currently exist under `src/modules/fund`.

No Prisma validation or client generation was required because this slice did not edit Prisma schema or migrations.

## Manual Verification Checklist

API/service checks before promotion:

- tenant with FUND enabled can list own Products;
- tenant without FUND enabled is forbidden;
- Tenant A cannot list Tenant B Products;
- Tenant A cannot get Tenant B Product by id;
- Product create rejects missing workflow class;
- Product create rejects inactive/missing workflow class;
- Product create sets current `organizationId`;
- Product code duplicate within tenant is rejected;
- same Product code in different tenants is allowed;
- Product slug duplicate within tenant is rejected;
- same Product slug in different tenants is allowed;
- Product activation rejects missing price;
- Product archive sets archive metadata;
- Product restore returns Product to draft;
- Catalogue create sets current `organizationId`;
- Catalogue code duplicate within tenant is rejected;
- same Catalogue code in different tenants is allowed;
- Catalogue slug duplicate within tenant is rejected;
- same Catalogue slug in different tenants is allowed;
- Catalogue activation rejects empty Catalogues;
- Catalogue activation rejects archived Products in active membership;
- Catalogue addProduct rejects Product from another tenant;
- Catalogue addProduct rejects Catalogue from another tenant;
- Catalogue addProduct rejects archived Product;
- Catalogue addProduct rejects archived Catalogue;
- Catalogue removeProduct sets membership inactive rather than hard deleting;
- Catalogue reorderProducts rejects memberships outside the Catalogue/current tenant;
- Catalogue archive does not archive Products;
- all significant mutations write AuditLog rows.

## Risks And Follow-Up Issues

Overall risk: Medium-low.

Reasons:

- The slice adds write APIs for new FUND entities.
- UI does not yet exercise the endpoints.
- Behaviour relies on service-layer tenant checks as well as database constraints.

Mitigations:

- No schema changes or migrations were created.
- All reads and writes are organization-scoped.
- OWNER/ADMIN checks restrict mutation procedures.
- Archive/restore avoids hard deletes.
- Activation rules prevent incomplete active Products and empty active Catalogues.

Follow-ups:

- Add API-level automated tests or integration tests once the project has a settled tRPC test harness for module routers.
- Add a dedicated media/asset slice before Product images/documents.
- Revisit FUND-specific module roles after the general role assignment strategy is decided.

## Recommended Next Slice

Next:

```text
Phase 1 Slice 1F - Products and Catalogues admin UI
```

After Slice 1F:

```text
Phase 1 Slice 1G - Projects as mandatory operational entities schema proposal
```

## Suggested Next Codex Prompt

```text
Proceed with FUND Phase 1 Slice 1F planning only: Products and Catalogues admin UI.

Read the Slice 1E implementation confirmation, the active FUND docs, and the IsoStack UI/UX standard/table CRUD pattern docs.

Do not edit code yet.
Do not edit Prisma schema.
Do not create migrations.
Do not run db:push.

Produce an implementation proposal for the Products/Catalogues admin UI using the existing Slice 1E routers only.
```
