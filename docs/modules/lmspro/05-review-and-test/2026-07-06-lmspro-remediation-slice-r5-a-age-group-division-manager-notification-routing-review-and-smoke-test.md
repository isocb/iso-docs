# LMSPro Remediation Slice R5-A - Age Group And Division Manager Notification Routing Review And Smoke Test

Date: 2026-07-06
Module: LMSPro / SeasonPro
Status: Browser smoke PASS for manager assignment UI; lower-confidence PASS for routing
Implementation confirmation: `docs/modules/lmspro/04-implementation-confirmations/2026-07-06-lmspro-remediation-slice-r5-a-age-group-division-manager-notification-routing-confirmation.md`

## Verdict

R5-A passes authenticated C1 browser smoke for the manager assignment UI.

Static verification passed. Operator browser smoke confirms Age Group and Division manager
assignment behaviour is green. Notification routing smoke is recorded as lower confidence
because the behaviour appeared correct in browser testing but still deserves a deterministic
recipient-resolution audit in the R5-B Notification Manager slice.

## Developer Checks

Commands run from the app repo:

```text
npx prisma format
npx prisma generate
npx tsc --noEmit --incremental false
npx eslint src/modules/lmspro/routers/age-groups.router.ts src/modules/lmspro/communications/notification-recipients.ts src/modules/lmspro/routers/team-variation-requests.router.ts src/server/core/routers/lmspro/freeDays.router.ts 'src/app/(app)/app/lmspro/aggs/page.tsx' 'src/app/(app)/app/lmspro/seasons/[seasonId]/_components/AgeGroupsTab.tsx' 'src/app/(app)/app/lmspro/seasons/[seasonId]/_components/DivisionsTab.tsx'
git diff --check
```

Results:

- Prisma format: pass.
- Prisma generate: pass.
- TypeScript: pass.
- Targeted ESLint: pass with warnings only.
- Whitespace/diff check: pass.

Known warning caveat: legacy Division screens still contain existing `any` and unused-helper
warnings. No blocking targeted ESLint errors remain.

## Local Migration

The R5-A migration was applied to local app `dev`:

```text
20260706120000_add_lmspro_age_group_division_managers
```

The migration:

- creates Age Group manager assignments;
- creates Division / AGG manager assignments;
- copies existing single Age Group `managerId` values into the new assignment table.

## Browser Smoke Route

Use the local dev server:

```text
http://localhost:3001
```

Port `3000` was already occupied, so this slice started a separate server on `3001`.

Suggested smoke screens:

```text
/app/lmspro/seasons
/app/lmspro/aggs
```

Use an authenticated C1 user.

## Browser Smoke Checklist

Age Group manager assignment:

- open a Season detail page;
- open the Age Groups tab;
- edit an Age Group;
- confirm the manager field is now a multi-select;
- assign two active League users;
- save;
- reopen the Age Group;
- confirm both managers remain selected;
- confirm the Age Group table shows manager names.

Result:

```text
PASS - all green.
```

Division / AGG manager assignment:

- open the Division / AGG management view;
- edit a Division;
- confirm the Division Managers multi-select is visible;
- assign one or more active League users;
- save;
- reopen the Division;
- confirm selected managers persist;
- confirm the Division table shows manager names.

Result:

```text
PASS - all green.
```

Notification routing smoke:

- create or use a team in a Division with a Division manager;
- submit a team Variation Request;
- confirm the notification targets Division managers rather than every League Admin;
- clear Division managers and leave Age Group managers assigned;
- submit a second controlled team-context notification, such as a Free Day Request;
- confirm the notification falls back to Age Group managers;
- clear scoped managers in a controlled test only;
- confirm notification fallback reaches League Admin / Owner recipients.

Result:

```text
LOWER-CONFIDENCE PASS - appeared correct in browser smoke.
```

Manual override smoke:

- configure a manual recipient override for a team-context notification;
- submit a controlled notification;
- confirm the manual recipient wins over scoped manager routing.

Result:

```text
LOWER-CONFIDENCE PASS - appeared correct in browser smoke.
```

## Review Notes

The implemented resolver order is:

```text
manual override
-> Division / AGG managers
-> Age Group managers
-> role override
-> League Admin / Owner fallback
```

Notification Manager explanatory wording was not added in this implementation pass. That is
a future refinement because the approved scope was storage, C1 assignment UI and routing.

Follow-on confidence note:

R5-B should include a deterministic recipient-resolution review or test harness that proves
the actual resolved recipient list for:

- Division manager routing;
- Age Group fallback routing;
- League Admin fallback;
- manual override priority.

## Roll-Forward Follow-Up

The next staging dummy roll-forward rehearsal should explicitly check manager assignments:

- whether Age Group assignments should copy forward;
- whether Division / AGG assignments should copy forward;
- what happens when a successor Age Group or Division is not clear;
- whether C1 should receive a review prompt before activating a new season.
