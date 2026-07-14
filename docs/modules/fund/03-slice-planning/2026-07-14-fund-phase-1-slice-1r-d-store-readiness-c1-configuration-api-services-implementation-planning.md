# FUND Phase 1 Slice 1R-D - Store Readiness And C1 Store Configuration API/Services Implementation Planning

Date: 2026-07-14

Status: Implemented, independently reviewed and validated at application commit `db85fcc`

Parent architecture:

`docs/modules/fund/03-slice-planning/2026-07-08-fund-phase-1-slice-1r-a-store-orders-commerce-core-planning.md`

Completed schema foundations:

- `1R-C1` Product media/input/tax/duplication;
- `1R-C2` Client branding, Project delivery and Event media;
- `1R-C3` Project Store, Store Product and immutable configuration version;
- `1R-C4` Production Asset Version;
- `1R-C5` Commission Policy and Assignment;
- `1R-C6` typed FUND Commerce context.

Parent controls:

- `docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`
- `docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

## 1. Goal

Implement the internal C1 service/API boundary that turns an already selected Project
Product set into a safe, versioned Project Store configuration and explains whether it may
be published.

The bounded flow is:

```text
C1 prepares one Store for one Project
-> service synchronises active Project Products without deleting history
-> current Product/Project Product/media/input/asset evidence is revalidated
-> each Store Product receives an immutable canonical configuration version
-> explicit readiness reason codes explain every blocker
-> C1 may publish, pause, resume, close or archive only through guarded transitions
```

The slice also implements the accepted safe Product duplication service required to create
an independently editable seasonal/contextual Product and explicitly selected Catalogue
memberships.

This is an internal configuration slice. It does not expose the Store publicly, perform
checkout, accept C2 commission terms, upload media or add UI.

## 2. Entry Baseline And No-Migration Gate

Implementation starts only from:

- application `dev` commit `9947669`;
- complete 137-migration disposable PostgreSQL history;
- C6 implementation/review documentation commit `4274eb7`;
- clean application and documentation worktrees apart from this lifecycle;
- a configured `TEST_DATABASE_URL` proven distinct from `DATABASE_URL` before writes.

The current Prisma schema already contains every 1R-D persistence field. This plan adds no
model, enum, field, index, constraint or migration. If implementation discovers that safe
behaviour requires a missing database invariant, stop and return to schema planning rather
than widening this service slice.

## 3. Controlling Business And Ownership Rules

1. One `FundProjectStore` belongs to exactly one same-tenant Project.
2. Project opening and closing instants remain authoritative; Store rows do not copy them.
3. Store status expresses operator intent and does not by itself prove that purchasing is
   currently open.
4. Product owns base price, tax treatment, price-entry basis, media and input definitions.
   Catalogue membership supplies availability only and never overrides Product terms.
5. Active `FundProjectProduct` rows are the selected Project subset. Store preparation
   consumes them, not raw Catalogue membership.
6. C1 configures and oversees Store terms. C1 approval/moderation is not a publication
   gate.
7. The current effective commission assignment must have explicit C2 acceptance before
   first publication. 1R-D reads and records that evidence but does not create, propose,
   replace or accept commission assignments.
8. Required Project/Store Product assets block only through explicit required links and
   accepted clean/reviewed evidence. Purchaser Order-line backups do not affect Store
   publication.
9. All images/files are IsoStack-managed `MediaFile` or Production Asset versions. The
   service validates tenant ownership and never accepts an external presentation URL.
10. No absent price, tax category, media, acceptance or asset state is inferred.

## 4. Bounded Scope

Implement only:

- C1 tenant/admin validation and inputs for Store preparation, refresh, copy edits and
  lifecycle actions;
- one Store-management router under `fund.storeManagement.*`;
- idempotent one-Store-per-Project creation;
- synchronisation of active Project Products into one Store Product per Project Product;
- current eligibility revalidation through the accepted 1Q-E source/suitability policy;
- Product-authoritative commercial snapshot refresh into Project Product evidence;
- deterministic Store Product presentation/media/input resolution;
- canonical schema-versioned configuration payload and SHA-256 hash generation;
- insert-only configuration versions and atomic current-version switching;
- stable Store Product and Store-level readiness codes;
- guarded publish/resume, pause, close and archive transitions with audit;
- publication-time commission-assignment snapshot update;
- safe, transactional, idempotent Product duplication including media associations,
  suitability, inputs/choices/choice media and explicitly requested target Catalogues;
- Product configuration-revision increments for later configuration-affecting edits;
- focused pure, service, router/static and disposable-database tests.

Do not implement:

- any Prisma schema or migration change;
- Product media/input/upload management APIs beyond copying existing accepted records;
- C2 commission offer/acceptance or replacement services;
- a public Store route, authenticated C2 Store route or real Store rendering;
- Store, Product Manager or commission UI;
- cart, checkout, Commerce Order/line creation or C6 context creation;
- payment, refund, pro-forma, provider or Stripe behaviour;
- upload, scanning, artwork-review or storage mutation;
- production authorisation/projection, fulfilment, dispatch or commission calculation;
- Store deletion after configuration history;
- email or notification behaviour;
- unrelated LMSPro work.

## 5. Access And Transaction Boundary

All router procedures must:

- use `withFeature('fund')`;
- derive the effective user and tenant from the authenticated context;
- permit only C1 `OWNER` or `ADMIN` actors;
- accept no `organizationId` from a caller;
- return not-found for cross-tenant Project, Store, Product or Catalogue identities;
- use serializable transactions for Store refresh/version switching and Product
  duplication;
- acquire a transaction advisory lock keyed by tenant plus Project for Store mutation, or
  tenant plus target Product code/slug for duplication;
- write audit rows in the same transaction as every mutation;
- make retry outcomes deterministic.

Read-only readiness may calculate outside a write transaction. A write action must
recalculate inside its own locked transaction and must never publish from a stale client
readiness response.

## 6. Store Preparation And Synchronisation

### 6.1 Idempotent Store creation

`prepareForProject(projectId)`:

- validates same-tenant Project, Client, organiser and delivery ownership;
- rejects an archived Project;
- returns the existing Store if one exists;
- otherwise creates one DRAFT Store using the Project name as its initial title;
- never copies Project dates, delivery address, Event banner or branding into the Store;
- synchronises and resolves Store Products in the same transaction.

### 6.2 Store Product identity

For every active same-tenant `FundProjectProduct`, synchronisation creates at most one
`FundProjectStoreProduct` with the exact Project/Product keys. Initial copy is:

```text
displayTitle       <- current Product name
displaySubtitle    <- current Product short description
displayDescription <- current Product description
sortOrder          <- Project Product sort order
```

Existing Store-owned copy and deliberate visibility are preserved. A removed/inactive
Project Product is never hard-deleted: its Store Product becomes ineligible and BLOCKED
with `PROJECT_PRODUCT_INACTIVE`. Existing configuration and Order history remain intact.

### 6.3 Eligibility

Refresh uses the accepted 1Q-E Event/standalone Catalogue and suitability policy at the
server evaluation instant. An active selected Project Product is eligible only if its
Product appears in the current deduplicated eligibility result.

Eligibility loss sets:

```text
isEligible = false
ineligibleAt = first observed loss time
readinessStatus = BLOCKED
```

Regained eligibility clears `ineligibleAt`. It does not automatically change a C1-hidden
Store Product back to visible.

### 6.4 Product-authoritative Project Product snapshots

Before resolving a Store Product, refresh copies the current Product/workflow commercial
contract into its selected Project Product evidence:

- Product code/name/short description;
- workflow identity/code/name;
- unit price, VAT rate and currency;
- tax treatment and price-entry basis.

This closes the pre-C1 service gap where tax treatment and price-entry basis were not copied
by the old Project Product mutation. No separate Project Product commercial override exists
in the current schema, so current Product terms win. A future override requires a separate
accepted schema/service slice.

## 7. Configuration Resolution And Versioning

### 7.1 Presentation and media

Resolution uses Store-owned display copy plus current Product commercial evidence.

Primary media precedence:

```text
valid explicit Store Product primary Product-media selection
else active Product media with role PRIMARY
else unresolved and PRIMARY_MEDIA_MISSING
```

Every resolved Product-media row and its `MediaFile` must belong to the actor tenant. Active
gallery media is retained in deterministic role/sort/ID order. No URL supplied by a caller
is accepted.

### 7.2 Input merge

Active input definitions resolve by exact stable `code` in this order:

```text
Product definition
-> matching Project Product definition replaces it
-> matching Store Product definition replaces it
```

Replacement is whole-definition replacement, not an unsafe field merge. Definitions and
active choices are then ordered by `sortOrder`, `code` and ID. Choice Product-media is
included only when it belongs to the same Product and tenant.

The version snapshot records definition/choice IDs, owning scope, code, label, help text,
kind, control, required/default/validation/customer/production visibility, sort order,
revision, signed price modifier and display-media evidence. Checkout later consumes this
resolved snapshot; it must not merge live definitions.

### 7.3 Asset readiness

A required `FundProjectAssetLink` blocks Store readiness unless its logical asset:

- is active and unarchived;
- has a current immutable version;
- has `CLEAN` malware evidence;
- is neither restricted nor deleted; and
- has artwork state `APPROVED` or `NOT_REQUIRED` for the current/review version.

A linked Store Product presentation asset is evaluated the same way. Optional source and
production assets may remain incomplete without blocking publication. Order-line artwork
backup purpose is excluded from this publication calculation.

### 7.4 Canonical payload and hash

Use one pure canonicaliser with recursive object-key sorting and preserved array order.
The version-1 payload contains only resolved contract data:

```text
schemaVersion
source Product/Project Product revisions and timestamps
Product/workflow identity
Store-owned presentation copy
commercial/tax values as exact decimal strings
primary and gallery media evidence
resolved input contract
asset/readiness evidence and stable reason codes
```

`configurationHash` is lowercase SHA-256 hex of UTF-8 canonical JSON. Volatile evaluation
time, actor, database IDs for the new version and diagnostic prose are excluded.

Under the Project advisory lock, the service:

1. locks the Store Product and current version;
2. returns the current version when its hash is unchanged;
3. otherwise allocates `max(version) + 1`;
4. inserts one immutable version;
5. atomically points the Store Product at it;
6. updates eligibility/readiness evidence and audits the change.

Historic versions are never updated or deleted by the service.

## 8. Stable Readiness Contract

### 8.1 Store Product codes

The service owns these stable reason codes:

```text
PROJECT_PRODUCT_INACTIVE
PRODUCT_NOT_ACTIVE
PRODUCT_NOT_ELIGIBLE
WORKFLOW_NOT_ACTIVE
PRICE_MISSING
PRICE_INVALID
VAT_INVALID
TAX_UNCLASSIFIED
CURRENCY_INVALID
PRIMARY_MEDIA_MISSING
MEDIA_TENANT_MISMATCH
INPUT_CONTRACT_INVALID
REQUIRED_PROJECT_ASSET_NOT_READY
REQUIRED_PRESENTATION_ASSET_NOT_READY
```

Rules:

- no reasons plus current configuration version and eligibility gives `READY`;
- a correctable missing setup value gives `INCOMPLETE`;
- inactive, ineligible, unsafe media or rejected asset evidence gives `BLOCKED`;
- codes are sorted/deduplicated before persistence;
- human copy remains UI work and is not stored as a contract.

### 8.2 Store-level codes

Readiness response derives, but does not persist as a new table:

```text
STORE_ARCHIVED
STORE_CLOSED
PROJECT_NOT_ACTIVE
PROJECT_ARCHIVED
PROJECT_DATE_INVALID
PROJECT_ALREADY_CLOSED
DELIVERY_PROFILE_MISSING
COMMISSION_ACCEPTANCE_REQUIRED
COMMISSION_CLOSE_SNAPSHOT_STALE
NO_VISIBLE_STORE_PRODUCTS
STORE_PRODUCT_NOT_READY
```

Project opening in the future does not block publication; it only blocks later runtime
trading until the opening instant. Project close at or before evaluation does block
publication/resume. Client branding and Event banner absence do not block because accepted
fallback presentation exists.

## 9. Lifecycle Actions

Accepted transitions:

```text
DRAFT     -> PUBLISHED | ARCHIVED
PUBLISHED -> PAUSED | CLOSED | ARCHIVED
PAUSED    -> PUBLISHED | CLOSED | ARCHIVED
CLOSED    -> ARCHIVED
ARCHIVED  -> no transition in 1R-D
```

### 9.1 Publish/resume

The mutation refreshes inside the lock and requires:

- Project ACTIVE, unarchived and `opensAt < closesAt`;
- evaluation before Project close;
- exact delivery profile;
- at least one visible Store Product and every visible Store Product READY;
- one current effective commission assignment with status ACCEPTED for the exact
  Project/Store, an authorised C2 acceptance actor already recorded by C5 evidence, and a
  Project-close snapshot equal to current `Project.closesAt`.

First publication sets `publishedAt` once and writes the same timestamp into the accepted
assignment's `storePublishedAtSnapshot` atomically. Resume preserves the first publication
instant. If a later accepted replacement has no publication snapshot, resume may copy the
Store's original `publishedAt`; 1R-D does not create or accept that replacement.

### 9.2 Pause, close and archive

- pause is explicit and preserves configuration;
- close records `closedAt` and is irreversible in this slice;
- archive records actor/reason/time and is irreversible in this slice;
- refresh may still explain historic configuration but may not reopen CLOSED/ARCHIVED;
- no hard Store or Store Product deletion procedure is exposed.

Every transition is idempotent only when the requested target is already the current state;
otherwise invalid transitions fail without partial writes.

## 10. Product Duplication

`duplicateProduct` requires:

```text
sourceProductId
newCode
newSlug
newName
targetCatalogueIds[]
```

The service:

- locks the tenant/source and target code/slug;
- rejects cross-tenant, archived source or invalid/archived target Catalogues;
- returns an existing exact copy on retry when source, code and slug match;
- otherwise creates a DRAFT Product with new identity, revision 1 and copy provenance;
- copies Product commercial/tax/configuration/production fields;
- copies active/inactive media associations to the same immutable tenant-owned MediaFiles;
- copies Project-type and organisation-type suitability;
- deep-copies Product-owned input definitions, choices and choice-media mapping to the new
  Product-media row IDs;
- adds only the explicitly selected target Catalogue memberships;
- never copies source Catalogue memberships implicitly;
- audits source, copy and target Catalogues transactionally.

The natural idempotency key is the tenant plus source Product plus normalized target
code/slug. A retry with conflicting details fails rather than creating a second Product.

## 11. Proposed API Contract

Add:

```text
src/modules/fund/lib/store-configuration.ts
src/modules/fund/lib/validation/store-management.ts
src/modules/fund/services/store-management.service.ts
src/modules/fund/routers/store-management.router.ts
```

Register:

```text
fund.storeManagement.getForProject
fund.storeManagement.prepareForProject
fund.storeManagement.refreshConfiguration
fund.storeManagement.updateStoreCopy
fund.storeManagement.updateStoreProductPresentation
fund.storeManagement.publish
fund.storeManagement.pause
fund.storeManagement.close
fund.storeManagement.archive
```

Extend the existing Product validation/service/router with:

```text
fund.products.duplicate
```

No procedure accepts raw readiness codes, calculated hashes, source revisions, tenant IDs,
commission state or lifecycle timestamps from the caller.

## 12. Failure And Rollback Policy

- validation, tenant, readiness or transition failure commits nothing;
- failure after any Store Product/version/duplicate child write rolls back the whole
  transaction and audit;
- unique conflicts are reread only for the documented idempotent Store/duplicate outcome;
- unexpected infrastructure errors are not converted into readiness blockers;
- no migration rollback exists because 1R-D adds no migration;
- after service use, rollback is code rollback only and must not delete Store,
  configuration-version, Product-copy or audit evidence.

## 13. Validation Plan

Static/repository:

```text
npx prisma validate
npx prisma generate
npx tsx scripts/verify-fund-1r-d-store-services.ts
npx eslint --no-ignore <all 1R-D changed TypeScript files>
npm run type-check
npm run verify
git diff --check
```

Pure tests:

- stable canonical JSON/hash independent of object insertion order;
- array order, decimal strings, signed modifiers and schema version preserved;
- exact input precedence and whole-definition replacement;
- sorted/deduplicated readiness codes and lifecycle transition matrix.

Disposable integration tests, only after the database identity proof:

- exactly 137 applied migrations and zero failed migrations before/after;
- Event and standalone Store preparation;
- same-Project retry returns one Store and one Store Product per Project Product;
- multi-Catalogue Product deduplicates to one Store Product;
- cross-tenant Project/Product/Catalogue/media rejection;
- Product current tax/commercial evidence refreshes Project Product;
- unchanged hash reuses version; changed source/copy/input/media produces next version;
- inactive/removed Project Product is preserved but blocked;
- missing price, unclassified tax, missing media and unsafe required asset blockers;
- clean approved/not-required required assets pass;
- C2-accepted current commission and exact close snapshot gate first publication;
- proposed/missing/stale assignment, closed Project and unready Product block publication;
- publish/pause/resume/close/archive chronology and invalid transitions;
- publication timestamp written once to Store and accepted assignment;
- Product duplicate deep copy, explicit Catalogue selection, safe MediaFile reuse,
  independent edits and exact retry;
- injected rollback after Store, version, duplicate Product and child-copy stages;
- C1-C6, Project Intake, K1-F/K2 and product eligibility regressions;
- zero Store/duplicate/audit fixture residue.

No shared development, staging or production database may be contacted or modified.

## 14. Expected Application Files

An accepted implementation may change only the bounded service/API surface and tests:

```text
src/modules/fund/lib/store-configuration.ts
src/modules/fund/lib/store-configuration.test.ts
src/modules/fund/lib/validation/store-management.ts
src/modules/fund/lib/validation/products-catalogues.ts
src/modules/fund/services/store-management.service.ts
src/modules/fund/services/products.service.ts
src/modules/fund/services/projects.service.ts
src/modules/fund/routers/store-management.router.ts
src/modules/fund/routers/products.router.ts
src/modules/fund/routers/index.ts
scripts/verify-fund-1r-d-store-services.ts
scripts/run-fund-1r-d-store-service-tests.ts
```

Small lifecycle-aware maintenance to existing static verifiers is allowed only if a prior
verifier incorrectly forbids the accepted later service. No Prisma or migration file is
authorised.

## 15. Review Gate

Independent review must confirm:

1. the service consumes, rather than weakens, C1-C6 exact identity;
2. Product and Project-date authority remain intact;
3. C2 acceptance gates publication without adding a C1 moderation gate;
4. Store copy is preserved while Product commercial evidence refreshes;
5. eligibility, media, inputs, assets and configuration hashing are deterministic;
6. immutable versions are insert-only and retry-safe;
7. Product duplication is deep enough for independent editing and does not copy Catalogue
   membership implicitly;
8. no Store/public/checkout/payment/upload/production/commission calculation/UI behaviour
   leaks into the slice;
9. no migration is required;
10. disposable tests exercise transaction rollback and leave zero residue.

If any missing business decision changes who may configure, accept or publish, stop for
user input. Purely technical implementation choices may be resolved during review.

## 16. Independent Review And Acceptance Outcome

Review result: accepted for bounded implementation on 2026-07-14.

The review confirmed:

- C1-C6 already provide every required persistence invariant, so 1R-D adds no migration;
- current Product values are the first-pass commercial authority because no Project Product
  price/tax override model exists;
- refreshing the existing Project Product snapshots is required before Store resolution,
  including the tax-treatment/price-basis fields omitted by the pre-C1 service;
- Store-owned presentation copy and visibility survive refresh while source commercial,
  eligibility, media and input evidence are re-evaluated;
- the accepted 1Q-E service remains the one Product eligibility authority and prevents
  duplicate Store Products when one Product appears through several Catalogues;
- media tenancy must be checked in application code because legacy `MediaFile` relations do
  not carry the composite tenant key;
- exact code replacement is the only deterministic first-pass input precedence supported by
  the current schema;
- required Project assets and linked presentation assets may block only from explicit C4
  evidence; purchaser Order-line backups remain irrelevant to publication;
- the C1 publish procedure is an operational lifecycle transition after exact C2 acceptance,
  not C1 approval or moderation. It cannot create acceptance and cannot bypass it;
- first publication and commission publication evidence must commit atomically;
- safe Product duplication can use source plus unique target code/slug as its persisted
  natural idempotency identity without a new table;
- no public Store, C2 acceptance, checkout, payment, upload, production, calculation or UI
  behaviour belongs in 1R-D.

No user decision is required to implement this boundary. Acceptance authorises only the
files and validation described above and does not start Store UI, public Store display,
Commerce A3 or another slice.

## 17. Single Bounded Implementation Prompt

```text
Continue only accepted FUND Phase 1 Slice 1R-D. Implement the internal C1 Store
preparation, synchronisation, deterministic configuration-version, readiness and guarded
lifecycle service/router boundary plus safe Product duplication exactly as accepted.

