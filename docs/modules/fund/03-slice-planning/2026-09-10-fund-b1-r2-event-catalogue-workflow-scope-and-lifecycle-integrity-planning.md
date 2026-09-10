# FUND B1-R2 — Event Catalogue Workflow Scope And Lifecycle Integrity Planning

Date: 2026-09-10

Status: **Implemented locally at `29104b55`; automated/connected proof PASS; human acceptance pending.**
Control depth: **High**. Work type: production-model correction.

Authority: [CR-Fix](../01-cr-inputs/CR-Fix-2026-09-10-fund-event-catalogue-workflow-scope-and-lifecycle-integrity.md)
-> [triage](../02-triage/2026-09-10-fund-b1-r2-event-catalogue-workflow-scope-and-lifecycle-integrity-triage.md)
-> [FUND roadmap](../00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md).
The [B1 controlling plan](2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-journey-development-plan.md)
retains the only restart checkpoint.

## 1. Visible Outcome

C1 can open an Event, choose its Products tab and assign compatible Catalogues without leaving
Event management. The same Event assignments remain manageable from Product/Catalogue
Availability. Catalogues state both their channel availability and supported workflows, so an
Event or standalone Project sees only the ranges appropriate to its workflow. Event close and
archive actions preserve linked-Project lifecycle integrity.

## 2. Fixed Decisions

| Item | Decision |
| --- | --- |
| Product workflow | Product remains workflow-neutral; no Product suitability control returns |
| Catalogue channel scope | Retain `EVENT_ONLY`, `STANDALONE_ONLY`, `EVENT_AND_STANDALONE`, `INTERNAL_ONLY` |
| Catalogue workflow scope | Required multi-select using the four `FundProjectType` values; general default is all four |
| Existing Catalogue migration | Backfill all four workflows to preserve current source visibility |
| Event source | Event-capable + workflow-compatible + explicitly Event-assigned Catalogue |
| Standalone source | Standalone-capable + workflow-compatible Catalogue union; no per-Project Catalogue gate |
| Event Products tab | Manages Event-Catalogue assignment and displays contributed Products; no Catalogue/Product editing |
| Draft Product membership | Allowed for preparation, visibly draft and excluded from Project eligibility |
| Event archive | Only `CLOSED -> ARCHIVED` |
| Event close | Only `ACTIVE -> CLOSED`, refused while any linked Project is `ACTIVE` |
| Historical evidence | Finalised offers and Orders remain immutable; current source contraction can block future action |

An empty workflow selection is invalid for every Catalogue. Internal Catalogues retain the same
workflow vocabulary so a later channel change cannot accidentally expose an unclassified range.

## 3. Schema And Migration Contract

Add a required `FundProjectType[]` workflow-scope field to `FundCatalogue`, mapped to a named
database column. Prefer a native enum array over a join table: the vocabulary is the same fixed
four-value enum already used by Event/Project authority, the set is small, there is no per-row
metadata, and one Catalogue update should replace the complete set atomically.

The versioned migration must:

1. add the non-null array with all four values as the database default;
2. backfill every existing Catalogue with all four values;
3. add a database check which rejects an empty array;
4. leave Product, Catalogue membership, Event assignment, Project selection, offer and Order
   rows unchanged;
5. support fresh and 155-to-next upgrade paths with inspected SQL and ledger readback.

Application validation must reject duplicates/unknown values, canonicalise to the fixed registry
order and require at least one value for selling channels. Catalogue create defaults to all four;
Catalogue update and channel-scope update enforce the invariant together. Schema/API serializers
return the exact workflow set.

## 4. Eligibility And Availability Authority

Use the existing tenant availability advisory lock. Catalogue workflow-scope edits are exclusive
availability writes because they may remove the last Product source. Canonical Event and
standalone eligibility reads remain shared operations and must filter at the Catalogue source:

```text
Event source Catalogue
  current + ACTIVE
  AND channel is EVENT_ONLY or EVENT_AND_STANDALONE
  AND Catalogue workflows contain Event.projectType
  AND active Event-Catalogue assignment is in window

Standalone source Catalogue
  current + ACTIVE
  AND channel is STANDALONE_ONLY or EVENT_AND_STANDALONE
  AND Catalogue workflows contain Project.projectType
```

