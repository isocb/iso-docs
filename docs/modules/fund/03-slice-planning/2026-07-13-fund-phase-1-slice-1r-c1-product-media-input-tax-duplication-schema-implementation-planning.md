# FUND Phase 1 Slice 1R-C1 - Product Media/Input/Tax/Duplication Schema Implementation Planning

Date: 2026-07-13

Status: Accepted / implemented / reviewed as passed

Parent plan:

`docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c-fund-store-input-schema-foundation-planning.md`

Implementation and review evidence:

- `docs/modules/fund/04-implementation-confirmations/2026-07-13-phase-1-slice-1r-c1-product-media-input-tax-duplication-schema-implementation-confirmation.md`
- `docs/modules/fund/05-review-and-test/2026-07-13-phase-1-slice-1r-c1-r1-product-media-input-tax-duplication-schema-review-and-test.md`

## 1. Goal

Define one bounded, additive FUND schema migration for:

- Product tax classification and price-entry basis;
- matching Project Product commercial snapshots;
- Product configuration revision and copy provenance;
- ordered Product media associations;
- typed Product and Project Product input definitions;
- input choices and choice-linked Product imagery.

This plan did not authorise Prisma, migration, seed, service, API or UI changes before
acceptance. Its acceptance resolution and bounded implementation handoff are recorded
below.

## 2. Hard Boundary

`1R-C1` may extend only existing FUND Product configuration records and add their directly
owned child records.

It must not add:

- Project Store or Store Product records;
- checkout sessions, baskets, Orders or Order lines;
- payments, refunds, pro-forma invoices or Stripe;
- typed FUND Commerce Order extensions;
- production assets or upload/storage services;
- Client branding, Project delivery profiles or Event media;
- commission policies or calculation;
- Product-duplication execution services.

`COMMERCE-A1` is complete through review/test. This plan does not reopen A1 and does not
authorise `COMMERCE-A2` or any other Commerce work.

## 3. Existing Data That Must Be Preserved

Current schema evidence:

- `FundProduct.unitPriceNet` is `Decimal(10,2)` and remains tax-exclusive legacy data;
- `FundProduct.vatRate` is `Decimal(5,2)` and cannot distinguish zero-rated from exempt;
- `FundProduct.currency` contains the Product currency;
- `FundProjectProduct` already snapshots Product code, name, workflow class, net price, VAT
  rate and currency;
- `FundProjectProduct` is unique by tenant/Project/Product;
- Product code and slug are tenant-unique;
- `FundProjectProduct` does not currently expose a composite `(organizationId, id)` unique
  relation key, although the proposed Project Product-owned input relation requires one;
- `MediaFile` is in the `public` schema and carries `organizationId`, but does not expose a
  composite `(organizationId, id)` unique relation key;
- the reviewed `COMMERCE-A1` schema now exists, containing only the Commerce namespace,
  Seller Profile and four stable enums; checkout, Orders and payments do not exist.

No migration may reinterpret these values or create Store/Order records.

## 4. Accepted Physical Direction

### 4.1 Enums

Add FUND-scoped enums:

```text
FundProductTaxTreatment
- UNCLASSIFIED
- STANDARD
- REDUCED
- ZERO_RATED
- EXEMPT

FundPriceEntryBasis
- TAX_EXCLUSIVE
- TAX_INCLUSIVE

FundProductMediaRole
- PRIMARY
- GALLERY

FundOrderInputOwnerScope
- PRODUCT
- PROJECT_PRODUCT

FundOrderInputKind
- PRODUCT_OPTION
- CUSTOM_ORDER_FIELD
- PRODUCTION_INPUT
- FILE_UPLOAD

FundOrderInputControlType
- SHORT_TEXT
- LONG_TEXT
- NUMBER
- DATE
- YES_NO
- SINGLE_SELECT
- MULTI_SELECT
- COLOUR_SWATCH
- FILE_UPLOAD
- EMAIL
- PHONE
```

`UNCLASSIFIED` is a safe migration state, not a checkout tax treatment. Later Store
readiness must reject it. It prevents the migration from guessing whether historic
zero/non-standard rates are standard, reduced, zero-rated or exempt.

The FUND enums are deliberately FUND-owned even where values overlap the Commerce A1
enums. They describe editable source-Product configuration and Project Product snapshots;
Commerce enums describe resolved generic commercial snapshots. No cross-schema enum reuse
or foreign key is introduced. A later FUND-to-Commerce integration must map the overlapping
values explicitly, and must reject `UNCLASSIFIED` because it has no Commerce equivalent.

