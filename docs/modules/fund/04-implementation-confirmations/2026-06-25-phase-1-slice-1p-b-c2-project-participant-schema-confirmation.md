# FUND Phase 1 Slice 1P-B - C2 Project Participant Schema Confirmation

Date: 2026-06-25

## 1. Slice Name

Phase 1 Slice 1P-B - C2 Project Participant Schema

## 2. Implementation Summary

Implemented the schema-only foundation for explicit C2 Project access using `FundProjectParticipant`.

This slice creates a tenant-scoped Project participant/access record that can later authorise C2 organiser dashboard visibility. It deliberately does not implement runtime access checks, APIs, services, routers or UI.

The key access boundary remains:

```text
FundProject.organiserName / organiserEmail / organiserPhone are contact snapshots only.
They do not grant C2 Project access.
```

## 3. Files Changed

App repo:

- `prisma/schema.prisma`
- `prisma/migrations/20260625143000_add_fund_project_participants/migration.sql`

Docs repo:

- `docs/modules/fund/03-slice-planning/2026-06-24-fund-phase-1-slice-1p-a-c2-project-access-model-proposal.md`
- `docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-b-c2-project-participant-schema-confirmation.md`

## 4. Prisma Schema Changes

Added enums:

- `FundProjectParticipantRole`
  - `PRIMARY_ORGANISER`
  - `COLLABORATOR`
  - `VIEWER`
- `FundProjectParticipantStatus`
  - `INVITED`
  - `ACTIVE`
  - `DISABLED`
  - `REMOVED`

Added model:

- `FundProjectParticipant`

Added relations:

- `Organization.fundProjectParticipants`
- `User.fundProjectParticipants`
- `FundProject.participants`

## 5. Migration Created

Migration path:

```text
prisma/migrations/20260625143000_add_fund_project_participants/migration.sql
```

SQL summary:

- creates `fund.FundProjectParticipantRole` enum;
- creates `fund.FundProjectParticipantStatus` enum;
- creates `fund.fund_project_participants`;
- adds unique/index coverage for tenant/project/user/email lookups;
- adds foreign keys to:
  - `public.organizations`;
  - `fund.fund_projects` using the same-tenant composite key;
  - `public.users` with `ON DELETE SET NULL`.

Confirmed:

- `db:push` was not used.
- Seed/reset commands were not used.

## 6. Tenant Scoping Strategy

Every participant row includes required `organizationId`.

The Project relation uses the existing same-tenant composite pattern:

```text
FundProjectParticipant.organizationId + projectId
  -> FundProject.organizationId + id
```

This prevents cross-tenant Project participant joins at the database relation level.

## 7. User Relation Strategy

`userId` is nullable.

Reason:

- C1 may know organiser email before the organiser has an account;
- future invitation/onboarding may create pending participants before a `User` exists;
- accepted invitations can later link `userId`.

The optional `User` relation was added with a named Prisma relation:

```text
FundProjectParticipantUser
```

This followed existing Prisma relation naming conventions cleanly, so no stop/report condition was triggered.

## 8. Access Semantics For Later Services

No runtime access checks were implemented in this schema-only slice.

Later C2 Project access must require:

```text
participant.organizationId = current tenant
participant.userId = currentUser.id
participant.status = ACTIVE
```

Pending email-only participants must not grant dashboard access.

`FundProjectParticipant.status` defaults to `INVITED` as a least-privilege schema default. Later C1 admin services must explicitly activate a participant before it grants access.

## 9. Relationship To Existing Organiser Fields

Existing Project organiser fields remain unchanged:

- `FundProject.organiserName`
- `FundProject.organiserEmail`
- `FundProject.organiserPhone`

They remain snapshots/contact details for display, records and future invitation defaults. They are not authoritative identity and must not be used for permission checks.

## 10. Indexes And Uniqueness Constraints

Added:

- `@@unique([organizationId, id])`
- `@@unique([organizationId, projectId, userId])`
- `@@index([organizationId, projectId, status])`
- `@@index([organizationId, userId, status])`
- `@@index([organizationId, email, status])`
- `@@index([organizationId, projectId, email])`

One-active-primary-per-Project is intentionally not database-enforced in this slice. That should be handled by later service logic unless a future slice explicitly approves a partial unique index strategy.

## 11. What Was Deliberately Not Implemented

This slice did not implement:

- runtime C2 access checks;
- routers;
- services;
- Zod schemas;
- tRPC endpoints;
- C2 dashboard UI;
- C1 participant management UI;
- organiser invitations;
- Project Request/onboarding;
- `FundOrganiserProfile`;
- Store schema;
- Orders;
- Commerce Core;
- payments;
- commissions;
- production batching;
- lifecycle engine;
- AI workflows.

## 12. Checks Run

- `npx prisma validate` - passed.
- `npm run db:generate` - passed.
- `npm run type-check` - passed.
- `npm run verify` - first sandboxed run failed because `tsx` could not create its local IPC pipe; rerun with approved escalation passed.
- `git diff --check` in app repo - passed.
- `git diff --check` in docs repo - passed.

## 13. Manual Verification Checklist

- Confirm Prisma schema validates.
- Confirm generated Prisma client includes `FundProjectParticipant`.
- Confirm migration SQL creates only the participant enums/table/indexes/FKs.
- Confirm no runtime C2 route/API/UI exists.
- Confirm organiser snapshot fields remain unchanged.
- Confirm same-tenant Project relation uses `organizationId + projectId`.
- Confirm no `db:push`, seed or reset command was used.

## 14. Risks / Follow-Ups

- `@@unique([organizationId, projectId, userId])` permits multiple rows with `userId = null` in PostgreSQL. Service logic must dedupe pending email-only participants.
- C2 access services must not accidentally grant access from `email` alone.
- Multi-C1 organiser identity remains deferred because current `User.organizationId` is single-tenant.
- One active primary organiser per Project should be service-enforced first.

## 15. Recommended Next Slice

Recommended next slice after review:

```text
Phase 1 Slice 1P-C - C2 Read-Only Project API/Services Planning
```

Do not implement C2 dashboard UI until participant-scoped read services are planned and reviewed.
