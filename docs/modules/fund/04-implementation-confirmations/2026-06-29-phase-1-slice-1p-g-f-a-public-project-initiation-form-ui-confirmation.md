# FUND Phase 1 Slice 1P-G-F-A - Public Project Initiation Form UI Confirmation

Date: 2026-06-29

## 1. Slice Name

FUND Phase 1 Slice 1P-G-F-A - Public Project Initiation Form UI Implementation

## 2. Implementation Summary

Implemented the first public/client-facing Project initiation form UI.

The implementation adds a public multi-step form that:

- loads an active C1-created Project Intake form by slug;
- collects the approved first visible field set;
- stores public requests as `CONFIRMATION_PENDING` Project Intake submissions;
- sends the narrow required confirmation email using bounded transactional copy;
- confirms submissions into `SUBMITTED` for C1 moderation;
- preserves the moderation-first boundary before any operational Client or Project records are created.

This UI is the public side of the existing C1 Project Intake form/admin workflow. C1 creates and manages forms under `/app/fund/project-intake`; public respondents use the generated `/fund/project-initiation/[formSlug]` route.

## 3. Public Routes Created

App routes added:

```text
/fund/project-initiation/[formSlug]
/fund/project-initiation/[formSlug]/confirm
/fund/project-initiation/[formSlug]/submitted
/fund/project-initiation/[formSlug]/expired
```

Route behaviour:

- `/fund/project-initiation/[formSlug]` renders the public multi-step initiation form for an active C1-created form.
- `/fund/project-initiation/[formSlug]/confirm` confirms a pending submission from the email confirmation link.
- `/fund/project-initiation/[formSlug]/submitted` shows the safe confirmed/submitted state.
- `/fund/project-initiation/[formSlug]/expired` shows the safe expired/invalid confirmation state.

## 4. Files / Components Changed

App repo:

- `src/app/(public)/fund/project-initiation/[formSlug]/page.tsx`
- `src/app/(public)/fund/project-initiation/[formSlug]/confirm/page.tsx`
- `src/app/(public)/fund/project-initiation/[formSlug]/submitted/page.tsx`
- `src/app/(public)/fund/project-initiation/[formSlug]/expired/page.tsx`
- `src/modules/fund/components/project-intake-public/PublicProjectInitiationForm.tsx`
- `src/modules/fund/components/project-intake-public/PublicProjectInitiationConfirmPage.tsx`
- `src/modules/fund/components/project-intake-public/PublicProjectInitiationStatusPage.tsx`
- `src/modules/fund/components/project-intake/ProjectIntakeFormsPage.tsx`
- `src/modules/fund/components/project-intake/ProjectIntakeFormDetailPage.tsx`
- `src/modules/fund/lib/validation/project-intake.ts`
- `src/modules/fund/routers/project-intake.router.ts`
- `src/modules/fund/services/project-intake.service.ts`

Docs repo:

