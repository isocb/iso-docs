# PLAT-ROLE-02A SeasonPro Owner User-Type Control Correction Local Gate

Date: 2026-08-10

Status: **TECHNICAL/HUMAN PASS; CORRECTED ACTOR/TARGET GATE ACCEPTED; DELIVERED THROUGH
PRODUCTION IN EXACT `60ac76c1`; COMPLETE PARENT LOCAL/STAGING/PRODUCTION GATES PASS;
CLOSED**

Implementation:

[`PLAT-ROLE-02A implementation`](../04-implementation-confirmations/2026-08-10-isostack-platform-plat-role-02a-seasonpro-owner-user-type-control-correction-implementation.md)

## 1. Review Conclusion

The correction matches the accepted boundary. UI presentation now comes from a current
server-backed user profile, unresolved authority fails closed, and the mutation remains
independently protected by the server's database-backed Organisation-authority service.
There is no schema, data, role-taxonomy, persona, routing or P1-authority expansion.

Technical gates pass. The first human test wording then conflated the acting Owner with the
target user's type and module role. That test design is invalid; it is not an application
failure. The control owner has confirmed the relevant presentation now behaves correctly:
the Owner does not receive the fixed C2 badge, and the target's SeasonPro role control is
editable. The parent matrix then records successful creation/reopen of a C1 Admin,
additional C1 Owner and C2 Member. The bounded correction is accepted locally.

## 2. Corrected Vocabulary

```text
Actor:  logged-in Acme Owner whose authority enables the controls
Target: another Owner/Admin or a newly created Admin/C2 Member
Type:   target C1 Owner/Admin or C2 Member
Role:   target's separate SeasonPro League/Club module role
```

The fixed C2 presentation is the restricted creation surface for an acting C1 Admin. It is
not the expected presentation for an acting Owner and is not determined merely by the
target's current/default type.

## 3. Corrected Immediate Human Test

Use the existing direct login `djfl@isodo.co.uk` in Acme Corporation. Hard-refresh
`http://localhost:3000/app/lmspro/admin/users` once after the local server restart.

1. Select **Create User** and confirm the acting Owner is not shown the fixed-C2 restricted
   presentation. **PRESENTATION OBSERVATION: PASS — confirmed by control owner.**
2. Confirm the target user-type input and the appropriate separate SeasonPro role input are
   editable. **PRESENTATION OBSERVATION: PASS — confirmed by control owner.**
3. Select a C1 Admin target, assign one exact League role and no Club role or Club, then
   create the disposable user. **PASS — CHRIS, parent item 1.**
4. Reopen it and confirm target Organisation `ADMIN`, the selected League role and C1
   dashboard routing are retained. **PASS — CHRIS, parent item 1.**
5. Open another disposable Owner/Admin and confirm the acting Owner can edit that target's
   SeasonPro role without changing the actor's own authority. **PASS — confirmed by control
   owner.**
6. Start a fresh C2 Member target and confirm an exact Club role and exact current Club are
   required. **PASS — CHRIS, parent item 3.**

All corrected PLAT-ROLE-02A items pass. `PLAT-ROLE-02B` now technically corrects the later
parent item-3/item-15 Club Officials findings. That does not invalidate this Owner-control
gate. The complete parent 1–18 run subsequently passed.

The discarded instruction to interpret the target's default as the acting Owner's own type
is recorded as **INVALID TEST — SUPERSEDED**, not `PASS` or application `FAIL`.

## 4. Promotion Decision

Current decision: **PLAT-ROLE-02A COMPLETE LOCALLY; COMPLETE PARENT 1–18 GATE PASSED;
FOCUSED PLAT-ROLE-02B ITEM-7 JUNCTION RETEST IS NOW**. This review does not authorise a
commit, push, staging deployment or production promotion.
