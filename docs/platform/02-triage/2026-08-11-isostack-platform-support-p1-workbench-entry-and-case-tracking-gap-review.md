# Platform Support P1 Workbench Entry And Case-Tracking Gap Review

Date: 2026-08-11

Status: **HISTORICAL GAP REVIEW COMPLETE; CORRECTIVE 03A/03B DELIVERED IN EXACT
`cde4eaff`, NOW ALIGNED THROUGH MAIN; USE THE PRODUCTION CLOSURE RECORD FOR CURRENT STATE**

Evidence:

[`Support Ticketing combined local smoke`](../05-review-and-test/2026-08-10-isostack-platform-support-ticketing-combined-local-review-and-smoke-gate.md)

## 1. What Happened

The P1 tester used `/support`, reached through the P1 sidebar item labelled `Support
Tickets`. That is the client-facing support surface and explains the observed C1/Member
modal, limited filters and absence of P1 internal-note/classification controls.

The separate P1 implementation is present at
`/platform?tab=support&subtab=tickets`. The P1 sidebar route and the smoke instructions did
not direct the tester there. This is a genuine integration and test-design defect, not proof
that the whole P1 dashboard implementation is absent.

## 2. Missed Outcomes

| Finding | Classification | Consequence |
| --- | --- | --- |
| P1 `Support Tickets` sidebar link targets `/support` | Remedial navigation defect | P1 is led to the client workflow and cannot discover the workbench |
| Human gate did not state the canonical P1 URL | Remedial evidence defect | A correct test could be performed on the wrong surface |
| P1 queue is cards although the plan names table rows | PLAT-SUPPORT-03 implementation/presentation variance | The expected scannable, expandable management table is not delivered |
| Status/classification/internal-note controls | Already implemented in the correct P1 workbench | Must be retested at the canonical route, not rebuilt on assumption |
| Created and first-review aging | Already implemented | Retain and reconcile at the canonical route |
| Next-action/response-due date and activity chronology | Requirements gap; not in accepted schema/plan | Requires explicit operational semantics, schema/migration and new filters |

## 3. Recommended Control

Create one corrective child CR under the existing Support Ticketing CR, but deliver it in
two bounded slices:

### PLAT-SUPPORT-03A — P1 Workbench Entry And Queue Presentation

- route the non-impersonating P1 `Support Tickets` navigation item to the canonical P1
  workbench;
- retain `/support` as the client ticket surface;
- make P1/client context unmistakable in headings and test instructions;
- present the desktop P1 queue as a readable table with expandable detail, with a stacked
  accessible equivalent at narrow widths;
- retain filters while opening/closing rows and mutations; and
- rerun existing items 6–8, 15, 17 and 21–30 before inventing missing code.

This is a small corrective slice and should require no schema change.

### PLAT-SUPPORT-03B — Operational Case Dates And Activity Chronology

Plan only after settling the exact business meanings of:

- `nextActionAt`: a nullable P1-owned follow-up date/time;
- whether a short `nextAction` description/owner is required;
- whether `responseDueAt` is distinct from next action or would incorrectly imply a
  contractual SLA;
- derived last-client-response, last-P1-response and last-activity timestamps;
- which lifecycle/classification changes appear in the visible activity chronology;
- overdue/next-action filters and counts; and
- closure/reopen behaviour for outstanding dates.

This slice requires schema/migration, server validation, audit/activity decisions,
filter/count consistency and a new human date-boundary matrix. Historic dates must not be
invented.

## 4. Estimate And Risk

Indicative focused effort:

- `03A`: 0.5–1.5 development days plus rerun;
- `03B`: 2–4 development days after semantics are accepted; and
- combined technical/human regression: 0.5–1 day.

The principal risk is treating `response due` as an informal UI date without deciding
whether it is an internal target, client promise or SLA. The safe default is an internal
P1 next-action date until a separate response-policy contract is deliberately accepted.

## 5. Immediate Recommendation

First open the canonical P1 workbench and perform a short discovery smoke. If its existing
filters, triage controls, internal notes and aging work, preserve that evidence and scope
`03A` to navigation/table usability. Accept `03B` only after the date semantics above are
confirmed. Do not discard the already green privacy and routing evidence, and do not promote
the Support candidate before the corrective gate passes.
