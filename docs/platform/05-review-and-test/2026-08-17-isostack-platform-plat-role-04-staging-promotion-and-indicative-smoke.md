# PLAT-ROLE-04 Staging Promotion And Indicative Smoke

Date: 2026-08-17

Status: **EXACT `250baf12` LIVE ON STAGING; BRANCH, SECURITY, LINUX-PARITY AND HEALTH
GATES PASS — HUMAN SMOKE PENDING; MAIN BLOCKED**

Parent gate:

[`PLAT-ROLE-04 P1 tenant module persona recovery gate`](2026-08-17-isostack-platform-plat-role-04-p1-tenant-module-persona-recovery-gate.md)

## 1. Promotion Summary

```text
feature commit           28aa1ca37b0072b9b200bf4c076adec5c9099c60
build-boundary commit    250baf12556de082fa11d005a8709fee656d8cd3
origin/dev               250baf12556de082fa11d005a8709fee656d8cd3
origin/staging           250baf12556de082fa11d005a8709fee656d8cd3
origin/main              cde4eaff1e14b2f02ba0953fe8693e7feb02bb61
dev Security Scan        32011557075 — PASS
staging Security Scan    32011784475 — PASS
FUND Linux parity        32011557112 — PASS
Render deploy            dep-da1cjovavr4c73fmm5r0 — LIVE at 250baf12
post-deploy health       2026-08-17T08:51:39.231Z — healthy; DB connected; RLS 11/11
```

The first Render attempt at `28aa1ca3` failed closed during root TypeScript checking. The
root application project was discovering the isolated FUND proof, but the application
deployment did not install its proof-only packages. Candidate `250baf12` corrects only
that project boundary: application and proof are independently type-checked, and the FUND
Linux proof remains green.

The component synchroniser also reported 50 rows against an expected built-in set of 44.
That was a warning, not the failure. Do not delete the six additional records as part of
this release; reconcile their provenance separately if later required.

Public staging health initially remained green while the replacement was building. Render
then recorded exact `250baf12` live at 08:51:24 UTC, and the fresh 08:51:39 UTC health
response passed with database connected and RLS 11/11.

## 2. Mandatory Deployment Gate

The automated release record confirms:

1. **PASS** — service `Staging-IsoStack` is **Live at `250baf12`** with subject
   `fix(build): isolate FUND proof TypeScript project`;
2. **PASS** — deploy `dep-da1cjovavr4c73fmm5r0` reached terminal `live`;
3. **PASS** — `https://staging.seasonpro.co.uk/api/health` returns healthy, database connected and
   RLS 11/11; and
4. **PASS** — no migration, FUND Stage C worker, credential or R2 action accompanied the deployment.

If the exact SHA differs or the deployment fails, stop. Do not run the human mutation
smoke and do not promote main.

## 3. Indicative Human Staging Smoke

This is intentionally shorter than the accepted 15-item local matrix. Use P1 and controlled
staging fixtures. Do not alter production and do not repeat the Northgate direct SQL repair.
Record each item `PASS`, `FAIL` or `BLOCKED`.

1. **PENDING** — Open Northgate Vale Youth Football League in P1 Client > Users. Confirm
   `nvy@isodo.co.uk` is visible as Core `OWNER`, with exact `League Admin`, exact `Club
   Secretary`, current `Alderwick Athletic`, and `C1 + Club hat`; no legacy `BOTH` role is
   selected.
2. **PENDING** — Reopen the record without changing it. Confirm the same exact composite is
   stable and the League/Club selectors contain only active exact roles owned by Northgate.
3. **PENDING** — Authenticate or impersonate afresh as the recovered user. Confirm C1
   League routing and the Club hat are both available; confirm the user is not gated as C2
   only.
4. **PENDING** — Create one disposable C1 Admin/Owner with one exact League role. Confirm
   creation is atomic, reopening is stable, and fresh routing is C1 League. Do not retain
   the disposable account beyond the agreed staging-test policy.
5. **PENDING** — On that disposable account, add one exact Club role and one current Club.
   Confirm the League role is preserved, the persona becomes `C1 + Club hat`, the target
   session is revoked, and the UI truthfully reports the revocation outcome.
6. **PENDING** — Submit one controlled invalid foreign-role or foreign/old-Club request.
   Confirm refusal and no partial User, current-Club junction, reset-token or success-audit
   persistence.
7. **PENDING** — Inspect audit evidence for the successful create/update and the failed
   request. Confirm before/after tenant, exact role and Club context is present and no secret
   value is stored.
8. **PENDING** — Open one non-SeasonPro tenant and confirm its P1 user flow remains
   Core-only. Recheck public health remains green after the test.

Any cross-tenant selector, partial persistence, false revocation claim, loss of C1 access,
incorrect C2-only routing, or unexpected Core-only regression is a release blocker.

## 4. Decision Boundary

Overall staging human result: **PENDING**

Main remains exact `cde4eaff` and is not authorised by this document. A complete eight-item
PASS plus exact Render identity authorises the control owner to request main promotion; it
does not perform or imply that promotion. `CR-Fix-PLAT-ROLE-04A` remains a separate deferred
follow-on and is not part of this candidate.
