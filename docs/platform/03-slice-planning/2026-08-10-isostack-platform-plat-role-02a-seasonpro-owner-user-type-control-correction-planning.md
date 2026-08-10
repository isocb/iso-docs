# PLAT-ROLE-02A SeasonPro Owner User-Type Control Correction Planning

Date: 2026-08-10

Status: **BOUNDED CORRECTIVE SLICE IMPLEMENTED AND HUMAN-ACCEPTED LOCALLY; RETURNED TO THE
PARENT; PLAT-ROLE-02B CORRECTS THE LATER ITEM-3/ITEM-15 FINDINGS; COMPLETE PARENT/FOCUSED
GATES PASS; COMMITTED IN ROLE CHILD `b1ede26f`; STOP BEFORE STAGING**

Source:

[`PLAT-ROLE-02A sub-CR`](../01-cr-inputs/2026-08-10-isostack-platform-plat-role-02a-seasonpro-owner-user-type-control-correction-sub-cr.md)

Parent:

[`PLAT-ROLE-02 Core-role mutation containment`](2026-08-06-isostack-platform-plat-role-02-core-role-mutation-containment-planning.md)

## 1. Objective

Restore the accepted Owner workflow at the exact point exposed by human smoke: a genuine C1
Owner must receive an editable **SeasonPro User Type** enum and be able to select C1 Owner,
C1 Admin or C2 Member, while non-Owners cannot obtain Owner choices from an unresolved or
incorrect client-session snapshot.

## 2. Implementation Boundary

1. Add a small presentation-policy function which resolves:
   - authoritative Owner -> editable Owner control;
   - authoritative Admin/Member -> fixed Member control; and
   - loading/missing authority -> unavailable/fail closed.
2. In the SeasonPro user-management page, load the existing `users.getProfile` query and
   derive the actor's authority and identifier from that server-backed result.
3. Remove `useSession().user.role` from user-type-control selection and mutation shaping.
4. Disable **Create User** until the actor profile is resolved; guard the handler as a second
   client-side protection.
5. Use the authoritative actor identifier for the existing cannot-edit-own-authority rule.
6. Retain the current server mutation, Platform-owned authority service and composite
   persona validation unchanged.
7. Make the explanatory copy truthful: Owners can create C1 users and C2 Members.

## 3. Explicit Non-Goals

- no schema, migration, seed or account repair;
- no change to stored roles or the tested Acme Owner;
- no redesign of Auth.js JWT refresh or session revocation;
- no broad `PLAT-REFINE-04` impersonation correction;
- no C2 same-node delegation enablement;
- no change to the C1/C2 persona matrix, role taxonomy, hat-swap routing or server
  authorisation policy; and
- no push, staging or production promotion.

## 4. Automated Gates

- focused presentation-policy tests prove Owner, Admin, Member and unresolved cases;
- existing Organisation-authority and SeasonPro-persona tests remain green;
- full TypeScript check passes;
- changed production/test files pass direct ESLint;
- critical-file and Next.js request-body verification pass; and
- production build passes.

## 5. Human Local Gate

Use the confirmed direct-login Acme C1 Owner. In every step distinguish the **acting
Owner** from the **target user** being created or edited:

1. open User Management and choose **Create User**;
2. confirm the acting Owner is **not** given the non-Owner fixed-C2 presentation;
3. confirm the target **SeasonPro User Type** control is editable;
4. select a C1 Admin target and confirm its separate League-role input is editable;
5. create that disposable C1 Admin with one exact League role and no Club role or Club;
6. reopen it and confirm target Organisation `ADMIN`, exact League role and C1 routing
   persist;
7. edit another disposable Owner/Admin and confirm its separate SeasonPro role remains
   editable without changing the acting Owner's authority;
8. select a C2 Member target and confirm the form requires an exact Club role and current
   Club; and
9. resume the parent `PLAT-ROLE-02` human matrix from item 2.

The earlier wording which treated the target default as though it described the acting
Owner is invalid and superseded. The correct presentation already observed by the control
owner — no fixed C2 badge and editable target/SeasonPro-role controls for the Owner — is not
a defect.

Any fixed C2 badge for the Owner, missing enum value, partial persistence or incorrect
persona blocks the parent slice. Stop at local dev after technical gates for this human
test.

## 6. Recovery

Revert the bounded client/presentation-policy change. No data rollback exists or is needed.
