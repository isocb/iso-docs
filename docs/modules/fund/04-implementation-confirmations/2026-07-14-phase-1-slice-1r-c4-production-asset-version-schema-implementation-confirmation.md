# FUND Phase 1 Slice 1R-C4 - Production Asset Version Schema Implementation Confirmation

Date: 2026-07-14

Status: Implemented and validated on disposable PostgreSQL / uncommitted / shared database deployment not performed

Planning record:

`docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1r-c4-production-asset-version-schema-implementation-planning.md`

Review/test record:

`docs/modules/fund/05-review-and-test/2026-07-14-phase-1-slice-1r-c4-r1-production-asset-version-schema-review-and-test.md`

## 1. Implemented Boundary

Implemented only the accepted schema foundation for:

- stable logical production assets;
- append-only-by-service-contract managed file versions and immutable file snapshots;
- Project asset context and same-Project Store Product asset context;
- artwork review, uploader, scan, retention, restriction and tombstone state shapes;
- the one supporting Store Product tenant/ID/Project composite key.

No upload/download/storage/scanning service, file inspection, guest checkout, purchaser
PII, Commerce Order/line/payment relation, physical-original evidence, production
authorisation, Project Intake change, commission, API, route or UI was added.

## 2. Application-Repository Files

```text
prisma/schema.prisma
prisma/migrations/20260714200000_fund_1r_c4_production_asset_version/migration.sql
scripts/verify-fund-1r-c4-schema.ts
scripts/verify-fund-1r-c4-pre-migration.sql
scripts/verify-fund-1r-c4-database.sql
scripts/run-fund-1r-c4-database-tests.ts
```

The C3 schema and migration already present in the same uncommitted worktree were preserved.
No later slice or application behaviour was introduced.

## 3. Schema Delivered

Added seven aggregate-prefixed FUND enums:

```text
FundProductionAssetPurpose
FundProductionAssetArtworkReviewStatus
FundProductionAssetVersionMalwareScanStatus
FundProductionAssetVersionRetentionCategory
FundProductionAssetVersionUploaderType
FundProjectAssetRole
FundStoreProductAssetRole
```

Added four FUND models/tables:

```text
FundProductionAsset            -> fund.fund_production_assets
FundProductionAssetVersion     -> fund.fund_production_asset_versions
FundProjectAssetLink           -> fund.fund_project_asset_links
FundStoreProductAssetLink      -> fund.fund_store_product_asset_links
```

The migration also adds:

- unique logical asset/version and contextual link identities;
- same-asset current/review version pointers;
- exact Project/asset and same-Project Store Product anchoring;
- one primary asset per Store Product/role through a partial unique index;
- managed `MediaFile.id` restriction and immutable filename/MIME/size/SHA-256 snapshots;
- uploader, artwork-review, malware-scan, retention, restriction and deletion checks;
- bounded Cascade/NoAction/Restrict deletion actions;
- `FundProjectStoreProduct (organizationId, id, projectId)` as the single supporting key.

## 4. Data Preservation And Backfill

The representative 131-to-132 migration proved that pre-existing MediaFile, Project,
Store, Store Product, Product media and configuration-version values remained exact.

No Production Asset, Version, Project link or Store Product link was inferred or created by
migration. All four C4 tables began empty.

## 5. Contract Evidence

Database smoke passed for:

- valid logical assets, multiple file lineages and multiple contextual links;
- public purchaser upload provenance without a User ID and authenticated C1/C2 uploader
  categories requiring a User ID;
- duplicate version/link/primary-role rejection;
- unknown and cross-tenant aggregate relation rejection;
- Store Product links constrained to their Store Product's Project and exact Project link;
- current/review pointers constrained to the same asset and reviewed version;
- positive version/size, filename, MIME, lowercase SHA-256 and JSON-object checks;
- coherent scan, review, legal-hold, restriction and tombstone evidence;
- direct MediaFile/asset/version deletion protection and bounded context cascades;
- Organization teardown and zero fixture residue.

The shared `MediaFile` model lacks a composite tenant key. The test therefore also
demonstrated, documented and immediately removed the known case where the database accepts
a known cross-tenant MediaFile ID. A later write service must validate MediaFile ownership;
C4 does not claim that database guarantee.

## 6. Validation Completed

Passed:

- Prisma format, multi-schema validation and client generation;
- C4 schema/migration verification;
- Commerce A1 and FUND C1/C2/C3 static regression verification;
- targeted verifier ESLint, TypeScript type-check and critical-file verification;
- `git diff --check`;
- representative 131-to-132 existing-data migration;
- complete fresh application of all 132 migrations;
- the planned asset/version/uploader/scan/review/retention/tenant/Project/Store Product and
  deletion constraint suite on both migration paths;
- final migration inventory and zero-residue cleanup.

Final disposable-database inventory:

```text
applied migrations: 132
failed migrations: 0
1R-C4 tables: 4
1R-C4 enums: 7
residual 1R-C4 test rows: 0
```

## 7. Database Safety

Database validation used only the retained disposable Neon database configured locally by
`TEST_DATABASE_URL`. Before connection, redacted identity fingerprints proved it distinct
from `DATABASE_URL`.

The pooled test URL was converted to its matching direct endpoint in process memory for
reset/migration operations. Credentials and connection strings were not printed or
committed. No shared development, staging or production database was contacted or modified.

## 8. Honest Behaviour Boundary

The schema records managed-file references and evidence state shapes. It does not upload,
inspect, scan, retain, delete or make storage objects immutable. Snapshot fields are
append-only through a later service contract; PostgreSQL does not prevent privileged direct
updates to them.

`ORDER_LINE_ARTWORK_BACKUP` and `PUBLIC_PURCHASER` are vocabulary only. A C4 asset, clean
scan or approved review does not prove payment, receipt of physical original artwork or
production authorisation.

## 9. Handoff

`1R-C4` is complete through implementation confirmation and its separate review/test record
passes. The changes are not yet committed or deployed to a shared database.

The single next candidate is planning-only `1R-C5` Commission Policy And Assignment
Foundation. This confirmation does not authorise its implementation, Project Intake
alignment, Commerce A2 or another slice.
