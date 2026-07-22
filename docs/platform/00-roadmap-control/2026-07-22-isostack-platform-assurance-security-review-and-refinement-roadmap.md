# IsoStack Platform Assurance, Security Review And Refinement Roadmap

Date: 2026-07-22

Status: Active first-class platform planning roadmap and refinement register; no
implementation authority

Direct parent control:

`docs/platform/00-roadmap-control/2026-07-22-isostack-platform-roadmap-and-slice-control.md`

Root control:

`docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`

Established source controls retained for provenance:

- `isostack-bedrock/docs/SECURITY_/SECURITY_ACTION_CHECKLIST.md` — code-adjacent weekly
  and monthly security-maintenance checklist;
- `docs/00-overview/isoblue-security-implementation-plan.md` — established weekly,
  monthly, quarterly and annual security-maintenance cadence; and
- `isostack-bedrock/docs/00-READ_THIS/SECURITY_STATUS.md` — code-adjacent security status,
  audit history and the recorded `next lint` migration requirement.

## 1. Purpose

This roadmap gives cross-cutting platform assurance work a first-class home above any one
product module. It owns findings that affect the reliability of shared engineering,
security and release gates but do not belong inside Commerce, FUND, LMSPro or another
module roadmap.

It also makes the existing monthly security-maintenance process explicit in the current
IsoDocs control structure. The older source documents remain useful provenance, but this
document is the active planning and review register for platform-wide assurance findings.

An entry in this roadmap does not authorise application code, schema, migration,
infrastructure, deployment or promotion work. Executable remediation still requires a
bounded slice plan, implementation confirmation, review/test evidence and reconciliation
into the Platform and root roadmaps.

## 2. Ownership Boundary

This platform lane owns cross-cutting assurance concerns such as:

- repository-wide static-analysis and type-safety gates;
- CI gate reliability and intentional coverage;
- platform dependency and toolchain maintenance findings;
- security-review findings whose ownership spans modules;
- detection and removal of silent exclusions or misleading green checks; and
- recurring review evidence for the controls above.

Module roadmaps continue to own module behaviour and module-specific remediation. A module
slice may report a platform finding, but it must not absorb unrelated repository-wide
cleanup into its own implementation boundary.

## 3. Monthly Platform Security And Assurance Review

The monthly review is a recurring audit/process, not a claim that every finding must be
fixed during the review window. Its purpose is to establish current evidence, classify
changes and promote material findings into bounded planning.

The monthly reviewer should record at least:

1. dependency audit and update posture, including unresolved high/critical advisories;
2. privileged/platform access review;
3. audit-chain and security-event review required by the established security plan;
4. repository-wide type-check, lint and security-scan status using the commands actually
   used by CI;
5. the number and classes of static-analysis errors and warnings, compared with the prior
   accepted baseline;
6. whether application, test, script, migration or generated paths are intentionally
   included or excluded, and whether configuration has changed;
7. deprecated quality/security tooling that must be migrated before an upstream removal;
8. any gate that is green only because relevant files are omitted, or non-green because
   longstanding debt has never received explicit ownership; and
9. the owner, severity and planning home for each new or materially changed finding.

The monthly record must distinguish:

- a security vulnerability;
- an assurance/control weakness;
- ordinary code-quality debt; and
- a toolchain or configuration defect.

Lint failure alone is not proof of a security vulnerability. A non-operational lint gate
is nevertheless an assurance weakness because it can hide substantive defects among
accepted noise and cannot reliably prevent regressions.

## 4. Active Platform Refinement Register

| Refinement ID | Name | Classification | Priority | Status |
| --- | --- | --- | --- | --- |
| `PLAT-ASSURE-01` | Repository-wide Lint, Typed-Test Coverage And CI Gate Remediation | Assurance/control weakness with code-quality and toolchain components | High | First-class finding; bounded remediation not yet authorised |
| `PLAT-ASSURE-02` | High-Severity Dependency Advisory And Staging Security-Gate Remediation | Security/dependency and recurring-monitoring correction | High operational follow-through | Dependency gate cleared on dev/staging; scheduled matrix awaits main activation |
| `PLAT-REFINE-01` | Dedicated Authenticated Private Binary Upload Transport | Runtime resilience/efficiency architecture refinement | Medium | Wishlist only; no implementation authority |

