# Platform Support Ticketing — Staging Promotion And Indicative Smoke

Date: 2026-08-11

Status: **EXACT `cde4eaff` STAGING DEPLOYMENT CONFIRMED; DEV/STAGING SECURITY SCANS,
PUBLIC HEALTH AND TEN-ITEM HUMAN SMOKE PASS; ACCEPTED FOR EXACT MAIN PROMOTION**

Source local gate:

[`PLAT-SUPPORT-03A/03B combined local review and smoke`](2026-08-11-isostack-platform-plat-support-03a-03b-combined-local-review-and-smoke-gate.md)

## 1. Promotion Preconditions

- Local Support human smoke is **24/24 PASS**.
- Full local Vitest is **410 passed**, **12 intentionally skipped**.
- TypeScript, targeted changed-source lint, repository verification, migration verification
  and production build pass at the local boundary.
- Promote one exact application commit containing `PLAT-SUPPORT-01/02/03/03A/03B` and the
  three additive Support migrations.
- Exclude the unrelated `1july2026.code-workspace` edit.
- Require the exact dev Security Scan to pass before changing staging.

## 2. Exact Promotion Evidence

```text
application commit: cde4eaff1e14b2f02ba0953fe8693e7feb02bb61
origin/dev: cde4eaff1e14b2f02ba0953fe8693e7feb02bb61
dev Security Scan: PASS — run 31494574593
origin/staging: cde4eaff1e14b2f02ba0953fe8693e7feb02bb61
staging Security Scan: PASS — run 31494804070
Render staging identity: PASS — Live at cde4eaff, feat(platform): complete support ticketing workbench
staging public health/database/RLS: PASS — HTTP 200; database connected; RLS 11/11
origin/main: 60ac76c17dea54db77097a4c3232f4874f9abe3f (unchanged)
```

The staging health response was observed at `2026-08-11T13:12:55.772Z`. The control owner
subsequently confirmed Render displayed `Live at cde4eaff` with commit subject
`feat(platform): complete support ticketing workbench`.

## 3. Indicative Staging Smoke

The 24-item local matrix is authoritative and is not repeated wholesale. On the exact
staging deployment:

1. **[PASS]** Confirm P1 Support navigation opens the Platform workbench, while C1
   `/support` remains tenant/requester scoped.
2. **[PASS]** Confirm the lifecycle cards, all eight filters/search and the paginated queue
   reconcile against known staging tickets.
3. **[PASS]** Confirm caret-only expansion and row/card click-to-manage at desktop and
   narrow widths.
4. **[PASS]** Change all five P1 triage fields, save, close and reopen; confirm stable
   persistence and immutable first-review evidence.
5. **[PASS]** Set/change/clear `Next action due`; confirm the note reveals only with a date
   and the overdue/today/next-seven-days/unset filters and balances reconcile.
6. **[PASS]** Confirm the compact case header and unified Case activity feed show creation,
   review,
   public reply, internal note and triage/lifecycle events without duplicated discussion.
7. **[PASS]** Using controlled mailboxes, confirm client create/reply, P1 public reply,
   status/closure and P1 internal-note no-send follow the accepted routing contract.
8. **[PASS]** As C1 and Member, confirm tenant/requester isolation, read-only
   classification, permitted close/reopen/reply and absence of all P1-only operational
   fields/internal content in the network response.
9. **[PASS]** Confirm P1 create with and without a requester records the intended
   delivery/skipped evidence and does not treat P1 as the client recipient.
10. **[PASS]** Refresh both P1 and client surfaces; confirm stable facts/counts and no
    provider send caused by read, expansion, filtering, preview or unrelated edit.

## 4. Gate

Staging acceptance requires all ten indicative items plus exact deployment identity, public
health/database/RLS and protected staging Security Scan. Do not promote to main before this
record is completed and explicitly accepted.

Control-owner decision recorded 2026-08-11: **FULLY ACCEPTED — 10/10 PASS.** Exact
`cde4eaff1e14b2f02ba0953fe8693e7feb02bb61` is authorised for main promotion, subject to
the protected main Security Scan and production deployment/health documentation.

Subsequent production evidence is controlled by
[`Support Ticketing production promotion and closure`](2026-08-11-isostack-platform-support-ticketing-production-promotion-and-closure.md).
