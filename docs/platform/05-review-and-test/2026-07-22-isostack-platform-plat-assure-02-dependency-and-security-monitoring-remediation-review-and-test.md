# IsoStack Platform PLAT-ASSURE-02 Dependency And Security Monitoring Remediation Review And Test

Date: 2026-07-22

Status: Technical review passed; staging human LMSPro F1 smoke remains required

Implementation confirmation:

`docs/platform/04-implementation-confirmations/2026-07-22-isostack-platform-plat-assure-02-dependency-and-security-monitoring-remediation-confirmation.md`

## 1. Review Result

The bounded Platform correction passes technical review. The high-severity dependency
promotion blocker is removed without a forced framework downgrade, canary adoption,
audit suppression or reduced gate severity.

The implementation is confined to the dependency graph and Security Scan workflow. No
module behaviour, schema, migration, environment setting or database state changed.

## 2. Local Evidence

Exact application commit `6c5aaa56` passed:

- clean dependency installation using Node `22.22.0` and npm `10.9.4`;
- resolved dependency-tree validation;
- Sharp runtime encode/decode smoke: Sharp `0.35.3`, libvips `8.18.3`, one-pixel PNG
  metadata returned correctly;
- npm audit: zero critical, zero high, three moderate;
- full Vitest: 21 files passed, one skipped; 142 tests passed, 12 skipped;
- critical-file verification;
- TypeScript type-check;
- workflow YAML parse, Prettier check and `git diff --check`; and
- complete Next.js `15.5.21` production build.

The build repeated the established local warnings for absent Upstash Redis/session
revocation configuration. It completed successfully and no environment value was changed.

## 3. Online Evidence

The following exact-commit Security Scans passed:

| Context | Run | Result |
| --- | --- | --- |
| Dedicated remediation branch | `29915521121` | Pass |
| `dev` push | `29915698746` | Pass |
| `staging` push | `29915869540` | Pass |

For the dev and staging push runs, ordinary Gitleaks, dependency audit, Prisma/schema and
TypeScript jobs all passed. This proves the result is not dependent on only the bounded
manual Gitleaks mode.

## 4. Deferred Operational Evidence

The scheduled protected-branch matrix can execute only after the workflow definition is
present on default branch `main`. Its code is implemented, parsed and accepted by GitHub
on dev/staging events, but the first scheduled `main`/`staging`/`dev` run must be recorded
after a separately authorised main promotion.

This deferred evidence does not re-block LMSPro staging testing because the exact dev and
staging commits have passed the authoritative high/critical gate. It does prevent claiming
that the recurring monitoring correction is fully operational in production.

## 5. Human Staging Test Boundary

The business/testing team should now resume the LMSPro `R8-A2R-F1` staging smoke defined
in:

`docs/modules/lmspro/05-review-and-test/2026-07-22-lmspro-remediation-slice-r8-a2r-f1-draft-resource-state-rehydration-and-attachment-transport-correction-review-and-test.md`

At minimum confirm:

1. staging has deployed exact commit `6c5aaa56`;
2. the communications page loads and normal navigation/authentication remain healthy;
3. PDF/image/TXT/CSV draft attachment and three-link rehydration tests are repeated;
4. the no-attachment and links-only working batch route remains a regression pass; and
5. no production promotion occurs until that human result is recorded.