Use the existing 137-migration C1-C6 schema without Prisma or migration changes. Preserve
Store-owned copy and history, refresh Product-authoritative Project Product commercial/tax
evidence, consume 1Q-E eligibility, validate managed media tenancy, resolve inputs by exact
scope precedence, insert immutable canonical hash versions, and require exact current C2-
accepted commission evidence before operational publication. Add no C2 acceptance, public
Store, checkout, payment, upload, production, commission calculation or UI behaviour.

Use only TEST_DATABASE_URL after proving it differs from DATABASE_URL. Complete pure,
service, transaction, rollback, tenant, idempotency, readiness, lifecycle, duplication and
regression checks with the migration inventory unchanged at 137 and zero residue. Then
create separate implementation-confirmation/review records and reconcile the FUND,
Commerce and root controls. Stop before 1R-E, public Store display or COMMERCE-A3.
```

## 18. Completed Lifecycle Outcome

Implementation and independent review completed on 2026-07-14 at application commit
`db85fcc`.

The delivered boundary matches this accepted plan:

- no Prisma model or migration changed; the inventory remains 137 applied and 0 failed;
- Store preparation, synchronisation, readiness, immutable configuration versions and
  guarded lifecycle transitions are tenant-scoped, locked and audited;
- Product commercial/tax authority, Project dates, 1Q-E eligibility and C2 commission
  acceptance remain authoritative;
- safe Product duplication deep-copies accepted media associations, suitability and input
  configuration into an independently editable DRAFT Product with only explicit Catalogue
  membership;
- unchanged refreshes and no-op Product edits do not create false revisions or versions;
- no public Store, C2 acceptance, checkout, payment, upload, production, commission
  calculation or UI behaviour was added.

The disposable PostgreSQL suite proved `TEST_DATABASE_URL` distinct from `DATABASE_URL`,
passed the accepted service/constraint/rollback scenarios and left zero `fund-1rd-*`
residue. See the separate implementation-confirmation and review/test records.
