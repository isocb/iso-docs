# FUND Phase 1 Slice 1R-C - FUND Store/Input Schema Foundation Planning

Date: 2026-07-13

Last amended: 2026-07-14 - Project-specific overrides and C2 commission acceptance refined

Status: Accepted planning / no implementation

## 1. Slice Goal

Plan the schema-only implementation of the FUND-owned Store, Product-input, branding,
delivery, production-asset and commission-policy foundations accepted in `1R-B`.

This slice must not add generic Orders, Order lines, checkout, payments, refunds, pro-forma
records or Stripe integration to the `fund` schema.

Related accepted planning:

- `docs/modules/fund/03-slice-planning/2026-07-08-fund-phase-1-slice-1r-a-store-orders-commerce-core-planning.md`
- `docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-b-commerce-core-and-fund-store-schema-options-planning.md`
- `docs/core/commerce/02-triage/2026-07-13-isostack-commerce-core-schema-foundation-planning.md`

## 2. Accepted Ownership Boundary

FUND owns:

- Project Store and Project Store Product;
- resolved Store Product configuration versions;
- Product media, Product options and C1-managed custom Order inputs;
- Product duplication provenance;
- C2 Client Store logo/branding;
- Project organiser delivery profile;
- production artwork/assets and immutable versions;
- Event-default and Project-specific commission policies;
- later typed FUND extensions for Commerce Orders and Order lines.

Commerce Core owns:

- checkout sessions;
- Orders and Order lines;
- seller/purchaser commercial snapshots;
- money/tax totals;
- payments, refunds and pro-forma lifecycle;
- Commerce idempotency and audit.

Control rule:

```text
1R-C may prepare FUND to consume Commerce Core.
It must not implement a FUND substitute for Commerce Core.
```

## 3. Current Schema Constraints

Current implemented records that `1R-C` must extend safely:

- `FundProduct`;
- `FundCatalogue` / `FundCatalogueProduct`;
- `FundEvent`;
- `FundProject`;
- `FundProjectProduct`;
- `FundClient`;
- shared `MediaFile`;
- `Organization`.

Important constraints:

- `FundProjectProduct` is unique by tenant/Project/Product;
- Store Products must use that selected row as their source;
- `FundProject.opensAt` and `closesAt` already own Store trading dates;
- `FundProduct.unitPriceNet`, `vatRate` and `currency` already contain live data and cannot
  be silently reinterpreted;
- `FundClient` has no C2 logo relation;
- neither `FundClient` nor `FundProject` has a structured delivery address;
- `MediaFile` is mutable shared media metadata, not immutable production evidence;
- no Commerce Core schema exists yet.

## 4. Recommended Delivery Strategy

The accepted FUND foundation is too broad for one opaque migration. Plan it as bounded
schema sub-slices under `1R-C`:

```text
1R-C1 - Product Media, Inputs, Tax Category And Duplication Foundation
1R-C2 - Client Branding, Project Delivery And Event Media Foundation
1R-C3 - Project Store And Store Product Foundation
1R-C4 - Production Asset Version Foundation
1R-C5 - Commission Policy And Assignment Foundation
1R-C6 - FUND Commerce Context Foundation (only after Commerce Core schema exists)
```

Each implementation sub-slice requires its own migration, implementation confirmation and
review/test record. Do not combine them merely to reduce slice count.

## 5. `1R-C1` - Product Media, Inputs, Tax And Duplication

### 5.1 FundProduct Changes

Candidate additions:

```text
taxTreatment
priceEntryBasis
copiedFromProductId
configurationRevision
```

Recommended conceptual enums:

```text
FundProductTaxTreatment:
- STANDARD
- REDUCED
- ZERO_RATED
- EXEMPT

FundPriceEntryBasis:
- TAX_EXCLUSIVE
- TAX_INCLUSIVE
```

Migration rule:

- existing `unitPriceNet` remains tax-exclusive until a deliberate later price migration;
- existing records receive `TAX_EXCLUSIVE` safely;
- existing `vatRate = 0` must not automatically distinguish zero-rated from exempt;
- C1 must explicitly review/migrate zero-rate Product tax treatment before checkout;
- `FundProjectProduct` must gain tax-treatment and price-entry-basis snapshots so its
  existing price/VAT/currency snapshot cannot depend on later Product edits;
- `configurationRevision` increments through services later, not database triggers unless a
  dedicated review accepts that approach.

