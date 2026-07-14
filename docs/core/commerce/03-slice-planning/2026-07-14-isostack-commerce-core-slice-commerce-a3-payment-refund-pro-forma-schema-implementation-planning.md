# IsoStack Commerce Core Slice COMMERCE-A3 - Payment, Refund And Pro-forma Schema Implementation Planning

Date: 2026-07-14

Status: Implemented and reviewed as passed at application commit `4a90be1`

Parent architecture:

`docs/core/commerce/02-triage/2026-07-13-isostack-commerce-core-schema-foundation-planning.md`

Parent controls:

- `docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`
- `docs/core/commerce/00-roadmap-control/2026-07-13-commerce-core-roadmap-and-slice-control.md`

Completed prerequisites:

- `COMMERCE-A1` commerce namespace, Seller Profile and stable enums;
- `COMMERCE-A2` Checkout, Order and Order-line schema foundation;
- FUND `1R-C6` typed Order/line context;
- FUND Store `1R-D` internal readiness/configuration services.

## 1. Goal

Add the provider-neutral persistence foundation for payment attempts, append-only refund
evidence and a separate pro-forma document lifecycle without implementing any payment or
provider behavior.

The bounded evidence chain is:

```text
Commerce Order
-> zero or more Commerce Payments
-> zero or more Refund records per Payment
-> exactly one optional Pro-forma record per PRO_FORMA_INVOICE Payment
```

Order, payment, refund and pro-forma states remain independent. Later services must apply
their transitions atomically; A3 only makes valid evidence shapes representable and
rejects structurally impossible rows.

## 2. Entry Baseline And Migration Boundary

Implementation begins only from:

```text
application dev: db85fcc
origin/dev:       3206199
Prisma history:   137 applied / 0 failed
latest migration: 20260714235900_fund_1r_c6_commerce_context_foundation
```

A3 adds one bounded migration, advancing the inventory from 137 to 138. It must:

- create four Commerce-prefixed enums and three `commerce` tables;
- add only reverse Prisma relations and supporting composite keys required for exact A3
  ownership;
- create no Payment, Refund or Pro-forma row;
- alter no existing Order, Order-line, FUND or LMSPro value;
- add no provider event/idempotency/audit table reserved for A4.

## 3. Accepted Enum Vocabulary

### 3.1 `CommercePaymentRoute`

```text
STRIPE_ONLINE
PRO_FORMA_INVOICE
```

This preserves the accepted first-pass business routes. Stripe is vocabulary only in A3;
no Stripe SDK, account, API, webhook or secret is introduced.

### 3.2 `CommercePaymentStatus`

```text
NOT_REQUIRED
PENDING
PAID
FAILED
CANCELLED
PARTIALLY_REFUNDED
REFUNDED
```

Payment status does not change `CommerceOrder.status`.

### 3.3 `CommerceRefundStatus`

```text
REQUESTED
PROCESSING
COMPLETED
FAILED
CANCELLED
```

`COMPLETED`, rather than provider-specific wording, is the generic successful refund
outcome. Refund rows are retained evidence; failed/cancelled attempts are not overwritten
or deleted.

### 3.4 `CommerceProFormaStatus`

```text
DRAFT
ISSUED
ACCEPTED
CANCELLED
SETTLED
```

`SETTLED` means C1 has recorded receipt of the corresponding offline/manual payment. It is
not an Order state and does not itself execute a payment transition in this slice.

## 4. `CommercePayment`

Purpose: one provider-neutral payment request/attempt/outcome attached to one exact Order.

Fields:

```text
id
organizationId
orderId
route
status
currency
amountRequestedMinor
amountPaidMinor
amountRefundedMinor
providerCode?
providerAccountReference?
externalCheckoutReference?
externalPaymentReference?
externalSessionReference?
safePayloadReference?
safePayloadHash?
initiatedAt?
paidAt?
failedAt?
cancelledAt?
createdById?
updatedById?
createdAt
updatedAt
```

Contract:

- Organization, Order and currency share one exact composite database relation;
- one Order may have several attempts;
- currency is uppercase ISO-style three-letter evidence and physically matches the Order;
- amounts are bounded non-negative minor units;
- paid cannot exceed requested and refunded cannot exceed paid;
- `NOT_REQUIRED`, `PENDING`, `PAID`, `FAILED`, `CANCELLED`, `PARTIALLY_REFUNDED` and
  `REFUNDED` each have exact amount/timestamp shapes;
- successful paid/refunded states require `amountPaidMinor = amountRequestedMinor`;
- partial refund requires `0 < refunded < paid`; full refund requires `refunded = paid`;
- `STRIPE_ONLINE` requires a bounded uppercase provider code;
- `PRO_FORMA_INVOICE` has no provider code/account/external provider references;
- external references remain optional because A3 creates no provider session;
- non-null provider references receive tenant/provider-scoped partial uniqueness;
- safe payload fields are opaque references/hashes only and may contain no secret payload.

