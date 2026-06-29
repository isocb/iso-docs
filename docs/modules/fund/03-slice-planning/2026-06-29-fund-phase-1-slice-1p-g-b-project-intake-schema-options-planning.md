# FUND Phase 1 Slice 1P-G-B - Project Intake Schema Options Planning

Date: 2026-06-29

Status: Planning only

## 1. Slice Goal

Decide the minimum safe Prisma schema direction for FUND Project Intake forms and moderated Project Request submissions.

This slice narrows the 1P-G-A moderation model into concrete schema options. It does not implement schema, migrations, API, UI, public forms, notifications or Client users.

Core decision:

```text
Project Intake submissions create moderation records only.
Operational records are created or linked later through explicit C1 moderation actions.
```

## 2. Current Accepted Baseline

Accepted foundation:

- `FundClient` exists and represents the C2 Client/account organisation.
- `FundProject.clientId` exists and is nullable.
- Project Client linkage API/UI has been implemented.
- 1P-H-C authenticated staging browser smoke testing passed with no remedial work required at this stage.
- Project Intake planning can depend on explicit Project-to-Client linkage.

Client organisation clarification:

- `FundClient` is the Client organisation/account, such as a school, club, PTA, charity branch or customer account.
- Client users/members are future login-capable users linked to the Client/account.
- Primary contact fields on `FundClient` remain C1 operational contact snapshots only. They are not the Client user model, login identity, invitation state, role membership, notification consent or access control.
- Future Client organisation details need structured physical address and delivery/fulfilment support before Store, Orders, Production or Dispatch.
- Projects should default or inherit delivery address from the linked Client where appropriate, but Project-level delivery snapshots and overrides need separate planning.
- Client-scoped Project initiation must use trusted Client route, token or authenticated context. Client ownership must not be inferred from organiser snapshot fields, respondent email alone, proposed Client contact fields alone or user-editable hidden fields.

Current branch baseline:

```text
feature/fund-phase-1-c2-project-access = 536c947
dev = 536c947
staging = 536c947
main = 62b727e
```

## 3. Recommended Schema Option

Recommended option:

```text
FUND-specific first, platform-aware.
```

Create:

- `FundProjectIntakeForm`
- `FundProjectIntakeSubmission`

Supporting enums:

- `FundProjectIntakeFormStatus`
- `FundProjectIntakeSubmissionStatus`
- `FundProjectIntakeSubmissionSource`
- `FundProjectIntakeModerationDecision`

Reason:

- The model is clearly FUND-specific in the near term.
- It can support public/embed/link use later without exposing operational records.
- It keeps Project Intake separate from Client user/member and notification architecture.
- It avoids premature reusable IsoStack form-builder scope.

## 4. Alternatives Considered

### Option A - Reusable IsoStack Intake/Form Core

Description:

Create a platform-wide form/intake framework first, then layer FUND Project Intake on top.

Rejected for now because:

- AMOW/FUND needs a focused Project Intake model.
- A reusable form-builder would expand scope into dynamic fields, validation, embeds, permissions and reporting.
- It risks blocking the AMOW workflow behind a platform abstraction.

### Option B - Direct Project Creation Endpoint

Description:

Allow public or C2 submissions to directly create `FundProject` records.

Rejected because:

- unknown respondents may not be authorised Client users;
- Client matching is a moderation decision;
- Event linkage needs C1 validation;
- notification and invitation boundaries are not planned;
- public endpoints must not create operational records automatically.

This rejection also applies to future Client-dashboard-originated Project requests until a controlled C2 Project initiation flow is explicitly planned. Existing Client users may eventually initiate additional Project requests from their dashboard, but the first intake model should still create a moderation record unless a later policy slice deliberately allows direct creation.

When direct creation is eventually planned, existing Client dashboard Project initiation should auto-scope the Project to the authenticated Client/account through trusted route/auth context. New Client / first Project intake may create or match Client/account, create or link a primary Client user/member and create a linked Project only after explicit C1 moderation/approval or a separately planned trusted direct-creation policy.

### Option C - Store Intake As Raw Issue / Change Request

Description:

Use the Issue Manager / CR flow for Project Intake.

Rejected because:

- Project Intake is a product workflow, not development issue evidence;
- C1 needs structured moderation and approval outputs;
- submissions may later drive Client/Project/Event creation.

## 5. Model Names And Table Names

Recommended Prisma models:

```text
FundProjectIntakeForm
FundProjectIntakeSubmission
```

Recommended mapped table names:

```text
fund_project_intake_forms
fund_project_intake_submissions
```

Recommended schema:

```text
@@schema("fund")
```

## 6. Enum Options

### FundProjectIntakeFormStatus

Recommended values:

- `DRAFT`
- `ACTIVE`
- `PAUSED`
- `ARCHIVED`

Rationale:

- `DRAFT` supports internal form preparation.
- `ACTIVE` supports accepting submissions later.
- `PAUSED` supports temporary suspension.
- `ARCHIVED` supports historical retention.

### FundProjectIntakeSubmissionStatus

Recommended values:

- `SUBMITTED`
- `IN_REVIEW`
- `NEEDS_INFO`
- `APPROVED`
- `REJECTED`
- `CANCELLED`
- `SPAM`
- `ARCHIVED`

Rationale:

- Separates moderation workflow from approval output.
- Keeps rejected/spam/cancelled records available for audit.
- Allows `ARCHIVED` without deleting evidence.

### FundProjectIntakeSubmissionSource

Recommended values:

- `PUBLIC_EMBED`
- `PUBLIC_LINK`
- `EMAIL_LINK`
- `CAMPAIGN_PAGE`
- `SEASONPRO_CLUB`
- `CLIENT_DASHBOARD`
- `C1_ADMIN_ENTRY`

Rationale:

- Captures where the request originated.
- Does not require SeasonPro integration yet.
- Leaves room for future authenticated Client dashboard requests.

Client dashboard clarification:

```text
CLIENT_DASHBOARD represents future Project initiation by an existing Client/account user.
```

The future Client dashboard is expected to become more than a passive Project display surface. It is expected to support Client Project initiation, engagement, C1 announcements, special offers/campaign prompts, 1:1 communication and dashboard-visible messages.

Those communications and engagement surfaces are deferred. The intake schema may record a Client dashboard submission source, but it must not imply notification sending, announcement delivery, messaging threads or Client dashboard communication implementation.

SeasonPro Club clarification:

```text
SEASONPRO_CLUB represents future Project initiation from a SeasonPro Club surface.
```

This source is future-facing. It depends on a SeasonPro League tenant having the FUND / Fundraising module enabled through subscription, League-level configuration of approved FUND producer tenant(s), catalogue availability to Clubs and an explicit SeasonPro Club to FUND Client/account mapping.

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

The Club should not see supplier/producer internals unless explicitly exposed. Product options should be presented as fundraising products available through the League/SeasonPro context, not as supplier-management records.

The SeasonPro Club should map to, create or link to a `FundClient` account. Any resulting FUND Project should use explicit `FundProject.clientId` linkage, not organiser snapshot fields or respondent email inference.

No SeasonPro integration is implemented by this schema slice. Until trusted direct creation is explicitly planned, SeasonPro Club-originated requests should create or route through moderated Project Intake submissions.

### FundProjectIntakeModerationDecision

Recommended values:

- `CREATE_CLIENT_AND_PROJECT`
- `LINK_CLIENT_CREATE_PROJECT`
- `CREATE_PROJECT_STANDALONE`
- `LINK_TO_EXISTING_PROJECT`
- `REQUEST_MORE_INFORMATION`
- `REJECT`
- `MARK_SPAM`
- `CANCEL`

Rationale:

- Captures the C1 decision separately from the current status.
- Allows audit/reporting on moderation outcome.
- Does not imply automatic execution until later service slices explicitly implement approval actions.

## 7. FundProjectIntakeForm Fields

Recommended fields:

- `id String @id @default(uuid())`
- `organizationId String @map("organization_id")`
- `code String`
- `name String`
- `slug String`
- `status FundProjectIntakeFormStatus @default(DRAFT)`
- `description String? @db.Text`
- `instructions String? @db.Text`
- `sourceLabel String? @map("source_label")`
- `defaultEventId String? @map("default_event_id")`
- `allowStandaloneProjects Boolean @default(true) @map("allow_standalone_projects")`
- `allowExistingClientSelection Boolean @default(false) @map("allow_existing_client_selection")`
- `allowedClientTypes Json @default("[]") @map("allowed_client_types")`
- `requiresModeration Boolean @default(true) @map("requires_moderation")`
- `startsAt DateTime? @map("starts_at")`
- `endsAt DateTime? @map("ends_at")`
- `submissionLimit Int? @map("submission_limit")`
- `successMessage String? @db.Text @map("success_message")`
- `publicTokenHash String? @map("public_token_hash")`
- `publicTokenIssuedAt DateTime? @map("public_token_issued_at")`
- `metadata Json @default("{}")`
- `archivedAt DateTime? @map("archived_at")`
- `archivedById String? @map("archived_by_id")`
- `archivedReason String? @db.Text @map("archived_reason")`
- `createdById String? @map("created_by_id")`
- `updatedById String? @map("updated_by_id")`
- `createdAt DateTime @default(now()) @map("created_at")`
- `updatedAt DateTime @updatedAt @map("updated_at")`

