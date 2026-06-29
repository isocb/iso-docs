# FUND Phase 1 Slice 1P-G-E-R1 - C1 Project Intake Moderation And Approval UI Review

Date: 2026-06-29

## 1. Review Verdict

Proceed.

The 1P-G-E C1 Project Intake moderation and approval UI is consistent with the approved planning document and the implemented Project Intake API/service boundaries. Browser smoke testing has been completed by the product owner on dev and the UI was reported as looking great, with no remedial work requested before staging promotion.

## 2. Routes Reviewed

Reviewed routes:

```text
/app/fund/project-intake
/app/fund/project-intake/forms
/app/fund/project-intake/forms/[id]
/app/fund/project-intake/submissions/[id]
/app/fund/project-intake/submissions/[id]/approval
```

Dashboard/navigation entry reviewed:

```text
/app/fund
FUND module sidebar/navigation entry: Project Intake
```

## 3. Files / Components Reviewed

Application files:

```text
src/app/(app)/app/fund/page.tsx
src/core/config/module-navigation.ts
src/core/components/layout/Navbar.tsx
src/app/(app)/app/fund/project-intake/page.tsx
src/app/(app)/app/fund/project-intake/forms/page.tsx
src/app/(app)/app/fund/project-intake/forms/[id]/page.tsx
src/app/(app)/app/fund/project-intake/submissions/[id]/page.tsx
src/app/(app)/app/fund/project-intake/submissions/[id]/approval/page.tsx
src/modules/fund/components/project-intake/ProjectIntakeActionCard.tsx
src/modules/fund/components/project-intake/ProjectIntakeDashboardPage.tsx
src/modules/fund/components/project-intake/ProjectIntakeFormsPage.tsx
src/modules/fund/components/project-intake/ProjectIntakeFormDetailPage.tsx
src/modules/fund/components/project-intake/ProjectIntakeSubmissionDetailPage.tsx
src/modules/fund/components/project-intake/ProjectIntakeApprovalPage.tsx
src/modules/fund/components/project-intake/types.ts
src/modules/fund/components/shared/FundStatusBadge.tsx
```

Documentation files:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-e-c1-project-intake-moderation-and-approval-ui-planning.md
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-e-c1-project-intake-moderation-and-approval-ui-confirmation.md
isodocs/docs/modules/fund/05-review-and-test/2026-06-29-phase-1-slice-1p-g-e-r1-c1-project-intake-moderation-and-approval-ui-review.md
isodocs/docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md
```

## 4. Endpoint Usage Proof

The UI uses the expected C1 Project Intake procedures only:

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

The approval page uses read-only C1 helper data from existing safe admin APIs:

```text
fund.clients.list
fund.events.list
```

No C2 organiser endpoints, public intake endpoints, email confirmation endpoints or Project mutation endpoints are used by the UI.

## 5. Dashboard / Action Card Assessment

The FUND C1 dashboard now includes a Project Intake action card.

The card:

- links to `/app/fund/project-intake`;
- shows summary rows for `SUBMITTED`, `IN_REVIEW` and `NEEDS_INFO`;
- excludes terminal/unactionable states from the active count;
- applies a subtle `1px` brand-primary border only when action-required counts are greater than zero;
- follows the documented C1 action-card standard and existing FUND dashboard hover/card styling.

The FUND module navigation also exposes an admin-only Project Intake entry.

## 6. Moderation Landing Assessment

The moderation landing page includes:

- summary cards for pipeline states;
- approval queue summary;
- submissions table;
- fuzzy search;
- status filtering;
- column-header sorting;
- row-click navigation to submission detail or approval page;
- loading, empty and error states.

No row edit/delete/action icon buttons are present in the submissions table.

## 7. Form Admin Assessment

The form list/detail UI supports C1 form administration through existing form procedures only.

The UI provides:

- form list search/filter/sort;
- create form flow;
- form detail edit flow;
- activate, pause, archive and restore actions.

The UI does not issue public links, render public forms or expose email-confirmation UI.

## 8. Submission Review Assessment

The submission detail UI supports C1 moderation actions:

- update review notes and matching hints;
- mark in review;
- mark needs information;
- reject;
- mark spam;
- cancel.

The review page shows Project basics, organisation details, main organiser details and moderation evidence. It does not expose confirmation token hashes, idempotency keys or submission fingerprints.

## 9. Approval Page Assessment

The approval page supports the planned explicit C1 approval actions:

- create Client + Project;
- link Client + create Project;
- create standalone Project when the form permits it.

The approval page requires C1-confirmed fields and surfaces conflict/blocker errors. Approved result links navigate to Client, Project and Event detail routes where applicable.

Return-to-review is not exposed in this UI slice, preserving the status-policy caveat from the 1P-G-D3-A review.

## 10. Authenticated Smoke Test Status

Authenticated browser smoke testing was completed by the product owner on dev.

Result:

```text
Passed. UI looks great. No remedial work requested before staging promotion.
```

No additional automated browser test was recorded in this review document.

## 11. Explicit Out-Of-Scope Confirmation

The review confirmed that this UI slice does not implement:

- public form rendering;
- public submission endpoints;
- email confirmation UI;
- email sending;
- token generation;
- public link issuing;
- Client users/members;
- invitations;
- notifications;
- Client dashboard Project creation;
- Store;
- Orders;
- Commerce;
- Sales/Reporting;
- production/dispatch workflows;
- SeasonPro integration;
- schema changes;
- migrations.

## 12. Checks

Checks run during implementation and confirmed before commit:

```text
npm run type-check
npm run verify
git diff --check
docs git diff --check
```

Results:

- `npm run type-check`: passed.
- `npm run verify`: passed after the known sandbox escalation for the `tsx` IPC pipe.
- `git diff --check`: passed.
- docs `git diff --check`: passed.

## 13. Defects / Follow-Ups

No blocking defects found.

Follow-ups:

- perform staging smoke testing after deployment;
- add representative Project Intake submission data for fuller approval-path testing;
- keep return-to-review UI deferred until the accepted status policy is tightened or explicitly planned;
- reuse the C1 action-card standard for future FUND workflow cards.

## 14. Recommendation On Dev/Staging Alignment

Recommendation: align the 1P-G-E UI batch to dev and staging.

Do not promote to main until staging deploy and smoke testing are confirmed.

## 15. Recommended Next Slice

Recommended next slice after staging confirmation:

```text
1P-G-F - Public Project Initiation Form UI Planning
```

This should remain separate from email sending, Client user/member provisioning and Store/Commerce work unless those boundaries are explicitly planned first.
