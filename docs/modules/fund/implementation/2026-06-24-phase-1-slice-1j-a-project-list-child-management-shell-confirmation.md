# FUND Phase 1 Slice 1J-A - Project List And Child Management Shell Confirmation

## Date

2026-06-24

## Slice Name

Phase 1 Slice 1J-A - Project List and Child Management Shell.

## Implementation Summary

Implemented the first Project Admin UI slice for FUND.

This slice proves the Project navigation model and operational shell:

- Project list route;
- compact Project create flow;
- Project child management page;
- Overview/edit details;
- status transition actions;
- activation readiness panel;
- read-only Products summary placeholder.

Project Product membership mutation controls were deliberately not implemented. They remain deferred to Slice 1J-B.

## Files Changed

App repository:

- `src/app/(app)/app/fund/page.tsx`
- `src/app/(app)/app/fund/projects/page.tsx`
- `src/app/(app)/app/fund/projects/[id]/page.tsx`
- `src/core/config/module-navigation.ts`
- `src/modules/fund/components/projects/ProjectCreateModal.tsx`
- `src/modules/fund/components/projects/ProjectDetailPage.tsx`
- `src/modules/fund/components/projects/ProjectTable.tsx`
- `src/modules/fund/components/shared/FundStatusBadge.tsx`
- `src/modules/fund/components/shared/FundTableControls.tsx`

Documentation repository:

- `docs/modules/fund/Planning/2026-06-23-fund-phase-1-slice-1j-project-admin-ui-proposal.md`
- `docs/modules/fund/implementation/2026-06-24-phase-1-slice-1j-a-project-list-child-management-shell-confirmation.md`

## Routes Added

- `/app/fund/projects`
- `/app/fund/projects/[id]`

The FUND landing page now links to Projects and Products/Catalogues.

The FUND module navigation now includes:

- FUND;
- Projects;
- Products.

## Components Created

- `ProjectTable`
- `ProjectCreateModal`
- `ProjectDetailPage`

## tRPC Endpoints Used

Project list:

- `fund.projects.list`

Project create:

- `fund.projects.create`

Project detail:

- `fund.projects.get`

Project update:

- `fund.projects.update`

Status actions:

- `fund.projects.activate`
- `fund.projects.pause`
- `fund.projects.close`
- `fund.projects.complete`
- `fund.projects.archive`
- `fund.projects.restore`

No Project Product membership mutation endpoints are used in this slice.

## Project List Behaviour

The Project list at `/app/fund/projects` includes:

- fuzzy search;
- status filter;
- sort selector;
- sort direction toggle;
- Project Number ascending default sort;
- archived hidden by default through the `All current` filter.

Columns:

- Project Number;
- Name;
- Status;
- Lifecycle State;
- Close Date;
- Product Count;
- Organiser;
- Updated.

Row click opens `/app/fund/projects/[id]`.

No edit/delete `ActionIcon` buttons or edit/delete actions column were added.

## Project Create Flow

Create uses a compact modal from the Project list.

Fields:

- Project Number;
- Name;
- Slug;
- Close Date;
- Organiser Name;
- Organiser Email;
- Organiser Phone.

On successful create:

- Project list invalidates;
- modal closes;
- user is routed to `/app/fund/projects/[id]`.

The API creates Projects as `DRAFT` with lifecycle state `SETUP`.

## Project Child Page

The child page at `/app/fund/projects/[id]` includes:

- breadcrumb back to Projects;
- Project header;
- Status badge;
- Lifecycle State badge;
- Overview tab;
- Products tab.

The Overview tab includes:

- activation readiness panel;
- status actions;
- Project details form;
- date/deadline fields;
- organiser contact fields;
- description and internal notes.

The Products tab is read-only in 1J-A.

## Status Action Behaviour

Only valid next actions are shown for the current Project status:

| Current Status | Visible Actions |
| --- | --- |
| `DRAFT` | Activate, Archive |
| `ACTIVE` | Pause, Close, Archive |
| `PAUSED` | Activate, Close, Archive |
| `CLOSED` | Complete, Archive |
| `COMPLETED` | Archive |
| `ARCHIVED` | Restore |

General Save does not mutate status.

Archive asks for confirmation before calling the archive endpoint.

## Activation Readiness Panel

The readiness panel shows:

- close date present;
- at least one active Project Product;
- no archived active Products;
- active Workflow Classes.

The panel is advisory and uses `fund.projects.get` data. Server-side activation validation remains authoritative and endpoint errors are surfaced through notifications.

## Product Membership Boundary

Slice 1J-A does not implement:

- add Product to Project;
- deactivate Product membership;
- reactivate Product membership;
- reorder Project Products;
- Product picker;
- Project Product mutation controls.

The Products tab only shows a read-only summary and a note that membership management is deferred to 1J-B.

## Date And Identifier Handling

Project Number and Slug remain editable in 1J-A because the Slice 1I API permits update.

The UI treats them as important identifiers and relies on the server to return duplicate/conflict errors clearly.

Date validation is mirrored client-side:

- Opens At must be before Closes At when both exist.
- Production Deadline cannot be before Closes At.
- Closes At is optional while draft but required by the server before activation.

## Deliberately Not Implemented

This slice did not implement:

- Prisma schema edits;
- migrations;
- `db:push`;
- seed/reset commands;
- Events;
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
- AI workflows;
- Project Product membership mutation controls.

## Checks Run

- `npm run type-check` - passed.
- `npm run verify` - passed after rerunning outside the sandbox because the initial sandboxed run blocked `tsx` IPC pipe creation with `EPERM`.
- Protected-route smoke check passed on the local dev server:
  - `/app/fund` returned the expected sign-in redirect.
  - `/app/fund/projects` returned the expected sign-in redirect.

## Manual Verification Checklist

- Open `/app/fund`.
- Confirm landing page links to Projects and Products.
- Open `/app/fund/projects`.
- Confirm Project list loads.
- Confirm fuzzy search works.
- Confirm status filter includes All current, Draft, Active, Paused, Closed, Completed and Archived.
- Confirm sort selector and direction toggle work.
- Confirm archived Projects are hidden by default.
- Create a Project.
- Confirm successful create routes to `/app/fund/projects/[id]`.
- Confirm row click opens Project child page.
- Confirm Overview tab displays detail form, readiness panel and status actions.
- Confirm Products tab is read-only and has no add/remove/reactivate/reorder controls.
- Confirm General Save updates details only.
- Confirm valid status actions are shown for the current status.
- Confirm activation readiness blockers are visible.
- Confirm activation API errors are surfaced through notifications.
- Confirm Product membership controls remain absent in 1J-A.

## Risks And Follow-Ups

- DB-backed Project UI testing requires the Slice 1H migration to be applied in the target environment. Local testing remains limited if `fund.fund_projects` does not exist.
- The readiness panel is intentionally advisory; future workflow-specific readiness rules should remain server-authoritative.
- Project Product membership management is the next UI complexity and should remain a separate 1J-B slice.

## Recommended Next Slice

Proceed to Slice 1J-B planning for Project Product membership management after 1J-A is reviewed and manually tested.
