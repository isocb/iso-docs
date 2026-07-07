# LMSPro Remediation Slice R5-B - Notification Manager Scoped Routing And Role Cleanup Confirmation

Date: 2026-07-06
Correction date: 2026-07-07
Module: LMSPro / SeasonPro
Status: Corrected locally on app `dev`; authenticated browser smoke rerun pending
Type: Notification Manager scoped routing configuration and role model cleanup
Planning: `docs/modules/lmspro/03-slice-planning/2026-07-06-lmspro-remediation-slice-r5-b-notification-manager-scoped-routing-and-role-cleanup-planning.md`
CR input: `docs/modules/lmspro/01-cr-inputs/2026-07-06-lmspro-cr-dynamic-age-group-division-role-permissions-routing-input.md`

## Summary

R5-B makes the R5-A manager-routing foundation visible and configurable in Notification
Manager.

The implementation adds routing policy storage to notification settings, extends the
recipient resolver for event-derived Age Group and Division / AGG manager scope, and
prevents Age Group / Division-specific roles from remaining the normal way to model
operational responsibility.

Initial smoke testing found a bad implementation shape: fixed Age Group and Division
multi-selects were added to Notification Manager. That was rejected because team-originated
notifications must derive scope from the event team. R5-B has now been corrected to store
only routing mode.

## Files Changed

Application files:

```text
prisma/schema.prisma
prisma/migrations/20260706143000_add_lmspro_notification_manager_scoped_routing/migration.sql
prisma/migrations/20260707095500_add_lmspro_event_scope_notification_routing_modes/migration.sql
prisma/migrations/20260707100000_correct_lmspro_notification_routing_event_scope/migration.sql
src/modules/lmspro/communications/notification-recipients.ts
src/modules/lmspro/communications/cohort-resolver.ts
src/modules/lmspro/components/communications/NotificationSettingModal.tsx
src/modules/lmspro/components/communications/NotificationSettingsTab.tsx
src/modules/lmspro/routers/notification-settings.router.ts
src/modules/lmspro/routers/roles.router.ts
src/modules/lmspro/lib/role-classification.ts
src/app/(app)/app/lmspro/admin/roles/page.tsx
src/app/(app)/app/lmspro/admin/users/page.tsx
src/app/(app)/app/lmspro/club/teams/page.tsx
src/modules/lmspro/components/dashboard/SpecialFreeDaysCard.tsx
src/server/core/routers/lmspro/freeDays.router.ts
```

Documentation files:

```text
docs/modules/lmspro/03-slice-planning/2026-07-06-lmspro-remediation-slice-r5-b-notification-manager-scoped-routing-and-role-cleanup-planning.md
docs/modules/lmspro/04-implementation-confirmations/2026-07-06-lmspro-remediation-slice-r5-b-notification-manager-scoped-routing-and-role-cleanup-confirmation.md
docs/modules/lmspro/05-review-and-test/2026-07-06-lmspro-remediation-slice-r5-b-notification-manager-scoped-routing-and-role-cleanup-review-and-smoke-test.md
```

## Implementation Details

### R5-B1 - Notification Setting Storage

`LmsproNotificationSetting` now stores:

```text
recipientRoutingMode
```

Supported routing modes are:

```text
DEFAULT
TEAM_SCOPED_MANAGERS
EVENT_AGE_GROUP_MANAGERS
EVENT_DIVISION_MANAGERS
ROLE_OVERRIDE
LEAGUE_ADMINS
```

Existing settings default to `DEFAULT`, preserving previous behaviour until C1 changes a
notification route.

### R5-B2 - Notification Manager UI

The Notification Manager modal now includes:

- recipient routing mode selector;
- event team Division manager routing option where the notification has team context;
- event team Age Group manager routing option where the notification has team context;
- event team Division-then-Age-Group fallback routing option where the notification has team
  context;
- explanatory copy that says scope is derived from the event team;
- broad-role recipient override wording;
- filtered broad role options.

The Notification Manager table now summarises the configured routing mode.

### R5-B3 - Recipient Resolver

The resolver now supports:

```text
manual email override
team-derived Division / Age Group managers
event team Age Group managers
event team Division / AGG managers
broad role override
League Admin / Owner fallback
```

Manual email override remains the highest priority.

Team-scoped routing derives scope from the event team:

```text
event team
-> team Division / AGG managers
-> team Age Group managers
-> League Admin / Owner fallback
```

Event Age Group manager routing derives the Age Group from the event team:

```text
event team
-> team Age Group managers
-> League Admin / Owner fallback
```

Event Division manager routing derives the Division / AGG from the event team:

```text
event team
-> team Division / AGG managers
-> League Admin / Owner fallback
```

### R5-B4 - Role Cleanup Boundary

A shared role classifier now identifies operational responsibility-shaped roles, such as:

```text
U10 Manager
Age Group Manager
Division Secretary
AGG Coordinator
```

Those roles are no longer exposed through normal assignment, cohort or Notification Manager
role selectors.

The C1 role admin page can still see historic roles so they can be reviewed. No historic
roles or audit history were deleted.

New role creation and template cloning now reject age/division-specific operational role
names and direct C1 users to Age Group or Division manager assignments instead.

### R5-B5 - Smoke-Test Follow-Up Fixes

Two minor smoke-test issues were found after the main R5-B correction:

1. Club Team Variation Requests could remain gated with:

   ```text
   Team continuation is currently in progress. Variation requests will be available once the team continuation window has closed.
   ```

   Cause: the club teams page used `teams.continuation` component visibility as a proxy for
   the Team Continuation active window. That was too broad because admin/league exemptions
   can keep the card visible before or after the window, and a component with no active
   timing rule should not gate variation requests.

   Fix: the gate now only treats Team Continuation as active when the component visibility
   result is visible, actionable and has a current timed `closesAt` value.

2. The league dashboard Free Days action card showed `0 pending applications` while the
   Change Request Management page showed pending Free Day approvals.

   Cause: the dashboard card was counting only Special Free Day applications, while the
   page includes standard Free Day requests.

   Fix: the card now uses `freeDays.getPendingCount`, which counts all pending Free Day
   requests for the current season.

## Local Database

The new migration was applied to the local app `dev` database.

Command used:

```text
npx prisma migrate deploy
```

Result:

```text
20260706143000_add_lmspro_notification_manager_scoped_routing applied successfully
20260707095500_add_lmspro_event_scope_notification_routing_modes applied successfully
20260707100000_correct_lmspro_notification_routing_event_scope applied successfully
```

## Checks Run

Developer checks:

```text
npx prisma format
npx prisma generate
npx tsc --noEmit --incremental false
npm run type-check
npx eslint src/modules/lmspro/communications/notification-recipients.ts src/modules/lmspro/communications/cohort-resolver.ts src/modules/lmspro/components/communications/NotificationSettingModal.tsx src/modules/lmspro/components/communications/NotificationSettingsTab.tsx src/modules/lmspro/routers/notification-settings.router.ts src/modules/lmspro/routers/roles.router.ts src/modules/lmspro/lib/role-classification.ts 'src/app/(app)/app/lmspro/admin/roles/page.tsx' 'src/app/(app)/app/lmspro/admin/users/page.tsx'
git diff --check
```

Results:

- Prisma schema formatted.
- Prisma Client generated.
- TypeScript passed.
- Full npm type-check passed after smoke-test follow-up fixes.
- Targeted ESLint passed with warnings only.
- `git diff --check` passed.

Known warning caveat: older role, user and cohort files still contain existing warnings for
`any`, unused helpers and legacy UI code. No blocking targeted ESLint errors remain.

## Browser Smoke Status

Authenticated browser smoke is pending.

Recommended route:

```text
/app/lmspro/communications
```

Primary smoke target:

```text
Notification Manager
```

## Boundaries

This slice did not:

- delete historic ModuleRole records;
- migrate active users from old operational roles to manager assignments;
- implement multi-playing-day architecture;
- change announcement or compose email workflows;
- add a deterministic recipient preview endpoint;
- change club-facing approval/rejection email recipients except where an explicit setting
  is configured.

Recipient preview remains a good later refinement because it would let C1 see the exact
resolved email list before saving a scoped route.
