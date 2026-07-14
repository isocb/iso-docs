# FUND Phase 1 Slice 1P-G-R3-A - Project Intake Automation Schema And Form Policy Foundation Implementation Confirmation

Date: 2026-07-14

Status: Implemented and validated on disposable PostgreSQL / application committed at `4bb7dd9` / no shared database deployment

Planning record:

`docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1p-g-r3-a-project-intake-automation-schema-form-policy-foundation-implementation-planning.md`

Review/test record:

`docs/modules/fund/05-review-and-test/2026-07-14-phase-1-slice-1p-g-r3-a-r1-project-intake-automation-schema-form-policy-foundation-review-and-test.md`

## 1. Implemented Boundary

Implemented only the accepted additive Project Intake schema/form-policy foundation:

- explicit aligned-form Event/standalone scope, contract version and policy revision;
- fixed/selectable Project-type form policy;
- typed organiser, address and Project-type submission evidence;
- submitted form contract/revision snapshots;
- automated/C1-review/exception and provisioning-completion evidence;
- exact approved member/Client, approved Project/Client, approved delivery/Project and
  trusted initiating member/Client relations;
- one additive migration and focused static/database verifiers.

No form was opted into automation. No confirmation, moderation, provisioning, User/member,
service, API, route, email or UI behaviour changed. No Store, Commerce, payment, production
or commission behaviour was added.

## 2. Application Files

```text
prisma/schema.prisma
prisma/migrations/20260714233000_fund_1p_g_r3_a_intake_automation_schema_policy/migration.sql
scripts/verify-fund-1p-g-r3-a-schema.ts
scripts/verify-fund-1p-g-r3-a-pre-migration.sql
scripts/verify-fund-1p-g-r3-a-database.sql
scripts/run-fund-1p-g-r3-a-database-tests.ts
```

No existing service, validation, router, route, component or email file changed.

## 3. Schema Delivered

Added three Fund-prefixed enums:

```text
FundProjectIntakeAlignedScope
FundProjectIntakeProvisioningPath
FundProjectIntakeExceptionReason
```

Added six form-policy fields and twenty-two nullable submission evidence fields. The only
non-null additions are inert defaults:

```text
allowProjectTypeSelection = false
allowedProjectTypeCodes = []
```

They cannot enable automation while `formContractVersion` is null.

Added exact supporting keys:

```text
FundClientMember(organizationId, id, clientId)
FundProject(organizationId, id, clientId)
FundProjectDeliveryProfile(organizationId, id, projectId)
```

The historic approved-Project relation remains in place. A second exact Project/Client
relation was added so aligned results prove Client ownership without weakening deletion
protection for historic clientless approvals.

## 4. Constraint Contract

The migration enforces:

- all-null legacy versus complete version-1 form alignment evidence;
- exact Event/standalone form shape;
- fixed versus selectable Project-type policy and JSON-array shape;
- typed nonblank and uppercase two-letter country evidence;
- paired form contract/revision snapshots;
- explicit nullable identity pairs despite PostgreSQL `MATCH SIMPLE` behavior;
- coherent automation evaluation evidence;
- complete version-1 automatic or C1-reviewed provisioning evidence;
- Event versus standalone completion shape;
- bounded incomplete exception statuses with no partial approved result;
- exact same-tenant and same-owner foreign keys;
- restrictive direct deletion evidence.

PostgreSQL `CHECK` alternatives use explicit non-null predicates where necessary so invalid
partial evidence cannot pass through three-valued `NULL` evaluation.

## 5. Data Preservation And Backfill

The representative 133-to-134 migration preserved twenty-four pre-migration fixtures,
including:

- active legacy manual form configuration and raw metadata;
- confirmation-pending and submitted evidence;
- a historic Client/Project approval;
- a historic clientless `CREATE_PROJECT_STANDALONE` approval and its original Project
  deletion protection;
- Client, member, Event, Project and delivery-profile values.

All historic alignment, typed, snapshot, exception and provisioning fields remained null.
The migration inserted or inferred no form, submission, Client, User, member, Project or
delivery-profile row.

## 6. Validation Completed

Passed:

- Prisma format, multi-schema validation and client generation;
- dedicated R3-A schema/migration verifier;
- Commerce A1 and FUND C1/C2/C3/C4/C5 static regressions;
- focused verifier ESLint;
- TypeScript type-check and critical-file verification;
- application and documentation `git diff --check`;
- representative 133-to-134 existing-data migration;
- complete fresh 134-migration replay;
- form, snapshot, typed evidence, exception, provisioning, tenant/owner and deletion tests;
- zero-residue cleanup.

Final disposable-database inventory:

```text
applied migrations: 134
failed migrations: 0
residual R3-A test rows: 0
```

## 7. Database Safety

Only the retained Neon database configured by `TEST_DATABASE_URL` was used. Before any
connection, redacted target fingerprints proved it distinct from `DATABASE_URL`. The runner
used the corresponding direct Neon endpoint for reset and migration operations.

One interrupted fresh-reset wrapper left one disposable-database advisory-lock session;
only that test-database session was terminated. The same empty-database replay then reached
all 134 migrations and passed the post-fresh suite. No shared development, staging or
production database was contacted or modified.

## 8. Honest Remaining Boundaries

R3-A stores evidence only. R3-B must still implement and verify:

- form-policy revision increment and comparison behavior;
- accepted Project-type vocabulary and JSON element normalization;
- current Event/Project and User/member tenant/access authority;
- atomic Client/User/member/Project/delivery provisioning;
- idempotency, duplicate detection and exception classification;
- confirmation-trigger behavior and audit writes.

The database cannot prove that an approved member has a login-capable `User`, because the
current User relation is platform-owned by ID. R3-A does not falsely claim that runtime
contract.

## 9. Handoff

R3-A is complete through implementation and independent review/test. Application changes
are committed at `4bb7dd9` and the documentation lifecycle is committed at `65fc243`. No
shared deployment is claimed.

Stop here. R3-B is the future service child but has not been planned or authorised by this
lifecycle.
