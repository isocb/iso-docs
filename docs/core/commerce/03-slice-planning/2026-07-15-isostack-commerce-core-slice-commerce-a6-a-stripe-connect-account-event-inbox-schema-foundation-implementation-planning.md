# IsoStack Commerce Core Slice COMMERCE-A6-A — Stripe Connect Account And Event-Inbox Schema Foundation Implementation Planning

Date: 2026-07-15

Status: Implemented and reviewed as passed on 2026-07-15 at application commit `513cf3a`;
no Stripe API, route, webhook, service, settings UI, Checkout, payment/refund or FUND
behavior was added

Accepted parent:

`docs/core/commerce/03-slice-planning/2026-07-14-isostack-commerce-core-slice-commerce-a6-stripe-connect-tenant-payments-planning.md`

## 1. Goal

Add only the retained tenant Stripe-account, onboarding-return-state and connected-account
event-inbox persistence required by later A6 slices.

A6-A is a schema-evidence slice. It creates no Stripe account, Account Link, Checkout
Session, PaymentIntent or Refund; receives no webhook; exposes no tenant setting; and
changes no Commerce or FUND runtime behaviour.

## 2. Entry Baseline And Boundary

The implementation baseline is the valid current Prisma multi-schema model and its complete
139-migration history:

- Commerce A1-A4 schema is implemented;
- Commerce A5 provider-neutral validation/services are implemented without a migration;
- FUND C1-C6 typed context is implemented;
- `Organization.stripeCustomerId` remains the platform-subscription `cus_...` reference;
- the existing `/api/webhooks/stripe` route remains the subscription-billing webhook;
- the installed Stripe SDK is `22.2.0`, and `src/lib/stripe.ts` pins API version
  `2026-05-27.dahlia`;
- A6-A changes neither that SDK/API pin nor the subscription webhook's existing
  `STRIPE_WEBHOOK_SECRET` contract.

The next migration must sort after
`20260716001000_commerce_a4_audit_idempotency_foundation`; the proposed bounded name is:

```text
20260716002000_commerce_a6_a_stripe_connect_account_event_inbox_foundation
```

Do not adopt the preview Accounts v2 API, upgrade Stripe or encode preview-only property
names in A6-A. Database fields use normalized internal vocabulary that can be populated
from the stable controller/account contract selected in A6-B.

## 3. Accepted Ownership And Separation

### 3.1 Tenant ownership

Every A6-A row belongs to exactly one selling `Organization`. A Stripe connected-account
identifier belongs to only one IsoStack tenant in this database. Current and historic
connections can never cross tenants.

### 3.2 Generic Payment remains provider-neutral

A6-A adds no Stripe-specific foreign key or reverse relation to `CommercePayment`.
Later A6-C uses the accepted fields as follows:

```text
providerCode = STRIPE
providerAccountReference = acct_...
externalCheckoutReference = cs_...
externalPaymentReference = pi_...
externalSessionReference = null / reserved
```

The globally unique connected-account identifier and exact tenant/connection keys allow
later services to validate `providerAccountReference` without coupling generic Payment to a
Stripe table.

### 3.3 No secrets or regulated provider data

The new tables may contain safe identifiers, bounded provider status/codes, counts,
timestamps and SHA-256 hashes only. They must not contain:

- platform or tenant secret keys;
- webhook signing secrets;
- OAuth/access/refresh tokens;
- Account Link or Dashboard login URLs;
- Checkout URLs or client secrets;
- KYC values, identity documents or verification payloads;
- bank, payout-account, card or payment-method data;
- full webhook bodies or purchaser PII.

## 4. Bounded Enums

All enums are Commerce-prefixed and stored in the `commerce` schema.

### 4.1 `CommerceStripeAccountConnectionStatus`

```text
CREATED
ONBOARDING
RESTRICTED
READY
DISABLED
DISCONNECTED
```

- `CREATED`: the safe provider identity exists but hosted onboarding has not begun;
- `ONBOARDING`: onboarding has begun or submitted details remain incomplete;
- `RESTRICTED`: requirements or capability review currently prevents readiness;
- `READY`: the accepted card/charge/payout/details and controller contract is satisfied;
- `DISABLED`: the provider reports an account-level disablement that is not represented as
  an actionable onboarding requirement;
- `DISCONNECTED`: verified current deauthorization/disconnection; the row is retained and
  is no longer the tenant's current connection. The same row may leave this state only
  through a later accepted provider-supported reconnection, with A4 audit evidence.

