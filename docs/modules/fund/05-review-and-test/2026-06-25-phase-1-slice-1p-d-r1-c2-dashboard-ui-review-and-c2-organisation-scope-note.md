# FUND Phase 1 Slice 1P-D-R1 - C2 Dashboard UI Review And C2 Organisation Scope Note

Date: 2026-06-25

Status: Review/scope note pending authenticated browser testing

## 1. Review Context

Slice 1P-D was implemented before the C2 organisation/account clarification was raised.

1P-D implemented:

- `/app/fund/organiser`
- `/app/fund/organiser/projects/[id]`

The implementation consumes only:

- `fund.organiser.projects.list`
- `fund.organiser.projects.get`

It does not use C1 admin Project endpoints for organiser pages.

## 2. Safety Assessment

The 1P-D implementation remains safe as an interim dashboard because it is:

- read-only;
- participant-scoped;
- additive;
- bounded to existing 1P-C organiser endpoints;
- free of C2 mutation controls;
- free of C1 participant management;
- free of invitations, Project Request/onboarding, Store, Orders and Commerce work;
- not a schema or migration slice.

## 3. Interim Model

Current implemented model:

```text
User -> FundProjectParticipant -> FundProject
```

This provides direct participant-scoped Project visibility.

It does not yet answer whether the final FUND C2 model should be organisation/account-scoped.

## 4. C2 Organisation Scope Note

The wider model may need to become:

```text
C1 Producer/Admin Tenant
-> C2 Fundraising Organisation / School / Club / PTA / Customer Account
-> Projects
-> C2 users
```

For SeasonPro integration, the C2 organisation may already exist conceptually as:

```text
C1 League Tenant
-> C2 Club
-> Teams
-> Club users
-> Fundraising Projects
```

Therefore, 1P-D should not be treated as the final C2 model. It should be treated as a safe interim bridge.

## 5. Review Requirements For 1P-D

Authenticated browser review should confirm:

- assigned active participant Projects appear;
- unassigned Projects do not appear;
- INVITED/DISABLED/REMOVED/null-user participants do not grant access;
- organiserEmail alone does not grant access;
- C2 Project detail is read-only;
- no mutation, invitation, participant management, Store, Order or Commerce controls are visible;
- dual-role context switch is navigation only;
- C1 `/app/fund` remains the admin home;
- `/app/fund/organiser` remains distinct from C1 `/app/fund/projects`.

## 6. Scope Hold

Further C2 dashboard expansion should pause before adding:

- C2 mutations;
- participant management UI;
- organiser invitations;
- Project Request/onboarding;
- sales/order/reporting views;
- Store;
- Orders;
- Commerce Core coupling.

These need the C2 organisation/account decision first.

## 7. Recommendation

Proceed with 1P-D-R1 authenticated review.

If no concrete defect is found, keep 1P-D as a read-only interim participant-scoped dashboard.

Then complete a C2 organisation/account scope planning slice before implementing any write-capable or commercially meaningful C2 surface.
