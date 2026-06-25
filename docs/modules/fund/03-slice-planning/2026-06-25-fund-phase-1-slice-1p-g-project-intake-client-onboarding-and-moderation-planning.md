# FUND Phase 1 Slice 1P-G - Project Intake, Client Onboarding And Moderation Planning

Date: 2026-06-25

Status: Future planning lane - do not implement yet

## 1. Purpose

Document the future Project Intake / Project Request and Client onboarding model before FUND work continues into write-capable C2 surfaces, invitations, Client users, Store, Orders or Commerce.

This clarification does not block the current 1P-F-E C1 Client Management UI because that slice remains C1 admin only and does not create Client users, send invitations, create Projects or implement Project Intake forms.

## 2. Current Context

Current foundation:

- 1P-F-C implemented the `FundClient` schema.
- 1P-F-D implemented C1 Client Management API/services.
- 1P-F-E is the current C1 Client Management UI lane.
- Client users, invitations, Project Client selector/linkage and Project Request/onboarding remain out of scope.
- C2 is the Project management node, but AMOW's immediate priority remains the C1 organisational dashboard.

## 3. Strategic Clarification

Projects will often be instantiated through a form created by C1 users.

C1 users should later be able to create Project Intake / Project Request forms that can be:

- embedded on websites;
- linked from emails;
- linked from campaign pages;
- linked from SeasonPro Club views;
- linked from future Client dashboards.

Respondents may or may not already be C2 users linked to the C1 tenant.

Form submissions should be moderated by C1 admin before creating or linking operational records.

## 4. Two Project Creation Paths

### New Client / First Project

Flow:

```text
external or unknown respondent
-> embedded / linked Project Intake form
-> C1 review and moderation
-> approved Client/account
-> initial C2 user/member where appropriate
-> operational Project
-> optional Event linkage or standalone Project
```

Characteristics:

- respondent may be unknown to the tenant;
- no existing Client/account may exist yet;
- C1 must decide whether to create or link a Client/account;
- C1 must decide whether to create or link a C2 user/member;
- C1 must decide whether the Project belongs to an Event or remains standalone.

### Existing Client / Additional Project

Flow:

```text
existing C2 user or SeasonPro Club user
-> future Client dashboard or SeasonPro Club view
-> Project request/create form
-> optional C1 approval depending on policy
-> Project created under existing Client/account
-> optional Event linkage or standalone Project
```

Characteristics:

- Client/account already exists;
- C2 user belongs to that Client/account;
- Project should be scoped to the existing Client/account;
- C1 approval may still be required depending on Event, Catalogue/Product availability, workflow suitability and operational policy.

## 5. SeasonPro Precedent

In SeasonPro:

- Clubs are C2 client organisations.
- Clubs have users.
- Clubs own Teams.
- Clubs are operational client organisations.

Integrated SeasonPro + FUND implication:

```text
SeasonPro Club
-> FUND Client/account
-> fundraising Project creator/account
```

A future FUND Project creation entry point may be linked from the SeasonPro Club view.

## 6. FUND Standalone Precedent

In standalone FUND:

- a school;
- PTA;
- club;
- charity branch;
- fundraising organisation;
- customer account;

may become the Client/account.

New Clients may originate from embedded Project Intake forms. Existing Clients may originate additional Projects from their future dashboard.

## 7. C1 Form Creation / Management

Future C1 form management should consider:

- form name/code/slug;
- intended Event, if any;
- standalone Project allowance;
- allowed Client types;
- required respondent fields;
- required Project fields;
- optional Product/Catalogue hints;
- moderation status;
- embed/link settings;
- audit trail;
- disabled/archived form handling.

Do not implement this in the current Client UI slice.

## 8. Embedded And Linked Form Use

Future Project Intake forms may be used from:

- AMOW/customer websites;
- direct email links;
- campaign pages;
- SeasonPro Club views;
- future Client dashboards;
- QR codes or offline campaign collateral.

These forms should create submissions for review, not directly create operational records.

## 9. Unknown Respondent Flow

Unknown respondent flow should capture enough information for C1 moderation:

- respondent name;
- respondent email;
- respondent phone where needed;
- proposed Client/account name;
- Client/account type;
- Project name/purpose;
- desired Event/campaign if form-linked;
- expected dates where relevant;
- free-text notes.

The submission should not automatically:

- create a User;
- create a Client;
- create a Project;
- send an invitation;
- send notifications.

## 10. Existing C2 User Flow

Existing C2 user flow should eventually:

- identify the authenticated user;
- identify their Client/account;
- allow Project initiation under that Client/account;
- show whether C1 approval is required;
- respect C1 Event, Catalogue/Product and workflow constraints.

This should depend on the accepted C2 Client/account and user model, not on `FundProjectParticipant` alone.

## 11. C1 Moderation Workflow

C1 moderation should decide whether to:

- reject or close a submission;
- request more information;
- create a new Client/account;
- link to an existing Client/account;
- create or link a C2 user/member;
- create a Project;
- link the Project to a C1 Event;
- keep the Project standalone;
- assign Products/Catalogues later through approved workflows.

Moderation must write audit events.

## 12. Approval Outputs

Approval may create or link:

- Client/account organisation;
- C2 user/member;
- Project;
- Event linkage;
- future Project Product or Catalogue availability decisions after separate planning.

Existing Projects must not be auto-created from a form submission until C1 approval is explicit.

## 13. Event-Linked Vs Standalone Projects

The intake model must support both:

- Event-linked Projects, where the intake form or campaign is tied to a C1 selling Event;
- standalone Projects, where no Event applies.

Event-linked Project rules must still respect:

- Event open date constraints;
- Event latest permissible effective close date;
- Event production deadline constraints.

Store-specific close dates remain future Store planning.

## 14. Notification And Invitation Boundary

No notification should be sent automatically until notification management is explicitly planned.

Notification management should follow the SeasonPro-style controlled communications pattern:

- explicit C1 configuration;
- explicit templates;
- explicit send/queue rules;
- audit trail;
- no accidental side effects from form submission, Client creation, User creation or Project approval.

Invitations are also deferred.

## 15. Audit Requirements

Future implementation should plan audit events for:

- form created/updated/archived;
- submission received;
- submission reviewed;
- submission approved/rejected;
- Client created/linked from submission;
- C2 user/member created/linked from submission;
- Project created from submission;
- Event linked from submission;
- notification queued/sent only after communications planning exists.

## 16. Dependencies

This lane depends on:

- accepted Client/account model;
- Project Client linkage;
- C2 user/member model;
- C1 Client management foundation;
- C2 Client/account scoping;
- Event/Product/Catalogue availability rules where forms constrain Project options.

## 17. Deferred Items

Do not implement in this lane until separately planned:

- Store;
- Orders;
- Commerce Core;
- Sales/Reporting;
- payments;
- commissions;
- production batching;
- fulfilment;
- dashboard communications;
- notification sending;
- invitation sending;
- SeasonPro Club mapping implementation.

## 18. Recommended Status

Recommended status:

```text
Document now.
Do not implement yet.
Continue 1P-F-E C1 Client Management UI because it remains presentation-critical and does not conflict with this future intake model.
```

## 19. Recommended Future Implementation Split

Suggested future sequence:

1. Project Client linkage planning and implementation.
2. C2 Client/account user/member model planning.
3. Project Intake form schema planning.
4. Project Intake API/services.
5. C1 Project Intake form management UI.
6. Public/embedded Project Intake form UI.
7. C1 moderation workflow UI.
8. Controlled notification/invitation planning.

## 20. Recommended Future Prompt

```text
Proceed with FUND Phase 1 Slice 1P-G-A planning only: Project Intake schema and moderation model.

Use:
- isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-g-project-intake-client-onboarding-and-moderation-planning.md
- current Client/account planning documents
- current Project/Event/Product/Catalogue planning documents

Planning only.

Do not implement application code.
Do not edit Prisma schema.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.
Do not send notifications.
Do not create Client users.
Do not implement public Project Intake forms yet.

Plan the schema and moderation model for C1-created Project Intake forms and Project Request submissions.
```
