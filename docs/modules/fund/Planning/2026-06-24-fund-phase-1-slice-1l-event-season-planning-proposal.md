# FUND Phase 1 Slice 1L - Event / Season Planning Proposal

Date: 2026-06-24

Status: Planning only

Target branch:

```text
feature/fund-phase-1-products-catalogues
```

Assumption for this planning pass: Slice 1K Project Admin UI Review and Manual Testing has completed successfully, or any findings are small enough not to change the Event/Project architecture.

## 1. Slice Goal

Slice 1L plans the next structural FUND layer: optional tenant-owned Events that can group Projects and optionally constrain Project open, close and production dates.

The model remains:

```text
Tenant
  -> Products and Catalogues
  -> optional Events
  -> Projects
  -> selected Products
  -> lifecycle/status
  -> organiser/contact context
  -> operational deadlines
  -> future Store association
```

Projects remain the mandatory operational unit of work. Events organise and constrain Projects; they do not replace Projects.

## 2. Terminology Recommendation

Recommendation: use `FundEvent` as the Phase 1 internal model name.

User-facing Event names can be:

- `Christmas 2026`
- `Mother's Day 2027`
- `Father's Day 2027`
- `Leavers 2027`
- `Custom Fundraiser`

Terminology assessment:

| Term | Use | Phase 1 Recommendation |
| --- | --- | --- |
| Event | Customer-facing selling phase, e.g. Christmas, Mother's Day, Leavers | Primary model name: `FundEvent` |
| Season | Operational production/calendar grouping, possibly AMOW-specific | Treat as an Event category/label or future higher-level grouping |
| Campaign | Marketing/comms wording, less precise technically | Avoid as internal model for Phase 1 |
| Programme | Too broad for current scope | Do not use in Phase 1 |

Rationale:

- `Event` is understandable to tenants and customers.
- `Event` fits the existing functional specification language.
- `Event` can represent AMOW seasonal selling phases without implying all Projects must be seasonal.
- `Season` is useful vocabulary, but risks implying a calendar-wide production concept rather than a customer-facing selling window.

Phase 1 should not introduce both `FundEvent` and `FundSeason`. That would create unnecessary conceptual and schema complexity before the first Event/Project constraints are proven.

## 3. Event / Season Decision

For Phase 1:

- create a future `FundEvent` model;
- include an `eventType` or `category` field that can hold values such as `CHRISTMAS`, `MOTHERS_DAY`, `FATHERS_DAY`, `LEAVERS`, `CUSTOM` if approved during implementation planning;
- allow the Event `name` to be tenant-defined;
- treat "Season" as a possible user-facing label/category for some Events;
- defer any separate `FundSeason` model.

Possible future options for Season:

1. Synonym/label for certain Events.
2. Higher-level grouping above Events, for example `AMOW 2026/27 Production Season`.
3. Unnecessary if `FundEvent` plus category covers the operational need.

Recommendation: start with option 1 in Phase 1 and revisit options 2/3 only after Events are tested with real AMOW calendars.

## 4. Implementation Boundary

Slice 1L is planning only.

Do not implement:

- application code;
- Prisma schema;
- migrations;
- `db:push`;
- seed/reset commands;
- routers;
- services;
- Zod schemas;
- tRPC endpoints;
- UI;
- Stores;
- Orders;
- commerce;
- payments;
- commissions;
- dashboards;
- production batching;
- SeasonPro integration;
- marketplace exposure;
- media/asset workflows;
- lifecycle tables;
- lifecycle transition engine;
- organiser identity/account linking;
- Project Request/onboarding flows;
- AI workflows.

## 5. Relationship Between Events And Projects

A `FundProject` is the mandatory operational fundraising/production unit.

A `FundEvent` is an optional grouping and constraint container.

Relationship:

```text
FundEvent 1 -> many FundProjects
FundProject 0 or 1 -> FundEvent
```

Rules:

- Projects must be able to exist without an Event.
- Event linkage must be optional.
- Event linkage should constrain or guide Project dates only when present.
- Event linkage should not replace Project lifecycle/status.
- Event linkage should not create Stores, Orders, payments, commissions, organiser users or Project Request flows.

## 6. Standalone Projects Versus Event-Linked Projects

Standalone Project:

- no `eventId`;
- Project open/close/production dates are governed only by normal Project validation;
- Project can still select Products and move through Project status/lifecycle;
- useful for bespoke fundraisers, one-off projects and non-seasonal work.

Event-linked Project:

- has optional `eventId`;
- belongs to the same tenant as the Event;
- Project dates must fit within Event constraints where those Event dates are set;
- may inherit default date helper text or suggested deadlines from Event;
- still owns its own Project status, lifecycle state, Products and future Store association.

## 7. Event Date Fields

Potential Event date fields:

