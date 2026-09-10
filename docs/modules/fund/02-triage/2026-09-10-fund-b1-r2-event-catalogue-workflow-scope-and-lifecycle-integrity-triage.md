# FUND B1-R2 — Event Catalogue Workflow Scope And Lifecycle Integrity Triage

Date: 2026-09-10

Disposition: **Accepted and implemented as a blocking correction inside B1; human acceptance pending.**
Control depth: **High** — Catalogue workflow eligibility, Event authority, schema migration,
concurrency and immutable commercial evidence are affected.

Source: [CR-Fix](../01-cr-inputs/CR-Fix-2026-09-10-fund-event-catalogue-workflow-scope-and-lifecycle-integrity.md).
[Root control](../../../00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md)
retains B1 as `Now`; [FUND control](../00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md)
selects this as the next correction within that outcome. It does not select `1R-G` or create a
second portfolio `Now`.

## Triage Decision

The Catalogue-led Product decision remains valid. The missing distinction is between:

- **channel availability** — Event, standalone, both or internal; and
- **workflow scope** — the subset of the four workflows supported by the Catalogue.

Workflow scope belongs on the Catalogue rather than the Product because C1 curates a compatible
range once and can change that range without revisiting every Product. Event assignment then
chooses from compatible ranges; a standalone Project receives compatible standalone ranges
without another assignment gate.

The Event Products tab is pulled forward from `2R-EVENT-05` because the B1 smoke demonstrated a
current management gap, and because it can reuse the exact Event-Catalogue mutation model rather
than introduce a second source of truth. Product membership and Catalogue scope remain owned by
Product/Catalogue management.

The Event transition behaviour is a separate lifecycle defect discovered in the same Event
management walkthrough. Correct it in B1-R2 because an Event Products surface would otherwise
offer new management context on top of invalid close/archive authority. Archive becomes a
strict `CLOSED -> ARCHIVED` action. Close is `ACTIVE -> CLOSED` only when no linked Project is
`ACTIVE`.

## Blocker And Data Position

B1 human testing is paused after steps 5–7. B1-R2 must be implemented and reviewed before that
schedule resumes. Existing B1/B1-R1 automated evidence remains valid within its exact scope; it
does not prove the new Catalogue or Event rules.

Chris confirms there are no FUND users requiring data remediation and permits recreation of the
development FUND test bed. Existing Catalogues should nevertheless migrate to all four workflows
to preserve current behaviour until C1 narrows them deliberately. Staging requires a versioned,
reviewed migration; shared non-FUND data must not be reset.

## Delivery Shape

Plan one coherent B1-R2 candidate with four ordered work packages:

1. Catalogue workflow-scope schema, migration and authoritative eligibility filters.
2. Event Products tab reusing Event-Catalogue services, with contributed-Product visibility.
3. Event lifecycle service/UI correction with concurrency-safe linked-Project checks.
4. Catalogue Product status clarity, then automated, connected and human proof.

Do not release a UI-only filter ahead of server eligibility, or hide invalid lifecycle buttons
without enforcing the same rule in the mutation service. Split only if implementation review
finds an independent release boundary that does not create inconsistent authority.

## Gates And Safe Continuation

The [bounded plan](../03-slice-planning/2026-09-10-fund-b1-r2-event-catalogue-workflow-scope-and-lifecycle-integrity-planning.md)
defines the implementation contract. Implementation requires owner authority, then 04
confirmation, independent 05 review/test, resumed C1/C2 human smoke and controlled environment
promotion. No application, database or environment mutation is performed by this triage.
