# FUND Phase 1 Slice 1P-G-D0 - Client-Scoped Project Initiation And Idempotency Planning

Date: 2026-06-29

Status: Planning only

## 1. Slice Goal

Decide how Client-scoped Project initiation should work before implementing Project Intake moderation API/services.

This slice protects the boundary between three different initiation lanes:

- public or unknown Project requests;
- new Client onboarding / first Project requests;
- existing authenticated Client dashboard Project creation;
- C1 admin-created intake forms;
- C1 moderation decisions;
- downstream operational approval gates.

Core decision:

```text
Client ownership must come from trusted Client route, token or authenticated context, not from respondent email, organiser snapshot fields, proposed Client contact fields or user-editable hidden fields.
```

Product principle:

```text
An authenticated C2 Client user creating a Project from the Client dashboard is not creating an intake submission by default.
The Project is created directly as a Client-owned selling unit under FundProject.clientId.
```

## 2. Dependencies

Accepted baseline:

- `FundClient` represents the Client organisation/account.
- `FundProject.clientId` exists and is nullable.
- Project Client linkage is implemented and accepted.
- Project Intake schema is implemented and reviewed.
- Intake submissions are moderation records only.
- Client users/members are not implemented yet.
- Public Project Intake forms are not implemented yet.
- Notifications, invitations, Store, Orders, Commerce and SeasonPro integration remain deferred.

Relevant documents:

- `03-slice-planning/2026-06-25-fund-phase-1-slice-1p-g-a-project-intake-schema-and-moderation-model-planning.md`
- `03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-b-project-intake-schema-options-planning.md`
- `04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-c-project-intake-schema-confirmation.md`
- `05-review-and-test/2026-06-29-phase-1-slice-1p-g-c-r1-project-intake-schema-review.md`
- `00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

## 3. Initiation Contexts

### Three-Lane Model

| Lane | Who initiates? | What happens? | C1 role |
| --- | --- | --- | --- |
| Unknown / public intake | Unknown person, public form, campaign link | Creates moderation submission | C1 approves/rejects and may create Client/user/Project |
| New Client onboarding | Organisation not yet trusted/linked | Creates moderation/onboarding submission | C1 creates/links Client and first user |
| Existing authenticated Client Project creation | C2 user in known Client/account | Creates Project directly under `FundProject.clientId` | C1 supplies products and manages fulfilment/production/commission |

### C1 Admin Intake Form

C1 creates an intake form for a tenant-owned process.

Possible channels:

- public link;
- embedded website form;
- email link;
- campaign page;
- manual C1 entry.

Default behaviour:

```text
submission -> C1 moderation -> explicit approval action
```

No operational Client, Client user, Project or Event record should be created automatically.

### Unknown Public Respondent

An unauthenticated respondent submits a request.

Default behaviour:

```text
submission source = PUBLIC_LINK / PUBLIC_EMBED / CAMPAIGN_PAGE
submission status = SUBMITTED
Client scope = proposed only, not trusted
```

Moderation may later:

- reject as spam;
- request more information;
- create or link a Client;
- create or link a primary Client user/member after future user planning;
- create a Project;
- link an Event where allowed.

### First Visible Public Initiation Form

The first client-facing Project initiation form should use tenant/product language, not internal intake-schema language.

Recommended form structure:

```text
Project basics
-> Organisation details
-> Main organiser details
-> email confirmation midpoint
-> confirmed submission
-> C1 moderation
```

Project basics:

- Project name.
- Type of fundraising project.
- Preferred project dates / target date.
- Notes / project description.

Client-facing Project Type question:

```text
What kind of fundraising project would you like to run?
```

Initial options:

- Artwork fundraising project.
- Group personalised product project.
- Bulk order / club-funded project.
- Not sure yet.

Do not expose internal terms such as workflow class, Store requirement, Commerce option or product workflow.

Organisation details:

- Organisation name.
- Organisation type:
  - School;
  - Club;
  - PTA / Friends group;
  - Charity / community group;
  - Other.
- Organisation address.

Main organiser details:

- First name.
- Last name.
- Email address.
- Phone number.
- Role in organisation.

Use "Main organiser details" as the public section label. Do not call this "primary user" on the public form.

Internal interpretation:

- the main organiser may become the future primary Client user/member after C1 approval;
- no Client user/member is created before approval;
- no Client user/member is created until the relevant user/member model exists;
- current primary contact fields remain C1 operational contact snapshots only.

Store/Commerce boundary:

```text
Do not ask "Do you require a Store?" on the first form.
```

Project Type helps C1 understand the likely route during moderation. Store, Orders, Commerce, payment, production and fulfilment remain deferred.

Data handling:

- use dedicated schema fields where they exist;
- store additional first-form values in `rawPayload` and/or `sourceContext` as moderation evidence where dedicated fields do not exist;
- do not add schema fields in this planning note.

### Existing Client Dashboard

A future authenticated Client user starts a Project from the Client dashboard.

This is not an intake submission by default.

Recommended future behaviour:

```text
authenticated C2 Client user
  -> Client dashboard
  -> New Project
  -> create FundProject directly
  -> set FundProject.clientId from authenticated Client/account context
  -> Project starts in a safe Client-managed pre-operational state
