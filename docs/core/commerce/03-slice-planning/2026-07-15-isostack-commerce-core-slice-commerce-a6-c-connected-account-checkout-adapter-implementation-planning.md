# IsoStack Commerce Core Slice COMMERCE-A6-C — Connected-account Checkout Adapter Implementation Planning

Date: 2026-07-15

Status: Implemented and reviewed as passed at application commit `34ef64bb`; A6-D, A7,
routes, UI and schema changes remain unauthorised

Parent:

`docs/core/commerce/03-slice-planning/2026-07-14-isostack-commerce-core-slice-commerce-a6-stripe-connect-tenant-payments-planning.md`

Completed dependencies:

- Commerce A1-A5 generic schema, audit/idempotency and provider-neutral services;
- A6-A Stripe Connect account/event-inbox evidence at application `513cf3a`;
- A6-B tenant settings and hosted onboarding at application `e8aecea`;
- complete 140-migration disposable PostgreSQL baseline.

## 1. Goal

Add one dormant internal Commerce service that creates or safely replays a Stripe-hosted
Checkout Session in `payment` mode as a direct charge on the seller tenant's current
connected Stripe account.

A6-C converts an already-persisted immutable Commerce Order and its already-persisted
`STRIPE_ONLINE` PENDING Payment into provider Checkout references. It does not create the
Order or Payment, expose public checkout, decide that payment succeeded, or invoke FUND.

## 2. Implementation Boundary

Expected application work is limited to:

- a narrow injectable connected-account Checkout provider adapter;
- pure Checkout request/result normalization and URL validation helpers;
- one internal tenant-scoped Checkout creation/replay service;
- the minimum correction to A5 idempotency failure/retry helpers required by the existing
  A4 status-shape constraint;
- fake-provider unit and disposable-database service tests.

A6-C adds no Prisma model, enum, relation, constraint or migration. It adds no public or C1
procedure, tRPC router, route handler, return page, webhook endpoint, UI or email. The
fixed return/cancel URL contract is produced and tested here, while the actual advisory
page/consumer invocation remains A7 work.

## 3. Authoritative Existing Records

The internal caller supplies only IDs and bounded actor evidence. The service re-reads and
locks the authoritative records; it never accepts price, seller, currency, amount,
purchaser email, connected account or provider reference from the caller.

Required exact chain:

```text
Organization
  -> ACTIVE CommerceSellerProfile
  -> SUBMITTED CommerceCheckoutSession
  -> SUBMITTED CommerceOrder
  -> PENDING STRIPE_ONLINE CommercePayment
  -> current READY + enabled CommerceStripeAccountConnection
```

The Order must have a non-null `checkoutSessionId`. The Checkout, Order, Payment, Seller
Profile and connection must all belong to the same exact tenant. The Payment must reference
that Order through the existing `(organizationId,orderId,currency)` relation. The Order's
seller profile and Checkout relation must resolve through their exact same-tenant keys.

Cancelled/closed Orders, open/expired/cancelled Checkout submissions, inactive Seller
Profiles, pro-forma/terminal Payments, disconnected/restricted/disabled connections and
cross-tenant IDs are refused.

## 4. Financial And Configuration Preconditions

Before any provider call, and again before final persistence:

- run A5 persisted Order/line arithmetic validation;
- require `Payment.currency = Order.currency`;
- require `Payment.amountRequestedMinor = Order.totalGrossMinor > 0`;
- require Payment paid/refunded amounts to remain zero;
- validate the Order currency and minor-unit exponent through A5;
- require `Payment.providerCode = STRIPE` exactly;
- require `externalSessionReference`, `safePayloadReference` and `safePayloadHash` null;
- require no conflicting provider account, Checkout Session or PaymentIntent reference;
- require the current connection's livemode to equal the server Stripe credential mode;
- retrieve the canonical Account through the existing A6-B provider boundary immediately
  before Session creation, reapply its safe normalization/readiness contract and refuse
  creation if it is no longer READY; readiness loss forces local checkout off exactly as
  A6-B already requires;
