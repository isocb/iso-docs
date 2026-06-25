# FUND Roadmap And Slice Control

Date: 2026-06-25

Status: Active control document

Purpose:

```text
Provide one current roadmap and slice-control view so future FUND work does not depend on reconstructing context from many individual slice documents.
```

This document is planning/documentation only. It does not implement code, change Prisma schema, create migrations, run deployment commands or start new feature work.

## 1. Current Released Baseline

The FUND C1 admin foundation has been tested on staging and accepted as the release baseline.

Current released app baseline:

```text
62b727e chore(release): promote FUND C1 admin foundation
```

Current branch alignment after 1P-D staging alignment:

```text
main    = 62b727e released C1 admin foundation baseline
dev     = f43d63b 1P-D C2 read-only organiser dashboard UI
staging = f43d63b 1P-D C2 read-only organiser dashboard UI
```

Release result:

- FUND C1 admin foundation is released on `main`.
- SeasonPro/LMSPro export hotfix is included in the released baseline.
- Staging browser testing found no blocking C1 admin foundation issues before release alignment.
- FUND remains expected to need refinement; the baseline is accepted as the foundation, not as final product polish.
- 1P-R1/1P-R1A remediation, 1P-B schema work and 1P-C read-only organiser Project API/services were aligned to `staging` at `69a9632`.
- 1P-D read-only organiser dashboard UI has been implemented on `feature/fund-phase-1-c2-project-access` at `f43d63b`, reviewed with caveats and aligned to `dev` and `staging`.
- 1P-D staging alignment was pushed by operator request; Render deployment and migration confirmation remain post-deploy checks.
- A post-1P-D C2 organisation/account scope clarification has been raised. The current participant-scoped dashboard remains safe but should be treated as an interim bridge until this is decided.
- Additional correction: C2 is the Project management node, not a passive/read-only recipient of Project information. Future C2 dashboard work must be Client/account scoped, not merely participant scoped.
- AMOW founding-tenant priority has been re-centred on the C1 organisational dashboard: C1 Client management, Products, Events, Projects and the operational framework for managing fundraising Clients and their Projects.
- 1P-D remains technically safe but is not the immediate AMOW product priority.
- 1P-F-C C1 Client Management schema has been implemented locally on the active FUND branch as schema-only work; it is not promoted to `main`.
- 1P-F-D C1 Client Management API/services has been implemented locally on the active FUND branch.
- 1P-F-E C1 Client Management UI is the next recommended planning/implementation lane.
- Project Intake / Project Request forms are a future critical lane. C1-created forms may eventually collect external or Client-originated Project requests and, after C1 moderation, create or link Client/account, C2 user/member, Project and Event records.
- Notification management remains deferred. Project intake, Client creation, C2 user creation and Project approval must not accidentally send notifications until controlled communications are explicitly planned.
- Staging `/api/health` returned HTTP 200 after alignment.
- `main` remains held at `62b727e` until the 1P-B/staging migration and smoke testing are accepted.
- Docs repo `main` latest before this staging-readiness update was `c4aaff0`.

## 2. Current Branch Landscape

### Release Branches

```text
main
dev
staging
```

Current state:

```text
main held at 62b727e
dev aligned at f43d63b
staging aligned at f43d63b
```

Use:

- `main` is the live/release baseline.
- `dev` is the integration baseline for the current C2 access lane and now includes 1P-D.
- `staging` carries 1P-D for Render deployment and authenticated smoke validation.

### Active FUND Branch

```text
feature/fund-phase-1-c2-project-access
```

Purpose:

- FUND C2 organiser access model planning.
- Immediate C1 admin remediation from first release feedback.
- Architecture planning for Event/Catalogue/Product availability and workflow suitability.

This branch should not absorb unrelated SeasonPro remediation unless intentionally cherry-picked.

### Active SeasonPro Remediation Branch

```text
feature/seasonpro-remediation
```

Purpose:

- SeasonPro/LMSPro fixes that should be testable/promotable without carrying unfinished FUND work.

This branch exists so SeasonPro remediation can move independently of future FUND C2 development.

### Retired / Historical FUND Feature Branch

```text
feature/fund-phase-1-products-catalogues
```

Purpose:

- Historical branch used for the C1 admin foundation.
- It has been promoted into the release baseline.

Recommendation:

```text
Do not continue new work on this branch.
```

