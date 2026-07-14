# IsoStack Commerce Core - Schema Foundation Planning

Date: 2026-07-13

Status: Accepted planning / separate platform lane / no implementation

Initial consumer: FUND Project Store

Roadmap control:

`docs/core/commerce/00-roadmap-control/2026-07-13-commerce-core-roadmap-and-slice-control.md`

## 1. Purpose

Plan a reusable IsoStack Commerce Core schema for checkout, Orders, money, payments, refunds
and pro-forma routes without embedding FUND Project or production concepts into the core.

This document is the separate platform-level plan required by:

- `docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-b-commerce-core-and-fund-store-schema-options-planning.md`;
- `docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c-fund-store-input-schema-foundation-planning.md`.

It does not implement Prisma schema, migrations, services, Stripe or FUND integration.

## 2. Core Principle

```text
Commerce Core knows how something is ordered and paid for.
The consuming module knows why it is sold and what operational work follows.
```

For FUND:

- Commerce owns the commercial Order and payment evidence;
- FUND owns Project Store, artwork, production, fulfilment and commission context;
- Commerce treats FUND Store/Store Product identifiers as opaque source references;
- FUND writes typed extension records keyed to Commerce Order/line IDs.

Commerce must not import or query FUND eligibility, Project, artwork or commission models.

## 3. Proposed Database Placement

Add a dedicated PostgreSQL/Prisma schema:

```text
commerce
```

`COMMERCE-A1` has now added `commerce` to the local Prisma datasource schema list alongside:

```text
public
bedrock
lmspro
pulse
fund
commerce
```

The A1 migration exists locally and passes static/generated-client plus disposable-database
migration/constraint review. This architecture record does not claim deployment to shared
development, staging or live databases.

Why a dedicated schema:

- Commerce is reusable platform infrastructure, not a FUND sub-domain;
- names such as Order, Payment and Refund should not collide with module concepts;
- migrations and ownership are easier to review;
- other modules can consume the same contracts later.

The schema is a namespace inside the existing IsoStack PostgreSQL database. It is not a
separate database or a substitute for tenant authorization.

## 4. Accepted First Boundary

Commerce Core v1 should include:

- tenant seller/tax profile;
- checkout session;
- Order;
- Order line;
- payment attempts/outcomes;
- refunds;
- pro-forma invoice route;
- audit/idempotency evidence;
- generic consumer source references.

Commerce Core v1 should not include:

- a generic Product/Catalogue registry;
- inventory, stock or warehouses;
- subscriptions or entitlements;
- FUND Projects, Stores or artwork;
- production/dispatch;
- commission policy/accounting;
- supplier marketplace logic.

Subscriptions and entitlements may later share payment/provider infrastructure, but they
must not inflate the first Order schema foundation.

## 5. Consumer Reference Contract

Recommended generic source fields:

```text
sourceModuleCode
sourceEntityType
sourceEntityId
```

Order-line equivalent:

```text
sourceItemType
sourceItemId
```

FUND example:

```text
sourceModuleCode = FUND
sourceEntityType = PROJECT_STORE
sourceEntityId = FundProjectStore.id

sourceItemType = FUND_PROJECT_STORE_PRODUCT
sourceItemId = FundProjectStoreProduct.id
```

Rules:

- identifiers are opaque to Commerce;
- source module service validates purchasability before Order creation;
- Commerce snapshots display/configuration data and never relies on live source rows for
  historic rendering;
- source references cannot authorize tenant access by themselves;
- generic reference types require controlled stable codes, not arbitrary user text.
- every Order line inherits its Order's `sourceModuleCode`; Commerce v1 does not permit one
  Order to mix source items from unrelated modules.

## 6. Recommended Models

### 6.1 `CommerceSellerProfile`

Purpose:

- C1/tenant legal seller identity and default checkout tax/money policy.

Candidate fields:

- `id`, unique `organizationId`;
- legal name;
- structured legal address;
- country code;
- tax/VAT registration reference;
- default currency;
- prices-include-tax default;
- rounding method;
- active state;
- created/updated actor/timestamps.

