# FUND Phase 1 Slice 1P-G-R3-B - Project Intake Automated Provisioning And Protection Services Implementation Confirmation

Date: 2026-07-14

Status: Implemented and validated on disposable PostgreSQL / application committed at `04da074` / dormant and undeployed

Planning record:

`docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1p-g-r3-b-project-intake-automated-provisioning-and-protection-services-implementation-planning.md`

Review/test record:

`docs/modules/fund/05-review-and-test/2026-07-14-phase-1-slice-1p-g-r3-b-r1-project-intake-automated-provisioning-protection-services-review-and-test.md`

## 1. Entry Baseline

R3-B began only after the required baselines were committed separately:

```text
application R3-A baseline: 4bb7dd9
IsoDocs R3-A lifecycle/R3-B accepted-plan baseline: 65fc243
database baseline: 134 applied migrations / 0 failed
```

No R3-B schema or migration change was required.

## 2. Implemented Boundary

Implemented the dormant internal version-1 engine only:

- canonical aligned-form policy normalization, revision and submitted-snapshot comparison;
- shared FUND Project-type normalization and identifier helpers;
- strict automatic and explicit reviewed platform User/member resolution modes;
- trusted active same-tenant Client/member/User capture and revalidation;
- bounded identity, access, duplicate, policy, Event/date and Project-type exception routing;
- exact submission row locking and ordered global-email, tenant-fingerprint and
  tenant/Client/Project advisory locks;
- serializable, bounded-retry, atomic Client/User/member/Project/delivery provisioning;
- transactional completion, exception and entity audit evidence;
- idempotent completed-result replay and injected rollback seams;
- service-level guards preventing aligned submissions from entering the three legacy
  approval procedures.

The engine is not called by a router, confirmation handler, token flow, form or UI. R3-C
remains responsible for integration.

## 3. Application Files

```text
src/modules/fund/lib/project-types.ts
src/modules/fund/lib/project-intake-policy.ts
src/modules/fund/lib/project-intake-policy.test.ts
src/modules/fund/services/project-intake-provisioning.service.ts
src/modules/fund/services/client-members.service.ts
src/modules/fund/services/client-dashboard.service.ts
src/modules/fund/services/project-intake.service.ts
scripts/verify-fund-1p-g-r3-b-services.ts
scripts/run-fund-1p-g-r3-b-service-tests.ts
```

No Prisma schema, migration, router, API route, component, email or storage file changed.

## 4. Runtime Contract

Automatic provisioning accepts only a confirmed, current, version-1 aligned submission.
It uses the saved form as Event/standalone and Project-type authority. Existing-Client
automation requires the exact server-captured Client/member pair and revalidates active
tenant ownership, linked active User, dashboard access and `PROJECT_MANAGER`/`ADMIN`
access.

A safe new-Client result creates one active Client, active primary Project Manager member,
login-capable User, Client-owned draft Project and initial delivery profile, then records
complete provisioning evidence in the same transaction. Stable business conflicts commit
only bounded exception/audit evidence. Infrastructure errors remain errors and roll back.

Existing active Users retain name, display name, phone, role, status and preferences. The
automatic resolver may only fill missing email verification from confirmation evidence.
Suspended, deactivated, deletion-requested, cross-tenant or conflicting identities are not
reactivated or attached.

## 5. Concurrency And Failure Safety

The implementation applies:

```text
exact tenant/form/submission SELECT ... FOR UPDATE
global normalized-email advisory lock
tenant/fingerprint advisory lock
tenant/Client/normalized-Project/Event/date advisory lock
SERIALIZABLE transaction
3-attempt serialization/deadlock retry
5-second acquisition wait / 20-second transaction timeout
```

Repeated completion returns the exact recorded result. Competing duplicate submissions
cannot both create operational outcomes. Injected failures after Client, User, member,
Project and delivery stages leave no operational or completion residue.

## 6. Validation Completed

Passed:

- TypeScript type-check and critical-file verification;
- five focused version-1 policy tests;
- production/script focused ESLint;
- dormant boundary/static service verifier;
- Commerce A1, FUND C1/C2/C3/C4/C5 and R3-A static/schema regressions;
- complete 134-migration inventory check;
- automatic new-Client and trusted existing-Client provisioning;
- safe same-tenant active-User reuse without profile/security mutation;
- cross-tenant, suspended, deletion-requested and membership-conflict protections;
- trusted C1 actor enforcement, rejection of non-admin/missing actors, explicit pending-User
  activation and preservation of reviewed exception history;
- same-submission concurrency/idempotency and cross-submission fingerprint concurrency;
- changed-policy, duplicate and legacy/manual routing;
- all five injected transaction rollback stages;
- transactional audit/result consistency and zero fixture/User/audit residue;
- application and documentation `git diff --check`.

The co-located Vitest file is intentionally outside this repository's type-aware ESLint
project include. It passed under Vitest; every production and script file passed focused
ESLint.

## 7. Database Safety

Only the retained Neon database configured by `TEST_DATABASE_URL` was used. The runner
parsed and compared the complete test and shared database target identities before any
write and printed only a redacted target fingerprint. It verified 134 applied and zero
failed migrations, created one isolated tenant family, then cascade-cleaned it and all
test Users/audits.

No shared development, staging or production database was contacted or modified.

## 8. Excluded Work

R3-B adds no:

- Prisma schema or migration;
- public or C1 route/procedure integration;
- confirmation invocation or token consumption;
- request rate-limit middleware;
- form or exception-review UI;
- email or notification;
- Store, Commerce, payment, production or commission behavior;
- generic C1/K2 Project-creation remediation.

## 9. Handoff

R3-B is complete through implementation and independent review/test. Its application is
committed at `04da074`; its documentation lifecycle is included in the current IsoDocs
baseline. No shared deployment is claimed.

Stop here. R3-C and every other slice remain unstarted and unauthorised.
