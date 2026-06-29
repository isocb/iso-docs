# FUND Phase 1 Slice 1P-G-A - Project Intake Schema And Moderation Model Planning

Date: 2026-06-25

Status: Planning only

## 1. Slice Goal

Plan the schema and moderation model for C1-created Project Intake forms and Project Request submissions.

Project Intake must let C1 users create forms that can be embedded or linked from controlled channels, while ensuring submissions do not directly create operational records.

Core rule:

```text
Submission creates a moderation record.
C1 approval creates or links operational records.
```

Operational records that may later be created or linked through moderation:

- Client/account;
- Client user/member;
- Project;
- Event linkage;
- future Product/Catalogue decisions after separate availability planning.

This slice is planning only. It does not implement schema, migrations, API, UI, public forms, Client users, notifications or Project creation flows.

## 2. Dependencies

Required foundation already in place:

- `FundClient` schema from 1P-F-C.
- C1 Client Management API/services from 1P-F-D.
- C1 Client Management UI from 1P-F-E.
- nullable `FundProject.clientId`.
- Project Client linkage API/services from 1P-H-A.
- Project Client selector/display UI from 1P-H-B.
- Project Client linkage review from 1P-H-C.
- Event, Project, Product and Catalogue C1 foundations from earlier Phase 1 slices.

Primary control documents:

- `00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`
- `03-slice-planning/2026-06-25-fund-phase-1-slice-1p-g-project-intake-client-onboarding-and-moderation-planning.md`
- `05-review-and-test/2026-06-25-phase-1-slice-1p-h-c-project-client-linkage-ui-review.md`

Important dependency decision:

```text
Project Intake should use explicit Client linkage, not organiserName/organiserEmail/organiserPhone inference.
```

## 3. Product Model

Project Intake forms are created by C1 users.

Forms may be exposed through:

- embedded website forms;
- email links;
- campaign pages;
- SeasonPro Club views;
- future Client dashboards;
- QR/offline campaign links.

The form audience may include:

- unknown external respondents;
- existing Client contacts without login;
- authenticated C2 users in a future Client dashboard;
- SeasonPro Club users in a future integrated flow.

Submissions are moderation inputs, not operational records.

### SeasonPro Club-Originated Project Initiation (Future)

SeasonPro Club-originated Project initiation is a future FUND intake path.

Where a SeasonPro League has the FUND / Fundraising module enabled through its subscription, the League tenant may configure fundraising availability for its Clubs. The League may choose which approved FUND producer tenant(s), such as AMOW, and which fundraising catalogue/product options are available to Clubs.

Future Club-facing flow:

```text
SeasonPro Club dashboard
-> Start fundraising Project
-> choose available fundraising catalogue / product options
-> choose sale method
-> submit Project request / create Project according to configured policy
```

Possible sale methods to preserve for later planning:

- direct purchase, for example parent/customer pays through a public Store;
- club-funded purchase, for example the Club is invoiced;
- bulk purchase via Store or campaign order workflow.

The Club should not see supplier/producer internals unless explicitly planned. Product options should be presented as fundraising products available through the League/SeasonPro context, not as supplier-management records.

The SeasonPro Club should map to, create or link to a FUND Client/account. Any resulting FUND Project must use explicit Client linkage through `FundProject.clientId`, not organiser snapshot fields or respondent email inference.

Until trusted direct creation is explicitly planned, this path should create or route through a moderated Project Intake submission using source `SEASONPRO_CLUB`.

This planning note does not implement SeasonPro integration, Store, Orders, Commerce, notification sending or public intake forms.

## 4. Proposed Models / Entities

Recommended first schema direction:

```text
FundProjectIntakeForm
FundProjectIntakeSubmission
```

Possible supporting enums:

```text
FundProjectIntakeFormStatus
FundProjectIntakeSubmissionStatus
FundProjectIntakeSubmissionSource
FundProjectIntakeModerationDecision
```

Do not implement:

- `FundClientUser` / Client member schema in this slice unless a later Client-user planning slice accepts it;
- notification queue schema;
- Store/order/commerce schema;
- Event/Catalogue/Product availability schema.

## 5. Form Definition Model

Recommended `FundProjectIntakeForm` concept:

- tenant-scoped to C1 `organizationId`;
- created and managed by C1 admin users;
- controls what data is requested from respondents;
- controls whether requests are for a specific Event or may be standalone;
- creates submissions for C1 moderation.

Suggested fields:

