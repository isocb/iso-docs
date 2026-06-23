# FUND Phase 1 Slice 1D - Tenant-Owned Products and Catalogues Schema Proposal

Date: 2026-06-23

Status: Proposal only

This document proposes the schema design for FUND Phase 1 Slice 1D. It does not authorise code, Prisma schema, migration, router, service, UI, dashboard, seed, reset or `db:push` work.

Canonical inputs:

- `01-fund-module-brief.md`
- `02-fund-architecture-principles.md`
- `03-fund-functional-specification.md`
- `04-fund-phase-1-implementation-plan.md`
- `05-fund-open-questions.md`
- `Planning/2026-06-23-fund-phase-1-slice-1b-schema-design-proposal.md`
- `Planning/2026-06-23-fund-phase-1-slice-1c-product-workflow-classes-proposal.md`
- `implementation/2026-06-23-phase-1-slice-1c-product-workflow-classes-confirmation.md`

## Slice Goal

Slice 1D should introduce tenant-owned FUND Products and Catalogues.

This slice should prove:

- Products belong to tenants.
- Products must reference a Product Workflow Class.
- FUND itself does not own products.
- Catalogues belong to tenants.
- Catalogues group Products from the same tenant.
- Product and Catalogue archival preserves historical meaning.

This slice should not introduce Projects, Events, Stores, Orders, payment logic, commissions, production batching or dashboards.

## Current Repository Context

Slice 1C has implemented:

- `fund` Prisma schema registration.
- `FundProductWorkflowClass`.
- platform-level protected defaults A1, A2, B and C.
- read-only `fund.workflowClasses.list` tRPC endpoint.

Relevant current repo conventions:

- tenant-owned tables use required `organizationId`;
- module tables live in module schemas where appropriate;
- money fields use `Decimal @db.Decimal(10, 2)`;
- VAT/rate fields use `Decimal @db.Decimal(5, 2)`;
- currency fields commonly default to `GBP`;
- tenant-owned files use core `MediaFile` records scoped by `organizationId`;
- significant mutations should write `AuditLog` records.

## Recommended Entities

Slice 1D should add:

- `FundProduct`
- `FundCatalogue`
- `FundCatalogueProduct`
- `FundProductStatus` enum
- `FundCatalogueStatus` enum

The models should live in the `fund` schema.

## 1. FundProduct Model

Recommended Prisma model:

```prisma
enum FundProductStatus {
  DRAFT
  ACTIVE
  ARCHIVED

  @@schema("fund")
}

model FundProduct {
  id             String @id @default(uuid())
  organizationId String @map("organization_id")

  workflowClassId String                   @map("workflow_class_id")
  workflowClass   FundProductWorkflowClass @relation(fields: [workflowClassId], references: [id], onDelete: Restrict)

  code        String
  name        String
  slug        String
  description String? @db.Text
  shortDescription String? @map("short_description")

  status     FundProductStatus @default(DRAFT)
  isFeatured Boolean           @default(false) @map("is_featured")
  sortOrder  Int               @default(0) @map("sort_order")

  unitPriceNet   Decimal? @map("unit_price_net") @db.Decimal(10, 2)
  vatRate        Decimal  @default(20) @map("vat_rate") @db.Decimal(5, 2)
  currency       String   @default("GBP")
  pricingNotes   String?  @map("pricing_notes") @db.Text

  primaryImageMediaFileId String?    @map("primary_image_media_file_id")
  primaryImageMediaFile   MediaFile? @relation("FundProductPrimaryImage", fields: [primaryImageMediaFileId], references: [id], onDelete: SetNull)

  infoDocumentMediaFileId String?    @map("info_document_media_file_id")
  infoDocumentMediaFile   MediaFile? @relation("FundProductInfoDocument", fields: [infoDocumentMediaFileId], references: [id], onDelete: SetNull)

  productionNotes String? @map("production_notes") @db.Text
  metadata        Json    @default("{}")

  archivedAt     DateTime? @map("archived_at")
  archivedById   String?   @map("archived_by_id")
  archivedReason String?   @map("archived_reason") @db.Text

  createdById String? @map("created_by_id")
  updatedById String? @map("updated_by_id")
  createdAt   DateTime @default(now()) @map("created_at")
  updatedAt   DateTime @updatedAt @map("updated_at")

  organization      Organization           @relation(fields: [organizationId], references: [id], onDelete: Cascade)
  catalogueProducts FundCatalogueProduct[]

  @@unique([organizationId, code])
  @@unique([organizationId, slug])
  @@index([organizationId, status])
  @@index([organizationId, workflowClassId])
  @@index([organizationId, sortOrder])
  @@index([primaryImageMediaFileId])
  @@index([infoDocumentMediaFileId])
  @@map("fund_products")
  @@schema("fund")
}
```

