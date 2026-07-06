# LMSPro CR Input - Communications, Email And Announcements Remediation

Date: 2026-07-06
Module: LMSPro / SeasonPro
Source: Operator review of LMSPro Club dashboard communications behaviour
Status: CR input captured; first remediation item implemented locally on app `dev`
Priority: High

## Purpose

This CR input collects LMSPro communications, email and announcement remediation items
found during operator smoke testing and follow-on review.

The intent is to keep related communication issues together while still implementing them
as small controlled slices:

```text
CR input -> slice plan -> implementation confirmation -> review/test
```

This document can be extended with further CR items before each item is moved into its own
planning and implementation slice.

## Architectural Boundary

LMSPro should continue to use the shared IsoStack communications/email architecture.

Do not create a parallel LMSPro-only email system unless a later CR explicitly approves a
new architectural direction.

Relevant existing references:

- `docs/modules/lmspro/Communication_function_planning.md`
- `docs/modules/lmspro/planning/CR-18-Email-Audit-And-Completion-Plan.md`
- `docs/modules/lmspro/planning/CR-18-Email-Notifications-System-Development-Plan.md`

## CR Item R4-001 - Club Dashboard Communications Tab Scoping

### User Observation

When logged in as either:

- a C1 user using hat-swap / affiliated Club access; or
- a C2 Club user;

the Club dashboard communications panel at:

```text
/app/lmspro/club/dashboard
```

shows three tabs:

- Emails;
- Past Announcements;
- Variation Requests.

The operator concern was that Variation Requests did not appear to be scoped as clearly to
the current Club dashboard as Emails and Past Announcements.

### Current Behaviour Found

The dashboard passed the current `clubId` to:

- the Emails tab through `lmspro.communications.listForClub`;
- active and dismissed announcements through `lmspro.announcements.*ForClub`.

The Variation Requests tab called:

```text
lmspro.teamVariationRequests.listForClub
```

without passing the dashboard `clubId`.

That meant the result was based on the logged-in user's inferred Club memberships rather
than explicitly on the Club dashboard being viewed.

### Desired Behaviour

All three Club dashboard communications tabs must be scoped to the same Club context:

```text
Club dashboard clubId
-> Emails for that Club
-> Past Announcements for that Club
-> Variation Requests for that Club
```

The server route must enforce this boundary. The UI passing a `clubId` is not sufficient by
itself.

### Acceptance Criteria

R4-001 is complete when:

- the Club dashboard Variation Requests tab passes the current dashboard `clubId`;
- `teamVariationRequests.listForClub` accepts an optional `clubId`;
- when a `clubId` is supplied, the router verifies the Club belongs to the user's
  organisation;
- non-league users can only query a Club they are permitted to access;
- C1 users with appropriate Club management access can query the selected Club;
- returned variation requests are filtered to teams belonging to that Club;
- existing Club teams page variation-request icons remain functional;
- type-check and targeted lint pass.

## Later CR Items To Add

Add further communications/email/announcement remedial items below this section before
moving them into separate R4 slices.

## CR Item R4-002 - Announcement Editor Rich Text Alignment

### User Observation

The Announcement create/edit experience should be aligned with the recently improved email
compose content entry experience at:

```text
/app/lmspro/communications
```

The email compose path now provides a larger content entry surface and a richer editing
experience. Announcement text entry should not feel like a smaller or older control when
announcements may carry important league information.

### Desired Behaviour

Announcement create/edit should use an editor pattern consistent with the email compose
experience:

- larger content entry area;
- rich text editing where appropriate;
- content preview/sanitisation consistent with current announcement display rules;
- polished editing experience for long announcements;
- no regression to dashboard announcement rendering.

### Acceptance Criteria

R4-002 is complete when:

- C1 announcement create/edit uses the larger rich text editing pattern;
- existing announcement HTML sanitisation remains safe;
- active and dismissed announcement display still renders correctly for C2 users;
- browser smoke confirms create, edit, view and dismiss behaviour.

## CR Item R4-003 - Publish Announcement With Optional Email Send

### User Observation

When a league announcement is published to Club dashboards, there should be an option to
also email the same announcement content to the targeted Club cohort.

This would let the announcement appear in-app while also reaching the Club secretary /
primary contact by email.

### Desired Behaviour