- `id`
- `organizationId`
- `code`
- `name`
- `slug`
- `status`
- `description`
- `instructions`
- `sourceLabel`
- `defaultEventId`
- `allowStandaloneProjects`
- `allowExistingClientSelection`
- `allowedClientTypes`
- `requiresModeration`
- `startsAt`
- `endsAt`
- `submissionLimit`
- `successMessage`
- `metadata`
- `archivedAt`
- `archivedById`
- `archivedReason`
- `createdById`
- `updatedById`
- `createdAt`
- `updatedAt`

Recommended first status values:

- `DRAFT`
- `ACTIVE`
- `PAUSED`
- `ARCHIVED`

First implementation should require moderation even if the model includes `requiresModeration`, because direct operational creation is too risky until downstream Client/user/project automation is proven.

## 6. Intake Form Fields

The first form definition should support a controlled default field set rather than a fully dynamic form builder.

Recommended initial respondent fields:

- respondent name;
- respondent email;
- respondent phone;
- respondent role/relationship to Client;
- consent/confirmation checkbox text if required later.

Recommended Client/account fields:

- proposed Client name;
- Client type;
- main contact name;
- main contact email;
- main contact phone;
- address fields later if Client organisation details planning accepts them;
- existing Client reference only if the form is scoped to authenticated or known Client users.

Recommended Project fields:

- Project name;
- Project purpose/description;
- desired fundraising window or target date;
- expected participant/group context;
- Event preference if the form is not fixed to one Event;
- free-text notes.

Deferred form fields:

- product selection;
- catalogue selection;
- workflow suitability;
- Store options;
- sales targets;
- payment/checkout details;
- artwork/upload fields;
- communication preferences beyond explicit consent capture.

## 7. Submission Model

Recommended `FundProjectIntakeSubmission` concept:

- tenant-scoped to C1 `organizationId`;
- belongs to an intake form;
- stores raw respondent/project/client request data as moderation evidence;
- optionally references matched/approved operational records after C1 decision.

Suggested fields:

- `id`
- `organizationId`
- `formId`
- `status`
- `source`
- `sourceContext`
- `respondentName`
- `respondentEmail`
- `respondentPhone`
- `respondentRoleLabel`
- `proposedClientName`
- `proposedClientType`
- `proposedClientContactName`
- `proposedClientContactEmail`
- `proposedClientContactPhone`
- `proposedProjectName`
- `proposedProjectDescription`
- `requestedEventId`
- `requestedStandalone`
- `requestedStartsAt`
- `requestedClosesAt`
- `notes`
- `rawPayload`
- `matchedClientId`
- `approvedClientId`
- `approvedProjectId`
- `approvedEventId`
- `moderationDecision`
- `moderationNotes`
- `reviewedById`
- `reviewedAt`
- `createdAt`
- `updatedAt`

Privacy note:

`rawPayload` should be treated as moderation evidence and should not be exposed to public or C2 views by default.

## 8. Submission Source

Recommended source values:

- `PUBLIC_EMBED`
- `PUBLIC_LINK`
- `EMAIL_LINK`
- `CAMPAIGN_PAGE`
- `SEASONPRO_CLUB`
- `CLIENT_DASHBOARD`
- `C1_ADMIN_ENTRY`

Purpose:

- help C1 understand where the request came from;
- support future anti-spam and attribution;
- support future SeasonPro integration without coupling schema too early.

## 9. Moderation Status Workflow

Recommended submission statuses:

- `SUBMITTED`
- `IN_REVIEW`
- `NEEDS_INFO`
- `APPROVED`
- `REJECTED`
- `CANCELLED`
- `SPAM`
- `ARCHIVED`

Recommended transitions:

```text
SUBMITTED -> IN_REVIEW
SUBMITTED -> SPAM
SUBMITTED -> REJECTED
IN_REVIEW -> NEEDS_INFO
IN_REVIEW -> APPROVED
IN_REVIEW -> REJECTED
NEEDS_INFO -> IN_REVIEW
NEEDS_INFO -> CANCELLED
APPROVED -> ARCHIVED
REJECTED -> ARCHIVED
SPAM -> ARCHIVED
```

Approval should be a deliberate C1 action.

Rejected/spam/cancelled submissions must not create operational records.

## 10. Unknown Respondent Flow

Unknown respondent flow:

```text
unknown respondent
-> public/embed/link intake form
-> FundProjectIntakeSubmission
-> C1 moderation
-> create/link Client only if approved
-> create/link Client user/member only after a future Client-user model exists
-> create Project only if approved
```

Unknown respondent submissions must not automatically:

- create a platform User;
- create a Client user/member;
- create a Client;
- create a Project;
- link to an Event;
- send invitations;
- send notifications.

