# FUND Phase 1 Slice 1R-C3 - Project Store/Store Product Schema Implementation Planning

Date: 2026-07-14

Status: Accepted 2026-07-14 / implemented and reviewed as passed on disposable PostgreSQL

Parent plan:

`docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c-fund-store-input-schema-foundation-planning.md`

Preceding completed slices:

- `docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c1-product-media-input-tax-duplication-schema-implementation-planning.md`;
- `docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1r-c2-client-branding-project-delivery-event-media-schema-implementation-planning.md`.

## 1. Goal

Define one bounded additive FUND schema migration for:

- one public-addressable Store per Project;
- one Store Product per selected Project Product;
- immutable resolved Store Product configuration versions;
- the accepted `STORE_PRODUCT` extension to typed Order-input ownership.

This document is planning only. It does not authorise Prisma, migration, service, API, UI,
public route, checkout, Order, payment, upload or production implementation.

## 2. Hard Boundary

`1R-C3` may add only FUND-owned Store configuration and the minimum composite keys required
to prove its tenant, Project, Product, media and input-owner integrity.

It must not add:

- checkout sessions, baskets, Commerce Orders or Order lines;
- payment, Stripe, refund or pro-forma records;
- FUND substitutes for generic Commerce records;
- a public Store route, publication service or C2/C1 Store-management UI;
- Product-selection, eligibility, readiness or configuration-resolution services;
- file upload, media mutation or production-asset behaviour;
- Event or standalone commission policy;
- Project Intake/member/User/delivery-profile workflow alignment;
- `1R-C4`, `1R-C6`, `COMMERCE-A2` or another slice.

## 3. Accepted Domain Contract

The Store is a FUND Project outlet, not an independent commerce tenant or date-owning
entity.

```text
C1 Organization (seller/tenant)
  -> FundClient (C2 Project-owning body)
    -> FundProject
      -> FundProjectStore
        -> FundProjectStoreProduct
          -> FundStoreProductConfigurationVersion
```

Controlling rules:

- first pass permits one Store per Project;
- the stable public Store identifier is a locator, not an authentication secret;
- public purchasers do not require an IsoStack account;
- Project `opensAt` and `closesAt` remain the only Store trading dates;
- a Store can trade only when its status, Project lifecycle/dates and later readiness rules
  all permit it;
- a Store Product comes from exactly one active selected `FundProjectProduct` row;
- Catalogue membership can explain eligibility but never identifies or duplicates a Store
  Product;
- one Product selected through several Catalogues still yields one Project Product and one
  Store Product;
- current eligibility loss hides purchasing while preserving Store configuration/history;
- Store Product configuration used by later carts/Orders is immutable and versioned;
- generic Commerce will receive opaque Store/Store Product/version source references and
  must not query FUND to infer purchasability.

## 4. Current Schema Evidence

The committed `COMMERCE-A1`, `1R-C1` and `1R-C2` schema establishes:

- `FundProject` has tenant-scoped identity and owns Store trading dates;
- `FundProjectProduct` is unique by tenant/Project/Product and snapshots Product identity,
  net price, VAT rate, currency, tax treatment and price-entry basis;
- `FundProduct.configurationRevision` records the live Product configuration revision;
- `FundProductMedia` owns typed Product media and has tenant-scoped identity;
- `FundOrderInputDefinition` currently permits exactly one `PRODUCT` or
  `PROJECT_PRODUCT` owner;
- `FundProjectDeliveryProfile`, `FundClientBranding` and `FundEventMedia` now exist, but a
  later readiness service—not this migration—will decide whether their current state is
  sufficient for publication;
- Commerce A1 has no checkout, Order, line or payment model.

No existing Project, Project Product, Product, media, input, branding, delivery or Event
value may be changed or reinterpreted by this migration.

## 5. Accepted Physical Direction

### 5.1 Enums

Add:

```text
FundProjectStoreStatus
- DRAFT
- PUBLISHED
- PAUSED
- CLOSED
- ARCHIVED

FundProjectStoreProductReadinessStatus
- INCOMPLETE
- READY
- BLOCKED
```

