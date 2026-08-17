# PLAT-ROLE-04 Production Promotion And Minimum Smoke

Date: 2026-08-17

Status: **EXACT `250baf12` LIVE ON PRODUCTION; TECHNICAL GATES PASS — MINIMUM HUMAN SMOKE
PENDING**

Staging source:

[`PLAT-ROLE-04 staging promotion and indicative smoke`](2026-08-17-isostack-platform-plat-role-04-staging-promotion-and-indicative-smoke.md)

## 1. Exact Promotion Evidence

```text
origin/dev              250baf12556de082fa11d005a8709fee656d8cd3
origin/staging          250baf12556de082fa11d005a8709fee656d8cd3
origin/main             250baf12556de082fa11d005a8709fee656d8cd3
main Security Scan      32015051267 — PASS
Render service          app / srv-d4t6l16uk2gs73ejugg0
Render deploy           dep-da1d6jh42hec73akbcp0 — LIVE at 250baf12
Render finished         2026-08-17T09:31:44.213766Z
production health       2026-08-17T09:32:01.344Z — healthy; DB connected; RLS 11/11
signed-out root         HTTP 307 to /auth/lmspro/login — PASS
```

Main was fast-forwarded without force from the exact 8/8 human-accepted staging ref. No
migration, production data repair, credential, FUND Stage C worker or R2 action accompanied
the promotion.

## 2. Minimum Human Production Smoke

Do not repeat the staging mutation matrix against production. Use existing valid accounts,
make no Save/Create/Delete request and record each check `PASS`, `FAIL` or `BLOCKED`.

1. **PENDING** — Open `https://app.seasonpro.co.uk` signed out and confirm the SeasonPro
   login page is displayed without an application error.
2. **PENDING** — As P1, open Platform > Clients and view one active SeasonPro tenant. Confirm
   Client > Users opens and separately labels Organisation Authority and SeasonPro Persona.
   Close without saving.
3. **PENDING** — As an existing valid C1 Owner/Admin, authenticate afresh and confirm the C1
   League dashboard and User Management page open. Do not alter a user.
4. **PENDING** — As an existing valid C2 Member, authenticate afresh and confirm Club
   dashboard routing with no C1 League dashboard access.
5. **PENDING** — Recheck `/api/health` remains healthy and record no unexpected authority,
   authentication or navigation error during the four read-only checks.

Any wrong-tenant data, loss of C1/C2 routing, unexpected write, authentication loop or
unhealthy response is a production incident. Stop and do not attempt direct data repair.

## 3. Decision Boundary

Production technical result: **PASS**

Production human result: **PENDING**

The accepted staging evidence and exact immutable promotion justify this deliberately
small live smoke. `PLAT-ROLE-04A` is a new bounded development commit and must not be
promoted under this production record.
