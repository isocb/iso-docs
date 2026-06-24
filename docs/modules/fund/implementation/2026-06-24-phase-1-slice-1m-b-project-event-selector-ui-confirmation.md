# Phase 1 Slice 1M-B - Project Event Selector UI

Date: 2026-06-24

## Implementation Summary

Implemented the C1/admin Project Event selector and linkage UI inside the existing Project admin surface.

This slice allows C1 tenant/admin users to:

- create standalone Projects with no Event;
- create Projects linked to eligible DRAFT or ACTIVE Events;
- view Event linkage on the Project child page;
- link, change or unlink Event linkage while a Project is DRAFT;
- see Event date constraint helper text;
- see effective close-date readiness that can use an inherited Event close date.

This remains a C1/admin surface. It does not implement the future C2 organiser dashboard.

## Files Changed

App repository:

- `src/modules/fund/components/projects/ProjectCreateModal.tsx`
- `src/modules/fund/components/projects/ProjectDetailPage.tsx`
- `src/modules/fund/components/projects/ProjectEventSelector.tsx`

Documentation repository:

- `docs/modules/fund/implementation/2026-06-24-phase-1-slice-1m-b-project-event-selector-ui-confirmation.md`

## Endpoints Used

Existing endpoints only:

- `fund.projects.get`
- `fund.projects.create`
- `fund.projects.update`
- `fund.projects.activate`
- `fund.events.list`

No routers, services, Zod schemas or tRPC endpoints were created or modified.

## Project Create Flow

The Project create modal now includes an optional Event selector.

Behaviour:

- Event selection is optional.
- Leaving Event blank creates a standalone Project.
- Selector options are DRAFT or ACTIVE Events from the current C1 tenant context.
- CLOSED and ARCHIVED Events are not eligible for new selection.
- Selected Event id is passed to `fund.projects.create` as `eventId`.
- Successful create invalidates Project list.
- Successful Event-linked create also invalidates Event list so linked Project counts can refresh.
- Event helper text explains close-date inheritance and date constraints.

## Project Detail Linkage Behaviour

The Project Overview tab now includes an Event Linkage section.

Behaviour:

- Linked Projects show the selected Event and Event constraint guidance.
- Standalone Projects show a standalone notice.
- Event linkage controls are enabled only while the Project is `DRAFT`.
- Non-DRAFT Projects show Event linkage read-only.
- CLOSED or ARCHIVED linked Events remain visible as historical context.
- Link/change/unlink uses `fund.projects.update` through the existing Project details save flow.
- General Save does not mutate Project status.

## DRAFT-Only Rule

The UI mirrors the server rule:

- `DRAFT`: link/change/unlink enabled.
- `ACTIVE`, `PAUSED`, `CLOSED`, `COMPLETED`, `ARCHIVED`: Event linkage read-only.

If a stale UI attempts an invalid Event linkage change, the server remains authoritative and the error is surfaced through notifications.

## C1 Tenant Scoping

The Event selector uses `fund.events.list`, which is tenant-scoped server-side.

The UI only presents Events returned for the current C1 tenant context. Server-side tenant scoping remains authoritative if a stale or malicious `eventId` is submitted.

## Effective Close-Date Display

Project activation readiness now distinguishes:

- Project close date;
- inherited Event close date;
- missing effective close date.

Rules:

- If Project `closesAt` exists, it is the effective close date.
- If Project `closesAt` is blank and linked Event `closesAt` exists, Event `closesAt` is shown as the effective close date with an `Inherited from Event` label.
- If both Project and linked Event close dates are blank, a warning states that there is no effective close date.
- Standalone Projects still require a Project close date before activation.

The UI does not copy Event dates into Project date fields.

## Readiness Changes

The readiness panel now uses effective close date for the close-date readiness item.

Other readiness checks remain unchanged:

- at least one active Project Product;
- no archived active Products;
- active Workflow Classes.

The readiness panel remains advisory. Server-side activation validation remains authoritative.

## Date Constraint UX

Client-side validation now guides users where practical:

- Project opensAt cannot be before linked Event opensAt.
- Project closesAt cannot be later than linked Event closesAt.
- Project productionDeadline cannot be later than linked Event productionDeadline.
- Project may close earlier than the Event.
- Event dates are not silently copied into Project fields.

Server-side validation remains authoritative.

## Query Invalidation

Project create:

- invalidates Project list;
- invalidates Event list when an Event was selected;
- routes to Project detail after success.

Project update:

- invalidates Project detail;
- invalidates Project list;
- invalidates Event list;
- invalidates previous and new Event detail queries where the Event ids are known.

## Error Handling

Project mutation notifications now map common tRPC errors:

- `BAD_REQUEST`: Project details not valid.
- `CONFLICT`: Duplicate Project.
- `FORBIDDEN`: Permission denied.
- `NOT_FOUND`: Project or Event not found.
- fallback: Project not created/saved or the status action title.

Mutation errors keep forms open and preserve form state.

## Deliberately Out Of Scope

Not implemented:

- Prisma schema changes.
- Migrations.
- `db:push`.
- Seed/reset commands.
- Router changes.
- Service changes.
- Zod schema changes.
- New tRPC endpoints.
- Event child linked-Project mutation controls.
- Stores.
- Orders.
- Commerce.
- Payments.
- Commissions.
- Production batching.
- SeasonPro integration.
- Marketplace exposure.
- Media/asset workflows.
- Lifecycle engine.
- Organiser identity/account linking.
- Project Request/onboarding.
- C2 organiser dashboard.
- Organiser invitations.
- Project ownership/access changes.
- AI workflows.

## Checks Run

- `npm run type-check` - passed.
- `npm run verify` - initially blocked by sandbox `tsx` IPC permissions, rerun outside the sandbox with approval and passed.

## Manual Verification Checklist

- Open Project create modal.
- Confirm Event selector loads DRAFT/ACTIVE Events only.
- Confirm standalone Project can be created with no Event.
- Confirm Project can be created linked to a DRAFT Event.
- Confirm Project can be created linked to an ACTIVE Event.
- Confirm CLOSED/ARCHIVED Events are not eligible for new selection.
- Confirm Event helper text appears when an Event is selected.
- Confirm Project close date can be blank when selected Event has `closesAt`.
- Confirm Project close date cannot be later than selected Event close date.
- Open a Project child page with linked Event.
- Confirm Event linkage displays in Overview.
- Confirm DRAFT Project can change/unlink Event.
- Confirm non-DRAFT Project Event linkage is read-only.
- Confirm CLOSED/ARCHIVED linked Event remains visible historically.
- Confirm effective close date shows `Inherited from Event` when Project close date is blank.
- Confirm a no effective close-date warning appears when both Project and linked Event close dates are blank.
- Confirm standalone Project still shows Project close date as required for activation.
- Confirm Project Products tab still works.
- Confirm Event list and Event detail still load.
- Confirm Products/Catalogues admin still works.
- Confirm no C2 organiser dashboard, organiser invitation, Project Request/onboarding or ownership/access change was introduced.

## Risks And Follow-Ups

- Browser testing should confirm the selector remains readable when there are many Events.
- The Project create modal is now denser; future UX may move complex Project setup to a child create page if needed.
- Current implementation uses existing Event list data; richer historical Event display may need a focused enhancement if Project detail ever stops including linked Event data.
- Future C2 organiser dashboard and Project Request/onboarding remain separate slices.

## Recommended Next Slice

Recommended next slice: Phase 1 Slice 1M-C - Project/Event Linkage UI Review and Manual Testing.
