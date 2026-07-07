# LMSPro Remediation Slice R5-B - Notification Manager Scoped Routing And Role Cleanup Review And Smoke Test

Date: 2026-07-06
Correction date: 2026-07-07
Module: LMSPro / SeasonPro
Status: Complete pass after correction and authenticated browser smoke
Implementation confirmation: `docs/modules/lmspro/04-implementation-confirmations/2026-07-06-lmspro-remediation-slice-r5-b-notification-manager-scoped-routing-and-role-cleanup-confirmation.md`

## Verdict

Initial R5-B smoke testing found a major implementation-shape error.

The incorrect interpretation was:

```text
C1 selects fixed Age Groups or Divisions inside Notification Manager.
```

That is rejected.

The corrected interpretation is:

```text
Notification Manager chooses the routing strategy.
The event/team supplies the Age Group or Division scope.
```

R5-B has been corrected locally. Authenticated C1 browser smoke was rerun and passed.

## Smoke-Test Follow-Up Corrections

Two additional issues were found during browser smoke:

- Club Team Variation Requests could remain blocked by the Team Continuation message even
  after the operator set the Team Continuation key date into the past.
- The league dashboard Free Days action card showed `0 pending applications` while Change
  Request Management showed pending Free Day approvals.

Both were corrected on local app `dev`.

Variation Request gate correction:

```text
Before:
teams.continuation card visible = variation requests blocked

After:
teams.continuation card visible + actionable + current timed closesAt = variation requests blocked
```

This avoids treating admin/league card visibility exemptions, or un-timed/no-rule component
visibility, as an active Team Continuation window.

Free Days count correction:

```text
Before:
dashboard card counted Special Free Day applications only

After:
dashboard card counts all pending Free Day requests for the current season
```

This aligns the action card with the Change Request Management page.

## Developer Checks

Commands run from the app repo after correction:

```text
npx prisma format
npx prisma generate
npx prisma migrate deploy
npx tsc --noEmit --incremental false
npm run type-check
npx eslint src/modules/lmspro/communications/notification-recipients.ts src/modules/lmspro/communications/cohort-resolver.ts src/modules/lmspro/components/communications/NotificationSettingModal.tsx src/modules/lmspro/components/communications/NotificationSettingsTab.tsx src/modules/lmspro/routers/notification-settings.router.ts src/modules/lmspro/routers/roles.router.ts src/modules/lmspro/lib/role-classification.ts 'src/app/(app)/app/lmspro/admin/roles/page.tsx' 'src/app/(app)/app/lmspro/admin/users/page.tsx'
```

Results:

- Prisma format: pass.
- Prisma generate: pass.
- Local migrations: pass.
- TypeScript: pass.
- Full npm type-check: pass after the follow-up fixes.
- Targeted ESLint: pass with warnings only.

Known warning caveat: legacy role/user/cohort surfaces still contain existing warning-level
issues. No targeted ESLint errors remain.

## Local Migrations

The R5-B migration path on local app `dev` is:

```text
20260706143000_add_lmspro_notification_manager_scoped_routing
20260707095500_add_lmspro_event_scope_notification_routing_modes
20260707100000_correct_lmspro_notification_routing_event_scope
```

The corrective migrations:

- add event-derived routing modes;
- map any locally saved bad selected-scope modes to event-derived modes;
- drop fixed selected Age Group and Division id columns.

## Browser Smoke Result

Authenticated browser smoke passed across:

- Notification Manager routing mode configuration;
- event-derived Age Group manager routing;
- event-derived Division / AGG manager routing;
- Division-then-Age-Group fallback routing;
- manual email override priority;
- broad role override filtering;
- role admin rejection of new Age Group / Division-specific operational roles;
- controlled recipient routing checks for Division managers, Age Group managers and League
  Admin / Owner fallback.

## Browser Smoke Route

Use the local dev server:

```text
http://localhost:3000
```

If port `3000` is already in use, use the alternative port reported by Next.js.

Suggested screen:

```text
/app/lmspro/communications
```

Use an authenticated C1 user.

## Notification Manager Smoke

Open Notification Manager.

For `Variation request submitted`:

- open the notification settings modal; PASS
- confirm `Recipient routing` is visible;PASS
- confirm there is no Age Group multi-select;PASS
- confirm there is no Division / AGG multi-select;PASS
- confirm routing options are event-derived, not fixed-scope selections;PASS
- select `Event team: Division managers, then Age Group managers`;PASS
- confirm explanatory copy says the scope is derived from the event team;PASS
- save;PASS
- reopen;PASS
- confirm the selected routing persists;PASS
- confirm the Notification Manager table summarises the route as event-team scoped.PASS

Event Age Group routing:

- open `Variation request submitted`;PASS
- select `Event team: Age Group managers`;PASS
- confirm explanatory copy says the Age Group comes from the event team;PASS
- save;PASS
- reopen;PASS
- confirm the route persists.PASS

Event Division routing:

- open `Variation request submitted`;PASS
- select `Event team: Division managers`; PASS
- confirm explanatory copy says the Division / AGG comes from the event team; PASS
- save;PASS
- reopen;PASS
- confirm the route persists.

Manual override priority:

- add a manual email override to a scoped notification; PASS
- save and reopen;PASS
- confirm the manual override remains visible;PASS
- record that manual override is expected to win at send time.PASS

Role override cleanup:

- open the role override selector;PASS
- confirm broad roles remain available;PASS
- confirm Age Group / Division-specific operational roles are not offered as recipient role
  overrides.PASS

Role admin boundary:

- open C1 role admin;PASS
- confirm historic roles remain visible for review/audit;PASS
- attempt to create a role such as `U10 Manager`;PASS
- confirm the app rejects it and directs C1 toward Age Group or Division manager
  assignments.PASS

## Recipient Routing Smoke

Use controlled data:

```text
Age Group U10: Manager A and Manager B PASS
Division U10 Red: Manager C PASS
Division U10 Blue: no manager
Team 1: U10 Red
Team 2: U10 Blue
Team 3: U10 with no Division
```

Expected routing: ALL PASS

- Team 1 Variation Request routes to Manager C when `Event team: Division managers, then
  Age Group managers` is selected;
- Team 2 Variation Request routes to Manager A and Manager B when `Event team: Division
  managers, then Age Group managers` is selected;
- Team 3 Variation Request routes to Manager A and Manager B when `Event team: Age Group
  managers` is selected;
- Team 1 Variation Request routes to Manager C when `Event team: Division managers` is
  selected;
- Team 2 Variation Request falls back to League Admin / Owner when `Event team: Division
  managers` is selected and the Division has no managers;
- manual email override wins over every scoped route.

## Review Notes

The corrected model is:

```text
setting chooses route
event supplies scope
```

The implementation intentionally does not delete old role records. This keeps historic
assignments and audit evidence available while moving new operational responsibility to Age
Group and Division manager assignment tables.

Recipient preview is not implemented in R5-B. A future refinement could add a preview
endpoint that resolves the exact recipient list for a sample event/team before C1 saves.
