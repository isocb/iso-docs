# PLAT-SUPPORT-03A/03B — Combined Local Review And Human Smoke Gate

Date: 2026-08-11

Status: **LOCAL HUMAN SMOKE 24/24 PASS; EXACT PRODUCTION `cde4eaff`; STAGING 10/10 AND ALL
SECURITY, HEALTH AND RENDER IDENTITY GATES PASS; PROJECT CLOSED**

Implementation:

[`local implementation confirmation`](../04-implementation-confirmations/2026-08-11-isostack-platform-plat-support-03a-03b-p1-workbench-and-case-tracking-implementation.md)

## 1. Preconditions

- Use local application code only and the validated local database.
- Sign in as a non-impersonating P1 and open exactly
  `http://localhost:3000/platform?tab=support&subtab=tickets`.
- Use disposable ticket data and a controlled requester address because public ticket
  events exercise the notification path. Do not use a real client recipient.
- Retain a separate C1/Member session for the privacy checks.

## 2. 03A Workbench Gate

1. **[PASS]** Select `Support Tickets` in P1 navigation; confirm it opens the exact P1 route above and
   does not open client `/support`.
2. **[PASS]** Expand a desktop
   table row. Confirm summary, classifications and dates are readable and filters do not reset.
3. **[PASS]** Open the management modal, change one triage Select without saving, and interact elsewhere in the
   modal. Confirm the changed value remains displayed, the unsaved alert appears and Save is
   enabled.
4. **[PASS]** Select Reset. Confirm all persisted values return and Save becomes disabled.
5. **[PASS]** Change Status, Priority, Severity, Impact and Category in one transaction; save, close and
   reopen. Confirm every persisted value is stable.
6. **[PASS]** Repeat one single-field edit after first review has been recorded. Confirm review refresh
   does not restore the former value before Save.
7. **[PASS]** Create a disposable P1 ticket with Severity and Impact. Confirm both appear in the queue
   and reopen correctly.
8. **[PASS]** Exercise all existing filters plus search and pagination/row expansion. Confirm the queue
   and counts remain coherent and filter state survives detail management.
9. **[PASS]** At a narrow/mobile
   viewport, confirm tickets use readable stacked cards and expand without a two-column squeeze.

## 3. 03B Dates And Activity Gate

10. **[PASS]** Open a historic ticket not touched by this test. Confirm missing operational dates say
    `Not recorded`; no historic response/activity timestamp has been invented.
11. **[PASS AFTER CORRECTION]** Set a future next action and note, save and reopen. Change it,
    then clear both and save; confirm each state persists. The first run exposed a cleared
    React event-target defect; the corrected handler passed human retest.
12. **[PASS; QUESTION RESOLVED]** `Next action due` is the
    manually assigned management date used by overdue/today/next-seven-days filters. Severity
    does not calculate a duration and no response SLA is implied. Create controlled
    tickets/actions covering overdue, today, next seven days and unset.
    Confirm each filter returns only its case and the overdue/due-today balances reconcile
    with the actively filtered queue.
13. **[PASS]** Add a public C1/Member reply. Confirm `Last client response` and `Last activity` advance,
    while `Last P1 response` does not.
14. **[PASS]** Add a P1 public reply. Confirm `Last P1 response` and `Last activity` advance and the
    controlled requester receives the expected event.
15. **[PASS]** Add a P1 internal note. Confirm only `Last activity` advances, no requester notification
    occurs and the event is labelled internal in the P1 chronology.
16. **[PASS]** Make a triage change. Confirm chronology is chronological and includes creation, public
    replies, internal note and relevant triage/review/lifecycle evidence without duplicating
    discussion content.
17. **[PASS]** Set a next action, close the ticket and reopen it. Confirm close clears date and note and
    reopen leaves them unset.

**Authority question recorded:** C1 creation does not expose Severity, Priority, Impact or
next action. This is currently expected under the accepted contract: these are authoritative
P1 triage fields, and item 20 proves clients cannot set them directly. A separately named
client-reported urgency/affected-scope intake remains an explicit business decision; it must
not silently become authoritative P1 classification.

## 4. Authority And Privacy Regression

18. **[PASS]** In the C1/Member session, confirm public discussion and permitted Close/Reply actions
    still work, while triage and internal-note controls remain unavailable.
19. **[PASS]** Inspect the C1/Member `support.getById` response. Confirm it contains none of
    `nextActionAt`, `nextActionNote`, `lastClientResponseAt`, `lastP1ResponseAt`,
    `lastActivityAt`, P1 chronology or internal discussion entries.
20. **[PASS]** Confirm direct C1 attempts to submit Severity, Impact, Priority override or next-action
    values are refused before ticket persistence.

## 5. Focused Presentation And Interaction Retest

21. **[PASS]** Click only the caret in a desktop and mobile ticket. Confirm it expands/collapses the
    summary and does not open the modal.
22. **[PASS]** Click any other part of a collapsed or expanded ticket row/card. Confirm the management
    modal opens; confirm keyboard `Enter` also opens it. Confirm no `Manage` button remains.
23. **[PASS]** Confirm the modal begins with one compact case summary and one chronological `Case
    activity` feed. Confirm public replies/internal notes appear once with their content and
    the former Operational dates plus duplicated Discussion history are absent.
24. **[PASS]** Confirm `Next action due` is initially aligned on its own; choosing a date reveals the
    note alongside it, and clearing the date hides and clears the note.

## 6. Gate Decision

- **PASS:** items 1–20 plus focused refinements 21–24 pass; authorise documentation finalisation and a separately
  requested commit/promotion cycle.
- **PARTIAL/FAIL:** record exact item, actor, ticket number and visible/network evidence;
  keep the Support candidate local and do not promote.

Human decision recorded 2026-08-11: **ALL GREEN — 24/24 PASS.** The Support candidate is
accepted and was committed as exact `cde4eaff1e14b2f02ba0953fe8693e7feb02bb61`.
`origin/dev` and `origin/staging` align to that commit; dev scan `31494574593` and staging
scan `31494804070` pass. This local record does not itself claim Render identity or a
staging human pass; those remain in the separate staging gate.
