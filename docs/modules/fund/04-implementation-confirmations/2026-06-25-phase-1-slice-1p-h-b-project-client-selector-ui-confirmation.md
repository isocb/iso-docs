# FUND Phase 1 Slice 1P-H-B - Project Client Selector UI Confirmation

Date: 2026-06-25

Status: Implemented / UI only

## 1. Slice Name

FUND Phase 1 Slice 1P-H-B - Project Client Selector UI

## 2. Implementation Summary

Implemented the C1/admin Project Client selector and linked Client display UI on top of the 1P-H-A Project Client linkage API/services.

The UI now allows C1 admins to:

- create a Project with no Client;
- create a Project linked to an active same-tenant Client;
- view a linked Client on Project detail;
- link, change or unlink Client while the Project is `DRAFT`;
- see Client linkage as read-only on non-DRAFT Projects;
- navigate from linked Client display to the Client detail page.

Client linkage remains separate from organiser contact snapshots. Selecting or changing a Client does not copy Client contact data into Project organiser fields.

## 3. Files / Components Changed

App repo:

- `src/modules/fund/components/projects/ProjectClientSelector.tsx`
- `src/modules/fund/components/projects/ProjectCreateModal.tsx`
- `src/modules/fund/components/projects/ProjectDetailPage.tsx`

This slice also depends on the 1P-H-A API/service changes already present in:

- `src/modules/fund/lib/validation/projects.ts`
- `src/modules/fund/services/projects.service.ts`

## 4. Endpoints Used

The UI uses only the accepted C1 endpoints:

- `fund.projects.create`
- `fund.projects.update`
- `fund.projects.get`
- `fund.projects.list`
- `fund.clients.list`

The implementation also invalidates existing Client queries after link/change/unlink where available:

- `fund.clients.list`
- `fund.clients.get`

No C2 organiser, Client user/invitation, Project Intake, Store, Order or Commerce endpoints are used.

## 5. Project Create Client Selector Behaviour

`ProjectCreateModal` now includes an optional Client selector.

Behaviour:

- Project creation with no Client remains allowed.
- Project creation linked to an active Client is allowed.
- Client and Event selection are independent.
- Event is not required when Client is selected.
- Client is not required when Event is selected.
- Selector helper text explains that only active Clients owned by the C1 tenant are available.
- Selector data comes from `fund.clients.list` filtered to active/current Clients.
- Archived and inactive Clients are not offered for new selection.
- Client is not inferred from organiser name/email/phone.
- Client contact fields are not copied into organiser snapshot fields.

After successful create, Project list is invalidated. Client list is also invalidated when a Client was linked so Client Project counts can refresh.

## 6. Project Detail Client Display / Edit Behaviour

`ProjectDetailPage` now includes a Client Linkage section in the Overview form.

Behaviour:

- Linked Client name, code, type and status are shown when present.
- The linked Client name navigates to `/app/fund/clients/[id]`.
- Projects without a Client show a clear standalone state.
- DRAFT Projects may link, change or unlink Client through the existing Project detail save flow.
- Non-DRAFT Projects show Client linkage as read-only.
- The UI explains that Client linkage does not copy Client contact fields into Project organiser fields.

After successful save, the UI invalidates:

- `fund.projects.get({ id })`
- `fund.projects.list`
- `fund.clients.list`
- linked old/new `fund.clients.get({ id })` where applicable
- existing Event query invalidations from the Project/Event linkage flow

## 7. Project List Client Display

Project list Client display was deferred.

Reason:

- the current Project table already carries Project number, name, status, lifecycle, close date, product count, organiser and updated date;
- adding Client as another visible column risks crowding the operational table;
- Project detail now provides the authoritative Client display and edit surface;
- a later table-density review can decide whether Client should replace or sit alongside organiser/contact display.

No row action buttons were added.

## 8. DRAFT / Non-DRAFT UI Behaviour

The UI mirrors the 1P-H-A service rule:

```text
Client link/change/unlink is editable only while Project is DRAFT.
```

Non-DRAFT Projects keep the Client selector disabled and show read-only advisory text.

The server remains authoritative and rejects stale or malicious non-DRAFT Client linkage changes.

## 9. Archived / Inactive Client UI Behaviour

New selector options include active Clients only.

If an existing linked Client is archived or inactive, it remains visible as historical Project context with a status warning. The current historical Client can be displayed but is not offered as an eligible new linkage option.

Archived/inactive Client rejection remains enforced by the 1P-H-A service validation.

## 10. Navigation To Client Detail

Linked Client display uses a direct C1 admin navigation link:

```text
/app/fund/clients/[id]
```

No C2 context switching, impersonation or Client user flow is introduced.

## 11. Explicit Out Of Scope

Not implemented:

- Project list Client column;
- Client users;
- Client roles;
- invitations;
- notification sending;
- Project Intake / Project Request forms;
- public embedded forms;
- C2 dashboard expansion;
- C2 Project creation;
- Store;
- Orders;
- Commerce Core;
- Sales/Reporting;
- Communications;
- key-date automation;
- SeasonPro Club mapping implementation;
- automatic Client creation from organiser snapshots;
- automatic Project creation from Client creation;
- schema changes;
- migrations.

## 12. db:push / Seed / Reset Confirmation

`db:push` was not run.

Seed commands were not run.

Reset commands were not run.

No schema changes or migrations were introduced in this UI slice.

## 13. Checks Run

App repo:

- `npm run type-check` - passed.
- `npm run verify` - passed after rerunning with elevated permissions because the sandbox blocked the `tsx` IPC pipe.
- `git diff --check` - passed.

## 14. Risks / Follow-Ups

- Authenticated browser testing should confirm the selector loads active Clients, linked Client display navigates correctly and DRAFT-only editing behaves as expected.
- Project list Client display remains a deliberate follow-up for a table-density/design pass.
- A later Project Client linkage review should test stale archived/inactive Client ids and non-DRAFT mutation attempts through the server.

## 15. Recommended Next Slice

Recommended next slice:

```text
1P-H-C - Project Client Linkage UI Review and Authenticated Smoke Testing
```

After the review, update the roadmap/control document and decide whether to align the Project Client linkage batch to dev/staging.
