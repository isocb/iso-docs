# PLAT-ROLE-01 Review And Human Matrix Gate

Date: 2026-08-06

Status: **COMPLETE — STATIC INVENTORY REVIEW PASS; ALL 13 CANONICAL MATRIX ITEMS ACCEPTED
AND C1/C2 PERSONA WORDING CORRECTED AFTER THE FIRST PLAT-ROLE-02 LOCAL GATE ON 2026-08-06;
PLAT-ROLE-02 SUBSEQUENTLY DELIVERED THROUGH PRODUCTION; PROJECT CLOSED; THIS REGISTER IS
HISTORICAL PROVENANCE AND CURRENT RESIDUALS ARE LIMITED TO TRIGGER-BASED `PLAT-ROLE-R1`**

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
| `RA-C01` | Confirmed Critical defect | SeasonPro create accepts/persists arbitrary Core role for actors including Core Admin | Delivered by `PLAT-ROLE-02` |
| `RA-C02` | Confirmed Critical defect | SeasonPro update plus self-first/module user authority permits direct Core-role mutation | Delivered by `PLAT-ROLE-02` |
| `RA-C03` | Confirmed Critical defect | Ordinary Core Admin invitation accepts Owner | Delivered by `PLAT-ROLE-02` |
| `RA-C04` | Confirmed Critical defect | Invitation acceptance can relink an existing cross-tenant account and replace Core role | Delivered by `PLAT-ROLE-02` |
| `RA-H01` | Confirmed High defect | Component list, single check and direct Core bypasses disagree | Narrow residual review parked in `PLAT-ROLE-R1` |
| `RA-H02` | Confirmed High defect | `canAccessClub` treats any module-role ID as League access | Delivered by `PLAT-ROLE-02` |
| `RA-H03` | Confirmed High defect | Read-only is calculated for presentation but not enforced by a shared server mutation guard | Affected Club Officials family delivered; bounded resolver review in `PLAT-ROLE-R1` |
| `RA-H04` | Confirmed High defect | Module-role IDs are not uniformly tenant/module/active/template validated | Delivered for accepted user/Officials workflows; resolver boundary retained in `PLAT-ROLE-R1` |
| `RA-H05` | Confirmed High design gap | Most SeasonPro procedures lack one canonical module-entitlement gate | `PLAT-REFINE-03` / `LMS-ROLE-02` |
| `RA-H06` | Confirmed High design gap | Real/effective identity differs across component, router and RLS consumers | `PLAT-REFINE-04` |
| `RA-H07` | Historical High functional/security gap | At the reviewed baseline, the generic League user router did not provide a complete exact-node C2 delegation contract | Desired same-Club outcome delivered through Club Officials and production-proven |
| `RA-D01` | Part-settled human decision | Multiple Owners and C1 Owner authority to create Admin/additional Owner are confirmed; exact workflow and last-Owner contract remain | Settled and delivered by `PLAT-ROLE-02` |
| `RA-D02` | Part-settled human decision | C2 same-node Member creation is accepted; exact enabling permission and remaining C1/Admin delegation matrix remain | Settled and production-proven through Club Officials |
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

For SeasonPro, C1 requires Organisation `OWNER` or `ADMIN` plus an explicit League role. C2
requires Organisation `MEMBER` plus a Club role and exact current Club. A Member never
receives League/C1 routing. A C2 dashboard may expose the Club's own child records, such as
Teams and Communications, but never another Club's records. The combined state is available
only to a C1 Owner/Admin and is derived from separate League and Club roles plus the exact
Club; `BOTH` is not a standalone user role or persona.

Core role and module role are related by controlled provisioning and permission checks, but
one must not be inferred from the other. A SeasonPro C1 Owner is therefore normally both:

```text
Organisation role: OWNER
SeasonPro role: an explicit League/C1 module role
```

## 4. Human Review Checklist

Accepted canonical statements:

1. **Accepted:** Core Owner/Admin/Member means the shared Organisation authority layer and
   remains separate from P1 and SeasonPro roles.
2. **Corrected and accepted after local-gate finding:** SeasonPro module procedures must not
   independently decide or directly persist Organisation role. A C1 Owner deliberately
   creates a C1 Owner/Admin or a C2 Member through the shared Platform-owned authority
   contract; there is no generic Member + League-role persona.
3. **Accepted:** Organisation Admin creates Members only and cannot elevate Organisation authority.
4. **Accepted:** a C1 Owner may create C1 Admins and additional C1 Owners, subject to
   explicit same-tenant, audit, session and last-Owner safeguards.
5. **Accepted:** the bounded controlled-combined workflow may be used for containment: the
   SeasonPro form may request Organisation Authority, but the shared Platform-owned contract
   alone validates, persists and audits it atomically with module provisioning.
6. **Accepted:** Module roles must be same-tenant, correct-module, active and non-template.
7. **Accepted:** Core Owner/Admin receives module administration only through an explicit assigned module
   role, not a runtime bypass.
8. **Accepted:** Club scope always requires an eligible same-tenant/current Club context.
9. **Accepted:** Read-only means server-refused mutations, not merely hidden controls.
10. **Accepted:** P1 impersonation uses the effective user's permissions unless a separately labelled,
    audited support override is deliberately invoked.
11. **Corrected and accepted after local-gate finding:** C1 requires Organisation Owner/Admin
    plus a League role. C2 requires Organisation Member plus a Club role and exact Club and
    never sees C1. Combined routing is only for a C1 Owner/Admin with a separate League role,
    separate Club role and exact Club; preserve this working behaviour without regression.
12. **Accepted:** a suitably permitted C2 Member may create other C2 Members only inside the
    actor's exact node. The target remains Organisation `MEMBER`, receives only eligible
    node-scoped roles, and cannot be attached to another node.
13. **Accepted:** C2 read-only and other capabilities come from module roles and are enforced server-side.

## 5. Final Disposition

The accepted matrix led to delivered `PLAT-ROLE-02/02A/02B`. Production proves the desired
same-Club C2 creation outcome. The project is closed; only the exact legacy writer/resolver
review in `PLAT-ROLE-R1` remains parked. Wider component families, live repair and
impersonation redesign are neither implied nor authorised by this historical register.
