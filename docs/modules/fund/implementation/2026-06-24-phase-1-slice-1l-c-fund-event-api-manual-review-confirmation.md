# Phase 1 Slice 1L-C - FundEvent API Manual Review

Date: 2026-06-24

## Purpose

Review and manually test Slice 1L-B FundEvent API/services and Project/Event linkage behaviour against the migrated local development database.

## Review Scope

Reviewed:

- `src/modules/fund/services/events.service.ts`
- `src/modules/fund/services/projects.service.ts`
- `src/modules/fund/routers/events.router.ts`
- `src/modules/fund/lib/validation/events.ts`
- `src/modules/fund/lib/validation/projects.ts`
- Slice 1L-A confirmation document
- Slice 1L-B confirmation document
- Active FUND planning/open-question notes

## Manual Service Tests Completed

A temporary review script was run against the local development database. It created prefixed temporary FundEvent, FundProject and FundProduct records, exercised the real service functions, and cleaned up the temporary entity records afterwards.

The final manual pass completed 23 checks with 23 passing and 0 failing.

Tested:

- `fund.events.create` creates DRAFT Events.
- Duplicate Event code returns `CONFLICT`.
- Duplicate Event slug returns `CONFLICT`.
- Event `opensAt` must be before `closesAt`.
- Event `productionDeadline` cannot be before `closesAt`.
- `fund.events.list` returns tenant-scoped Events only.
- `fund.events.get` returns Event detail, linked Project summaries and linked Project count.
- Event activation requires `closesAt`.
- Event status transitions follow the implemented matrix.
- Archived Events cannot be edited normally.
- Project create can link to a same-tenant DRAFT Event.
- Project create can link to a same-tenant ACTIVE Event.
- Project create rejects CLOSED Events.
- Project create rejects ARCHIVED Events.
- Project update can change/unlink Event only while Project is DRAFT.
- Project/Event same-tenant validation rejects another tenant's Event.
- Linked Project `closesAt` cannot exceed Event `closesAt`.
- Linked Project `opensAt` cannot be before Event `opensAt` when both exist.
- Linked Project `productionDeadline` cannot exceed Event `productionDeadline` when both exist.
- Linked Project with blank `closesAt` can use Event `closesAt` as effective close date for activation readiness.
- Standalone Project activation still requires Project `closesAt`.
- Project activation audit metadata includes `eventId` and `effectiveClosesAt`.
- Event and Project/Event audit events are written.

## Project UI Route Check

Started the local Next.js dev server and requested:

```text
/app/fund/projects
```

The route returned the expected unauthenticated redirect to sign-in:

```text
307 Temporary Redirect -> /auth/signin?callbackUrl=/app/fund/projects
```

No Prisma missing-table error or runtime Project UI error was seen in the server log.

## Store Close-Date Semantics Check

Searched FUND code and Prisma schema for Store/FundStore close-date semantics.

Result: no Store close-date semantics were introduced. The only search hits were unrelated modal close text in existing Product/Catalogue components.

## Defects Found

No product defects found.

Two temporary review-script fixture issues were corrected during the manual test pass:

- standalone TRPCError checks were updated to compare `error.code` directly;
- CLOSED/ARCHIVED Event fixtures were kept separate from restored fixture records.

No application code changes were required.

## Fixes Made

No application fixes were made.

No schema, migration, router, service or UI changes were made during this review slice.

## Commands Run

- `npx prisma validate` - passed.
- `npm run db:generate` - passed.
- `npm run type-check` - passed.
- `npm run verify` - passed after unsandboxed rerun. The first sandboxed run failed with the known `tsx` IPC `EPERM` limitation, not a code failure.

## Explicit Non-Actions

Confirmed:

- No Prisma schema edits.
- No migrations created.
- No migrations run.
- No `db:push`.
- No seed commands.
- No reset commands.
- No Event UI implemented.
- No Project Event selector UI implemented.
- No Stores, Orders, commerce, payments, commissions, dashboards, production batching, organiser onboarding, Project Request flows or AI workflows added.

## Recommendation

Proceed to Phase 1 Slice 1M - Event Admin UI planning.

The 1L-B API/services and Project/Event linkage foundation are review-clean for the next planning step.
