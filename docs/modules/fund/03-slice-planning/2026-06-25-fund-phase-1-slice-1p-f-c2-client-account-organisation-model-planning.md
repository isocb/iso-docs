# FUND Phase 1 Slice 1P-F - C2 Client/Account Organisation Model Planning

Date: 2026-06-25

Status: Planning only / architecture decision required

## 1. Slice Goal

Plan the long-term C2 Client/account organisation model before any further C2 dashboard expansion.

The current 1P-D dashboard is safe as a read-only participant-scoped interim dashboard, but it must not become the final C2 operating model by accident.

## 2. Current Interim Model

Current implemented access model:

```text
User
-> FundProjectParticipant
-> FundProject
```

This is safe for:

- read-only assigned Project list;
- read-only assigned Project detail;
- transition access while the C2 Client/account model is decided.

It is not sufficient as the long-term operating model for C2 clients, users, sales, reporting, communications or account-level administration.

## 3. Target Operating Model

Likely long-term FUND model:

```text
C1 tenant/admin organisation
-> C2 Client / Account organisation
-> C2 users
-> Projects
-> future Orders / Sales / Reporting
-> future Communications / Announcements
-> future automation via key dates
```

`Client` is the likely user-facing/admin term for C2 organisation/account.

In FUND, a Client may be:

- school;
- club;
- PTA;
- charity branch;
- fundraising organisation;
- customer account.

## 4. SeasonPro Precedent

SeasonPro already models a C1/C2 operating structure:

```text
C1 League
-> C2 Club
-> Club users
-> Teams
-> processes
-> communications
-> key-date automation
```

In SeasonPro:

- C1 League dashboard manages users, roles, Clubs, Teams, processes, communications and automation.
- Clubs are effectively C2 client organisations.
- Teams belong to Clubs.
- Key dates act as an organisational automation layer.
- Positive/negative offsets can trigger communications, announcements or dashboard-visible messages.

## 5. FUND Parallel

FUND should likely mirror the C1/C2 pattern:

```text
C1 Producer/Admin tenant
-> C2 Client / Account
-> C2 users
-> Projects
-> future Orders / Sales / Reporting
-> future dashboard announcements and communications
```

Projects belong to C2 Clients in the same broad way that Teams belong to Clubs in SeasonPro.

Future Orders, sales, reporting, communications and announcements should likely scope to the C2 Client/account, not just to individual Project participants.

## 6. Integrated SeasonPro + FUND

In integrated SeasonPro + FUND:

```text
C1 League
-> C2 Club
-> Teams
-> Club users
-> Fundraising Projects
-> future Project sales / Orders / Reporting
```

A SeasonPro Club may also be the FUND fundraising Client/account and Project creator.

Planning must avoid duplicating Club/Client concepts in a way that makes integrated SeasonPro + FUND awkward.

## 7. Core Question

Should IsoStack introduce a reusable C2 Client/account model, or should FUND implement a FUND-specific Client/account model first?

This decision affects:

- C2 dashboard;
- C1 Client management;
- C2 user access;
- Project ownership;
- future Store/Order ownership;
- reporting scope;
- communications/announcements;
- SeasonPro integration.

## 8. Options

### Option A - Continue Direct Project Participants

Use `FundProjectParticipant` as the main access/ownership model.

Verdict:

```text
Not recommended as the long-term model.
```

Why:

- does not model C2 Client/account ownership;
- repeats access per Project;
- weak foundation for sales, Orders, reporting and communications;
- does not align cleanly with SeasonPro Club precedent.

It remains useful as an interim bridge.

### Option B - FUND-Specific C2 Client/Account Model

Create a FUND-only C2 Client/account model.

Potential model:

```text
FundClient
FundClientUser
FundProject.clientId
```

Pros:

- fastest path to FUND-specific needs;
- supports schools/PTAs/clubs/customer accounts;
- clear Project ownership for FUND.

Cons:

- may duplicate SeasonPro Club concepts;
- may need later migration into a reusable platform model;
- may fragment C2 account patterns across modules.

