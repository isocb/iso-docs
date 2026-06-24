# FUND Phase 1 Slice 1L-A - FundEvent Schema Confirmation

## Slice Name

Phase 1 Slice 1L-A - FundEvent Schema Only.

## Date

2026-06-24

## Implementation Summary

Implemented the schema-only FundEvent foundation for optional Event-linked Projects.

This slice adds:

- `FundEventStatus` enum;
- `FundEvent` model;
- optional `FundProject.eventId`;
- optional tenant-safe `FundProject.event` relation;
- Organization relation for Events;
- tenant-scoped uniqueness and lookup indexes;
- reviewed migration SQL.

Standalone Projects remain valid because `FundProject.eventId` is nullable.

## Documentation Changes Made

Before schema work, FUND planning/open-question documents were clarified so 1L-A uses the correct Event-linked Project date semantics:

- `FundEvent.closesAt` is the latest permissible effective close date for linked Projects.
- `FundEvent.closesAt` is not a forced persisted Project close date.
- standalone Projects remain governed only by normal Project date validation.
- linked Projects may close earlier than Event `closesAt`.
- linked Projects must not set `closesAt` later than Event `closesAt`.
- if a linked Project has no `closesAt`, future UI/API may treat Event `closesAt` as the inherited/effective close date for display, activation readiness and future Store generation.
- Store-specific close-date semantics remain future Store planning and are not part of 1L-A.

Documents updated before/around this slice:

- `docs/modules/fund/05-fund-open-questions.md`
- `docs/modules/fund/Planning/2026-06-24-fund-phase-1-slice-1l-event-season-planning-proposal.md`

## Schema Changes Made

File:

- `prisma/schema.prisma`

Added:

- `FundEventStatus`
- `FundEvent`
- `Organization.fundEvents`
- `FundProject.eventId`
- `FundProject.event`
- `@@index([organizationId, eventId])` on `FundProject`

## Migration Created

Migration:

```text
prisma/migrations/20260624120000_add_fund_events/migration.sql
```

SQL summary:

- creates `fund.FundEventStatus` enum with `DRAFT`, `ACTIVE`, `CLOSED`, `ARCHIVED`;
- creates `fund.fund_events`;
- adds nullable `event_id` to `fund.fund_projects`;
- creates tenant-scoped unique indexes for Event `id`, `code` and `slug`;
- creates Event status/date/archive indexes;
- creates Project `(organization_id, event_id)` index;
- adds Event-to-Organization foreign key;
- adds tenant-safe Project-to-Event composite foreign key.

`db:push` was not used.

Seed/reset commands were not used.

## Models / Enums Added

### `FundEventStatus`

Values:

- `DRAFT`
- `ACTIVE`
- `CLOSED`
- `ARCHIVED`

### `FundEvent`

Fields:

- `id`
- `organizationId`
- `code`
- `name`
- `slug`
- `eventType`
- `description`
- `status`
- `opensAt`
- `closesAt`
- `productionDeadline`
- `internalNotes`
- `metadata`
- archive metadata
- created/updated metadata
- `organization`
- `projects`

No `FundSeason` model was created.

## FundProject Relation Changes

`FundProject` now has optional Event linkage:

```text
eventId String?
event   FundEvent?
```

The relation uses `[organizationId, eventId] -> [organizationId, id]` to keep Project/Event linkage tenant-safe.

Existing Projects remain valid with `eventId = null`.

Event linkage is not mandatory.

## Tenant-Safety Notes

- `FundEvent` is tenant-owned through required `organizationId`.
- `FundEvent.code` is tenant-unique.
- `FundEvent.slug` is tenant-unique.
- Project/Event relation is tenant-safe through a composite relation.
- No client/API code was added, so no client input accepts or implies `organizationId`.

## Standalone Project Compatibility

Standalone Projects remain valid:

- `eventId` is nullable;
- existing Projects are implicitly backfilled with `event_id = null`;
- no Event is required for Project creation or Project operation at schema level.

## Event-Linked Project Date Semantics

The schema enables future Event-linked Project validation but does not implement API validation yet.

Planned semantics:

- standalone Project `opensAt` / `closesAt` are governed only by normal Project validation;
- standalone Project `closesAt` must be after `opensAt` when both are present;
- Event-linked Project `closesAt` may be earlier than Event `closesAt`;
- Event-linked Project `closesAt` must not be later than Event `closesAt`;
- if Event-linked Project `closesAt` is blank, future UI/API may treat Event `closesAt` as the effective inherited close date;
- inherited/effective close date behaviour does not require copying Event `closesAt` into `FundProject.closesAt`;
- Store-specific close dates remain future Store planning.

## Deliberately Out Of Scope

This slice did not implement:

- Event API;
- Event services;
- Event Zod schemas;
- Event tRPC routers;
- Event UI;
- Project Event validation services;
- Project Event UI selectors;
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
- AI workflows;
- `FundSeason`.

## Checks Run

- `npx prisma validate` - passed.
- `npm run db:generate` - passed.
- `npm run type-check` - passed.
- `npm run verify` - passed after rerunning outside the sandbox because the initial sandboxed run blocked `tsx` IPC pipe creation with `EPERM`.
- `npm run db` - failed because this repository does not define a `db` script. The supported Prisma generation script is `npm run db:generate`, which passed.

## Risks / Follow-Ups

- Event API/service validation is still required before users can create/link Events.
- Project activation readiness must be updated in a later slice to understand Event-linked effective close dates.
- Project create/edit UI must later show Event close-date inheritance clearly.
- Event date changes may make linked Projects invalid; future services should report warnings or validation errors rather than silently cascading Project date changes.
- Store-specific close dates must remain out of Event schema/API work until Store planning begins.

## Recommended Next Slice

Recommended next slice:

```text
Phase 1 Slice 1L-B - FundEvent API and Services
```

Suggested scope:

- Event list/get/create/update/status procedures;
- tenant-scoped Event services;
- date validation for Event fields;
- Project create/update optional Event linkage validation;
- Event-linked Project date validation;
- audit logging;
- no UI yet unless explicitly approved.
