# FUND Phase 1 Slice 1R-B - Commerce Core And FUND Store Schema Options Planning

Date: 2026-07-13

Status: Accepted planning / no implementation

## 1. Slice Goal

Define the smallest safe schema boundary that lets FUND create Project Stores and later
consume reusable IsoStack Commerce Core Orders without making generic commerce a FUND-owned
implementation detail.

This slice converts the accepted `1R-A` business architecture into schema options. It does
not add Prisma models, migrations, services, UI, checkout or Stripe integration.

The core question is:

```text
Which records belong to reusable Commerce Core, which records belong to FUND, and which
immutable references and snapshots allow the two lanes to cooperate safely?
```

## 2. Accepted Inputs From 1R-A

The following decisions are inputs, not questions reopened by this slice:

- Store is Project-scoped and represented by an explicit Project Store record.
- Project Store Products come only from active selected `FundProjectProduct` rows.
- Current eligibility, Store lifecycle, visibility and production readiness all gate
  purchase.
- A Project Store and Project Store Product belong to FUND.
- Generic checkout, Order, Order line, money, payment, refund and pro-forma concepts belong
  to Commerce Core.
- FUND must not create a parallel generic Order model.
- Public Stores use a non-enumerable public identifier and do not require purchaser
  accounts.
- Project dates define the Store trading window; Store has no independent opening or
  closing dates.
- C1 tenant is the legal seller.
- Product owns first-pass price, tax category, options and media. Catalogue membership does
  not override them.
- Different seasonal, contextual or differently priced offerings are distinct duplicated
  Products.
- Product duplication is required Product Manager behaviour.
- Store prices are tax-inclusive by default and checkout preserves net, tax and gross
  evidence.
- One Order line represents one resolved Product/personalisation configuration.
- Different personalisation creates separate configured Order lines.
- Project bulk delivery to the Project organiser is the first fulfilment mode.
- Product options and C1-managed custom inputs are required for the first Order integration.
- Product Variants remain deferred unless a choice needs its own SKU, stock, weight, fixed
  price or fulfilment treatment.
- Stripe is the first online provider; pro-forma invoice is a separate Commerce route.
- Event-linked Projects inherit the Event commission policy.
- Standalone Projects use a C1-managed standalone flat rate or ladder.
- Commission is calculated from aggregate eligible Project sales, not as a final payable
  amount independently rounded on each Order line.
- Project-level production assets and purchaser Order-line assets remain separate.

Source planning:

- `docs/modules/fund/03-slice-planning/2026-07-08-fund-phase-1-slice-1r-a-store-orders-commerce-core-planning.md`
- `docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-i-c1-production-dispatch-commission-workflow-planning.md`
- `docs/modules/fund/01-cr-inputs/2026-07-13-fund-cr-commission-ladder-planner-input.md`
- `docs/modules/fund/00-roadmap-control/2026-07-08-fund-ecwid-commerce-platform-appraisal.md`

## 3. Current Implemented Schema Audit

The current app schema already provides:

- `FundProduct` with Product identity, workflow class, net unit price, VAT rate and currency;
- `FundCatalogue` and `FundCatalogueProduct`;
- `FundEvent` and `FundEventCatalogue`;
- `FundProject` with Event, Client, Project status, opening and closing dates;
- `FundProjectProduct` with one selected row per Project/Product and selection-time Product,
  workflow, price, VAT and currency snapshots;
- `FundClient` and `FundClientMember`;
- generic `Organization` branding, country, billing address and VAT-number fields;
- public `MediaFile` and polymorphic `MediaUsage` records.

The current schema does not provide:

- a `commerce` PostgreSQL/Prisma schema;
- generic Commerce Orders, Order lines, checkout sessions, payments, refunds or pro-forma
  records;
- Project Store or Project Store Product records;
- Product media roles, option definitions, choices, custom Order inputs or option-image
  mapping;
