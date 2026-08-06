# IsoStack Core Platform And SeasonPro Role-Authority Clarification And Remediation CR

Date: 2026-08-04

Owning lane: IsoStack Platform, with a bounded SeasonPro / LMSPro consumer outcome

Status: **TRIAGED 2026-08-06; MANDATORY PROJECT AFTER EMAIL F3; BOUNDED PLANS PREPARED;
NO APPLICATION OR DATA IMPLEMENTATION AUTHORITY**

Application source reviewed:

```text
Original CR baseline: cc4b4dc8332f0bdc994c7c2609d2ece873a74087
Triage source recheck: 72c02d92bf7222793f70b24a1d13e541eb215efa
```

IsoDocs parent reviewed:

```text
94b3e6e
```

Related registered work:

- `PLAT-REFINE-02` — Unified Tenant-User Provisioning And Account-Status Contract;
- `PLAT-REFINE-03` — Shared Module Route Entitlement Guard And Access-Denied Contract;
- `PLAT-REFINE-04` — Impersonation Effective-Principal And Tenant-View Contract;
- `LMS-W-USERS-01` — LMSPro user provisioning, visibility and repair; and
- the tenant-scoped LMSPro role-catalogue and legacy-template-pruning CR input.

Controlled outcome records:

- [`Role Authority triage`](../02-triage/2026-08-06-isostack-core-platform-seasonpro-role-authority-triage.md);
- [`PLAT-ROLE-01 authority inventory and canonical matrix`](../03-slice-planning/2026-08-06-isostack-platform-plat-role-01-authority-inventory-and-canonical-matrix-planning.md);
- [`PLAT-ROLE-02 Core-role mutation containment`](../03-slice-planning/2026-08-06-isostack-platform-plat-role-02-core-role-mutation-containment-planning.md);
- [`PLAT-ROLE-03 canonical Core authority service and owner safety`](../03-slice-planning/2026-08-06-isostack-platform-plat-role-03-canonical-core-authority-service-and-owner-safety-planning.md);
- [`LMS-ROLE-01 SeasonPro user-authority consumer alignment`](../03-slice-planning/2026-08-06-isostack-platform-lms-role-01-seasonpro-user-authority-consumer-alignment-planning.md); and
- [`LMS-ROLE-02 SeasonPro access parity and read-only enforcement`](../03-slice-planning/2026-08-06-isostack-platform-lms-role-02-seasonpro-access-parity-and-read-only-enforcement-planning.md).

## 1. Human Introduction — What This CR Is About

IsoStack currently describes a user in more than one way. Those descriptions serve different
purposes, but they are not explained consistently and some parts of the application do not
apply them consistently.

The first description is the person's **IsoStack Core tenant role**. Every ordinary tenant
user has exactly one of three values:

```text
OWNER
ADMIN
MEMBER
```

This is the person's organisation-wide authority. It is not their SeasonPro job title.
Changing it can affect user administration, tenant settings, billing, imports, security
functions and other enabled modules as well as SeasonPro.

The second description is the person's **SeasonPro module role or roles**. Examples include
League Administrator, League Secretary, Club Secretary and other roles deliberately created
for the tenant. These roles carry component permissions which determine the ordinary cards,
screens and workflows presented inside SeasonPro. Each role is scoped as `LEAGUE`, `CLUB` or
`BOTH` and may be read-only.

For a Club user there is a third important fact: **which Club the person is affiliated with**.
Club affiliation is separate from the role. A role can say what a Club user may do; the
affiliation says which Club's information they may do it to.

Seasonal cards then have a further overlay. Key Dates and Visibility Rules determine whether
a role-authorised card is open, upcoming, closed or exempt at the current point in the season.
A time gate should not grant underlying authority; it should only control when an already
authorised capability is presented or actionable.

P1 Platform authority is separate again. A `PlatformAdmin` record gives an authorised
Platform operator cross-tenant support and administration capability. P1 is not a fourth
value in the three-value Core tenant-role enum.

