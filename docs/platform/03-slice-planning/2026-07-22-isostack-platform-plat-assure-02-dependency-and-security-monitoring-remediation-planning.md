# IsoStack Platform PLAT-ASSURE-02 Dependency And Security Monitoring Remediation Planning

Date: 2026-07-22

Status: Accepted bounded corrective slice; implementation authorised by the user

Parent control:

`docs/platform/00-roadmap-control/2026-07-22-isostack-platform-assurance-security-review-and-refinement-roadmap.md`

Promotion blocker evidence:

`docs/00-roadmap-control/2026-07-22-lmspro-r8-a2r-f1-dev-promotion-and-staging-security-gate-blocker-confirmation.md`

## 1. Purpose

This slice removes the high-severity dependency findings that block the exact LMSPro
`R8-A2R-F1` dev commit from promotion and repairs the Security Scan coverage that allowed
new advisories to become visible only when `dev` was pushed.

It is a Platform assurance correction. It must not change LMSPro email behaviour, FUND
behaviour, schema, migrations, databases, environment configuration or deployment
settings.

## 2. Confirmed Emergence Timeline

The dependency graph passed online audit at 14:17 UTC on 2026-07-21. Four new high-severity
advisories affecting the existing graph were then published between 19:03 UTC and 22:08
UTC. The scheduled `main` scan detected dependency failure at 07:48 UTC on 2026-07-22 and
the next `dev` push detected zero critical and four high dependency nodes at 10:37 UTC.

No `package.json` or `package-lock.json` change occurred between the last green `dev`
commit and the first red `dev` commit. The LMSPro F1 correction did not introduce the
affected packages.

## 3. Settled Technical Decisions

1. Do not use `npm audit fix --force`, downgrade Next.js or weaken the high/critical gate.
2. Advance vulnerable transitive packages only to supported patched releases accepted by
   their parent ranges.
3. Resolve Next.js's optional Sharp dependency to patched `sharp@0.35.3` through a narrow,
   documented override while stable Next still requests `^0.34.x` and upstream canary has
   adopted `^0.35.3`.
4. The Sharp override is accepted only if a clean Node 22 install, dependency-tree check,
   production build and regression suite prove the resolved runtime.
5. Add `dev` to pull-request Security Scan coverage.
6. Scheduled dependency monitoring must inspect `main`, `staging` and `dev` independently,
   retain per-branch audit evidence and run all branches even when one fails.
7. Scheduled monitoring remains a high/critical gate. Lower severities remain visible in
   retained audit evidence and the monthly Platform assurance review.
8. Staging remains unchanged until the exact corrected `dev` commit passes the online
   Security Scan.

## 4. Bounded Implementation

Application repository work is limited to:

- `package.json` and `package-lock.json` dependency resolution;
- `.github/workflows/security-scan.yml` branch coverage, scheduled dependency matrix,
  evidence naming and accurate high/critical gate wording; and
- focused test support only if required to prove Sharp/Next compatibility.

Documentation work is limited to this plan, an implementation confirmation, review/test
evidence, blocker reconciliation and Platform/root roadmap status.

## 5. Required Verification

The implementation must prove:

1. a clean Node 22 `npm ci` succeeds;
2. `npm audit` reports zero high and zero critical findings;
3. `npm ls` resolves patched `fast-uri`, `linkify-it`, `sharp` and `tsx`/`esbuild` paths
   without invalid or duplicate vulnerable Sharp resolution;
4. the complete Vitest suite passes subject only to established intentional skips;
5. critical-file verification and TypeScript type-check pass;
6. a production Next.js build passes and exercises Sharp loading through the installed
   Next runtime;
7. the workflow is syntactically valid and scheduled matrix jobs identify `main`,
   `staging` and `dev` separately;
8. the dedicated remediation branch passes an online manually dispatched Security Scan;
9. the exact promoted `dev` commit passes its push-triggered Security Scan; and
10. `origin/staging` does not move before item 9 succeeds.

## 6. Promotion And Rollback

The implementation begins on
`fix/platform-plat-assure-02-security-gate`, based on exact `origin/dev` commit
`68b92361`.

If clean install, Sharp loading, build, tests or the online gate fail, the remediation must
remain on the dedicated branch and staging must remain at `3b148a65`. No audit suppression,
canary Next adoption or live promotion is an implicit fallback.

After an exact `dev` commit is green, the existing controlled dev-to-staging promotion may
resume for LMSPro F1 human testing. Production promotion remains separately controlled.