The schema does not require the sum of Payment attempts to equal the Order total. That is
an A5 service/reconciliation responsibility.

## 5. `CommerceRefund`

Purpose: append-only refund attempt/outcome evidence for one exact Payment and its exact
Order/currency.

Fields:

```text
id
organizationId
orderId
paymentId
currency
amountMinor
status
reasonCode
reasonNotes?
providerRefundReference?
requestedAt
processingAt?
completedAt?
failedAt?
cancelledAt?
requestedById?
completedById?
createdAt
updatedAt
```

Contract:

- the composite Payment relation proves tenant, Order and currency together;
- amount is greater than zero and bounded to the platform minor-unit range;
- reason code uses bounded uppercase system vocabulary while optional notes retain human
  context;
- each status has exact lifecycle timestamps and terminal timestamps are mutually
  exclusive;
- provider refund reference is optional and unique within its owning Payment when present;
- database rows do not allocate refunds to Order lines in A3;
- aggregate completed refunds versus Payment paid/refunded totals are reconciled later in
  one A5 transaction.

No hard-delete service is introduced. Restrictive foreign keys preserve completed and
failed refund history.

## 6. `CommerceProFormaInvoice`

Purpose: a separate manual/pro-forma document lifecycle for one exact
`PRO_FORMA_INVOICE` Payment and Order.

Fields:

```text
id
organizationId
orderId
paymentId
paymentRoute = PRO_FORMA_INVOICE
reference
status
currency
amountDueMinor
issuedAt?
dueAt?
acceptedAt?
cancelledAt?
settledAt?
documentReference?
notes?
createdById?
updatedById?
createdAt
updatedAt
```

Contract:

- tenant/reference is unique;
- Payment is one-to-one with at most one Pro-forma record;
- a composite relation including tenant, Order, currency and route proves that the linked
  Payment is exactly `PRO_FORMA_INVOICE`;
- amount due is a positive bounded minor-unit snapshot;
- DRAFT/ISSUED/ACCEPTED/CANCELLED/SETTLED have exact timestamp shapes;
- due, acceptance and settlement chronology follows issue time where present;
- document reference is an opaque nonblank managed-artifact reference, never a required
  purchaser-hosted URL;
- SETTLED and Payment PAID are separate evidence. A5 must update both consistently and
  audit the action; A3 adds no trigger or service.

One Order may therefore have several cancelled/reissued pro-forma attempts through
separate Payments, while each Payment remains unambiguous.

## 7. Exact Keys And Relations

Add:

```text
CommerceOrder:
  unique (organizationId, id, currency)

CommercePayment:
  unique (organizationId, id, orderId, currency)
  unique (organizationId, id, orderId, currency, route)

CommerceRefund -> CommercePayment:
  (organizationId, paymentId, orderId, currency)

CommerceProFormaInvoice -> CommercePayment:
  (organizationId, paymentId, orderId, currency, paymentRoute)
```

Organization and Order reverse relations are navigation/client-generation support only.
They do not move payment ownership into FUND. Order and Organization deletion remain
`RESTRICT`; Payment deletion is restricted by Refund or Pro-forma evidence.

## 8. Indexes And Partial Uniqueness

Plan:

- Payment tenant/Order/status/time;
- Payment tenant/route/status/time;
- partial unique external checkout, payment and session references by tenant/provider;
- Refund tenant/Order/status/requested time;
- Refund tenant/Payment/status/requested time;
- partial unique provider-refund reference within Payment;
- Pro-forma tenant/reference unique;
- Pro-forma Payment unique;
- Pro-forma tenant/status/due date.

Indexes support later services but do not imply transitions or provider behavior.

## 9. Migration And Backfill

Migration order:

1. create A3 enums;
2. add the Payment composite support keys;
3. create Payment, Refund and Pro-forma tables with checks/indexes;
4. add Organization, Order and exact Payment foreign keys;
5. validate Prisma multi-schema generation and migration SQL ownership.

Backfill policy: zero rows. Existing A1/A2/FUND evidence remains byte-for-byte unchanged.

Rollback policy during development: reset only the disposable database and correct the
unreleased migration. Do not hand-delete A3 objects from a shared database. After release,
commercial evidence requires forward remediation.

## 10. Explicit Exclusions

A3 adds no:

- payment initiation, capture, cancellation, refund or settlement service;
- arithmetic aggregation or Order/payment reconciliation;
- provider account configuration;
- Stripe SDK, Checkout Session, Payment Intent or webhook handling;
- idempotency request/event ledger or Commerce audit-event table;
- pro-forma numbering/generation/PDF/email behavior;
- refund line allocation;
- checkout/Order creation service;
- FUND relation or field;
- public/C1/C2 route, API procedure or UI;
- commission, Store, fulfilment or production behavior.

These boundaries preserve A4 audit/idempotency, A5 provider-neutral services, A6 Stripe
adapter/webhooks and A7 FUND consumer integration as separate lifecycles.

