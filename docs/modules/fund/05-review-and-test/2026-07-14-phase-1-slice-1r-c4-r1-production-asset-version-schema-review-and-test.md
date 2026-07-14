# FUND Phase 1 Slice 1R-C4-R1 - Production Asset Version Schema Review And Test

Date: 2026-07-14

Status: Passed / disposable PostgreSQL migration and constraint smoke complete

Implementation confirmation:

`docs/modules/fund/04-implementation-confirmations/2026-07-14-phase-1-slice-1r-c4-production-asset-version-schema-implementation-confirmation.md`

## 1. Review Scope

Reviewed the bounded 1R-C4 implementation for:

- exact logical asset, file version, Project link and Store Product link boundary;
- aggregate-prefixed FUND enum naming;
- managed MediaFile reference and immutable snapshot shape;
- uploader, scan, review, retention, restriction and tombstone coherence;
- same-tenant, same-asset and same-Project identity;
- multi-file representation as independent logical assets;
- migration/zero-backfill safety and deletion actions;
- absence of upload/storage, guest checkout, Commerce, physical-artwork and production-gate
  behaviour.

## 2. Static And Repository Checks

Passed:

```text
npx prisma format
npx prisma validate
npx prisma generate
npx tsx scripts/verify-fund-1r-c4-schema.ts
npx tsx scripts/verify-fund-1r-c3-schema.ts
npx tsx scripts/verify-fund-1r-c2-schema.ts
npx tsx scripts/verify-fund-1r-c1-schema.ts
npx tsx scripts/verify-commerce-a1-schema.ts
npx eslint --no-ignore scripts/verify-fund-1r-c4-schema.ts scripts/run-fund-1r-c4-database-tests.ts
npm run type-check
npx tsx scripts/verify-critical-files.ts
git diff --check
```

## 3. Database Target Safety

Before any connection, redacted target fingerprints proved `TEST_DATABASE_URL` distinct
from `DATABASE_URL`. Only the retained disposable Neon test database was used.

The matching direct endpoint was derived in process memory for reset and migration work.
No credential or connection string was written or committed. No shared database was
contacted or modified.

## 4. Representative Existing-Data Migration

Starting state:

- disposable database at 131 successful migrations through FUND `1R-C3`;
- `20260714200000_fund_1r_c4_production_asset_version` was the only pending migration;
- representative Organizations, MediaFiles, Projects, Stores, Store Products, Product
  media and configuration versions existed before migration.

Result:

- only the C4 migration applied;
- representative counts and values remained exact;
- all four C4 tables began empty;
- no existing media/configuration row was reinterpreted as production evidence;
- the database finished at 132 successful migrations.

## 5. Constraint And Relation Smoke

Passed evidence for:

- asset defaults, nonblank text and object metadata;
- independent logical assets for multi-file Project/Store Product use;
- positive unique version numbers, positive byte sizes, nonblank snapshot values and exact
  lowercase SHA-256 shape;
- public/system uploader categories rejecting a User ID and C1/C2 categories requiring one;
- coherent pending/clean/infected/failed scan evidence;
- coherent awaiting/submitted/reviewing/changes-required/approved/not-required review
  evidence and exact current/review version equality;
- legal hold, restriction and tombstone evidence checks;
- duplicate versions, Project links, Store Product links and primary-role rejection;
- unknown/cross-tenant aggregate relations and cross-Project Store Product anchoring
  rejection;
- exact same-asset current/review pointer rejection for another asset's version;
- direct MediaFile, linked asset and selected version deletion restriction;
- Project/Store Product/Project-link context cascades, Organization teardown and zero
  fixture residue.

The suite deliberately proved the existing `MediaFile` tenant limitation: a known media ID
from another tenant satisfies the simple Core foreign key. The test row was removed in the
same rollback-only suite. This is accepted evidence of a later service invariant, not a
claim of database tenant enforcement.

Two test-harness refinements preceded the passing lifecycle. The first isolated the intended
same-Project foreign key from an earlier uniqueness collision; the second corrected the
expected PostgreSQL SQLSTATE for `RESTRICT`. Both attempts ran transactionally and rolled
back completely. Neither exposed a migration defect or left residue.

## 6. Deletion, Retention And Immutability Verdict

Passed:

- asset deletion is blocked while versions or Project links remain;
- MediaFile deletion is restricted while a production version references it;
- current/review versions cannot be removed while selected;
- Project and Store Product deletion remove only their contextual links;
- deleting a Project source link cascades the dependent Store Product context link;
- Organization teardown removes the bounded C4 graph after satisfying Core MediaFile
  restrictions.

Retention categories, restrictions and tombstones are evidence only. The schema does not
physically delete storage objects, enforce purge permissions or make version snapshots
immune to privileged direct update.

## 7. Fresh Migration Replay And Regression

The disposable database was destructively reset and all 132 migrations applied from empty.
Post-fresh fixtures then passed the same complete C4 constraint/deletion suite.

Commerce A1 and FUND C1/C2/C3 schema regressions passed. No existing schema contract was
weakened by C4.

Final inventory:

```text
applied migrations: 132
failed migrations: 0
residual 1R-C4 test rows: 0
```

## 8. Scope Verdict

The implementation contains no upload/download/storage/scanning service, file inspection,
API, route, UI, Project Intake, Commerce Order/payment, physical-original or production
authorisation state.

`ORDER_LINE_ARTWORK_BACKUP` and `PUBLIC_PURCHASER` remain schema vocabulary only. The test
does not claim that a public purchaser uploaded a real file, that payment was confirmed or
that any asset authorised production.

## 9. Review Result

`1R-C4-R1` passes. The bounded C4 lifecycle is complete locally and remains uncommitted and
undeployed to shared databases.

The next permitted action is a separately requested, planning-only `1R-C5` Commission
Policy And Assignment slice. No later implementation is authorised by this review.
