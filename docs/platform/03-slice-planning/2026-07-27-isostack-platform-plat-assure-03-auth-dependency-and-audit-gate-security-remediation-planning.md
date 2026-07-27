# IsoStack Platform PLAT-ASSURE-03 Auth Dependency And Audit-Gate Security Remediation Planning

Date: 2026-07-27

Status: Accepted bounded corrective slice; implementation authorised

Triage:

`docs/platform/02-triage/2026-07-27-isostack-platform-auth-dependency-and-audit-gate-security-remediation-triage.md`

Human staging schedule:

`docs/platform/05-review-and-test/2026-07-27-isostack-platform-plat-assure-03-auth-session-and-routing-staging-human-smoke-test-schedule.md`

## 1. Objective

Clear the current critical/high dependency findings and make the npm-audit workflow fail closed
without weakening its accepted high/critical policy, while preserving shared authentication and
routing behaviour after the supported Auth.js/NextAuth update.

## 2. Implementation Boundary

In scope:

- `package.json` and `package-lock.json`;
- `.github/workflows/security-scan.yml`;
- `scripts/security/check-npm-audit-report.mjs` and focused tests;
- only authentication checks directly requiring a concrete `session.user` after the dependency
  update; and
- matching Platform lifecycle evidence.

Out of scope:

- framework downgrade, `npm audit fix --force`, audit suppression or threshold reduction;
- schema, migrations, databases, environment values or provider credentials;
- authentication redesign, role redesign or tenant-scope changes;
- unrelated application/module behaviour; and
- staging or production deployment from this plan alone.

## 3. Settled Technical Contract

1. Pin supported patched Auth.js adapter and NextAuth versions rather than accepting a moving beta
   range.
2. Resolve PostCSS and `brace-expansion` to patched versions compatible with the Node 22 baseline.
3. Capture the actual `npm audit` exit status as retained evidence.
4. Accept only npm audit report version 2 with complete, non-negative and internally consistent
   severity counts.
5. Treat unexpected audit exit codes, invalid JSON and missing/inconsistent metadata as gate
   failures.
6. Continue blocking high/critical findings while reporting moderate/low/info findings.
7. Treat a session as authenticated only when `session.user` exists at affected shared guards.

## 4. Required Automated Evidence

1. focused audit-parser tests cover pass, block and fail-closed paths;
2. `npm audit --audit-level=moderate` reports zero vulnerabilities;
3. `npm ls` reports a valid patched dependency tree;
4. TypeScript passes;
5. critical-file verification passes;
6. the full Vitest suite passes subject only to established intentional skips;
7. the complete production build passes;
8. `git diff --check` passes; and
9. the exact promoted `dev` commit passes the online Security Scan.

## 5. Human And Promotion Gates

Automated success does not prove shared sign-in and redirect behaviour. After the exact commit is
deployed to staging, the responsible tester must execute the linked human schedule across public,
Platform, LMSPro and FUND entry paths with representative authorised roles.

The slice stops after technical review and `dev` promotion until that staging evidence is PASS.
No production promotion is authorised here.
