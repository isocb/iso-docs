# IsoStack Platform Roadmap And Slice Control

Date: 2026-07-22

Last reconciled: 2026-08-10

Status: Active authoritative Platform child roadmap; no implementation authorised by
this document alone

Parent control:

`docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`

Subordinate assurance/refinement control:

`docs/platform/00-roadmap-control/2026-07-22-isostack-platform-assurance-security-review-and-refinement-roadmap.md`

Application routing reference:

`isostack-bedrock/src/app/README.md`

## 0. Authoritative CR Inventory And Current Platform Disposition — 2026-08-10

This file is confirmed as the one authoritative Platform child roadmap. The Platform
Assurance, Security Review And Refinement Roadmap remains a subordinate finding/register
and cannot select the global next slice. The root Platform/module roadmap remains the
cross-lane `Now`/`Next` authority.

Every Platform CR input must be registered in this table in the same documentation change
that creates the CR. Registration confirms traceability only; it does not perform triage,
select a slice or authorise implementation. Later triage, planning, implementation and
review records must update the same row rather than leaving the CR cognitively active by
default.

| Source CR | Current disposition | Roadmap treatment |
| --- | --- | --- |
| [`2026-07-22-isostack-platform-node-middleware-request-body-finalisation-defect-cr.md`](../01-cr-inputs/2026-07-22-isostack-platform-node-middleware-request-body-finalisation-defect-cr.md) | Completed through `PLAT-RUNTIME-01`; subsequently included in the completed LMSPro R8-A production release | Closed historical corrective input; do not reopen without a new finding |
| [`2026-07-27-isostack-platform-auth-dependency-and-audit-gate-security-remediation-cr-input.md`](../01-cr-inputs/2026-07-27-isostack-platform-auth-dependency-and-audit-gate-security-remediation-cr-input.md) | Completed through the documented `PLAT-ASSURE-03` dev/staging lifecycle and human gate; no separate production claim is added by this reconciliation | Closed at its recorded evidence boundary; `PLAT-REFINE-03` and `PLAT-REFINE-04` retain separate follow-up concerns |
| [`2026-08-04-isostack-core-platform-and-seasonpro-role-authority-clarification-and-remediation-cr.md`](../01-cr-inputs/2026-08-04-isostack-core-platform-and-seasonpro-role-authority-clarification-and-remediation-cr.md) | Active root project; delivered containment release `60ac76c1` is aligned through main; local matrix, staging 8/8, all exact branch scans and public health pass | Production exact-build/non-mutating smoke is `Now`; conditional `PLAT-ROLE-03` authority decision follows |
| [`2026-08-10-isostack-platform-plat-role-02a-seasonpro-owner-user-type-control-correction-sub-cr.md`](../01-cr-inputs/2026-08-10-isostack-platform-plat-role-02a-seasonpro-owner-user-type-control-correction-sub-cr.md) | Corrective child of `PLAT-ROLE-02`; authoritative-profile correction is technically/human accepted and included in exact main `60ac76c1` | Complete bounded child; shared promotion evidence retained by the parent release |
| [`CR-Fix-2026-08-10-isostack-platform-plat-role-02b-club-officials-authority-integrity.md`](../01-cr-inputs/CR-Fix-2026-08-10-isostack-platform-plat-role-02b-club-officials-authority-integrity.md) | Implemented/accepted as Role child `b1ede26f`, retained in exact main `60ac76c1`; staging 8/8 and exact-Club proof pass | Corrective child delivered; production non-mutating completion evidence remains with parent release |
| [`2026-08-05-isostack-core-platform-support-ticketing-client-readiness-and-communications-cr.md`](../01-cr-inputs/2026-08-05-isostack-core-platform-support-ticketing-client-readiness-and-communications-cr.md) | Captured; selected as the mandatory self-contained project after Role Authority; awaiting formal Platform triage | Client-enablement and privacy/security project; internal-note privacy, server lifecycle authority and notification operability precede client enablement; Platform Notice remains separable and non-expedite |
| [`CR-Fix-2026-08-09-isostack-platform-protected-branch-security-scan-advisory-refresh.md`](../01-cr-inputs/CR-Fix-2026-08-09-isostack-platform-protected-branch-security-scan-advisory-refresh.md) | Dependency child `60ac76c1`; exact dev/staging/main scans, staging smoke and staging/production health PASS | Delivered through main; retain exact scan evidence with the combined release |