In plain English, the intended sequence is:

```text
Does the organisation have the module?
-> Is the user a valid member of that organisation?
-> What is the user's Core tenant authority?
-> Which SeasonPro roles and component permissions have been assigned?
-> Is the user League-scoped, Club-scoped or both?
-> If Club-scoped, which Club are they affiliated with?
-> Is the seasonal card currently available under its Key Date rules?
-> Does the server independently permit the requested read or change?
```

The card and the operation behind it must agree. Showing a card which then refuses its normal
operation is misleading. Allowing an operation which the user's visible role does not explain
is equally unsafe.

## 2. Proposed Business Vocabulary And Intention

The following is the understandable operating model confirmed as the triage baseline. It
records the control owner's stated expectation without pretending that every detailed
authority decision required by `PLAT-ROLE-03` has already been accepted.

| Person | Proposed Core authority | Proposed SeasonPro authority |
| --- | --- | --- |
| P1 Platform operator | Separate `PlatformAdmin` authority | Controlled Platform support/administration; not an ordinary tenant persona |
| C1 tenant owner | `OWNER` | An appropriate `LEAGUE` SeasonPro role, normally League Administrator |
| Additional C1 tenant administrator | `ADMIN` | An appropriate `LEAGUE` or `BOTH` SeasonPro role |
| League worker without tenant-administration responsibility | `MEMBER` | A deliberately bounded `LEAGUE` role |
| C2 Club user | `MEMBER` | A `CLUB` or appropriate `BOTH` role plus the correct Club affiliation |
| Unassigned user | Normally `MEMBER` | No valid module role; visible and repairable through the controlled unassigned-user outcome |

The intended principles are:

1. The actual tenant owner is a Core `OWNER`.
2. An ordinary C2 Club user is normally a Core `MEMBER`.
3. Not every League user is automatically a Core Owner or Admin. A limited League worker may
   remain a Member while receiving only the SeasonPro capabilities required for their job.
4. Core `ADMIN` is for delegated organisation-wide administration, not simply a higher
   SeasonPro job title.
5. A Core role must not be inferred only from a SeasonPro role name or from whether the user
   sees a League dashboard.
6. A SeasonPro role must not silently grant billing, tenant deletion, cross-module or other
   Core Platform authority.
7. Core Owner/Admin status should not silently grant every module capability. An entitled
   tenant owner should instead receive an explicit, auditable default module-administrator
   role when the module is enabled or provisioned.
8. The same effective permissions must govern card visibility, direct navigation, API reads
   and mutations.
9. Read-only must be enforced by the server as well as represented in the UI.
10. P1 support access and impersonation must preserve the real Platform actor while applying
    the selected tenant user's effective organisation, Core role, module roles, scope and
    affiliations consistently.

## 3. Why The Current Language Is Ambiguous

The original IsoStack glossary defines:

```text
C1 = Client Super Admin = OWNER
C2 = Client Admin       = ADMIN
C3 = Client User        = MEMBER
```

Recent SeasonPro lifecycle records instead use:

```text
C1 = League / tenant operator
C2 = Club user
```

Older SeasonPro code comments retain a third interpretation in which C1 is a senior League
official, C2 is a specialist League official and C3 is a Club official.

Consequently, the label `C2` can currently mean either a Core tenant Administrator or a
SeasonPro Club user who is normally a Core Member. `C1` can mean a genuine Core Owner or any
user who has been given sufficiently broad League component permissions.

This CR proposes that lifecycle documents and operator-facing guidance stop using a C-number
by itself. Where a C-number remains useful, it should be qualified, for example:

```text
C1 Tenant Owner
C1 League User
C2 Club User
Core OWNER
Core ADMIN
Core MEMBER
```

The canonical security contract should use the actual Core role, module role, scope and
affiliation rather than relying on the informal C-number.

## 4. Confirmed Current Model

The static source review confirms four separate authority or presentation layers.

