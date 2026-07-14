# FUND Phase 1 Slice 1R-C3-R1 - Project Store/Store Product Schema Review And Test

Date: 2026-07-14

Status: Passed / disposable PostgreSQL migration and constraint smoke complete

Implementation confirmation:

`docs/modules/fund/04-implementation-confirmations/2026-07-14-phase-1-slice-1r-c3-project-store-store-product-schema-implementation-confirmation.md`

## 1. Review Scope

Reviewed the bounded 1R-C3 implementation for:

- exact Store, Store Product, configuration-version and input-owner boundary;
- aggregate-prefixed FUND enum naming;
- Project-date authority and absence of Store date duplication;
- tenant, Project, Project Product, Product and Product-media identity;
- immutable version source/current ownership;
- input exactly-one-owner preservation and extension;
- migration/backfill safety;
- direct deletion protection, bounded cascades and tenant teardown;
- absence of Store services/UI, Intake, Commerce, upload, production and commission work.

## 2. Static And Repository Checks

Passed:

```text
npx prisma format
npx prisma validate
npx prisma generate
npx tsx scripts/verify-fund-1r-c3-schema.ts
npx tsx scripts/verify-fund-1r-c2-schema.ts
npx tsx scripts/verify-fund-1r-c1-schema.ts
npx tsx scripts/verify-commerce-a1-schema.ts
npx eslint --no-ignore scripts/verify-fund-1r-c3-schema.ts
npm run type-check
npx tsx scripts/verify-critical-files.ts
git diff --check
```

Ordinary sandbox execution blocked `tsx` temporary IPC sockets. The exact verifiers and
repository check passed using the already-approved `npx tsx` execution allowance. This was
an execution-environment restriction, not an implementation failure.

## 3. Database Target Safety

Before any connection, redacted target fingerprints proved `TEST_DATABASE_URL` distinct
from `DATABASE_URL`. Only the retained disposable Neon test database was used.

The matching direct endpoint was derived in process memory for reset and migration work.
No credential or connection string was printed or written.

## 4. Representative Existing-Data Migration

Starting state:

- disposable database at 130 successful migrations through FUND `1R-C2`;
- `20260714150000_fund_1r_c3_project_store_store_product` was the only pending migration;
- representative Organizations, Products, Projects, Project Products, Product Media,
  Product/Project Product input definitions and choices existed before migration.

Result:

- only the C3 migration applied;
- all representative scalar, enum, decimal, timestamp and JSON values remained exact;
- existing input owners remained valid with null `store_product_id`;
- all three new tables and Store-owned input scope began empty;
- no public ID, Store, Store Product, media choice, readiness state or configuration version
  was inferred;
- the database finished at 131 successful migrations.

## 5. Constraint And Relation Smoke

Passed evidence for:

- Store defaults, title checks, one Store per Project and unique public ID;
- Store Product defaults, sort/title checks and one row per Store/Project Product;
- cross-tenant Store/Project/Project Product/input rejection;
- Store Project versus Project Product Project equality;
- Project Product versus Product equality;
- primary Product-media versus Product equality;
- configuration source Product/Project Product equality;
- positive unique versions, 64-character lowercase hash, positive source revision,
  commercial ranges, uppercase currency and object-shaped JSON snapshots;
- exact same-Store Product current-version ownership;
- readiness requiring eligibility and a current version;
- Product, Project Product and Store Product exactly-one-owner shapes;
- Store Product input-code uniqueness scoped to its owner;
- direct deletion blocks and explicit Store configuration cascade;
- zero fixture residue.

Two smoke-fixture refinements were made before the passing run:

- Product/media mismatch cases were moved to an unselected Project Product so the intended
  composite foreign key, rather than the earlier duplicate-selection key, was isolated;
- the pre-existing Core `MediaFile -> Organization` restriction was isolated from FUND
  tenant teardown by removing the mutable media association/file first.

Both failed attempts ran inside a transaction and rolled back completely. They exposed no
migration or production-data defect.

## 6. Deletion And History Verdict

Passed:

- direct Project deletion is blocked while its Store exists;
- direct Project Product and selected primary Product-media deletion is blocked;
- direct current configuration-version deletion is blocked;
- explicit Store deletion cascades its pre-Order Store Products, versions and Store-owned
  inputs;
- Organization teardown succeeds for the remaining C3 graph after satisfying the existing
  Core MediaFile restriction;
- immutable version media evidence is scalar/snapshot data and does not couple history to
  mutable Product-media deletion.

Later Order references must add history-based deletion restriction. No Order model exists
in this slice.

## 7. Fresh Migration Replay

The disposable database was reset and all 131 migrations were applied from empty through:

```text
20260713120000_commerce_a1_schema_seller_profile_enums
20260713150000_fund_1r_c1_product_configuration_foundation
20260714100000_fund_1r_c2_client_branding_delivery_event_media
20260714150000_fund_1r_c3_project_store_store_product
```

The complete C3 fixture and constraint suite then passed again with zero residue.

Final inventory:

```text
applied migrations: 131
failed migrations: 0
1R-C3 tables: 3
1R-C3 enums: 2
residual 1R-C3 test rows: 0
```

Migration status reported the disposable database schema up to date.

## 8. Boundary Verdict

Passed. `1R-C3` implements only the accepted FUND Store schema foundation.

Not added:

- Store creation, configuration-resolution, readiness or publication service;
- C1/C2 Store manager, public Store route or purchaser UI;
- Project Intake/member/User/delivery alignment;
- upload/storage/scanning behaviour;
- checkout, Commerce Orders, payments or providers;
- production assets or commission;
- `1R-C4`, `1R-C6` or Commerce A2 implementation.

No shared development, staging or production database deployment is claimed. The retained
test database remains disposable infrastructure at the complete 131-migration state.
