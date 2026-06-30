# FUND Phase 1 Slice 1P-K1-B - Client User/Member Schema Foundation Confirmation

Date: 2026-06-30

Status: Implemented - schema only

## 1. Slice Summary

Implemented the schema foundation for FUND Client users/members.

This creates the data structure needed for future C1 Client detail `Users` management and later C2 Client dashboard access, without implementing services, routers, UI, invitations, notifications or dashboard behaviour.

## 2. Files Changed

App/schema:

- `prisma/schema.prisma`
- `prisma/migrations/20260630120000_add_fund_client_members/migration.sql`

Documentation:

- `isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1p-k1-b-client-user-member-schema-foundation-confirmation.md`

## 3. Migration

Migration created:

```text
20260630120000_add_fund_client_members
```

The migration adds:

- `fund.FundClientMemberStatus`;
- `fund.FundClientMemberAccessLevel`;
- `fund.fund_client_members`.

No existing records are backfilled.

No Client members are inferred from:

- `FundClient.primaryContactEmail`;
- `FundClient.primaryContactName`;
- `FundProject.organiserEmail`;
- `FundProjectParticipant.email`;
- Project Intake respondent email.

## 4. Schema Added

New enums:

```text
FundClientMemberStatus:
- DRAFT
- ACTIVE
- INACTIVE
- ARCHIVED

FundClientMemberAccessLevel:
- NONE
- VIEWER
- PROJECT_MANAGER
- ADMIN
```

New model:

```text
FundClientMember
```

The model includes:

- tenant boundary through `organizationId`;
- same-tenant Client relation through `clientId`;
- optional platform `User` relation through `userId`;
- first name, last name, display name, email and phone;
- role label;
- access level;
- status;
- primary marker;
- dashboard access enabled marker;
- last accessed timestamp;
- archive timestamp;
- created/updated audit ids and timestamps.

## 5. Relations

Added:

- `Organization.fundClientMembers`;
- `User.fundClientMembers`;
- `FundClient.members`;
- `FundClientMember.organization`;
- `FundClientMember.client`;
- `FundClientMember.user`.

The `FundClientMember.client` relation uses the existing FUND same-tenant pattern:

```text
fields: [organizationId, clientId]
references: [organizationId, id]
```

The platform `User` relation is optional and uses `onDelete: SetNull` so the Client member/contact record can remain as operational context if a user identity is later removed.

## 6. Indexes And Constraints

Added tenant-scoped constraints and indexes for:

- same-tenant id lookup;
- Client/email uniqueness;
- Client/user uniqueness;
- Client/status filtering;
- User/status lookup;
- email/status lookup;
- dashboard access filtering;
- archived records.

Nullable `userId` behaviour remains bounded to schema foundation only. Service slices must still enforce same-tenant linked User checks before assigning `userId`.

## 7. Boundary Confirmations

This slice did not implement:

- application services;
- routers;
- Zod schemas;
- UI;
- C1 Client detail tabs;
- C2 Client dashboard;
- Client-owned Project creation;
- platform User creation;
- invitations;
- email sending;
- notifications;
- Store;
- Orders;
- Commerce;
- Sales/Reporting;
- production/artwork/dispatch workflows;
- SeasonPro integration.

No `db:push` was run.

No seed or reset commands were run.

## 8. Checks Run

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

Initial result: failed because stale `.next/types` still referenced the previously moved public Project initiation route.

Resolution: removed generated `.next` build artifacts only, then reran type-check.

Final result: passed.

```text
npm run verify
```

Initial result: sandbox `tsx` IPC pipe error.

Resolution: reran outside the sandbox.

Final result: passed.

```text
git diff --check
```

Result: passed.

## 9. Risks And Follow-Ups

- Service implementation must enforce that linked platform `User.organizationId` matches `FundClientMember.organizationId`.
- C1 API/services must not send automatic invitations or email.
- C1 UI must treat member creation/linking as data/access management only until `1P-N0` notification/email planning is accepted.
- Primary member behaviour should be enforced in services or through a later partial unique index if needed.
- C2 dashboard access must derive Client context from authenticated `User -> FundClientMember -> FundClient`, not from input or email inference.

## 10. Recommended Next Slice

```text
1P-K1-C - C1 Client User/Member API/Services
```

Goal:

```text
Implement tenant-scoped C1 API/services for listing, creating, updating, archiving and restoring Client members from the C1 Client detail Users tab, without invitations, email, notifications or C2 dashboard behaviour.
```
