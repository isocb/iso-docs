# FUND CR Input - Commission Ladder Planner

Date: 2026-07-13

Status: Planning input

## 1. Purpose

Capture the C1 Commission Ladder Planner requirement so it is considered during FUND
Phase 1 Store, Orders and Commerce planning before schema, service, API or UI work begins.

This is a planning and documentation input only. It must not trigger implementation until
the proposed model and scope have been reviewed and accepted.

## 2. Business Concept

Commission may be configured in one of two ways:

1. A flat commission rate applying throughout an Event or Project.
2. A stepped commission ladder configured by the C1 administrator for an Event.

The commission ladder is intended to encourage earlier activity. The highest commission
rate is offered earlier in the Event or Project lifecycle, with the rate reducing as the
relevant closing date approaches.

Each ladder step should define:

- the commission rate available at that step;
- when that rate ceases to apply;
- the next, lower commission rate that takes effect.

## 3. Timing Method

A commission ladder must use one, and only one, of these timing methods:

- `OFFSET_BASED`: a specified number of days before the relevant closing date;
- `FIXED_DATE`: on or before a specified calendar date.

The two timing methods must not be mixed within the same ladder.

## 4. Inheritance And Scope Questions

Planning must assess and document:

- whether the ladder should belong to the Event, with linked Projects inheriting it;
- whether a Project may override the Event ladder or use a flat rate instead;
- which closing date should control offset calculations when a Project closes earlier than
  its Event;
- what commission applies after the final ladder threshold has passed;
- how the applicable ladder version and aggregate Project sales calculation basis are fixed
  so that later ladder changes do not alter historical commission reporting;
- how draft, active and archived ladders should be managed;
- what validation is required to prevent overlapping, duplicated or incorrectly ordered
  steps.

## 5. Required Planning Boundary

The planning review must distinguish between:

- ladder configuration by C1;
- buyer-facing Order/Order-line sales evidence;
- aggregate Project sales calculation against the applicable ladder;
- later commission accounting, reporting, adjustment and payment.

Planning must also decide whether aggregate commission is evaluated at:

- Store close;
- Project close;
- payment-total reporting cut-off;
- production/dispatch milestone;
- another explicitly defined accounting or recognition event.

Non-negotiable:

```text
Later ladder changes must not alter historical commission reporting for already closed or
accounted Project sales periods.
```

Clarification:

```text
Commission is not calculated as a final independently rounded payable amount on each Store
transaction. Order lines provide sales evidence; commission payable is calculated from
aggregate Project sales against the applicable Project/Event ladder to avoid cumulative
rounding discrepancies.
```

## 6. Roadmap Update Request

Please:

1. Review the existing FUND roadmap and related commission, Event, Project and commerce
   planning documents.
2. Recommend the appropriate phase and slice for the Commission Ladder Planner.
3. Describe its dependencies on Events, Projects, Stores, Orders and commission accounting.
4. Define a sensible implementation boundary and, if appropriate, split it into
   schema/service and UI slices.
5. Update the roadmap and any relevant control or planning documentation.
6. Do not expand into implementation until the proposed model and scope have been reviewed.

## 7. Initial Position

This input promotes `2R-PROD-05` from a parked Phase 2 wishlist item into an explicit
Phase 1 Store/Orders/Commerce planning dependency.

The likely planning position is:

- use `1R-A` to confirm the ladder's architecture and snapshot boundaries;
- keep implementation out of `1R-A`;
- introduce later `1R` implementation slices only after Store/Order snapshot requirements
  are accepted;
- keep Commission Ladder Planner configuration separate from commission accounting and
  payment/settlement workflows.
