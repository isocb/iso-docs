# FUND Phase 1 Slice 1P-K1-C - C1 Client User/Member API/Services Confirmation

Date: 2026-06-30

Status: Implemented

## 1. Slice Summary

Implemented tenant-scoped C1 API/services for managing FUND Client members from the future C1 Client detail `Users` tab.

This slice builds on the 1P-K1-B schema foundation and remains C1 admin only. It does not implement C2 dashboard access, UI, invitations, email sending or notification workflows.

## 2. Files Changed

App:

- `prisma/schema.prisma`
- `prisma/migrations/20260630120000_add_fund_client_members/migration.sql`
- `src/modules/fund/lib/validation/client-members.ts`
- `src/modules/fund/services/client-members.service.ts`
- `src/modules/fund/routers/clients.router.ts`

Documentation:

- `isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1p-k1-b-client-user-member-schema-foundation-confirmation.md`
- `isodocs/docs/modules/fund/05-review-and-test/2026-06-30-phase-1-slice-1p-k1-b-r1-client-user-member-schema-foundation-review.md`
- `isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1p-k1-c-c1-client-user-member-api-services-confirmation.md`

## 3. Procedures Added

Added nested C1 procedures under:

```text
fund.clients.members.*
```

Procedures:

- `list`;
- `get`;
- `create`;
- `update`;
- `archive`;
- `restore`.

All procedures:

- use `withFeature('fund')`;
- require `assertFundAdmin`;
- derive `organizationId` from actor/effective tenant context;
- never accept `organizationId` from client input.

## 4. Validation Added

Added `src/modules/fund/lib/validation/client-members.ts`.

Validation covers:

- Client-scoped list input;
- member get id;
- create input;
- update input;
- archive input;
- restore id input;
- email normalization;
- role/access/status fields;
- optional nullable contact fields.

The list endpoint requires `clientId`, preserving the C1 Client detail `Users` tab boundary.

## 5. Service Behaviour

Added `src/modules/fund/services/client-members.service.ts`.

Implemented:

- Client-scoped list with search, status filter, access-level filter and sorting;
- get by id within tenant;
- create member;
- update member;
- archive member;
- restore member;
- same-tenant Client validation;
- same-tenant platform `User` validation when `userId` is supplied;
- single-primary-member service enforcement;
- audit events.

Archive behaviour:

- sets status to `ARCHIVED`;
- disables dashboard access;
- sets `archivedAt`;
- does not delete the record.

Restore behaviour:

- restores status to `ACTIVE`;
- clears `archivedAt`;
- does not enable dashboard access automatically.

## 6. Audit Events

Added audit event writes for:

- `FUND_CLIENT_MEMBER_CREATED`;
- `FUND_CLIENT_MEMBER_UPDATED`;
- `FUND_CLIENT_MEMBER_STATUS_CHANGED`;
- `FUND_CLIENT_MEMBER_ACCESS_CHANGED`;
- `FUND_CLIENT_MEMBER_ARCHIVED`;
- `FUND_CLIENT_MEMBER_RESTORED`.

Audit metadata includes `noEmailSent: true` where relevant to preserve the explicit no-notification boundary.

## 7. Tenant And Access Guardrails

The implementation enforces:

- Client member operations are C1 admin only;
- Client member operations are tenant-scoped;
- `organizationId` is never accepted from input;
- `clientId` must belong to the actor tenant;
- archived Clients cannot have members created or updated;
- linked platform `User` must belong to the actor tenant;
- archived Client members cannot be edited until restored;
- status `ARCHIVED` must use the archive procedure rather than generic update;
- dashboard access cannot be enabled for non-active members or `NONE` access level.

The implementation does not grant C2 dashboard access. `dashboardAccessEnabled` remains a stored marker for future C2 dashboard slices.

## 8. Email, Invitation And Notification Boundary

No automatic email is sent when:

- a Client member is created;
- a Client member is linked to a platform `User`;
- a Client member is updated;
- access level changes;
- dashboard access is enabled/disabled;
- a member is archived;
- a member is restored.

No invitations are created.

No notification templates or notification triggers are implemented.

Onboarding/access communication remains a manual operational step until the future `1P-N0` notification/email lane is accepted.

## 9. Explicit Out Of Scope

This slice did not implement:

- C1 Client detail `Users` tab UI;
- C1 Client detail `Projects` tab UI;
- C2 Client dashboard;
- Client-owned Project creation;
- platform User creation;
- invitations;
- automatic email;
- notification sending;
- Store;
- Orders;
- Commerce;
- Sales/Reporting;
- production/artwork/dispatch workflows;
- SeasonPro integration.

No `db:push` was run.

No seed/reset commands were run.

## 10. Checks Run

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

Initial result: sandbox `tsx` IPC pipe error.

Resolution: reran outside the sandbox.

Final result: passed.

```text
git diff --check
```

Result: passed.

```text
docs git diff --check
```

Result: passed.

## 11. Risks And Follow-Ups

- UI must keep C1 Client member management separate from notification/invitation behaviour.
- Future API tests should cover same-tenant `User` linking and duplicate member conflicts.
- Primary member enforcement is service-level; consider a partial unique index only if needed later.
- C2 dashboard implementation must derive Client context through authenticated `User -> FundClientMember -> FundClient`.
- The next UI slice should confirm the table CRUD pattern: row click to edit, no row action icon clutter, and archive/restore in modal/detail action areas.

## 12. Recommended Next Slice

```text
1P-K1-D - C1 Client Detail Tabs: Details / Projects / Users UI
```

Goal:

```text
Add top-level Client detail tabs for Client Details, Projects and Users. Use the new C1 Client member procedures for the Users tab, and keep email/invitation/notification behaviour out of scope.
```
