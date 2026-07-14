# FUND Phase 1 Slice 1P-G-R3-A-R1 - Project Intake Automation Schema And Form Policy Foundation Review And Test

Date: 2026-07-14

Status: Passed / disposable PostgreSQL migration and constraint lifecycle complete

Implementation confirmation:

`docs/modules/fund/04-implementation-confirmations/2026-07-14-phase-1-slice-1p-g-r3-a-project-intake-automation-schema-form-policy-foundation-implementation-confirmation.md`

## 1. Review Scope

Independently reviewed the bounded R3-A implementation for:

- exact accepted enums, fields, keys, relations, checks and indexes;
- legacy-safe aligned-form opt-in and policy revision evidence;
- typed organiser/address/Project-type evidence;
- automated, C1-review and incomplete-exception shapes;
- nullable composite-key behavior and exact tenant/owner identity;
- zero-backfill migration safety and historic approval preservation;
- exclusion of all runtime automation and later-slice behavior.

## 2. Static And Generated-Client Checks

Passed:

```text
npx prisma format --check
npx prisma validate
npx prisma generate
npx tsx scripts/verify-fund-1p-g-r3-a-schema.ts
npx tsx scripts/verify-commerce-a1-schema.ts
npx tsx scripts/verify-fund-1r-c1-schema.ts
npx tsx scripts/verify-fund-1r-c2-schema.ts
npx tsx scripts/verify-fund-1r-c3-schema.ts
npx tsx scripts/verify-fund-1r-c4-schema.ts
npx tsx scripts/verify-fund-1r-c5-schema.ts
npx eslint --no-ignore scripts/verify-fund-1p-g-r3-a-schema.ts scripts/run-fund-1p-g-r3-a-database-tests.ts
npm run type-check
npx tsx scripts/verify-critical-files.ts
git diff --check
```

Prisma validates both the retained historic approved-Project relation and the additional
exact Project/Client relation using overlapping nullable scalar fields.

## 3. Database Target Safety

The test runner loaded both URLs locally, compared their complete parsed target identities
and refused equality. Only the redacted disposable target identity was printed. Migration
and reset work used the direct endpoint derived in memory.

No shared development, staging or production database was contacted.

## 4. Representative Existing-Data Migration

Starting state:

- complete 133-migration C5 disposable baseline;
- twenty-four representative legacy records across Organizations, Events, Clients, members,
  Projects, delivery profiles, Intake forms and Intake submissions;
- R3-A as the sole pending migration.

Result:

- R3-A applied as migration 134;
- every representative business value and raw JSON snapshot remained exact;
- no legacy form received aligned scope/version/revision;
- no historic submission received typed, snapshot, exception or provisioning evidence;
- the historic clientless approval remained valid and continued to restrict deletion of its
  approved Project;
- no operational row was created by migration.

## 5. Form And Evidence Constraint Tests

Passed positive and negative evidence for:

- valid fixed Event and selectable standalone form policy;
- inert legacy `requiresModeration = false` without an aligned contract;
- partial alignment rejection;
- Event without Event ID and standalone with Event ID rejection;
- blank fixed type, non-array type configuration, empty selectable set and default outside
  the allowed set rejection;
- paired submitted form contract/revision snapshots;
- typed nonblank evidence and uppercase country code;
- valid automatic Event completion;
- valid C1-reviewed standalone completion retaining its original exception reason;
- valid incomplete exception progression from `IN_REVIEW` through later non-completion
  review states;
- rejection of `SUBMITTED` as an automated exception;
- rejection of incomplete completion, automatic completion with an exception, and C1 review
  without reviewer evidence.

## 6. Exact Identity And Deletion Tests

Passed:

- approved member belongs to approved Client;
- approved Project belongs to approved Client;
- approved delivery profile belongs to approved Project;
- trusted initiating member belongs to trusted initiating Client;
- half-present trusted identity rejection;
- wrong-Client, wrong-Project and cross-tenant relation rejection;
- direct approved member, delivery, Project and Client deletion restriction;
- retained historic clientless approved-Project deletion restriction.

The existing `RESTRICT` foreign keys correctly report PostgreSQL SQLSTATE `23001`; new
`NO ACTION` exact keys report `23503`. Test expectations distinguish these contracts.

## 7. Fresh Replay And Test Refinements

The disposable database was reset from empty and reached all 134 migrations. The same
representative fixture, constraint and deletion suite passed after the fresh replay.

Two verifier refinements preceded the final pass:

- direct deletion expectations were corrected from generic foreign-key SQLSTATE `23503` to
  PostgreSQL `23001` where the historic relation explicitly uses `RESTRICT`;
- explicit non-null predicates were added to alternative `CHECK` branches after PostgreSQL
  correctly demonstrated that a `NULL` result otherwise satisfies a check constraint.

An execution-wrapper cutoff interrupted the long reset process and left one advisory-lock
session on the disposable target. That test-only session was terminated, the same fresh
replay completed, and the final migration inventory showed no failure. This was harness
recovery, not a migration or data correction.

Final inventory:

```text
applied migrations: 134
failed migrations: 0
residual R3-A test rows: 0
```

## 8. Scope Verdict

The implementation adds schema vocabulary and evidence constraints only. It does not alter
form behavior, confirmation, moderation, provisioning, Client/User/member management,
service, API, route, email or UI code. It creates no Store, Commerce, payment, production or
commission behavior.

Project-type vocabulary validation, revision comparison, exact live Event authority,
login-capable User proof and the atomic provisioning transaction remain R3-B runtime work.

## 9. Review Result

`1P-G-R3-A-R1` passes. The bounded R3-A lifecycle is complete locally, uncommitted and
undeployed to shared databases.

Stop here. R3-B, R3-C, Store `1R-D`, `1R-C6`, `COMMERCE-A2` and every other slice remain
unstarted and unauthorised.
