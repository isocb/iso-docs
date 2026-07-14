# IsoStack Commerce Core Slice COMMERCE-A6 — Stripe Connect Tenant Payments Planning

Date: 2026-07-14

Status: Reviewed and accepted on 2026-07-14; authorises creation of the bounded A6-A
implementation-planning document only; no A6 schema, Stripe account, route, webhook or UI
implementation is authorised by this document

Parent architecture:

`docs/core/commerce/02-triage/2026-07-13-isostack-commerce-core-schema-foundation-planning.md`

Depends on completed Commerce A1-A5 and FUND C1-C6. The Neon development database is
current through all 139 existing migrations before A6 planning begins.

## 1. Purpose

Add Stripe as the first provider adapter for generic IsoStack Commerce while preserving:

- C1 tenant ownership of the seller relationship;
- generic Commerce ownership of Order, Payment, Refund and provider evidence;
- typed FUND ownership of Store, Project, production and commission context;
- A4 idempotency/audit and A5 provider-neutral validation boundaries;
- strict separation from IsoStack's existing Stripe subscription billing.

A6 includes tenant Stripe configuration in the tenant master settings. It does not make
FUND the owner of Stripe, and it does not store a Stripe secret key supplied by each tenant.

## 2. Accepted business and platform direction

### 2.1 One tenant, one current seller connection

Each selling `Organization` has at most one current Stripe connected-account connection.
Historic disconnected/replaced connections remain retained because Payments may reference
them. Connection evidence is tenant-owned and cannot be shared across Organizations.

Provider-neutral `CommercePayment` remains the commercial evidence owner. For Stripe in
the first pass, `providerCode = STRIPE`, `providerAccountReference` holds the retained
`acct_...` connected-account reference, `externalCheckoutReference` holds the `cs_...`
Checkout Session reference and `externalPaymentReference` holds the `pi_...` PaymentIntent
reference. `externalSessionReference` remains unused/reserved. A6 must not make the generic
Payment model dependent on a Stripe-only foreign key; exact tenant/account ownership is
proved against the retained connection before every provider operation and recorded in A4
audit evidence.

### 2.2 The C1 tenant is merchant of record

The C1 tenant is already the accepted seller. A6 therefore uses Stripe Connect direct
charges on the tenant's connected account. The connected account receives the payment,
pays Stripe processing fees, owns refunds/disputes and has full Stripe Dashboard access.

The first pass adds no Stripe application fee or checkout-time split. FUND commission is a
separate post-close business calculation and is not a Stripe transfer or application fee.

### 2.3 Stripe-hosted account management

Use Stripe-hosted Connect onboarding with a full Stripe Dashboard account configuration,
Stripe collecting requirements, Stripe collecting its fees and Stripe managing connected
account loss risk where the tenant/country configuration supports it. This minimises KYC,
PCI, dispute and payout functionality inside IsoStack.

The intended account-controller contract is therefore full Dashboard access, Stripe as
requirements collector, the connected account paying Stripe processing fees, Stripe
responsible for connected-account losses and the card-payments capability requested. The
chosen stable API representation must preserve that contract exactly.

Do not start a new integration with Connect OAuth. Do not build custom KYC forms or store
identity documents. Before A6-A implementation, confirm the stable Accounts API/controller
shape supported by the repository's pinned Stripe SDK/API version; do not silently adopt a
preview Accounts v2 contract or upgrade Stripe as part of A6.

### 2.4 Environment and secrets

- `STRIPE_SECRET_KEY` remains a platform/deployment secret and is never persisted or shown.
- add a separate `STRIPE_CONNECT_WEBHOOK_SECRET` per deployment environment;
- test/sandbox versus live mode is controlled by deployment configuration, never by a
  tenant UI switch;
- tenant rows store connected-account identifiers and safe readiness snapshots only;
- `Organization.stripeCustomerId` remains reserved for the tenant's IsoStack subscription
  billing and must not be reused for Commerce seller payments;
- existing subscription-billing routes/webhooks must remain isolated from Connect Commerce
  routes and connected-account events.

## 3. Bounded serial delivery

COMMERCE-A6 is a parent planning slice, not one executable implementation unit:

```text
COMMERCE-A6-A - Stripe Connect Account And Event-Inbox Schema Foundation
  -> COMMERCE-A6-B - Tenant Payment Settings And Stripe-hosted Onboarding
  -> COMMERCE-A6-C - Connected-account Checkout Session Adapter
  -> COMMERCE-A6-D - Connect Webhook, Refund Sync And Reconciliation
  -> COMMERCE-A7 - FUND Consumer Integration
```

Each child requires separate planning acceptance, implementation confirmation and
review/test evidence. Do not combine the four children into one implementation.

## 4. A6-A — account and event-inbox schema foundation

Plan one bounded Commerce migration for Stripe-specific provider evidence.