Extend the existing `FundOrderInputOwnerScope` with:

```text
STORE_PRODUCT
```

Status meanings remain separate:

- Store lifecycle status controls operator publication intent;
- Store Product `isVisible` controls deliberate presentation;
- `isEligible` records the last resolved Product/Project eligibility result;
- readiness records whether the resolved Store Product contract is purchasable;
- Project lifecycle and dates remain independent runtime gates.

Do not collapse these concerns into one status enum.

FUND enum naming follows the existing model/aggregate prefix convention:

```text
Fund<OwningAggregate><Meaning>
```

Accordingly, this slice uses `FundProjectStoreStatus`,
`FundProjectStoreProductReadinessStatus` and the existing
`FundOrderInputOwnerScope`. New FUND enums must retain the `Fund` namespace prefix and name
their owning aggregate; generic names such as `Status`, `Type` or `ReadinessStatus` are not
permitted. Previously implemented stable enum names are not renamed merely for stylistic
uniformity.

### 5.2 `FundProjectStore`

Planned fields:

```text
id
organizationId
projectId
publicId
status
title
introduction
fundraisingObjective
publishedAt
pausedAt
closedAt
archivedAt
archivedById
archivedReason
createdById
updatedById
createdAt
updatedAt
metadata
```

Field decisions:

- `publicId` is a generated high-entropy UUID and globally unique for stable public URLs;
- `publicId` is never used as purchaser authentication or authorisation;
- `title` is required and nonblank;
- introduction and fundraising objective are optional nonblank text when supplied;
- no `opensAt`, `closesAt`, delivery address, seller profile or payment configuration is
  stored on the Store;
- status defaults to `DRAFT`;
- lifecycle timestamps record actual Store transitions and do not replace Project dates;
- metadata is non-contract extension data only.

Relations and constraints:

- direct tenant relation to `Organization` with tenant-teardown cascade;
- same-tenant Project relation;
- unique `(organizationId, projectId)` for one Store per Project;
- unique `(organizationId, id)` typed identity;
- unique `(organizationId, id, projectId)` relation key for Store Product Project matching;
- global unique `publicId`;
- the Project relation uses `onDelete: NoAction`: direct Project deletion is blocked while
  a Store exists, but an intentional Organization tenant-teardown cascade can remove both
  owner and dependent rows in the same operation;
- tenant/status and tenant/Project indexes support management and resolution.

Store copy is Store-owned. Event banner context continues to resolve through the Project's
Event and its typed `FundEventMedia -> MediaFile` association; no Event copy or media
location is duplicated into the Store row.

All first-party Store banners, Client logos, Product images and similar user-provided media
are uploaded into IsoStack-managed storage and represented by the existing `MediaFile`
foundation plus the appropriate typed FUND association. Users are not expected to provide
or operate external web hosting. A storage key, generated delivery URL or signed URL is an
infrastructure concern resolved from `MediaFile`; it is not user-authored Store data and
must not become the durable identity of the image. This schema slice consumes those typed
media references but does not implement the upload/storage service itself.

### 5.3 `FundProjectStoreProduct`

Planned fields:

```text
id
organizationId
storeId
projectId
projectProductId
productId
sortOrder
isVisible
isEligible
readinessStatus
readinessReasonCodes
eligibilityCheckedAt
readinessCheckedAt
displayTitle
displaySubtitle
displayDescription
primaryProductMediaId
currentConfigurationVersionId
hiddenAt
ineligibleAt
archivedAt
archivedById
archivedReason
createdById
updatedById
createdAt
updatedAt
metadata
```

Defaults:

- `sortOrder = 0`;
- `isVisible = true`;
- `isEligible = false`;
- `readinessStatus = INCOMPLETE`;
- `readinessReasonCodes = []`;
- `metadata = {}`.

Field decisions:

- `projectId` and `productId` are deliberate integrity keys copied from the selected Project
  Product, not independently editable ownership;
- `displayTitle` is required and nonblank; subtitle/description are optional Store-specific
  resolved presentation copy;
- readiness reason codes remain a string array so later gate additions do not require an
  enum migration; services must own a documented stable-code vocabulary;
