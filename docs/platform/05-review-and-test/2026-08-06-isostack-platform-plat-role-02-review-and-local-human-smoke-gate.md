# PLAT-ROLE-02 Review And Local Human Smoke Gate

Date: 2026-08-06

Status: **COMPLETE PARENT HUMAN MATRIX ACCEPTED LOCALLY; ITEMS 1–18 PASS; ITEM 7 EXPOSED
ONE BOUNDED CURRENT-CLUB JUNCTION RECONCILIATION DEFECT; CORRECTION, FOCUSED ITEM-7 RETEST
AND READ-ONLY DERBY EXACT-JUNCTION PROOF PASS; COMPLETE LOCAL GATE COMMITTED IN ROLE CHILD
`b1ede26f`**

Application under review: `7e453665`

Implementation record:

[`PLAT-ROLE-02 implementation`](../04-implementation-confirmations/2026-08-06-isostack-platform-plat-role-02-core-role-mutation-containment-implementation.md)

## 1. Failed-Gate Finding And Corrected Contract

The first human test against `5e551938` correctly exposed that the test itself embodied a
false business model: it expected an Organisation Member to retain a League role. That
expectation is invalid in SeasonPro and was as valuable as an ordinary failed test.

The corrected, accepted personas are:

```text
P1 = separate Platform authority and route
C1 Owner = Organisation OWNER + exact LEAGUE role
C1 Admin = Organisation ADMIN + exact LEAGUE role
C2 Member = Organisation MEMBER + exact CLUB role + exact current Club
Hat swap = C1 Owner/Admin + separate LEAGUE role + separate CLUB role + exact Club
```

`BOTH` is not an assignable persona. A Member never receives a League role or C1 dashboard.
An unassigned generic Platform account may exist, but it receives no SeasonPro operating
context until an authorised workflow forms a complete valid persona.

`5e551938` retained valuable escalation, invitation and cross-tenant containment, but was not
promotable because it permitted the invalid Member + League combination. Corrective child
`7e453665` preserves those controls and makes persona validation atomic across Organisation
authority, exact module-role scope and exact Club affiliation.

## 2. Corrective Technical Review

The corrected implementation:

- rejects Member + League, Member + `BOTH`, Member + Club role without exact Club, and
  Owner/Admin + Club-only combinations before persistence;
- permits a C1 Owner to create C1 Owner, C1 Admin or C2 Member through the shared
  Platform-owned authority transaction;
- limits a C1 Admin to creating C2 Members;
- derives League, Club and hat-swap runtime context from the same persona contract;
- offers only exact active tenant `LEAGUE` and `CLUB` roles; and
- keeps the earlier same-tenant, non-self, last-Owner, audit, session-revocation, invitation
  and cross-tenant protections.

Automated, regression, type, lint, verification, production-build and dependency gates pass
at the corrected exact commit. Human routing and form behaviour remain the required stop
gate.

## 3. Replacement Local Human Smoke

Use disposable local accounts and records only. Do not test escalation against a real user.
Record every executed step as `PASS`, `FAIL` or `NOT RUN`.

1. PASS - As a C1 Owner, create a disposable **C1 Admin** with one exact League role and no Club
   role or Club. Reopen it and confirm Organisation `ADMIN`, the selected League role and C1
   dashboard routing are retained. **PASS — CHRIS, 2026-08-10.** The earlier fixed-C2
   presentation finding is superseded by the bounded
   [`PLAT-ROLE-02A` correction](2026-08-10-isostack-platform-plat-role-02a-seasonpro-owner-user-type-control-correction-local-gate.md):
   the Owner receives editable target-type and SeasonPro-role controls, and the created C1
   Admin reopens correctly.
2. PASS - As a C1 Owner, create a disposable **additional C1 Owner** with one exact League role.
   Reopen it and confirm Organisation `OWNER`, the selected League role and C1 routing.
   **PASS — CHRIS, 2026-08-10.**
3. PASS - As a C1 Owner, create a disposable **C2 Member** with one exact Club role and one exact
   current Club. Reopen it and confirm Organisation `MEMBER`, the selected Club role and
   Club. Sign in or use the welcome route and confirm it receives the C2 Club dashboard and
   never the C1 League dashboard. **COMPLETE PASS — CHRIS, 2026-08-10.** The initially
   exposed Club Officials read/error defect was corrected by `PLAT-ROLE-02B`; creation,
   Organisation `MEMBER`, exact active Club role/current Club, reopen, C2 routing and the
   component-authorised Officials view all pass.

4. PASS - **CHRIS - PASS ** **Change actor before testing:** sign out from the Owner session and sign in as the
   disposable **C1 Admin** created in item 1, preferably in a separate/private browser
   session. As that C1 Admin, create a disposable user. Confirm the form fixes the target to
   C2 Member, requires an exact Club role and exact Club, offers no Owner/Admin choice and
   reopens with the same complete C2 persona. While still logged in as the Owner this item is
   `NOT RUN`: an Owner must retain editable target-type and SeasonPro-role controls and must
   not receive the fixed-C2 presentation.
5. PASS **PASS** As C1 Admin, use a copied/direct disposable request to attempt Owner, Admin or Member +
   League creation. Confirm `FORBIDDEN` or validation refusal and no partial User, role or
   Club-affiliation persistence.
