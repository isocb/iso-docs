# FUND Phase 1 Slice 1R-C3 - Project Store/Store Product Schema Implementation Confirmation

Date: 2026-07-14

Status: Implemented and validated on disposable PostgreSQL / uncommitted / shared database deployment not performed

Planning record:

`docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1r-c3-project-store-store-product-schema-implementation-planning.md`

Review/test record:

`docs/modules/fund/05-review-and-test/2026-07-14-phase-1-slice-1r-c3-r1-project-store-store-product-schema-review-and-test.md`

## 1. Implemented Boundary

Implemented only the accepted schema foundation for:

- one Project Store per Project with stable public identity and lifecycle state;
- one Store Product per selected Project Product;
- immutable-by-contract resolved Store Product configuration versions;
- `STORE_PRODUCT` ownership for typed FUND Order-input definitions.

No Store creation/readiness/publication service, public route, UI, Project Intake change,
upload, Commerce checkout/Order/payment, production asset or commission behaviour was added.

## 2. Application-Repository Files

```text
prisma/schema.prisma
prisma/migrations/20260714150000_fund_1r_c3_project_store_store_product/migration.sql
scripts/verify-fund-1r-c3-schema.ts
scripts/verify-fund-1r-c3-pre-migration.sql
scripts/verify-fund-1r-c3-database.sql
scripts/verify-fund-1r-c1-schema.ts
```

The C1 verifier changed only to recognise the accepted additive `STORE_PRODUCT` enum value.
No C1 table or migration was changed.

## 3. Schema Delivered

Added two aggregate-prefixed FUND enums:

```text
FundProjectStoreStatus
FundProjectStoreProductReadinessStatus
```

Extended:

```text
FundOrderInputOwnerScope
  + STORE_PRODUCT
```

The naming follows `Fund<OwningAggregate><Meaning>`. Generic enum names were not introduced.

Added three FUND models/tables:

```text
FundProjectStore                       -> fund.fund_project_stores
FundProjectStoreProduct                -> fund.fund_project_store_products
FundStoreProductConfigurationVersion   -> fund.fund_store_product_configuration_versions
```

The migration also adds:

- composite relation targets on Project Product and Product Media;
- same-tenant Store-to-Project identity;
- Store Product-to-Store Project equality;
- Store Product-to-Project Product Project/Product equality;
- primary Product-media Product equality;
- configuration-version source Product/Project Product equality;
- exact current-version ownership;
- Store Product input-owner relation, index, partial code uniqueness and revised
  exactly-one-owner check;
- nonblank, ordering, readiness, version, hash, source-revision, commercial range,
  currency and JSON-object checks;
- accepted `Cascade`/`NoAction` deletion actions.

No Store opening or closing columns were added. `FundProject.opensAt` and `closesAt` remain
authoritative.

## 4. Data Preservation And Backfill

The representative 130-to-131 migration proved that existing values remained exact for:

- Product price, VAT, currency, tax treatment, price-entry basis, revision and metadata;
- Project opening/closing dates and metadata;
- Project Product identity, commercial/tax snapshots and metadata;
- Product and Project Product input owners, codes, revisions, choices and values.

No Store, Store Product, configuration version or Store-owned input was inferred or
created by migration. Existing input rows received only a null `store_product_id` column.

## 5. Identity, Version And Deletion Evidence

Database smoke passed for:

- valid Store, Store Product, configuration-version and Store-owned input creation;
- one Store per Project and globally unique public ID;
- one Store Product per Store/Project Product;
- cross-tenant and cross-Project rejection;
- Project Product/Product and primary Product-media/Product matching;
- configuration source Product/Project Product matching;
- current version belonging to the same Store Product;
- `READY` requiring eligibility and a current version;
- valid Product, Project Product and Store Product exactly-one-owner shapes;
- duplicate Store Product input-code rejection while the same code under another Store
  Product remains valid;
- direct Project, Project Product, primary Product-media and current-version deletion block;
- explicit Store deletion cascade to its pre-Order Store Products, versions and inputs;
- intentional Organization teardown of the remaining Store/Project/Product/version graph.

The existing Core `MediaFile -> Organization` deletion restriction is independent of
1R-C3. The tenant-teardown test removed the mutable media association/file first while the
configuration version retained its scalar media snapshot evidence.

## 6. Validation Completed

Passed:

- Prisma format, multi-schema validation and client generation;
- targeted C3 generated-client/schema/migration verification;
- Commerce A1 and FUND C1/C2 static regression verification;
- targeted verifier ESLint;
- TypeScript type-check;
- repository critical-file verification;
- `git diff --check`;
- representative 130-to-131 existing-data migration;
- complete fresh application of all 131 migrations;
- complete identity, ownership, uniqueness, default, check and deletion suite on both
  migration paths;
- final zero-residue and migration inventory.

Final disposable-database inventory:

```text
applied migrations: 131
failed migrations: 0
1R-C3 tables: 3
1R-C3 enums: 2
residual 1R-C3 test rows: 0
```

## 7. Database Safety

Database validation used only the retained disposable Neon database configured locally by
`TEST_DATABASE_URL`. Before connection, redacted identity fingerprints proved it distinct
from `DATABASE_URL`.

The pooled test URL was converted to its matching direct endpoint in process memory for
reset/migration operations. Credentials and connection strings were not printed or
committed. No shared development, staging or production database was contacted or modified.

## 8. Immutability Boundary

Configuration versions have no `updatedAt`, update actor or mutable metadata and are
designed for insert/read-only application behaviour. Composite keys enforce ownership and
source identity. The schema does not falsely claim that PostgreSQL prevents a privileged
direct `UPDATE`; the later resolver must remain insert-only, and later Commerce/FUND Order
relations will restrict referenced version deletion.

## 9. Handoff

`1R-C3` is complete through implementation confirmation and its separate review/test record
passes. The changes are not yet committed or deployed to a shared database.

The next recommended action is planning-only `1R-C4` Production Asset Version Foundation.
No `1R-C4` implementation, Project Intake alignment, Commerce A2 or another slice is
authorised by this confirmation.
