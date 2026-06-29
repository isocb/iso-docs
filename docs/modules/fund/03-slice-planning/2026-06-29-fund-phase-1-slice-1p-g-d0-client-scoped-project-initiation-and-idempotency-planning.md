# FUND Phase 1 Slice 1P-G-D0 - Client-Scoped Project Initiation And Idempotency Planning

Date: 2026-06-29

Status: Planning only

## 1. Slice Goal

Decide how Client-scoped Project initiation should work before implementing Project Intake moderation API/services.

This slice protects the boundary between:

- public or unknown Project requests;
- authenticated Client dashboard Project initiation;
- C1 admin-created intake forms;
- C1 moderation decisions;
- future direct Project creation policies.

Core decision:

```text
Client ownership must come from trusted Client route, token or authenticated context, not from respondent email, organiser snapshot fields, proposed Client contact fields or user-editable hidden fields.
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

### Existing Client Dashboard

A future authenticated Client user starts a Project from the Client dashboard.

Default recommended behaviour for first implementation:

```text
Client dashboard request -> moderated Project Intake submission
```

The trusted Client scope should come from authenticated Client membership/context, not from form fields.

Future direct creation may be allowed only after a separate policy slice decides:

- which Client users can directly create Projects;
- whether C1 approval is still required;
- which Project fields can be self-entered;
- whether Project starts as DRAFT or REQUESTED;
- how audit and notification boundaries work.

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
- moderation-first behaviour unless trusted direct creation is separately approved.

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
- SeasonPro integration retries a request;
- new Client / first Project approval creates duplicate Client or User records.

Principle:

```text
Submission records may be duplicated as evidence, but approval actions must be idempotent where they create or link operational records.
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

Email matching may assist duplicate detection but must not prove Client ownership by itself.

## 7. Existing Client / Additional Project Flow

Recommended first behaviour:

```text
authenticated Client context
  -> create moderated intake submission with source CLIENT_DASHBOARD
  -> store trusted matchedClientId or equivalent server-derived Client reference
  -> C1 review
  -> create DRAFT Project linked through FundProject.clientId
```

Do not implement yet:

- Client dashboard initiation UI;
- Client user membership checks;
- direct Project creation;
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

Future approval services should be designed so repeated approval attempts do not create duplicate Clients or Projects.

Recommended service guardrails:

- submission status transition must be checked server-side;
- approval action should run in a transaction;
- if `approvedClientId` already exists, reuse it;
- if `approvedProjectId` already exists, return the existing Project rather than creating another;
- C1 must explicitly confirm create-new versus link-existing;
- duplicate hints should be advisory, not automatic ownership assignment.

## 10. Project Creation Boundary

When future moderation creates a Project:

- Project should start as `DRAFT` unless a later slice approves another status;
- `FundProject.clientId` should be set only from C1-selected or trusted Client context;
- Event linkage should use accepted Project/Event constraints;
- organiser snapshot fields may be copied as contact snapshots but not access control;
- Project readiness and activation rules remain unchanged.

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

1. 1P-G-D - Project Intake Moderation API/Services Planning.
2. 1P-G-D1 - Project Intake C1 Form API/Services.
3. 1P-G-D2 - Project Intake Submission Review API/Services.
4. 1P-G-D3 - Approval Action Planning/Implementation, if accepted.
5. 1P-G-E - C1 Intake Moderation UI Planning.

Public forms, Client dashboard initiation and SeasonPro Club initiation should remain deferred until the relevant trust/context models are accepted.

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
Define C1 admin Project Intake form and submission moderation services while preserving moderation-first behaviour, trusted Client scope boundaries and idempotent approval design.
```
