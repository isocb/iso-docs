# IsoStack Commerce Core Slice COMMERCE-A6-D — Connected-account Webhook, Payment/Refund Synchronization And Reconciliation Implementation Planning

Date: 2026-07-15

Status: Planning complete; awaiting explicit review and acceptance before implementation

Parent:

`docs/core/commerce/03-slice-planning/2026-07-14-isostack-commerce-core-slice-commerce-a6-stripe-connect-tenant-payments-planning.md`

Completed dependencies:

- Commerce A1-A5 generic Seller, Order, Payment, Refund, audit, idempotency and validation
  contracts;
- A6-A retained Stripe connection and durable Event Inbox schema at application `513cf3a`;
- A6-B tenant settings, hosted onboarding and Account-readiness services at `e8aecea`;
- A6-C dormant direct-charge Checkout adapter at `34ef64bb`;
- complete unchanged 140-migration disposable PostgreSQL baseline;
- pinned Stripe SDK `22.2.0` and API version `2026-05-27.dahlia`.

## 1. Goal

Add the authoritative connected-account event boundary that converts verified Stripe
evidence into generic Commerce Payment and Refund state.

A6-D receives and durably deduplicates signed Connect events, then processes them through a
separate retryable worker. Every business transition re-retrieves canonical Stripe objects
under the exact retained connected account before applying A5 rules under tenant, inbox,
Payment and Refund locks.

A6-D does not create Orders or Payments, initiate refunds, expose refund UI, invoke FUND,
or authorize fulfilment or production.

## 2. Implementation Boundary

Expected application work is limited to:

- one dedicated Connect webhook receipt route, separate from subscription billing;
- a narrow fakeable signature-verification and canonical-object Stripe adapter;
- one durable Event Inbox receipt service;
- one bounded Event Inbox claim/retry processor registered with the existing shared job
  tick;
- canonical Account, Checkout Session, PaymentIntent and Refund reconciliation services;
- provider-originated Commerce Refund synchronization;
- append-only A4 idempotency/audit evidence;
- signed-fixture, fake-provider and disposable PostgreSQL tests.

No Prisma enum, model, relation, migration or backfill is required. The existing A3/A4/A6-A
schema is sufficient, so the migration inventory remains exactly 140.

## 3. Isolation From Subscription Billing

The existing subscription webhook remains unchanged at:

```text
/api/webhooks/stripe
STRIPE_WEBHOOK_SECRET
Organization.stripeCustomerId
```

Commerce Connect receives events only at a new route:

```text
/api/webhooks/commerce/stripe-connect
STRIPE_CONNECT_WEBHOOK_SECRET
STRIPE_CONNECT_WEBHOOK_SECRET_PREVIOUS (optional rotation overlap only)
```

The Connect route must never call subscription handlers, query `stripeCustomerId`, mutate
`OrganizationProduct`, send subscription email or accept the subscription webhook secret.
The subscription route must gain no Commerce logic.

The platform `STRIPE_SECRET_KEY` remains the only Stripe API credential. Tenants enter no
secret and no secret is stored in PostgreSQL.

## 4. Receipt Boundary

The route reads the untouched raw request body exactly once and passes that exact body and
the `Stripe-Signature` header to the official Stripe verifier using its default timestamp
tolerance. Verification tries the current Connect secret first and the optional previous
secret second. Rotation success records only a bounded key-slot classification such as
`CURRENT` or `PREVIOUS` in transient memory; no secret or signature is logged or persisted.

Receipt refusal:

- missing or invalid signature: `400`;
- missing current Connect secret: `503` without attempting subscription-secret fallback;
- malformed Event ID/type/account/object envelope or a livemode that differs from the
  deployment Stripe key: `400`;
- valid signature but transient database failure before durable insert: `500`, allowing
  Stripe retry;
- valid same-hash duplicate or successful durable insert: prompt `2xx`.

Every owned Event must contain:

