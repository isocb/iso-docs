# LMS-ROLE-01 SeasonPro User Authority Consumer Alignment Planning

Date: 2026-08-06

Status: **CONDITIONAL CONSUMER PLAN PREPARED; DEPENDS ON PLATFORM AUTHORITY/PROVISIONING
CONTRACT; NOT EXECUTABLE**

Accepted triage:

`docs/platform/02-triage/2026-08-06-isostack-core-platform-seasonpro-role-authority-triage.md`

Dependencies: `PLAT-ROLE-01`, `PLAT-ROLE-02`, the accepted `PLAT-ROLE-03` service contract
and the relevant `PLAT-REFINE-02` provisioning decisions.

## 1. Objective

Make SeasonPro a correct consumer of Platform identity/Core authority while retaining
tenant-owned functional module roles, scope and Club affiliation.

## 2. Bounded Consumer Contract

- consume the shared Platform provisioning/completion boundary rather than independently
  creating a second Core account lifecycle;
- keep Organisation authority clearly separate from SeasonPro roles; ordinary module-user
  workflows treat it as read-only, while the C1 Owner's deliberate Admin/additional-Owner
  request is routed through the Platform-owned authority contract;
- validate every selected ModuleRole as same-tenant, LMSPro, active and non-template;
- require a valid same-tenant Club affiliation when selected role scope requires Club;
- do not infer Core role from League/Club/Both scope or role name;
- show same-tenant users with missing/invalid module authority as `Unassigned`, with a
  repairable module-role/affiliation workflow;
- keep cross-tenant email conflict fail closed and never relink a user silently;
- revoke/refresh sessions according to the accepted module-role/affiliation policy; and
- record actor, target, module-role and affiliation changes without leaking credentials.

## 3. Acceptance

Cover P1 and tenant creation, compatible same-tenant completion, cross-tenant conflict,
League Member, Club Member, multiple module roles, invalid/inactive/template role,
missing/wrong-tenant Club, Unassigned repair and other-module preservation.

Human smoke must prove the displayed Core authority, SeasonPro roles, scope and affiliation
remain distinct and survive create/edit/reopen without silent elevation or demotion.

## 4. Non-Goals And Stop

No live repair, legacy-field deletion, card/action parity, route entitlement or impersonation
redesign is included. If provisioning requires schema/migration or compatible partial-state
rules remain undecided, stop for a revised Platform-parent plan.