### Product Field Notes

`organizationId` is required because Products are tenant-owned.

`workflowClassId` is required because every Product must declare operational behaviour through A1, A2, B or C.

`code` should be tenant-unique and human-operational, for example `AMOW-XMAS-MUG-001`.

`slug` should be tenant-unique and URL-safe, but Slice 1D does not need public product pages.

`unitPriceNet` is optional at schema level so draft Products can exist before final pricing. A later service/UI rule can require price before activation.

`status` is the main lifecycle control for product availability.

`metadata` gives a safe place for early non-critical product attributes while avoiding premature over-modelling.

## 2. FundCatalogue Model

Recommended Prisma model:

```prisma
enum FundCatalogueStatus {
  DRAFT
  ACTIVE
  ARCHIVED

  @@schema("fund")
}

model FundCatalogue {
  id             String @id @default(uuid())
  organizationId String @map("organization_id")

  code        String
  name        String
  slug        String
  description String? @db.Text

  status     FundCatalogueStatus @default(DRAFT)
  isFeatured Boolean             @default(false) @map("is_featured")
  sortOrder  Int                 @default(0) @map("sort_order")

  coverImageMediaFileId String?    @map("cover_image_media_file_id")
  coverImageMediaFile   MediaFile? @relation("FundCatalogueCoverImage", fields: [coverImageMediaFileId], references: [id], onDelete: SetNull)

  metadata Json @default("{}")

  archivedAt     DateTime? @map("archived_at")
  archivedById   String?   @map("archived_by_id")
  archivedReason String?   @map("archived_reason") @db.Text

  createdById String? @map("created_by_id")
  updatedById String? @map("updated_by_id")
  createdAt   DateTime @default(now()) @map("created_at")
  updatedAt   DateTime @updatedAt @map("updated_at")

  organization      Organization           @relation(fields: [organizationId], references: [id], onDelete: Cascade)
  catalogueProducts FundCatalogueProduct[]

  @@unique([organizationId, code])
  @@unique([organizationId, slug])
  @@index([organizationId, status])
  @@index([organizationId, sortOrder])
  @@index([coverImageMediaFileId])
  @@map("fund_catalogues")
  @@schema("fund")
}
```

### Catalogue Field Notes

Catalogues are tenant-owned groupings of tenant-owned Products.

Examples:

- AMOW Christmas Catalogue 2026
- AMOW Leavers Catalogue
- AMOW Personalised Products
- Future Producer Sportswear Catalogue

AMOW is an initial product provider context, but should not be hard-coded into schema, enum values, migrations or services.

## 3. FundCatalogueProduct Join Model

Recommended Prisma model:

