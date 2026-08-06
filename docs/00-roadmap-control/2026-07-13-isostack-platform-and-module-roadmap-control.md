# IsoStack Platform And Module Roadmap Control

Date: 2026-07-27

Last portfolio reconciliation: 2026-08-06

Status: Active parent roadmap

## 0. Current Portfolio Control — 2026-08-06

This section is the current cross-lane control and supersedes older global `single next`
wording later in this document. Older statements remain evidence of the sequence at the
time they were written; they must not displace this reconciled `Now`/`Next` pair.

The three definitive product/platform child roadmaps in the present solo-developer
portfolio are:

1. Platform —
   `docs/platform/00-roadmap-control/2026-07-22-isostack-platform-roadmap-and-slice-control.md`;
2. LMSPro / SeasonPro —
   `docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md`; and
3. FUND —
   `docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`.

Commerce Core remains a separately authoritative bounded Core-domain control because FUND
depends on shared checkout, Order, money and payment contracts. It joins the serial
portfolio queue when selected, but it is not a fourth product backlog for daily attention.

Current application evidence:

```text
local dev = 5e551938 (PLAT-ROLE-02; not pushed)
origin/dev = staging = origin/staging = main = origin/main = 72c02d92
F3 tests/type/verify/build = PASS; dev/staging/main Security Scans = PASS
F3 staging human smoke = 13/13 PASS; production promotion = COMPLETE
staging and production public health = HTTP 200; database connected; RLS 11/11
PLAT-ROLE-01 matrix = COMPLETE and all 13 items accepted
PLAT-ROLE-02 automated/type/verify/build/security gates = PASS; local human smoke pending
```

Current serial portfolio decision:

| Position | Lane and outcome | Exact boundary |
| --- | --- | --- |
| **NOW** | `PLAT-ROLE-02` local human containment gate | Exact local `5e551938` has passed automated, regression, type, verification, build and security gates. Execute the disposable-account Organisation Authority, invitation and League/Club-context smoke matrix; no staging yet. |
| **NEXT** | `PLAT-ROLE-02` exact-commit staging lifecycle | Only after the local gate passes, align/push the accepted exact commit and conduct the documented staging security/deployment/human gate. Do not begin `PLAT-ROLE-03` or live repair implicitly. |

Registered and ordered work outside that pair:

- Platform/SeasonPro role-authority clarification: active root project. `PLAT-ROLE-01` is
  accepted and complete; `PLAT-ROLE-02` is implemented only on local dev at `5e551938` and
  awaits the explicit local human gate;
- Platform support-ticketing client readiness: privacy/security and client-enablement triage
  input selected as the mandatory self-contained project after Role Authority, with the
  internal-note and server-authority findings eligible for an explicit expedite proposal
  if triage confirms the risk;
- LMSPro 500-recipient operating envelope: standard communications/capacity triage input;
- LMSPro R11-A recipient-tab presentation: automated/build and authenticated local smoke
  18/18 PASS and staging smoke all green; exact `83356030` is aligned through `origin/main`;
  the live deployment is triggered and public health is PASS, while exact Render-build
  identification and authenticated production smoke remain; this bounded UI release does
  not displace the portfolio `Now`/`Next` pair;
- LMSPro cohort email draft persistence and audience selection `CR-Fix`: F1/F2.1/F2.2 and
  F3 are delivered in the ancestry of current application `72c02d92`; F3 staging smoke
  passed 13/13 and exact main promotion is complete;
- FUND `1R-F-A`: deliberately parked at its exact pre-planning boundary until F3, Role
  Authority and Support Ticketing are completed; no application implementation is
  authorised;
- Platform `PLAT-REFINE-02` through `PLAT-REFINE-04`: registered non-executable findings;
  and
- all parked FUND and LMSPro candidates recorded in their child CR inventories.

CR capture contract:

1. every new CR is added to its owning authoritative child roadmap in the same
   documentation change;
2. the child row always carries an explicit disposition, even when that disposition is
   only `captured; awaiting triage`;
3. registration does not authorise or schedule work;
4. the root is updated only when a CR changes cross-lane ownership/dependency, creates an
   expedite proposal, or changes portfolio `Now`/`Next`; and
5. exactly one `Now` and one `Next` may exist across the child lanes.

Remedial `CR-Fix` control:

1. `CR-Fix` identifies a fault/regression CR inside its owning child lane; it is not a
   fourth roadmap or automatic implementation authority;
2. every `CR-Fix` records containment, severity, workaround safety, risk assessment,
   expedite decision and displaced-work resumption;
3. an accepted expedite becomes the only portfolio `Now`;
4. the displaced former `Now` becomes `Next` at its exact safe resumption point, while the
   former `Next` remains registered but temporarily loses that formal position; and
5. closure/re-disposition of the `CR-Fix` must explicitly resume the interrupted outcome
   and restore or reconsider the prior sequence.

The email `CR-Fix` expedite was accepted and its incident-ending corrections were delivered.
Its required F3 policy follow-on is now selected as portfolio `Now`. The source, earlier
triage and delivered F1/F2 slice plan are:

- `docs/modules/lmspro/01-cr-inputs/CR-Fix-2026-08-05-lmspro-cohort-email-draft-persistence-and-audience-selection.md`;
- `docs/modules/lmspro/02-triage/2026-08-05-lmspro-cr-fix-f1-f2-cohort-email-draft-persistence-and-audience-selection-triage.md`; and
- `docs/modules/lmspro/03-slice-planning/2026-08-05-lmspro-cr-fix-f1-f2-cohort-email-draft-persistence-and-audience-selection-planning.md`.

Its replacement F2.1 plan is:

- `docs/modules/lmspro/03-slice-planning/2026-08-05-lmspro-cr-fix-f2-1-cohort-taxonomy-and-picker-correction-planning.md`.

The accepted F3 authority is:

- `docs/modules/lmspro/02-triage/2026-08-06-lmspro-cr-fix-f3-uploaded-file-only-acknowledgement-triage.md`; and
- `docs/modules/lmspro/03-slice-planning/2026-08-06-lmspro-cr-fix-f3-uploaded-file-only-acknowledgement-planning.md`.