## 3. Completed C1 Admin Foundation Slices

The completed C1 foundation is documented across planning and implementation confirmation files in:

```text
isodocs/docs/modules/fund/Planning/
isodocs/docs/modules/fund/implementation/
```

### Completed Slice Summary

| Slice | Area | Status |
| --- | --- | --- |
| 1C | Product Workflow Classes | Complete |
| 1D | Products/Catalogues schema | Complete |
| 1E | Products/Catalogues API/services | Complete |
| 1F-A | Products/Catalogues core admin UI | Complete |
| 1F-B | Catalogue Product membership manager | Complete |
| 1G | Products/Catalogues review/remediation | Complete |
| 1H | Project schema | Complete |
| 1I | Project API/services | Complete |
| 1J-A | Project list and child management shell | Complete |
| 1J-B | Project Product membership manager | Complete |
| 1K | Project admin UI review/manual testing | Complete |
| 1L-A | FundEvent schema | Complete |
| 1L-B | FundEvent API/services | Complete |
| 1L-C | FundEvent API/manual review | Complete |
| 1M-A | FundEvent admin UI | Complete |
| 1M-B | Project Event selector/linkage UI | Complete |
| 1M-C | Project/Event linkage UI review | Complete |
| 1N | C1 admin foundation authenticated review | Complete |
| 1O | C1 admin foundation staging readiness/release alignment | Complete |
| 1P-A | C2 Project Access Model Planning | Complete |
| 1P-B | C2 Project Participant Schema | Complete / aligned to dev+staging |
| 1P-C | C2 Read-Only Project API/Services | Complete / reviewed / aligned to dev+staging |
| 1P-C-R1 | C2 Read-Only Project API/Services Review | Complete / proceed with caveats |
| 1P-D | C2 Read-Only Organiser Dashboard UI | Implemented / reviewed with caveats |
| 1P-D-R1 | C2 Dashboard UI Review And C2 Organisation Scope Note | Complete / proceed with caveats |
| 1P-D0 | C2 Organisation Scope Clarification | Active planning clarification |
| 1P-F | C2 Client/Account Organisation Model Planning | Active architecture planning |
| 1P-F-CORR | C2 Client/Account As Project Management Node Planning | Active architecture correction |
| 1P-F-A | C1 Client Management Foundation For AMOW | Planning complete |
| 1P-F-B | C1 Client Management Schema Options | Planning complete |
| 1P-F-C | C1 Client Management Schema | Implemented locally / schema only |
| 1P-F-D | C1 Client Management API/Services | Implemented locally / API-services only |
| 1P-F-E | C1 Client Management UI | Recommended next |

### C1 Admin Surfaces Released

Released C1/admin routes include:

```text
/app/fund
/app/fund/products
/app/fund/projects
/app/fund/projects/[id]
/app/fund/events
/app/fund/events/[id]
```

Released C1/admin domains include:

- Products.
- Catalogues.
- Catalogue Product membership.
- Projects.
- Project Product membership.
- Events.
- Project/Event linkage.
- Activation readiness basics.
- FUND module/product allocation foundation.

## 4. Current Remediation Lane

Source triage document:

```text
isodocs/docs/modules/fund/02-triage/2026-06-25-fund-c1-admin-remediation-and-architecture-triage.md
```

Source issue export:

```text
isodocs/docs/modules/fund/01-cr-inputs/change-request-cmqt61xmf000612xt5ifl1mdn-2026-06-25.md
```

### Immediate Remediation

These have been handled at code/static-check level and should receive an authenticated browser spot-check before staging promotion:

1. Issue #46 - Project close date after linked Event close date accepted.
2. Issue #50 - Issue Manager module filtering/server render error.

### Near-Term UI/UX Remediation

These were included because scope remained small:

1. Issue #47 - Adding a Project Product is an activation gate but not intuitive.
2. Issue #44 - Product breadcrumb navigation.
3. Issue #45 - Sidebar icons repeated; update UI guidance.

### 1P-R1A UI Consistency Addendum

An iterative UI consistency addendum was documented retrospectively as:

```text
03-slice-planning/2026-06-25-fund-phase-1-slice-1p-r1a-c1-admin-ui-consistency-remediation.md
04-implementation-confirmations/2026-06-25-phase-1-slice-1p-r1a-c1-admin-ui-consistency-remediation-confirmation.md
```