Current Platform portfolio disposition:

- local and remote dev, staging and main are exact combined candidate `60ac76c1`: Role
  child `b1ede26f` followed by dependency child `60ac76c1`;
- Role Authority is active. `PLAT-ROLE-01` is corrected, accepted and complete.
  `PLAT-ROLE-02` was corrected at `7e453665`; `PLAT-ROLE-02A` is technically and
  human-accepted. The complete parent 1–18 human matrix now
  passes. `PLAT-ROLE-02B` is implemented and technically accepted and its exact disposable
  fixture is repaired. The item-7 focused retest and read-only Derby exact-junction proof
  pass, completing the local Role gate. The staging gate then passed 8/8, including a
  read-only exact-current-Club junction proof, and `60ac76c1` is aligned through main.
  Support Ticketing remains the mandatory following
  self-contained project and still requires triage and bounded planning;
- exact dev Security Scan `31384553388`, staging `31384766945`, main `31387014370`, staging
  smoke 8/8 and staging/production public health pass. Production Render exact-build
  confirmation and the bounded non-mutating C1/C2 route smoke are the current gate;
- an evidenced live security/privacy failure may still be proposed to the root as an
  expedite candidate under the ordinary control process.

Prepared Role Authority sequence:

1. [`PLAT-ROLE-01 — Authority Inventory And Canonical Matrix`](../03-slice-planning/2026-08-06-isostack-platform-plat-role-01-authority-inventory-and-canonical-matrix-planning.md) — complete; all 13 matrix items accepted with corrected C1/C2 persona wording;
2. [`PLAT-ROLE-02 — Core-Role Mutation Containment`](../03-slice-planning/2026-08-06-isostack-platform-plat-role-02-core-role-mutation-containment-planning.md) — complete item-1-through-item-18 matrix accepted and included in exact main `60ac76c1`;
3. [`PLAT-ROLE-02A — SeasonPro Owner User-Type Control Correction`](../03-slice-planning/2026-08-10-isostack-platform-plat-role-02a-seasonpro-owner-user-type-control-correction-planning.md) — technically/human accepted and delivered with the parent release;
4. [`PLAT-ROLE-02B — Club Officials Authority Integrity`](../03-slice-planning/2026-08-10-isostack-platform-plat-role-02b-club-officials-authority-integrity-planning.md) — complete local/staging pass including parent 18/18, focused item 7 and read-only exact-current-Club junction proofs; delivered with the parent release;
5. [`PLAT-ROLE-03 — Canonical Core Authority Service And Owner Safety`](../03-slice-planning/2026-08-06-isostack-platform-plat-role-03-canonical-core-authority-service-and-owner-safety-planning.md) — conditional Platform service;
6. [`LMS-ROLE-01 — SeasonPro User Authority Consumer Alignment`](../03-slice-planning/2026-08-06-isostack-platform-lms-role-01-seasonpro-user-authority-consumer-alignment-planning.md) — conditional consumer alignment; and
7. [`LMS-ROLE-02 — SeasonPro Access Parity And Read-Only Enforcement`](../03-slice-planning/2026-08-06-isostack-platform-lms-role-02-seasonpro-access-parity-and-read-only-enforcement-planning.md) — conditional UI/server parity.

The controlling triage is
[`2026-08-06-isostack-core-platform-seasonpro-role-authority-triage.md`](../02-triage/2026-08-06-isostack-core-platform-seasonpro-role-authority-triage.md).

## 1. Purpose

This roadmap brings continued development of the shared IsoStack Platform under the
same controlled lifecycle used by LMSPro, FUND and Commerce Core.

It corrects the historic absence of a dedicated Platform planning hierarchy. It does
not retroactively manufacture change requests, plans, implementation confirmations or
review evidence for work completed before this control was adopted.

New Platform work must move through explicit requirement capture, ownership/impact
triage, bounded planning, implementation evidence and independent review/test before its
roadmap or deployment status changes.

## 2. Controlled Documentation Hierarchy

```text
docs/platform/
├── 00-roadmap-control
├── 01-cr-inputs
├── 02-triage
├── 03-slice-planning
├── 04-implementation-confirmations
└── 05-review-and-test
```

