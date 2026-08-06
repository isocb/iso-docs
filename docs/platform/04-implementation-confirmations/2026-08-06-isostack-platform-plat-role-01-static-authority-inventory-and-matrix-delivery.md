# PLAT-ROLE-01 Static Authority Inventory And Matrix Delivery

Date: 2026-08-06

Status: **STATIC READ-ONLY DELIVERY COMPLETE AT APPLICATION `72c02d92`; HUMAN MATRIX
ACCEPTANCE PENDING; OPTIONAL LIVE AGGREGATE INVENTORY NOT AUTHORISED OR RUN; NO APPLICATION,
SCHEMA, CONFIGURATION OR DATA CHANGE**

Accepted plan:

`docs/platform/03-slice-planning/2026-08-06-isostack-platform-plat-role-01-authority-inventory-and-canonical-matrix-planning.md`

Application source reviewed:

`72c02d92bf7222793f70b24a1d13e541eb215efa`

## 1. Delivery Boundary

This slice inspected source and documentation only. It did not execute a role-changing
procedure, query a shared database, inspect a named user, start a browser session, edit
application code or alter configuration.

Reproducible searches covered:

- runtime and tooling writers of `User.role`, `Invitation.role` and `PlatformAdmin`;
- assignment and consumption of `lmsproRoleIds`, legacy role fields and Club affiliation;
- Core, Platform, module-component, scope, read-only and impersonation guards;
- browser controls and payloads for Core and SeasonPro user administration; and
- onboarding, invitation, completion, status, deletion and session-revocation paths.

## 2. Canonical Authority Layers

| Layer | Stored/derived fact | What it may decide | What it must not imply |
| --- | --- | --- | --- |
| P1 Platform authority | `PlatformAdmin` related to a dedicated Platform user | Explicit cross-tenant Platform operations and support entry | A fourth Core role or silent tenant persona |
| Core tenant authority | Literal `User.role`: Owner, Admin or Member | Organisation-wide administration under the accepted owner-safety matrix | A SeasonPro job, role scope or automatic module capability |
| Product entitlement | Active/trial `OrganizationProduct` path to an enabled module | Whether the tenant may use the module | Which individual may see or mutate module data |
| Module authority | Same-tenant, active `ModuleRole` IDs and component/action grants | Which module capabilities the person has | Core elevation or access to another module/tenant |
| Module scope | `LEAGUE`, `CLUB` or `BOTH` | Breadth of module data context | A Core Owner/Admin/Member state |
| Club context | Same-tenant/current Club affiliation and assignments | Exact Club data boundary | League-wide authority |
| C1/C2 presentation context | Derived from valid module scope plus node affiliation | Tenant-side, exact-node or combined dashboard route | Core authority or an independent security grant |
| Read-only | Effective assigned module-role policy | Refusal of module mutations | A browser-only presentation hint |
| Seasonal visibility | Key Dates and visibility rules | When an already-authorised action is presented/actionable | Underlying authority |

## 3. Runtime Writer Inventory

### 3.1 Core role, invitation and P1 writers

| Surface | Actor/entry guard | Write | Current safety result | Owning slice |
| --- | --- | --- | --- | --- |
| `onboarding.startTrial` | Public validated self-sign-up | New organisation Owner | Fixed-purpose new-tenant owner; LMSPro default role is explicitly seeded | `PLAT-ROLE-03` shared provisioning adoption |
| LMSPro league registration verification | Public registration verification flow | New organisation Owner | Fixed-purpose new-tenant owner plus League Admin module role | `LMS-ROLE-01` consumer alignment |
| `/api/auth/signup-module` | Public module sign-up route | New organisation Owner | Fixed-purpose owner but does not visibly share the same LMSPro default-role completion path | `PLAT-REFINE-02` / `LMS-ROLE-01` |
| `organizations.create` | P1-only Platform procedure | New organisation Owner | Explicit P1 path; separate implementation from other provisioning flows | `PLAT-ROLE-03` |
| `users.updateRole` | Core Owner; same tenant; not self | Any Core role | No last-active-Owner protection, transactionally coupled audit or session revocation | `PLAT-ROLE-03` |
| `users.invite` | Core Admin or Owner | Any invitation role and matching pending User role | **Critical:** Admin can request/create Owner | `PLAT-ROLE-02` |
| `users.resendInvitation` / tRPC acceptance | Admin/Owner resend; stored invitation role consumed | Stored Core role | Inherits the authority of the original invitation; duplicated completion contract | `PLAT-ROLE-02/03` |
| `/api/invitations/accept` server action | Possession of invitation token | Creates User, or changes an existing User's organisation and Core role | **Critical:** an existing cross-tenant account can be silently relinked and re-roled | `PLAT-ROLE-02`, then `PLAT-REFINE-02` |
| `users.createForOrganization` | P1 | Any Core role | Explicit P1 writer with its own audit/completion behaviour | `PLAT-ROLE-03` |
| `users.platformUpdateUser` | P1 | Core role, status and LMSPro role IDs | Explicit P1 writer but no canonical shared owner/session service | `PLAT-ROLE-03` / `LMS-ROLE-01` |
| Platform-admin add/update/remove procedures | Existing P1 | PlatformAdmin plus Core role/status | Dedicated Platform organisation is enforced on add; service/audit/session rules remain duplicated | `PLAT-ROLE-03` / `PLAT-REFINE-04` |
| Platform `_actions` promote/demote/invite | P1 | Admin/Member or Admin/Owner invitation | Some last-Owner checks exist, but operations are separate and not consistently transactional/revoking | `PLAT-ROLE-03` |
| `updateTeamMember` server action | Core Owner/Admin or P1; same tenant | Core role/status/profile | Owner can write Core role through a second surface; rules differ from `users.updateRole` | `PLAT-ROLE-03` |
| FUND client-member provisioning | Authorised FUND service | New Core Member only | Safe fixed Core default; still a future shared-provisioning consumer | `PLAT-REFINE-02` |
| Club/official provisioning helpers | Authorised SeasonPro workflows | New Core Member only | Safe fixed Core default; module/Club validation remains consumer work | `LMS-ROLE-01` |

