# FUND Phase 1 Slice 1R-F-B - Individual Artwork Template And Offer-Lock Schema Foundation Planning

Date: 2026-09-01

Status: Restored as portfolio `Now` for strategic user-framework and planning review after
the security expedite closed; bounded draft preserved; no implementation authorised

Control depth: `High` — this future production build concerns persistent schema, tenant
authority, immutable commercial evidence and secure-access evidence.

Work type: planning for a production build. This planning turn creates documentation only;
it does not build or alter the production model.

Authoritative controls:

- `docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`
- `docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`
- `docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-f-project-offer-artwork-readiness-reconciliation-planning.md`
- `docs/modules/fund/03-slice-planning/2026-08-11-fund-phase-1-slice-1r-f-a-real-amow-template-pricing-and-deployed-renderer-proof-planning.md`
- `SAFE_DATABASE_WORKFLOW.md`

## Restart Checkpoint

```text
Current state: 1R-F-B is restored as portfolio Now for strategic user-framework and planning review after PLAT-ASSURE-04 closed; the detailed draft remains unaccepted and does not authorise implementation
Last proven commit: application 0c7e48489aef697c6f39faf1a081456f9f3858a4; 1R-F-A local, Linux, security, physical and disposable external evidence PASS with zero residue; IsoDocs pre-plan baseline e317098
Current environment: application dev/staging/main and origins align at exact production 14077382; PLAT-ASSURE-04 is closed with all gates PASS; no Prisma, database, provider or runtime mutation has been made for 1R-F-B
Next human decision/test: first reconcile the high-level user framework and proportionality, then review, amend or reject the detailed aggregate, field, constraint, migration and Do Not Build boundaries
Safe resumption point: return to this unchanged draft with the root/FUND roadmaps and accepted 1R-F parent; do not edit Prisma or create a migration until the control owner accepts the strategic skeleton and later gives explicit implementation authority
```

## 1. Authorised Outcome And Stopping Point

Plan one additive, tenant-scoped schema foundation for the accepted Individual Artwork
path:

```text
reusable Application Template identity and immutable versions
-> Event / standalone assignment history
-> immutable Project offer versions and exact selected Product rows
-> Project-specific Artwork Template identity and immutable generated versions
-> generation-attempt and secure-grant evidence
```

The stopping point for this turn is an evidence-based plan ready for control-owner review.
No application repository file, database, migration, test database, provider account,
Render service, object store, route, service, UI or deployment may change.

If this plan is later accepted, implementation remains a separate explicit decision. That
future implementation would be a production-model build because it creates persistent
records. It must initially run only against a positively identified disposable database
and must not migrate any shared development, staging or production database without a
separate promotion decision.

## 2. Evidence Used And Decisions Carried Forward

### 2.1 Current application baseline

Direct inspection at exact application `0c7e4848` confirms 153 migration directories and
the existing tenant-scoped identities that 1R-F-B must extend:

- `FundEvent`, `FundClientMember` and `FundProject` own Event, exact organiser and Project
  identity;
- `FundProjectProduct` owns selected Product membership and display order;
- the one-per-Project `FundProjectStore` owns the Store and canonical public identity;
- `FundProjectStoreProduct` owns the exact Store/Project/Project Product/Product junction;
- immutable `FundStoreProductConfigurationVersion` owns the exact commercial and
  presentation configuration snapshot; and
- `FundProductionAsset` remains a separate production-file aggregate and must not be
  reinterpreted as a generated Artwork Template.

1R-F-B adds no replacement Product, Store, price, media, Order, payment, commission or
production-asset authority.

### 2.2 Proven 1R-F-A inputs

The completed High-control assumption test proved the candidate renderer/layout contract
at exact `0c7e4848`, including genuine-source visual/physical review, deployment-equivalent
Linux execution, private object behaviour and resource measurements. For schema planning,
the controlling outputs are:

- A4 portrait `STANDARD` supports a validated ceiling of ten Product rows;
- A4 landscape `COMPACT` supports a validated ceiling of twelve Product rows;
- every selected Project Product consumes exactly one printable row;
- the minimum finalised Individual Artwork offer contains one selected Product;
- Product order, exact gross displayed price, Project/Client content, branding, canonical
  Store URL/QR and the renderer/layout contract must be pinned at finalisation; and
