# FUND Phase 1 Slice 1P-G-E - C1 Project Intake Moderation And Approval UI Planning

Date: 2026-06-29

## 1. Slice Goal

Plan the C1 FUND admin UI for moderated Project Intake submissions and explicit approval actions.

The UI should let a C1 FUND admin:

- see incoming confirmed Project Intake submissions;
- review submission details, moderation notes and matching hints;
- move submissions through review statuses;
- choose an explicit approval action;
- create/link C2 Client organisations/accounts and Projects only through the existing approval API;
- navigate to created Clients and Projects after approval.

This slice is C1 admin UI planning only. It does not implement public Project Intake forms, email confirmation screens, Client dashboard Project creation, Client users/members, invitations, notifications, Store, Orders, Commerce, production/dispatch or SeasonPro integration.

## 2. Dependencies

Implemented dependencies:

```text
1P-G-C - Project Intake schema foundation
1P-G-C2-A - Project Intake email confirmation schema addendum
1P-G-D1 - C1 Project Intake Form API/Services
1P-G-D2 - C1 Project Intake Submission Review API/Services
1P-G-D3 - Project Intake Approval Action Planning
1P-G-D3-A - Project Intake Approval API/Services
1P-G-D3-A-R1 - Project Intake Approval API/Services Review
```

Current relevant procedures:

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
fund.projectIntake.approvals.returnToReview
```

## 3. Recommended Routes

Use tenant-facing C1 admin routes under the existing FUND admin surface:

```text
/app/fund/project-intake
/app/fund/project-intake/forms
/app/fund/project-intake/forms/[id]
/app/fund/project-intake/submissions/[id]
/app/fund/project-intake/submissions/[id]/approval
```

Route behaviour:

- `/app/fund/project-intake` is the main moderation landing page.
- `/app/fund/project-intake/forms` manages C1-created intake forms.
- `/app/fund/project-intake/forms/[id]` shows a form detail/admin view.
- `/app/fund/project-intake/submissions/[id]` shows submission review detail.
- `/app/fund/project-intake/submissions/[id]/approval` is the explicit approval page.

Do not use public form routes in this slice.

## 4. Dashboard And Navigation

Add a C1 FUND dashboard card or navigation entry for:

```text
Project Intake
```

Tenant-facing copy should be plain and operational, for example:

```text
Review fundraising project requests and approve the Client and Project records they create.
```

The card should link to `/app/fund/project-intake`.

The FUND sidebar/navigation should expose Project Intake only for C1 FUND admins. It must remain separate from C2 organiser/client dashboard navigation.

## 5. Moderation Landing Behaviour

The moderation landing should include:

- summary cards for confirmed submissions by status;
- an approval summary card for submissions ready for C1 approval;
- a submissions table;
- search, status filter and sort controls;
- clear empty/loading/error states.

Recommended summary cards:

- Awaiting review: `SUBMITTED`;
- In review: `IN_REVIEW`;
- Needs information: `NEEDS_INFO`;
- Ready for approval: confirmed submissions eligible for approval action;
- Recently approved: `APPROVED`.

Do not show `CONFIRMATION_PENDING` submissions in the default moderation queue.

The approval summary card should use row click-through to the dedicated approval page:

```text
/app/fund/project-intake/submissions/[id]/approval
```

Use the existing IsoStack/FUND table pattern:

- `mantine-datatable`;
- `FundTableControls`;
- `FundSortableHeader`;
- row click opens detail or approval page;
- no edit/delete/action icon buttons in table rows.

## 6. Submission Table Behaviour

The submission table should show:

- submitted date;
- form name/code;
- source;
- status;
- proposed Project name/type;
- organisation name/type;
- main organiser name/email;
- matched Client hint, if present;
- requested Event hint, if present;
- updated/reviewed date.

Filters:

- status;
- source;
- form;
- date range if practical;
- search across Project, organisation and organiser fields.

Default query behaviour:

- confirmed submissions only;
- exclude `CONFIRMATION_PENDING`;
- sort newest actionable submissions first.

## 7. Submission Detail Behaviour

The submission detail page should show:

- submission status and source;
- form context;
- Project basics from the submitted payload;
- organisation details;
- main organiser details;
- requested Event / matched Client hints;
- moderation notes;
- C1 review fields;
- raw payload/source context in a restrained C1-only section if useful for debugging or audit.

Review actions:

- mark in review;
- mark needs information;
- reject;
- mark spam;
- cancel.

The detail page should provide a clear route to approval when the submission is eligible:

```text
Review approval options
```

That command should navigate to:

```text
/app/fund/project-intake/submissions/[id]/approval
```

## 8. Approval Page Behaviour

The approval page is a deliberate C1 decision surface.

It should not auto-approve or infer ownership from respondent email, organiser snapshot fields, proposed contact fields or hidden public form fields.

Approval options:

1. Create Client and Project.
2. Link existing Client and create Project.
3. Create standalone Project, only if the intake form allows standalone Projects.

The page should clearly distinguish:

- C2 Client organisation/account;
- main organiser/contact snapshots;
- future login-capable Client user/member, which is not created in this slice;
- Project record to be created as a safe draft.

After approval, show links to:

- created/linked Client detail;
- created Project detail;
- linked Event detail, if applicable.

## 9. Approval Form Fields

### Create Client And Project

Client fields:

- code;
- name;
- slug;
- client type;
- description;
- primary contact name/email/phone as snapshots only;
- internal notes.

Project fields:

- project number;
- name;
- slug;
- description;
- optional Event;
- organiser name/email/phone as snapshots only;
- open date;
- close date;
- production deadline;
- internal notes.

### Link Client And Create Project

Client selection:

- searchable active Client selector;
- archived/inactive Clients should not be selectable;
- show selected Client summary.

Project fields are the same as above.

### Standalone Project

Only visible when the form allows standalone Projects.

Project fields are the same as above, with no Client selector.

## 10. Return-To-Review Policy

The 1P-G-D3-A-R1 review recorded a caveat: the API currently allows most non-approved, non-confirmation-pending submissions to return to `IN_REVIEW`.

UI planning recommendation:

- do not expose return-to-review for `APPROVED`;
- do not expose return-to-review for `CONFIRMATION_PENDING`;
- do not expose return-to-review for ordinary `SUBMITTED`, `IN_REVIEW` or `NEEDS_INFO` states where existing review actions already apply;
- expose return-to-review only for explicitly permitted terminal states after the policy is finalised.

Recommended implementation prerequisite:

```text
Confirm whether return-to-review should be allowed from REJECTED, CANCELLED and SPAM only.
```

If necessary, implement a tiny API policy tightening before the approval UI.

## 11. Error And Conflict Handling

The UI should surface approval errors clearly:

- duplicate Client code/slug;
- duplicate Project number/slug;
- inactive/archived Client selected;
- archived/closed Event selected;
- Project dates outside Event date boundaries;
- standalone Project not allowed for the form;
- stale submission already approved.

Do not hide errors in table body text alone. Use the existing alert/notification patterns from FUND Client and Project pages.

## 12. UI Standard Compliance

Follow current FUND admin conventions:

- muted operational styling;
- semantic colour only for status/action meaning;
- no oversized hero or marketing surfaces;
- row click opens detail/approval pages;
- no edit/delete/archive action icons inside table rows;
- destructive/status-changing actions belong in detail page action areas;
- use current Mantine/DataTable/FUND shared components where practical;
- keep compact headings inside cards and tables.

## 13. Non-Goals

Do not implement:

- public Project Intake form rendering;
- public submission endpoint UI;
- email confirmation screens;
- email sending;
- token generation;
- public link issuing;
- Client users/members;
- invitations;
- notifications;
- Client dashboard Project creation;
- C2 dashboard expansion;
- Store;
- Orders;
- Commerce;
- Sales/Reporting;
- production/dispatch workflow;
- SeasonPro integration;
- schema changes or migrations.

## 14. Manual Test Checklist For Future Implementation

When implemented, manually verify:

- C1 admin can open `/app/fund/project-intake`.
- `CONFIRMATION_PENDING` submissions do not appear by default.
- Empty state is clear when no submissions exist.
- Search, filter and sorting work.
- Row click opens submission detail.
- Approval summary card rows open the approval page.
- Submission detail can mark in review, needs info, reject, spam and cancel.
- Create Client and Project approval creates a C2 Client organisation/account and DRAFT Project.
- Link Client and create Project approval links to an active same-tenant Client only.
- Standalone approval is only available when the form allows standalone Projects.
- Duplicate Client/Project conflicts are clear.
- Approved submissions are idempotent on retry.
- Created Client and Project links navigate to existing C1 admin pages.
- No Client users, invitations, notifications, Store, Orders, Commerce or SeasonPro surfaces appear.

## 15. Implementation Prompt

```text
Proceed with FUND Phase 1 Slice 1P-G-E implementation: C1 Project Intake Moderation And Approval UI.

