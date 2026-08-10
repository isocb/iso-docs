# IsoStack Core Platform And SeasonPro Role-Authority Clarification And Remediation CR

Date: 2026-08-04

Owning lane: IsoStack Platform, with a bounded SeasonPro / LMSPro consumer outcome

Status: **COMPLETE AND CLOSED; PLAT-ROLE-01 AND DELIVERED PLAT-ROLE-02/02A/02B ACCEPTED;
LOCAL, STAGING AND PRODUCTION EVIDENCE PASS AT EXACT `60ac76c1`, INCLUDING SAME-CLUB C2
MEMBER CREATION AND MAGIC-LINK AUTHENTICATION; CONDITIONAL PLAT-ROLE-03/LMS-ROLE-01/02
ARE SUPERSEDED AS NEXT SLICES; EXACT RESIDUALS PARKED IN TRIGGER-BASED `PLAT-ROLE-R1`**

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
- [`PLAT-ROLE-03 canonical Core authority service and owner safety`](../03-slice-planning/2026-08-06-isostack-platform-plat-role-03-canonical-core-authority-service-and-owner-safety-planning.md) — historical conditional plan, superseded as an automatic next slice;
- [`LMS-ROLE-01 SeasonPro user-authority consumer alignment`](../03-slice-planning/2026-08-06-isostack-platform-lms-role-01-seasonpro-user-authority-consumer-alignment-planning.md) — historical conditional plan, required outcomes delivered; and
- [`LMS-ROLE-02 SeasonPro access parity and read-only enforcement`](../03-slice-planning/2026-08-06-isostack-platform-lms-role-02-seasonpro-access-parity-and-read-only-enforcement-planning.md) — historical conditional plan, residual review narrowed to `PLAT-ROLE-R1`.

Current delivery evidence:

- [`PLAT-ROLE-01 static authority inventory and matrix delivery`](../04-implementation-confirmations/2026-08-06-isostack-platform-plat-role-01-static-authority-inventory-and-matrix-delivery.md); and
- [`PLAT-ROLE-01 review and human matrix gate`](../05-review-and-test/2026-08-06-isostack-platform-plat-role-01-review-and-human-matrix-gate.md);
- [`PLAT-ROLE-02 implementation confirmation`](../04-implementation-confirmations/2026-08-06-isostack-platform-plat-role-02-core-role-mutation-containment-implementation.md); and
- [`PLAT-ROLE-02 local review and human smoke gate`](../05-review-and-test/2026-08-06-isostack-platform-plat-role-02-review-and-local-human-smoke-gate.md);
- [`PLAT-ROLE-02A Owner user-type control sub-CR`](2026-08-10-isostack-platform-plat-role-02a-seasonpro-owner-user-type-control-correction-sub-cr.md);
- [`PLAT-ROLE-02A implementation confirmation`](../04-implementation-confirmations/2026-08-10-isostack-platform-plat-role-02a-seasonpro-owner-user-type-control-correction-implementation.md); and
- [`PLAT-ROLE-02A local human gate`](../05-review-and-test/2026-08-10-isostack-platform-plat-role-02a-seasonpro-owner-user-type-control-correction-local-gate.md);
- [`PLAT-ROLE-02B Club Officials authority-integrity CR-Fix`](CR-Fix-2026-08-10-isostack-platform-plat-role-02b-club-officials-authority-integrity.md);
- [`PLAT-ROLE-02B triage`](../02-triage/2026-08-10-isostack-platform-plat-role-02b-club-officials-authority-integrity-triage.md); and
- [`PLAT-ROLE-02B planning`](../03-slice-planning/2026-08-10-isostack-platform-plat-role-02b-club-officials-authority-integrity-planning.md);
- [`PLAT-ROLE-02B implementation`](../04-implementation-confirmations/2026-08-10-isostack-platform-plat-role-02b-club-officials-authority-integrity-implementation.md); and
- [`PLAT-ROLE-02B local gate`](../05-review-and-test/2026-08-10-isostack-platform-plat-role-02b-club-officials-authority-integrity-local-gate.md).
- [`Role Authority project closure and residual disposition`](../05-review-and-test/2026-08-10-isostack-platform-role-authority-project-closure-and-residual-disposition.md); and
- [`PLAT-ROLE-R1 residual authority consistency review`](CR-Fix-2026-08-10-isostack-platform-residual-authority-consistency-review.md).

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
legacy-compatible `BOTH` and may be read-only. The accepted combined-dashboard persona is
not a single `BOTH` role: it is derived from a separate League role, a separate Club role and
the specific Club affiliation.

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

`C1` and `C2` describe the module's operating hierarchy and resulting dashboard/data
context, not additional Core roles:

```text
P1 = Platform operator and separate Platform route
C1 = the tenant-side context, for example the League
C2 = a client node inside that tenant, for example one Club
```

A C2 SeasonPro user is therefore a composite: Organisation `MEMBER`, a node-scoped
SeasonPro role, and affiliation to the exact Club node. That combination routes the person
to the Club dashboard and limits data to that Club. A SeasonPro `MEMBER` never receives a
League role or C1 dashboard. `MEMBER` without a valid Club role and exact Club is not a valid
SeasonPro C2 persona and receives no SeasonPro operating context.

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

