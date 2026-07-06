# LMSPro Remediation Slice R5-A - Age Group And Division Manager Notification Routing Planning

Date: 2026-07-06
Module: LMSPro / SeasonPro
Status: Implemented locally; manager assignment browser smoke passed
Type: Notification routing and operational manager assignment
Related CR input: `docs/modules/lmspro/01-cr-inputs/2026-07-06-lmspro-cr-dynamic-age-group-division-role-permissions-routing-input.md`

## Purpose

R5-A plans the move away from Age Group-specific role proliferation and toward explicit
operational manager assignments on Age Groups and Divisions / AGGs.

The goal is to let LMSPro route operational notifications to the people responsible for
the relevant Age Group or Division / AGG, while keeping C1 role management simple.

Target concept:

```text
Team-context event
-> Division / AGG manager(s), if assigned
-> Age Group manager(s), if assigned
-> League Admin fallback
```

## Current Implementation Signals

Initial code/schema review found:

- `LMSProAgeGroup` currently has a single `managerId`;
- `LMSProAgeGroupGroup` currently has no manager assignment field;
- `User` has a `managedAgeGroups` relation through the current Age Group `managerId`;
- notification recipient helpers currently support manual override, role override and
  broad League Admin fallback;
- team-context notifications already include Age Group / Division values in some event
  templates, especially Variation Requests;
- communications cohorts can select Age Groups and Divisions, but that is not the same as
  automated routing to assigned League managers.

This means R5-A should not start by inventing new roles. It should first define and then
implement manager-assignment data and recipient resolution.

## Product Policy To Lock

### Assignment Policy

Preferred policy:

- Age Groups can have more than one assigned C1 League user;
- Divisions / AGGs can have more than one assigned C1 League user;
- assigned users must be active users in the same organisation;
- assigned users should be C1 / League-scope users, not C2 Club-only users;
- assignments are operational responsibilities, not separate permission roles.

### Routing Policy

Preferred default for team-context notifications:

```text
1. Manual recipient override, if explicitly configured for the notification.
2. Division / AGG manager recipients, if the event has a Division / AGG and managers exist.
3. Age Group manager recipients, if the event has an Age Group and managers exist.
4. Recipient role override, if deliberately configured and still relevant.
5. League Admin / Owner fallback.
```

This ordering should be confirmed before implementation. The important product point is
that manager assignment routing should distribute the operational load without relying on
many narrow role names.

### Roll-Forward Policy

R5-A must decide how manager assignments behave during season roll-forward:

- copy forward automatically;
- copy forward only when a successor Age Group / Division / AGG is clear;
- reset and require C1 review;
- copy forward but show an audit/review prompt before activating the new season.

The slice should prefer an explicit rule and test rather than accidental persistence.

## Proposed Data Model Direction

Because the refined requirement allows multiple managers, a single `managerId` field is not
enough long-term.

Recommended model direction:

```text
LMSProAgeGroupManager
- id
- organizationId
- seasonId
- ageGroupId
- userId
- createdAt / updatedAt

LMSProAgeGroupGroupManager
- id
- organizationId
- seasonId
- ageGroupGroupId
- userId
- createdAt / updatedAt
```

Alternative naming can be chosen during implementation, but the relationship should be a
join table rather than role-per-age-group records.

Migration note:

- existing `LMSProAgeGroup.managerId` values should be migrated into the new Age Group
  manager assignment table;
- `managerId` may be retained temporarily for backward compatibility or removed in a later
  tidy slice;
- Division / AGG manager assignments will be new data.

## Expected Code Surfaces

Likely schema and router surfaces:

```text
prisma/schema.prisma
src/modules/lmspro/routers/age-groups.router.ts
src/modules/lmspro/routers/age-group-groups.router.ts
src/modules/lmspro/routers/team-variation-requests.router.ts
src/modules/lmspro/routers/free-days.router.ts
src/modules/lmspro/communications/notification-recipients.ts
src/modules/lmspro/components/communications/NotificationSettingModal.tsx
```

