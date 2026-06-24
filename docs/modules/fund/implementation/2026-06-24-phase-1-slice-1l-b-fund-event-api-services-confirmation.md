# Phase 1 Slice 1L-B - FundEvent API and Services

Date: 2026-06-24

## Implementation Summary

Implemented tenant-scoped FundEvent API and service support for Phase 1, plus optional Project-to-Event linkage in the existing Project API/services.

This slice keeps FundEvent as an optional tenant-owned grouping and constraint container. Projects remain the mandatory operational FUND entity.

## Files Changed

- `src/modules/fund/lib/validation/events.ts`
- `src/modules/fund/lib/validation/projects.ts`
- `src/modules/fund/routers/events.router.ts`
- `src/modules/fund/routers/index.ts`
- `src/modules/fund/services/events.service.ts`
- `src/modules/fund/services/projects.service.ts`
- `isodocs/docs/modules/fund/implementation/2026-06-24-phase-1-slice-1l-b-fund-event-api-services-confirmation.md`

## Validation Schemas Added

Added Event validation schemas for:

- list
- get
- create
- update
- archive
- status actions

Project create/update schemas now accept optional `eventId`.

## tRPC Endpoints Added

Router path: `fund.events`

Procedures:

- `fund.events.list`
- `fund.events.get`
- `fund.events.create`
- `fund.events.update`
- `fund.events.activate`
- `fund.events.close`
- `fund.events.archive`
- `fund.events.restore`

All Event procedures use the FUND feature gate. Event mutations require OWNER or ADMIN, matching existing FUND Products/Catalogues/Projects service behaviour.

## Event Service Behaviour

Implemented tenant-scoped Event service methods for:

- list
- get
- create
- update
- activate
- close
- archive
- restore

Event create/update validate:

- code/name/slug requirements
- tenant-unique code and slug
- open date before close date
- production deadline not before close date
- status is not directly mutated through update
- archived Events must be restored before normal editing

Event status transitions:

- `DRAFT -> ACTIVE`
- `DRAFT -> ARCHIVED`
- `ACTIVE -> CLOSED`
- `ACTIVE -> ARCHIVED`
- `CLOSED -> ARCHIVED`
- `ARCHIVED -> DRAFT`

Event activation requires a close date.

## Project/Event Linkage Behaviour

Project create/update now supports optional `eventId`.

Rules implemented:

- Event lookup is tenant-scoped.
- `organizationId` is never accepted from client input.
- Archived Events cannot be newly linked.
- Closed Events cannot be newly linked.
- Project Event linkage can only be changed while the Project is `DRAFT`.
- Existing linked Projects remain visible if an Event is later closed or archived.

Audit events added for:

- `FUND_PROJECT_EVENT_LINKED`
- `FUND_PROJECT_EVENT_UNLINKED`
- `FUND_PROJECT_EVENT_CHANGED`

## Event-Linked Project Date Rules

Standalone Projects remain governed by normal Project date validation.

For linked Projects:

- Project `opensAt` cannot be before Event `opensAt` when both exist.
- Project `closesAt` cannot be later than Event `closesAt` when both exist.
- Project `productionDeadline` cannot be later than Event `productionDeadline` when both exist.
- Project `productionDeadline` cannot be before the effective close date.

Effective close date:

```text
project.closesAt ?? linkedEvent.closesAt
```

Linked Projects may use Event `closesAt` as the effective inherited close date for activation readiness. The Event close date is not copied into `FundProject.closesAt`.

## Audit Logging

Event audit actions:

- `FUND_EVENT_CREATED`
- `FUND_EVENT_UPDATED`
- `FUND_EVENT_ACTIVATED`
- `FUND_EVENT_CLOSED`
- `FUND_EVENT_ARCHIVED`
- `FUND_EVENT_RESTORED`

Project/Event audit actions:

- `FUND_PROJECT_EVENT_LINKED`
- `FUND_PROJECT_EVENT_UNLINKED`
- `FUND_PROJECT_EVENT_CHANGED`

Existing Project activation audit metadata now includes `eventId` and `effectiveClosesAt`.

## What Was Deliberately Not Implemented

- Event UI
- Project Event selector UI
- Store schema
- Order schema
- commerce
- payments
- commissions
- dashboards
- production batching
- SeasonPro integration
- marketplace exposure
- media/asset workflows
- lifecycle tables
- lifecycle transition engine
- organiser identity/account linking
- Project Request/onboarding
- AI workflows
- Prisma schema changes
- migrations
- seed/reset commands
- `db:push`

## Checks Run

- `npx prisma validate` - passed.
- `npm run db:generate` - passed.
- `npm run type-check` - passed.
- `npm run verify` - passed after unsandboxed rerun. The first sandboxed run failed with the known `tsx` IPC `EPERM` limitation, not a code failure.

## Manual Verification Checklist

- Confirm `fund.events.list` returns tenant-scoped Events only.
- Confirm `fund.events.get` returns Event details and linked Project summaries for the current tenant.
- Confirm Event create rejects duplicate tenant code/slug.
- Confirm Event update rejects invalid date ordering.
- Confirm Event activation requires `closesAt`.
- Confirm Event close/archive/restore follow the allowed transition matrix.
- Confirm Project create can link to a DRAFT or ACTIVE same-tenant Event.
- Confirm Project create rejects archived/closed Events.
- Confirm Project update can change/unlink Event only while DRAFT.
- Confirm linked Project `closesAt` cannot exceed Event `closesAt`.
- Confirm linked Project activation can use Event `closesAt` when Project `closesAt` is blank.
- Confirm standalone Project activation still requires Project `closesAt`.
- Confirm Project/Event mutations write AuditLog rows.

## Risks and Follow-Ups

- Browser/manual tRPC testing should be completed in a migrated target environment.
- Project UI does not yet expose Event selection.
- Event UI is not yet implemented.
- Future Event child-page UI should make inherited effective close dates clear to users.
- Future Store planning must avoid assuming a single e-commerce mode.

## Recommended Next Slice

Phase 1 Slice 1M - FundEvent Admin UI planning, or a focused 1L-B API/manual tRPC review before UI if preferred.
