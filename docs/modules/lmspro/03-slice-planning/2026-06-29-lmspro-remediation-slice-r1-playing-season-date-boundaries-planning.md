# LMSPro Remediation Slice R1 - Playing Season Date Boundaries Planning

Date: 2026-06-29  
Module: LMSPro / SeasonPro  
Status: Planning  
Type: Remedial product/UX planning

## Goal

Plan support for two additional season dates:

- Playing Season Start
- Playing Season End

These define the effective playing period inside the broader technical/admin season.

## Problem

The current season has Start Date and End Date. These are technically correct as admin boundaries, but they are not always the same as the real playing period.

League admins need separate playing-season dates so the app can later support:

- countdown to the start of the playing season;
- countdown to the end of the playing season;
- `% season remaining` based on the effective playing season;
- future dashboard announcements using offsets from playing-season dates.

## Date Semantics

Technical/admin dates:

- `startDate` = admin season begins.
- `endDate` = admin season ends.

Playing-season dates:

- `playingSeasonStartsAt` = effective playing season begins.
- `playingSeasonEndsAt` = effective playing season ends.

Playing dates should sit within the technical/admin season dates.

## Data Entry Behaviour

Playing-season dates should be optional and blank until manually set.

Because only one league is currently using SeasonPro, no automatic backfill is required for the first slice.

Recommended UI placement:

- Season CRUD modal: editable fields for Playing Season Start and Playing Season End.
- Season admin page: operational display of technical season dates and playing-season dates.

The CRUD modal is the data-entry surface. The season admin page is the operational visibility surface.

## Season Admin Display

The Season admin page should show:

- Technical season: Start Date -> End Date.
- Playing season: Playing Season Start -> Playing Season End.
- If either playing date is missing: show `Not set`.

Future display behaviour:

- Before Playing Season Start: show countdown to playing season start.
- During playing season: show `% season remaining` and/or countdown to playing season end.
- After Playing Season End: show playing season ended.

## Season Progress Rule

Existing `% season remaining` should be based on playing-season dates once both are set.

It should only be visible once the playing-season start date has passed.

If playing-season dates are not set, the UI should either:

- hide playing-season progress; or
- clearly label any fallback to technical season dates.

Preferred behaviour for the first implementation:

```text
If playing-season dates are not set, hide playing-season progress and show "Playing season dates not set".
```

If the current date is before Playing Season Start, show countdown-to-start wording rather than `% complete`.

If the current date is after Playing Season End, show playing season ended rather than a live progress percentage.

## Validation Rules

Recommended validation:

- Playing Season Start is optional.
- Playing Season End is optional.
- If both are set, Playing Season Start must be before Playing Season End.
- If technical Start Date is set, Playing Season Start must not be before it.
- If technical End Date is set, Playing Season End must not be after it.

Validation should exist server-side in the season router and client-side where the existing Season CRUD forms already validate dates.

Expected user-facing validation messages:

- `Playing Season End must be after Playing Season Start`.
- `Playing Season Start must not be before the season Start Date`.
- `Playing Season End must not be after the season End Date`.

## Expected App Files

Before implementing, inspect and expect to touch:

- `prisma/schema.prisma` - add nullable LMSProSeason fields.
- `prisma/migrations/<timestamp>_add_lmspro_playing_season_dates/migration.sql` - migration only, no db push.
- `src/modules/lmspro/routers/seasons.router.ts` - create/update input, validation and dashboard summary payload.
- `src/app/(app)/app/lmspro/seasons/page.tsx` - Season CRUD modal fields and list display if useful.
- `src/app/(app)/app/lmspro/seasons/[seasonId]/_components/SeasonOverviewTab.tsx` - Season admin page edit/display.
- `src/modules/lmspro/components/dashboard/SeasonSummaryPanel.tsx` - existing season-progress calculation and display.

Optional only if needed by existing typing:

- relevant generated Prisma client output via `npm run db:generate`.

Do not touch:

- club dashboard countdown widgets;
- key-date automation;
- notification settings;
- season rollover/clone semantics beyond preserving blank playing-season dates;
- FUND module files.

## Schema Direction

Add nullable fields to `LMSProSeason`:

```text
playingSeasonStartsAt DateTime? @map("playing_season_starts_at")
playingSeasonEndsAt   DateTime? @map("playing_season_ends_at")
```

No automatic backfill.

Existing seasons should remain:

```text
playingSeasonStartsAt = null
playingSeasonEndsAt = null
```

The user will manually set the dates for the live league.

## Migration Boundary

Create a normal Prisma migration.

Do not use:

- `db:push`;
- seed commands;
- reset commands;
- manual production data updates.

The migration should only add nullable columns.

## Future Announcement Automation

Future automation may allow the league admin to create countdown announcements from offsets such as:

- 30 days before Playing Season Start;
- 7 days before Playing Season Start;
- 14 days before Playing Season End;
- final week of the playing season.

This slice should not implement announcement automation.

## Implementation Boundary

This planning slice may lead to an implementation slice covering:

- schema fields for playing-season dates;
- season CRUD modal fields;
- season admin page display;
- validation;
- season-progress calculation update.

Do not include:

- dashboard announcement automation;
- notification sending;
- C2 Club dashboard countdown widgets;
- broader key-date architecture changes;
- unrelated season rollover changes;
- FUND module logic.

## Checks For Implementation

Run:

```text
npx prisma validate
npm run db:generate
npm run type-check
npm run verify
git diff --check
```

If `npm run verify` hits the known local `tsx` IPC sandbox issue, rerun it in the approved way and record that in the confirmation.

## Implementation Confirmation

After implementation, create:

```text
04-implementation-confirmations/2026-06-29-lmspro-remediation-slice-r1-a-playing-season-date-fields-and-season-admin-display-confirmation.md
```

The confirmation should include:

- slice name and date;
- files changed;
- migration name;
- schema fields added;
- CRUD modal behaviour;
- Season admin page behaviour;
- progress calculation behaviour;
- validation rules;
- checks run and results;
- explicit excluded-scope confirmation;
- risks/follow-ups;
- recommended review slice.

## Recommended Implementation Slice

```text
LMSPro R1-A - Playing Season Date Fields And Season Admin Display
```

Scope:

- Add optional playing-season date fields.
- Show/edit them in Season CRUD.
- Display them on the Season admin page.
- Update season-progress calculation to use playing-season dates only when set.
- Keep announcement automation deferred.

## Implementation Prompt

```text
Proceed with LMSPro / SeasonPro remediation slice R1-A:
Playing Season Date Fields And Season Admin Display.

Work on:
feature/seasonpro-remediation

Use:
- isodocs/docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md
- isodocs/docs/modules/lmspro/03-slice-planning/2026-06-29-lmspro-remediation-slice-r1-playing-season-date-boundaries-planning.md
- current LMSPro Season model/router/UI conventions

Goal:
Add optional Playing Season Start and Playing Season End date boundaries to LMSPro seasons.

Implement only:
1. Nullable `playingSeasonStartsAt`.
2. Nullable `playingSeasonEndsAt`.
3. Prisma migration with nullable columns only.
4. Season create/edit router input and validation.
5. Season CRUD modal fields.
6. Season admin page display of technical and playing-season date ranges.
7. Season dashboard summary/progress logic using playing-season dates only when both are set.

Rules:
- Existing seasons remain blank until manually set.
- Do not backfill.
- Do not use db:push.
- Playing dates must sit within technical season Start Date and End Date.
- `% season remaining` uses playing dates only after Playing Season Start has passed.
- If playing dates are not set, hide progress and show `Playing season dates not set`.

Do not implement:
- dashboard announcement automation;
- notification sending;
- C2 Club dashboard countdown widgets;
- broader key-date architecture;
- season rollover changes;
- unrelated dashboard, tenant, club, team, fixture or billing behaviour;
- FUND logic.

Run:
- npx prisma validate
- npm run db:generate
- npm run type-check
- npm run verify
- git diff --check

Create implementation confirmation:
isodocs/docs/modules/lmspro/04-implementation-confirmations/2026-06-29-lmspro-remediation-slice-r1-a-playing-season-date-fields-and-season-admin-display-confirmation.md

Do not promote branches after implementation.
```
