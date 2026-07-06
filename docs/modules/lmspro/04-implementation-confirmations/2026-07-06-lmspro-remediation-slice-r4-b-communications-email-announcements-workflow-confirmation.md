# LMSPro Remediation Slice R4-B - Communications Email And Announcements Workflow Confirmation

Date: 2026-07-06
Module: LMSPro / SeasonPro
Status: Implemented and browser-smoke passed on local app `dev`
Type: Communications workflow refinement
Planning: `docs/modules/lmspro/03-slice-planning/2026-07-06-lmspro-remediation-slice-r4-b-communications-email-announcements-workflow-planning.md`
CR input: `docs/modules/lmspro/01-cr-inputs/2026-07-06-lmspro-cr-communications-email-announcements-remediation-input.md`

## Summary

R4-B has been implemented against the shared IsoStack communications service without a
schema change.

The implementation covers:

- Announcement body editing now uses the shared rich text editor pattern rather than a
  small plain text area;
- Announcement publish can optionally email the same Announcement content to the targeted
  Club cohort;
- compose-email recipient groups now open Club Roles and League Roles by default while
  leaving other recipient accordions closed;
- email compose can save and reopen drafts using existing `EmailStatus.DRAFT` support;
- sent emails can be duplicated into editable drafts while preserving the original sent
  history record.

## Files Changed

Application files:

```text
src/app/(app)/app/lmspro/communications/page.tsx
src/core/services/communications/components/CohortPicker.tsx
src/core/services/communications/components/ComposeEmailModal.tsx
src/core/services/communications/routers/emails.router.ts
src/modules/lmspro/components/communications/AnnouncementModal.tsx
src/modules/lmspro/routers/announcements.router.ts
```

Related R4-A files remain in the same local working batch but are documented separately:

```text
src/app/(app)/app/lmspro/club/teams/page.tsx
src/modules/lmspro/components/dashboard/ClubCommunicationsPanel.tsx
src/modules/lmspro/routers/team-variation-requests.router.ts
```

## Implementation Details

### R4-B1 - Announcement Rich Text Alignment

`AnnouncementModal` now uses the shared `RichTextEditor` with a larger editing area. The
announcement router continues to sanitise announcement HTML before storing and returning
content.

### R4-B2 - Announcement Email Send

Announcement create/update accepts an optional `sendEmailOnPublish` flag. When selected and
the Announcement is active, the router:

- resolves targeted Clubs from `targetClubIds`, or all approved current-season Clubs when
  no targets are selected;
- chooses the Club primary contact first, then falls back to a Club official email;
- creates a normal LMSPro `Email` record and recipient records;
- sends through the shared `sendBatchEmails` service;
- records sent/failed counts and audit log entries.

Email failure does not roll back the Announcement. The C1 user receives an outcome message
showing whether the email was sent, partially failed, failed, or had no recipients.

### R4-B3 - Recipient Accordion Defaults

`CohortPicker` now supports default-expanded category ids. LMSPro compose opens:

```text
clubRoles
leagueRoles
```

Other categories start closed.

The role source remains the existing live tenant role tree. Existing provider behaviour
already filters by active LMSPro tenant roles, so this slice does not add a new static or
template role list.

### R4-B4 - Save Draft

`ComposeEmailModal` can now save a draft. Drafts preserve:

- subject;
- rich text body;
- cohort filters;
- manual recipients;
- CC/BCC;
- linked Club/Team metadata.

Draft save uses the existing `Email` model and `DRAFT` status. No Prisma schema change was
required.

The draft edit path was smoke-tested and then corrected after an operator finding: the
Recipients and Preview tabs initially appeared inoperative because a fresh default
`initialFilters` array caused the modal to reset back to Compose on every render. The modal
now uses a stable empty default, and draft tabs remain usable.

### R4-B5 - Duplicate Sent Email To Draft

The sent email list now has a `Duplicate to Draft` action. The router creates a new draft
from the source email and copies:

- subject;
- body;
- template reference;
- cohort filter;
- CC/BCC;
- linked Club/Team metadata;
- recipient records for review;
- attachment metadata.

The original email is not modified.

## Checks Run

Developer checks:

```text
npx tsc --noEmit --incremental false
npx eslint src/modules/lmspro/components/communications/AnnouncementModal.tsx src/modules/lmspro/routers/announcements.router.ts src/core/services/communications/components/ComposeEmailModal.tsx src/core/services/communications/components/CohortPicker.tsx src/core/services/communications/routers/emails.router.ts src/app/(app)/app/lmspro/communications/page.tsx
git diff --check
```

Results:

- TypeScript passed.
- Targeted ESLint passed with warnings only.
- `git diff --check` passed.

Known lint warnings remain in older communications compose/router code, including unused
legacy variables and `any` types. They did not block this slice and were not broadened into
this remediation.

## Browser Smoke

Operator smoke on local dev passed.

Confirmed:

- create Announcement with rich text;
- create Announcement without email;
- create Announcement with email to a small test Club cohort;
- save a new draft;
- edit draft email opens;
- Recipients tab works after the draft modal reset fix;
- Preview tab works after the draft modal reset fix.
- reopen/edit/send draft;
- duplicate sent email to draft and review before sending.

## Boundaries

This slice did not:

- rebuild the communications service;
- change sender domain policy;
- add unsubscribe/legal preference management;
- change key-date sequence scheduling;
- change notification settings pause/resume;
- implement dynamic Age Group / Division role-permission routing.

## Recommendation

R4-B can be committed with the R4-A/R4-B communications remediation batch on local `dev`,
aligned to `origin/dev`, and promoted through staging for online testing.
