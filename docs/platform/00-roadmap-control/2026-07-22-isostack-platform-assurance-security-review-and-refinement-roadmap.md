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
| `PLAT-ASSURE-03` | Auth Dependency And Audit-Gate Security Remediation | Critical/high dependency security and fail-closed assurance correction | Urgent | Dev/staging `df40f45c`; exact scans and complete human staging schedule PASS; two pre-existing findings registered separately |
| `PLAT-REFINE-01` | Dedicated Authenticated Private Binary Upload Transport | Runtime resilience/efficiency architecture refinement | Medium | Wishlist only; no implementation authority |
| `PLAT-REFINE-02` | Unified Tenant-User Provisioning And Account-Status Contract | Shared tenancy/authentication remediation with LMSPro consumer adoption | High | Registered wishlist/finding; CR, triage and bounded planning required |
| `PLAT-REFINE-03` | Shared Module Route Entitlement Guard And Access-Denied Contract | Shared product/module entitlement and defence-in-depth routing refinement | Medium; elevate if read-path audit finds data disclosure | Registered from staging smoke; CR, triage and bounded planning required |
| `PLAT-REFINE-04` | Impersonation Effective-Principal And Tenant-View Contract | Shared support impersonation correctness, authorization and audit refinement | Medium; elevate if inventory finds data exposure or unsafe mutation | Registered from staging smoke; CR, triage and bounded planning required |

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

## 6A. PLAT-ASSURE-03 — Auth Dependency And Audit-Gate Security Remediation

The 2026-07-27 audit of unchanged application baseline `f2b794da` reports 2 critical,
19 high and 1 moderate vulnerability. The affected paths include Auth.js/NextAuth,
`brace-expansion` and PostCSS. The same review found that the workflow records
`npm audit ... || true` and therefore does not retain or validate the command's true exit status.

`PLAT-ASSURE-03` is accepted as the single urgent Platform corrective slice. It is isolated from
the documentation-only `f2b794da` change. Dedicated-branch implementation `dc616c85` passes its
dependency graph, fail-closed parser, complete tests, type-check, verification and production
build gates. The implementation was consolidated into dev and promoted to staging. Dev/staging
and their remote counterparts align at npm 10-compatible follow-up `df40f45c`.

Automated completion is not the staging gate. The supported Auth.js/NextAuth update and stricter
`session.user` checks require the dedicated signed-out/authenticated Platform, LMSPro and FUND
human schedule:

`docs/platform/05-review-and-test/2026-07-27-isostack-platform-plat-assure-03-auth-session-and-routing-staging-human-smoke-test-schedule.md`

Exact dev Security Scan `30260022945` and staging Security Scan `30260218731` pass. Staging
health and the complete signed-out/authenticated P1, tenant, LMSPro and FUND schedule pass
on `df40f45c`. Two pre-existing supplemental observations are registered separately as
`PLAT-REFINE-03` / `2R-ACCESS-01` and `PLAT-REFINE-04`; neither is introduced by the
bounded Auth.js/session correction. The `PLAT-ASSURE-03` staging human gate is complete.
No schema, migration, database, environment or production action is authorised.

Implementation and review evidence:

- `docs/platform/04-implementation-confirmations/2026-07-27-isostack-platform-plat-assure-03-auth-dependency-and-audit-gate-security-remediation-confirmation.md`; and
- `docs/platform/05-review-and-test/2026-07-27-isostack-platform-plat-assure-03-auth-dependency-and-audit-gate-security-remediation-review-and-test.md`.

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

## 7B. PLAT-REFINE-02 — Unified Tenant-User Provisioning And Account-Status Contract

An LMSPro workflow investigation on exact application dev/staging baseline `df40f45c`
confirmed that P1 Platform user creation and C1 LMSPro user creation use separate
provisioning implementations with different status and module-role outcomes.

The P1 path correctly links the new user to the selected tenant through
`User.organizationId`, but creates only a Core tenant account. It does not assign an
LMSPro `ModuleRole`, creates the account with the legacy `PENDING` status and presents UI
wording that does not match that result. The user may therefore authenticate and reach the
handled `No LMSPro Access` screen while remaining absent from normal C1 user-management
views. C1 creation then returns the safe global-email conflict instead of completing the
same-tenant partial account.

The accepted future outcome is:

1. Replace separate P1 and C1 creation implementations with one transactional shared
   provisioning service.
2. Let module consumers provide validated module-role and affiliation inputs without
   duplicating Core account, tenant, status, audit or authentication logic.
3. Make same-tenant retries genuinely idempotent by completing a compatible partial
   account rather than returning an unrecoverable conflict.
4. Preserve global email uniqueness and fail closed when the existing account belongs to
   another tenant; provisioning must never silently move or relink a cross-tenant user.
5. Define and enforce one account-status matrix across magic link, WebAuthn and any retained
   password authentication, including explicit first-sign-in activation and refusal rules.
6. Record user creation, partial-account completion, role assignment and refused
   cross-tenant conflicts with appropriate audit evidence.
