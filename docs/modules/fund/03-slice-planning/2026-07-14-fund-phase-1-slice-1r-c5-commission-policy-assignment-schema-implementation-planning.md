# FUND Phase 1 Slice 1R-C5 - Commission Policy And Assignment Schema Implementation Planning

Date: 2026-07-14

Status: Accepted, implemented and reviewed as passed on disposable PostgreSQL 2026-07-14 / uncommitted / no shared deployment

Parent plan:

`docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c-fund-store-input-schema-foundation-planning.md`

Preceding completed slices: `1R-C1` through `1R-C4`.

## 1. Goal

Define one bounded additive FUND schema migration for versioned Event-default and
Project-specific commission policy configuration and controlled-lifecycle, historically
preserved policy assignments for a Project Store.

Plan only:

```text
FundCommissionPolicy
FundCommissionPolicyVersion
FundCommissionStep
FundProjectCommissionAssignment
```

Acceptance in section 15 authorises only the bounded Prisma schema, migration and verifier
changes identified in section 13. This document itself makes no implementation change and
does not authorise service, API, route, UI, Commerce, commission calculation, accounting or
payment behaviour.

## 2. Hard Boundary

`1R-C5` is bounded to:

- one stable logical commission policy for an Event or an individual Project;
- draft, active and archived immutable configuration versions;
- flat-rate or stepped-rate configuration;
- one timing method per stepped version;
- one explicitly C2-accepted policy-version assignment per Project, with append-only
  assignment history, retrospective replacement and a post-close finalization boundary;
- the minimum tenant/owner/version/Project/Store keys, checks and indexes.

Exclude:

- eligible-sale discovery, commission calculation, recognition execution or rounding;
- aggregate periods, band sales totals, refunds, adjustments or payable amounts;
- statements, accounting, settlement or commission payment;
- Commerce checkout, Orders, Order lines, payments, refunds or pro-forma records;
- commission columns on Commerce Orders or Order lines;
- Store publication/configuration services or UI;
- Project Intake alignment, production workflow, `1R-C6`, `COMMERCE-A2` or another slice.

`FundProjectCommissionPeriod` remains deferred until Commerce provides authoritative paid,
cancelled, refunded and adjusted sales evidence.

## 3. Accepted Business Contract

### 3.1 Scope Authority

Exactly two policy-owner scopes exist:

```text
EVENT
PROJECT
```

Rules:

- an Event may own one stable logical default policy;
- a linked Project inherits that Event policy when it has no active Project policy;
- C1 may give any individual Event-linked Project its own active flat-rate policy as an
  ad-hoc commercial override;
- a context-valid active Project policy wins for that Project only, whether the Project is
  Event-linked or standalone;
- an Event-linked Project override cannot define a stepped ladder;
- a Project with no Event requires its own C1-managed flat or stepped Project policy;
- a Project policy never changes the Event default or another Project;
- Event defaults and standalone Project policies may be flat or stepped; Event-linked
  Project overrides are flat only.

The C1 `Organization` is the tenant and policy administrator. Commission benefits the C2
Project/Client context but does not make the C2 body the seller or policy owner.

### 3.2 Timing And Rate Semantics

A stepped version uses exactly one timing method:

```text
OFFSET_BASED
FIXED_DATE
```

Threshold semantics are end-boundaries rather than overlapping start/end ranges:

- an offset step applies through its threshold a configured number of calendar days before
  the assigned Project close;
- a fixed-date step applies through its configured calendar date;
- the next ordered step starts immediately after the preceding threshold;
- one final step has no threshold and applies until the assigned Project closes;
- rates must strictly decrease through the ordered ladder;
- a flat version applies one rate to all later eligible aggregate Project sales.

Rate values use integer basis points:

```text
0 to 10,000 basis points
100 basis points = 1.00%
10 basis points = 0.1%
```

The C1 UI contract is a percentage input and display with exactly one decimal place:

```text
UI value 12.5% -> stored value 1,250 basis points
UI value 5.0%  -> stored value   500 basis points
```

