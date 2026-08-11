# LMSPro R12-A Free Day Owner Notice Authority — Local Review And Smoke

Date: 2026-08-11

Status: **COMPLETE GREEN LOCAL PASS; EXACT `39a25d99` PROMOTED TO STAGING; STAGING SMOKE
PENDING**

Implementation:

[`R12-A implementation`](../04-implementation-confirmations/2026-08-11-lmspro-r12-a-free-day-owner-notice-authority-implementation.md)

## 1. Review Conclusion

The code now expresses the clarified business rule consistently. The previous hidden
`max(configured, 28)` floor is absent from both calendars and the server. Valid values below
28 survive resolution unchanged; the direct server check uses the same configured value as
the UI. Save success explicitly refreshes the current-season policy.

No unrelated Free Day workflow was changed. Technical gates are green at the local boundary.

## 2. Human Smoke Preconditions

- Use the local application and the validated local-development database only.
- Sign in as a disposable/test C1 League Owner with season-management authority.
- Use the current season and a disposable eligible current Team.
- Record the original notice value before testing and restore it after the final step.
- Do not use Special Free Days; this gate concerns standard requests only.

## 3. Human Smoke — Explicit Minimum Set

1. **[PASS]** Open the current season's settings and confirm `Notice Period (Days)` accepts integers
   from 1 through 90 and will not accept 0 or 91.
2. **[PASS]** Set the value to **1**, save, remain in the same browser session and open the standard
   Free Day request calendar. Confirm tomorrow is the first selectable date and today is
   unavailable.
3. **[PASS]** Reopen the season and confirm **1** persisted.
4. **[PASS]** Set the value to **14**, save and return to the request calendar without a hard refresh.
   Confirm the first selectable date changes immediately to exactly 14 calendar days from
   today—not 28.
5. **[PASS]** Reopen the season and confirm **14** persisted.
6. **[PASS]** Set the value to **28**, save and confirm the first selectable date is exactly 28 days.
7. **[PASS]** Set the value to **90**, save and confirm the first selectable date is exactly 90 days.
8. **[PASS]** Reopen the season and confirm **90** persisted.
9. **[PASS]**   Restore the original value (or the intended operational value), save and confirm the
   calendar changes immediately to that exact boundary.

## 4. Controlled Submission Boundary

10. **[PASS]** With a deliberately chosen lower-than-28 test value and an eligible disposable Team,
    submit a standard Free Day request on the exact first permitted date. Confirm it is
    accepted once.
11. **[PASS]** Confirm the preceding calendar day is unavailable in the UI. If a controlled direct
    request is part of the tester's normal tooling, confirm the server refuses that date
    with the configured notice-period message. Do not create duplicate requests.

## 5. Regression Checks

12. **[PASS]** Confirm the displayed notice-period message equals the saved value.
13. **[PASS]** Confirm request-window open/close behaviour, Team eligibility and quota presentation
    are unchanged.
14. **[PASS]** Confirm the Special Free Day route remains independent of the standard notice period.

## 6. Recording

Record each item as `PASS`, `FAIL` or `NOT RUN`, with concise non-sensitive evidence. A
failure of immediate refresh, a below-28 boundary, persistence or direct server refusal is a
release blocker. Do not promote to staging until this document is accepted and the control
owner gives separate authority.

## 7. Accepted Local Disposition And Promotion

The control owner reported the complete local smoke **GREEN** on 2026-08-11 and authorised
staging promotion. R12-A was isolated from the uncommitted Support Ticketing candidate and
committed as exact application `39a25d99`. Exact dev Security Scan run `31488395920` passed
before `origin/staging` was fast-forwarded to the same commit. No Support Ticketing code or
migration is included in that staging release.

Staging evidence:

[`R12-A staging promotion and smoke`](2026-08-11-lmspro-r12-a-free-day-owner-notice-authority-staging-gate.md)