### 4.2 `FundProduct` Additions

Add:

```text
taxTreatment         FundProductTaxTreatment @default(UNCLASSIFIED)
priceEntryBasis      FundPriceEntryBasis      @default(TAX_EXCLUSIVE)
copiedFromProductId  String?
copiedFromOrganizationId String?
configurationRevision Int                     @default(1)
```

Relation rules:

- `copiedFromProductId` and the relation-supporting `copiedFromOrganizationId` are both
  null or both set;
- a database check requires `copiedFromOrganizationId = organizationId` whenever the copy
  source is set;
- the two nullable source fields form the composite same-tenant self-relation;
- source deletion uses `SetNull` on both nullable source fields, preserving the copied
  Product;
- copied Products never inherit later source changes;
- `configurationRevision` must be positive;
- this slice adds the field but no service-side increment behaviour.

The self-relation must reference the existing `(organizationId, id)` Product key and
receive an explicit short relation/index/check name. A composite relation using the copied
Product's required `organizationId` directly is rejected: ordinary Prisma/PostgreSQL
`SetNull` would attempt to null a required tenant field. The nullable relation-support field
is therefore intentional, not a second tenant owner.

`unitPriceNet` remains a normalized tax-exclusive Decimal amount regardless of
`priceEntryBasis`. In this slice, `priceEntryBasis` records the C1 entry/display convention
only; it does not change the stored amount's meaning. A later accepted pricing service must
normalize tax-inclusive entry into `unitPriceNet`, apply the seller rounding policy and
preserve resolved net/tax/gross evidence before Store publication or Commerce submission.
No service in `1R-C1` may set `TAX_INCLUSIVE`.

### 4.3 `FundProjectProduct` Snapshot Additions

Add:

```text
taxTreatmentSnapshot    FundProductTaxTreatment @default(UNCLASSIFIED)
priceEntryBasisSnapshot FundPriceEntryBasis      @default(TAX_EXCLUSIVE)
```

These fields close the review gap in which Project Product price/VAT snapshots could still
depend on a later Product tax edit.

The migration must not refresh any existing price, VAT rate or currency snapshot from the
current Product.

Add `@@unique([organizationId, id])` to `FundProjectProduct`, with an explicit short mapped
name, before creating Project Product-owned input definitions. The existing primary key is
not sufficient for a composite same-tenant foreign key.

The snapshot fields remain `UNCLASSIFIED`/`TAX_EXCLUSIVE` for existing rows and for rows
created by the unchanged selection service. They are safe placeholders, not evidence that
tax configuration has been propagated. The later accepted selection/configuration service
must copy reviewed values atomically before Store readiness can pass.

### 4.4 `FundProductMedia`

Planned fields:

- `id`, `organizationId`, `productId`, `mediaFileId`;
- `role`, `altText`, `caption`, `sortOrder`, `isActive`;
- `createdById`, `updatedById`, `createdAt`, `updatedAt`.

Constraints:

- same-tenant Product relation through `(organizationId, productId)`;
- direct tenant relation to `Organization`, following existing FUND tenant-owned model
  convention;
- unique Product/media association within a tenant;
- non-negative sort order;
- one active `PRIMARY` row per Product, enforced by reviewed partial unique SQL because
  Prisma cannot express the conditional uniqueness directly;
- Product deletion cascades only while no later restrictive Store/history relation exists;
- MediaFile deletion is restricted while associated;
- the database relation to `MediaFile` uses `mediaFileId -> MediaFile.id` with restrictive
  deletion;
- service validation must verify MediaFile tenant ownership before insert/update because
  current `MediaFile` lacks a composite tenant/id relation key. `1R-C1` adds no write
  service, so no application path may create these associations until that validation is
  implemented and tested.

No media rows are created automatically for historic Products.

### 4.5 `FundOrderInputDefinition`

Use one definition table with an explicit owner scope and nullable owner foreign keys.

Planned fields:

- `id`, `organizationId`, `ownerScope`;
- nullable `productId` and `projectProductId`;
- tenant/owner-stable `code`;
- `label`, `helpText`, `kind`, `controlType`;
- `isRequired`, optional validated `defaultValue` JSON;
- optional validated `validationConfig` JSON;
- `isCustomerVisible`, `isProductionVisible`;
- `sortOrder`, `isActive`, `revision`;
- normal actor/timestamp fields.

