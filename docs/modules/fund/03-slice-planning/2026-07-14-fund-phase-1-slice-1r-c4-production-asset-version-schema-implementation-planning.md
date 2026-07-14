# FUND Phase 1 Slice 1R-C4 - Production Asset Version Schema Implementation Planning

Date: 2026-07-14

Status: Accepted, implemented and reviewed as passed on disposable PostgreSQL 2026-07-14 / uncommitted / no shared deployment

Parent plan:

`docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c-fund-store-input-schema-foundation-planning.md`

Preceding completed slices: `1R-C1`, `1R-C2` and `1R-C3`.

## 1. Goal

Define one bounded additive FUND schema migration for logical production assets,
append-only file-version identity, immutable file snapshots, Project asset context and
same-Project Store Product asset context.

This plan does not authorise implementation or create Prisma, migration, service, API,
storage, route or UI changes.

## 2. Hard Boundary

Plan only:

```text
FundProductionAsset
FundProductionAssetVersion
FundProjectAssetLink
FundStoreProductAssetLink
```

The minimum supporting composite keys, enums, checks and indexes are included. Exclude:

- upload/download, signed-URL, object-storage and malware-scanning services;
- file-selection, removal-before-upload and artwork-review UI;
- production collation, notification and handoff behaviour;
- Commerce Order-line asset relations and guest-checkout upload behaviour; the public
  backup-photo purpose/uploader contract may be reserved here but its Order-line link waits
  for Commerce and the later typed FUND extension;
- Store readiness/publication behaviour and Project Intake alignment;
- Commerce checkout, Orders, Order lines, payments, Stripe, refunds and pro-forma records;
- commission, `1R-C5`, `1R-C6`, `COMMERCE-A2` and every other slice.

## 3. Current Evidence And Managed Storage Contract

The implemented C1-C3 schema provides tenant-scoped `FundProject` and
`FundProjectStoreProduct` identity and the accepted same-owner current-version pattern.
Shared `MediaFile` represents a file uploaded into IsoStack-managed storage.

Important limitations and rules:

- `MediaFile` has `organizationId` but no composite `(organizationId, id)` relation key;
- `MediaFile.fileUrl` is generated infrastructure metadata, not a user-authored asset URL;
- FUND production rows reference `MediaFile.id` and never accept or copy an external URL;
- versions snapshot original filename, detected MIME type, byte size and SHA-256 checksum;
- a later service must validate `MediaFile` tenant ownership, prevent binary replacement
  and verify checksums where required;
- executable/script prevention requires inspected content and an allowlist later, not a
  database filename or MIME check.

No existing Product, media, Project, Store, Store Product, configuration version, input,
branding, delivery or Event value may be changed or reinterpreted.

## 4. Logical Asset, Version And Multi-File Contract

`FundProductionAsset` is the stable identity for one evolving production file.
`FundProductionAssetVersion` is one uploaded or C1-produced revision:

```text
logical asset
  -> version 1 -> MediaFile A + file evidence snapshots
  -> version 2 -> MediaFile B + file evidence snapshots
  -> currentVersionId -> version 2
```

One logical asset is one file lineage, not a bag of files. A multi-file selection creates
multiple logical assets and links in one later controlled operation. Each file therefore
has independent version, scan, review, retention and restriction evidence. No file-ID
array or opaque multi-file JSON is planned.

File identity, upload provenance and snapshot columns are append-only. Scan, retention,
restriction and tombstone adjudication may transition asynchronously. Later services must
prevent file-evidence mutation and unauthorised hard deletion; Prisma alone must not be
described as making an entire row physically immutable.

### 4.1 Two Distinct Upload Routes

The schema vocabulary must preserve two different uploader routes without implementing
either upload workflow:

1. A public purchaser may upload a photograph during guest checkout. No IsoStack account or
   `User` row is required. The photograph is a backup in case the physical original artwork
   is lost while returning through the Project organiser to C1.
2. An authenticated C2 Project organiser may upload Project-scoped source artwork, logos,
   text/name files and bulk personalisation data. C1 may inspect those files and create a
   separate composite or Store Product presentation asset.

An authenticated C1 user may also create or upload the C1 composite/presentation asset. A
C1 composite is normally a distinct logical asset from the C2 source asset, not a new
version that erases their different purposes and provenance.