6. PASS **PASS** As C1 Owner, directly attempt Member + League, Member + `BOTH`, Member + Club without
   Club, and Owner/Admin + Club-only. Confirm every invalid composite fails with no partial
   persistence.
7. PASS WITH BOUNDED FOLLOW-THROUGH - Edit a disposable C2 Member's exact Club role and
   exact Club within a valid complete composite. Confirm Organisation authority remains
   `MEMBER` and reopen is stable. **THE INTENDED ASSERTION PASSES — CHRIS, 2026-08-10:** the
   Club change, Organisation `MEMBER`, exact role and reopen were correct. The subsequent
   `/app/lmspro/club/officials` refusal for `c2b@isodo.co.uk` is also correct for the selected
   `Club Secretary Club` role because that role does not grant `clubs.officials.view`.
   `Club Secretary` does grant it. The server must not bypass or silently change that tenant
   role configuration.

   Read-only chronology identified one separate persistence defect: moving the user from
   Derby Spitfires to Nottingham Tigers changed `User.lmsproClubId` and added the new
   current-season ClubOfficial membership, but retained the old Derby current-season
   membership. The exact-Club UI/persona assertion therefore passed while a lower-level
   junction consumer could retain too much Club context. This bounded defect is corrected
   in the same `PLAT-ROLE-02B` working tree. Its focused retest and read-only Derby
   exact-junction proof pass; it did not invalidate or require repetition of items 1–18.
8. PASS **PASS** Attempt to replace that C2 Member's Club role with a League role without changing the
   complete persona. Confirm refusal and no mutation.
9. PASS **PASS** Edit a disposable C1 user's League role. Confirm its Owner/Admin authority is unchanged
   and reopen is stable.
10. PASS **PASS** On an existing known disposable hat-swap user, confirm Organisation Owner/Admin plus a
    separate League role, separate Club role and exact Club produces the League/Club context
    choice. Confirm no standalone `BOTH` role is present. Remove the Club role and Club
    together and confirm only C1 remains; restore them if required.
11. PASS **PASS** Confirm exact `BOTH` roles are absent from assignable League and Club selectors. Attempt
    a direct `BOTH` assignment and confirm refusal. **Clarification:** `BOTH` is deduced, not
    assigned manually: hat-swap is detected from separate League and Club roles plus the
    exact Club. It is not a user-defined role, so this test passes.
12. PASS **PASS** For a C2 Member, confirm access to the exact current Club and refusal for another Club.
    For a genuine C1 Owner/Admin with League role, confirm intended League-wide Club access.
13. PASS **PASS** Attempt to change your own Organisation authority. Confirm the control is disabled and
    a direct request is refused.
14. PASS **PASS** With disposable Owner fixtures, attempt to demote the last active Owner. Confirm refusal
    and no change. With another active Owner present, confirm a deliberate non-self change
    is audited and the target must re-authenticate.
15. PASS - In Team settings as Admin, confirm Invite exposes Member only. Directly request
    Admin or Owner and confirm refusal before User or Invitation persistence. **PASS —
    CHRIS, 2026-08-10.** The earlier Club Officials whole-role replacement discovered while
    this item was interrupted is corrected separately by
    [`PLAT-ROLE-02B`](../03-slice-planning/2026-08-10-isostack-platform-plat-role-02b-club-officials-authority-integrity-planning.md);
    the repaired disposable fixture and completed matrix confirm the corrected boundary.
16. PASS With disposable tenant fixtures, confirm an invitation email already belonging to
    another tenant cannot relink or re-role that account. If a pre-policy elevated invitation
    exists, confirm it must be reissued by an Owner.
17. PASS If a generic unassigned Platform user fixture is available, confirm it receives no
    SeasonPro League or Club context. Confirm P1 organisation-user editing remains on the
    separate Platform route and SeasonPro exposes no hidden P1 bypass.
18. PASS  Save module-role or Club-affiliation edits on valid disposable users and confirm no
    unrelated Organisation-authority demotion occurs.

If local email delivery is unavailable, invitation completion in steps 15–16 may use
disposable token/database fixtures or be carried forward explicitly to staging. Do not mark
an unexecuted step PASS.

## 4. Acceptance And Promotion Decision

Any failure in persona formation, routing, cross-tenant isolation, Owner/Admin containment,
last-Owner safety or no-partial-write behaviour blocks staging.

Current decision: **THE CONTROL OWNER ACCEPTS THE COMPLETE ITEM-1-THROUGH-ITEM-18 LOCAL
MATRIX. ITEM 7'S INTENDED PERSONA ASSERTION, BOUNDED JUNCTION CORRECTION, FOCUSED RETEST
AND READ-ONLY DERBY EXACT-JUNCTION PROOF PASS. THE LOCAL ROLE GATE IS COMPLETE; DO NOT
RERUN THE MATRIX. PACKAGE THE ROLE AND DEPENDENCY CHILD COMMITS SEPARATELY BEFORE THE
COMBINED EXACT DEV SECURITY GATE**.

Staging remains blocked until the combined exact dev SHA passes every Security Scan job and
receives a separate promotion decision. `PLAT-ROLE-03` does not begin merely because this
local implementation exists.