Local checkout enablement is a separate Boolean. Turning checkout off does not change the
provider connection status to `DISABLED`.

### 4.2 `CommerceStripeCapabilityStatus`

```text
UNREQUESTED
PENDING
ACTIVE
INACTIVE
DISABLED
```

This is the normalized safe state of the requested `card_payments` capability. It preserves
the stable Stripe capability vocabulary without storing its requirements payload.

### 4.3 `CommerceStripeEventInboxStatus`

```text
RECEIVED
PROCESSING
RETRY_PENDING
PROCESSED
IGNORED
FAILED
```

`FAILED` is terminal/quarantined evidence after a permanent conflict or exhausted retry.
Transient failure uses `RETRY_PENDING` with an explicit next-attempt time.

The onboarding-attempt lifecycle is represented by mutually exclusive terminal timestamps;
it does not need a fourth enum.

## 5. `CommerceStripeAccountConnection`

Purpose: retained exact tenant-to-connected-account identity, accepted controller
configuration and latest safe readiness snapshot.

### 5.1 Planned fields

```text
id
organizationId
connectedAccountId
status
cardPaymentsCapabilityStatus
enabledForCheckout
livemode
chargesEnabled
payoutsEnabled
detailsSubmitted
dashboardType
feesPayer
lossesController
requirementsCollector
countryCode?
defaultCurrency?
disabledReasonCode?
requirementsCurrentlyDueCount
requirementsPastDueCount
requirementsPendingVerificationCount
requirementsFingerprint?
connectedAt
readyAt?
disabledAt?
disconnectedAt?
lastSyncedAt
lastProviderEventAt?
lastSyncedApiVersion
createdById
updatedById?
createdAt
updatedAt
```

Normalized fixed controller evidence is:

```text
dashboardType = FULL
feesPayer = ACCOUNT
lossesController = STRIPE
requirementsCollector = STRIPE
```

These bounded strings deliberately describe the internal accepted contract rather than
binding the schema to preview Accounts v2 property paths.

### 5.2 Exact keys and relations

- `livemode` is immutable server-derived evidence of the deployment credential/mode under
  which IsoStack established and manages this connection; it is not tenant input and is not
  read from an untrusted Account payload;
- each deployment/database supports only its configured mode and keeps its sandbox/test and
  live connected accounts separate; a production Connect endpoint may receive both Stripe
  live and test events, but an event whose `livemode` does not match the retained
  connection/deployment mode creates no inbox row;
- `connectedAccountId` is globally unique and must have the `acct_` shape;
- `(organizationId, id)` is unique for tenant ownership;
- `(organizationId, id, connectedAccountId, livemode)` is unique for exact Event Inbox
  ownership;
- `(organizationId, connectedAccountId)` is retained for tenant lookup and proof;
- a raw SQL partial unique index permits one current row per tenant where status is not
  `DISCONNECTED`;
- `organizationId` references `Organization` with `Restrict`;
- `(organizationId, createdById)` and `(organizationId, updatedById)` reference exact
  same-tenant `User` rows with `Restrict`;
- `Organization` gains only the connection reverse relation;
- `User` gains the two named creator/updater reverse relations.

`User` currently lacks a composite tenant/ID candidate key. Add exactly one supporting
`@@unique([organizationId, id])` with an explicit A6-A name. This is non-destructive because
`id` is already globally unique; it exists solely to make the actor foreign keys prove
tenant ownership.

### 5.3 Checks

- all identifiers/codes/API-version values are nonblank and length bounded;
- country is null or uppercase two-letter; currency is null or uppercase three-letter;
- requirement counts are non-negative and bounded integers;
- fingerprints are null or 64 lowercase hexadecimal characters;
- `enabledForCheckout = true` requires `status = READY`;
- `READY` requires card capability `ACTIVE`, charges/payouts/details true and the four
  accepted controller values;
- every non-`READY` status requires `enabledForCheckout = false`;
- `DISCONNECTED` requires `disconnectedAt`; another status may retain the most recent
  disconnection timestamp after an audited reconnection of the same account identity;
- `DISABLED` requires `disabledAt`;
- if any currently-due, past-due or pending-verification count is non-zero, a requirements
  fingerprint is required;
- `connectedAt <= lastSyncedAt`; provider-event and lifecycle timestamps cannot predate
  `connectedAt`;
- `lastSyncedApiVersion` is safe nonblank version evidence, not a secret.

`readyAt`, `disabledAt` and `disconnectedAt` are retained latest historical transition
evidence and may remain set after later status changes. A4 audit events retain the complete
transition sequence; A6-A does not create those events.