- `primaryProductMediaId` is optional while setup is incomplete, but if present it must be
  media for the same Product;
- `currentConfigurationVersionId` is nullable until an accepted later resolver creates the
  first immutable version;
- `READY` requires `isEligible = true` and a current configuration version;
- visibility may remain false for an otherwise ready Product, allowing deliberate hiding
  without destroying configuration.

Database-enforced identity:

```text
Store Product (organizationId, storeId, projectId)
  -> Store (organizationId, id, projectId)

Store Product (organizationId, projectProductId, projectId, productId)
  -> Project Product (organizationId, id, projectId, productId)

Store Product (organizationId, primaryProductMediaId, productId)
  -> Product Media (organizationId, id, productId)
```

The supporting composite unique keys added to `FundProjectProduct` and
`FundProductMedia` are relation targets only. They do not alter data or business identity.

Additional constraints:

- unique `(organizationId, storeId, projectProductId)`;
- unique `(organizationId, id)` typed identity;
- unique `(organizationId, id, projectProductId, productId)` relation key for immutable
  configuration-version source matching;
- non-negative sort order;
- nonblank display title and optional display text when supplied; readiness reason-code
  syntax is a later service-owned stable vocabulary rather than a speculative database
  enum or array-expression check;
- Project Product and primary Product-media relations use `onDelete: NoAction`, blocking
  direct source deletion while permitting intentional tenant teardown;
- explicit Store deletion may cascade its mutable Store Products and configuration
  versions in this pre-Order foundation, but later Order references must restrict historic
  deletion;
- service planning must prohibit hard deletion after publication/configuration history and
  use archive/hide instead; database Order-history restriction is added only when those
  typed relations exist.

### 5.4 `FundStoreProductConfigurationVersion`

Purpose:

- preserve one immutable resolved Store Product contract for later cart and Order-line
  validation.

Planned fields:

```text
id
organizationId
storeProductId
version
configurationHash
sourceProductId
sourceProductRevision
sourceProjectProductId
sourceProjectProductUpdatedAt
productCodeSnapshot
productNameSnapshot
displayTitleSnapshot
displaySubtitleSnapshot
displayDescriptionSnapshot
unitPriceNetSnapshot
vatRateSnapshot
currencySnapshot
taxTreatmentSnapshot
priceEntryBasisSnapshot
primaryProductMediaIdSnapshot
mediaSnapshot
inputContractSnapshot
readinessSnapshot
createdById
createdAt
```

Decisions:

- the database requires a positive version and uniqueness per Store Product; the later
  insert-only resolver assigns the next monotonically increasing value transactionally;
- unique `(organizationId, storeProductId, version)` prevents duplicate versions;
- `configurationHash` is a required lowercase 64-character SHA-256 hex digest of a
  documented canonical resolved payload;
- commercial fields use the existing Project Product snapshots without changing their
  interpretation;
- currency remains a three-letter uppercase code;
- Product/configuration revision and Project Product update evidence make the source state
  auditable; `sourceProductId`, `sourceProjectProductId` and
  `primaryProductMediaIdSnapshot` are immutable scalar evidence rather than deletion-
  coupling foreign keys;
- media and input snapshots are immutable JSON contracts with documented schema versions;
- the live Store Product points to its current version through a composite relation proving
  that the version belongs to that Store Product;
- no `updatedAt`, update actor or mutable metadata belongs on a version row;
- database constraints protect shape and ownership. Immutability is a schema/domain
  contract reinforced by having no update/audit-mutation fields; the later resolver must
  expose insert/read-only behaviour, and later Order foreign keys will restrict deletion.
  `1R-C3` does not claim that PostgreSQL alone prevents a privileged direct `UPDATE`;
- no cart or Order reference is added in `1R-C3`.

Exact ownership keys:

```text
Configuration Version
  (organizationId, storeProductId, sourceProjectProductId, sourceProductId)
  -> Store Product
     (organizationId, id, projectProductId, productId) ON DELETE CASCADE

Store Product (organizationId, currentConfigurationVersionId, id)
  -> Configuration Version (organizationId, id, storeProductId) ON DELETE NO ACTION
```

