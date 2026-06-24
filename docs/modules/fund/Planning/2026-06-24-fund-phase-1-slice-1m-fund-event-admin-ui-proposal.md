# FUND Phase 1 Slice 1M - FundEvent Admin UI Proposal

Date: 2026-06-24

Status: Planning only

Target branch:

```text
feature/fund-phase-1-products-catalogues
```

## 1. Slice Goal

Plan the FundEvent admin UI using the existing Slice 1L-B Event API/services.

Events are optional tenant-owned grouping and constraint containers. Projects remain the mandatory operational unit of work.

The Event UI should let tenant admins create, review, edit and status-manage Events while clearly explaining how Event dates constrain linked Projects.

Events organise and constrain Projects. They do not replace Projects and do not create Stores, Orders, payments, commissions, production batches, organiser users or Project Request flows.

## 1A. Role And Ownership Clarification

Slice 1M-A is a C1 tenant/admin surface.

Role model:

- C1 users are tenant/admin users who configure Events, date constraints and campaign-level settings.
- C2 users are Project organisers who operate Projects within the tenant context and, where applicable, within Event constraints.

Ownership model:

- Events are managed by C1 tenant/admin users.
- Events should not be treated as C2-owned records.
- Projects belong to C2 Project organisers, but Project organiser ownership/access must not be redesigned in 1M-A.
- Linked Projects may be displayed from the Event detail page so C1 admins can understand Event impact.

Dashboard boundary:

- FUND is expected to have both C1 and C2 dashboard surfaces.
- The C1 dashboard/admin surface is the tenant/admin/producer control surface for Event management, Products, Catalogues, Project oversight, production, distribution and communications to C2 organisers.
- The C2 dashboard is the organiser/project operating surface for managing own Projects, fundraising lifecycle, project communications, template creation, artwork upload, submission/approval tasks and progress.
- Current Phase 1 admin work, including 1M-A, is building the C1 dashboard/admin foundation only.
- The current admin foundation must not be mistaken for the future C2 organiser dashboard.

1M-A must not implement:

- C2 organiser dashboards;
- organiser invitations;
- Project Request/onboarding;
- Project ownership changes;
- Project organiser access changes.

## 2. Implementation Boundary

Slice 1M is planning only.

Recommended implementation split:

- 1M-A - Event list and child management shell.
- 1M-B - Project Event selector / linkage UI.

1M-A should not implement Project Event selection or Project linkage controls. It should show linked Projects read-only using the existing Event detail response.

Do not implement in 1M planning:

- application code;
- Prisma schema edits;
- migrations;
- `db:push`;
- seed/reset commands;
- routers, services, Zod schemas or tRPC endpoints;
- Event UI implementation;
- Project Event selector UI;
- Stores, Orders, commerce, payments or commissions;
- dashboards or production batching;
- SeasonPro integration;
- marketplace exposure;
- media/asset workflows;
- lifecycle tables or lifecycle transition engine;
- organiser identity/account linking;
- organiser invitations;
- Project Request/onboarding flows;
- Project ownership/access changes;
- C2 organiser dashboards;
- AI workflows.

## 3. Source Documents And Assumptions

Read and applied:

- `implementation/2026-06-24-phase-1-slice-1l-a-fund-event-schema-confirmation.md`
- `implementation/2026-06-24-phase-1-slice-1l-b-fund-event-api-services-confirmation.md`
- `implementation/2026-06-24-phase-1-slice-1l-c-fund-event-api-manual-review-confirmation.md`
- `Planning/2026-06-24-fund-phase-1-slice-1l-event-season-planning-proposal.md`
- `05-fund-open-questions.md`
- Slice 1H and 1I Project schema/API confirmations
- Slice 1J-A and 1J-B Project Admin UI confirmations
- IsoStack UX/UI standard
- table CRUD pattern guidance
- current FUND Products/Catalogues UI patterns
- current FUND Project Admin UI patterns

Assumptions:

- Slice 1L-B API/services are review-clean.
- The local development database has current FUND migrations applied.
- `fund.events.get` includes linked Project summaries and Project count.
- Project Event selector work is deliberately deferred to 1M-B.
- Event detail should be bookmarkable because Events can affect multiple Projects and future child domains.