Route 2 uses `FundProjectAssetLink` and, where relevant,
`FundStoreProductAssetLink` in this foundation. Route 1 reuses the logical asset/version
foundation but its typed Commerce Order-line link waits for Commerce Order lines and the
later FUND Commerce-context slice. No purchaser identity, Order ID or Order-line ID is
added to the C4 models.

### 4.2 Backup Evidence And Production Authority

The public purchaser photograph is a conditional production backstop. Normal production is
expected to use the physical original artwork after it has travelled through the organiser
to C1 and been manually checked against the paid Order. If the original is lost or cannot
be recovered, C1 may explicitly authorise production from the backup photograph so the
paid purchaser's Order can still be fulfilled.

The following concepts are deliberately separate:

- asset/version presence and malware state;
- Project/C1 artwork review;
- Commerce-owned Order/payment state;
- physical-original receipt and manual check;
- final production authorisation.

The mere presence of a C4 asset, `CLEAN` scan, artwork `APPROVED` state or backup photograph
does not authorise production. A later typed FUND Order/Order-line production extension
must combine the authoritative Commerce payment/order state with physical-artwork
receipt/check evidence, required inputs and an explicit C1 production-authorisation
decision. That decision may select the backup photograph as the production source when the
physical original has been recorded as lost or unavailable.

Payment remains Commerce-owned and must not be copied into a competing mutable FUND payment
status. Physical-artwork presence is operational FUND evidence, not a digital asset
version. Exceptions—missing/damaged originals or any decision to produce from the backup
photograph—must be a later explicit override that records actor, reason, timestamp and the
selected production source. Exact receipt, hold, exception and authorisation states belong
to later production workflow/UI planning.

## 5. Enum Naming And Values

Follow `Fund<OwningAggregate><Meaning>`:

```text
FundProductionAssetPurpose
- ORDER_LINE_ARTWORK_BACKUP
- PROJECT_SOURCE_ARTWORK
- C1_COMPOSITE_ARTWORK
- STORE_PRODUCT_PRESENTATION
- BULK_PERSONALISATION_DATA
- PRODUCTION_REFERENCE
- OTHER

FundProductionAssetArtworkReviewStatus
- NOT_REQUIRED
- AWAITING_UPLOAD
- SUBMITTED
- UNDER_REVIEW
- CHANGES_REQUIRED
- APPROVED

FundProductionAssetVersionMalwareScanStatus
- PENDING
- CLEAN
- INFECTED
- SCAN_FAILED

FundProductionAssetVersionRetentionCategory
- STANDARD
- PRODUCTION_EVIDENCE
- LEGAL_HOLD

FundProductionAssetVersionUploaderType
- PUBLIC_PURCHASER
- C2_PROJECT_ORGANISER
- C1_TENANT_USER
- SYSTEM_IMPORT

FundProjectAssetRole
- SOURCE_ARTWORK
- COMPOSITE_ARTWORK
- BULK_PERSONALISATION_DATA
- PRODUCTION_REFERENCE

FundStoreProductAssetRole
- PRESENTATION_ARTWORK
- PRODUCTION_ARTWORK
- PERSONALISATION_DATA
- PRODUCTION_REFERENCE
```

Purpose describes the logical asset; link role describes its contextual use.
`AWAITING_UPLOAD` belongs to the logical asset because no version exists. Malware state
belongs to the exact version. Uploader type records the actor category without implying
authentication. Artwork review, Store readiness and production authorisation remain
separate.

## 6. Planned Models

### 6.1 `FundProductionAsset`

Fields:

```text
id, organizationId, purpose, name, description?
currentVersionId?
artworkReviewStatus, artworkReviewVersionId?
artworkReviewedByUserId?, artworkReviewedAt?, artworkReviewNotes?
archivedAt?, archivedById?, archivedReason?
createdById?, updatedById?, createdAt, updatedAt, metadata
```

Constraints:

- unique `(organizationId, id)` and nonblank name;
- current/review pointers each select a version of this same tenant and asset;
- if both pointers exist they are equal, preventing stale approval of a replaced file;
- `AWAITING_UPLOAD` has no current/review version or completed review evidence;
- `SUBMITTED`/`UNDER_REVIEW` require a current/review version but no completed decision;
- `CHANGES_REQUIRED`/`APPROVED` require version, reviewer ID and review timestamp;
- `NOT_REQUIRED` requires a current/review version but no reviewer decision;
- notes/reasons are nonblank when present.