`copiedFromProductId` is optional self-relation provenance. It must not make the copied
Product inherit future changes from its source.

### 5.2 `FundProductMedia`

Candidate fields:

- `id`, `organizationId`, `productId`, `mediaFileId`;
- role: `PRIMARY` or `GALLERY`;
- alt text and caption;
- sort order, active state;
- audit actor/timestamps.

Constraints:

- same-tenant Product/media validation in service and relation shape where supported;
- one active effective primary image per Product;
- unique Product/media association as appropriate;
- media association can be copied independently during Product duplication;
- binary `MediaFile` may be shared by source and copied Product.

### 5.3 `FundOrderInputDefinition`

Purpose:

- one typed input foundation for Product options, custom Order fields, production inputs and
  file uploads.

Candidate semantic kinds:

```text
PRODUCT_OPTION
CUSTOM_ORDER_FIELD
PRODUCTION_INPUT
FILE_UPLOAD
```

Candidate control types:

```text
SHORT_TEXT
LONG_TEXT
NUMBER
DATE
YES_NO
SINGLE_SELECT
MULTI_SELECT
COLOUR_SWATCH
FILE_UPLOAD
EMAIL
PHONE
```

Candidate owner scope:

- Product;
- Project Product.

Project Store Product ownership/override is added in `1R-C3` after the Store Product table
exists. `1R-C1` must not reference a not-yet-created Store Product table.

The physical schema may use nullable owner foreign keys plus a database check constraint
requiring exactly one owner, or separate base/override tables. The implementation planning
review must choose one approach before migration SQL is written.

Recommended `1R-C1` implementation:

```text
One definition table with explicit PRODUCT or PROJECT_PRODUCT owner scope and
exactly-one-owner constraint.
```

Candidate fields:

- stable code, label, help text;
- semantic kind and control type;
- required/default behaviour;
- validation constraints;
- customer visibility and C1 production visibility;
- sort order, active state and revision;
- audit actor/timestamps.

### 5.4 `FundOrderInputChoice`

Candidate fields:

- definition relation;
- stable code and display label;
- price modifier in currency minor units;
- sort order and active state;
- optional display metadata;
- audit fields.

First-pass modifiers are absolute amounts only. Percentage and formula pricing remain
deferred.

### 5.5 `FundOrderInputChoiceMedia`

Purpose:

- map a choice such as colour to Store imagery without introducing a Product Variant.

Candidate fields:

- choice relation;
- Product media relation;
- sort order/primary-for-choice flag;
- audit fields.

Complex dependency graphs remain deferred.

### 5.6 Duplication Contract

No Product-copy rows are pre-created by migration. Later services must copy atomically:

- Product fields and workflow class;
- tax/price configuration;
- suitability rows;
- input definitions and choices;
- Product-media associations;
- choice-media mappings.

The service must assign unique tenant-scoped code/slug values, accept target Catalogue
membership and use an idempotency key.

Catalogue membership itself does not override copied Product data.

## 6. `1R-C2` - Client Branding, Delivery And Event Media

### 6.1 `FundClientBranding`

Minimum fields:

- `id`, `organizationId`, unique `clientId`;
- primary logo `mediaFileId`;
- alt text;
- active/audit fields.

Resolution rule:

```text
active C2 Client logo
-> C1 Organization logo fallback
```

Do not duplicate the C1 Organization logo into every Client or Store record.

### 6.2 `FundProjectDeliveryProfile`

Minimum fields:

- `id`, `organizationId`, unique `projectId`;
- recipient/organiser name;
- address line 1/2/3;
- locality/city, region/county, postcode and country code;
- email/phone where required;
- delivery notes;
- audit fields.

The live Project profile may be edited. Later FUND Order context must snapshot the effective
profile at submission.

The first-pass delivery mode is always Project bulk delivery to this organiser destination.

Clarification recorded in the bounded `1R-C2` plan on 2026-07-14:

- the first Project onboarding form represents both the new C2 Client
  organisation/project-owning body and its main organiser; the body may be a school, club,
  Scout or Guide group, team, league, PTA, charity, community group or another organisation
  type;
- completing automated or exception-reviewed provisioning of a new Project requires a
  primary `FundClientMember`/login-capable
  organiser as well as the Client-owned Project;
- the initial Project delivery profile is copied once from the structured organisation
  address and organiser details accepted through confirmed automated onboarding or C1
  exception review, then is Project-owned and editable by the organiser;