The lifecycle is:

```text
business/technical finding
-> 01-cr-inputs
-> 02-triage and ownership decision
-> Platform/root roadmap selection
-> 03 bounded slice planning
-> implementation on a dedicated branch
-> 04 implementation confirmation
-> 05 independent review and test
-> human UI or operational gate where required
-> child/root roadmap reconciliation
-> normal dev, staging and live promotion controls
```

No phase may be treated as evidence for a later phase. In particular:

- a CR does not authorise implementation;
- triage is not a slice plan;
- a plan is not evidence that code exists;
- implementation confirmation records actual work and verification only;
- automated checks do not replace required human UI/operational testing; and
- a review record does not itself authorise promotion.

## 3. Platform Ownership Boundary

Platform owns reusable IsoStack capabilities such as:

- authentication, session and account gates;
- organisation/tenant administration and shared role/permission behaviour;
- Platform Admin and shared tenant-administration surfaces;
- common application shell, navigation, settings and support infrastructure;
- reusable media, import/export, communication and audit infrastructure;
- shared tRPC/API, server Core, security and tenancy controls;
- common components and platform-level user experience; and
- platform engineering assurance, toolchain and CI controls.

Relevant application areas may include:

```text
src/app
src/core
src/components
src/server/core
src/lib
src/hooks
src/styles
src/tests
```

These paths are indicators, not automatic ownership. `src/app` is a composition and route
boundary containing shared platform, public, Commerce and module entry points.

Ownership follows the capability being changed:

| Change | Owning lifecycle |
| --- | --- |
| Shared authentication, organisation, settings, Platform Admin or application-shell behaviour | Platform |
| Generic checkout, Order, money or payment behaviour | Commerce Core |
| FUND business behaviour or a route that merely composes FUND services/UI | FUND |
| LMSPro/SeasonPro business behaviour or a route that merely composes LMSPro services/UI | LMSPro |
| Reusable platform contract plus module adoption | Platform parent/contract slice followed by bounded module consumer work, unless the root roadmap accepts a different coordinated boundary |

Moving code into `src/app` does not transfer domain ownership to Platform. Conversely,
a reusable platform defect discovered by a module must be elevated into this lane rather
than hidden inside unrelated module remediation.

## 4. Relationship To Existing Controls

This roadmap is a sibling of:

- Commerce Core:
  `docs/core/commerce/00-roadmap-control/2026-07-13-commerce-core-roadmap-and-slice-control.md`;
- FUND:
  `docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`; and
- LMSPro:
  `docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md`.

The root roadmap owns the one serial cross-lane next-slice decision. This Platform
roadmap may register and prepare candidates but cannot bypass the root sequence.

The Platform Assurance, Security Review And Refinement Roadmap is subordinate to this lane.
It captures monthly and cross-cutting findings; it is not a second executable roadmap.

## 5. Change-Request And Triage Contract

A Platform CR input should state:

- the observed problem or desired outcome;
- affected users, roles, tenants and surfaces;
- evidence and reproduction information where applicable;
- whether the concern is shared or was merely discovered through a module;
- known security, privacy, data, deployment and compatibility implications;
- settled business/technical decisions;
- open questions; and
- explicit non-goals.

Triage must then determine:

1. the owning lane;
2. whether the issue is a defect, remediation, refinement, security finding or new
   capability;
3. severity and urgency without confusing importance with execution authority;
4. affected contracts, repositories, environments and consumers;
5. whether architecture/decision work is needed before executable planning;
6. whether the item should be rejected, consolidated, deferred, registered or promoted;
7. the smallest safe slice boundary; and
8. which root-roadmap dependency or current slice would be displaced if promoted.

## 6. Bounded Slice Planning Contract

Every executable Platform slice plan must define:

- exact objective and acceptance criteria;
- authoritative requirements and triage inputs;
- inspected current implementation and confirmed gap;
- in-scope files/contracts and explicit non-goals;
- role, tenant and permission boundaries;
- schema/migration/data implications, including no-change statements where applicable;
- security/privacy and failure-mode implications;
- compatibility implications for modules and public routes;
- implementation sequence and rollback/recovery boundary;
- focused, regression, build and static-analysis tests;
- required human UI, accessibility, operational or deployment smoke;
- documentation/evidence outputs; and
- the stop condition before the next slice.

