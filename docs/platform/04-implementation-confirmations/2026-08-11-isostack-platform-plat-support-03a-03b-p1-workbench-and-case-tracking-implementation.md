# PLAT-SUPPORT-03A/03B — P1 Workbench And Case Tracking Local Implementation

Date: 2026-08-11

Status: **IMPLEMENTED AND COMMITTED AT EXACT `cde4eaff`; LOCAL 24/24 AND STAGING 10/10
HUMAN GATES PASS; DEV/STAGING SECURITY, IDENTITY AND HEALTH PASS; MAIN PROMOTION AUTHORISED**

Baseline: application `dev` at `39a25d996da2ce24d717d11a754636c31435d517`

Authority:

- [`corrective CR-Fix`](../01-cr-inputs/CR-Fix-2026-08-11-isostack-platform-support-p1-workbench-editing-and-case-tracking.md)
- [`PLAT-SUPPORT-03A plan`](../03-slice-planning/2026-08-11-isostack-platform-plat-support-03a-p1-workbench-entry-editing-and-queue-planning.md)
- [`PLAT-SUPPORT-03B plan`](../03-slice-planning/2026-08-11-isostack-platform-plat-support-03b-operational-case-dates-and-activity-planning.md)

## 1. 03A Delivery

- Non-impersonating P1 `Support Tickets` navigation now targets the canonical workbench at
  `/platform?tab=support&subtab=tickets`; client `/support` remains unchanged.
- Ticket detail is copied into an independent draft only once when a ticket is opened.
  First-review recording is a separate effect, so review mutation/refetch/rerender cannot
  restore persisted Select values over unsaved operator changes.
- Dirty state, unchanged-Save disablement, Reset and discarded-change feedback are explicit.
- P1 creation supports optional initial Severity and Impact as well as the existing
  Priority, Category and Module.
- The desktop queue is a semantic paginated table with expandable summaries; narrow screens
  receive an expandable stacked card layout. Expansion does not open/mark reviewed.
- Existing Client, Status, Severity, Impact, Module, Category and Review filters remain;
  filter state is not cleared by row expansion or ticket management.

## 2. 03B Delivery

Migration `20260811150000_platform_support_p1_case_tracking` adds nullable:

```text
nextActionAt
nextActionNote
lastClientResponseAt
lastP1ResponseAt
lastActivityAt
```

It adds only the operational indexes `status + nextActionAt` and `lastActivityAt`. No
historic values are backfilled.

Server-owned event mapping is now:

| Event | Date evidence |
| --- | --- |
| New ticket | `lastActivityAt` |
| Client public reply | `lastClientResponseAt`, `lastActivityAt` |
| P1 public reply | `lastP1ResponseAt`, `lastActivityAt` |
| P1 internal note | `lastActivityAt` only |
| Triage / client lifecycle / first review | `lastActivityAt`; first review remains separately immutable |
| Close | clears `nextActionAt` and `nextActionNote` |
| Reopen | leaves next action unset |

P1 has overdue, today, next-seven-days and unset filters, plus overdue/due-today balances
computed against the same filtered population. `today` uses the Europe/London calendar and
DST-aware boundaries. Detail includes P1 chronology from creation, valid discussion entries
and relevant audit events.

## 3. Privacy And Validation

- Operational fields and chronology are stripped from non-P1 response objects, not merely
  hidden by the UI.
- Direct clients cannot set classification or next-action fields.
- A next-action note without a date is refused; an unchanged historic overdue date does not
  prevent saving a separate triage correction.
- Dates are new authenticated-event evidence only. `nextActionAt` is an internal management
  target and is not described as a response promise or SLA.

## 4. Automated Evidence

- local target identity: `f6a66d727ced`, distinct from shared `DATABASE_URL`;
- Prisma migration: all **152** migrations applied and status current;
- Support schema/index verifier plus pre-test historic-null assertion: PASS;
- focused Support policy/router/draft tests: **17/17 PASS**;
- complete Vitest: **410 passed**, **12 skipped**, no failures;
- TypeScript: PASS;
- repository critical-file verification: PASS;
- lint: PASS, no findings (tooling emits the existing Next lint deprecation notices);
- Next.js production build: PASS, all 131 static pages generated; and
- middleware request-body finalisation verification: PASS.

A fresh development process for this repository is listening on port `3000`; local health
returns HTTP 200 and the unauthenticated canonical P1 URL returns the expected HTTP 307 to
Platform login. Authenticated behaviour remains the human gate.

The first attempted build gate overlapped another build invocation and produced transient
`.next` route-artifact errors. A clean serial rerun completed with exit code 0; this was a
local build-directory concurrency issue, not an application failure.

## 5. Local Smoke Corrective Iteration — Next-Action Note Input

The first human attempt to type into the P1 next-action note failed with
`Cannot read properties of null (reading 'value')`. The `onChange` handler referenced
`event.currentTarget.value` inside the deferred functional state updater. React had cleared
the event target before that updater executed.

The handler now captures the input string synchronously and passes only that plain string to
a pure immutable draft-update helper. A regression test confirms the helper changes the new
draft without mutating the persisted draft or retaining a browser event. Focused tests, the
complete suite and TypeScript pass after the correction. This remains part of
`PLAT-SUPPORT-03B`, not a separate CR.

## 6. Local Smoke Presentation And Interaction Refinement

The subsequent smoke accepted the content but identified avoidable interaction and
information-density problems. The local candidate now applies these refinements:

- the caret is the only table/card control that expands or collapses the summary;
- clicking anywhere else on a ticket row/card opens the management modal, including
  keyboard `Enter`; the redundant `Manage` buttons are removed;
- `Next action` is relabelled `Next action due`, making clear that this manually assigned
  date drives overdue/today/upcoming filters and is not calculated from Severity;
- the next-action note is hidden until a date exists and its alignment-breaking helper text
  is removed; clearing the date also clears the hidden note;
- the modal starts with one compact case-summary card containing subject, saved status,
  priority, description, client, requester and opened date;
- the separate Operational dates block is removed; and
- P1 audit events and discussion are combined into one chronological `Case activity` feed,
  with comment content rendered on its event. The separate duplicated Discussion history is
  removed, while the reply/internal-note composer remains.

The C1 absence of Severity, Priority, Impact and next-action inputs is not a rendering bug:
under the accepted authority contract these are P1-owned triage classifications. If clients
need structured self-reporting, that should use separately named non-authoritative fields
such as reported urgency and reported affected scope rather than allowing clients to set P1
classification.

After this refinement, focused tests remain 17/17, complete Vitest remains 410 passed with
12 intentional skips, TypeScript passes and targeted lint of changed source files passes.
The repository-wide lint command still fails on unrelated pre-existing files and is not
represented as a candidate regression.

## 7. Disposition

At the local acceptance boundary, human smoke was 24/24 green. The code and three additive
Support migrations were then committed as exact
`cde4eaff1e14b2f02ba0953fe8693e7feb02bb61`, excluding the unrelated
`1july2026.code-workspace` edit. `origin/dev` and `origin/staging` are aligned to that exact
commit. Dev Security Scan `31494574593` and staging Security Scan `31494804070` pass.
Public staging health returns HTTP 200 with database connected and RLS 11/11. Render exact
deployment identity and the concise ten-item human staging gate pass. The control owner
authorises exact main promotion subject to its protected scan and production evidence.