Working-method and human navigation references:

- authoritative human/AI method:
  `docs/modules/<module>/work-method.md`;
- plain-English CR-to-release guide:
  `docs/00-roadmap-control/2026-08-05-human-guide-change-request-to-release.md`; and
- printable management snapshots:
  `docs/00-roadmap-control/printable-summaries/`.

The printable summaries are subordinate snapshots. Refresh the affected summary when a
material reconciliation changes its source roadmap; if it ever differs, this root control
and the authoritative child control win.

## 1. Purpose

Provide the parent control above Platform, bounded Core-domain and product-module roadmaps.

The root roadmap coordinates sibling lanes without moving platform ownership into a module
or making a module roadmap authoritative for reusable Core infrastructure.

## 2. Governed Roadmap Tree

```text
IsoStack Root Roadmap
├── Platform roadmap
│   ├── shared application, tenancy, administration and platform services
│   └── Platform assurance, security review and refinement roadmap
│       └── cross-cutting quality/security gates, toolchain debt and monthly findings
├── LMSPro / SeasonPro roadmap
│   └── League, Club, season, participation and module communications behaviour
├── Core Commerce roadmap
│   └── reusable checkout, Order, money and payment infrastructure
└── FUND roadmap
    └── Project Store, Product inputs, production and commission context
```

Authoritative child controls:

```text
docs/platform/00-roadmap-control/2026-07-22-isostack-platform-roadmap-and-slice-control.md
docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md
docs/core/commerce/00-roadmap-control/2026-07-13-commerce-core-roadmap-and-slice-control.md
docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md
```

Subordinate Platform assurance/refinement control:

`docs/platform/00-roadmap-control/2026-07-22-isostack-platform-assurance-security-review-and-refinement-roadmap.md`

Other Platform, bounded Core-domain and module roadmaps may be added as siblings when their
work requires cross-lane coordination.

## 3. Mandatory Slice Lifecycle

Every executable slice in every governed lane follows:

```text
03-slice-planning
-> implementation in the owning application/repository scope
-> 04-implementation-confirmations
-> 05-review-and-test
```

Rules:

- `04-implementation-confirmations` contains only evidence of actual implementation;
- planning decisions and handoffs belong in `02-triage` or the lane roadmap;
- umbrella architecture documents may govern several slices but do not substitute for a
  bounded slice plan;
- implementation confirmation does not substitute for independent review/test evidence;
- a slice is not deployment-complete while a recorded deployment gate remains pending.

## 4. Ownership Boundary

Commerce Core owns generic:

- seller profile;
- checkout and Order lifecycle;
- monetary/tax snapshots;
- payment, refund and pro-forma evidence;
- provider-neutral audit/idempotency contracts.

FUND owns:

- Project Store and Store Product;
- Product inputs and media;
- artwork and production context;
- Project delivery context;
- Event-default and Project-specific commission policies;
- typed FUND extensions keyed to generic Commerce records.

Cross-lane references remain generic from Commerce and typed from FUND.

Platform owns reusable application, tenancy, authentication, administration, shared
service and platform-engineering contracts. Its subordinate Platform Assurance control
owns cross-cutting engineering and security-assurance findings, including repository-wide
static analysis, typed-test lint coverage, CI gate integrity, toolchain deprecation and the
monthly security/assurance review register. Neither boundary absorbs module behaviour.

## 5. Current Lane Status

### 2026-07-14 Development Promotion Checkpoint

Application `dev` is aligned with `origin/dev` at `fd7376b`; all 139 migrations are applied
to the Neon development database. Disposable FUND test rows were cleared only after an
R3-D empty-baseline guard stopped migration and the user explicitly authorised their
removal. LMSPro/public row counts were unchanged, all Commerce A1-A4 and FUND C1-C6
contract verifiers passed, and application staging/main remained at `ea4e619`.

Authoritative deployment evidence:

`docs/00-roadmap-control/2026-07-14-fund-commerce-dev-promotion-and-migration-confirmation.md`

Any older statement below saying these slices remain unpushed or undeployed to the shared
development database is superseded by this checkpoint. Staging and production remain
undeployed.

### 2026-07-15 Commerce A7 Development And Staging Promotion Checkpoint

Application `dev`/`origin-dev` and `staging`/`origin-staging` are aligned at `91e8751c`.
The Neon development database is current at 140 applied migrations with no failed
migration. Dev and staging security/type/schema gates passed; staging reported healthy
with its database connected and RLS enabled on all 11 expected tables; and human FUND
administrator login plus pre-existing UI smoke verification passed.

Application `main`, live deployment and the live database remain unchanged at their prior
boundary. This checkpoint supersedes older statements below that describe A6-A through A7
or retained FUND dependencies as local, unpushed or undeployed to staging.

Authoritative evidence:

`docs/00-roadmap-control/2026-07-15-commerce-a7-dev-staging-promotion-confirmation.md`

### 2026-07-21 FUND Default Project Store Testability Correction

Post-promotion preparation established that E-B/E-C human acceptance cannot begin from the
real empty FUND state. C1 correctly has oversight/exceptional intervention only, the C2 UI
can manually `Prepare Store`, but none of the retained Project creation/intake paths creates
the Store/default eligible Product set.

The E-A/B/C technical and automated evidence remains passed. Human acceptance is blocked,
not failed. Governed `1R-E-D - Default Project Store Instantiation And Eligible Product
Reconciliation` planning was reviewed and accepted on 2026-07-21 as the single next
implementation candidate before `1R-F-A`. Review confirmed that the existing one-Store-per-
Project key is sufficient and E-D adds no Prisma migration. E-D is now implemented/reviewed
as passed at implementation commit `c45a41d9`, integrated/revalidated and aligned on
application `dev`/`origin/dev` at `174dc8ac`, without an E-D migration or shared database
change. Its real-workflow E-B/E-C human schedule remains pending controlled staging
promotion.

Authoritative records:

- `docs/modules/fund/01-cr-inputs/2026-07-21-fund-default-project-store-and-eligible-product-presumption-input.md`
- `docs/modules/fund/03-slice-planning/2026-07-21-fund-phase-1-slice-1r-e-d-default-project-store-instantiation-eligible-product-reconciliation-implementation-planning.md`

### 2026-07-20 FUND 1R-E Development And Staging Promotion Checkpoint

Application `dev`/`origin-dev` and `staging`/`origin-staging` are aligned at `e3f44b4b`.
This promotes completed E-A intervention authority and the E-B/E-C C1/C2 Store surfaces.
Exact dev and staging Security Scans passed, and online staging reported healthy database
connectivity with RLS enabled on all 11 expected tables. The new C1 Store and retained C2
application boundaries returned the expected unauthenticated sign-in redirects.

The Render build contract applies committed migrations through `prisma migrate deploy`
before building. No direct staging migration inventory was queried locally, and the Neon
development database was not migrated in this turn. Post-promotion preparation subsequently
found E-B/E-C human acceptance blocked by missing default Project Store instantiation.
Application `main`, live deployment and the live database are unchanged.

Authoritative evidence:

`docs/00-roadmap-control/2026-07-20-fund-1r-e-dev-staging-promotion-confirmation.md`

This checkpoint supersedes the E-A local-only and E-B/E-C unpushed deployment wording in
the older checkpoint and status detail below.

### Platform And Platform Assurance

- The Platform now has the same controlled `00` through `05` documentation lifecycle
  used by Commerce Core, FUND and LMSPro:
  `docs/platform/00-roadmap-control/2026-07-22-isostack-platform-roadmap-and-slice-control.md`.
- The hierarchy applies prospectively from 2026-07-22 and does not invent retrospective
  lifecycle evidence for the initial IsoStack build.
- The first-class Platform Assurance, Security Review And Refinement Roadmap is active:
  `docs/platform/00-roadmap-control/2026-07-22-isostack-platform-assurance-security-review-and-refinement-roadmap.md`.
- `PLAT-ASSURE-01 - Repository-wide Lint, Typed-Test Coverage And CI Gate Remediation` is
  registered as a high-priority platform assurance finding.
- The finding records 27 pre-existing production-source lint errors and seven test parser
  errors at discovery, plus the retained deprecated `next lint` package contract. These
  counts are evidence to reproduce, not a permanent accepted baseline.
- The monthly platform security and assurance review now owns recurrence, classification
  and status evidence for this finding.
- No platform remediation implementation is authorised by registration, and the finding
  does not invalidate focused passing evidence from a bounded module slice.
- `PLAT-RUNTIME-01 - Node Middleware Request-Body Finalisation Backport And
  Production-Runtime Assurance` is the completed staging-accepted Platform corrective slice that
  began at exact application baseline `90974123`. It owns the shared Next.js Node middleware
  defect exposed by LMSPro R8-A3 staging testing.
- PLAT-RUNTIME-01 implementation and automated review pass at dedicated-branch application commit
  `6b822e45`; that exact commit was subsequently fast-forwarded through `origin/dev` to
  `origin/staging`. Clean Node 22 installation, exact fail-closed patch verification, full tests,
  ordinary/standalone builds, repeated payload probes and the mandatory staging smoke passed.
- The dependent LMSPro delivery handoff passed through R8-A3-F1 at application commit `d14a652f`
  after diagnostics identified and corrected the staging cron's plural private-bucket typo. A
  fresh large-PDF Email queued, processed, updated the UI and arrived with its attachment. Platform
  control returned to R8-A3. Its remaining resource, CC/BCC, send-again, status/log and batch
  regression checks passed, and a deterministic no-network test proved 300 recipients across two
  150-recipient cycles at no more than three mocked provider starts per rolling second. R8-A3 was
  staging-accepted and subsequently completed its separately controlled live promotion and
  transport gate.
- `PLAT-REFINE-01 - Dedicated Authenticated Private Binary Upload Transport` is registered as a
  non-executable wishlist item and does not expand the current corrective slice.
- `PLAT-REFINE-02 - Unified Tenant-User Provisioning And Account-Status Contract` is
  registered as a high-priority, non-executable Platform refinement after an LMSPro
  investigation on application baseline `df40f45c`. It owns the shared transactional
  account/tenant service, same-tenant idempotent completion, cross-tenant fail-closed
  conflict, authentication-status matrix, read-only partial-account inventory and shared
  integration contract.
- LMSPro consumer wishlist `LMS-W-USERS-01` owns required/default LMSPro role and
  affiliation inputs, repairable `Unassigned` visibility and the P1-to-C1-to-login
  acceptance path. Until a controlled remediation is promoted, the recorded operating
  rule is to create LMSPro users through C1 LMSPro User Management.
- Registration authorises no implementation or data repair and does not displace the
  root roadmap's current serial next-slice decision.
- `PLAT-REFINE-03 - Shared Module Route Entitlement Guard And Access-Denied Contract` is
  registered from authenticated staging smoke at exact application commit `df40f45c`.
  An LMSPro-only session can render the static `/app/fund` dashboard shell by direct URL,
  while Product-derived API and FUND domain checks subsequently refuse operations.
- Application history places the ungated FUND entry point at initial shell commit
  `db6ff5ff` on 2026-06-11, so the finding is not introduced by `PLAT-ASSURE-03`.
  Platform owns the reusable guard; FUND refinement `2R-ACCESS-01` owns the first consumer
  adoption and its client-member/public-route exceptions.
- This is medium-priority, non-executable refinement scope. A read-only route/API inventory
  must precede planning, and triage must elevate the item if it finds tenant data disclosure
  or broader authorization bypass. Registration does not reopen `PLAT-ASSURE-03` or change
  the root serial next-slice decision.
- `PLAT-REFINE-04 - Impersonation Effective-Principal And Tenant-View Contract` is
  registered from the same staging schedule. P1 impersonation reached the selected C1
  dashboard but showed an effectively new or empty tenant; stop/sign-out routing passed.
- Static review found mixed identity propagation: shared context resolves the effective
  subject while many LMSPro reads still consume the real P1 session, and RLS retains the
  real Platform-administrator bypass. The future Platform contract must consistently
  separate and audit the real actor and effective subject across data, authorization,
  routing and session lifecycle.
