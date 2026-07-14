# FUND Phase 1 Slice 1R-C5-R1 - Commission Policy And Assignment Schema Review And Test

Date: 2026-07-14

Status: Passed / disposable PostgreSQL migration and constraint lifecycle complete

Implementation confirmation:

`docs/modules/fund/04-implementation-confirmations/2026-07-14-phase-1-slice-1r-c5-commission-policy-assignment-schema-implementation-confirmation.md`

## 1. Review Scope

Reviewed the bounded 1R-C5 implementation for:

- Event-default, standalone Project and flat-only Event-Project override ownership;
- logical Policy versus immutable configuration Version identity;
- flat/stepped and offset/fixed-date/final Step shape;
- integer basis-point range and one-decimal increment enforcement;
- exact same-tenant Event, Project, Store, Policy, Version and predecessor identity;
- proposed, C2-accepted, superseded and post-close-finalized Assignment evidence;
- additive migration/zero-backfill safety and deletion actions;
- absence of calculation, Commerce, Store service/UI, Intake and later-slice behaviour.

## 2. Static And Repository Checks

Passed:

```text
npx prisma format --check
npx prisma validate
npx prisma generate
npx tsx scripts/verify-fund-1r-c5-schema.ts
npx tsx scripts/verify-fund-1r-c4-schema.ts
npx tsx scripts/verify-fund-1r-c3-schema.ts
npx tsx scripts/verify-fund-1r-c2-schema.ts
npx tsx scripts/verify-fund-1r-c1-schema.ts
npx tsx scripts/verify-commerce-a1-schema.ts
npx eslint --no-ignore scripts/verify-fund-1r-c5-schema.ts scripts/run-fund-1r-c5-database-tests.ts
npm run type-check
npx tsx scripts/verify-critical-files.ts
git diff --check
```

## 3. Database Target Safety

Before any connection, a redacted identity comparison proved `TEST_DATABASE_URL` distinct
from `DATABASE_URL`. Only the retained disposable Neon test database was used.

The matching direct endpoint was derived in process memory for reset and migration work.
No credential or connection string was written or committed. No shared database was
contacted or modified.

## 4. Representative Existing-Data Migration

Starting state:

- disposable database at 132 successful migrations through FUND `1R-C4`;
- `20260714230000_fund_1r_c5_commission_policy_assignment` was the only pending migration;
- representative Organizations, Events, Event-linked/standalone Projects, Stores and a C4
  Production Asset/link existed before migration.

Result:

- only the C5 migration applied;
- representative counts and values remained exact;
- all four C5 tables began empty;
- no commission term or assignment was inferred from existing metadata;
- the database finished at 133 successful migrations.

## 5. Constraint And Relation Smoke

Passed evidence for:

- exact Event owner or Project owner/mode policy shape;
- one Event policy and one Project policy per mode while preserving a different historical
  Project policy mode;
- active Version uniqueness, positive Version numbering and coherent lifecycle evidence;
- flat/stepped shape, flat-only Event-linked override and exact timing relation;
- basis-point range and divisibility by ten on flat rates and Steps;
- PostgreSQL `DATE` fixed thresholds, offset/date/final Step shapes, duplicate threshold,
  sequence and final-Step protection;
- exact Project/Event, Store/Project, Policy/owner, Version/Policy/mode and predecessor
  relations;
- proposed/accepted/superseded/finalized evidence, chronology, publication-before-close and
  finalization-at-or-after-close checks;
- one current proposal, one effective assignment and one successor per predecessor;
- direct assigned Version/Store deletion protection and Organization teardown.

The suite deliberately proved three accepted service boundaries and removed their rows in
the same rollback-only transaction:

- nonblank text cannot prove IANA timezone registry membership;
- a nullable Project/Event composite relation cannot prove that a standalone Assignment's
  live Project has no Event;
- partial indexes/FKs cannot reject a proposed replacement of a finalized predecessor or
  make the two-row supersession/acceptance transition atomic.

Actor role/tenant authority and ordered cross-row rate/date progression likewise remain
later service checks and are not falsely claimed as database guarantees.

## 6. Test-Harness Refinements

Three negative-test refinements preceded the passing lifecycle:

- the wrong-timing Step fixture was changed so the intended foreign key, rather than the
  earlier final-Step uniqueness rule, was exercised;
- the wrong-Store Assignment fixture was moved to a Project without an existing proposal so
  Store/Project identity, rather than proposal uniqueness, was exercised;
- the expected SQLSTATE for the existing Project-to-Event `RESTRICT` relation was corrected
  from `23503` to PostgreSQL `23001`.

Each failed attempt ran inside the disposable test target. The constraint transaction
rolled back and no fixture residue remained. These were test-isolation corrections, not
migration defects.

## 7. Fresh Migration Replay And Regression

The disposable database was destructively reset and all 133 migrations applied from empty.
Post-fresh fixtures passed the same complete C5 constraint/deletion suite.

Commerce A1 and FUND C1/C2/C3/C4 schema regressions passed. No earlier schema contract was
weakened by C5.

Final inventory:

```text
applied migrations: 133
failed migrations: 0
residual 1R-C5 test rows: 0
```

## 8. Scope Verdict

The implementation contains no commission calculation, eligible-sale discovery, period,
band aggregate, recognition, accrual, accounting, statement, settlement or payment state.
It contains no Commerce Order/line/payment/refund relation and no Store publication,
Commission Acceptance, API, route, UI, Project Intake or production-workflow behaviour.

C2 acceptance and post-close finalization remain schema evidence vocabulary. The tests do
not claim a real organiser accepted terms, a Store was published, a paid sale occurred or
commission money was calculated.

## 9. Review Result

`1R-C5-R1` passes. The bounded application changes are committed locally on `dev` at
`8b5f208`; that commit is not pushed and no shared database deployment has occurred.

Stop here. No Project Intake alignment, `1R-C6`, `COMMERCE-A2` or another slice is
authorised by this review.
