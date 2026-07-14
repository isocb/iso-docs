# Commerce Core COMMERCE-A3 Payment, Refund And Pro-forma Schema Implementation Confirmation

Date: 2026-07-14

Status: Implemented and validated on disposable PostgreSQL / shared deployment not performed

Application commit: `4a90be1` on local `dev`

Planning source:

`docs/core/commerce/03-slice-planning/2026-07-14-isostack-commerce-core-slice-commerce-a3-payment-refund-pro-forma-schema-implementation-planning.md`

## 1. Outcome

Implemented the accepted provider-neutral persistence foundation for Payment attempts,
append-oriented Refund evidence and separate Pro-forma lifecycle evidence.

Added:

- four bounded Commerce-prefixed enums;
- `CommercePayment`, `CommerceRefund` and `CommerceProFormaInvoice`;
- exact tenant/Order/currency, Payment and pro-forma route relations;
- status, amount, timestamp, reference and chronology checks;
- tenant/provider-scoped partial reference uniqueness;
- restrictive commercial-evidence deletion;
- one additive migration and reproducible disposable-database verification tooling.

No shared development, staging or production database was accessed or changed.

## 2. Application Files

Updated:

```text
prisma/schema.prisma
scripts/verify-commerce-a2-schema.ts
```

Created:

```text
prisma/migrations/20260715001000_commerce_a3_payment_refund_pro_forma_foundation/migration.sql
scripts/verify-commerce-a3-schema.ts
scripts/verify-commerce-a3-pre-migration.sql
scripts/verify-commerce-a3-database.sql
scripts/run-commerce-a3-database-tests.ts
```

The A2 verifier was made lifecycle-aware so it continues to validate its accepted subset
after later Commerce models are added. No A2 persistence contract changed.

## 3. Persistence Contract

- one Order may have multiple Payment attempts;
- every Payment physically matches its Organization, Order ID and Order currency;
- a Refund belongs to one exact Payment/Order/currency tuple;
- a Pro-forma belongs to one exact `PRO_FORMA_INVOICE` Payment tuple;
- Order, Payment, Refund and Pro-forma states remain independent;
- Refund rows retain requested, processing, completed, failed or cancelled evidence;
- Payment aggregate refund evidence and Refund-row reconciliation remain later service work;
- deletion of owning Organization/Order/Payment evidence is restricted.

## 4. Migration And Data Policy

Migration `20260715001000_commerce_a3_payment_refund_pro_forma_foundation` advances the
repository inventory from 137 to 138. It adds a supporting Order tenant/ID/currency key,
four enums and three tables. It creates no operational row and changes no existing value.

## 5. Validation Result

Passed:

- Prisma format, validation and client generation;
- A1, lifecycle-aware A2 and A3 schema-contract verifiers;
- TypeScript type-check and critical-file verification;
- representative 137-to-138 migration with existing Commerce/FUND evidence preserved;
- full fresh replay of all 138 migrations;
- valid Stripe-route and pro-forma-route evidence shapes;
- amount, lifecycle, chronology, tenant, Order, currency, Payment and route rejection;
- reference uniqueness and restrictive deletion;
- A1, A2 and FUND C6 representative/fresh regressions;
- no Commerce-owned database-to-Prisma drift;
- final `138 applied / 0 failed / 0 A3 rows / 0 fixture rows` inventory;
- diff hygiene and pre-commit type-check.

Repository-wide lint was also run. It remains non-green only because of pre-existing UI
errors and warnings outside every A3 file; A3 adds no UI source.

## 6. Scope Confirmation

Not implemented:

- payment, refund, settlement or pro-forma services;
- audit/idempotency events;
- provider configuration, Stripe SDK or webhooks;
- checkout/Order runtime behavior;
- document generation or email;
- FUND relation or Store integration;
- API, route or UI;
- shared deployment.

## 7. Handoff

A3 is complete through implementation and disposable review. `COMMERCE-A4 - Audit And
Idempotency Foundation` is the single next planning candidate; it is not started or
authorised by this confirmation.