Planning must not use broad labels such as “Core cleanup” to combine unrelated debt. A
cross-cutting change should be decomposed into reviewable slices with explicit consumer
impact.

## 7. Implementation And Evidence Contract

Implementation should occur on a dedicated branch based on the controlled development
baseline. The implementation window may update source and the accepted slice documents,
but it must not silently expand scope or mark roadmap status without evidence.

The matching implementation confirmation records:

- exact branch and commit boundary;
- files/contracts actually changed;
- migrations and environment changes actually introduced;
- tests and commands actually run with their outcomes;
- deviations from the accepted plan;
- known limitations and pending human/external gates; and
- explicit statements of what was not deployed or promoted.

The matching review/test record independently assesses:

- requirement and scope conformance;
- security, tenant and permission boundaries;
- regression and integration evidence;
- test quality and failure-path coverage;
- UI/accessibility/operational testing where applicable;
- migration and rollback safety where applicable;
- documentation accuracy; and
- pass, conditional pass, fail or blocked disposition.

## 8. Emergency And Small-Fix Rule

Small fixes still require the lifecycle. The documents may be concise and a single bounded
record may cross-reference closely related evidence, but phases must remain distinguishable.

For a genuine production incident, emergency containment may precede the full written
cycle only under the accepted incident/deployment authority. The CR, triage, bounded scope,
implementation evidence and review/test must then be completed as incident follow-through;
emergency status is not permission to omit the lifecycle permanently.

## 9. Historic Work And Adoption Boundary

The initial IsoStack build predates this hierarchy. Historic documents may be cited as
architecture or provenance, but their existence must not be reclassified as a completed
modern slice lifecycle.

From 2026-07-22 onward:

- new Platform work uses this hierarchy;
- active work entering implementation should first receive triage and a bounded plan;
- already implemented historic behaviour is not reopened solely to create paperwork;
- a later material change to historic behaviour enters as a new CR/remediation slice; and
- discovered cross-cutting debt enters the refinement/assurance register until promoted.

## 10. Current Registered And Executable Work

`PLAT-ASSURE-01 - Repository-wide Lint, Typed-Test Coverage And CI Gate Remediation` is the
first registered platform assurance finding. It is controlled by:

`docs/platform/00-roadmap-control/2026-07-22-isostack-platform-assurance-security-review-and-refinement-roadmap.md`

It is high priority but is not an executable slice and does not displace the root roadmap's
current next candidate unless the root control explicitly promotes it.

`PLAT-REFINE-02 - Unified Tenant-User Provisioning And Account-Status Contract` is
registered in the subordinate assurance/refinement roadmap after an LMSPro investigation
confirmed divergent P1 and C1 creation outcomes on application baseline `df40f45c`.

Platform owns the reusable transactional account/tenant provisioning boundary, same-tenant
idempotent completion, cross-tenant fail-closed email conflict, account-status matrix,
authentication enforcement, shared audit evidence and integration-test contract. LMSPro
owns its bounded consumer adoption: required/default LMSPro roles and affiliations,
repairable `Unassigned` visibility and the P1-to-C1-to-login human acceptance path.

The item is a high-priority registered wishlist/finding, not an executable slice. It does
not authorise code, schema, migration or data repair; it does not displace the root
roadmap's selected work. A read-only partial-account inventory must precede any later
repair authority. Until controlled remediation is promoted, LMSPro users should be created
through the C1 LMSPro User Management surface.

`PLAT-REFINE-03 - Shared Module Route Entitlement Guard And Access-Denied Contract` is
registered from authenticated `PLAT-ASSURE-03` staging smoke on exact application commit
`df40f45c`. An LMSPro-only session can render the static `/app/fund` dashboard shell by
direct URL, while Product-derived tRPC and domain mutation checks subsequently refuse
operations.

Application history and static review place the ungated FUND shell at least as far back as
its initial 2026-06-11 entry-point commit `db6ff5ff`; it is not an Auth.js remediation
regression. Platform owns the reusable effective-user/effective-organisation module-route
guard and consistent handled refusal contract. FUND refinement `2R-ACCESS-01` owns the
first bounded consumer adoption and FUND-specific client-member/public-route exceptions.

