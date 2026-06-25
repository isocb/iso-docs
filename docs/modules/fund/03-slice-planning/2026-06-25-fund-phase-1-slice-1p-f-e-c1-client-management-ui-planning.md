# FUND Phase 1 Slice 1P-F-E - C1 Client Management UI Planning

Date: 2026-06-25

Status: Planning only

## 1. Slice Goal

Plan the C1 Client Management UI using the implemented `fund.clients.*` procedures.

The immediate AMOW founding-tenant priority is the C1 organisational dashboard:

- Clients;
- Products;
- Catalogues;
- Events;
- Projects;
- Project/Event linkage;
- Project Product membership.

The Client UI should make the operating model clear:

```text
AMOW manages Clients.
Clients are fundraising organisations such as schools, clubs or PTAs.
Projects belong to Clients.
Future Store, Orders, Sales, Communications and Reporting sit naturally under the Client and Project structure.
```

## 2. Implementation Boundary

Plan UI only.

Allowed in the implementation slice:

- C1 Client list route;
- C1 Client detail route;
- Client create/edit/archive/restore UI;
- linked Project summaries on Client detail;
- loading, empty and error states;
- breadcrumbs and navigation;
- dashboard navigation card/link if consistent with current FUND admin home.

Not allowed:

- Project Client selector/linkage;
- Project create/edit changes;
- Client users;
- Client roles;
- invitations;
- C2 dashboard expansion;
- C2 mutations;
- Project Request/onboarding;
- Store;
- Orders;
- Commerce Core;
- Sales/Reporting;
- Communications;
- key-date automation;
- SeasonPro Club mapping;
- reusable core Client/account model;
- schema changes;
- migrations.

## 3. Routes

Recommended routes:

```text
/app/fund/clients
/app/fund/clients/[id]
```

Route purpose:

- `/app/fund/clients`: C1 Client list and create entry point.
- `/app/fund/clients/[id]`: C1 Client detail/edit/linked Project summary surface.

Client is an operational parent entity, so the detail route should be a child management page, not only a modal.

## 4. Data Dependencies

Use only:

```text
fund.clients.list
fund.clients.get
fund.clients.create
fund.clients.update
fund.clients.archive
fund.clients.restore
```

Do not use:

- C2 organiser endpoints;
- Project mutation endpoints;
- future Client user endpoints;
- future invitation endpoints;
- Store/Order/Commerce endpoints.

Recommended query invalidation:

- after create: invalidate `fund.clients.list`;
- after update: invalidate `fund.clients.get({ id })` and `fund.clients.list`;
- after archive/restore: invalidate `fund.clients.get({ id })` and `fund.clients.list`.

Project list invalidation is not required because this slice does not mutate Projects.

## 5. Recommended Components

Suggested component structure:

```text
src/modules/fund/components/clients/ClientTable.tsx
src/modules/fund/components/clients/ClientCreateModal.tsx
src/modules/fund/components/clients/ClientDetailPage.tsx
src/modules/fund/components/clients/ClientProfileForm.tsx
src/modules/fund/components/clients/ClientProjectsSummary.tsx
```

Route files should follow existing app route conventions:

```text
src/app/(app)/app/fund/clients/page.tsx
src/app/(app)/app/fund/clients/[id]/page.tsx
```

If the current FUND admin route wrappers already use a module shell, reuse that shell.

## 6. Client List Behaviour

The Client list should show:

- Client name;
- code;
- client type;
- status;
- primary contact;
- project count;
- updated date;
- archive state/filter.

Default behaviour:

- archived Clients hidden by default;
- fuzzy search available;
- status filter includes:
  - All current;
  - Active;
  - Inactive;
  - Archived;
- row click opens `/app/fund/clients/[id]`;
- no edit/delete/archive `ActionIcon` buttons in table rows.

Recommended sortable columns:

- code;
- name;
- client type;
- status;
- primary contact;
- project count;
- updated date.

Sorting should use the existing FUND `FundSortableHeader` pattern where practical.

Search should cover:

- code;
- name;
- slug;
- client type;
- primary contact name;
- primary contact email;
- description if present in list payload.

## 7. Client Detail Behaviour

The Client detail page should show:

- breadcrumb back to Clients;
- Client name/code/status header;
- Client profile;
- primary contact snapshot;
- status/archive information;
- linked Project summaries;
- internal notes for C1 admin;
- action area for save/archive/restore.

Recommended layout:

- Overview/Profile section;
- Projects section;
- Future sections omitted by default unless a subtle placeholder is useful for AMOW explanation.