- C2 Client logo/Store branding records;
- structured Project organiser delivery details;
- immutable production asset versions, checksums, scan state or retention evidence;
- Event Store banner/media roles;
- C1 Commerce seller/tax profile;
- Event or standalone Project commission-policy records.

Important existing-field interpretation:

```text
FundProjectProduct price/VAT snapshots are selection-time audit evidence.
They are not the accepted live Store price source and must not silently become it.
```

The Store must resolve current Product commercial/configuration data into a versioned
Project Store Product configuration. Checkout then revalidates that version and creates the
immutable Commerce Order-line snapshot.

The existing `MediaFile` model is also not sufficient immutable production evidence because
it has no checksum, malware-scan state, immutable version chain or retention policy.

## 4. Ownership Decision

Accepted direction:

```text
Dedicated reusable Commerce Core
+ typed FUND Store and production context
+ immutable cross-lane identifiers and snapshots
```

Recommended PostgreSQL/Prisma placement:

| Schema | Owns |
| --- | --- |
| `commerce` | checkout sessions, Orders, Order lines, monetary totals, seller/purchaser snapshots, payments, refunds, pro-forma lifecycle and Commerce audit |
| `fund` | Projects, Stores, Store Products, Product inputs/media, delivery context, production assets, FUND Order extensions and commission policy |
| `public` | tenant identity, shared users and existing shared media/storage records where suitable |

Adding a dedicated `commerce` schema requires an explicit future datasource/schema change.
That change belongs to the Commerce Core schema implementation lane, not this planning
slice.

Commerce Core must not require a compile-time dependency on `FundProject`,
`FundProjectStore` or another FUND model. It should identify its consumer through generic
source/channel references. FUND owns the typed mapping back to its Project and production
records.

## 5. Options Considered

### Option A - Derive Store From Project And Put Orders In FUND

Shape:

```text
FundProject
FundOrder
FundOrderLine
```

Verdict:

```text
Rejected.
```

Reasons:

- no explicit Store lifecycle or stable public Store identity;
- duplicates generic Order/payment architecture inside FUND;
- blocks reuse by SeasonPro and other modules;
- makes later migration to Commerce Core expensive and risky.

### Option B - Generic Commerce Orders With FUND Context Stored Only As JSON

Shape:

```text
CommerceOrder.sourceContext Json
CommerceOrderLine.sourceContext Json
```

Verdict:

```text
Not sufficient as the only model.
```

Reasons:

- useful for immutable snapshots but weak for typed C1 production queries;
- cannot safely enforce Project/Store/Product relationships;
- makes production grouping and same-tenant validation harder;
- encourages important identifiers and statuses to drift inside unvalidated blobs.

### Option C - Generic Commerce Core Plus Typed FUND Context

Shape:

```text
commerce.CommerceOrder
commerce.CommerceOrderLine

fund.FundProjectStore
fund.FundProjectStoreProduct
fund.FundOrderContext
fund.FundOrderLineContext
```

Verdict:

```text
Recommended.
```

Benefits:

- preserves generic Commerce ownership;
- leaves FUND in control of Project and production semantics;
- supports typed production aggregation and audit;
- allows Commerce Core to serve other modules later;
- avoids forcing generic Commerce Product/Price catalogue modelling into the first Store
  foundation.

### Option D - Build A Full Generic Commerce Product And Price Catalogue First

Shape:

```text
CommerceProduct
CommercePrice
CommerceVariant
CommerceInventory
```

Verdict:

```text
Deferred.
```

Reasons:

- FUND already has the accepted Product/Catalogue/Project Product source model;
- inventory and generic price books are not required for the first Project Store;
- Commerce Order lines can safely snapshot a module-owned sellable item;
- a later platform lane may introduce generic product/price registries without changing
  historic Order evidence.

## 6. Recommended Commerce Core Foundation

The following names are conceptual. The dedicated Commerce Core planning/implementation
lane may refine them without changing ownership.

### 6.1 `CommerceSellerProfile`

Purpose:

- tenant-owned legal seller and checkout tax defaults;
- source for immutable seller snapshots on Orders.