### 4.1 Core tenant authority

`User.role` is one of `OWNER`, `ADMIN` or `MEMBER`. A separate `PlatformAdmin` relation records
P1 authority. Invitations also carry a Core role.

Core authority is already used for tenant-wide functions. Examples include:

- Owner/Admin access to tenant user administration and many settings;
- Owner-only role changes through the Core user router;
- Owner-only imports and selected high-consequence operations;
- Owner/Admin billing-gate presentation; and
- Owner or P1 Danger Gate bypass, while Admin/Member require the configured module grant.

### 4.2 SeasonPro module authority

`User.lmsproRoleIds[]` points to active `ModuleRole` records. Each role supplies:

- a tenant/module role name and description;
- `LEAGUE`, `CLUB` or `BOTH` scope;
- a set of component keys;
- active/default/template metadata; and
- an optional read-only flag.

The effective component resolver normally collects the user's active module roles, combines
their component keys, applies component overrides and filters them by page context. Without a
valid SeasonPro role, the normal component list is empty and the landing page presents the
handled `No LMSPro Access` outcome.

### 4.3 Club affiliation and operational assignment

`User.lmsproClubId`, current-season Club-official membership and related assignment records
constrain the data context. They are not substitutes for Core or module roles. Age Group and
Division operational responsibilities must remain explicit assignments rather than being
recreated as misleading global role names.

### 4.4 Seasonal visibility

Visibility Rules link component definitions to Key Dates and may exempt named module roles.
The intended evaluation is role grant first, time gate second and server action authority
last. No time rule should expand tenant, Club or data scope.

## 5. Confirmed Current Inconsistencies

### 5.1 SeasonPro creation silently assigns Core Member

The C1 SeasonPro User Management create form does not present the Core role. It silently sets
new users to `MEMBER`, including users who are assigned a League-scoped default module role.

This is safe for ordinary Club users but can create a League user who appears operationally
to be C1 while lacking the Core authority expected by some C1 administration functions.

### 5.2 The Core-role control is conditional and easily misunderstood

On edit, the SeasonPro form labels the Core field `Platform Role` and displays it only when
the signed-in session has the actual Core role `OWNER`. A user described operationally as a
C1 League Administrator may therefore not see it if their underlying Core role is `ADMIN` or
`MEMBER`.

The separate P1 Client Users screen presents Member/Admin/Owner directly. This explains why
the control can appear available to the Platform owner while seeming absent to a tenant user.
At the reviewed source baseline, a genuine direct-login Core `OWNER` should see the field on
edit, but not during creation. If a person believed to be the tenant owner does not see it,
their effective Core role, direct-versus-impersonated session and deployed version require
verification rather than assumption.

### 5.3 Card and server checks do not use one consistent authority path

Ordinary dashboard cards are primarily derived from module-role component keys. Several
Administration cards are instead shown directly to Core `OWNER` or `ADMIN` users.

The shared `hasComponentAccess` helper currently gives P1 and Core Owner/Admin a broad bypass,
but the component-list resolver still requires assigned module roles to return ordinary
cards. Some routers use component permission; others still require Core Owner/Admin directly.

This can produce either mismatch:

- a role-authorised card is visible but its operation is refused by a separate Core check; or
- a Core Owner/Admin is permitted by a direct operation but receives incomplete or
  unexplained module presentation.

### 5.4 Core-role mutation is not consistently protected

The Core user router restricts role changes to Core `OWNER`. The SeasonPro user-update input
also accepts `role` and writes it after a broader same-tenant user-management check. That
broader check can admit Core Admins and users classified as C1 through module component keys.

The browser hiding a Core-role field is not a security boundary. The SeasonPro mutation must
not be capable of assigning `OWNER` or `ADMIN` unless the same explicit, server-enforced Core
authority and safety rules have passed. This is a security-relevant finding requiring triage;
this CR does not assert that it has been exploited.

### 5.5 Legacy compatibility obscures the current contract

