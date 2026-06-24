# FUND Phase 1 Slice 1J - Project Admin UI Proposal

Date: 2026-06-24

Status: Planning only

Target branch:

```text
feature/fund-phase-1-products-catalogues
```

Filename note: this document remains in the 2026-06-23 FUND planning sequence because it follows directly from the Slice 1H and 1I work completed in that sequence.

## Source Context

This proposal uses:

- `isodocs/docs/modules/fund/implementation/2026-06-23-phase-1-slice-1h-project-schema-confirmation.md`
- `isodocs/docs/modules/fund/implementation/2026-06-23-phase-1-slice-1i-project-api-services-confirmation.md`
- active FUND docs in `isodocs/docs/modules/fund/`
- Slice 1C, 1D, 1E, 1F-A and 1F-B confirmation documents
- `docs/2026-IsoStack-Docs/Standards/ui-ux/isostack-ux-ui-standard.md`
- `docs/2026-IsoStack-Docs/Standards/ui-ux/table-crud-pattern.md`

## 1. Slice Goal

Slice 1J should plan the Project admin UI for FUND.

The goal is to make Projects visible and manageable as the mandatory operational FUND entity, while preserving the architecture:

```text
Project is the centre.
Products and Catalogues support Projects.
Stores, Orders, commerce, production batching, commissions, Events and dashboards remain later layers.
```

The UI should expose Projects without turning the module into a store-first, order-first or commerce-first surface.

## 2. Implementation Boundary

Allowed in later Slice 1J implementation:

- Project list route.
- Project child/detail route.
- Project create flow.
- Project overview/edit surface.
- Project status transition controls.
- Activation readiness panel.
- Date and organiser fields.
- Planning only for Project Product membership management.

Project Product membership management must not be implemented in 1J-A. It is documented in this Slice 1J proposal only to define the 1J-B boundary.

Not allowed in Slice 1J:

- Prisma schema edits.
- migrations.
- `db:push`.
- seed/reset commands.
- Events.
- Stores.
- Orders.
- commerce.
- payments.
- commissions.
- dashboards.
- production batching.
- SeasonPro integration.
- marketplace exposure.
- media/asset workflows.
- lifecycle tables.
- lifecycle transition engine.
- organiser identity/account linking.
- AI workflows.

## 2A. Future Planning Note - Events, Requests And Organiser Onboarding

Slice 1J-A is authenticated tenant-side Project administration only. It assumes a C1 tenant user is managing Projects inside the FUND admin surface.

Future FUND slices may introduce richer Project initiation paths, but they must not be implemented in 1J-A:

- Event-linked Projects, where an optional tenant-owned Event constrains or guides Project open dates, close dates, production deadlines, communications and campaign rules.
- Standalone Projects, where no Event exists and Project dates remain free within normal validation rules.
- Project Initiation / Project Request flows, where a Project may be started by an existing C2 organiser or by an unknown customer through a multi-stage onboarding flow similar to SeasonPro new club onboarding.
- Future onboarding flows that may create or invite a C2 user, associate that user with the C1 tenant and grant access to an organiser dashboard.

For Slice 1J-A, organiser fields remain optional snapshot/contact fields only. They must not imply organiser identity, portal access, onboarding state, invitations or dashboard access.

## 3. Route Recommendation

Recommended routes:

```text
/app/fund/projects
/app/fund/projects/[id]
```

`/app/fund/projects` should be the Project list and create entry point.

`/app/fund/projects/[id]` should be the Project child management page for overview, edit, status transitions, activation readiness and later Product membership management.

## 4. Why Projects Use A Child Page Rather Than A Modal

Recommendation: use a child page, not a CRUD modal, for Project editing/detail.

Reason:

- Project is an operational parent entity, not a simple CRUD item.
- Project has child data: selected Products now, and future lifecycle, Stores, Orders, production and communications later.
- Project editing spans more than a small form: details, organiser contact, dates, status transitions, readiness checks and Product membership.
- The user needs deep linking, browser back/forward navigation and a bookmarkable Project workspace.
- IsoStack UX standard Section 7.2 says complex entities with children and multiple sections should use child pages.
- IsoStack UX standard Section 16 says management containers should open management pages rather than modals.

