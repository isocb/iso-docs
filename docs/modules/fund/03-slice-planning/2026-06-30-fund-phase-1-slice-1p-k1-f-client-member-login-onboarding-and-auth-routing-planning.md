# FUND Phase 1 Slice 1P-K1-F - Client Member Login/Onboarding And Auth Routing Planning

Date: 2026-06-30

Status: Planning

## 1. Slice Goal

Plan how a C1-managed FUND Client member becomes a login-capable C2 user and how authentication routes them into the correct future Client dashboard.

This slice exists before:

```text
1P-K2 - C2 Client Dashboard Read-Only Project View Planning
```

K1-B/C/D created the Client member schema, C1 API/services and C1 Users tab. K1-F defines the missing login/onboarding and routing policy before any C2 dashboard implementation.

This is planning only. It does not implement application code, schema changes, migrations, email sending, invitations, notification templates, C2 dashboard UI, Store, Orders, Commerce or production workflows.

## 2. Current State

Current implemented state:

- `FundClientMember` exists as a Client/account member record.
- `FundClientMember.userId` may optionally link to a platform `User`.
- C1 can create and manage Client members from the Client detail `Users` tab.
- The UI clearly states that no email, invitation or platform user is created.

Current expected limitation:

```text
Creating a Client member does not make that person login-capable.
```

Observed smoke test:

```text
/auth/error?error=Configuration
```

This confirms that auth routing/onboarding is not yet planned for Client members.

## 3. Product Position

Client members are people linked to a FUND Client organisation/account.

Some Client members may only be contacts.

Some Client members may later become authenticated C2 users who can access the Client dashboard.

These are separate states:

```text
Client member/contact record
Linked platform User
Dashboard access enabled
Magic-link/onboarding available
C2 dashboard route available
```

Do not treat creation of a Client member as automatic creation of all later states.

## 4. Required Future Flow

Recommended future flow:

```text
C1 creates or links Client member
-> C1 explicitly enables dashboard access
-> platform User is created or linked according to accepted policy
-> magic-link/onboarding email is initiated according to accepted policy
-> user authenticates
-> auth routing resolves User -> FundClientMember -> FundClient
-> user lands on C2 Client dashboard
```

Until the C2 dashboard route exists, authenticated Client members should not be routed to `/platform` or any P1/C1 dashboard by default.

## 5. User Creation / Link Policy

K1-F should decide one of these policies:

### Option A - Link Existing User Only First

C1 can link a Client member to an existing same-tenant `User`.

Pros:

- smallest behaviour;
- avoids accidental user provisioning;
- keeps email out of scope.

Cons:

- does not solve onboarding new Client users.

### Option B - Create Platform User Without Sending Email

C1 can create a platform `User` in a pending/passwordless-compatible state and link it to `FundClientMember`, but no email is sent automatically.

Pros:

- supports manual onboarding;
- keeps notification sending explicit;
- avoids deprecated password reset behaviour.

Cons:

- requires careful auth/user-state policy.

### Option C - Create User And Queue/Send Magic Link

C1 creates/links the platform `User` and triggers a magic-link/onboarding email.

Pros:

- complete admin workflow.

Cons:

- should wait for notification/email planning unless treated as a narrow authentication exception;
- must not use deprecated password reset emails;
- requires default recipient/content/pause policy.

Recommended first implementation direction:

```text
Option B, if platform User creation is needed before the notification lane:
create/link the User without automatic email, then keep onboarding communication manual.
```

## 6. Email And Notification Boundary

No password reset email should be used for Client member onboarding.

Password reset is deprecated in favour of magic link/passkey style access.

No general workflow email should be sent from Client member creation or access changes until:

```text
1P-N0 - FUND System Notifications And Editable Email Defaults Planning
```

K1-F may allow a narrow hard-coded authentication exception only if required for magic-link authentication, but the preferred near-term rule remains:

```text
manual onboarding/access communication until the notification lane is accepted.
```

Any future email must use trusted branding fallback:

```text
Client/Event/tenant context where available
-> FUND module branding
-> IsoStack/platform branding
```

## 7. Auth Routing Policy

Future auth routing must avoid sending C2 Client users to:

- `/platform`;
- P1 dashboards;
- C1 FUND admin dashboards;
- unrelated modules.

Recommended routing resolution:

```text
authenticated User
-> find active same-tenant FundClientMember records
-> require dashboardAccessEnabled
-> require accessLevel != NONE
-> if one Client membership, route to /app/fund/client
-> if multiple Client memberships, route to Client switcher/context selection
-> if no valid membership, show access unavailable state
```

The final route name may be decided in K2, for example:

```text
/app/fund/client
/app/fund/client/projects
/app/fund/client/projects/[id]
```

Do not rely on email matching alone for Client ownership.

## 8. Access Guardrails

Required guardrails:

- derive Client context from authenticated `User -> FundClientMember -> FundClient`;
- require same-tenant membership;
- require member status `ACTIVE`;
- require `dashboardAccessEnabled = true`;
- require access level other than `NONE`;
- ignore archived members;
- ignore archived Clients;
- never accept `clientId` from untrusted input as proof of access;
- never infer Client ownership from respondent email, organiser snapshots or hidden fields.

## 9. Login Error Handling

Until C2 routing exists, the app should avoid confusing Client members with a generic configuration error where possible.

Future behaviour should provide a branded, useful message such as:

```text
Your account exists, but Client dashboard access is not available yet.
Please contact your fundraising provider.
```

This error handling should not expose whether arbitrary emails belong to Client accounts.

## 10. Relationship To K2

K2 should not implement dashboard views until K1-F has decided:

- route path;
- auth guard;
- user/member link policy;
- dashboard access eligibility;
- unavailable-state handling;
- onboarding/email boundary.

K2 can then implement read-only Project view using:

```text
authenticated User
-> active FundClientMember
-> FundClient
-> linked FundProjects
```

## 11. Implementation Split Recommendation

Recommended next implementation split:

```text
1P-K1-F-A - Client Member Auth Routing And Access Policy Implementation
1P-K1-F-B - Client Member User Link/Create Service Planning
1P-K2 - C2 Client Dashboard Read-Only Project View Planning
```

If the team wants to defer platform User creation completely, K1-F-A may only implement safe routing/unavailable states and leave User creation to K1-F-B.

## 12. Explicit Non-Goals

This planning slice does not implement:

- app code;
- Prisma schema changes;
- migrations;
- platform User creation;
- magic-link email sending;
- invitation emails;
- notification templates;
- C2 dashboard UI;
- Client-owned Project creation;
- Store;
- Orders;
- Commerce;
- Sales/Reporting;
- production/artwork/dispatch workflows;
- SeasonPro integration.

## 13. Recommended Next Slice

```text
1P-K1-F-A - Client Member Auth Routing And Access Policy Implementation
```

Implementation goal:

```text
Add the smallest safe auth routing/access policy needed so authenticated Client members do not land on P1/C1 surfaces and receive a clear unavailable state until the C2 Client dashboard exists.
```

Do not implement email, invitations, platform User creation, C2 dashboard UI or Client-owned Project creation in K1-F-A.
