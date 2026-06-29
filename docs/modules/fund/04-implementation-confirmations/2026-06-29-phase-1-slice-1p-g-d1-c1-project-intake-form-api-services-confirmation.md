# FUND Phase 1 Slice 1P-G-D1 - C1 Project Intake Form API/Services Confirmation

Date: 2026-06-29

## 1. Slice Name

FUND Phase 1 Slice 1P-G-D1 - C1 Project Intake Form API/Services

## 2. Implementation Summary

Implemented C1 admin API/services for managing Project Intake form definitions.

The implementation adds tenant-scoped procedures for:

- Project Intake form list;
- Project Intake form get/detail;
- Project Intake form create;
- Project Intake form update;
- Project Intake form activate;
- Project Intake form pause;
- Project Intake form archive;
- Project Intake form restore.

This slice manages form definitions only. It does not expose public forms, create submissions, send confirmation emails, generate confirmation tokens, review submissions, approve submissions, create Clients, create Client users/members or create Projects.

## 3. Files Changed

App repo:

- `src/modules/fund/lib/validation/project-intake.ts`
- `src/modules/fund/services/project-intake.service.ts`
- `src/modules/fund/routers/project-intake.router.ts`
- `src/modules/fund/routers/index.ts`

Docs repo:

- `isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-d1-c1-project-intake-form-api-services-confirmation.md`
- `isodocs/docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

## 4. Router / Service / Validation Structure

New router namespace:

```text
fund.projectIntake.forms
```

Procedures created:

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

Validation schemas created:

```text
projectIntakeFormListInputSchema
projectIntakeFormGetInputSchema
projectIntakeFormCreateInputSchema
projectIntakeFormUpdateInputSchema
projectIntakeFormArchiveInputSchema
projectIntakeFormIdInputSchema
```

Service functions created:

```text
listProjectIntakeForms
getProjectIntakeForm
createProjectIntakeForm
updateProjectIntakeForm
activateProjectIntakeForm
pauseProjectIntakeForm
archiveProjectIntakeForm
restoreProjectIntakeForm
```

## 5. Tenant Scoping And Access Control

All procedures:

- use `withFeature('fund')`;
- require `assertFundAdmin`;
- derive `organizationId` from the authenticated/effective tenant context;
- never accept `organizationId` from client input;
- scope all reads and writes to `actor.organizationId`;
- return safe `NOT_FOUND` for missing/cross-tenant form ids.

Default Event references are validated against the same C1 tenant before create/update.

## 6. Form Behaviour

Create:

- creates a current-tenant form only;
- defaults status to `DRAFT`;
- validates code and slug uniqueness per tenant;
- validates optional default Event as same-tenant;
- validates date windows when both start and end are set;
- defaults `requiresModeration` to true;
- does not issue public tokens.

Update:

- updates current-tenant forms only;
- rejects edits to archived forms until restored;
- updates safe form profile/configuration fields only;
- preserves public token fields untouched;
- validates same-tenant default Event when changed;
- validates date windows.

List/get:

- hide archived forms by default unless explicitly included;
- expose safe C1 admin form fields;
- include default Event summary where present;
- include submission counts;
- do not expose `publicTokenHash` or `publicTokenIssuedAt`.

## 7. Lifecycle Behaviour

Implemented lifecycle procedures:

```text
DRAFT -> ACTIVE
ACTIVE -> PAUSED
PAUSED -> ACTIVE
DRAFT / ACTIVE / PAUSED -> ARCHIVED
ARCHIVED -> PAUSED
```

Archive is soft archive only and sets:

- `status = ARCHIVED`;
- `archivedAt`;
- `archivedById`;
- `archivedReason`.

Restore clears archive fields and returns the form to `PAUSED`, so C1 must deliberately activate it again.

Hard delete is not exposed.

## 8. Audit Events

Audit records are written for meaningful C1 mutations:

- `FUND_PROJECT_INTAKE_FORM_CREATED`;
- `FUND_PROJECT_INTAKE_FORM_UPDATED`;
- `FUND_PROJECT_INTAKE_FORM_ACTIVATED`;
- `FUND_PROJECT_INTAKE_FORM_PAUSED`;
- `FUND_PROJECT_INTAKE_FORM_ARCHIVED`;
- `FUND_PROJECT_INTAKE_FORM_RESTORED`.

Audit records use entity type:

```text
FundProjectIntakeForm
```

## 9. Explicit Out Of Scope Confirmation

Not implemented:

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
- Store;
- Orders;
- Commerce Core;
- Sales/Reporting;
- production/dispatch workflows;
- SeasonPro integration;
- schema changes;
- migrations.

## 10. db:push / Seed / Reset Confirmation

Not run:

- `db:push`;
- seed commands;
- reset commands.

No Prisma schema changes or migrations were introduced in this slice.

## 11. Checks Run

App repo:

```text
npx prisma validate
npm run db:generate
npm run type-check
npm run verify
git diff --check
```

Results:

- `npx prisma validate` passed.
- `npm run db:generate` passed.
- `npm run type-check` passed.
- `npm run verify` initially hit the known sandbox IPC restriction from `tsx`; rerun outside the sandbox passed with all verifications.
- `git diff --check` passed.

Docs repo:

```text
git diff --check
```

Result:

- `git diff --check` passed.

## 12. Risks / Follow-Ups

Follow-ups:

- Review 1P-G-D1 before alignment.
- Implement `1P-G-D2 - C1 Project Intake Submission Review API/Services`.
- Plan public form rendering and email confirmation services separately before public launch.
- Keep approval automation and Client/user/Project creation from submissions in a later explicit approval-action slice.

Residual risks:

- Public token issuing remains dormant and unimplemented.
- Submission review queues are still not implemented.
- The first client-facing form UI still needs public form and email-confirmation service planning before build.

## 13. Recommended Next Slice

Recommended next slice:

```text
1P-G-D2 - C1 Project Intake Submission Review API/Services
```

This should implement C1 review of confirmed submissions only and continue to exclude public endpoint implementation, email sending, approval automation, Client users/members and Project creation unless separately accepted.
