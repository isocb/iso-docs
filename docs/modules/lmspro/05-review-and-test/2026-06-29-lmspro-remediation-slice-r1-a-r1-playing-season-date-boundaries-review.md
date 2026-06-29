# LMSPro Remediation Slice R1-A-R1 - Playing Season Date Boundaries Review

Date: 2026-06-29  
Module: LMSPro / SeasonPro  
Branch: `feature/seasonpro-remediation`  
Verdict: Proceed with caveats

## Review Summary

R1-A added optional Playing Season Start and Playing Season End boundaries to LMSPro seasons.

The implementation is structurally sound and passed technical checks. During browser testing, two remedial findings were identified and addressed before review close:

1. The local/dev database initially had not applied the new migration, causing the Seasons page to display `No seasons found`.
2. Playing-season dates initially displayed one day earlier than selected in UK summer time due to DateInput local-midnight handling.

Both issues were corrected:

- pending migrations were applied to the dev database with `npx prisma migrate deploy`;
- DateInput values are now normalised to UTC midnight immediately on selection and again on save.

## Routes / Surfaces Reviewed

- `/app/lmspro/seasons`
- `/app/lmspro/seasons/[seasonId]`
- LMSPro dashboard season summary
- Existing Club summary season-progress card

## Files Reviewed

App:

- `prisma/schema.prisma`
- `prisma/migrations/20260629160000_add_lmspro_playing_season_dates/migration.sql`
- `src/modules/lmspro/routers/seasons.router.ts`
- `src/app/(app)/app/lmspro/seasons/page.tsx`
- `src/app/(app)/app/lmspro/seasons/[seasonId]/_components/SeasonOverviewTab.tsx`
- `src/modules/lmspro/components/dashboard/SeasonSummaryPanel.tsx`
- `src/modules/lmspro/components/dashboard/ClubSummaryPanel.tsx`

Docs:

- `docs/modules/lmspro/04-implementation-confirmations/2026-06-29-lmspro-remediation-slice-r1-a-playing-season-date-fields-and-season-admin-display-confirmation.md`
- `docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md`

## Migration / Database Review

Migration:

```text
20260629160000_add_lmspro_playing_season_dates
```

Confirmed:

- migration adds nullable `playing_season_starts_at`;
- migration adds nullable `playing_season_ends_at`;
- no data backfill;
- existing records remain valid.

Dev database note:

The dev database had pending migrations. `npx prisma migrate deploy` was run and applied:

- `20260629120000_add_fund_project_intake`;
- `20260629133000_add_project_intake_confirmation`;
- `20260629160000_add_lmspro_playing_season_dates`.

After migration deployment, read-only verification confirmed LMSPro seasons returned successfully with the new playing-season columns present.

## Date Display Review

Observed defect:

- User selected July 10, 2026 and April 30, 2027.
- UI displayed the previous calendar day in the playing-season summary.

Cause:

- DateInput values entered form state as local-midnight dates.
- `formatDateOnly()` intentionally reads UTC date components for persisted date-only fields.
- During UK summer time, local midnight can be represented as the previous UTC date.

Fix made during review:

- Normalise DateInput values to UTC midnight immediately on selection.
- Continue normalising on save.
- Apply the same date-only rule to technical start/end and playing start/end fields.

## Behaviour Assessment

Confirmed by implementation review:

- Playing Season Start and Playing Season End are optional.
- Existing seasons can remain blank.
- Season CRUD modal exposes both fields.
- Season admin overview exposes both fields.
- Server validation blocks dates outside the technical/admin season range.
- Progress display uses playing-season dates only when both are set.
- Missing playing-season dates show `Playing season dates not set`.
- No announcement automation was introduced.
- No notification sending was introduced.
- No season rollover changes were introduced.
- No FUND logic was introduced.

Browser/user testing:

- Initial migration-missing issue was observed and explained.
- Initial one-day-prior display issue was observed and fixed.
- Final browser re-test should confirm exact selected dates display after re-saving.

## Checks Run

```text
npx prisma validate
npm run db:generate
npm run type-check
npm run verify
git diff --check
docs git diff --check
```

Results:

- `npx prisma validate` passed.
- `npm run db:generate` passed.
- `npm run type-check` passed.
- `git diff --check` passed.
- docs `git diff --check` passed.
- `npm run verify` hit the known `tsx` IPC sandbox issue, then passed on approved rerun.

## Defects / Follow-Ups

Resolved during review:

- local/dev database migration missing;
- one-day-prior playing-season date display.

Remaining caveats:

- Staging must apply the new migration before staging smoke testing.
- Existing test values saved before the date-normalisation correction should be re-selected and re-saved.
- Dashboard announcement/countdown automation remains deferred.

## Recommendation

Proceed with caveats.

Recommended next step:

```text
Commit R1-A app and docs once final local browser re-test confirms exact playing-season dates display.
```

After commit:

```text
Align dev, then staging after deployment/migration confirmation.
```