- `evt_...` provider Event ID;
- top-level `account = acct_...`;
- exact deployment `livemode`;
- event type and provider creation time;
- optional `data.object.object` plus object ID as one complete pair;
- raw-body SHA-256 payload hash.

Resolve the globally unique connected account to one retained
`CommerceStripeAccountConnection`, then persist its exact Organization, connection,
account and mode. Unknown accounts create no unowned inbox row and receive a bounded
non-disclosing `2xx`; they may be recorded only in redacted operational logs.

Insert `CommerceStripeEventInbox` as `RECEIVED` in one short transaction. The full body,
Event data object, metadata, purchaser details, card/payment method and error message are
never stored. A duplicate `providerEventId` is successful only when its immutable account,
mode, event type and payload hash match the retained envelope. A same-ID/different-envelope
collision is rejected and does not mutate the retained row.

Persist the signed Event's API version in the existing safe envelope. An allowlisted Event
whose API version is null or differs from pinned `2026-05-27.dahlia` is durably received,
then permanently quarantined as `FAILED` with `UNSUPPORTED_API_VERSION`; it is never used
for provider retrieval or business mutation. This preserves prompt receipt and operational
evidence without silently processing an unreviewed provider contract.

Receipt never retrieves a provider object or changes a connection, Payment or Refund.

## 5. Explicit Event Allowlist

The first processor allowlist is:

```text
account.updated
capability.updated
checkout.session.completed
checkout.session.expired
payment_intent.succeeded
payment_intent.payment_failed
payment_intent.canceled
refund.created
refund.updated
refund.failed
```

All other valid owned Event types are durably received, claimed once and marked `IGNORED`
without provider retrieval or business mutation. In particular:

- `checkout.session.async_payment_*` remains ignored because delayed methods are excluded;
- `account.application.deauthorized` remains ignored because A6 does not use Connect OAuth;
- dispute, payout, transfer, fee, subscription and Customer events remain ignored.

The deployed Stripe Connect event destination should later be configured for only the
allowlist above. This plan performs no Stripe Dashboard or shared-environment action.

## 6. Durable Worker And Inbox Lifecycle

Register a Commerce Stripe Event processor with the existing `jobs:tick` runner. Receipt
and processing remain separate: the webhook returns after durable insert, and no unreliable
fire-and-forget work runs in the route.

The processor claims at most 25 rows per tick using `FOR UPDATE SKIP LOCKED` and ordered
provider creation/receipt time. Eligible rows are:

- `RECEIVED`;
- `RETRY_PENDING` with `nextAttemptAt <= now`;
- stale `PROCESSING` whose lease has elapsed.

Claiming changes the row to `PROCESSING`, increments `attemptCount`, sets `processingAt`
and clears prior failure/retry fields exactly as required by the A6-A status-shape check.
Only one worker may own an inbox row at a time.

Provider retrieval occurs outside the claim transaction. A second SERIALIZABLE transaction
re-locks the inbox and exact tenant business records, revalidates canonical results, applies
the transition, appends audit, completes A4 idempotency and marks the inbox `PROCESSED`.

Failure classification:

- transient provider/database availability or serialization failure becomes
  `RETRY_PENDING` with a bounded non-secret error code and exponential next-attempt time;
- a permanent account/object/tenant/mode/currency/amount/reference/state conflict becomes
  `FAILED`, the schema's quarantine state;
- after eight failed attempts, a transient row becomes `FAILED`;
- no provider response body, decline text, purchaser information or secret enters
  `lastErrorCode`, audit or logs.

Use bounded delays of approximately 1 minute, 5 minutes, 15 minutes, 1 hour, 6 hours and
24 hours, capped at 24 hours. A stale processing lease is five minutes. These are service
constants, not tenant settings.

## 7. Provider Adapter And Canonical Retrieval

The narrow adapter may only:

- verify/construct a signed Event from the raw body;
- retrieve Account;
- retrieve Checkout Session;
- retrieve PaymentIntent;
- retrieve one Refund;
- list all Refunds for one exact PaymentIntent with bounded pagination.

