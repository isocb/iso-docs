# LMSPro Remediation Slice R5-B - Notification Manager Scoped Routing And Role Cleanup Planning

Date: 2026-07-06
Module: LMSPro / SeasonPro
Status: Planned
Type: Notification Manager routing configuration and role model cleanup
Related CR input: `docs/modules/lmspro/01-cr-inputs/2026-07-06-lmspro-cr-dynamic-age-group-division-role-permissions-routing-input.md`
Preceding slice: `docs/modules/lmspro/03-slice-planning/2026-07-06-lmspro-remediation-slice-r5-a-age-group-division-manager-notification-routing-planning.md`

## Purpose

R5-A adds the storage and initial resolver foundation for Age Group and Division / AGG
manager routing.

R5-B should make that routing visible and configurable in Notification Manager, and should
cleanly remove Age Group / Division-specific role complexity from the role-management path.

The core product policy is:

```text
Roles grant broad permission.
Age Groups and Divisions hold operational responsibility.
Notifications use operational responsibility for routing.
```

## Current Position After R5-A

R5-A establishes:

- multiple Age Group manager assignments;
- multiple Division / AGG manager assignments;
- C1 assignment UI on Age Groups and Divisions;
- team-scoped recipient resolution for Variation Request and Free Day request notifications;
- fallback order from Division managers to Age Group managers to League Admins.

R5-A deliberately does not:

- add Notification Manager routing controls;
- add Notification Manager wording for scoped manager routing;
- remove or retire legacy/template Age Group-specific roles;
- solve all future team-context notification events.

R5-B is the planned follow-on slice for those remaining pieces.

## Product Policy To Lock

### Notification Routing Modes

Notification Manager should allow C1 to see and choose the recipient routing mode for each
notification where that is safe.

Recommended modes:

```text
Manual email override
Team scoped managers
Selected Division managers
Selected Age Group managers
Selected role
League Admin fallback
```

### Recommended Default

For team-context operational notifications, the recommended default should be:

```text
1. manual override, if set
2. event team's Division / AGG manager(s), if present
3. event team's Age Group manager(s), if present
4. selected role override, if set and manager routing is not available
5. League Admin / Owner fallback
```

This keeps the existing manual override as an explicit top-level override while allowing
team-context events to route to the people responsible for the work.

### Explicit Scope Selection

For some notifications, C1 may want to route to managers of selected operational scopes
rather than derive scope from a specific team.

Notification Manager should support:

- selected Age Group manager routing;
- selected Division / AGG manager routing;
- multi-select of Age Groups;
- multi-select of Divisions / AGGs;
- display of which managers will receive the notification based on the selected scope.

Selecting a Division should route to that Division's assigned managers. If a selected
Division has no managers, the fallback should be configurable but should usually be:

```text
selected Division
-> parent Age Group managers
-> League Admin fallback
```

Selecting an Age Group should route to that Age Group's assigned managers. If the Age Group
has no managers, the fallback should be:

```text
selected Age Group
-> League Admin fallback
```

## Role Model Cleanup Policy

R5-B should remove the need for role names that encode an Age Group or Division.

Roles to avoid:

```text
U7 Manager
U8 Manager
U9 Division 1 Manager
Saturday U10 Manager
Sunday U11 Division Secretary
```

Reason:

- these roles become difficult to manage across seasons;
- they duplicate data that already belongs to Age Groups and Divisions;
- they make dynamic structures such as multi-day leagues much harder;
- they blur the difference between permission and responsibility.

Target state:

- LMSPro roles remain broad permission categories;
- Age Group manager responsibility is stored on Age Group assignment records;
- Division manager responsibility is stored on Division / AGG assignment records;
- Notification Manager uses those assignment records for recipient routing.

## R5-B Implementation Shape

### R5-B1 - Audit Existing Notification Settings

Review:

- `LMSProNotificationSetting` schema;
- current Notification Manager UI;
- current manual recipient override behaviour;
- current role override behaviour;
- which notification events have team context;
- which notification events can be scoped by selected Age Groups or Divisions.

Output:

- final list of supported routing modes;
- migration decision for storing routing mode and selected scopes.

### R5-B2 - Notification Setting Data Model

Add storage for routing policy where needed.

Likely options:

```text
recipientRoutingMode
recipientScopeConfig JSON
```

or specific fields such as:

```text
recipientRoutingMode
recipientAgeGroupIds
recipientAgeGroupGroupIds
recipientFallbackMode
```

The implementation should choose the smallest durable shape that:

- supports team-derived manager routing;
- supports selected Age Group manager routing;
- supports selected Division / AGG manager routing;
- preserves manual recipient override;
- preserves selected role override where still useful;
- remains understandable in Notification Manager.

### R5-B3 - Notification Manager UI

Notification Manager should show routing controls for each notification.

Expected UI behaviour:

- show whether the event supports team-derived manager routing;
- show routing mode selector;
- when `Team scoped managers` is selected, explain the fallback path;
- when `Selected Age Group managers` is selected, show Age Group multi-select;
- when `Selected Division managers` is selected, show Division / AGG multi-select;
- show a preview/count of resolved recipients where practical;
- keep manual email override available and clearly labelled as an override;
- keep role override available only for broad roles, not Age Group-specific role variants.