Database checks must enforce:

```text
PRODUCT         -> productId is set and projectProductId is null
PROJECT_PRODUCT -> projectProductId is set and productId is null
```

Additional constraints:

- positive revision and non-negative sort order;
- tenant-scoped owner/code uniqueness for each owner type through two reviewed partial
  unique SQL indexes (`PRODUCT` and `PROJECT_PRODUCT`), avoiding nullable-column uniqueness
  ambiguity;
- same-tenant composite foreign keys to Product or Project Product;
- direct tenant relation to `Organization`;
- restrictive owner deletion once definitions are referenced by later immutable Store
  configuration history; the initial migration may use cascade only if the `1R-C3`
  migration explicitly changes it before history exists.

`defaultValue` and `validationConfig` are JSON storage contracts only in this schema slice.
Control-type compatibility and JSON shape are service validation concerns; the migration
must not claim semantic JSON validation that PostgreSQL checks do not implement.

Store Product ownership is not included. `1R-C3` will deliberately extend the check
constraint after the Store Product table exists.

### 4.6 `FundOrderInputChoice`

Planned fields:

- `id`, `organizationId`, `definitionId`;
- stable `code`, `label`;
- `priceModifierMinor` as a signed integer amount;
- optional `displayMetadata` JSON;
- `sortOrder`, `isActive` and normal audit fields.

Constraints:

- same-tenant definition relation;
- unique definition/code;
- non-negative sort order;
- fixed minor-unit modifiers only—no percentage or formula fields.

Use Prisma `Int` / PostgreSQL signed 32-bit integer. Its range of
`-2,147,483,648..2,147,483,647` minor units is more than sufficient for a single Product
option modifier and avoids `BigInt` API serialization. Negative modifiers are permitted;
services must reject a resolved selling price below zero. Percentage and formula modifiers
remain excluded.

### 4.7 `FundOrderInputChoiceMedia`

Planned fields:

- `id`, `organizationId`, `choiceId`, `productMediaId`;
- `sortOrder`, `isPrimaryForChoice`;
- normal audit fields.

Constraints:

- same-tenant choice and Product-media relations;
- unique choice/Product-media association;
- at most one primary media row per choice through reviewed partial unique SQL;
- linked Product media must belong to the Product ultimately owning the definition; this
  cross-path invariant is service-validated and covered by later service tests.

No Product Variant or dependency-graph table is introduced.

### 4.8 Locked Relation And Deletion Contract

All new FUND child models carry `organizationId`, a direct `Organization` relation and an
explicit `@@unique([organizationId, id])` where another new child uses a composite
same-tenant foreign key.

Before immutable Store configuration history exists, deletion behavior is:

- Product -> Product media and Product-owned definitions: `Cascade`;
- Project Product -> Project Product-owned definitions: `Cascade`;
- input definition -> choices: `Cascade`;
- input choice -> choice-media mappings: `Cascade`;
- Product media -> choice-media mappings: `Cascade`;
- MediaFile -> Product media: `Restrict`;
- copied source Product -> both nullable copy-source fields: `SetNull`;
- Organization -> new FUND configuration rows: `Cascade`, consistent with existing FUND
  tenant teardown.

`1R-C3` must replace mutable configuration deletion with restrictive/history-preserving
behavior before immutable Store configuration versions can reference these records.

## 5. Product Duplication Boundary

This schema slice implements provenance only. It does not implement the copy command.

The later atomic Product-duplication service must copy:

- Product/workflow/tax/price fields;
- suitability rows;
- Product-media associations while reusing binary `MediaFile` records;
- Product-owned definitions, choices and choice-media mappings;
- no Project Product-owned definitions;
- no Catalogue memberships unless explicitly selected by C1.

The copied Product starts with its own revision and may diverge immediately. Unique code and
slug generation, transactionality and idempotency belong to that later service plan.

## 6. Migration Plan

Create one named additive migration after implementation-plan acceptance.

Order:

1. Add the new FUND enums.
2. Add the required/defaulted Product and Project Product columns without changing legacy
   commercial columns; use the safe enum defaults as the backfill.
3. Add the Product self-relation index/foreign key, paired-null/same-tenant provenance
   checks and positive-revision check.
4. Add the mapped `(organizationId, id)` unique key to `FundProjectProduct`.
5. Create Product media and input tables in dependency order: Product media, definitions,
   choices, then choice-media mappings. Include direct Organization relations and required
   composite same-tenant keys.