The Project list should therefore use:

```text
Row click -> /app/fund/projects/[id]
```

It should not open an edit modal from the Project row.

Create Project may use a compact modal or simple create page because it is a short creation step. Full editing/detail should happen only on the child page.

## 5. Proposed 1J-A / 1J-B Split

Recommendation: split implementation into two parts.

### Phase 1 Slice 1J-A - Project List And Child Management Shell

1J-A should prove the Project navigation model, status transition UX and activation-readiness pattern before adding Product membership complexity.

Build:

- `/app/fund/projects` list page.
- Project table/list.
- Create Project flow.
- `/app/fund/projects/[id]` child page.
- Overview/edit details.
- Status actions.
- Activation readiness panel.
- Date and organiser fields.

Do not build the Project Product membership manager in 1J-A. It must remain planning-only in this slice. The implementation boundary is Project list, create, child page shell, overview/edit details, status actions and activation readiness.

### Phase 1 Slice 1J-B - Project Product Membership Manager

Build:

- Add Product to Project.
- Deactivate Product membership.
- Reactivate Product membership.
- Reorder Project Products.
- Display Product snapshots.
- Disabled/read-only membership controls after `CLOSED`, `COMPLETED` or `ARCHIVED`.

Why separate:

- Project Product membership has its own table/picker/reorder lifecycle.
- It needs specific snapshot wording.
- It has separate mutation failure modes.
- Splitting keeps 1J-A focused on proving Project management navigation and status handling.

## 6. Project List / Table Design

Route:

```text
/app/fund/projects
```

Required controls:

- fuzzy search;
- status filter;
- sort selector;
- sort direction toggle, or approved header-sort equivalent;
- visible data columns sortable where practical.

Status filter values:

- All current;
- Draft;
- Active;
- Paused;
- Closed;
- Completed;
- Archived.

Default:

- Archived Projects hidden by default.
- Default sort: Project Number ascending.

Recommended columns:

- Project Number.
- Name.
- Status.
- Lifecycle State.
- Close Date.
- Product Count.
- Organiser.
- Updated.

Row behaviour:

- Row click opens `/app/fund/projects/[id]`.
- Do not open an edit modal from row click.
- Do not add edit/delete `ActionIcon` buttons to Project table rows.
- Do not add edit/delete action columns.
- Inline quick actions, if any, must be non-destructive, far-right and use `stopPropagation()`.

## 7. Project Create Flow

Create should be intentionally compact.

This create flow is authenticated tenant-side admin Project creation only. It is not the future public or organiser-led Project Request / Project Initiation flow.

Recommended required fields:

- Project Number.
- Name.
- Slug.

Recommended optional fields during create:

- Closes At.
- Organiser Name.
- Organiser Email.
- Organiser Phone.

Fields that can wait for the child page:

- Description.
- Internal Notes.
- Opens At.
- Production Deadline.

Recommended UX:

- Create button above the Project list.
- Use a compact create modal or a simple create page.
- On successful create, navigate to `/app/fund/projects/[id]`.
- Surface duplicate project number/slug conflicts as clear notifications.
- Do not expose status on create; API creates as `DRAFT`.
- Do not expose lifecycle state on create; API creates as `SETUP`.

## 8. Project Child Page Layout

Route:

```text
/app/fund/projects/[id]
```

Recommended page structure:

- Breadcrumb: `FUND / Projects / {projectNumber or name}`.
- Header with Project number, Project name, status badge and lifecycle state badge.
- Secondary tab row or section navigation:
  - Overview.
  - Products.

For Slice 1J-A:

- Overview is required.
- Prefer omitting the Products tab until 1J-B unless a simple read-only readiness summary is trivial from the existing `fund.projects.get` response.
- If present in 1J-A, the Products tab may show a read-only count or readiness-related summary if this is trivial from `fund.projects.get`, but it must not include add/remove/reactivate/reorder controls.

For Slice 1J-B:

- Products becomes the Project Product membership manager.

## 9. Project Detail / Edit Form Design

Overview fields:

- Project Number.
- Name.
- Slug.
- Status display.
- Lifecycle State display.
- Organiser Name.
- Organiser Email.
- Organiser Phone.
- Opens At.
- Closes At.
- Production Deadline.
- Description.
- Internal Notes.

Rules:

- General Save calls `fund.projects.update`.
- General Save must not mutate status.
- Status display is read-only.
- Lifecycle State display is read-only in Slice 1J.
- Use dedicated status buttons for transitions.
- Keep form data intact on mutation errors.

Recommended grouping:

- Project identity: number, name, slug, status, lifecycle state.
- Dates: opens at, closes at, production deadline.
- Organiser contact: name, email, phone.
- Notes: description and internal notes.

Identifier caution:

- In 1J-A, Project Number and Slug may remain editable while the Project is still early-stage, but the UI should treat them as important identifiers and surface duplicate/conflict errors clearly.
- A future slice may lock or restrict these fields after activation if required.

## 10. Project Status Action Design

Status transitions must use dedicated endpoints:

- `fund.projects.activate`
- `fund.projects.pause`
- `fund.projects.close`
- `fund.projects.complete`
- `fund.projects.archive`
- `fund.projects.restore`

Only show valid next actions for the current Project status.

Transition visibility:

| Current Status | Visible Actions |
| --- | --- |
| `DRAFT` | Activate, Archive |
| `ACTIVE` | Pause, Close, Archive |
| `PAUSED` | Activate, Close, Archive |
| `CLOSED` | Complete, Archive |
| `COMPLETED` | Archive |
| `ARCHIVED` | Restore |

General rules:

- Do not show every status action at once.
- Invalid actions should be hidden or disabled with clear helper text.
- Archive should be visually separated from positive transitions.
- Destructive or irreversible-looking actions should use confirmation.
- General Save must not mutate status.

## 11. Activation Readiness Panel

Add an activation readiness panel on the Project child page.

Purpose:

- make activation blockers visible before the user clicks Activate;
- reduce avoidable API errors;
- teach the operational rules without relying on long explanatory text.

Readiness checks:

- Close date present.
- At least one active Project Product.
- No archived Products among active Project Products.
- Active Workflow Classes for active Project Products.

Data source:

- Use `fund.projects.get`.
- The Project detail response includes Project Product membership, nested Product and Workflow Class data.

In 1J-A, the readiness panel may show Product-related blockers even though the Products manager is deferred. This is acceptable because it explains why activation is blocked without trying to solve membership management in the same slice.

The client may calculate simple visible readiness checks for user guidance, but the server remains authoritative. The UI must still handle activation endpoint errors cleanly.

Panel behaviour:

- Show checklist-style status.
- If all checks pass, show Activate as available for valid statuses.
- If checks fail, show Activate disabled or allow the API call but present the blockers. Recommendation: disable with clear blockers where data is complete.
- If Products are deferred to 1J-B, 1J-A can still show a readiness panel using `fund.projects.get`, with Product-related checks showing current API-derived state.

Activation API errors to surface:

- missing `closesAt`;
- no active Project Product;
- archived Product in active Project Product;
- inactive or missing Workflow Class.

## 12. Date / Deadline UX

Fields:

- Opens At.
- Closes At.
- Production Deadline.

Rules:

- `closesAt` may be blank while `DRAFT`.
- Activation requires `closesAt`.
- `opensAt` must be before `closesAt` when both exist.
- `productionDeadline` must not be before `closesAt` when both exist.

UX requirements:

- Use date/time controls consistent with existing app patterns.
- Surface server validation messages directly.
- Avoid over-validating future workflow-specific deadline rules in 1J.
- Do not introduce Event date constraints before Event schema exists.

## 13. Organiser Contact Field UX

Fields:

- Organiser Name.
- Organiser Email.
- Organiser Phone.

Rules:

- optional;
- treated as contact snapshot fields;
- no organiser identity/account link;
- no Project Request or onboarding state;
- no C2 user invitation or organiser dashboard access;
- no `FundOrganiser`;
- no Project participant UI.

