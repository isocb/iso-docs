# Commerce A6-D Connected-account Webhook, Payment/Refund Synchronization And Reconciliation Implementation Confirmation

Date: 2026-07-15

Status: Implemented at application commit `fa670e3c`; not pushed, deployed or configured in
any shared environment

Planning authority:

`docs/core/commerce/03-slice-planning/2026-07-15-isostack-commerce-core-slice-commerce-a6-d-connected-account-webhook-payment-refund-reconciliation-implementation-planning.md`

## 1. Implemented Outcome

The accepted A6-D boundary is implemented without a Prisma schema change or migration.

Application commit `fa670e3c` adds:

- the isolated raw-body Connect receipt route at
  `/api/webhooks/commerce/stripe-connect`;
- current and optional previous Connect-secret verification with no subscription-secret
  fallback;
- tenant/account/livemode resolution and minimal immutable Event Inbox receipt;
- same-envelope duplicate acknowledgement and conflicting-envelope refusal;
- an explicit Connect event allowlist and durable ignore/API-version quarantine paths;
- a fakeable Account, Checkout Session, PaymentIntent and Refund adapter;
- a 25-row `SKIP LOCKED` shared-job processor with five-minute leases, bounded retry and
  eight-attempt quarantine;
- one coordinated inbox/A4 operation lifecycle with stale-worker token checks;
- canonical same-account Payment success, failed-attempt, expiry and cancellation
  reconciliation;
- provider-originated Refund creation/progression and completed-refund aggregation;
- account/capability readiness synchronization;
- signed-fixture unit tests and disposable PostgreSQL service validation.

The Commerce processor is registered after the existing LMSPro sequence processors.
Durably scheduled retries and quarantines return handled work and do not make unrelated job
processors fail.

## 2. Actual Application Files

- `src/app/api/webhooks/commerce/stripe-connect/route.ts`
- `src/modules/commerce/services/stripe-connect-webhook.service.ts`
- `src/modules/commerce/services/stripe-connect-webhook.service.test.ts`
- `scripts/jobs/processors/commerce-stripe-events.ts`
- `scripts/jobs/run.ts`
- `scripts/run-commerce-a6-d-service-tests.ts`

## 3. Preserved Boundaries

- `prisma/schema.prisma` and all migrations are unchanged at 140.
- `/api/webhooks/stripe`, `STRIPE_WEBHOOK_SECRET`, subscription billing,
  `Organization.stripeCustomerId` and subscription email are unchanged.
- No real Stripe network call, Event destination, account, payment or refund was created.
- No shared secret was configured or rotated.
- No public checkout/return UI, Order/Payment creation, refund API/UI, Store, FUND,
  commission, fulfilment or production authorization was added.
- No raw body, signature, secret, Checkout URL, purchaser email, client secret, payment
  method, card detail, decline text or provider response body is retained or audited.

## 4. Database And Deployment State

Only the retained disposable PostgreSQL database identified by `TEST_DATABASE_URL` was
used. The test runner proved it differed from `DATABASE_URL` before connecting. It
confirmed 140 applied migrations and removed all A6-D fixtures.

Development, staging and production databases were not modified. The Connect webhook
secret and Stripe Event destination remain deliberately unconfigured. Application commit
`fa670e3c` is local only at this confirmation point.

## 5. Handoff

A6-D is implemented. Its independent review/test record controls acceptance of this
implementation. A7 and FUND Store UI were not started.