### 4.1 `CommerceStripeAccountConnection`

Purpose: retained tenant-to-connected-account history and current readiness.

Core fields:

```text
id
organizationId
connectedAccountId
status = CREATED | ONBOARDING | RESTRICTED | READY | DISABLED | DISCONNECTED
enabledForCheckout
livemode
chargesEnabled
payoutsEnabled
detailsSubmitted
countryCode?
defaultCurrency?
disabledReasonCode?
requirementsCurrentlyDueCount
requirementsPastDueCount
requirementsFingerprint?
connectedAt?
readyAt?
disabledAt?
disconnectedAt?
lastSyncedAt?
lastProviderEventAt?
createdById?
updatedById?
createdAt
updatedAt
```

The readiness snapshot also records the bounded card-payments capability state required by
the pinned Stripe Accounts API, for example `UNREQUESTED | PENDING | ACTIVE | INACTIVE`.

Contracts:

- connected account ID is globally unique;
- a partial unique index permits only one non-disconnected/current connection per tenant;
- `READY` requires active card payments, charges enabled, payouts enabled and details
  submitted; the conservative payout requirement prevents new sales accumulating while a
  tenant cannot receive funds;
- checkout requires `READY` plus `enabledForCheckout=true`;
- disable/disconnect never deletes a connection or commercial evidence;
- safe requirement counts/codes may be stored, never Stripe KYC values/documents;
- exact tenant keys support Payment and event ownership checks.

### 4.2 `CommerceStripeOnboardingAttempt`

Store a hashed, expiring, single-use onboarding/return state bound to the exact tenant,
connection and initiating OWNER. Do not persist the Account Link URL, authorization code,
secret or full provider response. Return/refresh redirects are navigation only; readiness
always comes from a server-side account retrieval or verified event.

### 4.3 `CommerceStripeEventInbox`

Purpose: durable, deduplicated receipt before asynchronous provider-object reconciliation.

Core fields:

```text
id
organizationId
connectionId
providerEventId
connectedAccountId
eventType
apiVersion?
livemode
providerObjectType?
providerObjectId?
payloadHash
status = RECEIVED | PROCESSING | PROCESSED | IGNORED | FAILED
attemptCount
receivedAt
processingAt?
processedAt?
failedAt?
lastErrorCode?
nextAttemptAt?
createdAt
updatedAt
```

Contracts:

- provider event ID is unique;
- every persisted connected-account event must first resolve to the same exact retained
  tenant connection; malformed or unknown-account deliveries create no unowned Commerce
  inbox row;
- no purchaser PII, card data or full webhook body is retained;
- after signature verification, retain a payload hash and minimal safe envelope, then
  retrieve the canonical provider object under the connected account when processing;
- receipt status is mutable operational evidence; corresponding business transitions emit
  append-only A4 audit events;
- restrictive deletion retains event/payment history.

### 4.4 Migration policy

Zero backfill. Existing Organization billing IDs and Commerce/FUND rows remain unchanged.
Run representative 139-to-140 and fresh disposable migrations, same-tenant/current-account
uniqueness, status-shape, deletion, event dedupe and zero-residue tests. A6-A adds no Stripe
API call, route or UI.

## 5. A6-B — tenant master payment settings and onboarding

Add an Organisation settings tab at `/settings/payments`, visible to tenant OWNER and ADMIN
for status. Only OWNER may connect, resume onboarding, enable/disable checkout or request a
provider-supported disconnection.
Platform administrators do not mutate a tenant connection unless using an existing,
explicitly audited impersonation/support path.

### 5.1 UI states

The page shows:

- Not connected — `Connect Stripe`;
- Onboarding incomplete — `Continue setup` and safe outstanding-requirement count;
- Restricted/action required — clear explanation and Stripe-hosted remediation link;
- Ready but disabled — `Enable online payments`;
- Ready and enabled — charges/payouts ready, last synchronized time and Stripe Dashboard
  link;
- Disconnected — retained-history explanation and a new connection action when the chosen
  Stripe account contract permits it.

Never render or accept secret keys, webhook secrets, access/refresh tokens, KYC fields or
bank/card data. Payment methods, payouts, disputes, statement descriptors and bank accounts
remain managed in Stripe Dashboard in the first pass.

### 5.2 Onboarding services

- OWNER-only mutation creates the tenant's connected account through the platform;
- account creation and Account Link creation use A4/Stripe idempotency keys;
- return and refresh URLs are server-generated from allowlisted IsoStack domains;
- Account Link URLs are short-lived, never logged and returned only to the requesting OWNER;
- returning from Stripe triggers a server-side account sync; it does not itself prove
  readiness;