Candidate fields:

- `id`;
- `organizationId`;
- `legalName`;
- `legalAddress` as a validated structured snapshot shape;
- `countryCode`;
- `vatNumber` / tax-registration reference;
- `defaultCurrency`;
- `pricesIncludeTax`;
- `roundingMethod`;
- `isActive`;
- audit timestamps/actor fields.

This profile should not read mutable `Organization.billingAddress` at historic Order render
time. The effective values must be copied to the Order snapshot.

### 6.2 `CommerceCheckoutSession`

Purpose:

- provisional public basket/checkout state;
- expiry and idempotent transition into one Order.

Candidate fields:

- `id`;
- `organizationId`;
- high-entropy public/session identifier hash where appropriate;
- generic `sourceModuleCode`, `sourceEntityType` and `sourceEntityId`;
- `currency`;
- status such as `OPEN`, `SUBMITTED`, `EXPIRED`, `CANCELLED`;
- `configurationVersion` / basket fingerprint;
- `idempotencyKey`;
- `expiresAt`, `submittedAt`, timestamps.

Cart data remains provisional. Submission must revalidate the FUND Store, Store Product,
resolved configuration, upload gates and effective price/tax values.

### 6.3 `CommerceOrder`

Purpose:

- immutable commercial record for one submitted checkout or accepted manual/pro-forma
  route.

Candidate identity/context fields:

- `id`;
- `organizationId` as the seller tenant;
- tenant-scoped `orderNumber`;
- `sourceModuleCode` such as `FUND`;
- `sourceEntityType` such as `PROJECT_STORE`;
- `sourceEntityId` containing the opaque consumer Store identifier;
- `checkoutSessionId` where applicable;
- Order status separate from payment, production and fulfilment;
- `currency` and currency minor-unit exponent.

Candidate immutable seller snapshot:

- legal seller name;
- address;
- country;
- VAT/tax registration reference;
- applied tax-profile identifier/version;
- price display basis and rounding method.

Candidate purchaser snapshot:

- name;
- email;
- phone where required;
- consent/receipt metadata required by the accepted checkout route.

Candidate monetary totals in integer minor units:

- item net;
- discount;
- delivery;
- tax;
- gross/final total;
- refunded total;
- adjusted total where required.

Recommended Order-status responsibility:

```text
SUBMITTED
CANCELLED
CLOSED
```

Payment outcome must not be folded into Order status.

### 6.4 `CommerceOrderLine`

Purpose:

- immutable purchased-item and monetary snapshot.

Candidate fields:

- `id`, `organizationId`, `orderId`, `sortOrder`;
- generic source item type/id, for example `FUND_PROJECT_STORE_PRODUCT`;
- Product code, name, description and display snapshot;
- quantity;
- unit net/gross amount;
- option/input modifier total;
- line discount, net, tax and gross totals;
- tax category code, rate and treatment snapshot;
- price-inclusive/exclusive basis;
- resolved configuration version/hash;
- generic display/configuration snapshot JSON for receipts and consumer-independent audit.

One line represents one resolved configuration. A different name, artwork or other
personalisation creates a separate line even when the base Product is the same.

### 6.5 `CommercePayment`

Purpose:

- provider-neutral payment attempts and outcomes.

Candidate fields:

- `id`, `organizationId`, `orderId`;
- route/method such as `STRIPE_ONLINE` or `PRO_FORMA_INVOICE`;
- provider code;
- provider account and external payment/session identifiers;
- requested/paid/refunded amounts in minor units;
- status;
- idempotency key;
- provider payload reference/hash rather than unrestricted secret-bearing JSON;
- initiated, paid, failed and cancelled timestamps.

Accepted first-pass payment states:

```text
NOT_REQUIRED
PENDING
PAID
FAILED
CANCELLED
PARTIALLY_REFUNDED
REFUNDED
```

Provider events must be idempotent and append auditable state changes; they must not rewrite
historic Order-line prices.

### 6.6 `CommerceRefund`

