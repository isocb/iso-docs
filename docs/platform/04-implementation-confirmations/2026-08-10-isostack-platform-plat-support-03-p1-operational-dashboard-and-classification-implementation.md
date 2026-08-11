# PLAT-SUPPORT-03 P1 Operational Dashboard And Classification Implementation

Date: 2026-08-10

Status: **DELIVERED AND CORRECTED BY 03A/03B IN EXACT `cde4eaff`, ALIGNED THROUGH MAIN;
LOCAL/STAGING HUMAN GATES, ALL PROTECTED SCANS AND PUBLIC HEALTH CHECKS PASS; PRODUCTION
RENDER IDENTITY PENDING FOR CLOSURE**

Plan:

[`PLAT-SUPPORT-03 planning`](../03-slice-planning/2026-08-10-isostack-platform-plat-support-03-p1-operational-dashboard-and-classification-planning.md)

Combined review/gate:

[`Support Ticketing combined local review and smoke gate`](../05-review-and-test/2026-08-10-isostack-platform-support-ticketing-combined-local-review-and-smoke-gate.md)

## 1. Delivered Outcome

The P1 Support Tickets dashboard now uses one composable server query contract for rows,
lifecycle balances and unreviewed aging. It provides independent balances for Open, In
Progress, Waiting Response, Resolved, Closed and Total; `closed` is never calculated as a
remainder.

Composable filters cover Client, Status, Severity, Impact, Module, canonical Category,
reviewed/unreviewed and server-side search. Exact ticket number, title, requester and
organisation searches compose with the other filters and pagination.

P1 can assign:

- Severity: Critical, High, Medium or Low;
- Impact: Individual, Multiple Users, Tenant-wide or Multi-tenant;
- the existing Priority; and
- canonical Category and lifecycle status.

Historic nullable classification remains visible as untriaged rather than being invented.
The first deliberate P1 detail open calls an idempotent server mutation which stores
`firstReviewedAt` and `firstReviewedById` once. Client reads, notifications and later P1
opens do not replace that evidence.

The dashboard adds unreviewed total, oldest-unreviewed warning and descriptive `<1 day`,
`1–3 days`, `3–7 days`, `>7 days` buckets. These are management indicators, not a promised
SLA. Loading, empty/error states and primary data use responsive layouts.

## 2. Migration And Historic Data

Migration `20260810150000_platform_support_ticket_client_readiness` adds:

- nullable `SupportSeverity` and `SupportImpact` enums;
- nullable first-review time/actor fields;
- requester support shared with `PLAT-SUPPORT-01/02`;
- five bounded indexes for tenant/status, review aging, Severity/Impact, Module/Category and
  requester access; and
- safe normalisation of known category spellings while retaining every unknown value for P1
  review.

No historic first-review timestamp, Severity or Impact is invented. No ticket or discussion
is deleted.

The migration was applied only to a database proven distinct from the shared `.env` target.
The new verifier confirmed all expected columns, eight enum values, five indexes and both
routing-test evidence columns. A separately configured disposable US Neon target was
unavailable to Prisma's schema engine, so no claim is made for that target; the validated
local-development migration and schema verification are the current evidence boundary.

## 3. Principal Implementation

- `prisma/schema.prisma` and the two bounded migrations;
- `scripts/run-prisma-on-local-dev-database.ts` — refuses migration commands when local and
  shared database identities match and permits only status/deploy;
- `scripts/verify-platform-support-ticket-schema.ts` — distinct-target schema/index/enum
  verification;
- `src/server/core/routers/support.router.ts` — filter-consistent rows, balances, aging,
  search, classification and idempotent first review; and
- `SupportTicketsTab.tsx` — operational cards, filters, triage fields and responsive detail.

## 4. Recovery And Gate

The application can roll back while retaining nullable additive columns and indexes. A
destructive database down migration is not authorised. The P1 human gate must reconcile
known tickets across at least two tenants, filters, lifecycle cards, first-review stability,
classification persistence, search and responsive presentation before a shared promotion
is proposed.

That original P1 gate exposed the route, editing, presentation and case-tracking gaps now
owned by 03A/03B. The corrective implementation and 24/24 local human gate pass. The full
Support result is committed at exact `cde4eaff1e14b2f02ba0953fe8693e7feb02bb61`, aligned
through main with all exact scans and public health green; only production Render identity
remains in the shared closure gate.
