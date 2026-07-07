# LMSPro Remediation Slice R5-C - Tenant-Scoped Role Catalogue Polish Planning

Date: 2026-07-07
Module: LMSPro / SeasonPro
Related CR: `docs/modules/lmspro/01-cr-inputs/2026-07-07-lmspro-cr-tenant-scoped-role-catalogue-legacy-template-pruning-input.md`
Status: Implemented locally; browser smoke pending
Priority: High / pre-season clarity and safety

## Purpose

R5-C polishes the LMSPro role model after R5-A and R5-B moved Age Group and Division
operational responsibility into explicit manager assignment.

The aim is to make C1-facing role management and role attribution show only the real,
active, tenant-scoped roles that belong to the league:

```text
actual tenant ModuleRole records
-> LEAGUE, CLUB or BOTH scope
-> offered to C1 users
```

The slice should remove or hide legacy/template/hard-coded operational roles from normal
operator-facing lists so C1 does not see stale choices such as historic Age Group Manager
or Division Manager roles.

## Product Principle

Role choices should describe access level and app responsibility.

Operational workload ownership should be assigned through the purpose-built screens:

```text
Age Group managers -> Age Group edit UI
Division / AGG managers -> Division / AGG edit UI
```

This keeps the role model understandable and prevents the app drifting back toward a large
matrix of age/division-specific roles.

## Scope

### Included

- inventory LMSPro role sources and role selectors;
- identify actual tenant `ModuleRole` records;
- identify legacy or template role records;
- identify hard-coded role lists/enums that leak into LMSPro operator UI;
- clean role admin so it defaults to active tenant roles;
- clean user role attribution so it offers active tenant roles only;
- clean Notification Manager role override selectors;
- clean Communications cohort role selectors;
- preserve required platform/auth role behaviour;
- add or update documentation and review/test notes.

### Excluded

- changing Age Group or Division manager assignment storage;
- deleting core platform authentication roles;
- changing login, tenant membership or NextAuth behaviour;
- implementing multi-playing-day architecture;
- changing notification routing semantics already proven in R5-B.

## Current Assumption

There is only one live SeasonPro league tenant and it has not started its first season.

That gives the work more room than usual to prune confusing legacy/template role choices,
but the implementation should still start with an inventory so no active user loses their
access by accident.

## R5-C1 - Read-Only Role Inventory

Before changing code or data, produce an inventory of:

- all LMSPro `ModuleRole` records for the tenant;
- role name;
- role scope, such as `LEAGUE`, `CLUB` or `BOTH`;
- active/inactive state;
- users assigned to each role;
- component keys attached to each role;
- roles that look like legacy/template roles;
- roles that look like operational responsibility roles, such as `U10 Manager`.

Acceptance:

- inventory can be reviewed before pruning;
- any role assigned to an active user is visible in the report;
- no destructive data operation occurs in this step.

## R5-C2 - Role Source Audit

Audit where role choices come from.

Known or likely surfaces:

- C1 role admin page;
- C1 user edit / role attribution modal;
- Notification Manager role override selector;
- Communications recipient/cohort selectors;
- role router list endpoints;
- seed/default role helpers;
- any enum or hard-coded role list used for LMSPro choices.

Acceptance:

- every operator-facing LMSPro role selector has a documented source;
- selectors that already use tenant `ModuleRole` records are identified;
- selectors that merge tenant roles with hard-coded/template values are identified.

## R5-C3 - Clean Selector Policy

Implement a shared role catalogue rule for LMSPro operator-facing selectors.

Default selector rule:

```text
active tenant ModuleRole
+ correct organizationId
+ roleScope appropriate to the selector
+ not classified as legacy/template/operational responsibility
```

Selector examples:

- League user attribution can offer `LEAGUE` and `BOTH` roles;
- Club user attribution can offer `CLUB` and `BOTH` roles;
- Notification role override can offer broad active tenant roles only;
- Communications cohorts can offer broad active tenant roles only.

Acceptance:

- UI role options are no longer padded by hard-coded/template choices;
- Age Group / Division responsibility-shaped roles do not appear in normal role selectors;
- existing broad tenant roles still appear.

## R5-C4 - Role Admin UI Polish

Update C1 role admin so the default view is the live tenant role catalogue.

Possible behaviour:

- active tenant roles are shown by default;
- legacy/template roles are hidden by default;
- if retained, legacy/template roles appear only behind an explicit maintenance/archive
  affordance;
- creating new operational responsibility-shaped roles remains blocked;
- guidance points C1 users to Age Group and Division manager assignment.

Acceptance:

- the page reads as a clean live role catalogue;
- it is obvious which roles are assignable;
- old templates do not look like active league roles.

## R5-C5 - Tenant Data Cleanup

After inventory review, decide whether to:

- hard-delete unused legacy/template LMSPro role records;
- deactivate them;
- mark them as archived/legacy if the schema supports it;
- or simply hide them from operator-facing selectors.

For the current pre-season tenant, hard deletion may be acceptable if:

- no active user is assigned to the role;
- no required notification/cohort setting depends on it;
- no seeded/system code path requires it;
- the deleted role can be recreated from a controlled template if ever needed.

Acceptance:

- no active user loses necessary access;
- no live role assignment references a deleted role;
- role list clarity improves.

## R5-C6 - Documentation And Smoke

Document the final role policy in the implementation confirmation.

Browser smoke should cover:

- C1 role admin shows only current tenant roles by default;
- creating `U10 Manager` or similar remains blocked;
- user edit role attribution offers only appropriate active tenant roles;
- Notification Manager role override offers only broad active tenant roles;
- Communications cohort role selection offers only broad active tenant roles;
- Age Group / Division manager assignment still works through the manager UIs;
- existing C1 and C2 users can still load their dashboards.

Developer checks should include:

```text
npm run type-check
targeted lint for changed role/user/communication files
git diff --check
```

## Risk Assessment

### Main Risks

- accidentally removing an active user's only useful LMSPro role;
- confusing platform auth roles with LMSPro module roles;
- breaking seeded onboarding scripts by deleting template assumptions;
- hiding a role that is still used by Notification Manager or Communications;
- leaving old hard-coded values in one selector, undermining the cleanup.

### Mitigations

- run inventory first;
- treat platform/auth roles separately from LMSPro `ModuleRole` records;
- prefer hiding/deactivation over deletion until inventory is reviewed;
- test every role selector after the cleanup;
- include dashboard smoke for both C1 and C2 users.

## Acceptance Criteria

R5-C is complete when:

- C1 role management is driven by actual active tenant roles;
- user role attribution is driven by actual active tenant roles;
- Notification Manager and Communications no longer offer legacy/template role choices;
- Age Group / Division responsibility-shaped roles are not offered in normal role lists;
- necessary platform/auth behaviour remains intact;
- pre-season tenant role data is clean or clearly hidden from operators;
- browser smoke passes for role admin, user edit, Notification Manager, Communications and
  C1/C2 dashboard access;
- implementation confirmation and review/test documents are written.

## Suggested Handoff Prompt

```text
Proceed with LMSPro Remediation Slice R5-C on local app dev. Keep the work limited to
tenant-scoped LMSPro role catalogue cleanup, role selector polish and safe legacy/template
role pruning. Start with a read-only role inventory. Do not remove platform/auth roles.
Stop and report before any destructive tenant role cleanup if active users or settings
depend on the roles.
```