### 5.4 Identity immutability

A bounded PostgreSQL trigger prevents update of organization, connected-account identity,
livemode, connected time and creator and rejects deletion of the retained connection row.
Readiness/controller snapshots and their timestamps remain mutable for A6-B/A6-D
synchronization.

## 6. `CommerceStripeOnboardingAttempt`

Purpose: hashed, expiring, single-use return-state evidence for a future Stripe-hosted
onboarding attempt.

### 6.1 Planned fields

```text
id
organizationId
connectionId
initiatedById
stateHash
expiresAt
consumedAt?
expiredAt?
cancelledAt?
createdAt
updatedAt
```

### 6.2 Contract

- `(organizationId, connectionId)` references the exact connection with `Restrict`;
- `(organizationId, initiatedById)` references the exact same-tenant User with `Restrict`;
- `stateHash` is a globally unique 64-character lowercase SHA-256 value;
- the plaintext state and Account Link URL are never persisted;
- `expiresAt` is strictly later than `createdAt`;
- consumed, expired and cancelled timestamps are mutually exclusive;
- consumption must occur no later than expiry; explicit expiry occurs at or after expiry;
- a raw SQL partial unique index permits at most one unterminated attempt per connection;
- a new refresh attempt must first terminate the earlier row transactionally in A6-B;
- identity, hash, expiry, initiator and creation time are protected by a bounded update
  trigger while the three terminal fields remain mutable;
- indexes support tenant/connection expiry and initiator audit lookup.

A6-A does not generate, compare, consume or expire state. Those are A6-B service concerns.

## 7. `CommerceStripeEventInbox`

Purpose: minimal durable, deduplicated and tenant-owned connected-account event receipt for
later asynchronous A6-D processing.

### 7.1 Planned fields

```text
id
organizationId
connectionId
connectedAccountId
providerEventId
eventType
apiVersion?
livemode
providerCreatedAt
providerObjectType?
providerObjectId?
payloadHash
status
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

`providerCreatedAt` is required ordering evidence. It does not authorize applying events in
delivery order; A6-D must retrieve the canonical provider object before business mutation.

### 7.2 Exact ownership and deduplication

- `providerEventId` is globally unique and must have the `evt_` shape;
- `(organizationId, connectionId, connectedAccountId, livemode)` references the exact
  retained connection composite key with `Restrict`;
- Organization has a direct `Restrict` relation for tenant query/isolation;
- connected-account ID and livemode therefore cannot disagree with the connection;
- malformed or unknown-account webhook deliveries cannot create an unowned inbox row;
- indexes support tenant/status/retry time, connection/provider-created time and safe
  provider-object lookup.

### 7.3 Safe envelope and status checks

- event type, optional API version, optional object type/ID and optional error code are
  nonblank and length bounded when present;
- provider object type and ID are either both null or both present;
- `payloadHash` is exactly 64 lowercase hexadecimal characters;
- `attemptCount` is non-negative and bounded;
- `RECEIVED` has no processing/terminal/retry timestamp and attempt count zero;
- `PROCESSING` has `processingAt`, attempt count at least one and no terminal/retry time;
- `RETRY_PENDING` has `processingAt`, `failedAt`, `lastErrorCode`, a `nextAttemptAt` later
  than `failedAt` and no processed time;
- `PROCESSED` and `IGNORED` have `processingAt`, `processedAt`, attempt count at least one,
  no retry time and no failure time;
- terminal `FAILED` has `processingAt`, `failedAt`, `lastErrorCode` and attempt count at
  least one but no retry or processed time;
- processing, failure and completion times cannot predate receipt; `providerCreatedAt` is
  retained for ordering but is not compared to the application clock in a database check;
- no JSON payload or full webhook body column exists.

A bounded trigger makes tenant, connection, provider-event identity, event type/API version,
livemode, provider-created/object evidence, payload hash, received time and creation time
immutable and rejects deletion of the retained Event Inbox row. Processing
status/counters/error/timestamps remain mutable.

## 8. Prisma Relation Additions

Only these public-schema supporting changes are planned:

```text
Organization
  commerceStripeAccountConnections
  commerceStripeOnboardingAttempts
  commerceStripeEventInbox

User
  createdCommerceStripeAccountConnections
  updatedCommerceStripeAccountConnections
  commerceStripeOnboardingAttempts
  @@unique([organizationId, id])
