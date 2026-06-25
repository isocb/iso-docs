# FUND Phase 1 Slice 1P-F - C2 Client/Account As Project Management Node Planning

Date: 2026-06-25

Status: Planning only / architecture correction

## 1. Purpose

Record the corrected FUND C2 operating model before further C2 testing or development.

The current 1P-D read-only organiser dashboard is technically safe because it is read-only and participant-scoped, but it is not representative of the intended C2 product model.

## 2. Core Correction

C2 is not a passive/read-only receiver of Project information.

C2 is the Project management node.

In FUND, the C2 actor is an organisation/client/account such as:

- school;
- club;
- PTA;
- charity branch;
- fundraising organisation;
- customer account.

C2 users belong to that C2 organisation/client/account.

C2 users are not simply personal participants assigned to individual Projects. They are users operating within the C2 organisational node.

## 3. Strategic Model

The strategic model to evaluate is:

```text
C1 tenant
-> C2 Client/account organisation
-> C2 users
-> Projects
-> future Orders / Sales / Reporting / Communications
```

This model should guide all future C2 dashboard, Project Request, Store, Order, sales/reporting and communications planning.

## 4. Current Interim Model

Current implemented technical bridge:

```text
User
-> FundProjectParticipant
-> FundProject
```

This remains safe for:

- read-only participant-scoped Project visibility;
- technical validation of the 1P-C organiser endpoints;
- temporary access bridging while the C2 Client/account model is designed.

It must not be treated as final C2 operating architecture.

## 5. C2 Capabilities To Plan

The C2 Client/account may eventually:

- initiate its own Projects;
- submit Project Requests;
- create Projects directly where allowed;
- manage its own Projects;
- link Projects to a C1-defined selling Event where appropriate;
- create or manage standalone Projects where allowed;
- view/manage Project sales;
- view/manage Orders;
- view reporting;
- receive and manage communications;
- see dashboard announcements;
- participate in automation driven by key dates.

These capabilities should be organisation/client scoped, not merely participant scoped.

## 6. SeasonPro Precedent

SeasonPro model:

```text
C1 League
-> C2 Club
-> Club users
-> Teams
```

SeasonPro implications:

- C1 League manages C2 Clubs.
- Clubs have users.
- Clubs own Teams.
- Clubs are operational client organisations.
- Processes, communications and key-date automation operate around those organisations and their Teams.

Integrated SeasonPro + FUND:

```text
C1 League
-> C2 Club
-> Club users
-> Teams
-> Fundraising Projects
```

In integrated SeasonPro + FUND, the Club will often be the fundraising Project creator/account.

## 7. FUND Parallel

FUND model:

```text
C1 Producer/Admin
-> C2 Client/account
-> C2 users
-> Projects
```

C1 Producer/Admin manages C2 Clients/accounts.

C2 Clients/accounts own Projects.

C2 users manage those Projects.

## 8. Client Terminology Decision

Decision needed:

```text
Is "Client" the correct user-facing/admin term for the C2 organisation/account?
```

Arguments for `Client`:

- works for schools, clubs, PTAs, charity branches, fundraising organisations and customer accounts;
- aligns with C1 admin language;
- can map SeasonPro Club into a broader cross-module concept;
- avoids overfitting FUND to "organiser" as a person.

Risk:

- SeasonPro may continue to call the same concept `Club` in module-specific UI.

Possible convention:

```text
Core/platform term: Client/account
SeasonPro user-facing term: Club
FUND user-facing term: Client or Fundraising Client
```

## 9. FUND-Specific vs Reusable Core Model

Decision needed:

```text
Should the model be FUND-specific first or reusable IsoStack core?
```

### FUND-Specific First

Potential shape:

```text
FundClient
FundClientUser
FundProject.clientId
```

Pros:

- quicker to model FUND needs;
- lower immediate platform blast radius.

Cons:

- may duplicate SeasonPro Club/account concepts;
- may need later migration into core;
- may complicate integrated SeasonPro + FUND.

### Reusable IsoStack Core

Potential shape:

```text
ClientAccount
ClientAccountUser
ClientAccountModuleLink
FundProject.clientAccountId
LMSProClub.clientAccountId
```

Pros:

- strongest cross-module architecture;
- supports C1 Client view across modules;
- avoids parallel C2 account implementations.

Cons:

- larger planning/implementation surface;
- requires careful migration/integration with SeasonPro.

### Hybrid

Likely preferred direction:

```text
Core Client/account concept
+ module-specific links and vocabulary
+ FundProjectParticipant retained for per-Project exceptions/contacts
```

## 10. C2 Users And Roles

Question:

```text
Are C2 users peers initially?
```

Recommended initial answer:

```text
Yes, if the first Client/account-scoped dashboard remains read-only or low-risk.
```

Later role/access design should happen before:

- Project creation;
- Project mutation;
- Event linking;
- Store management;
- Order access;
- reporting access;
- communications management;
- approvals.

## 11. Project Visibility And Management

Question:

```text
Can active C2 users in a Client/account see/manage all Projects owned by that Client/account?
```

Initial recommendation:

- read-only visibility: yes, unless explicit exception rules apply;
- management rights: plan separately with roles before implementation.

The distinction matters:

```text
Visibility can be broad.
Mutation rights should be role/permission controlled.
```