```

Do not choose a final status enum in this planning note. The product principle is:

```text
Project is created directly as a Client-owned selling unit in a safe pre-operational state.
```

This should not require C1 moderation merely to create the Project record.

The trusted Client scope must come from authenticated Client membership/context, not from form fields.

Direct Client dashboard Project creation requires a future Client user/member and role/permission model. A separate policy slice must decide:

- which Client users can directly create Projects;
- which Client users can only request Projects;
- which Project fields can be self-entered;
- which safe pre-operational Project status is used;
- whether C1 review is required before activation;
- how audit and notification boundaries work.

C1 review or approval may still be required before:

- Project activation;
- Store launch;
- public ordering;
- production batching;
- dispatch/fulfilment;
- notification sending;
- commerce/payment activity.

### C2 Client Project Manager Role

The authenticated C2 Client user is the Project manager for Client-owned Projects.

Within future role/permission rules and operational constraints, the C2 Client user may manage their own Project, including:

- planning;
- editing core Project details;
- choosing dates;
- choosing whether the Project is Event-linked or standalone where permitted;
- cancelling;
- archiving;
- managing the Project lifecycle from the Client dashboard.

Exact role/permission rules require the future Client users/members planning slice.

### C1 Producer / Supplier Role

C1 is the FUND producer tenant, supplier and fulfilment operator.

C1 is responsible for operational and fulfilment surfaces such as:

- Product and Catalogue availability;
- Event/Product availability rules;
- artwork checking where required;
- production and fulfilment;
- dispatch;
- commission;
- order/commerce operational oversight;
- supplier-side status and exception handling.

C1 should not be described as approving every authenticated C2 Project creation by default.

### Client-Scoped Token Or Link

C1 may later create a Client-scoped intake link.

The Client scope must come from a server-issued token or trusted route context.

Rules:

- token must identify tenant and Client;
- token must be hashed or otherwise safely stored if persisted;
- token must not be user-editable;
- hidden Client id fields are advisory only and must not establish ownership;
- expired, revoked, archived or mismatched tokens must not create trusted Client scope.

### SeasonPro Club

SeasonPro Club-originated requests are future-facing.

The trusted source would be SeasonPro League and Club context, subject to:

- FUND/Fundraising module entitlement;
- League configuration of approved FUND producer tenant(s);
- Club-to-FUND Client/account mapping;
- catalogue and sale method planning;
- moderation-first behaviour unless trusted direct creation is separately approved for the SeasonPro context.

## 4. Trusted Client Scope Rule

Trusted Client scope may be established only by:

1. authenticated Client membership in a future Client user/member model;
2. C1 admin selecting an existing Client during moderation;
3. a server-issued Client-scoped token/link;
4. trusted SeasonPro Club context after integration planning;
5. C1 admin creating or editing a Project directly.

Trusted Client scope must not be established by:

- `FundProject.organiserName`;
- `FundProject.organiserEmail`;
- `FundProject.organiserPhone`;
- respondent email alone;
- proposed Client name;
- proposed Client contact fields;
- public hidden `clientId` fields;
- submitted `approvedClientId` values from public payloads.

## 5. Idempotency Goals

Idempotency should prevent accidental duplicate operational records while preserving audit evidence.

Potential duplicate risks:

- same respondent submits the same request repeatedly;
- public form is refreshed or retried;
- C1 moderator clicks approve twice;
- Client dashboard submit button is retried;
- authenticated Client dashboard Project creation request is retried;
- SeasonPro integration retries a request;
- new Client / first Project approval creates duplicate Client or User records.

Principle:

```text
Submission records may be duplicated as evidence, but approval actions must be idempotent where they create or link operational records.
Authenticated Client dashboard Project creation must also be idempotent where it creates Client-owned Projects directly.
```

## 6. Idempotency Inputs

Possible inputs for future matching:

- tenant id;
- intake form id;
- trusted Client id where present;
- respondent email, normalised;
- proposed Client name, normalised;
- requested Project name, normalised;
- Event id where trusted or selected by C1;
- external source and external id for SeasonPro;
- future Client user/member id;
- future idempotency key from public/API requests.
- future idempotency key from authenticated Client dashboard Project creation requests.

Email matching may assist duplicate detection but must not prove Client ownership by itself.

## 7. Existing Client / Additional Project Flow

Recommended future behaviour:

```text
authenticated Client context
  -> Client dashboard New Project
  -> create FundProject directly
  -> set FundProject.clientId from authenticated Client/account context
  -> Project starts in a safe Client-managed pre-operational state
```

This does not need C1 moderation simply to create the Project record.

Later C1 review or separate policy gates may still control:

- Project activation;
- Store launch;
- public ordering;
- production batching;
- dispatch/fulfilment;
- notification sending;
- commerce/payment activity.

Do not implement yet:

- Client dashboard initiation UI;
- Client user membership checks;
- role/permission checks;
- direct Project creation services;
- notification sending.

## 8. New Client / First Project Flow

Recommended moderation outcome:

```text
unknown or new Client request
  -> create submission
  -> C1 moderation
  -> create or match FundClient
  -> future create/link primary Client user/member
  -> create DRAFT Project linked to FundClient
