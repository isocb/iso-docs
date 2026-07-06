# LMSPro Remediation Slice R4-A - Club Dashboard Communications Scoping Confirmation

Date: 2026-07-06
Module: LMSPro / SeasonPro
Status: Implemented locally on app `dev`; awaiting browser smoke, commit and promotion
Type: Communications access scoping remediation
Related planning: `docs/modules/lmspro/03-slice-planning/2026-07-06-lmspro-remediation-slice-r4-a-club-dashboard-communications-scoping-planning.md`

## Goal

Ensure the Club dashboard communications panel scopes all three tabs to the same current
Club dashboard context:

- Emails;
- Past Announcements;
- Variation Requests.

The immediate defect was that Variation Requests were not passed the dashboard `clubId`,
while Emails and Past Announcements already were.

## Implementation Summary

Updated:

```text
src/modules/lmspro/components/dashboard/ClubCommunicationsPanel.tsx
src/modules/lmspro/routers/team-variation-requests.router.ts
src/app/(app)/app/lmspro/club/teams/page.tsx
```

Changes:

- `ClubCommunicationsPanel` now calls:

```text
lmspro.teamVariationRequests.listForClub({ clubId })
```

- `teamVariationRequests.listForClub` now accepts:

```text
{ clubId?: string; seasonId?: string }
```

- when `clubId` is supplied, the router:
  - confirms the Club exists in the user's organisation;
  - permits access for authorised C1 users with `clubs.manage`;
  - otherwise requires the Club to be in the user's resolved permitted Club IDs;
  - filters returned variation requests to teams belonging to that Club.

- the Club teams page now passes `context.clubId` explicitly when loading variation
  requests for row icons.

## Behaviour After Change

On:

```text
/app/lmspro/club/dashboard
```

the Communications panel behaves as follows:

| Tab | Scope |
| --- | --- |
| Emails | Current dashboard Club |
| Past Announcements | Current dashboard Club |
| Variation Requests | Current dashboard Club |

The Variation Requests tab no longer relies only on the user's inferred Club membership
set when the dashboard has a specific Club context.

## Preserved Behaviour

The router still supports the older no-`clubId` call shape:

```text
lmspro.teamVariationRequests.listForClub({ seasonId })
```

When no `clubId` is supplied, it uses the user's resolved permitted Club IDs. This avoids
breaking existing callers while allowing Club-dashboard callers to be precise.

## Non-Goals

This slice did not:

- redesign the Communications panel UI;
- change email recipient/cohort logic;
- change announcement targeting;
- alter variation request create/approve/reject flows;
- change notification templates;
- perform data repair;
- add a review/test document yet.

## Checks Run

```text
npm run type-check
npx eslint src/modules/lmspro/components/dashboard/ClubCommunicationsPanel.tsx src/modules/lmspro/routers/team-variation-requests.router.ts 'src/app/(app)/app/lmspro/club/teams/page.tsx'
git diff --check
```

Results:

- `npm run type-check` passed.
- targeted ESLint passed with 0 errors.
- targeted ESLint reported existing `any` warnings in `club/teams/page.tsx`; no new error
  blocks were introduced.
- `git diff --check` passed.

## Browser Smoke Still Required

Before commit/promotion, confirm:

- C2 Club dashboard loads;
- C1 hat-swap / affiliated Club dashboard loads;
- Emails tab is Club scoped;
- Past Announcements tab is Club scoped;
- Variation Requests tab shows only variation requests for the current Club;
- variation requests belonging to another Club do not appear.

## Commit Reference

Pending.

## Promotion Reference

Pending.

Expected chain once smoke is accepted:

```text
local dev -> origin/dev -> staging -> origin/staging
```

Live promotion should remain a separate decision after staging smoke.

## Follow-On

Continue adding communications/email/announcement CR items to:

```text
docs/modules/lmspro/01-cr-inputs/2026-07-06-lmspro-cr-communications-email-announcements-remediation-input.md
```

Future R4 slices should maintain:

- CR input;
- `03-slice-planning`;
- `04-implementation-confirmations`;
- `05-review-and-test` after operator/developer review.
