# LMSPro R8-A2R-F1 Dev Promotion And Staging Security-Gate Blocker Confirmation

Date: 2026-07-22

Status: Security blocker resolved; exact corrected dev/staging commit passed; human staging
test pending

## 1. Scope

This record confirms the controlled promotion attempt for:

`R8-A2R-F1 - Draft Resource State Rehydration And Attachment Transport Correction`

It records repository alignment, local verification, development promotion and the exact
online gate that prevented staging promotion. It does not claim staging deployment, human
UI acceptance or production readiness.

## 2. Repository Alignment

Application:

- dedicated branch:
  `fix/lmspro-r8-a2r-f1-draft-resource-correction`;
- correction commit: `c8af7bd3`;
- Platform routing-document commit: `68b92361`;
- `origin/dev` advanced from `3b148a65` to exact commit `68b92361`; and
- the dedicated remote branch also points to `68b92361`.

Documentation:

- the dedicated documentation branch was merged with current `origin/main`;
- documentation main advanced to `558b000`; and
- the LMSPro correction lifecycle, failed precursor UI evidence and first-class Platform
  lifecycle are present in canonical IsoDocs.

## 3. Local Verification Before Promotion

Exact application commit `68b92361` passed:

- full Vitest: 21 files passed, one skipped; 142 tests passed, 12 skipped;
- critical-file verification;
- TypeScript type-check; and
- Next.js production build.

The build emitted the known local warning that Upstash Redis/session-revocation services
were not configured in the local environment. It completed successfully and no environment
setting was changed.

No Prisma schema, migration, database or infrastructure change is included in F1.

## 4. Online Development Security Gate

GitHub `Security Scan` run `29912591540` executed against exact `origin/dev` commit
`68b92361`.

Passed jobs:

- database schema security check;
- secret detection; and
- TypeScript type safety.

Failed job:

- dependency vulnerability scan — zero critical and four high-severity vulnerabilities.

The audit reported current advisories affecting:

- `fast-uri` — two high-severity host-confusion advisories;
- `linkify-it` — high-severity quadratic-complexity denial of service;
- `sharp` — high-severity inherited `libvips` vulnerabilities;
- `esbuild` under `tsx` — an additional advisory reported by the audit; and
- `postcss` under Next.js — a moderate advisory reported below the high/critical gate.

The audit reports non-forced fixes for some transitive packages, while the proposed forced
path for the Next.js/`sharp` chain would install an unsafe breaking Next.js version. No
forced audit fix, dependency override or gate suppression was applied.

## 5. Staging Decision

Staging promotion stopped at the required online security gate.

- `origin/staging` remains at `3b148a65`;
- application `main`, production and the live database remain unchanged;
- no staging merge or push was performed; and
- the F1 human UI/private-R2 retest cannot begin on staging until the dependency gate is
  remediated and the exact promoted dev commit receives a passing Security Scan.

## 6. Required Follow-On

The dependency finding is registered as `PLAT-ASSURE-02` in the Platform Assurance,
Security Review And Refinement Roadmap.

Before staging promotion:

1. reproduce the audit against the current lockfile;
2. determine safe direct/transitive upgrade or override paths without forced framework
   downgrade;
3. run dependency, type, test, build and security regressions;
4. commit and promote the remediation through `dev`;
5. require a passing GitHub Security Scan for the resulting exact commit; and
6. only then align `staging` to that commit for human F1 testing.

## 7. Resolution

The required follow-on completed on 2026-07-22 through bounded Platform slice
`PLAT-ASSURE-02`.

- remediation commit `6c5aaa56` safely resolved the high-severity dependency graph;
- remediation-branch Security Scan `29915521121` passed;
- exact `origin/dev` Security Scan `29915698746` passed;
- `origin/staging` was then fast-forwarded from `3b148a65` to exact commit `6c5aaa56`;
- exact staging Security Scan `29915869540` passed; and
- application `main`, production and every database remain unchanged.

The staging security blocker is therefore closed. LMSPro F1 remains pending the human
staging smoke already defined by its review-and-test evidence. The separately implemented
three-branch scheduled dependency matrix awaits default-branch activation and first-run
evidence before recurring Platform monitoring can be described as fully operational.