Purpose:

- preserve refund/adjustment evidence independently of current payment state.

Candidate fields:

- `id`, `organizationId`, `orderId`, `paymentId`;
- amount and currency;
- provider reference;
- reason/status;
- requested/completed timestamps;
- actor/audit fields.

Refund allocation to Order lines may be introduced when required for accurate tax,
production cancellation or commission adjustment. The schema must not assume every refund
is a whole-Order refund.

### 6.7 `CommerceProFormaInvoice`

Purpose:

- represent the accepted `BY_PRO_FORMA_INVOICE` route without pretending it is an online
  provider payment.

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
- tenant-scoped reference;
- issue/due dates where used;
- status;
- issued/accepted/settled timestamps;
- document reference;
- C1 notes and actor/audit fields.

`SETTLED` means an offline/manual payment has been received and recorded. Pro-forma status,
Order status and payment status remain separate.

### 6.8 Commerce Audit

Commerce Core needs append-only audit evidence for:

- checkout submission;
- Order creation/cancellation/closure;
- payment initiation and provider-event application;
- pro-forma issue/acceptance/settlement;
- refunds and manual adjustments;
- idempotency/replay outcomes.

The implementation lane must decide whether this uses a dedicated `CommerceAuditEvent` or
the existing platform audit system with a strict Commerce event contract.

## 7. Commerce-to-FUND Reference Boundary

Commerce records should carry generic consumer references:

```text
sourceModuleCode
sourceEntityType
sourceEntityId
```

For FUND:

```text
CommerceOrder.sourceEntityId
-> FundProjectStore.id

CommerceOrderLine.sourceItemId
-> FundProjectStoreProduct.id
```

Commerce Core must treat these as opaque identifiers. It must not query FUND tables to
decide what can be purchased.

FUND services perform Store/readiness validation and write typed FUND context in the same
logical transaction as Commerce Order creation.

Two physical-integrity options remain for the implementation spike:

1. scalar Commerce IDs on FUND context records, with service/transaction enforcement and no
   reverse Commerce-to-FUND relation;
2. cross-schema foreign keys from FUND context records to Commerce records, accepting the
   minimal reverse Prisma relation needed by the client generator.

Recommended starting position:

```text
Prefer database-enforced cross-schema foreign keys if Prisma can preserve one-way module
ownership without causing Commerce services to depend on FUND.
```

If the Prisma relation shape creates unacceptable reverse module coupling, use scalar IDs
with unique constraints and transaction-scoped service validation. Do not add a direct
Commerce foreign key to `FundProject` or `FundProduct` merely for convenience.

## 8. Recommended FUND Store Foundation

### 8.1 `FundProjectStore`

Purpose:

- explicit Project Store identity, public access and lifecycle.

Candidate fields:

- `id`, `organizationId`, `projectId`;
- one high-entropy stable `publicId` suitable for the public URL;
- lifecycle status such as `DRAFT`, `PUBLISHED`, `PAUSED`, `CLOSED`, `ARCHIVED`;
- Store title/introduction/fundraising objective copy;
- branding resolution/configuration fields where required;
- `publishedAt`, `pausedAt`, `closedAt`;
- audit actor/timestamps;
- metadata only for non-contract extension data.

Constraints:

- one Store per Project in the first pass;
- Project and Store must belong to the same tenant;
- no Store `opensAt` or `closesAt` fields;
- Project dates determine the trading window;
- public ID must be non-sequential and non-enumerable but is a locator, not an authentication
  secret;
- archived Projects cannot expose an open Store.

### 8.2 `FundProjectStoreProduct`

Purpose:

- stable Store representation of one selected Project Product.

Candidate fields:

- `id`, `organizationId`, `storeId`, `projectProductId`;
- C1 display order and visibility;
- readiness state and reason codes;
- resolved presentation title/subtitle/copy where Store-specific copy is allowed;
- primary media reference/version;
- current resolved configuration version/hash;
- resolved Product identity and commercial audit fields;
- hidden/ineligible/archived timestamps and actor fields;
- created/updated audit fields.

