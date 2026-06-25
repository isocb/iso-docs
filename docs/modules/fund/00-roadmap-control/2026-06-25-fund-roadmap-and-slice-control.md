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

Branch alignment after release:

```text
main    = 62b727e
dev     = 62b727e
staging = 90325c1 after 1P-R1/1P-R1A remediation push
```

Release result:

- FUND C1 admin foundation is released/aligned.
- SeasonPro/LMSPro export hotfix is included.
- Staging browser testing found no blocking C1 admin foundation issues before release alignment.
- FUND remains expected to need refinement; the baseline is accepted as the foundation, not as final product polish.
- 1P-R1/1P-R1A remediation has now been pushed to staging at `90325c1`.
- Main/dev remain at the released baseline `62b727e` until the remediation browser spot-check is accepted.

## 2. Current Branch Landscape

### Release Branches

```text
main
dev
staging
```

Current state:

```text
main/dev aligned at 62b727e
staging aligned to 90325c1 for C1 remediation validation
```

Use:

- `main` is the live/release baseline.
- `dev` is the integration baseline.
- `staging` currently carries the 1P-R1/1P-R1A C1 remediation batch for validation.

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

### Live Issue Status Register

This table is the current compact issue-status view for planning. It should be updated after remediation, review or architecture-planning slices so future planning does not require rereading every triage note.

| Issue | Current Status | Category | Next Action | Blocks C2? | Blocks Store/Commerce? | Current / Suggested Slice |
| --- | --- | --- | --- | --- | --- | --- |
| #46 Project/Event close-date constraint | Remediated in 1P-R1; 1P-R2 static/check review passed | Immediate remediation | Authenticated browser spot-check before staging promotion | No for planning; spot-check before promotion | No, but must remain clean before Store date generation | Browser spot-check / next promotion gate |
| #50 Issue Manager module filtering/server render error | Remediated in 1P-R1; 1P-R2 static/check review passed | Immediate platform remediation | Authenticated Issue Manager spot-check before staging promotion | No | No | Browser spot-check / next promotion gate |
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

- Continue planning the access model.
- Do not implement the C2 dashboard UI until immediate C1 remediation has had its authenticated browser spot-check or is accepted as low-risk enough to continue planning in parallel.
- C2 access-model planning may proceed now because it does not change runtime behaviour.
- C2 participant schema/API/UI implementation should wait for the remediation browser spot-check or explicitly record the risk if proceeding in parallel.
- First C2 dashboard should likely be narrow/read-only.
- C2 users should see only Projects explicitly assigned through a participant/access record.

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

- C2 organiser dashboard implementation.
- C2 organiser invitations.
- Project Request/onboarding.
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
- C2 invitation/onboarding flow.
- Project Request public flow.
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

### Next 2 - C1 Admin Remediation Review

Suggested slice:

```text
Slice 1P-R2 - C1 Admin Remediation Review And Staging Readiness
```

Status:

```text
Static/code review and automated checks complete.
Authenticated browser spot-check remains recommended before staging promotion.
```

Scope:

- verify Issue #46 and #50 fixes;
- ensure no regression to Products, Catalogues, Projects or Events;
- decide whether to promote remediation before continuing C2 implementation.

### Next 3 - C2 Project Participant Schema Planning / Implementation

Suggested slice:

```text
Slice 1P-A - C2 Project Access Model Planning
Slice 1P-B - C2 Project Participant Schema
```

Scope:

- finish/accept the access-model planning decision;
- schema-only implementation of `FundProjectParticipant` or equivalent, if planning is accepted;
- no dashboard UI yet.

Status:

```text
1P-A planning document updated 2026-06-25 with current staging/remediation status.
1P-B should not be promoted beyond local/dev review until 1P-R1/1P-R1A staging spot-check is accepted.
```

### Next 4 - Event / Catalogue / Product Availability Planning

Suggested slice:

```text
Slice 1Q - Event/Catalogue/Product Availability And Workflow Suitability Planning
```

Scope:

- resolve Issues #48 and #49 together;
- produce schema/API plan;
- explicitly record Store/Commerce impacts.

### Next 5 - C2 Dashboard Foundation Planning / Read-Only Implementation

Suggested slice:

```text
Slice 1R - C2 Dashboard Foundation
```

Only start after:

- C1 immediate remediation is complete;
- C2 participant/access model is accepted;
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
Proceed with C1 admin immediate remediation for:
1. Issue #46 - Event-linked Project close date must not be later than Event closesAt.
2. Issue #50 - Issue Manager module filtering/server render error.
Optionally include small UI polish for Issues #47, #44 and #45 if scope stays contained.

Do not start:
- C2 dashboard implementation;
- Commerce Core;
- Store;
- Order;
- payments;
- commissions;
- production batching;
- organiser onboarding;
- Event-Catalogue/Product availability schema;
- Product workflow suitability schema;
until their planning slices are accepted.
```