## 5. PLAT-ASSURE-01 — Repository-wide Lint, Typed-Test Coverage And CI Gate Remediation

### 5.1 Trigger And Provenance

The finding was confirmed while reviewing the bounded LMSPro `R8-A2R-F1` corrective work.
That slice's focused production lint, type-check, build and tests passed, but a
repository-wide lint run could not provide a clean gate because of unrelated pre-existing
application violations and the existing typed-lint configuration boundary for test files.

The correct conclusion is:

> Repository-wide lint remains non-green because of pre-existing application violations
> and the existing ESLint/TypeScript configuration mismatch for test files. Focused
> linting of the R8-A2R-F1 production changes reports no errors.

This finding must not be reported as an LMSPro attachment-route failure, and the LMSPro
slice must not be expanded to repair unrelated platform pages.

### 5.2 Confirmed Evidence At Discovery

The 2026-07-22 discovery run established:

- 34 repository-wide ESLint errors;
- 27 production-source errors across 13 application files;
- most production errors were `react/no-unescaped-entities`, alongside substantive
  pre-existing findings including a conditional React hook, a reserved `module` variable
  assignment and a `prefer-const` violation;
- seven test-file parser errors because typed ESLint uses `parserOptions.project` against
  the main `tsconfig.json`, while that TypeScript project excludes `*.test.ts` and
  `*.test.tsx` files;
- the package lint command still delegates to deprecated `next lint`, which must be
  replaced by direct ESLint CLI use before Next.js removes that command; and
- focused linting of the changed LMSPro production files reported no errors.

Counts are discovery evidence, not a permanent baseline. The first bounded remediation
slice must reproduce and classify the current state before changing configuration or
source.

### 5.3 Risk And Scope Implication

The immediate risk is not that every lint error is exploitable. The platform risk is that:

- a noisy global result cannot act as a dependable zero-error regression gate;
- substantive rule violations can be obscured by longstanding presentational errors;
- test files may appear covered while typed lint cannot parse them under the configured
  project; and
- continued use of `next lint` creates a known upgrade blocker for a later Next.js
  transition.

Until remediated, bounded slices must report both focused lint evidence and the known
repository-wide limitation honestly. They must not claim a clean repository-wide lint
gate when only changed files were checked.

### 5.4 Proposed Bounded Remediation Family

Later planning should assess a small serial family rather than one unbounded cleanup:

1. **Baseline and production-source correction** — reproduce the error inventory, fix the
   accepted production-source violations without unrelated functional redesign, and prove
   no rule was weakened merely to obtain green output.
2. **Test-aware lint configuration** — give test files an intentional ESLint/TypeScript
   project or another documented test-lint boundary that parses and checks them reliably.
3. **Direct ESLint CLI migration** — replace deprecated `next lint`, align local and CI
   commands and document the exact included paths.
4. **Zero-error CI enforcement** — activate the repository-wide gate only after the
   accepted baseline is clean, with no silent exclusions and with clear failure evidence.

Planning may combine steps where the resulting slice remains reviewable and reversible,
but it must not conceal configuration changes inside broad mechanical source cleanup.

### 5.5 Acceptance Principles

The platform outcome is complete only when:

- the documented repository-wide lint command exits successfully from a clean checkout;
- production and test source have intentional, reviewable lint coverage;
- `next lint` is no longer the operative package/CI contract;
- substantive existing violations are corrected rather than globally suppressed;
- exclusions are minimal, explicit and justified;
- local and CI commands agree;
- the monthly review can compare a meaningful zero-error baseline; and
- module slices no longer need to qualify lint evidence because of unrelated historical
  failures.

## 6. PLAT-ASSURE-02 — High-Severity Dependency Advisory And Staging Security-Gate Remediation

GitHub Security Scan run `29912591540` failed on 2026-07-22 against exact application dev
commit `68b92361`, reporting zero critical and four high-severity dependency
vulnerabilities. Schema security, secret detection and TypeScript jobs passed.