Event assignment mutation re-reads the locked Event and every submitted Catalogue. It refuses a
Catalogue that does not support the Event workflow or Event channel. A later Catalogue workflow
contraction may leave an existing assignment row for audit/context, but it becomes ineligible;
the Event Products UI must show it as incompatible and require removal rather than conceal it.
Current Project selections, Store refresh, offer finalisation and checkout then use B1-R1's
last-source protection. No locked offer or Order snapshot is rewritten.

Changing an Event workflow remains refused after any linked Project, so existing assignments do
not need implicit reclassification. Catalogue scope changes report affected Event/source context
where inexpensive and invalidate eligibility caches.

## 5. Event Products Tab

Add `Products` beside Overview and Linked Projects on `/app/fund/events/[id]`. It is a C1 Event
planning surface with:

- the Event's fixed workflow and channel explanation;
- compatible active Event-capable Catalogues as selectable rows;
- assigned state, Catalogue code/name, channel scope and Product counts;
- an expandable/read-only Product list showing Product code/name/status and membership state;
- a warning for assigned Catalogues that have become inactive, archived, channel-incompatible or
  workflow-incompatible;
- one Save action using the existing `fund.availability.setEventCatalogues` mutation;
- cache invalidation for Event detail, Availability summary/assignment and Product eligibility.

The tab must not edit Catalogue channel/workflow scope, Catalogue Product membership, Product
status, C2 Project Product selection, price, media or Store readiness. Provide a clear link to
Product/Catalogue management for those tasks. Keep the existing Availability screen and its
scope controls; both surfaces must read/write the same Event-Catalogue records.

The server response should supply the Event-specific candidate list and contributed Product
summaries directly, rather than making the browser infer authority from a tenant-wide Catalogue
list. Cross-tenant Event/Catalogue/Product records return no data and cannot be submitted.

## 6. Event Lifecycle Integrity

Replace the Event transition map with the strict forward path:

```text
DRAFT -> ACTIVE
ACTIVE -> CLOSED
CLOSED -> ARCHIVED
ARCHIVED -> DRAFT (existing explicit restore)
```

Before close, take the declared Event row lock and check same-tenant linked Projects. Refuse with
`PRECONDITION_FAILED` when any linked Project has `status = ACTIVE`, including a concrete count
and safe instruction to pause/close/complete those Projects first. Archive is refused unless the
locked Event is `CLOSED`; linked active Projects are therefore also impossible through the normal
path.

Project creation/linkage and Project activation must participate in the same Event lifecycle
serialization boundary. Under the locked Event, creation/link refuses `CLOSED/ARCHIVED`; Project
activation rechecks that a linked Event is `ACTIVE`. The close transaction and these Project
transactions must acquire locks in one declared order so a concurrent action cannot commit an
active Project under a closed Event. Retry serialisation conflicts within the existing bounded
policy and return a clear safe failure otherwise.

UI actions mirror server facts:

- DRAFT shows Activate only;
- ACTIVE shows Close; disable it with an active-Project explanation when detail has a reliable
  active count, while still relying on the server;
- CLOSED shows Archive;
- ARCHIVED shows Restore.

The linked Projects tab shows enough status context for C1 to resolve the blocker.

## 7. Product And Membership State Clarity

In Catalogue Product management:

- include Product status in the add option label and show a preparation warning when a draft
  Product is selected;
- rename the table's ambiguous `Status` column to `Product status` and render the Product's
  `DRAFT/ACTIVE/ARCHIVED` badge;
- retain a separate `Membership` control/badge for active/inactive Catalogue membership;
- state that active membership does not activate a Product;
- allow draft Product membership so a Catalogue can be prepared before Product activation;
- continue to exclude draft/archived Products from Project eligibility on the server.

Do not silently activate a Product when it is added to an active Catalogue.

## 8. Source Inventory