Constraints:

- unique `(organizationId, storeId, projectProductId)`;
- `FundProjectProduct.projectId` must equal `FundProjectStore.projectId`;
- a Product available through several Catalogues still creates one Project Product and one
  Store Product;
- current eligibility loss hides purchasing but does not delete the Store Product;
- a Store Product referenced by historic Orders cannot be hard-deleted;
- Catalogue identity is explanatory audit context, not Store Product identity.

### 8.3 `FundStoreProductConfigurationVersion`

Purpose:

- immutable resolved Product/Store configuration used by carts and Order-line snapshots.

Candidate fields:

- `id`, `organizationId`, `storeProductId`, monotonically increasing `version`;
- configuration hash;
- resolved Product code/name/copy/media references;
- resolved base price, currency and tax category;
- resolved option/custom-input/upload requirement snapshot;
- readiness/gate-policy snapshot;
- created timestamp/actor;
- superseded timestamp where useful.

The live Store Product points to its current version. A cart records the version it used.
Submission fails cleanly and requires revalidation if the current version differs.

Historic versions are immutable and cannot be deleted while referenced by checkout or
Order evidence.

## 9. Product Media, Inputs And Duplication

### 9.1 Product Media

Recommended typed relation:

```text
FundProductMedia
```

Candidate fields:

- `id`, `organizationId`, `productId`;
- shared media/storage reference;
- media role such as `PRIMARY` or `GALLERY`;
- alt text/caption;
- sort order and active state;
- audit fields.

The first Store requires exactly one effective primary image or an accepted fallback state.
Full gallery UI may remain later work.

Event Store banners should use a separate typed `FundEventMedia` role rather than pretending
the banner belongs to every Product.

### 9.2 Product Options And Custom Order Inputs

Recommended conceptual model:

```text
FundOrderInputDefinition
FundOrderInputChoice
FundOrderInputChoiceMedia
```

`FundOrderInputDefinition` supports both Product options and custom Order inputs through an
explicit semantic kind, for example:

```text
PRODUCT_OPTION
CUSTOM_ORDER_FIELD
PRODUCTION_INPUT
FILE_UPLOAD
```

Candidate definition fields:

- tenant and stable code;
- one scope: Product, Project Product or Project Store Product;
- label/help text;
- control/data type;
- required/default behaviour;
- validation constraints;
- customer and C1 production visibility;
- sort order and active state;
- revision/audit fields.

Candidate choice fields:

- stable code and display label;
- sort order/active state;
- absolute minor-unit price modifier in the first pass;
- optional media mapping;
- metadata only for non-contract display hints.

Resolution order:

```text
Product definition
-> Project Product definition/override
-> Project Store Product definition/override
-> immutable Store Product configuration version
```

The implementation schema must enforce exactly one owner scope per definition and prevent
duplicate active codes in one resolved scope. Reusable Product Type/Option Templates remain
deferred.

Complex dependent-option graphs remain deferred. Choice-to-image mapping is accepted and
does not create a Product Variant by itself.

### 9.3 Product Duplication

Product duplication primarily requires safe service behaviour, but schema should retain
optional provenance:

```text
FundProduct.copiedFromProductId
```

The provenance link is audit-only. The copied Product is a new independent Product.

Duplication must copy within one tenant:

- Product details, price/tax category and workflow class;
- suitability rules;
- option/input definitions and choices;
- Product media associations;
- accepted production configuration.

It must:

- assign new unique Product code, slug and other required references;
- let C1 select target Catalogue membership;
- avoid silently copying every source Catalogue membership;
- share immutable binary media assets where safe while creating independent Product-media
  association rows;
- use idempotency so retries cannot create multiple copies.

Per-Catalogue price/media overrides are not introduced.

## 10. Client Branding And Project Delivery Prerequisites

### 10.1 C2 Store Branding

`Organization` branding belongs to the C1 tenant and cannot represent the C2 Client logo.

