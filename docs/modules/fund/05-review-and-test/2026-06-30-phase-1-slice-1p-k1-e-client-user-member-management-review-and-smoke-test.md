# FUND Phase 1 Slice 1P-K1-E - Client User/Member Management Review And Smoke Test

Date: 2026-06-30

Verdict: Proceed with caveat

## 1. Review Summary

Reviewed and smoke tested the K1-B/C/D Client user/member management batch.

The C1 management surface is working as intended:

- Client member schema exists;
- C1 Client member API/services are available;
- C1 Client detail page has top-level `Client Details`, `Projects` and `Users` tabs;
- C1 can create a Client member record from the `Users` tab;
- C1 Client member edit modal opens and displays correctly.

The remaining caveat is expected and must be planned before K2:

```text
Client member login/onboarding and post-auth routing are not implemented yet.
```

## 2. Scope Reviewed

Reviewed K1-B:

- Client member schema foundation;
- migration;
- same-tenant Client relation;
- optional platform User relation.

Reviewed K1-C:

- `fund.clients.members.list`;
- `fund.clients.members.get`;
- `fund.clients.members.create`;
- `fund.clients.members.update`;
- `fund.clients.members.archive`;
- `fund.clients.members.restore`.

Reviewed K1-D:

- `/app/fund/clients/[id]`;
- `Client Details` tab;
- `Projects` tab;
- `Users` tab;
- Client member create/edit modal.

## 3. Browser Smoke Test Results

User-confirmed browser smoke test:

- C1 Client detail route loaded.
- `Client Details` tab behaved as expected.
- `Projects` tab displayed as expected.
- `Users` tab displayed as expected.
- Add Client user/member modal displayed correctly.
- Client member creation succeeded after the dev database migration was applied.
- Client member review/edit modal opened correctly.

Observed before migration application:

```text
Invalid prisma.fundClientMember.create() invocation:
The table fund.fund_client_members does not exist in the current database.
```

Resolution:

- confirmed `fund.fund_client_members` was missing from the dev DB;
- applied the exact K1-B migration SQL;
- recorded the migration in `public._prisma_migrations` with matching checksum;
- verified `fund.fund_client_members` exists;
- verified Prisma schema validation passes.

No `db:push` was run.

No seed/reset commands were run.

## 4. Auth/Login Smoke Observation

Attempting to log in as the newly created Client member did not provide a working C2 Client dashboard route.

Observed route:

```text
/auth/error?error=Configuration
```

Assessment:

This is not a blocker for K1-B/C/D because those slices explicitly did not implement:

- platform User creation/provisioning;
- magic-link invitation/onboarding;
- Client member auth routing;
- C2 dashboard routes;
- C2 dashboard access guards.

However, it is a blocker for moving directly to K2 implementation.

The next planning slice must define how a C1-created Client member becomes login-capable and where they land after authentication.

## 5. Boundary Confirmation

K1-B/C/D correctly did not implement:

- platform User creation;
- password reset onboarding;
- magic-link sending;
- invitations;
- access emails;
- workflow notifications;
- notification templates;
- C2 Client dashboard;
- Client-owned Project creation;
- Store;
- Orders;
- Commerce;
- Sales/Reporting;
- production/artwork/dispatch workflows;
- SeasonPro integration.

## 6. Checks Confirmed

Implementation checks recorded across the K1-B/C/D batch:

```text
npx prisma validate
npm run db:generate
npm run type-check
npm run verify
git diff --check
docs git diff --check
```

Results:

- Prisma validation passed.
- Prisma client generation passed.
- TypeScript passed.
- Verify passed after the known sandbox `tsx` IPC rerun.
- App diff check passed.
- Docs diff check passed.

## 7. Defects / Follow-Ups

No K1-B/C/D functional blocker remains for C1 Client member management.

Required next planning before K2:

```text
1P-K1-F - Client Member Login/Onboarding And Auth Routing Planning
```

This should decide:

- whether C1 creates or links a platform `User`;
- how magic-link access is initiated;
- how onboarding remains separate from general notification workflows;
- how auth redirects route Client members to the future C2 dashboard;
- how the app handles a Client member with no dashboard route yet.

## 8. Recommendation

Do not proceed directly to K2 implementation.

Proceed to:

```text
1P-K1-F - Client Member Login/Onboarding And Auth Routing Planning
```

After K1-F is accepted, proceed to:

```text
1P-K2 - C2 Client Dashboard Read-Only Project View Planning
```
