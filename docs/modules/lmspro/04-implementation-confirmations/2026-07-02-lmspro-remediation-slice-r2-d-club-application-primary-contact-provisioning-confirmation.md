# LMSPro Remediation Slice R2-D - Club Application Primary Contact Provisioning Confirmation

Date: 2026-07-02
Module: LMSPro / SeasonPro
Status: Implemented, committed, promoted to staging
Type: Preventive code hardening confirmation

## Goal

Ensure approved or waitlisted new Club applications provision their primary contact through
the same safe path used by the strengthened import route.

## Implementation Summary

Updated:

```text
src/modules/lmspro/routers/club-applications.router.ts
```

Changes:

- imported `provisionClubUser`;
- removed the local `upsertPrimaryContactClubUser` helper;
- changed `clubApplications.approve` to call `provisionClubUser`;
- changed `clubApplications.waitlist` to call `provisionClubUser`;
- preserved existing Club approval, waitlist, team transition and email-notification behaviour.

## Behaviour After Change

When a Club application is approved or waitlisted:

- the primary contact user is created or linked;
- the default Club role is merged where available;
- the legacy `User.lmsproClubId` is repaired when safe;
- the `LMSProClubOfficial` membership row is ensured;
- cross-organisation email matches are skipped rather than hijacked.

This prevents the application route from creating a hidden stale-link problem for the next
season roll-forward.

## Data Boundary

No staging or live data repair is performed by this slice.

This is a code-path prevention fix only.

## Checks

```text
npm test -- run src/modules/lmspro/lib/__tests__/provision-club-user.test.ts
npm test -- run src/modules/lmspro/import/handlers/__tests__/club.test.ts
npm run type-check
./node_modules/.bin/eslint src/modules/lmspro/routers/club-applications.router.ts src/modules/lmspro/lib/provision-club-user.ts
git diff --check
```

Results:

- Provisioning helper test passed: 3 tests.
- Club import regression test passed: 16 tests.
- `npm run type-check` passed.
- Targeted ESLint passed with 0 errors and 1 pre-existing warning in `club-applications.router.ts`.
- App `git diff --check` passed.
- Docs `git diff --check` passed.

## Commit Reference

```text
f09000b fix(lmspro): align club application user provisioning
```

## Promotion Reference

```text
local dev -> origin/dev -> staging -> origin/staging
```

Promotion completed:

```text
f09000b is present on local dev, origin/dev, local staging and origin/staging.
```