Recommended typed FUND record:

```text
FundClientBranding
```

Minimum fields:

- `organizationId`, `clientId`;
- light/primary logo media reference;
- alt text;
- active/audit fields.

Store branding resolves:

```text
C2 FundClient logo
-> fallback C1 Organization logo
```

Do not copy a mutable logo URL into every Store. Order/receipt rendering may snapshot the
resolved seller branding only where legally or operationally required.

### 10.2 Project Organiser Delivery

`FundClient` and `FundProject` do not currently provide a structured delivery address.

Recommended first-pass record:

```text
FundProjectDeliveryProfile
```

Minimum fields:

- `organizationId`, `projectId`;
- recipient/organiser name;
- address lines, locality, region, postcode and country code;
- email/phone where required;
- delivery notes;
- audit fields.

The Project holds the live delivery profile. Commerce/FUND Order context snapshots the
effective recipient and address at submission so later edits do not change historic
fulfilment evidence.

Full reusable Client address-book/default management remains later work.

## 11. Production Asset Versioning

The existing `MediaFile` record may remain the shared uploaded binary/storage reference,
but it is not enough on its own for production evidence.

Recommended FUND concepts:

```text
FundProductionAsset
FundProductionAssetVersion
FundProjectAssetLink
FundStoreProductAssetLink
FundOrderLineAssetSnapshot
```

`FundProductionAsset` represents the logical artwork/input. Each immutable version retains:

- shared media/storage reference;
- original filename;
- detected MIME type;
- byte size;
- checksum;
- malware scan state/result;
- upload source/actor and timestamp;
- review state and reviewer evidence where applicable;
- retention category and deletion/restriction timestamps.

Typed link records distinguish Project-level assets, Store Product presentation assets and
purchaser Order-line evidence. Avoid one unconstrained polymorphic owner field for all
production data.

Order-line asset snapshots must reference an immutable version, not merely the latest live
asset.

## 12. FUND Order And Production Extensions

Recommended typed extension records:

```text
FundOrderContext
FundOrderLineContext
FundOrderLineInputSnapshot
FundOrderLineAssetSnapshot
```

### `FundOrderContext`

Candidate fields:

- `organizationId`;
- unique `commerceOrderId`;
- Project Store, Project, Client and optional Event identifiers;
- Project type/workflow snapshot;
- Project organiser delivery snapshot reference/data;
- Event/standalone commission-policy assignment/version reference;
- production/fulfilment state separate from Commerce Order/payment state;
- timestamps/audit fields.

### `FundOrderLineContext`

Candidate fields:

- `organizationId`;
- unique `commerceOrderLineId`;
- `FundProjectStoreProduct`, `FundProjectProduct` and Product identifiers;
- Store Product configuration-version reference;
- workflow/production grouping codes;
- production and artwork-readiness state;
- production-unit expansion status where required;
- timestamps/audit fields.

### Input And Asset Snapshots

Typed child snapshots should retain:

- definition code, label, semantic kind and control type;
- submitted value/display value;
- selected choice code/label and price modifier;
- validation/presence state;
- immutable production asset-version reference where relevant.

Commerce Order lines may also retain a generic JSON rendering snapshot, but C1 production
must query typed FUND snapshots rather than parse unbounded JSON.

### Production Projection

Orders remain intact commercial records. FUND derives a production projection that can:

- group paid eligible lines by Project and Store Product;
- subdivide by option/personalisation configuration;
- expand quantity into production units when required;
- trace each unit/aggregate back to its Commerce Order line;
- exclude or adjust cancelled/refunded production according to later workflow rules.

Do not create one Commerce Order line per production unit when several units share exactly
the same configuration.

## 13. Commission Schema Options

Commission belongs to FUND policy/accounting context, not generic Commerce payment.

Recommended concepts:

```text
FundCommissionPolicy
FundCommissionPolicyVersion
FundCommissionStep
FundProjectCommissionAssignment
FundProjectCommissionPeriod
```

### Policy Scope

