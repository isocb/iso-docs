# COMMERCE-A6-C Connected-account Checkout Adapter Implementation Confirmation

Date: 2026-07-15

Status: Implemented at application commit `34ef64bb`; independently reviewed and tested

Planning authority:

`docs/core/commerce/03-slice-planning/2026-07-15-isostack-commerce-core-slice-commerce-a6-c-connected-account-checkout-adapter-implementation-planning.md`

## Implemented

- a narrow fakeable connected-account Checkout Session create/retrieve/expire adapter;
- fixed server-owned success/cancel URL construction and strict provider-result
  normalization;
- exact tenant Checkout, Order, Payment, Seller Profile and retained Stripe connection
  authority validation;
- fresh A6-B Account readiness synchronization before Session creation;
- Payment-key A4 idempotency, short transactions around the remote call, stable replay and
  concurrent-request convergence;
- atomic safe provider-reference persistence, append-only A4 audit and best-effort expiry
  compensation after permanent post-create authority loss;
- nullable creation-time PaymentIntent support and later same-account observation;
- the bounded A5 correction that gives FAILED operations a completion time and clears all
  terminal response/resource/error/completion evidence before retrying PROCESSING;
- unit and disposable PostgreSQL service coverage with fake providers only.

## Preserved Boundaries

- no Prisma model, migration, public/C1 procedure, router, route, return page or UI was
  added; the migration inventory remains 140;
- no Order or Payment is created and no Payment status or money value changes;
- no webhook, refund, fee, transfer, Store, production, commission or FUND behavior was
  added;
- no Checkout URL, purchaser email, secret, client secret, payment method, card data or
  provider body is persisted, logged or written to audit metadata;
- no real Stripe network request or charge occurred;
- A6-D remains the authority for verified provider-event payment/refund reconciliation and
  A7 remains the consumer/public invocation boundary.

## Application Evidence

```text
34ef64bb feat(commerce): add connected-account checkout adapter
```

The implementation is committed locally on application `dev`. No push, shared-database
migration, staging deployment or production deployment is claimed by this record.