- the proof was temporary assumption testing, not production storage, credentials,
  infrastructure or a persistent model.

Ten and twelve are evidence-backed ceilings for those two exact proven variants. They are
not global defaults and do not authorise a future version with another layout to claim the
same capacity without its own validation evidence.

### 2.3 Accepted business authority

The accepted parent requires three separate aggregates:

| Aggregate | Meaning |
| --- | --- |
| Application Template / Version | Reusable C1-owned A4 design and immutable layout/capacity contract |
| Artwork Template / Version | Generated, immutable, Project-specific Individual Artwork document finalised by the exact C2 organiser |
| Collective Project Artwork / Version | A later Group/Bulk aggregate outside 1R-F-B |

Pre-finalisation assignment follows a stable Application Template identity, not a mutable
or preselected version:

- an Event-linked Project follows its Event assignment and has no Project override;
- a standalone Project uses its exact Project assignment when present, otherwise the
  tenant's standalone default; and
- finalisation pins the exact Application Template Version then current, so later template
  changes cannot rewrite a historic offer or Artwork Template.

An offer may be finalised before Store publication. Finalisation does not publish the
Store, authorise checkout, prove payment or authorise production.

## 3. Bounded Schema Vocabulary

Add only the following enums:

```text
FundApplicationTemplateVersionStatus
- DRAFT
- ACTIVE
- ARCHIVED

FundApplicationTemplateOrientation
- PORTRAIT
- LANDSCAPE

FundApplicationTemplateRowDensity
- STANDARD
- COMPACT

FundApplicationTemplateAssignmentScope
- EVENT
- STANDALONE_DEFAULT
- STANDALONE_PROJECT

FundArtworkTemplateGenerationAttemptStatus
- REQUESTED
- RUNNING
- SUCCEEDED
- FAILED
- CANCELLED

FundArtworkTemplateGrantIssuerType
- C1_TENANT_USER
- SYSTEM
```

Do not encode Project type, Workflow Class, Store, Order, payment or delivery states again
inside these enums. Those remain owned by their existing aggregates.

## 4. Planned Models And Contracts

Common rules for every planned table:

- expose a unique `(organizationId, id)` key and include `organizationId` in every domain
  foreign key, including references to public-schema `User`;
- use restrictive deletion for version, assignment, offer, Store/Product, attempt, grant
  and actor evidence; tenant deletion remains governed by the existing Organization
  lifecycle rather than a new FUND shortcut;
- use explicit named foreign keys, checks, unique indexes and operational lookup indexes;
- keep metadata out unless a named bounded contract genuinely requires it; and
- follow the current FUND tenant-security posture without widening database roles or
  bypassing application tenant filters. Any future row-level-security change requires its
  own explicit review rather than being inferred here.

### 4.1 `FundApplicationTemplate`

Stable tenant-owned reusable template identity:

```text
id, organizationId, code, name, description?
currentVersionId?
archivedAt?, archivedById?, archivedReason?
createdById, updatedById, createdAt, updatedAt
```

Required constraints:

- unique `(organizationId, id)` and `(organizationId, code)`;
- nonblank code/name and nonblank archive reason when archived;
- current-version pointer may reference only a version of this same tenant and template;
- no hard delete after a version, assignment or offer lock refers to the identity; and
- actor relations use exact `(organizationId, User.id)` ownership.

The stable identity does not contain layout JSON or capacity. Those belong to a version.

### 4.2 `FundApplicationTemplateVersion`

Versioned design and validation contract:

```text
id, organizationId, applicationTemplateId, version, status
orientation, rowDensity
pageWidthMm, pageHeightMm
safePrintTopMm, safePrintRightMm, safePrintBottomMm, safePrintLeftMm
validatedGridCapacity, maximumSelectedProjectProducts
definitionSchemaVersion, definitionSnapshot, definitionHash
rendererContractVersion, rendererContractHash, fontPackHash
validatedAt, validationEvidenceId
activatedAt?, activatedById?, archivedAt?, archivedById?, archivedReason?
createdById, createdAt
```

Required constraints:

- unique `(organizationId, applicationTemplateId, version)` with positive version;
- positive A4 dimensions and nonnegative safe-print insets that leave a positive content
  area;