Accepted UI values range from `0.0%` to `100.0%` in `0.1%` increments. The service converts
the decimal percentage to integer basis points before persistence and converts it back for
display. Stored values must therefore be divisible by 10 basis points; values such as
`1,255` basis points are rejected even though basis-point storage could technically express
them.

Integer storage avoids ambiguous decimal scale and floating-point persistence. C5 stores no
currency or commission amount because rates apply to a later accepted sales amount basis,
not to a C5 monetary balance.

Fixed calendar dates are interpreted through an immutable IANA timezone snapshot on the
policy version. A fixed threshold includes the whole named local calendar day. Offset days
are calendar-day subtraction in that same timezone, preserving the Project close's local
time across daylight-saving transitions before conversion to an instant.

### 3.3 Assignment Acceptance, Retrospective Replacement And Finalization

The policy version is resolved before the Project Store is published. Resolution precedence
is deterministic:

```text
active context-valid Project policy version
else active Event policy version for an Event-linked Project
else unresolved and later Store publication must block
```

Resolution alone is not permission to publish. An authorised C2 Project organiser must
explicitly accept the resolved commission offer for that Project. This `Commission
Acceptance` is a first-class Store publication gate even when:

- the Project is Event-scoped and simply inherits the Event default;
- C1 has configured a Project flat-rate override;
- the Project opening date is already in the past; or
- the Store and its Products otherwise appear ready.

The accepted assignment snapshots:

- Project, Store and resolved Event-default/standalone/flat-override policy identity;
- exact policy version;
- C2 acceptance actor and timestamp;
- Store publication timestamp when publication subsequently occurs;
- Project closing timestamp used by the Store and offset ladder.

An accepted assignment may be replaced after Store publication and after paid Orders exist.
C1 configuration of changed terms creates a proposed replacement linked to the existing
accepted row. It becomes effective only when an authorised C2 Project organiser explicitly
accepts that exact replacement version. The previous accepted assignment remains effective
until then and is never overwritten.

The newest accepted assignment applies retrospectively to all eligible sales in the whole
Project sales window, including Orders recognised before the replacement. It does not split
the Project into old-rate and new-rate periods. For a stepped Event or standalone policy,
each sale's recognised payment timestamp is re-evaluated against the newly accepted ladder,
then sales remain aggregated by resulting band for the later final calculation.

This retrospective rule is safe because commission is not finalized per Order. Orders
preserve sales/payment/refund evidence; the final commission is calculated from the
aggregate Project evidence after Project close.

Before finalization, any public, C2 or C1 “commission earned” amount is an estimate using
the current accepted assignment. It must be labelled as provisional and recalculated across
all eligible Project sales whenever C2 accepts replacement terms. Estimate continuity must
not prevent C1 proposing or C2 accepting an override.

The assignment becomes non-replaceable only when the later post-close commission period is
explicitly finalized. The first eligible paid sale does not lock commission terms. C5 may
record assignment terms as `FINALIZED`, but it does not perform the aggregate calculation
or create the later period/accounting record.

Project `closesAt` remains the authoritative Store/sales-window close. If it changes before
terms are finalized, a replacement assignment with the new close snapshot requires C2
acceptance. After finalization, date or term changes require a later controlled adjustment
or reopening workflow and cannot silently rewrite the finalized evidence.

### 3.4 Reserved C1/C2 UI Requirement

A later management slice must expose the separated C1 configuration/overview and C2
acceptance responsibilities:

- C1 can see the resolved terms, acceptance state and history and may propose, change or
  clear a flat-rate override until post-close finalization;
- C1 overview is not a Project-moderation or Store-publication approval step;
- the C2 Project view shows the exact offered Event-default, standalone or override terms
  and provides the explicit Commission Acceptance control to an authorised organiser;
- a changed C1 offer remains proposed until C2 accepts it, then applies retrospectively to
  the whole Project sales window;
- the Store Publish control remains unavailable until a current assignment has explicit C2
  Commission Acceptance, regardless of the Project opening date;
