# FUND Phase 1 Slice 1P-K1-F-A - Client Member Auth Routing And Access Policy Implementation Confirmation

Date: 2026-06-30

Status: Implemented on dev branch

## 1. Slice Goal

Add the smallest safe auth routing/access policy needed so authenticated FUND Client members do not land on P1/C1 surfaces before the C2 Client dashboard exists.

This implementation creates a controlled unavailable state only. It does not create a Client dashboard.

## 2. Implementation Summary

Implemented:

- active FUND Client member detection during authentication/session refresh;
- post-login `/welcome` routing for non-admin Client members;
- middleware guard for `/platform` and C1 FUND routes;
- dedicated unavailable route:

```text
/app/fund/client-unavailable
```

The unavailable page confirms that FUND Client member access is recognised, lists recognised Client access, and explains that the Client dashboard is not live yet.

## 3. Files Changed

App code:

- `src/server/auth/index.ts`
- `src/middleware.ts`
- `src/app/(app)/welcome/page.tsx`
- `src/app/(app)/app/fund/client-unavailable/page.tsx`
- `src/modules/fund/lib/client-member-routing.ts`
- `src/modules/fund/services/client-member-auth.service.ts`

Documentation:

- `docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1p-k1-f-a-client-member-auth-routing-and-access-policy-confirmation.md`

## 4. Routing Behaviour

For authenticated users with an active same-tenant `FundClientMember` and access level other than `NONE`:

```text
/welcome
-> /app/fund/client-unavailable
```

If a non-admin Client member attempts to reach:

```text
/platform
/app/fund
/app/fund/*
```

then middleware redirects them to:

```text
/app/fund/client-unavailable
```

C1/P1 users are not redirected by this guard.

## 5. Access Rules Used

Client member recognition requires:

- linked platform `User`;
- same tenant `organizationId`;
- `FundClientMember.status = ACTIVE`;
- `FundClientMember.accessLevel != NONE`;
- `FundClientMember.dashboardAccessEnabled = true`;
- member not archived;
- linked `FundClient.status = ACTIVE`;
- linked Client not archived.

This implementation does not infer access from primary contact snapshots, respondent email, organiser snapshots or hidden public form fields.

## 6. Explicitly Not Implemented

This slice did not implement:

- email sending;
- invitations;
- platform User creation;
- password reset onboarding;
- magic-link onboarding;
- notification templates;
- C2 Client dashboard UI;
- Client-owned Project creation;
- Store;
- Orders;
- Commerce;
- production;
- dispatch;
- SeasonPro integration;
- Prisma schema changes;
- migrations.

## 7. Checks Run

Passed:

```text
npx prisma validate
npm run db:generate
npm run type-check
npm run verify
git diff --check
```

`npm run verify` initially hit the known sandbox IPC restriction for `tsx`; it passed after rerunning outside the sandbox.

## 8. Follow-Up

Recommended next slice:

```text
1P-K1-F-B - Client Member User Link/Create Service Planning
```

That slice should decide whether C1 can create/link platform Users for Client members manually before the notification/email lane exists.

Then proceed to:

```text
1P-K2 - C2 Client Dashboard Read-Only Project View Planning
```