- require the source Commerce Checkout not to be expired and to retain enough lifetime for
  Stripe's minimum Checkout expiry.

Stripe permits a Checkout expiry from 30 minutes to 24 hours. Use a server-owned bounded
expiry no later than the source Commerce Checkout expiry and no later than 24 hours. Refuse
creation when fewer than 30 minutes remain; do not silently extend source authority.

## 5. Provider Adapter

Add a separate narrow adapter rather than expanding tenant-onboarding operations into a
general untyped Stripe wrapper.

```text
createPaymentCheckoutSession(request, connectedAccountId, idempotencyKey)
retrievePaymentCheckoutSession(checkoutSessionId, connectedAccountId)
expirePaymentCheckoutSession(checkoutSessionId, connectedAccountId)
```

Every provider request carries the connected account through Stripe's server-side request
option/`Stripe-Account` context. Direct-charge PaymentIntent and Checkout objects therefore
exist on the connected account and must always be retrieved using the same account context.

Production continues to use the pinned Stripe SDK `22.2.0` and API
`2026-05-27.dahlia`. Tests use an injected deterministic fake and make no network call.
The service also injects/reuses A6-B's narrow Account-retrieval and normalization boundary
for the immediate readiness refresh; it does not duplicate controller/readiness rules.
Extract the safe connection-synchronization primitive so A6-B can continue supplying its
User actor while A6-C can record a provider/system refresh with nullable `updatedById`.
Never attach a guest/customer identifier to the User foreign key.

## 6. Checkout Request Contract

Create exactly one hosted Checkout Session with:

```text
mode = payment
payment_method_types = [card]
line_items = one gross Order-summary item, quantity 1
line unit_amount = CommerceOrder.totalGrossMinor
line currency = lowercase CommerceOrder.currency
customer_email = bounded CommerceOrder.purchaserEmail
client_reference_id = CommercePayment.id
success_url/cancel_url = fixed server-owned URLs
```

Explicit `card` permits supported card wallets through Stripe without enabling delayed
methods. Do not create a Stripe Customer, save payment details, collect shipping, enable
automatic tax or promotion codes, or pass line-level Product/personalisation data.

The one summary name uses bounded Order/seller snapshot text and contains no purchaser or
production information.

Apply the same opaque metadata allowlist to the Checkout Session and
`payment_intent_data.metadata`:

```text
organizationId
orderId
paymentId
checkoutId   // the local CommerceCheckoutSession ID
```

No email, name, phone, address, source-module identifier, FUND identifier, line content,
secret or mutable amount enters metadata.

Do not set `application_fee_amount`, `transfer_data`, `on_behalf_of`, saved-card options or
another commission/transfer field. This is a direct charge owned by the connected tenant.

## 7. URL Safety And Advisory Return Contract

Reuse the A6-B deployment-origin policy: base URL comes only from an explicit server
deployment URL, development localhost is bounded, and non-development requires HTTPS. The
caller cannot supply a host, path or redirect target.

Use fixed versioned paths and opaque identifiers only. The success URL may contain Stripe's
literal `{CHECKOUT_SESSION_ID}` replacement token. The cancel URL identifies only the local
Checkout/Payment continuation context. Neither URL contains purchaser data, provider
account ID, amount, state token or an arbitrary return target.

A6-C defines/builds these URLs but exposes no route. When A7 adds the page, it may retrieve
and display current server-side status. The page must never mark a Payment paid, authorize
fulfilment/production or treat browser return as provider evidence. Only A6-D verified
webhook reconciliation may advance the Payment.

## 8. Safe Provider Result

The adapter normalizes only:

```text
Checkout Session cs_ ID
PaymentIntent pi_ ID when present
hosted Checkout HTTPS URL for immediate response only
mode, livemode, status/payment_status
currency, amount_total and expiry
```