### 3.2 Confirmed unsafe SeasonPro Core writers

| Procedure | Admitted actor | Unsafe capability | UI relationship |
| --- | --- | --- | --- |
| `lmspro.users.create` | P1 and Core Owner/Admin accepted by `canManageUsers` | Input accepts every Core role and persists it; a Core Admin can create Owner | Create UI hides Core role but always sends its local role value |
| `lmspro.users.update` | P1, Core Owner/Admin, qualifying League/Club module users and the target user themself through `canCRUDUser` | Input accepts every Core role and persists it; self-elevation and module-user elevation are possible through direct procedure calls | Edit UI shows Core role only to Core Owner but every Save sends it |

The browser's conditional control is not a security boundary. These two fields must be
removed from the SeasonPro procedure schemas and persistence, not merely hidden.

### 3.3 Non-production writers

`prisma/seed.ts`, Platform-admin utility scripts, DJFL user/backfill utilities and bounded
integration-test scripts also create Core roles or PlatformAdmin rows. They are not normal
runtime entry points. They remain privileged tooling and must not be presented as an
ordinary recovery path. Any future execution needs its own exact-environment authority.

## 4. Module-Role, Scope And Consumer Inventory

| Consumer/writer | Current behaviour | Finding | Owning slice |
| --- | --- | --- | --- |
| `lmspro.users.create/update` role assignment | Owner/Admin/C1 shortcuts can accept role-ID arrays without proving every ID is active, tenant-owned and LMSPro | Cross-tenant, inactive, template or wrong-module identifiers are not uniformly refused | `LMS-ROLE-01` |
| `lmspro.users.bulkUpdate` | Checks tenant ownership for add, but not the LMSPro module or active state | A tenant-owned role from another module can enter `lmsproRoleIds` | `LMS-ROLE-01` |
| Onboarding/product assignment | Explicitly seeds and assigns a tenant League Admin role to Owners | This is the preferred visible/auditable pattern; Core role itself should not be a runtime module bypass | `PLAT-ROLE-03` / `LMS-ROLE-01` |
| `getEffectiveComponents` | Uses assigned role IDs and active state, but does not constrain the fetched roles by module or organisation | Wrong-module/tenant role IDs can contribute matching component keys | `LMS-ROLE-02` |
| `hasComponentAccess` | P1 and Core Owner/Admin bypass; role lookup lacks module/organisation constraint | Direct procedure authority can exceed card-list authority and explicit module assignment | `LMS-ROLE-02` |
| `components.listForUser` | Uses real session user/org, not effective impersonated identity; no Core bypass | Cards can disagree with direct component checks and impersonated context | `LMS-ROLE-02` plus `PLAT-REFINE-04` |
| Dashboard `adminOnly` cards | Uses Core Owner/Admin from the browser session | Core authority is used as a module UI capability outside the role/component contract | `LMS-ROLE-02` |
| `user-context.getUserContext` | Uses effective identity, but role query omits tenant/active constraints and legacy facts still affect scope | Scope may be derived from stale or invalid role facts | `LMS-ROLE-01/02` |
| Welcome dashboard routing | Derives League/Club/combined route from role scope and Club association | Direction matches C1/C2 intent, but resolution lacks one canonical tenant/module/active-role contract | `LMS-ROLE-01/02` |
| C2 user creation/delegation | UI fixes a Club-only creator to their Club; server `canManageUsers` excludes Member, `canAssignRoles` admits `BOTH`, and create checks a supplied Club only as same-tenant | Legitimate same-node delegation is blocked while the adjacent server contract would not safely constrain it if enabled alone | `LMS-ROLE-01` |
| `user-context.canAccessClub` | Treats any `lmsproRoleIds` value as League-wide access | A Club-only assigned role can be misclassified as League authority | `LMS-ROLE-02` Critical data-scope containment consideration |
| Read-only role calculation | `user-context` exposes a display flag when all roles are read-only | No shared server mutation guard consumes that flag | `LMS-ROLE-02` |
| LMSPro layout/routers | Layout checks a recent organisation product state; most routers use `protectedProcedure` plus local guards | No single server module-entitlement guard proves active LMSPro entitlement before every operation | `PLAT-REFINE-03` / `LMS-ROLE-02` |
| Context/RLS during impersonation | Effective user/org are resolved, but RLS role and PlatformAdmin facts are taken from the real session | Real/effective authority can diverge across routers and RLS | `PLAT-REFINE-04` |

