# CR-Fix — Platform Support P1 Workbench Editing And Case Tracking

Date: 2026-08-11

Owning lane: IsoStack Platform

Status: **COMPLETE AND CLOSED WITH PARENT AT EXACT PRODUCTION `cde4eaff`; ALL HUMAN GATES,
PROTECTED SCANS, PUBLIC HEALTH AND RENDER IDENTITIES PASS**

Parent CR:

[`Support Ticketing client readiness and communications`](2026-08-05-isostack-core-platform-support-ticketing-client-readiness-and-communications-cr.md)

## 1. Evidence And Defect

The corrected-route human smoke used the P1 workbench at
`/platform?tab=support&subtab=tickets` and confirmed:

- required filters and search are present;
- the visible triage Selects cannot be changed and saved reliably;
- the P1 navigation item still routes to client `/support`;
- the queue is cards rather than the planned management table/expandable rows; and
- next-action and prior-activity management information is absent.

Source review identifies an edit-state defect consistent with the observation: detail
initialisation and first-review mutation share one effect whose dependencies can rerun after
local Select state changes and restore the stored values before Save.

## 2. Accepted Operational Contract

P1 must be able to edit and persist Status, Priority, Severity, Impact and Category. P1 may
also set one nullable internal next-action date/time and a short next-action note.

The system records actual process dates:

- last client public response;
- last P1 public response; and
- last tracked activity.

`nextActionAt` is an internal support-management target, not a promised client response time
or contractual SLA. No `responseDueAt` field is introduced without a later explicit policy.

Closing a ticket clears its outstanding next action; the audit history retains the prior
value. Reopening does not invent a new target. Historic process dates remain null unless
supported by a new event; no timestamps are fabricated from old discussion or update data.

## 3. Required Outcome

1. The non-impersonating P1 Support Tickets navigation opens the P1 workbench.
2. Triage controls remain changed until save/cancel and reopen with persisted values.
3. P1 create may set initial Priority, Severity, Impact, Category, Module and next action.
4. The desktop queue is a readable paginated table with expandable case summary; narrow
   screens receive an accessible stacked equivalent.
5. Filter/search state survives row expansion and detail editing.
6. Next-action state filters distinguish overdue, today, next seven days and unset.
7. Counts/aging use the same filtered population as the queue.
8. P1 detail shows actual response/activity dates and a P1-only activity chronology.
9. Client responses never expose internal notes, next-action notes or P1-only chronology.
10. Existing green privacy and notification evidence remains valid.

## 4. Data And Privacy Risk

Risk is medium because this adds operational metadata to cross-tenant P1 management while
client response shaping must remain fail-closed. The fields contain no new client-authored
content beyond existing tickets, but next-action notes may contain operational context and
are therefore P1-only.

The migration is additive and nullable. At CR acceptance no Support commit, shared
migration, client enablement or staging promotion was authorised. Subsequent implementation
and local acceptance authorised exact `cde4eaff`, which is now aligned through dev/staging;
main/client enablement remains gated by the staging record.

## 5. Delivery Slices

- `PLAT-SUPPORT-03A` — workbench entry, stable editable triage and responsive expandable
  management queue; and
- `PLAT-SUPPORT-03B` — internal next action, tracked activity dates, P1 chronology and
  filter/count alignment.

Both slices share one combined local human gate because editable triage, activity evidence
and management presentation are one operator workflow.

Implementation and gate:

- [`PLAT-SUPPORT-03A/03B local implementation`](../04-implementation-confirmations/2026-08-11-isostack-platform-plat-support-03a-03b-p1-workbench-and-case-tracking-implementation.md)
- [`combined local human smoke`](../05-review-and-test/2026-08-11-isostack-platform-plat-support-03a-03b-combined-local-review-and-smoke-gate.md)
