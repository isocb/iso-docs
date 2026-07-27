# IsoStack Platform PLAT-ASSURE-03 Auth Dependency And Audit-Gate Security Remediation Confirmation

Date: 2026-07-27

Status: Implemented through dev and staging at `df40f45c`; exact Security Scans and signed-out
smoke PASS; authenticated staging browser smoke pending

Planning control:

`docs/platform/03-slice-planning/2026-07-27-isostack-platform-plat-assure-03-auth-dependency-and-audit-gate-security-remediation-planning.md`

## 1. Exact Implementation Boundary

Application branch:

`fix/security-dependency-audit-and-auth-session-hardening`

Application commit:

`dc616c85`

The branch is pushed to `origin`. It was merged after documentation-only baseline `f2b794da` at
dev commit `d2b303a5`. Follow-up `df40f45c` restores npm 10 lockfile compatibility without
changing the resolved application dependency versions. Application dev/staging and their remote
counterparts are aligned at `df40f45c`.

## 2. Implemented Change

- Auth.js/NextAuth, Auth Prisma adapter, PostCSS and `brace-expansion` resolve to patched versions.
- Direct dependencies are pinned where a moving beta/range would weaken reproducibility.
- The Security Scan captures and retains the real `npm audit` exit status.
- A dedicated parser accepts only complete, internally consistent npm audit v2 evidence and fails
  closed for invalid JSON, missing metadata, unexpected exit status or inconsistent totals.
- Six focused parser tests cover pass, block and fail-closed paths.
- Affected shared route/page guards now require `session.user` rather than treating a session
  shell without a user as authenticated.

No schema, migration, database, environment value, provider credential or deployment setting
changed.

## 3. Verification Evidence

The initial implementation passed locally under Node `22.23.1` and npm `11.6.0`. The final
promoted lock was then regenerated and clean-installed under the CI-compatible Node `22.23.1`
and npm `10.9.4` baseline:

- `npm ci` passed;
- `npm audit --audit-level=moderate` reported zero vulnerabilities;
- the patched dependency-tree inspection passed;
- focused audit-parser tests passed: 6 of 6;
- full Vitest passed: 26 files passed, 1 intentionally skipped; 168 tests passed,
  12 intentionally skipped;
- critical-file verification and TypeScript passed;
- the complete Next.js `15.5.21` production build passed;
- `git diff --check` passed; and
- repository pre-commit checks passed.

The build emitted the established warnings for intentionally absent local Upstash
Redis/session-revocation configuration. No environment value was changed.

## 4. Promotion And Pending Gate

Exact dev Security Scan `30260022945` and exact staging Security Scan `30260218731` pass for
`df40f45c`. The commit is promoted to staging; Render assets changed at 11:02:22 UTC and the
staging health endpoint returns HTTP 200 with connected database and 11/11 RLS coverage.

The signed-out portion of the auth/session/routing smoke passes. Authenticated P1/C1/C2/FUND
browser scenarios remain NOT RUN. No production promotion is authorised by this confirmation.