It covers:

- whole-card FUND dashboard navigation;
- brand/semantic colour use instead of decorative peer-card colours;
- column-header sort/reverse-sort;
- consistent breadcrumbs;
- destination-specific navigation icons;
- Issue Manager `Modules` CRUD field consolidation to match filtering, badges and CR exports.

Recommended branch:

```text
feature/fund-phase-1-c2-project-access
```

Recommended remediation principle:

```text
Fix the C1 foundation in place before exposing dependent behaviour to C2 organisers.
```

### Current C2 Access Lane Status

Current branch state:

```text
feature/fund-phase-1-c2-project-access = f43d63b
dev                              = f43d63b
staging                          = f43d63b
main                             = 62b727e
```

Current C2 lane status:

- 1P-A access model planning is complete.
- 1P-B participant schema is implemented.
- 1P-C read-only organiser Project API/services are implemented and reviewed.
- 1P-D read-only organiser dashboard UI is implemented and statically reviewed with caveats.
- 1P-D0 C2 organisation/account scope clarification has been raised and must be decided before C2 expansion.

Staging migration note:

- Render build runs `prisma migrate deploy` through `scripts/render-build.sh`.
- Neon Prisma migrations are expected to happen automatically during Render deployment because the Render build executes `prisma migrate deploy`.
- Direct staging `_prisma_migrations` inspection was not available from the local shell.
- Local shell checks found no Render CLI, no Neon CLI and no exposed staging database environment variable.
- Migration `20260625143000_add_fund_project_participants` exists locally.
- 1P-D staging alignment has been pushed; confirm in Render/Neon that deployment completed and `20260625143000_add_fund_project_participants` has applied before authenticated smoke testing.
- Lightweight staging health check after alignment returned HTTP 200 for `/api/health`.

### Live Issue Status Register

This table is the current compact issue-status view for planning. It should be updated after remediation, review or architecture-planning slices so future planning does not require rereading every triage note.

| Issue | Current Status | Category | Next Action | Blocks C2? | Blocks Store/Commerce? | Current / Suggested Slice |
| --- | --- | --- | --- | --- | --- | --- |
| #46 Project/Event close-date constraint | Remediated in 1P-R1; 1P-R2 static/check review passed | Immediate remediation | Authenticated browser spot-check before staging promotion | No for planning; spot-check before promotion | No, but must remain clean before Store date generation | Browser spot-check / next promotion gate |
| #50 Issue Manager module filtering/server render error | Remediated in 1P-R1; module-field confusion corrected in `ce65830` | Immediate platform remediation | Smoke-test Issue Manager module filter and modal field behaviour on staging | No | No | Staging smoke test |
| #47 Product activation gate visibility | Small UX remediation included in 1P-R1; 1P-R2 static/check review passed | UI/UX polish | Browser spot-check Project Overview affordance | No | No | Browser spot-check / next promotion gate |
| #44 Product breadcrumb navigation | Small UI polish included in 1P-R1/1P-R1A; 1P-R2 static/check review passed | UI polish | Browser spot-check Products, Projects and Events breadcrumbs | No | No | Browser spot-check / next promotion gate |
| #45 Sidebar icons repeated | Small UI polish included in 1P-R1/1P-R1A; 1P-R2 static/check review passed | UI polish | Browser spot-check FUND navigation icons | No | No | Browser spot-check / next promotion gate |
| #48 Events should link to one or more Product Catalogues | Open | Architecture planning | Plan Event/Catalogue/Product availability before implementation | Partially for C2 product/action surfaces | Yes | 1Q |
| #49 Product Workflow Class suitability | Open | Architecture planning | Plan workflow suitability/availability layer before Store, production or workflow expansion | Partially for C2 product/action surfaces | Yes | 1Q |

Planning rule:

```text
For every new FUND planning slice, read this status register first. Use the detailed triage documents only when the register points to an issue or decision needing background evidence.
```

### CR Handling Rule

Change requests are treated as development inputs, not direct implementation instructions.

Every CR must pass through triage before implementation. If accepted, it receives the same slice planning, implementation confirmation, review/test confirmation and roadmap update sequence as new feature work.

Current CR workflow:

```text
CR input
  -> triage decision
  -> slice planning
  -> implementation confirmation
  -> review/test confirmation
  -> roadmap/control update
```

For the current CR batch:

