# FUND Phase 1 Slice 1P-G-E - C1 Project Intake Moderation And Approval UI Confirmation

Date: 2026-06-29

## 1. Slice Name

FUND Phase 1 Slice 1P-G-E - C1 Project Intake Moderation And Approval UI

## 2. Implementation Summary

Implemented the C1 FUND admin UI for Project Intake moderation and approval.

The implementation adds C1-only UI surfaces for:

- Project Intake dashboard/action queue;
- C1-created Project Intake form list and form detail administration;
- confirmed Project Intake submission review;
- explicit approval actions for creating/linking Client and Project records.

The UI uses only existing C1 Project Intake APIs. It does not introduce public intake rendering, email confirmation UI, token generation, Client users/members, invitations, notifications, Store, Orders, Commerce, production/dispatch or SeasonPro integration.

## 3. Routes Created

App routes added:

```text
/app/fund/project-intake
/app/fund/project-intake/forms
/app/fund/project-intake/forms/[id]
/app/fund/project-intake/submissions/[id]
/app/fund/project-intake/submissions/[id]/approval
```

Route behaviour:

- `/app/fund/project-intake` shows the C1 moderation landing page.
- `/app/fund/project-intake/forms` lists and creates C1 Project Intake forms.
- `/app/fund/project-intake/forms/[id]` edits and manages a C1 Project Intake form.
- `/app/fund/project-intake/submissions/[id]` reviews a confirmed submission.
- `/app/fund/project-intake/submissions/[id]/approval` performs explicit C1 approval actions.

## 4. Files / Components Changed

App repo:

- `src/app/(app)/app/fund/page.tsx`
- `src/core/config/module-navigation.ts`
- `src/core/components/layout/Navbar.tsx`
- `src/app/(app)/app/fund/project-intake/page.tsx`
- `src/app/(app)/app/fund/project-intake/forms/page.tsx`
- `src/app/(app)/app/fund/project-intake/forms/[id]/page.tsx`
- `src/app/(app)/app/fund/project-intake/submissions/[id]/page.tsx`
- `src/app/(app)/app/fund/project-intake/submissions/[id]/approval/page.tsx`
- `src/modules/fund/components/project-intake/ProjectIntakeActionCard.tsx`
- `src/modules/fund/components/project-intake/ProjectIntakeDashboardPage.tsx`
- `src/modules/fund/components/project-intake/ProjectIntakeFormsPage.tsx`
- `src/modules/fund/components/project-intake/ProjectIntakeFormDetailPage.tsx`
- `src/modules/fund/components/project-intake/ProjectIntakeSubmissionDetailPage.tsx`
- `src/modules/fund/components/project-intake/ProjectIntakeApprovalPage.tsx`
- `src/modules/fund/components/project-intake/types.ts`
- `src/modules/fund/components/shared/FundStatusBadge.tsx`

Docs repo:

- `isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-e-c1-project-intake-moderation-and-approval-ui-confirmation.md`

## 5. Endpoints Used

The UI uses these existing C1 admin procedures:

```text
fund.projectIntake.forms.list
fund.projectIntake.forms.get
fund.projectIntake.forms.create
fund.projectIntake.forms.update
fund.projectIntake.forms.activate
fund.projectIntake.forms.pause
fund.projectIntake.forms.archive
fund.projectIntake.forms.restore

fund.projectIntake.submissions.list
fund.projectIntake.submissions.get
fund.projectIntake.submissions.updateReview
fund.projectIntake.submissions.markInReview
fund.projectIntake.submissions.markNeedsInfo
fund.projectIntake.submissions.reject
fund.projectIntake.submissions.markSpam
fund.projectIntake.submissions.cancel

fund.projectIntake.approvals.getContext
fund.projectIntake.approvals.approveCreateClientAndProject
fund.projectIntake.approvals.approveLinkClientCreateProject
fund.projectIntake.approvals.approveStandaloneProject
```

The approval UI also uses read-only C1 helper data from existing safe admin APIs:

```text
fund.clients.list
fund.events.list
```

No C2 organiser endpoints or Project mutation endpoints are used for this UI slice.

## 6. Dashboard Action Card Behaviour

Added a C1 FUND dashboard action card for:

```text
Project Intake
```

The action card:

- links to `/app/fund/project-intake`;
- is paired with an admin-only FUND sidebar/navigation entry for `/app/fund/project-intake`;
- shows summary row counts for `SUBMITTED`, `IN_REVIEW` and `NEEDS_INFO` submissions;
- excludes `CONFIRMATION_PENDING`, `APPROVED`, `REJECTED`, `CANCELLED`, `SPAM` and `ARCHIVED` from the action-required state;
- applies a subtle `1px` brand-primary border only when action-required counts are greater than zero;
- uses the same hover and card styling conventions as the C1 FUND dashboard.

This implements the documented C1 action-card pattern for workflow cards that require admin attention.

## 7. Moderation Landing Behaviour

The moderation landing page includes:

- C1 breadcrumbs and tenant-facing title/copy;
- summary cards for awaiting review, in review, needs information, ready for approval and recently approved;
- an approval summary card with ready-for-approval counts;
- submission search, status filter and column-header sorting;
- row-click navigation to the submission detail or approval page;
- loading, empty and error states.

The submissions table does not include row edit/delete/archive action icons.

## 8. Form List And Detail Behaviour

The form list page supports:

- C1 form search and status filtering;
- column-header sorting;
- row-click navigation to the form detail page;
- create form flow for C1 admins.

The form detail page supports:

- profile edits for C1 Project Intake form configuration;
- activate, pause, archive and restore actions through dedicated API procedures;
- moderation setting visibility;
- no public link issuing or public rendering.

## 9. Submission Detail Behaviour

The submission detail page supports C1 review actions:

- update review notes and matching hints;
- mark in review;
- mark needs information;
- reject;
- mark spam;
- cancel.

The page shows:

- Project basics;
- organisation details;
- main organiser details;
- matched Client/requested Event hints;
- source context and raw payload as C1 moderation evidence.

The UI does not expose confirmation token hashes, idempotency keys, submission fingerprints or public confirmation controls.

## 10. Approval Page Behaviour

The approval page supports explicit C1 approval modes:

- create Client + Project;
- link existing Client + create Project;
- create allowed standalone Project.

The page:

- requires C1-confirmed Client/Project fields before submitting;
- lists existing Clients and Events through safe C1 helper queries;
- respects form-level standalone Project permission;
- surfaces blocker/conflict errors clearly;
- shows approved result links to Client, Project and Event detail routes where applicable.

Return-to-review is not exposed as a UI action in this slice, preserving the accepted status boundary while the API policy remains available for a later, explicitly planned review flow.

## 11. UI Standard Compliance

The UI follows the current FUND/IsoStack admin patterns:

- muted operational styling;
- semantic colour only for status/action meaning;
- breadcrumbs on C1 admin pages;
- table CRUD pattern with row-click detail navigation;
- no row-level action icon buttons in moderation tables;
- dedicated detail/action pages for mutations;
- clear loading, empty and error states.

Project Intake remains a C1 FUND admin surface. It is exposed in FUND module navigation only as an admin-only item and remains separate from C2 organiser/client dashboard navigation.

## 12. Explicit Out Of Scope Confirmation

Not implemented:

- public form rendering;
- public submission endpoints;
- email confirmation UI;
- email sending;
- token generation;
- public link issuing;
- Client users/members;
- invitations;
- notifications;
- C2 Client dashboard Project creation;
- Project Request direct creation outside C1 approval;
- Store;
- Orders;
- Commerce Core;
- Sales/Reporting;
- production/dispatch workflows;
- SeasonPro integration;
- schema changes;
- migrations.

No `db:push`, seed or reset commands were used.

## 13. Checks Run

Checks run from the app repo:

```text
npm run type-check
npm run verify
git diff --check
```

Results:

- `npm run type-check`: passed.
- `npm run verify`: initial sandbox run hit the known `tsx` IPC permission issue; rerun with sandbox escalation passed.
- `git diff --check`: passed.

## 14. Risks / Follow-Ups

Follow-ups:

- authenticated browser smoke testing should confirm the Project Intake dashboard/action card, form CRUD, submission review and approval flows with representative data;
- public form rendering and email confirmation remain separate future slices;
- approval result data should be tested against duplicate Client code/slug and Project number/slug conflicts;
- later C1 workflow cards should reuse the action-card standard introduced here.

## 15. Recommended Next Slice

Recommended next slice:

```text
1P-G-E-R1 - C1 Project Intake Moderation And Approval UI Review And Authenticated Smoke Testing
```

After review, decide whether the 1P-G-D/E Project Intake moderation batch is ready for dev/staging alignment.