Every retrieval uses the inbox connection's `connectedAccountId` request context. No object
is retrieved in platform context and no object supplied inside the webhook body is treated
as state authority.

Normalized results expose only the IDs, mode/status, amount, currency, timestamps and safe
relationship fields needed for reconciliation. They exclude card, billing, purchaser,
payment-method, client-secret, charge-outcome and free-text provider data.

## 8. Exact Payment Resolution

Checkout events resolve an exact tenant Payment by:

```text
providerCode = STRIPE
providerAccountReference = inbox connected account
externalCheckoutReference = canonical Checkout Session ID
route = STRIPE_ONLINE
```

PaymentIntent events first use an existing `externalPaymentReference`. When A6-C created a
Session before Stripe exposed a PaymentIntent, opaque provider metadata may identify only a
candidate Payment; authority is established only after retrieving that Payment's recorded
Checkout Session and proving that the Session now references the same PaymentIntent.

Require exact Organization, Order, Payment, Checkout, Seller and connection ownership,
plus:

- Session mode `payment` and matching livemode;
- Session total/currency equal immutable Payment requested amount/currency;
- PaymentIntent amount/currency equal the same authority;
- PaymentIntent obtained under the retained account;
- Payment still owns the same Session and has no conflicting provider reference;
- Order/line arithmetic continues to pass A5 validation.

A null `externalPaymentReference` may be filled only after the exact Session link is proved.
An existing different reference is a permanent conflict.

## 9. Payment State Reconciliation

Canonical provider state, not Event delivery order or Event body state, determines the
transition.

### 9.1 Successful payment

When the PaymentIntent is `succeeded`, its received amount equals the immutable requested
amount, the Session relationship reconciles and the Payment is `PENDING`:

- apply A5 `PENDING -> PAID`;
- set `amountPaidMinor = amountRequestedMinor`;
- retain `amountRefundedMinor = 0` until Refund reconciliation;
- set `paidAt` from the earliest verified provider Event time that proves success, which
  must not predate `initiatedAt`;
- persist the proved PaymentIntent reference if previously null;
- emit append-only provider audit bound to inbox and A4 idempotency evidence.

Repeated or older success events against `PAID`, `PARTIALLY_REFUNDED` or `REFUNDED` are
idempotent no-ops after canonical equality checks.

### 9.2 Attempt failure is not terminal

`payment_intent.payment_failed` means one payment attempt failed; the PaymentIntent may
still be retried in the open Checkout Session. It therefore does not by itself transition
Commerce Payment to `FAILED`. Record only a bounded audit event with no decline detail and
leave the Payment `PENDING` unless canonical Session state is already terminal.

### 9.3 Expiry and cancellation

For a canonically expired Session with no successful PaymentIntent:

- use `PENDING -> FAILED` only when the canonical PaymentIntent contains evidence of a
  failed payment attempt;
- otherwise use `PENDING -> CANCELLED`;
- set only the matching `failedAt` or `cancelledAt` from verified provider Event time.

A canonical `payment_intent.canceled` maps `PENDING -> CANCELLED`. A late failure/expiry
Event can never reverse `PAID` or a refund state. Any canonical success conflicting with a
locally terminal failed/cancelled Payment is quarantined rather than forced through an
illegal reverse transition.

## 10. Provider-originated Refund Synchronization

Refund events retrieve the exact Refund, its PaymentIntent and the bounded complete Refund
list under the retained connected account. Follow provider pagination up to 100 Refunds per
PaymentIntent; exceeding that limit quarantines reconciliation with
`REFUND_SET_LIMIT_EXCEEDED` and never applies a partial aggregate. Require:

- `re_...` Refund identity;
- exact PaymentIntent and Payment ownership;
- refund currency equal Payment currency;
- each amount positive and no greater than paid amount;
- sum of all canonical succeeded refunds no greater than paid amount;
- no same provider Refund reference attached to another local Payment or tenant.

