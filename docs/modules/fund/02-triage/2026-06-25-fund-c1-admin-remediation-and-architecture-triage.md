# FUND C1 Admin Remediation And Architecture Triage

Date: 2026-06-25

Status: Planning only

Source issue export:

```text
isodocs/docs/modules/fund/01-cr-inputs/change-request-cmqt61xmf000612xt5ifl1mdn-2026-06-25.md
```

Target app branch:

```text
feature/fund-phase-1-c2-project-access
```

## 1. Purpose

Triage the first staging feedback batch after the FUND C1 admin foundation was accepted as a release baseline.

This document separates:

- issues that should be fixed immediately before dependent FUND work continues;
- near-term C1 admin UI/UX refinements;
- architecture questions that should be planned before Store, Commerce, workflow or production development;
- items that can be deferred without blocking the next planning steps.

This is planning only. It does not edit application code, Prisma schema, migrations, routers, services, UI, seed data or deployment scripts.

## 2. Triage Summary

| Issue | Title | Triage | Severity | Blocks C2 Dashboard Planning | Blocks Commerce/Store Planning |
| --- | --- | --- | --- | --- | --- |
| #46 | Close date for Project overrides Event close date | Immediate remediation | High | Partially | No |
| #50 | Issue manager module filtering/server render error | Immediate remediation | High | No | No |
| #47 | Adding Product is a gate but not intuitive | UI/UX polish / near-term remediation | Medium | No | No |
| #44 | Product breadcrumb navigation | UI/UX polish | Low | No | No |
| #45 | Sidebar icons repeated | UI/UX polish and UI guidance update | Low | No | No |
| #48 | Events should link to one or more Product Catalogues | Architecture planning | High | Partially | Yes |
| #49 | Product Workflow Class suitability | Architecture planning | High | Partially | Yes |

## 3. Issue Triage

### Issue #46 - Close Date For Project Overrides Event Close Date

Issue id:

```text
cmqt4iked0005zd0f9g047nlm
```

Triage:

```text
Immediate remediation
```

Observed problem:

- A Project linked to an Event can currently accept a Project close date later than the Event close date.
- Advisory text can update incorrectly after that invalid date is accepted.
- This contradicts the agreed Phase 1 Event-linked Project rule.

Affected area:

- Project create modal.
- Project detail/edit date handling.
- Project/Event linkage helper text.
- Project service date validation if the server currently allows the invalid state.

Likely cause or design question:

- The UI may be validating Project dates before selected Event context is fully available.
- The server-side Project create/update validation may not be consistently enforcing Event date constraints in all paths.
- The advisory/effective-date display may trust local form state without recalculating against the linked Event.

Severity:

```text
High
```

Recommended action:

Fix before continuing dependent Project/Event work.

Required behaviour:

- Standalone Projects may set any valid `closesAt` after `opensAt`.
- Event-linked Projects may set `closesAt` earlier than or equal to `FundEvent.closesAt`.
- Event-linked Projects must never set `closesAt` later than `FundEvent.closesAt`.
- If linked Project `closesAt` is blank, Event `closesAt` may be treated as inherited/effective for readiness/display.
- Event `closesAt` is the latest permissible effective close date, not a forced copied Project close date.

Implementation should check both:

- client-side form validation and helper text;
- server-side `fund.projects.create` and `fund.projects.update` enforcement.

Clarification needed before implementation:

No. The agreed rule is already clear.

Suggested slice/branch:

```text
Slice 1P-Remediation-A - Project/Event Date Constraint Fix
feature/fund-phase-1-c2-project-access
```

Blocks C2 dashboard planning:

Partially. C2 planning can continue, but C2 implementation should not rely on Project/Event date readiness until this is fixed.

Blocks Commerce/Store planning:

No, but it must be fixed before Store generation uses effective close dates.

### Issue #50 - Issue Manager Module Filtering / Server Render Error

Issue id:

```text
cmqt5tc0l000112xteuoaqndw
```

Triage:

```text
Immediate remediation
```

Observed problem:

- P1 can create issues and add Module metadata.
- The Issue Manager module filter does not reliably show/filter FUND issues.
- There appear to be two module inputs with different module option sets.
- One filter includes only Bedrock and LMSPro.
- Filtering to FUND can return an empty list.
- A production Server Components render error can occur.

Affected area:

- Issue Manager list/filter UI.
- Issue create/edit form module field(s).
- Module catalogue or module option source used by Issue Manager.
- Server-rendered issue manager route.

Likely cause or design question:

- The Issue Manager may be using inconsistent sources for module options:
  - module catalogue defaults;
  - user-scoped modules;
  - hard-coded/static module list;
  - product/module allocation visibility.
