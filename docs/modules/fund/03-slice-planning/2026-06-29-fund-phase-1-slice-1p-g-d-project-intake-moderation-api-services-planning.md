# FUND Phase 1 Slice 1P-G-D - Project Intake Moderation API/Services Planning

Date: 2026-06-29

Status: Planning only

## 1. Slice Goal

Plan the C1 admin API/service layer for moderated Project Intake forms and Project Intake submissions.

This slice follows the accepted split-lane policy:

```text
Unknown / public intake and new Client onboarding remain moderation-first.
Existing authenticated Client dashboard direct Project creation is a later Client-owned Project lifecycle lane.
```

The immediate implementation priority is the moderated initiation form and C1 approval workflow, not authenticated Client dashboard Project creation.

## 2. Dependencies

Accepted baseline:

- `FundClient` is the Client organisation/account.
- `FundProject.clientId` is the explicit Project-to-Client ownership link.
- `FundProjectIntakeForm` and `FundProjectIntakeSubmission` exist from 1P-G-C.
- 1P-G-C schema-only implementation and 1P-G-C-R1 review are complete.
- 1P-G-D0 split-lane initiation/idempotency policy is accepted.
- Project Intake submissions are moderation records only.
- Operational Client, Client user/member and Project records are created or linked only through later explicit C1 approval actions.

Relevant documents:

- `03-slice-planning/2026-06-25-fund-phase-1-slice-1p-g-a-project-intake-schema-and-moderation-model-planning.md`
- `03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-b-project-intake-schema-options-planning.md`
- `03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-d0-client-scoped-project-initiation-and-idempotency-planning.md`
- `04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-c-project-intake-schema-confirmation.md`
- `05-review-and-test/2026-06-29-phase-1-slice-1p-g-c-r1-project-intake-schema-review.md`
- `00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

## 3. Core Product Policy

The moderated initiation form is always moderation-first, even if the respondent email appears to match an existing Client/contact.

Default flow:

```text
multi-step initiation form
-> email confirmation midpoint
-> confirmed submission
-> C1 moderation
-> create/link Client
-> future create/link Client user/member
-> create/link Project
```

Existing email/Client matches may provide matching hints and idempotency signals, but they must not auto-approve a submission or establish Client ownership.

Client ownership must not be inferred from:

- respondent email alone;
- organiser snapshot fields;
- proposed Client contact fields;
- public hidden fields;
- submitted `matchedClientId`, `approvedClientId` or `approvedProjectId` values.

Authenticated Client dashboard direct Project creation remains a later lane:

```text
1P-K0 - Client-Owned Project Lifecycle And Dashboard Management Planning
```

## 4. Recommended Router And Service Shape

Recommended router namespace:

```text
fund.projectIntake
```

Recommended files for the implementation slice:

```text
src/modules/fund/routers/project-intake.router.ts
src/modules/fund/services/project-intake.service.ts
src/modules/fund/lib/validation/project-intake.ts
```

All 1P-G-D procedures are C1 admin procedures:

- use existing FUND feature gating;
- require the same C1/admin permission convention as Products, Clients, Projects and Events;
- derive `organizationId` from the authenticated/effective tenant context;
- never accept `organizationId` from client input;
- scope all reads and writes to the current tenant.

## 5. C1 Form Management Services

Planned procedures:

```text
fund.projectIntake.forms.list
fund.projectIntake.forms.get
fund.projectIntake.forms.create
fund.projectIntake.forms.update
fund.projectIntake.forms.activate
fund.projectIntake.forms.pause
fund.projectIntake.forms.archive
fund.projectIntake.forms.restore
```

Purpose:

- allow C1 admins to define tenant-owned Project initiation forms;
- control whether a form is draft, active, paused or archived;
- prepare for future public rendering without implementing public rendering in this slice.

List behaviour:

- tenant-scoped only;
- archived hidden by default;
- support search by code, name, slug and source label;
- support status filtering;
- support safe sorting by name, status, updated date and created date.

Create/update fields:

- code;
- name;
- slug;
- status through explicit activate/pause/archive/restore procedures;
- description;
- instructions;
- source label;
- default Event;
- standalone Project allowance;
- existing Client selection allowance;
- allowed Client types;
- starts/ends dates;
- submission limit;
- success message;
- metadata only if existing safe JSON conventions are used.

Rules:

- code and slug remain unique per tenant;
- default Event must be same-tenant;
- archived forms cannot be edited until restored;
- restore should return the form to a non-public state, preferably `PAUSED` or `DRAFT`, so reactivation is explicit;
- public token handling should remain dormant until public form endpoints are planned.

## 6. Submission Review Services

Planned procedures:

```text
fund.projectIntake.submissions.list
fund.projectIntake.submissions.get
fund.projectIntake.submissions.updateReview
fund.projectIntake.submissions.markInReview
fund.projectIntake.submissions.markNeedsInfo
fund.projectIntake.submissions.reject
fund.projectIntake.submissions.markSpam
fund.projectIntake.submissions.cancel
```

Purpose:

- give C1 admins a moderated queue of confirmed Project Intake submissions;
- allow C1 review notes, status changes and matching decisions;
- avoid creating operational records until explicit approval actions are planned and accepted.

List behaviour:

- tenant-scoped only;
- filter by form, status, source, requested Event, matched Client and date range;
- search by respondent name/email, proposed Client name and proposed Project name;
- show matching hints without treating matches as ownership proof.

Detail behaviour:

- show submission form context;
- show respondent and proposed Client/Project fields;
- show requested Event/standalone/date context;
- show raw payload only to C1 admins if useful and safe;
- show matched/approved Client, Project and Event references where already present;
- show moderation decision, notes, reviewer and reviewed date.

Status transition guidance:

```text
SUBMITTED -> IN_REVIEW
SUBMITTED / IN_REVIEW -> NEEDS_INFO
SUBMITTED / IN_REVIEW / NEEDS_INFO -> REJECTED
SUBMITTED / IN_REVIEW / NEEDS_INFO -> SPAM
SUBMITTED / IN_REVIEW / NEEDS_INFO -> CANCELLED
SUBMITTED / IN_REVIEW / NEEDS_INFO -> APPROVED only through a later explicit approval service
```

The first implementation should avoid broad generic status mutation if explicit transition procedures are clearer and safer.

## 7. Email Confirmation Midpoint

The product flow should include an email confirmation midpoint before a public/new Client submission becomes actionable.

Target future behaviour:

```text
partial form entry
-> respondent email captured
-> confirmation token issued
-> respondent confirms email
-> confirmed submission becomes visible/actionable for C1 moderation
```

Current schema assessment:

- `FundProjectIntakeForm` has `publicTokenHash` and `publicTokenIssuedAt` for future form/link publication.
- `FundProjectIntakeSubmission` does not currently have `confirmedAt`, `confirmationTokenHash`, `confirmationTokenExpiresAt` or a dedicated partial-submission status.
- `FundProjectIntakeSubmission` defaults directly to `SUBMITTED`.

Schema gap:

```text
The current schema does not fully support email confirmation midpoint implementation without an additional confirmation/status design.
```

Recommended handling:

- document email confirmation as required for the public form slice;
- do not implement public submission endpoints in 1P-G-D;
- do not send emails or notifications in 1P-G-D;
- before public form implementation, plan whether to add confirmation fields to `FundProjectIntakeSubmission` or introduce a separate draft/partial submission model;
- store confirmation tokens as hashes with expiry and revocation rules;
- avoid making unconfirmed submissions actionable in C1 moderation.

## 8. Approval Service Boundary

1P-G-D should plan approval but should not implement operational approval automation unless a later implementation prompt explicitly accepts it.

Future approval actions may include:

```text
approve and link existing Client
approve and create new Client
approve and create Project
approve and link Event
approve and create/link primary Client user/member after future user model
```

Required approval rules:

- approval must be idempotent;
- approval must run inside a server-side transaction;
- repeated approval must not create duplicate Clients or Projects;
- if `approvedClientId` or `approvedProjectId` already exists, return or reuse the existing record;
- C1 must explicitly choose create-new or link-existing;
- existing email/Client matches are advisory hints only;
- cross-tenant Client/Event/Project ids must return `NOT_FOUND` or a safe validation error;
- approved Projects should start in a safe pre-operational state, likely `DRAFT`, until lifecycle policy is accepted.

Approval should not:

- create Client users/members until that model exists;
- send invitations;
- send notifications;
- open Store/public ordering;
- trigger production, dispatch, payment or commission workflows.

## 9. Client/User/Project Creation Boundary

Client:

- `FundClient` exists and can be linked after C1 decision.
- Proposed Client fields on a submission remain proposed data only.
- C1 approval must explicitly create or link the Client.

Client user/member:

- no `FundClientUser` or equivalent model exists yet;
- primary contact snapshots are not Client users;
- future Client user/member creation requires a separate schema and onboarding policy slice.

Project:

- Project creation from intake submissions should remain deferred until explicit approval-action implementation is accepted;
- future created Projects must set `FundProject.clientId` from C1-selected or otherwise trusted Client context;
- Project ownership must not use organiser snapshot fields or respondent email inference.

## 10. Tenant, Security And Trust Rules

All C1 procedures:

- derive tenant from the authenticated actor;
- use same-tenant relation checks for Form, Submission, Client, Event and Project references;
- require C1 FUND admin access;
- should return safe `NOT_FOUND` for cross-tenant ids.

Future public endpoints:

- must not trust hidden `clientId` fields;
- must not expose supplier/producer internals;
- must rate-limit submissions;
- must enforce payload size limits;
- must use spam controls;
- must use safe public error messages;
- must require email confirmation before moderation where policy requires it.

## 11. Zod And Payload Planning

Recommended validation groups:

```text
createProjectIntakeFormInput
updateProjectIntakeFormInput
listProjectIntakeFormsInput
getProjectIntakeFormInput
transitionProjectIntakeFormInput
listProjectIntakeSubmissionsInput
getProjectIntakeSubmissionInput
updateProjectIntakeSubmissionReviewInput
transitionProjectIntakeSubmissionInput
```

Form payloads should expose:

- id, code, slug, name, status;
- description/instructions/source label;
- default Event summary;
- standalone/existing Client allowance flags;
- allowed Client types;
- starts/ends dates and submission limits;
- created/updated/archive metadata according to C1 conventions.

Submission payloads should expose:

- id, status, source and source context;
- form summary;
- respondent fields;
- proposed Client and Project fields;
- requested Event/standalone/date fields;
- matched and approved references;
- moderation decision, notes, reviewer and reviewed date;
- created/updated timestamps.

Submission payloads should not expose:

- public token hashes;
- notification internals;
- unrelated Client users;
- Store, Orders, Sales/Reporting or Commerce data.

## 12. Audit Requirements

Audit should be recorded for meaningful C1 mutations where existing FUND conventions support it:

- form create;
- form update;
- form activate/pause/archive/restore;
- submission review update;
- submission status transition;
- future approval action;
- future operational record creation/linking from approval.

If audit conventions are not straightforward during implementation, the implementation should document the gap rather than inventing a new audit pattern.

## 13. Schema Gaps And Non-Blocking Findings

No schema blocker is identified for C1 admin form management and C1 submission review services.

Known schema gaps before wider intake/product behaviour:

1. Email confirmation midpoint is not fully represented on `FundProjectIntakeSubmission`.
2. Partial/unconfirmed submission state is not currently modelled.
3. Client users/members do not exist yet.
4. Client physical address and delivery inheritance are not modelled yet.
5. Approval action idempotency keys are not modelled separately.
6. Dynamic/custom form field definitions are not modelled as structured child records.
7. Notification/outbox handling is not part of the current schema.

These gaps do not block a C1-only moderation API/services slice, provided public form creation, email sending and approval automation remain deferred.

## 14. Recommended Implementation Split

Recommended next implementation split:

```text
1P-G-D1 - C1 Project Intake Form API/Services
1P-G-D2 - C1 Project Intake Submission Review API/Services
1P-G-D3 - Project Intake Approval Action Planning
1P-G-E - C1 Project Intake Moderation UI Planning
1P-G-F - Public Project Initiation Form And Email Confirmation Planning
```

`1P-K0 - Client-Owned Project Lifecycle And Dashboard Management Planning` remains the later lane for authenticated Client dashboard direct Project creation.

## 15. Explicit Non-Goals

Do not implement in 1P-G-D planning:

- application code;
- Prisma schema changes;
- migrations;
- routers;
- services;
- Zod schemas;
- UI;
- public form rendering;
- public submission endpoints;
- email sending;
- notifications;
- Client users/members;
- invitations;
- authenticated Client dashboard Project creation;
- Store;
- Orders;
- Commerce;
- Sales/Reporting;
- production/dispatch workflows;
- SeasonPro integration;
- Event/Catalogue/Product availability schema changes;
- delivery address fields.

Do not run:

- `db:push`;
- seed commands;
- reset commands.

## 16. Recommended Next Implementation Prompt

```text
Proceed with FUND Phase 1 Slice 1P-G-D1 implementation: C1 Project Intake Form API/Services.

Work on:
feature/fund-phase-1-c2-project-access

Use:
- isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-d-project-intake-moderation-api-services-planning.md
- current FUND router/service/Zod conventions
- current Client, Project and Event service patterns
- current audit and tenant-scoping conventions

Implement C1 Project Intake Form API/services only.

Add tenant-scoped C1 procedures under fund.projectIntake.forms for:
- list;
- get;
- create;
- update;
- activate;
- pause;
- archive;
- restore.

Use existing FUND feature gating and C1 admin access conventions.
Never accept organizationId from client input.
Do not implement submission review services, public form endpoints, email confirmation, approval actions, Client user creation, Project creation from submissions, notifications, Store, Orders, Commerce or SeasonPro integration.

Run:
- npx prisma validate
- npm run db:generate
- npm run type-check
- npm run verify
- git diff --check

Create implementation confirmation documentation.
Do not promote to main after implementation.
```