| Area | Expected source |
| --- | --- |
| Schema/migration | `prisma/schema.prisma`; one new reviewed migration |
| Catalogue validation/service/UI | `lib/validation/products-catalogues.ts`, `services/catalogues.service.ts`, `components/catalogues/CatalogueModal.tsx` |
| Availability service/UI | `services/availability.service.ts`, router/validation, `components/availability/AvailabilityManager.tsx` |
| Eligibility/downstream | `services/product-eligibility.service.ts`, Store refresh/finalisation/checkout tests |
| Event service/UI | `services/events.service.ts`, `components/events/EventDetailPage.tsx`, Event router/validation |
| Project lifecycle | C1/C2 Project create/link/activate services and their existing authority tests |
| Evidence | new focused unit/integration/concurrency proof plus B1-R1 regression suites |

Search all raw Catalogue queries and direct Event/Project status writes before implementation;
this inventory is not permission to leave an indirect path unreviewed.

## 9. Verification And Failure Boundaries

Automated proof must include:

- fresh and 155-to-next migration, exact schema/constraint/ledger readback and non-FUND count
  preservation;
- create/update validation for all-four, subset, duplicate and invalid empty workflow scopes;
- one Product in several differently scoped Catalogues, deduplicated correctly;
- four Event workflows and four standalone workflows, with positive and negative Catalogue
  filtering;
- cross-tenant Event assignment and stale/incompatible submissions refused;
- workflow/channel contraction while a Product has one source and multiple sources;
- selected Product becomes unavailable without deletion; restoration does not override C2
  exclusion;
- finalised offer and Order snapshots unchanged after contraction;
- DRAFT/ACTIVE Event archive refused, CLOSED archive accepted;
- close with no active Projects accepted; close with one or several active Projects refused;
- close racing Project activation/linkage cannot commit an invalid pair;
- Event Products and Product/Catalogue Availability reflect the same assignment after mutation;
- draft Product membership visible as draft and absent from C2 eligibility;
- type check, production build, focused lint, FUND tests, critical-file verification,
  whitespace and credential-pattern scan.

Failure before migration completion must leave the old schema/application pair usable. Failure
after schema deployment stops application promotion; do not run old B1-R1 source against the new
schema if the generated client contract is incompatible. No staging/live migration or deployment
is part of local implementation acceptance.

## 10. Human Smoke And Acceptance

Resume the B1-R1 schedule from the paused point after B1-R2 automated/connected proof:

1. Configure one Catalogue for all workflows and another for one workflow; verify Event and
   standalone candidates for all four workflows.
2. From Event Products, assign compatible Catalogues and inspect contributed active/draft
   Products; confirm the Availability screen shows the same assignments.
3. Attempt to submit an incompatible Catalogue through stale UI/API and confirm refusal.
4. Add a draft Product to an active Catalogue and confirm Product status and membership state are
   distinct; activate it and confirm C2 eligibility changes.
5. Confirm DRAFT and ACTIVE Events cannot archive.
6. Confirm an ACTIVE Event with an ACTIVE linked Project cannot close; resolve the Project and
   then close and archive the Event in order.
7. Continue B1-R1 source withdrawal, finalised-offer and immutable-Order checks.

Record exact candidate, role/tenant, database fingerprint, time and PASS/FAIL. Human acceptance
does not promote the candidate.

## 11. Do Not Build

- Product workflow or Product suitability fields;
- per-Project Catalogue assignment for standalone Projects;
- Catalogue definition or Product membership editing inside Event detail;
- Event-specific Product overrides;
- automatic Product activation;
- automatic Project close/pause when an Event closes;
- reopening a closed Event or unarchiving directly to active;
- offer unlock, repricing, Order mutation, refund or production exception workflow;
- public Store, payment/provider or 1R-G implementation;
- staging/live migration or environment promotion.

## 12. Stopping Point

Application `29104b55`, the versioned migration and 04/05 records now form the local candidate.
Stop for independent review and the resumed human smoke.
Do not promote to dev/staging/main or apply the migration beyond the identified local DevData
target without the later controlled-promotion gate.
