# FUND Phase 1 Slice 1P-G-D3 - Project Intake Approval Action Planning

Date: 2026-06-29

Status: Planning only

## 1. Slice Goal

Plan the explicit C1 approval actions for reviewed Project Intake submissions.

This planning slice decides how C1 may approve a confirmed and reviewed submission into operational records, including Client/account linkage, future Client user/member handling and Project creation/linkage. It also plans the first C1 approval user experience, including an approval summary card with row click-through to an approval page.

This slice does not implement application code, schema, migrations, UI, public forms, email sending, notifications, Store, Orders, Commerce or SeasonPro integration.

## 2. Dependencies

Required baseline:

- 1P-G-C Project Intake schema exists.
- 1P-G-C2-A email confirmation schema addendum exists.
- 1P-G-D1 C1 Project Intake Form API/services is implemented.
- 1P-G-D2 C1 Project Intake Submission Review API/services is implemented.
- `FundClient` is the Client organisation/account.
- `FundProject.clientId` is the explicit Project-to-Client ownership link.
- Project Intake submissions remain moderation/review records until explicit C1 approval.

Relevant documents:

- `03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-d-project-intake-moderation-api-services-planning.md`
- `03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-d2-c1-project-intake-submission-review-api-services-planning.md`
- `04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-d2-c1-project-intake-submission-review-api-services-confirmation.md`
- `03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-d0-client-scoped-project-initiation-and-idempotency-planning.md`
- `00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

## 3. Core Approval Policy

The moderated initiation form remains moderation-first.

Approval means a C1 admin explicitly decides what operational records should be created or linked from a reviewed submission.

Approval must not be inferred from:

- respondent email alone;
- organiser snapshot fields;
- proposed Client contact fields;
- hidden public fields;
- pre-filled `matchedClientId`;
- public submission source.

Approval must be explicit, tenant-scoped, audited and idempotent.

## 4. Approval Actions To Plan

Recommended first approval actions:

```text
approveAndCreateClientAndProject
approveAndLinkClientCreateProject
approveStandaloneProject
rejectFromApproval
returnToReview
```

Deferred approval actions:

```text
approveAndCreateClientUserMember
approveAndInviteClientUser
approveAndLinkExistingProject
approveAndLinkSeasonProClub
approveAndOpenStore
```

Rationale:

- Client users/members do not exist yet.
- Invitations and notifications are deferred.
- Store, Orders, Commerce, production and dispatch gates are deferred.
- SeasonPro Club integration is future-facing and must not be improvised in FUND approval actions.

## 5. Approval Preconditions

A submission should be eligible for approval only when:

- it belongs to the current tenant;
- it is confirmed/actionable;
- it is not `CONFIRMATION_PENDING`;
- it is not already `APPROVED`;
- it is not `REJECTED`, `CANCELLED`, `SPAM` or `ARCHIVED`;
- required approval inputs have been supplied by C1;
- same-tenant Client/Event/Project references validate successfully.

Recommended eligible statuses:

```text
SUBMITTED
IN_REVIEW
NEEDS_INFO
```

## 6. Approval Outputs

### Create Client And Project

Use when the respondent represents a new Client/account.

Expected output:

- create `FundClient`;
- create `FundProject`;
- set `FundProject.clientId` to the created Client;
- optionally link Project to a same-tenant Event;
- mark submission `APPROVED`;
- set `approvedClientId`;
- set `approvedProjectId`;
- set `approvedEventId` if applicable;
- set moderation decision `CREATE_CLIENT_AND_PROJECT`.

Client users/members are not created in this first approval action.

### Link Client And Create Project

Use when C1 selects an existing same-tenant Client/account.

Expected output:

- validate selected `FundClient`;
- create `FundProject`;
- set `FundProject.clientId` to selected Client;
- optionally link Project to a same-tenant Event;
- mark submission `APPROVED`;
- set `approvedClientId`;
- set `approvedProjectId`;
- set `approvedEventId` if applicable;
- set moderation decision `LINK_CLIENT_CREATE_PROJECT`.

### Create Standalone Project

Use only if the approved form policy allows standalone Projects.

Expected output:

- create `FundProject` with `clientId = null`;
- optionally link Project to a same-tenant Event;
- mark submission `APPROVED`;
- set `approvedProjectId`;
- set `approvedEventId` if applicable;
- set moderation decision `CREATE_PROJECT_STANDALONE`.

Standalone approval should remain explicit and visible because the strategic model is Client-owned Projects.

## 7. Project Creation Defaults

Approved Projects should start in a safe pre-operational state.

Recommended defaults:

- `status = DRAFT`;
- `lifecycleState` remains the existing Project default;
- Client linkage uses `FundProject.clientId`;
- Event linkage uses explicit same-tenant `eventId` only where selected/approved;
- organiser snapshot fields may be copied as contact snapshots if useful, but must not establish ownership or access;
- no Store/public ordering is opened;
- no production, dispatch, payment or commission workflow is triggered.

Project create defaults should follow existing C1 Project service conventions where possible.

## 8. Client Creation Defaults

When creating a Client from a submission:

- create a `FundClient` organisation/account in the current C1 tenant only;
- use C1-selected/confirmed Client code, name, slug and client type;
- use proposed organisation/contact fields only as source evidence;
- set primary contact snapshot fields only if C1 confirms them;
- do not create a login-capable Client user/member;
- do not send invitations;
- do not send notifications.

Clarification:

- `FundClient` means the C2 organisation/account that is a client of the C1 tenant, such as a school, club, PTA, charity branch or fundraising organisation.
- `FundClient` is not the C2 person/user.
- The respondent/main organiser is a future Client user/member candidate, not the Client organisation itself.
- Project initiation forms may create or link C2 Client organisations and future C2 Client users/members after C1 approval, but they must never create new C1 tenant organisations.
- New C1 tenants remain P1/platform-controlled or module-signup-controlled, outside this Project Intake approval lane.

Primary contact fields remain C1 operational contact snapshots only.

## 9. Future Client User/Member Boundary

The respondent or main organiser may become a future Client user/member, but not in this slice.

Future approval planning must separately decide:

- `FundClientUser` or equivalent schema;
- authenticated User linkage;
- primary Client user/member;
- role labels such as Treasurer, Secretary, Project Lead;
- invitation and magic-link onboarding policy;
- notification consent and communication boundaries.

Until then, approval actions must not create users, send invitations or grant dashboard access.

## 10. Idempotency And Transaction Requirements

Approval actions must be idempotent.

Implementation should:

- run approval in a server-side transaction;
- lock or re-read the submission inside the transaction;
- reject or safely return if the submission is already approved;
- avoid duplicate Client creation on retry;
- avoid duplicate Project creation on retry;
- reuse existing `approvedClientId` / `approvedProjectId` if already set;
- write audit records once per meaningful approval outcome where practical.

Recommended first behaviour:

```text
If submission is already APPROVED and approved records exist, return the existing approval result rather than creating new records.
```

## 11. Same-Tenant Rules

Approval services must enforce:

- submission.organizationId = current tenant;
- selected Client organizationId = current tenant;
- selected Event organizationId = current tenant;
- created Client organizationId = current tenant;
- created Project organizationId = current tenant;
- Project `clientId` relation uses same-tenant Client linkage.

Cross-tenant ids should return `NOT_FOUND` or a safe validation error.

## 12. C1 Approval Summary Card

The C1 dashboard should include an approval summary card once the approval UI slice is reached.

Suggested card title:

```text
Project approvals
```

Suggested card purpose:

```text
Review confirmed Project requests and approve the Client, Project and Event setup.
```

The card should show compact operational counts:

- awaiting review;
- in review;
- needs info;
- ready for approval if such a derived state is introduced;
- recently approved if useful.

The card must be tenant-facing and should avoid internal planning language such as C1/C2, schema, workflow class or implementation.

## 13. Approval Queue / Row Click Behaviour

The approval surface should use the existing IsoStack table CRUD pattern:

- queue rows are clickable;
- row click opens a dedicated approval page;
- no row-level approve/reject action icons in the table;
- approval actions live on the detail/approval page;
- destructive/reject/cancel actions use existing confirmation patterns.

Recommended future routes:

```text
/app/fund/intake
/app/fund/intake/submissions/[id]
/app/fund/intake/submissions/[id]/approval
```

Alternative shorter route if preferred:

```text
/app/fund/approvals
/app/fund/approvals/[id]
```

Recommendation:

Use `/app/fund/intake` for the wider intake area and a dedicated approval page per submission. This leaves room for form management, submission review and approval history without blending them into Projects or Clients prematurely.

## 14. Approval Page Behaviour

The approval page should show:

- submission summary;
- respondent/main organiser details;
- proposed Client/account details;
- proposed Project details;
- requested Event/date context;
- matched Client hints;
- raw payload/source context if useful to C1 admins;
- approval action selector;
- Client create/link section;
- Project create options;
- Event linkage section;
- explicit warnings that Client user/member creation and notifications are deferred.

Approval action buttons should be disabled until required C1 decisions are complete.

## 15. API/Service Planning Implications

Future approval API/services should likely live under:

```text
fund.projectIntake.approvals
```

Suggested procedures:

```text
fund.projectIntake.approvals.getContext
fund.projectIntake.approvals.approveCreateClientAndProject
fund.projectIntake.approvals.approveLinkClientCreateProject
fund.projectIntake.approvals.approveStandaloneProject
fund.projectIntake.approvals.returnToReview
```

Avoid a single generic `approve` mutation if explicit procedures make the audit trail and validation safer.

## 16. Audit Requirements

Audit should record:

- approval action selected;
- submission id;
- created/linked Client id;
- created Project id;
- linked Event id;
- previous/new submission status;
- C1 user who approved;
- idempotency reuse if the approval was retried.

Suggested entity type:

```text
FundProjectIntakeSubmission
```

Additional audit events may be written for created Client and Project using existing entity audit conventions.

## 17. Explicit Non-Goals

Do not implement in 1P-G-D3 planning:

- application code;
- Prisma schema changes;
- migrations;
- routers;
- services;
- Zod schemas;
- UI;
- public form rendering;
- public submission endpoints;
- email confirmation endpoint;
- email sending;
- token generation;
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
- approval automation without explicit C1 action.

Do not run:

- `db:push`;
- seed commands;
- reset commands.

## 18. Recommended Implementation Split

Recommended next implementation split:

```text
1P-G-D3-A - Project Intake Approval API/Services Planning
1P-G-D3-B - Project Intake Approval API/Services
1P-G-E - C1 Project Intake Moderation And Approval UI Planning
1P-G-E-A - C1 Project Intake Approval Summary Card And Queue UI
1P-G-E-B - C1 Project Intake Approval Detail Page UI
1P-G-F - Public Project Initiation Form And Email Confirmation Planning
```

Rationale:

- Approval service decisions are high-impact and should be planned before implementation.
- The summary card and approval page are UI concerns and should follow service acceptance.
- Public form/email confirmation remains separate from C1 approval tooling.

## 19. Recommended Next Slice

Recommended next slice:

```text
1P-G-D3-A - Project Intake Approval API/Services Planning
```

That slice should turn this approval action policy into concrete service contracts, input validation, transaction/idempotency rules and implementation prompts.
