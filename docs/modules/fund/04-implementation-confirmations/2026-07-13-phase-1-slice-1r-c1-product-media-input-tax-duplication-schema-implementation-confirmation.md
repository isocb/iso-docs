# FUND Phase 1 Slice 1R-C1 - Product Media/Input/Tax/Duplication Schema Implementation Confirmation

Date: 2026-07-13

Status: Implemented and validated on disposable PostgreSQL / shared database deployment not performed

Application commit: `4575d2d` (`dev` and `origin/dev`, committed with Commerce A1/FUND 1R-C2)

Planning record:

`docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c1-product-media-input-tax-duplication-schema-implementation-planning.md`

Review/test record:

`docs/modules/fund/05-review-and-test/2026-07-13-phase-1-slice-1r-c1-r1-product-media-input-tax-duplication-schema-review-and-test.md`

## 1. Implemented Boundary

Implemented only the accepted schema foundation for:

- Product tax treatment and price-entry-basis configuration;
- matching Project Product snapshots;
- Product configuration revision and same-tenant copy provenance;
- Product media associations;
- typed Product/Project Product input definitions;
- input choices and choice-linked Product media.

No Store, checkout, Commerce Order, payment, upload, Product-copy service, API, UI,
production, commission or `COMMERCE-A2` work was added.

## 2. Application-Repository Files

```text
prisma/schema.prisma
prisma/migrations/20260713150000_fund_1r_c1_product_configuration_foundation/migration.sql
scripts/verify-fund-1r-c1-schema.ts
scripts/verify-fund-1r-c1-pre-migration.sql
scripts/verify-fund-1r-c1-database.sql
```

The existing local Commerce A1 files were preserved and were not absorbed into this FUND
slice.

## 3. Schema Delivered

Added six FUND enums:

```text
FundProductTaxTreatment
FundPriceEntryBasis
FundProductMediaRole
FundOrderInputOwnerScope
FundOrderInputKind
FundOrderInputControlType
```

Added four FUND models:

```text
FundProductMedia
FundOrderInputDefinition
FundOrderInputChoice
FundOrderInputChoiceMedia
```

Extended `FundProduct` with tax/basis, configuration revision and paired nullable
copy-source fields. Extended `FundProjectProduct` with tax/basis snapshots and the required
tenant/id composite key.

The migration includes:

- safe `UNCLASSIFIED`, `TAX_EXCLUSIVE` and revision-1 defaults/backfills;
- paired-null and same-tenant copy-provenance checks;
- positive revision and non-negative sort-order checks;
- exactly-one-owner enforcement;
- owner-specific partial unique indexes;
- one-active-primary Product-media and one-primary-per-choice partial indexes;
- composite same-tenant FUND relations;
- restrictive `MediaFile` deletion;
- accepted mutable-configuration cascades before later Store history exists.

## 4. Data Preservation

The representative pre-migration test proved that migration did not alter:

- Product `unitPriceNet`, `vatRate` or `currency`;
- null legacy Product prices;
- Project Product code/name, net-price, VAT-rate or currency snapshots;
- Product or Project Product row counts.

No media, input, choice or choice-media rows were inferred during migration.

## 5. Validation Completed

Passed:

- Prisma format, validation and client generation;
- 1R-C1 generated-client/schema/migration contract verifier;
- TypeScript type-check;
- targeted verifier ESLint;
- repository critical-file verification;
- `git diff --check`;
- representative 128-to-129 migration with legacy FUND rows;
- backfill, ownership, tenant, uniqueness, deletion and integer-bound smoke tests;
- complete fresh application of all 129 migrations;
- Commerce A1 static and database regression checks;
- final migration and zero-residue inventory.

Final disposable-database inventory:

```text
applied migrations: 129
failed migrations: 0
1R-C1 tables: 4
1R-C1 enums: 6
residual test Organizations: 0
```

## 6. Database Safety

Database validation used only the retained Neon database configured locally by
`TEST_DATABASE_URL`. Before connection, redacted identity fingerprints proved it distinct
from `DATABASE_URL`. The connection string remains local and uncommitted.

The fresh replay used the test database's direct Neon endpoint after a killed pooled test
session retained Prisma's advisory lock. Only stale advisory-lock sessions on the verified
disposable database were terminated. No shared development, staging or production database
was contacted or modified.

## 7. Known Gate Preserved

`MediaFile` still lacks a composite `(organizationId, id)` key. The database therefore
restricts deletion by `mediaFileId` but cannot enforce matching tenant ownership for a
Product-media association. No media write service was added. A later accepted service must
validate MediaFile tenant ownership before enabling writes.

## 8. Handoff

`1R-C1` is complete through implementation. Its separate review/test record passes. No
later FUND or Commerce slice is authorised by this confirmation.