The item is medium priority and non-executable, with mandatory elevation if its read-only
route/API inventory finds tenant data disclosure or a broader authorization bypass. It
does not reopen or expand `PLAT-ASSURE-03`, and it does not displace the root roadmap's
selected work.

`PLAT-REFINE-04 - Impersonation Effective-Principal And Tenant-View Contract` is
registered from the same authenticated staging schedule. P1 impersonation reached the
expected C1 dashboard, but tenant content appeared new or empty; stop/sign-out and routing
behaved correctly.

Static review found that shared context resolves an effective user and organisation while
many LMSPro reads still use the real P1 session identity, and RLS retains the real
Platform-administrator bypass. Platform owns a single validated effective-principal
contract, consistent data/authorization propagation, dual-actor audit evidence and
fail-closed lifecycle behaviour. LMSPro, FUND and shared tenant surfaces provide
representative consumer acceptance.

The item is medium priority and non-executable, with mandatory elevation if its read-only
inventory finds cross-tenant disclosure, unauthorised mutation or another security-boundary
failure. It predates the bounded Auth.js remediation, does not reopen `PLAT-ASSURE-03` and
does not displace the root roadmap's selected work.

`PLAT-RUNTIME-01 - Node Middleware Request-Body Finalisation Backport And
Production-Runtime Assurance` is the most recently completed Platform corrective slice. It was
discovered through LMSPro R8-A3 staging testing but is Platform-owned because the defect sits
in shared Node middleware before tRPC/domain execution.

Lifecycle control:

- `docs/platform/01-cr-inputs/2026-07-22-isostack-platform-node-middleware-request-body-finalisation-defect-cr.md`;
- `docs/platform/02-triage/2026-07-22-isostack-platform-node-middleware-request-body-finalisation-defect-triage.md`; and
- `docs/platform/03-slice-planning/2026-07-22-isostack-core-platform-slice-plat-runtime-01-node-middleware-request-body-finalisation-backport-planning.md`.

LMSPro R8-A3 human attachment testing was blocked until PLAT-RUNTIME-01 passed its automated
review and separately controlled staging smoke.

Implementation and automated review now pass at exact dedicated-branch application commit
`6b822e45`. Clean Node 22 installation, fail-closed patch verification, full Vitest, type-check,
ordinary/standalone builds and repeated small/representative/10 MiB runtime probes passed. The
commit was subsequently fast-forwarded through `origin/dev` to `origin/staging`. The mandatory
Platform staging smoke passed. A dependent delivery failure was then isolated through R8-A3-F1 to
an incorrect plural private-bucket name in the staging cron; after correction to
`seasonpro-email-attachment-staging`, a fresh large-PDF Email queued, processed, updated the UI and
arrived with its attachment. PLAT-RUNTIME-01 is complete at the staging acceptance boundary and no
longer blocks LMSPro R8-A3 testing. `main`/live promotion remains separately controlled.

## 11. Current Control Decision

The Platform lifecycle hierarchy is active for future work. No application code,
schema, migration, infrastructure, deployment or promotion is authorised by establishing
this control.

The current Platform action is:

```text
PLAT-RUNTIME-01 staging acceptance complete
-> control returned to LMSPro R8-A3
-> R8-A3 staging acceptance and evidence reconciliation complete
-> current combined staging-to-main release HOLD pending cross-lane/live-migration gates
```

The governing production decision is:

`docs/00-roadmap-control/2026-07-23-lmspro-r8-a3-and-combined-staging-bundle-production-risk-assessment-and-promotion-decision.md`

PLAT-RUNTIME-01 itself is not reopened. Its production inclusion is governed as part of the
exact combined release or a separately planned selective LMSPro dependency bundle.

## 12. Reconciliation Rule

When a Platform item changes state:

1. when a CR input is created, add or update its governed-inventory row here in the same
   documentation change;
2. update its lifecycle record in the appropriate folder;
3. update this child roadmap disposition;
4. reconcile any subordinate assurance/refinement entry;
5. update the root roadmap last when the item changes a cross-lane dependency, expedite
   posture or portfolio `Now`/`Next`; and
6. record promotion separately from implementation completion.

No Platform planning window may independently claim implementation, testing,
deployment or roadmap completion that occurred elsewhere.