- the initial delivery recipient is the confirmed C2 Client organisation/body, with the
  main organiser recorded separately as the initial attention contact;
- this is not live address inheritance and does not permit migration-time inference from
  legacy organiser fields or intake JSON;
- the current Project Intake submission/approval workflow requires a separately reviewed
  alignment amendment before it can claim to satisfy that initialization contract; that
  amendment is now named and initiated as `1P-G-R3 - Project Intake Automated
  Provisioning Alignment` and remains under parent traceability review.

Controlling detail and references to `1P-G-C`, `1P-G-F`, `1P-G-D3-A` and `1P-K1-F-B` are
recorded in:

`docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1r-c2-client-branding-project-delivery-event-media-schema-implementation-planning.md`

`docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1p-g-r3-project-intake-automated-provisioning-alignment-planning.md`

### 6.3 `FundEventMedia`

Minimum role required:

```text
STORE_BANNER
```

Candidate fields mirror Product media association fields but belong to Event. Event banner
context must not change Product identity or commercial terms.

## 7. `1R-C3` - Project Store Foundation

### 7.1 Store Status

Recommended enum:

```text
FundProjectStoreStatus:
- DRAFT
- PUBLISHED
- PAUSED
- CLOSED
- ARCHIVED
```

This status does not replace Project status or Project dates.

### 7.2 `FundProjectStore`

Candidate fields:

- `id`, `organizationId`, unique `projectId`;
- high-entropy unique `publicId`;
- Store status;
- title/introduction/fundraising objective copy;
- optional Event-derived copy override markers where required;
- `publishedAt`, `pausedAt`, `closedAt`, `archivedAt`;
- actor/timestamp audit fields;
- metadata for non-contract extension data only.

Do not add Store opening/closing fields. Effective openness requires:

```text
Store status = PUBLISHED
+ Project status permits trading
+ current time inside FundProject.opensAt/closesAt
+ Store readiness passes
```

### 7.3 Store Product Status/Readiness

Recommended separate concerns:

- visibility: shown/hidden;
- eligibility: current eligibility result;
- readiness: incomplete/ready/blocked;
- archive/history state.

Do not compress these into one ambiguous status if several can apply simultaneously.

### 7.4 `FundProjectStoreProduct`

Candidate fields:

- `id`, `organizationId`, `storeId`, `projectProductId`;
- sort order and visibility;
- readiness status/reason codes;
- resolved display title/subtitle/copy;
- primary Product-media association/version reference;
- current configuration-version relation;
- Product/configuration revision last resolved;
- hidden/ineligible/archived timestamps and actor fields;
- normal audit fields.

Required constraints:

- unique tenant/Store/Project Product;
- Store Project equals Project Product Project;
- no duplicate Store Product when Product appears through several Catalogues;
- restrictive deletion once referenced by configuration history or later Orders;
- eligibility loss hides purchase but preserves history.

### 7.5 `FundStoreProductConfigurationVersion`

Candidate fields:

- `id`, `organizationId`, `storeProductId`, integer `version`;
- unique Store Product/version;
- configuration hash;
- Product and Project Product revision/source evidence;
- immutable resolved Product display/commercial snapshot;
- immutable resolved input/choice/upload-gate snapshot;
- readiness snapshot;
- created actor/timestamp;
- superseded timestamp where useful.

The resolved snapshot may use validated JSON for the complete version contract while key
query identifiers and commercial fields remain explicit columns.

The live Store Product points to the current version. Historic versions are never updated.

### 7.6 Project Store Product Input Scope

`1R-C3` extends the accepted input-definition/override model so a Project Store Product can
refine Product or Project Product inputs. The migration must update the exactly-one-owner
constraint deliberately and preserve existing Product/Project Product definitions.

The Store Product configuration version stores the fully resolved input contract; checkout
does not merge mutable definitions itself.

## 8. `1R-C4` - Production Asset Version Foundation

### 8.1 Asset Purpose

Production assets include:

- Project source artwork;
- C1-created composite artwork;
- Store Product presentation artwork;
- purchaser Order-line backstop images/files;
- Project/bulk personalisation data files.

### 8.2 Recommended Models

```text
FundProductionAsset
FundProductionAssetVersion
FundProjectAssetLink
FundStoreProductAssetLink
```

Order-line asset links wait for Commerce Core and `1R-C6`.

### 8.3 Immutable Version Fields

