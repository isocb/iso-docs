# FUND Phase 1 Slice 1P-G-R3-C-R1 - Project Intake Form, Confirmation And Exception-Review Alignment Review And Test

Date: 2026-07-14

Status: Passed / integration and disposable PostgreSQL lifecycle complete

Implementation confirmation:

`docs/modules/fund/04-implementation-confirmations/2026-07-14-phase-1-slice-1p-g-r3-c-project-intake-form-confirmation-exception-review-alignment-implementation-confirmation.md`

## 1. Review Scope

Reviewed the bounded R3-C implementation for explicit alignment, policy revision,
tenant-safe public routing, typed capture, optional-session authority, capacity reservation,
idempotency, fingerprinting, confirmation/resend safety, atomic R3-B invocation, public
data minimisation, reviewed correction, legacy separation and zero schema change.

## 2. Static And Application Evidence

Passed:

```text
npm run type-check
npx tsx scripts/verify-fund-1p-g-r3-c-integration.ts
focused ESLint for every changed R3-C production file
git diff --check
```

The static verifier confirms exact Organization/form routing, optional-session authority,
submit/resend rate protection, version-1 acknowledgement/fingerprint contracts,
serializable row locking, in-transaction R3-B invocation, uniform public confirmation
errors, legacy-writer guards, typed/free-text form separation and immutable-email UI.

## 3. Disposable Integration Evidence

`scripts/run-fund-1p-g-r3-c-integration-tests.ts` proved:

- `TEST_DATABASE_URL` differs from `DATABASE_URL` before connection;
- the database remains at exactly 134 applied and zero failed migrations;
- aligned submit writes typed address, contract/revision, hash-only confirmation token and
  `v1` HMAC fingerprint evidence;
- same evidence/idempotency retries return the same row and changed evidence is rejected;
- a mismatched Organization/form route is rejected;
- confirmation and automatic R3-B provisioning commit atomically with one Project result;
- a consumed token cannot be reused and unknown/consumed failures share the generic public
  outcome;
- review-first confirmation exposes only `REVIEW_REQUIRED`;
- aligned rows are rejected by the legacy return-to-review path;
- protected reviewed resolution preserves confirmed email and original fingerprint while
  applying an allowed audited typed correction;
- a live pending confirmation occupies form capacity, an expired reservation releases it,
  and resend rotates hash/expiry without external delivery;
- historic null-contract capture retains its free-text address and confirmation remains
  review-only with no Project provisioning;
- final cascade cleanup leaves zero R3-C Organization/User residue.

External email was disabled throughout. The runner captured the existing
not-configured-email result and never contacted an email provider.

## 4. R3-B And Prior-Slice Regressions

The complete R3-B disposable service runner passed again after connection through R3-C:

- new/existing Client and User/member protection;
- reviewed authority and activation rules;
- same-submission and cross-submission concurrency;
- changed-policy, duplicate and legacy routing;
- injected rollback after Client, User, member, Project and delivery stages;
- transactional audit consistency and zero residue.

Static regressions passed for Commerce A1, FUND C1/C2/C3/C4/C5, R3-A and R3-B. No Prisma
schema or migration file changed.

## 5. Review Findings Resolved

Testing exposed and resolved two material issues:

1. Remote serializable confirmation plus provisioning could exceed Prisma's five-second
   default interactive transaction timeout. The bounded Intake transactions now use a
   10-second acquisition wait and 30-second transaction timeout.
2. The broad historic return-to-review writer still accepted an aligned row. It now rejects
   every non-null submitted contract so aligned review can only use the R3-B-backed path.

Review also restored exact historic form compatibility: null-contract forms render and
store the former free-text address rather than being forced into the version-1 typed
address contract.

## 6. Lint Qualification

Focused ESLint passes for all changed R3-C production files. Repository-wide `npm run
lint` still fails on unrelated pre-existing JSX escaping errors in Bedrock, Import and
LMSPro pages. These files were not modified by R3-C and are not masked as a passing global
result.

## 7. Scope Verdict

R3-C remains within scope: no schema/migration, Store, Commerce, payment, upload,
production, commission, generic Project-creation remediation, invitation email or real
iframe behavior was added. No form was activated and no shared environment was changed.

## 8. Review Result

`1P-G-R3-C-R1` passes. R3-C is complete through implementation confirmation and
review/test and is committed/promoted to application `origin/dev` at `234f115`. It remains
undeployed to staging/main and shared databases, and must stop here.

The next candidate is planning only for `1P-G-R3-D - Project Creation Contract Alignment`
to reconcile generic C1/K2 internal-dashboard Project creation. It has not been started.
