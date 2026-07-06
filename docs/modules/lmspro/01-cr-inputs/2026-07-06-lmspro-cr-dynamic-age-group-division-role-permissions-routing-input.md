# LMSPro CR Input - Age Group And Division Manager Assignment Notification Routing

Date: 2026-07-06
Module: LMSPro / SeasonPro
Source: Operator planning observation during LMSPro communications remediation
Status: CR input refined for slice planning
Priority: High

## Refined User Observation

The earlier concern was framed as "dynamic Age Group and Division role permissions".
The better direction is more precise:

```text
Do not solve Age Group responsibility by creating or maintaining many role variants.
```

LMSPro already has Age Groups, and Age Groups currently have a League user/manager concept.
The refined requirement is that more than one C1 League user may be responsible for an Age
Group.

Divisions / AGGs do not currently have the same link to C1 League users, but they should.
This creates a cleaner, more operational model:

```text
League users keep normal C1 roles
Age Groups and Divisions/AGGs hold explicit manager assignments
Notifications route to those assigned managers where possible
```

This is expected to be much simpler to manage than creating role-based Age Group
responsibilities, and it keeps responsibility visible in the same operational places where
Age Groups and Divisions/AGGs are managed.

## Current Implementation Signal

Initial code/schema review shows:

- `LMSProAgeGroup` currently has a single `managerId`;
- `LMSProAgeGroupGroup` (Division / AGG) does not currently have manager assignment fields;
- notification recipient helpers currently fall back to league admin / owner users unless a
  notification setting override is configured;
- communications cohorts can already select Age Groups and Divisions, but this is not the
  same as automated notification routing to responsible League users.

This CR therefore refines the target away from role proliferation and toward explicit
manager assignment data.

## Problem Statement

League operational work is naturally distributed by Age Group and sometimes by Division /
AGG.

Examples include:

- Free Day Requests;
- Variation Requests;
- Team applications;
- team registration / continuation activity;
- other team events that belong to a specific Age Group or Division / AGG.

If all these notifications go only to broad League Admins, the workload is centralised.
If this is solved by creating Age Group-specific roles, the role model becomes complex,
fragile and hard to maintain across seasons.

The safer product model is:

```text
team event
-> team Division / AGG, if present
-> assigned Division / AGG manager(s), if present
-> assigned Age Group manager(s), if present
-> configured notification override, if applicable
-> League Admin fallback
```

The precise order of notification-setting override versus manager routing should be locked
in the planning slice, but the product intent is clear: operational managers should receive
operational notifications before the system falls back to broad League Admin recipients.

## Desired Policy

### Responsibility Model

Age Group and Division / AGG responsibility should be stored as explicit assignments to
active C1 League users.

Target direction:

- one Age Group can have many responsible League users;
- one Division / AGG can have many responsible League users;
- a Division / AGG belongs to an Age Group where applicable;
- if a Division / AGG has no assigned manager, routing can fall back to its Age Group;
- if the Age Group has no assigned manager, routing can fall back to League Admins;
- assignments should be season-aware and tenant-aware.

### Avoided Model

Do not create separate roles such as:

```text
U7 Manager
U8 Manager
U9 Division 1 Manager
```

unless there is a future, deliberate reason to do so. That would make user and role
management unnecessarily complex.

### Notification Routing

Automated notification routing should be able to use operational context.

For a team-related event, the system should be able to derive:

```text
team
-> Division / AGG
-> Age Group
-> responsible manager recipients
```

Notification Manager should expose whether a notification uses:

- existing global/manual recipient override;
- Division / AGG manager routing;
- Age Group manager fallback;
- League Admin fallback.

This should make routing clear to C1 users and easier to reason about when testing.

## Scope Of Concern

This CR covers:

- Age Group manager assignment storage and UI;
- Division / AGG manager assignment storage and UI;
- support for multiple assigned League users per Age Group;
- support for multiple assigned League users per Division / AGG;
- notification recipient routing for team-context events;
- Notification Manager settings or display changes needed to explain routing;
- current-season / tenant-aware query behaviour;
- roll-forward behaviour for Age Group and Division / AGG manager assignments.

## Notification Events To Review

The planning slice should review at least:

- Free Day Requests;
- Special Free Day Applications, if applicable;
- Variation Requests;
- team applications / team registration;
- team continuation / roll-forward activity;
- team approval / placement workflows;
- any future team event that can identify a team, Age Group or Division / AGG.

## Roll-Forward And Season Behaviour

Because LMSPro is season-based, this cannot be treated as static configuration.