## 5. Canonical Matrix For Human Acceptance

`Core` in this technical matrix means shared Organisation authority. `Core Member` is the
literal `User.role = MEMBER`, not membership of a separate Core product. `Allowed` below
means the target contract, not a claim about current source.

| Actor/context | Core user authority | SeasonPro role/affiliation authority | Module/data result |
| --- | --- | --- | --- |
| P1 in Platform context | Allowed only through explicit P1 procedures with real-actor audit, owner safety and session action | Allowed through explicit same-tenant Platform support/provisioning service | No ordinary tenant module persona or hidden bypass |
| P1 impersonating a tenant user | No additional Core mutation from the impersonated surface | Exactly the effective user's module capability unless an explicitly labelled support override is invoked | Cards, routes, API and RLS use one effective-subject result while retaining real-actor audit |
| Tenant Owner | Create Member/Admin/additional Owner through a Platform-owned same-tenant authority contract; manage roles subject to last-Owner rules | Assign same-tenant active roles/affiliation when explicitly authorised | Needs explicit module-administrator assignment; Core Owner alone is not module capability |
| Tenant Admin | Create Members only; no Owner/Admin grant, self-change or owner-state change | Assign bounded same-tenant module roles/affiliation if the accepted matrix permits | No blanket module bypass |
| Limited League Member | No Core role/status authority | Only explicitly granted module user-management actions; never Core mutation | League data/actions named by active role and component grants |
| C2 Club Member | Literal Organisation Member; no Core elevation | When explicitly granted, create/manage Organisation Members with eligible Club-only roles inside the actor's exact current Club; never choose another node | Club dashboard and data for the exact Club only; never League/other-Club access |
| Read-only module user | No Core authority | No module mutation even if a card/control is reachable | Reads only inside entitlement, role and scope |
| Unassigned user | Profile/self-service only | No module role or inferred affiliation | Clear handled Unassigned outcome; no business actions/data |
| No active module entitlement | Core account may remain valid | Module roles do not overcome missing entitlement | Module routes and procedures refuse or route to an explained gate |

## 6. `PLAT-ROLE-02` Confirmed Boundary

The containment plan must cover four source-confirmed paths:

1. remove independent Core-role policy and direct persistence from `lmspro.users.create`;
2. remove independent Core-role policy and direct persistence from `lmspro.users.update`;
3. restrict Organisation Admin creation/invitation to Member while preserving a C1 Owner's
   accepted ability to create Admin/additional Owner through a Platform-owned contract; and
4. make invitation acceptance fail closed for an email already attached to another tenant;
   it must never relink or re-role that account.

The slice must also add direct procedure/route regression tests and prove refused attempts
persist no partial User or Invitation state. It does not need live-user repair or a schema
change.

## 7. Retained Decisions And Stop

Human acceptance is still required for:

1. the exact direct/invitation/acceptance workflow by which a C1 Owner creates an Admin or
   additional Owner;
2. exact self-change, last-active-Owner, suspension and deactivation rules;
3. whether Organisation Admin is strictly Member-create only or can request elevation for
   Owner approval;
4. which explicit module permission lets a limited League Member assign module roles or
   Club affiliation;
5. the exact module permission enabling the accepted C2 same-node Member creation contract;
6. session revocation/reauthentication requirements for Core role, status, module role and
   affiliation changes; and
7. the explicit support override, if any, during P1 impersonation.

The business owner has settled the C2 boundary in principle: suitably module-authorised C2
Members may create C2 Members only inside their own node. The remaining decision is which
module permission grants it and the wider C1/Admin delegation matrix.

No application implementation may start from this record until the controlling next slice
is explicitly selected. No live aggregate inventory was inferred or executed.