7. Add integration coverage for P1 creation through C1 visibility and LMSPro access,
   same-tenant partial-account completion, cross-tenant conflicts and the complete
   authentication-status matrix.

Before implementation planning, the Platform lane must define:

- the canonical service/API boundary and transaction;
- email normalisation and same-tenant matching rules;
- which partial states are safe to complete automatically and which require explicit
  operator review;
- status transitions for `PENDING`, `PENDING_INVITE`, `ACTIVE`, `SUSPENDED`,
  `DEACTIVATED` and GDPR deletion states;
- session revocation and reauthentication behaviour after status or role changes;
- failure, retry, audit and rollback behaviour; and
- the Platform-parent/LMSPro-consumer slice boundary.

A read-only inventory must precede any data repair. It should identify LMSPro-enabled
tenants with users whose `lmsproRoleIds` are empty, invalid, orphaned or incompatible with
their status/affiliation. The inventory is evidence only: this wishlist item does not
authorise automatic role assignment, account activation, tenant relinking, deletion or any
other shared-database mutation.

The corresponding LMSPro consumer item is `LMS-W-USERS-01` in:

`docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md`

Until a controlled remediation passes review and promotion, LMSPro users should be created
through C1 LMSPro User Management. Existing partial accounts should be reviewed and repaired
in place under explicit authority rather than routinely deleted and recreated.

This is a registered high-priority finding and wishlist outcome only. It requires CR input,
ownership/security triage, bounded Platform planning, separately bounded LMSPro adoption,
implementation confirmation, automated review and an exact P1/C1 human smoke schedule
before promotion.

## 7C. PLAT-REFINE-03 — Shared Module Route Entitlement Guard And Access-Denied Contract

Authenticated `PLAT-ASSURE-03` staging smoke against exact application commit `df40f45c`
found that an LMSPro-only C1 or C2 session can enter `/app/fund` by direct URL and render
the static FUND dashboard shell and CRUD affordances. Attempted mutations return
`FORBIDDEN`, and no cross-tenant access was observed.

Static application review confirms that this is not introduced by the Auth.js dependency
remediation:

- the common authenticated app layout checks for a session but does not check the requested
  module against the tenant's active Product/Package/Module entitlement;
- the FUND root page renders its dashboard cards without a server-side module guard;
- FUND tRPC procedures use `withFeature('fund')`, which checks the effective
  organisation's active Product-derived feature set before domain execution; and
- FUND mutations additionally enforce their domain actor rules.

The FUND application entry point has existed in this form since its initial shell commit
`db6ff5ff` on 2026-06-11. The evidence therefore supports a pre-existing route/UI
entitlement gap, not a `PLAT-ASSURE-03` regression. URL obscurity or the need to guess a
route is not a security control. The current API refusal is useful defence in depth, but it
does not make an unauthorised module shell an accepted experience.

The accepted future outcome is a reusable, server-side module route guard that:

1. resolves the effective user and organisation, including authorised P1 impersonation;
2. derives module entitlement from the canonical
   `OrganizationProduct -> ProductPackage -> ProductModule -> ModuleCatalogue` chain;
3. distinguishes organisation Product entitlement from module-specific user roles,
   memberships and affiliations without treating one as a substitute for another;
4. refuses direct navigation before rendering the module shell, cards, forms or other
   capability descriptions;
5. preserves API/service authorization as an independent fail-closed boundary;
6. returns a consistent handled unavailable/not-authorised outcome or safe redirect without
   leaking tenant data or creating redirect loops; and
7. is reusable by FUND, LMSPro, Pulse, Bedrock, IsoCare, API Keychain and future modules
   rather than implemented as unrelated page-by-page checks.

Before bounded implementation planning, perform a read-only route and API inventory:

- enumerate every authenticated `/app/<module>` entry and nested layout;
- identify which routes have no Product/module entitlement guard;
- identify public routes that must remain outside the authenticated guard, including FUND
  Project Initiation;
- verify read as well as write procedures for a tenant without the requested module;
- test a multi-product tenant so organisation entitlement is not confused with an
  individual module role;
- classify what static capability information is disclosed before API calls fail; and
- confirm suspended, expired and trial Product behaviour.

Acceptance must cover signed-out, entitled, unentitled, multi-product, module-role-missing,
FUND client-member, P1 and P1-impersonation scenarios. Tests must prove both direct root
navigation and representative nested routes, no private data response, no module shell
flash and preservation of public module-adjacent routes.

The first confirmed consumer item is FUND refinement `2R-ACCESS-01` in:

`docs/modules/fund/00-roadmap-control/2026-07-20-fund-refinement-wishlist-and-slice-control.md`

This is a medium-priority registered finding and wishlist outcome. Triage must elevate it
if the read-path inventory finds tenant data disclosure or broader authorization bypass.
Registration does not authorise application, schema, migration, deployment or data changes
and does not reopen `PLAT-ASSURE-03`.

## 7D. PLAT-REFINE-04 — Impersonation Effective-Principal And Tenant-View Contract

