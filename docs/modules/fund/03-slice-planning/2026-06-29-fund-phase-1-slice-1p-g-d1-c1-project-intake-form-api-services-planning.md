# FUND Phase 1 Slice 1P-G-D1 - C1 Project Intake Form API/Services Planning

Date: 2026-06-29

Status: Planning only

## 1. Slice Goal

Plan the C1 admin API/service layer for managing Project Intake forms.

This is the first implementation slice after the Project Intake email-confirmation schema addendum. It should give C1 admins controlled API/service support for creating and maintaining intake form definitions, without implementing public form rendering, public submission creation, email confirmation, submission review, approval automation or Project creation.

## 2. Dependencies

Required baseline:

- 1P-G-C Project Intake schema exists.
- 1P-G-C-R1 schema review passed.
- 1P-G-C2-A Project Intake Email Confirmation Schema Addendum is implemented and reviewed.
- 1P-G-D Project Intake Moderation API/Services planning is complete.
- `FundProjectIntakeForm` exists.
- `FundProjectIntakeSubmission` exists.
- `CONFIRMATION_PENDING` exists for later public/email-confirmed submission flow.
- Current FUND router/service/Zod conventions are established by Clients, Projects, Products, Catalogues and Events.

Relevant documents:

- `03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-d-project-intake-moderation-api-services-planning.md`
- `03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-c2-project-intake-email-confirmation-schema-addendum-planning.md`
- `04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-c2-a-project-intake-email-confirmation-schema-addendum-confirmation.md`
- `05-review-and-test/2026-06-29-phase-1-slice-1p-g-c2-a-r1-project-intake-email-confirmation-schema-addendum-review.md`
- `00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

## 3. Scope

Implement C1 admin Project Intake Form API/services only.

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

The slice prepares the admin-controlled form definition layer. It does not expose forms publicly or create submissions.

## 4. Recommended File Structure

Follow existing FUND conventions.

Recommended new files:

```text
src/modules/fund/routers/project-intake.router.ts
src/modules/fund/services/project-intake.service.ts
src/modules/fund/lib/validation/project-intake.ts
```

Recommended router mount:

```text
src/modules/fund/routers/index.ts
```

Mount as:

```text
projectIntake: projectIntakeRouter
```

This keeps the future submission-review procedures grouped under the same `fund.projectIntake` namespace.

## 5. Access Control And Tenant Scoping

All procedures must:

- use `withFeature('fund')`;
- require the same C1/admin permission convention as Products, Clients, Projects and Events;
- use `assertFundAdmin`;
- derive `organizationId` from the authenticated/effective tenant context;
- never accept `organizationId` from client input;
- return safe `NOT_FOUND` for cross-tenant ids;
- enforce same-tenant checks for default Event references.

This slice is C1 admin only. It must not use C2 organiser endpoints or participant-scoped access rules.

## 6. Form Model Behaviour

`FundProjectIntakeForm` represents a tenant-owned intake form definition.

Fields to expose in C1 form services:

- id;
- code;
- name;
- slug;
- status;
- description;
- instructions;
- source label;
- default Event summary;
- allow standalone Projects;
- allow existing Client selection;
- allowed Client types;
- requires moderation;
- starts/ends dates;
- submission limit;
- success message;
- metadata if existing safe JSON conventions are used;
- archive metadata;
- created/updated timestamps.

Do not expose raw public token hashes in list/get payloads.

`publicTokenHash` and `publicTokenIssuedAt` should remain dormant until public link/token issuing is explicitly planned.

## 7. List Behaviour

`fund.projectIntake.forms.list` should:

- list current tenant forms only;
- hide archived forms by default;
- include archived forms only when explicitly requested;
- support search by code, name, slug and source label;
- support status filter;
- support default Event filter if straightforward;
- support sorting by name, code, status, createdAt and updatedAt;
- return submission counts if straightforward and efficient.

Recommended safe list fields:

- id;
- code;
- name;
- slug;
- status;
- sourceLabel;
- defaultEvent summary;
- allowStandaloneProjects;
- allowExistingClientSelection;
- startsAt;
- endsAt;
- submissionLimit;
- submission count if implemented;
- createdAt;
- updatedAt;
- archivedAt.

## 8. Get Behaviour

`fund.projectIntake.forms.get` should:

- fetch one current-tenant form by id;
- return `NOT_FOUND` for missing/cross-tenant ids;
- include the full C1 admin form profile;
- include default Event summary where present;
- include submission count if straightforward;
- not include submission rows in this slice unless trivially count-only.

Submission review belongs to `1P-G-D2`.

## 9. Create Behaviour

`fund.projectIntake.forms.create` should:

- create a form in the current tenant only;
- normalise/validate code and slug consistently with existing FUND conventions;
- require code, name and slug;
- default status to `DRAFT`;
- validate default Event is same-tenant if supplied;
- validate date windows if both startsAt and endsAt are supplied;
- default `requiresModeration` to true;
- avoid issuing public tokens;
- write an audit event if current FUND audit conventions are straightforward.

Create must not:

- create submissions;
- send emails;
- generate public links/tokens;
- create Client, Client user/member, Project or Event linkage records.

## 10. Update Behaviour

`fund.projectIntake.forms.update` should:

- update current tenant forms only;
- reject updates to archived forms until restored;
- allow safe profile/configuration fields;
- avoid direct transition to `ARCHIVED`;
- use explicit activate/pause/archive/restore procedures for lifecycle changes;
- validate same-tenant default Event if changed;
- preserve public token fields untouched.

Recommended update fields:

- code;
- name;
- slug;
- description;
- instructions;
- sourceLabel;
- defaultEventId;
- allowStandaloneProjects;
- allowExistingClientSelection;
- allowedClientTypes;
- requiresModeration;
- startsAt;
- endsAt;
- submissionLimit;
- successMessage;
- metadata if safe conventions are used.

## 11. Status And Archive Behaviour

Recommended lifecycle:

```text
DRAFT -> ACTIVE
ACTIVE -> PAUSED
PAUSED -> ACTIVE
DRAFT / ACTIVE / PAUSED -> ARCHIVED
ARCHIVED -> PAUSED or DRAFT
```

Recommended procedure behaviour:

- `activate`: only non-archived forms; validates required fields and date windows.
- `pause`: active forms only; keeps public-facing implementation deferred.
- `archive`: soft archive only; sets status `ARCHIVED`, `archivedAt`, `archivedById`, `archivedReason`.
- `restore`: clears archive fields and returns status to `PAUSED` or `DRAFT` so public activation is explicit.

Recommended restore status:

```text
PAUSED
```

Rationale:

- restored forms should not immediately become active;
- C1 must deliberately activate the form after review.

Hard delete must not be exposed.

## 12. Validation Planning

Recommended schemas:

```text
projectIntakeFormListInputSchema
projectIntakeFormGetInputSchema
projectIntakeFormCreateInputSchema
projectIntakeFormUpdateInputSchema
projectIntakeFormArchiveInputSchema
projectIntakeFormIdInputSchema
```

Reuse existing FUND validation helpers where appropriate:

- `fundCodeSchema`;
- `fundSlugSchema`;
- `fundNameSchema`;
- `fundArchiveReasonSchema`;
- `fundMetadataSchema`.

Additional validation:

- source label max length;
- instructions/success message text max length;
- allowed Client types as a safe string array;
- submission limit positive integer;
- date windows valid when both sides are present;
- UUID validation for default Event id.

## 13. Audit Planning

Write audit events for meaningful C1 mutations where current conventions are straightforward:

- form create;
- form update;
- activate;
- pause;
- archive;
- restore.

Suggested entity type:

```text
FundProjectIntakeForm
```

If audit conventions are not straightforward during implementation, document the gap rather than inventing a different audit pattern.

## 14. Duplicate / Conflict Behaviour

Tenant-scoped uniqueness already exists for:

- code;
- slug.

Implementation should:

- perform explicit same-tenant uniqueness checks where consistent with existing services;
- convert Prisma `P2002` duplicate errors to `CONFLICT`;
- use clear messages such as:

```text
A Project Intake form with this code or slug already exists for this tenant
```

## 15. Explicit Non-Goals

Do not implement in 1P-G-D1:

- public form rendering;
- public submission endpoints;
- submission review list/get/status procedures;
- email confirmation endpoint;
- email sending;
- token generation;
- public link issuing;
- Client users/members;
- invitations;
- notifications;
- approval automation;
- Project creation from submissions;
- C2 Client dashboard Project creation;
- Store;
- Orders;
- Commerce;
- Sales/Reporting;
- production/dispatch workflows;
- SeasonPro integration;
- schema changes or migrations unless a genuine blocker is found first.

Do not run:

- `db:push`;
- seed commands;
- reset commands.

## 16. Checks For Implementation Slice

Implementation should run:

```text
npx prisma validate
npm run db:generate
npm run type-check
npm run verify
git diff --check
```

Docs updates should also run:

```text
docs git diff --check
```

## 17. Manual/API Review Checklist

Review should confirm:

- C1 admin can list forms in current tenant only.
- Archived forms are hidden by default.
- Include-archived filter works.
- C1 admin can create a DRAFT form.
- Duplicate code/slug returns `CONFLICT`.
- Default Event must be same-tenant.
- C1 admin can update safe fields.
- Archived forms cannot be updated until restored.
- Activate/pause/archive/restore use dedicated procedures.
- Restore does not immediately make the form active.
- No public token issuing occurs.
- No submissions are created.
- No email is sent.
- No Project, Client or Client user/member is created.

## 18. Recommended Implementation Prompt

```text
Proceed with FUND Phase 1 Slice 1P-G-D1 implementation: C1 Project Intake Form API/Services.