When creating or publishing an Announcement, C1 should be able to choose:

```text
Publish to dashboard only
Publish to dashboard and email targeted Clubs
```

The email recipients should mirror the Announcement target cohort:

- all Clubs when `targetClubIds` is empty;
- only selected Clubs when `targetClubIds` is populated;
- primary Club user / Club secretary / primary contact, according to the current LMSPro
  recipient model.

The email content should use the same title/message content as the Announcement, with
appropriate email branding and audit logging through the shared communications service.

### Important Boundaries

This should not create a separate announcement-email system.

It should reuse the shared communications/email sending architecture and should record the
email in the normal communication history where feasible.

### Acceptance Criteria

R4-003 is complete when:

- C1 can publish an Announcement without sending email;
- C1 can publish an Announcement and send matching email to the targeted Clubs;
- targeted Club logic matches dashboard announcement targeting;
- email sending failure is handled safely and visibly without corrupting the Announcement;
- sent email audit/history is available through the normal communications records;
- C2 dashboard announcement behaviour is unchanged.

## CR Item R4-004 - Email Compose Recipient Accordion Defaults And Role Cohort Accuracy

### User Observation

In email compose recipient selection, the recipient accordions/concertinas should open in a
more helpful default state.

Only the most commonly used role sections should be open initially:

- Club Roles;
- League Roles.

Other recipient sections should start closed to reduce visual load.

The recipient role lists should also mirror the actual live roles available in the tenant.
Legacy template roles should not be offered as selectable recipient roles.

### Desired Behaviour

Email compose recipient selection should:

- open Club Roles by default;
- open League Roles by default;
- close other recipient accordions by default;
- load role options from current live tenant roles;
- exclude legacy template roles and obsolete static role labels;
- avoid presenting role options that do not map to actual recipients.

### Acceptance Criteria

R4-004 is complete when:

- compose email opens with only Club Roles and League Roles expanded by default;
- recipient role options match current tenant role configuration;
- legacy/template roles are excluded from normal recipient selection;
- role-based recipient preview/counts remain accurate;
- no existing cohort type is removed, only default collapsed state and role-source hygiene
  are changed.

## CR Item R4-005 - Email Draft Save

### User Observation

Email compose needs a Save Draft option so C1 can prepare communications without sending
them immediately.

### Desired Behaviour

Email compose should support:

- save draft;
- reopen/edit draft;
- send from draft;
- delete draft where appropriate;
- preserve subject, content, selected recipients/cohorts and attachments where supported.

Drafts should be clearly separated from sent emails.

### Acceptance Criteria

R4-005 is complete when:

- C1 can save a composed email as a draft;
- draft content and recipient/cohort selections persist;
- C1 can reopen the draft and send it later;
- sent email records remain immutable after send;
- draft records do not appear as sent communications to Clubs.

## CR Item R4-006 - Duplicate Sent Email To Draft

### User Observation

The sent email list should support a "duplicate to draft" action.

This is useful when league administrators need to resend a similar communication with small
changes, or reuse a prior message as a starting point.

### Desired Behaviour

From the sent email list, C1 should be able to duplicate a sent email into a new draft.

The draft should copy:

- subject;
- body/content;
- recipient cohort or recipient list where safely reusable;
- attachments where supported and still available.

The new draft must be independent from the original sent email. Editing the draft must not
change the historical sent record.

### Acceptance Criteria

R4-006 is complete when:

- sent email rows expose a duplicate-to-draft action;
- the duplicated draft opens or is available in drafts;
- original sent email history remains unchanged;
- recipient/cohort reuse is clear and reviewable before sending;
- audit/history can distinguish original sent email from the duplicated draft.

## Potential Future Themes

Further items may also include:

- notification settings and pause/resume behaviour;
- key-date email sequence review;
- sender identity / reply-to behaviour;
- communication history and audit visibility;
- announcement lifecycle and archive visibility beyond the editor/email-send items above.

## Linked Slices

First implementation/planning slices:

```text
docs/modules/lmspro/03-slice-planning/2026-07-06-lmspro-remediation-slice-r4-a-club-dashboard-communications-scoping-planning.md
docs/modules/lmspro/03-slice-planning/2026-07-06-lmspro-remediation-slice-r4-b-communications-email-announcements-workflow-planning.md
```