The following is the understandable operating model first confirmed as the triage baseline
and subsequently delivered. No `PLAT-ROLE-03` decision remains open for this project.

Here, `Core` is the technical name for the shared tenant/organisation authority layer. It
does not mean a separate product or route. `Core Member` means the literal `User.role =
MEMBER`; human-facing UI should normally say `Organisation Member`. P1 remains the separate
Platform authority which creates the tenant organisation and its initial C1 Owner.

| Person | Proposed Core authority | Proposed SeasonPro authority |
| --- | --- | --- |
| P1 Platform operator | Separate `PlatformAdmin` authority | Controlled Platform support/administration; not an ordinary tenant persona |
| C1 tenant owner | `OWNER` | An appropriate `LEAGUE` SeasonPro role, normally League Administrator |
| Additional C1 tenant administrator | `ADMIN` | An appropriate `LEAGUE` role; add a separate `CLUB` role and exact Club only when hat swapping is required |
| C2 Club user | `MEMBER` | A node-bounded `CLUB` role plus the exact current Club affiliation |
| Unassigned/incomplete account | Any retained Organisation authority | No valid SeasonPro persona; no SeasonPro dashboard/data; visible only to authorised repair workflow |

The intended principles are:

1. The actual tenant owner is a Core `OWNER`.
2. An ordinary C2 Club user is normally a Core `MEMBER`.
3. Every SeasonPro C1 League user is an Organisation Owner or Admin with an explicit League
   role. A Member cannot receive a League role or C1 context.
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
11. A C1 Owner may deliberately create C1 Admins and additional C1 Owners. That combined
    SeasonPro workflow must call a Platform-owned, same-tenant organisation-authority
    contract rather than making SeasonPro the owner of Core-role policy or persistence.
12. C1/C2 is a composite authority and module-context distinction. C1 requires Organisation
    `OWNER` or `ADMIN` plus a League role. C2 requires Organisation `MEMBER` plus a Club role
    and exact current Club. The combined hat state is available only to a C1 Owner/Admin and
    requires a separate League role, separate Club role and exact Club; `BOTH` is not a user
    role or independently assigned persona.
13. A suitably permitted C2 Member may create other C2 Members only inside the actor's own
    Club node. The target remains Organisation `MEMBER`, receives only node-scoped roles and
    cannot be affiliated to another Club.
14. C2 read-only and other action capabilities are determined by assigned module roles and
    must be enforced by the server as well as the dashboard.

## 3. Why The Current Language Is Ambiguous

The original, now superseded for current operating guidance, IsoStack glossary defines:

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

The accepted current meaning is hierarchical: C1 is the tenant-side module context and C2
is a client node inside that tenant. Lifecycle documents and operator-facing guidance must
qualify the context, for example:

```text
C1 Tenant Owner
C1 League User
C2 Club User
Core OWNER
Core ADMIN
Core MEMBER
```

The canonical security contract must use the actual Core role, module role, scope and node
affiliation rather than trusting the C-number label by itself.

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

### 5.7 C2 dashboard routing and same-node user delegation are not one enforced contract

The welcome route currently chooses League, Club or combined presentation from module-role
scope and Club association. The proven working combined path—separate League role plus
separate Club role plus exact Club affiliation—is the accepted non-regression baseline. The
queries do not yet apply every tenant/module/active-role constraint in one canonical
resolver, and legacy `roleScope = BOTH` compatibility must not be mistaken for the business
persona or allow a combined context without an exact Club.

The reviewed baseline's generic League user-management path did not safely provide C2
delegation. The delivered solution does not open that wider path: the bounded Club Officials
workflow permits an authorised C2 Member to create a sibling Member only in the same Club.
Production evidence proves creation and magic-link authentication. No `LMS-ROLE-01`
expansion is required for the accepted business outcome.

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
9. Each module must derive its C1/C2 dashboard and data context from validated module scope
   and node affiliation. Core `MEMBER` is not a dashboard-routing flag.
10. Node-scoped user delegation must force the actor's exact node server-side and must not
    accept another same-tenant node or a tenant-wide/combined role.
11. SeasonPro combined routing must preserve the conjunctive contract: at least one valid
    League role, at least one valid Club role and the exact Club affiliation. Removing any
    one of those facts removes the combined context.

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
    refusal;
11. explicit C1 tenant-context and C2 node-context dashboard routing, including a handled
    combined-context choice only when separate League and Club roles plus exact Club
    affiliation are valid;
12. same-node C2 Member creation when granted by module role, with cross-node and
    tenant-wide-role assignment refused server-side; and
13. a controlled retirement plan for conflicting legacy C1/C2/C3 wording and remaining legacy role
    consumers.

## 8. Safety Rules For Core-Role Management

The delivered release enforces the following minimum operating safety rules. Any later
Owner-recovery/status expansion activates review under `PLAT-ROLE-R1` rather than reopening
`PLAT-ROLE-03` automatically:

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
  requires one;