C1 moderation should provide matching context:

- possible existing Clients by name/email/domain;
- possible duplicate submissions;
- possible existing Projects;
- requested Event if supplied.

## 11. Existing Client / C2 User Flow

Future existing Client flow:

```text
authenticated C2 user
-> future Client dashboard intake entry
-> submission scoped to Client/account
-> optional C1 moderation
-> Project created under approved Client
```

This depends on a future accepted Client user/member model.

Until then:

- public intake may collect claimed Client information;
- C1 must approve and link to an existing Client manually;
- no submission should rely solely on respondent email as proof of Client authority.

## 12. New Client / First Project Flow

New Client / first Project approval should support:

1. Create a new `FundClient` from moderated organisation details.
2. Optionally create/link a future Client user/member after that model exists.
3. Create a DRAFT `FundProject`.
4. Link Project to the new Client.
5. Optionally link Project to an Event if requested and valid.

Important:

```text
Primary contact snapshots may be copied to Client contact fields only by explicit C1 approval.
They must not create users or invitations automatically.
```

## 13. Existing Client / Additional Project Flow

Existing Client / additional Project approval should support:

1. Link submission to an existing active Client.
2. Create a DRAFT Project under that Client.
3. Link to a valid Event where appropriate.
4. Keep Project standalone where allowed.

Rules:

- archived Clients cannot receive new Projects;
- inactive Clients should require explicit restore/reactivation before new Projects;
- Client linkage must use the existing same-tenant Client relation;
- organiser snapshot fields remain optional contact snapshots, not ownership proof.

## 14. Event-Linked Vs Standalone Rules

Intake forms may be:

- fixed to one Event;
- allow Event choice from C1-approved Events;
- allow standalone Projects only;
- allow either Event-linked or standalone requests.

Approval must respect current Project/Event rules:

- linked Event must be same tenant;
- Event must be eligible for new Project linkage;
- Project open/close/production dates must satisfy Event constraints;
- Event close date may provide effective Project close date when Project close date is blank;
- standalone Project activation still requires a Project close date.

Do not introduce Store close-date semantics in intake planning.

## 15. Client Linkage Dependency

Project Intake depends on accepted Project Client linkage.

Approval output should use:

```text
FundProject.clientId
```

It must not infer Client ownership from:

- Project organiser name;
- Project organiser email;
- Project organiser phone;
- respondent email alone;
- free-text Client name alone.

The moderation UI should make the Client decision explicit:

- create new Client;
- link existing Client;
- leave Project standalone where policy allows;
- reject submission.

## 16. Client User / Member Boundary

Future model direction:

```text
FundClient = organisation/account.
Client user/member = person linked to Client.
User = authenticated platform identity.
Client role = future role label/access concept.
```

In this planning slice:

- do not create Client users;
- do not create platform Users;
- do not create invitations;
- do not treat respondent as authenticated;
- do not treat primary contact fields as access control.

Moderation may capture a future desired action:

```text
Create/link Client user/member later
```

But implementation must wait for the Client user/member planning slice.

## 17. Notification / Invitation Boundary

No notification or invitation should be sent automatically from:

- form creation;
- form publication;
- submission receipt;
- Client creation;
- Client linkage;
- Project creation;
- Event linkage;
- approval/rejection.

Future notification work must define:

- templates;
- recipient selection;
- consent/legal basis;
- queueing/sending rules;
- audit events;
- preview/test-send behaviour;
- failure/retry handling.

Until then, UI may show local success messages only.

## 18. Audit Requirements

Future implementation should write audit events for:

- intake form created;
- intake form updated;
- intake form activated/paused/archived/restored;
- submission received;
- submission status changed;
- submission assigned/reviewed;
- submission approved/rejected/spam/cancelled;
- Client created from submission;
- Client linked from submission;
- Project created from submission;
- Event linked from submission;
- moderation notes changed.

Audit metadata should include:

- form id/code;
- submission id;
- source;
- approved Client id;
- approved Project id;
- approved Event id;
- reviewer id;
- decision/status transition.

## 19. Security / Anti-Spam Considerations

Public embedded or linked forms need explicit controls before implementation:

- tenant/form slug must not leak private tenant data;
- inactive/archived forms must not accept submissions;
- rate limiting;
- honeypot or equivalent bot trap;
- optional captcha/turnstile if needed;
- submission payload size limits;
- file upload disabled until an asset workflow exists;
- server-side validation for all public fields;
- audit/source tracking;
- safe success/error messages;
- no public enumeration of Clients, Events, Products or Projects unless explicitly exposed;
- private Client/Event ids should not be blindly trusted from public submissions.