- `validatedGridCapacity >= 1` and
  `1 <= maximumSelectedProjectProducts <= validatedGridCapacity`;
- supported initial proof pairs are `PORTRAIT/STANDARD <= 10` and
  `LANDSCAPE/COMPACT <= 12`; a different pair/capacity requires separately accepted proof,
  not a silent schema entry;
- definition snapshot must be a JSON object governed by a positive schema version;
- definition, renderer and font hashes are lowercase SHA-256 values;
- validation evidence is a bounded internal lifecycle/commit identifier, not a URL,
  filesystem path or provider object key;
- the declarative definition may identify controlled layout elements and stored media
  identities, but never executable HTML/JavaScript, arbitrary CSS, filesystem paths,
  database connection strings, provider credentials or externally fetched runtime assets;
- only one `ACTIVE` version per template, enforced by a partial unique index;
- activation requires validation evidence, timestamps and exact tenant actor;
- substantive fields become immutable on activation; only the accepted archive lifecycle
  fields may then change; and
- current-pointer selection and activation occur in one transaction and must point to the
  same template's `ACTIVE` version.

No migration seeds an AMOW template. Creating and validating a real tenant template is
later C1 lifecycle work under `1R-F-C`.

### 4.3 `FundApplicationTemplateAssignment`

Append-only assignment history with one active assignment per applicable scope:

```text
id, organizationId, scope
applicationTemplateId
eventId?, projectId?
assignedAt, assignedById
retiredAt?, retiredById?, retiredReason?
createdAt
```

Required database shape checks:

```text
EVENT              -> eventId present, projectId absent
STANDALONE_DEFAULT -> eventId absent,  projectId absent
STANDALONE_PROJECT -> eventId absent,  projectId present
```

Required constraints and indexes:

- template, Event, Project and actor references are tenant-exact;
- partial unique indexes allow only one unretired Event assignment per Event, one unretired
  standalone default per tenant and one unretired Project assignment per Project;
- retired evidence is complete and its reason is nonblank;
- history cannot be hard deleted; and
- later `1R-F-C` services must reject a Project assignment unless `eventId IS NULL` and
  must reject standalone resolution for an Event-linked Project. The database cannot infer
  this changing Project fact through a row-local check.

Assignments point to template identity so a Project follows the identity's active version
until finalisation. They never point directly to a draft version.

### 4.4 `FundIndividualArtworkOffer`

Stable one-per-Project Individual Artwork offer identity:

```text
id, organizationId, projectId
currentVersionId?
createdById, createdAt
```

Required constraints:

- unique `(organizationId, projectId)`;
- exact tenant Project relation;
- current pointer may select only a version of this same offer and Project; and
- later services create/use it only for `ARTWORK_FUNDRAISING`; schema presence alone does
  not change Project type or make a Project ready.

### 4.5 `FundIndividualArtworkOfferVersion`

Append-only finalisation/lock record:

```text
id, organizationId, offerId, projectId, storeId, version
applicationTemplateVersionId
supersedesVersionId?
selectedProductCount
canonicalStoreUrlSnapshot
projectContentSchemaVersion, projectContentSnapshot
brandingSchemaVersion, brandingSnapshot
rendererInputSchemaVersion, rendererInputSnapshot
offerLockHash
finalisedByClientMemberId, clientId, finalisedAt, createdAt
```

Required constraints:

- unique `(organizationId, offerId, version)` with positive version;
- offer, Project and Store form one exact tenant/Project chain;
- finalising member belongs to the Project's exact Client; later `1R-F-D` additionally
  proves that member is the Project's current exact organiser and is active/authorised;
- Application Template Version is the exact active version resolved through accepted
  assignment authority at the start of the finalisation transaction;
- `selectedProductCount >= 1` and does not exceed that template version's configured
  maximum, enforced transactionally by `1R-F-D` because it crosses rows;
- snapshot JSON values are objects with positive schema versions;
- canonical URL is nonblank, normalised and derived from the Store's existing public
  identity by the later service, never accepted as arbitrary user input;
- `offerLockHash` is lowercase SHA-256 over the canonical complete lock payload;
- supersession points only to an older version of the same offer; and
- finalised rows are append-only and cannot be updated or deleted through ordinary
  application authority.

