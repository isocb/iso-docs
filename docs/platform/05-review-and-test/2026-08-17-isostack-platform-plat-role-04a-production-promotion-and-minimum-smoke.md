# PLAT-ROLE-04A Production Promotion And Minimum Smoke

Date: 2026-08-17

Status: **EXACT `fcd162db` LIVE ON PRODUCTION; MAIN SECURITY, RENDER AND HEALTH GATES PASS
— MINIMUM THREE-CHECK READ-ONLY HUMAN SMOKE PENDING**

Staging source:

[`PLAT-ROLE-04A staging promotion and minimum smoke`](2026-08-17-isostack-platform-plat-role-04a-staging-promotion-and-minimum-smoke.md)

## 1. Exact Promotion Evidence

```text
origin/dev              fcd162db60956858233821fd3f29c55e17d954dd
origin/staging          fcd162db60956858233821fd3f29c55e17d954dd
origin/main             fcd162db60956858233821fd3f29c55e17d954dd
main Security Scan      32019884264 — PASS
Render service          app / srv-d4t6l16uk2gs73ejugg0
Render deploy           dep-da1e1ve7bikc73ckt9eg — LIVE at fcd162db
Render finished         2026-08-17T10:29:19.590584Z
production health       2026-08-17T10:29:34.662Z — healthy; DB connected; RLS 11/11
signed-out root         HTTP 307 to /auth/lmspro/login — PASS
```

Main was fast-forwarded without force from exact staging-accepted `fcd162db`. No schema
migration, production data repair, credential, FUND Stage C worker or R2 action accompanied
the release.

## 2. Minimum Human Production Smoke

Do not manufacture an incomplete production User and do not repeat the local mutation
matrix. Use existing identities, make no Save/Create/Delete request, and record each item
`PASS`, `FAIL` or `BLOCKED`.

1. **PENDING** — Open `https://app.seasonpro.co.uk` signed out and confirm the SeasonPro
   login page appears without an application error.
2. **PENDING** — As one existing valid C1 Owner, open `/app/lmspro/admin/users`. Confirm
   League Users, Club Users and Needs repair tabs load, the initial Core-status filter is
   `All`, and existing valid users remain in their correct populations. Close any opened
   record without saving.
3. **PENDING** — Confirm production `/api/health` remains healthy and no unexpected
   authority, tenant, navigation or application error occurred during checks 1–2.

Stop on wrong-tenant disclosure, unexpected write, loss of a valid League/Club user,
authentication loop or unhealthy response. Do not attempt direct production data repair.

## 3. Decision Boundary

Production technical result: **PASS**

Production human result: **PENDING**

Technical closure requires exact main scan, Render identity and post-deploy health. The
three-check human result then closes PLAT-ROLE-04A and returns portfolio control to the
recorded FUND Stage C `Next`, unless the control owner records another explicit decision.