6. Add exactly-one-owner and non-negative/positive checks using reviewed SQL where Prisma
   cannot express them. PostgreSQL `integer` itself enforces the signed `Int` range.
7. Add the two owner-specific partial unique indexes, the active Product-primary partial
   unique index and the choice-primary partial unique index.
8. Run backfill and relation/constraint verification queries inside the retained disposable
   Neon database addressed only by `TEST_DATABASE_URL`, after confirming it is distinct
   from `DATABASE_URL`.
9. Validate Prisma and generated client before any service work is proposed.

Do not combine this migration with `1R-C2`, Store tables or Commerce schema creation.

## 7. Backfill And Data-Review Plan

### 7.1 Automatic Safe Backfill

- every existing Product receives `priceEntryBasis = TAX_EXCLUSIVE`;
- every existing Project Product receives
  `priceEntryBasisSnapshot = TAX_EXCLUSIVE`;
- every existing Product and Project Product tax treatment remains `UNCLASSIFIED`;
- every existing Product receives `configurationRevision = 1`;
- every existing Product receives no copy source;
- no media, input, choice or choice-media rows are inferred.

Until a later accepted Project Product service change explicitly copies reviewed Product
tax settings, newly selected Project Products also remain safely `UNCLASSIFIED`. This is not
sellable readiness and must not be mistaken for a completed commercial snapshot. The schema
migration is compatible with the current selection service because both new snapshot fields
have safe defaults, but it deliberately does not claim end-to-end tax propagation.

### 7.2 Required Verification Queries

Record counts for:

- Products grouped by `vatRate`, currency and new tax treatment;
- Project Products grouped by VAT snapshot and new tax-treatment snapshot;
- zero-rate Products and Project Products requiring C1 classification;
- non-20/non-zero legacy VAT rates requiring C1 classification;
- null legacy Product prices;
- orphan Product/Project Product rows before and after migration;
- duplicate candidate media/input keys—expected to be zero because child tables start
  empty.

Also record that the new child tables contain zero rows immediately after migration and
that adding the `FundProjectProduct` composite key reveals no duplicates.

### 7.3 Later C1 Classification

Changing `UNCLASSIFIED` to a sellable treatment is deliberate business data maintenance,
not migration inference. A later service/UI plan must:

- require an explicit treatment;
- preserve the numeric rate separately;
- update Product configuration revision;
- define whether already-selected Project Products keep or intentionally refresh their
  snapshots;
- audit the actor and previous/new values.

No Store Product may become ready while its effective treatment is `UNCLASSIFIED`.

## 8. Expected Implementation Files

Only after acceptance:

- `prisma/schema.prisma`;
- one new `prisma/migrations/<timestamp>_fund_1r_c1_product_configuration_foundation/`
  migration SQL file;
- narrowly scoped schema/migration test or verification files following repository
  convention;
- one implementation confirmation and one review/test record in the FUND documentation
  folders.

No router, page, component, Stripe, Commerce service or upload implementation file belongs
to this slice.

## 9. Validation Matrix

Required before implementation confirmation:

- `prisma format` produces no unintended schema rewrite;
- `prisma validate` passes;
- Prisma client generation passes;
- migration applies to a fresh disposable database;
- migration applies to a representative pre-`1R-C1` database with legacy Product and
  Project Product rows;
- post-migration record counts match pre-migration counts;
- legacy net price, VAT rate and currency values are byte/value equivalent;
- default price basis and `UNCLASSIFIED` backfills are correct;
- copy provenance rejects half-populated or cross-tenant source fields, and source deletion
  nulls both source fields without changing the copied Product's `organizationId`;
- exactly-one-owner checks reject zero-owner and two-owner input definitions;
- tenant-mismatched Product/Project Product relations are rejected;
- the new `FundProjectProduct (organizationId, id)` key supports the composite owner
  relation;
- duplicate owner/code, Product/media and definition/choice keys are rejected;
- partial primary-media indexes reject two active primaries but allow gallery rows;
- `priceModifierMinor` accepts signed 32-bit boundary values and rejects overflow;
- deletion behaviour matches the accepted foreign-key contract;
- `git diff --check`, type-check and targeted lint/verification commands pass;
- schema/migration diff introduces no Store, Order or payment model and does not add or
  modify any existing `commerce` model.

Database-backed checks must use a disposable/test database and must not mutate shared
development, staging or production data.