The first relation proves that the recorded source Product/Project Product IDs match the
Store Product at version creation without coupling history to deletion of the mutable
Product or Project Product rows. The configuration-version table also exposes unique
`(organizationId, id, storeProductId)`. The second relation blocks direct deletion of the
current version and prevents a Store Product from pointing at another Store Product's
version, while `NoAction` avoids a restrictive-action conflict when the owning Store
Product is intentionally deleted and its versions cascade. Prisma must use explicit named
relations for these two directions.

`unitPriceNetSnapshot` and `vatRateSnapshot` remain nullable so an incomplete source can be
represented without inventing commercial values; when present, accepted range checks
apply. Later readiness must block a missing price/VAT decision or `UNCLASSIFIED` tax state.

Migration relation order must avoid the current-version cycle:

1. create Store;
2. create Store Product without its current-version foreign key;
3. create configuration version and its Store Product foreign key;
4. add the Store Product current-version composite foreign key.

### 5.5 Store Product Input Ownership

Extend `FundOrderInputDefinition` with nullable `storeProductId` and a typed same-tenant
relation to `FundProjectStoreProduct`.

Replace the existing owner constraint so exactly one matching owner is always present:

```text
PRODUCT        -> productId only
PROJECT_PRODUCT -> projectProductId only
STORE_PRODUCT  -> storeProductId only
```

Add:

- tenant/Store Product/sort index;
- partial unique `(organizationId, storeProductId, code)` where `storeProductId` is not
  null;
- Store Product relation with cascade while definitions remain mutable configuration.

Existing Product and Project Product definitions retain their current IDs, owners,
revisions, choices and media mappings. The new column is null for every existing row.

The migration SQL must handle the PostgreSQL enum extension safely. Owner checks may cast
the enum to text, and the new partial index may predicate on `store_product_id IS NOT NULL`,
so the migration does not depend on unsafe same-transaction use of a newly added enum
literal.

## 6. Effective Store And Readiness Semantics

No database column alone proves a Store is open. Later application planning must evaluate:

```text
Store.status == PUBLISHED
AND Project status/lifecycle permits trading
AND now is within Project.opensAt and Project.closesAt
AND Project is not archived
AND required Project delivery/branding/artwork gates pass
AND Store Product is visible, eligible and READY
AND current configuration version still matches the resolved source state
```

Consequences:

- Project date edits take effect without copying dates to Store;
- reaching a Project close date does not require rewriting Store dates;
- Store `CLOSED` remains an explicit operator lifecycle state, not an inferred date cache;
- Product `UNCLASSIFIED` tax treatment must cause later readiness to block;
- this schema migration does not calculate, publish or repair readiness.

## 7. Migration And Backfill Plan

Create one additive migration only after explicit plan acceptance.

Order:

1. add the Store lifecycle/readiness enums and extend input owner scope;
2. add supporting composite unique keys to existing Project Product and Product Media;
3. create `fund_project_stores`;
4. create `fund_project_store_products` without the current-version foreign key;
5. create `fund_store_product_configuration_versions`;
6. extend `fund_order_input_definitions` with `store_product_id`;
7. replace the input exactly-one-owner check and add Store Product indexes/uniqueness;
8. add nonblank, non-negative, hash, currency, positive-version and readiness checks;
9. add same-tenant Project/Product/media/version foreign keys with the accepted
   Cascade/`NoAction` actions in dependency order;
10. validate representative existing-data upgrade and complete fresh replay only on the
    verified disposable database.

Automatic backfill:

- create no Store;
- create no Store Product;
- create no configuration version;
- create no Store-owned input definition;
- do not infer public IDs, display copy, media, eligibility or readiness;
- do not copy Product or Project Product inputs;
- do not update Product/Project Product tax, price, media or revision data.

Required pre/post evidence:

- all existing table counts and scalar/JSON values are unchanged;
- existing input-owner rows and their choices/media are unchanged;
- all three new tables are empty immediately after migration;
- existing Product and Project Product commercial snapshots are byte/value equivalent;
- enum/table/index/check/foreign-key inventory matches the accepted contract.