- the UI must not offer stepped override controls for an Event-linked Project;
- a standalone Project may use the full flat/stepped Project policy editor;
- every C1 rate control accepts and displays a percentage with one decimal place, while the
  service persists the exact integer basis-point conversion;
- C2 organisers may accept offered terms but cannot edit policy rates or ladder
  configuration; an unaccepted initial offer blocks first publication, while an unaccepted
  replacement leaves the prior accepted assignment effective. Public purchasers cannot
  view or manage the acceptance control.

That UI and its write services are required follow-on behaviour but remain explicitly
outside this schema-only slice.

## 4. Current Implemented Evidence

The implemented schema provides:

- `Organization` as tenant owner with an IANA `displayTimezone` configuration;
- tenant-scoped `FundEvent` and `FundProject` identity;
- optional `FundProject.eventId` using a same-tenant Event relation;
- `FundProject.opensAt` and `closesAt` as Store trading-window authority;
- one tenant/Project `FundProjectStore` with exact `(organizationId, id, projectId)` key;
- no Commerce Order, Order line, payment or refund schema;
- no existing commission policy, version, step, assignment or period rows.

No C1-C4 Product, media, input, branding, delivery, Store, configuration-version or
production-asset value needs reinterpretation for C5.

## 5. Enum Naming And Values

Follow the established `Fund<OwningAggregate><Meaning>` convention:

```text
FundCommissionPolicyMode
- EVENT_DEFAULT
- STANDALONE_PROJECT
- EVENT_PROJECT_FLAT_OVERRIDE

FundCommissionPolicyMethod
- FLAT
- STEPPED

FundCommissionPolicyTimingMethod
- OFFSET_BASED
- FIXED_DATE

FundCommissionPolicyVersionStatus
- DRAFT
- ACTIVE
- ARCHIVED

FundProjectCommissionAssignmentStatus
- PROPOSED
- ACCEPTED
- SUPERSEDED
- FINALIZED

```

Assignment status records offered terms, C2 acceptance, audited replacement and the later
post-close finalization boundary. It does not copy sale, payment, Order or generic
source-reference state into FUND.

## 6. Planned Models

### 6.1 `FundCommissionPolicy`

Fields:

```text
id, organizationId, mode
eventId?, projectId?
code, name, description?
archivedAt?, archivedById?, archivedReason?
createdById?, updatedById?, createdAt, updatedAt, metadata
```

Constraints:

- unique tenant identity and tenant-scoped nonblank code;
- `EVENT_DEFAULT` requires only `eventId`;
- `STANDALONE_PROJECT` and `EVENT_PROJECT_FLAT_OVERRIDE` require only `projectId`;
- partial uniqueness permits at most one logical policy per Event and one per Project per
  Project-policy mode;
- unique `(organizationId, id, mode)` supports exact version/assignment mode proof;
- unique `(organizationId, id, eventId, mode)` and
  `(organizationId, id, projectId, mode)` keys support exact assignment owner proof;
- Event/Project owner relations use tenant composite keys and `NoAction` deletion;
- name/code and optional description/archive reason are nonblank when present;
- metadata is a JSON object.

A logical policy persists while its configuration changes through new versions. Archiving
the policy does not delete historical versions or Project assignments.

The mode distinguishes a standalone Project policy from the deliberately flat-only
Event-linked Project override. Uniqueness is per Project and mode, rather than across both
modes, so a Project that later gains or loses an Event can preserve its old policy history
and create the newly context-valid policy mode. Later services must allow only the mode
matching the Project's current Event context to be activated, offered or assigned. A policy
from the other historical mode is not a fallback merely because it still exists.

### 6.2 `FundCommissionPolicyVersion`

Fields:

```text
id, organizationId, policyId, policyMode, version
status, method, timingMethod?
flatRateBasisPoints?
timeZoneSnapshot
activatedAt?, activatedById?
archivedAt?, archivedById?, archiveReason?
createdById?, createdAt, configurationMetadata
```

Constraints:

- positive version and unique `(organizationId, policyId, version)`;
- unique `(organizationId, id, policyId, policyMode)` for exact assignment ownership;
- unique `(organizationId, id, timingMethod)` supports the Step relation; a Step's required
  timing method cannot reference a flat version whose timing method is null;
- the tenant/policy/mode relation proves the version repeats its owning policy's mode;
- one `ACTIVE` version per policy through a partial unique index;
- `FLAT` requires a rate and no timing method;
- `STEPPED` requires a timing method and no flat rate;
- `EVENT_PROJECT_FLAT_OVERRIDE` additionally requires `FLAT` and therefore can never own
  steps;
- basis points are between zero and 10,000 and divisible by 10, matching the one-decimal
  percentage contract;
- timezone and optional archive reason are nonblank;
- configuration metadata is a JSON object;
- lifecycle evidence is coherent:
  - `DRAFT` has no activation or archive timestamp;
  - `ACTIVE` has activation evidence and no archive timestamp;
  - `ARCHIVED` has archive evidence and may represent either a retired active version or an
    abandoned draft.

Configuration fields and child steps become immutable once a version is active or assigned.
Status/activation/archive evidence remains lifecycle state. PostgreSQL does not prevent a
privileged direct update, so the later service must enforce draft-only editing and
insert/read-only assigned configuration.

The database validates only a nonblank timezone snapshot. The activation service must
validate that it is a recognised IANA timezone; the schema must not claim that a text check
proves timezone registry membership.

Activating a version must later validate its complete flat/step shape and atomically archive
the prior active version. Existing Project assignments continue to reference the exact old
version even after it becomes archived.

### 6.3 `FundCommissionStep`

Fields:

```text
id, organizationId, policyVersionId
timingMethod, sequence, label?
rateBasisPoints, isFinal
offsetDaysBeforeClose?, fixedThroughDate? (PostgreSQL `date`)
createdById?, createdAt
```

Constraints:

- tenant/version relation includes `timingMethod`, proving every step uses its version's
  one timing method and preventing steps on a flat version;
- positive unique sequence per version;
- rate between zero and 10,000 basis points and divisible by 10;
- nonnegative offset when present and nonblank label when present;
- `OFFSET_BASED` uses only `offsetDaysBeforeClose` on non-final steps;
- `FIXED_DATE` uses only `fixedThroughDate` on non-final steps;
- a final step has neither threshold;
- one final step at most per version through a partial unique index;
- duplicate offset/fixed thresholds within a version are rejected.

Before activation, the later service must require:

- at least two steps for a genuinely stepped version;
- exactly one final step and contiguous sequence values;
- strictly decreasing rates by sequence;
- strictly decreasing offsets by sequence, moving towards Project close; or strictly
  increasing fixed dates by sequence;
- thresholds that produce deterministic non-overlapping bands;
- assignment-time compatibility between fixed thresholds and the Project close snapshot.

These are ordered cross-row invariants and are not falsely described as row-level database
checks.

### 6.4 `FundProjectCommissionAssignment`

Fields:

```text
id, organizationId, projectId, storeId
policyId, policyVersionId, policyModeSnapshot
eventIdSnapshot?
eventPolicyId?, projectPolicyId?
status, projectClosesAtSnapshot
proposedAt, proposedById?, proposalReason?
acceptedAt?, acceptedById?
storePublishedAtSnapshot?
supersedesAssignmentId?
supersededAt?, supersededById?, supersessionReason?
finalizedAt?, finalizedById?, finalizationReason?
createdAt
```

Owner identity:

- `EVENT_DEFAULT` requires `eventIdSnapshot` and `eventPolicyId`, with
  `eventPolicyId = policyId`;
- the Event policy relation proves that policy owns that Event, and an exact Project/Event
  relation proves the Project was linked to it;
- `EVENT_PROJECT_FLAT_OVERRIDE` requires `projectPolicyId = policyId` and a nonnull
  `eventIdSnapshot` proving the override context;
- `STANDALONE_PROJECT` requires `projectPolicyId = policyId` and no Event snapshot;
- the Project policy relation uses the assigned `projectId`, proving it belongs to that
  exact Project;
