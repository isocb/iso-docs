# FUND Phase 1 Slice 1P-F-D - C1 Client Management API/Services Confirmation

Date: 2026-06-25

Status: Implemented / API-services only

## 1. Slice Name

FUND Phase 1 Slice 1P-F-D - C1 Client Management API/Services

## 2. Implementation Summary

Implemented tenant-scoped C1 Client Management API/services using the schema introduced in Slice 1P-F-C.

Created the C1 admin procedures:

```text
fund.clients.list
fund.clients.get
fund.clients.create
fund.clients.update
fund.clients.archive
fund.clients.restore
```

The implementation is C1/admin only and uses the existing FUND feature gate and admin access convention.

No UI, Project Client selector, Client users, invitations, C2 dashboard expansion, C2 mutations, Project Request/onboarding, Store, Orders, Commerce Core, Sales/Reporting, Communications, key-date automation, SeasonPro mapping or reusable core Client/account model was implemented.

## 3. Files Changed

App repo API/services changes:

- `src/modules/fund/lib/validation/clients.ts`
- `src/modules/fund/services/clients.service.ts`
- `src/modules/fund/routers/clients.router.ts`
- `src/modules/fund/routers/index.ts`

Existing uncommitted schema foundation from 1P-F-C remains present in the app repo:

- `prisma/schema.prisma`
- `prisma/migrations/20260625170000_add_fund_clients/migration.sql`

Docs repo:

- `docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-f-d-c1-client-management-api-services-confirmation.md`

## 4. Router / Service / Zod Structure

Router:

```text
src/modules/fund/routers/clients.router.ts
```

Service:

```text
src/modules/fund/services/clients.service.ts
```

Validation:

```text
src/modules/fund/lib/validation/clients.ts
```

Router mount:

```text
fund.clients
```

## 5. Procedures Created

Created procedures:

- `fund.clients.list`
- `fund.clients.get`
- `fund.clients.create`
- `fund.clients.update`
- `fund.clients.archive`
- `fund.clients.restore`

All procedures use:

```text
withFeature('fund')
```

All procedures require:

```text
assertFundAdmin(actor)
```

## 6. Service Functions Created

Created service functions:

- `listClients`
- `getClient`
- `createClient`
- `updateClient`
- `archiveClient`
- `restoreClient`
- `getClientOrThrow`
- `assertClientCanBeLinked`
- `validateProjectClientLink`

`validateProjectClientLink` is a helper for later Project-linking work only. It does not mutate Project create/update behaviour in this slice.

## 7. Validation Schemas Created

Created schemas:

- `clientListInputSchema`
- `clientGetInputSchema`
- `clientCreateInputSchema`
- `clientUpdateInputSchema`
- `clientArchiveInputSchema`
- `clientIdInputSchema`

Validation follows current FUND conventions by reusing:

- `fundCodeSchema`
- `fundNameSchema`
- `fundSlugSchema`
- `fundArchiveReasonSchema`
- `fundMetadataSchema`

Client status validation uses:

```text
z.nativeEnum(FundClientStatus)
```

## 8. Tenant Scoping Strategy

Every Client read and write is scoped by:

```text
organizationId = actor.organizationId
```

The API never accepts `organizationId` from client input.

Cross-tenant Client ids resolve as:

```text
NOT_FOUND
```

Tenant-scoped uniqueness is checked before create/update for:

- `code`
- `slug`

Prisma `P2002` is also caught and mapped to a `CONFLICT` response.

## 9. Admin / Feature Gating Approach

The Client router follows the current FUND admin convention:

- actor is resolved from the authenticated/effective user and organization context;
- every procedure is gated by `withFeature('fund')`;
- every procedure calls `assertFundAdmin(actor)`.

This keeps Client management as a C1 admin surface.

No C2 self-service Client procedure was introduced.

## 10. Client Create / Update / Archive / Restore Behaviour

Create:

- creates within the current actor tenant;
- defaults to `ACTIVE`;
- requires code, name, slug and client type;
- supports optional primary contact snapshot fields;
- does not create users or invitations;
- does not auto-link Projects.

Update:

- only updates current-tenant Clients;
- supports safe profile/contact/status updates;
- blocks direct update to `ARCHIVED`;
- blocks general edits while archived and requires restore first.

Archive:

- soft-archives only;
- blocks archive when linked Projects are `ACTIVE` or `PAUSED`;
- allows archive when linked Projects are `DRAFT`, `CLOSED`, `COMPLETED` or `ARCHIVED`;
- sets `status = ARCHIVED`;
- sets `archivedAt`, `archivedById`, `archivedReason`;
- does not hard-delete;
- leaves linked Projects intact for historical display.

Restore:

- restores archived Clients to `ACTIVE`;
- clears archive fields;
- does not mutate linked Projects.

## 11. Linked Project Summary Behaviour

`fund.clients.get` includes linked Project summaries.

Project summary fields include:

- `id`
- `projectNumber`
- `name`
- `slug`
- `status`
- `lifecycleState`
- `eventId`
- `opensAt`
- `closesAt`
- `productionDeadline`
- `updatedAt`

`fund.clients.list` includes `projectCount`.

Active Project counts were not added in this slice because the safe first API surface only needs total linked Project count. More detailed Project rollups can be planned for the UI slice if needed.

## 12. Organiser Snapshot Field Confirmation

Client ownership is not inferred from:

- `FundProject.organiserName`
- `FundProject.organiserEmail`
- `FundProject.organiserPhone`

Existing Projects are not auto-linked to Clients.

No placeholder Clients are generated from organiser snapshot fields.

Primary contact fields on Client are also treated as contact snapshots only, not authoritative identity or access control.

## 13. Audit Events

Implemented audit events:

- `FUND_CLIENT_CREATED`
- `FUND_CLIENT_UPDATED`
- `FUND_CLIENT_ARCHIVED`
- `FUND_CLIENT_RESTORED`
- `FUND_CLIENT_STATUS_CHANGED`
- `FUND_CLIENT_CONTACT_CHANGED`

Audit metadata includes Client code, slug, name and relevant status/contact/archive context.

## 14. Explicit Out Of Scope Confirmation

Not implemented:

- UI;
- Project Client selector;
- Project create/edit changes;
- Client list/detail UI;
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
- reusable core Client/account model.

## 15. Schema / Migration / db:push / Seed / Reset Confirmation

No new schema changes were introduced by 1P-F-D beyond the existing uncommitted 1P-F-C schema foundation already present in the app repo.

No new migration was created by 1P-F-D.

`db:push` was not run.

Seed commands were not run.

Reset commands were not run.

## 16. Checks Run And Results

App repo checks:

```text
npx prisma validate
```

Result: passed.

```text
npm run db:generate
```

Result: passed.

```text
npm run type-check
```

Result: passed.

```text
npm run verify
```

Result: passed after rerunning outside the sandbox because the first sandboxed run failed with a `tsx` temporary IPC pipe `EPERM` error.

```text
git diff --check
```

Result: passed.

## 17. Risks / Follow-Ups

Risks:

- Project create/update still does not expose Client linking; that remains intentionally out of scope.
- Future Project-linking work must use `validateProjectClientLink` or equivalent same-tenant archived/inactive checks.
- Client archive currently leaves linked Projects intact for historical display; future UI should make this clear.
- Client user/account modelling remains deferred.

Follow-ups:

- 1P-F-E: C1 Client Management UI.
- Project Client selector/linkage planning.
- C2 Client/account users and roles planning.
- SeasonPro Club mapping planning.

## 18. Recommended Next Slice

Recommended next slice:

```text
FUND Phase 1 Slice 1P-F-E - C1 Client Management UI
```

Goal:

```text
Build the C1 Client list/detail admin surface using fund.clients.* procedures, with Project summaries visible but no Client users, invitations, Store, Orders, Commerce, Sales/Reporting or Communications.
```