## 8. Expected Implementation Files

Only after acceptance:

```text
prisma/schema.prisma
prisma/migrations/<timestamp>_fund_1r_c3_project_store_store_product/migration.sql
scripts/verify-fund-1r-c3-schema.ts
scripts/verify-fund-1r-c3-pre-migration.sql
scripts/verify-fund-1r-c3-database.sql
```

Then create exactly one `1R-C3` implementation confirmation and one review/test record,
update the FUND and root roadmaps, and stop.

No service, route, page, component, Store UI, Commerce, upload, production or commission
file belongs to this slice.

## 9. Validation Matrix

Required before implementation confirmation:

- Prisma format, validation and client generation pass;
- targeted `1R-C3` schema/migration verifier passes;
- type-check, targeted lint, repository verification and `git diff --check` pass;
- migration applies after the current 130-migration baseline with representative existing
  Project, Project Product, Product Media and all existing input-owner forms;
- all existing values and counts remain unchanged;
- complete fresh-database migration replay passes;
- valid Store, Store Product, configuration version and Store-owned input rows can be
  created;
- duplicate Store per Project, public ID and Store Product per selected Project Product are
  rejected;
- cross-tenant Store/Project/Project Product/Product Media/input relations are rejected;
- a Store Product whose Store Project differs from its Project Product Project is rejected;
- a Store Product whose Product differs from its Project Product or primary media Product
  is rejected;
- a configuration version whose recorded source Product or Project Product differs from
  its Store Product is rejected;
- a current configuration version belonging to another Store Product is rejected;
- duplicate/non-positive configuration versions, malformed hashes, invalid currency,
  negative sort order and blank required copy are rejected;
- `READY` without eligibility/current configuration is rejected;
- Product, Project Product and Store Product input owners each accept only their matching
  exactly-one-owner shape;
- duplicate Store Product input code is rejected while the same code under another owner is
  permitted;
- direct Project/Project Product/Product Media/current-version deletion is blocked, explicit
  Store deletion cascades its pre-Order mutable configuration, and intentional Organization
  tenant teardown succeeds without orphaning rows;
- cleanup leaves zero test residue;
- A1, C1 and C2 static/database regression checks still pass;
- schema/migration diff introduces no Commerce, checkout, Order, payment, upload,
  production, commission or Intake-alignment implementation.

Database-backed checks must use only `TEST_DATABASE_URL`, after proving it is distinct from
`DATABASE_URL`. Use the retained disposable test database/direct endpoint for destructive
reset and migration operations. Do not modify shared development, staging or production
databases.

## 10. Failure And Rollback Strategy

- review generated and handwritten SQL before application;
- fix an unapplied migration rather than layering speculative correction migrations;
- recreate only the verified disposable database after a failed migration test;
- never drop or rewrite existing Project/Product/media/input data;
- if a constraint reveals impossible representative legacy data, stop and amend the plan
  rather than weakening tenant or ownership integrity silently;
- correct an already-applied persistent environment through a reviewed forward migration
  unless an operator-approved restore is safer;
- record migration identifier, pre/post counts, test target and residue inventory in the
  implementation confirmation.

Rollback of application code must not assume the new enum value can be removed safely.
Persistent-environment rollback therefore uses restoration or a reviewed forward
compatibility migration, not ad hoc enum surgery.

## 11. Explicit Non-Goals

- no Store creation/publication/readiness/configuration service;
- no C1/C2 Store manager or public Store page;
- no basket, checkout, Order, line, payment, Stripe, refund or pro-forma;
- no public purchaser identity/contact capture;
- no direct-to-purchaser delivery or fulfilment calculation;
- no Product/Project Product selection or duplication service;
- no upload/storage/scanning or production asset/version;
- no commission policy or calculation;
- no Project Intake/member/User/delivery alignment;
- no `1R-C4`, `1R-C6` or Commerce A2 work.

## 12. Acceptance Criteria

Accept this implementation plan only when:

- Store lifecycle, visibility, eligibility, readiness and Project-date authority remain
  separate;
