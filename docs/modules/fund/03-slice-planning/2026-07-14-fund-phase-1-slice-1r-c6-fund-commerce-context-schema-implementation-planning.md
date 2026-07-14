# FUND Phase 1 Slice 1R-C6 - FUND Commerce Context Schema Implementation Planning

Date: 2026-07-14

Status: Draft awaiting explicit review/acceptance

Roadmap control:

`docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

Parent foundations:

```text
docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-b-commerce-core-and-fund-store-schema-options-planning.md
docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c-fund-store-input-schema-foundation-planning.md
docs/core/commerce/03-slice-planning/2026-07-14-isostack-commerce-core-slice-commerce-a2-checkout-order-order-line-schema-implementation-planning.md
```

Application baseline:

`3206199` on `dev` and `origin/dev`, with 136 migrations

## 1. Goal

Add typed FUND Project, Store, Store Product, input and production-asset meaning keyed to
generic Commerce A2 Orders and Order lines.

C6 must preserve the ownership rule:

```text
Commerce owns the commercial Order, line, seller/purchaser snapshots and money.
FUND owns Project/Store/production context and typed input/asset evidence.
```

C6 is a schema-evidence slice. It creates no checkout, Order, production or commission
service and does not make a Store publicly usable.

## 2. Critical-path Position

```text
COMMERCE-A2 complete
-> FUND 1R-C6 (this plan)
-> FUND 1R-D Store readiness/configuration services
-> later Commerce payment/service/provider and FUND integration slices
```

Commerce A2 is implemented and reviewed. Its tables are empty on the retained disposable
database and no shared database deployment is claimed.

## 3. Cross-schema Relation Direction

Use physical PostgreSQL/Prisma foreign keys from FUND consumer records to generic Commerce
records.

Accepted direction for review:

- `FundOrderContext` references `CommerceOrder` by exact tenant and Order ID;
- `FundOrderLineContext` references `CommerceOrderLine` by exact tenant, line ID and owning
  Commerce Order ID;
- Prisma may expose reverse fields on Commerce models for client generation;
- reverse fields do not give Commerce services knowledge of FUND and do not permit Commerce
  to create FUND records;
- no Commerce source field references a FUND model.

### 3.1 Required Generic Supporting Key

A2 provides `(organizationId, id)` on `CommerceOrder` but its Order-line key does not
include the owning Order. Exact C6 line ownership therefore requires one generic supporting
key:

```text
CommerceOrderLine (organizationId, id, orderId)
```

The C6 implementation plan proposes adding only that unique key and the Prisma reverse
relation fields needed for physical foreign keys. It adds no Commerce field, lifecycle or
behavior.

Review must either accept this bounded supporting-key addition inside the C6 migration or
split it into a preceding Commerce-owned addendum. C6 must not fall back to a scalar-only
line ID or lose tenant/Order integrity merely to avoid the explicit decision.

## 4. Bounded FUND Enums

Add only:

```text
FundOrderProductionStatus
- NOT_READY
- READY
- IN_PRODUCTION
- COMPLETED
- ON_HOLD
- CANCELLED

FundOrderFulfilmentStatus
- PENDING
- READY_FOR_DISPATCH
- DISPATCHED
- DELIVERED
- CANCELLED

FundOrderLineArtworkReadinessStatus
- NOT_REQUIRED
- MISSING
- PRESENT_UNREVIEWED
- READY
- BLOCKED

FundOrderLineProductionUnitProjectionStatus
- NOT_PROJECTED
- PROJECTED
- INVALIDATED

FundOrderLineInputPresenceStatus
- PROVIDED
- OMITTED_OPTIONAL
- MISSING_REQUIRED

FundOrderLineInputValidationStatus
- VALID
- WARNING_ACCEPTED
- INCOMPLETE_ACCEPTED

