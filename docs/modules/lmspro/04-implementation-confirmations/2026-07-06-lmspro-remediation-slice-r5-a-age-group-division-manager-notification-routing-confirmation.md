# LMSPro Remediation Slice R5-A - Age Group And Division Manager Notification Routing Confirmation

Date: 2026-07-06
Module: LMSPro / SeasonPro
Status: Implemented locally on app `dev`; browser smoke PASS for assignment UI
Type: Manager assignment storage, C1 assignment UI and notification recipient routing
Planning: `docs/modules/lmspro/03-slice-planning/2026-07-06-lmspro-remediation-slice-r5-a-age-group-division-manager-notification-routing-planning.md`
CR input: `docs/modules/lmspro/01-cr-inputs/2026-07-06-lmspro-cr-dynamic-age-group-division-role-permissions-routing-input.md`

## Summary

R5-A has been implemented without creating Age Group-specific roles.

The implementation adds explicit manager assignment storage for:

- Age Groups;
- Divisions / AGGs.

It also updates C1 assignment UI and routes team-context notifications to the most specific
manager recipients available.

## Files Changed

Application files:

```text
prisma/schema.prisma
prisma/migrations/20260706120000_add_lmspro_age_group_division_managers/migration.sql
src/modules/lmspro/routers/age-groups.router.ts
src/modules/lmspro/communications/notification-recipients.ts
src/modules/lmspro/routers/team-variation-requests.router.ts
src/server/core/routers/lmspro/freeDays.router.ts
src/app/(app)/app/lmspro/seasons/[seasonId]/_components/AgeGroupsTab.tsx
src/app/(app)/app/lmspro/seasons/[seasonId]/_components/DivisionsTab.tsx
src/app/(app)/app/lmspro/aggs/page.tsx
```

Documentation files:

```text
docs/modules/lmspro/03-slice-planning/2026-07-06-lmspro-remediation-slice-r5-a-age-group-division-manager-notification-routing-planning.md
docs/modules/lmspro/04-implementation-confirmations/2026-07-06-lmspro-remediation-slice-r5-a-age-group-division-manager-notification-routing-confirmation.md
docs/modules/lmspro/05-review-and-test/2026-07-06-lmspro-remediation-slice-r5-a-age-group-division-manager-notification-routing-review-and-smoke-test.md
```

## Implementation Details

### R5-A1 - Routing Policy

The locked routing order is:

```text
1. Manual notification recipient override.
2. Division / AGG manager assignments.
3. Age Group manager assignments.
4. Notification role override.
5. League Admin / Owner fallback.
```

Manual overrides remain deliberately highest priority. Scoped manager routing only applies
when the notification has a team context.

### R5-A2 - Manager Assignment Storage

Two assignment models were added:

```text
LMSProAgeGroupManager
LMSProAgeGroupGroupManager
```

The migration creates:

```text
lmspro.lmspro_age_group_managers
lmspro.lmspro_age_group_group_managers
```

Existing `LMSProAgeGroup.managerId` values are copied into
`lmspro_age_group_managers`. The legacy `managerId` field is retained and mirrored to the
first assigned Age Group manager for compatibility.

### R5-A3 - C1 Assignment UI

The Age Group and Division management screens now expose multi-select manager controls:

- Age Groups: multiple League managers can be selected;
- Divisions / AGGs: multiple League managers can be selected;
- manager options are limited to active organisation users with league-level access shape
  (`OWNER`, `ADMIN`, LMSPro League/Both scoped roles or legacy league roles);
- tables show assigned manager names.

### R5-A4 - Notification Recipient Resolver

`notification-recipients.ts` now includes reusable team-scoped manager resolution.

The resolver checks:

```text
team
-> team Division / AGG manager assignments
-> team Age Group manager assignments
-> legacy Age Group managerId fallback
-> configured role fallback
-> League Admin / Owner fallback
```

The following notification routes now consume that resolver:

- `lmspro.variation_request.submitted`;
- `lmspro.free_day.requested`.

### R5-A5 Boundary

The planning document noted future Notification Manager wording/visibility. That was not
implemented in this pass because the approved implementation scope was limited to:

```text
storage, C1 assignment UI and notification recipient routing
```

Notification Manager explanatory wording remains a refinement candidate.

## Local Database

The new migration was applied to the local app `dev` database after `prisma migrate status`
reported it as the only pending migration.

Command used:

```text
npx prisma migrate deploy
```

Result:

```text
20260706120000_add_lmspro_age_group_division_managers applied successfully
```

## Checks Run

Developer checks:

```text
npx prisma format
npx prisma generate
npx tsc --noEmit --incremental false
npx eslint src/modules/lmspro/routers/age-groups.router.ts src/modules/lmspro/communications/notification-recipients.ts src/modules/lmspro/routers/team-variation-requests.router.ts src/server/core/routers/lmspro/freeDays.router.ts 'src/app/(app)/app/lmspro/aggs/page.tsx' 'src/app/(app)/app/lmspro/seasons/[seasonId]/_components/AgeGroupsTab.tsx' 'src/app/(app)/app/lmspro/seasons/[seasonId]/_components/DivisionsTab.tsx'
git diff --check
```

Results:

- Prisma schema formatted.
- Prisma Client generated.
- TypeScript passed.
- Targeted ESLint passed with warnings only.
- `git diff --check` passed.

Known warning caveat: the older Division screens still contain existing `any` and unused
helper warnings. Blocking quote-escaping errors in those touched files were corrected.

## Browser Smoke

Local dev server:

```text
http://localhost:3001
```

The server was started because `localhost:3000` was already in use.

Authenticated C1 browser smoke was completed by the operator.

Results:

- Age Group manager assignment: PASS / all green;
- Division / AGG manager assignment: PASS / all green;
- notification routing smoke: lower-confidence PASS;
- manual override smoke: lower-confidence PASS.

The lower-confidence routing result means the UI behaviour appeared correct, but R5-B should
add deterministic recipient-resolution evidence through Notification Manager preview, audit
output or a focused resolver test.

## Boundaries

This slice did not:

- create Age Group-specific roles;
- alter C2 Club official permissions;
- rebuild Notification Manager settings UI;
- change club email compose or announcement workflows;
- decide or implement next-season roll-forward behaviour for these assignments.

Roll-forward assignment behaviour should be included in the next staging dummy roll-forward
rehearsal.