Actor IDs remain audit scalars rather than User foreign keys. This retains historic IDs
after User deletion and avoids a false same-tenant database guarantee. Later services must
validate actor tenant and reset review to `SUBMITTED` when a new current version is chosen.

### 6.2 `FundProductionAssetVersion`

Fields:

```text
id, organizationId, assetId, version, mediaFileId
originalFileNameSnapshot, detectedMimeTypeSnapshot
byteSizeSnapshot, sha256ChecksumSnapshot
uploaderType, uploadedByUserId?, uploadedAt
malwareScanStatus, malwareScannerName?, malwareScannerVersion?
malwareScanResult?, malwareScannedAt?
retentionCategory, retainUntil?
restrictedAt?, restrictedById?, restrictedReason?
deletedAt?, deletedById?, deletionReason?
createdAt, adjudicationUpdatedAt
```

Constraints:

- unique `(organizationId, assetId, version)` with positive version;
- tenant-scoped asset relation and required restrictive `MediaFile.id` relation;
- positive byte size, nonblank filename/MIME and 64-character lowercase SHA-256;
- scan-result JSON, when present, is an object;
- `PENDING` has no scanner identity, result or timestamp;
- every terminal state requires a scan timestamp and nonblank scanner name;
- `INFECTED` and `SCAN_FAILED` additionally require an object result recording the finding
  or failure evidence; `CLEAN` may retain an optional object result;
- `PUBLIC_PURCHASER` and `SYSTEM_IMPORT` require no `uploadedByUserId`;
- `C2_PROJECT_ORGANISER` and `C1_TENANT_USER` require an `uploadedByUserId`, with tenant,
  Project role and C1/C2 authority validated by the later service;
- public purchaser identity/contact remains a Commerce purchaser/Order snapshot and is not
  copied as PII into this version row;
- only a `CLEAN` version may become current, enforced by the later service because a
  declarative cross-row check cannot prove it;
- restriction/deletion reasons are nonblank when present;
- restriction actor/reason evidence cannot exist without `restrictedAt`, and a restriction
  timestamp requires a reason;
- deletion actor/reason evidence cannot exist without `deletedAt`, and a deletion timestamp
  requires a reason;
- `deletedAt` is a tombstone, not physical `MediaFile` or object deletion;
- `LEGAL_HOLD` requires `retainUntil` to remain null; release from hold and any later purge
  require an explicit later service decision.

The database rejects unknown media IDs but cannot reject a known cross-tenant media ID.
The later write service must query `MediaFile` by both ID and organization before insert.
This slice does not modify the shared public media contract.

### 6.3 `FundProjectAssetLink`

Fields:

```text
id, organizationId, projectId, assetId, role
label?, sortOrder, isRequired, createdById?, createdAt
```

Project and asset relations use composite tenant keys. One asset links once to a Project,
while many distinct assets may share a role. This is the multi-file contract. Sort order is
nonnegative and a present label is nonblank. `isRequired` is configuration evidence only.

Add composite identity `(organizationId, id, projectId, assetId)` for downstream exact
source proof. Project deletion cascades contextual links only; asset deletion is restricted
while versions or Project links remain.

### 6.4 `FundStoreProductAssetLink`

Fields:

```text
id, organizationId, projectId, storeProductId
projectAssetLinkId, assetId, role
label?, sortOrder, isPrimary, createdById?, createdAt
```

Every Store Product asset must first be linked to the Store Product's own Project. Add only
the supporting `FundProjectStoreProduct (organizationId, id, projectId)` unique key.
Composite relations must prove:

- tenant, Store Product and Project match;
- Project link, Project and asset match;
- redundant asset IDs cannot substitute another asset.

One asset links once to a Store Product; several distinct assets may share a role. A partial
unique index permits at most one primary asset per Store Product and role. Deleting the
Store Product or Project source link cascades this contextual link only.

## 7. Deletion And Retention Direction

| Parent | Child/reference | Action |
| --- | --- | --- |
| Organization | all C4 rows | `Cascade` |
| Production Asset | Version | `NoAction` |
| MediaFile | Version | `Restrict` |
| Version | current/review pointer | `NoAction` |
| Project | Project Asset Link | `Cascade` |
| Production Asset | Project Asset Link | `NoAction` |
| Store Product | Store Product Asset Link | `Cascade` |
| Project Asset Link | Store Product Asset Link | `Cascade` |
| Production Asset | Store Product Asset Link | `NoAction` |