If future sections are shown, they must be clearly non-functional and minimal:

- Users: deferred;
- Orders: deferred;
- Sales/Reporting: deferred;
- Communications: deferred.

Avoid creating tabs for future sections unless there is a strong presentation reason. Empty future tabs can make the product feel less complete.

## 8. Create Flow

Recommended create UI:

- `Create Client` button on `/app/fund/clients`;
- modal is acceptable for initial create because full Client management continues on the child detail page;
- after create, navigate to `/app/fund/clients/[id]` if the returned payload includes id;
- alternatively refresh list and show success notification if navigation pattern is awkward.

Create fields:

- code;
- name;
- slug;
- client type;
- description;
- primary contact name;
- primary contact email;
- primary contact phone;
- internal notes.

Metadata editing:

```text
Defer unless an existing safe JSON/object editing UI pattern is already available and clearly appropriate.
```

Do not create users or invitations.

## 9. Edit Flow

Edit should happen on the Client detail child page.

Editable fields:

- code;
- name;
- slug;
- client type;
- description;
- status between `ACTIVE` and `INACTIVE`;
- primary contact name;
- primary contact email;
- primary contact phone;
- internal notes.

Rules:

- general update must not set `ARCHIVED`;
- archive/restore are dedicated actions;
- archived Clients should show read-only profile fields with restore action;
- mutation errors should preserve form state;
- duplicate code/slug conflicts should surface clearly.

## 10. Archive / Restore UI

Archive:

- use existing destructive-action conventions;
- place in detail action area, not row action buttons;
- require confirmation;
- collect optional archive reason if a current archive-reason pattern exists;
- call `fund.clients.archive`;
- show API blocker clearly when linked Projects are `ACTIVE` or `PAUSED`.

Blocker copy should explain:

```text
Clients with active or paused Projects cannot be archived.
Close, complete, pause resolution or unlink Projects according to a future approved workflow before archiving.
```

Restore:

- visible for archived Clients;
- call `fund.clients.restore`;
- restore returns Client to `ACTIVE`;
- clear archive indicators after successful mutation.

No hard delete.

## 11. Linked Project Summary Behaviour

Client detail should display linked Project summaries returned by `fund.clients.get`.

Fields to show:

- project number;
- name;
- status;
- lifecycle state;
- Event context if available in payload or defer if not;
- open/close/production dates;
- updated date.

Because 1P-F-D currently returns `eventId` but not full Event summary, the first UI should either:

- display `eventId` only if genuinely useful, or
- omit Event display and document full Event summary as a follow-up.

Do not mutate Project Client linkage in this slice.

Do not call Project mutation endpoints.

Row click on a linked Project summary may navigate to `/app/fund/projects/[id]` if this is consistent with C1 admin navigation and does not mutate anything.

## 12. Navigation And Breadcrumbs

Add Clients to C1 FUND navigation where appropriate:

- FUND dashboard card/link;
- sidebar/module navigation if the existing FUND navigation structure includes Products, Projects and Events;
- breadcrumbs on list/detail pages.

Recommended breadcrumb examples:

```text
FUND > Clients
FUND > Clients > [Client Name]
```

The Client card/link on `/app/fund` should follow the current dashboard card standard:

- whole card clickable if dashboard cards use that pattern;
- muted operational styling;
- brand-primary or brand-secondary accent only;
- no decorative random colours;
- icon should be destination-specific and not reuse a generic Home icon.

## 13. UI Standard Compliance

Client UI must follow IsoStack/FUND UI standards:

- operational, muted, work-focused UI;
- semantic colour only for status/RAG/action meaning;
- no decorative colour use;
- no nested cards;
- no row edit/delete/archive icon buttons;
- row click opens detail;
- destructive/archive actions live in the detail/action area;
- fuzzy search on list;
- column-header sorting with active sort indicator;
- archived hidden by default;
- loading, empty and error states;
- text must not overflow controls on mobile/desktop;
- use existing icons from the app icon library.

## 14. Loading / Empty / Error States

List loading:

- table loading state consistent with Products/Projects/Events.

List empty:

- no Clients yet: show concise empty text and create button;
- no filter matches: show filter-specific empty copy.

Detail loading:

- use existing page loading/skeleton pattern if available.

Detail not found/error:

- show safe error state;
- offer return to Clients list;
- do not leak tenant/cross-tenant information.

Mutation errors:

- preserve form state;
- surface `CONFLICT` for duplicate code/slug;
- surface archive blocker for active/paused linked Projects;
- show generic fallback for unexpected errors.

## 15. C1 / C2 Boundary