- C2 user creation must keep the target as Organisation Member, force the creator's exact
  current Club node, accept only eligible Club-scoped roles and refuse other nodes even
  inside the same tenant;
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

## 10. Final Human Decisions And Residual Disposition

1. Accepted: `C1` is the tenant-side module context and `C2` is a client node within that
   tenant; Core authority remains explicitly Owner/Admin/Member.
2. Accepted: every SeasonPro C1 League user is Organisation `OWNER` or `ADMIN` plus an exact
   League role. There is no limited Member + League persona.
3. Accepted: Core Owner/Admin module capability should be explicit and auditable. The
   remaining legacy component-resolver shortcut is not a blocker to the tested personas and
   is retained only in trigger-based `PLAT-ROLE-R1`.
4. Accepted and production-proven: a suitably authorised C2 Member may create a sibling C2
   Member through the same-Club Club Officials workflow. `clubb@isodo.co.uk` created
   `clubc@isodo.co.uk`, which authenticated successfully by magic link.
5. Confirmed: multiple Owners are supported and a C1 Owner may create an additional Owner
   directly through the controlled creation workflow.
6. Accepted and tested: the last active Owner cannot be demoted; with another active Owner
   present, a deliberate non-self change is allowed. Define any additional ownership-
   transfer and recovery work belongs only to a future triggered review if the workflow is
   expanded.
7. Confirmed: the direct creation form should use the user-facing labels `Owner` and
   `Admin Delegate`, not `C1 Owner` or `C1 Admin`; the underlying Organisation authorities
   remain literal `OWNER` and `ADMIN`.
8. Historical C1/C2/C3 wording may remain in clearly historical records. Current security
   and product documents use C1 tenant context, C2 node context and literal Organisation
   authority explicitly.

No other business decision should be invented during implementation. Technical ambiguities
found by the inventory must be reported for the planning decision.

## 11. Accepted Delivery Shape

Final disposition of the independently controlled slices:

1. **`PLAT-ROLE-01` Authority inventory and canonical matrix** — complete.
2. **`PLAT-ROLE-02` Core-role mutation containment** — remove the confirmed SeasonPro and
   ordinary Admin-invitation escalation paths without waiting for the wider redesign;
   complete with 02A/02B corrective children.
3. **`PLAT-ROLE-03`** — superseded as an automatic next slice because the shared bounded
   authority service and required Owner safeguards were delivered by `PLAT-ROLE-02`.
4. **`LMS-ROLE-01`** — superseded as an automatic next slice because the required C1/C2,
   exact-role/Club and same-Club creation outcomes are delivered and proven.
5. **`LMS-ROLE-02`** — delivered for the affected Club Officials family; no broad rewrite
   authorised. The exact remaining resolver question is parked in `PLAT-ROLE-R1`.
6. **Conditional legacy/live reconciliation** — separately approved dry-run and execution
   only if the inventory proves that data repair is necessary.

Wider-module adoption remains separate; no SeasonPro implementation may silently change an
established business-role contract in another module. Platform Core authority and each
module consumer must remain independently testable and reversible.

The Role Authority project is closed. Historical conditional plans do not keep it active.

## 12. Acceptance Evidence Contract

The completed lifecycle supplied automated and human evidence for the selected operating
outcomes below. Wider impersonation and unrelated module-refinement concerns retain their
own controls and are not closure blockers:

- P1, C1 tenant Owner, C1 tenant Admin, C2 Club Member and Unassigned outcomes;
- identical direct-login and properly constrained impersonation results;
- visible cards agree with permitted direct navigation and mutations;
- League-only users route to the C1 dashboard, Club-only users route to their C2 node
  dashboard, and users holding separate valid League and Club roles plus an exact Club
  receive the deliberate context choice;
- removing the League role, Club role or exact Club from that combined user removes the
  combined context without changing Core authority;
- a Club user cannot obtain League or another Club's data;
- a permitted C2 Member can create an Organisation Member only for their own Club, while a
  copied/direct request for another Club or a League/Both role is refused;
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

## 13. Explicit Non-Goals And Final Stop Condition

This CR input does not:

- authorise application code changes;
- authorise a schema or migration;
- authorise any database query or data change;
- authorise user promotion, demotion, relinking, activation, suspension or deletion;
- authorise environment changes or deployment;
- replace `PLAT-REFINE-02`, `PLAT-REFINE-03`, `PLAT-REFINE-04` or `LMS-W-USERS-01`;
- reopen completed SeasonPro business-status remediation; or
- assume that every current role assignment is wrong.

Platform triage, the accepted matrix and `PLAT-ROLE-02/02A/02B` are complete. Checkpoint
`5e551938` failed usefully and was never promoted; its corrective descendants are retained
in exact `60ac76c1`, aligned through production. Local/staging/production, Security Scan,
health, exact-Club and same-Club C2 creation/authentication evidence pass. No schema,
migration or bulk live repair occurred. The final stop is project closure; only the exact
trigger-based `PLAT-ROLE-R1` review may be opened later without a new production finding.

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