```text
01-cr-inputs/change-request-cmqt61xmf000612xt5ifl1mdn-2026-06-25.md
  -> 02-triage/2026-06-25-fund-c1-admin-remediation-and-architecture-triage.md
  -> 03-slice-planning/2026-06-25-fund-phase-1-slice-1p-r1-c1-admin-immediate-remediation.md
```

## 5. Current C2 Access-Model Planning Lane

Current C2 planning documents:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-24-fund-phase-1-slice-1p-c2-organiser-dashboard-proposal.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-24-fund-phase-1-slice-1p-a-c2-project-access-model-proposal.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-d0-c2-organisation-scope-clarification.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-f-c2-client-account-organisation-model-planning.md
```

Recommended model:

```text
IsoStack User for authentication
+ FundProjectParticipant for Project access
+ optional future FundOrganiserProfile for reusable organiser identity/contact history
```

Key decision:

```text
C2 Project access must not derive from organiserName/organiserEmail/organiserPhone snapshot fields.
```

Current C2 recommendation:

- Treat the implemented 1P-D read-only dashboard as a safe participant-scoped interim bridge.
- Treat 1P-D smoke testing as technical validation only, not decisive product validation.
- Decide the C2 organisation/account scope before adding C2 mutations, participant management UI, C2 client/account management UI, C1 Client view, invitations, Project Request/onboarding, sales/order/reporting views, Store or Commerce coupling.
- Do not assume direct `FundProjectParticipant` access is the final C2 operating model.
- Likely long-term direction to evaluate: C2 Client/account owns Projects, C2 users belong to that Client/account, and `FundProjectParticipant` remains for named contacts, overrides, exceptions and transition access.
- 1P-F is the active architecture planning slice for the C2 Client/account organisation model.

### C2 Organisation / Account Scope Clarification

Post-1P-D clarification:

```text
Current interim model:
User -> FundProjectParticipant -> FundProject

Wider likely model:
C1 Producer/Admin Tenant
-> C2 Client / Account / Fundraising Organisation / School / Club / PTA / Customer Account
-> C2 users
-> Projects
-> future Project sales/orders/reporting
```

Important correction:

```text
C2 is the Project management node.
C2 Clients/accounts own and manage Projects.
C2 users operate within the Client/account organisation.
FundProjectParticipant is not the strategic Project ownership model.
```

SeasonPro precedent:

```text
C1 League Tenant
-> C2 Club
-> Teams
-> Club users
```

Integrated SeasonPro + FUND may use the SeasonPro Club as the fundraising Project creator/account.

Terminology note:

```text
Client may be the user-facing/admin term for the C2 organisation/account.
In SeasonPro, Client is synonymous with Club.
In FUND, Client may be a school, club, PTA, charity branch, fundraising organisation or customer account.
```

C1 Client view note:

```text
C1 should eventually be able to enter a managed Client/account view for support, preview or administration.
This must be distinct from hat-swapping and must not rely on unsafe impersonation.
```

Open decision:

```text
Should FUND create a FUND-specific C2 organisation/account model, a reusable IsoStack C2 organisation/account model, or a hybrid that retains FundProjectParticipant for Project-level exceptions?
```

Control rule:

```text
Further C2 dashboard expansion must pause before write-capable or commercially meaningful surfaces until this is resolved.
```

### AMOW Founding-Tenant Priority

The immediate AMOW presentation priority is the C1 organisational dashboard, not expansion of the interim C2 read-only dashboard.

AMOW needs to be able to explain and demonstrate the operating model:

```text
AMOW manages Clients, Products, Events and Projects.
Clients are fundraising organisations such as schools, clubs or PTAs.
Projects belong to Clients.
Future Store, Orders, Sales, Communications and Reporting sit naturally under the Client and Project structure.
```

Current priority slice:

```text
1P-F-A - C1 Client Management Foundation
```

Control decision:

- 1P-D remains technically safe as a read-only participant-scoped interim dashboard.
- 1P-D is not the immediate AMOW product priority.
- Further C2 dashboard expansion remains paused.
- C2 mutations, invitations, Project Request/onboarding, Store, Orders, Commerce, Sales/Reporting and Communications remain deferred.
- C1 Client management is the next priority planning lane.

### Project Intake / Client Onboarding Clarification

Future FUND Project creation has two important paths:

```text
New Client / first Project:
external or unknown respondent -> C1 Project Intake form -> C1 moderation -> Client/account + C2 user/member + Project

