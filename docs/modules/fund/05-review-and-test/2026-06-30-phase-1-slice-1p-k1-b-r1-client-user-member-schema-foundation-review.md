# FUND Phase 1 Slice 1P-K1-B-R1 - Client User/Member Schema Foundation Review

Date: 2026-06-30

Verdict: Proceed

## 1. Review Summary

Reviewed the 1P-K1-B schema-only implementation for FUND Client users/members.

The implementation is safe to build on for C1 Client user/member API/services because it adds a bounded FUND-specific Client member model without introducing application behaviour, invitations, email sending, notifications or C2 dashboard access.

## 2. Files Reviewed

App/schema:

- `prisma/schema.prisma`
- `prisma/migrations/20260630120000_add_fund_client_members/migration.sql`

Documentation:

- `isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1p-k1-b-client-user-member-schema-foundation-confirmation.md`
- `isodocs/docs/modules/fund/03-slice-planning/2026-06-30-fund-phase-1-slice-1p-k1-a-client-user-member-schema-options-planning.md`

## 3. Assessment

The schema implements the selected K1-A option:

```text
FundClientMember = FUND-specific Client/account member record
```

The model remains separate from:

- `FundProjectParticipant`, which is Project-scoped;
- platform `User`, which is an authenticated identity but not sufficient to prove Client/account membership;
- `FundClient` primary contact snapshots, which remain C1 operational display fields only.

The schema correctly supports:

- same-tenant Client relation;
- optional platform User relation;
- role label distinct from access level;
- status;
- primary marker;
- dashboard access marker;
- archive marker;
- tenant-scoped lookup/index patterns.

## 4. Boundary Confirmation

The reviewed slice does not implement:

- routers;
- services;
- Zod schemas;
- UI;
- C1 Client detail tabs;
- C2 Client dashboard;
- Client-owned Project creation;
- platform User creation;
- invitations;
- email sending;
- notifications;
- Store, Orders, Commerce, Sales/Reporting;
- production/artwork/dispatch;
- SeasonPro integration.

No `db:push` was run.

No seed/reset commands were run.

## 5. Checks Confirmed

The implementation confirmation records:

```text
npx prisma validate
npm run db:generate
npm run type-check
npm run verify
git diff --check
```

Results:

- Prisma validation passed.
- Prisma client generation passed.
- TypeScript passed after clearing stale generated `.next` route artifacts.
- Verify passed after rerunning outside the sandbox due the known `tsx` IPC pipe restriction.
- `git diff --check` passed.

## 6. Caveats

- API/services must enforce that any linked platform `User` belongs to the same tenant as the `FundClientMember`.
- UI/services must not infer members from primary contact snapshots, Project organiser snapshots or public respondent email.
- `dashboardAccessEnabled` is a stored marker only until C2 dashboard access rules are implemented.
- No automatic onboarding email should be sent when a member is created, linked, updated, archived or restored.
- Primary member uniqueness should be enforced in services initially unless a later schema slice introduces a partial unique index.

## 7. Recommendation

Proceed to:

```text
1P-K1-C - C1 Client User/Member API/Services
```

Scope:

```text
Implement tenant-scoped C1 API/services for listing, creating, updating, archiving and restoring Client members from the C1 Client detail Users tab, without invitations, email, notifications or C2 dashboard behaviour.
```