Work on:
feature/fund-phase-1-c2-project-access

Use:
- isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-d1-c1-project-intake-form-api-services-planning.md
- isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-c2-a-project-intake-email-confirmation-schema-addendum-confirmation.md
- current FUND router/service/Zod conventions
- current Client, Project and Event service patterns
- current audit and tenant-scoping conventions

Implement C1 Project Intake Form API/services only.

Add:
- project intake validation schemas;
- project intake service functions for forms;
- project intake router mounted under fund.projectIntake.forms;
- C1 admin procedures for list, get, create, update, activate, pause, archive and restore.

Requirements:
- use withFeature('fund');
- require assertFundAdmin;
- derive organizationId from actor/effective tenant context;
- never accept organizationId from client input;
- enforce same-tenant default Event references;
- hide archived forms by default;
- use soft archive only;
- convert duplicate code/slug conflicts to CONFLICT;
- write audit events where current conventions make this straightforward.

Do not implement:
- public form rendering;
- public submission endpoints;
- submission review services;
- email confirmation endpoint;
- email sending;
- token generation;
- public link issuing;
- Client users/members;
- invitations;
- notifications;
- approval automation;
- Project creation from submissions;
- C2 Client dashboard Project creation;
- Store, Orders, Commerce, Sales/Reporting, production/dispatch or SeasonPro integration;
- schema changes or migrations unless a blocker is identified and explained first.

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

Create implementation confirmation documentation.
Do not promote to main after implementation.
```

## 19. Recommended Next Slice

After 1P-G-D1 implementation and review:

```text
1P-G-D2 - C1 Project Intake Submission Review API/Services
```

That slice should implement C1 moderation queue/review services for confirmed submissions and should continue to exclude public endpoints, email sending and approval automation unless separately accepted.
