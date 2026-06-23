# Phase 1 Slice 1D - Tenant-Owned Products and Catalogues

Date: 2026-06-23

Status: Implemented as schema/migration only on `isostack-bedrock` `dev`

## Implementation Summary

FUND Phase 1 Slice 1D adds the schema foundation for tenant-owned Products and Catalogues.

This slice was implemented after Slice 1C was cleaned and committed as:

```text
feda396 feat(fund): add product workflow classes
```

Slice 1D remains deliberately narrow:

- added Product and Catalogue status enums;
- added tenant-owned Product model;
- added tenant-owned Catalogue model;
- added tenant-owned Catalogue/Product join model;
- added required `Organization` relations;
- added tenant-scoped uniqueness and indexes;
- added composite same-tenant foreign keys for Catalogue/Product membership;
- created a migration.

No routers, services, UI pages or dashboards were created.

## Files Changed

App repository:

- `prisma/schema.prisma`
- `prisma/migrations/20260623133000_add_fund_products_catalogues/migration.sql`

Documentation repository:

- `docs/modules/fund/implementation/2026-06-23-phase-1-slice-1d-products-catalogues-confirmation.md`

## Prisma And Schema Changes

Added enums:

- `FundProductStatus`
- `FundCatalogueStatus`

Both enums live in the `fund` schema and currently support:

- `DRAFT`
- `ACTIVE`
- `ARCHIVED`

Added models:

- `FundProduct`
- `FundCatalogue`
- `FundCatalogueProduct`

Updated existing models:

- `Organization` now has relations to FUND Products, Catalogues and Catalogue/Product membership.
- `FundProductWorkflowClass` now has a relation to Products that use it.

## Migration Path And SQL Summary

Migration path:

```text
prisma/migrations/20260623133000_add_fund_products_catalogues/migration.sql
```

SQL summary:

- creates `fund.FundProductStatus`;
- creates `fund.FundCatalogueStatus`;
- creates `fund.fund_products`;
- creates `fund.fund_catalogues`;
- creates `fund.fund_catalogue_products`;
- adds tenant-scoped unique indexes for Product `code` and `slug`;
- adds tenant-scoped unique indexes for Catalogue `code` and `slug`;
- adds status, workflow-class and sort-order indexes;
- adds foreign keys to `public.organizations`;
- adds Product-to-Workflow-Class foreign key with `ON DELETE RESTRICT`;
- adds composite same-tenant Catalogue/Product membership foreign keys.

Confirmation:

- `db:push` was not used.
- Seed commands were not used.
- Reset commands were not used.

## Tenant Ownership Strategy

All new tenant-owned tables include required `organizationId`:

- `FundProduct.organizationId`
- `FundCatalogue.organizationId`
- `FundCatalogueProduct.organizationId`

Product and Catalogue uniqueness is tenant-scoped:

- Product `code` is unique per tenant.
- Product `slug` is unique per tenant.
- Catalogue `code` is unique per tenant.
- Catalogue `slug` is unique per tenant.

The join table includes `organizationId` and uses composite foreign keys:

- `FundCatalogueProduct(organizationId, catalogueId)` references `FundCatalogue(organizationId, id)`.
- `FundCatalogueProduct(organizationId, productId)` references `FundProduct(organizationId, id)`.

This prevents cross-tenant catalogue/product joins at the database level.

## Workflow Class Relationship

`FundProduct.workflowClassId` is required.

`FundProduct.workflowClassId` references `FundProductWorkflowClass.id`.

The foreign key uses `ON DELETE RESTRICT`, because Product Workflow Classes are protected platform reference records and Products must not be orphaned from their operational workflow class.

## Product And Catalogue Status Strategy

Products and Catalogues both support:

- `DRAFT`
- `ACTIVE`
- `ARCHIVED`

Default status:

- Products default to `DRAFT`.
- Catalogues default to `DRAFT`.

Archive strategy:

- records are archived by status, not hard-deleted;
- archive metadata fields are available:
  - `archivedAt`
  - `archivedById`
  - `archivedReason`

This preserves future historical meaning for Projects, Stores and Orders once those slices exist.

## Pricing, VAT And Currency Strategy

`FundProduct` includes:

- `unitPriceNet Decimal? @db.Decimal(10, 2)`
- `vatRate Decimal @default(20) @db.Decimal(5, 2)`
- `currency String @default("GBP")`
- `pricingNotes String?`

Notes:

- price is nullable at schema level so draft Products can be created before final pricing;
- VAT follows the existing decimal pattern used elsewhere in the repo;
- gross price calculation is deferred to future services/UI;
- no Stripe, GoCardless, payment-provider, discount, bundle or commission fields were added.

## Media And Document Strategy

Direct `MediaFile` relations were deliberately deferred.

Reason:

- existing `MediaFile` is a public tenant-owned model;
- adding direct Product/Catalogue media relations would require broad public `MediaFile` back-relations;
- no Product/Catalogue service layer exists in this slice to validate same-tenant media ownership;
- the user explicitly requested stopping rather than forcing broad or ambiguous MediaFile changes.

For now:

- Product image/document strategy remains documented for a later asset slice;
- no product image field was added;
- no catalogue image field was added;
- no asset table was added.

Recommended future slice:

- `FundProductAsset` or a carefully validated direct MediaFile integration, with service-layer same-tenant checks.

## Deliberately Not Implemented

This slice did not implement:

- Projects;
- Events;
- Stores;
- Orders;
- payments;
- commissions;
- dashboards;
- UI pages;
- tRPC routers;
- services;
- sharing or marketplace logic;
- SeasonPro integration;
- direct MediaFile relations;
- product asset library;
- product/gallery uploads;
- AMOW hard-coding.

## Checks Run And Results

Passed:

- `npx prisma validate`
- `npm run db:generate`
- `npm run type-check`
- `npm run verify`

Notes:

- `npm run verify` initially failed inside the sandbox because `tsx` could not create its IPC pipe under `/var/folders/...`.
- The same verify command passed when rerun with the required local execution permission.

Lint was not rerun for this slice. The previous lint run for Slice 1C failed on existing unrelated repo-wide UI lint issues, not on FUND files.

## Manual Verification Checklist

Before promotion, verify:

- migration exists in source control;
- migration creates only Product/Catalogue schema objects;
- `FundProductStatus` enum exists;
- `FundCatalogueStatus` enum exists;
- `FundProduct` includes required `organizationId`;
- `FundCatalogue` includes required `organizationId`;
- `FundCatalogueProduct` includes required `organizationId`;
- `FundProduct.workflowClassId` is required;
- Product-to-Workflow-Class deletion is restricted;
- Product `code` and `slug` are unique per tenant;
- Catalogue `code` and `slug` are unique per tenant;
- Catalogue/Product membership cannot join records across tenants;
- media/document relations are absent by design;
- no routers/UI/services were added;
- `db:push` was not used;
- seed/reset commands were not used;
- Prisma validation passes;
- type-check passes;
- verify passes.

## Risks And Follow-Up Issues

Overall risk: Medium-low.

Risks:

- This is the first tenant-owned FUND operational schema.
- Future services must preserve tenant scoping in every Product/Catalogue query.
- Product activation rules are not enforced until services exist.
- Media/image/document fields are deferred and need a later clear design.
- RLS policies are not added in this slice and should be planned before deployed tenant data is relied upon.

Mitigations:

- required `organizationId` on all new tenant-owned models;
- composite same-tenant join foreign keys;
- no router/service/UI surface yet;
- no sharing or marketplace behaviour yet;
- archive-first status model;
- checks passed.

## Recommended Next Slice

Recommended next slice:

```text
Phase 1 Slice 1E - Projects as Mandatory Operational Entities schema proposal
```

Before implementation, confirm:

- Project number strategy;
- organiser model strategy;
- Project/Product selection shape;
- whether Products can be selected directly or only through Catalogues;
- RLS policy timing for FUND tenant-owned tables.

## Suggested Next Codex Prompt

```text
Proceed with FUND Phase 1 Slice 1E planning only: Projects as mandatory operational entities.

Do not edit code.
Do not edit Prisma schema.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.
Do not create routers, services, UI pages or dashboards.

Read the active FUND docs plus Slice 1C and Slice 1D confirmation documents.

Produce a schema design proposal covering FundProject, Project/Product relationships, project number strategy, organiser model options, lifecycle-state link, optional Event readiness without implementing Event yet, tenant safety, audit events, indexes, migration risks and open decisions before implementation.
```