This UI is C1 admin only.

It must not:

- use C2 organiser endpoints;
- introduce C2 dashboard expansion;
- introduce hat-swapping changes;
- create Client users;
- create organiser invitations;
- create Project Request/onboarding flows;
- imply C2 self-service Client management.

Client is the C2 organisation/account concept, but this slice is only the C1 admin management surface for that concept.

## 16. Non-Goals

Do not implement:

- Project Client selector/linkage;
- Project create/edit changes;
- Client users;
- Client roles;
- invitations;
- C2 dashboard expansion;
- C2 mutations;
- Project Request/onboarding;
- Store;
- Orders;
- Commerce Core;
- Sales/Reporting;
- Communications;
- key-date automation;
- SeasonPro Club mapping;
- reusable core Client/account model;
- schema changes;
- migrations.

## 17. Manual Test Checklist

Implementation review should verify:

- `/app/fund/clients` loads for C1 admin with FUND access.
- Client list calls `fund.clients.list`.
- Archived Clients are hidden by default.
- Archived filter/status displays archived Clients.
- Search finds Clients by name/code/slug/client type/contact.
- Column headers sort and reverse-sort.
- Row click opens `/app/fund/clients/[id]`.
- No row edit/delete/archive action buttons exist.
- Create Client succeeds and invalidates list.
- Duplicate code/slug conflict is clear.
- Client detail calls `fund.clients.get`.
- Client detail shows profile/contact/internal notes.
- Client detail shows linked Project summaries if present.
- Save updates profile/contact fields.
- Archived Client is read-only or update-blocked until restored.
- Archive uses confirmation and calls `fund.clients.archive`.
- Archive blocker for active/paused linked Projects is clear.
- Restore calls `fund.clients.restore`.
- No hard delete exists.
- No Project Client selector/linkage appears.
- No Client users/invitations/C2/Store/Orders/Commerce surfaces appear.
- Products, Projects and Events C1 pages still load.
- FUND dashboard navigation remains coherent.

## 18. Recommended Implementation Prompt

```text
Proceed with FUND Phase 1 Slice 1P-F-E implementation: C1 Client Management UI.

Work on:
feature/fund-phase-1-c2-project-access

Use:
- isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-f-e-c1-client-management-ui-planning.md
- isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-f-d-c1-client-management-api-services-confirmation.md
- current FUND UI conventions
- current Products/Projects/Events admin UI patterns
- current IsoStack table CRUD pattern

Implement C1 Client Management UI only.

Routes:
- /app/fund/clients
- /app/fund/clients/[id]

Use only:
- fund.clients.list
- fund.clients.get
- fund.clients.create
- fund.clients.update
- fund.clients.archive
- fund.clients.restore

Do not use:
- C2 organiser endpoints;
- Project mutation endpoints for Client linkage;
- future Client user/invitation endpoints.

Requirements:
- Client list with fuzzy search, status/archive filter and column-header sorting;
- row click opens Client detail;
- no row edit/delete/archive ActionIcon buttons;
- create Client flow;
- Client detail/profile edit flow;
- archive/restore actions in detail/action area;
- archive blocker from API surfaced clearly;
- linked Project summaries on detail if returned by fund.clients.get;
- loading, empty and error states;
- breadcrumbs and navigation;
- muted operational styling;
- semantic colour only for status/action meaning;
- C1 admin surface only.

Do not implement:
- Project Client selector/linkage;
- Project create/edit changes;
- Client users;
- Client roles;
- invitations;
- C2 dashboard expansion;
- C2 mutations;
- Project Request/onboarding;
- Store;
- Orders;
- Commerce Core;
- Sales/Reporting;
- Communications;
- key-date automation;
- SeasonPro Club mapping;
- reusable core Client/account model;
- schema changes;
- migrations.

Run:
- npm run type-check
- npm run verify
- git diff --check

Create implementation confirmation document:
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-f-e-c1-client-management-ui-confirmation.md

The confirmation should include:
- slice name and date;
- implementation summary;
- routes created;
- files/components changed;
- endpoints used;
- list behaviour;
- detail behaviour;
- create/edit/archive/restore behaviour;
- linked Project summary behaviour;
- UI standard compliance;
- explicit out-of-scope confirmation;
- checks run and results;
- risks/follow-ups;
- recommended next slice.
```

## 19. Planning Verdict

Verdict:

```text
Proceed to UI implementation after review.
```

Recommended implementation:

```text
1P-F-E - C1 Client Management UI.
```

Recommended next after UI:

```text
1P-F-E-R1 - C1 Client Management UI Review.
```
