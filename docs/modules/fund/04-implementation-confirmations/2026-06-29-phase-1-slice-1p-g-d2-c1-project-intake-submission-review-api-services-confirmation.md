# FUND Phase 1 Slice 1P-G-D2 - C1 Project Intake Submission Review API/Services Confirmation

Date: 2026-06-29

## 1. Slice Name

FUND Phase 1 Slice 1P-G-D2 - C1 Project Intake Submission Review API/Services

## 2. Implementation Summary

Implemented C1 admin API/services for reviewing confirmed Project Intake submissions.

The implementation adds tenant-scoped procedures for:

- Project Intake submission list;
- Project Intake submission get/detail;
- Project Intake submission review update;
- mark in review;
- mark needs info;
- reject;
- mark spam;
- cancel.

This slice gives C1 admins review/status tooling only. It does not implement public forms, public submission endpoints, email confirmation endpoints, email sending, token generation, approval automation, Client user/member creation or Project creation from submissions.

## 3. Files Changed

App repo:

- `src/modules/fund/lib/validation/project-intake.ts`
- `src/modules/fund/services/project-intake.service.ts`
- `src/modules/fund/routers/project-intake.router.ts`

Docs repo:

- `isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-d2-c1-project-intake-submission-review-api-services-confirmation.md`
- `isodocs/docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

## 4. Router / Service / Validation Structure

New router namespace:

```text
fund.projectIntake.submissions
```

Procedures created:

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

Validation schemas created:

```text
projectIntakeSubmissionListInputSchema
projectIntakeSubmissionGetInputSchema
projectIntakeSubmissionReviewUpdateInputSchema
projectIntakeSubmissionTransitionInputSchema
projectIntakeSubmissionIdInputSchema
```

Service functions created:

```text
listProjectIntakeSubmissions
getProjectIntakeSubmission
updateProjectIntakeSubmissionReview
markProjectIntakeSubmissionInReview
markProjectIntakeSubmissionNeedsInfo
rejectProjectIntakeSubmission
markProjectIntakeSubmissionSpam
cancelProjectIntakeSubmission
```

## 5. Tenant Scoping And Access Control

All procedures:

- use `withFeature('fund')`;
- require `assertFundAdmin`;
- derive `organizationId` from the authenticated/effective tenant context;
- never accept `organizationId` from client input;
- scope all reads and writes to `actor.organizationId`;
- return safe `NOT_FOUND` for missing/cross-tenant submission ids.

Matched Client and requested Event review references are validated against the same C1 tenant before update.

## 6. Moderation Queue Behaviour

Default list behaviour includes confirmed/actionable statuses:

```text
SUBMITTED
IN_REVIEW
NEEDS_INFO
REJECTED
CANCELLED
SPAM
ARCHIVED
```

Default list behaviour excludes:

```text
CONFIRMATION_PENDING
APPROVED
```

`CONFIRMATION_PENDING` remains unconfirmed and non-actionable by default.

Explicit status filtering is available for C1 diagnostic/admin review.

## 7. Payload Safety

Submission list/detail payloads include safe C1 review context:

- form summary;
- respondent fields;
- proposed Client fields;
- proposed Project fields;
- requested Event summary;
- matched Client summary;
- approved Client/Project/Event summaries where already present;
- moderation decision, notes, reviewer and review date;
- source context and raw payload for C1 admin review.

The service strips these internal fields from returned payloads:

```text
confirmationTokenHash
confirmationTokenExpiresAt
idempotencyKey
submissionFingerprint
```

No confirmation token hashes are exposed.

## 8. Review Update Behaviour

`updateReview` allows C1 admins to update review-support fields:

- moderation notes;
- matched Client id;
- requested Event id;
- safe non-approval moderation decision values.

Review updates do not create or link operational records.

## 9. Status Transition Behaviour

Implemented dedicated procedures:

```text
markInReview
markNeedsInfo
reject
markSpam
cancel
```

Implemented transitions:

```text
SUBMITTED -> IN_REVIEW
SUBMITTED / IN_REVIEW -> NEEDS_INFO
SUBMITTED / IN_REVIEW / NEEDS_INFO -> REJECTED
SUBMITTED / IN_REVIEW / NEEDS_INFO -> SPAM
SUBMITTED / IN_REVIEW / NEEDS_INFO -> CANCELLED
```

No generic arbitrary status mutation was introduced.

No `APPROVED` transition was implemented in this slice.

## 10. Audit Events

Audit records are written for meaningful C1 review mutations:

- `FUND_PROJECT_INTAKE_SUBMISSION_REVIEW_UPDATED`;
- `FUND_PROJECT_INTAKE_SUBMISSION_MARKED_IN_REVIEW`;
- `FUND_PROJECT_INTAKE_SUBMISSION_MARKED_NEEDS_INFO`;
- `FUND_PROJECT_INTAKE_SUBMISSION_REJECTED`;
- `FUND_PROJECT_INTAKE_SUBMISSION_MARKED_SPAM`;
- `FUND_PROJECT_INTAKE_SUBMISSION_CANCELLED`.

Audit records use entity type:

```text
FundProjectIntakeSubmission
```

## 11. Explicit Out Of Scope Confirmation

Not implemented:

- public form rendering;
- public submission endpoints;
- email confirmation endpoint;
- email sending;
- token generation;
- public link issuing;
- approval automation;
- approving submissions into Clients, Client users/members, Projects or Event links;
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
- `npm run type-check` initially found a nullable/non-nullable Prisma date-filter mismatch; this was corrected.
- `npm run type-check` passed after the correction.
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

- Review 1P-G-D2 before alignment.
- Plan `1P-G-D3 - Project Intake Approval Action Planning`.
- Keep approval automation and Client/user/Project creation from submissions in a later explicit approval-action slice.
- Plan public form rendering and email confirmation services separately before public launch.

Residual risks:

- There is still no C1 moderation UI for these review services.
- Approved submission handling remains intentionally deferred.
- Public form/email-confirmation services remain unimplemented.

## 15. Recommended Next Slice

Recommended next slice:

```text
1P-G-D3 - Project Intake Approval Action Planning
```

That slice should decide explicit approval actions for creating/linking Clients, future Client users/members and Projects from reviewed submissions.
