# Phase 1 Slice 1M-A - FundEvent Admin UI

Date: 2026-06-24

## Implementation Summary

Slice 1M-A adds the C1 tenant/admin Event management surface for FUND.

Implemented:

- `/app/fund/events` Event list page.
- `/app/fund/events/[id]` Event child management page.
- Event fuzzy search, status filter, sort selector and sort direction toggle.
- Compact Create Event modal.
- Event overview/edit form.
- Event status actions using dedicated API procedures.
- Event date constraint panel.
- Read-only linked Projects list from `fund.events.get`.
- Effective close date display for linked Projects.
- FUND navigation and FUND home-page links to Events.

This slice is C1/admin-side only. It does not implement the future C2 organiser dashboard.

## Files Changed

- `src/app/(app)/app/fund/events/page.tsx`
- `src/app/(app)/app/fund/events/[id]/page.tsx`
- `src/app/(app)/app/fund/page.tsx`
- `src/core/config/module-navigation.ts`
- `src/modules/fund/components/events/EventCreateModal.tsx`
- `src/modules/fund/components/events/EventDetailPage.tsx`
- `src/modules/fund/components/events/EventTable.tsx`
- `isodocs/docs/modules/fund/implementation/2026-06-24-phase-1-slice-1m-a-fund-event-admin-ui-confirmation.md`

## Routes Added

- `/app/fund/events`
- `/app/fund/events/[id]`

## Components Created

- `EventTable`
- `EventCreateModal`
- `EventDetailPage`

## tRPC Endpoints Used

Existing Slice 1L-B endpoints only:

- `fund.events.list`
- `fund.events.get`
- `fund.events.create`
- `fund.events.update`
- `fund.events.activate`
- `fund.events.close`
- `fund.events.archive`
- `fund.events.restore`

No routers, services, Zod schemas or tRPC endpoints were created or changed.

## Event List Behaviour

- Archived Events are hidden by default through the current status filter.
- Fuzzy search covers Event code, name, slug, status and event type.
- Sort selector defaults to Code ascending.
- Sort direction can be toggled.
- Row click opens the Event child page.
- No edit/delete row ActionIcons or actions column were added.

## Event Create Flow

- Create Event is a compact modal.
- Required fields: Code, Name, Slug.
- Optional fields: Event Type / Category, Opens At, Closes At, Production Deadline.
- Status is not exposed on create.
- Events are created as DRAFT by the existing API.
- Successful create invalidates the Event list and navigates to the Event child page.
- Duplicate code/slug CONFLICT errors are surfaced as user notifications.

## Event Child Page Behaviour

- Event details are managed on `/app/fund/events/[id]`.
- The page includes an Overview tab and a Linked Projects tab.
- General Save calls `fund.events.update` and does not mutate status.
- Archived Events show normal edit fields disabled with restore-first guidance.
- Event Code and Slug are presented as tenant-scoped identifiers.

## Status Action Behaviour

Dedicated status actions are shown only where valid:

- DRAFT: Activate, Archive.
- ACTIVE: Close, Archive.
- CLOSED: Archive.
- ARCHIVED: Restore.

Activation is disabled in the UI until `closesAt` is set, while server-side validation remains authoritative. Close and Archive actions ask for confirmation where appropriate.

After status changes, Event detail and Event list queries are invalidated.

## Date Constraint Panel Behaviour

The date constraint panel explains that:

- Event `opensAt` is the earliest permitted linked Project `opensAt`, when set.
- Event `closesAt` is the latest permissible effective linked Project close date, when set.
- Linked Projects may close earlier than the Event, but not later.
- If a linked Project has no close date, the Event close date can act as its effective inherited close date.
- Event close dates are not copied into `FundProject.closesAt`.
- Store-specific close dates remain future Store planning.

## Linked Projects Read-Only List

The linked Projects tab uses summaries returned by `fund.events.get`.

It displays:

- Project Number.
- Name and slug.
- Status.
- Lifecycle State.
- Opens At.
- Project Close Date.
- Effective Close Date.
- Production Deadline.
- Updated date.

The list is read-only in this slice. It has no unlink controls, no Project mutation controls and no Project ownership/access controls.

## Effective Close Date Display

- If a Project has its own `closesAt`, that value is displayed as the Project and effective close date.
- If a Project has no `closesAt` and the Event has `closesAt`, the Event close date is displayed as inherited/effective.
- If both Project and Event close dates are blank, a warning badge shows that there is no effective close date.
- The UI does not imply the Event close date has been copied into the Project.

## C1/C2 Dashboard Boundary

1M-A is part of the C1 operating/admin console.

- C1 users manage Events, date constraints and campaign-level settings.
- C2 users are future Project organisers.
- Linked Projects are shown read-only for C1 impact visibility.
- This slice does not implement C2 organiser dashboards, organiser invitations, Project Request/onboarding, Project ownership changes or Project organiser access changes.

## Deliberately Out Of Scope

Not implemented:

- Prisma schema changes.
- Migrations.
- `db:push`.
- Seed/reset commands.
- Router, service, Zod or tRPC endpoint changes.
- Project Event selector UI.
- Project create/edit Event selection.
- Project mutation controls from Event pages.
- C2 organiser dashboard.
- Organiser invitations.
- Project Request/onboarding.
- Project ownership/access changes.
- Stores.
- Orders.
- Commerce.
- Payments.
- Commissions.
- Dashboards beyond this admin Event surface.
- Production batching.
- SeasonPro integration.
- Marketplace exposure.
- Media/asset workflows.
- Lifecycle tables.
- Lifecycle transition engine.
- AI workflows.

## Checks Run

- `npm run type-check` - passed.
- `npm run verify` - initially blocked by sandbox `tsx` IPC permissions, rerun outside the sandbox with approval and passed.

## Manual Verification Checklist

- Open `/app/fund/events` and confirm Events load.
- Confirm archived Events are hidden by default.
- Search by code, name, slug and event type.
- Change status filter and sort direction.
- Create a DRAFT Event and confirm navigation to `/app/fund/events/[id]`.
- Try duplicate code/slug and confirm a clear CONFLICT notification.
- Edit Event details and confirm the status is unchanged.
- Confirm archived Event fields are disabled until restore.
- Activate a DRAFT Event with `closesAt` set.
- Confirm activation is disabled without `closesAt`.
- Close an ACTIVE Event and confirm the linked Project warning where applicable.
- Archive and restore an Event.
- Confirm linked Projects display read-only.
- Confirm row click from linked Projects navigates to Project detail.
- Confirm no Project unlink, Project mutation, Event selector or C2 organiser controls are present.
- Confirm the effective close date display distinguishes Project close date, inherited Event close date and no effective close date.
- Confirm `/app/fund/projects`, Project detail and Products/Catalogues admin still load.

## Risks And Follow-Ups

- Full browser/manual testing should be completed against an authenticated tenant with FUND enabled.
- Linked Project list depends on the current `fund.events.get` summary shape.
- Future Event UI work should add Project linkage controls only in a dedicated Project/Event linkage slice.
- Future C2 organiser dashboard work must remain separate from the C1 Event admin surface.

## Recommended Next Slice

Recommended next slice: Phase 1 Slice 1M-B - FundEvent Admin UI Review and Manual Testing.

