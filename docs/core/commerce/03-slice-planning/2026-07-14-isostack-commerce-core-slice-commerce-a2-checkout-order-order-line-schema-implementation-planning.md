# IsoStack Commerce Core Slice COMMERCE-A2 - Checkout, Order And Order-line Schema Implementation Planning

Date: 2026-07-14

Status: Accepted, implemented and reviewed as passed / shared deployment not performed

Roadmap control:

`docs/core/commerce/00-roadmap-control/2026-07-13-commerce-core-roadmap-and-slice-control.md`

Parent architecture:

`docs/core/commerce/02-triage/2026-07-13-isostack-commerce-core-schema-foundation-planning.md`

Application baseline:

`e1c2d9f` on local `dev`, containing the complete 135-migration R3-D baseline

Implementation commit:

`3206199` on local `dev`

## 1. Goal

Create the smallest generic Commerce persistence foundation that can own:

- a provisional checkout submission boundary;
- an immutable submitted commercial Order;
- immutable resolved Order lines;
- seller, purchaser, source, tax and monetary snapshots;
- exact same-tenant identity and restrictive commercial-evidence deletion.

A2 is a schema slice. It creates no checkout, Order or Order-line service and exposes no
public or authenticated route.

## 2. Critical-path Position

```text
COMMERCE-A1 complete
-> COMMERCE-A2
-> FUND 1R-C6 typed Order/line context
-> FUND Store readiness/configuration and later Commerce integration
```

FUND `1R-C6` must not begin until A2 is implemented and its cross-schema relation direction
is validated. A2 must not absorb `1R-C6`, Store services or consumer-specific fields.

## 3. Accepted Boundary Decisions Requiring Review

### 3.1 Checkout Is A Header And Submission Boundary

Commerce persists `CommerceCheckoutSession` but does not persist mutable checkout basket
lines in A2.

The consumer module owns its provisional basket and revalidates current source
configuration. At submission it supplies one immutable validated contract. A later
provider-neutral Commerce service atomically:

1. locks the checkout session;
2. revalidates seller/currency/session state;
3. creates one Order and its lines;
4. changes the session from `OPEN` to `SUBMITTED`.

The session records a source configuration version and fingerprint so stale or altered
consumer submissions can be rejected. A2 adds no service implementing that transition.

This avoids duplicating mutable FUND Store Product configuration in generic Commerce.

### 3.2 Money Uses Prisma `Int` Minor Units

A2 uses signed PostgreSQL/Prisma `Int` fields constrained to the non-negative range
`0..2,000,000,000` minor units. For GBP this supports individual Orders up to GBP
20,000,000.00, far beyond the intended Store checkout while preserving direct JSON and
JavaScript number interoperability.

Each Order records:

- uppercase ISO currency code;
- minor-unit exponent in the range `0..3`;
- deterministic integer totals.

No Decimal major-unit field is introduced. FUND conversion from Decimal Product pricing
remains a later tested consumer responsibility.

### 3.3 Initial Seller Tax Configuration Is Bounded

A2 adds nullable `standardTaxRateBps` and `reducedTaxRateBps` to
`CommerceSellerProfile`:

```text
0..10,000 basis points
100 basis points = 1.00%
```

`ZERO_RATED` and `EXEMPT` always snapshot an applied rate of zero. The nullable profile
rates avoid inventing tax settings for any existing profile. Later seller activation and
Order-creation services must require the applicable configured rate.

This is not a jurisdictional tax engine, effective-dated rules table or Product tax
classifier. The consumer supplies the Product/item tax-treatment/category choice;
Commerce validates and snapshots the applied treatment/rate.

### 3.4 Generic Source Boundary

Checkout and Order headers use:

```text
sourceModuleCode
sourceEntityType
sourceEntityId
```

Order lines use:

```text
sourceItemType
sourceItemId
```