- This is medium-priority, non-executable refinement scope, with mandatory elevation if
  inventory finds cross-tenant disclosure, unauthorised mutation or another
  security-boundary failure. It does not reopen `PLAT-ASSURE-03` or change the root serial
  next-slice decision.

### 2026-07-23 R8-A3 Reconciliation And Completed Combined Production Release

Runtime ancestor `d14a652f` and assurance-only descendant `99164ddd` are retained in the
controlled combined release. Application `dev`, `staging` and `main`, including their
remote counterparts, are aligned at `b9287ffa`.

The scheduled and exact-candidate Security Scans passed. The Platform Owner completed the
live snapshot and read-only migration preflights. The migration chain stopped safely at the
R3-D empty-FUND guard, disposable live FUND development data was cleared under the recorded
authority without deleting LMSPro/public data, the failed attempt was resolved as rolled
back and the migration-before-code deployment completed.

An Upstash REST URL/token mismatch initially caused authentication HTTP 500 responses and
was corrected without changing authentication or encryption keys. A later live attachment
test exposed stale R2 signing credentials on the separately configured cron after the web
service credentials had been rotated. Aligning each environment's web and cron consumers
to its current R2 credential set restored delivery. Fresh attachment delivery passes in
both staging and MAIN. R8-A3 is complete in staging and live.

FUND E-B/E-C/E-D human testing continues independently and no unrestricted FUND production
acceptance is inferred.

The immediate evidence-gathering action for the preferred full-bundle option is the consolidated
FUND E-B/E-C/E-D staging schedule:

`docs/modules/fund/05-review-and-test/2026-07-23-fund-phase-1-slice-1r-e-b-through-1r-e-d-consolidated-staging-human-smoke-test-schedule.md`

Authoritative assessment:

`docs/00-roadmap-control/2026-07-23-lmspro-r8-a3-and-combined-staging-bundle-production-risk-assessment-and-promotion-decision.md`

### 2026-07-27 LMSPro Four-Item Remediation CR Completion

The post-R8-A LMSPro remediation CR now contains exactly four complete business briefs:
Club Email-history integrity, attachment click-to-browse restoration, Club admission/
participation alignment and responsive Team status/Waiting List visibility. The formerly
expected C1 League dashboard reorganisation is standalone work and is not a fifth item.

Formal LMSPro triage accepts the CR as coordinated programme `R9`, with four separately
bounded child lifecycles in the requested Item 3, Item 1, Item 4 and Item 2 order:
`R9-A` Club admission/seasonal participation, `R9-B` Club Email visibility/history,
`R9-C` responsive Team status and `R9-D` attachment click-to-browse.

`R9-A0 - Club Participation Writer, Consumer And Live-State Inventory` is selected as the
LMSPro lane's next planning/evidence boundary. Item 3's business semantics are settled:
completed validated SeasonPro import, the linked two-stage form after email validation and
C1 approval, and authorised direct C1 creation are the three valid
Registered/admission routes; `APPROVED` remains the Current compatibility state; and zero
qualifying Current/allocated Teams means Club Waiting List while unallocated Teams remain
distinct. R9-A0 authorises static inventory and separately authorised read-only aggregate
evidence only. It authorises no application implementation, schema, migration,
reconciliation, live-data mutation or deployment. Its reviewed results must define the
candidate compatibility and implementation slices before another control decision may
accept them.

This LMSPro planning selection does not displace the root roadmap's single cross-lane
executable-slice authority or the currently recorded FUND planning candidate.

Authoritative LMSPro records:

- `docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md`;
- `docs/modules/lmspro/01-cr-inputs/2026-07-22-lmspro-consolidated-email-integrity-club-visibility-and-remedial-work-cr-input.md`; and
- `docs/modules/lmspro/01-cr-inputs/2026-07-27-lmspro-consolidated-four-item-remediation-planning-refinement.md`;
- `docs/modules/lmspro/02-triage/2026-07-27-lmspro-r9-consolidated-four-item-remediation-triage.md`; and
- `docs/modules/lmspro/03-slice-planning/2026-07-27-lmspro-remediation-slice-r9-a0-club-participation-writer-consumer-and-live-state-inventory-planning.md`.

### 2026-07-27 PLAT-ASSURE-03 Urgent Security Remediation Selection

An audit of unchanged application baseline `f2b794da` reports 2 critical, 19 high and
1 moderate dependency vulnerability across Auth.js/NextAuth, `brace-expansion` and PostCSS
paths. The current npm-audit workflow also fails to retain and validate the command's real exit
status. `PLAT-ASSURE-03` is selected as the urgent bounded Platform slice and displaces ordinary
feature execution.

Dedicated-branch implementation `dc616c85` passes zero-vulnerability audit, fail-closed parser
tests, dependency-tree, full test, type-check, critical-file and production build gates.
At this selection checkpoint, application `dev` and `origin/dev` were aligned at the separately
completed documentation-only baseline `f2b794da`; controlled integration and its exact-commit
online Security Scan were the next gates. The later Dev/Staging checkpoint below supersedes that
branch status. Because the change updates shared authentication dependencies and guards, an
exact-commit authenticated staging smoke across public, Platform, LMSPro and FUND entry paths
remains mandatory. No production, schema, migration, database or environment action is
authorised.

Planning and human schedule:

- `docs/platform/03-slice-planning/2026-07-27-isostack-platform-plat-assure-03-auth-dependency-and-audit-gate-security-remediation-planning.md`; and
- `docs/platform/05-review-and-test/2026-07-27-isostack-platform-plat-assure-03-auth-session-and-routing-staging-human-smoke-test-schedule.md`.

### 2026-07-27 PLAT-ASSURE-03 Dev/Staging Checkpoint

Application dev/staging and their remote counterparts align at `df40f45c`. Exact dev Security
Scan `30260022945` and staging Security Scan `30260218731` pass. The Render staging deployment
is healthy with connected database and 11/11 RLS coverage. Signed-out Platform/SeasonPro routing,
login and defensive-session checks pass.

