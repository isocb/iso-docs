# FUND Phase 1 Slice 1M-B - Project Event Selector UI Proposal

Date: 2026-06-24

Status: Planning only

Target branch:

```text
feature/fund-phase-1-products-catalogues
```

## 1. Slice Goal

Plan the C1/admin Project Event selector and linkage UI inside the existing Project admin surface.

Slice 1M-B should allow authenticated C1 tenant/admin users to:

- create standalone Projects with no Event;
- create Projects linked to eligible Events;
- view current Project/Event linkage on the Project child page;
- link, change or unlink Events while a Project is still `DRAFT`;
- understand Event date constraints and inherited/effective close-date behaviour;
- see activation-readiness feedback that reflects linked Event close dates.

This is not a C2 organiser dashboard, Project Request/onboarding flow, organiser invitation flow or Project ownership/access redesign.

## 2. Implementation Boundary

Planning only. Do not implement in this slice.

1M-B implementation should use only existing APIs:

- `fund.projects.get`
- `fund.projects.create`
- `fund.projects.update`
- `fund.projects.activate`
- `fund.events.list`
- `fund.events.get`, only if needed for richer helper/detail display

Do not introduce:

- application code during this planning pass;
- Prisma schema edits;
- migrations;
- `db:push`;
- seed/reset commands;
- routers, services, Zod schemas or tRPC endpoints;
- Stores, Orders, commerce, payments or commissions;
- dashboards beyond existing C1 admin surfaces;
- production batching;
- SeasonPro integration;
- marketplace exposure;
- media/asset workflows;
- lifecycle engine;
- organiser identity/account linking;
- Project Request/onboarding;
- C2 organiser dashboards;
- organiser invitations;
- Project ownership/access changes;
- AI workflows.

## 3. Source Documents And Assumptions

Read and applied:

- `Planning/2026-06-24-fund-phase-1-slice-1m-fund-event-admin-ui-proposal.md`
- `implementation/2026-06-24-phase-1-slice-1m-a-fund-event-admin-ui-confirmation.md`
- `implementation/2026-06-24-phase-1-slice-1l-a-fund-event-schema-confirmation.md`
- `implementation/2026-06-24-phase-1-slice-1l-b-fund-event-api-services-confirmation.md`
- `implementation/2026-06-24-phase-1-slice-1l-c-fund-event-api-manual-review-confirmation.md`
- `implementation/2026-06-24-phase-1-slice-1j-a-project-list-child-management-shell-confirmation.md`
- `implementation/2026-06-24-phase-1-slice-1j-b-project-product-membership-manager-confirmation.md`
- active FUND documents in `isodocs/docs/modules/fund/`
- current `ProjectCreateModal`
- current `ProjectDetailPage`
- current `EventTable`, `EventCreateModal` and `EventDetailPage`
- IsoStack UX/UI standard
- table CRUD pattern guidance

Assumptions:

- Slice 1L-B Project/Event API behaviour is review-clean.
- `Project.eventId` is optional.
- `fund.projects.create` and `fund.projects.update` already accept optional `eventId`.
- Events are tenant-owned and tenant-scoped by the API.
- The Event selector must only show Events owned by the same C1 tenant as the Project.
- C2/project organisers must not see or link to Events from other tenants.
- Server-side tenant scoping remains authoritative if a stale or malicious `eventId` is submitted.
- Event linkage can only change while a Project is `DRAFT`.
- DRAFT and ACTIVE Events are eligible for new Project linkage.
- CLOSED and ARCHIVED Events remain visible historically when already linked, but are not eligible for new linkage.
- Project activation remains a Project status action and the server remains authoritative.

## 4. Role And Ownership Boundary

C1 users are tenant/admin users who configure Events and oversee Projects.

C2 users are Project organisers. Projects conceptually belong to C2 Project organisers, but current Phase 1 Project admin UI is still a C1/admin surface.

1M-B should therefore:

- expose Project/Event linkage controls to C1/admin users only through the existing Project admin surface;
- treat Events as C1/admin-managed tenant records;
- list and link only Events owned by the same C1 tenant as the Project;
- keep organiser fields as optional Project contact/snapshot fields;
- avoid C2-facing Project management behaviour;
- avoid organiser invitations, organiser account creation, Project Request/onboarding and Project ownership/access changes.