### R5-B4 - Recipient Resolver Extension

Extend the R5-A resolver so it can resolve recipients from:

```text
event team context
selected Age Group ids
selected Division / AGG ids
manual override
selected broad role
League Admin fallback
```

Resolver acceptance scenarios:

- team has Division managers: route to Division managers;
- team has no Division manager but has Age Group managers: route to Age Group managers;
- selected Division has managers: route to selected Division managers;
- selected Division has no managers but parent Age Group has managers: fall back to parent Age Group managers;
- selected Age Group has managers: route to selected Age Group managers;
- no scoped managers: route to League Admin / Owner fallback;
- manual override: manual emails win.

### R5-B5 - Apply To Team-Scoped Notifications

Review and update team-context notifications, including at least:

- Variation Requests;
- Free Day Requests;
- Special Free Day Applications, if they have team context;
- Team registration / application events that can identify Age Group or Division;
- Team continuation / roll-forward events where team or Age Group is known;
- future team placement / allocation notifications.

Events without team, Age Group or Division context should not pretend to be scoped. They can
still use selected Age Group / Division scope if C1 has configured that explicitly in
Notification Manager.

### R5-B6 - Role Cleanup Audit

Audit LMSPro roles and role templates for Age Group / Division-specific patterns.

Review:

```text
ModuleRole records for LMSPro
legacy User.lmsproLeagueRoles values
role assignment UI
seed/template role creation
role filtering in communications recipient cohorts
```

Identify:

- roles that are broad permission roles and should remain;
- roles that encode operational responsibility and should move to manager assignments;
- roles that are inactive templates and should be removed or hidden;
- roles still assigned to users and requiring migration review.

### R5-B7 - Role Cleanup Implementation

Clean removal should be cautious.

Recommended order:

1. Stop showing Age Group / Division-specific roles as assignable options.
2. Stop using those roles for recipient routing.
3. Migrate unambiguous responsibility from roles to manager assignments.
4. Produce an audit list for ambiguous role assignments.
5. Retire or remove template roles once safe.
6. Preserve audit history and avoid breaking historic records.

This should not remove broad roles such as League Admin, League Secretary, Club Secretary,
Safeguarding, Treasurer or other genuine permission groups.

## Out Of Scope

R5-B should not:

- rebuild the full communications composer;
- change club dashboard communications tabs;
- introduce multi-playing-day architecture;
- change C2 Club official lifecycle policy;
- remove audit history;
- delete broad LMSPro permission roles;
- implement roll-forward copying of manager assignments unless specifically included after
  audit.

## Review And Test Plan

Developer checks should include:

```text
npx prisma format
npx prisma generate
npx tsc --noEmit --incremental false
npx eslint <changed notification manager / routing / role files>
git diff --check
```

Browser smoke should use controlled data:

```text
Age Group U10: Manager A and Manager B
Division U10 Red: Manager C
Division U10 Blue: no manager
Team 1: U10 Red
Team 2: U10 Blue
Team 3: U10 with no Division
```

Expected routing:

- Team 1 Variation Request routes to Manager C;
- Team 2 Variation Request routes to Manager A and Manager B;
- Team 3 Free Day Request routes to Manager A and Manager B;
- selected Division U10 Red notification preview resolves Manager C;
- selected Division U10 Blue notification preview falls back to Manager A and Manager B;
- selected Age Group U10 notification preview resolves Manager A and Manager B;
- scoped notification with no managers falls back to League Admin / Owner;
- manual override wins over scoped routing.

Role cleanup smoke:

- Age Group-specific roles no longer appear as assignable role options;
- broad roles remain assignable;
- communications recipient role cohorts do not show retired template roles;
- users with broad roles are unaffected;
- any migrated manager responsibility appears in Age Group / Division assignment UI.

## Acceptance Criteria

R5-B is complete when:

- Notification Manager exposes scoped manager routing clearly;
- C1 can select team-derived manager routing where supported;
- C1 can select specific Age Groups for manager routing;
- C1 can select specific Divisions / AGGs for manager routing;
- recipient preview or review evidence proves the selected routing;
- Variation Request and Free Day Request routing still work after settings are applied;
- other team-scoped notification events are reviewed and updated or explicitly deferred;
- Age Group / Division-specific roles are no longer presented as the correct way to model
  operational responsibility;
- any role cleanup migration/audit is documented;
- implementation confirmation and 05 review/test docs are produced.

## Recommended Implementation Prompt

Proceed with LMSPro Remediation Slice R5-B on local app `dev`. Keep the work limited to
Notification Manager scoped manager routing, team-scoped notification recipient resolution
and clean removal/retirement of Age Group / Division-specific role complexity. Do not change
multi-playing-day architecture, club lifecycle policy or unrelated communications compose
behaviour. Stop and report if role cleanup reveals active ambiguous role assignments that
cannot be safely mapped to Age Group or Division manager assignments.