## 11. Validation Plan

Static/repository:

```text
npx prisma format
npx prisma validate
npx prisma generate
npx tsx scripts/verify-commerce-a3-schema.ts
npx tsx scripts/verify-commerce-a1-schema.ts
npx tsx scripts/verify-commerce-a2-schema.ts
npx tsx scripts/verify-fund-1r-c6-schema.ts
npm run type-check
npm run verify
git diff --check
```

Disposable PostgreSQL only after proving `TEST_DATABASE_URL` differs from `DATABASE_URL`:

- representative 137-to-138 migration with existing A1/A2 and FUND evidence preserved;
- full fresh replay of all 138 migrations;
- zero A3 backfill;
- valid Stripe pending/paid/refunded shapes;
- valid pro-forma pending/payment plus DRAFT/ISSUED/ACCEPTED/SETTLED shapes;
- payment amount/status/timestamp/provider-route check rejection;
- refund amount/status/timestamp/reason and provider-reference rejection;
- pro-forma route/payment/order/currency/reference/status/chronology rejection;
- duplicate external and document references;
- exact tenant/Order/Payment cross-tenant and mismatch rejection;
- restrictive Organization, Order and Payment deletion;
- A1/A2/C6 database regression samples;
- schema-to-migration drift inspection for A3-owned objects;
- final inventory 138/0 and zero fixture residue.

No shared development, staging or production database may be used.

## 12. Planned Files

```text
prisma/schema.prisma
prisma/migrations/20260715001000_commerce_a3_payment_refund_pro_forma_foundation/migration.sql
scripts/verify-commerce-a3-schema.ts
scripts/verify-commerce-a3-pre-migration.sql
scripts/verify-commerce-a3-database.sql
scripts/run-commerce-a3-database-tests.ts
```

Existing historical verifiers may receive only lifecycle-aware maintenance where they
incorrectly forbid accepted A3 objects.

## 13. Independent Review Gate

Review must confirm:

1. Payment, Refund and Pro-forma lifecycles remain separate from Order state;
2. exact tenant/Order/currency/route ownership is enforced physically;
3. refund evidence is append-oriented and line allocation remains deferred;
4. Pro-forma settlement is not silently treated as provider execution;
5. external/provider references contain no secrets and are optional in schema foundation;
6. A4-A7 responsibilities do not leak into A3;
7. migration performs zero backfill and preserves existing data;
8. disposable validation covers representative upgrade, fresh replay, constraints,
   deletion and residue.

## 14. Independent Review And Acceptance Outcome

Review result: accepted for bounded implementation on 2026-07-14.

The review resolved the architecture's remaining A3 gates:

- refund states are `REQUESTED`, `PROCESSING`, `COMPLETED`, `FAILED`, `CANCELLED`;
- every Refund is tied to one exact Payment plus its tenant/Order/currency;
- each Pro-forma is one-to-one with one exact `PRO_FORMA_INVOICE` Payment, including route
  in the physical composite foreign key;
- Pro-forma `SETTLED` and Payment `PAID` remain separate evidence that later services must
  transition atomically;
- Payment aggregate refunded amount and append-only Refund rows intentionally coexist;
  cross-row reconciliation belongs to A5;
- A4 still owns idempotency/audit events; A6 still owns Stripe behavior.

These are technical persistence resolutions within already accepted business routes and
statuses. No user decision is required. Acceptance authorises only the bounded schema,
migration and validation files listed above.

## 15. Single Bounded Implementation Prompt

```text
Continue only accepted IsoStack Commerce Core Slice COMMERCE-A3. Implement the four
Commerce-prefixed enums and CommercePayment, CommerceRefund and CommerceProFormaInvoice
schema foundation in one bounded 137-to-138 migration. Apply exact tenant/Order/currency/
route ownership, status/amount/timestamp shapes, partial provider-reference uniqueness,
restrictive deletion and zero backfill exactly as accepted.

Add no payment/refund/settlement service, provider configuration, Stripe SDK/webhook,
idempotency/audit-event foundation, pro-forma generation/email, checkout/Order service,
FUND relation, API, route or UI. Use only TEST_DATABASE_URL after proving it differs from
DATABASE_URL. Complete representative upgrade, fresh replay, constraint, deletion,
regression, drift and zero-residue validation, then create separate implementation and
review/test records and reconcile Commerce, FUND and root controls. Stop before A4, A5,
A6, A7 or FUND 1R-E.
```

## 16. Lifecycle Outcome

The accepted scope was implemented at application commit `4a90be1`. The final review
strengthened Payment-to-Order ownership so tenant, Order ID and currency are one physical
composite relation. Representative 137-to-138 and fresh 138-migration lifecycles, A1/A2/C6
regressions, restrictive deletion and zero-residue checks passed on the distinct disposable
`TEST_DATABASE_URL`. Separate implementation-confirmation and review/test records complete
the A3 lifecycle. No shared database or runtime payment behavior was changed.