## 4. Route Recommendation

Recommended routes:

```text
/app/fund/events
/app/fund/events/[id]
```

`/app/fund/events` should be the Event list and create entry point.

`/app/fund/events/[id]` should be the Event child management page for overview/editing, status actions, date constraints and linked Project visibility.

## 5. Why Events Use A Child Page

Use a child page rather than a large CRUD modal.

Reasons:

- Event may list multiple linked Projects.
- Event dates constrain Project dates and activation readiness.
- Event status transitions need context and confirmation.
- Event detail should be bookmarkable and shareable.
- Event may later gain default Catalogues/Products, communications, production grouping or reporting.
- This mirrors the Project child-page pattern already used for complex FUND parent entities.

Simple create may still use a compact modal or create page. Full detail/edit must happen in the child page.

## 6. Event List/Table Design

Route:

```text
/app/fund/events
```

Use a page structure similar to `/app/fund/projects`:

- page title and short context text;
- Create Event button above the table;
- `FundTableControls` for search/status/sort;
- DataTable with row click to child page;
- no edit/delete row ActionIcons;
- no edit/delete actions column.

Recommended columns:

- Code;
- Name;
- Status;
- Event Type / Category;
- Opens At;
- Closes At;
- Production Deadline;
- Linked Project Count;
- Updated.

Default sort:

```text
Code ascending
```

This is consistent with the Project table defaulting to the primary identifier.

Status filter values:

- All current;
- Draft;
- Active;
- Closed;
- Archived.

Archived Events should be hidden by default.

Row behaviour:

- row click opens `/app/fund/events/[id]`;
- use `normalizeRowClick(params?.record ?? params)` equivalent, matching existing FUND table safety;
- show pointer cursor and row hover feedback;
- no destructive inline actions;
- any future inline quick actions must be non-destructive, far-right and call `stopPropagation()`.

## 7. Event Create Flow

Recommended create fields:

Required:

- Code;
- Name;
- Slug.

Optional during create:

- Event Type / Category;
- Opens At;
- Closes At;
- Production Deadline.

Fields that can wait for child page:

- Description;
- Internal Notes.

Recommended UX:

- Create Event button above the Event list.
- Use a compact create modal or simple create page.
- On success, invalidate Event list and navigate to `/app/fund/events/[id]`.
- Do not expose status on create.
- API creates Events as `DRAFT`.
- Surface duplicate code/slug `CONFLICT` errors clearly.

## 8. Event Child Page Layout

Route:

```text
/app/fund/events/[id]
```

Recommended layout follows `ProjectDetailPage`:

- Back to Events link.
- Title area showing Event name/code/status.
- Primary tabs:
  - Overview;
  - Linked Projects.

For 1M-A:

- Overview is required.
- Linked Projects is read-only.
- No Project Event selector UI.
- No Project link/unlink controls.

Suggested Overview composition:

- Event overview/edit form.
- Status actions card.
- Date constraint panel.
- Linked Project summary count.

## 9. Event Overview/Edit Form Design

Editable fields:

- Code;
- Name;
- Slug;
- Event Type / Category;
- Opens At;
- Closes At;
- Production Deadline;
- Description;
- Internal Notes.

Read/display fields:

- Status;
- Created/updated metadata if readily available;
- Linked Project count.

Rules:

- General Save must call `fund.events.update`.
- General Save must not mutate status.
- Status is changed only through dedicated status actions.
- Archived Events should show disabled normal edit fields or a clear restore-first notice, matching API behaviour.

## 10. Event Status Action Design

Use dedicated endpoint calls:

- `fund.events.activate`
- `fund.events.close`
- `fund.events.archive`
- `fund.events.restore`

Only show valid next actions for the current Event status:

| Current Status | Actions |
| --- | --- |
| `DRAFT` | Activate, Archive |
| `ACTIVE` | Close, Archive |
| `CLOSED` | Archive |
| `ARCHIVED` | Restore |

Do not show every status action at once.

Invalid actions should be hidden or disabled with clear helper text.

Confirmation rules:

- Archive must ask for confirmation.
- Close should ask for confirmation when linked Projects exist or where closing may block new Project linkage.
- Restore can be direct or confirmed; a light confirmation is acceptable because restore changes visibility/availability.