Deprecated League and Club role fields, old C1/C2/C3 helpers and current UUID-based
`ModuleRole` records coexist. Some fallback behaviour is still required for live continuity,
but comments and selectors can make a legacy classification appear authoritative when it is
not.

### 5.6 Provisioning remains split

The previously recorded `PLAT-REFINE-02` / `LMS-W-USERS-01` finding remains relevant. P1 and
C1 creation use different account lifecycles, and a P1-created Core account may have no valid
SeasonPro role or repairable SeasonPro scope. Role clarification must be incorporated into the
shared provisioning contract rather than corrected independently in multiple UIs.

## 6. Why This Matters Beyond SeasonPro

`User.role` belongs to the shared Platform user, not to LMSPro. A change made from a
SeasonPro-labelled screen can therefore change authority over the entire organisation and
other enabled products.

The wider IsoStack contract should remain:

```text
Core Platform
  owns identity, tenant membership, OWNER/ADMIN/MEMBER,
  account status, sessions, audit, entitlement and P1 authority

Each module
  owns its business roles, component/action grants, scope,
  affiliation/assignment and module-specific read-only behaviour
```

This has the following cross-module implications:

1. A Core role change must be performed through one shared Platform service and audit
   contract, even when initiated from a module-aware user screen.
2. Modules may supply requested module roles and affiliations, but must not independently
   redefine or elevate Core authority.
3. Product/module entitlement must remain separate from individual module-role assignment.
4. Every module should use the same effective-principal contract for direct login and P1
   impersonation.
5. Component visibility is not sufficient authorisation. Every server read and mutation must
   enforce the matching tenant, entitlement, role/action and data-scope rules.
6. A Platform solution should support current and future module role arrays without embedding
   SeasonPro-specific C1/C2 language into Core authentication.
7. Removal of legacy LMSPro role fields must not be attempted until their remaining writers,
   consumers and live assignments have been inventoried.
8. Session revocation or refresh after Core or module-role changes must be predictable across
   every authentication method and module.

## 7. Requested Combined Outcome

The combined Platform-parent and SeasonPro-consumer remediation should deliver:

1. one canonical terminology and authority matrix covering P1, Core roles, module roles,
   scopes, affiliations, read-only behaviour and time gates;
2. one shared, transactional and audited service for tenant-user creation, compatible
   same-tenant completion and Core-role changes;
3. an explicitly authorised Core-role management surface for the tenant owner, with wording
   that explains the organisation-wide consequences;
4. explicit SeasonPro module-role and Club-affiliation controls which do not imply Core
   elevation;
5. a visible, repairable `Unassigned` state for users without valid module authority;
6. consistent card, route, read and mutation checks using the same effective principal;
7. removal of unsafe Core-role mutation paths from module-specific procedures;
8. consistent server enforcement of read-only module roles;
9. session invalidation/refresh after authority changes;
10. preservation of tenant and Club isolation, including copied-URL and direct-procedure
    refusal; and
11. a controlled retirement plan for ambiguous C1/C2/C3 wording and remaining legacy role
    consumers.

## 8. Safety Rules For Core-Role Management

The triage confirms the following minimum safety direction. The exact owner-appointment,
status and session rules remain decisions for `PLAT-ROLE-03` planning acceptance:

- only an authorised Core `OWNER` or controlled P1 action may grant or remove Core Owner
  authority;
- a Core `ADMIN` must not promote anyone to Owner or use a module endpoint to elevate Core
  authority;
- a user must not silently change their own Core role;
- the final active tenant Owner must not be removed, demoted, suspended or deactivated through
  an ordinary role edit;
- every Core-role change must be tenant-scoped, audited and revoke or refresh affected
  sessions;
- a cross-tenant account must never be moved or relinked silently;
- module-role changes must be validated against the same tenant and module;
- Club-scoped roles must require a valid same-tenant Club affiliation where the role contract
  requires one; and
- UI visibility must never substitute for server-side enforcement.