- The create form and filter dropdown may be using different fields or different module identifiers.
- Server component rendering may fail when module metadata is missing or unexpected.

Severity:

```text
High
```

Recommended action:

Fix before more staged testing because Issue Manager is the tester feedback/control surface.

Expected behaviour:

- FUND issues created during testing must be findable by module filter.
- The create/edit module field and list filter must use one canonical module id/source.
- Module id should be `fund`.
- P1/platform owner should be able to filter across modules needed for testing.
- Server render errors must be replaced by stable empty/error states.

Clarification needed before implementation:

Yes, small clarification may be needed on whether the issue list filter should show:

- all platform modules to P1;
- modules assigned to the current product/tenant;
- modules represented by existing issues;
- a hybrid of the above.

For immediate remediation, prefer a safe P1 behaviour:

```text
P1/platform owner can filter by all registered modules, including fund.
```

Suggested slice/branch:

```text
Platform Remediation - Issue Manager Module Filter
feature/fund-phase-1-c2-project-access
```

If the issue manager is shared platform functionality, consider a separate short-lived platform remediation branch if it must be promoted independently of FUND.

Blocks C2 dashboard planning:

No.

Blocks Commerce/Store planning:

No.

### Issue #47 - Adding Product Is A Gate But Not Intuitive

Issue id:

```text
cmqt4m3rp0007zd0fat6wox41
```

Triage:

```text
UI/UX polish / near-term remediation
```

Observed problem:

- A Project must have at least one active Project Product before activation.
- Product membership lives on a separate Products tab.
- The activation gate is not visible or intuitive enough from the Project overview/readiness area.

Affected area:

- Project Overview readiness panel.
- Project detail tab layout.
- Project Products tab affordance.
- Activation error messaging.

Likely cause or design question:

- The requirement is server-enforced, but the UI does not guide users clearly enough toward the Products tab.
- The readiness panel likely reports the blocker but does not provide enough visual prominence or navigation affordance.

Severity:

```text
Medium
```

Recommended action:

Near-term UX remediation.

Potential fixes:

- Make the missing Product gate prominent in the Overview readiness panel.
- Add a clear "Add Project Product" or "Go to Products tab" action when no active Project Products exist.
- Show active Project Product count in the Overview.
- Keep mutation controls on the Products tab; avoid duplicating the membership manager on Overview.

Clarification needed before implementation:

No. This is a usability improvement around an existing rule.

Suggested slice/branch:

```text
Slice 1P-Remediation-B - Project Readiness UX Improvements
feature/fund-phase-1-c2-project-access
```

Blocks C2 dashboard planning:

No, but C2 organiser-facing readiness should learn from this.

Blocks Commerce/Store planning:

No.

### Issue #44 - Product Breadcrumb Navigation

Issue id:

```text
cmqt46cz40001zd0fmiix8x67
```

Triage:

```text
UI/UX polish
```

Observed problem:

- `/app/fund/products` needs breadcrumb navigation so users can navigate back/up cleanly.

Affected area:

- Products/Catalogues admin page.
- FUND C1 admin navigation consistency.

Likely cause or design question:

- The Products/Catalogues page was built as an admin management surface but does not yet include the same breadcrumb pattern expected elsewhere.

Severity:

```text
Low
```

Recommended action:

Add breadcrumb navigation consistent with other app pages.

Clarification needed before implementation:

No.

Suggested slice/branch:

```text
Slice 1P-Remediation-C - FUND Admin Navigation Polish
feature/fund-phase-1-c2-project-access
```

Blocks C2 dashboard planning:

No.

Blocks Commerce/Store planning:

No.

### Issue #45 - Make Sidebar Icons Appropriate

Issue id:

```text
cmqt48j300003zd0fg6h56mxw
```

Triage:

```text
UI/UX polish and module UI guidance update
```

Observed problem:

- The sidebar uses the Home icon repeatedly.
- Icons should better match page content.
- The module UI instructions should explicitly warn against repeated generic icons.

Affected area:

- FUND module navigation.
- Possibly shared module navigation guidance.
- IsoStack UI/UX standards documentation.

Likely cause or design question:

- FUND routes may have been added with generic fallback icons.
- Existing guidance may not be explicit enough that repeated generic icons reduce scanability.

Severity:

```text
Low
```

Recommended action:

Update navigation icons and add a short UI standard note.

Potential icon direction:

- FUND overview: dashboard/layout icon.
- Products/Catalogues: package/tags/list icon.
- Projects: clipboard/list/checklist icon.
- Events: calendar icon.