```prisma
model FundCatalogueProduct {
  id             String @id @default(uuid())
  organizationId String @map("organization_id")

  catalogueId String        @map("catalogue_id")
  catalogue   FundCatalogue @relation(fields: [catalogueId], references: [id], onDelete: Cascade)

  productId String      @map("product_id")
  product   FundProduct @relation(fields: [productId], references: [id], onDelete: Restrict)

  sortOrder Int     @default(0) @map("sort_order")
  isActive  Boolean @default(true) @map("is_active")

  addedById String?  @map("added_by_id")
  addedAt   DateTime @default(now()) @map("added_at")
  updatedAt DateTime @updatedAt @map("updated_at")

  organization Organization @relation(fields: [organizationId], references: [id], onDelete: Cascade)

  @@unique([catalogueId, productId])
  @@index([organizationId])
  @@index([organizationId, catalogueId, sortOrder])
  @@index([organizationId, productId])
  @@map("fund_catalogue_products")
  @@schema("fund")
}
```

### Join Model Notes

The join model should include `organizationId` even though it can be inferred through Product and Catalogue. This keeps tenant filtering simple, fast and consistent with IsoStack conventions.

Application/service validation must ensure:

- the Catalogue belongs to the current `organizationId`;
- the Product belongs to the current `organizationId`;
- the join row uses the same `organizationId`;
- cross-tenant Product/Catalogue joins are rejected.

Database-level composite foreign keys could enforce same-tenant joins more strongly, but would add complexity. For Slice 1D, application-level validation plus tenant-scoped queries is acceptable if documented and tested.

## 4. Relationship To FundProductWorkflowClass

`FundProduct.workflowClassId` should reference `FundProductWorkflowClass.id`.

This relation should use `onDelete: Restrict`.

Reasoning:

- Workflow Classes are protected platform reference data.
- Products require a workflow class.
- Existing Products should prevent deletion of a referenced workflow class.
- Slice 1C did not expose delete/update endpoints for workflow classes.

Recommended future include shape:

```ts
include: {
  workflowClass: true,
}
```

This lets Product list/detail views show whether the Product is A1, A2, B or C.

## 5. Tenant Ownership Using organizationId

`FundProduct`, `FundCatalogue` and `FundCatalogueProduct` must all include required `organizationId`.

Tenant ownership rules:

- Products belong to exactly one tenant.
- Catalogues belong to exactly one tenant.
- Catalogue membership belongs to exactly one tenant.
- A Product may appear in many Catalogues owned by the same tenant.
- A Catalogue may contain many Products owned by the same tenant.
- FUND itself does not own Product records.
- Platform-level workflow classes do not make Products platform-owned.

All read/write paths in later slices must:

- resolve the current user's `organizationId`;
- filter by `organizationId`;
- verify referenced Product/Catalogue IDs belong to the same tenant;
- reject cross-tenant IDs;
- write audit records for significant mutations.

## 6. Product Status And Archival Strategy

Recommended Product statuses:

- `DRAFT` - editable setup state, not ready for selection.
- `ACTIVE` - available for use in Catalogues and later Projects.
- `ARCHIVED` - retired from new use but preserved for historical context.

Recommended rules:

- Product creation defaults to `DRAFT`.
- Product activation should eventually require a workflow class, name, code, slug and valid pricing where pricing is required.
- Archiving should set `status = ARCHIVED`, `archivedAt`, `archivedById` and optional `archivedReason`.
- Archived Products should not be hard-deleted.
- Archived Products should remain readable where historical Projects, Stores or Orders later reference them.
- Archived Products should not be selectable for new Project setup unless an explicit override is later approved.

Do not add physical deletion in Slice 1D unless there is no historical relationship. Even then, prefer archive-first.

## 7. Catalogue Status And Archival Strategy

Recommended Catalogue statuses:

- `DRAFT` - editable setup state.
- `ACTIVE` - available for selection by later Events/Projects.
- `ARCHIVED` - retired from new use but preserved for historical context.

Recommended rules:

- Catalogue creation defaults to `DRAFT`.
- Active Catalogues may contain active Products.
- Draft Catalogues may contain draft or active Products while being prepared.
- Archived Catalogues remain readable.
- Archiving a Catalogue should not archive its Products.
- Archiving a Product should not archive its Catalogues, but future list views should make archived Product membership visible.
- Catalogue membership rows should generally remain for historical meaning.