Likely UI surfaces:

```text
src/app/(app)/app/lmspro/age-groups/page.tsx
src/app/(app)/app/lmspro/divisions/page.tsx
src/modules/lmspro/components/dashboard/TeamVariationRequestsManage.tsx
src/modules/lmspro/components/dashboard/FreeDaysManage.tsx
```

Exact file names should be confirmed during implementation; the planning point is that
both Age Group management and Division / AGG management need visible C1 assignment UI.

## R5-A Implementation Shape

R5-A should be split into controlled sub-items:

### R5-A1 - Audit And Lock Routing Policy

Confirm:

- current Age Group manager UI and router behaviour;
- current Division / AGG UI and router behaviour;
- current notification events with team context;
- current notification setting override semantics;
- final fallback order.

### R5-A2 - Manager Assignment Data Model

Add or plan join-table storage for:

- Age Group managers;
- Division / AGG managers.

Include migration from existing single `managerId` where safe.

### R5-A3 - C1 Assignment UI

Add UI so C1 can manage:

- multiple Age Group managers;
- multiple Division / AGG managers.

The UI should be list/select based and should not require creating new roles.

### R5-A4 - Notification Recipient Resolver

Add a resolver that can derive manager recipients from event context:

```text
teamId
-> team.aggId / team.ageGroupId
-> AGG managers
-> Age Group managers
-> fallback recipients
```

This should be reusable by Variation Requests, Free Day Requests and future team-context
notifications.

### R5-A5 - Notification Manager Visibility

Update Notification Manager wording/settings so C1 understands whether each notification
uses:

- manual override;
- scoped manager routing;
- role override;
- League Admin fallback.

### R5-A6 - Review/Test And Roll-Forward Note

Create review coverage for:

- Division manager present;
- Division manager blank, Age Group manager present;
- no managers, League Admin fallback;
- multiple managers;
- manual override;
- role override if retained;
- roll-forward assignment behaviour.

## Out Of Scope

R5-A should not:

- create a separate role for every Age Group or Division;
- rebuild the communications service;
- change C2 Club official permissions;
- implement unrelated dashboard redesign;
- change R4 email compose, drafts or announcement behaviour.

## Review And Test Plan

Developer checks should include:

```text
npm run type-check
npx eslint <changed LMSPro manager/routing files>
git diff --check
```

Functional review should confirm:

- existing Age Group manager assignments remain visible after migration;
- multiple managers can be assigned to one Age Group;
- multiple managers can be assigned to one Division / AGG;
- team-context notification routes can resolve the correct manager recipients;
- fallback works when manager assignments are blank;
- Notification Manager explains the selected routing policy.

Browser smoke should include a small controlled data set:

```text
Age Group A: two managers
Division A1: one manager
Division A2: no manager
Team 1: in Division A1
Team 2: in Division A2
Team 3: no Division but in Age Group A
```

Expected outcomes:

- Team 1 notification routes to Division A1 manager;
- Team 2 notification falls back to Age Group A managers;
- Team 3 notification routes to Age Group A managers;
- team with no scoped manager falls back to League Admins.

## Acceptance Criteria

R5-A is complete when:

- the role-proliferation approach is explicitly avoided;
- Age Group manager assignment policy is locked;
- Division / AGG manager assignment policy is locked;
- data model and migration path are documented;
- notification fallback order is documented;
- implementation confirmation records changed files and behaviour;
- review/test document proves manager routing and fallback with controlled examples.

## Recommended Implementation Prompt

Proceed with LMSPro Remediation Slice R5-A on local app `dev`. Keep the work limited to
Age Group / Division manager assignment storage, C1 assignment UI and notification
recipient routing. Do not create Age Group-specific roles. Stop and report if the existing
single `managerId` field or notification settings require a larger migration split before
implementation.
