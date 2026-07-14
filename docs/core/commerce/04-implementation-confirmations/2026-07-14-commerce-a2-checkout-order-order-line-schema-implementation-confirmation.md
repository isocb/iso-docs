# Commerce Core COMMERCE-A2 Checkout/Order/Order-line Schema Implementation Confirmation

Date: 2026-07-14

Status: Implemented and validated on disposable PostgreSQL / shared deployment not performed

Application commit: `3206199` on `dev` and `origin/dev`

Planning source:

`docs/core/commerce/03-slice-planning/2026-07-14-isostack-commerce-core-slice-commerce-a2-checkout-order-order-line-schema-implementation-planning.md`

## 1. Outcome

Implemented the accepted generic Commerce A2 schema foundation from the separately
committed R3-D baseline `e1c2d9f`.

Added:

- `CommerceCheckoutStatus` and `CommerceOrderStatus`;
- nullable standard/reduced seller tax rates in basis points;
- `CommerceCheckoutSession` as a header/submission boundary without basket lines;
- immutable `CommerceOrder` seller/purchaser/source/money snapshots;
- immutable `CommerceOrderLine` item/configuration/tax/money snapshots;
- exact same-tenant composite keys and relations;
- restrictive commercial-evidence deletion;
- one additive migration and reproducible verification tooling.

No shared development, staging or production database was accessed or changed.

## 2. Application Files

Updated:

```text
prisma/schema.prisma
```

Created:

```text
prisma/migrations/20260714235500_commerce_a2_checkout_order_line_foundation/migration.sql
scripts/verify-commerce-a2-schema.ts
scripts/verify-commerce-a2-pre-migration.sql
scripts/verify-commerce-a2-database.sql
scripts/run-commerce-a2-database-tests.ts
```

No service, API, route, page, component, payment, provider, Stripe or FUND file was added.

## 3. Persistence Contract

Checkout sessions store:

- tenant and controlled generic source tuple;
- hashed public identity only;
- currency/minor-unit exponent;
- source configuration version/fingerprint;
- explicit lifecycle and matching timestamps;
- expiry evidence.

Orders store:

- tenant-scoped Order number;
- exact seller-profile and optional one-session/one-Order identity;
- immutable seller and purchaser/contact snapshots;
- generic source tuple;
- integer minor-unit totals and database reconciliation;
- commercial status separate from payment/production/fulfilment.

Order lines store:

- one resolved source item/configuration per line;
- positive quantity and explicit base/modifier/discount/net/tax/gross arithmetic;
- Product/item display evidence;
- tax treatment/category/rate and price-entry basis;
- immutable version/fingerprint/JSON configuration evidence.

## 4. Tax And Money Decisions

- money uses Prisma/PostgreSQL `Int` minor units constrained to `0..2,000,000,000`;
- exponent is constrained to `0..3`;
- seller standard/reduced rates are nullable `0..10,000` basis points;
- existing seller profiles receive null, not guessed, rates;
- zero-rated and exempt lines require zero applied rate;
- database checks reconcile each Order and line row safely using bigint intermediate casts;
- aggregate line-to-Order and rounding validation remains a later service invariant.

## 5. Migration And Backfill

Migration `20260714235500_commerce_a2_checkout_order_line_foundation` advances the repository
inventory from 135 to 136.

It creates no checkout, Order or line row and changes no existing value. The only existing
table change adds two nullable rate columns and one supporting same-tenant key to
`CommerceSellerProfile`.

The migration contains no FUND relation or data statement.

## 6. Validation Result

Passed:

- Prisma format, validation and client generation;
- generated DMMF/static schema and forbidden-scope verification;
- TypeScript type-check and repository critical-file verification;
- targeted lint for both A2 TypeScript verifiers;
- representative 135-to-136 migration with existing A1 seller and FUND Client fixtures;
- null tax-rate backfill and exact fixture-value preservation;
- full fresh replay of all 136 migrations;
- valid checkout, Order and multi-line insertion;
- lifecycle/hash/source/currency/exponent/contact/tax/money checks;
- duplicate and cross-tenant identity rejection;
- seller/session/Order/line restrictive deletion;
- A1 constraint/default regression on representative and fresh databases;
- Commerce-scoped database-to-Prisma drift verification;
- final `136 applied / 0 failed / 0 A2 rows / 0 fixture rows` inventory;
- diff hygiene and pre-commit type-check.

The complete lifecycle used only the retained `TEST_DATABASE_URL` after proving it differed
from `DATABASE_URL`.

## 7. Scope Confirmation

Not implemented:

- mutable Commerce basket lines;
- checkout/Order/line services or UI;
- Order-number generation;
- tax calculation/rule selection;
- payment, refund or pro-forma schema;
- audit/idempotency foundation;
- provider or Stripe integration;
- FUND Order/line context, Store behavior, production or commission;
- shared database deployment.

## 8. Handoff

A2 is complete through implementation and disposable review. It unlocks bounded planning
of FUND `1R-C6 - FUND Commerce Context Foundation`; it does not authorise Store `1R-D`,
Commerce A3 or runtime checkout integration.