## 8. Product Price, Currency And VAT Fields

Recommended Slice 1D product pricing fields:

```prisma
unitPriceNet Decimal? @map("unit_price_net") @db.Decimal(10, 2)
vatRate      Decimal  @default(20) @map("vat_rate") @db.Decimal(5, 2)
currency     String   @default("GBP")
pricingNotes String?  @map("pricing_notes") @db.Text
```

Design notes:

- Store the net unit price on Product for Phase 1.
- Store VAT rate separately, using the same decimal pattern as Pulse quotes.
- Gross price can be calculated in service/UI later.
- Currency should default to `GBP` but remain explicit per Product.
- `unitPriceNet` is nullable so drafts can be created before final pricing.
- Do not add Stripe/GoCardless/payment provider IDs in Slice 1D.
- Do not add variants, tier pricing, bundles, discounts or commission rates in Slice 1D.

Open question:

- Should Product activation require `unitPriceNet`, or can some Product workflows be quote-based/no-price until Project setup?

## 9. Product Image And Document Strategy For Phase 1

Use existing tenant-owned `MediaFile` records rather than creating a new file table in Slice 1D.

Recommended Product fields:

- `primaryImageMediaFileId`
- `infoDocumentMediaFileId`

Recommended Catalogue field:

- `coverImageMediaFileId`

Service-level validation must confirm that any referenced `MediaFile` belongs to the same `organizationId`.

Phase 1 should not build:

- a full Product asset library;
- artwork upload workflows;
- template PDF generation;
- proofing workflows;
- production file storage;
- multi-image gallery;
- public download logic;
- AI image/document processing.

Those belong to later artwork, template and production slices.

## 10. Product Sharing Across Tenants

Do not implement Product sharing across tenants in Slice 1D.

Slice 1D should only allow:

- Tenant A sees Tenant A Products.
- Tenant B sees Tenant B Products.
- Tenant A Catalogues contain Tenant A Products only.
- Tenant B Catalogues contain Tenant B Products only.

This avoids cross-tenant leakage while the core Product/Catalogue model is still being proven.

## 11. Future AMOW-Owned Product Exposure

AMOW-owned Products may later be exposed to other tenants, but this should be deferred.

Possible future models:

1. Copy Product into consuming tenant.
2. Create controlled Product sharing grants.
3. Create producer marketplace/catalogue publication model.
4. Create Project-level producer relationship with explicit permission boundaries.

Recommended direction for later review:

- Keep AMOW as a tenant/producer, not a hard-coded platform owner.
- Do not let consuming tenants directly mutate AMOW-owned Products.
- Require explicit grants or copies before cross-tenant exposure.
- Audit every grant, copy or marketplace publication.

Do not build this in Slice 1D.

## 12. Tenant-Safety Implications

Primary risks:

- Product from Tenant A is accidentally added to Tenant B Catalogue.
- Product media from Tenant A is displayed to Tenant B.
- Future AMOW sharing is implemented as direct cross-tenant reads without clear grants.
- Archived Products disappear from historical contexts.
- FUND starts acting as a global Product owner.

Mitigations:

- required `organizationId` on Product, Catalogue and join model;
- tenant-scoped unique constraints;
- tenant-scoped list/detail queries;
- same-tenant validation for workflow operations;
- same-tenant validation for `MediaFile` references;
- no sharing model in Slice 1D;
- archive-first strategy;
- audit logs for significant mutations.

RLS note:

- These are tenant-owned operational tables and should be planned for RLS policy coverage.
- Application-level tenant filters are still required regardless of RLS.

## 13. Audit Events

Recommended audit actions for later implementation:

Products:

- `FUND_PRODUCT_CREATED`
- `FUND_PRODUCT_UPDATED`
- `FUND_PRODUCT_ACTIVATED`
- `FUND_PRODUCT_ARCHIVED`
- `FUND_PRODUCT_RESTORED`
- `FUND_PRODUCT_WORKFLOW_CLASS_CHANGED`
- `FUND_PRODUCT_MEDIA_CHANGED`
- `FUND_PRODUCT_PRICE_CHANGED`

Catalogues:

- `FUND_CATALOGUE_CREATED`
- `FUND_CATALOGUE_UPDATED`
- `FUND_CATALOGUE_ACTIVATED`
- `FUND_CATALOGUE_ARCHIVED`
- `FUND_CATALOGUE_RESTORED`
- `FUND_CATALOGUE_PRODUCT_ADDED`
- `FUND_CATALOGUE_PRODUCT_REMOVED`
- `FUND_CATALOGUE_PRODUCT_REORDERED`

Audit metadata should include:

- entity id;
- entity code/slug where useful;
- old status and new status;
- workflow class id/code where changed;
- price/currency/VAT fields where changed;
- media file id where changed;
- affected Product/Catalogue ids for join changes.

## 14. Indexes And Uniqueness Constraints

Recommended Product constraints:

```prisma
@@unique([organizationId, code])
@@unique([organizationId, slug])
@@index([organizationId, status])
@@index([organizationId, workflowClassId])
@@index([organizationId, sortOrder])
@@index([primaryImageMediaFileId])
@@index([infoDocumentMediaFileId])
```

Recommended Catalogue constraints:

```prisma
@@unique([organizationId, code])
@@unique([organizationId, slug])
@@index([organizationId, status])
@@index([organizationId, sortOrder])
@@index([coverImageMediaFileId])
```

Recommended join constraints:

```prisma
@@unique([catalogueId, productId])
@@index([organizationId])
@@index([organizationId, catalogueId, sortOrder])
@@index([organizationId, productId])
```

Optional future hardening:

- add composite unique constraints that include `organizationId` and id pairs;
- use composite foreign keys to enforce same-tenant joins at database level;
- add partial unique constraints for active-only slugs if Postgres partial indexes become desirable.

For Slice 1D, keep constraints straightforward and service validation explicit.

## 15. Migration Risks

Overall risk: Medium-low.

Risks:

- Adding tenant-owned FUND models introduces the first operational FUND data.
- Product/Catalogue relations to `Organization` and `MediaFile` require relation fields on existing public models.
- Money/VAT fields need careful decimal handling in future tRPC inputs.
- Join model could allow cross-tenant joins if services are careless.
- Future sharing/marketplace needs could tempt premature cross-tenant modelling.

Mitigations:

- use required `organizationId` on all tenant-owned tables;
- validate all referenced IDs belong to the current tenant;
- avoid sharing in Slice 1D;
- use archive-first rather than delete-first behaviour;
- keep Stripe/payment/commission fields out of Product;
- use existing `MediaFile` conventions;
- run Prisma validate, generate, type-check and verify after implementation.

## 16. Open Decisions Before Implementation

Resolve or explicitly defer these before implementation:

1. Should `unitPriceNet` be required for `ACTIVE` Products?
2. Should Product `code` be user-entered, generated or both?
3. Should Product `slug` be user-visible in Phase 1, or reserved for later public Store URLs?
4. Should Product images/documents use direct `MediaFile` relations only, or should a future `FundProductAsset` model be planned now and deferred?
5. Should archived Products be restorable in Slice 1D, or should restore be deferred?
6. Should Catalogues allow draft Products while the Catalogue is active?
7. Should `FundCatalogueProduct` support per-catalogue display names or override pricing later?
8. Should VAT default come from tenant settings if available, or stay as schema default `20` for now?
9. Should Product status include `RETIRED` separately from `ARCHIVED`, or is `ARCHIVED` sufficient?
10. Should there be a stronger database-level same-tenant join constraint in Slice 1D?

