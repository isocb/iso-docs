# PLAT-ASSURE-03 Dev/Staging Promotion And Human Smoke Checkpoint

Date: 2026-07-27

Status: COMPLETE — dev/staging promotion, exact Security Scans and complete signed-out/
authenticated human smoke PASS; no production promotion performed or authorised

Authoritative Platform review:

`docs/platform/05-review-and-test/2026-07-27-isostack-platform-plat-assure-03-auth-dependency-and-audit-gate-security-remediation-review-and-test.md`

Human schedule:

`docs/platform/05-review-and-test/2026-07-27-isostack-platform-plat-assure-03-auth-session-and-routing-staging-human-smoke-test-schedule.md`

## 1. Promotion Boundary

Application local/remote branches:

```text
dev:     df40f45c
staging: df40f45c
main:    b9287ffa
```

The bundle contains the intentional legacy environment-reference deletion plus
`PLAT-ASSURE-03`. There is no Prisma/schema/migration or runtime-environment change.

## 2. Security And Deployment Evidence

- initial merged dev `d2b303a5`: scan `30259810543` failed at npm 10 clean install because the
  npm 11 lock omitted optional esbuild platform packages;
- correction `df40f45c`: lock regenerated and clean-installed under Node 22/npm 10.9.4;
- exact dev Security Scan `30260022945`: PASS;
- exact staging Security Scan `30260218731`: PASS;
- Render staging assets: last modified 11:02:22 UTC after the staging push; and
- health: HTTP 200, database connected, RLS enabled on 11/11 tables.

## 3. Smoke Disposition

Signed-out Platform/SeasonPro routing, login surfaces, callback preservation, session null
response, malformed bearer handling and absence of private protected content all pass.

The authorised human tester subsequently completed the Platform owner, tenant owner/admin,
LMSPro C1, LMSPro C2 and representative FUND scenarios in desktop Vivaldi, Chrome and
Safari. Ordinary sign-in, shared/module entry, copied-URL tenant isolation, sign-out,
expiry/revocation and impersonation stop/sign-out pass. No remediation-attributable
browser-console error was reported; no separate console export was retained.

Two pre-existing supplemental findings remain open:

- Platform `PLAT-REFINE-03` / FUND `2R-ACCESS-01`: an LMSPro-only user can render the
  static FUND shell by direct URL, while mutations refuse access and no cross-tenant access
  was observed; and
- Platform `PLAT-REFINE-04`: P1 impersonation routes correctly but does not consistently
  reproduce the selected tenant's established data because effective identity and RLS
  context are not consumed uniformly.

The bounded `PLAT-ASSURE-03` staging human gate is complete. The findings remain controlled
roadmap scope and are not treated as acceptable behaviour or silently closed.

No application main, live service, live database or production environment was changed.
This checkpoint records staging completion only and does not authorise production
promotion.