### Option C - Reusable IsoStack C2 Client/Account Model

Create a reusable platform-level C2 Client/account model usable by FUND, SeasonPro and future modules.

Potential model:

```text
ClientAccount
ClientAccountUser
Module-specific links:
  ClientAccount -> LMSProClub
  ClientAccount -> FundProject
```

Pros:

- strongest long-term platform architecture;
- supports multi-module client/account surfaces;
- helps unify C1 Client view and cross-module customer support;
- avoids duplicating C2 account logic in every module.

Cons:

- larger scope;
- requires careful integration with existing SeasonPro Club structures;
- may delay near-term FUND C2 expansion.

### Option D - Hybrid Model

Use a Client/account model for ownership and retain `FundProjectParticipant` for per-Project contact/override/exception access.

Recommended planning direction.

Potential shape:

```text
C1 tenant
-> C2 Client / Account
-> C2 users
-> Projects

FundProjectParticipant remains for:
-> named Project contacts
-> role overrides
-> exception access
-> temporary transition access
```

This lets 1P-D remain useful while preventing it from becoming the long-term account model by accident.

## 9. Recommended Direction

Recommended direction for planning:

```text
Hybrid model, ideally using a reusable IsoStack C2 Client/account concept if feasible.
```

Minimum accepted model:

- C2 Client/account owns Projects.
- C2 users belong to the C2 Client/account.
- Active C2 users can see Projects for their Client/account, subject to future role rules.
- `FundProjectParticipant` remains for Project contacts, overrides, exceptions and transition access.

## 10. C2 User Hierarchy

Initial recommendation:

```text
C2 users can be peers initially, with no hierarchy, if the first implementation is read-only.
```

Reasons:

- reduces initial complexity;
- supports dashboard visibility;
- avoids premature role design before C2 actions exist.

Role modelling should be planned before:

- C2 mutations;
- Project self-service;
- approvals;
- Store controls;
- Order visibility controls;
- communications management.

## 11. Project Visibility

Question:

```text
Should all active C2 users in a Client/account see all Projects for that account?
```

Recommended initial answer:

```text
Yes for read-only C2 dashboard visibility, unless a Project has explicit exception rules.
```

Rationale:

- aligns with C2 Client/account ownership;
- supports schools/clubs/PTAs where multiple contacts may operate the same fundraising relationship;
- gives future sales/reporting a stable account scope.

Exception model:

- `FundProjectParticipant` can provide named contacts, overrides or temporary exceptions.
- Future role permissions can restrict sensitive actions later.

## 12. Relationship To FundProjectParticipant

`FundProjectParticipant` should not be deleted or treated as a mistake.

Future possible roles:

- named Project contact;
- primary organiser for a Project;
- role override;
- exception access;
- temporary bridge before Client/account membership exists;
- audit-friendly Project assignment record.

Planning rule:

```text
Do not derive long-term C2 account ownership solely from FundProjectParticipant.
```

## 13. C1 Client Management

C1 must be able to manage more than Project participant access.

Future C1 Client management should likely include:

- Client/account creation;
- Client/account profile;
- Client/account status;
- C2 users;
- roles/access levels;
- Projects belonging to the Client/account;
- future Orders;
- future sales/reporting;
- communications/announcements;
- automation/key-date context.

This should be a C1 admin/control surface, not a C2 self-service surface.

## 14. Hat-Swapping vs C1 Client View

These must remain distinct.

### Hat-Swapping

Hat-swapping means the same authenticated user chooses between their own allowed contexts.

Example:

```text
I am both a C1 admin and a C2 Client user.
I choose whether to operate as C1 admin or as my own C2 Client user.
```

### C1 Client View

C1 Client view means a C1 admin opens a managed Client/account context for support, preview or administration.

Example:

```text
I am a C1 admin.
I open School A's Client view to inspect its users, Projects, Orders and future communications.
```

Client view must not be implemented as unsafe impersonation.

It should have:

- explicit access controls;
- clear visual context;
- audit logging;
- read-only/preview defaults unless future slices explicitly add support actions.

## 15. Key Dates And Automation

SeasonPro key dates provide a useful precedent.

Future C2 Client/account planning should consider:

- Client-level key dates;
- Project-level key dates;
- Event-level key dates;
- positive/negative offsets;
- communication triggers;
- dashboard-visible announcements;
- task/reminder generation;
- C1 admin automation setup;
- C2 dashboard visibility.

Do not implement this in 1P-F.

Key dates should be considered before designing:

- communications;
- announcements;
- workflow reminders;
- Store open/close automation;
- production deadlines;
- organiser dashboard tasks.

## 16. Route / UX Implications

Current interim route:

```text
/app/fund/organiser
```

This remains acceptable for the read-only participant-scoped interim dashboard.

If Client/account becomes the long-term model, route naming should be reviewed.

Possible future routes:

```text
/app/fund/organiser
/app/fund/client
/app/fund/account
/app/fund/clients/[id]
```

Recommendation:

- keep `/app/fund/organiser` for current read-only interim UI;
- plan C1 Client management under an explicit C1 route, likely separate from C2 user route;
- do not rename until the model is accepted.

## 17. Schema Planning Implications

This slice does not create schema.

Future schema planning must decide whether the model lives in:

- platform/core schema;
- FUND schema;
- SeasonPro schema;
- a hybrid with core Client/account plus module-specific links.

Likely future entities to evaluate:

- Client/account table;
- Client/account user membership table;
- Client/account role/status enum;
- FundProject client/account relation;
- SeasonPro Club to Client/account relation;
- audit events.

## 18. Deferred Until Model Accepted

Do not build yet:

- C2 mutations;
- C2 participant management UI;
- C2 Client/account management UI;
- C1 Client view;
- organiser invitations;
- Project Request/onboarding;
- Store;
- Orders;
- Commerce Core coupling;
- sales/reporting views;
- communications/announcements;
- key-date automation;
- dashboard task workflows.

## 19. Risks

Primary risks:

- over-building a FUND-specific model that later conflicts with SeasonPro Clubs;
- over-generalising a core Client/account model before requirements are clear;
- accidentally treating `FundProjectParticipant` as final account ownership;
- confusing hat-swapping with C1 Client view;
- adding Store/Order/reporting work before account ownership is resolved.

## 20. Open Decisions

Open decisions before implementation:

- Is the Client/account model core IsoStack, FUND-specific, or hybrid?
- How does SeasonPro Club map to Client/account?
- Is `Client` the accepted user-facing/admin term?
- Are initial C2 users peers?
- Do all active Client users see all Client Projects?
- What role does `FundProjectParticipant` keep?
- What does C1 Client view allow?
- What audit events are required for C1 Client view?
- Are key dates Client-level, Project-level, Event-level or all three?

## 21. Recommended Next Slice

Recommended next planning slice:

```text
FUND Phase 1 Slice 1P-F-A - C2 Client/Account Schema Options
```

Purpose:

```text
Decide whether the first schema implementation should be core IsoStack, FUND-specific, or hybrid.
```

Do not proceed to implementation until this decision is accepted.

## 22. Recommended Implementation Prompt For Next Slice

```text
Proceed with FUND Phase 1 Slice 1P-F-A planning only: C2 Client/Account Schema Options.

Use:
- isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-f-c2-client-account-organisation-model-planning.md
- isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-d0-c2-organisation-scope-clarification.md
- current SeasonPro Club/User/Role schema and services
- current FUND Project/Participant schema and services
- active FUND roadmap/control document

Planning only.

Do not implement code.
Do not edit Prisma schema.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.

Plan schema options for:
- reusable core Client/account model;
- FUND-specific Client/account model;
- hybrid model linking core Client/account to FUND and SeasonPro.

The plan must compare risks, migration impact, SeasonPro Club compatibility, FUND Project ownership, C2 user membership, C1 Client view and future Store/Order/reporting scope.
```