Reject malformed IDs, non-payment mode, credential-mode mismatch, amount/currency mismatch,
unsafe/non-Stripe hosted URL or a terminal/incompatible newly-created Session.

The pinned Stripe type correctly allows `payment_intent = null` on a Checkout Session.
Therefore A6-C:

- always persists the `cs_...` Session reference after successful validation;
- persists `externalPaymentReference` only when Stripe supplies a valid `pi_...` ID;
- may fill that nullable reference during a canonical same-account replay if it becomes
  available and still agrees with the existing evidence;
- never invents or requires a PaymentIntent ID at Session creation;
- leaves authoritative later PaymentIntent discovery/reconciliation to A6-D.

The hosted URL is returned only to the trusted immediate caller and is never persisted,
placed in A4 response bodies/audit metadata, or logged.

## 9. Reference Ownership And Persistence

On successful finalization update only the existing PENDING Payment:

```text
providerAccountReference  = exact current connected acct_ ID
externalCheckoutReference = validated cs_ ID
externalPaymentReference  = validated pi_ ID when present, otherwise null
externalSessionReference  = null/reserved
```

`providerCode` remains `STRIPE`; `initiatedAt`, requested/paid/refunded values and Payment
status remain unchanged. A6-C writes no safe provider payload.

Before writing, prove the account against the exact tenant connection. A normal first
creation requires that connection to remain current, READY and enabled. A completed replay
uses the Payment's retained account reference and exact retained tenant connection even if
a later current connection exists; it must never query a direct-charge object under a
different account.

Any existing partial/conflicting shape is rejected unless it is the exact completed A6-C
evidence being replayed. Provider reference uniqueness and exact ownership remain protected
by the A3 indexes and service checks.

## 10. Idempotency, Concurrency And Remote Failure

The durable uniqueness boundary is the Payment, not a caller-generated operation UUID.
Claim A4 scope `STRIPE_CHECKOUT.CREATE` with the Payment ID as the tenant-scoped key and a
canonical request hash of authoritative Order/Payment/connection/URL-policy evidence. This
prevents two different client operation IDs from creating two Sessions for one Payment.

Use a short transaction to:

1. take ordered tenant/Payment advisory locks;
2. lock and validate the complete persisted chain;
3. claim/commit the A4 processing record.

Outside the database transaction, retrieve and normalize the canonical connected Account.
If readiness was lost, use a short transaction to persist the safe A6-B snapshot/forced
disable and fail the operation without creating a Session. Otherwise create the Session
with a stable provider idempotency key derived from the retained A4 record ID. Then use a
second SERIALIZABLE transaction to reacquire the same locks, revalidate all authority and
provider output, atomically persist references, emit A4 audit and complete idempotency.

This avoids holding database locks during a network call. If Stripe succeeds and local
finalization fails, retry uses the same Stripe idempotency key and converges on the same
Session. Provider failure records only a bounded safe failure code; no provider body is
retained.

The existing A5 `failCommerceIdempotency` helper conflicts with the A4 database contract:
`FAILED` requires non-null `completedAt`, and retrying a failed/expired record must clear
terminal response/resource/error/completion fields before returning to `PROCESSING`.
A6-C implementation must correct only those generic helper assignments and add direct
FAILED -> PROCESSING constraint tests. This is prerequisite remediation, not a new
payment/provider state.

If the provider creates a Session but second-transaction authority has permanently changed
(for example the Order was cancelled or connection disabled), do not return its URL. Make
a bounded best-effort `expire` call under the same connected-account context. A transient
database failure remains retryable against the same provider idempotency key rather than
prematurely expiring the convergent Session. Expiry failure returns a redacted operational
error and never authorizes local persistence or payment; later provider evidence remains
A6-D responsibility.