Work on:
feature/fund-phase-1-c2-project-access

Use:
- isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-e-c1-project-intake-moderation-and-approval-ui-planning.md
- isodocs/docs/modules/fund/05-review-and-test/2026-06-29-phase-1-slice-1p-g-d3-a-r1-project-intake-approval-api-services-review.md
- current FUND admin UI conventions
- current Client, Project, Event and table/detail patterns

Implement C1 Project Intake moderation and approval UI only.

Recommended routes:
- /app/fund/project-intake
- /app/fund/project-intake/forms
- /app/fund/project-intake/forms/[id]
- /app/fund/project-intake/submissions/[id]
- /app/fund/project-intake/submissions/[id]/approval

Use only:
- fund.projectIntake.forms.*
- fund.projectIntake.submissions.*
- fund.projectIntake.approvals.*
- read-only Client/Event helper data only where already exposed safely by current C1 admin APIs.

Requirements:
- C1 Project Intake dashboard/navigation entry;
- moderation landing with summary cards, approval summary card and submissions table;
- row click opens detail/approval pages;
- no action icon buttons in table rows;
- submission detail review actions;
- approval page for create Client + Project, link Client + Project and allowed standalone Project;
- clear loading, empty and error states;
- conflict/blocker errors surfaced clearly;
- approved result links to Client, Project and Event detail where applicable;
- no Client user/member, invitation, notification, Store, Orders, Commerce, production, dispatch or SeasonPro surfaces.

Before exposing return-to-review in the UI, either constrain it in the UI to the accepted statuses or tighten the API policy if needed.

Do not implement:
- public form rendering;
- email confirmation UI;
- email sending;
- token generation;
- Client users/members;
- invitations;
- notifications;
- Client dashboard Project creation;
- Store, Orders, Commerce, Sales/Reporting, production/dispatch or SeasonPro integration;
- schema changes or migrations.

Run:
- npm run type-check
- npm run verify
- git diff --check

Create implementation confirmation documentation.
Do not promote to main after implementation.
```

## 16. Recommended Next Slice

```text
1P-G-E-A - C1 Project Intake Moderation And Approval UI Implementation
```

If return-to-review policy needs to be tightened before UI implementation, add a tiny prerequisite:

```text
1P-G-D3-A-R2 - Project Intake Approval Return-To-Review Policy Tightening
```