The future slice must decide whether manager assignments:

- copy forward to the next season;
- are reset and require review;
- copy forward only when the Age Group / Division / AGG successor is clear;
- require a roll-forward audit/checklist before activating the new season.

The preferred direction is a deliberate roll-forward rule, not accidental persistence.

## Suggested Slice Shape

Create a planning/implementation route such as:

```text
LMSPro Remediation Slice R5-A - Age Group And Division Manager Notification Routing
```

Recommended first implementation slice:

```text
R5-A - Manager Assignment Data Model And Notification Routing Plan
```

R5-A should start with a focused code review and implementation plan before changing
schema, because it touches current Age Group storage, Division / AGG storage and automated
notifications.

## Review / Audit Questions

- Where is the Age Group manager UI currently implemented?
- Does it currently support only one manager because of `managerId`?
- Which C1 League users should be selectable as Age Group / Division managers?
- Should manager assignments be stored as a join table rather than a single foreign key?
- Should Division / AGG manager assignments be direct to the Division / AGG record or a
  separate join table?
- Which notification events have enough context to resolve Team -> Division / AGG -> Age
  Group?
- Should manual notification recipient override trump manager routing, or should manager
  routing be the default unless override is explicitly enabled?
- How should the Notification Manager explain fallback behaviour?
- What should happen during season roll-forward?
- What test data is needed to prove routing works for:
  - Division manager present;
  - Division manager blank, Age Group manager present;
  - both blank, League Admin fallback;
  - multiple managers assigned.

## Acceptance Criteria For A Future Slice

The future implementation slice should not be considered complete until:

- Age Group manager assignment policy is documented;
- Division / AGG manager assignment policy is documented;
- multiple manager assignments are supported where agreed;
- automated notification routing can target Division / AGG managers;
- routing falls back to Age Group managers where Division / AGG managers are blank;
- routing falls back to League Admins where no scoped manager exists;
- Notification Manager makes the routing/fallback policy visible enough for C1 testing;
- roll-forward behaviour is documented;
- targeted tests or audit scripts confirm recipient resolution.

## Out Of Scope

This CR input does not itself request immediate code changes.

It should not be bundled into R4 communications editor/draft improvements. It is adjacent
to communications, but the data model and routing risk is broad enough to deserve its own
slice.

## Relationship To Communications R4

R4 improved communications UI, announcement email workflow, drafts, duplicate-to-draft and
Club dashboard communications scoping.

This CR is the next routing layer:

```text
When the system sends operational notifications, who should receive them?
```

The answer should be driven by Age Group / Division manager assignments, not by a growing
set of narrow role names.

## R5-B Refinement - Notification Manager Scoped Routing And Role Cleanup

After R5-A implementation, the next refinement is to make Notification Manager itself
explicitly aware of Age Group / Division manager routing.

R5-A provides the foundation:

- Age Group manager assignment storage;
- Division / AGG manager assignment storage;
- C1 assignment UI;
- team-context resolver routing Variation Request and Free Day request notifications to
  scoped managers where available.

R5-B should complete the operational model by letting C1 configure routing from the
Notification Manager rather than relying only on implicit resolver behaviour.

Desired direction:

- team-scoped notifications can use the event's team to find Division managers, then Age
  Group managers, then fallback recipients;
- Notification Manager can explicitly show and select this routing policy;
- Notification Manager can optionally route to selected Age Group managers;
- Notification Manager can optionally route to selected Division / AGG managers;
- selecting Divisions should use the managers assigned to those Divisions, not create new
  Division-specific roles;
- selecting Age Groups should use the managers assigned to those Age Groups, not create new
  Age Group-specific roles;
- the Role settings area should no longer encourage or expose Age Group-specific role
  variants for operational manager responsibility.

This matters because the manager-assignment model is cleaner than roles such as:

```text
U7 Manager
U8 Manager
Division 1 Manager
Sunday U10 Manager
```

Those responsibilities belong on the Age Group / Division management records. Roles should
remain broad permission categories; operational responsibility should be explicit data.

R5-B should therefore include a controlled cleanup plan for any legacy/template
Age Group-scoped roles:

- audit existing LMSPro role definitions;
- identify role names/templates that encode Age Group or Division responsibility;
- confirm whether any active users still hold those roles;
- migrate any real responsibility into Age Group / Division manager assignments where the
  mapping is unambiguous;
- hide, retire or remove template roles from the app so they cannot be newly assigned;
- preserve audit history so historic role usage is understandable.