The authorised human tester subsequently completed the P1, tenant owner/admin, LMSPro C1,
LMSPro C2 and FUND browser scenarios in Vivaldi, Chrome and Safari. The bounded
authentication, routing, sign-out, expiry/revocation and intended-account checks PASS.
No remediation-attributable browser failure was reported.

Two supplemental observations were confirmed as pre-existing and registered separately:
the unentitled static FUND shell under `PLAT-REFINE-03` / `2R-ACCESS-01`, and inconsistent
P1 impersonation tenant data under `PLAT-REFINE-04`. Neither is introduced by the
`session.user` guard correction. The staging human gate for `PLAT-ASSURE-03` is complete;
this checkpoint does not authorise production promotion. No application main, live service,
live database, schema, migration or environment setting changed.

Promotion checkpoint:

`docs/00-roadmap-control/2026-07-27-plat-assure-03-dev-staging-promotion-and-human-smoke-checkpoint.md`

### 2026-07-22 LMSPro R8-A2R-F1 Development Promotion And Staging Blocker

Application `origin/dev` and the dedicated F1 branch are aligned at verified commit
`68b92361`. Full Vitest, critical-file verification, type-check and production build passed.
Canonical IsoDocs includes the F1 lifecycle and Platform hierarchy at `558b000`.

GitHub Security Scan run `29912591540` then failed its dependency job with zero critical
and four high-severity vulnerabilities. Schema security, secret detection and TypeScript
jobs passed. This historic result blocked staging until Platform slice `PLAT-ASSURE-02`
remediated the graph at exact commit `6c5aaa56` without a forced framework downgrade or
weakened gate. Remediation-branch run `29915521121`, dev run `29915698746` and staging run
`29915869540` passed. `origin/dev` and `origin/staging` now align at `6c5aaa56`; application
main, production and all databases remain unchanged. LMSPro F1 is ready for its human
staging smoke. The scheduled three-protected-branch dependency matrix is implemented but
awaits default-branch activation and first scheduled evidence.

Authoritative evidence:

`docs/00-roadmap-control/2026-07-22-lmspro-r8-a2r-f1-dev-promotion-and-staging-security-gate-blocker-confirmation.md`

### 2026-07-15 FUND 1R-E-A Local Completion Checkpoint

FUND `1R-E-A - Store Authority, Exceptional Intervention And Lifecycle Service Alignment`
is implemented and independently reviewed as passed at application `dev`/`origin/dev`
commit `daafc349`.
Its bounded migration advances only the retained disposable test database from 140 to 141
applied migrations with zero failures and zero test residue. Representative upgrade, full
fresh replay, preflight refusal, schema/constraint/service/concurrency/rollback, retained
1R-D/A7 regressions, Prisma validation/generation, type-check and production build passed.

The application code is backed up on `origin/dev`, but the shared Neon development
database and staging remain at the previously promoted `91e8751c`/140-migration boundary;
production remains unchanged. GitHub `Security Scan` run `29417617533` passed for exact
application commit `daafc349`. This checkpoint
supersedes older current-action statements below that say E-A implementation has not
started. The bounded `1R-E-B - C1 Store Portfolio Oversight And Exceptional Intervention
Surface` implementation/review lifecycle is complete locally without a migration and is
not yet committed/deployed. `1R-E-C - C2 Project Store Control Surface` is also
implemented/reviewed locally without a migration or shared deployment; its human UI
schedule remains pending. `1R-F - Project Offer And Artwork Readiness Reconciliation` is
reviewed/accepted at
`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-f-project-offer-artwork-readiness-reconciliation-planning.md`.
Its bounded `1R-F-A` real-template/renderer proof is selected as formal portfolio `Now` for
planning; the conditional proof implementation is `Next`, and `1R-G` remains unauthorised.

### Commerce Core

- Commerce schema foundation architecture: accepted.
- `COMMERCE-A1`: implemented and reviewed as passed.
- A1 static/generated-client and schema-contract review: passed.
- A1 fresh/existing-schema disposable PostgreSQL migration: passed.
- A1 rollback-only constraint/default smoke: passed with zero residual test rows.
- A1/C1/C2 application schema foundation: committed together at `4575d2d`;
- C3/C4 application schema foundation: committed at `686229c`, with `dev` and `origin/dev`
  aligned; staging/main remain at `ea4e619`.
- C5 application schema foundation: implemented/reviewed at `8b5f208`, now included on
  `origin/dev`; not deployed to a shared database;
  staging/main and all shared databases remain unchanged.
- Dedicated Neon `TEST_DATABASE_URL` target: retained as disposable test infrastructure;
  its connection string remains local and uncommitted.
- Shared development, staging and live database deployment: not performed.
- `COMMERCE-A2`: implemented/reviewed at application commit `3206199` on `origin/dev`; representative
  135-to-136 and fresh 136-migration disposable lifecycles passed with zero residue and no
  shared deployment.
- FUND `1R-C6`: implemented/reviewed at local application commit `9947669`; representative
  136-to-137, refusal and fresh 137-migration disposable lifecycles passed with zero residue
  and no shared deployment. The commit is not yet pushed.
- FUND Store `1R-D`: implemented/reviewed at local application commit `db85fcc`; its
  service/transaction lifecycle passed against the unchanged 137-migration disposable
  baseline with zero `fund-1rd-*` residue. The commit is not yet pushed or deployed.
- `COMMERCE-A3`: implemented/reviewed at local application commit `4a90be1`; representative
  137-to-138 and fresh 138-migration disposable lifecycles, A1/A2/C6 regressions and
  zero-residue checks passed. It is not pushed or deployed to a shared database.
- `COMMERCE-A4`: implemented/reviewed at local application commit `5b69920`; representative
  138-to-139 and fresh 139-migration disposable lifecycles, A1/A2/A3/C6 regressions,
  immutable-audit checks and zero-residue checks passed. It is not pushed or deployed to a
  shared database.
- `COMMERCE-A5`: implemented/reviewed at application commit `fd7376b`, included on
  `origin/dev`; no migration or shared-database deployment was required.
