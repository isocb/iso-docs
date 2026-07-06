# LMSPro Remediation Slice R4-A - Club Dashboard Communications Scoping Planning

Date: 2026-07-06
Module: LMSPro / SeasonPro
Status: Planned; implemented locally on app `dev`
Type: Communications access scoping remediation
Related CR input: `docs/modules/lmspro/01-cr-inputs/2026-07-06-lmspro-cr-communications-email-announcements-remediation-input.md`

## Purpose

Ensure every tab in the Club dashboard communications panel is scoped to the current Club
dashboard context.

The immediate issue is the Variation Requests tab. Emails and Past Announcements already
receive the dashboard `clubId`. Variation Requests must follow the same pattern and must be
enforced server-side.

## Route Under Review

```text
/app/lmspro/club/dashboard
```

Panel:

```text
src/modules/lmspro/components/dashboard/ClubCommunicationsPanel.tsx
```

Tabs:

- Emails;
- Past Announcements;
- Variation Requests.

## Existing Scoping

### Emails

The Emails tab calls:

```text
lmspro.communications.listForClub({ clubId, limit })
```

The router verifies:

- current user;
- organisation ownership;
- effective Club access;
- C1 `clubs.manage` access where appropriate.

This is already Club scoped.

### Past Announcements

The Past Announcements tab calls:

```text
lmspro.announcements.listDismissedForClub({ clubId })
```

Active announcements also call:

```text
lmspro.announcements.listActiveForClub({ clubId })
```

The router verifies access and filters announcement dismissals by Club.

This is already Club scoped.

### Variation Requests

Before R4-A, the dashboard called:

```text
lmspro.teamVariationRequests.listForClub(undefined)
```

The route inferred permitted Club IDs from the logged-in user and returned variation
requests for all inferred Clubs. That behaviour is useful as a legacy fallback, but it is
too broad for a panel that is explicitly rendering one Club dashboard.

## Implementation Scope

R4-A should:

- pass the dashboard `clubId` from `ClubCommunicationsPanel` into the Variation Requests
  query;
- extend `teamVariationRequests.listForClub` input to accept optional `clubId`;
- verify the supplied Club exists in the user's organisation;
- reject access where the user cannot access that Club and is not a permitted C1 manager;
- when `clubId` is supplied, return only variation requests for teams belonging to that
  Club;
- preserve existing no-`clubId` fallback behaviour for any existing caller that relies on
  permitted Club IDs;
- update the Club teams page to pass its current `context.clubId` explicitly.

## Files Expected To Change

```text
src/modules/lmspro/components/dashboard/ClubCommunicationsPanel.tsx
src/modules/lmspro/routers/team-variation-requests.router.ts
src/app/(app)/app/lmspro/club/teams/page.tsx
```

## Out Of Scope

R4-A must not:

- redesign the communications panel;
- alter announcement targeting policy;
- alter email recipient or cohort resolution;
- change variation request create/approve/reject workflows;
- change C1 league dashboard variation-request views;
- introduce new notification templates;
- perform data remediation.

## Review And Test Plan

Developer checks:

```text
npm run type-check
npx eslint src/modules/lmspro/components/dashboard/ClubCommunicationsPanel.tsx src/modules/lmspro/routers/team-variation-requests.router.ts 'src/app/(app)/app/lmspro/club/teams/page.tsx'
git diff --check
```

Browser smoke:

- log in as a C2 Club user;
- open `/app/lmspro/club/dashboard`;
- confirm Emails tab only shows emails for the Club;
- confirm Past Announcements only shows dismissed announcements for the Club;
- confirm Variation Requests only shows requests for teams belonging to the Club;
- repeat with a C1 user using hat-swap / affiliated Club access;
- if possible, compare against another Club with known variation requests and confirm they
  do not appear in the current Club dashboard.

## Acceptance Criteria

R4-A is complete when:

- all three Club dashboard communications tabs are Club scoped;
- the Variation Requests tab uses the same dashboard `clubId` context as the other tabs;
- the server route enforces organisation and Club access;
- local type-check passes;
- targeted lint has no new errors;
- browser smoke confirms the C1 hat-swap and C2 views behave as expected.

## Follow-On Slice Handling

Further communications, email and announcements CRs should be added to:

```text
docs/modules/lmspro/01-cr-inputs/2026-07-06-lmspro-cr-communications-email-announcements-remediation-input.md
```

Each accepted item should then receive its own R4 slice plan and implementation
confirmation.

## Implementation Confirmation

Implementation confirmation for this slice:

```text
docs/modules/lmspro/04-implementation-confirmations/2026-07-06-lmspro-remediation-slice-r4-a-club-dashboard-communications-scoping-confirmation.md
```