Completed local replay retrieves the recorded Session under its recorded connected account
and returns its safe current hosted URL only while Stripe reports it redirectable. It never
creates a replacement Session. Expired/completed Sessions return a bounded non-redirectable
result; a later workflow may create a new Payment attempt only after A6-D has reconciled the
old one.

## 11. Audit And Data Minimisation

Successful creation emits append-only A4 evidence such as
`STRIPE.CHECKOUT.SESSION_CREATED`, bound to the idempotency record and Payment, containing
only safe IDs, mode, currency, amount, livemode and boolean PaymentIntent-presence.

Core tenant audit is not required for the public/internal purchase action; A4 Commerce
audit is the authoritative cross-actor record. Actor evidence is bounded to the trusted
caller's `USER`, `GUEST` or `SERVICE` classification and optional opaque actor ID. A6-C
does not persist purchaser identity in audit metadata.

Idempotency completion stores only a bounded result code and Payment resource identity. It
stores no Checkout URL, email, secret, client secret, payment method or provider payload.

## 12. Validation Plan

Use only `TEST_DATABASE_URL` after proving it differs from `DATABASE_URL`. Require the
unchanged complete 140-migration inventory.

Pure/fake-provider coverage:

- direct connected-account request context and stable provider idempotency;
- one summary line, card-only method, metadata allowlist and bounded email;
- fixed HTTPS/localhost URLs and unsafe-host/path rejection;
- valid/null/malformed/conflicting PaymentIntent results;
- Session ID, URL, mode, account-mode, amount, currency and expiry normalization;
- no real Stripe call or charge.

Disposable service coverage:

- exact tenant Checkout/Order/Payment/Seller/connection ownership;
- inactive/terminal/expired/cross-tenant and readiness/enablement refusal;
- fresh provider Account readiness loss forcing local checkout off before Session creation;
- persisted Order/line arithmetic, positive amount and exact currency reconciliation;
- Payment-key idempotent replay, different-request conflict and concurrent convergence;
- provider failure, post-provider injected rollback and stable retry convergence;
- valid A4 FAILED shape, FAILED/expired retry-field clearing and constraint compliance;
- permanent post-create authority loss, no URL return and best-effort Session expiry;
- provider-account/Checkout/PaymentIntent partial and conflicting-reference refusal;
- PaymentIntent-null creation and later safe fill on replay;
- Payment status and money values remain unchanged;
- A4 audit/idempotency redaction and append-only behavior;
- A1-A6-B, FUND C1-C6 and subscription-billing static regressions;
- zero A6-C fixture residue.

No migration replay beyond confirming the retained 140 baseline is required because A6-C
changes no schema.

## 13. Explicit Exclusions

A6-C adds no:

- public/C1 route, return/cancel handler, UI or public checkout orchestration;
- Order, line, Payment or consumer-context creation;
- payment success/failure/expiry transition;
- webhook receipt, event-inbox processing or reconciliation;
- refund, dispute, saved card, Stripe Customer or delayed payment method;
- application fee, transfer, destination charge, payout or FUND commission split;
- Store readiness/publication, production authorization, fulfilment or FUND behavior;
- schema migration, environment secret, subscription-billing change or real Stripe test.

A6-D remains responsible for verified connected-account events, Payment/refund transitions
and reconciliation. A7 remains responsible for the consumer/public invocation and advisory
return experience.

## 14. Rollback

Application rollback removes only the dormant A6-C adapter/service/tests. There is no
database rollback. Any provider Session created after future activation remains provider
and audit evidence and must not be deleted or hidden by application rollback.

## 15. Official Provider References

- direct charges and connected-account request context:
  `https://docs.stripe.com/connect/direct-charges`
- Checkout Session creation:
  `https://docs.stripe.com/api/checkout/sessions/create`
- Checkout lifecycle and webhook authority:
  `https://docs.stripe.com/payments/checkout/how-checkout-works`
- Stripe idempotent requests:
  `https://docs.stripe.com/api/idempotent_requests`

