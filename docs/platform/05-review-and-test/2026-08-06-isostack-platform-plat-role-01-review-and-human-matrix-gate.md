# PLAT-ROLE-01 Review And Human Matrix Gate

Date: 2026-08-06

Status: **STATIC INVENTORY REVIEW PASS; NO BROWSER SMOKE APPLICABLE; HUMAN AUTHORITY-MATRIX
ACCEPTANCE PENDING; STOPPED BEFORE PLAT-ROLE-02 IMPLEMENTATION**

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
| `RA-D01` | Human decision | Owner appointment, multiple Owner and last-Owner contract | Before `PLAT-ROLE-03` |
| `RA-D02` | Human decision | Exact module user-management and Club-management delegation | Before `LMS-ROLE-01` |
| `RA-L01` | Conditional live concern | Invalid/orphaned/cross-module assignments may already exist | Aggregate query only with separate database authority |

No exploitation or live invalid assignment is claimed by the source findings.

## 3. Human Review Checklist

Confirm or amend these statements:

1. Core Owner/Admin/Member remains Platform-owned and separate from SeasonPro roles.
2. SeasonPro never writes Core role; new SeasonPro users are Core Members.
3. Core Admin creates Members only and cannot elevate Core authority.
4. Core Owner may create Admin, subject to accepted owner safety and audit.
5. Owner creation/transfer remains blocked from ordinary invitation until its dedicated
   contract is accepted.
6. Module roles must be same-tenant, correct-module, active and non-template.
7. Core Owner/Admin receives module administration only through an explicit assigned module
   role, not a runtime bypass.
8. Club scope always requires an eligible same-tenant/current Club context.
9. Read-only means server-refused mutations, not merely hidden controls.
10. P1 impersonation uses the effective user's permissions unless a separately labelled,
    audited support override is deliberately invoked.

## 4. Next Decision

If the matrix is accepted, explicitly authorise `PLAT-ROLE-02` as the next bounded Critical
containment slice, incorporating `RA-C04` and a containment review of `RA-H02`. Do not combine
the canonical service, live repair, every component family or impersonation redesign into
that release.