This record pins resolved display/branding/renderer input but does not duplicate mutable
Store or configuration rows. The foreign-keyed Product rows below retain exact source
lineage.

### 4.6 `FundIndividualArtworkOfferProduct`

One printable Product row in one exact offer version:

```text
id, organizationId, offerVersionId
storeProductId, projectProductId, productId
configurationVersionId
sortOrder
displayLabelSnapshot
grossUnitPriceSnapshot, currencySnapshot
createdAt
```

Required constraints:

- exact tenant relations prove that Store Product belongs to the offer's Store/Project and
  the immutable configuration version belongs to that exact Store Product;
- unique Product membership and unique `sortOrder` within an offer version;
- nonnegative contiguous ordering is enforced by the finalisation service;
- nonblank label, nonnegative gross price and ISO three-letter uppercase currency;
- row count equals the parent `selectedProductCount` and respects the pinned template
  capacity in the same finalisation transaction; and
- rows are append-only with their parent version.

The gross amount is the exact purchaser-facing printable amount resolved from the pinned
configuration. This does not replace the configuration's net/VAT/basis authority and does
not create Order or payment evidence.

### 4.7 `FundArtworkTemplate`

Stable Project-specific generated-document identity:

```text
id, organizationId, offerId, projectId
currentVersionId?
createdAt
```

Required constraints:

- unique `(organizationId, offerId)` and `(organizationId, projectId)`;
- exact tenant offer/Project chain; and
- current pointer may select only a generated version of this same Artwork Template and
  Project.

This aggregate is not `FundProductionAsset` and its presence does not imply that a PDF was
stored or delivered.

### 4.8 `FundArtworkTemplateGenerationAttempt`

Append-only request identity with tightly controlled execution-state adjudication:

```text
id, organizationId, artworkTemplateId, offerVersionId, attemptNumber
idempotencyKey, requestHash, status
requestedByClientMemberId, requestedAt
startedAt?, finishedAt?
failureCode?, redactedFailureSummary?
createdAt, adjudicationUpdatedAt
```

Required constraints:

- exact tenant Artwork Template, offer version and requesting Client member lineage;
- unique `(organizationId, artworkTemplateId, attemptNumber)` and tenant-scoped
  `idempotencyKey`;
- positive attempt number, bounded idempotency key and lowercase SHA-256 request hash;
- `REQUESTED`, `RUNNING` and terminal timestamp shapes are database checked;
- `FAILED` requires a bounded nonblank code and redacted summary, while success cannot
  retain failure detail;
- ordinary updates may change only the accepted state/timestamp/failure adjudication
  fields; request identity and hashes are immutable; and
- no Render job, object-store key, provider request, credential or machine identity is
  stored here.

`1R-F-E` later owns the worker, retry policy, concurrency and operational implementation.

### 4.9 `FundArtworkTemplateVersion`

Immutable evidence for one successful generated document:

```text
id, organizationId, artworkTemplateId, offerVersionId, generationAttemptId, version
pdfSha256, byteSize, pageCount
pageWidthMm, pageHeightMm
rendererContractHash, generatedAt, createdAt
```

Required constraints:

- unique `(organizationId, artworkTemplateId, version)` with positive version;
- one generation attempt can create at most one version and must belong to the same
  Artwork Template/offer version;
- later service permits creation only from a `SUCCEEDED` attempt;
- PDF hash and renderer hash are lowercase SHA-256, byte size/page count are positive and
  physical dimensions match the pinned A4 contract; and
- generated version rows are append-only and cannot be hard deleted through ordinary
  application authority.

No provider/object location is included. `1R-F-E` must separately plan private managed
storage, checksum-to-object binding, retention, deletion and recovery before a generated
version can be operationally delivered.

### 4.10 `FundArtworkTemplateAccessGrant`

Revocable, expiring evidence that targets one exact generated version and organiser:

```text
id, organizationId, artworkTemplateVersionId
clientId, recipientClientMemberId
tokenDigest
issuerType, issuedByUserId?, issuedAt, expiresAt
revokedAt?, revokedByUserId?, revocationReason?
createdAt, adjudicationUpdatedAt
```

Required constraints:

- exact tenant Artwork Template Version, Client member and optional User actors;
- globally unique lowercase SHA-256 token digest for lookup without tenant ambiguity;
- raw bearer token is never stored, logged, committed or placed in lifecycle evidence;
- `C1_TENANT_USER` requires an exact tenant issuer; `SYSTEM` requires no issuer User;
- expiry is after issue; revocation fields are all absent or complete with a nonblank
  reason; and
- grant identity, recipient, version and digest are immutable; only revocation
  adjudication may change.

This is schema support, not a working link. `1R-F-E` owns token entropy, fixed-time digest
comparison, expiry/reissue policy, authorised download, access logging, email/resend,
retention and rate limiting. No public bucket or permanent object URL is authorised.

## 5. Transaction, Immutability And Authority Boundaries

Later service implementation must use bounded transactions for:

1. retiring and replacing one active assignment;
2. activating a validated Application Template Version and changing its same-template
   current pointer;
3. resolving Event/standalone assignment, current version, exact organiser, Store,
   selected Product rows and configuration versions, then inserting the complete offer
   version/Product lock and changing its current pointer atomically; and
4. recording a successful attempt, immutable Artwork Template Version and same-template
   current pointer without duplicate output.

Optimistic checks must fail closed when any resolved Project, assignment, template, Store,
Product configuration or organiser authority changes during finalisation. A retry must
re-resolve authority; it must not silently reuse stale input.

Unlock behaviour is deliberately not modelled as a mutable `locked` boolean. `1R-F-D`
must plan the exact append-only unlock decision evidence after it can bind the accepted
rules for Store publication/trading, paid Orders and recorded physical distribution. A
permitted unlock creates a full superseding offer version after refinalisation; it never
edits historic offer/Product/Artwork versions or Commerce Order evidence.

## 6. Migration Plan If Separately Authorised

The implementation candidate is one additive migration after the current 153-directory
baseline, provided preflight still proves that exact baseline. If another migration lands
first, the implementer must refresh the baseline and migration identifier rather than
assuming ordinal 154.

Required sequence under `SAFE_DATABASE_WORKFLOW.md`:

1. identify repository, branch, exact commit and dirty state; preserve unrelated changes;
2. prove `TEST_DATABASE_URL` exists and is not equal to `DATABASE_URL`, and positively
   identify the disposable target before any reset/drop/rollback action;
3. inspect migration ledger and failed-migration state;
4. add Prisma enums/models/reverse relations and one reviewed SQL migration;
5. add named checks, partial unique indexes, exact tenant foreign keys and narrowly scoped
   immutability triggers that Prisma cannot express;
6. run static schema/migration contract verification;
7. run representative existing-data 153-to-candidate migration proof, preserving exact
   pre-existing row counts and values;
8. run a full fresh migration replay and all negative/concurrency/rollback tests;
9. remove test fixtures and prove zero residue; and
10. stop with no shared database migration, deployment or promotion.

The migration must not backfill, reinterpret or update an existing FUND, Commerce, public
or other-module row. New tables begin empty. Reverse relations and supporting composite
keys may be added only where an exact foreign key requires them and may not alter owning
aggregate behaviour.

## 7. High-Control Validation Contract

### 7.1 Static and migration checks

- `prisma format`, `prisma validate`, client generation, TypeScript validation and the
  production build pass;
- a dedicated 1R-F-B schema verifier asserts the exact model/table/enum/constraint set and
  rejects forbidden provider, Order/payment, production and public-link fields;
- the migration contains only the reviewed additive FUND scope and necessary reverse
  relations/supporting keys;
- both representative upgrade and full fresh replay finish with a clean migration ledger;
  and
- rollback-before-evidence is proved on a disposable database only.

### 7.2 Required positive proofs

- create both proven template-version variants with maximums at their accepted ceilings;
- activate one version and select it through Event, standalone-default and exact
  standalone-Project assignment resolution fixtures;
- create a ten-row portrait and twelve-row landscape offer lock from exact Store Product
  configuration versions;
- create a generation attempt, successful immutable document version and expiring grant
  to the exact organiser; and
- prove historic version and Product lineage remains readable after a new template/offer/
  artwork version becomes current.

### 7.3 Required negative and failure proofs