Existing Client / additional Project:
existing C2 user or SeasonPro Club user -> Client dashboard or Club view -> Project request/create flow -> C1 moderation if policy requires
```

Project Intake / Project Request forms may later be:

- embedded on websites;
- linked from emails;
- linked from campaign pages;
- linked from SeasonPro Club views;
- linked from future Client dashboards.

Control rules:

- C1 users may create/manage Project Intake forms in a future slice.
- Form submissions must be moderated before operational records are created or linked.
- Approval may create/link Client/account, C2 user/member, Project and Event linkage.
- Projects may be linked to a C1 Event or may be standalone depending on campaign/form policy.
- Existing SeasonPro Clubs may later act as the FUND Client/account and Project creator.
- Notification/invitation sending is deferred and must follow a controlled SeasonPro-style communications pattern.
- 1P-F-E Client UI remains C1 admin only and does not implement Project Intake forms, Client users, invitations or automatic Project creation.

## 6. Architecture Planning Required Before Store / Commerce

The first remediation CR surfaced two architecture questions that should be resolved before Store, Order, Commerce or production workflow work.

### Event / Catalogue / Product Availability

Source issue:

```text
Issue #48 - Events should link to one or more Product Catalogues
```

Design question:

```text
How should Event-linked Projects and standalone Projects determine eligible Products?
```

Planning needed:

- Event-to-Catalogue links.
- Standalone Project Catalogues.
- Catalogue type/scope.
- Whether Events can use multiple Catalogues.
- Whether Catalogues can serve multiple Events.
- Project Product picker eligibility.
- Future Store generation eligibility.

### Product Workflow Suitability

Source issue:

```text
Issue #49 - Product Workflow Class suitability
```

Design question:

```text
Is a Product's workflow class a default, a suitability set, or a Project-specific operational choice?
```

Current stabilising interpretation:

- `FundProduct.workflowClassId` is the Product default/initial classification.
- `FundProjectProduct.workflowClassId` is the operational Project Product workflow snapshot.
- A future suitability/availability layer may allow one Product to support multiple workflow classes.

Planning needed before Store/Commerce/production:

- Whether suitability belongs on Product.
- Whether suitability belongs on Catalogue membership.
- Whether Event constraints limit permitted workflow classes.
- Whether Project Product chooses final workflow.
- How suitability affects production export and lifecycle.

## 7. Commerce Core As Separate Future IsoStack Lane

Commerce Core should be treated as a reusable IsoStack platform lane, not a FUND-only implementation detail.

Future Commerce Core lane should cover:

- provider-neutral Products/Prices/Orders/Payments/Subscriptions where appropriate;
- payment providers such as Stripe and GoCardless;
- VAT/tax model;
- checkout/session lifecycle;
- payment status and webhooks;
- subscription and usage billing options;
- audit and tenant safety.

FUND Store planning should depend on, or at least align with, this future platform lane.

## 8. SeasonPro Remediation As Separate Branch / Lane

SeasonPro/LMSPro fixes should use:

```text
feature/seasonpro-remediation
```

Purpose:

- keep SeasonPro remediation testable and promotable without unfinished FUND C2 work;
- cherry-pick specific fixes into FUND branches only when needed;
- avoid using FUND feature branches as a holding area for unrelated SeasonPro fixes.

Recent example:

- `fix(lmspro): support team data export` was first isolated as a SeasonPro-only hotfix, then absorbed into FUND before release.

Recommended rule:

```text
SeasonPro fixes start in the SeasonPro remediation lane unless the fix is genuinely FUND-dependent.
```

## 9. Deferred Items

Deferred until explicitly planned:

- C2 organiser dashboard mutations or expansion beyond the implemented read-only interim participant-scoped view.
- C2 organisation/account model implementation beyond controlled Client-management planning.
- C2 organiser invitations.
- Project Intake / Project Request / onboarding forms.
- Organiser account provisioning.
- FundOrganiserProfile.
- Store schema.
- Order schema.
- Commerce Core implementation.
- Payments.
- Subscriptions.
- Commissions.
- Production batching.
- Fulfilment/distribution workflows.
- Artwork/data/template submission workflows.
- Media/asset library.
- Marketplace / AMOW product sharing.
- SeasonPro integration/distribution channel.
- AI workflows.
- Lifecycle transition engine.
- Lifecycle tables/templates.

## 10. Current Do Not Build Yet List

Until remediation and architecture planning are complete, do not build:

- Event-Catalogue linking schema.
- Product workflow suitability schema.
- Store generation.
- Order management.
- Commerce checkout.
- Payment webhooks.
- Production export/batching.
- C2 dashboard implementation.
- C2 dashboard mutation/management expansion.
- C2 organisation/account schema before the Client/account schema-options slice is accepted.
- C2 invitation/onboarding flow.
- Project Intake / Project Request public flow.
- Organiser dashboard actions.
- Product marketplace/sharing.
- Any schema migration for the above without a planning slice first.

## 11. Recommended Next 3-5 Slices

### Next 1 - C1 Admin Immediate Remediation

Suggested slice:

```text
Slice 1P-R1 - C1 Admin Immediate Remediation
Slice 1P-R1A - C1 Admin UI Consistency Remediation
```

Status:

```text
Implemented and check-passed.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-r1-c1-admin-immediate-remediation.md
```

Scope:

- Issue #46 Project/Event date constraint fix.
- Issue #50 Issue Manager module filtering/server render fix.
- Issue #47 Project Product activation gate visibility.
- Issue #44 breadcrumbs.
- Issue #45 sidebar icon specificity.
- Dashboard card interaction/colour consistency.
- Column-header sort alignment.
- Issue Manager module field consolidation.

Branch:

```text
feature/fund-phase-1-c2-project-access
```

### Next 2 - C2 Read-Only Organiser Dashboard UI

Suggested slice:

```text
Slice 1P-D - C2 Read-Only Organiser Dashboard UI
```

Status:

```text
1P-A planning complete.
1P-B participant schema implemented and aligned to dev/staging.
1P-C read-only organiser Project API/services implemented, reviewed and aligned to dev/staging.
1P-D implemented on feature/fund-phase-1-c2-project-access.
1P-D-R1 review complete with caveats.
```

Scope:

- implement C2 read-only organiser landing page;
- implement C2 read-only assigned Project detail page;
- consume only `fund.organiser.projects.list/get`;
- include C1/C2 context navigation for dual-role users;
- no C2 mutations, invitations, participant management, Store, Orders or Commerce.

Pre-implementation note:

```text
Confirm staging has applied 20260625143000_add_fund_project_participants before authenticated staging testing.
```

### Next 3 - C1 Client Management Foundation For AMOW

Suggested slice:

```text
Slice 1P-F-A - C1 Client Management Foundation
```

Scope:

- plan the AMOW-facing C1 Client management foundation;
- decide how `Client` should be presented as the C2 organisation/account concept;
- define the minimal Client record needed for AMOW explanation and near-term implementation;
- define Client to Project relationship expectations;
- document how future Orders, Sales, Reporting, Communications and key-date automation sit under Client and Project;
- defer schema implementation until schema-options planning is accepted.

Status:

```text
Active priority planning.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-f-a-c1-client-management-foundation-planning.md
```

### Next 4 - C1 Client / Account Schema Options

Suggested slice:

```text
Slice 1P-F-B - C1 Client Management Schema Options
```

Scope:

- decide whether Client/account should be FUND-specific, reusable IsoStack core, or hybrid;
- define tenant scoping and same-tenant Project linkage;
- decide Project `clientId` / `clientAccountId` direction;
- define migration/backfill approach for existing Projects;
- define SeasonPro Club mapping guardrails;
- define C1 Client list/detail UI implications.

Status:

```text
Planning document created.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-f-b-c1-client-management-schema-options.md
```

Recommended next implementation slice:

```text
Slice 1P-F-C - C1 Client Management Schema
```

Status:

```text
Implemented locally as schema-only work.
```

Confirmation document:

```text
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-f-c-c1-client-management-schema-confirmation.md
```

### Next 5 - C1 Client Management API/Services

Suggested slice:

```text
Slice 1P-F-D - C1 Client Management API/Services
```

Scope:

- plan C1 tenant-scoped Client list/get/create/update/archive/restore services;
- plan Client search/filter/sort behaviour;
- plan Client detail payload with linked Project summaries;
- plan same-tenant enforcement and archived Client behaviour;
- plan audit events and error handling;
- keep UI, Project Client selector, Client users, invitations, Store, Orders, Commerce, Sales/Reporting, Communications and SeasonPro mapping out of scope.

Status:

```text
Implemented locally as API-services only.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-f-d-c1-client-management-api-services-planning.md
```

Confirmation document:

```text
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-f-d-c1-client-management-api-services-confirmation.md
```

### Next 6 - C1 Client Management UI

Suggested slice:

```text
Slice 1P-F-E - C1 Client Management UI
```

Scope:

- build C1 Client list;
- build C1 Client detail;
- consume `fund.clients.*` only;
- show linked Project summaries;
- support create/update/archive/restore;
- keep Client users, invitations, Project Request/onboarding, Store, Orders, Commerce, Sales/Reporting, Communications and SeasonPro mapping out of scope.

Status:

```text
Planning document created.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-f-e-c1-client-management-ui-planning.md
```

Recommended next implementation slice:

```text
Slice 1P-F-E - C1 Client Management UI
```

### Next 7 - Event / Catalogue / Product Availability Planning

Suggested slice:

```text
Slice 1Q - Event/Catalogue/Product Availability And Workflow Suitability Planning
```

Scope:

- resolve Issues #48 and #49 together;
- produce schema/API plan;
- explicitly record Store/Commerce impacts.

### Next 8 - Project Intake / Client Onboarding Planning

Suggested slice:

```text
Slice 1P-G - Project Intake, Client Onboarding And Moderation Planning
```

Scope:

- plan C1-created Project Intake forms;
- plan embedded public forms and email/campaign links;
- plan SeasonPro Club-view Project creation entry points;
- plan future Client-dashboard additional Project initiation;
- plan unknown respondent and existing C2 user flows;
- plan C1 moderation before creating/linking operational records;
- plan approval creating/linking Client/account, C2 user/member, Project and Event linkage;
- define notification/invitation boundary;
- defer Store, Orders, Commerce, Sales/Reporting and Communications implementation.

Status:

```text
Future planning lane documented. Do not implement yet.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-g-project-intake-client-onboarding-and-moderation-planning.md
```

### Next 9 - C2 Dashboard Foundation Expansion

Suggested slice:

```text
Slice 1R - C2 Dashboard Foundation Expansion
```

Only start after:

- C1 immediate remediation is complete;
- 1P-D read-only dashboard review is complete;
- C2 organisation/account scope is accepted;
- C1 Client/account schema direction is accepted;
- C2 read-only visibility rules are clear.

## 12. Prompt To Use In A Fresh Chat

```text
We are working on IsoStack FUND.

