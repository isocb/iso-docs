# FUND Phase 1 Slice 1P-K1-F-B - Client Member User Link/Create Service Confirmation

Date: 2026-06-30

Status: Implemented on dev branch

## 1. Slice Goal

Allow C1 FUND admins to create or link a same-tenant platform `User` when adding or updating a FUND Client member, without sending any automatic email, invitation or notification.

This bridges the gap between:

```text
FundClientMember = Client organisation member/contact
User = login-capable platform identity
```

## 2. Implementation Summary

Implemented:

- C1 Client `Add User` now creates or links a platform `User` inside the same tenant.
- `FundClientMember.userId` is set to the linked/created `User.id`.
- If a same-tenant `User` already exists for the email, it is linked and made magic-link compatible.
- If no same-tenant `User` exists, a new platform `User` is created.
- Existing unlinked `FundClientMember` records are linked/created when edited and saved.
- No email, invitation, password reset, magic-link send, notification or communication template is triggered.

## 3. Platform User Defaults

Newly created platform Users use:

```text
role = MEMBER
status = ACTIVE
emailVerified = now()
organizationId = current C1 tenant
preferences.defaultModuleSlug = fund
```

The user is created without a communicated password. Login remains through the existing platform authentication flow, such as manually sharing the normal sign-in URL and allowing the user to request/use a magic link.

## 4. Same-Tenant Link Rules

When creating/linking:

- same-tenant existing Users may be linked;
- cross-tenant Users with the same email are rejected;
- suspended or GDPR delete-requested Users are rejected;
- linked/created Users are not emailed automatically;
- audit metadata records the platform user link/create outcome.

## 5. UI Behaviour

The C1 Client detail `Users` modal now explains that saving creates or links a same-tenant login account while still not sending email.

Default Add User values now favour a viable login-ready Client member:

```text
status = ACTIVE
accessLevel = VIEWER
dashboardAccessEnabled = true
```

C1 can still change those values before saving.

## 6. Explicitly Not Implemented

This slice did not implement:

- automatic onboarding email;
- invitation email;
- notification template;
- password reset email;
- public email content management;
- C2 Client dashboard UI;
- Client-owned Project creation;
- Store;
- Orders;
- Commerce;
- production;
- dispatch;
- Prisma schema changes;
- migrations.

## 7. Files Changed

App code:

- `src/modules/fund/services/client-members.service.ts`
- `src/modules/fund/lib/validation/client-members.ts`
- `src/modules/fund/components/clients/ClientDetailPage.tsx`

Documentation:

- `docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1p-k1-f-b-client-member-user-link-create-service-confirmation.md`

## 8. Checks

Passed during implementation:

```text
npx prisma validate
npm run db:generate
npm run type-check
npm run verify
git diff --check
docs git diff --check
```

`npm run verify` initially hit the known sandbox IPC restriction for `tsx`; it passed after rerunning outside the sandbox.

## 9. Recommended Next Slice

```text
1P-K2 - C2 Client Dashboard Read-Only Project View Planning
```

That slice can now rely on:

```text
authenticated User
-> active FundClientMember
-> FundClient
-> linked FundProjects
```