## 5. Event Selection In Project Create

Update the compact Project create flow to include an optional Event selector.

Recommended placement:

- after Project Number, Name and Slug;
- before Close Date and organiser contact fields;
- with concise helper text when an Event is selected.

Create behaviour:

- selector can be blank for standalone Projects;
- selector lists eligible tenant Events;
- selected Event id is passed as `eventId` to `fund.projects.create`;
- on success, invalidate Project list and navigate to `/app/fund/projects/[id]`;
- if Event-linked create affects Event project counts later, invalidate Event list as well.

Do not:

- force Project close date to equal Event close date;
- copy Event dates into Project date fields;
- create/invite organiser users;
- expose organiser dashboard access.

## 6. Event Selection In Project Detail/Edit

Add an Event linkage section to the Project Overview tab in `ProjectDetailPage`.

Recommended placement:

- near the date/readiness area, before or inside the Project details form;
- visually close to Opens At, Closes At and Production Deadline because Event linkage affects those validations.

Display states:

- linked Project: show Event code, name, status, event type, close date and a link to `/app/fund/events/[id]`;
- standalone Project: show a clear `Standalone Project` state;
- linked CLOSED or ARCHIVED Event: show it read-only as historical context.

Mutation rule:

- permit link/change/unlink only while `project.status === 'DRAFT'`;
- for non-DRAFT Projects, show Event linkage as read-only with helper text explaining that linkage can only be changed while Draft.

Implementation should use `fund.projects.update`.

General Save must not mutate Project status. Status transitions remain dedicated actions.

## 7. Event Picker Design

Preferred control:

- searchable Mantine `Select` or `Combobox`;
- clearable selection to support standalone Projects/unlinking;
- disabled/read-only when Project is not DRAFT.

Option display should include:

- Event code;
- Event name;
- Event status;
- Event type/category where available;
- Event close date where available.

Recommended label format:

```text
EVT-CHRISTMAS-2026 - Christmas 2026 · ACTIVE · closes 2026-11-30
```

For richer display in a Combobox, show:

- primary line: code and name;
- secondary line: status, event type and close date.

## 8. Eligible Event Filtering

Use `fund.events.list`.

The Event selector must only list Events from the current actor's C1 tenant context. Cross-tenant Events must never appear in selector results, and server-side same-tenant validation remains authoritative if a stale or malicious `eventId` is submitted.

Eligible for new selection:

- `DRAFT`;
- `ACTIVE`.

Not eligible for new selection:

- `CLOSED`;
- `ARCHIVED`.

Recommended implementation approach:

- call `fund.events.list` with current/non-archived input first;
- filter client-side to DRAFT and ACTIVE if needed;
- do not show CLOSED/ARCHIVED Events as selectable options for new linkage.

Current linked Events:

- if current linked Event is CLOSED or ARCHIVED, keep it visible in the Project detail page as historical context;
- do not allow selecting that CLOSED/ARCHIVED Event for another Project;
- if the picker list does not include the current linked Event, use Project detail data or `fund.events.get` only when needed to display the current Event summary.

Do not introduce a new Event eligibility endpoint in 1M-B.

## 9. Project/Event Linkage And Unlinking Rules

Link/change/unlink should call `fund.projects.update`.

Expected payload:

```ts
{
  id: projectId,
  eventId: selectedEventIdOrNull,
  // plus existing form fields when saving the Project detail form
}
```

Recommended UI options:

- In create modal: Event selector is part of the create form.
- In detail page: Event linkage can be part of the main Project details form, or a small dedicated Event Linkage card that still calls `fund.projects.update`.

Preferred detail-page behaviour:

- keep Event linkage in the Overview tab;
- let the user change Event and save with the Project details form while DRAFT;
- use clear helper text rather than a separate destructive unlink button;
- if a separate `Remove Event Link` button is used, it must be labelled, non-icon-only and must not appear as a tiny destructive table action.

## 10. DRAFT-Only Linkage Change Rule

The UI must mirror the server rule:

- `DRAFT`: link/change/unlink enabled.
- `ACTIVE`, `PAUSED`, `CLOSED`, `COMPLETED`, `ARCHIVED`: linkage read-only.

Do not hide the current linkage on non-DRAFT Projects. Show it clearly and explain why it cannot be changed.

Suggested read-only text:

```text
Event linkage can only be changed while the Project is Draft.
```

If a stale UI tries to change linkage after status changes, surface the server `BAD_REQUEST` response clearly.

## 11. Standalone Project Behaviour

Standalone Projects remain first-class.

Create:

- Event selector may be left blank.
- No Event date constraints apply.

Detail:

- display `Standalone Project` when no Event is linked.
- no inherited Event close date exists.

Activation:

- standalone Project activation still requires Project `closesAt`;
- Project `closesAt` must be after `opensAt` when both are present;
- no Event latest-close-date boundary applies.

## 12. Event-Linked Project Date Helper Text

When an Event is selected or linked, the UI should explain:

- Event `opensAt` is the earliest permitted linked Project open date where set.
- Event `closesAt` is the latest permissible effective linked Project close date where set.
- Project close date may be earlier than Event close date.
- If Project close date is blank, Event close date may act as the effective inherited close date.
- Event close date is not copied into the Project.
- Store-specific close dates remain future Store planning.

Suggested wording:

```text
This Project is linked to {Event name}.
Linked Projects may close earlier than the Event, but not later.
If this Project has no close date, the Event close date can act as its effective close date.
The Event close date is not copied into the Project.
Store-specific close dates are a later Store planning concern.
```

## 13. Effective Close-Date Display

Update Project Overview and activation readiness wording to distinguish Project close date from effective close date.

Display rules:

- if Project `closesAt` exists, show it as Project close date and effective close date;
- if Project `closesAt` is blank and linked Event `closesAt` exists, show Event `closesAt` as effective close date with an `Inherited from Event` label;
- if both Project and linked Event close dates are blank, show a warning that there is no effective close date;
- for standalone Projects, keep the existing missing Project close-date blocker.

Recommended panel wording:

- `Project close date`
- `Effective close date`
- `Inherited from Event`
- `No effective close date`

Do not imply inherited Event dates are persisted into `FundProject.closesAt`.

## 14. Activation Readiness Interaction

The activation readiness panel should refresh after Event linkage changes.

Readiness logic should reflect current API rules:

- standalone Project requires Project `closesAt`;
- Event-linked Project may satisfy close-date readiness through Project `closesAt` or linked Event `closesAt`;
- at least one active Project Product is still required;
- archived active Products remain blockers;
- inactive/missing Workflow Classes remain blockers;
- server activation remains authoritative.

If the UI performs client-side readiness checks, keep them advisory and simple.

Activation errors from `fund.projects.activate` must still be shown clearly because the server is the source of truth.

## 15. Date Validation UX

Mirror key server date validations client-side where practical.

For standalone Projects:

- Project `closesAt` must be after Project `opensAt` when both are present;
- Project activation requires Project `closesAt`;
- existing production deadline validation remains.

For Event-linked Projects:

- if Event `opensAt` is set, Project `opensAt` must not be before it;
- if Event `closesAt` is set and Project `closesAt` is set, Project `closesAt` must not be after it;
- if Event `productionDeadline` is set and Project `productionDeadline` is set, Project `productionDeadline` must not be after it;
- Project may close earlier than Event;
- Project production deadline may be earlier than Event production deadline.

Do not:

- silently overwrite Project dates when Event changes;
- automatically copy Event dates into Project fields;
- introduce Store close-date semantics.

If a newly selected Event conflicts with existing Project dates, the UI should show field-level helper/error text and still rely on the server to reject invalid saves.

## 16. Query Invalidation Strategy

Project create with Event:

- invalidate `fund.projects.list`;
- navigate to Project detail;
- invalidate `fund.events.list` if linked Project counts may be shown.

Project detail Event link/change/unlink:

- invalidate `fund.projects.get({ id })`;
- invalidate `fund.projects.list`;
- invalidate `fund.events.list`;
- invalidate `fund.events.get({ id: previousEventId })` and `fund.events.get({ id: newEventId })` if either id is known and detail pages may be open/stale.

