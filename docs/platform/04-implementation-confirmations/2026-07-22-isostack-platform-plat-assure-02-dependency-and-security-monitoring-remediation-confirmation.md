# IsoStack Platform PLAT-ASSURE-02 Dependency And Security Monitoring Remediation Confirmation

Date: 2026-07-22

Status: Implemented through development and staging; scheduled three-branch evidence awaits
activation from the default branch

Planning control:

`docs/platform/03-slice-planning/2026-07-22-isostack-platform-plat-assure-02-dependency-and-security-monitoring-remediation-planning.md`

## 1. Implementation Boundary

Application commit `6c5aaa56` implements the bounded correction on
`fix/platform-plat-assure-02-security-gate` and is the exact current commit of both
`origin/dev` and `origin/staging`.

The implementation changes only:

- `package.json` and `package-lock.json`;
- `.github/workflows/security-scan.yml`; and
- Platform lifecycle documentation in IsoDocs.

It includes no LMSPro/FUND functional source, Prisma schema, migration, database,
environment or infrastructure change.

## 2. Dependency Correction

The resolved graph now contains:

- `fast-uri@3.1.4`;
- `linkify-it@5.0.2`;
- `tsx@4.23.1` with `esbuild@0.28.1`;
- Next.js `15.5.21`, within the existing accepted Next 15 range; and
- one `sharp@0.35.3` resolution using the documented temporary Sharp override.

Stable Next `15.5.21` still declares optional Sharp `^0.34.3`, while current Next canary
has adopted `^0.35.3`. The override avoids the audit tool's unsafe forced Next downgrade
and is backed by clean-install, resolved-tree, runtime Sharp and complete build evidence.

The corrected npm 10 audit reports zero critical, zero high, zero low and three moderate
dependency nodes. The remaining moderate result is the existing Next/PostCSS-derived
chain, including its propagated Next Auth node. It does not trigger the established
high/critical promotion gate and remains visible to monthly Platform assurance review.

## 3. Security Scan Correction

The workflow now:

- runs automatically for pull requests targeting `dev`, `staging` or `main`;
- retains the normal dependency gate for push, pull-request and manual events;
- runs a fail-fast-disabled scheduled dependency matrix for `main`, `staging` and `dev`;
- checks out each scheduled protected branch explicitly;
- retains a separately named audit artifact for each scheduled branch;
- calculates the gate from the single retained audit report rather than querying the
  advisory service repeatedly within one job; and
- accurately labels the high-or-critical gate.

GitHub schedules load workflow definitions from the default branch. The matrix code is
therefore implemented and syntax/execution-path validated through dev and staging, but its
first real scheduled three-branch execution cannot occur until this workflow reaches
`main` through the separately controlled production sequence.

## 4. Promotion Evidence

Online Security Scan results for exact commit `6c5aaa56`:

- remediation branch manual run `29915521121` — passed;
- `dev` push run `29915698746` — passed; and
- `staging` push run `29915869540` — passed.

Each executed dependency, Prisma/schema, secret-detection and TypeScript job passed.
The scheduled matrix correctly skipped for non-scheduled events.

Application `origin/main` remains unchanged at `ea4e6193`. No production promotion or
database action was performed.

## 5. Operational Follow-On

1. Complete the already-defined LMSPro F1 human staging smoke against the deployed staging
   service.
2. Keep the Sharp override recorded until a supported stable Next release adopts Sharp
   `0.35.x` or later; remove it only through verified dependency maintenance.
3. When the exact workflow reaches `main`, inspect and record the first scheduled
   `main`/`staging`/`dev` matrix run.
4. Continue reporting the residual moderate PostCSS chain during monthly Platform
   assurance review rather than weakening or misrepresenting the gate.