- logical asset relation and version number;
- shared `MediaFile`/storage reference;
- original filename, detected MIME type and byte size snapshots;
- checksum;
- malware-scan state/result;
- upload source/actor/time;
- artwork review state and reviewer evidence where applicable;
- retention category and restricted/deleted timestamps;
- normal tenant/audit fields.

Broad file support must not permit executable/script uploads. Exact allowlists, scanning
provider and storage implementation remain separate planning.

### 8.4 Artwork Review State

Recommended enum concepts:

```text
NOT_REQUIRED
AWAITING_UPLOAD
SUBMITTED
UNDER_REVIEW
CHANGES_REQUIRED
APPROVED
```

Artwork review state and Store readiness remain separate.

## 9. `1R-C5` - Commission Policy Foundation

### 9.1 Recommended Models

```text
FundCommissionPolicy
FundCommissionPolicyVersion
FundCommissionStep
FundProjectCommissionAssignment
```

`FundProjectCommissionPeriod` may be introduced with later calculation/accounting work if
no period record is needed before Orders.

### 9.2 Policy Scope

Accepted scopes:

```text
EVENT
PROJECT
```

Exactly one Event or Project owner is required.

- Event-linked Projects inherit the Event default policy when no active Project-specific
  policy exists.
- C1 may assign an Event-linked Project its own flat-rate Project policy for an ad-hoc
  commercial override; that policy wins only for the owning Project.
- Standalone Projects use a C1-managed flat or stepped Project policy.
- Event defaults may be flat or stepped; Event-linked Project overrides are flat only.

### 9.3 Version And Step Enums

Conceptual enums:

```text
Policy method:
- FLAT
- STEPPED

Timing method:
- OFFSET_BASED
- FIXED_DATE

Version status:
- DRAFT
- ACTIVE
- ARCHIVED
```

One stepped version uses only one timing method.

### 9.4 Assignment Acceptance And Finalization

Assignment rules:

- resolve a context-valid active Project policy first, otherwise the Event default, before
  Store publication;
- require explicit acceptance by an authorised C2 Project organiser before publication;
- give C1 configuration and overview responsibility without making C1 acceptance or
  moderation a publication gate;
- allow C1 to propose audited replacement terms after sales, effective only when C2 accepts
  the exact replacement;
- apply the newest accepted assignment retrospectively to the whole Project sales window;
- treat pre-finalization displayed commission as a provisional estimate that recalculates
  from the current accepted assignment;
- do not lock at the first eligible paid sale; finalize terms only with the later post-close
  commission evidence;
- let Project close fix the sales window/calculation period.

No calculation or commission-payment fields belong on individual Order lines.

## 10. `1R-C6` - FUND Commerce Context Foundation

This sub-slice cannot start until the Commerce Core schema foundation exists.

Recommended models:

```text
FundOrderContext
FundOrderLineContext
FundOrderLineInputSnapshot
FundOrderLineAssetSnapshot
```

They store typed FUND Project/Store/Product/production meaning keyed to generic Commerce
Order and line IDs.

They do not duplicate:

- Order numbers;
- purchaser commercial snapshot;
- Order/line monetary totals;
- payment/refund/pro-forma state.

The physical cross-schema foreign-key versus scalar-ID decision requires a Prisma validation
spike in the Commerce Core schema lane. Preserve one-way ownership even if Prisma requires a
reverse relation field for client generation.

## 11. Migration And Backfill Rules

- Use additive migrations first.
- Do not reinterpret existing Product price/VAT fields silently.
- Do not auto-create Stores for every historic Project during initial schema migration.
- Do not auto-create Store Products from all Project Products until readiness/services are
  implemented and reviewed.
- Do not guess C2 logos or Project delivery addresses from unrelated free text.
- Do not mark historic assets scanned/approved without evidence.
- Do not assign commission policies without explicit Project-specific-first/Event-default
  resolution.
- Use short explicit constraint/index names where generated PostgreSQL names may collide.
- Every new FUND relation follows the existing same-tenant composite relation pattern where
  the related model exposes `(organizationId, id)`.

## 12. Index And Constraint Checklist

Plan indexes/constraints for:

- Store by tenant/Project/status/public ID;
- Store Product by tenant/Store/sort/visibility/readiness;
- unique Store Product per selected Project Product;
- configuration version by Store Product/version/hash;
- Product media by Product/role/sort;
- input definitions by owner scope/code/active/sort;
- choices by definition/code/active/sort;
- assets by tenant/context/review/scan state;
- commission policy by tenant/scope/owner;
- active policy version and ordered/non-overlapping steps;
- commission assignment by tenant/Project and assigned version;
- delivery/branding one-to-one ownership;
- archive timestamps where existing FUND conventions require them.

Database check constraints are required where Prisma cannot express exactly-one-owner or
mutually exclusive timing fields.

## 13. Service Invariants Reserved For Later Slices

Schema alone cannot enforce:

- current Product eligibility;
- Project/Store trading-window evaluation;
- Store readiness;
- configuration resolution and hashing;
- Product duplication naming/idempotency;
- C2 permission boundaries;
- file malware scanning;
- commission band calculation;
- Commerce checkout revalidation.

The implementation confirmation must not claim those behaviours merely because schema
fields exist.

## 14. Explicitly Out Of Scope

Do not implement in this planning slice:

- Prisma edits or migrations;
- Commerce Core records;
- services, routers or validation schemas;
- Product duplication execution;
- Product/Store UI;
- public Store routes;
- checkout, Orders, Stripe or pro-forma logic;
- file upload/scanning/storage services;
- production aggregation;
- dispatch;
- commission calculation/accounting/payment;
- Product inventory/stock/warehouse concepts;
- per-Catalogue price, media or option overrides.

## 15. Acceptance Criteria

Planning review should confirm:

- every proposed model is FUND-owned;
- no generic Commerce model is added to FUND;
- the sub-slice/migration split is accepted;
- Product duplication and copied-media semantics are explicit;
- input owner scope and exactly-one-owner enforcement are accepted;
- Store dates remain derived from Project dates;
- Store Product/version history supports later checkout revalidation;
- Client branding and Project delivery gaps are addressed;
- production assets are versioned independently of mutable `MediaFile` metadata;
- Event-default versus Project-specific commission scope, precedence, C2 acceptance,
  retrospective replacement and post-close finalization are explicit;
- `1R-C6` waits for Commerce Core;
- no implementation is performed by this document.

## 16. Accepted Review And Handoff

The 2026-07-13 architecture review accepted this foundation with the following bounded
implementation gates:

- `1R-C1` must include the Project Product tax-treatment and price-entry-basis snapshots
  described above;
- checkout basket persistence remains a Commerce Core decision and must not be introduced
  by a FUND schema slice;
- Commerce Order-line source references inherit the Order source-module boundary;
- refund and pro-forma/manual-payment lifecycle detail remains in the separate Commerce
  implementation lane;
- `1R-C6` remains blocked until the Commerce schema and cross-schema relation strategy are
  implemented and accepted.

Accepted first implementation-planning follow-on:

```text
docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c1-product-media-input-tax-duplication-schema-implementation-planning.md
```

## 17. Accepted Child-Plan Handoff

The `1R-C1` implementation plan was reviewed and accepted on 2026-07-13 and is now
implemented and reviewed as passed. Its authoritative records are:

`docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c1-product-media-input-tax-duplication-schema-implementation-planning.md`

`docs/modules/fund/04-implementation-confirmations/2026-07-13-phase-1-slice-1r-c1-product-media-input-tax-duplication-schema-implementation-confirmation.md`

`docs/modules/fund/05-review-and-test/2026-07-13-phase-1-slice-1r-c1-r1-product-media-input-tax-duplication-schema-review-and-test.md`

```text
1R-C1 is complete through review/test. Do not rerun it and do not begin 1R-C2,
COMMERCE-A2 or another slice without a separate explicit instruction.
```

That explicit instruction was received on 2026-07-14. The bounded `1R-C2` plan now exists
and has been accepted, implemented and reviewed as passed:

`docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1r-c2-client-branding-project-delivery-event-media-schema-implementation-planning.md`

`docs/modules/fund/04-implementation-confirmations/2026-07-14-phase-1-slice-1r-c2-client-branding-project-delivery-event-media-schema-implementation-confirmation.md`

`docs/modules/fund/05-review-and-test/2026-07-14-phase-1-slice-1r-c2-r1-client-branding-project-delivery-event-media-schema-review-and-test.md`

No shared deployment is claimed. Do not rerun `1R-C2`. The Project Intake alignment has
since been separately initiated as planning-only `1P-G-R3`; it does not authorise
implementation, `1R-C6`, `COMMERCE-A2` or another slice.