- `COMMERCE-A6-A`: account/onboarding/event-inbox schema foundation is implemented/reviewed
  at local application commit `513cf3a`. Representative 139-to-140 and fresh 140-migration
  disposable lifecycles plus A1-A5/C1-C6 regressions passed with zero residue. It is not
  pushed or deployed to a shared database and adds no Stripe runtime behavior.
- `COMMERCE-A6-B`: tenant payment settings and hosted onboarding is implemented/reviewed at
  local application commit `e8aecea`. The unchanged 140-migration baseline, fake-provider
  lifecycle, tenant/actor boundaries, state, idempotency/concurrency, readiness,
  audit-redaction, build and zero-residue checks passed. It is not pushed or deployed and
  adds no Checkout or Connect webhook behavior.
- `COMMERCE-A6-C`: connected-account Checkout adapter is implemented/reviewed at local
  application commit `34ef64bb`. The unchanged 140-migration baseline, fake-provider
  direct-charge, ownership, readiness, idempotency/concurrency, compensation, redaction,
  build and zero-residue checks passed. It is not pushed or deployed and adds no route,
  UI, webhook or payment transition.
- `COMMERCE-A6-D`: connected-account webhook, Payment/Refund synchronization and
  reconciliation is implemented/reviewed at local application commit `fa670e3c`. The
  unchanged 140-migration baseline, signed fixtures, durable receipt, canonical Payment
  and provider-originated Refund reconciliation, retry/job isolation, A6-B/A6-C
  regressions, build and zero-residue checks passed. It is not pushed or deployed, and no
  shared Connect secret or Event destination was configured.

### FUND

- `1R-A`, `1R-B` and `1R-C` architecture planning: accepted.
- `1R-C1`: implemented and reviewed as passed on disposable PostgreSQL; no shared database
  deployment performed.
- `1R-C2`: implemented and reviewed as passed on disposable PostgreSQL; no shared database
  deployment performed. Its required later Project Intake alignment remains separate.
- `1R-C3`: implemented and reviewed as passed on disposable PostgreSQL; committed on
  application `dev` and documented on IsoDocs `main`; undeployed to shared databases.
- `1R-C4`: implemented and reviewed as passed on disposable PostgreSQL; committed on
  application `dev` and documented on IsoDocs `main`; undeployed to shared databases. It records
  asset/version evidence vocabulary only; media/actor runtime validation, Commerce payment
  authority, physical-artwork checks, explicit backup source selection and production
  authorisation remain later dependencies.
- `1R-C5`: implemented and reviewed as passed on disposable PostgreSQL; application changes
  are committed at `8b5f208`, included on `origin/dev` and undeployed to shared databases. It records
  Event-default, standalone Project and flat-only Event-Project override configuration plus
  C2 acceptance/replacement/finalization evidence, but no calculation or Store behaviour.
- `1P-G-R3`: Project Intake Automated Provisioning Alignment parent planning is accepted as
  a non-executable three-child family. It reconciles the complete implemented 1P-G lifecycle, K1-F and
  1R-C2, records the incomplete historic D1/D2 and K1-F-A/B review chain without inventing
  backdated evidence, and authorises no implementation by itself.
- `1P-G-R3-A`: Project Intake Automation Schema And Form Policy Foundation is implemented,
  reviewed at application `4bb7dd9`, included on `origin/dev` and undeployed to shared databases.
- `1P-G-R3-B`: Project Intake Automated Provisioning And Protection Services is implemented,
  reviewed at application `04da074` and included on `origin/dev`; its documentation lifecycle
  is included in the current IsoDocs baseline. It remains undeployed to shared databases.
- `1P-G-R3-C`: form, confirmation and exception-review alignment is implemented/reviewed,
  committed and promoted to application `origin/dev` at `234f115`; it remains undeployed to
  staging/main and shared databases and adds no migration. It invokes
  R3-B only through aligned atomic confirmation and protected C1 review, preserves historic
  null-contract Intake, sends no invitation email and activates no real form.
- `1P-G-R3-D`: Project Creation Contract Alignment is implemented/reviewed against
  migration 135 at application `e1c2d9f`, now included on `origin/dev` at `3206199`; its
  documentation commit `9d140fa` is included on IsoDocs `origin/main`. It remains
  undeployed to shared databases.
- `1R-D`: Store Readiness And C1 Store Configuration API/Services is implemented/reviewed
  at local application commit `db85fcc`, with no migration or shared deployment.
- The all-source Project Creation Contract Alignment requirement is closed by
  `1P-G-R3-D`; staging/main and shared-database promotion remain separate.
- `1R-C6`: implemented and reviewed as passed at local application commit `9947669`. It
  stores typed FUND Commerce evidence only; no runtime Store, checkout, payment,
  production or commission behavior was added.

## 6. Dependency Map

```text
COMMERCE-A1 complete
  -> COMMERCE-A2 Checkout/Order/Order-line foundation
  -> FUND 1R-C6 typed Commerce context
  -> FUND 1R-D Store readiness/configuration services
  -> COMMERCE-A3 payment/refund/pro-forma schema complete
  -> COMMERCE-A4 audit/idempotency complete
  -> COMMERCE-A5 provider-neutral services complete
  -> COMMERCE-A6 Stripe Connect tenant-payments parent plan (accepted)
     -> A6-A account/event-inbox schema complete
     -> A6-B tenant settings/hosted onboarding complete at `e8aecea`
     -> A6-C connected-account Checkout adapter complete at `34ef64bb`
     -> A6-D webhook/refund reconciliation complete at `fa670e3c`
  -> COMMERCE-A7 FUND consumer integration complete and promoted through staging
  -> FUND 1R-E C1 Store Oversight And C2 Project Store Control Alignment parent accepted
  -> FUND 1R-E-A Store authority/intervention service implemented/reviewed locally
     -> FUND 1R-E-B C1 Store Portfolio Oversight And Exceptional Intervention Surface
        implemented/reviewed as passed locally; no shared deployment
     -> FUND 1R-E-C C2 Project Store Control Surface
        implemented/reviewed/promoted; human acceptance pending promoted E-D workflow
     -> FUND 1R-E-D Default Project Store Instantiation And Eligible Product Reconciliation
        implemented/reviewed at c45a41d9 and included by ancestry in live 7154937;
        separate E-B/E-C real-workflow human acceptance is not inferred
  -> FUND 1R-F Project Offer And Artwork Readiness Reconciliation parent accepted
     -> FUND 1R-F-A Real AMOW Template, Pricing And Deployed Renderer Proof
        formal portfolio NOW for bounded planning; conditional executable proof is NEXT
        and remains unauthorised until the plan is explicitly accepted

FUND 1R-C1 -> C2 -> C3 -> C4 -> C5 -> C6 complete
FUND 1P-G-R3-A -> R3-B -> R3-C -> R3-D complete

Platform Assurance monthly review
  -> classify cross-cutting finding
  -> register in the platform refinement roadmap
  -> parent roadmap explicitly promotes a bounded platform slice when selected
  -> implementation confirmation and independent review/test
  -> restore and monitor the accepted platform gate
```