Historic Orders copy the effective values. They do not render from the current profile.

### 6.2 `CommerceCheckoutSession`

Purpose:

- provisional basket and submission boundary.

Candidate fields:

- `id`, `organizationId`;
- high-entropy public/session identifier hash where used publicly;
- source reference tuple;
- currency;
- status;
- source configuration version/fingerprint;
- idempotency key;
- expiry/submission timestamps;
- created/updated timestamps.

Recommended states:

```text
OPEN
SUBMITTED
EXPIRED
CANCELLED
```

The source module owns basket-item validation. Commerce owns expiry, idempotent submission
and the one-session-to-one-Order transition.

### 6.3 `CommerceOrder`

Purpose:

- immutable commercial header and totals.

Candidate fields:

- `id`, `organizationId`;
- tenant-scoped order number;
- source reference tuple;
- optional checkout-session relation;
- Order status;
- currency and minor-unit exponent;
- seller snapshot;
- purchaser/contact snapshot;
- item net, discount, delivery, tax, gross/final, refunded and adjusted totals in minor
  units;
- submitted/cancelled/closed timestamps;
- created/updated audit fields.

Recommended first Order states:

```text
SUBMITTED
CANCELLED
CLOSED
```

Order status does not encode paid, refunded, produced or dispatched.

### 6.4 `CommerceOrderLine`

Purpose:

- immutable purchased-item/configuration and monetary evidence.

Candidate fields:

- `id`, `organizationId`, `orderId`, sort order;
- source item tuple;
- Product/item code, name, description and display snapshot;
- quantity;
- unit net/gross amount;
- modifier total;
- discount, net, tax and gross line totals;
- tax treatment, category code and applied rate;
- inclusive/exclusive basis;
- source configuration version/hash;
- validated configuration/rendering snapshot;
- timestamps.

One line represents one resolved configuration. Consumers create separate lines when
personalisation differs.

### 6.5 `CommercePayment`

Purpose:

- provider-neutral payment request/attempt/outcome.

Candidate fields:

- `id`, `organizationId`, `orderId`;
- payment route and provider code;
- provider-account reference;
- external checkout/payment/session references;
- requested, paid and refunded amount;
- currency;
- payment status;
- idempotency key;
- safe provider-payload reference/hash;
- initiated/paid/failed/cancelled timestamps;
- created/updated audit fields.

Accepted initial routes:

```text
STRIPE_ONLINE
PRO_FORMA_INVOICE
```

Accepted initial payment states:

```text
NOT_REQUIRED
PENDING
PAID
FAILED
CANCELLED
PARTIALLY_REFUNDED
REFUNDED
```

One Order may have several payment attempts. The schema must not assume one external Stripe
object per Order forever.

### 6.6 `CommerceRefund`

Purpose:

- append refund/adjustment evidence rather than deriving history only from current payment
  status.

Candidate fields:

- `id`, `organizationId`, `orderId`, `paymentId`;
- amount/currency;
- provider reference;
- status/reason;
- requested/completed timestamps;
- actor/audit fields.

Plan for later line allocation. Do not require every refund to cover the whole Order.

### 6.7 `CommerceProFormaInvoice`

Purpose:

- separate manual/pro-forma document lifecycle attached to an Order.

Candidate states:

```text
DRAFT
ISSUED
ACCEPTED
CANCELLED
SETTLED
```

Candidate fields:

- `id`, `organizationId`, `orderId`;
- tenant-scoped pro-forma reference;
- status;
- issue/due dates where enabled;
- issued/accepted/settled timestamps;
- generated-document reference;
- C1 notes/audit fields.

`SETTLED` records receipt of the corresponding offline/manual payment. It does not mutate
the Order into a FUND-specific state.

### 6.8 `CommerceAuditEvent`

Preferred first direction:

- append-only event rows for Commerce lifecycle changes;
- actor/source/event code;
- entity type/id;
- idempotency/replay reference;
- safe metadata with no provider secrets;
- occurred/recorded timestamps.

An implementation review may instead use the existing platform audit table if it can
enforce the same append-only Commerce contract and queryability.

## 7. Money Representation

