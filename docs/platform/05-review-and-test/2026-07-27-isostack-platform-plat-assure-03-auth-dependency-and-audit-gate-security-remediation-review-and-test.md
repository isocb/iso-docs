# IsoStack Platform PLAT-ASSURE-03 Auth Dependency And Audit-Gate Security Remediation Review And Test

Date: 2026-07-27

Status: COMPLETE — technical review, exact dev/staging Security Scans, staging deployment
and complete signed-out/authenticated human browser schedule PASS

Implementation confirmation:

`docs/platform/04-implementation-confirmations/2026-07-27-isostack-platform-plat-assure-03-auth-dependency-and-audit-gate-security-remediation-confirmation.md`

Human staging schedule:

`docs/platform/05-review-and-test/2026-07-27-isostack-platform-plat-assure-03-auth-session-and-routing-staging-human-smoke-test-schedule.md`

## 1. Review Disposition

Commit `dc616c85` conforms to the bounded plan and passes technical review.

The implementation:

- removes the reproduced 2 critical, 19 high and 1 moderate audit result without a forced
  framework downgrade or gate weakening;
- fails closed when npm audit output cannot be trusted;
- retains the accepted high/critical blocking policy;
- limits authentication source changes to concrete `session.user` checks required by the updated
  shared auth contract; and
- introduces no data, migration, tenant-scope, role or environment change.

## 2. Test Assessment

The focused parser tests cover valid non-blocking results, high/critical blocking results,
missing metadata, registry/error-shaped output, unexpected audit exit codes and inconsistent
severity totals.

The clean Node 22 install, zero-vulnerability audit, dependency tree, full tests, TypeScript,
critical-file verification and production build provide proportionate technical evidence for the
dependency and compile/runtime boundary. The successful build includes all affected routes.

## 3. Dev And Staging Evidence

The implementation was merged after `f2b794da` at dev merge commit `d2b303a5`. Its first exact
dev Security Scan `30259810543` failed because the npm 11-generated lock omitted optional
`esbuild@0.28.1` platform entries required by GitHub's npm 10 `npm ci`. The application tests did
not run in that failed workflow.

Bounded follow-up commit `df40f45c` regenerated the lock using Node 22/npm 10.9.4. A clean npm 10
install, zero-vulnerability audit, 168 tests, verification and TypeScript passed. Exact dev
Security Scan `30260022945` and staging Security Scan `30260218731` passed.

Local and remote dev/staging are aligned at `df40f45c`. Render-served staging assets changed at
11:02:22 UTC and subsequent health checks return HTTP 200 with connected database and RLS enabled
on 11 of 11 tables. There is no migration or environment change.

## 4. Human Evidence And Final Disposition

The authorised tester completed the linked schedule in desktop Vivaldi, Chrome and Safari.
Signed-out routing, ordinary authentication, shared/module entry, P1, tenant owner/admin,
LMSPro C1, LMSPro C2, representative FUND, copied-URL tenant isolation, sign-out,
expiry/revocation and impersonation stop/sign-out scenarios pass.

No remediation-attributable browser-console error was reported; no separate console export
was retained.

Two supplemental observations were reviewed and confirmed as pre-existing rather than
introduced by `PLAT-ASSURE-03`:

- an LMSPro-only C1/C2 session can render the static `/app/fund` shell by direct URL,
  although mutations fail with `FORBIDDEN` and no cross-tenant access was observed; this is
  registered under Platform `PLAT-REFINE-03` and FUND `2R-ACCESS-01`; and
- P1 impersonation reaches the expected C1 dashboard but does not consistently reproduce
  the selected tenant's established data; stop/sign-out passes, and the mixed effective
  identity/RLS contract is registered under `PLAT-REFINE-04`.

Neither observation is accepted as correct product behaviour. Their separate registration
preserves controlled follow-up without misclassifying them as regressions in the bounded
dependency and defensive-session change.

Final disposition: **PASS FOR THE BOUNDED PLAT-ASSURE-03 STAGING GATE**. The staging human
evidence is complete. This review does not itself authorise application-main or production
promotion.