The affected audit chains include `fast-uri`, `linkify-it` and `sharp`, with `esbuild` and
`postcss` advisories also reported. The forced audit proposal for the Next.js/`sharp` chain
is not an accepted remediation because it proposes a breaking framework downgrade.

Resolution evidence:

1. bounded application commit `6c5aaa56` resolves the high-severity dependency graph;
2. local Node 22 install, audit, dependency-tree, Sharp runtime, test, type and production
   build evidence passed;
3. remediation-branch run `29915521121`, dev run `29915698746` and staging run
   `29915869540` passed;
4. `origin/dev` and `origin/staging` now align at `6c5aaa56`;
5. no forced audit fix, framework downgrade, canary adoption or threshold weakening was
   used; and
6. the three-protected-branch scheduled dependency matrix is implemented but awaits
   default-branch activation and its first scheduled evidence.

Authoritative promotion evidence:

`docs/00-roadmap-control/2026-07-22-lmspro-r8-a2r-f1-dev-promotion-and-staging-security-gate-blocker-confirmation.md`

Lifecycle evidence:

- `docs/platform/03-slice-planning/2026-07-22-isostack-platform-plat-assure-02-dependency-and-security-monitoring-remediation-planning.md`;
- `docs/platform/04-implementation-confirmations/2026-07-22-isostack-platform-plat-assure-02-dependency-and-security-monitoring-remediation-confirmation.md`; and
- `docs/platform/05-review-and-test/2026-07-22-isostack-platform-plat-assure-02-dependency-and-security-monitoring-remediation-review-and-test.md`.

## 7. Settled Planning Decisions

1. This is a platform assurance finding, not an LMSPro implementation defect.
2. It is high-priority platform remediation because it affects the trustworthiness of a
   shared quality and security-adjacent gate.
3. The monthly platform security and assurance review owns recurrence and status checking.
4. Existing module work may use focused lint evidence but must disclose the global gate
   limitation until this finding is closed.
5. Remediation must not weaken rules or silently exclude source merely to make CI green.
6. This roadmap registers and sequences the finding but does not authorise implementation.

## 7A. PLAT-REFINE-01 — Dedicated Authenticated Private Binary Upload Transport

LMSPro attachment remediation currently carries accepted binary content as Base64 inside a tRPC
JSON mutation before private R2 persistence. The immediate Node middleware race is controlled by
Platform slice PLAT-RUNTIME-01 and must not be conflated with this wider design option.

A later appraisal should consider an authenticated, tenant-scoped upload path that writes
accepted content directly to private object storage and lets tRPC carry durable object metadata
and associations only. The appraisal must preserve the existing narrow type/content checks,
size/count limits, private storage, acknowledgement/audit evidence and prohibition on server-side
preview/parsing.

This is wishlist/refinement scope only. It does not authorise a new endpoint, direct browser
credential exposure, presigned upload, schema change or migration, and it does not block the
bounded upstream runtime correction.

## 8. Open Planning Questions

The bounded slice plan must determine:

1. whether tests use a dedicated `tsconfig.eslint.json`, ESLint project service or another
   supported typed-lint configuration;
2. whether warnings become an immediate zero-warning gate or remain separately budgeted
   after the zero-error contract is restored;
3. which non-application paths, including scripts and migrations, belong in the first
   enforced repository-wide command;
4. whether production-source correction and toolchain migration should be one slice or two
   independently reviewable slices; and
5. which CI workflow becomes the authoritative lint gate and how branch protection will
   consume it.

## 9. Promotion And Monthly Reconciliation Rule

At each monthly review:

1. rerun the authoritative commands on the current controlled branch;
2. update evidence only when counts, classifications or configuration materially change;
3. do not rewrite historic discovery evidence;
4. promote implementation only through an accepted bounded platform slice;
5. record implementation and independent review/test in the normal lifecycle; and
6. reconcile this roadmap and the root roadmap when the finding changes state.

This lane does not displace the current serial product/module delivery candidate unless
the parent roadmap explicitly promotes a platform assurance slice as the next executable
work.