One policy version has exactly one accepted scope:

- Event policy, referenced by an Event and inherited by all linked Projects; or
- standalone Project policy, referenced by one standalone Project.

Event policy wins for Event-linked Projects. A linked Project cannot replace it with a
Project-specific policy.

Policy method:

```text
FLAT
STEPPED
```

Stepped timing method:

```text
OFFSET_BASED
FIXED_DATE
```

The two timing methods cannot be mixed in one policy version.

### Version Assignment

Recommended conflict resolution:

```text
Resolve and assign the effective policy version when the Store is published.
Lock the assignment no later than the first eligible paid sale.
Project close fixes the sales window and calculation period, not a mutable policy lookup.
```

This is safer than looking up whichever Event/Project policy happens to be active at Project
close. Later C1 changes create a new policy version and do not rewrite existing assigned
Projects. A pre-sale reassignment must be explicit and audited.

### Steps And Calculation Evidence

Flat policy:

- one rate applied to aggregate eligible Project sales.

Stepped policy:

- rate;
- fixed threshold date or offset days before Project close;
- deterministic ordering and non-overlap validation;
- final step effective until Project close.

Each eligible paid sale is assigned to the band active at its recognised payment timestamp.
Sales are then aggregated by Project/policy version/band and commission is calculated on the
aggregate, avoiding cumulative per-line rounding differences.

`FundProjectCommissionPeriod` should preserve:

- Project and policy-version assignment;
- Store/Project closing window;
- included paid, refunded and adjusted sales totals;
- band aggregates;
- calculation timestamp/basis/version;
- later adjustment evidence;
- accounting status separate from payment settlement.

No commission schema, calculation service, dashboard or payment is implemented by `1R-B`.

## 14. Tax And Money Rules

Recommended Product tax treatments:

```text
STANDARD
REDUCED
ZERO_RATED
EXEMPT
```

`FundProduct` owns its tax category. C1 Commerce seller/tax configuration supplies the
effective rates. FUND must not infer tax treatment from Product names.

Recommended first-pass price model:

- preserve/migrate the current Product net price deliberately;
- add an explicit price-entry/display basis rather than relying on field naming forever;
- resolve the tax-inclusive Store display amount;
- snapshot unit net, tax and gross values on the Commerce Order line;
- store Order/line money in integer currency minor units;
- apply one explicit C1 rounding policy consistently at Order-line level;
- reconcile line totals to immutable Order totals.

Schema implementation planning must decide whether to migrate `FundProduct.unitPriceNet` and
`vatRate` immediately or add compatible category/basis fields first. It must not silently
reinterpret existing values.

## 15. Status Separation

The schema must not use one status enum for several operational concerns.

| Concern | Owner | Examples |
| --- | --- | --- |
| Store lifecycle | FUND | draft, published, paused, closed, archived |
| Checkout lifecycle | Commerce | open, submitted, expired, cancelled |
| Order lifecycle | Commerce | submitted, cancelled, closed |
| Payment lifecycle | Commerce | pending, paid, failed, refunded |
| Pro-forma lifecycle | Commerce | draft, issued, accepted, settled, cancelled |
| Artwork review | FUND | awaiting upload, submitted, under review, changes required, approved |
| Production | FUND | not ready, ready, in production, complete |
| Fulfilment | FUND | pending, ready, dispatched/handed over, complete |
| Commission accounting | FUND | provisional, calculated, adjusted, approved, settled |

Exact enum names require implementation review, but ownership separation is non-negotiable.

## 16. Tenant, Public Access And Deletion Rules

- Every Commerce and FUND record carries or derives the C1 seller `organizationId`.
- All C1/C2 mutations validate tenant and Project/Client scope.
- Public Store reads resolve tenant and Store from the high-entropy Store public ID; callers
  cannot supply a trusted tenant ID.
- Checkout submission revalidates published/open state and every Store Product gate.
- Public endpoints require rate limiting, abuse controls and idempotency.
- Commerce source identifiers and FUND typed context must agree on tenant, Store and line
  identity.
