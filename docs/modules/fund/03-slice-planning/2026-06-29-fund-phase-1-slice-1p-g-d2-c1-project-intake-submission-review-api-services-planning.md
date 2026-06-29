# FUND Phase 1 Slice 1P-G-D2 - C1 Project Intake Submission Review API/Services Planning

Date: 2026-06-29

Status: Planning only

## 1. Slice Goal

Plan the C1 admin API/service layer for reviewing confirmed Project Intake submissions.

This slice follows 1P-G-D1, which implemented C1 Project Intake form definition services. D2 should give C1 admins a tenant-scoped moderation queue for confirmed submissions without implementing public form endpoints, email sending, approval automation, Client user/member creation or Project creation from submissions.

## 2. Dependencies

Required baseline:

- 1P-G-C Project Intake schema exists.
- 1P-G-C2-A email confirmation schema addendum exists.
- 1P-G-D1 C1 Project Intake Form API/services is implemented.
- `CONFIRMATION_PENDING` represents unconfirmed public/multi-step submissions.
- `SUBMITTED` remains the first confirmed/actionable C1 moderation status.
- Current FUND router/service/Zod conventions are established by Clients, Projects, Events and Project Intake forms.

Relevant documents:

- `03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-d-project-intake-moderation-api-services-planning.md`
- `03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-d1-c1-project-intake-form-api-services-planning.md`
- `04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-d1-c1-project-intake-form-api-services-confirmation.md`
- `03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-c2-project-intake-email-confirmation-schema-addendum-planning.md`
- `00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

## 3. Scope

Implement C1 admin Project Intake submission review API/services only.

Planned procedures:

```text
fund.projectIntake.submissions.list
fund.projectIntake.submissions.get
fund.projectIntake.submissions.markInReview
fund.projectIntake.submissions.markNeedsInfo
fund.projectIntake.submissions.reject
fund.projectIntake.submissions.markSpam
fund.projectIntake.submissions.cancel
fund.projectIntake.submissions.updateReview
```

The slice should expose confirmed submissions for C1 moderation and allow safe review/status updates. It must not approve submissions into operational records yet.

## 4. Recommended File Structure

Extend the D1 files:

```text
src/modules/fund/lib/validation/project-intake.ts
src/modules/fund/services/project-intake.service.ts
src/modules/fund/routers/project-intake.router.ts
```

Keep the namespace:

```text
fund.projectIntake.submissions
```

## 5. Access Control And Tenant Scoping

All procedures must:

- use `withFeature('fund')`;
- require `assertFundAdmin`;
- derive `organizationId` from authenticated/effective tenant context;
- never accept `organizationId` from client input;
- scope all reads/writes to current tenant;
- return safe `NOT_FOUND` for missing/cross-tenant submission ids;
- enforce same-tenant checks for form, Client, Event and Project references used as review hints.

This slice is C1 admin only.

## 6. Queue Behaviour

Default queue should include confirmed/actionable statuses:

```text
SUBMITTED
IN_REVIEW
NEEDS_INFO
REJECTED
CANCELLED
SPAM
ARCHIVED
```

Default queue should exclude:

```text
CONFIRMATION_PENDING
APPROVED
```

Rationale:

- `CONFIRMATION_PENDING` is not actionable because email confirmation has not completed.
- `APPROVED` records belong to the later approval-action/read-history flow.

The list endpoint should support explicit status filtering, including `CONFIRMATION_PENDING`, for C1 diagnostic/admin use only if useful. Default behaviour must keep unconfirmed submissions out of the working moderation queue.

## 7. List Behaviour

`fund.projectIntake.submissions.list` should:

- list current-tenant submissions only;
- default to confirmed/actionable statuses;
- support status filter;
- support form filter;
- support source filter;
- support requested Event filter;
- support matched Client filter;
- support created/submitted date range if straightforward;
- support search across respondent name/email, proposed Client name and proposed Project name;
- sort by submittedAt/createdAt/updatedAt;
- include safe form summary;
- include safe requested Event and matched Client summaries where present.

Recommended list payload:

- id;
- status;
- source;
- form summary;
- respondent name/email/phone/role;
- proposed Client name/type;
- proposed Project name;
- requested Event summary;
- matched Client summary;
- submittedAt;
- confirmedAt;
- reviewedAt;
- createdAt;
- updatedAt.

Do not expose confirmation token hashes.

## 8. Get Behaviour

`fund.projectIntake.submissions.get` should:

- fetch one current-tenant submission;
- return safe `NOT_FOUND` for missing/cross-tenant ids;
- include form context;
- include respondent fields;
- include proposed Client fields;
- include proposed Project fields;
- include requested Event/standalone/date context;
- include source context and raw payload for C1 admins only;
- include matched/approved Client, Project and Event summaries where present;
- include moderation decision, notes, reviewer and reviewed date.

Detail payload should not expose:

- confirmation token hash;
- unrelated Client users/members;
- invitations;
- notifications;
- Store, Orders, Commerce, Sales/Reporting or production data.

## 9. Review Update Behaviour

`fund.projectIntake.submissions.updateReview` should allow C1 admins to update moderation-support fields without changing status unless explicitly accepted:

- moderation notes;
- matched Client id;
- requested Event id if used as review context;
- advisory moderation decision if required by current schema;
- safe source/raw payload annotations only if existing JSON conventions make this straightforward.

Rules:

- matched Client id must be same-tenant.
- requested/approved Event ids must be same-tenant.
- approved Client/Project/Event fields should not be set by this slice unless needed for historical display and explicitly guarded.
- respondent email and proposed Client fields remain evidence only, not ownership proof.

## 10. Status Transition Behaviour

Recommended explicit procedures:

```text
markInReview
markNeedsInfo
reject
markSpam
cancel
```

Recommended transitions:

```text
SUBMITTED -> IN_REVIEW
SUBMITTED / IN_REVIEW -> NEEDS_INFO
SUBMITTED / IN_REVIEW / NEEDS_INFO -> REJECTED
SUBMITTED / IN_REVIEW / NEEDS_INFO -> SPAM
SUBMITTED / IN_REVIEW / NEEDS_INFO -> CANCELLED
```

Do not implement generic arbitrary status mutation.

Do not implement `APPROVED` transition in this slice unless the implementation prompt explicitly accepts approval without operational record creation. Preferred position: approval is deferred to `1P-G-D3`.

## 11. Matching And Ownership Boundary

C1 review may show or store advisory matches.

Matching hints may include:

- respondent email;
- proposed Client name;
- proposed organisation/contact fields;
- future Client/user/member matches.

Matching hints must not:

- establish Client ownership;
- bypass moderation;
- create Client users;
- create Projects;
- link Projects to Clients automatically;
- send invitations or notifications.

Client ownership must come from explicit C1 approval action, authenticated Client context, trusted token/route context or future trusted SeasonPro context.

## 12. Audit Requirements

Write audit events for meaningful C1 review mutations where current FUND conventions are straightforward:

- submission review updated;
- submission marked in review;
- submission marked needs info;
- submission rejected;
- submission marked spam;
- submission cancelled.

Suggested entity type:

```text
FundProjectIntakeSubmission
```

If audit conventions are not straightforward during implementation, document the gap rather than inventing a different audit pattern.

## 13. Validation Planning

Recommended schemas:

```text
projectIntakeSubmissionListInputSchema
projectIntakeSubmissionGetInputSchema
projectIntakeSubmissionReviewUpdateInputSchema
projectIntakeSubmissionTransitionInputSchema
projectIntakeSubmissionIdInputSchema
```

Validation should cover:

- UUID ids;
- safe optional status/source filters;
- safe date filters;
- moderation note length;
- same-tenant reference ids at service level;
- no organizationId input.

## 14. Explicit Non-Goals

Do not implement in 1P-G-D2:

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
- Commerce;
- Sales/Reporting;
- production/dispatch workflows;
- SeasonPro integration;
- schema changes or migrations unless a genuine blocker is found first.

Do not run:

- `db:push`;
- seed commands;
- reset commands.

## 15. Checks For Implementation Slice

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

## 16. Manual/API Review Checklist

Review should confirm:

- C1 admin can list current-tenant confirmed submissions.
- `CONFIRMATION_PENDING` is excluded from default moderation queue.
- C1 admin can explicitly filter by status if implemented.
- C1 admin can get a current-tenant submission detail.
- Cross-tenant submission id returns `NOT_FOUND`.
- Review notes can be updated safely.
- Same-tenant matched Client validation works.
- Status transitions use dedicated procedures.
- No generic status mutation is exposed.
- No approval action creates Clients/users/Projects.
- No email is sent.
- No public endpoint exists.

## 17. Recommended Implementation Prompt

```text
Proceed with FUND Phase 1 Slice 1P-G-D2 implementation: C1 Project Intake Submission Review API/Services.

