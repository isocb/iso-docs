# FUND Phase 1 Slice 1R-C2 - Client Branding/Project Delivery/Event Media Schema Implementation Planning

Date: 2026-07-14

Status: Accepted 2026-07-14 / implemented and reviewed as passed on disposable PostgreSQL

Parent plan:

`docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c-fund-store-input-schema-foundation-planning.md`

Preceding completed slice:

`docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c1-product-media-input-tax-duplication-schema-implementation-planning.md`

## 1. Goal

Define one bounded additive FUND schema migration for:

- C2 Client Store-logo configuration;
- one structured live delivery profile per Project;
- typed Event Store-banner media associations.

This document is planning only. It does not authorise Prisma, migration, service, API, UI,
upload, Store, Order or payment implementation.

Terminology in this plan:

- `Organization` means the C1 IsoStack tenant/supplier record;
- `FundClient`, or **C2 Client organisation**, means the Project-owning body. It may be a
  school, club, Scout or Guide group, team, league, PTA, charity, community group or another
  organisation type. “School/club” is illustrative only and is not the primary domain term
  or a restriction on eligibility.

## 2. Hard Boundary

`1R-C2` may add only directly owned FUND configuration records related to existing
`FundClient`, `FundProject`, `FundEvent`, `MediaFile` and `Organization` records.

It must not add:

- Project Store or Store Product records;
- Store publication/readiness services;
- checkout, Commerce Order, Order-line, payment, refund or pro-forma records;
- immutable Order delivery snapshots or typed Commerce Order context;
- file-upload, storage, scanning or MediaFile mutation services;
- production assets or asset versions;
- Client address-book/default-address management;
- purchaser delivery or direct-to-purchaser fulfilment;
- commission policy or calculation;
- `COMMERCE-A2`, `1R-C3` or another slice.

## 3. Current Schema Evidence

The current Prisma schema establishes:

- `Organization` is the C1 tenant and carries mutable C1 branding URLs/colors;
- `FundClient` is the C2 organisation/account concept and has no logo/media relation;
- `FundProject` has optional `clientId` and `eventId` composite same-tenant relations;
- `FundProject.organiserName`, `organiserEmail` and `organiserPhone` are general Project
  contact fields, not a structured delivery address;
- `FundClientMember` is the implemented C2 person/member record and may link to the
  platform `User` used for later dashboard access;
- the public Project Intake form planned in `1P-G-F` asks for Organisation address and
  Main organiser details, but the current typed `FundProjectIntakeSubmission` columns do
  not provide a structured organisation-address contract;
- the implemented `1P-G-D3-A` approval action creates or links a Client and creates a
  Project, but explicitly does not create the primary Client member/login account or a
  delivery profile;
- `FundEvent` has no typed media relation;
- `FundClient`, `FundProject` and `FundEvent` each expose
  `@@unique([organizationId, id])`, supporting composite same-tenant child relations;
- shared `MediaFile` carries `organizationId` but still lacks a composite
  `(organizationId, id)` unique key;
- `1R-C1` is implemented locally and has established the accepted MediaFile relation
  limitation and disposable-database verification pattern;
- Commerce A1 contains no Order or delivery model.

No existing Client, Project, Event, Organization or MediaFile value may be changed or
reinterpreted by the migration.

## 4. Accepted Physical Direction For Review

### 4.1 `FundClientBranding`

Add one optional branding record per existing Client.

Planned fields:

```text
id
organizationId
clientId
primaryLogoMediaFileId
logoAltText
isActive
createdById
updatedById
createdAt
updatedAt
```

Field decisions:

- `clientId` is required and unique within the tenant, making the relation one-to-one;
- `primaryLogoMediaFileId` is required when a branding row exists;
- `logoAltText` is optional because later rendering may fall back to the Client name;
- `isActive` defaults to `true`; deactivation deliberately selects the C1 fallback;
- dark-logo, favicon, colors, typography and arbitrary branding JSON are deferred.

Resolution contract:

```text
active FundClientBranding.primaryLogoMediaFileId
-> Organization.lightLogoUrl
-> deprecated Organization.logoUrl only as legacy fallback
-> no-logo presentation state
```

Do not copy Organization branding into Client, Project or later Store rows. A Store/receipt
snapshot is later work only where legal or historic rendering requires it.

Relations and constraints:

- direct tenant relation to `Organization` with tenant-teardown cascade;
- same-tenant Client relation through `(organizationId, clientId)` with cascade before
  Store/history references exist;
- simple `primaryLogoMediaFileId -> MediaFile.id` relation with restrictive deletion;
- unique `(organizationId, clientId)`;
- composite `(organizationId, id)` key for consistent typed child identity;
- index by tenant/active state.

### 4.2 `FundProjectDeliveryProfile`

Add one optional live delivery profile per existing Project.

#### 4.2.1 C2 organiser and first-Project contract

The business meaning is now explicit:

- a new C2 relationship begins when a person submits the onboarding form for the first
  Project on behalf of a C2 Client organisation/project-owning body;
- approval of that first Project must create or match the `FundClient`, create or match a
  primary `FundClientMember` for the main organiser, link that member to the login-capable
  platform `User` through the established Client-member onboarding policy, and create the
  Client-owned Project;
- a primary organiser profile is therefore a prerequisite of completing new Project
  creation, not optional descriptive text on the Project;
- Event linkage remains optional and comes only from the trusted intake-form/default Event
  or explicit C1 approval choice;
- the organiser later reaches the Project through authenticated
  `User -> FundClientMember -> FundClient -> FundProject` scope and may manage the Project's
  delivery profile from the C2 dashboard.

This refines, but does not erase, the earlier Project Intake work:

- `1P-G-F - Public Project Initiation Form UI Planning` defined the visible Organisation
  address and Main organiser form sections, and `1P-G-F-A` implemented that form;
- `1P-G-C - Project Intake Schema Confirmation` explicitly deferred structured Client and
  Project delivery-address handling to later planning;
- `1P-G-D3-A - Project Intake Approval API/Services` currently creates/links the Client and
  Project but deliberately does not provision a Client member/login;
- `1P-K1-F-B - Client Member User Link/Create Service` supplies the existing bounded
  member-to-User mechanism that the aligned approval workflow should reuse.

Controlling source records:

- `docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-f-public-project-initiation-form-ui-planning.md`;
- `docs/modules/fund/04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-f-a-public-project-initiation-form-ui-confirmation.md`;
- `docs/modules/fund/04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-c-project-intake-schema-confirmation.md`;
- `docs/modules/fund/04-implementation-confirmations/2026-06-29-phase-1-slice-1p-g-d3-a-project-intake-approval-api-services-confirmation.md`;
- `docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1p-k1-f-b-client-member-user-link-create-service-confirmation.md`.

Consequently, `1R-C2` may add the delivery-profile schema, but it must not claim that the
current intake/approval workflow already satisfies this prerequisite. Before new intake
approvals can be treated as Store-ready, a separately reviewed Project Intake alignment
slice must add typed structured organisation/delivery-address capture and atomically
coordinate Client, primary Client member/User, Project and initial delivery-profile
creation. That amendment must preserve moderation, tenant scoping, explicit approval and
idempotency. It is application workflow work and is not implemented by this schema slice.

#### 4.2.2 Planned delivery-profile record

Planned fields:

```text
id
organizationId
projectId
recipientName
attentionName
addressLine1
addressLine2
addressLine3
locality
region
postalCode
countryCode
email
phone
deliveryNotes
createdById
updatedById
createdAt
updatedAt
```

Field decisions:

- `projectId` is required and unique within the tenant;
- `recipientName` is the effective organisation/body named on the delivery and is required
  with `addressLine1`, `locality`, `postalCode` and `countryCode` when a profile exists;
- `attentionName` is an optional named delivery contact; first-Project onboarding defaults
  it to the confirmed main organiser, but the organiser/C1 may change or remove it when the
  destination does not require an attention line;