- reject cross-tenant template, Event, Project, Store, Product, member and User references;
- reject invalid polymorphic assignment shapes, two active assignments for one scope and a
  direct assignment to a version;
- reject zero capacity, maximum above validated capacity, unsupported unproved variant,
  malformed/non-object JSON and malformed hashes;
- reject a current pointer to another aggregate, simultaneous duplicate version numbers
  and two active versions;
- reject empty offer, over-capacity offer, duplicate/missing Product order, cross-Project
  Store Product and configuration version from another Store Product;
- reject a non-organiser/inactive/wrong-Client finaliser through later service proof;
- reject ordinary update/delete of activated template contract, offer version/Product and
  Artwork Template Version;
- reject duplicate generation idempotency, illegal status/timestamp transitions,
  unredacted or overlong failure evidence and version creation from a non-success attempt;
- reject plaintext/malformed/duplicate grant token material, wrong-member version access,
  expired/revoked grants and incomplete revoke evidence; and
- inject a transaction failure before each current-pointer change and prove no partial
  assignment, offer/Product lock, attempt/version or grant residue.

### 7.4 Existing behaviour and human gates

Focused schema tests must be followed by the relevant existing FUND Store, readiness,
Commerce A7, full automated, lint, type, migration-integrity and build gates. The migration
must not change existing Store readiness or Order behaviour.

There is no end-user UI in 1R-F-B, so no C1/C2 browser acceptance is claimed. Human gates
are:

1. control-owner review/acceptance of this plan before implementation;
2. later review of the exact Prisma/migration diff, table meanings and rollback report;
   and
3. separate human UI/physical acceptance in the owning C/D/E children when behaviour is
   actually introduced.

## 8. Recovery, Redundancy And Operational Ownership

The future records are ordinary tenant-scoped production database records protected by the
application database backup/recovery model, not by a developer's Mac, Keychain or a
temporary external test resource. Git retains schema/migration/application definitions;
database backups retain production data. Neither is a substitute for the other.

Operational owner: FUND application/C1 domain for template and offer authority. There is
no worker or provider owner in this slice. `1R-F-E` must name the operational owner,
credential custody, private storage, backup/recovery and observability model before any
generated file delivery exists.

Rollback boundary:

- before shared use and while candidate tables are empty, the disposable migration may be
  rolled back and replayed;
- after persistent records exist, do not drop or rewrite the tables as routine rollback;
  stop writes, preserve evidence, restore from verified database backup if required and
  use a reviewed forward correction; and
- no production rollback, restore or provider action is authorised by this plan.

## 9. Do Not Build

This plan and any later narrowly accepted schema implementation exclude:

- C1 template CRUD, activation editor, visual editor or assignment UI (`1R-F-C`);
- C2 selection, preview, finalisation, unlock or readiness behaviour (`1R-F-D`);
- renderer worker, queue/cron, retry runtime, Render service or recurring service cost;
- R2/S3 bucket, object key, credentials, signed URL, public-development URL or production
  storage contract (`1R-F-E`);
- organiser email, resend, download route, link policy, access log, retention/deletion or
  physical distribution confirmation (`1R-F-E`);
- Store publication/trading, checkout, Order, payment, refund, production authority,
  commission or Store Order Code behaviour;
- Product option/price-modifier display policy not yet accepted by its owning later slice;
- collective Group/Bulk artwork, Standard path or `1R-F-F` through `1R-F-I`;
- public Store `1R-G`, production/fulfilment work or any other roadmap outcome; and
- shared development, staging or production migration/deployment/promotion.

## 10. Planning Acceptance Gate And Subsequent Decision

This draft is ready for control-owner review when it truthfully demonstrates:

1. exact reuse of current tenant/Project/Store/Product configuration authority;
2. separate reusable template, offer lock and generated-document aggregates;
3. exact version/current-pointer, assignment, finaliser and Product lineage;
4. secure-grant evidence without plaintext secret or storage/provider invention;
5. High-depth failure, negative, rollback and concurrency boundaries;
6. a safe 153-to-candidate disposable migration route; and
7. explicit exclusion of all C/D/E behaviour and production infrastructure.

Acceptance of the plan would permit selection of a separate bounded 1R-F-B schema
implementation decision; it would not itself authorise that implementation. Root `Next`
therefore remains unselected while this draft is under review.