Work on:
feature/fund-phase-1-c2-project-access

Use:
- isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-d2-c1-project-intake-submission-review-api-services-planning.md
- isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-d1-c1-project-intake-form-api-services-confirmation.md
- current FUND router/service/Zod conventions
- current Client, Project, Event and Project Intake form service patterns
- current audit and tenant-scoping conventions

Implement C1 Project Intake Submission Review API/services only.

Add tenant-scoped C1 procedures under fund.projectIntake.submissions for:
- list;
- get;
- updateReview;
- markInReview;
- markNeedsInfo;
- reject;
- markSpam;
- cancel.

Requirements:
- use withFeature('fund');
- require assertFundAdmin;
- derive organizationId from actor/effective tenant context;
- never accept organizationId from client input;
- exclude CONFIRMATION_PENDING from the default moderation queue;
- do not expose confirmation token hashes;
- validate same-tenant Client/Event/Project references used as review hints;
- write audit events where current conventions make this straightforward.

Do not implement:
- public form rendering;
- public submission endpoints;
- email confirmation endpoint;
- email sending;
- token generation;
- public link issuing;
- approval automation;
- Client users/members;
- invitations;
- notifications;
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

## 18. Recommended Next Slice

After 1P-G-D2 implementation and review:

```text
1P-G-D3 - Project Intake Approval Action Planning
```

That slice should decide the explicit approval actions for creating/linking Clients, future Client users/members and Projects from reviewed submissions.