Normal behaviour archives, restricts or tombstones evidence. Database relations protect
referenced rows, while append-only and purge policy remain later service/permission work.

## 8. Required Indexes And Checks

Require:

- tenant ID uniques on all four models;
- unique asset/version, Project/asset and Store Product/asset identities;
- same-asset current/review keys and exact Project-link source identity;
- partial unique primary Store Product asset per role;
- Project/role/sort, Store Product/role/sort, asset/version and scan/retention indexes;
- positive version/byte-size and nonnegative sort checks;
- lowercase SHA-256, nonblank text and JSON-object checks;
- coherent artwork-review, scan, restriction and deletion evidence checks;
- coherent uploader-type/User-ID checks.

No database check may infer safety from MIME type or extension alone.

## 9. Migration And Zero-Backfill Plan

One additive migration must:

1. create the C4 enums;
2. add the supporting Store Product tenant/ID/Project key;
3. create the four tables without cyclic current/review foreign keys;
4. add indexes and checks;
5. add Organization, asset, MediaFile, Project, Store Product and Project-link keys;
6. add current/review composite foreign keys last.

Backfill rule:

```text
Create no C4 row by migration.
Change no existing MediaFile, Project, Store Product or configuration-version value.
```

Existing Product/Event/branding/presentation media is configuration media, not production
evidence, and must not be silently converted.

## 10. Disposable-Database Validation

Use only `TEST_DATABASE_URL` after proving it differs from `DATABASE_URL`. Require:

- Prisma format, multi-schema validation, generation and a dedicated static verifier;
- A1/C1/C2/C3 regression verifiers;
- representative existing-data migration with unchanged counts/values;
- complete fresh migration replay and zero C4 rows after migration;
- valid empty asset, version/current pointer and same-Project links;
- rejection of duplicates, unknown IDs, cross-tenant relations, cross-Project Store Product
  links, other-asset current/review pointers and duplicate primary roles;
- proof that multiple distinct files link to one Project/Store Product;
- proof that a public backup asset/version can carry `PUBLIC_PURCHASER` with no User ID
  without creating a Commerce Order-line relation;
- proof that C1/C2 uploader types require a User ID while public/system types reject one;
- rejection of invalid versions, sizes, sort values, blank text, checksum and state evidence;
- planned deletion/restriction behaviour, Organization teardown and zero fixture residue;
- an honest record of the MediaFile tenant limitation.

The review must not claim that schema tests upload, scan or inspect files, make storage
objects immutable, or perform runtime actor/media tenant validation.

The review must also confirm that no C4 field or state represents payment confirmation,
physical-original receipt/check or production authorisation.

## 11. Rollback And Failure Policy

Before shared deployment, rollback may be tested only on the disposable database by
dropping pointer constraints, C4 tables, the supporting key when unused and C4 enums in
reverse order. Once shared evidence exists, use a reviewed forward migration; never drop
production evidence to simulate rollback.

## 12. Expected Files After Acceptance

Only an accepted implementation may change `prisma/schema.prisma`, one bounded migration,
C4 verification scripts, separate confirmation/review records and roadmap/README lifecycle
references. No service, API, storage, UI, Project Intake or Commerce file is in scope.

## 13. Acceptance Criteria

Review must confirm the four models remain FUND-owned; logical and version identity are
separate; file evidence has an honest immutability boundary; multi-file uses multiple
assets; Store Product assets anchor to their own Project; managed media introduces no
user-authored URL; media/actor tenant limitations are explicit; scan, artwork review and
Store readiness remain distinct; the public purchaser photograph is a conditional
production backstop rather than an automatically selected source; C2 Project uploads and
the normally preferred physical artwork remain distinguishable; Commerce remains
authoritative for payment; no C4 state alone authorises production; tombstones do not claim
physical deletion; no existing media is backfilled; and migration/validation coverage is
complete.

There are no unresolved business questions required to review this bounded direction.
Acceptance must still be explicit and precede implementation.

## 14. Review And Acceptance Outcome

Review result: accepted for bounded implementation planning on 2026-07-14.

The review confirmed:

- all four models are FUND-owned and require no Commerce relation in C4;
- `FundProductionAsset` is stable logical identity and each version represents one exact
  managed file revision;
- multiple uploaded files create multiple assets rather than an opaque array or JSON bag;
- current and artwork-review pointers use the C3 composite same-owner pattern and cannot
  select a version belonging to another asset;