- `account.updated` and deauthorization events remain authoritative for later state changes;
- local disable is always available and blocks new checkout immediately;
- provider disconnection/removal must use only the operation supported by the chosen stable
  full-Dashboard account contract; A6 must not call account deletion for a live account for
  which Stripe is responsible for losses, and inability to disconnect never prevents local
  checkout disablement;
- every configuration transition emits an A4 Commerce audit event and core tenant audit
  evidence without secrets.

A6-B does not create Checkout Sessions, Payments or Orders.

## 6. A6-C — connected-account Checkout adapter

Use Stripe-hosted Checkout in `payment` mode for the first online-payment path. Direct
charges are created under the tenant connected account using the server-side
`Stripe-Account` context.

### 6.1 Preconditions

- authenticated internal service call or accepted later public-checkout boundary;
- exact tenant Order and `STRIPE_ONLINE` Payment in `PENDING` state;
- active Seller Profile;
- current tenant connection `READY` and enabled;
- Payment amount/currency exactly matches immutable Order gross/currency;
- A5 arithmetic and state validation passes;
- Checkout/Payment have not already acquired conflicting provider references.

### 6.2 Checkout creation

- use one gross Order-summary line in the first pass so Stripe's payable amount exactly
  equals the immutable Commerce total; detailed product/personalisation remains on the
  IsoStack Order review page;
- configure cards/wallets only initially; delayed payment methods remain deferred until
  their lifecycle is explicitly implemented;
- purchaser email may prefill Checkout but is never placed in metadata;
- metadata contains opaque tenant, Order, Payment and Checkout IDs only;
- success/cancel URLs are server-generated and allowlisted;
- Stripe request idempotency derives from the A4 operation record;
- store the connected account in `providerAccountReference`, Checkout Session in
  `externalCheckoutReference` and PaymentIntent in `externalPaymentReference`; leave
  `externalSessionReference` null/reserved in the first pass;
- never store the Checkout URL, client secret, payment method or card details;
- use no application fee, destination transfer or commission split.

The success/return page is advisory. It may display current server-side status but must not
mark a Payment paid, create fulfilment or authorize production. Verified webhook evidence
is authoritative.

## 7. A6-D — webhooks, refund synchronization and reconciliation

Create a dedicated connected-accounts webhook endpoint, separate from IsoStack subscription
billing webhooks.

### 7.1 Receipt boundary

- read the untouched raw request body;
- verify `Stripe-Signature` with the environment-specific Connect webhook secret and the
  official Stripe library/default timestamp tolerance;
- reject invalid signatures, unknown livemode or malformed envelopes;
- map the top-level connected account ID to one tenant connection;
- insert/dedupe the minimal inbox envelope and return `2xx` promptly;
- process only an explicit event allowlist; unrelated events become safely `IGNORED`;
- never trust webhook delivery order and never process the same event twice.

### 7.2 Processing boundary

Retrieve the canonical Checkout Session, PaymentIntent, Refund or Account object using the
connected-account context. Under row/advisory locks and A4 idempotency:

- synchronize account readiness/deauthorization;
- reconcile Checkout completion, expiry and asynchronous payment outcomes;
- transition Commerce Payment using A5 rules;
- synchronize refunds created either by an internal future service or directly in the
  tenant Stripe Dashboard; a provider-originated refund creates tenant-scoped
  `CommerceRefund` evidence and advances it through the accepted A5 lifecycle rather than
  bypassing refund state constraints;
- aggregate completed refunds and update Payment status atomically;
- emit append-only audit events and retain provider request/event IDs;
- retry transient failures with bounded attempts; quarantine permanent tenant/object/
  currency/amount conflicts for C1/platform operational review.

First-pass fulfillment/production must not be triggered by A6. A7/FUND later consumes a
paid Commerce Payment and separately enforces physical-artwork/readiness gates.

### 7.3 Deferred Stripe behavior

Defer disputes/chargeback schema, saved cards/Stripe Customers, subscriptions, Payment
Element, embedded Checkout, delayed payment methods, multicurrency conversion, application
fees, destination/separate charges, platform payouts, automatic tax, refund UI and payout
reporting. C1 can manage disputes and manual refunds in its full Stripe Dashboard; A6-D
only synchronizes the supported Refund evidence.

## 8. Security and operational requirements

- redact all `sk_`, `whsec_`, Account Link, client-secret and payment-method values from
  logs/errors/audit metadata;
- pin and record the Stripe SDK/API version; upgrades require separate review;
- separate test and live keys, Connect endpoint secrets and connected accounts;
- verify tenant, livemode, currency, amount and provider-object ownership on every call;
- use stable idempotency keys for every Stripe POST and local A4 operation;
- configure the Stripe event destination for connected accounts and only required events;
- rotate webhook secrets with an overlap window supported by deployment configuration;
- no provider payload may override immutable Order seller, amount, currency or source data;
- no hard deletion of provider/payment/refund/audit evidence.