- the version relation proves `policyVersionId` belongs to `policyId` and repeats the same
  mode;
- the Store relation proves Store and Project identity match.

The migration may add only the supporting `FundProject (organizationId, id, eventId)` key
needed for exact Event assignment proof. The existing Store composite key is reused.

Required relation keys are explicit:

- Event-policy ownership uses Policy `(organizationId, id, eventId, mode)`;
- Project-policy ownership uses Policy `(organizationId, id, projectId, mode)`;
- exact Version ownership uses Version
  `(organizationId, id, policyId, policyMode)`;
- Store/Project identity uses Store `(organizationId, id, projectId)`;
- Project/Event identity uses Project `(organizationId, id, eventId)`;
- predecessor identity uses Assignment `(organizationId, id, projectId)`.

Assignment constraints:

- required Project close snapshot; a present Store publication snapshot must precede it;
- one effective `ACCEPTED` or `FINALIZED` assignment per Project through a partial unique
  index;
- at most one `PROPOSED` replacement per Project through a partial unique index;
- an optional predecessor relation must reference an assignment for the same Project and
  may be superseded only once;
- accepted, superseded and finalized timestamps cannot precede `proposedAt`, supersession
  and finalization cannot precede acceptance, and finalization cannot precede the captured
  Project close;
- `PROPOSED` has no acceptance, supersession or finalization evidence;
- `ACCEPTED` requires a C2 acceptance actor/timestamp and has no supersession/finalization
  evidence;
- `SUPERSEDED` requires prior C2 acceptance and supersession actor/timestamp/reason;
- `FINALIZED` requires prior C2 acceptance and finalization actor/timestamp/reason and has
  no supersession evidence;
- optional reasons are nonblank.

Actor IDs are audit scalars rather than User foreign keys, preserving historical evidence
after User deletion. An actor scalar records the authenticated public `User.id`; later
services validate that proposal/configuration actors have C1 authority and acceptance
actors have active C2 organiser/member authority for the assigned Project at acceptance.

Commercial identity fields and policy/version/close snapshots are immutable after a row is
proposed. Assignment rows still have controlled lifecycle transitions: acceptance evidence,
the one-time Store publication snapshot, supersession evidence or finalization evidence is
written as the corresponding event occurs. Once written, those event timestamps and actors
must not be rewritten by later services.

An assignment's Event snapshot is historical context. A later Project/Event change must not
rewrite an accepted or finalized assignment. Before finalization it requires a proposed
replacement and C2 acceptance; after finalization it requires later controlled remediation.

Partial indexes can permit one proposal beside the current accepted assignment, but they
cannot also prove that the proposal's predecessor is not `FINALIZED` or make the two-row
`ACCEPTED -> SUPERSEDED` / `PROPOSED -> ACCEPTED` transition atomic. The later assignment
service must lock the Project assignment set, reject replacement of a finalized predecessor
and perform both transitions in one transaction. Schema tests must state this boundary.

The exact Event-default and Event-override branches can use a nonnull composite
Project/Event relation. PostgreSQL cannot use the same nullable relation to prove that a
`STANDALONE_PROJECT` assignment's live Project has `eventId IS NULL`. The later assignment
service must validate that condition transactionally; the database smoke record must state
this limitation rather than claim complete context enforcement.

## 7. What C5 Can Record Before Commerce Exists

C5 can record:

- approved policy configuration and immutable versions;
- deterministic rate/timing steps;
- the exact version offered to and accepted by C2 before Store publication;
- Store publication and Project close snapshots;
- proposed, accepted, superseded and finalized assignment evidence;
- an auditable replacement chain without splitting the Project sales window by assignment.

C5 cannot determine or record:

- whether a paid sale is eligible;
- the first eligible paid-sale timestamp or Commerce record identity;
- whether commission uses net, tax-exclusive, gross, refunded or adjusted sales amounts;
- sales allocated to each band;
- calculated, accrued, approved, payable or settled commission money.