## 9. Evidence Required Before Implementation

The first technical boundary should be a read-only writer, consumer and live-assignment
inventory. It should report rather than repair.

### 9.1 Static source inventory

Identify and classify:

- every writer of `User.role` and `PlatformAdmin`;
- every user creation, invitation, completion, role-edit and status-edit path;
- every writer and reader of module-role IDs, scopes, read-only flags and Club affiliation;
- every Core `requireRole`, component-permission, admin-card and Danger Gate check used by
  SeasonPro;
- every route where card visibility and server action authority differ;
- remaining legacy role fields, enum helpers, hard-coded choices and fallback consumers;
- session/JWT refresh and revocation behaviour after each authority change; and
- direct-login versus impersonated effective-principal consumption.

### 9.2 Read-only live-state inventory

Only after exact environment and database authority is granted, collect the smallest useful
tenant-scoped evidence for:

- Core Owner/Admin/Member counts;
- users grouped by Core role and effective SeasonPro scope;
- League-role users who remain Core Members;
- Club-role users who are Core Owner/Admin;
- users with no role, invalid/orphaned role IDs or incompatible affiliation;
- active users assigned inactive/template/legacy roles;
- tenants with zero, one or multiple active Owners; and
- any P1-created partial accounts already covered by `PLAT-REFINE-02`.

No names, email addresses, credentials or unnecessary row-level personal information should
enter the lifecycle evidence. No data repair, promotion, demotion, relinking, activation or
deletion is authorised by the inventory.

## 10. Decisions Requiring Human Confirmation Before `PLAT-ROLE-03`

1. Confirm that current SeasonPro documentation will use `C1 League` and `C2 Club` only when
   qualified, while Core authority is always named Owner/Admin/Member explicitly.
2. Confirm whether additional C1 League administrators who manage users and configuration
   should normally be Core `ADMIN`, while limited League workers remain Core `MEMBER`.
3. Confirm that Core Owner/Admin should not receive blanket module capability merely because
   of Core status; the preferred outcome is explicit automatic assignment of an auditable
   module-administrator role.
4. Confirm which Core roles may create ordinary users, assign module roles and assign Club
   affiliations.
5. Confirm whether the tenant Owner may create another Owner directly, or whether a controlled
   invitation/acceptance or P1 recovery path is required.
6. Confirm whether multiple Owners are intentionally supported and define the last-Owner
   protection and ownership-transfer process.
7. Confirm how a direct C1 creation form should ask for the new person's intended persona
   without exposing confusing technical terminology.
8. Confirm whether legacy C1/C2/C3 wording is corrected in place or retained only in a clearly
   marked historical glossary section.

No other business decision should be invented during implementation. Technical ambiguities
found by the inventory must be reported for the planning decision.

## 11. Accepted Delivery Shape

Triage divides the project into these independently authorisable slices; none is authorised
by this CR or the planning records alone:

1. **`PLAT-ROLE-01` Authority inventory and canonical matrix** — read-only evidence and
   accepted language.
2. **`PLAT-ROLE-02` Core-role mutation containment** — remove the confirmed SeasonPro and
   ordinary Admin-invitation escalation paths without waiting for the wider redesign.
3. **`PLAT-ROLE-03` Platform authority service and owner safety** — one shared
   Core-role/provisioning/session/audit contract after the retained human decisions.
4. **`LMS-ROLE-01` SeasonPro user-authority consumer alignment** — provisioning, module
   role/affiliation assignment and visible Unassigned repairability.
5. **`LMS-ROLE-02` SeasonPro access parity and read-only enforcement** — a bounded first
   component/action set chosen by the inventory.
6. **Conditional legacy/live reconciliation** — separately approved dry-run and execution
   only if the inventory proves that data repair is necessary.

Wider-module adoption remains separate; no SeasonPro implementation may silently change an
established business-role contract in another module. Platform Core authority and each
module consumer must remain independently testable and reversible.