Recommended relations:

- `organization Organization`
- optional same-tenant `defaultEvent FundEvent?`
- `submissions FundProjectIntakeSubmission[]`

Notes:

- `publicTokenHash` stores a hash only. Do not store public bearer tokens in plain text.
- Public token handling should not be used until a public submission endpoint is separately planned.
- `requiresModeration` should remain true in first implementation even if present as a field.

## 8. FundProjectIntakeSubmission Fields

Recommended fields:

- `id String @id @default(uuid())`
- `organizationId String @map("organization_id")`
- `formId String @map("form_id")`
- `status FundProjectIntakeSubmissionStatus @default(SUBMITTED)`
- `source FundProjectIntakeSubmissionSource @default(PUBLIC_LINK)`
- `sourceContext Json @default("{}") @map("source_context")`
- `respondentName String? @map("respondent_name")`
- `respondentEmail String? @map("respondent_email")`
- `respondentPhone String? @map("respondent_phone")`
- `respondentRoleLabel String? @map("respondent_role_label")`
- `proposedClientName String? @map("proposed_client_name")`
- `proposedClientType String? @map("proposed_client_type")`
- `proposedClientContactName String? @map("proposed_client_contact_name")`
- `proposedClientContactEmail String? @map("proposed_client_contact_email")`
- `proposedClientContactPhone String? @map("proposed_client_contact_phone")`
- `proposedProjectName String? @map("proposed_project_name")`
- `proposedProjectDescription String? @db.Text @map("proposed_project_description")`
- `requestedEventId String? @map("requested_event_id")`
- `requestedStandalone Boolean? @map("requested_standalone")`
- `requestedStartsAt DateTime? @map("requested_starts_at")`
- `requestedClosesAt DateTime? @map("requested_closes_at")`
- `notes String? @db.Text`
- `rawPayload Json @default("{}") @map("raw_payload")`
- `matchedClientId String? @map("matched_client_id")`
- `approvedClientId String? @map("approved_client_id")`
- `approvedProjectId String? @map("approved_project_id")`
- `approvedEventId String? @map("approved_event_id")`
- `moderationDecision FundProjectIntakeModerationDecision? @map("moderation_decision")`
- `moderationNotes String? @db.Text @map("moderation_notes")`
- `reviewedById String? @map("reviewed_by_id")`
- `reviewedAt DateTime? @map("reviewed_at")`
- `createdAt DateTime @default(now()) @map("created_at")`
- `updatedAt DateTime @updatedAt @map("updated_at")`

Recommended relations:

- `organization Organization`
- same-tenant `form FundProjectIntakeForm`
- optional same-tenant `requestedEvent FundEvent?`
- optional same-tenant `matchedClient FundClient?`
- optional same-tenant `approvedClient FundClient?`
- optional same-tenant `approvedProject FundProject?`
- optional same-tenant `approvedEvent FundEvent?`

## 9. Tenant Scoping And Same-Tenant Relations

Required tenant boundary:

```text
organizationId = C1 tenant
```

Recommended same-tenant relations:

```text
FundProjectIntakeSubmission(organizationId, formId)
-> FundProjectIntakeForm(organizationId, id)

FundProjectIntakeForm(organizationId, defaultEventId)
-> FundEvent(organizationId, id)

FundProjectIntakeSubmission(organizationId, requestedEventId)
-> FundEvent(organizationId, id)

FundProjectIntakeSubmission(organizationId, matchedClientId)
-> FundClient(organizationId, id)

FundProjectIntakeSubmission(organizationId, approvedClientId)
-> FundClient(organizationId, id)

FundProjectIntakeSubmission(organizationId, approvedProjectId)
-> FundProject(organizationId, id)

FundProjectIntakeSubmission(organizationId, approvedEventId)
-> FundEvent(organizationId, id)
```

