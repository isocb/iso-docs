# FUND Phase 1 Slice 1P-G-R3-C - Project Intake Form, Confirmation And Exception-Review Alignment Implementation Confirmation

Date: 2026-07-14

Status: Implemented and validated / application committed and promoted to `origin/dev` at `234f115` / shared databases undeployed

Planning record:

`docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1p-g-r3-c-project-intake-form-confirmation-exception-review-alignment-implementation-planning.md`

Review/test record:

`docs/modules/fund/05-review-and-test/2026-07-14-phase-1-slice-1p-g-r3-c-r1-project-intake-form-confirmation-exception-review-alignment-review-and-test.md`

## 1. Entry Baseline

R3-C began from separately committed baselines:

```text
application R3-B baseline: 04da074
IsoDocs R3-B lifecycle/R3-C accepted-plan baseline: 6964b58
database baseline: 134 applied migrations / 0 failed
```

R3-C changes no Prisma schema or migration.

## 2. Implemented Boundary

Implemented the accepted integration only:

- explicit version-1 Event/standalone, automatic/review-first and fixed/selectable
  Project-type configuration in existing C1 form management;
- canonical form-policy revision calculation and activation validation;
- exact Organization/form public lookup through canonical shared-host routes and trusted
  tenant-domain routing;
- typed Project, Client address and organiser evidence for aligned forms;
- preserved free-text address and review-only confirmation behavior for historic
  null-contract forms;
- optional-session eligible Client selection using exact active K1-F membership authority;
- server-written acknowledgement evidence, bounded honeypot/time checks and rate-limited
  submit/confirm/resend entry points;
- locked form-capacity reservation, expiry release, evidence-bound idempotency and a
  domain-separated `v1` HMAC fingerprint;
- hash-only confirmation/resend tokens and public-safe created/review/error outcomes;
- serializable confirmation and R3-B provisioning in one transaction;
- one protected C1 reviewed-resolution path with audited typed corrections;
- immutable confirmed email, original raw evidence and fingerprint;
- explicit rejection of aligned rows by legacy approval and return-to-review writers.

## 3. Runtime Contract

New forms are explicitly aligned at creation. Existing null-contract forms remain legacy
until deliberately replaced or aligned by a future controlled action. An aligned form
snapshots its contract and policy revision at submission. Confirmation consumes the token
and invokes R3-B atomically; automatic success creates the accepted Client/member/User/
Project/delivery result, while intentional review or a bounded exception exposes only a
public-safe review outcome.

C1 reviewed resolution uses R3-B with exact actor/tenant authority. Corrections are limited
to accepted typed business evidence. The confirmed email cannot be replaced, and raw
payload/fingerprint evidence is retained.

## 4. Public And C1 Surfaces

Canonical shared-host routes use:

```text
/fund/project-initiation/by/{organizationSlug}/{formSlug}
```

The existing slug-only route family remains available only when middleware supplies a
trusted `x-organisation-id`; it resolves the Organization slug server-side. Public lookup
never trusts a form slug alone.

The C1 submission detail identifies aligned contract/revision and bounded exception
evidence. Its approval page routes aligned rows through protected reviewed provisioning;
historic rows retain their legacy UI/procedures.

## 5. Database And Email Safety

Only the retained disposable Neon target configured by `TEST_DATABASE_URL` was used. The
runner parsed and compared full test/shared database identities before connecting and
printed only a redacted target fingerprint. External email was disabled; confirmation and
resend delivery were captured through the existing not-configured result.

Final evidence:

```text
applied migrations: 134
failed migrations: 0
R3-C Organization/User residue: 0
```

No shared development, staging or production database was contacted or modified.

## 6. Validation Completed

Passed:

- TypeScript type-check;
- focused changed-file ESLint with zero errors/warnings;
- R3-C static integration verifier;
- complete R3-C disposable integration lifecycle;
- complete R3-B policy/provisioning/concurrency/rollback regression lifecycle;
- Commerce A1, FUND C1/C2/C3/C4/C5, R3-A and R3-B static/schema regressions;
- unchanged 134-migration inventory and no Prisma diff;
- application and documentation `git diff --check`.

The repository-wide lint command remains red because of pre-existing unrelated Bedrock,
Import and LMSPro JSX lint errors. No changed R3-C production file has a focused lint
error or warning.

## 7. Excluded Work

R3-C adds no migration, Store, Commerce, payment, upload, production, commission, generic
C1/K2 Project-creation remediation, invitation/onboarding email or real iframe/CSP
behavior. It activates no real form and performs no deployment.

## 8. Handoff

R3-C is complete through implementation and review/test. Its application is committed and
promoted to `origin/dev` at `234f115`. No staging/main promotion, shared database change or
real-form activation is claimed.

The R3-A/R3-B/R3-C Intake alignment lifecycle is now complete. The separate generic C1/K2
Project-creation gap remains and should be planned as `1P-G-R3-D - Project Creation
Contract Alignment` before selecting Commerce A2. R3-D is a planning candidate only and
has not been started by this implementation.
