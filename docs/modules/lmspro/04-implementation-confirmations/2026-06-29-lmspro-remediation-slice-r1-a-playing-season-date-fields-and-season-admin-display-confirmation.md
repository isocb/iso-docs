# LMSPro Remediation Slice R1-A - Playing Season Date Fields And Season Admin Display Confirmation

Date: 2026-06-29  
Module: LMSPro / SeasonPro  
Branch: `feature/seasonpro-remediation`  
Status: Implemented, pending review

## Slice Goal

Add optional Playing Season Start and Playing Season End date boundaries to LMSPro seasons, distinct from the technical/admin Season Start Date and End Date.

## Implementation Summary

Implemented nullable playing-season date fields for `LMSProSeason`, added a nullable-column migration, exposed the dates through Season create/update flows, added C1 Season CRUD and Season admin UI fields, and updated existing season-progress display logic so it no longer uses technical/admin season dates as the playing-season basis.

Existing seasons remain blank until manually set.

## Files Changed

App files:

- `prisma/schema.prisma`
- `prisma/migrations/20260629160000_add_lmspro_playing_season_dates/migration.sql`
- `src/modules/lmspro/routers/seasons.router.ts`
- `src/app/(app)/app/lmspro/seasons/page.tsx`
- `src/app/(app)/app/lmspro/seasons/[seasonId]/_components/SeasonOverviewTab.tsx`
- `src/modules/lmspro/components/dashboard/SeasonSummaryPanel.tsx`
- `src/modules/lmspro/components/dashboard/ClubSummaryPanel.tsx`

Documentation:

- `isodocs/docs/modules/lmspro/04-implementation-confirmations/2026-06-29-lmspro-remediation-slice-r1-a-playing-season-date-fields-and-season-admin-display-confirmation.md`

## Migration

Migration:

```text
20260629160000_add_lmspro_playing_season_dates
```

SQL summary:

- Adds nullable `playing_season_starts_at` to `lmspro.lmspro_seasons`.
- Adds nullable `playing_season_ends_at` to `lmspro.lmspro_seasons`.
- No data backfill.
- No seed/reset/db push work.

## Schema Fields Added

```text
playingSeasonStartsAt DateTime? @map("playing_season_starts_at")
playingSeasonEndsAt   DateTime? @map("playing_season_ends_at")
```

## Router / Validation Behaviour

Updated `lmspro.seasons.create` and `lmspro.seasons.update` to accept optional playing-season dates.

Server-side validation:

- Playing Season Start is optional.
- Playing Season End is optional.
- If both are set, Playing Season End must be after Playing Season Start.
- Playing Season Start must not be before the technical/admin Start Date.
- Playing Season End must not be after the technical/admin End Date.

Dashboard summary payload now includes the playing-season dates.

## CRUD Modal Behaviour

The Season CRUD modal now includes optional, clearable fields:

- Playing Season Start
- Playing Season End

Existing seasons show these as blank until manually set.

Date-only values are normalised to UTC midnight on save so a selected calendar date displays back as the same date, including during UK summer time.

Date picker values are also normalised into form state immediately on selection so preview/summary text does not show the previous UTC calendar day.

## Season Admin Page Behaviour

The Season admin overview now shows:

- technical/admin season range;
- playing-season range;
- `Not set` when either playing-season date is missing.

The edit form includes optional, clearable Playing Season Start and Playing Season End fields.

The Season admin overview save path also normalises date-only fields to UTC midnight for consistent calendar-date display.

## Progress Calculation Behaviour

Existing season progress display now uses playing-season dates only when both are set.

Behaviour:

- Missing playing-season dates: show `Playing season dates not set`.
- Before Playing Season Start: do not show `% complete`; show not-started wording.
- During playing season: show playing-days remaining and `% complete`.
- After Playing Season End: show ended wording.

`ClubSummaryPanel` was updated only because it already contained a season-progress card that used technical/admin dates. No new Club dashboard countdown widget was introduced.

## Explicit Excluded Scope

Not implemented:

- dashboard announcement automation;
- notification sending;
- new C2 Club dashboard countdown widgets;
- broader key-date architecture changes;
- season rollover changes;
- unrelated dashboard, tenant, club, team, fixture or billing behaviour;
- FUND module logic.

## Checks Run

```text
npx prisma validate
npm run db:generate
npm run type-check
npm run verify
git diff --check
```

Results:

- `npx prisma validate` passed.
- `npm run db:generate` passed.
- `npm run type-check` passed.
- `git diff --check` passed.
- `npm run verify` initially hit the known local `tsx` IPC sandbox issue, then passed on the approved rerun.

## Risks / Follow-Ups

- Browser smoke testing should confirm Season CRUD create/edit, Season detail edit, and dashboard progress states for blank, future, current and ended playing-season dates.
- Staging deployment must run the migration before authenticated staging smoke testing.
- Future announcement/countdown automation remains deferred and should be planned separately.

## Recommended Review Slice

```text
LMSPro R1-A-R1 - Playing Season Date Boundaries Review And Smoke Test
```

Review focus:

- migration applies cleanly;
- existing seasons remain blank;
- validation blocks invalid playing dates;
- Season CRUD modal and Season admin page show/edit playing dates correctly;
- progress display uses playing-season dates only when both are set;
- no announcement automation, notifications, rollover changes or unrelated behaviour were introduced.
