# LMSPro CR Input - Dynamic Age Group And Division Role Permissions Routing

Date: 2026-07-06
Module: LMSPro / SeasonPro
Source: Operator planning observation during LMSPro communications remediation
Status: CR input captured for triage and slice planning
Priority: High

## User Observation

LMSPro Age Groups and Divisions are dynamic operational structures. They may change by
season, league configuration, import, roll-forward, registration choices and administrative
refinement.

Role permissions and routing need to be reviewed in that context.

The concern is that some permissions, menu routes, dashboards, recipient cohorts or page
access rules may assume fixed/legacy Age Group or Division structures. If Age Groups and
Divisions are dynamic, permissions and routing must remain accurate when those structures
change.

## Scope Of Concern

This CR covers:

- Age Group permissions;
- Division / AGG permissions;
- route access where pages are filtered by Age Group, Division or AGG;
- dashboard component visibility where the user's role implies limited Age Group or
  Division scope;
- communications recipient cohorts based on Age Groups or Divisions;
- legacy/static role assumptions that may no longer map cleanly to live tenant roles;
- roll-forward or import scenarios that change Age Group / Division records.

## Problem Statement

If permissions are tied to static labels, legacy template roles or old route assumptions,
the app can drift from the live season configuration.

Potential symptoms include:

- a user seeing an Age Group or Division they should not see;
- a user being unable to reach a current Age Group or Division they should manage;
- communications recipient cohorts including the wrong teams or Clubs;
- route guards allowing page access but data queries returning the wrong scope;
- stale permissions after roll-forward or import;
- role labels in UI that do not reflect live tenant roles.

## Desired Policy

Age Group and Division permissions should be data-driven and tenant-aware.

Where a user's role or assignment is limited by Age Group, Division or AGG, both routing and
data queries should use the current live records rather than legacy/static assumptions.

The safe target state is:

```text
role assignment
-> current tenant/season structure
-> route access
-> data query scope
-> communications recipient cohort
```

Each step should agree with the others.

## Areas To Review

### Role Definitions

Review whether live tenant roles contain dynamic Age Group / Division scope, or whether the
system still relies on template roles or hard-coded labels.

### Route Guards

Review routes that expose Age Group, Division or AGG-specific views. Confirm route access
does not rely only on broad LMSPro access where narrower scope is intended.

### Data Queries

Review query filters so that permission scope is enforced server-side, not only in the UI.

### Communications Cohorts

Review LMSPro communications recipient cohorts for:

- Age Groups;
- Divisions / AGGs;
- Club roles linked to teams in selected groups;
- team managers linked to selected groups.

Recipient cohorts must mirror live structures and avoid legacy template roles.

### Roll-Forward And Import

Review how Age Group / Division permissions behave after:

- season roll-forward;
- new Age Group creation;
- Division/AGG restructuring;
- Club/team import;
- team continuation or registration into a new season.

## Suggested Slice Shape

Create a planning slice such as:

```text
LMSPro Remediation Slice R5 - Dynamic Age Group And Division Role Permissions Routing
```

Recommended first slice:

```text
R5-A - Audit Current Role Permission And Route Scope For Dynamic Age Groups / Divisions
```

R5-A should be read/audit-heavy before implementation. The goal is to locate every current
assumption before changing behaviour.

## Review / Audit Questions

- Which pages/routes are intended to be Age Group or Division scoped?
- Which role assignments can limit a user by Age Group, Division or AGG?
- Are those assignments stored as current record IDs, labels, role names or metadata?
- Do route guards and server queries use the same permission source?
- Do communication cohorts use the same live structures as the operational pages?
- Are any legacy/template roles still visible in recipient selection or permission setup?
- What happens to scoped permissions during season roll-forward?
- What happens when an Age Group or Division is renamed, merged, split or archived?

## Acceptance Criteria For A Future Slice

The future implementation slice should not be considered complete until:

- role permission source of truth is documented;
- dynamic Age Group / Division routing rules are documented;
- server-side data queries enforce the same scope as the UI;
- communication recipient cohorts use current tenant/season structures;
- legacy/template roles are excluded from normal live-role selection;
- roll-forward/import behaviour is reviewed;
- targeted tests or audit scripts confirm the permission model.

## Out Of Scope

This CR input does not itself request immediate code changes.

It should not be bundled into the current R4 communications UI/editor improvements unless a
specific recipient-cohort bug is isolated and deliberately pulled forward.

## Relationship To Communications R4

This CR is related to communications because recipient cohorts can be based on Age Groups
and Divisions. It is separate because the risk is broader than email:

- navigation;
- dashboard visibility;
- data access;
- team/Club administration;
- roll-forward correctness.

Keep it as a separate CR and slice route so the permission/routing review receives proper
attention.