After status transition:

- invalidate Event detail;
- invalidate Event list;
- consider invalidating Project list/detail queries only where linked Project displayed state may depend on Event status/date context.

## 11. Event Date Constraint Panel

Purpose:

- explain how Event dates constrain linked Projects;
- make clear that Event `closesAt` is the latest permissible effective close date for linked Projects;
- make clear that Project close date may be earlier than Event close date;
- make clear that if a linked Project has no close date, the Event close date can act as its effective inherited close date;
- make clear that Store-specific close dates are not part of this slice.

Panel should display:

- Event `opensAt` as earliest permitted linked Project `opensAt`, where present;
- Event `closesAt` as latest permitted effective linked Project `closesAt`, where present;
- Event `productionDeadline` as latest permitted linked Project `productionDeadline`, where present;
- plain-language helper text.

Suggested wording:

- "Linked Projects may close earlier than this Event, but not later."
- "If a linked Project has no close date, the Event close date can act as its effective close date."
- "Store-specific close dates are a later Store planning concern."

The panel must not imply Event `closesAt` is copied into `FundProject.closesAt`.

## 12. Linked Projects Read-Only List

Purpose:

- show which Projects are currently linked to the Event;
- help admins understand the impact of Event date/status changes;
- provide navigation to Project child pages.

This is a C1/admin visibility surface only. It must not redesign Project organiser ownership, C2 access, organiser invitations or organiser dashboard access.

Use linked Project summaries from `fund.events.get`.

Recommended columns:

- Project Number;
- Name;
- Status;
- Lifecycle State;
- Opens At;
- Project Close Date;
- Effective Close Date;
- Production Deadline;
- Updated.

If Product count is not included in the current Event detail response, do not add a new endpoint in 1M-A. Either omit Product Count or show it only if already available.

Rules:

- read-only in 1M-A;
- row click may navigate to `/app/fund/projects/[id]`;
- no edit/delete ActionIcons;
- no unlink controls;
- no Project Event selector UI;
- no Project mutation controls.
- no Project ownership/access controls.

## 13. Event-Linked Project Date Semantics Display

The UI must use careful language:

- `Project close date`;
- `Effective close date`;
- `Inherited from Event`;
- `Latest allowed close date`.

Display rules:

- If Project has its own `closesAt`, display that as Project close date and effective close date.
- If Project `closesAt` is blank and Event `closesAt` is present, display Event `closesAt` as effective/inherited close date.
- If both are blank, show that the Project has no effective close date.

Do not imply the Event close date has been copied into the Project.

## 14. Search/Sort/Filter Behaviour

Event list must include:

- fuzzy search;
- status filter;
- sort selector;
- sort direction toggle, unless an approved visible-column/header sort equivalent is used.

Recommended search keys:

- code;
- name;
- slug;
- event type/category;
- description;
- status.

Recommended sort keys:

- code;
- name;
- status;
- event type/category;
- opensAt;
- closesAt;
- productionDeadline;
- linked Project count;
- updatedAt.

Visible data columns should be sortable where practical.

## 15. Table/Child-Page UX Compliance

Complies with IsoStack patterns:

- Event list is a complex-entity list where row click opens a child page.
- No edit/delete row actions.
- No destructive inline actions.
- Create action sits above the table.
- Search/filter/sort controls are mandatory.
- Child page is used for multi-section detail and linked child visibility.
- Status transitions are explicit contextual actions, not generic form saves.

This follows the existing Project admin pattern more than the simple Product/Catalogue modal CRUD pattern.

## 16. tRPC Usage Plan

Use existing 1L-B endpoints only.

Event list:

- `fund.events.list`

Event detail:

- `fund.events.get`

Event create:

- `fund.events.create`

Event update:

- `fund.events.update`

Status actions:

- `fund.events.activate`
- `fund.events.close`
- `fund.events.archive`
- `fund.events.restore`

Project endpoints:

- 1M-A should not use Project mutation endpoints.
- Project linked-list display should use `fund.events.get` linked Project summaries.
- Do not introduce new endpoints.

Invalidation strategy:

- create: invalidate Event list and navigate to Event detail;
- update: invalidate Event detail and Event list;
- status transition: invalidate Event detail and Event list;
- optionally invalidate Project queries if the UI displays Event-derived effective close dates in Project views later;
- no Project mutation invalidation is needed in 1M-A.

