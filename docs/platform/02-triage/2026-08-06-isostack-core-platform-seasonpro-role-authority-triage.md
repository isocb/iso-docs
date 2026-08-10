# IsoStack Core Platform And SeasonPro Role Authority Triage

Date: 2026-08-06

Status: **HISTORICAL TRIAGE — PROJECT COMPLETE AND CLOSED AT EXACT `60ac76c1`; CRITICAL
CONTAINMENT, C1/C2/HAT-SWAP, EXACT-CLUB, SAME-CLUB C2 CREATION AND CLUB OFFICIALS
OUTCOMES PASS THROUGH PRODUCTION; CONDITIONAL LATER PLANS SUPERSEDED; EXACT RESIDUAL
REVIEW PARKED AS TRIGGER-BASED `PLAT-ROLE-R1`**

Source CR:

`docs/platform/01-cr-inputs/2026-08-04-isostack-core-platform-and-seasonpro-role-authority-clarification-and-remediation-cr.md`

Source evidence rechecked against application:

`72c02d92bf7222793f70b24a1d13e541eb215efa`

Closure supersession:

[`Role Authority project closure and residual disposition`](../05-review-and-test/2026-08-10-isostack-platform-role-authority-project-closure-and-residual-disposition.md)

Sections 1–3 below retain the source state and risk assessment that justified the project.
They are historical evidence, not current application status. The delivered disposition is
controlled by Sections 4–6 as reconciled below and the closure record.

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

Email F3 is closed at exact application `72c02d92`. Role Authority is now the root project.
The complete corrected `PLAT-ROLE-01` matrix was accepted and `PLAT-ROLE-02` was explicitly
authorised. Checkpoint `5e551938` failed usefully at its first human test and was not
promoted. The corrective bounded containment is implemented locally at `7e453665`;
replacement human local smoke is the current stop gate.

## 2. Confirmed Authority Layers

The project must preserve distinct concepts:

| Layer | Canonical authority |
| --- | --- |
| P1 Platform operator | Separate `PlatformAdmin` authority and real-actor audit identity |
| Core tenant authority | Exactly one `User.role`: `OWNER`, `ADMIN` or `MEMBER` |
| Module authority | Tenant/module `ModuleRole` assignments and component/action grants |
| Module scope | `LEAGUE`, `CLUB` or legacy-compatible `BOTH` role scope; canonical combined routing is derived from separate League and Club roles plus exact Club |
| Club data context | Same-tenant/current Club affiliation and assignments |
| C1/C2 module context | Derived tenant-side or exact client-node dashboard/data context |
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
9. C2 same-node creation is not one server-enforced contract: `canManageUsers` excludes
   Organisation Members, while adjacent C2 role logic admits `BOTH` and create validates a
   supplied Club as same-tenant rather than exact-actor-node.

These are source-confirmed authorization defects. No exploitation, live user change or
cross-tenant disclosure is asserted by this triage.

## 4. Bounded Project Sequence

| Order | Slice | Purpose | Current authority |
| --- | --- | --- | --- |
| 1 | `PLAT-ROLE-01` | Complete writer/consumer/static assignment inventory and settle the canonical matrix | Complete; all 13 matrix items accepted |
| 2 | `PLAT-ROLE-02/02A/02B` | Contain Core-role paths and deliver the accepted SeasonPro persona/Club Officials outcomes | Complete through production at exact `60ac76c1`; all recorded gates pass |
| 3 | `PLAT-ROLE-03` | Original conditional maximum-scope shared-service plan | Superseded as an automatic next slice; required bounded service/safeguards delivered in order 2 |
| 4 | `LMS-ROLE-01` | Original conditional consumer plan | Superseded as an automatic next slice; C1/C2, exact-role/Club and same-Club C2 creation outcomes pass |
| 5 | `LMS-ROLE-02` | Original conditional access-parity plan | Affected Club Officials family delivered; broad plan not authorised |
| 6 | `PLAT-ROLE-R1` | Review exactly one legacy Core writer and the bounded component-resolver consistency question | Captured and deferred; opens only on an explicit trigger |

`PLAT-REFINE-02`, `PLAT-REFINE-03`, `PLAT-REFINE-04` and `LMS-W-USERS-01` remain traceable
inputs. This project consumes their relevant authority/provisioning evidence but does not
silently close route-entitlement or impersonation work outside the accepted slices.

## 5. Settled Decisions

- Core Owner/Admin/Member authority is organisation-wide and Platform-owned.
- SeasonPro roles, scope and Club affiliation do not grant or redefine Core authority.
- P1 remains a separate Platform authority, not a fourth tenant role.
- Core means the shared Organisation authority layer; `Core Member` is literal
  `User.role = MEMBER`, not membership of a separate Core product.
- SeasonPro procedures must not independently decide or directly persist Core role.
- ordinary module users default safely to literal Member, while a C1 Owner retains the
  accepted ability to create C1 Admins and additional C1 Owners through a Platform-owned
  same-tenant authority contract.
- P1 creates/manages tenant organisations and the initial C1 Owner.
- C1 is the tenant-side module context; C2 is a client node inside that tenant. They are not
  synonyms for Core Owner/Admin/Member.
- dashboard routing derives from validated module scope and node affiliation: League-only to
  C1, Club-only to the exact C2 node, and separate League plus Club roles plus exact Club to
  a deliberate context choice. `BOTH` is not an independently assigned business persona.
- a suitably permitted C2 Organisation Member may create other Organisation Members only
  inside the actor's own node; target role, affiliation and all reads/writes remain
  server-bounded to that node.
- Core Owner/Admin must not receive unexplained blanket module capability; module access is
  explicit and auditable.
- documentation and UI must qualify C-number language and name actual authority in security
  contracts.
- every server read/mutation remains authoritative regardless of UI visibility.
- no live repair, role change, status change, relinking or deletion occurs during inventory.

## 6. Closed Decisions And Deferred Trigger

The delivered release settles the operating decisions required by this project: direct
Owner creation, Admin-Delegate Member-only creation, non-self/last-active-Owner safety,
audited/session-revoking authority change, exact C1/C2/hat-swap personas and bounded
same-Club C2 creation. Current terminology uses `Owner` and `Admin Delegate` in the product
while retaining literal Organisation `OWNER`/`ADMIN` in technical evidence.

No broad `PLAT-ROLE-03` decision gate remains. The exact residual review and all activation
triggers are recorded in
[`PLAT-ROLE-R1`](../01-cr-inputs/CR-Fix-2026-08-10-isostack-platform-residual-authority-consistency-review.md).

## 7. Global Stop Conditions

Stop and return to triage if a slice requires:

- cross-tenant account relinking;
- automatic inference of Core role from a module role name or scope;
- schema/migration work not proved by `PLAT-ROLE-01`;
- bulk live repair;
- weakening tenant, Club, entitlement or RLS checks;
- broad impersonation redesign belonging to `PLAT-REFINE-04`; or
- combining containment, shared-service replacement and live repair into one release.