`1R-C1` and `COMMERCE-A1` are independent schema slices. Separate ownership does not permit
different documentation lifecycles.

## 7. Current Parent Control Decision

The 2026-08-06 reconciliation in Section 0 is the current decision: F3 is complete at exact
deployed application `72c02d92`, and Role Authority is the active project. `PLAT-ROLE-01` is
accepted and complete. `PLAT-ROLE-02` is implemented locally at `5e551938`; its human local
gate is `Now` and its exact-commit staging lifecycle is `Next`. Support Ticketing follows the
completed Role Authority project.
FUND `1R-F-A` is preserved at its exact pre-planning boundary until the housekeeping
outcomes are complete.
R11-A is a separately authorised bounded UI release at `83356030`; local smoke is 18/18 and
staging smoke is all green. The exact commit is aligned through `origin/main`, the live
deployment is triggered and public live health is PASS. Exact Render live-build
identification and authenticated production smoke remain. It does not alter the current
`PLAT-ROLE-02` local/staging `Now`/`Next` pair.
R10-A is complete after the control owner's totally-green production smoke. The detailed
history below explains how the lanes reached that position and must not be read as a
competing selector.

`1R-C1` through `1R-D`, `1P-G-R3-A`/`R3-B`/`R3-C`/`R3-D`, Commerce A1 through A7 and
FUND 1R-E-A are complete through implementation confirmation and review/test. The retained
disposable database is at the complete 141-migration E-A baseline with zero test residue.

The accepted parent family is `1P-G-R3 - Project Intake Automated Provisioning Alignment`.
Its A/B/C child lifecycles are complete and included on `origin/dev`. R3-A is committed at `4bb7dd9`, R3-B at
`04da074`, and R3-C is implemented/reviewed and promoted to application `origin/dev` at
`234f115`; shared staging/main and databases remain unchanged. R3-C passed its
134-migration disposable integration lifecycle and the complete R3-B regression with zero
residue and external email disabled.

For clarity:

- `1R-B` and the parent `1R-C` architecture planning are already accepted and are not to be
  repeated;
- `COMMERCE-A2` is implemented/reviewed at application `3206199` on `origin/dev` and must not be rerun
  as pending work;
- FUND `1R-C1` through `1R-C6` and `1P-G-R3-A`/`R3-B`/`R3-C` must not be rerun as pending work;
- `1R-C3`/`1R-C4` application changes are committed at `686229c` on `origin/dev`, lifecycle
  documents are committed at `f230d14` on IsoDocs `origin/main`, and no shared database
  deployment is claimed;
- `1R-C5` implementation/review is complete at `8b5f208`, included on `origin/dev` and
  undeployed to shared databases;
- `1P-G-R3-A` implementation/review is at application `4bb7dd9` and documentation
  `65fc243`; the application commit is included on `origin/dev` and shared databases remain undeployed;
- `1P-G-R3-B` implementation/review is committed at `04da074`; R3-C connects it only for
  aligned Intake confirmation and protected review;
- `1P-G-R3-D` is implemented/reviewed at application `e1c2d9f`, included on `origin/dev`
  at `3206199`, and documented by `9d140fa` on IsoDocs `origin/main`; it is not pending
  planning work and is not deployed to shared databases;
- FUND `1R-C6` is implemented/reviewed at local application `9947669`, has no shared
  deployment and must not be rerun as pending work;
- Store `1R-D` is implemented/reviewed at local application `db85fcc`, adds no migration,
  has no shared deployment and must not be rerun as pending work;
- `COMMERCE-A3 - Payment, Refund And Pro-forma Schema Foundation` is implemented/reviewed
  at local application `4a90be1`, is undeployed to shared databases and must not be rerun;
- `COMMERCE-A4 - Audit And Idempotency Foundation` is implemented/reviewed at local
  application `5b69920`, is undeployed to shared databases and must not be rerun;
- `COMMERCE-A5 - Provider-neutral Services And Validation` is implemented and reviewed at
  application commit `fd7376b`; its provider-neutral validators and
  idempotency/audit helpers passed disposable tests with zero residue and no migration;
- `COMMERCE-A6-A - Stripe Connect Account And Event-Inbox Schema Foundation` is
  implemented/reviewed at local application commit `513cf3a`; its 140-migration disposable
  lifecycle passed with zero residue, no shared deployment and no Stripe runtime behavior;
- `COMMERCE-A6-B - Tenant Payment Settings And Hosted Onboarding` is implemented/reviewed
  at local application commit `e8aecea` and is not pushed or deployed;
- `COMMERCE-A6-C - Connected-account Checkout Adapter` is implemented/reviewed at local
  application `34ef64bb`; it added no migration, route, UI, webhook or payment transition;
- `COMMERCE-A6-D - Connected-account Webhook, Payment/Refund Synchronization And
  Reconciliation` is implemented/reviewed at local application `fa670e3c`; it added no
  migration, real Stripe action, shared configuration, UI, FUND or production behavior;
- Event policies are defaults for linked Projects, while an active C1-managed flat-rate
  override wins only for its owning Event-linked Project; standalone Project policies may
  be flat or stepped;
