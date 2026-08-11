# PLAT-SUPPORT-03 P1 Operational Dashboard And Classification Planning

Date: 2026-08-10

Status: **DELIVERED AND CORRECTED BY 03A/03B IN EXACT `cde4eaff`, ALIGNED THROUGH MAIN;
LOCAL/STAGING HUMAN GATES, ALL PROTECTED SCANS AND PUBLIC HEALTH CHECKS PASS; PRODUCTION
RENDER IDENTITY PENDING FOR CLOSURE**

Accepted triage:

[`Support Ticketing client-readiness triage`](../02-triage/2026-08-10-isostack-platform-support-ticketing-client-readiness-triage.md)

## 1. Objective

Give P1 one reliable operational view of all authorised support tickets: exact lifecycle
balances, first-review aging, useful classification, composable filters and functional
server-side search, with every card and summary representing the same population as the
ticket table.

## 2. P1 Management Contract

The P1 dashboard population is cross-tenant under explicit P1 authority. Active filters
apply identically to:

- table rows and pagination;
- every lifecycle count;
- unreviewed count and aging buckets;
- oldest-unreviewed summary; and
- search results.

Required lifecycle balances are independent counts for:

```text
Open
In Progress
Waiting for Response
Resolved
Closed
Total
```

`closed` must never be inferred as `total - other selected states`.

## 3. Classification Contract

P1 owns final operational classification:

| Field | Initial values | Meaning |
| --- | --- | --- |
| Severity | Critical, High, Medium, Low | Degree of product/service degradation |
| Impact | Individual, Multiple Users, Tenant-wide, Multi-tenant | Breadth of affected users/organisations |
| Priority | Existing Low, Medium, High, Urgent | P1 scheduling/response ordering |
| Category | Technical, Billing, Feature Request, Other | Canonical request type shared with routing |
| Module | Canonical module slug/Core | Product area used for filtering/reporting |

Severity and Impact are nullable for historic/untriaged rows. Clients do not author their
final values. Priority is not automatically calculated from Severity and Impact in this
slice.

## 4. Review And Aging Contract

- `createdAt` is ticket age;
- first review is recorded once when P1 deliberately opens the detail for review through an
  idempotent server operation;
- the record retains `firstReviewedAt` and the reviewing P1 actor or equivalent audit link;
- client views, automated notifications and incidental updates never mark first review;
- `updatedAt` is not used as a substitute; and
- the initial descriptive buckets are `<1 day`, `1–3 days`, `3–7 days`, `>7 days`.

These buckets are management information, not a contractual SLA. Threshold constants must
be named and testable so a later operating-policy decision can change them deliberately.

## 5. Filters, Search And Presentation

Provide composable server-side filters for:

- Client;
- Status;
- Severity;
- Impact;
- Module;
- Category; and
- reviewed/unreviewed state where practical within the same query contract.

Search must work server-side with pagination for exact ticket number and safe text matching
across title, requester identity and organisation name. Description search may be included
only if its query/index cost is acceptable at inspected volumes.

P1 filter state survives opening/closing a ticket and mutations. Empty, loading and error
states must be explicit. Mobile presentation must keep lifecycle balance, age and primary
classification readable without relying on hover.

## 6. Data And Migration

A bounded migration is expected for canonical Severity, Impact and first-review facts.
Planning implementation must:

- inventory distinct existing status, priority, category and module values read-only;
- map known legacy category casing safely;
- retain unknown historic values through an explicit compatibility outcome rather than
  dropping tickets;
- add indexes justified by the P1 cross-tenant filter/count queries;
- backfill no invented first-review timestamp; historic rows remain unreviewed until P1
  reviews them after release; and
- provide forward and recovery verification for the migration.

Do not rewrite discussion history or create synthetic SLA evidence.

## 7. Implementation Boundary

Likely application areas:

```text
prisma/schema.prisma
prisma/migrations/<bounded-support-dashboard-migration>/migration.sql
src/server/core/routers/support.router.ts
src/app/(platform)/platform/_components/SupportTicketsTab.tsx
focused support router/query/UI tests
```

The large P1 component may be split into bounded presentation components if that materially
improves testability, but this is not authority for a general UI rewrite.

## 8. Automated Acceptance

Prove:

1. a P1 unfiltered query counts every lifecycle state independently across authorised
   tenants;
2. each Client/Status/Severity/Impact/Module/Category combination returns the same
   population in rows, counts and aging;
3. waiting-response is never counted as closed;
4. first P1 review is recorded once and never overwritten by later reviewers;
5. a client read or notification does not mark a ticket reviewed;
6. oldest-unreviewed and every aging bucket are deterministic at boundary timestamps;
7. exact ticket-number and text search compose with filters and pagination;
8. historic null classification remains visible and filterable as unclassified where
   required;
9. P1 classification changes are audited and unauthorised clients are refused directly;
10. query plans/indexes are acceptable at a triage-approved representative volume; and
11. mutations invalidate or refresh every affected count/summary without losing filters.

Run migration checks on a disposable database, focused tests, full relevant tests,
type-check, changed lint, verification, production build and Security Scan.

## 9. Human P1 Gate

Using known non-sensitive tickets across at least two tenants:

1. reconcile every unfiltered lifecycle card to the visible/queryable balance;
2. apply each essential filter alone and in representative combinations;
3. confirm cards, table, total, unreviewed count and aging change together;
4. open an unreviewed ticket and confirm first-review age resolves once;
5. reopen it and confirm the original review timestamp/actor remains;
6. set Severity, Impact and Priority and confirm their distinct values persist;
7. test exact ticket number, requester and organisation search;
8. mutate status/comment and confirm counts refresh without filter loss;
9. inspect empty/error/loading states and mobile layout; and
10. confirm a C1 user cannot access P1 reporting or classification operations.

## 10. Estimate, Recovery And Stop

Focused estimate: **4–6 development days**, including migration, tests and documentation.

Recovery requires application revert plus the migration's accepted rollback/forward-repair
procedure. Stop on invented historic review evidence, cross-tenant client exposure,
unbounded free-text search cost, contractual SLA requirements or a request to combine
Platform Notices with ticket counts.

## 11. Implementation Disposition — 2026-08-10

Local implementation is recorded at the
[`PLAT-SUPPORT-03 implementation confirmation`](../04-implementation-confirmations/2026-08-10-isostack-platform-plat-support-03-p1-operational-dashboard-and-classification-implementation.md).
The bounded additive migration is applied and verified on the distinct local-development
database. No classification or first-review evidence was invented. Operational count,
filter, search, aging, persistence and responsive presentation remain the P1 portion of the
[`combined local smoke gate`](../05-review-and-test/2026-08-10-isostack-platform-support-ticketing-combined-local-review-and-smoke-gate.md).
