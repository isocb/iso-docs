# IsoStack Platform Roadmap And Slice Control

Date: 2026-07-22

Status: Active authoritative Platform child roadmap; no implementation authorised by
this document alone

Parent control:

`docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`

Subordinate assurance/refinement control:

`docs/platform/00-roadmap-control/2026-07-22-isostack-platform-assurance-security-review-and-refinement-roadmap.md`

Application routing reference:

`isostack-bedrock/src/app/README.md`

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

`PLAT-RUNTIME-01 - Node Middleware Request-Body Finalisation Backport And
Production-Runtime Assurance` is the current executable Platform corrective slice. It was
discovered through LMSPro R8-A3 staging testing but is Platform-owned because the defect sits
in shared Node middleware before tRPC/domain execution.

Lifecycle control:

- `docs/platform/01-cr-inputs/2026-07-22-isostack-platform-node-middleware-request-body-finalisation-defect-cr.md`;
- `docs/platform/02-triage/2026-07-22-isostack-platform-node-middleware-request-body-finalisation-defect-triage.md`; and
- `docs/platform/03-slice-planning/2026-07-22-isostack-core-platform-slice-plat-runtime-01-node-middleware-request-body-finalisation-backport-planning.md`.

LMSPro R8-A3 human attachment testing remains explicitly blocked until PLAT-RUNTIME-01 passes
its automated review and separately controlled staging smoke.

Implementation and automated review now pass at exact dedicated-branch application commit
`6b822e45`. Clean Node 22 installation, fail-closed patch verification, full Vitest, type-check,
ordinary/standalone builds and repeated small/representative/10 MiB runtime probes passed. The
commit is not pushed, merged or deployed. PLAT-RUNTIME-01 and LMSPro R8-A3 remain blocked on the
separately controlled staging promotion and human/operational smoke.

## 11. Current Control Decision

The Platform lifecycle hierarchy is active for future work. No application code,
schema, migration, infrastructure, deployment or promotion is authorised by establishing
this control.

The current Platform action is:

```text
review exact PLAT-RUNTIME-01 commit 6b822e45 for controlled branch/dev/staging promotion
-> stop before staging deployment without explicit authority
-> run separately authorised staging smoke
-> hand control back to LMSPro R8-A3 only after PASS
```

## 12. Reconciliation Rule

When a Platform item changes state:

1. update its lifecycle record in the appropriate folder;
2. update this child roadmap;
3. reconcile any subordinate assurance/refinement entry;
4. update the root roadmap last; and
5. record promotion separately from implementation completion.

No Platform planning window may independently claim implementation, testing,
deployment or roadmap completion that occurred elsewhere.
