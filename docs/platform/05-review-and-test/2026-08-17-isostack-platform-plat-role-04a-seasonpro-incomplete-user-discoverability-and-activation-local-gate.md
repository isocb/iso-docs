# PLAT-ROLE-04A Local Review And Human Smoke Gate

Date: 2026-08-17

Status: **LOCAL GATE ACCEPTED — 14/14 HUMAN-APPLICABLE CHECKS PASS; BULK ATOMICITY
AUTOMATED-ONLY PASS; EXACT `fcd162db` ALIGNED TO DEV WITH SECURITY SCAN PASS**

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

1. **PASS** — Open `/app/lmspro/admin/users` as a valid C1 Owner. Confirm League Users,
   Club Users and `Needs repair` tabs display, and the initial status filter is `All`.
2. **PASS** — Open an incomplete same-tenant Owner/Admin. Confirm it is visible in Needs
   repair, is absent from valid League/Club populations, and shows raw Core status
   separately from `SeasonPro access: Deactivated — persona repair required`.
3. **PASS** — Open and close that record without Save. Confirm no `updatedAt`, audit or
   other persistence change occurs merely from listing/viewing it.
4. **PASS** — Inspect fixtures with a missing/unavailable role, legacy `BOTH` role or
   other contradictory composite. Confirm each remains visible for repair and receives no
   effective League/Club access.
5. **PASS** — Inspect a C2 fixture linked to a prior-season Club where a same-name current
   Club exists. Confirm it remains Needs repair; the current Club may assist selection but
   the old stored UUID is not accepted as current access.
6. **PASS** — Attempt to set an incomplete record to Core `ACTIVE`. Confirm Save is
   disabled in the UI and a controlled direct request is also refused before User, Club
   junction or audit persistence.
7. **AUTOMATED-ONLY PASS — NOT EXPOSED BY THE UI** — The server-focused bulk activation
   test selects an incomplete target, proves validation occurs before the transaction and
   confirms no partial persistence. No unsupported manual API mutation was required.
8. **PASS** — Repair a disposable Owner/Admin with one exact League role and no Club
   role/Club. Save and reopen; confirm it leaves Needs repair, appears in League Users and
   retains C1 dashboard routing.
9. **PASS** — Repair a disposable Member with one exact Club role and one exact current
   Club. Save and reopen; confirm it leaves Needs repair, appears in Club Users, receives
   C2 Club routing and never C1 League routing.
10. **PASS** — Repair or inspect a C1 hat-swap account. Confirm it requires an exact
    League role plus one exact Club role and current Club; no standalone `BOTH` role is
    offered or accepted.
11. **PASS** — On an incomplete non-active fixture, perform a status-only
    suspension/deactivation with its stored persona otherwise unchanged. Confirm the action
    succeeds while SeasonPro remains fail-closed; activation remains blocked until repair.
12. **PASS** — Try to create the email of an existing same-tenant repair record. Confirm
    the duplicate message points to League Users, Club Users or Needs repair and creates
    nothing.
13. **PASS** — Using a controlled email known to exist only in another tenant, confirm
    the conflict remains generic and reveals no tenant, role, Club or repair detail.
14. **PASS** — For one successful repair/activation, inspect the notification and audit.
    Confirm before/after Core authority, exact roles and Club context are truthful, no secret
    is stored, and session revocation success or unavailability is reported accurately.
15. **PASS** — Confirm a repair/list operation does not remove the User's access to any
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

Overall local result: **ACCEPTED — ALL HUMAN-APPLICABLE CHECKS GREEN**

The control owner reported every available human check green on 2026-08-17. Item 7 is not
available through the current UI and is accepted through the retained automated
pre-transaction atomicity proof. This is not represented as a human test.

Exact accepted application commit: `fcd162db60956858233821fd3f29c55e17d954dd`

Exact dev Security Scan: `32018358354` — **PASS**

The accepted commit is aligned to `origin/dev`. This local result and dev scan do not by
themselves authorise staging; staging remains exact `250baf12` pending a separate promotion
decision.
