# FUND Phase 1 Slice 1P-G-R3-D-R1 - Project Creation Contract Alignment Review And Test

Date: 2026-07-14

Status: Passed / implementation and disposable PostgreSQL lifecycle complete

Implementation confirmation:

`docs/modules/fund/04-implementation-confirmations/2026-07-14-phase-1-slice-1p-g-r3-d-project-creation-contract-alignment-implementation-confirmation.md`

## 1. Review Scope

Reviewed the R3-D schema, migration, shared aggregate service, C1/C2 dashboard integration,
Client address management, Intake mechanical alignment, typed Product eligibility and
legacy-writer retirement against the accepted plan.

## 2. Disposable Database Safety And Migration

The test runner proved `TEST_DATABASE_URL` differs from `DATABASE_URL` before connecting.
Only the direct disposable Neon endpoint was used.

Passed:

- representative 134-to-135 migration application;
- exactly 135 applied and zero failed migrations;
- full reset and fresh replay of all 135 migrations;
- unrelated platform/LMSPro migration history replay;
- explicit migration-precondition rejection when a FUND Client exists;
- final cleanup with no R3-D fixture residue.

No shared development, staging or production database was changed.

## 3. Contract And Integration Evidence

`scripts/run-fund-1p-g-r3-d-integration-tests.ts` passed:

- structured Client address and database country/nonblank constraints;
- exact Client/organiser member identity;
- typed Project type;
- atomic Project and delivery-profile creation with copied address/contact defaults;
- transactional Client/Event/organiser/delivery audit evidence;
- Event window and date-order rejection;
- cross-Client organiser rejection;
- exact sequential idempotent retry;
- changed-evidence key rejection;
- concurrent retry convergence after bounded serializable `P2034` retry;
- injected post-delivery failure rolling back Project, delivery and audit together;
- zero-residue teardown.

The first concurrency run exposed PostgreSQL's expected serializable write-conflict case.
The implementation was corrected to retry only `P2034`, at most three transactions. The
complete suite then passed.

## 4. Regression Evidence

Passed after migration 135:

- the complete R3-B policy/provisioning/identity/concurrency/rollback disposable suite;
- the complete R3-C form/confirmation/exception-review disposable suite with the standard
  `react-server` Node condition, external email disabled and historic free-text Intake
  remaining review-only;
- R3-A, R3-B and R3-C static contract verification;
- Commerce A1 and FUND C1/C2/C3/C4/C5 schema verifiers;
- the new R3-D static contract verifier;
- Prisma format, validate and generate;
- `npm run type-check`;
- `npm run verify`;
- focused ESLint with zero errors;
- `git diff --check`.

Focused lint retains warnings already present in the large Client/Project detail surfaces
and warnings for deliberately dormant historic approval helpers; no lint error remains.

## 5. Scope Verdict

R3-D stays within its accepted boundary. It changes the FUND Project-creation contract and
the Client address data needed to make that contract valid. It does not begin Store 1R-D,
Commerce A2, FUND 1R-C6 or any LMSPro work.

## 6. Review Result

`1P-G-R3-D-R1` passes. The all-source non-Intake Project-creation gap is closed. Application
commit `e1c2d9f` is included on `origin/dev` at `3206199`; shared-environment deployment
remains a separate release action and is not claimed here.

Commerce A2 is now complete on `origin/dev` at `3206199`. The created FUND `1R-C6 - FUND
Commerce Context Foundation` plan is the single next review action; Store `1R-D - Store
Readiness And C1 Store Configuration API/Services` remains queued behind it.
