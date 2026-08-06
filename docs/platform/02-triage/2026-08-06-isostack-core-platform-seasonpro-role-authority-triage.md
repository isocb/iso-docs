# IsoStack Core Platform And SeasonPro Role Authority Triage

Date: 2026-08-06

Status: **ACTIVE PORTFOLIO PROJECT; PLAT-ROLE-01 STATIC INVENTORY COMPLETE; HUMAN MATRIX
GATE PENDING; CRITICAL PLAT-ROLE-02 CONTAINMENT NOT YET IMPLEMENTATION-AUTHORISED**

Source CR:

`docs/platform/01-cr-inputs/2026-08-04-isostack-core-platform-and-seasonpro-role-authority-clarification-and-remediation-cr.md`

Source evidence rechecked against application:

`72c02d92bf7222793f70b24a1d13e541eb215efa`

## 1. Triage Decision

Accept the CR as one Platform-parent, SeasonPro-consumer project. Do not treat it as one
implementation slice.

Classification:

```text
Type       Shared authorization defect, contract remediation and consumer alignment
Priority   Mandatory project after F3; before Support Ticketing and FUND
Severity   Critical for confirmed Core-role escalation paths; High for wider inconsistency
Owner      IsoStack Platform parent; SeasonPro bounded consumer
Data       Read-only inventory first; no repair authority
Schema     No schema need established
Release    Multiple exact, reversible slices; no combined big-bang release
```

Email F3 is closed at exact application `72c02d92`. Role Authority is now the root project
and `PLAT-ROLE-01` has executed inside its read-only boundary. This document does not
authorise containment code. The human matrix gate and an explicit `PLAT-ROLE-02` decision
remain required.

## 2. Confirmed Authority Layers

The project must preserve distinct concepts:

| Layer | Canonical authority |
| --- | --- |
| P1 Platform operator | Separate `PlatformAdmin` authority and real-actor audit identity |
| Core tenant authority | Exactly one `User.role`: `OWNER`, `ADMIN` or `MEMBER` |
| Module authority | Tenant/module `ModuleRole` assignments and component/action grants |
| Module scope | `LEAGUE`, `CLUB` or `BOTH` role scope |
| Club data context | Same-tenant/current Club affiliation and assignments |
| Seasonal presentation | Key Dates and visibility rules applied after underlying authority |

No C-number, dashboard mode, role name, card visibility or browser-hidden control is a
server authorization boundary.

## 3. Current Critical Findings

The 2026-08-06 static source recheck confirms broader risk than the original UI symptom:

1. `lmspro.users.update` accepts and writes Core `role` after `canCRUDUser`.
2. `canCRUDUser` explicitly allows a user to update themself before checking Core or module
   authority. A direct procedure caller can therefore submit a Core-role change for their
   own account.
3. The same update path can admit Core Admins and qualifying module users for other
   same-tenant targets, while the browser hides the Core-role field from most of them.
4. `lmspro.users.create` accepts any Core role and `canManageUsers` admits Core Admins, so an
   Admin can create a new Core Owner through the procedure even though the current browser
   defaults creation to Member.
5. the shared `users.invite` procedure admits Core Admin and Owner callers while accepting
   every Core role, so an Admin can request an Owner invitation.
6. the active invitation-acceptance server action changes an existing User's organisation
   and Core role when the invitation belongs to another tenant, instead of failing closed.
7. the ordinary Core `updateRole` path is Owner-only and rejects self-change, but Core role
   writers remain duplicated across Core, P1 and SeasonPro procedures and do not share one
   owner-safety/session/audit contract.
8. component-list resolution, individual component checks and direct Core-role checks do
   not currently produce one explainable card/route/API result.

These are source-confirmed authorization defects. No exploitation, live user change or
cross-tenant disclosure is asserted by this triage.

## 4. Bounded Project Sequence

| Order | Slice | Purpose | Current authority |
| --- | --- | --- | --- |
| 1 | `PLAT-ROLE-01` | Complete writer/consumer/static assignment inventory and settle the canonical matrix | Static delivery complete; human matrix acceptance pending; no live query run |
| 2 | `PLAT-ROLE-02` | Remove unauthorized Core-role mutation from SeasonPro, ordinary Admin invitation and cross-tenant invitation acceptance paths | Critical containment plan requires amendment/explicit code authority |
| 3 | `PLAT-ROLE-03` | Introduce one audited Platform Core-authority service with owner/session safety | Conditional plan prepared; business decisions and explicit authority required |
| 4 | `LMS-ROLE-01` | Align SeasonPro provisioning, module-role assignment, Club affiliation and Unassigned repairability | Conditional consumer plan prepared |
| 5 | `LMS-ROLE-02` | Align SeasonPro component/card/direct-action and read-only enforcement | Conditional consumer plan prepared; inventory controls exact file list |
| 6 | Conditional reconciliation | Dry-run and separately authorised repair only if inventory proves live invalid states | Not planned or authorised |

`PLAT-REFINE-02`, `PLAT-REFINE-03`, `PLAT-REFINE-04` and `LMS-W-USERS-01` remain traceable
inputs. This project consumes their relevant authority/provisioning evidence but does not
silently close route-entitlement or impersonation work outside the accepted slices.

## 5. Settled Decisions

- Core Owner/Admin/Member authority is organisation-wide and Platform-owned.
- SeasonPro roles, scope and Club affiliation do not grant or redefine Core authority.
- P1 remains a separate Platform authority, not a fourth tenant role.
- SeasonPro procedures must not independently write Core role.
- ordinary new SeasonPro users default safely to Core Member until an authorised Platform
  authority process deliberately changes that fact.
- Core Owner/Admin must not receive unexplained blanket module capability; module access is
  explicit and auditable.
- documentation and UI must qualify C-number language and name actual authority in security
  contracts.
- every server read/mutation remains authoritative regardless of UI visibility.
- no live repair, role change, status change, relinking or deletion occurs during inventory.

## 6. Decisions Required Before `PLAT-ROLE-03`

1. Whether ordinary tenant ownership supports multiple active Owners.
2. Whether a tenant Owner may appoint another Owner directly, or only through a controlled
   transfer/invitation/recovery flow.
3. The last-active-Owner, self-change, suspension and deactivation rules.
4. The exact matrix for who may create ordinary users, assign module roles and assign Club
   affiliations.
5. Whether Core Admin may create users only as Members or may request Admin subject to Owner
   approval.
6. The intended C1 League persona choices presented during user creation without conflating
   them with Core roles.
7. Session refresh/revocation behaviour for Core role, module role, affiliation and status
   changes.
8. Whether legacy C1/C2/C3 wording is corrected in current guidance and retained only as
   marked historical terminology.

Planning recommendation: support multiple active Owners, prohibit self-demotion and loss of
the last active Owner, let ordinary Admin create Members only, and require an Owner/P1
controlled action for every Core elevation. These remain recommendations until accepted.

## 7. Global Stop Conditions

Stop and return to triage if a slice requires:

- cross-tenant account relinking;
- automatic inference of Core role from a module role name or scope;
- schema/migration work not proved by `PLAT-ROLE-01`;
- bulk live repair;
- weakening tenant, Club, entitlement or RLS checks;
- broad impersonation redesign belonging to `PLAT-REFINE-04`; or
- combining containment, shared-service replacement and live repair into one release.
