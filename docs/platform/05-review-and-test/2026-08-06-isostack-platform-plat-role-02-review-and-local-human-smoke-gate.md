# PLAT-ROLE-02 Review And Local Human Smoke Gate

Date: 2026-08-06

Status: **CORRECTIVE TECHNICAL REVIEW PASS AT LOCAL `7e453665`; REPLACEMENT HUMAN LOCAL
SMOKE REQUIRED; PREVIOUS `5e551938` GATE FAILED USEFULLY AND IS SUPERSEDED; NO STAGING OR
PRODUCTION AUTHORITY**

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

1. As a C1 Owner, create a disposable **C1 Admin** with one exact League role and no Club
   role or Club. Reopen it and confirm Organisation `ADMIN`, the selected League role and C1
   dashboard routing are retained.
2. As a C1 Owner, create a disposable **additional C1 Owner** with one exact League role.
   Reopen it and confirm Organisation `OWNER`, the selected League role and C1 routing.
3. As a C1 Owner, create a disposable **C2 Member** with one exact Club role and one exact
   current Club. Reopen it and confirm Organisation `MEMBER`, the selected Club role and
   Club. Sign in or use the welcome route and confirm it receives the C2 Club dashboard and
   never the C1 League dashboard.
4. As a C1 Admin, create a disposable user. Confirm the form fixes the target to C2 Member,
   requires an exact Club role and exact Club, offers no Owner/Admin choice and reopens with
   the same complete C2 persona.
5. As C1 Admin, use a copied/direct disposable request to attempt Owner, Admin or Member +
   League creation. Confirm `FORBIDDEN` or validation refusal and no partial User, role or
   Club-affiliation persistence.
6. As C1 Owner, directly attempt Member + League, Member + `BOTH`, Member + Club without
   Club, and Owner/Admin + Club-only. Confirm every invalid composite fails with no partial
   persistence.
7. Edit a disposable C2 Member's exact Club role and exact Club within a valid complete
   composite. Confirm Organisation authority remains `MEMBER` and reopen is stable.
8. Attempt to replace that C2 Member's Club role with a League role without changing the
   complete persona. Confirm refusal and no mutation.
9. Edit a disposable C1 user's League role. Confirm its Owner/Admin authority is unchanged
   and reopen is stable.
10. On an existing known disposable hat-swap user, confirm Organisation Owner/Admin plus a
    separate League role, separate Club role and exact Club produces the League/Club context
    choice. Confirm no standalone `BOTH` role is present. Remove the Club role and Club
    together and confirm only C1 remains; restore them if required.
11. Confirm exact `BOTH` roles are absent from assignable League and Club selectors. Attempt
    a direct `BOTH` assignment and confirm refusal.
12. For a C2 Member, confirm access to the exact current Club and refusal for another Club.
    For a genuine C1 Owner/Admin with League role, confirm intended League-wide Club access.
13. Attempt to change your own Organisation authority. Confirm the control is disabled and
    a direct request is refused.
14. With disposable Owner fixtures, attempt to demote the last active Owner. Confirm refusal
    and no change. With another active Owner present, confirm a deliberate non-self change
    is audited and the target must re-authenticate.
15. In Team settings as Admin, confirm Invite exposes Member only. Directly request Admin or
    Owner and confirm refusal before User or Invitation persistence.
16. With disposable tenant fixtures, confirm an invitation email already belonging to
    another tenant cannot relink or re-role that account. If a pre-policy elevated invitation
    exists, confirm it must be reissued by an Owner.
17. If a generic unassigned Platform user fixture is available, confirm it receives no
    SeasonPro League or Club context. Confirm P1 organisation-user editing remains on the
    separate Platform route and SeasonPro exposes no hidden P1 bypass.
18. Save module-role or Club-affiliation edits on valid disposable users and confirm no
    unrelated Organisation-authority demotion occurs.

If local email delivery is unavailable, invitation completion in steps 15–16 may use
disposable token/database fixtures or be carried forward explicitly to staging. Do not mark
an unexecuted step PASS.

## 4. Acceptance And Promotion Decision

Any failure in persona formation, routing, cross-tenant isolation, Owner/Admin containment,
last-Owner safety or no-partial-write behaviour blocks staging.

Current decision: **STOP AT LOCAL DEV**.

After the replacement local smoke passes, update this record and reconcile the root and
Platform roadmaps before pushing/promoting through the normal exact-commit process.
`PLAT-ROLE-03` does not begin merely because this local implementation exists.