When Commerce exists, the later typed FUND integration creates a
`FundProjectCommissionPeriod` or equivalent calculation/audit aggregate after Project close.
It recalculates the full Project sales window using the current accepted assignment, then
references that exact assignment/version when the period and its terms are finalized. It
must not copy or re-resolve whichever policy is then current. The sales-amount basis and
rounding policy must be decided with Commerce monetary/refund evidence, not guessed in C5.

## 8. Deletion And Retention Direction

| Parent | Child/reference | Action |
| --- | --- | --- |
| Organization | all C5 rows | `Cascade` |
| Event | Event policy | `NoAction` |
| Project | Project-specific policy | `NoAction` |
| Policy | version | `NoAction` |
| Version | draft steps | `Cascade` only when the version itself is deletable |
| Project | assignment | `NoAction` |
| Store | assignment | `NoAction` |
| Policy/version | assignment | `NoAction` |
| Prior assignment | replacement assignment | `NoAction` |

Normal operation archives policies/versions and supersedes assignments. Once a version or
assignment has been used, later services must prohibit hard deletion. C5 has no period or
Commerce child capable of enforcing every future retention rule, so the implementation
must not claim universal database immutability.

## 9. Index And Constraint Checklist

Require:

- tenant identity keys on all four models;
- partial unique Event ownership and Project-plus-mode policy ownership;
- mode/owner checks distinguishing Event defaults, standalone policies and flat-only
  Event-Project overrides;
- unique policy version number and one active version per policy;
- unique step sequence/threshold and one final step per version;
- policy scope exactly-one-owner check;
- version method/timing/rate/lifecycle checks;
- step timing/final/rate/sequence checks;
- exact tenant/Project/Store/policy/version assignment keys;
- one effective accepted/finalized assignment, at most one proposal per Project and one
  successor per predecessor;
- coherent proposal/C2-acceptance/supersession/finalization evidence;
- assignment chronology and post-close finalization checks;
- indexes for tenant/scope/owner, policy/status/version, version/sequence and
  Project/proposed/effective/finalized assignment reads.

Use short explicit PostgreSQL names where Prisma-generated names could collide.

## 10. Migration And Zero-Backfill Plan

One additive migration must:

1. create the bounded C5 enums;
2. add the supporting Project tenant/ID/Event key;
3. create Policy and Version tables without assignment/self-reference cycles;
4. create Step and Assignment tables;
5. add checks, ordinary and partial unique indexes;
6. add tenant, owner, version, Project and Store foreign keys;
7. add assignment predecessor/self-reference last.

Backfill rule:

```text
Create no policy, version, step or assignment row by migration.
Change no existing Event, Project, Store or C1-C4 value.
Do not infer commission rates or ownership from metadata/free text.
```

Existing Projects without a policy remain without one until a later C1 workflow explicitly
configures and offers it. Store publication must eventually require an exact current C2-
accepted assignment, but that service/UI behaviour is outside C5. A past Project opening
date does not create acceptance or bypass that gate.

## 11. Disposable-Database Validation

Use only `TEST_DATABASE_URL` after proving it differs from `DATABASE_URL`. Require:

- Prisma format, multi-schema validation, generation and a dedicated C5 static verifier;
- A1/C1/C2/C3/C4 static regression verifiers;
- representative 132-to-133 existing-data migration with exact value preservation;
- complete fresh replay of all 133 migrations and zero C5 rows after migration;
- valid Event-default flat/stepped policies, a flat-only Event-linked Project override and
  standalone flat/stepped Project policies;
- preservation of separate historical standalone and Event-override policy modes for the
  same Project, with service-context limitations stated rather than falsely database-proven;
- rejection of no-owner, dual-owner, duplicate-owner, cross-tenant and unknown-owner rows;
- flat versus stepped version shape, one active version and lifecycle checks;
- offset/fixed/final step shape, duplicate sequence/threshold/final, basis-point range and
  10-basis-point increment checks;