Accepted first direction:

- ISO currency code;
- integer minor-unit monetary values;
- explicit minor-unit exponent when needed;
- immutable line and Order totals;
- explicit tax-inclusive/exclusive basis;
- one seller-profile rounding policy applied consistently;
- deterministic reconciliation between line totals and Order totals.

Implementation planning must choose `Int` versus `BigInt` after checking maximum supported
Order values and API serialization. Do not mix Decimal major-unit and integer minor-unit
fields inside one Commerce calculation contract without explicit conversion.

FUND currently stores Product net price as Decimal. The FUND consumer performs an explicit,
tested conversion when resolving Store Product commercial terms.

## 8. Tax Boundary

Commerce Core owns:

- seller tax profile;
- applied rate/treatment snapshots;
- inclusive/exclusive display basis;
- line/Order tax totals and rounding evidence.

The source module owns:

- the source Product/item tax-category selection.

Commerce does not infer Product tax treatment from names or descriptions.

Initial tax-treatment codes must support:

```text
STANDARD
REDUCED
ZERO_RATED
EXEMPT
```

The implementation review must decide whether seller rates are fixed profile columns,
tenant tax-category records or a versioned tax-rule table. Historic Order lines always
snapshot the actual treatment/rate used.

## 9. Status Separation

Commerce owns separate status dimensions for:

- checkout;
- Order;
- payment;
- refund;
- pro-forma.

Commerce does not own:

- FUND Store publication;
- artwork review;
- production;
- Project fulfilment;
- commission accounting.

The consuming module may close production or fulfilment while the Commerce Order remains a
stable submitted/closed commercial record.

## 10. Idempotency And Provider Audit

Required unique/idempotency boundaries:

- checkout create where a client-supplied key is accepted;
- checkout submission to Order;
- Order creation from source/session;
- payment attempt creation;
- Stripe webhook event application;
- refund event application;
- manual pro-forma settlement action.

Provider webhook implementation must:

- verify signature before processing;
- deduplicate provider event ID;
- store safe audit evidence;
- update payment state only through controlled transitions;
- never recalculate historic source Product prices;
- tolerate delivery retries and out-of-order events.

No webhook implementation is authorised by this plan.

## 11. Tenancy And Access

- `organizationId` is the seller tenant boundary on every Commerce record.
- Order number/reference uniqueness is tenant-scoped unless a later global format is
  explicitly accepted.
- Source module and Commerce organization IDs must match.
- Public checkout does not trust caller-supplied tenant or source IDs.
- Source Store public ID resolves through the consuming module before Commerce session
  creation.
- Provider account selection derives from the authenticated/configured seller profile.
- C1/C2/public views use separate authorization and redaction policies.
- Purchaser contact, addresses and uploaded personal data receive restricted access and
  retention treatment.

## 12. Cross-Schema Relation Options

### Option A - Core Generic References Plus Consumer Scalar IDs

FUND extension records store unique Commerce Order/line IDs without Prisma relations.

Pros:

- no reverse Commerce model dependency on FUND;
- simple conceptual ownership.

Cons:

- no database foreign-key enforcement;
- service transaction must prevent orphaned extension records.

### Option B - Cross-Schema Foreign Keys From Consumer To Commerce

FUND extension records reference Commerce IDs through database/Prisma relations.

Pros:

- database integrity and restrictive deletion;
- safer joins/audit.

Cons:

- Prisma may require reverse relation fields on Commerce models;
- generated client shape can appear to couple Commerce to FUND.

Recommended validation spike:

```text
Prefer Option B if reverse Prisma fields do not create service/module coupling.
Otherwise use Option A with unique constraints and mandatory transaction validation.
```

In both options, Commerce services remain consumer-agnostic.

## 13. Index And Constraint Checklist

Plan indexes/constraints for:

- tenant/order number;
- source module/entity/id;
- checkout public/session identifier, expiry and status;
- unique checkout-to-Order transition;
- Order status/submission date;
- line Order/sort/source item;
- payment Order/status/provider/external references;
- unique provider event/idempotency references;
- refund payment/status/provider reference;
- pro-forma tenant/reference/status/due date;
- audit entity/event/time;
- restrictive deletion of commercial evidence;
- monetary non-negativity and quantity greater than zero where appropriate.