All codes are controlled uppercase machine vocabulary. IDs are opaque. Order lines inherit
the Order source-module boundary and cannot introduce a separate module code.

No A2 model or migration references the FUND schema.

## 4. Bounded Enums

Add only:

```text
CommerceCheckoutStatus
- OPEN
- SUBMITTED
- EXPIRED
- CANCELLED

CommerceOrderStatus
- SUBMITTED
- CANCELLED
- CLOSED
```

Payment, refund, pro-forma, provider and fulfilment states remain outside A2.

## 5. `CommerceCheckoutSession`

Planned fields:

```text
id
organizationId
publicTokenHash
sourceModuleCode
sourceEntityType
sourceEntityId
currency
minorUnitExponent
status
sourceConfigurationVersion
sourceConfigurationFingerprint
expiresAt
submittedAt?
expiredAt?
cancelledAt?
createdById?
createdAt
updatedAt
```

Contract:

- tenant is the seller Organization;
- only a SHA-256/HMAC-style lowercase 64-character hexadecimal public-token hash is stored;
- no public token or secret is stored in plaintext;
- public-token hash is globally unique;
- source codes and IDs are nonblank and controlled by later services;
- currency is uppercase three-character ISO shape;
- configuration fingerprint is lowercase 64-character hexadecimal evidence;
- expiry is later than creation;
- terminal timestamps must match exactly one terminal status;
- one session may create at most one Order;
- Organization deletion and later Order-linked session deletion are restricted.

No idempotency-event table or request replay service is added; those remain A4 work.

## 6. `CommerceOrder`

Planned fields:

```text
id
organizationId
sellerProfileId
checkoutSessionId?
orderNumber
sourceModuleCode
sourceEntityType
sourceEntityId
status
currency
minorUnitExponent

sellerLegalName
sellerTradingName?
sellerAddressLine1
sellerAddressLine2?
sellerAddressLine3?
sellerLocality
sellerRegion?
sellerPostalCode
sellerCountryCode
sellerTaxRegistrationNumber?

purchaserName
purchaserEmail
purchaserPhone?
billingAddressSnapshot?
deliveryAddressSnapshot?

itemsNetMinor
itemsTaxMinor
discountMinor
deliveryNetMinor
deliveryTaxMinor
totalGrossMinor

submittedAt
cancelledAt?
closedAt?
createdById?
createdAt
updatedAt
```

Contract:

- `orderNumber` is unique within the seller Organization;
- seller profile, optional checkout and Order must share the exact Organization;
- optional checkout may belong to only one Order;
- source tuple is copied from the validated checkout/session contract;
- seller identity is an immutable explicit snapshot, not rendered from the live profile;
- purchaser name and email are required nonblank contact evidence;
- optional billing/delivery JSON snapshots are immutable versioned address evidence for
  later service validation, not FUND Project-delivery relations;
- status does not encode payment, refund, production, dispatch or commission;
- `submittedAt` is always present;
- `CANCELLED` requires only `cancelledAt`; `CLOSED` requires only `closedAt`;
- monetary totals are non-negative bounded minor units;
- total reconciliation is:

```text
totalGrossMinor =
  itemsNetMinor
  - discountMinor
  + itemsTaxMinor
  + deliveryNetMinor
  + deliveryTaxMinor
```

- discount cannot exceed `itemsNetMinor`;
- Organization, seller-profile and checkout deletion are restricted while an Order exists.

The schema does not enforce Order-number generation or complete JSON snapshot shape; those
are later service contracts.

## 7. `CommerceOrderLine`

Planned fields:

```text
id
organizationId
orderId
sortOrder
sourceItemType
sourceItemId
itemCode?
itemName
itemDescription?
quantity

unitBaseNetMinor
unitModifierNetMinor
unitNetMinor
unitDisplayGrossMinor
lineDiscountMinor
lineNetMinor
lineTaxMinor
lineGrossMinor

taxTreatment
taxCategoryCode
appliedTaxRateBps
priceEntryBasis

sourceConfigurationVersion
sourceConfigurationFingerprint
configurationSnapshot
displaySnapshot?
createdAt
```

