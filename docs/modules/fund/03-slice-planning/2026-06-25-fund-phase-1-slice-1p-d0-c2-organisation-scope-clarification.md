# FUND Phase 1 Slice 1P-D0 - C2 Organisation Scope Clarification

Date: 2026-06-25

Status: Architecture clarification / planning only

## 1. Purpose

Record the post-implementation C2 architecture clarification raised after Slice 1P-D.

Slice 1P-D implemented a safe read-only C2 organiser dashboard using direct participant-scoped Project access:

```text
User -> FundProjectParticipant -> FundProject
```

This should be treated as an interim bridge until the C2 organisation/account model is decided.

## 2. Current 1P-D Implementation State

1P-D created:

- `/app/fund/organiser`
- `/app/fund/organiser/projects/[id]`

1P-D consumes only:

- `fund.organiser.projects.list`
- `fund.organiser.projects.get`

1P-D does not use C1 admin Project endpoints for organiser pages.

1P-D does not implement:

- C2 mutations;
- invitations;
- participant management;
- Store;
- Orders;
- Commerce Core;
- schema changes;
- migrations.

The `/app/fund` route remains the C1 admin home and includes a muted organiser navigation card. The context switch is navigation only and does not introduce impersonation or server-side role switching.

## 3. Wider C1/C2 Operating Model

The broader model is likely not simply "user assigned to Project".

SeasonPro already points toward a C1/C2 operating structure:

```text
C1 League Tenant
-> C2 Club
-> Teams
-> Club users
```

FUND likely needs a parallel structure:

```text
C1 Producer/Admin Tenant
-> C2 Fundraising Organisation / School / Club / PTA / Customer Account
-> Projects
-> C2 users
-> future Project sales/orders/reporting
```

Integrated SeasonPro + FUND may share the C2 node:

```text
C1 League Tenant
-> C2 Club
-> Teams
-> Club users
-> Fundraising Projects
-> future Project sales/orders/reporting
```

In integrated mode, a SeasonPro Club may be the fundraising Project creator/account. In standalone FUND, the equivalent C2 entity may be a school, PTA, charity branch, sports club or fundraising organiser/customer account.

## 4. Options To Decide

### Option A - Continue With Direct Project Participants

Use `FundProjectParticipant` as the MVP and long-term access model.

Pros:

- already implemented;
- Project-scoped;
- simple to reason about for read-only access;
- avoids new schema work immediately.

Cons:

- does not naturally model C2 organisations;
- may require repeated participant rows across Projects;
- does not answer future C2 organisation sales/reporting/account questions.

### Option B - FUND-Specific C2 Organisation / Account Model

Introduce a FUND-specific C2 organisation/account layer.

Pros:

- fits standalone FUND;
- supports Projects owned by schools, PTAs, clubs or customer accounts;
- can scope future sales/orders/reporting to the C2 organisation.

Cons:

- may duplicate SeasonPro Club concepts;
- may need later abstraction if other modules need the same pattern.

### Option C - Reusable IsoStack C2 Organisation / Account Model

Plan a reusable core C2 account model shared by SeasonPro, FUND and future modules.

Pros:

- strongest platform architecture;
- avoids module-specific duplication;
- supports multi-module customer/account surfaces.

Cons:

- larger scope;
- may delay practical FUND dashboard progress;
- requires careful migration/integration with existing SeasonPro Club concepts.

### Option D - Hybrid Model

Use C2 organisation/account ownership for Projects and retain `FundProjectParticipant` for narrower Project-level access.

Recommended direction to evaluate.

Possible shape:

```text
C2 organisation owns Projects.
C2 users belong to the C2 organisation.
Active C2 organisation users can see organisation-scoped Projects.
FundProjectParticipant remains useful for named Project contacts, Project role overrides, temporary access bridges and finer-grained exceptions.
```

This keeps the current participant work useful while avoiding overfitting the long-term dashboard to direct Project assignment only.

## 5. Key Questions

### C2 User Hierarchy

Does the first C2 model treat all active C2 users as peers, or does it need roles inside the C2 organisation?

Possible minimal answer:

```text
First C2 organisation users may be peers for read-only access, with role expansion planned later.
```

### Organisation-Wide Project Visibility

Should any active C2 user in a C2 organisation see all Projects owned by that C2 organisation?

This is likely necessary for:

- club admins;
- school/PTA administrators;
- customer account managers;
- future sales/order reporting.

But it may be too broad for temporary contacts or named Project helpers, where `FundProjectParticipant` remains useful.

### Future Sales / Orders / Reporting Scope

Future Store, Order, sales and reporting work should probably scope to the C2 organisation/account, not only to individual participant assignments.

Important future question:

```text
Are sales reports shown per Project, per C2 organisation, or both?
```

### FundProjectParticipant Future Role

`FundProjectParticipant` may remain useful as:

- temporary access bridge;
- named Project contact;
- per-Project role override;
- finer-grained exception access;
- transition model while C2 organisation/account scope is introduced.

It should not be assumed to replace C2 organisation membership until this is explicitly decided.

### Reusable Core Model

If SeasonPro and FUND both need C2 organisations, a generic IsoStack C2 organisation/account model may be better than a FUND-only table.

This should be decided before deep Store/Commerce work.

### Hat-Swapping Users

Users may be:

- C1 admin only;
- C2 organisation user only;
- both C1 admin and C2 organisation user;
- participant on a specific Project.

The UI should continue to use explicit context navigation. The context switch must not bypass server-side access rules.

### Route Naming

`/app/fund/organiser` remains acceptable as the interim read-only route.

If C2 access becomes organisation scoped, route naming should be reviewed. Possible future alternatives:

- `/app/fund/organiser`
- `/app/fund/account`
- `/app/fund/customer`
- `/app/fund/organisation`

Recommendation:

```text
Keep /app/fund/organiser for 1P-D review. Revisit naming only when the C2 organisation/account model is planned.
```

## 6. Impact On 1P-D

1P-D was implemented before this clarification was raised.

The implementation is safe because it is:

- read-only;
- participant-scoped;
- additive;
- not powered by C1 admin Project endpoints;
- free of mutations, invitations, participant management, Store, Orders or Commerce work.

1P-D can remain as an interim dashboard while C2 organisation/account modelling is decided.

## 7. Work That Must Pause

Do not continue into the following until the C2 organisation/account model is decided:

- C2 mutations;
- C2 participant management UI;
- organiser invitations;
- Project Request/onboarding;
- C2 sales/order/reporting views;
- Store generation;
- Orders;
- Commerce Core coupling;
- C2 organisation settings/profile surfaces.

## 8. Safest Next Sequence

Recommended sequence:

1. `1P-D-R1` - review implemented C2 read-only organiser dashboard UI.
2. `1P-D0` - decide C2 organisation/account scope.
3. `1P-D1` or `1P-F` - plan C2 organisation/account model if required.
4. Only then continue with participant management, invitations, C2 mutations, Store, Orders, sales or reporting.

## 9. Recommendation

Proceed with 1P-D review, but mark the dashboard as interim.

Further C2 expansion should pause until the C2 organisation/account scope is resolved.

The likely long-term direction is a hybrid:

```text
C2 organisation/account owns Projects.
C2 users belong to that organisation/account.
FundProjectParticipant remains for Project contacts, overrides, exceptions and transition access.
```