Clarification needed before implementation:

No, unless there is a preferred icon library mapping.

Suggested slice/branch:

```text
Slice 1P-Remediation-C - FUND Admin Navigation Polish
feature/fund-phase-1-c2-project-access
```

Blocks C2 dashboard planning:

No.

Blocks Commerce/Store planning:

No.

### Issue #48 - Events Should Link To One Or More Product Catalogues

Issue id:

```text
cmqt4sj670009zd0frbt4d830
```

Triage:

```text
Architecture planning
```

Observed problem:

- Events should define or constrain the Product offer for Projects linked to that Event.
- Standalone Projects should receive Products from Catalogues intended for non-Event Projects.
- The issue suggests a Catalogue Type concept, such as Event Catalogue versus Independent Project Catalogue.

Affected area:

- Event model.
- Catalogue model.
- Project Product selection.
- Future Store generation.
- Product availability rules.

Likely cause or design question:

Current Phase 1 implemented:

- tenant-owned Products;
- tenant-owned Catalogues;
- optional Events;
- Projects and Project Products.

It did not yet implement an availability layer connecting Events to Catalogues or controlling which Products can be selected for a Project based on Event/standalone context.

Architecture questions:

- Should Events link directly to Catalogues?
- Should Catalogues have type/scope fields?
- Should availability be modelled as Event-Catalogue membership, Catalogue scope, Product availability rules, or Project selection validation?
- Can one Event use multiple Catalogues?
- Can a Catalogue be available for multiple Events?
- How are standalone Project Catalogues selected?
- Should Event-linked Projects be restricted to Event-linked Catalogues only?
- How does this interact with future Store generation?

Severity:

```text
High
```

Recommended action:

Plan before implementation. Do not add Event-Catalogue links ad hoc.

Recommended next architecture slice:

```text
Slice 1Q - Event/Catalogue/Product Availability Model Planning
```

Clarification needed before implementation:

Yes.

Suggested slice/branch:

```text
feature/fund-phase-1-c2-project-access
```

or a later branch if the immediate remediation fixes are split first.

Blocks C2 dashboard planning:

Partially. C2 dashboard access planning can continue, but C2 Product/action surfaces should stay read-only until Product availability is designed.

Blocks Commerce/Store planning:

Yes. Store generation needs a clear Product/Catalogue availability model.

### Issue #49 - Product Workflow Class Suitability

Issue id:

```text
cmqt5095w000bzd0f14y9svpi
```

Triage:

```text
Architecture planning
```

Observed problem:

- A Product may be suitable for many workflows.
- Example: a water bottle could be:
  - individual artwork;
  - group artwork;
  - logo;
  - logo and name;
  - standard product.
- Workflow suitability is relevant, but not deterministic at Product level.
- Project context determines the workflow branch.
- Events may constrain Projects to certain workflows.
- Different workflows may belong in separate Projects created by the same C2 organiser.

Affected area:

- Product Workflow Class model.
- Product model.
- Project Product membership.
- Catalogue membership.
- Event constraints.
- Future Store, production and workflow/lifecycle engines.

Likely cause or design question:

The first C1 foundation made `FundProduct.workflowClassId` required, which treats a Product as having one primary workflow class. Staging feedback suggests this may be too deterministic for real catalogue/Product usage.

Architecture questions:

- Is a Product assigned one default workflow class plus future suitability metadata?
- Can a Product be suitable for multiple workflow classes?
- Does workflow selection belong on:
  - Product;
  - Catalogue Product membership;
  - Event-Catalogue availability;
  - Project Product;
  - Project itself;
  - future Store Product configuration?
- Should Project Product snapshot record the actual workflow chosen for that Project?
- Should Event constraints limit permitted workflow classes?
- Should Product Workflow Class remain a required default field while multi-suitability is layered later?

Severity:

```text
High
```

Recommended action:

Plan before workflow/store/production development. Avoid changing the schema immediately unless the availability/workflow model is reviewed together with Issue #48.

Recommended architecture stance for now:

- Treat current `FundProduct.workflowClassId` as the Product's default or initial classification.
- Treat `FundProjectProduct.workflowClassId` as the operational workflow snapshot for that Project.
- Plan a suitability/availability layer before Store and production work.
- Do not assume Product default workflow class is the only workflow it can ever support.

Clarification needed before implementation:

Yes.

Suggested slice/branch:

```text
Slice 1Q - Event/Catalogue/Product Availability And Workflow Suitability Planning
feature/fund-phase-1-c2-project-access
```

Blocks C2 dashboard planning:

Partially. C2 access/read-only dashboard planning can continue, but C2 workflow actions should be deferred until suitability is designed.

Blocks Commerce/Store planning:

Yes. Store/Product configuration and production exports need the workflow suitability model.

## 4. Recommended Immediate Remediation Order

Recommended order:

1. Fix Issue #46 Project/Event date constraint enforcement.
2. Fix Issue #50 Issue Manager module filtering/server render error.
3. Improve Issue #47 Project Product activation gate visibility.
4. Polish Issue #44 breadcrumbs and Issue #45 sidebar icons/guidance.
5. Run a short remediation review pass.
6. Continue C2 access planning and architecture planning in parallel, but do not implement C2 dashboard surfaces until date and issue-management blockers are clear.

## 5. Recommended Immediate Remediation Prompt

```text
Proceed with FUND C1 admin immediate remediation implementation.

Work on:
feature/fund-phase-1-c2-project-access

Use:
- isodocs/docs/modules/fund/02-triage/2026-06-25-fund-c1-admin-remediation-and-architecture-triage.md
- issue export change-request-cmqt61xmf000612xt5ifl1mdn-2026-06-25.md
- active FUND docs and current Project/Event implementation

Implement only immediate C1 admin/platform remediation:

1. Fix Project/Event close-date constraint handling:
   - Event-linked Project closesAt must not be later than Event closesAt.
   - Standalone Projects remain free to use any valid closesAt after opensAt.
   - Keep Event close date as inherited/effective when Project closesAt is blank.
   - Check both Project create and update paths.
   - Ensure helper/advisory text updates correctly.

2. Fix Issue Manager module filtering/server render error:
   - FUND issues must be discoverable by module filter.
   - Use a consistent module id/source for create/edit and list filtering.
   - Ensure P1/platform owner can filter by fund.
   - Replace server render failure with stable behaviour.

3. Improve Project activation Product gate visibility:
   - Make missing active Project Product prominent on Project Overview/readiness.
   - Provide a clear path to the Products tab.
   - Do not duplicate the full Project Product manager outside the Products tab.

4. Add Products breadcrumb navigation and replace repeated generic sidebar Home icons with content-appropriate icons.
   - Update module UI guidance to avoid repeated generic sidebar icons.

Do not edit Prisma schema unless a genuine bug requires it and is explained first.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.
Do not start C2 dashboard, Commerce Core, Store, Order, payment, commission, production batching or organiser onboarding work.

Run:
- npm run type-check
- npm run verify

Report files changed, fixes made, checks run, and any remaining risks.
```

## 6. Recommended Architecture Planning Prompt

```text
Proceed with FUND architecture planning only: Event/Catalogue/Product availability and workflow suitability.

Work on:
feature/fund-phase-1-c2-project-access

Use:
- isodocs/docs/modules/fund/02-triage/2026-06-25-fund-c1-admin-remediation-and-architecture-triage.md
- Issue #48 Events should link to one or more Product Catalogues
- Issue #49 Product Workflow Class suitability
- active FUND docs and current C1 admin implementation

Planning only.

Do not edit application code.
Do not edit Prisma schema.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.
Do not implement Event-Catalogue links, Product suitability, Store, Order, Commerce Core, production batching or C2 dashboard work yet.

Produce a planning document covering:

1. Event-to-Catalogue availability model options.
2. Standalone Project catalogue availability model.
3. Whether Catalogues need type/scope/status metadata.
4. Whether Events can link to multiple Catalogues.
5. Whether Catalogues can link to multiple Events.
6. How Project Product picker eligibility should work for Event-linked Projects.
7. How Project Product picker eligibility should work for standalone Projects.
8. Product Workflow Class default versus suitability.
9. Whether Product suitability belongs on Product, Catalogue membership, Event constraints, Project Product or another availability layer.
10. Migration risks.
11. Impact on C2 dashboard.
12. Impact on Store/Commerce planning.
13. Recommended schema slice, if any.

Planning only.
```

## 7. Recommendation On C2 Dashboard Planning

Recommendation:

```text
Pause C2 dashboard implementation, but continue C2 access-model planning.
```

Reason:

- Issue #46 should be fixed before any Project/Event state is exposed to C2 organisers.
- Issue #50 should be fixed so testing and issue management remain reliable.
- Issue #48 and #49 affect future C2 Product/workflow actions, but they do not block planning the access model itself.

Safe next steps:

- Continue or refine Slice 1P-A C2 Project Access Model planning.
- Do not implement the C2 dashboard UI yet.
- Complete immediate remediation first.
- Plan Event/Catalogue/Product availability and workflow suitability before Store/Commerce or C2 workflow actions.