- one Store per Project and one Store Product per selected Project Product are explicit;
- tenant, Project and Product equality is database-enforced through composite relations;
- primary media cannot belong to a different Product;
- configuration versions are immutable resolved evidence and current-version ownership is
  enforced;
- the Store Product input-owner extension preserves every existing definition;
- no Store/configuration rows are inferred by migration;
- generic Commerce ownership and opaque source-reference boundaries remain intact;
- deletion before Commerce history and later history restrictions are distinguished;
- migration, representative-data, fresh-replay, constraint, regression and cleanup evidence
  are required;
- no implementation occurs before explicit acceptance.

### 12.1 Decision Closure

There are no unresolved business or schema questions inside the bounded `1R-C3` plan. The
2026-07-14 review resolved deletion actions, exact current-version ownership, source-
evidence relations and the boundary between database constraints and later insert-only
service enforcement against the implemented C1/C2 schema.

The following are later-slice dependencies, not open `1R-C3` questions:

- Store creation, configuration resolution, publication/readiness and public access;
- Project Intake organiser/delivery alignment;
- Commerce cart/Order source references and historic deletion restrictions;
- production assets, commission and payment behaviour.

## 13. Review And Acceptance Outcome

Review result: accepted for bounded implementation.

The review confirmed:

- Store lifecycle does not copy or replace Project trading dates;
- composite keys enforce same-tenant Store/Project Product/Product-media identity;
- exact source/current-version ownership prevents mismatched source evidence and cross-Store
  Product version selection;
- Store-owned inputs extend, rather than reinterpret, existing Product and Project Product
  definitions;
- no existing row requires a Store, configuration version or Store-owned input backfill;
- `NoAction` direct-owner/current-version relations preserve deletion safety without
  blocking deliberate Organization tenant teardown;
- fresh and representative existing-data migration/constraint validation remains mandatory
  on the retained disposable database;
- Commerce, Project Intake, upload, production, commission and UI/application behaviour
  remain outside this implementation.

Acceptance does not authorise another slice and does not claim implementation or shared
database deployment.

## 14. Single Bounded Implementation Prompt

```text
Continue only accepted FUND Phase 1 Slice 1R-C3. Do not begin Project Intake alignment,
1R-C4, COMMERCE-A2 or another slice.

Implement only the accepted Project Store, Store Product, immutable configuration-version
and STORE_PRODUCT input-owner schema foundation in the current Prisma schema and one
bounded migration. Preserve Project-date authority and every existing Project, Project
Product, Product-media and input-definition value. Create no Store, Store Product,
configuration-version or Store-owned input rows by migration. Apply the accepted composite
same-tenant/Project/Product/media/current-version keys, Cascade/NoAction deletion actions,
checks, partial unique indexes and enum extension exactly as planned.

Do not add Store creation, readiness/configuration/publication services, public routes, UI,
Project Intake changes, uploads, Commerce checkout/Orders/payments, production assets or
commission behaviour.

Use only TEST_DATABASE_URL after proving it differs from DATABASE_URL. Complete fresh and
representative existing-data migration tests, all planned identity/constraint/deletion
tests, A1/C1/C2 regression checks and zero-residue cleanup. Do not modify shared
development, staging or production databases.

After successful validation, create the separate FUND 1R-C3 implementation-confirmation
and review/test records, update the FUND and root roadmaps, and stop without starting the
next slice.
```

## 15. Lifecycle Outcome

The accepted bounded schema implementation and separate review/test lifecycle completed on
2026-07-14:

`docs/modules/fund/04-implementation-confirmations/2026-07-14-phase-1-slice-1r-c3-project-store-store-product-schema-implementation-confirmation.md`

`docs/modules/fund/05-review-and-test/2026-07-14-phase-1-slice-1r-c3-r1-project-store-store-product-schema-review-and-test.md`

Representative 130-to-131 migration, complete fresh 131-migration replay, constraint,
deletion, regression and zero-residue checks passed on the retained disposable database.
No shared development, staging or production deployment is claimed. Do not rerun `1R-C3`
or begin `1R-C4`, Project Intake alignment, Commerce A2 or another slice without a separate
explicit instruction.
