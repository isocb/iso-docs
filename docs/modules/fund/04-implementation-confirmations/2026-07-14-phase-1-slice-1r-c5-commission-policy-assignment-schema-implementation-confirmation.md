# FUND Phase 1 Slice 1R-C5 - Commission Policy And Assignment Schema Implementation Confirmation

Date: 2026-07-14

Status: Implemented and validated on disposable PostgreSQL / application committed locally at `8b5f208` / not pushed or deployed to a shared database

Planning record:

`docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1r-c5-commission-policy-assignment-schema-implementation-planning.md`

Review/test record:

`docs/modules/fund/05-review-and-test/2026-07-14-phase-1-slice-1r-c5-r1-commission-policy-assignment-schema-review-and-test.md`

## 1. Implemented Boundary

Implemented only the accepted schema foundation for:

- Event-default, standalone Project and flat-only Event-Project override policies;
- immutable-by-service-contract configuration versions and ordered Steps;
- one-decimal percentage rates stored as integer basis points divisible by ten;
- exact Project/Store/policy/version assignment evidence;
- C2 acceptance, audited replacement, supersession and post-close finalization state;
- the one supporting Project tenant/ID/Event composite key.

No Store publication or Commission Acceptance service, UI, API or route was added. No
commission calculation, eligible-sale period, band aggregate, recognition, accrual,
accounting, statement, settlement or payment behaviour was added. Commerce Orders, Order
lines, payments, refunds, Project Intake, production workflow and every later slice remain
unchanged.

## 2. Application-Repository Files

```text
prisma/schema.prisma
prisma/migrations/20260714230000_fund_1r_c5_commission_policy_assignment/migration.sql
scripts/verify-fund-1r-c5-schema.ts
scripts/verify-fund-1r-c5-pre-migration.sql
scripts/verify-fund-1r-c5-database.sql
scripts/run-fund-1r-c5-database-tests.ts
```

No service, API, route, UI or Commerce file changed.

## 3. Schema Delivered

Added five aggregate-prefixed FUND enums:

```text
FundCommissionPolicyMode
FundCommissionPolicyMethod
FundCommissionPolicyTimingMethod
FundCommissionPolicyVersionStatus
FundProjectCommissionAssignmentStatus
```

Added four FUND models/tables:

```text
FundCommissionPolicy              -> fund.fund_commission_policies
FundCommissionPolicyVersion       -> fund.fund_commission_policy_versions
FundCommissionStep                -> fund.fund_commission_steps
FundProjectCommissionAssignment   -> fund.fund_project_commission_assignments
```

The migration also adds:

- `FundProject (organizationId, id, eventId)` as the one supporting key;
- one Event policy and one Project policy per Project/mode through partial uniqueness;
- exact Event/Project owner, Policy/Version, Store/Project and predecessor relations;
- one active Version per Policy, one final Step per Version, one current proposal and one
  effective accepted/finalized assignment per Project;
- flat/stepped, offset/fixed-date/final-step and lifecycle checks;
- `DATE` storage for fixed thresholds and immutable timezone text snapshots;
- rate range and exact `0.1%` increment checks;
- proposal, acceptance, supersession, publication, chronology and post-close finalization
  evidence checks;
- bounded Cascade/NoAction deletion actions.

## 4. Data Preservation And Backfill

The representative 132-to-133 migration proved that pre-existing Organization, Event,
Project, Store and C4 Production Asset/link values remained exact.

No Policy, Version, Step or Assignment row was inferred or created by migration. The four
C5 tables began empty.

## 5. Contract Evidence

Database smoke passed for:

- valid Event-default offset and fixed-date stepped policies;
- valid standalone flat policy and Event-linked flat override;
- separate historical standalone and override modes for one Project;
- exact tenant, Event, Project, Store, Policy, Version and predecessor ownership;
- duplicate Event policy, Project/mode policy, active Version, Step/final and current
  Assignment rejection;
- flat/stepped/override shape and one-decimal basis-point rejection;
- Version and Assignment lifecycle/chronology checks;
- accepted Assignment plus proposed replacement, atomic test transition to superseded/newly
  accepted evidence and post-close finalization;
- direct owner/version/Store deletion restriction, Organization teardown and zero residue.

The schema intentionally cannot validate IANA registry membership, live C1/C2 actor role,
standalone-versus-Event context, ordered cross-row Step activation, replacement of a
non-finalized predecessor or the atomic two-row replacement transition. Tests explicitly
demonstrated the bounded timezone/context/predecessor limitations. Later services must
enforce them transactionally.

## 6. Validation Completed

Passed:

- Prisma format, multi-schema validation and client generation;
- dedicated C5 schema/migration verification;
- Commerce A1 and FUND C1/C2/C3/C4 static regression verification;
- targeted verifier ESLint, TypeScript type-check and critical-file verification;
- `git diff --check`;
- representative 132-to-133 existing-data migration;
- complete fresh application of all 133 migrations;
- the complete policy/version/step/assignment/tenant/context/lifecycle/chronology/deletion
  suite on both migration paths;
- final migration inventory and zero-residue cleanup.

Final disposable-database inventory:

```text
applied migrations: 133
failed migrations: 0
1R-C5 tables: 4
1R-C5 enums: 5
residual 1R-C5 test rows: 0
```

## 7. Database Safety

Database validation used only the retained disposable Neon database configured locally by
`TEST_DATABASE_URL`. Before connection, redacted target identity fingerprints proved it
distinct from `DATABASE_URL`.

The pooled test URL was converted to its matching direct endpoint in process memory for
reset/migration operations. Credentials and connection strings were not printed or
committed. No shared development, staging or production database was contacted or modified.

## 8. Honest Behaviour Boundary

The schema records configuration and assignment evidence only. It does not resolve offers,
validate C2 authority, gate Store publication, recalculate provisional UI figures or
finalize a real commission period.

The newest accepted assignment's retrospective commercial effect is a later calculation
contract; C5 stores the auditable assignment chain but has no Order/payment evidence and
computes no money.

## 9. Handoff

`1R-C5` is complete through implementation confirmation and its separate review/test record
passes. The bounded application changes are committed locally on `dev` at `8b5f208`. That
commit has not been pushed to `origin/dev`, and no shared database has been migrated.

Stop here. This confirmation does not authorise Project Intake alignment, `1R-C6`,
`COMMERCE-A2` or another slice.