- `opensAt`
- `closesAt`
- `productionDeadline`

Recommended semantics:

- `opensAt`: earliest customer-facing selling/open date for linked Projects.
- `closesAt`: latest permissible effective close date for linked Projects.
- `productionDeadline`: campaign-level production deadline or latest production deadline guidance.

`FundEvent.closesAt` is not a forced persisted Project close date. It is the upper boundary for linked Projects and may be used as an inherited/effective close date where a linked Project has no own `closesAt`.

Nullability:

- allow date fields to be nullable while Event is `DRAFT`;
- require at least `closesAt` before Event activation if activation is implemented;
- production deadline may remain optional until production workflow is more mature.

Date validation:

- Event `opensAt` must be before Event `closesAt` when both exist.
- Event `productionDeadline` must not be before Event `closesAt` when both exist, unless AMOW operational reality proves otherwise.

## 8. Project Date Constraints When Linked To Event

When a Project is linked to an Event:

- Project `opensAt` must not be before Event `opensAt` when Event `opensAt` exists.
- Project `closesAt` must not be after Event `closesAt` when both exist.
- Project `productionDeadline` should not be after Event `productionDeadline` when Event `productionDeadline` exists.
- Project may close earlier than the Event closes.
- Project may leave `closesAt` blank and use Event `closesAt` as the effective close date for display, readiness and future Store generation.
- Project may have a production deadline earlier than the Event production deadline.

Constraint examples:

| Event Field | Project Rule |
| --- | --- |
| `event.opensAt` | `project.opensAt >= event.opensAt` |
| `event.closesAt` | `project.closesAt <= event.closesAt`, when Project close date is set |
| `event.productionDeadline` | `project.productionDeadline <= event.productionDeadline` |

Effective close-date behaviour:

- Standalone Projects use their own Project dates and normal Project validation.
- Linked Projects may set their own `closesAt` earlier than Event `closesAt`.
- Linked Projects must not set `closesAt` later than Event `closesAt`.
- If a linked Project has no `closesAt`, the UI/API may treat Event `closesAt` as the effective inherited close date for display, activation readiness and future Store generation.
- This inherited/effective behaviour does not require copying Event `closesAt` into `FundProject.closesAt`.
- The UI should clearly show when a Project is using the Event close date.

Open question: if Project `opensAt` is null and Event `opensAt` exists, should Project implicitly inherit Event open date for display later, or should null remain "not set"? Recommendation for Phase 1: do not create persisted inheritance in schema; show defaults/helper text in UI later.

Do not introduce Store close-date semantics in 1L-A. Store-specific close dates remain future Store planning.

## 9. Optional Project Linkage

Future schema should add an optional `eventId` to `FundProject`.

Recommended:

```text
FundProject.eventId String? @map("event_id")
```

The relation must be tenant-safe:

- Event and Project must have the same `organizationId`;
- use composite same-tenant foreign keys where consistent with existing FUND patterns;
- do not accept `organizationId` from client input.

Projects should be movable between Events only while `DRAFT` in the initial implementation, unless a stronger operational rule is approved.

## 10. Event Lifecycle / Status Concepts

Potential status values:

- `DRAFT`
- `ACTIVE`
- `CLOSED`
- `ARCHIVED`

Recommendation: use these four for Phase 1 planning.

`COMPLETED` is probably not needed for Events in Phase 1.

Reason:

- Project has operational completion.
- Event is a grouping/constraint container.
- `CLOSED` is enough to indicate the Event is no longer accepting new/active selling work.
- Production completion will likely happen at Project, Store/Order, batch or dashboard layers later.

Status semantics:

| Status | Meaning |
| --- | --- |
| `DRAFT` | Event being prepared; Projects may be linked if allowed by policy |
| `ACTIVE` | Event available for Project linkage and active date guidance |
| `CLOSED` | Event is no longer accepting new Project linkage/activation, but linked Projects remain visible |
| `ARCHIVED` | Event hidden from default lists; linked Projects remain visible historically |

## 11. Tenant Ownership And Scoping

`FundEvent` must be tenant-owned:

- required `organizationId`;
- relation to `Organization`;
- tenant-unique `code`;
- tenant-unique `slug`;
- all reads/writes scoped to actor `organizationId`;
- no client input accepts `organizationId`.

Project/Event linkage must validate:

- Project belongs to actor tenant;
- Event belongs to actor tenant;
- archived Events cannot be newly linked;
- closed Events cannot be newly linked unless explicitly approved later;
- existing linked Projects remain visible if the Event is closed or archived.

## 12. Effect On Project Creation / Editing

Future Project create/edit UI should allow Event selection only after Event schema/API exists.

Project creation:

- Event selection optional;
- standalone Projects remain valid;
- selecting Event should show date guidance;
- if Event date bounds exist, Project date fields should show helper text.
- if Project `closesAt` is blank and Event `closesAt` exists, the UI should clearly indicate that the Event close date is being used as the effective close date.

Project editing:

- Event linkage changes should probably be allowed only while Project is `DRAFT` in the first implementation;
- Project date edits must validate against linked Event constraints;
- if an Event's dates change and linked Projects become invalid, surface warnings rather than silently changing Project dates.
- do not force-copy Event close date into Project close date.

Do not automatically cascade Project date changes in Phase 1 unless explicitly approved. It is safer to show warnings and require intentional correction.

## 13. Effect On Project Activation Readiness

When Event linkage exists, activation readiness should include Event checks:

- linked Event is not archived;
- linked Event is not closed if policy blocks activation after Event close;
- Project open date is not before Event open date;
- Project close date is not after Event close date when Project close date is set;
- Project has either its own close date or an effective inherited close date from the linked Event;
- Project production deadline is not after Event production deadline where both exist.

Activation should remain a Project status action. Event status should not replace Project activation.

Open question: should a Project linked to an Event be activatable after Event `CLOSED` if the Project was already prepared and dates are valid? Recommendation: initially block activation if Event is `CLOSED` or `ARCHIVED`, unless business rules require late activation.

## 14. Future Support For Stores, Orders, Production And Communications

Events may later support:

- default Product/Catalogue selections for Projects;
- campaign-wide close dates;
- campaign-wide production deadlines;
- Store generation defaults;
- communication schedules;
- commission rule defaults;
- production batching/grouping;
- reporting by seasonal campaign.

These are later layers. In Phase 1 Event planning, do not create Store, Order, payment, commission, batch or communication records.

## 15. Suggested Future Schema Shape

Planning-only sketch:

```prisma
enum FundEventStatus {
  DRAFT
  ACTIVE
  CLOSED
  ARCHIVED

  @@schema("fund")
}

model FundEvent {
  id             String @id @default(uuid())
  organizationId String @map("organization_id")

  code        String
  name        String
  slug        String
  eventType   String? @map("event_type")
  description String? @db.Text

  status FundEventStatus @default(DRAFT)

  opensAt            DateTime? @map("opens_at")
  closesAt           DateTime? @map("closes_at")
  productionDeadline DateTime? @map("production_deadline")

  internalNotes String? @map("internal_notes") @db.Text
  metadata      Json    @default("{}")

  archivedAt     DateTime? @map("archived_at")
  archivedById   String?   @map("archived_by_id")
  archivedReason String?   @map("archived_reason") @db.Text

  createdById String?  @map("created_by_id")
  updatedById String?  @map("updated_by_id")
  createdAt   DateTime @default(now()) @map("created_at")
  updatedAt   DateTime @updatedAt @map("updated_at")

  organization Organization @relation(fields: [organizationId], references: [id], onDelete: Cascade)
  projects     FundProject[]

  @@unique([organizationId, id])
  @@unique([organizationId, code])
  @@unique([organizationId, slug])
  @@index([organizationId, status])
  @@index([organizationId, closesAt])
  @@index([archivedAt])
  @@map("fund_events")
  @@schema("fund")
}
```

Future `FundProject` addition:

```prisma
eventId String? @map("event_id")
event   FundEvent? @relation(fields: [organizationId, eventId], references: [organizationId, id], onDelete: Restrict)
```

This is a planning sketch only. Do not implement until the schema slice is explicitly approved.

## 16. Suggested Future API / Service Surface

Potential Event endpoints:

- `fund.events.list`
- `fund.events.get`
- `fund.events.create`
- `fund.events.update`
- `fund.events.activate`
- `fund.events.close`
- `fund.events.archive`
- `fund.events.restore`

Potential Project endpoint/service changes:

- Project create accepts optional `eventId`;
- Project update accepts optional `eventId` while Project is `DRAFT`;
- Project date validation includes linked Event constraints;
- Project activation readiness includes linked Event constraints.

Error handling:

- `CONFLICT` for tenant-unique `code`/`slug`;
- `BAD_REQUEST` for invalid Event status, invalid date constraints or invalid Project/Event linkage;
- `NOT_FOUND` for missing tenant-scoped Event;
- `FORBIDDEN` for feature/permission failure.

Audit events to consider:

- `FUND_EVENT_CREATED`
- `FUND_EVENT_UPDATED`
- `FUND_EVENT_ACTIVATED`
- `FUND_EVENT_CLOSED`
- `FUND_EVENT_ARCHIVED`
- `FUND_EVENT_RESTORED`
- `FUND_PROJECT_EVENT_LINKED`
- `FUND_PROJECT_EVENT_UNLINKED`
- `FUND_PROJECT_EVENT_CHANGED`
- `FUND_PROJECT_EVENT_DATE_CONSTRAINT_FAILED`