Authenticated `PLAT-ASSURE-03` staging smoke against exact application commit `df40f45c`
confirmed that starting P1 impersonation routes to the expected C1 dashboard, but the
dashboard presents an effectively new or empty tenant rather than the selected tenant's
established data. Ending impersonation and signing out clear the session and return to the
correct login surface.

Static application review confirms a mixed effective-identity implementation:

- shared tRPC context resolves `effectiveUserId` and `effectiveOrgId` from the authorised
  impersonation cookie;
- selected organisation, module, LMSPro user-context and club procedures consume those
  effective identifiers;
- many other LMSPro procedures, including dashboard component and season-summary reads,
  still use the real P1 `session.user.id` and `session.user.organizationId`; and
- the shared RLS context uses the effective user and organisation but retains the real
  session's role and Platform-administrator bypass.

The Auth.js remediation changed only defensive `session.user` presence checks in these
surfaces. The mixed-context behaviour predates `PLAT-ASSURE-03` and is therefore a separate
impersonation-fidelity finding, not a failure of the dependency/security correction.

The accepted future outcome is a single effective-principal contract that:

1. retains both the real P1 actor and the explicitly selected effective user,
   organisation, role, module roles and affiliations;
2. validates the impersonation record and target state on every request rather than
   trusting unverified cookie fields as authority;
3. makes all tenant reads, writes, feature checks, component checks, navigation and
   server-rendered surfaces consume the same effective principal;
4. defines whether RLS should emulate the tenant subject or use a separately constrained
   and audited support override, without accidentally retaining unrestricted P1 behaviour;
5. displays a persistent, unambiguous impersonation banner naming the effective tenant and
   user without exposing sensitive values;
6. records both real actor and effective subject in audit evidence for every mutation;
7. fails closed when the target user, organisation, role, entitlement or impersonation
   authority becomes invalid; and
8. clears effective context reliably on stop, sign-out, expiry and revocation.

Before bounded implementation planning, perform a read-only inventory of application
layouts, server components, tRPC routers, server actions, services, feature checks and RLS
entry points. Classify every direct use of `session.user` as real-actor metadata,
authentication control or a defect requiring the effective principal. Include LMSPro
league and club dashboards, user management, FUND and shared tenant settings in the
inventory.

Acceptance must compare direct C1/C2 login with P1 impersonation of the same user and prove
equivalent tenant data, permitted actions, refused actions and navigation. It must also
cover cross-tenant copied URLs, suspended/deactivated targets, mid-session role changes,
stop/sign-out/expiry, concurrent tabs, mutation audit attribution and representative RLS
read/write behaviour.

This is a medium-priority registered Platform finding and wishlist outcome. Triage must
elevate it if the inventory finds cross-tenant data exposure, unauthorised mutation or
another security-boundary failure. Registration does not authorise application, schema,
migration, deployment or data changes and does not reopen `PLAT-ASSURE-03`.

## 8. 2026-08-09 Protected-Branch Dependency-Gate Finding

The control owner reported failed GitHub Security Scan runs while local `PLAT-ROLE-02`
human testing was in progress. Read-only investigation confirms that all three protected
branches remain aligned at exact `72c02d92` and share a lockfile which now produces two
High npm audit findings:

- `js-yaml@4.3.0`, development-only through ESLint, affected by
  `GHSA-5p4m-2wfm-xmqj`; and
- `nanoid@3.3.16`, below PostCSS, affected by `GHSA-2v37-7h3g-55p8` /
  `CVE-2026-67213`.

The repository fail-closed audit validator correctly refuses the report. Static source and
dependency-tree review found no application import or exposed vulnerable call pattern, so
reviewed live exploitability is Low. The known-High dependency posture and certain
protected-branch promotion failure make release-gate impact High.

The registered source and full triage are:

- `docs/platform/01-cr-inputs/CR-Fix-2026-08-09-isostack-platform-protected-branch-security-scan-advisory-refresh.md`; and
- `docs/platform/02-triage/2026-08-09-isostack-platform-protected-branch-security-scan-advisory-refresh-triage.md`.

The expedite is now accepted. Exact `js-yaml@4.3.1` and `nanoid@3.3.18` overrides plus only
their lock records pass isolated Node 22/npm 10 clean-install, zero-finding audit validator,
full regression, TypeScript, critical verification and production build gates. The
dependency work remains a separate child commit following the completed local Role child
in one release candidate. Staging remains blocked until the combined exact dev SHA passes
the online Security Scan.

Accepted delivery records:

- `docs/platform/03-slice-planning/2026-08-10-isostack-platform-protected-branch-security-scan-advisory-refresh-planning.md`;
- `docs/platform/04-implementation-confirmations/2026-08-10-isostack-platform-protected-branch-security-scan-advisory-refresh-implementation.md`; and
- `docs/platform/05-review-and-test/2026-08-10-isostack-platform-protected-branch-security-scan-advisory-refresh-local-gate.md`.

## 9. Open Planning Questions

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

## 10. Promotion And Monthly Reconciliation Rule

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