- C2 organiser acceptance, not C1 acceptance or moderation, gates Store publication;
  accepted replacement terms apply retrospectively to the Project sales window, provisional
  figures recalculate and first sale does not lock the assignment;
- public backup photographs are conditional production backstops that C1 may explicitly
  select if the physical original is lost or unavailable; C6 now stores their immutable
  typed Order-line evidence, while Commerce payment, physical-original checks and
  production-source authorisation remain deferred;
- the Project Intake alignment recorded by `1R-C2` is now separately planned as
  `1P-G-R3`; the provisional `1R-D` assignment was corrected because that identifier is
  already reserved for the accepted Store-readiness lane;
- FUND `1R-C6` used the Commerce Order/line foundation only for typed evidence relations;
  Store `1R-D` now consumes that completed foundation without creating Orders or payments.

The controlled release sequence is also retained at parent level: promote and verify the
schema-foundation baseline through C4 at `686229c` on staging before combining it with later
LMSPro UI work; then stage and UI-smoke the LMSPro work separately before promotion to
main/live. This is a deployment gate, not a claim that any shared database has been
migrated.

The Platform lane is now a first-class sibling control, with Platform Assurance as
its subordinate finding/refinement register. Its active `PLAT-ASSURE-01` finding is
registered but not selected as the global next executable slice. It therefore does not
displace the current authorised FUND/Commerce sequence.
Until the parent roadmap promotes its bounded remediation, module reviews must disclose
the known repository-wide lint limitation and may provide focused changed-scope lint
evidence without claiming a clean global gate.

### 7.1 Integrated Serial Delivery Control

The root roadmap owns the one serial critical-path queue across sibling lanes. Child
roadmaps continue to own scope and evidence inside their lane, but they must not nominate a
different global next slice.

Default execution for an authorised slice is:

```text
create bounded plan
-> review against accepted architecture/current implementation
-> resolve non-business conflicts and mark accepted
-> implement only accepted scope
-> validate on safe disposable infrastructure
-> create implementation confirmation
-> create review/test record
-> update child and root roadmaps/README
-> stop at the next slice boundary
```

This lifecycle may proceed without repeated user prompts when decisions are already fixed
by accepted architecture and safe local/disposable validation is available. Work must stop
for explicit user input when a genuine business/product choice remains, authority would
expand, destructive/shared-environment work would be required, or the accepted plan cannot
be satisfied safely.

`COMMERCE-A6-D - Connected-account Webhook, Payment/Refund Synchronization And
Reconciliation` is implemented/reviewed at `fa670e3c` against completed A6-A/A6-B/A6-C and
the unchanged 140-migration baseline.

`COMMERCE-A7 - FUND Consumer Integration` is implemented/reviewed as passed at application
commit `598305ce` on the unchanged 140-migration baseline and is included in the completed
dev/staging promotion at `91e8751c`:

`docs/core/commerce/03-slice-planning/2026-07-15-isostack-commerce-core-slice-commerce-a7-fund-consumer-integration-implementation-planning.md`

A7 remains a dormant internal boundary with no route, UI or real Stripe action. Its
staging health and human smoke gates passed. The FUND
`1R-E - C1 Store Oversight And C2 Project Store Control Alignment` parent plan is reviewed
and accepted. The bounded `1R-E-A - Store Authority, Exceptional Intervention And
Lifecycle Service Alignment` lifecycle is implemented/reviewed as passed locally against
the new 141-migration disposable baseline. The bounded `1R-E-B - C1 Store Portfolio
Oversight And Exceptional Intervention Surface` implementation/review lifecycle is
complete and promoted through application dev/staging at `e3f44b4b` without an E-B
schema/migration change. `1R-E-C - C2 Project Store Control Surface` is included in the
same promoted application commit without an E-C migration; its authenticated human UI
acceptance awaits controlled promotion of the now-implemented Project-to-Store/default-
Product workflow. Bounded `1R-E-D - Default Project Store Instantiation And Eligible Product
Reconciliation` is implemented/reviewed at `c45a41d9` and integrated/revalidated on
application `dev`/`origin/dev` at `174dc8ac` without an E-D migration or shared database
change. Its application commit is now included by ancestry in live `7154937`; this does not
invent separate E-B/E-C real-workflow human acceptance. The non-executable
`1R-F - Project Offer And Artwork Readiness Reconciliation` parent is reviewed/accepted.
`1R-F-A - Real AMOW Template, Pricing And Deployed Renderer Proof` is selected as formal
portfolio `Now` for bounded planning; its conditional executable proof is `Next`. No proof,
`1R-G` or artwork/template production implementation is authorised.

`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-e-b-c1-store-portfolio-oversight-exceptional-intervention-surface-implementation-planning.md`

`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-e-c-c2-project-store-control-surface-implementation-planning.md`

`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-e-c1-store-oversight-c2-project-store-control-alignment-planning.md`

`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-e-a-store-authority-exceptional-intervention-lifecycle-service-alignment-implementation-planning.md`

The subordinate FUND strategic completion overview and its three 2026-07-15 CR inputs are
now registered through the authoritative FUND roadmap. A7 planning must read them so the
integration preserves exact workflow and immutable FUND offer evidence, but A7 remains a
thin cross-lane consumer boundary. It must not absorb Template Manager/Artwork Template,
collective artwork approval, C1/public Store UI, production, fulfilment or commission
implementation. CR open questions remain with their later bounded FUND workstreams unless
an answer is strictly required to define the A7 contract.

## 8. Child Roadmap Discipline

Child roadmaps own detailed slice ordering inside their lanes. This parent roadmap records
only:

- sibling ownership;
- cross-lane dependencies;
- shared gates;
- the currently authorised handoff between lanes.

The Platform roadmap owns shared-platform slice lifecycle and its subordinate Platform
Assurance roadmap owns the recurring monthly security and assurance finding register.
Their entries follow the same promotion and evidence discipline as module refinements and
cannot nominate themselves as the global next slice.

When a child status changes, update the child roadmap first and then this root summary.