## 17. Form Handling And Validation Plan

Client validation should mirror server rules but not replace them.

Create validation:

- code required;
- name required;
- slug required;
- slug URL-safe/lowercase pattern.

Update validation:

- status field is not directly editable through general Save;
- `opensAt` before `closesAt` when both exist;
- `productionDeadline` not before `closesAt` when both exist.

Server remains authoritative for:

- tenant scoping;
- duplicate code/slug;
- Event status transitions;
- Event date validation;
- archived Event edit restrictions;
- linked Project constraint implications.

## 18. Error Handling And Notifications

Map tRPC errors:

- `CONFLICT`: duplicate Event code/slug.
- `BAD_REQUEST`: invalid dates, invalid status transition, archived edit restriction or linked Project/date constraint issue.
- `NOT_FOUND`: stale or missing Event.
- `FORBIDDEN`: permission or FUND feature access.
- generic error: clear fallback message.

Use Mantine notifications consistent with existing Project/Product/Catalogue UI.

Mutation errors should keep the child page open and preserve form state.

## 19. Loading/Empty/Error States

Event list:

- loading table/skeleton;
- empty state for no Events;
- empty search/filter state;
- archived-filter messaging;
- retry control on load error.

Event detail:

- loading skeleton;
- not-found state with return to Events;
- error state with retry;
- disabled form controls while saving.

Linked Projects:

- no linked Projects message;
- read-only notice;
- loading state if fetched asynchronously through Event detail;
- no Project link/unlink affordances in 1M-A.

## 20. Manual Test Checklist

Event list:

- `/app/fund/events` loads.
- Fuzzy search works.
- Status filter works.
- Archived hidden by default.
- Sort selector and direction toggle work.
- Row click opens `/app/fund/events/[id]`.
- No edit/delete ActionIcons exist in Event table rows.

Event create:

- Event can be created.
- Duplicate code shows `CONFLICT`.
- Duplicate slug shows `CONFLICT`.
- Create navigates to Event child page.
- Event is created as `DRAFT`.

Event detail:

- Overview tab loads.
- Event details can be edited.
- General Save does not mutate status.
- Invalid date ordering errors are shown clearly.
- Date constraint panel explains Event/Project relationship.
- Store close-date semantics are not shown.
- Event detail remains a C1/admin surface and does not expose organiser ownership/access controls.

Status actions:

- DRAFT shows Activate and Archive.
- ACTIVE shows Close and Archive.
- CLOSED shows Archive.
- ARCHIVED shows Restore.
- Invalid actions are not shown.
- Archive asks for confirmation.
- Close asks for confirmation where appropriate.
- Status changes use dedicated endpoints.

Linked Projects:

- Linked Projects list displays linked Projects from Event detail response.
- Linked Projects list is read-only.
- Project row click navigates to Project child page if implemented.
- Effective close date displays Project close date when Project has one.
- Effective close date displays inherited Event close date when Project close date is blank.
- No effective close date warning is shown when both Project and Event close dates are blank.

Regression:

- `/app/fund/projects` still loads.
- Project child page still loads.
- Project Products tab still works.
- Products/Catalogues admin still works.
- No Project Event selector UI is introduced in 1M-A.
- No C2 organiser dashboard, organiser invitation, Project Request/onboarding or Project ownership change is introduced in 1M-A.

## 21. Deliberately Out Of Scope

Out of scope for 1M-A:

- Event schema changes;
- migrations;
- Event API/service changes;
- Project Event selector UI;
- Project create/edit Event selection;
- Project link/unlink controls from Event detail;
- Store schema;
- Order schema;
- commerce;
- payments;
- commissions;
- dashboards;
- production batching;
- SeasonPro integration;
- marketplace exposure;
- media/asset workflows;
- lifecycle engine;
- organiser identity/account linking;
- organiser invitations;
- C2 organiser dashboards;
- Project Request/onboarding flows;
- Project ownership/access changes;
- AI workflows.

## 22. Risks And Recommendations

Risks:

- Event detail can become too dense if create/edit/status/linked Projects are all forced into one panel.
- Date semantics can confuse users if inherited effective close date is not labelled precisely.
- Status actions could be accidentally overexposed if all actions are shown at once.
- Event date edits may affect linked Project validity; 1M-A should display linked Projects clearly but should not attempt to auto-mutate them.

Recommendations:

- Keep 1M-A focused on Event list, create, child detail, status actions, date constraint panel and read-only linked Projects.
- Use Project child-page UI as the primary implementation reference.
- Prefer clear language over clever UI for effective/inherited close date.
- Defer Project Event selector/linkage UI to 1M-B.
- Do a short 1M-C UI review/manual testing pass after 1M-A and 1M-B are implemented, before moving to Store or organiser-facing planning.

## 23. Recommended Implementation Prompt For 1M-A

```text
Proceed with FUND Phase 1 Slice 1M-A implementation: FundEvent list and child management shell.

Work on:
feature/fund-phase-1-products-catalogues

Use:
- isodocs/docs/modules/fund/Planning/2026-06-24-fund-phase-1-slice-1m-fund-event-admin-ui-proposal.md
- Slice 1L-A, 1L-B and 1L-C confirmation documents
- existing FUND Project Admin UI patterns
- IsoStack UX/UI standard
- table CRUD pattern guidance

Implement only:
- /app/fund/events list page;
- Event table/list with fuzzy search, status filter, sort selector and sort direction toggle;
- compact Create Event flow;
- /app/fund/events/[id] child page;
- Event overview/edit form;
- Event status actions;
- Event date constraint panel;
- read-only linked Projects list from fund.events.get;
- loading/empty/error states;
- implementation confirmation document.

Use existing endpoints only:
- fund.events.list
- fund.events.get
- fund.events.create
- fund.events.update
- fund.events.activate
- fund.events.close
- fund.events.archive
- fund.events.restore

Do not edit Prisma schema.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.
Do not create or modify routers, services, Zod schemas or tRPC endpoints.
Do not implement Project Event selector UI.
Do not implement Project create/edit Event selection.
Do not create Stores, Orders, commerce, payments, commissions, dashboards, production batching, SeasonPro integration, marketplace exposure, media/asset workflows, lifecycle tables, lifecycle transition engine, organiser identity/account linking, Project Request/onboarding flows or AI workflows.
Do not implement C2 organiser dashboards, organiser invitations, Project ownership changes or Project organiser access changes.

Run:
- npm run type-check
- npm run verify

Create:
isodocs/docs/modules/fund/implementation/2026-06-24-phase-1-slice-1m-a-fund-event-admin-ui-confirmation.md
```

## 24. Recommended Follow-Up Planning Prompt For 1M-B

```text
Proceed with FUND Phase 1 Slice 1M-B planning only: Project Event selector and linkage UI.

Work on:
feature/fund-phase-1-products-catalogues

Use:
- isodocs/docs/modules/fund/Planning/2026-06-24-fund-phase-1-slice-1m-fund-event-admin-ui-proposal.md
- isodocs/docs/modules/fund/implementation/2026-06-24-phase-1-slice-1m-a-fund-event-admin-ui-confirmation.md
- Slice 1L-A, 1L-B and 1L-C confirmation documents
- existing Project Admin UI implementation
- IsoStack UX/UI standard

Plan only:
- Event selection in Project create/edit;
- clear Event date helper text in Project UI;
- effective inherited close date display when Project closesAt is blank;
- activation readiness refresh for Event-linked Projects;
- Project Event linkage changes only while Project is DRAFT;
- standalone Projects remain valid;
- C1/admin Project Event linkage UI only, not C2 organiser ownership/access redesign;
- no Event API/schema changes unless a reviewed gap is discovered.

Do not implement code.
Do not edit Prisma schema.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.
Do not create Stores, Orders, commerce, payments, commissions, dashboards, production batching, SeasonPro integration, marketplace exposure, media/asset workflows, lifecycle engine, organiser identity/account linking, Project Request/onboarding flows or AI workflows.
Do not implement C2 organiser dashboards, organiser invitations, Project ownership changes or Project organiser access changes.

Produce:
isodocs/docs/modules/fund/Planning/2026-06-24-fund-phase-1-slice-1m-b-project-event-selector-ui-proposal.md
```