## 16. Review And Acceptance Outcome

Review against the accepted A6 parent, current Prisma/PostgreSQL constraints, A5 helpers,
A6-A/A6-B implementation and pinned Stripe types resolved:

- Payment ID is the correct one-Session-per-Payment idempotency boundary; caller operation
  UUIDs alone cannot prevent competing Session creation;
- two short local transactions around the provider call avoid holding database locks while
  the A4 record ID supplies one stable Stripe idempotency key;
- provider Session retrieval/replay always uses the Payment's retained connected account;
- canonical Account refresh reuses A6-B normalization, with a nullable system updater for
  guest checkout rather than a false User relation;
- the A4 constraint requires a bounded correction to A5 failure/retry assignments before
  A6-C can safely record and retry provider failures;
- provider Session expiry is required as best-effort compensation for permanent authority
  loss after remote creation and before local finalization;
- creation-time `payment_intent` is nullable in the pinned Stripe contract, so A3's
  nullable field is preserved and A6-D remains authoritative for later discovery;
- one gross card-only Session, fixed URLs, opaque metadata and transient URL response meet
  the minimisation boundary;
- no route/UI is required until A7 activates the dormant service;
- no paid/failed/expired Payment transition, webhook/refund authority or FUND responsibility
  enters A6-C.

The plan is accepted for bounded implementation.

Implementation and review completed on 2026-07-15. The dormant adapter, A5 idempotency
correction and fake-provider/disposable-database evidence are recorded in the matching
`04-implementation-confirmations` and `05-review-and-test` documents. No migration,
shared-database change or real Stripe action occurred.

## 17. Single Bounded Implementation Prompt

```text
Continue only accepted IsoStack Commerce Core Slice COMMERCE-A6-C. Do not begin A6-D, A7,
FUND Store UI or another slice.

Starting from committed A6-B application baseline e8aecea and the complete unchanged
140-migration history, implement only the dormant internal connected-account Checkout
adapter/service and tests exactly as accepted. Add the narrow fakeable create/retrieve/
expire Session adapter; fixed server URL builder; safe direct-charge request/result
normalization; exact tenant Checkout/Order/Payment/Seller/connection locking and validation;
fresh A6-B Account readiness synchronization; Payment-key A4 idempotency; provider-call-
outside-transaction flow; stable retry/replay; atomic safe reference persistence; A4 audit;
and best-effort compensation for permanent post-create authority loss.

Apply only the required provider-neutral A5 helper correction: FAILED must set completedAt,
and FAILED/expired retry must clear terminal completion/response/resource/error fields
before PROCESSING. Add direct PostgreSQL constraint tests for both paths. Add no schema or
migration.

Create one gross card-only payment-mode Session as a direct charge under the exact retained
connected account. Derive amount, currency, email, metadata and expiry only from persisted
authority. Persist providerAccountReference and externalCheckoutReference; persist
externalPaymentReference only when Stripe supplies a valid PaymentIntent; keep
externalSessionReference and safe-payload fields null. Never persist/log/audit the Checkout
URL, email, secret, client secret, payment method or provider body.

Add no public/C1 procedure, router, route, return page, UI, Order/Payment creation,
Payment status/money transition, webhook, refund, application fee/transfer, Store,
production, commission or FUND behavior. Make no real Stripe network call or charge.

Use only TEST_DATABASE_URL after proving it differs from DATABASE_URL. Verify unchanged
140 migrations, fake-provider direct-account context, ownership/readiness/arithmetic/
amount/currency/URL/reference checks, Payment-key idempotency and concurrency, FAILED retry
constraints, null/later PaymentIntent, rollback/compensation/replay, audit redaction,
A1-A6-B/C1-C6 and subscription regressions and zero residue.

After successful validation, create separate A6-C implementation-confirmation and
review/test records, update Commerce, FUND and root roadmaps and Commerce planning README,
and stop. Do not start A6-D.
```