- exact inherited Event-default, Event-Project flat-override and standalone assignment;
- rejection of wrong Event, wrong Project, wrong Store, wrong policy version and cross-
  tenant assignment relations;
- proposed/accepted/superseded/finalized status shapes, C2 acceptance evidence, optional
  publication snapshot, timestamp chronology, post-close finalization and predecessor
  constraints;
- replacement of an accepted assignment after representative paid-sale evidence would
  exist conceptually, without any Commerce row or per-Order rate split in C5;
- planned deletion/restriction behaviour, Organization teardown and zero fixture residue;
- deterministic proof that only an active flat Project policy can override an Event default
  for its owning Project, rejection of a stepped override, plus explicit evidence that the
  database cannot prove a standalone Project's null Event, actor authority, valid IANA
  registry membership, predecessor lifecycle state, atomic two-row replacement or aggregate
  sales;
- C1-C4 row/value preservation and regression checks.

The review must not claim commission calculation, Commerce eligibility, Store publication
gating, C2 actor authority, accounting, payment or ordered cross-row activation validation
from schema smoke tests.

## 12. Rollback And Failure Policy

Before shared deployment, rollback may be exercised only on the disposable database by
dropping assignment self-reference, C5 foreign keys/tables, the unused supporting Project
key and enums in reverse dependency order.

After shared policy or assignment evidence exists, use a reviewed forward migration. Never
drop historical commission evidence to simulate rollback.

Any migration or constraint failure must stop the lifecycle. Do not edit an applied shared
migration, infer backfill values or weaken tenant/owner constraints to make a test pass.

## 13. Expected Files After Acceptance

Only an accepted implementation may change:

```text
prisma/schema.prisma
prisma/migrations/<one bounded 1R-C5 migration>/migration.sql
scripts/verify-fund-1r-c5-schema.ts
scripts/verify-fund-1r-c5-pre-migration.sql
scripts/verify-fund-1r-c5-database.sql
scripts/run-fund-1r-c5-database-tests.ts
```

It must then create separate `04-implementation-confirmations` and `05-review-and-test`
records and update the FUND/root roadmaps. No service, API, Commerce, UI or later-slice file
is authorised.

## 14. Acceptance Criteria

Review must confirm:

- all four models remain FUND-owned;
- flat-only Project override precedence over an Event default is explicit and tenant-scoped;
- logical policies and immutable configuration versions are separate;
- flat and stepped shapes and one timing method are deterministic;
- one-decimal percentage UI, exact basis-point conversion and timezone/date semantics are
  accepted;
- assignments preserve exact owner/version/Store/Project/close evidence;
- explicit C2 acceptance gates later Store publication without introducing C1 moderation;
- accepted terms may be replaced retrospectively after sales, while finalized post-close
  terms cannot be silently replaced;
- provisional commission displays recalculate from the current accepted assignment;
- Project close remains the sales-window/calculation-period authority;
- live Project/Event context validation for standalone versus flat-override modes is
  explicit and bounded by later services;
- paid-sale evidence, sales amount basis and period/calculation/accounting remain deferred;
- migration is additive with zero backfill and disposable validation is complete;
- no implementation is performed by this document.

There are no unresolved schema questions inside the accepted direction.

## 15. Review And Acceptance Outcome

Review result: accepted for bounded implementation on 2026-07-14.

The review confirmed:

- the current Prisma schema supplies tenant-scoped Event, Project and one-Store-per-Project
  identities, while the migration needs only the planned Project/Event supporting key;
- Event defaults, standalone Project policies and flat-only Event-Project overrides have
  deterministic precedence and exact tenant/owner proof;
- Project policy uniqueness is per Project and policy mode, preserving history when Event
  context changes without making the wrong historical mode assignable;
- logical Policy identity, immutable configuration Versions and ordered Steps remain
  separate;
- one-decimal percentage input maps exactly to integer basis points divisible by ten;
- fixed thresholds use PostgreSQL calendar dates plus an immutable IANA timezone snapshot,
  while offset thresholds remain Project-close-relative;