Recommended defaults if not otherwise decided:

- allow nullable price in draft;
- require price before activation in service validation;
- keep `DRAFT`, `ACTIVE`, `ARCHIVED` only;
- do not build restore in first implementation unless cheap and audited;
- keep same-tenant enforcement in service validation for Slice 1D.

## 17. Recommended Slice 1D Implementation Scope

Recommended implementation scope after review:

1. Add `FundProductStatus` enum.
2. Add `FundCatalogueStatus` enum.
3. Add `FundProduct`.
4. Add `FundCatalogue`.
5. Add `FundCatalogueProduct`.
6. Add required relation fields to `Organization`.
7. Add required relation fields to `MediaFile` if direct media relations are used.
8. Create migration only.
9. Add read-only or minimal internal tRPC list/get only if explicitly approved for this slice.
10. Run Prisma validation.
11. Run Prisma client generation.
12. Run type-check.
13. Run existing verify command.
14. Create implementation confirmation document.

Recommended strict scope:

- schema and migration only, unless read-only router access is explicitly requested;
- no UI;
- no dashboard;
- no Projects;
- no Events;
- no Stores;
- no Orders;
- no payment/commission logic;
- no sharing model.

## 18. Confirmation Document Requirements After Implementation

After implementation, create:

```text
isodocs/docs/modules/fund/implementation/2026-06-23-phase-1-slice-1d-products-catalogues-confirmation.md
```

The confirmation document should include:

1. Slice name:
   - `Phase 1 Slice 1D - Tenant-Owned Products and Catalogues`
2. Date.
3. Implementation summary.
4. Files changed.
5. Prisma/schema changes made.
6. Migration created:
   - migration name/path;
   - summary of SQL;
   - confirmation that `db:push` was not used;
   - confirmation that seed/reset commands were not used.
7. Models/enums created.
8. Tenant ownership strategy.
9. Workflow class relationship.
10. Product/Catalogue status strategy.
11. Pricing/VAT/currency strategy.
12. Media/document strategy.
13. What was deliberately not implemented.
14. Checks run and results.
15. Manual verification checklist.
16. Risks or follow-up issues.
17. Recommended next slice.
18. Suggested next Codex prompt.

## Manual Verification Checklist For Implementation

When implementation is approved, verify:

- Prisma schema validates.
- Migration creates only the intended enums/tables/indexes.
- Product requires `organizationId`.
- Product requires `workflowClassId`.
- Product can reference A1, A2, B or C.
- Product cannot reference a missing workflow class.
- Catalogue requires `organizationId`.
- CatalogueProduct requires `organizationId`.
- Same-tenant Product/Catalogue join validation exists if services are added.
- Product and Catalogue codes are unique per tenant.
- Product and Catalogue slugs are unique per tenant.
- Media references are tenant-validated if services are added.
- `db:push` was not used.
- seed/reset commands were not used.
- Type-check passes.
- Existing verify command passes or any failure is documented.

## Recommended Next Codex Prompt

```text
Proceed with FUND Phase 1 Slice 1D implementation for Tenant-Owned Products and Catalogues only.

Use:
- isodocs/docs/modules/fund/Planning/2026-06-23-fund-phase-1-slice-1d-products-catalogues-schema-proposal.md
- active FUND docs
- Slice 1C implementation confirmation

You may edit Prisma schema and create a migration.

Do not run db:push.
Do not run seed/reset commands.
Do not create Projects, Events, Stores, Orders, commerce, commissions, dashboards, UI pages, sharing/marketplace logic or SeasonPro integration.

Implement only:
- FundProductStatus
- FundCatalogueStatus
- FundProduct
- FundCatalogue
- FundCatalogueProduct
- required relations/indexes
- migration
- implementation confirmation documentation

Run Prisma validation, Prisma client generation, type-checking and the existing verify command.
```