```

The first Project flow needs a later idempotency decision for:

- Client matching;
- primary contact matching;
- future platform User matching;
- invitation boundaries;
- notification boundaries.

## 9. Approval Action Idempotency

Future C1 moderation approval services for unknown/public/new Client intake should be designed so repeated approval attempts do not create duplicate Clients or Projects.

Recommended service guardrails:

- submission status transition must be checked server-side;
- approval action should run in a transaction;
- if `approvedClientId` already exists, reuse it;
- if `approvedProjectId` already exists, return the existing Project rather than creating another;
- C1 must explicitly confirm create-new versus link-existing;
- duplicate hints should be advisory, not automatic ownership assignment.

Do not frame authenticated Client dashboard Project creation as C1 approval-action idempotency.

Authenticated Client dashboard direct Project creation needs its own idempotency protection:

- create requests should run inside server-side transaction boundaries;
- repeated double-click/retry should not create duplicate Projects;
- a future idempotency key should be considered for create Project requests;
- if the same authenticated request is retried, return the existing Project where possible;
- prevent duplicate Project creation within the same Client/account where a request is retried;
- audit the creating authenticated Client user/member and Client account.

## 10. Project Creation Boundary

When future moderation or authenticated Client dashboard creation creates a Project:

- Project should start in a safe pre-operational state according to the future policy slice;
- `FundProject.clientId` should be set only from C1-selected or trusted Client context;
- Event linkage should use accepted Project/Event constraints;
- organiser snapshot fields may be copied as contact snapshots but not access control;
- Project readiness and activation rules remain unchanged;
- direct Client-created Projects do not imply Store, Orders, Commerce, production, dispatch or notification approval.

## 11. Client User / Member Boundary

This slice does not implement Client users.

Future planning must decide:

- `FundClientUser` or equivalent model;
- relationship to platform `User`;
- primary Client user/member concept;
- role labels versus access permissions;
- invitation and onboarding flow;
- notification consent and delivery rules.

Until then:

- primary contact fields remain C1 operational snapshots;
- public respondents do not become users;
- approval does not send invitations.

## 12. Address / Delivery Boundary

Client organisation address and delivery defaults are required before Store, Orders, Production and Dispatch.

Future planning must decide:

- Client physical address fields;
- delivery address defaults;
- Project-level delivery snapshots;
- Project-level delivery overrides;
- how dispatch uses Client and Project address data.

Do not add delivery fields in Project Intake services until this is planned.

## 13. Security Requirements

Future implementation must include:

- server-side tenant scoping;
- same-tenant Client/Event/Project checks;
- no trust in public hidden fields;
- public payload size limits;
- rate limiting and spam controls for public forms;
- audit events for moderation and approval;
- safe error messages;
- token expiry/revocation where Client-scoped links are used.

## 14. Recommended Implementation Sequence

Recommended sequence:

Public/new Client intake lane:

1. 1P-G-D - Project Intake Moderation API/Services Planning.
2. 1P-G-D1 - Project Intake C1 Form API/Services.
3. 1P-G-D2 - Project Intake Submission Review API/Services.
4. 1P-G-D3 - Approval Action Planning/Implementation, if accepted.
5. 1P-G-E - C1 Intake Moderation UI Planning.

Client-owned Project creation lane:

1. 1P-K0 - Client-Owned Project Lifecycle And Dashboard Management Planning.
2. 1P-K1 - Client User/Member Role And Project Permission Planning.
3. 1P-K2 - Authenticated Client Dashboard Project Creation API/Services Planning.

Public forms, Client dashboard initiation and SeasonPro Club initiation should remain deferred until the relevant trust/context, role/permission and idempotency models are accepted.

## 15. Explicit Non-Goals

Do not implement in this slice:

- application code;
- Prisma schema changes;
- migrations;
- routers;
- services;
- Zod schemas;
- UI;
- public Project Intake forms;
- Client dashboard initiation UI;
- Client users/members;
- invitations;
- notifications;
- Store;
- Orders;
- Commerce;
- SeasonPro integration;
- delivery/fulfilment fields.

Do not run:

- `db:push`;
- seed commands;
- reset commands.

## 16. Recommended Next Slice

Recommended next slice:

```text
1P-G-D - Project Intake Moderation API/Services Planning
```

Planning goal:

```text
Define the moderated Project initiation form and C1 approval services, including multi-step form flow, email confirmation midpoint, submission creation, Client/user/Project matching, idempotency and approval outputs.
```

Deferred later lane:

```text
1P-K0 - Client-Owned Project Lifecycle And Dashboard Management Planning
```

Deferred lane goal:

```text
Define how authenticated C2 Client users manage Client-owned Projects from the Client dashboard, including Project lifecycle, safe pre-operational status, edit/cancel/archive rules and C1 downstream operational gates.
```