- PostgreSQL enforces row shapes, exact composite identity, uniqueness, chronology and
  finalization after the captured close; ordered cross-row activation and live role/context
  authority, IANA registry validation and atomic replacement of a non-finalized predecessor
  remain later transactional service checks;
- C2 acceptance, not C1 moderation, is the later Store-publication gate;
- a later accepted replacement applies retrospectively to the whole Project sales window,
  first paid sale does not lock terms and estimates remain provisional until post-close
  finalization;
- C5 creates policy and assignment evidence only and introduces no Commerce, calculation,
  eligible-sale, accrual, accounting, payment, Store-service/UI or Intake behaviour;
- the additive migration creates no C5 rows and changes no existing C1-C4 value;
- fresh and representative existing-data migration, constraints, regressions and zero
  residue must be proven only on the retained disposable database.

No blocker remains inside the bounded schema plan. Acceptance does not implement C5 or
authorise Project Intake alignment, `1R-C6`, `COMMERCE-A2` or another slice.

## 16. Single Bounded Implementation Prompt

```text
Continue only accepted FUND Phase 1 Slice 1R-C5. Do not begin Project Intake alignment,
1R-C6, COMMERCE-A2 or another slice.

Implement only FundCommissionPolicy, FundCommissionPolicyVersion, FundCommissionStep and
FundProjectCommissionAssignment, their bounded Fund-prefixed enums and the one supporting
FundProject tenant/ID/Event key in the current Prisma schema and one migration. Apply the
accepted Event-default, standalone Project and flat-only Event-Project override ownership,
per-Project/per-mode history, exact tenant/owner/version/Store/Project/predecessor keys,
flat/stepped shapes, active-version uniqueness, one-decimal basis-point constraints,
PostgreSQL date/timezone semantics, C2-acceptance lifecycle, retrospective replacement,
chronology, post-close finalization, deletion, checks, indexes and partial unique indexes
exactly as planned.

Preserve every existing Organization, Event, Project, Store and C1-C4 value. Create no
Policy, Version, Step or Assignment row by migration and infer no commission term from
metadata or free text. C2 acceptance is schema evidence only in this slice: add no Store
publication gate or configuration/acceptance service.

Do not add commission calculation, eligible-sale discovery, period, band aggregate,
recognition, accrual, accounting, statement, settlement or payment behaviour. Do not add
Commerce checkout, Order, Order-line, payment or refund fields or relations, and do not add
service, API, route, UI, Project Intake or production-workflow changes.

Use only TEST_DATABASE_URL after proving it differs from DATABASE_URL. Complete fresh and
representative 132-to-133 existing-data migration tests, all planned policy/version/step/
assignment/tenant/context/lifecycle/chronology/deletion constraints, A1/C1/C2/C3/C4
regression checks and zero-residue cleanup. Do not modify shared development, staging or
production databases.

After successful validation, create separate FUND 1R-C5 implementation-confirmation and
review/test records, update the FUND and root roadmaps and planning README, and stop. Do
not start the next slice.
```

## 17. Completed Lifecycle Outcome

The bounded implementation was completed and reviewed on 2026-07-14 without expanding the
accepted scope. Authoritative evidence:

- `docs/modules/fund/04-implementation-confirmations/2026-07-14-phase-1-slice-1r-c5-commission-policy-assignment-schema-implementation-confirmation.md`
- `docs/modules/fund/05-review-and-test/2026-07-14-phase-1-slice-1r-c5-r1-commission-policy-assignment-schema-review-and-test.md`

The representative 132-to-133 migration and complete 133-migration fresh replay passed on
the retained disposable database. The complete constraint/deletion suite and A1/C1/C2/C3/C4
regressions passed with zero C5 fixture residue. No shared development, staging or
production database was contacted or modified.

The implementation remains schema vocabulary and evidence structure only. It adds no
commission calculation, Commerce, Store service/UI, Commission Acceptance, Project Intake
or production-workflow behaviour. The application and documentation changes remain
uncommitted. Stop here. Planning-only Project Intake alignment is the single next candidate
but is not started or authorised by this outcome.