If refund evidence arrives before the payment-success Event, canonical succeeded
PaymentIntent evidence may first advance `PENDING -> PAID` in the same locked
reconciliation.

For every canonical provider Refund not yet represented locally, create a
`CommerceRefund` initially as `REQUESTED`, with:

```text
requestedById = null
providerRefundReference = Stripe Refund ID
reasonCode = bounded STRIPE_* mapping
reasonNotes = null
requestedAt = provider Refund creation time
```

Then advance it through A5 rules rather than inserting a terminal row directly:

```text
Stripe pending/requires_action -> REQUESTED -> PROCESSING
Stripe succeeded               -> REQUESTED -> PROCESSING -> COMPLETED
Stripe failed                  -> REQUESTED -> PROCESSING -> FAILED
Stripe canceled                -> REQUESTED -> PROCESSING -> CANCELLED
```

Existing Refund rows advance only through legal forward transitions. Canonical current
state wins over older Event order. Provider reason values map to a fixed safe code set such
as `STRIPE_DUPLICATE`, `STRIPE_FRAUDULENT`, `STRIPE_REQUESTED_BY_CUSTOMER` or
`STRIPE_PROVIDER_ORIGINATED`; provider descriptions and failure text are not retained.

After synchronizing the complete canonical set, sum local `COMPLETED` Refund amounts and
atomically set:

- `amountRefundedMinor` to that sum;
- `PAID -> PARTIALLY_REFUNDED` when the sum is positive but below paid amount;
- `PAID/PARTIALLY_REFUNDED -> REFUNDED` when the sum equals paid amount.

Use `paymentStatusForRefund` and A5 transition validation. Failed, cancelled and processing
Refunds do not increase `amountRefundedMinor`. A completed Refund is immutable terminal
business evidence; a later contradictory provider state is quarantined for operational
review rather than reversing Commerce history.

A6-D synchronizes refunds created directly by the C1 seller in its Stripe Dashboard. It
does not provide an IsoStack refund-initiation service or UI.

## 11. Account Readiness Events

`account.updated` and `capability.updated` always retrieve the canonical Account and reuse
A6-B normalization. They may restrict/disable new checkout immediately and update safe
readiness snapshots. `lastProviderEventAt` advances monotonically to the greatest verified
provider Event time; older delivery never overwrites a newer timestamp.

Provider retrieval failure is transient and does not prove disconnection. This slice does
not delete a connected account or infer `DISCONNECTED` from an API error. Local checkout
disable remains available through A6-B.

## 12. Idempotency, Locking And Audit

Use one A4 scope such as `STRIPE_CONNECT.EVENT_PROCESS` with the provider Event ID as key
and a canonical hash of inbox ID, payload hash, event type, account and mode. The inbox
unique Event ID is receipt deduplication; A4 is business-transition idempotency.

Acquire ordered advisory/row locks for:

```text
tenant -> inbox -> Payment -> provider Refund IDs
```

All Payment/Refund mutations, A4 completion, append-only audit and inbox completion occur
in one final transaction. Audit actor is `PROVIDER`; metadata contains only safe opaque
IDs, transition names, amount/currency, mode, attempt number and boolean classifications.

No raw payload, signature, secret, Checkout URL, purchaser email, client secret, payment
method, card detail, decline text or provider response is persisted, logged or audited.

## 13. Validation Plan

Use only `TEST_DATABASE_URL` after proving it differs from `DATABASE_URL`. Confirm the
unchanged complete 140-migration inventory and zero pre-test A6-D fixture residue.

Pure/signed-fixture coverage:

- current and previous Connect secret verification;
- invalid, tampered, missing and stale signatures;
- raw-body preservation and payload hash;
- missing/malformed account, Event, object, mode and version evidence;
- subscription-secret refusal and route isolation;
- explicit allowlist and ignored-event classification;
- no real Stripe network call.

Disposable service coverage:

- exact account-to-tenant/livemode routing and unknown-account no-row behavior;
- same-hash duplicate success and different-envelope Event-ID collision refusal;
- prompt receipt without provider retrieval/business mutation;
- claim concurrency, `SKIP LOCKED`, stale lease recovery, bounded retry/backoff and
  permanent/max-attempt quarantine;
- account/capability readiness loss and out-of-order timestamp handling;
- Checkout/PaymentIntent tenant, account, Session, amount, currency and reference checks;
- null-to-proved PaymentIntent fill;
- succeeded, failed-attempt, expired-with-attempt, expired-without-attempt and canceled
  Payment paths;
- duplicate and deliberately reversed Event processing order;
- dashboard-originated pending/succeeded/failed/canceled, partial and multiple Refunds;
- refund-before-payment-event convergence and completed-refund aggregation;
- rollback injection at claim, provider retrieval boundary and every mutation/audit/inbox
  finalization stage;
- A4 idempotency/audit and A5 transition regressions;
- A6-A/A6-B/A6-C, Commerce A1-A5, FUND C1-C6 and subscription-billing static regressions;
- production build, repository verifier and zero fixture residue.

Use the official Stripe signed-header fixture helper and fake provider objects only. Do not
use Stripe CLI, sandbox network access, real Events, payments, refunds, accounts or secrets.

## 14. Migration, Deployment And Rollback

No migration or backfill is permitted. Validation confirms 140 migrations before and after
the suite.

Application rollback removes the Connect receipt route, worker registration and A6-D
services/tests. It does not delete retained inbox, Payment, Refund, idempotency or audit
evidence. If receipt has been deployed, disable the external Connect event destination
before rolling back the route; that is a later controlled deployment action, not part of
implementation or automated tests.

Implementation may add environment-variable reads and documentation but must not create,
rotate or deploy a secret or configure a Stripe event destination.

## 15. Explicit Exclusions

A6-D adds no:

- Prisma schema or migration;
- Order, Checkout or Payment creation;
- public Store/checkout invocation or advisory return page;
- internal refund request/API/UI;
- dispute/chargeback, saved card, Customer, delayed method or subscription behavior;
- application fee, transfer, destination charge, payout or automatic tax;
- fulfilment, production authorization, physical-artwork decision or FUND commission;
- tenant settings UI change, email or notification;
- staging/production secret, webhook destination, network payment/refund or deployment.

A7 remains responsible for consumer/public checkout invocation and FUND integration.

## 16. Review Outcome

The plan is deliberately left awaiting explicit review and acceptance. No schema,
application, route, webhook, worker or Stripe change is authorised by this document.

## 17. Single Bounded Review Prompt

```text
Review only IsoStack Commerce Core Slice COMMERCE-A6-D Connected-account Webhook,
Payment/Refund Synchronization And Reconciliation Implementation Planning. Do not implement
schema or application code and do not begin A7, FUND Store UI or another slice.

Verify the plan against the accepted A6 parent, completed A1-A5 and A6-A through A6-C,
current 140-migration Prisma/PostgreSQL contracts, existing subscription webhook, shared
job runner and pinned Stripe SDK/API. Resolve any conflict in raw-body signature and secret
rotation isolation, account/livemode routing, immutable inbox deduplication, receipt versus
worker authority, event allowlist, claim/retry/quarantine lifecycle, canonical same-account
retrieval, Payment reference/amount/currency transitions, non-terminal failed attempts,
expiry/cancellation, provider-originated Refund lifecycle and completed-refund aggregation,
A4 idempotency/audit, out-of-order delivery, redaction, rollback and disposable validation.

Confirm A6-D adds no migration, Order/Payment creation, refund initiation/UI, public
checkout/return UI, fulfilment/production authorization, FUND commission, disputes, saved
cards, delayed methods, application fees/transfers/payouts, email, real Stripe action or
shared-environment configuration.

If acceptable, mark only A6-D accepted and provide its single bounded implementation
prompt. Make no Prisma, migration, Stripe API, service, job, route, webhook or UI change
during review.
```