FundOrderLineAssetRole
- PURCHASER_ARTWORK_BACKUP
- PRODUCTION_INPUT
- PERSONALISATION_DATA
- PRODUCTION_REFERENCE
```

These are FUND workflow vocabulary only. They do not duplicate Commerce Order, payment or
refund status and add no transition service.

## 5. `FundOrderContext`

Planned fields:

```text
id
organizationId
commerceOrderId

projectId
storeId
clientId
eventIdSnapshot?

projectTypeSnapshot
projectNumberSnapshot
projectNameSnapshot

deliveryProfileId
deliveryRecipientNameSnapshot
deliveryAttentionNameSnapshot?
deliveryAddressLine1Snapshot
deliveryAddressLine2Snapshot?
deliveryAddressLine3Snapshot?
deliveryLocalitySnapshot
deliveryRegionSnapshot?
deliveryPostalCodeSnapshot
deliveryCountryCodeSnapshot
deliveryEmailSnapshot?
deliveryPhoneSnapshot?
deliveryNotesSnapshot?

commissionAssignmentIdAtSubmission?
commissionTermsObservedAt?

productionStatus
fulfilmentStatus
createdById?
updatedById?
createdAt
updatedAt
```

Contract:

- exactly one FUND Order context may exist per Commerce Order;
- Commerce Order, Project, Store, Client and delivery profile share the exact tenant;
- Store belongs to the exact Project;
- Project belongs to the exact Client;
- optional Event snapshot must match the Event-linked Project when present;
- Project type/number/name and structured delivery values are immutable submission-time
  audit snapshots;
- the live Project delivery profile remains the Project-level operational source until a
  later production/dispatch slice explicitly finalizes delivery evidence;
- production and fulfilment fields are separate from Commerce payment/refund status;
- C6 adds no production/fulfilment transition rules.

### 5.1 Commission Observation Is Not Calculation Authority

`commissionAssignmentIdAtSubmission` is optional audit evidence of the then-current
accepted assignment. It is not a per-Order commission lock.

C5 remains authoritative:

- C1 may offer a retrospective replacement;
- C2 acceptance makes replacement terms current for the whole Project sales window;
- final commission is resolved after Project close from the finalized Project assignment;
- C6 stores no rate, commission amount, accrual, statement or settlement value.

The relation uses the existing exact assignment `(organizationId, id, projectId)` key.

## 6. `FundOrderLineContext`

Planned fields:

```text
id
organizationId
orderContextId
commerceOrderId
commerceOrderLineId

storeId
projectId
storeProductId
projectProductId
productId
configurationVersionId

workflowClassCodeSnapshot
workflowClassNameSnapshot
configurationHashSnapshot

productionStatus
artworkReadinessStatus
productionUnitProjectionStatus
productionGroupingKey?

createdById?
updatedById?
createdAt
updatedAt
```

Contract:

- exactly one FUND line context may exist per Commerce Order line;
- line context and parent Order context share exact tenant, Commerce Order, Store and
  Project;
- the Commerce line belongs to the exact Commerce Order;
- Store Product belongs to the exact Store/Project and exact Project Product/Product;
- configuration version belongs to the exact Store Product;
- workflow and configuration hash are immutable submission-time snapshots;
- production grouping is FUND-owned but monetary grouping/calculation is not;
- quantity remains authoritative on the Commerce Order line;
- production-unit projection status does not create unit rows or projection behavior.

Required supporting FUND key:

```text
FundProjectStoreProduct
(organizationId, id, storeId, projectId, projectProductId, productId)
```

The key adds no field or behavior; it permits one exact line-context foreign key.

## 7. `FundOrderLineInputSnapshot`

Planned fields:

```text
id
organizationId
orderLineContextId
inputDefinitionId

definitionCodeSnapshot
definitionLabelSnapshot
definitionKindSnapshot
definitionControlTypeSnapshot
definitionOwnerScopeSnapshot
definitionRevisionSnapshot
isRequiredSnapshot
sortOrderSnapshot

presenceStatus
validationStatus
submittedValueSnapshot?
submittedDisplayValueSnapshot?
selectedChoicesSnapshot
priceModifierMinorSnapshot