## 9. Validation strategy

Each child plan must include:

- unit tests with a fake Stripe adapter—no network or real charge required;
- tenant isolation, authorization, idempotency, concurrency and rollback tests;
- disposable PostgreSQL migration/service tests through the current baseline;
- signed raw-body webhook fixtures, invalid/tampered/stale signature cases;
- duplicate and out-of-order event processing;
- mismatched tenant/account/livemode/currency/amount rejection;
- completed, failed, expired and refunded payment paths;
- existing IsoStack subscription-billing regression tests;
- settings UI states and OWNER/ADMIN authorization tests;
- optional Stripe sandbox/CLI end-to-end evidence only when explicit test credentials and
  a safe endpoint are available;
- zero fixture residue and no staging/production activity.

No real payment, refund, payout or account disconnection is permitted in automated tests.

## 10. Official Stripe references

- Connect for SaaS platforms and merchant-of-record direction:
  `https://docs.stripe.com/connect/saas-platforms-and-marketplaces`
- connected-account configuration and responsibilities:
  `https://docs.stripe.com/connect/accounts-v2/connected-account-configuration`
- Stripe-hosted onboarding:
  `https://docs.stripe.com/connect/hosted-onboarding`
- direct charges and connected-account request context:
  `https://docs.stripe.com/connect/direct-charges`
- connected-account authentication:
  `https://docs.stripe.com/connect/authentication`
- Checkout lifecycle:
  `https://docs.stripe.com/payments/checkout/how-checkout-works`
- webhook signatures, duplicates, ordering and prompt acknowledgement:
  `https://docs.stripe.com/webhooks`
- Stripe idempotent requests:
  `https://docs.stripe.com/api/idempotent_requests`

## 11. Review and acceptance outcome

Independent review on 2026-07-14 confirmed:

- completed Commerce A1-A5 already owns the generic seller, Order, line, payment, refund,
  Pro-Forma, idempotency and audit contracts required by A6;
- completed FUND C1-C6 remains a typed consumer and gains no Stripe ownership or commission
  split;
- direct charges, full Stripe Dashboard access and Stripe-collected fees/requirements/loss
  responsibility align with the accepted C1-as-seller model;
- `Organization.stripeCustomerId` and the existing subscription webhook remain isolated
  platform-subscription evidence;
- no tenant secret key, webhook secret, OAuth token, KYC document, bank or card data enters
  tenant configuration;
- Checkout return navigation is advisory and verified connected-account webhook evidence
  remains authoritative;
- mandatory tenant/connection event ownership, explicit provider-reference mapping,
  conservative card/payment/payout readiness and local checkout disablement resolve the
  ambiguities found during review;
- A6-A through A6-D remain the correct serial boundaries.

The parent is accepted. This acceptance authorises creation and later independent review of
the bounded A6-A implementation plan only. It authorises no Prisma, migration, Stripe API,
route, webhook or UI change.

## 12. Single bounded A6-A planning prompt

```text
Continue only accepted IsoStack Commerce Core Slice COMMERCE-A6-A planning. Do not
implement schema or application code and do not begin A6-B, A6-C, A6-D, A7, FUND Store UI
or another slice.

Create one bounded Stripe Connect Account And Event-Inbox Schema Foundation implementation
plan against the complete 139-migration Commerce A1-A4/FUND C1-C6 baseline and completed
A5 provider-neutral services. Plan only the bounded Commerce-prefixed enums,
CommerceStripeAccountConnection, CommerceStripeOnboardingAttempt and
CommerceStripeEventInbox plus the minimum Organization/User reverse relations or exact
same-tenant keys required by Prisma.

Resolve one current retained connection per tenant, globally unique connected-account
identity, full-Dashboard/Stripe-fees/Stripe-losses/Stripe-requirements controller evidence,
card-payment/charge/payout/details readiness, local checkout enablement, immutable
livemode, exact tenant/connection event ownership, provider-event deduplication, bounded
processing state, safe payload hash/envelope retention, hashed expiring single-use
onboarding state, actor ownership, restrictive deletion and zero backfill. Preserve the
accepted generic CommercePayment provider-reference mapping without adding a Stripe-only
Payment foreign key. Preserve Organization.stripeCustomerId exclusively for IsoStack
subscription billing.

Define one migration, rollback and disposable PostgreSQL validation for representative
139-to-140 and fresh replay, current-connection and provider-event uniqueness, every
status/check/tenant/deletion constraint, A1-A5/C1-C6 regressions and zero residue. Add no
Stripe API call, account creation, secret, route, webhook handler, settings UI, Checkout,
payment/refund transition or FUND behavior.

Leave the new A6-A implementation plan awaiting explicit review and acceptance and provide
its single review prompt. Make no Prisma, migration, service, API, route, webhook or UI
change.
```
