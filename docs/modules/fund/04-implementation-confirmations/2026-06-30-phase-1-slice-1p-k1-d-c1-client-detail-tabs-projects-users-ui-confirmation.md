# FUND Phase 1 Slice 1P-K1-D - C1 Client Detail Tabs: Details / Projects / Users UI Confirmation

Date: 2026-06-30

Status: Implemented

## 1. Slice Summary

Implemented the C1 Client detail tabbed management surface.

The Client detail route now exposes top-level tabs:

```text
Client Details
Projects
Users
```

The `Users` tab uses the new C1 Client member API/services from 1P-K1-C. The implementation does not create platform users, send invitations, send emails or expose C2 dashboard behaviour.

## 2. Route

Updated existing route:

```text
/app/fund/clients/[id]
```

No new routes were created.

## 3. Files Changed

App:

- `prisma/schema.prisma`
- `prisma/migrations/20260630120000_add_fund_client_members/migration.sql`
- `src/modules/fund/lib/validation/client-members.ts`
- `src/modules/fund/services/client-members.service.ts`
- `src/modules/fund/routers/clients.router.ts`
- `src/modules/fund/components/clients/ClientDetailPage.tsx`

Documentation:

- `isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1p-k1-b-client-user-member-schema-foundation-confirmation.md`
- `isodocs/docs/modules/fund/05-review-and-test/2026-06-30-phase-1-slice-1p-k1-b-r1-client-user-member-schema-foundation-review.md`
- `isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1p-k1-c-c1-client-user-member-api-services-confirmation.md`
- `isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1p-k1-d-c1-client-detail-tabs-projects-users-ui-confirmation.md`

## 4. Endpoints Used

Existing Client detail/profile:

- `fund.clients.get`
- `fund.clients.update`
- `fund.clients.archive`
- `fund.clients.restore`

New Client member procedures:

- `fund.clients.members.list`
- `fund.clients.members.create`
- `fund.clients.members.update`
- `fund.clients.members.archive`
- `fund.clients.members.restore`

No public endpoints are used.

No C2 organiser/client dashboard endpoints are used.

## 5. Client Details Tab

The previous Client profile edit surface now lives under:

```text
Client Details
```

It preserves:

- profile editing;
- primary contact snapshot editing;
- internal notes;
- archive/restore actions;
- archived Client read-only behaviour.

The tab continues to state that primary contact fields are operational snapshots, not user accounts or access control.

## 6. Projects Tab

The linked Projects section now lives under:

```text
Projects
```

Behaviour:

- table of Projects linked through `FundProject.clientId`;
- fuzzy search;
- status filter;
- column-header sorting;
- row click opens `/app/fund/projects/[id]`;
- no row action icon clutter.

No Project Client selector/linkage changes were implemented.

No Project mutation endpoints are used from this tab.

## 7. Users Tab

Added:

```text
Users
```

Behaviour:

- table of Client member records;
- fuzzy search;
- status filter;
- column-header sorting;
- row click opens edit modal;
- add user/member action in the tab header;
- archive/restore actions inside the edit modal action area.

Displayed fields include:

- name;
- email/phone;
- role label;
- access level;
- dashboard access marker;
- status;
- platform User link state;
- updated date.

Create/edit fields include:

- first name;
- last name;
- display name;
- email;
- phone;
- role label;
- access level;
- status;
- primary Client contact marker;
- dashboard access enabled marker.

## 8. Email, Invitation And Notification Boundary

The Users tab explicitly states that Client users are member/contact records for future C2 access.

The UI does not:

- create platform users;
- send invitations;
- send access emails;
- send notifications;
- trigger workflow email;
- expose notification templates.

Success messages also confirm that no email was sent.

Onboarding/access communication remains a manual operational step until the dedicated FUND notification/email lane is accepted.

## 9. C2 Dashboard Boundary

The UI does not implement:

- C2 Client dashboard;
- Client dashboard routing;
- Client-owned Project creation;
- login provisioning;
- authenticated Client context resolution.

`dashboardAccessEnabled` is shown only as a stored future-access marker.

## 10. UI Standard Compliance

Implemented using current FUND admin patterns:

- muted operational styling;
- top-level tabs for distinct Client account areas;
- table CRUD pattern with row click;
- no row edit/delete/archive icon buttons;
- action buttons in tab/modal action areas;
- loading, empty and error states;
- semantic colour only for status/action meaning;
- archive/restore remains in explicit action areas.

## 11. Explicit Out Of Scope

This slice did not implement:

- Project Client selector/linkage changes;
- Project create/edit changes;
- platform User creation;
- Client invitations;
- email sending;
- notifications;
- C2 dashboard;
- C2 mutations;
- Client-owned Project creation;
- Store;
- Orders;
- Commerce;
- Sales/Reporting;
- production/artwork/dispatch workflows;
- SeasonPro integration.

No `db:push` was run.

No seed/reset commands were run.

## 12. Checks Run

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

Earlier in the same K1-B/K1-C implementation batch:

```text
npx prisma validate
npm run db:generate
```

Result: passed.

## 13. Risks And Follow-Ups

- Browser smoke testing should confirm the tab layout, Users table filtering/sorting, create/edit modal, archive/restore flow and no-email messaging.
- Future API tests should cover same-tenant linked platform User validation and duplicate member conflict cases.
- The next C2 dashboard slice must derive access through authenticated `User -> FundClientMember -> FundClient`.
- Notification/email behaviour must remain deferred to the future `1P-N0` lane.

## 14. Recommended Next Slice

```text
1P-K1-D-R1 - C1 Client Detail Tabs And Users UI Review
```

After review, proceed to:

```text
1P-K1-F - Client Member Login/Onboarding And Auth Routing Planning
```

K1-F must be accepted before:

```text
1P-K2 - C2 Client Dashboard Read-Only Project View Planning
```