Database checks should enforce total/currency invariants that are safe at persistence level.
Services remain responsible for complete arithmetic reconciliation before write.

## 14. Proposed Migration Sequence

Recommended separate platform implementation slices:

```text
COMMERCE-A1 - Add commerce schema, seller profile and enums
COMMERCE-A2 - Checkout, Order and Order-line schema foundation
COMMERCE-A3 - Payment, refund and pro-forma schema foundation
COMMERCE-A4 - Audit/idempotency foundation
COMMERCE-A5 - Provider-neutral services and validation
COMMERCE-A6 - Stripe provider adapter and webhook handling
COMMERCE-A7 - FUND consumer integration
```

Each schema implementation requires:

- migration SQL review;
- Prisma validation;
- generated-client validation;
- same-tenant and cross-schema relation tests;
- implementation confirmation;
- separate review/test evidence.

Do not implement Stripe in the same unreviewed migration that introduces Commerce Orders.

## 15. FUND Consumer Contract

Before Commerce creates a FUND Order, FUND must supply a validated immutable submission
contract containing:

- seller tenant;
- Store and Store Product source identifiers;
- Store Product configuration versions;
- Product/item display snapshots;
- quantity and resolved input/personalisation snapshot;
- unit/line price and tax inputs;
- required-upload validation evidence;
- Project delivery and typed FUND context identifiers;
- idempotency/fingerprint evidence.

Commerce validates arithmetic, currency, seller profile and lifecycle persistence. FUND
writes typed `FundOrderContext` and `FundOrderLineContext` records in the accepted atomic
boundary.

Commerce returns stable Order/line IDs for later FUND production projection.

## 16. Explicitly Out Of Scope

Do not implement in this planning document:

- Prisma schema or migrations;
- database schema creation;
- APIs/services;
- checkout UI;
- Stripe SDK/provider configuration/webhooks;
- FUND Store models or UI;
- generic Product/price catalogue;
- stock/inventory;
- subscriptions/entitlements;
- production/dispatch;
- commission calculation/payment;
- accounting ledger/general ledger.

## 17. Acceptance Criteria

Planning review should confirm:

- `commerce` is accepted as a dedicated schema in the existing IsoStack database;
- Commerce is module-neutral;
- FUND remains the first concrete consumer without becoming a core dependency;
- generic source references are sufficient and stable;
- seller/tax and immutable Order snapshots are explicit;
- money representation and arithmetic validation have a controlled implementation decision;
- checkout, Order, payment, refund and pro-forma states remain separate;
- idempotency and provider audit are first-order requirements;
- cross-schema relation strategy receives a Prisma validation spike;
- implementation is split before Stripe/provider work;
- no application or schema changes are made by this plan.

## 18. Accepted Review And Handoff

The 2026-07-13 architecture review accepted this platform foundation with these bounded
implementation gates:

- `COMMERCE-A1` adds only the `commerce` namespace, seller profile and shared enums;
- `COMMERCE-A2` must decide whether checkout basket lines are persisted by Commerce or the
  checkout session is only a submission/lifecycle boundary;
- Commerce Order lines inherit the Order source-module boundary;
- `COMMERCE-A3` must define refund states and the exact pro-forma/manual-payment evidence
  relationship;
- the Prisma cross-schema validation spike must complete before FUND typed extensions are
  implemented.

Accepted first implementation-planning follow-on:

```text
docs/core/commerce/03-slice-planning/2026-07-13-isostack-commerce-core-slice-commerce-a1-schema-seller-profile-enums-implementation-planning.md
```

## 19. Recommended Next Prompt

```text
Review and accept IsoStack Commerce Core Slice COMMERCE-A1 Schema/Seller Profile/Enums
Implementation Planning. Implement only after acceptance. Keep checkout, Orders, payments,
providers, Stripe and FUND relations out of A1. Require Prisma multi-schema validation,
migration review and tenant-isolation evidence.
```