The retained Neon `TEST_DATABASE_URL` database is the approved disposable target for this
work. Its connection string remains local and uncommitted. Before migration/reset, repeat
the identity comparison against `DATABASE_URL`; if they are not demonstrably distinct,
stop without changing either database.

The database cannot reject a tenant-mismatched `MediaFile` association until shared
`MediaFile` exposes a composite tenant key. The review must therefore verify that no
application write path is added in this schema-only slice and record this limitation for
the later media service tests. It must not claim database-enforced MediaFile tenant
isolation.

## 10. Failure And Rollback Strategy

- Review generated SQL before applying anywhere persistent.
- Prefer fixing the unapplied migration during development.
- If a disposable migration test fails, recreate only that disposable database.
- Do not publish a destructive down migration that drops existing Product data.
- If an applied environment needs correction, use a reviewed forward migration unless an
  operator-approved restore is safer.
- Record the pre/post counts and migration identifier in the implementation confirmation.

## 11. Explicit Non-Goals

- no `FundProjectStore` or `FundProjectStoreProduct`;
- no configuration-version snapshots;
- no Store publication/readiness service;
- no checkout, Commerce Order or payment schema;
- no file upload or malware scanning;
- no Product copy API/service/UI;
- no Catalogue-level overrides;
- no advanced option dependencies;
- no commission, production or delivery schema.

## 12. Acceptance Criteria

Accept this implementation plan only when:

- all additions are FUND-owned Product configuration foundations;
- `FundProjectProduct` tax and price-basis snapshots are included;
- `UNCLASSIFIED` prevents unsafe tax inference;
- existing commercial values remain unchanged;
- the single-table input owner/check approach is accepted;
- conditional primary-media uniqueness is planned in migration SQL;
- MediaFile tenant validation limitations are explicit;
- Product duplication remains provenance-only in this schema slice;
- migration, backfill, data review and rollback evidence are specified;
- Store, Commerce Order and payment work remains excluded;
- no implementation has occurred before acceptance.

## 13. Acceptance Review Resolution

Review completed against the accepted `1R-C` foundation and current Prisma schema on
2026-07-13. The plan is accepted with the clarifications incorporated above:

- the existing Commerce A1 schema is acknowledged without coupling FUND configuration to
  Commerce enums or authorising A2;
- FUND-to-Commerce tax/price-basis mapping is explicit and `UNCLASSIFIED` is non-mappable;
- `unitPriceNet` remains tax-exclusive and is not reinterpreted;
- nullable paired copy-source fields preserve both same-tenant enforcement and safe
  `SetNull` behavior without nulling the copied Product's required tenant key;
- Project Product snapshot defaults are explicitly non-sellable placeholders until a later
  service copies reviewed Product classification;
- the missing `FundProjectProduct (organizationId, id)` composite key is now required;
- nullable-owner code uniqueness uses owner-specific partial indexes;
- Product modifier storage is locked to signed `Int` with an explicit range;
- relation, deletion and migration order are fixed;
- MediaFile tenant isolation remains a declared service gate rather than a false database
  guarantee;
- retained disposable-database safeguards, fresh/existing-data migration checks, backfill
  evidence and rollback expectations are complete.

No unresolved schema-policy conflict blocks bounded `1R-C1` implementation. No schema,
migration, service or application change was made during this acceptance review.

## 14. Completed Implementation Handoff

The implementation prompt below has been completed and must not be rerun against a shared
database. `1R-C1` is closed through review/test.

```text
Continue only accepted FUND Phase 1 Slice 1R-C1. Do not begin 1R-C2, COMMERCE-A2 or any
other slice.

Implement only the accepted Product Media/Input/Tax/Duplication schema foundation in the
current Prisma schema and one bounded migration. Preserve every existing Product and
Project Product commercial value; apply only the accepted UNCLASSIFIED, TAX_EXCLUSIVE and
revision backfills. Add the required same-tenant keys, relations, checks and partial unique
indexes exactly as planned. Do not add Store, checkout, Commerce Order, payment, upload or
Product-duplication service/application behaviour.

Use only the retained disposable database configured by TEST_DATABASE_URL for fresh and
representative existing-data migration and constraint tests. First prove it is distinct
from DATABASE_URL. Do not modify shared development, staging or production databases.

After implementation and successful validation, create the separate FUND 1R-C1
implementation-confirmation and review/test records, then update the FUND and root
roadmaps. Stop after completing the 1R-C1 lifecycle and do not start the next slice.
```
