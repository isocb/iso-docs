# LMSPro Remediation Slice R4-B - Communications Email And Announcements Workflow Planning

Date: 2026-07-06
Module: LMSPro / SeasonPro
Status: Planned
Type: Communications workflow refinement
Related CR input: `docs/modules/lmspro/01-cr-inputs/2026-07-06-lmspro-cr-communications-email-announcements-remediation-input.md`

## Purpose

R4-B covers the next communications, email and announcement workflow improvements captured
in the R4 CR input after R4-A Club dashboard communications scoping.

This slice addresses:

- R4-002 - Announcement editor rich text alignment;
- R4-003 - optional email send when publishing an Announcement;
- R4-004 - email compose recipient accordion defaults and live-role accuracy;
- R4-005 - email draft save;
- R4-006 - duplicate sent email to draft.

The slice can be implemented in one controlled pass if the code surfaces are cohesive, but
the work should be allowed to split into smaller implementation confirmations if the draft
or announcement-email paths expose deeper behaviour.

## Architectural Boundary

LMSPro must continue to use the shared IsoStack communications/email architecture.

Do not build a separate LMSPro-only email sending system.

Relevant references:

- `docs/modules/lmspro/Communication_function_planning.md`
- `docs/modules/lmspro/planning/CR-18-Email-Audit-And-Completion-Plan.md`
- `docs/modules/lmspro/planning/CR-18-Email-Notifications-System-Development-Plan.md`

## Current Implementation Signals

Initial code review shows:

- `AnnouncementModal` currently uses a Mantine `Textarea` for announcement body input;
- `ComposeEmailModal` uses the shared `RichTextEditor`;
- `Email.status` already supports `DRAFT`;
- `Email` already stores `cohortFilter`, body, subject, attachments and sent metadata;
- `EmailRecipient` stores resolved recipient and delivery information;
- LMSPro cohort role trees are resolved in the communications provider/cohort resolver.

This suggests R4-B should first reuse existing communications infrastructure before adding
schema.

## R4-B1 - Announcement Editor Rich Text Alignment

### Scope

Replace or align the Announcement body editor with the richer/larger editor pattern used by
email compose.

Expected code surfaces:

```text
src/modules/lmspro/components/communications/AnnouncementModal.tsx
src/modules/lmspro/routers/announcements.router.ts
src/lib/sanitize-html-content.ts
src/components/ui/RichTextEditor.tsx
```

### Expected Behaviour

- Announcement create/edit has a larger content editor.
- The editor supports the same broad rich text expectations as compose email where safe.
- Existing sanitisation still protects dashboard rendering.
- Active and dismissed announcements display correctly.

### Boundaries

Do not change announcement targeting in this sub-slice unless required for the optional
email send.

## R4-B2 - Publish Announcement With Optional Email Send

### Scope

Add a C1 option to send the Announcement content by email when publishing.

Expected code surfaces:

```text
src/modules/lmspro/components/communications/AnnouncementModal.tsx
src/modules/lmspro/routers/announcements.router.ts
src/core/services/communications/lib/send-email.ts
src/core/services/communications/routers/emails.router.ts
src/modules/lmspro/communications/notification-recipients.ts
src/modules/lmspro/communications/cohort-resolver.ts
```

### Expected Behaviour

C1 can choose:

```text
Publish to dashboard only
Publish to dashboard and email targeted Clubs
```

Email recipients should mirror the dashboard Announcement target:

- empty `targetClubIds` means all Clubs in the current scope;
- populated `targetClubIds` means only those Clubs;
- recipient should be the current primary Club user / Club secretary / primary contact,
  according to the existing LMSPro recipient model.

The email should use the shared email service, organisation branding/letterhead where
available, and normal communications audit/history where feasible.

### Error Policy

Email send failure must not corrupt the Announcement record.

Implementation should make the result clear to C1, for example:

```text
Announcement published; email send failed for N recipients.
```

or:

```text
Announcement published and email sent to N recipients.
```

The exact user-facing text can be refined during implementation.

## R4-B3 - Recipient Accordion Defaults And Live Role Accuracy

### Scope

Improve the email compose recipient selection defaults and ensure role lists reflect live
tenant roles.

Expected code surfaces:

```text
src/core/services/communications/components/CohortPicker.tsx
src/core/services/communications/components/ComposeEmailModal.tsx
src/modules/lmspro/communications/provider.ts
src/modules/lmspro/communications/cohort-resolver.ts
src/modules/lmspro/lib/componentResolution.ts
```

### Expected Behaviour

On opening email compose:

- Club Roles starts open;
- League Roles starts open;
- other accordions start closed;
- role options come from current tenant roles;
- legacy template/static roles are excluded from normal recipient selection;
- no valid existing cohort type is removed.

### Live Role Accuracy

Implementation should verify whether legacy/template roles are identifiable by:

- module role status;
- role scope;
- naming convention;
- template/default flags if present;
- absence of live tenant assignment.

If the code does not currently have a reliable marker for "template role", document the
finding in the implementation confirmation and avoid unsafe guessing.

## R4-B4 - Save Email Draft

### Scope

Add a Save Draft path for email compose.

Expected code surfaces:

```text
src/core/services/communications/components/ComposeEmailModal.tsx
src/core/services/communications/routers/emails.router.ts
src/app/(app)/app/lmspro/communications/page.tsx
prisma/schema.prisma
```

### Schema Expectation

The current `Email` model already supports:

```text
EmailStatus.DRAFT
```

Therefore, no schema change should be required unless implementation discovers the current
router shape cannot persist all needed draft data.

### Expected Behaviour

C1 can:

- save an email as draft;
- reopen/edit the draft;
- send from draft;
- delete draft where appropriate.

Draft should preserve, where supported:

- subject;
- body/content;
- cohort filter;
- manual recipients;
- CC/BCC;
- linked Club/Team metadata;
- attachments.

Draft emails must not appear to C2 users as sent communications.

## R4-B5 - Duplicate Sent Email To Draft

### Scope

Add a duplicate-to-draft action from the sent email list.

Expected code surfaces:

```text
src/app/(app)/app/lmspro/communications/page.tsx
src/core/services/communications/routers/emails.router.ts
src/core/services/communications/components/ComposeEmailModal.tsx
```

### Expected Behaviour

From a sent email row, C1 can create a new draft copied from the original sent email.

The new draft may copy:

- subject;
- body/content;
- cohort filter or recipient list where safely reusable;
- linked Club/Team metadata;
- attachments where available and safe.

The original sent email must remain immutable.

### Recipient Safety

Duplicated recipients/cohorts must be reviewable before sending.

If a cohort was dynamic, the draft should clearly use the cohort definition and allow C1 to
preview current recipients before sending. If exact historical recipients are copied, this
must be explicit.

## Out Of Scope

R4-B does not include:

- rebuilding the communications service;
- changing sender domain policy;
- adding unsubscribe/legal preference management;
- changing key-date sequence scheduling;
- changing notification settings pause/resume;
- changing C2 Club dashboard communications scoping already covered by R4-A;
- dynamic Age Group / Division role-permission routing, which is captured separately.

## Suggested Implementation Order

Recommended order:

1. R4-B1 announcement editor alignment.
2. R4-B2 optional announcement email send.
3. R4-B3 recipient accordion/live-role cleanup.
4. R4-B4 draft save.
5. R4-B5 duplicate sent email to draft.

If draft save requires more work than expected, split R4-B4/R4-B5 into a separate
implementation slice before coding further.

## Review And Test Plan

Developer checks:

```text
npm run type-check
npx eslint src/modules/lmspro/components/communications/AnnouncementModal.tsx src/modules/lmspro/routers/announcements.router.ts src/core/services/communications/components/ComposeEmailModal.tsx src/core/services/communications/components/CohortPicker.tsx src/core/services/communications/routers/emails.router.ts src/app/(app)/app/lmspro/communications/page.tsx
git diff --check
```

Browser smoke:

- create Announcement with rich text content;
- edit Announcement and confirm content remains safe/rendered correctly;
- publish Announcement without email;
- publish Announcement with email to selected test Club cohort;
- confirm sent email is logged where expected;
- confirm C2 dashboard shows Announcement;
- open compose email and confirm only Club Roles and League Roles are expanded by default;
- confirm recipient role options match live tenant roles and exclude legacy/template roles;
- save a draft;
- reopen/edit/send draft;
- duplicate a sent email to draft;
- confirm original sent email remains unchanged.

## Acceptance Criteria

R4-B is complete when:

- Announcement editor aligns with the compose email rich text/large editor pattern;
- Announcement publish can optionally send matching email to targeted Clubs;
- email compose recipient accordions default to Club Roles and League Roles open only;
- role recipient lists are live-role accurate and do not expose legacy template roles;
- C1 can save and reopen email drafts;
- C1 can duplicate sent email to draft;
- C2 users do not see drafts as communications;
- type-check, targeted lint and browser smoke pass;
- an implementation confirmation is created in `04-implementation-confirmations`;
- a review/test document is created in `05-review-and-test` after smoke.

## Implementation Confirmation Target

Expected confirmation document:

```text
docs/modules/lmspro/04-implementation-confirmations/2026-07-06-lmspro-remediation-slice-r4-b-communications-email-announcements-workflow-confirmation.md
```

## Recommended Implementation Prompt

Proceed with LMSPro Remediation Slice R4-B on local app `dev`, keeping changes limited to
communications, email compose and announcements. Implement the R4-B sub-items in the
recommended order, stop and report if draft save requires schema or larger router changes,
then update the implementation confirmation and prepare a 05 review/test document after
browser smoke.
