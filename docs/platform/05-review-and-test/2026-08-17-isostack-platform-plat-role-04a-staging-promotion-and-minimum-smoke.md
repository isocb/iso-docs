# PLAT-ROLE-04A Staging Promotion And Minimum Smoke

Date: 2026-08-17

Status: **STAGING ACCEPTED — EXACT `fcd162db`; 3/3 HUMAN-APPLICABLE CHECKS PASS AND TWO
MALFORMED-FIXTURE CHECKS ACCEPTED THROUGH RETAINED LOCAL/AUTOMATED EVIDENCE**

Local source:

[`PLAT-ROLE-04A local review and smoke`](2026-08-17-isostack-platform-plat-role-04a-seasonpro-incomplete-user-discoverability-and-activation-local-gate.md)

## 1. Why This Is A Minimum Gate

The accepted local gate already proves the complete mutation and authority matrix: 14/14
human-applicable checks pass, bulk atomicity is automated-green, 441 regression tests pass
and exact dev Security Scan `32018358354` is green. Staging therefore checks deployment
identity and representative read/guard behaviour, not the whole local matrix again.

Do not run direct API experiments, bulk mutations or cross-tenant fixture construction in
staging for this gate.

## 2. Exact Promotion Evidence

```text
feature commit           fcd162db60956858233821fd3f29c55e17d954dd
origin/dev               fcd162db60956858233821fd3f29c55e17d954dd
origin/staging           fcd162db60956858233821fd3f29c55e17d954dd
origin/main              250baf12556de082fa11d005a8709fee656d8cd3
dev Security Scan        32018358354 — PASS
staging Security Scan    32018776885 — PASS
Render service           Staging-IsoStack / srv-d4miroogjchc73balrvg
Render deploy            dep-da1drj5g1s2s73c6pge0 — LIVE at fcd162db
Render finished          2026-08-17T10:15:56.828227Z
staging health           2026-08-17T10:16:19.863Z — healthy; DB connected; RLS 11/11
signed-out root          HTTP 307 to /auth/lmspro/login — PASS
```

The promotion was a fast-forward from the exact accepted dev ref. No force push,
migration, data correction, credential, FUND Stage C, worker or R2 action accompanied it.

## 3. Minimum Human Staging Smoke

Use existing non-sensitive staging fixtures. Make no Save/Create/Delete request. Record
each item `PASS`, `FAIL` or `BLOCKED`.

1. **PASS** — Sign in as a valid staging C1 Owner and open
   `/app/lmspro/admin/users`. Confirm League Users, Club Users and Needs repair tabs load,
   and the initial Core-status filter is `All`.
2. **NOT APPLICABLE — NO MALFORMED STAGING FIXTURE** — Staging contains no incomplete
   same-tenant record, and the UI correctly prevents creating an invalid composite. The
   accepted local checks 2–5 and automated read-model test retain evidence that such a
   record appears only in Needs repair with Core status separate from module access.
3. **NOT APPLICABLE — NO MALFORMED STAGING FIXTURE** — The staging UI validation prevents
   constructing the incomplete `ACTIVE` state needed for this check. Accepted local check
   6 and the direct/bulk server tests prove activation refusal before persistence; the
   read-only/no-write contract is also automated-green.
4. **PASS** — Open one existing valid League user and one existing valid Club user.
   Confirm they remain in their correct populations with their current exact roles/Club;
   close both without saving.
5. **PASS** — Confirm staging `/api/health` is healthy after the exact deploy and no
   unexpected authority, tenant, navigation or application error occurred during checks
   1–4.

Stop immediately on wrong-tenant disclosure, an incomplete record appearing active in a
valid population, an enabled incomplete activation, any read-time write or unhealthy
response.

## 4. Decision Boundary

Technical staging result: **PASS**

Human staging result: **ACCEPTED — 3/3 APPLICABLE CHECKS PASS; 2 FIXTURE-DEPENDENT CHECKS
NOT APPLICABLE WITH RETAINED EVIDENCE**

The absence of malformed staging data is the intended steady state. Manufacturing an
invalid User through direct database/API action would bypass the controls under test and
add unnecessary data risk. The control owner reported every available staging check green
on 2026-08-17; the accepted local and automated evidence closes the two unavailable checks.

This accepted staging result permits a separate main promotion decision. It does not
itself promote main.
