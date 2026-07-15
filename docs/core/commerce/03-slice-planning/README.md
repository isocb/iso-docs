# Commerce Core Slice Planning

Each bounded executable Commerce slice begins here and must later receive a matching
implementation confirmation and review/test record.

Completed through review/test:

```text
COMMERCE-A1 - Schema namespace, Seller Profile and stable enums
COMMERCE-A2 - Checkout, Order and Order-line schema foundation
COMMERCE-A3 - Payment, Refund and Pro-forma schema foundation
COMMERCE-A4 - Audit and Idempotency foundation
COMMERCE-A5 - Provider-neutral services and validation
COMMERCE-A6-A - Stripe Connect account and event-inbox schema foundation
COMMERCE-A6-B - Tenant payment settings and hosted onboarding
COMMERCE-A6-C - Connected-account Checkout adapter
```

FUND `1R-C6` is implemented/reviewed at local application commit `9947669` against the
completed Commerce A2 foundation. FUND Store `1R-D` is implemented/reviewed at local
application commit `db85fcc` without adding Commerce behavior or another migration.

Commerce A3 is implemented/reviewed at local application commit `4a90be1`; its complete
138-migration disposable lifecycle passed with zero residue and no shared deployment.

Commerce A4 is implemented/reviewed at local application commit `5b69920`; its complete
139-migration disposable lifecycle passed with zero residue and no shared deployment.

Commerce A5 is implemented/reviewed at application commit `fd7376b`.
Its provider-neutral validators and idempotency/audit transaction helpers passed unit,
static and disposable PostgreSQL smoke tests with zero residue and no migration.

COMMERCE-A6 Stripe Connect Tenant Payments parent planning is reviewed and accepted at:

`2026-07-14-isostack-commerce-core-slice-commerce-a6-stripe-connect-tenant-payments-planning.md`

The bounded A6-A Stripe Connect Account And Event-Inbox Schema Foundation plan is
implemented/reviewed at application commit `513cf3a`:

`2026-07-15-isostack-commerce-core-slice-commerce-a6-a-stripe-connect-account-event-inbox-schema-foundation-implementation-planning.md`

Implementation confirmation and review/test:

`../04-implementation-confirmations/2026-07-15-commerce-a6-a-stripe-connect-account-event-inbox-schema-foundation-implementation-confirmation.md`

`../05-review-and-test/2026-07-15-commerce-a6-a-stripe-connect-account-event-inbox-schema-foundation-review-and-test.md`

The representative 139-to-140 and fresh 140-migration disposable lifecycles passed with
zero residue.

The bounded A6-B Tenant Payment Settings And Hosted Onboarding plan is implemented/reviewed
at application commit `e8aecea`:

`2026-07-15-isostack-commerce-core-slice-commerce-a6-b-tenant-payment-settings-hosted-onboarding-implementation-planning.md`

Implementation confirmation and review/test:

`../04-implementation-confirmations/2026-07-15-commerce-a6-b-tenant-payment-settings-hosted-onboarding-implementation-confirmation.md`

`../05-review-and-test/2026-07-15-commerce-a6-b-tenant-payment-settings-hosted-onboarding-review-and-test.md`

A6-B added no migration and passed fake-provider, authorization, state, readiness, audit,
build and zero-residue validation without a real Stripe call.

A6-C Connected-account Checkout Adapter is implemented/reviewed at application commit
`34ef64bb`:

`2026-07-15-isostack-commerce-core-slice-commerce-a6-c-connected-account-checkout-adapter-implementation-planning.md`

Implementation confirmation and review/test:

`../04-implementation-confirmations/2026-07-15-commerce-a6-c-connected-account-checkout-adapter-implementation-confirmation.md`

`../05-review-and-test/2026-07-15-commerce-a6-c-connected-account-checkout-adapter-review-and-test.md`

A6-C added no migration and passed fake-provider, PostgreSQL service, concurrency,
compensation, redaction, build and zero-residue validation without a real Stripe call. The
single next candidate is bounded A6-D planning; A6-D implementation remains unauthorised.
