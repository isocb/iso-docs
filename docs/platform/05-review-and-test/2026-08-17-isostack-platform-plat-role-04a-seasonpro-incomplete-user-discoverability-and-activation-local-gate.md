# PLAT-ROLE-04A Local Review And Human Smoke Gate

Date: 2026-08-17

Status: **AUTOMATED REVIEW PASS — LOCAL HUMAN SMOKE PENDING; NO COMMIT OR PROMOTION**

Implementation:

[`PLAT-ROLE-04A implementation`](../04-implementation-confirmations/2026-08-17-isostack-platform-plat-role-04a-seasonpro-incomplete-user-discoverability-and-activation-implementation.md)

## 1. Purpose And Fixture

Test on local `dev` only. Use a valid C1 Owner and disposable same-tenant accounts. Prefer
an existing incomplete local fixture. If none exists, create one only in disposable local
data, record its identity, and repair it through the UI before finishing. Do not alter a
real/staging/production identity.

Record each item `PASS`, `FAIL` or `BLOCKED`. Stop on wrong-tenant disclosure, unexpected
Core deactivation, partial bulk persistence or activation of an invalid persona.

## 2. Human Smoke

1. **PENDING** — Open `/app/lmspro/admin/users` as a valid C1 Owner. Confirm League Users,
   Club Users and `Needs repair` tabs display, and the initial status filter is `All`.
2. **PENDING** — Open an incomplete same-tenant Owner/Admin. Confirm it is visible in Needs
   repair, is absent from valid League/Club populations, and shows raw Core status
   separately from `SeasonPro access: Deactivated — persona repair required`.
3. **PENDING** — Open and close that record without Save. Confirm no `updatedAt`, audit or
   other persistence change occurs merely from listing/viewing it.
4. **PENDING** — Inspect fixtures with a missing/unavailable role, legacy `BOTH` role or
   other contradictory composite. Confirm each remains visible for repair and receives no
   effective League/Club access.
5. **PENDING** — Inspect a C2 fixture linked to a prior-season Club where a same-name current
   Club exists. Confirm it remains Needs repair; the current Club may assist selection but
   the old stored UUID is not accepted as current access.
6. **PENDING** — Attempt to set an incomplete record to Core `ACTIVE`. Confirm Save is
   disabled in the UI and a controlled direct request is also refused before User, Club
   junction or audit persistence.
7. **PENDING** — Select one incomplete and one valid disposable record for bulk activation.
   Confirm the complete request is refused and neither record is changed.
8. **PENDING** — Repair a disposable Owner/Admin with one exact League role and no Club
   role/Club. Save and reopen; confirm it leaves Needs repair, appears in League Users and
   retains C1 dashboard routing.
9. **PENDING** — Repair a disposable Member with one exact Club role and one exact current
   Club. Save and reopen; confirm it leaves Needs repair, appears in Club Users, receives
   C2 Club routing and never C1 League routing.
10. **PENDING** — Repair or inspect a C1 hat-swap account. Confirm it requires an exact
    League role plus one exact Club role and current Club; no standalone `BOTH` role is
    offered or accepted.
11. **PENDING** — On an incomplete non-active fixture, perform a status-only
    suspension/deactivation with its stored persona otherwise unchanged. Confirm the action
    succeeds while SeasonPro remains fail-closed; activation remains blocked until repair.
12. **PENDING** — Try to create the email of an existing same-tenant repair record. Confirm
    the duplicate message points to League Users, Club Users or Needs repair and creates
    nothing.
13. **PENDING** — Using a controlled email known to exist only in another tenant, confirm
    the conflict remains generic and reveals no tenant, role, Club or repair detail.
14. **PENDING** — For one successful repair/activation, inspect the notification and audit.
    Confirm before/after Core authority, exact roles and Club context are truthful, no secret
    is stored, and session revocation success or unavailability is reported accurately.
15. **PENDING** — Confirm a repair/list operation does not remove the User's access to any
    other subscribed module. Recheck the preserved workspace edit and confirm no FUND,
    Stage C, Render or R2 artefact changed.

## 3. Automated Review Evidence

```text
focused tests               30/30 PASS
non-FUND regression         441 PASS; 12 skipped
TypeScript                  PASS
critical-file verifier      PASS
request-body verifier       PASS
production build            PASS; 131 pages
runtime lint                0 errors; 10 pre-existing page warnings
schema/migration            unchanged
exact local base            250baf12556de082fa11d005a8709fee656d8cd3
```

## 4. Decision

Overall local human result: **PENDING**

A complete pass permits a separate commit and `origin/dev` alignment decision. It does not
by itself authorise staging. Any failed authority, tenant-isolation, atomicity or
multi-module check keeps the slice local for a corrective iteration.