```

Use explicit relation and database-constraint names. Do not add relations to Payment,
Refund, Seller Profile, FUND models or `Organization.stripeCustomerId`.

## 9. Migration And Backfill

One bounded migration performs, in dependency order:

1. create the three Commerce enums;
2. add the supporting User tenant/ID unique key;
3. create account connection;
4. create onboarding attempt and Event Inbox;
5. add exact Organization/User/connection foreign keys;
6. add checks, ordinary indexes and partial unique indexes;
7. add the three bounded identity/envelope immutability triggers.

Backfill policy is zero rows:

- create no connection, attempt or event row;
- infer no Stripe connected account from `Organization.stripeCustomerId`, settings JSON,
  Commerce provider references or free text;
- change no existing Organization, User, Commerce or FUND value;
- add no default Stripe configuration to existing tenants.

Migration review must explicitly prove the generated SQL does not drop, rewrite or relax
existing A1-A4/C1-C6 constraints.

## 10. Deletion And Retention

- Organization, actor and connection foreign keys use `Restrict`;
- connection and Event Inbox rows are retained and gain no hard-delete service;
- disconnection is a retained status transition, not row deletion;
- onboarding attempts retain only hashed state and timestamps; any later pruning policy is
  outside A6-A and requires a separate accepted retention/service contract;
- no cascade can remove payment-provider identity or event evidence;
- later user offboarding should deactivate users rather than erase referenced audit actors.

## 11. Disposable PostgreSQL Validation

All database tests use only `TEST_DATABASE_URL` after comparing normalized host, database
and connection identity with `DATABASE_URL`. Refuse to continue when equality or target
identity is uncertain. Do not touch shared development, staging or production.

### 11.1 Representative 139-to-140 migration

Create representative pre-A6 tenants, Users, Seller Profile, Checkout, Order/line,
Payment/refund/Pro-Forma, audit/idempotency and FUND C1-C6 evidence on the disposable
139-migration baseline. Apply A6-A and prove:

- every existing value and row count is unchanged;
- the User supporting key is added without rewrite/conflict;
- all three new tables are empty;
- all 140 migrations are applied with zero failure.

### 11.2 Fresh replay

Apply the complete 140-migration history to an empty disposable database and run Prisma
validation/generation plus schema-to-migration drift inspection.

### 11.3 Constraint matrix

Verify at minimum:

- valid CREATED, ONBOARDING, RESTRICTED, READY, DISABLED and DISCONNECTED connection rows;
- globally duplicate connected-account rejection;
- second current connection rejection and replacement only after retained disconnection;
- controller, readiness, capability, checkout-enable, livemode, country/currency, counts,
  fingerprint and timestamp checks;
- cross-tenant creator/updater rejection and User/Organization deletion restriction;
- connection identity/livemode mutation rejection;
- valid pending/consumed/expired/cancelled onboarding attempts;
- duplicate/plain/malformed state hash, multiple open attempts, cross-tenant initiator,
  terminal-shape, expiry and protected-field mutation rejection;
- valid RECEIVED/PROCESSING/RETRY_PENDING/PROCESSED/IGNORED/FAILED events;
- duplicate provider event, wrong connection account/livemode/tenant, malformed hash/prefix,
  object-pair, status-shape, retry and chronology rejection;
- Event Inbox immutable-envelope mutation and connection/Organization deletion rejection;
- A1-A5 and FUND C1-C6 schema/service regressions;
- existing subscription `stripeCustomerId` and webhook code remain unchanged;
- zero A6-A fixture residue.

No Stripe network call, account, payment, refund, payout or disconnection is permitted.

## 12. Rollback

Before A6-B creates any operational row, rollback may drop the new triggers, partial
indexes, tables and enums, remove only the new reverse relations/supporting User key from
Prisma, and return to the exact 139-migration schema.

After any environment contains A6-A evidence, do not roll back destructively. Disable later
runtime consumers and ship a forward correction that preserves connection/event history.

## 13. Expected Implementation Files

If later accepted, implementation is limited to:

- `prisma/schema.prisma`;
- one migration directory ordered after the A4 migration;
- one bounded disposable SQL/TypeScript smoke-test harness or extension of the established
  migration harness;
- separate A6-A implementation-confirmation and review/test records;
- Commerce, FUND and root roadmap plus Commerce planning README status updates.

## 14. Explicit Exclusions

A6-A adds no:

- Stripe SDK/API call or SDK/API-version upgrade;
- connected-account or Account Link creation;
- state generation, comparison, consumption or expiry service;
- webhook route, signature verification or event processor;
- Checkout Session, PaymentIntent, Charge or Refund behavior;
- tenant settings page, procedure, permission or UI;
- payment/refund transition or reconciliation service;
- secret/environment-variable change;
- Payment foreign key or generic Commerce field;
- FUND, Store, commission, production or fulfilment behavior;
- staging/production action or shared-database migration.

## 15. Review And Acceptance Outcome

Independent review on 2026-07-15 confirmed:

- the current Prisma schema validates and the complete baseline contains 139 migrations at
  application commit `fd7376b`;
- the three Commerce-prefixed enums cover the bounded connection, card-capability and inbox
  lifecycles without introducing provider vocabulary into generic Payment;
- fixed normalized controller evidence maps to the stable Account contract: full Dashboard,
  account-paid fees and Stripe-owned loss/requirements responsibility;
- card capability plus charges, payouts and submitted details form a conservative and
  internally consistent checkout-readiness snapshot;
- the new User `(organizationId, id)` candidate key is non-destructive and is required for
  exact same-tenant creator/updater/initiator foreign keys;
- global account identity, one-current partial uniqueness and retained same-row reconnection
  prevent both cross-tenant reuse and duplicate current configuration;
- connection `livemode` is server-derived deployment/credential evidence. Connect events
  carry their own mode, and production endpoints can receive both live and test events, so
  a mode mismatch is rejected before inbox persistence;
- exact connection/event composites, globally unique provider event IDs, safe hashes and
  immutable envelope triggers provide tenant ownership and deduplication without storing a
  webhook body;
- connection and Event Inbox deletion guards preserve provider evidence while onboarding
  attempt pruning remains explicitly deferred;
- the ordered 139-to-140 migration, zero-backfill policy, pre-runtime rollback and
  disposable validation are complete and implementable;
- installed Stripe SDK `22.2.0`, API pin `2026-05-27.dahlia`, subscription webhook and
  `Organization.stripeCustomerId` remain unchanged.

The plan is accepted for its bounded Prisma/migration implementation. Acceptance does not
authorize A6-B, any Stripe network call, account/onboarding action, webhook handler, route,
service, settings UI, Checkout, payment/refund mutation or FUND behavior.

## 16. Single Bounded Implementation Prompt

```text
Continue only accepted IsoStack Commerce Core Slice COMMERCE-A6-A. Do not begin A6-B,
A6-C, A6-D, A7, FUND Store UI or another slice.