- address lines 2/3, region, email, phone and delivery notes are optional;
- `countryCode` is fixed-length two-character uppercase ISO-style storage;
- email/phone format is validated by a later service, not a database regex;
- `deliveryNotes` is typed text, not unbounded contract metadata;
- no status, fulfilment-mode or address-type enum is introduced: first-pass fulfilment is
  fixed as Project bulk delivery to the organiser destination.

Database checks:

- required recipient/address text must remain nonblank after trimming, and optional
  `attentionName` must be null or nonblank;
- country code must match two uppercase ASCII letters.

Relations and deletion:

- direct tenant relation to `Organization` with tenant-teardown cascade;
- same-tenant Project relation through `(organizationId, projectId)` with cascade;
- unique `(organizationId, projectId)`;
- composite `(organizationId, id)` key for later typed references;
- no tenant/postal-code or address-search index: no first-pass query requires one, so
  `1R-C2` must not add a speculative index.

Live-source semantics:

- the profile is mutable current Project configuration;
- no profile means delivery setup is incomplete; later Store readiness must block rather
  than infer an address;
- for a newly approved first Project, the initial profile defaults from the structured
  C2 Client organisation address and main-organiser details explicitly confirmed during
  moderated onboarding;
- the default `recipientName` is the confirmed C2 Client organisation name and the default
  `attentionName` is the confirmed main-organiser name; both then remain editable Project
  delivery values;
- those values are copied once into the Project-owned profile in the eventual aligned
  approval transaction; they are not a live inherited view of Client/member data;
- C1 must be able to review/correct the proposed destination at approval, and the organiser
  may later edit it from the tenant-scoped C2 Project dashboard;
- existing organiser name/email/phone may be offered as deliberate UI prefill for legacy
  or C1-created Projects, but migration and runtime resolution do not silently copy or fall
  back to them;
- once present, the profile owns effective delivery recipient/contact/address data;
- a later FUND Order context must snapshot the effective values at submission so edits do
  not alter historic fulfilment evidence;
- reusable Client address books/defaults remain deferred.

Delivery addresses and notes may contain personal data. Later service/API planning must
apply tenant authorization, minimum disclosure and retention rules. This schema slice adds
no public read/write path.

### 4.3 `FundEventMediaRole`

Add one FUND enum:

```text
FundEventMediaRole
- STORE_BANNER
```

Do not reuse Product-media roles. Event imagery supplies Store context and never changes
Product identity, price, tax or option configuration.

### 4.4 `FundEventMedia`

Add typed Event/media associations.

Planned fields:

```text
id
organizationId
eventId
mediaFileId
role
altText
caption
sortOrder
isActive
createdById
updatedById
createdAt
updatedAt
```

Defaults:

- `role = STORE_BANNER`;
- `sortOrder = 0`;
- `isActive = true`.

Relations and constraints:

- direct tenant relation to `Organization` with tenant-teardown cascade;
- same-tenant Event relation through `(organizationId, eventId)` with cascade before Store
  history exists;
- simple `mediaFileId -> MediaFile.id` relation with restrictive deletion;
- unique `(organizationId, eventId, mediaFileId)` association;
- non-negative sort order;
- one active `STORE_BANNER` per Event through reviewed partial unique SQL because Prisma
  cannot express conditional uniqueness;
- composite `(organizationId, id)` key;
- tenant/Event/active/sort index and MediaFile index.

No media row is created automatically for an existing Event. A Project without an Event or
an Event without an active banner has no Event-banner context; this does not invent a
Product or branding fallback.

### 4.5 MediaFile Tenant Limitation

Both Client branding and Event media reference shared `MediaFile.id`. The current public
model lacks a composite `(organizationId, id)` unique key, so PostgreSQL cannot enforce
matching tenant ownership through the planned relation without changing shared Core
schema.

Accepted bounded handling:

- do not modify the shared MediaFile schema in `1R-C2`;
- keep direct Organization and same-tenant FUND-owner relations database-enforced;
- restrict MediaFile deletion while referenced;
- add no application write path in this schema-only slice;
- require later branding/Event-media write services to query the MediaFile by both
  `id` and actor `organizationId` before create/update;
- record this limitation explicitly in implementation and review evidence.

## 5. Migration And Backfill Plan

Create one additive migration after explicit plan acceptance.

Order:

1. add `FundEventMediaRole` in the `fund` schema;
2. create `fund_client_branding`;
3. create `fund_project_delivery_profiles`;
4. create `fund_event_media`;
5. add primary/unique/index structures and explicit short names;
6. add nonblank, country-code and non-negative checks through reviewed SQL;
7. add the active Event-banner partial unique index;
8. add Organization, Client, Project, Event and MediaFile foreign keys;
9. validate fresh and representative existing-data migration only on the verified
   disposable database.

Automatic backfill:

- create no branding row;
- create no delivery profile;
- create no Event-media row;
- do not copy Organization logos;
- do not copy Project organiser contact fields;
- do not parse historic Project Intake `rawPayload` into delivery profiles or create Client
  members/Users from historic respondents;
- do not infer delivery addresses from `Organization.billingAddress`, Client fields,
  Project metadata or free text;
- do not infer Event banners from Product media or existing URLs.

Required pre/post evidence:

- Organization, Client, Project, Event and MediaFile counts unchanged;
- existing scalar/JSON values unchanged;
- all three new tables empty immediately after migration;
- no duplicate owner keys before constraint creation;
- enum/table/index/constraint inventory matches the accepted contract.

The later Project Intake alignment must test new-workflow initialization separately. It
must not be disguised as migration backfill and must define an explicit operator-reviewed
remediation path for any existing Project that lacks a primary organiser or delivery
profile.

## 6. Expected Implementation Files

Only after acceptance:

```text
prisma/schema.prisma
prisma/migrations/<timestamp>_fund_1r_c2_client_branding_delivery_event_media/migration.sql
scripts/verify-fund-1r-c2-schema.ts
scripts/verify-fund-1r-c2-pre-migration.sql
scripts/verify-fund-1r-c2-database.sql
```

Then create exactly one FUND implementation confirmation and one review/test record and
reconcile this roadmap, the FUND roadmap and the root roadmap.

No router, service, page, component, upload handler, Store, Commerce or production file
belongs to this slice.

## 7. Validation Matrix

Required before implementation confirmation:

- Prisma format, validation and client generation pass;
- targeted 1R-C2 schema/migration verifier passes;
- type-check, targeted verifier lint, repository verification and `git diff --check` pass;
- migration applies after the current 129-migration baseline with representative existing
  Client, Project, Event, Organization and MediaFile rows;
- all existing values and counts remain unchanged;
- migration applies through a complete fresh-database replay;
- valid Client branding, Project delivery and Event media rows can be created;
- duplicate Client branding and Project delivery profiles are rejected;
- cross-tenant Client, Project and Event owner relations are rejected;
- unknown MediaFile references are rejected;
- referenced MediaFile deletion is restricted;
- blank required delivery fields, a blank non-null attention name, lowercase/invalid
  country code and negative sort order are rejected;
- two active Event banners are rejected while inactive/historical associations remain
  permitted;
- Client/Project/Event deletion cascades only the mutable configuration rows as planned;
- cleanup leaves zero test residue;
- Commerce A1 and FUND 1R-C1 static verifiers still pass;
- schema/migration diff introduces no Store, Order, payment, upload, production or
  commission model and modifies no Commerce model.

Database-backed checks must use only `TEST_DATABASE_URL`, after proving it is distinct from
`DATABASE_URL`. Use the direct Neon endpoint for reset/migration operations. Do not modify
shared development, staging or production databases.

The review must not claim database-enforced MediaFile tenant isolation. It must confirm
that no write service/API was added and retain the later service-validation gate.

## 8. Failure And Rollback Strategy