Current app branch:
feature/fund-phase-1-c2-project-access

Current released baseline:
62b727e chore(release): promote FUND C1 admin foundation

Read first:
- isodocs/docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md
- isodocs/docs/modules/fund/02-triage/2026-06-25-fund-c1-admin-remediation-and-architecture-triage.md
- isodocs/docs/modules/fund/01-cr-inputs/change-request-cmqt61xmf000612xt5ifl1mdn-2026-06-25.md
- isodocs/docs/modules/fund/05-fund-open-questions.md
- current app implementation on feature/fund-phase-1-c2-project-access

Context:
- FUND C1 admin foundation has been released and aligned to main/dev/staging.
- Active FUND branch is for C2 access planning and C1 remediation.
- SeasonPro remediation has its own branch: feature/seasonpro-remediation.
- Do not mix unrelated SeasonPro fixes into FUND unless explicitly requested.

Immediate recommended work:
Proceed with C1 Client Management UI planning/implementation:
1. Treat 1P-F-C as the schema-only Client foundation.
2. Treat 1P-F-D as the C1 Client API/services foundation.
3. Build only C1 admin Client list/detail UI using `fund.clients.*`.
4. Keep Client primary contact fields as snapshots only.
5. Keep Project Client selector/linkage, Client users, invitations, Store, Orders, Commerce, Sales/Reporting and Communications out of scope unless separately planned.

Do not start:
- C2 dashboard expansion;
- C2 mutations;
- C2 invitations;
- Project Request/onboarding;
- Commerce Core;
- Store;
- Order;
- Sales/Reporting implementation;
- Communications implementation;
- payments;
- commissions;
- production batching;
- Event-Catalogue/Product availability schema;
- Product workflow suitability schema;
until their planning slices are accepted.
```
