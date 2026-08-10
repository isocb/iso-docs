# PLAT-ROLE-02A SeasonPro Owner User-Type Control Correction Sub-CR

Date: 2026-08-10

Parent CR:

[`IsoStack Core Platform And SeasonPro Role-Authority Clarification And Remediation`](2026-08-04-isostack-core-platform-and-seasonpro-role-authority-clarification-and-remediation-cr.md)

Parent slice: `PLAT-ROLE-02`

Status: **CORRECTIVE CHILD COMPLETE AND DELIVERED THROUGH PRODUCTION IN EXACT
`60ac76c1`; COMPLETE PARENT LOCAL/STAGING/PRODUCTION GATES PASS; CLOSED**

## 1. Human-Gate Finding

The first replacement `PLAT-ROLE-02` local smoke stopped before creating a disposable C1
Admin. The authenticated tester, `djfl@isodo.co.uk`, was shown a read-only `C2 MEMBER` badge
under **SeasonPro User Type** instead of the Owner-only input.

Read-only development-data examination confirmed that this is not invalid test data. The
account is:

```text
Organisation: Acme Corporation
Organisation Authority: OWNER
Status: ACTIVE
SeasonPro roles: one exact LEAGUE role and one exact CLUB role
Club affiliation: one exact current Club
Platform administrator: no
```

It is therefore the accepted C1 Owner hat-swap persona: Organisation Owner, separate League
and Club roles, and an exact Club. `BOTH` is derived routing and is not an assigned role.

## 2. Defect

The SeasonPro user-management page decides whether **SeasonPro User Type** is editable from
the browser session snapshot:

```text
session.user.role === OWNER
```

When that value does not represent the current authoritative Organisation role, the page
takes the non-Owner branch. It renders a badge styled like a form control, fixes creation to
C2 Member and omits the Owner/Admin enum even though the server-side account is an Owner.

The server mutation remains authoritative and has not been shown to grant an invalid
operation. The immediate failure is nevertheless serious because a valid Owner cannot form
the requested C1 persona and the UI states the actor's capability incorrectly.

## 3. Required Behaviour

Three different facts must remain explicit in the UI and test language:

```text
Acting-user authority = whether the logged-in person is allowed to administer users
Target user type       = whether the created/edited person is C1 Owner/Admin or C2 Member
SeasonPro role         = the target person's separate League and/or Club module role
```

The editable/read-only presentation is selected from the **acting user's** authority. The
value and module-role controls inside the form describe the **target user**. A test must not
describe the target's default value as if it changes the acting Owner's own authority.

For an authoritative acting Organisation `OWNER`, **SeasonPro User Type** is an editable
target-user input with:

- `C1 Owner`;
- `C1 Admin`; and
- `C2 Member`.

The existing composite rules continue to apply to the target. Owner/Admin target selections
require an exact League role; Member requires an exact Club role and current Club. The
acting C1 Owner may edit the separate SeasonPro roles of other Owners/Admins and may create
C1 Admins or C2 Members. The previously accepted additional-Owner policy remains in the
parent slice and is not changed by this corrective child.

For an authoritative acting Organisation `ADMIN`, creation remains fixed to a C2 Member
target because the accepted containment permits Admin to create C2 Members only. The fixed
C2 badge must never be shown merely because the target default is C1 Admin while the actor
is an Owner. A Member receives no broader creation authority.

The form must not choose the non-Owner branch while authoritative profile resolution is
still pending or has failed.

## 4. Accepted Correction

- derive the acting user's Organisation authority and identifier from the existing
  server-backed current/effective-user profile query;
- do not use the JWT-backed client session role to select the Owner input branch;
- disable opening a fresh Create User modal until the authoritative profile is available;
- retain server-side policy as the final authority for create/update;
- use the authoritative profile identifier for the existing self-authority-edit safeguard;
- correct the explanatory copy so it does not imply that Owners create only C1 users; and
- add focused regression coverage for Owner input, Admin/Member fixed behaviour and the
  unresolved-profile fail-closed state.

## 5. Risk Assessment

| Risk | Assessment | Control |
| --- | --- | --- |
| Valid Owner remains unable to create C1 users | High operational impact; reproduced locally | Server-backed profile selects the input branch |
| Non-Owner receives Owner choices during loading/failure | High authority-presentation risk | No modal opening until authority resolves; unresolved state fails closed |
| UI choice exceeds server authority | Contained | Existing server mutation reloads the actor and enforces the Organisation policy |
| Impersonation semantics expand unexpectedly | Out of scope | Reuse the existing effective-user profile; no impersonation contract redesign |
| Schema/data regression | None expected | No schema, migration, seed or data mutation |

Local development data was inspected read-only. No account or role was altered.

## 6. Acceptance And Stop

Automated acceptance requires focused policy tests, full type-check, changed-file lint,
critical-file verification and a production build. Human acceptance restarts
`PLAT-ROLE-02` smoke item 1 with the confirmed Acme C1 Owner:

1. **SeasonPro User Type** is an input, not the C2 badge;
2. it offers C1 Owner, C1 Admin and C2 Member;
3. C1 Admin is the initial creation choice;
4. creation of a disposable C1 Admin with one exact League role succeeds and reopens
   unchanged; and
5. the original `PLAT-ROLE-02` matrix then resumes from item 2.

The corrected actor/target human gate passes and control returned to parent `PLAT-ROLE-02`.
The parent's later item-3 Club Officials consumer finding does not reopen this accepted
Owner-control correction. `PLAT-ROLE-02B` corrected that finding plus item 15, and the
complete parent 1–18 rerun subsequently passed. This sub-CR does not independently
authorise push, staging or production promotion.
