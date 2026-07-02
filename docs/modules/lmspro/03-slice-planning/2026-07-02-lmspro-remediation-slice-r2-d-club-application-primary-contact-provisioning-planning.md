# LMSPro Remediation Slice R2-D - Club Application Primary Contact Provisioning Planning

Date: 2026-07-02
Module: LMSPro / SeasonPro
Status: Planned for immediate implementation on app `dev`
Type: Preventive code hardening after R2 staging audit

## Goal

Close the remaining hidden membership gap in the new Club application approval route.

The import route was strengthened in R2-A, but review found that the public Club application
approval and waitlist paths still used a separate local helper. That helper created or updated
the primary contact user and set `User.lmsproClubId`, but did not ensure the authoritative
`LMSProClubOfficial` membership row.

R2-D should make Club application approval use the same provisioning policy as import.

## Problem

The hidden-risk path is:

```text
new Club application submitted
-> Club shell created
-> application approved or waitlisted
-> primary contact converted into an active C2 user
-> user points at current Club through User.lmsproClubId
-> no LMSProClubOfficial row is guaranteed
-> next season roll-forward creates new Club IDs
-> stale User.lmsproClubId can become the only link
-> C2 save checks may fail or rely on resolver tolerance
```

This is similar in shape to the imported-user issue, but it is triggered by the approval
workflow rather than the CSV import.

## Scope

In scope:

- `clubApplications.approve`;
- `clubApplications.waitlist`;
- primary contact user provisioning for approved/waitlisted Club applications;
- reuse of `provisionClubUser`;
- confirmation that no live/staging data is edited by the code change itself;
- docs and review/test updates.

Out of scope:

- changing public application submission;
- changing team naming;
- changing application email templates;
- deleting or rewriting existing users;
- live data repair;
- broad Club Officials UI changes.

## Intended Code Change

Replace the local `upsertPrimaryContactClubUser` helper in:

```text
src/modules/lmspro/routers/club-applications.router.ts
```

with:

```text
provisionClubUser
```

Expected result:

- new primary contact users are created consistently;
- existing same-organisation users are linked consistently;
- cross-organisation email collisions are skipped safely;
- `LMSProClubOfficial` is always ensured for the approved/waitlisted Club;
- same-name stale legacy pointers are repaired by the shared helper where safe.

## Tests And Checks

Run:

```text
npm test -- run src/modules/lmspro/lib/__tests__/provision-club-user.test.ts
npm test -- run src/modules/lmspro/import/handlers/__tests__/club.test.ts
npm run type-check
./node_modules/.bin/eslint src/modules/lmspro/routers/club-applications.router.ts src/modules/lmspro/lib/provision-club-user.ts
git diff --check
```

## Promotion Plan

Code:

```text
local dev -> origin/dev -> staging -> origin/staging
```

Docs:

The docs repo currently has `main`/`origin/main`, not a separate `dev`/`staging` branch.
Commit the documentation to the docs repo without disturbing unrelated existing docs work.

## Acceptance Criteria

- Application approval and waitlist both call `provisionClubUser`.
- The old local helper is removed.
- Focused tests and type-check pass.
- R2-D confirmation and review docs exist.
- The live repair plan notes that R2-D should be included before final live promotion.
