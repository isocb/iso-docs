# IsoStack Platform PLAT-ASSURE-03 Auth Dependency And Audit-Gate Security Remediation Confirmation

Date: 2026-07-27

Status: Implemented and locally verified on dedicated branch; dev integration, online Security
Scan and staging human smoke pending

Planning control:

`docs/platform/03-slice-planning/2026-07-27-isostack-platform-plat-assure-03-auth-dependency-and-audit-gate-security-remediation-planning.md`

## 1. Exact Implementation Boundary

Application branch:

`fix/security-dependency-audit-and-auth-session-hardening`

Application commit:

`dc616c85`

The branch is pushed to `origin`. Application `dev` and `origin/dev` were separately
fast-forwarded to the documentation-only baseline `f2b794da`; they do not yet contain this
security commit.

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

Using a clean install under Node `22.23.1` and npm `11.6.0`:

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

## 4. Pending Gates

1. integrate the separate security commit into `dev` under the accepted branch workflow;
2. record the exact promoted `dev` Security Scan;
3. deploy that exact accepted commit to staging; and
4. execute and record the required auth/session/routing human smoke.

No staging or production promotion is authorised by this confirmation.