- moving current artwork-review state to the logical asset resolves the parent foundation's
  mutable-review/immutable-version tension while `artworkReviewVersionId` pins the state and
  reviewer evidence to the exact reviewed version;
- file identity, snapshot and upload-provenance columns are append-only service contracts,
  while malware, retention, restriction and tombstone adjudication may transition;
- the database can enforce state-shape checks but cannot enforce append-only column
  behaviour, `CLEAN` current-version selection, User role/tenant authority, `MediaFile`
  tenant matching, object immutability or legal-hold release workflow; these remain explicit
  later service/permission gates;
- the public purchaser photograph is a conditional production backstop with no C4
  Order-line relation, purchaser PII or automatic production authority;
- C2 Project source assets and C1 composite/presentation assets retain separate purposes and
  provenance;
- Store Product assets are anchored through an exact asset link for that Store Product's
  own Project;
- Commerce remains authoritative for Order/payment state, while physical-original receipt,
  source selection, exceptions and production authorisation remain later typed FUND
  Order/Order-line workflow concerns;
- the migration creates no C4 rows and reinterprets no existing media or configuration;
- fresh, representative existing-data, constraint, deletion, regression and zero-residue
  validation on the retained disposable database is mandatory.

No blocker remains inside the bounded schema plan. Acceptance does not implement C4,
authorise Project Intake alignment, start `1R-C5`/`COMMERCE-A2`, or claim shared database
deployment.

## 15. Single Bounded Implementation Prompt

```text
Continue only accepted FUND Phase 1 Slice 1R-C4. Do not begin Project Intake alignment,
1R-C5, COMMERCE-A2 or another slice.

Implement only the accepted FundProductionAsset, FundProductionAssetVersion,
FundProjectAssetLink and FundStoreProductAssetLink schema foundation, its bounded FUND
enums and the one supporting FundProjectStoreProduct tenant/ID/Project key in the current
Prisma schema and one migration. Apply the accepted logical-asset/version identity,
same-asset current/review pointers, same-Project Store Product anchoring, managed MediaFile
reference, immutable file snapshots, uploader, scan, retention, tombstone, deletion, check,
index and partial-unique contracts exactly as planned.

Preserve every existing MediaFile, Project, Store, Store Product, Product media and
configuration-version value. Create no Production Asset, Version or link row by migration.
The ORDER_LINE_ARTWORK_BACKUP purpose and PUBLIC_PURCHASER uploader type are schema
vocabulary only: add no guest-checkout behaviour, purchaser PII, Commerce Order/Order-line
relation, payment state, physical-artwork state or production-authorisation state.

Do not add upload/download/storage/scanning services, file inspection, API, route, UI,
Project Intake changes, Commerce checkout/Orders/payments, production workflow or
commission behaviour.

Use only TEST_DATABASE_URL after proving it differs from DATABASE_URL. Complete fresh and
representative existing-data migration tests, all planned asset/version/uploader/scan/
review/retention/tenant/Project/Store Product/deletion constraints, A1/C1/C2/C3 regression
checks and zero-residue cleanup. Do not modify shared development, staging or production
databases.

After successful validation, create separate FUND 1R-C4 implementation-confirmation and
review/test records, update the FUND and root roadmaps and planning README, then stop. Do
not start the next slice.
```

## 16. Completed Lifecycle Outcome

The bounded implementation was completed and reviewed on 2026-07-14 without expanding the
accepted scope. Authoritative evidence:

- `docs/modules/fund/04-implementation-confirmations/2026-07-14-phase-1-slice-1r-c4-production-asset-version-schema-implementation-confirmation.md`
- `docs/modules/fund/05-review-and-test/2026-07-14-phase-1-slice-1r-c4-r1-production-asset-version-schema-review-and-test.md`

The representative 131-to-132 migration and complete 132-migration fresh replay passed on
the retained disposable database. The constraint/deletion suite and A1/C1/C2/C3 regressions
passed with zero C4 fixture residue. No shared development, staging or production database
was contacted or modified.

The implementation remains schema vocabulary and evidence structure only. It adds no
upload, storage, scanning, guest-checkout, Commerce, physical-artwork or production-gate
behaviour. The application and documentation changes remain uncommitted. `1R-C5` is the
single next planning candidate and is not authorised for implementation by this outcome.
