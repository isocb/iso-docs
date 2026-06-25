# FUND Phase 1 Slice 1P-F-C - C1 Client Management Schema Confirmation

Date: 2026-06-25

Status: Implemented / schema only

## 1. Slice Name

FUND Phase 1 Slice 1P-F-C - C1 Client Management Schema

## 2. Implementation Summary

Implemented the schema-only foundation for C1 Client Management.

The implementation follows the accepted 1P-F-B schema direction:

```text
FUND-specific first, platform-aware.
FundClient + nullable FundProject.clientId.
```

No routers, services, Zod schemas, UI, Client users, invitations, Store, Orders, Commerce, Sales/Reporting, Communications, key-date automation, SeasonPro mapping or reusable core Client/account model were implemented.

## 3. Files Changed

App repo:

- `prisma/schema.prisma`
- `prisma/migrations/20260625170000_add_fund_clients/migration.sql`

Docs repo:

- `docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-f-c-c1-client-management-schema-confirmation.md`

## 4. Prisma Schema Changes

Added:

- `FundClientStatus` enum.
- `FundClient` model.
- `Organization.fundClients` relation.
- nullable `FundProject.clientId`.
- nullable `FundProject.client` relation.
- `@@index([organizationId, clientId])` on `FundProject`.

## 5. Migration Created And SQL Summary

Migration created:

```text
prisma/migrations/20260625170000_add_fund_clients/migration.sql
```

SQL summary:

- creates `fund.FundClientStatus` enum with `ACTIVE`, `INACTIVE`, `ARCHIVED`;
- creates `fund.fund_clients`;
- adds nullable `client_id` to `fund.fund_projects`;
- adds tenant-scoped unique constraints for Client `id`, `code` and `slug`;
- adds Client indexes for status, client type and archive state;
- adds Project index for `[organization_id, client_id]`;
- adds Client-to-Organization foreign key;
- adds same-tenant Project-to-Client foreign key:

```text
fund.fund_projects(organization_id, client_id)
-> fund.fund_clients(organization_id, id)
```

No existing Projects are backfilled.

No placeholder Clients are generated.

## 6. Models / Enums Created

Created enum:

```text
FundClientStatus
```

Values:

- `ACTIVE`
- `INACTIVE`
- `ARCHIVED`

Created model:

```text
FundClient
```

Core fields:

- `id`
- `organizationId`
- `code`
- `name`
- `slug`
- `clientType`
- `description`
- `status`
- `primaryContactName`
- `primaryContactEmail`
- `primaryContactPhone`
- `internalNotes`
- `metadata`
- `archivedAt`
- `archivedById`
- `archivedReason`
- `createdById`
- `updatedById`
- `createdAt`
- `updatedAt`

## 7. Tenant Scoping Strategy

`FundClient.organizationId` is the C1 tenant boundary.

`FundProject.organizationId` remains the C1 tenant boundary.

`FundClient` uses tenant-scoped uniqueness:

- `@@unique([organizationId, id])`
- `@@unique([organizationId, code])`
- `@@unique([organizationId, slug])`

Tenant-scoped indexes were added for:

- `[organizationId, status]`
- `[organizationId, clientType]`

## 8. Project / Client Same-Tenant Relation

`FundProject.clientId` is nullable.

The Prisma relation is:

```text
clientId String?     @map("client_id")
client   FundClient? @relation(fields: [organizationId, clientId], references: [organizationId, id], onDelete: Restrict)
```

This follows the current FUND same-tenant relation pattern used by Projects and Events.

The relation ensures a Project can only link to a Client in the same C1 tenant.

## 9. Nullable / Backfill Strategy

`FundProject.clientId` is nullable.

Existing Projects remain valid with:

```text
clientId = null
```

No automatic backfill was performed because:

- existing organiser snapshot fields are contact details, not authoritative Client ownership;
- no authoritative Client source exists yet;
- automatic Client creation from organiser name/email would create false account records.

Future C1 Client API/UI slices should allow Projects to be linked deliberately.

## 10. Delete / Archive Strategy

Clients are intended to be soft-archived, not hard-deleted, once in operational use.

`FundProject.client` uses `onDelete: Restrict` so linked Projects protect Client history.

Archived Clients should remain visible on historical Projects.

Future services should block linking new Projects to archived Clients.

## 11. SeasonPro Mapping Guardrails

No SeasonPro schema or mapping was implemented.

The schema remains platform-aware by:

- using the user-facing FUND term `Client`;
- keeping the model FUND-specific for now;
- avoiding assumptions that every FUND Client is a SeasonPro Club;
- avoiding assumptions that every SeasonPro Club is immediately a FUND Client;
- preserving a future path to either direct SeasonPro mapping or reusable core Client/account mapping.

## 12. Explicit Out Of Scope Confirmation

Not implemented:

- routers;
- services;
- Zod schemas;
- UI;
- Project Client selector;
- Client list/detail UI;
- Client users;
- Client roles;
- invitations;
- C2 mutations;
- Project Request/onboarding;
- Store;
- Orders;
- Commerce Core;
- payments;
- commissions;
- Sales/Reporting;
- Communications;
- key-date automation;
- SeasonPro Club mapping;
- reusable core Client/account model.

## 13. db:push / Seed / Reset Confirmation

`db:push` was not run.

Seed commands were not run.

Reset commands were not run.

## 14. Checks Run And Results

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

## 15. Risks / Follow-Ups

Risks:

- Client API/UI must preserve the same-tenant Project-to-Client rule.
- Future services must block linking Projects to archived Clients.
- Future migration/backfill must not infer Clients from organiser snapshot fields.
- The FUND-specific `FundClient` model should remain platform-aware so SeasonPro Club mapping or core Client/account migration remains possible.

Follow-ups:

- 1P-F-D: C1 Client Management API/services.
- 1P-F-E: C1 Client Management UI.
- Project create/edit Client selector.
- Project Overview Client display.
- Future Client/account users and roles planning.
- Future SeasonPro Club mapping planning.

## 16. Recommended Next Slice

Recommended next slice:

```text
FUND Phase 1 Slice 1P-F-D - C1 Client Management API/Services
```

Goal:

```text
Expose tenant-scoped C1 Client list/get/create/update/archive/restore procedures and safe Project-linking behaviour using the schema introduced in 1P-F-C.
```