- Project Store/Product records referenced by checkout or Orders are hidden/archived rather
  than hard-deleted.
- Commerce Orders, lines, payments, refunds and snapshots use restrictive deletion rules.
- Uploaded personal/child data follows explicit retention and restricted-access rules;
  deletion/anonymisation must preserve only the minimum lawful accounting/audit evidence.

## 17. Recommended Implementation Split After Acceptance

### 17.1 `1R-C` - FUND Store/Input Schema Foundation

FUND-only schema implementation may include:

- Project Store and Store Product;
- Store Product configuration versions;
- Product media and option/custom-input definitions;
- Product duplication provenance;
- Client Store branding and Project delivery profile;
- immutable FUND production asset/version records;
- commission policy/version/assignment foundation where separately accepted;
- no Commerce Orders, payments or Stripe integration.

### 17.2 Separate IsoStack Commerce Core Lane

Create and accept a core planning/implementation slice outside FUND for:

- adding the `commerce` schema;
- seller/tax profile;
- checkout, Order, line, payment, refund and pro-forma foundations;
- generic source-reference contract;
- audit/idempotency rules;
- no FUND UI or production workflow.

### 17.3 FUND Store Services And UI

After `1R-C`:

- Store readiness/configuration services;
- Product duplication services and Product Manager action;
- C1 Store management UI;
- public Store display and option/input controls;
- no Order submission until Commerce Core passes review.

### 17.4 FUND Commerce Consumer Integration

After both foundations pass:

- Commerce checkout creation from an accepted FUND Store;
- FUND validation and immutable Order context/line snapshots;
- Stripe and pro-forma routes through Commerce Core;
- C1/C2 Order visibility and production projection;
- later production, dispatch and commission accounting slices.

## 18. Explicitly Out Of Scope

Do not implement in `1R-B`:

- Prisma models or datasource schema changes;
- migrations, seed data or database pushes;
- routers/services/validation schemas;
- Product duplication service/UI;
- Store UI or public endpoints;
- Commerce checkout or Order creation;
- Stripe SDK, provider accounts or webhooks;
- file upload/storage/malware scanning implementation;
- production batching;
- dispatch workflow;
- commission calculation, accounting or settlement;
- generic inventory, SKU stock or warehouse management;
- reusable Product Type/Option Template manager;
- per-Catalogue commercial overrides.

## 19. Review And Acceptance Criteria

Planning review should confirm:

- dedicated Commerce Core ownership is accepted;
- no FUND-only generic Order model is introduced;
- Project Store and Store Product belong to FUND;
- current `FundProjectProduct` snapshots are not misused as live Store commercial terms;
- generic source references and typed FUND extensions are both retained;
- Store/Product configuration versioning is sufficient for cart revalidation;
- Product duplication, media, inputs, branding and delivery prerequisites are visible;
- immutable production asset evidence is not delegated to mutable `MediaFile` alone;
- Product and C1 tax-profile ownership are explicit;
- Event and standalone Project commission policies are versioned and auditable;
- Store, checkout, Order, payment, production, fulfilment and commission statuses remain
  separate;
- the implementation split avoids circular FUND/Commerce dependencies;
- no code or schema implementation is performed in this planning slice.

## 20. Accepted Planning Handoff

Created FUND follow-on:

```text
docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c-fund-store-input-schema-foundation-planning.md
```

Created separate platform follow-on:

```text
docs/core/commerce/02-triage/2026-07-13-isostack-commerce-core-schema-foundation-planning.md
```

Planning creation confirmation:

```text
docs/modules/fund/02-triage/2026-07-13-phase-1-slice-1r-b-store-and-commerce-planning-handoff.md
```

Next review prompt:

```text
Review the created 1R-C FUND Store/Input Schema Foundation plan and the separate IsoStack
Commerce Core Schema Foundation plan. Do not implement schema or application code until
each plan is accepted. Preserve generic Commerce source references and typed FUND production
extensions.
```