Activation readiness:

- refresh through Project detail invalidation after Event linkage changes;
- no separate readiness endpoint should be introduced.

## 17. Error Handling And Notifications

Map tRPC errors to clear notifications:

- `BAD_REQUEST`: invalid Event status, invalid Project status for linkage change, Event date constraint failure or missing effective close date.
- `NOT_FOUND`: stale or missing Event/Project.
- `FORBIDDEN`: permission or FUND feature access failure.
- `CONFLICT`: duplicate/conflict condition from existing Project services.
- generic: clear fallback message.

Recommended titles:

- `Project not saved`
- `Event link not changed`
- `Event no longer available`
- `Date constraints not met`
- `Permission denied`

Keep forms open and preserve unsaved state on mutation errors.

## 18. Loading, Empty And Error States

Project create modal:

- show Event selector loading state while Events load;
- allow standalone Project creation if Event list fails, but show a warning that Events could not be loaded;
- show `No eligible Events available` when no DRAFT/ACTIVE Events exist.

Project detail:

- show linked Event summary loading state if extra Event detail is loaded;
- show standalone state when no Event is linked;
- show read-only historical Event state when linked Event is CLOSED or ARCHIVED;
- show no effective close-date warning when both Project and linked Event close dates are blank;
- show Event/date validation errors without navigating away.

## 19. Manual Test Checklist

Project create:

- Create standalone Project with no Event.
- Create Project linked to a DRAFT Event.
- Create Project linked to an ACTIVE Event.
- Confirm CLOSED Events are not eligible for new selection.
- Confirm ARCHIVED Events are not eligible for new selection.
- Force stale/invalid Event selection if practical and confirm server rejection is clear.
- Confirm Event helper text appears when Event is selected.
- Confirm Project close date can be earlier than Event close date.
- Confirm Project close date cannot be later than Event close date.
- Confirm Project can be created with blank Project close date when linked Event has `closesAt`.

Project detail/edit:

- Existing linked Event displays in Project Overview.
- Standalone Project displays standalone status.
- DRAFT Project can link to an Event.
- DRAFT Project can change Event.
- DRAFT Project can unlink Event.
- Non-DRAFT Project shows Event linkage read-only.
- Closed/archived linked Event remains visible historically.
- General Save does not mutate status.
- Event linkage changes use `fund.projects.update`.
- Event date helper text remains accurate after change/unlink.

Activation/readiness:

- Standalone Project activation still requires Project `closesAt`.
- Linked Project with blank Project `closesAt` and Event `closesAt` passes close-date readiness.
- Linked Project with both Project `closesAt` and Event `closesAt` blank shows missing effective close-date blocker.
- Readiness refreshes after Event linkage changes.
- Server activation errors are surfaced clearly.

Regression:

- `/app/fund/projects` still loads.
- Project child page still loads.
- Project Products tab still works.
- `/app/fund/events` still loads.
- Event child page still loads.
- Products/Catalogues admin still works.
- No C2 organiser dashboard, organiser invitation, Project Request/onboarding or Project ownership/access change is introduced.

## 20. Deliberately Out Of Scope

1M-B must not implement:

- Event schema changes;
- Event API/service changes;
- Project API/service changes unless a reviewed blocker is discovered;
- migrations;
- `db:push`;
- seed/reset commands;
- Event child linked-Project mutation controls;
- C2 dashboards;
- organiser invitations;
- Project Request/onboarding;
- Project ownership/access changes;
- Stores;
- Orders;
- commerce;
- payments;
- commissions;
- dashboards beyond existing admin surfaces;
- production batching;
- lifecycle engine;
- SeasonPro integration;
- marketplace exposure;
- media/asset workflows;
- AI workflows.

## 21. Risks And Recommendations

Risks:

- Event date inheritance can be misread as copied Project dates if wording is not clear.
- The Project create modal may become dense if Event helper text is too long.
- Project readiness currently has simple client-side logic; it must be updated carefully without trying to duplicate every server rule.
- Current linked CLOSED/ARCHIVED Events may not appear in a DRAFT/ACTIVE Event list, so implementation must preserve historical display from Project detail or fetch detail only when needed.