createdAt
```

Contract:

- one snapshot per line context and definition code;
- the live definition relation is provenance only; rendering/production uses snapshots;
- `selectedChoicesSnapshot` is a bounded JSON array so `MULTI_SELECT` retains every selected
  code/label/price modifier without inventing one Order line per choice;
- aggregate choice modifier is stored in `priceModifierMinorSnapshot` and must reconcile
  with the Commerce line's immutable modifier calculation in a later atomic service;
- missing required input is permitted only with `INCOMPLETE_ACCEPTED`, preserving the C1
  setting that may allow an explicitly disclaimed incomplete Order;
- omitted optional input cannot be marked incomplete;
- C6 creates no input validation or disclaimer behavior.

Snapshots do not duplicate Commerce line net/tax/gross totals.

## 8. `FundOrderLineAssetSnapshot`

Planned fields:

```text
id
organizationId
orderLineContextId
assetId
assetVersionId
role
purposeSnapshot
isRequiredSnapshot
malwareScanStatusSnapshot
artworkReviewStatusSnapshot
wasAvailableAtSubmission
createdAt
```

Contract:

- multiple files are represented by multiple rows;
- asset version must belong to the exact logical Production Asset;
- the immutable version—not merely the asset's current version—is linked;
- public purchaser backup rows use role `PURCHASER_ARTWORK_BACKUP` and purpose
  `ORDER_LINE_ARTWORK_BACKUP`;
- a database check enforces that role/purpose pairing;
- the backup photograph remains a conditional production backstop if the paid purchaser's
  physical original is lost or unavailable;
- snapshot presence does not mean payment confirmed, physical original received or backup
  selected as production source;
- later production services must recheck current malware restriction/deletion and explicit
  production-source authorization.

C6 adds no upload, download, storage, scanning, guest-checkout or purchaser-PII behavior.

## 9. Exact Relation And Key Plan

### 9.1 Order Context

```text
FundOrderContext.(organizationId, commerceOrderId)
  -> CommerceOrder.(organizationId, id)

FundOrderContext.(organizationId, projectId, clientId)
  -> FundProject.(organizationId, id, clientId)

FundOrderContext.(organizationId, projectId, eventIdSnapshot)
  -> FundProject.(organizationId, id, eventId) when Event-scoped

FundOrderContext.(organizationId, storeId, projectId)
  -> FundProjectStore.(organizationId, id, projectId)

FundOrderContext.(organizationId, deliveryProfileId, projectId)
  -> FundProjectDeliveryProfile.(organizationId, id, projectId)
```

### 9.2 Line Context

```text
FundOrderLineContext.(organizationId, commerceOrderLineId, commerceOrderId)
  -> CommerceOrderLine.(organizationId, id, orderId)

FundOrderLineContext.(organizationId, orderContextId, commerceOrderId, storeId, projectId)
  -> FundOrderContext supporting key

FundOrderLineContext exact Store Product source tuple
  -> FundProjectStoreProduct supporting key

FundOrderLineContext.(organizationId, configurationVersionId, storeProductId)
  -> FundStoreProductConfigurationVersion.(organizationId, id, storeProductId)
```

### 9.3 Child Snapshots

Input snapshots reference exact tenant/line context and input definition. Asset snapshots
reference exact tenant/line context, logical asset and asset version.

All foreign keys use explicit short names. Commerce Order/line and historic FUND source
deletion is `Restrict`/`NoAction`; no commercial or production evidence cascades from a
source model deletion.

## 10. Generic Source-tuple Service Gate

Schema relations prove typed identity but cannot compare arbitrary values across related
rows without triggers. The later atomic write service must require:

```text
CommerceOrder.sourceModuleCode = FUND
CommerceOrder.sourceEntityType = PROJECT_STORE
CommerceOrder.sourceEntityId = FundOrderContext.storeId

CommerceOrderLine.sourceItemType = FUND_PROJECT_STORE_PRODUCT
CommerceOrderLine.sourceItemId = FundOrderLineContext.storeProductId