## 12. Project Initiation

C2 may initiate Projects through:

- Project Request/onboarding flow;
- authenticated Project creation;
- C1-created Project assignment;
- SeasonPro Club-triggered Project creation;
- future template/campaign-driven flows.

Planning questions:

- Can C2 create standalone Projects?
- Can C2 create Event-linked Projects?
- Does C1 approve Project Requests?
- Does Event linkage constrain dates/products?
- Does Project creation require selected Catalogue/Product availability?
- Does Project creation require C1 review before activation?

Do not implement Project Request/onboarding in this slice.

## 13. Event Linkage

C1 defines Events.

C2 Projects may link to C1-defined Events where appropriate.

Questions:

- Can C2 choose from eligible Events?
- Can C1 restrict which Clients can use an Event?
- Can C1 require approval before Event-linked Project activation?
- Can standalone Projects exist when no Event is selected?
- Does Event selection constrain Project dates and Product availability?

Existing date rule remains:

```text
Event closesAt is the latest permissible effective close date for linked Projects.
```

## 14. Standalone Projects

Standalone Projects remain important.

For standalone Projects:

- Project opensAt/closesAt are governed by normal Project validation;
- Project closesAt must be after Project opensAt when both are present;
- no Event close-date boundary applies.

Future planning must decide which C2 Clients can create standalone Projects and whether C1 approval is needed.

## 15. Project Ownership / Scoping

Future Project ownership should likely include:

```text
FundProject.organizationId = C1 tenant
FundProject.clientAccountId = C2 Client/account
```

`organizationId` remains the C1 tenant boundary.

`clientAccountId` or equivalent would provide the C2 operating scope.

This is planning only and must be handled in a future schema slice.

## 16. FundProjectParticipant Future Role

`FundProjectParticipant` may remain useful for:

- named Project contacts;
- Project-level role overrides;
- exception access;
- temporary transition access;
- specific helper/contact visibility;
- audit-friendly assignment records.

It should not be the strategic Project ownership model.

## 17. C1 Client View

C1 Client view is a future C1 admin/support surface.

It may show:

- C2 Client/account profile;
- C2 users;
- Projects;
- future Orders;
- future sales/reporting;
- future communications;
- future dashboard announcements;
- automation/key-date status.

C1 Client view must not rely on unsafe impersonation.

It should be explicitly distinct from hat-swapping.

## 18. Hat-Swapping

Hat-swapping means:

```text
The same authenticated user chooses between their own C1 admin context and their own C2 Client/user context.
```

Hat-swapping should not grant C1 access to a Client unless that user actually has C2 membership or C1 Client-view permission.

## 19. Orders / Sales / Reporting / Communications

Future scope should likely be:

```text
C1 tenant
-> C2 Client/account
-> Project
-> Store / Orders / Sales / Reporting / Communications
```

Reporting likely needs both:

- Project-level reporting;
- Client/account-level reporting.

Communications and dashboard announcements likely need:

- C1-to-Client messaging;
- Client-to-Project messaging;
- key-date-triggered reminders;
- Event-related notices;
- Store/order status notices.

Do not implement this until Client/account ownership is accepted.

## 20. Key Dates And Automation

SeasonPro key-date automation should inform FUND.

Future planning should decide whether key dates are:

- C1 tenant-level;
- Client/account-level;
- Event-level;
- Project-level;
- Store-level;
- or layered.

Positive/negative offsets may trigger:

- emails;
- dashboard messages;
- announcements;
- reminders;
- tasks;
- production deadlines.

This remains deferred.

## 21. Impact On 1P-D Smoke Testing

1P-D smoke testing has limited product-validation value because there is not yet a real C2 Client/account scope.

It can still validate:

- endpoint safety;
- read-only UI behaviour;
- participant-scoped access predicates;
- empty/error states;
- C1/C2 navigation separation.

It cannot validate:

- the real C2 Project management model;
- Client/account ownership;
- C2 Project creation/management;
- C2 sales/reporting/communications;
- C1 Client view.

If a C2 user currently sees the C1 dashboard, that should be treated as evidence that the real routing/context model is not implemented yet, not automatically as a defect in the interim read-only dashboard.

## 22. Immediate Control Decision

Do not continue treating 1P-D authenticated smoke testing as decisive product validation.

Record 1P-D as:

```text
Technically safe.
Functionally interim.
Not representative of the final C2 Project management model.
```

## 23. Deferred Until Model Accepted

Do not build yet:

- C2 Project creation;
- C2 Project mutation;
- C2 Client/account management UI;
- C1 Client view;
- participant management UI;
- invitations;
- Project Request/onboarding;
- Orders;
- Store;
- Commerce Core coupling;
- sales/reporting;
- communications/announcements;
- key-date automation.

## 24. Recommended Next Slice

Recommended next slice:

```text
FUND Phase 1 Slice 1P-F-A - C2 Client/Account Schema And Routing Options
```

Goal:

```text
Decide the schema/routing shape for C2 Client/account ownership before implementation.
```

This should compare:

- core IsoStack Client/account;
- FUND-specific Client/account;
- hybrid core + module link model;
- SeasonPro Club mapping;
- C2 Project ownership;
- C2 user membership;
- C1 Client view;
- C2 Project management routing.
