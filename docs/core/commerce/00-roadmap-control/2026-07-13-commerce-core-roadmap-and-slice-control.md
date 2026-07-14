# IsoStack Commerce Core Roadmap And Slice Control

Date: 2026-07-13

Status: Active Commerce Core roadmap

Parent roadmap:

`docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`

## 1. Mission

Deliver reusable tenant-owned Commerce infrastructure without embedding FUND or another
consumer module into generic checkout, Order, money or payment records.

## 2. Documentation Lifecycle

```text
01-cr-inputs                  raw Commerce change/request inputs
02-triage                     architecture, ownership and decision records
03-slice-planning             bounded executable slice plans
04-implementation-confirmations actual implementation evidence only
05-review-and-test            independent review, tests and deployment gates
```

## 3. Accepted Architecture

Authoritative architecture record:

`docs/core/commerce/02-triage/2026-07-13-isostack-commerce-core-schema-foundation-planning.md`

Accepted direction:

- dedicated `commerce` namespace in the existing IsoStack PostgreSQL database;
- public `Organization` remains the tenant/seller identity;
- generic source references remain opaque to Commerce;
- consumer modules write typed extensions keyed to Commerce IDs;
- checkout, Order, payment, refund and pro-forma states remain separate;
- provider work remains later than provider-neutral schema/service foundations.

## 4. Slice Sequence

```text
COMMERCE-A1 - Schema namespace, Seller Profile and stable enums
COMMERCE-A2 - Checkout, Order and Order-line schema foundation
COMMERCE-A3 - Payment, refund and pro-forma schema foundation
COMMERCE-A4 - Audit and idempotency foundation
COMMERCE-A5 - Provider-neutral services and validation
COMMERCE-A6 - Stripe adapter and webhook handling
COMMERCE-A7 - FUND consumer integration
```

Each slice requires its own `03 -> implementation -> 04 -> 05` lifecycle.

## 5. `COMMERCE-A1` Status

Planning:

`docs/core/commerce/03-slice-planning/2026-07-13-isostack-commerce-core-slice-commerce-a1-schema-seller-profile-enums-implementation-planning.md`

Implementation confirmation:

`docs/core/commerce/04-implementation-confirmations/2026-07-13-commerce-a1-schema-seller-profile-enums-implementation-confirmation.md`

Review/test:

`docs/core/commerce/05-review-and-test/2026-07-13-commerce-a1-schema-seller-profile-enums-review-and-test.md`

Current result:

- implemented and reviewed as passed;
- static/generated-client/schema-contract review passed;
- fresh and existing-schema disposable PostgreSQL migration passed;
- rollback-only constraint/default smoke passed with zero residual test rows;
- the dedicated Neon database configured by local `TEST_DATABASE_URL` is retained as
  disposable test infrastructure for future accepted migration-test plans;
- committed with FUND 1R-C1/1R-C2 at application commit `4575d2d` and aligned to
  `origin/dev`;
- no shared development, staging or live database migration/deployment performed.

## 6. `COMMERCE-A2` Entry Gates

Before A2 implementation planning can close, decide:

- whether Commerce persists checkout basket lines or receives an immutable submission from
  the consumer;
- `Int` versus `BigInt` minor-unit money representation;
- initial seller tax-rate/rule representation;
- arithmetic reconciliation and immutable snapshot contract;
- Order-line inheritance of the Order source-module boundary.

A2 must not absorb provider, Stripe, FUND production or commission work.

The 2026-07-14 bounded A2 review resolved these gates as follows:

- Commerce persists the checkout header/submission boundary, not mutable basket lines;
- money uses bounded Prisma `Int` minor units;
- seller profiles gain nullable standard/reduced basis-point rates while Orders/lines hold
  immutable applied snapshots;
- Order arithmetic uses explicit per-row integer reconciliation and later service-level
  aggregate validation;
- Order lines inherit the Order source-module boundary;
- exact same-tenant composite relations are required throughout.

Accepted implementation plan:

`docs/core/commerce/03-slice-planning/2026-07-14-isostack-commerce-core-slice-commerce-a2-checkout-order-order-line-schema-implementation-planning.md`

## 7. Cross-Lane Dependency

FUND implemented `1R-C1` through `1R-C5` inside its own schema lane without Commerce
Orders. FUND `1R-C6` then consumed the completed Commerce A2 Order/line foundation through
typed FUND-owned evidence and exact cross-schema relations.

The FUND roadmap is a sibling control, not the parent Commerce roadmap:

`docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

## 7.1 `COMMERCE-A2` Status

Planning:

`docs/core/commerce/03-slice-planning/2026-07-14-isostack-commerce-core-slice-commerce-a2-checkout-order-order-line-schema-implementation-planning.md`

Implementation confirmation:

`docs/core/commerce/04-implementation-confirmations/2026-07-14-commerce-a2-checkout-order-order-line-schema-implementation-confirmation.md`

Review/test:

`docs/core/commerce/05-review-and-test/2026-07-14-commerce-a2-checkout-order-order-line-schema-review-and-test.md`

Current result:

- implemented and reviewed as passed at application commit `3206199` on `origin/dev`;
- representative 135-to-136 and fresh 136-migration disposable lifecycles passed;
- A1 regression, same-tenant, state, arithmetic, tax and deletion suites passed;
- final disposable inventory is 136 applied, zero failed and zero test rows;
- no Commerce-owned database-to-Prisma drift was found;
- no shared database deployment was performed; staging/main remain unchanged.

## 8. Current Next Step

`COMMERCE-A1` and `COMMERCE-A2` are complete through review/test. The accepted generic
Order/line and same-tenant relation foundation supported FUND `1R-C6 - FUND Commerce
Context Foundation`, which is implemented/reviewed at local application commit `9947669`.
Its representative 136-to-137 and fresh 137-migration disposable lifecycles passed with
zero residue and no shared deployment.

Store `1R-D - Store Readiness And C1 Store Configuration API/Services` is the single next
planning candidate under the root roadmap. `COMMERCE-A3` remains queued and neither slice
is authorised for implementation by C6 completion.
