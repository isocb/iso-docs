# PLAT-SUPPORT-03B — Operational Case Dates And Activity Planning

Date: 2026-08-11

Status: **COMPLETE AND CLOSED AT EXACT PRODUCTION `cde4eaff`; ALL HUMAN, SECURITY, HEALTH
AND RENDER IDENTITY GATES PASS**

CR:

[`P1 workbench editing and case tracking CR-Fix`](../01-cr-inputs/CR-Fix-2026-08-11-isostack-platform-support-p1-workbench-editing-and-case-tracking.md)

## 1. Objective

Give P1 enough truthful time/process evidence to manage the next action and understand prior
case activity without inventing SLA promises or historic timestamps.

## 2. Data Contract

Add nullable fields to `SupportTicket`:

```text
nextActionAt
nextActionNote
lastClientResponseAt
lastP1ResponseAt
lastActivityAt
```

New-ticket creation records `lastActivityAt`. Public client reply records client response
and activity; public P1 reply records P1 response and activity; internal note, triage and
client lifecycle transition record activity only. First review remains separately immutable.

Closing clears the outstanding next action. Reopen leaves it unset. Historic rows remain
null. Add only indexes justified by next-action queue/filter use.

## 3. Server And Presentation

- P1 create/update accepts a valid future/present next action plus trimmed note; a note
  without a date is refused and a date may exist without a note.
- clients cannot write or receive internal operational fields;
- next-action filters are `overdue`, `today`, `next-seven-days` and `unset`;
- stats include the same filtered population plus overdue/due-today balances;
- P1 list/detail display actual first review, last client response, last P1 response, last
  activity and next action;
- P1 chronology combines ticket creation, discussion entries and relevant audit events in
  timestamp order, while clients retain the existing public discussion-only response; and
- mutation invalidation refreshes dates/counts without clearing filters.

## 4. Automated Acceptance

Prove event-to-date mapping, close/reopen behaviour, next-action validation/boundaries,
filter/count consistency, null historic compatibility, chronology ordering, P1-only response
shape and client mutation refusal. Run migration deploy/status and schema/data verification
only on the validated distinct local database, then focused/full tests, type, lint,
repository verification and production build.

## 5. Human Acceptance

Set, change, clear and reopen a next action; verify overdue/today/upcoming/unset filters;
create client and P1 replies plus an internal note and triage change; reconcile all displayed
dates and chronology; close/reopen; then verify C1/Member responses contain none of the
P1-only fields or internal events.

Evidence: [`combined local gate`](../05-review-and-test/2026-08-11-isostack-platform-plat-support-03a-03b-combined-local-review-and-smoke-gate.md).