- review generated and handwritten SQL before application;
- fix an unapplied migration rather than layering speculative correction migrations;
- recreate only the verified disposable database after a failed migration test;
- never drop or rewrite existing Client, Project, Event, Organization or MediaFile data;
- correct an already-applied persistent environment through a reviewed forward migration
  unless an operator-approved restore is safer;
- record migration identifier, pre/post counts, test target and residue inventory in the
  implementation confirmation.

## 9. Explicit Non-Goals

- no Store or Store Product;
- no Order/line delivery snapshot;
- no checkout, payment, Stripe, refund or pro-forma;
- no Client address book or Client default delivery address;
- no Project Intake form/approval amendment, Client-member provisioning or login creation;
- no purchaser/direct delivery;
- no delivery pricing, carrier, dispatch, tracking or batching;
- no upload/storage/scanning service;
- no production asset/version;
- no branding colors/themes or Event galleries beyond the typed banner foundation;
- no media-management UI;
- no commission schema;
- no `1R-C3`, `1R-C6` or Commerce A2 work.

## 10. Acceptance Criteria

Accept this implementation plan only when:

- all three planned models are FUND-owned configuration;
- Client branding resolves to C1 fallback without duplicating Organization URLs;
- one live Project delivery profile supplies the future bulk-delivery source;
- the first-Project contract requires an approved primary Client organiser and initializes
  the Project profile once from confirmed structured onboarding details;
- the current Project Intake/address and member-provisioning gap is explicit and assigned
  to a separately reviewed alignment slice;
- existing organiser fields, intake JSON and legacy Projects are not silently reinterpreted
  or copied by migration;
- immutable Order delivery snapshots remain deferred to typed FUND Order context;
- Event Store-banner media remains separate from Product media;
- no historic rows are inferred by migration;
- same-tenant FUND owner relations and deletion rules are explicit;
- MediaFile tenant limitations and later service gates are explicit;
- migration, representative-data, fresh-database, constraint and cleanup evidence are
  required;
- Store, Commerce, upload, production and commission boundaries remain intact;
- no implementation occurs before explicit acceptance.

### 10.1 Decision Closure

There are no unresolved business or schema questions inside the bounded `1R-C2` plan.
Formal review should verify the recorded decisions rather than reopen them without new
evidence.

The following are deliberate later-slice dependencies, not open `1R-C2` questions:

- Project Intake/member/User/delivery-profile workflow alignment;
- tenant-scoped media write-service validation;
- Store readiness and immutable Order delivery snapshots;
- upload, media-management and C2 delivery-edit UI.

## 11. Single Review/Acceptance Prompt

```text
Review and accept FUND Phase 1 Slice 1R-C2 Client Branding/Project Delivery/Event Media
Schema Implementation Planning. Do not implement schema or application code during the
review and do not begin COMMERCE-A2 or another slice.

Verify the plan against the accepted 1R-C parent and current Prisma schema. Resolve any
remaining conflicts in logo fallback, first-Project organiser/onboarding alignment, live
delivery-profile ownership, Event banner uniqueness, MediaFile tenant validation,
migration/backfill, deletion and disposable database testing.

If acceptable, mark only the plan accepted and provide the single bounded 1R-C2
implementation prompt. Make no Prisma, migration, service, API or UI changes.
```

## 12. Lifecycle Outcome

The plan was reviewed and accepted on 2026-07-14. The bounded schema implementation and
its separate review/test lifecycle are complete:

`docs/modules/fund/04-implementation-confirmations/2026-07-14-phase-1-slice-1r-c2-client-branding-project-delivery-event-media-schema-implementation-confirmation.md`

`docs/modules/fund/05-review-and-test/2026-07-14-phase-1-slice-1r-c2-r1-client-branding-project-delivery-event-media-schema-review-and-test.md`

No shared development, staging or production deployment is claimed. Do not rerun `1R-C2`
or begin the Project Intake alignment, `1R-C3`, `COMMERCE-A2` or another slice without a
separate explicit instruction.
