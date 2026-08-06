# PLAT-ROLE-02 Review And Local Human Smoke Gate

Date: 2026-08-06

Status: **TECHNICAL REVIEW PASS; AWAITING HUMAN LOCAL DEV SMOKE; NO STAGING OR PRODUCTION
AUTHORITY**

Application under review: `5e551938`

Implementation record:

[`PLAT-ROLE-02 implementation`](../04-implementation-confirmations/2026-08-06-isostack-platform-plat-role-02-core-role-mutation-containment-implementation.md)

## 1. Technical Review Conclusion

The implementation matches the accepted containment boundary. Organisation Authority is
not inferred from SeasonPro role or Club scope; unsafe legacy `role` payloads fail; ordinary
Admin elevation and cross-tenant invitation relinking fail before mutation; and the Club
access query no longer treats every module role as League-wide.

The controlled combined create transaction is accepted for this slice: the SeasonPro form
collects the request, but the shared Platform-owned service is the sole authority policy and
persistence writer. This keeps deliberate Owner creation usable without allowing partial
module/Organisation provisioning.

Automated acceptance, full regression, type, changed lint, repository verification,
production build and dependency audit pass. Human role/context behaviour remains the
required gate.

## 2. Local Human Smoke

Use disposable local accounts and records only. Do not test escalation against a real user.

1. Sign in as a user who has Organisation Authority `ADMIN` and an assigned SeasonPro
   League-scoped role which permits user management. In SeasonPro Admin > Users, create a
   new user and assign that new user an eligible League-scoped SeasonPro role. Confirm the
   new user's separate Organisation Authority is fixed at `MEMBER`—with no Admin/Owner
   choice—and, after reopening the record, both `MEMBER` and the selected SeasonPro League
   role have been retained.
2. As the same Admin, create an ordinary Club user. Confirm Member + intended Club role +
   exact current Club; reopen and verify all three facts.
3. Edit either user's SeasonPro role/Club affiliation and confirm Organisation Authority is
   unchanged.
4. In Team settings as Admin, confirm Invite exposes Member only; complete a disposable
   Member invitation if local mail/token access permits.
5. Using a copied/direct request against disposable data, request Admin or Owner as an Admin.
   Confirm `FORBIDDEN` and confirm no User or Invitation was created.
6. As a C1 Organisation Owner, create a disposable C1 Admin with an intended League role.
   Confirm both authorities survive reopen.
7. As Owner, create a disposable additional Owner. Confirm it survives reopen, is audited,
   and does not acquire a SeasonPro role unless one was explicitly selected.
8. Attempt to change your own Organisation Authority. Confirm the control is disabled and a
   direct request is refused.
9. With disposable Owner fixtures, attempt to demote the last active Owner. Confirm refusal
   and no change. With another active Owner present, confirm a deliberate non-self change is
   accepted and the target must re-authenticate.
10. With an existing known dual-context user, confirm separate League role + separate Club
    role + exact Club still offers the League/Club context choice. Reopen the user and verify
    no standalone `BOTH` persona was created.
11. Remove one of those three dual-context ingredients in disposable data and confirm the
    combined context disappears without changing Organisation Authority; restore it after
    the test if required.
12. For a Club-only role, confirm access to its exact current Club and refusal for another
    Club. For a League role, confirm legitimate League-wide Club access remains.
13. With disposable tenant fixtures, attempt to accept an invitation whose email already
    belongs to another tenant. Confirm a neutral failure and no User, role, organisation or
    Invitation mutation.
14. If a pre-policy elevated invitation is available locally, confirm it is refused until an
    Owner reissues it. Confirm the reissued invitation can complete its matching same-tenant
    pending account atomically.
15. Confirm P1 organisation-user editing remains on the separate Platform route and that
    SeasonPro does not expose a hidden P1 bypass.

If local email delivery is unavailable, steps 4, 13 and 14 may use disposable token/database
fixtures or be carried forward explicitly to staging; do not mark an unexecuted step PASS.

## 3. Acceptance Record

Record each step as `PASS`, `FAIL` or `NOT RUN`, with a short note for any failure. A failure
in steps 1–3, 5–10, 12 or 13 blocks staging. Do not repair live data during this gate.

## 4. Promotion Decision

Current decision: **STOP AT LOCAL DEV**.

After a complete human pass, update this record and reconcile the root and Platform
roadmaps before pushing/promoting through the normal exact-commit process. `PLAT-ROLE-03`
does not begin merely because this local implementation exists.