CommerceOrderLine.sourceConfigurationVersion/configuration fingerprint
  = accepted FundStoreProductConfigurationVersion identity/hash
```

C6 does not add that write service. No generic Commerce row becomes FUND-owned merely
because its opaque source ID happens to match.

## 11. Migration And Backfill

One bounded migration after the complete 136-migration A2 baseline, subject to review of
the generic Order-line supporting key.

Order:

1. add bounded FUND enums;
2. add the accepted generic Commerce Order-line supporting key;
3. add the exact Store Product supporting key;
4. create `FundOrderContext`;
5. create `FundOrderLineContext`;
6. create input snapshots;
7. create asset snapshots;
8. add checks, indexes and foreign keys in dependency order.

Backfill policy:

- create no context or snapshot row;
- preserve every A1/A2 and FUND C1-C5/R3-D value;
- infer no Project/Store relation from opaque source text;
- infer no input or asset snapshot from JSON;
- infer no commission assignment or delivery address;
- reject migration if any pre-existing Commerce Order declares `sourceModuleCode = FUND`,
  because silently leaving a historic FUND Order without typed context would violate the
  new boundary;
- generic non-FUND Commerce Orders/lines may exist and remain unchanged.

Expected inventory moves from 136 to 137 migrations if the review accepts one combined
supporting-key/C6 migration. If the supporting key is split into a Commerce addendum, the
review must update the inventory and lifecycle before implementation.

## 12. Checks And Indexes

Required enforcement includes:

- one context per Commerce Order and one line context per Commerce line;
- exact tenant/Order/Store/Project source keys;
- exact Store Product/Project Product/Product/configuration identity;
- nonblank project/workflow/configuration snapshots;
- uppercase delivery country and nonblank required address fields;
- commission observation timestamp/assignment nullability pairing;
- nonblank input definition snapshots and positive definition revision;
- input presence/validation consistency;
- JSON arrays for selected-choice snapshots;
- non-negative input price modifier where accepted configuration requires it, or explicit
  signed modifier support matching existing `FundOrderInputChoice.priceModifierMinor`;
- exact asset/version ownership;
- purchaser-backup role/purpose pairing;
- indexes by tenant/Project/Store/production/fulfilment/readiness;
- indexes by Commerce Order/line IDs;
- indexes by configuration version, input definition and asset version.

Review must explicitly confirm whether signed input modifiers remain supported. The current
source field is signed `Int`; C6 should snapshot it without silently forbidding an existing
discount option.

## 13. Deletion And Retention

- Organization deletion is restricted while Commerce/FUND Order evidence exists;
- Commerce Order/line deletion is restricted by typed contexts;
- Project, Store, Store Product, Project Product, Product, configuration version, input
  definition and asset/version deletion is restricted while referenced;
- archive/tombstone behavior on existing source records remains authoritative;
- snapshot rows have no archive flag because they are immutable commercial/production
  evidence;
- no migration or service purges purchaser input/asset evidence;
- later retention planning must reconcile legal/commercial evidence with personal-data
  minimization before any destructive behavior.

## 14. Disposable-database Validation

Use only `TEST_DATABASE_URL` after proving it differs from `DATABASE_URL`.

Required evidence:

- Prisma format/validation/generation;
- static model/enum/relation/migration contract verification;
- representative 136-to-137 migration with existing generic non-FUND Commerce Order/line
  and representative C1-C5 FUND source rows preserved exactly;
- migration refusal for pre-existing `FUND` source Orders without typed context;
- full fresh replay of the resulting migration inventory;
- valid Event-scoped and standalone Order contexts;
- valid standard, multi-select, optional/incomplete input snapshots;
- valid multiple asset versions including purchaser backup;
- duplicate, unknown and cross-tenant Order/line/source/configuration rejection;
- mismatched Commerce line/Order and FUND Store/Project/Product rejection;
- commission observation and delivery snapshot checks;
- input presence/validation/JSON/definition checks;
- asset purpose/version/tenant/deletion checks;
- restrictive deletion across Commerce and FUND evidence;
- A1/A2 and C1-C5/R3-D static/regression verification;
- zero test residue and final applied/failed migration inventory;
- Commerce-scoped and FUND C6-owned drift inspection;
- type-check, critical-file verification and `git diff --check`.

No shared development, staging or production database may be modified.

## 15. Rollback

Before any real typed context exists, rollback may remove the four C6 tables, bounded enums
and supporting unique keys.

After real Order context exists, destructive rollback is prohibited. Forward repair must
preserve generic Commerce evidence and every typed input/asset snapshot.

Migration failure before completion must leave no partial table/key/enum state. Test
fixtures use transactions or explicit zero-residue cleanup.

## 16. Expected Implementation Files

Only after acceptance:

```text
prisma/schema.prisma
prisma/migrations/<timestamp>_fund_1r_c6_commerce_context_foundation/migration.sql
scripts/verify-fund-1r-c6-contract.ts
scripts/verify-fund-1r-c6-pre-migration.sql
scripts/verify-fund-1r-c6-database.sql
scripts/run-fund-1r-c6-database-tests.ts
docs/modules/fund/04-implementation-confirmations/<1r-c6-record>.md
docs/modules/fund/05-review-and-test/<1r-c6-review>.md
```

Roadmaps and planning README must close the lifecycle recursively.

## 17. Explicitly Out Of Scope

- checkout, Order or line creation services;
- mutable Commerce basket lines;
- Store readiness/configuration/publication services or UI;
- public Store, basket or checkout routes/UI;
- payment, refund, pro-forma, provider or Stripe schema/behavior;
- Order numbering, tax calculation or monetary reconciliation services;
- upload/download/storage/scanning services;
- payment-confirmed or physical-original production authorization;
- backup-photo production-source selection;
- production-unit projection rows or production workflow;
- commission calculation, period, accrual, statement, settlement or payment;
- dispatch workflow;
- shared database deployment.

## 18. Review Gate

Review must resolve:

1. whether the one generic Commerce Order-line supporting key may be included in the C6
   migration or requires a preceding Commerce addendum;
2. the exact composite Store Product and Order-context keys;
3. whether the bounded production/fulfilment/readiness enums are sufficient without
   implying runtime behavior;
4. provisional commission-observation semantics under retrospective C5 replacement;
5. delivery snapshot audit versus later Project-level operational authority;
6. signed input price-modifier snapshot behavior;
7. asset backup role/purpose and multi-file constraints;
8. migration refusal for any pre-existing FUND-source Commerce Order;
9. deletion, retention and disposable validation coverage.

No schema or application implementation is authorised until this review marks C6 accepted.

## 19. Single Review Prompt

```text
Review only FUND Phase 1 Slice 1R-C6 FUND Commerce Context Schema Implementation Planning.
Do not implement schema or application code and do not begin Store 1R-D, COMMERCE-A3 or
another slice.

Verify the plan against completed Commerce A2, FUND C1-C5/R3-D and the current Prisma
multi-schema contract. Resolve the generic Commerce Order-line supporting key and reverse
relation ownership; exact tenant/Order/line/Store/Project/Product/configuration identity;
typed delivery and provisional commission evidence; production/fulfilment/readiness enum
scope; multi-select and signed input snapshots; multi-file immutable asset-version links;
public artwork-backup semantics; deletion/retention; zero backfill; pre-existing FUND-source
Order refusal; migration order, rollback and disposable-database validation.

Confirm C6 stores typed FUND evidence only. It must add no checkout/Order service, Store
readiness/publication, payment/refund/pro-forma/provider/Stripe behavior, upload/scanning,
production authorization/projection, commission calculation or UI.

If acceptable, mark only C6 accepted and provide its single bounded implementation prompt.
Make no Prisma, migration, service, API, route, storage or UI changes during review.
```