## 12. Acceptance Direction

Future accepted plans should require automated and human evidence proving at least:

- P1, tenant Owner, tenant Admin, limited League Member, Club Member and Unassigned outcomes;
- identical direct-login and properly constrained impersonation results;
- visible cards agree with permitted direct navigation and mutations;
- a Club user cannot obtain League or another Club's data;
- a League module role does not silently grant Core tenant administration;
- Core Admin cannot grant Owner authority;
- self-demotion and last-Owner loss fail safely;
- authority changes are audited and existing sessions are revoked/refreshed as designed;
- read-only is enforced at UI and server;
- module entitlement and module-role absence produce clear, different handled outcomes;
- P1 and C1 provisioning create the same intended complete record;
- compatible same-tenant partial accounts can be repaired without cross-tenant relinking;
- other enabled modules retain their intended access after a Core-role change; and
- Security Scan, focused access-control tests, type checking, lint/build and exact-commit
  environment smoke all pass before promotion.

## 13. Explicit Non-Goals And Current Stop Condition

This CR input does not:

- authorise application code changes;
- authorise a schema or migration;
- authorise any database query or data change;
- authorise user promotion, demotion, relinking, activation, suspension or deletion;
- authorise environment changes or deployment;
- replace `PLAT-REFINE-02`, `PLAT-REFINE-03`, `PLAT-REFINE-04` or `LMS-W-USERS-01`;
- reopen completed SeasonPro business-status remediation; or
- assume that every current role assignment is wrong.

Platform-led triage is complete. It confirms a Critical containment candidate within a
larger High-severity consistency project and preserves Platform parent / SeasonPro consumer
ownership. The next controlled action, after Email F3 closes, is explicit root selection of
the read-only `PLAT-ROLE-01` inventory. `PLAT-ROLE-02` may receive separate implementation
authority after that static writer boundary is confirmed. The remaining plans stay
conditional on their recorded dependencies and the human decisions in section 10.

## 14. Evidence And Orientation References

Human and lifecycle references reviewed for this CR:

- `docs/00-overview/glossary.md`;
- `docs/00-overview/ui_ux_components/two_tier_three_scope_components.md`;
- `docs/modules/lmspro/unified-workflow-gating-architecture.md`;
- `docs/modules/lmspro/01-cr-inputs/2026-07-07-lmspro-cr-tenant-scoped-role-catalogue-legacy-template-pruning-input.md`;
- `docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md`;
- `docs/platform/00-roadmap-control/2026-07-22-isostack-platform-assurance-security-review-and-refinement-roadmap.md`; and
- `docs/00-overview/technical-continuity-and-succession-handbook.md`.

Application source evidence reviewed at the stated baseline:

- `prisma/schema.prisma` — Core roles, PlatformAdmin, module-role IDs, Club affiliation,
  ModuleRole and VisibilityRule;
- `src/modules/lmspro/lib/roles.ts` — legacy classifications, user-management authority and
  Danger Gate;
- `src/modules/lmspro/lib/componentResolution.ts` — component resolution and Core bypass;
- `src/modules/lmspro/routers/user-context.router.ts` — effective League/Club/Both scope and
  read-only calculation;
- `src/modules/lmspro/routers/components.router.ts` — card visibility-rule evaluation;
- `src/modules/lmspro/routers/users.router.ts` — SeasonPro user creation and update;
- `src/app/(app)/app/lmspro/admin/users/page.tsx` — C1 user-management presentation;
- `src/app/(platform)/platform/clients/[id]/_components/ClientUsersTab.tsx` — P1 role
  presentation;
- `src/modules/lmspro/components/dashboard/DashboardActionCards.tsx` — component and
  Core-admin card selection;
- `src/server/core/routers/users.router.ts` — shared Core user and Owner-only role mutation;
- `src/server/core/routers/import.router.ts` — Owner-only import authority; and
- `src/server/core/access-control.ts` — module enablement and default-role assignment.
