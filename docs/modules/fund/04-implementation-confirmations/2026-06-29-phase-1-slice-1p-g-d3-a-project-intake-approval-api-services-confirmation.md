# FUND Phase 1 Slice 1P-G-D3-A - Project Intake Approval API/Services Confirmation

Date: 2026-06-29

## 1. Slice Name

FUND Phase 1 Slice 1P-G-D3-A - Project Intake Approval API/Services

## 2. Implementation Summary

Implemented C1 admin Project Intake approval API/services.

The implementation adds explicit tenant-scoped approval procedures for:

- approval context;
- approve and create Client + Project;
- approve and link existing Client + create Project;
- approve standalone Project;
- return to review.

Approval actions create or link operational records only through explicit C1 action. They do not infer ownership from respondent email, organiser snapshots, proposed contact fields or hidden public fields.

## 3. Files Changed

App repo:

- `src/modules/fund/lib/validation/project-intake.ts`
- `src/modules/fund/services/project-intake.service.ts`
- `src/modules/fund/routers/project-intake.router.ts`

Docs repo:

- `isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-d3-project-intake-approval-action-planning.md`
- `isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-d3-a-project-intake-approval-api-services-confirmation.md`
- `isodocs/docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

## 4. Router / Service / Validation Structure

New router namespace:

```text
fund.projectIntake.approvals
```

Procedures created:

```text
fund.projectIntake.approvals.getContext
fund.projectIntake.approvals.approveCreateClientAndProject
fund.projectIntake.approvals.approveLinkClientCreateProject
fund.projectIntake.approvals.approveStandaloneProject
fund.projectIntake.approvals.returnToReview
```

Validation schemas created:

```text
projectIntakeApprovalContextInputSchema
projectIntakeApproveCreateClientAndProjectInputSchema
projectIntakeApproveLinkClientCreateProjectInputSchema
projectIntakeApproveStandaloneProjectInputSchema
projectIntakeApprovalReturnToReviewInputSchema
```

Service functions created:

```text
getProjectIntakeApprovalContext
approveCreateClientAndProject
approveLinkClientCreateProject
approveStandaloneProject
returnProjectIntakeApprovalToReview
```

## 5. Tenant Scoping And Access Control

All approval procedures:

- use `withFeature('fund')`;
- require `assertFundAdmin`;
- derive `organizationId` from the authenticated/effective tenant context;
- never accept `organizationId` from client input;
- scope all reads and writes to `actor.organizationId`;
- validate selected Client/Event references as same-tenant;
- create Clients and Projects inside the current C1 tenant only.

The approval lane creates C2 Client organisations/accounts and Projects for the current C1 tenant. It does not create new C1 tenant organisations.

## 6. Approval Actions

### Create Client And Project

Procedure:

```text
fund.projectIntake.approvals.approveCreateClientAndProject
```

Behaviour:

- requires C1-confirmed Client fields;
- creates a `FundClient` organisation/account;
- creates a `FundProject`;
- links the Project to the created Client through `FundProject.clientId`;
- optionally links the Project to a same-tenant Event;
- marks the submission `APPROVED`;
- sets `approvedClientId`, `approvedProjectId` and optional `approvedEventId`;
- sets moderation decision `CREATE_CLIENT_AND_PROJECT`.

### Link Client And Create Project

Procedure:

```text
fund.projectIntake.approvals.approveLinkClientCreateProject
```

Behaviour:

- validates selected same-tenant active Client;
- creates a `FundProject`;
- links the Project to the selected Client through `FundProject.clientId`;
- optionally links the Project to a same-tenant Event;
- marks the submission `APPROVED`;
- sets `approvedClientId`, `approvedProjectId` and optional `approvedEventId`;
- sets moderation decision `LINK_CLIENT_CREATE_PROJECT`.

### Standalone Project

Procedure:

```text
fund.projectIntake.approvals.approveStandaloneProject
```

Behaviour:

- requires the submission form to allow standalone Projects;
- creates a `FundProject` with `clientId = null`;
- optionally links the Project to a same-tenant Event;
- marks the submission `APPROVED`;
- sets `approvedProjectId` and optional `approvedEventId`;
- sets moderation decision `CREATE_PROJECT_STANDALONE`.

Standalone approval remains explicit because the strategic model is Client-owned Projects.

### Return To Review

Procedure:

```text
fund.projectIntake.approvals.returnToReview
```

Behaviour:

- returns eligible non-approved submissions to `IN_REVIEW`;
- refuses approved submissions;
- refuses `CONFIRMATION_PENDING` submissions so unconfirmed records cannot become actionable.

## 7. Idempotency And Transactions

Approval creation actions run inside server-side transactions.

If an approval action is retried after the submission is already `APPROVED`, the service returns the existing approved Client/Project/Event result rather than creating duplicate records.

Approval actions also:

- validate duplicate Client code/slug before Client creation;
- validate duplicate Project number/slug before Project creation;
- convert Prisma unique constraint failures to `CONFLICT`;
- write audit records inside the transaction.

## 8. Project Creation Defaults

Approved Projects are created as safe draft Projects:

- `status = DRAFT`;
- `lifecycleState = SETUP`;
- Store/public ordering is not opened;
- production, dispatch, payment and commission workflows are not triggered;
- organiser fields remain contact snapshots only;
- Client ownership is explicit through `FundProject.clientId`.

Project Event date constraints are validated when an Event is linked.

## 9. Client Creation Defaults

Created Clients are C2 organisation/account records in the current C1 tenant.

The services:

- create `FundClient` as `ACTIVE`;
- use C1-confirmed Client code, name, slug and client type;
- allow C1-confirmed primary contact snapshots;
- do not create login-capable Client users/members;
- do not create invitations;
- do not send notifications.

## 10. Audit Events

Audit records are written for:

- approval action selected;
- Client created from Project Intake;
- Project created from Project Intake.

Audit action names include:

```text
FUND_PROJECT_INTAKE_APPROVED_CREATE_CLIENT_AND_PROJECT
FUND_PROJECT_INTAKE_APPROVED_LINK_CLIENT_CREATE_PROJECT
FUND_PROJECT_INTAKE_APPROVED_STANDALONE_PROJECT
FUND_CLIENT_CREATED_FROM_PROJECT_INTAKE
FUND_PROJECT_CREATED_FROM_PROJECT_INTAKE
FUND_PROJECT_INTAKE_APPROVAL_RETURNED_TO_REVIEW
```

## 11. Explicit Out Of Scope Confirmation

Not implemented:

- public form rendering;
- public submission endpoints;
- email confirmation endpoint;
- email sending;
- token generation;
- public link issuing;
- Client users/members;
- invitations;
- notifications;
- C2 Client dashboard Project creation;
- Store;
- Orders;
- Commerce Core;
- Sales/Reporting;
- production/dispatch workflows;
- SeasonPro integration;
- C1 tenant creation;
- schema changes;
- migrations.

## 12. db:push / Seed / Reset Confirmation

Not run:

- `db:push`;
- seed commands;
- reset commands.

No Prisma schema changes or migrations were introduced in this slice.

## 13. Checks Run

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

## 14. Risks / Follow-Ups

Follow-ups:

- Review 1P-G-D3-A before alignment.
- Plan C1 Intake Approval UI, including the Project approvals summary card and row-click approval page.
- Plan Client users/members before any user creation or invitation behaviour.
- Plan public form rendering and email confirmation services separately before public launch.

Residual risks:

- Approval actions do not yet have C1 UI.
- No Client user/member is created, so approved Projects do not grant C2 dashboard access yet.
- Store/Commerce/production readiness gates remain future work.

## 15. Recommended Next Slice

Recommended next slice:

```text
1P-G-D3-A-R1 - Project Intake Approval API/Services Review
```

After review, proceed to C1 Project Intake approval UI planning.