- `isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-f-public-project-initiation-form-ui-planning.md`
- `isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-f-a-public-project-initiation-form-ui-confirmation.md`
- `isodocs/docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

## 5. Public Procedures Added

Added public procedures under:

```text
fund.projectIntake.public.getForm
fund.projectIntake.public.submit
fund.projectIntake.public.confirm
```

Procedure behaviour:

- `getForm` returns only active, available, non-archived forms by slug.
- `submit` creates a `CONFIRMATION_PENDING` submission and sends the required confirmation email.
- `confirm` validates the confirmation token hash and moves the submission to `SUBMITTED`.

These procedures do not expose C1 admin routes, confirmation token hashes, supplier internals, Client user/member data, Store, Orders or Commerce.

## 6. Public Field Set

Implemented the approved first public field set:

Project basics:

- Project name;
- Type of fundraising project;
- Preferred project dates / target date;
- Notes / project description.

Organisation details:

- Organisation name;
- Organisation type;
- Organisation address.

Main organiser details:

- First name;
- Last name;
- Email address;
- Phone number;
- Role in organisation.

The public Project Type question is:

```text
What kind of fundraising project would you like to run?
```

Options:

```text
Individual Artwork Project
Group personalised product project
Bulk order / club-funded project
Not sure yet
```

The form does not ask whether a Store is required.

## 7. Event-Scoped Form Behaviour

The implementation reinforces the existing planned model:

- C1-created Project Intake forms may be general or Event-scoped.
- Event scoping comes from the trusted `FundProjectIntakeForm.defaultEventId` form definition.
- the C1 form create/edit UI exposes a Default Event selector using existing safe C1 Event list data.
- Public respondents do not choose or spoof Event linkage through editable or hidden fields.
- If a public form has a default Event, the public UI shows simple contextual copy naming the Event.
- Public submissions created from an Event-scoped form carry the trusted Event into `requestedEventId`.
- The approved Project remains C2 Client-owned through `FundProject.clientId`; the Event is campaign/context linkage, not Project ownership.

General forms leave `requestedEventId` empty unless C1 links an Event during approval.

## 7A. C1 Public Link Affordance

Added a C1 detail-page affordance for Project Intake forms:

```text
Copy public link
Open
```

The copied/opened route uses:

```text
/fund/project-initiation/[formSlug]
```

This is intended to make browser testing and tenant-admin operation clearer. It does not create a separate public-link issuing model or expose hidden C1 internals.

## 8. Email Confirmation Behaviour

The public flow uses the schema addendum boundary:

```text
CONFIRMATION_PENDING -> SUBMITTED
```

Submission behaviour:

- confirmation tokens are generated server-side;
- only token hashes are stored;
- tokens expire after the configured confirmation period;
- confirmed submissions clear the token hash and set `confirmedAt` / `submittedAt`;
- unconfirmed submissions do not become actionable C1 moderation items.

The confirmation email uses a narrow hard-coded transactional exception for the required confirmation step only.

The code includes a placeholder annotation for future notification registry migration:

```text
TODO(FUND_NOTIFICATIONS): register FUND_PROJECT_INTAKE_CONFIRMATION_EMAIL
```

No approval, rejection, needs-information, marketing or workflow emails were implemented.

## 9. Branding Behaviour

The public form uses trusted branding configuration only.

Fallback order:

```text
trusted FUND tenant / form organisation branding
-> FUND module branding
-> IsoStack/platform fallback
```

Respondent-entered organisation names, uploaded files and hidden public fields are not used to determine the form brand.

The confirmation email is sent through the existing branded email wrapper with `moduleKey: fund`, so it can inherit the existing tenant/module/platform letterhead and footer behaviour.

## 10. Moderation And Ownership Boundary

The public form does not create operational records.

It does not create:

- `FundClient`;
- Client users/members;
- invitations;
- notifications beyond the required confirmation email;
- `FundProject`;
- Event links beyond submission-level `requestedEventId`;
- Store;
- Orders;
- Commerce records.

Operational Client/Project records remain created or linked only through explicit C1 approval actions.

Respondent email, organiser snapshot fields, proposed Client contact fields and public hidden fields do not prove Client ownership.

## 11. Explicit Out Of Scope Confirmation

Not implemented:

- public form builder / custom field authoring;
- public link issuing UI;
- email template management UI;
- broader workflow notification sending;
- Client users/members;
- invitations;
- Client dashboard Project creation;
- Store;
- Orders;
- Commerce Core;
- Sales/Reporting;
- production/dispatch;
- SeasonPro integration;
- schema changes;
- migrations.

No `db:push`, seed or reset commands were run.

## 12. Checks Run

Checks completed:

```text
npm run type-check
npm run verify
git diff --check
docs git diff --check
```

Results:

- `npm run type-check` passed.
- `npm run verify` initially hit the known sandbox `tsx` IPC pipe permission issue, then passed when rerun with the approved escalation path.
- `git diff --check` passed.
- docs `git diff --check` passed.

## 13. Risks / Follow-Ups

Follow-ups:

- add a C1 "Copy public link" affordance for Project Intake forms so admins can easily find `/fund/project-initiation/[formSlug]`;
- consider server-side idempotency reuse semantics for repeated submit attempts with the same idempotency key;
- review the public form in browser across mobile and desktop viewports;
- ensure staging email configuration is intentionally tested before relying on public confirmation delivery;
- implement `1P-N0 - FUND System Notifications And Editable Email Defaults Planning` before adding broader workflow emails.

## 14. Recommended Next Slice

Recommended review slice:

```text
1P-G-F-A-R1 - Public Project Initiation Form UI Review And Smoke Testing
```

After review, decide whether to commit, align to `dev`, promote to `staging`, and add the C1 public-link affordance as a follow-up polish slice.