UX:

- Put organiser contact in its own section.
- Label it as contact information rather than user account membership.
- Email should validate as email client-side and server-side.
- Keep wording neutral: this is not yet a portal invitation or organiser login.

## 14. Project Product Membership Design For 1J-B

Plan but do not implement in 1J-A unless explicitly approved.

Required endpoints:

- `fund.projects.get`
- `fund.projects.addProduct`
- `fund.projects.removeProduct`
- `fund.projects.setProductActive`
- `fund.projects.reorderProducts`
- `fund.products.list`

Membership behaviours:

- Add Product to Project.
- Deactivate membership using soft removal.
- Reactivate inactive membership.
- Reorder Products with Move Up / Move Down controls.
- Display active/inactive membership state.
- Prevent membership changes after `CLOSED`, `COMPLETED` or `ARCHIVED`.
- Disable or hide membership mutation controls after `CLOSED`, `COMPLETED` or `ARCHIVED`.
- Allow membership changes only in `DRAFT`, `ACTIVE` and `PAUSED`.

Recommended UI:

- Products tab on Project child page.
- Product picker at top.
- Membership table below.
- Move Up / Move Down instead of drag-and-drop.
- Deactivate as a user-facing button, not a tiny destructive icon.
- Reactivate via clear button or active switch.
- Inline controls far-right where practical.
- All inline controls use `stopPropagation()`.

## 15. Product Snapshot Display Rules

Project Product rows should clearly show captured values as Project snapshots.

Do not imply that snapshot price or workflow values live-update from Product changes.

Suggested wording:

- `Captured for this Project`
- `Snapshot price`
- `Snapshot Workflow Class`

Snapshot fields to display:

- `productCodeSnapshot`
- `productNameSnapshot`
- `productShortDescriptionSnapshot`
- `workflowClassCodeSnapshot`
- `workflowClassNameSnapshot`
- `unitPriceNetSnapshot`
- `vatRateSnapshot`
- `currencySnapshot`

Recommended table columns for 1J-B:

- Product Code.
- Product Name.
- Snapshot Workflow Class.
- Snapshot Price.
- Active State.
- Sort Order / Move controls.

## 16. Search / Sort / Filter Behaviour

Project list:

- fuzzy search mandatory;
- status filter mandatory;
- sort selector and direction toggle mandatory, unless an approved header-sort equivalent is used;
- archived hidden by default;
- default sort Project Number ascending.

Suggested searchable fields:

- project number;
- name;
- slug;
- organiser name;
- organiser email;
- status;
- lifecycle state.

Suggested sortable fields:

- project number;
- name;
- status;
- lifecycle state;
- close date;
- product count;
- organiser;
- updated.

Project Products tab in 1J-B:

- search Product code/name/snapshot workflow;
- sort by code/name/workflow/price/active/sort order where practical.

## 17. Table / Child-Page UX Compliance

Project list follows IsoStack child-page rules:

- row click opens child page, not CRUD modal;
- child page header shows entity name;
- child page may use secondary tabs;
- search/sort controls remain mandatory on list/table surfaces;
- table rows are pointer/hover clickable;
- no edit/delete `ActionIcon` buttons in Project table rows;
- no edit/delete action columns;
- inline quick actions, if any, are non-destructive and call `stopPropagation()`.

Project detail follows management-container guidance:

- bookmarkable URL;
- browser back/forward compatible;
- page-level context retained;
- child tabs/sections for Overview and Products.

## 18. tRPC Usage Plan

Project list:

- `fund.projects.list`

Project detail:

- `fund.projects.get`

Project create:

- `fund.projects.create`

Project update:

- `fund.projects.update`

Status actions:

- `fund.projects.activate`
- `fund.projects.pause`
- `fund.projects.close`
- `fund.projects.complete`
- `fund.projects.archive`
- `fund.projects.restore`

Project Product membership in 1J-B:

- `fund.projects.addProduct`
- `fund.projects.removeProduct`
- `fund.projects.setProductActive`
- `fund.projects.reorderProducts`
- `fund.products.list`

Invalidation strategy:

- create: invalidate Project list, navigate to detail;
- update: invalidate Project detail and list;
- status transition: invalidate Project detail and list;
- membership mutation: invalidate Project detail and list;
- Product picker in 1J-B: invalidate Product list only when needed, usually not after Project membership mutations.

## 19. Form Handling And Validation Plan

Client validation should mirror server rules but not replace them.

Project create:

- project number required;
- name required;
- slug required and URL-safe;
- organiser email optional but valid when supplied.

Project update:

- same shape as server update;
- no status field;
- no lifecycle state field;
- validate date ordering:
  - opens at before closes at;
  - production deadline not before closes at.

Server remains authoritative:

- project number uniqueness;
- slug uniqueness;
- activation readiness;
- status transitions;
- tenant scoping;
- membership mutation restrictions.

## 20. Error Handling And Notifications

Use Mantine notifications consistent with the Products/Catalogues UI.

Recommended handling:

- `CONFLICT`: show duplicate project number/slug or duplicate Product membership message.
- `BAD_REQUEST`: show server message, especially readiness, date ordering, invalid transition or membership lock messages.
- `NOT_FOUND`: show stale/missing record message and route back to list where appropriate.
- `FORBIDDEN`: show permission/feature access message.
- generic errors: show clear fallback.

Keep form state intact on mutation errors.

Status actions:

- show success notification after transition;
- keep user on Project detail page;
- refresh Project detail/list state.

## 21. Loading / Empty / Error States

Project list:

- loading skeleton or table loading state;
- empty state for no Projects;
- empty search state for no matching Projects;
- clear archived-filter messaging when viewing Archived.

Project detail:

- detail skeleton while loading;
- not found state with return to Projects;
- error state with retry;
- disabled form controls while saving.

Readiness panel:

- loading state while detail data loads;
- clear incomplete checklist when Product data is absent or no products exist.

Products tab in 1J-B:

- no Products in Project;
- no eligible Products available to add;
- archived/closed/completed read-only notice.

## 22. Manual Test Checklist

### 1J-A Project List And Overview

- Project list loads.
- Fuzzy search works.
- Sort selector and direction toggle work.
- Status filter works for All current, Draft, Active, Paused, Closed, Completed and Archived.
- Archived Projects are hidden by default.
- Project row click opens `/app/fund/projects/[id]`.
- Project row click does not open a modal.
- Project table has no edit/delete `ActionIcon` buttons.
- Create Project succeeds and navigates to child page.
- Duplicate project number shows `CONFLICT`.
- Duplicate slug shows `CONFLICT`.
- Edit Project details succeeds.
- General Save does not mutate status.
- Date ordering errors are shown clearly.
- Organiser contact fields save as contact snapshots.
- Project create does not create organiser users, invite organiser users or expose organiser dashboard access.
- Status actions only show valid next actions.
- Activation readiness panel shows missing close date.
- Activation readiness panel shows missing active Product.
- Activation API errors are shown clearly.
- Project can be activated once readiness conditions are met.
- Pause, Activate, Close, Complete, Archive and Restore status flows work.

### 1J-B Project Product Membership

- Product can be added to Project.
- Archived Product cannot be added.
- Duplicate active membership shows `CONFLICT`.
- Membership can be deactivated.
- Inactive membership can be reactivated.
- Reactivation refreshes snapshots.
- Membership reorder requires full list and works with Move Up / Move Down.
- Product membership controls are disabled/read-only after `CLOSED`, `COMPLETED` and `ARCHIVED`.
- Snapshot Product values display as captured values, not live values.

### Prerequisite

- Apply Slice 1H migration in the target environment before UI testing.
- Do not use `db:push`, seed or reset as a shortcut.

## 23. Deliberately Out Of Scope

Do not implement in Slice 1J:

- Event schema.
- Store schema.
- Order schema.
- commerce.
- payments.
- commissions.
- dashboards.
- production batching.
- SeasonPro integration.
- AMOW marketplace exposure.
- media/asset workflows.
- lifecycle tables.
- lifecycle transition engine.
- organiser identity/account linking.
- AI workflows.
- Prisma schema changes.
- migrations.
- `db:push`.
- seed/reset commands.

## 24. Risks And Recommendations

Overall UI risk: Medium.

Reasons:

- Project is the operational centre of FUND.
- Project has status transitions and activation readiness rules.
- Project Product membership adds child-data complexity.
- Local DB-backed tRPC smoke testing previously could not run until the 1H migration exists in the database.

Mitigations:

- Split 1J into 1J-A and 1J-B.
- Use child page instead of modal.
- Surface activation readiness before users click Activate.
- Only show valid status actions.
- Keep Product membership manager separate until the Project shell is proven.
- Complete DB-backed testing only after the 1H migration is applied.

Recommendation:

- Proceed with 1J-A first.
- Defer full Project Product membership manager to 1J-B.
- Do not start Events, Stores, Orders or commerce until Project UI foundations are tested.

## 25. Recommended Implementation Prompt For 1J-A

```text
Proceed with FUND Phase 1 Slice 1J-A implementation: Project list and child management shell.

Work on:
feature/fund-phase-1-products-catalogues

Do not edit Prisma schema.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.
Do not create Events, Stores, Orders, commerce, payments, commissions, dashboards, production batching, SeasonPro integration, marketplace exposure, media/asset workflows, lifecycle tables, lifecycle transition engine, organiser identity/account linking or AI workflows.

Use:
- isodocs/docs/modules/fund/Planning/2026-06-23-fund-phase-1-slice-1j-project-admin-ui-proposal.md
- isodocs/docs/modules/fund/implementation/2026-06-23-phase-1-slice-1i-project-api-services-confirmation.md
- IsoStack UX/UI standard
- table CRUD pattern guidance

Implement only:
- /app/fund/projects list page;
- Project table with fuzzy search, status filter, sort selector and direction toggle;
- row click navigation to /app/fund/projects/[id];
- Project create flow;
- /app/fund/projects/[id] child page;
- Overview/edit details form;
- status action controls showing only valid next actions;
- activation readiness panel;
- date/deadline fields;
- organiser contact fields;
- loading/empty/error states;
- confirmation documentation.

Do not implement the full Project Product membership manager in 1J-A.
In 1J-A, do not implement Project Product membership mutation controls. A Products tab may be omitted or included only as a read-only placeholder/summary.
The activation readiness panel may display Product-related blockers from fund.projects.get, but server-side activation validation remains authoritative.

Run:
- npm run type-check
- npm run verify

Create confirmation document:
isodocs/docs/modules/fund/implementation/2026-06-24-phase-1-slice-1j-a-project-list-child-management-shell-confirmation.md
```

## 26. Recommended Follow-Up Prompt For 1J-B

```text
Proceed with FUND Phase 1 Slice 1J-B planning only: Project Product membership manager.

Work on:
feature/fund-phase-1-products-catalogues

Do not edit Prisma schema.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.
Do not create Events, Stores, Orders, commerce, payments, commissions, dashboards, production batching, SeasonPro integration, marketplace exposure, media/asset workflows, lifecycle tables, lifecycle transition engine, organiser identity/account linking or AI workflows.

Use:
- isodocs/docs/modules/fund/Planning/2026-06-23-fund-phase-1-slice-1j-project-admin-ui-proposal.md
- 1J-A confirmation document
- Slice 1I Project API/services confirmation
- IsoStack UX/UI standard
- table CRUD pattern guidance

Plan Project Product membership management inside the Project child page Products tab using only:
- fund.projects.get
- fund.projects.addProduct
- fund.projects.removeProduct
- fund.projects.setProductActive
- fund.projects.reorderProducts
- fund.products.list

The plan must cover add, deactivate, reactivate, reorder, active/inactive display, snapshot display wording, disabled/read-only state after CLOSED/COMPLETED/ARCHIVED, error handling, query invalidation and manual tests.

Planning only. Do not implement.
```