## 17. Suggested Future Admin UI Surface

Recommended route:

```text
/app/fund/events
/app/fund/events/[id]
```

Use a child page for Event detail rather than a large modal.

Reason:

- Event may list linked Projects;
- Event will likely gain date constraint panels, default Catalogue/Product selections, communications and production grouping later;
- Event detail needs to be bookmarkable.

Event list should include:

- fuzzy search;
- status filter;
- sort selector/direction;
- archived hidden by default;
- columns for code, name, status, open date, close date, production deadline, linked Project count, updated.

Event detail should include:

- Overview/edit details;
- date constraints panel;
- read-only linked Projects list in the first Event UI slice;
- later defaults for Catalogues/Products, communications or production.

Project UI changes later:

- Project create/edit can select optional Event;
- Project date fields show Event constraint helper text;
- Project list can gain Event filter;
- activation-readiness panel can show Event-linked blockers.

## 18. Migration / Testing Considerations

Migration planning:

- add `FundEventStatus`;
- add `FundEvent`;
- add optional `eventId` to `FundProject`;
- backfill existing Projects with `eventId = null`;
- keep existing standalone Projects valid;
- create indexes for tenant/status/date lookups.

Testing:

- existing Projects remain visible after migration;
- standalone Project create/edit still works;
- Event create/edit validates dates;
- Event-linked Project cannot violate Event date constraints;
- Project can close earlier than Event;
- Project cannot close after Event;
- archived Event remains visible from linked Project context;
- archived Event cannot be newly linked;
- tenant A cannot see or link tenant B Events.

## 19. Risks And Open Questions

### Risk: Event Becomes Too Operational

If Event starts absorbing lifecycle/status responsibilities, it will compete with Project. Mitigation: keep Project as the operational unit; Event is grouping/constraint only.

### Risk: Season Terminology Confusion

AMOW may talk naturally in Seasons. Mitigation: use Event internally for Phase 1 and allow category/name labels such as Christmas, Mother's Day or Leavers.

### Risk: Date Cascade Surprises

Changing Event dates could make linked Projects invalid. Mitigation: show warnings and require intentional Project updates rather than silently changing Project dates.

### Risk: Store/Order Drift

Event could tempt early Store/Order generation. Mitigation: do not add Store/Order work in Event schema/API/UI slices.

Open questions:

- Should Event `eventType` be enum-backed or free-text/category string?
- Should Project/Event linkage be editable only while Project is `DRAFT`?
- Should Event activation require `closesAt`?
- Should Event `CLOSED` block Project activation or only new Project linkage?
- Should Event production deadline be mandatory for AMOW Events but optional generally?
- Should Event date changes produce warnings only, or a formal invalid-linked-Project state?
- Should "Season" later become a parent grouping above Events for AMOW production calendars?

## 20. Recommended Next Implementation Slice

Recommended next implementation slice:

```text
Phase 1 Slice 1L-A - FundEvent Schema Only
```

Scope:

- `FundEventStatus` enum;
- `FundEvent` model;
- optional `eventId` relation on `FundProject`;
- tenant-safe relation/indexes;
- migration;
- implementation confirmation document.

Defer:

- routers/services;
- Project Event validation in API;
- Event UI;
- Store/Order/commerce layers.

## 21. Recommended Implementation Prompt For 1L-A

```text
Proceed with FUND Phase 1 Slice 1L-A implementation: FundEvent schema only.

Work on:
feature/fund-phase-1-products-catalogues

Before editing, read:
- isodocs/docs/modules/fund/Planning/2026-06-24-fund-phase-1-slice-1l-event-season-planning-proposal.md
- active FUND docs
- Slice 1H, 1I, 1J-A, 1J-B and 1K documents
- current Prisma schema conventions

Implement only:
- FundEventStatus enum;
- FundEvent model;
- optional Event relation on FundProject;
- required Organization relation;
- required tenant-safe indexes and uniqueness constraints;
- migration;
- implementation confirmation document.

Use FundEvent as the Phase 1 model name.
Do not create FundSeason in this slice.
Keep Project.eventId optional.
Keep standalone Projects valid.
Do not create Stores, Orders, commerce, payments, commissions, dashboards, production batching, SeasonPro integration, marketplace exposure, media/asset workflows, lifecycle tables, lifecycle transition engine, organiser identity/account linking, Project Request/onboarding flows or AI workflows.

Do not run db:push.
Do not run seed/reset commands.

Run:
- npx prisma validate
- npm run db:generate
- npm run type-check
- npm run verify

Create confirmation document:
isodocs/docs/modules/fund/implementation/2026-06-24-phase-1-slice-1l-a-fund-event-schema-confirmation.md
```