Starting from committed application baseline `fd7376b` and its complete 139-migration
history, implement only the accepted Stripe Connect Account And Event-Inbox Schema
Foundation in the current Prisma schema and one migration ordered as
`20260716002000_commerce_a6_a_stripe_connect_account_event_inbox_foundation`.

Add only CommerceStripeAccountConnectionStatus, CommerceStripeCapabilityStatus and
CommerceStripeEventInboxStatus; CommerceStripeAccountConnection,
CommerceStripeOnboardingAttempt and CommerceStripeEventInbox; the exact Organization/User
reverse relations; and the one supporting User `(organizationId, id)` unique key. Apply the
accepted controller/readiness/status shapes, server-derived immutable livemode, global and
same-tenant identities, one-current/open-attempt partial uniqueness, hashes, chronology,
retention/deletion guards, immutable identity/envelope triggers, checks and indexes exactly
as planned.

Preserve every existing Organization, User, Commerce and FUND value. Create no connection,
attempt or event row and infer nothing from Organization.stripeCustomerId, settings JSON,
provider references or free text. Add no Stripe foreign key to CommercePayment and do not
change the installed Stripe SDK/API pin, STRIPE_SECRET_KEY, subscription
STRIPE_WEBHOOK_SECRET or existing subscription webhook.

Add no Stripe API call, account or Account Link creation, state service, webhook route or
processor, Connect webhook secret, settings procedure/UI, Checkout Session, PaymentIntent,
payment/refund transition, email or FUND behavior.

Use only TEST_DATABASE_URL after proving it differs from DATABASE_URL. Complete the
representative 139-to-140 migration, full fresh replay, every planned enum/status/controller/
readiness/tenant/actor/account/mode/onboarding/event/retry/hash/partial-unique/trigger/
deletion constraint, A1-A5/C1-C6 and subscription-billing static regressions, Prisma
validation/generation, migration review and zero-residue cleanup. Do not modify shared
development, staging or production databases.

After successful validation, create separate A6-A implementation-confirmation and
review/test records, update Commerce, FUND and root roadmaps and the Commerce planning
README, and stop. Do not start A6-B.
```
