# LMSPro R12-A Free Day Owner Notice Authority Planning

Date: 2026-08-11

Status: **IMPLEMENTED; COMPLETE GREEN LOCAL PASS; EXACT `39a25d99` ALIGNED THROUGH
DEV/STAGING; STAGING HUMAN ACCEPTANCE PENDING**

CR:

[`Free Day Owner notice authority CR-Fix`](../01-cr-inputs/CR-Fix-2026-08-11-lmspro-free-day-owner-notice-authority.md)

Triage:

[`Free Day Owner notice authority triage`](../02-triage/2026-08-11-lmspro-free-day-owner-notice-authority-triage.md)

## 1. Objective

Make the current season's League Owner-configured standard Free Day notice period definitive
through every UI and server consumer, with a 28-day default and exact accepted range 1–90.

## 2. Implementation Boundary

1. Add a pure shared policy with constants for default 28, minimum 1 and maximum 90.
2. Return every valid configured integer unchanged; use 28 only for absent/invalid legacy
   data.
3. Replace the hard 28-day `Math.max` in both request calendars and server validation.
4. Align the Team-list notice consumer to the same policy.
5. Change schema, create/edit defaults and validation from historic 7/0 to 28/1.
6. Add a bounded migration which changes the database default to 28 and normalises only 0
   and 7 to 28.
7. Invalidate `seasons.getCurrent` after both season-edit success paths.
8. Add focused policy and migration verification.

Likely files:

```text
prisma/schema.prisma
prisma/migrations/<r12-a>/migration.sql
src/modules/lmspro/lib/free-day-notice-policy.ts
src/modules/lmspro/lib/free-day-notice-policy.test.ts
src/server/core/routers/lmspro/freeDays.router.ts
src/modules/lmspro/components/dashboard/FreeDaysRequest.tsx
src/app/(app)/app/lmspro/club/free-days/page.tsx
src/modules/lmspro/routers/teams.router.ts
src/modules/lmspro/routers/seasons.router.ts
src/app/(app)/app/lmspro/seasons/page.tsx
src/app/(app)/app/lmspro/seasons/[seasonId]/_components/SeasonOverviewTab.tsx
```

## 3. Acceptance Matrix

Automated proof:

- 1, 7, 27, 28 and 90 resolve unchanged;
- null/undefined, 0, negative, fractional and >90 resolve to default 28;
- migration changes only 0/7 legacy rows and the column default;
- direct server validation accepts the exact configured boundary and refuses one day early;
- calendars present the same minimum;
- season save refreshes current-season consumers; and
- no Special Free Day/quota/status behaviour changes.

Human local proof:

1. set current season to 1 and verify tomorrow is the first eligible calendar date;
2. set it to 14 and verify exactly 14 days;
3. set it to 28 and verify exactly 28 days;
4. set it to 90 and verify exactly 90 days;
5. reopen the season each time and confirm persistence;
6. confirm the calendar updates immediately without hard refresh; and
7. submit one controlled boundary request and confirm one-day-early direct/UI refusal.

## 4. Recovery And Promotion Boundary

The original plan stopped before staging. The control owner subsequently accepted the
complete local smoke and explicitly authorised promotion. Exact `39a25d99` passed the dev
Security Scan before staging alignment; the exact staging Security Scan and public health
also pass. Application
rollback is sufficient; retaining 28 in legacy normalised rows is safe because it is their
pre-correction effective value. Human local acceptance is mandatory before a commit or
staging proposal and is now recorded complete. Main remains unauthorised pending staging
human acceptance.