Recommended first implementation:

```text
C1 internal form definition and moderation schema first.
Public submission endpoint later.
```

## 20. Public Embedded Form Constraints

Public forms should be constrained:

- one public form slug/code per tenant/form;
- no authenticated C1 admin data in public payloads;
- no direct Client/Project/Event creation;
- no product/order/payment collection;
- no file uploads;
- no invitation sending;
- no notification sending;
- no hidden operational status changes.

For Event-linked campaign forms, public display may show a human-friendly Event name/dates only if C1 explicitly publishes that form.

## 21. C1 Moderation UI Implications

Future moderation UI should support:

- intake form list/detail;
- submission inbox;
- status filters;
- source filters;
- duplicate/match hints;
- review notes;
- create Client from submission;
- link existing Client;
- create Project from approved submission;
- link Event where allowed;
- reject/spam/cancel actions;
- audit/history view.

It should not initially support:

- automatic Client user creation;
- invitation sending;
- notification sending;
- Store/order/payment setup;
- product/catalogue selection except as read-only notes or future planning markers.

## 22. Approval Outputs

Approval outputs may include:

- `approvedClientId`
- `approvedProjectId`
- `approvedEventId`
- future `approvedClientUserId` after Client user/member model exists

Approval should produce a DRAFT Project first.

Project activation remains governed by existing Project readiness rules:

- effective close date;
- Event date constraints;
- at least one active Project Product;
- valid workflow/product states;
- server-side activation checks.

## 23. What Remains Deferred

Deferred:

- Prisma schema implementation;
- migrations;
- routers/services/Zod;
- public Project Intake forms;
- embedded forms;
- C1 moderation UI;
- Client users/members;
- platform User creation;
- invitations;
- notification sending;
- Project Intake approval automation;
- Product/Catalogue availability decisions;
- Store;
- Orders;
- Commerce Core;
- Sales/Reporting;
- Communications;
- key-date automation;
- SeasonPro Club integration implementation;
- file uploads/artwork workflows.

## 24. Implementation Split

Recommended split:

### 1P-G-B - Project Intake Schema Options

Planning only:

- confirm model names;
- confirm enum values;
- confirm required fields;
- confirm relation shape;
- confirm public-token/slug strategy;
- confirm audit/event plan.

### 1P-G-C - Project Intake Schema

Schema only:

- `FundProjectIntakeForm`;
- `FundProjectIntakeSubmission`;
- enums;
- indexes;
- tenant scoping;
- no public endpoint;
- no UI.

### 1P-G-D - C1 Intake API/Services

C1 admin API/services:

- form list/get/create/update/archive;
- submission list/get/review/status;
- no approval automation beyond status change unless separately accepted.

### 1P-G-E - C1 Intake Moderation UI

C1 admin UI:

- form management;
- submission inbox/detail;
- review notes/status;
- no public forms yet.

### 1P-G-F - Public Submission Endpoint Planning

Planning only before public exposure:

- anti-spam;
- rate limits;
- safe public payload;
- embed constraints.

## 25. Recommended Next Slice

Recommended next slice:

```text
1P-G-B - Project Intake Schema Options
```

Goal:

```text
Decide exact Prisma model, enum, relation and migration shape for Project Intake forms and submissions.
```

Do not implement schema until 1P-G-B is reviewed and accepted.

## 26. Recommended Implementation Prompt For 1P-G-B

```text
Proceed with FUND Phase 1 Slice 1P-G-B planning only: Project Intake Schema Options.

Work on:
feature/fund-phase-1-c2-project-access

Use:
- isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-g-a-project-intake-schema-and-moderation-model-planning.md
- isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-g-project-intake-client-onboarding-and-moderation-planning.md
- current Client schema/API/UI confirmations
- current Project Client linkage confirmations and review
- current Project/Event/Product/Catalogue planning documents
- roadmap/control document
- current Prisma schema conventions

Goal:
Decide the exact schema direction for Project Intake forms and moderated submissions.

Planning only.

Cover:
1. Model names and ownership.
2. Form status enum.
3. Submission status enum.
4. Submission source enum.
5. Required form fields.
6. Required submission fields.
7. Relations to Organization, FundClient, FundProject and FundEvent.
8. Tenant scoping and indexes.
9. Public slug/token strategy.
10. Raw payload and PII handling.
11. Moderation fields and audit requirements.
12. Migration/backfill strategy.
13. Implementation boundary for schema-only slice.

Do not implement application code.
Do not edit Prisma schema.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.
Do not send notifications.
Do not create Client users.
Do not implement public forms.
```