Contract:

- line and Order must share the exact Organization;
- sort order is unique within one tenant/Order;
- one line represents one resolved configuration; differently personalised units require
  separate lines;
- quantity is positive and bounded;
- all monetary values are non-negative bounded minor units;
- `unitNetMinor = unitBaseNetMinor + unitModifierNetMinor`;
- `lineNetMinor = unitNetMinor * quantity - lineDiscountMinor`, using PostgreSQL bigint
  casts inside the check to prevent intermediate overflow;
- `lineGrossMinor = lineNetMinor + lineTaxMinor`;
- unit display gross is at least unit net and is a display snapshot; line-level HALF_UP tax
  reconciliation remains a later service validation;
- rate is `0..10,000` basis points;
- `ZERO_RATED` and `EXEMPT` require zero applied rate;
- configuration version, fingerprint and JSON snapshot are immutable source evidence;
- Order deletion is restricted while lines exist.

Order totals versus summed line totals remain a mandatory atomic service invariant. A2
database checks enforce safe per-row arithmetic but do not introduce triggers that could
conflict with future append/audit behavior.

## 8. Tenant And Relation Keys

Add the supporting keys required for exact composite relations:

```text
CommerceSellerProfile (organizationId, id)
CommerceCheckoutSession (organizationId, id)
CommerceOrder (organizationId, id)
```

Relations:

```text
checkout.organizationId -> public.Organization
order.organizationId -> public.Organization
order.(organizationId, sellerProfileId) -> CommerceSellerProfile
order.(organizationId, checkoutSessionId) -> CommerceCheckoutSession
line.organizationId -> public.Organization
line.(organizationId, orderId) -> CommerceOrder
```

All use explicit short names. Commercial evidence uses `Restrict`/`NoAction` semantics;
there is no cascade deletion of Orders or lines.

The supporting keys allow later FUND-to-Commerce validation. A2 itself adds no FUND reverse
relation or typed extension.

## 9. Index And Uniqueness Plan

Required indexes/uniqueness:

- checkout public-token hash unique;
- checkout by tenant/status/expiry;
- checkout by tenant/source tuple/status;
- tenant/checkout ID supporting unique key;
- Order number unique per tenant;
- optional checkout unique per tenant/Order transition;
- Order by tenant/source tuple/submission time;
- Order by tenant/status/submission time;
- tenant/Order ID supporting unique key;
- line sort order unique per tenant/Order;
- line by tenant/source item;
- line by tenant/Order/tax treatment.

No source tuple is globally unique: repeat/retry purchases remain legitimate and later
idempotency contracts decide replay identity.

## 10. Migration And Backfill

One bounded migration after the complete 135-migration baseline:

1. create the two A2 enums;
2. add nullable seller-profile standard/reduced rate columns and checks;
3. add the seller-profile `(organizationId, id)` supporting key;
4. create checkout sessions;
5. create Orders;
6. create Order lines;
7. add indexes, checks and foreign keys in dependency order.

Backfill policy:

- create no checkout, Order or line row;
- preserve every Organization, seller profile and FUND value;
- leave both new seller tax-rate fields null on existing profiles;
- infer no seller tax rate, source tuple, purchaser identity or commercial value;
- reference no FUND table or migration fixture.

Expected inventory moves from 135 to 136 migrations.

## 11. Rollback And Deletion

Before any real Order exists, rollback may drop A2 line, Order and checkout tables, the two
new enums, the two nullable seller-profile columns and the supporting unique key.

After real commercial evidence exists, destructive rollback is not acceptable. Forward
repair or an explicit evidence-preserving replacement migration is required.

Application-level deletion services are out of scope. Database foreign keys must prove:

- tenant deletion is restricted by checkout/Order/line evidence;
- seller profile deletion is restricted by Orders;
- linked checkout deletion is restricted by its Order;
- Order deletion is restricted by lines;
- no automatic deletion reaches FUND or another module.

## 12. Validation Matrix

All database validation uses only `TEST_DATABASE_URL` after proving it is distinct from
`DATABASE_URL`.

Required evidence:

- `prisma format`, `prisma validate` and Prisma generation pass;
- static contract verification finds exactly the A1+A2 Commerce models/enums and no FUND,
  payment, refund, pro-forma, provider or Stripe scope;
- representative 135-to-136 migration preserves existing A1 and FUND rows/values;
- fresh replay applies all 136 migrations;
- valid seller rates, checkout, Order and several lines persist;
- nullable existing seller rates remain valid;
- invalid rate, hash, currency, exponent, source, contact and state/timestamp shapes fail;
- unknown/cross-tenant Organization, seller profile, checkout and Order relations fail;
- duplicate token, tenant Order number, checkout transition and line sort fail;
- invalid quantity, amount bounds and every line/Order reconciliation fail;
- zero/exempt non-zero tax rates fail;
- required restrictive deletion behavior passes;
- A1 defaults/country/currency/nonblank/tenant constraints regress successfully;
- no Commerce table contains FUND identity or relation columns;
- rollback-only fixtures leave zero test residue;
- final disposable migration status reports 136 applied and zero failed;
- `git diff --check`, type-check and critical-file verification pass.

## 13. Expected Implementation Files

Only after review acceptance:

- `prisma/schema.prisma`;
- one `prisma/migrations/<timestamp>_commerce_a2_checkout_order_line_foundation/migration.sql`;
- one static A2 contract verifier;
- one A2 pre-migration fixture/inventory SQL file;
- one rollback-only A2 database constraint SQL file;
- one safe A2 disposable lifecycle runner;
- A2 implementation confirmation and review/test records;
- Commerce, root and FUND roadmap/README alignment.

## 14. Explicitly Out Of Scope

- checkout basket-line persistence;
- checkout/Order/line creation or mutation services;
- public tokens, routes, procedures or UI;
- Order numbering implementation;
- tax calculation/rule-selection service;
- payment, refund or pro-forma schema;
- audit/idempotency tables or services;
- provider configuration, Stripe or webhooks;
- FUND relations, context rows, Store behavior or production assets;
- commission, accounting, statements, fulfilment or dispatch;
- shared development, staging or production database deployment.

## 15. Review Gate

Review must verify the plan against the accepted Commerce architecture, A1 implementation,
current Prisma multi-schema behavior and FUND C6 dependency. Any unresolved business choice
must stop implementation; technical details already controlled by architecture may be
resolved in the review record.

If accepted, implementation remains bounded to the files and contracts above and stops
after the complete A2 lifecycle.

## 16. Accepted Review Resolution

The 2026-07-14 bounded review accepted this plan after checking it against the A1 Prisma
model/migration, the parent Commerce architecture, the 135-migration application baseline
and FUND `1R-C6` ownership boundary.

Resolved review findings:

- a Commerce checkout header without Commerce basket-line persistence is sufficient for
  the future atomic submission boundary;
- Prisma `Int` minor units are appropriate for the bounded first Order values and avoid a
  premature BigInt serialization contract;
- nullable standard/reduced seller rates plus immutable line snapshots satisfy the first
  tax boundary without inventing a tax engine or backfill;
- exact `(organizationId, id)` keys preserve tenant integrity across seller, session,
  Order and line relations;
- one optional checkout may create at most one Order;
- restrictive evidence deletion is required throughout;
- JSON address/configuration snapshots are evidence containers whose exact versioned shape
  remains a later service contract;
- no reverse or direct FUND relation belongs in A2;
- A2 unblocks planning of `1R-C6` but does not itself authorise that slice.

No open product or business question remains for this schema-only implementation.
