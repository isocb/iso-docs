# LMSPro CR Input - Tenant-Scoped Role Catalogue And Legacy Template Pruning

Date: 2026-07-07
Module: LMSPro / SeasonPro
Source: R5-B browser smoke follow-up and operator role-management review
Status: CR input captured for planning
Priority: High / pre-season cleanup

## User Observation

R5-B correctly moved Age Group and Division operational responsibility away from role
creation and into explicit Age Group / Division manager assignment.

However, role management and role attribution still expose too much historic or template
role noise. League-scoped actual roles are valid, but historic roles, old role templates
and hard-coded role lists should not continue to appear as normal choices for C1 operators.

There is currently only one league using SeasonPro, and that league has not yet started its
first season. The risk of confusing the live operator with inaccurate or legacy roles is
therefore greater than the value of retaining every historic/template role in the active
UI.

## Core Requirement

Role management and role attribution should offer only real tenant-scoped LMSPro roles that
exist for the league.

The desired operational model is:

```text
Actual tenant ModuleRole records
-> scoped as LEAGUE, CLUB or BOTH
-> offered in role management and user attribution
```

The undesired operational model is:

```text
Hard-coded role enum/list/template values
-> offered as if they were live roles
-> mixed with actual tenant roles
```

## Clarification: System Roles Versus LMSPro Module Roles

This CR does not mean the app should remove core authentication or platform-level roles
that the system needs internally.

For example, low-level concepts such as owner/admin/member may still be needed for
authentication, tenancy and platform security.

The requested pruning applies to LMSPro operational role choices shown to C1 users, such
as:

- role management lists;
- user role assignment controls;
- notification recipient role override controls;
- communication cohort role selectors;
- any UI where C1 is choosing a league or club responsibility role.

Those surfaces should be driven by actual `ModuleRole` records for the current
organisation, not by hard-coded template lists.

## Examples

### Good Role Options

These are valid if they exist as active tenant roles:

```text
League Admin
League Secretary
Fixtures Secretary
Referee Secretary
Club Secretary
Club Primary Contact
Club User
Read Only League User
```

They should be scoped explicitly:

```text
LEAGUE
CLUB
BOTH
```

### Roles That Should Not Be Offered As Normal Choices

These should not appear as normal assignable roles unless deliberately recreated as active
tenant roles for a specific reason:

```text
U10 Manager
U11 Manager
Age Group Manager
Division Manager
AGG Coordinator
Template Club Admin
Legacy League Role
Deprecated seeded role
```

Age Group and Division responsibility should be assigned through the Age Group / Division
manager UI, not by creating or assigning role records.

## Proposed Behaviour

### Role Management

Role admin should show the active tenant role catalogue.

It should not present historic role templates as if they are current roles.

If historic roles are retained for audit or migration, they should either be:

- hidden from normal management by default;
- shown only in a clearly labelled archive/legacy section;
- or removed entirely if the tenant has no meaningful live audit dependency.

### User Attribution

User role assignment should offer active tenant roles only.

The user assignment UI should not merge:

```text
actual tenant roles
+ hard-coded defaults
+ platform role templates
+ legacy operational-responsibility roles
```

into one operator-facing list.

### Notification And Communications Role Selectors

Notification Manager and Communications recipient role selectors should only offer broad,
active tenant roles that are appropriate for cohorts.

They should not offer Age Group / Division-specific responsibility roles, because those
responsibilities are now modelled through manager assignment records.

### Seeding And Templates

Seeded role templates should not behave like live roles.

If templates remain useful for future tenant onboarding, they should be treated as template
library data rather than assignable operational roles.

For this one live pre-season tenant, it may be acceptable to prune old template records
more aggressively after a short review.

## Implications

### Benefits

- clearer role management for C1 users;
- less risk of assigning obsolete or misleading roles;
- aligns with the R5 manager-assignment model;
- reduces accidental notification routing through stale role concepts;
- makes the live tenant easier to support before first season starts;
- keeps Age Group / Division workload assignment in the correct UI.

### Risks

- code paths may still assume certain seeded role names exist;
- removing records could break users if their only access comes from a legacy role;
- hard-coded enum values may still be required for platform authentication and should not
  be removed casually;
- migration must distinguish tenant `ModuleRole` records from platform-level auth roles;
- documentation and onboarding material may still reference old templates.

### Mitigations

- first produce a read-only role inventory for the tenant;
- identify roles currently assigned to users;
- identify hard-coded/template roles appearing in UI selectors;
- keep core platform auth roles intact;
- only prune or hide LMSPro operational template/legacy roles;
- run browser smoke against role admin, user edit, Notification Manager and Communications
  cohorts after pruning.

## Open Questions

- Should legacy roles be hard-deleted, deactivated, or archived behind a separate section?
- Are any legacy/template roles currently assigned to active users?
- Which selectors still read from hard-coded lists rather than tenant `ModuleRole` records?
- Should template roles remain available to developers or onboarding scripts but hidden
  from C1?
- Should the role admin page include a maintenance-only "show legacy roles" switch?
- Does staging need a one-off data cleanup before live promotion?

## Acceptance Direction For A Future Slice

A future planning slice should:

- inventory actual tenant roles, template roles and hard-coded role lists;
- identify every UI selector that offers role choices;
- define which roles are active, archived or removed;
- preserve required platform auth behaviour;
- update role management to display only tenant-scoped actual roles by default;
- update user attribution to offer active tenant roles only;
- update Notification Manager and Communications role selectors to use the same clean
  tenant role catalogue;
- include a safe migration or data-clean step for the current pre-season tenant;
- document smoke tests for role admin, user edit, notifications and communications.

## Out Of Scope

This CR does not request immediate deletion of production data.

This CR does not remove the R5 Age Group / Division manager assignment model.

This CR does not remove internal platform roles needed for authentication, tenancy or
security. It is about pruning/hiding legacy LMSPro operational roles and templates from
operator-facing role management and assignment.
