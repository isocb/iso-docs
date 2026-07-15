# FUND Phase 1 Slice 1R-E-A - Store Authority, Exceptional Intervention And Lifecycle Service Alignment Implementation Confirmation

Date: 2026-07-15

Status: Implemented and validated on disposable PostgreSQL / application `dev` and `origin/dev` at `daafc349` / no shared database deployment

Planning record:

`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-e-a-store-authority-exceptional-intervention-lifecycle-service-alignment-implementation-planning.md`

Review/test record:

`docs/modules/fund/05-review-and-test/2026-07-15-phase-1-slice-1r-e-a-r1-store-authority-exceptional-intervention-lifecycle-service-alignment-review-and-test.md`

## 1. Implemented Boundary

Implemented only the accepted Store-authority alignment:

- typed, tenant-owned C1 exceptional Store intervention evidence;
- C2 Project Store intent and Project lifecycle authority for exact Client members;
- one fail-closed server-derived effective-state, readiness and allowed-action policy;
- Event default and non-cascading outer-envelope enforcement;
- C1 exceptional pause/release and closure/reopen with immutable resolution evidence;
- Store preparation, refresh, copy, ordering, visibility and Product-selection access for
  authorised C2 Project members;
- retirement of persistent `CLOSED`/`closedAt` Store semantics; and
- A7 initial submission and failed/expired retry consumption of the same Store
  availability policy before Commerce or provider mutation.

No C1/C2 UI, public Store or Checkout route, real Stripe action, Product/Catalogue
commercial editor, artwork/template workflow, upload, Order operation, production,
fulfilment or commission behaviour was added.

## 2. Schema And Migration

Added only:

- `FundProjectStoreInterventionKind`;
- `FundProjectStoreInterventionReason`;
- `FundProjectStoreInterventionResolution`;
- `FundProjectStoreEffectiveState`;
- `FundProjectStoreIntervention` and exact Organization/User/Project/Store reverse
  relations; and
- migration
  `20260716003000_fund_1r_e_a_store_authority_intervention_foundation`.

The migration has a fail-before-change preflight for any Store with status `CLOSED` or a
non-null `closed_at`. It applies zero semantic backfill. It adds exact same-tenant foreign
keys, chronology and resolution checks, one-active-intervention partial uniqueness,
separate start/resolution idempotency uniqueness, immutable identity/resolution triggers,
restrictive deletion and the Store constraint that retires `CLOSED`/`closedAt`.

## 3. Internal Authority Services

`store-authority.service.ts` is the single internal policy boundary for effective Store
state, blockers and allowed actions. It evaluates Project lifecycle and dates, Event
envelope validity, Store intent, C1 intervention precedence, Store/Product readiness,
Seller Profile and local A6-B payment readiness.

C1 OWNER/ADMIN actors can start and resolve only typed exceptional interventions. Closure
truthfully supersedes a current exceptional pause; releasing or reopening removes only the
C1 overlay and never forces the C2 Store open.

Exact C2 Client members receive:

- VIEWER read access;
- PROJECT_MANAGER/ADMIN Project activation, pause and resume;
- PROJECT_MANAGER/ADMIN Store preparation, refresh, copy, ordering, visibility,
  Product-selection and publish/pause/resume; and
- no Product commercial, Product source-presentation or readiness-authority write.

All authority-changing operations use exact tenant/Client/Project/Store validation,
serializable Project locking, bounded idempotency and redacted transactional audit.

## 4. Compatibility And Safety

Existing `PAUSED` remains C2 Store intent. `CLOSED` is no longer a valid service
transition, archive refuses an active intervention and Project archive refuses a Project
whose Store has an active intervention. Event-date changes lock linked Projects and reject
an envelope that would exclude any explicit Project window; no Project date is cascaded.

`FundProject.lifecycleState` and mutable metadata remain non-authoritative. Dormant A7
uses the same effective policy before both initial submission and retry, while retaining
its existing no-route/no-real-provider boundary.

## 5. Application Files

```text
prisma/schema.prisma
prisma/migrations/20260716003000_fund_1r_e_a_store_authority_intervention_foundation/migration.sql
src/modules/fund/services/store-authority.service.ts
src/modules/fund/services/store-management.service.ts
src/modules/fund/services/store-checkout.service.ts
src/modules/fund/services/client-dashboard.service.ts
src/modules/fund/services/events.service.ts
src/modules/fund/services/projects.service.ts
src/modules/fund/routers/store-management.router.ts
src/modules/fund/routers/client-dashboard.router.ts
src/modules/fund/lib/store-configuration.ts
src/modules/fund/lib/validation/store-management.ts
src/modules/fund/lib/validation/client-dashboard.ts
scripts/check-fund-1r-e-a-test-baseline.ts
scripts/run-prisma-on-test-database.ts
scripts/run-fund-1r-e-a-store-authority-tests.ts
scripts/run-fund-1r-d-store-service-tests.ts
scripts/run-commerce-a7-fund-consumer-integration-tests.ts
```

## 6. Validation Outcome

Passed:

- representative 140-to-141 migration;
- complete fresh replay of all 141 migrations;
- preflight refusal and rollback-before-evidence proof;
- intervention, supersession, resolution, idempotency, immutability and deletion checks;
- tenant, actor, Client member, Project, Store and Event-envelope authority checks;
- effective-state/readiness/action, concurrency and injected rollback checks;
- C2 Store-management and Project-lifecycle service tests;
- retained 1R-D and A7 disposable-database regressions;
- Prisma validation and client generation;
- TypeScript type-check, targeted unit/static verification and production build; and
- zero reserved test residue.

The first representative migration attempt exposed an incorrect assumption about the
physical public User foreign-key column name. The disposable migration was marked rolled
back, the SQL was corrected from an inferred snake-case name to the actual
`public.users."organizationId"` contract, and both the representative upgrade and full
fresh replay then passed. No shared database was contacted.

## 7. Database And Deployment State

The test runners proved `TEST_DATABASE_URL` differed from `DATABASE_URL` before database
access. Only the retained disposable test database was migrated and tested. It finished at
141 applied migrations, zero failed migrations and zero E-A/A7/1R-D reserved test residue.

Application `dev` and `origin/dev` contain E-A at `daafc349`. The shared Neon development
database and application/database staging remain at the previously promoted
`91e8751c`/140-migration boundary. Production remains unchanged. Applying migration 141 to
a shared database requires a separate controlled database promotion.

GitHub `Security Scan` run `29417617533` passed for exact commit `daafc349` after the
`origin/dev` push.

## 8. Handoff

E-A is complete through implementation confirmation and review/test. The bounded `1R-E-B
- C1 Store Portfolio Oversight And Exceptional Intervention Surface` plan is created and
awaiting explicit review. It is not accepted or authorised for implementation by this
record.