Recommendations:

- Keep Project create helper text short and reserve detailed explanation for the Project Overview Event linkage section.
- Prefer one reusable `ProjectEventSelector`/`ProjectEventLinkageCard` component if it can serve create and detail without becoming awkward.
- Keep readiness checks advisory and server-backed.
- Complete a focused review/manual testing slice after implementation before moving to Event-linked workflows or C2 surfaces.

## 22. Recommended Implementation Prompt For 1M-B

```text
Proceed with FUND Phase 1 Slice 1M-B implementation: Project Event selector and linkage UI.

Work on:
feature/fund-phase-1-products-catalogues

Use:
- isodocs/docs/modules/fund/Planning/2026-06-24-fund-phase-1-slice-1m-b-project-event-selector-ui-proposal.md
- isodocs/docs/modules/fund/implementation/2026-06-24-phase-1-slice-1m-a-fund-event-admin-ui-confirmation.md
- isodocs/docs/modules/fund/implementation/2026-06-24-phase-1-slice-1l-b-fund-event-api-services-confirmation.md
- isodocs/docs/modules/fund/implementation/2026-06-24-phase-1-slice-1l-c-fund-event-api-manual-review-confirmation.md
- current Project Admin UI implementation
- current Event Admin UI implementation

Implement only C1/admin Project Event selector and linkage UI.

Use existing endpoints only:
- fund.projects.get
- fund.projects.create
- fund.projects.update
- fund.projects.activate
- fund.events.list
- fund.events.get only if needed for detail/helper display

Do not edit Prisma schema.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.
Do not create or modify routers, services, Zod schemas or tRPC endpoints.
Do not create Stores, Orders, commerce, payments, commissions, production batching, SeasonPro integration, marketplace exposure, media/asset workflows, lifecycle engine, organiser identity/account linking, Project Request/onboarding flows, C2 organiser dashboards, organiser invitations, Project ownership/access changes or AI workflows.

Implementation requirements:
- add optional Event selector to Project create;
- list only eligible DRAFT/ACTIVE Events for new linkage;
- only show Events owned by the same C1 tenant as the Project;
- ensure C2/project organisers cannot see or link to Events from other tenants;
- rely on server-side tenant scoping as authoritative if a stale or malicious eventId is submitted;
- allow standalone Project creation with no Event;
- add Event linkage section to Project Overview;
- permit link/change/unlink only while Project is DRAFT;
- show non-DRAFT Project Event linkage read-only;
- keep CLOSED/ARCHIVED linked Events visible historically;
- show Event date constraint helper text;
- show effective close date in Project Overview/readiness, including inherited Event close date where Project closesAt is blank;
- show warning when both Project and linked Event close dates are blank;
- do not copy Event dates into Project date fields;
- do not silently overwrite Project dates when Event changes;
- refresh Project detail/list and Event list/detail where linkage counts may change;
- preserve form state on mutation errors;
- surface BAD_REQUEST, NOT_FOUND, FORBIDDEN, CONFLICT and generic errors clearly.

Run:
- npm run type-check
- npm run verify

Create confirmation document:
isodocs/docs/modules/fund/implementation/2026-06-24-phase-1-slice-1m-b-project-event-selector-ui-confirmation.md

The confirmation should include implementation summary, files changed, endpoints used, create flow, detail linkage behaviour, DRAFT-only rule, effective close-date display, readiness changes, query invalidation, out-of-scope confirmation, checks run and recommended next slice.
```

## 23. Recommended Follow-Up Review/Testing Slice

Recommended next slice after implementation:

```text
Phase 1 Slice 1M-C - Project/Event Linkage UI Review and Manual Testing
```

The review should cover:

- Project create with and without Events;
- DRAFT/ACTIVE Event eligibility;
- CLOSED/ARCHIVED Event exclusion for new linkage;
- DRAFT-only linkage changes;
- effective close-date display;
- readiness refresh;
- server error handling;
- Project and Event page regressions;
- confirmation that no C2 organiser dashboard, organiser invitations, Project Request/onboarding or ownership/access changes were introduced.
