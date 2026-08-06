# PLAT-ROLE-01 Review And Human Matrix Gate

Date: 2026-08-06

Status: **STATIC INVENTORY REVIEW PASS; CORE AND C1/C2 CONTEXT TERMINOLOGY ACCEPTED; C1
OWNER AND C2 SAME-NODE AUTHORITY CLARIFIED 2026-08-06; REMAINING MATRIX ITEMS PENDING;
STOPPED BEFORE PLAT-ROLE-02**

Delivery record:

`docs/platform/04-implementation-confirmations/2026-08-06-isostack-platform-plat-role-01-static-authority-inventory-and-matrix-delivery.md`

## 1. Review Conclusion

The static inventory satisfies the read-only boundary and confirms the first containment
file/procedure set. No application, schema, environment or data change was made, so there is
no meaningful local browser smoke: the current UI would merely reproduce known unsafe
server contracts and must not be used to attempt an escalation.

The appropriate human gate is review of the canonical matrix and retained decisions.

## 2. Finding Register

| ID | Classification | Finding | Disposition |
| --- | --- | --- | --- |
| `RA-C01` | Confirmed Critical defect | SeasonPro create accepts/persists arbitrary Core role for actors including Core Admin | `PLAT-ROLE-02` |
| `RA-C02` | Confirmed Critical defect | SeasonPro update plus self-first/module user authority permits direct Core-role mutation | `PLAT-ROLE-02` |
| `RA-C03` | Confirmed Critical defect | Ordinary Core Admin invitation accepts Owner | `PLAT-ROLE-02` |
| `RA-C04` | Confirmed Critical defect | Invitation acceptance can relink an existing cross-tenant account and replace Core role | `PLAT-ROLE-02` |
| `RA-H01` | Confirmed High defect | Component list, single check and direct Core bypasses disagree | `LMS-ROLE-02` |
| `RA-H02` | Confirmed High defect | `canAccessClub` treats any module-role ID as League access | `LMS-ROLE-02` containment review |
| `RA-H03` | Confirmed High defect | Read-only is calculated for presentation but not enforced by a shared server mutation guard | `LMS-ROLE-02` |
| `RA-H04` | Confirmed High defect | Module-role IDs are not uniformly tenant/module/active/template validated | `LMS-ROLE-01` |
| `RA-H05` | Confirmed High design gap | Most SeasonPro procedures lack one canonical module-entitlement gate | `PLAT-REFINE-03` / `LMS-ROLE-02` |
| `RA-H06` | Confirmed High design gap | Real/effective identity differs across component, router and RLS consumers | `PLAT-REFINE-04` |
| `RA-H07` | Confirmed High functional/security gap | C2 Member creation is blocked by one guard while adjacent role/Club checks do not enforce the complete exact-node contract | `LMS-ROLE-01` |
| `RA-D01` | Part-settled human decision | Multiple Owners and C1 Owner authority to create Admin/additional Owner are confirmed; exact workflow and last-Owner contract remain | Before `PLAT-ROLE-02/03` |
| `RA-D02` | Part-settled human decision | C2 same-node Member creation is accepted; exact enabling permission and remaining C1/Admin delegation matrix remain | Before `LMS-ROLE-01` |
| `RA-L01` | Conditional live concern | Invalid/orphaned/cross-module assignments may already exist | Aggregate query only with separate database authority |

No exploitation or live invalid assignment is claimed by the source findings.

## 3. Terms In Plain English

`Core` means the shared **tenant/organisation authority layer** below P1 Platform authority
and above any individual product module. It is not another route and it does not mean that
the person “belongs to Core”.

The literal database field is `User.role`, with exactly three values:

```text
OWNER
ADMIN
MEMBER
```

Therefore, **Core Member means the literal `MEMBER` value**. It is clearer in human UI and
guidance to say **Organisation Member** unless the technical layer itself is being discussed.

The complete relationship is:

```text
P1 Platform operator
-> creates/manages tenant organisations and the initial tenant Owner

Organisation Owner/Admin/Member (shared Core role)
-> governs shared organisation-level authority

Product attribution/entitlement
-> says which modules the organisation has

Module role + permissions + scope/affiliation
-> says what that user can do inside SeasonPro or another module
```

Within a module, C1/C2 describes operating context rather than Core role:

```text
C1 tenant context (League) + League role -> League dashboard
C2 client node (Club) + MEMBER + Club role + exact Club -> Club dashboard
separate League role + separate Club role + exact Club -> explicit context/hat choice
no valid module context -> handled no-access/unassigned outcome
```

An Organisation Member is not automatically C2. A bounded C1 League worker can also be a
Member. The module scope and node affiliation therefore select presentation and data scope;
module permissions decide actions/read-only behaviour. A C2 dashboard may expose the Club's
own child records, such as Teams and Communications, but never another Club's records.
The combined state is derived and conjunctive: `BOTH` is not a standalone user role or
persona, and removing the League role, Club role or Club link removes the combined context.

Core role and module role are related by controlled provisioning and permission checks, but
one must not be inferred from the other. A SeasonPro C1 Owner is therefore normally both:

```text
Organisation role: OWNER
SeasonPro role: an explicit League/C1 module role
```

## 4. Human Review Checklist

Confirm or amend these statements:

1. **Accepted:** Core Owner/Admin/Member means the shared Organisation authority layer and
   remains separate from P1 and SeasonPro roles.
2. **Clarified target:** SeasonPro module procedures must not independently decide or directly persist
   Organisation role. An ordinary module user defaults to literal `MEMBER`; a C1 Owner may
   deliberately create an Organisation Admin or additional Owner through the shared
   Platform-owned authority contract.
3. Organisation Admin creates Members only and cannot elevate Organisation authority.
4. **Accepted:** a C1 Owner may create C1 Admins and additional C1 Owners, subject to
   explicit same-tenant, audit, session and last-Owner safeguards.
5. The exact safe workflow—direct creation, invitation/acceptance or a controlled combined
   workflow—still needs confirmation. Containment must not remove the accepted C1 Owner
   capability before its Platform-owned replacement is available.
6. Module roles must be same-tenant, correct-module, active and non-template.
7. Core Owner/Admin receives module administration only through an explicit assigned module
   role, not a runtime bypass.
8. Club scope always requires an eligible same-tenant/current Club context.
9. Read-only means server-refused mutations, not merely hidden controls.
10. P1 impersonation uses the effective user's permissions unless a separately labelled,
    audited support override is deliberately invoked.
11. **Accepted:** C1 is the tenant-side module context and C2 is a client node within it;
    dashboard routing derives from validated module scope and node affiliation, not Core
    `MEMBER` alone.
    Combined routing specifically requires a separate League role, separate Club role and
    exact Club affiliation; preserve this currently working behaviour without regression.
12. **Accepted:** a suitably permitted C2 Member may create other C2 Members only inside the
    actor's exact node. The target remains Organisation `MEMBER`, receives only eligible
    node-scoped roles, and cannot be attached to another node.
13. C2 read-only and other capabilities come from module roles and are enforced server-side.

## 5. Next Decision

If the matrix is accepted, explicitly authorise `PLAT-ROLE-02` as the next bounded Critical
containment slice, incorporating `RA-C04` and a containment review of `RA-H02`. Do not combine
the canonical service, the fail-closed `RA-H07` C2 feature repair, live repair, every
component family or impersonation redesign into that release.
