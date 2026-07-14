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
- no shared development, staging or live deployment performed.

## 6. `COMMERCE-A2` Entry Gates

Before A2 implementation planning can close, decide:

- whether Commerce persists checkout basket lines or receives an immutable submission from
  the consumer;
- `Int` versus `BigInt` minor-unit money representation;
- initial seller tax-rate/rule representation;
- arithmetic reconciliation and immutable snapshot contract;
- Order-line inheritance of the Order source-module boundary.

A2 must not absorb provider, Stripe, FUND production or commission work.

## 7. Cross-Lane Dependency

FUND may implement `1R-C1` through `1R-C5` inside its own schema lane without Commerce
Orders. FUND `1R-C6` waits for the accepted Commerce Order/line foundation and cross-schema
relation direction.

The FUND roadmap is a sibling control, not the parent Commerce roadmap:

`docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

## 8. Current Next Step

`COMMERCE-A1` is complete through review/test. FUND `1R-C1` is also implemented and reviewed
as passed without changing the Commerce A1 contract. `COMMERCE-A2` remains future work and
is not started or authorised by either completion. The root roadmap currently authorises no
next slice.