Recommendation:

- add `@@unique([organizationId, id])` to both intake models;
- use compound relations for same-tenant safety;
- use `onDelete: Restrict` for operational approval links;
- use `onDelete: Cascade` only from form to submissions if accepted after reviewing retention needs.

Retention preference:

```text
Do not hard-delete forms with submissions.
Use archive.
```

Therefore first implementation should prefer restrictive deletion rather than cascade deletion for moderated evidence.

## 10. Indexes And Uniqueness

Recommended `FundProjectIntakeForm` constraints:

- `@@unique([organizationId, id])`
- `@@unique([organizationId, code])`
- `@@unique([organizationId, slug])`
- `@@index([organizationId, status])`
- `@@index([organizationId, defaultEventId])`
- `@@index([archivedAt])`

Recommended `FundProjectIntakeSubmission` constraints:

- `@@unique([organizationId, id])`
- `@@index([organizationId, formId])`
- `@@index([organizationId, status])`
- `@@index([organizationId, source])`
- `@@index([organizationId, createdAt])`
- `@@index([organizationId, matchedClientId])`
- `@@index([organizationId, approvedClientId])`
- `@@index([organizationId, approvedProjectId])`
- `@@index([organizationId, requestedEventId])`
- `@@index([organizationId, approvedEventId])`
- `@@index([respondentEmail])`

PII note:

`respondentEmail` indexing supports moderation/search, but access must remain C1/admin only.

## 11. Public Slug / Token Strategy

Recommended first schema support:

- tenant-scoped `slug` for internal and future public route identity;
- nullable `publicTokenHash`;
- nullable `publicTokenIssuedAt`.

Do not implement public intake endpoint in the schema slice.

Future public route options:

```text
/fund/intake/[organizationSlug]/[formSlug]?token=...
/public/fund/intake/[formId-or-slug]?token=...
```

Rules:

- public tokens must be generated only by a later service slice;
- only token hashes should be stored;
- public endpoints must rate-limit and validate server-side;
- archived/paused/non-active forms must not accept submissions;
- public forms must not reveal private Client/Event/Product data unless explicitly published.

## 12. Raw Payload And PII Handling

`rawPayload` is useful for:

- moderation evidence;
- future field evolution;
- debugging public submission handling.

Rules:

- do not expose `rawPayload` to public users or C2 dashboards by default;
- keep C1/admin-only;
- avoid file uploads in raw payload;
- enforce payload size limits in future API;
- do not store secrets, public tokens or payment data.

## 13. Moderation Fields

Recommended first moderation fields:

- `status`
- `moderationDecision`
- `moderationNotes`
- `reviewedById`
- `reviewedAt`
- approval output ids:
  - `approvedClientId`
  - `approvedProjectId`
  - `approvedEventId`

Recommended future fields, deferred:

- assigned reviewer;
- duplicate group id;
- needs-info message;
- external respondent reply thread;
- notification/invitation ids.
- dashboard-visible announcement/message ids.
- special offer or campaign prompt ids.

Future dashboard-visible communication fields are deferred. Do not add announcement, offer, message-thread or communication-delivery fields to the intake schema in the first schema slice.

## 14. Approval Output Boundaries

Schema may store approval output links, but first implementation must not automatically execute approval workflows unless a later service slice explicitly plans and implements them.

Approval output links mean:

- C1 has reviewed the submission;
- C1 has created/linked an operational record by explicit action;
- the submission records that relationship for audit/history.

They do not mean:

- automatic Client creation;
- automatic Client user creation;
- automatic Project creation;
- automatic Event linkage;
- automatic notification sending.
- dashboard announcement/message creation.
- special offer or campaign prompt delivery.

## 15. Audit Requirements

Use existing `AuditLog` conventions rather than inventing a new audit table.

Recommended future audit actions:

- `FUND_PROJECT_INTAKE_FORM_CREATED`
- `FUND_PROJECT_INTAKE_FORM_UPDATED`
- `FUND_PROJECT_INTAKE_FORM_ACTIVATED`
- `FUND_PROJECT_INTAKE_FORM_PAUSED`
- `FUND_PROJECT_INTAKE_FORM_ARCHIVED`
- `FUND_PROJECT_INTAKE_SUBMISSION_RECEIVED`
- `FUND_PROJECT_INTAKE_SUBMISSION_STATUS_CHANGED`
- `FUND_PROJECT_INTAKE_SUBMISSION_REVIEWED`
- `FUND_PROJECT_INTAKE_SUBMISSION_APPROVED`
- `FUND_PROJECT_INTAKE_SUBMISSION_REJECTED`
- `FUND_PROJECT_INTAKE_SUBMISSION_MARKED_SPAM`
- `FUND_PROJECT_INTAKE_SUBMISSION_LINKED_CLIENT`
- `FUND_PROJECT_INTAKE_SUBMISSION_LINKED_PROJECT`

Audit metadata should include:

- form id/code/slug;
- submission id;
- previous/new status;
- moderation decision;
- source;
- linked Client id;
- linked Project id;
- linked Event id.

## 16. Migration / Backfill Strategy

Recommended migration strategy:

- create enums;
- create `fund_project_intake_forms`;
- create `fund_project_intake_submissions`;
- add indexes and same-tenant foreign keys;
- add `Organization` relations if needed by Prisma;
- no backfill;
- no seed data;
- no public forms created automatically.

Existing Clients, Projects and Events remain unchanged.

## 17. Implementation Boundary For Schema-Only Slice

The next schema-only implementation slice should implement only:

- enums;
- `FundProjectIntakeForm`;
- `FundProjectIntakeSubmission`;
- Organization relations if required;
- migration.

It must not implement:

- routers;
- services;
- Zod schemas;
- UI;
- public endpoints;
- embed scripts;
- Client user/member schema;
- invitations;
- notification sending;
- dashboard announcements;
- 1:1 Client communications;
- special offers or campaign prompts;
- approval automation;
- Project creation from submissions;
- Store;
- Orders;
- Commerce Core;
- Sales/Reporting;
- Communications;
- SeasonPro Club mapping implementation;
- Event/Catalogue/Product availability schema.

## 18. Risks And Open Decisions

Open decisions before schema implementation:

- Should `FundProjectIntakeForm.defaultEventId` be included now or deferred until Event-published-form planning?
- Should `publicTokenHash` be included now or deferred until public endpoint planning?
- Should form-to-submission delete use `Restrict` or `Cascade`? Recommendation: restrict/soft archive.
- Should `FundProjectIntakeModerationDecision` be an enum now or represented as text until moderation workflow stabilises? Recommendation: enum now.
- Should respondent email be indexed? Recommendation: yes, C1/admin-only search.

Risk:

- Adding too many public-form fields now may imply public endpoint readiness. Keep public submission implementation separate.

## 19. Recommended Next Slice

Recommended next slice:

```text
1P-G-C - Project Intake Schema
```

Goal:

```text
Implement the accepted schema-only foundation for Project Intake forms and moderated submissions.
```

Before implementation, confirm:

- enum names and values;
- whether `defaultEventId` is included now;
- whether `publicTokenHash` is included now;
- delete/archive strategy;
- final field list.

## 20. Recommended Implementation Prompt For 1P-G-C

```text
Proceed with FUND Phase 1 Slice 1P-G-C implementation: Project Intake schema only.

Work on:
feature/fund-phase-1-c2-project-access

Use:
- isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-b-project-intake-schema-options-planning.md
- isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-g-a-project-intake-schema-and-moderation-model-planning.md
- current Prisma schema conventions
- current FUND Client, Project and Event schema conventions

Implement schema only:
- FundProjectIntakeFormStatus enum;
- FundProjectIntakeSubmissionStatus enum;
- FundProjectIntakeSubmissionSource enum;
- FundProjectIntakeModerationDecision enum;
- FundProjectIntakeForm model;
- FundProjectIntakeSubmission model;
- Organization relations if required;
- same-tenant relations and indexes;
- migration.

Do not implement:
- routers;
- services;
- Zod schemas;
- UI;
- public endpoints;
- embed scripts;
- Client users/members;
- invitations;
- notification sending;
- approval automation;
- Project creation from submissions;
- Store;
- Orders;
- Commerce Core;
- Sales/Reporting;
- Communications;
- SeasonPro Club mapping implementation;
- Event/Catalogue/Product availability schema.

Do not run:
- db:push;
- seed commands;
- reset commands.

Run:
- npx prisma validate
- npm run db:generate
- npm run type-check
- npm run verify
- git diff --check

Create implementation confirmation document:
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-c-project-intake-schema-confirmation.md

Do not promote to main after implementation.
```
