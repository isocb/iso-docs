# FUND Phase 1 Slice 1R-E-A - Store Authority, Exceptional Intervention And Lifecycle Service Alignment Implementation Planning

Date: 2026-07-15

Status: Implemented/reviewed as passed and committed to application `dev`/`origin/dev` at `daafc349`; no shared database deployment

Implementation confirmation:

`docs/modules/fund/04-implementation-confirmations/2026-07-15-phase-1-slice-1r-e-a-store-authority-exceptional-intervention-lifecycle-service-alignment-implementation-confirmation.md`

Review/test record:

`docs/modules/fund/05-review-and-test/2026-07-15-phase-1-slice-1r-e-a-r1-store-authority-exceptional-intervention-lifecycle-service-alignment-review-and-test.md`

Authoritative controls:

- `docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`
- `docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`
- `docs/modules/fund/00-roadmap-control/2026-07-15-fund-store-artwork-orders-and-production-strategic-completion-roadmap.md`
- `docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-e-c1-store-oversight-c2-project-store-control-alignment-planning.md`

Application baseline:

- application `dev`/staging promotion checkpoint `91e8751c`;
- complete 140-migration Prisma/PostgreSQL history;
- Commerce A1-A7 implemented and reviewed;
- FUND 1Q-E/1Q-F, C1-C6, 1R-D, K1-F/K2 and R3-D implemented and reviewed; and
- no live FUND Store data is assumed, but the migration must still be non-destructive and
  must infer no intervention from mutable or historic values.

## 1. Goal

Correct the current C1-only Store lifecycle service before any C1 or C2 Store UI is built.

E-A separates three authorities that the current mutable Store status cannot safely
represent:

```text
C2 normal Store intent
+ C1 exceptional intervention
+ Project lifecycle/date/readiness authority
= one server-derived effective Store state and allowed-action contract
```

E-A is a bounded schema-and-internal-service alignment slice. It adds no C1 or C2 Store
UI, public Store route or public Checkout route.

## 2. Accepted Invariants

The implementation must preserve all of the following:

1. A Store belongs to one Project and has no independent trading dates.
2. `FundProject.opensAt` and `FundProject.closesAt` are the only trading window.
3. A linked Event supplies creation defaults and an outer date envelope only.
4. Project dates are copied as explicit values; later Event changes never cascade them.
5. C2 `PROJECT_MANAGER` and `ADMIN` members normally activate their valid Project and
   publish, pause or resume its Store.
6. C2 `VIEWER` may read but may not mutate.
7. C1 is not a routine publication moderator.
8. C1 `OWNER` or `ADMIN` may apply an exceptional pause or closure for legal, payment,
   safety or seller-of-record reasons and may explicitly release or reopen it.
9. C2 cannot release or reopen a C1 intervention.
10. Releasing a C1 intervention only removes that overlay; it never forces the Store open.
11. Passing the Project close instant is a derived non-trading outcome, not a Store close
    mutation.
12. Exact-organiser-only workflow approval remains distinct from ordinary C2 Store
    management and is not broadened by this slice.
13. Store readiness, commission acceptance, Product eligibility, delivery and payment
    readiness remain authoritative gates.
14. Dormant A7 submission and retry use the same effective availability predicate as
    Store management.

## 3. Current Contract And Required Correction

Current implementation findings:

- `fund.storeManagement.*` and the current Project lifecycle mutations require C1
  `OWNER`/`ADMIN`;
- C2 can create and edit a Project but cannot move its DRAFT Project to ACTIVE;
- `1R-D` refuses Store publication unless the Project is ACTIVE;
- `FundProjectStoreStatus.PAUSED` cannot distinguish C2 intent from a C1 hold;
- `FundProjectStoreStatus.CLOSED` is irreversible in the current transition map;
- Event updates do not reject a newly narrowed envelope that excludes linked Projects;
- Store/A7 availability is currently assembled from Store status, Project status and
  timestamps in more than one service boundary; and
- generic `AuditLog` is useful history but is not a durable current authorization source.

E-A must correct those facts without making readiness or effective time-window states
mutable database status.

## 4. Bounded Persistent Evidence

### 4.1 Enums

Add only these Fund-prefixed enums:

```text
FundProjectStoreInterventionKind
- EXCEPTIONAL_PAUSE
- EXCEPTIONAL_CLOSURE

FundProjectStoreInterventionReason
- LEGAL
- PAYMENT
- SAFETY
- SELLER_OF_RECORD
- OTHER

FundProjectStoreInterventionResolution
- RELEASED
- REOPENED
- SUPERSEDED_BY_CLOSURE

FundProjectStoreEffectiveState
- SETUP
- SCHEDULED
- OPEN
- C2_PAUSED
- C1_EXCEPTION_PAUSED
- PROJECT_PAUSED
- PROJECT_INACTIVE
- CLOSED_BY_PROJECT_WINDOW
- C1_EXCEPTION_CLOSED
- BLOCKED
- ARCHIVED
```

`FundProjectStoreEffectiveState` is the typed service vocabulary and is persisted only as
the intervention's immutable previous-state snapshot. Current effective state is always
derived.

### 4.2 `FundProjectStoreIntervention`

Add one model with the following bounded shape:

```text
id
organizationId
storeId
projectId

kind
reason
operatorNote
previousEffectiveState
idempotencyKey
requestHash

startedAt
startedById

resolution?
resolutionNote?
resolutionIdempotencyKey?
resolutionRequestHash?
resolvedAt?
resolvedById?

createdAt
updatedAt
```

Contract:

- Store and Project identity are exact and same-tenant;
- the Store belongs to the exact Project;
- starting and resolving actors belong to the exact tenant;
- only C1 `OWNER`/`ADMIN` may create or resolve the record through the service;
- `operatorNote` and a supplied `resolutionNote` are trimmed, 1-2,000 characters and
  nonblank;
- the reason enum is C2-safe; free-text notes are internal C1 evidence and never appear in
  C2 responses;
- `idempotencyKey` is a trimmed 12-160-character caller operation key unique within the
  tenant;
- `requestHash` is the server-derived lowercase SHA-256 of the canonical start request;
- `resolutionIdempotencyKey` is a separately trimmed 12-160-character tenant-unique key
  for the one resolution operation;
- `resolutionRequestHash` is the server-derived lowercase SHA-256 of the canonical
  resolution request;
- `startedAt`, actor, identity, reason, note, kind, previous state, start operation key and
  request hash are immutable;
- resolution, resolution note, resolution operation key/hash, resolver and resolved time
  form one single atomic null-to-complete transition;
- an exceptional pause resolves as `RELEASED` or, only inside the atomic replacement
  operation, `SUPERSEDED_BY_CLOSURE`;
- an exceptional closure resolves only as `REOPENED`;
- `resolvedAt >= startedAt`;
- a resolved intervention cannot be edited, reopened or deleted; and
- Store, Project, actor or tenant deletion must not silently erase retained intervention
  evidence.

Required relations and supporting keys:

- `(organizationId, storeId, projectId)` to the existing exact Store key;
- `(organizationId, projectId)` to the existing exact Project key;
- `(organizationId, startedById)` and optional `(organizationId, resolvedById)` to the
  existing User tenant/ID key;
- Organization, User, Project and Store reverse relations for Prisma generation; and
- no caller-supplied actor or tenant relation.

Required database enforcement:

- unique `(organizationId, id)`;
- unique `(organizationId, idempotencyKey)`;
- partial unique `(organizationId, resolutionIdempotencyKey)` where the resolution key is
  not null;
- one unresolved intervention per Store using a partial unique index;
- indexes by tenant/Store/start time, tenant/Project/start time and tenant/kind/start time;
- check constraints for trimmed notes, chronology and complete resolution shape;
- check constraints for operation-key bounds and lowercase 64-character SHA-256 hashes;
- a trigger preventing identity/start/reason/note/previous-state changes; and
- a trigger preventing deletion and any second resolution mutation.

If C1 exceptional closure is requested while a pause is active, one serializable operation
must resolve the pause as `SUPERSEDED_BY_CLOSURE` and create the closure, with both audit
events. It must not inaccurately record a normal release. Two active overlays must never
coexist. The caller supplies one bounded operation key; the server derives stable,
domain-separated resolution/start keys for the two retained writes.

### 4.3 Existing Store status compatibility

The existing Store status becomes C2 intent plus administrative archive:

```text
DRAFT      = C2 has not published
PUBLISHED  = C2 intends the Store to trade when every other authority permits
PAUSED     = C2 has voluntarily paused
ARCHIVED   = retained administrative terminal state
CLOSED     = retired compatibility value; no new write is allowed
```

Rules:

- C1 intervention never rewrites `FundProjectStore.status`, `pausedAt` or `closedAt`;
- `pausedAt` remains evidence of C2's current pause intent;
- `closedAt` is retired and must remain null after E-A;
- the PostgreSQL enum value `CLOSED` may remain because removing an enum member is unsafe,
  but a database check must forbid `status = CLOSED` and non-null `closedAt`;
- E-A services and tests must contain no transition to Store `CLOSED`; and
- normal Project-window ending performs no Store write.

Store or Project archive is refused while an unresolved intervention exists. C1 must first
release or reopen it explicitly; archive is not an implicit intervention resolution.

The migration must first prove there is no Store row using `CLOSED` or `closedAt`. It must
fail safely if such a row exists and report that non-live FUND test data requires explicit
operator cleanup. It must neither delete the row nor infer an exceptional closure. Existing
DRAFT/PUBLISHED/PAUSED/ARCHIVED values remain unchanged and create no intervention.

## 5. Exact Actor And Ownership Policy

### 5.1 C1

C1 Store oversight/intervention requires a session-derived tenant and an effective C1
`OWNER` or `ADMIN` actor.

C1 may:

- read every Store in its tenant;
- start exceptional pause or closure;
- release an exceptional pause;
- reopen an exceptional closure; and
- retain existing supplier-side preparation, readiness and archive operations where they
  do not become routine C2 publication authority.

C1 may not use the exceptional service as an ordinary publish/pause/resume shortcut.

### 5.2 C2

C2 access requires an active, unarchived same-tenant `FundClientMember` whose exact Client
owns the exact Project and Store.

- `VIEWER`: read effective state, public-safe blockers and allowed-action result only;
- `PROJECT_MANAGER`/`ADMIN`: normal Project activation/pause/resume and Store
  publish/pause/resume, subject to locked server checks;
- `NONE`, inactive or archived membership: no Store read or mutation; and
- cross-tenant, cross-Client or caller-supplied ownership: not found.

For a qualifying `PROJECT_MANAGER`/`ADMIN`, E-A aligns these existing server capabilities
through exact Client-scoped wrappers:

- prepare the Project Store and request a server-owned configuration/readiness refresh;
- edit Store title, introduction and fundraising objective;
- list eligible Products and add/remove/reactivate/reorder Project Product selections
  through the existing 1Q-E/1Q-F eligibility contract;
- reorder and show/hide Store Products that remain eligible and released; and
- activate/pause/resume the Project and publish/pause/resume the Store.

C2 cannot write Product identity, commercial snapshots, price, tax, source media,
configuration hashes/revisions, readiness codes, Store Product display copy or primary
media. The current broad `updateStoreProductPresentation` boundary must therefore be split:
C2 receives only ordering/visibility fields, while source presentation and release evidence
remain C1/server-owned. C1 may diagnose or refresh source authority but may not routinely
edit C2-owned Store copy or publish on C2's behalf.

Ordinary C2 Store authority does not confer exact-organiser approval. Where an artwork or
other governed workflow requires the exact organiser, E-A returns a workflow blocker and
leaves the later exact-organiser action to its owning slice.

### 5.3 Dual-role and impersonation safety

Every operation resolves one effective context. A C1 role does not imply C2 Client
membership, and C2 membership does not grant C1 intervention authority. Impersonation uses
the established effective actor and tenant contract and is revalidated inside the locked
transaction.

## 6. Project Lifecycle And Event Envelope

### 6.1 C2 Project lifecycle

Add exact Client-dashboard Project lifecycle service procedures for:

```text
DRAFT -> ACTIVE        activate
ACTIVE -> PAUSED       pause
PAUSED -> ACTIVE       resume
```

They require C2 `PROJECT_MANAGER`/`ADMIN` and exact Client ownership. Target-state retries
are idempotent. E-A does not grant C2 close, complete or archive authority and does not
change C1 administrative Project operations.

Activation revalidates tenant, Client, Project type, explicit Project dates, linked Event
envelope and the existing typed Project/organiser/delivery contract. Store publication
then performs its own complete Store-readiness check; activating a Project is not a Store
publication promise.

The existing free-text `FundProject.lifecycleState` is not authority for these transitions
or for Store availability. E-A must not add new meaning to it; `FundProject.status`, typed
relations, dates and readiness evidence remain authoritative until a separately governed
schema slice retires or replaces that legacy display field.

### 6.2 Event-linked Project defaults

Use one canonical server helper for Event-linked Project date normalization:

- omitted creation values resolve to the Event's opening/closing instants;
- the resolved values are persisted as explicit Project dates;
- explicitly narrower values remain valid;
- values outside the Event envelope fail; and
- standalone Projects still require explicit valid dates.

An omitted value can default only when the corresponding Event instant exists. If either
resolved Project instant is still absent, Project creation fails rather than inventing a
date.

This helper aligns internal C1, C2 and Intake creation boundaries. E-A adds no form or UI.

### 6.3 Non-cascading Event edits

An Event date mutation must:

1. use SERIALIZABLE isolation and lock the Event;
2. lock its non-archived linked Projects in stable ID order;
3. reject opening after a linked Project opens or closing before a linked Project closes;
4. return stable `EVENT_WINDOW_CONFLICT` evidence with a bounded affected-Project summary
   to authorised C1 callers;
5. expose no cross-tenant Project identity; and
6. never rewrite Project dates.

## 7. Effective Store State And Readiness

### 7.1 One evaluator

Add one internal pure/persisted-read boundary, provisionally
`evaluateFundProjectStoreAuthority`, consumed by:

- C1 Store overview/readiness services;
- C2 Project Store reads and lifecycle mutations;
- C2 Project activation/pause/resume where Store actions are reported;
- Store publish/pause/resume;
- dormant A7 initial submission; and
- dormant A7 failed/expired retry.

No router or UI may independently reconstruct trading authority.

### 7.2 Deterministic state precedence

The evaluator returns exactly one current state using this precedence:

1. archived Store or archived Project -> `ARCHIVED`;
2. active exceptional closure -> `C1_EXCEPTION_CLOSED`;
3. active exceptional pause -> `C1_EXCEPTION_PAUSED`;
4. Project `PAUSED` -> `PROJECT_PAUSED`;
5. Project `CLOSED` or `COMPLETED` -> `PROJECT_INACTIVE`;
6. `now >= Project.closesAt` -> `CLOSED_BY_PROJECT_WINDOW`;
7. Store `DRAFT` -> `SETUP`;
8. Store `PAUSED` -> `C2_PAUSED`;
9. Store `PUBLISHED` and `now < Project.opensAt` -> `SCHEDULED`;
10. any authoritative readiness failure -> `BLOCKED`;
11. Store `PUBLISHED`, Project `ACTIVE`, in-window and ready -> `OPEN`.

Invalid or impossible persisted shapes fail closed as `BLOCKED` with internal diagnostics;
they never default to OPEN.

The response also includes readiness independently so a setup, scheduled or paused Store
can show what still requires remediation before it can trade. A future DRAFT Store remains
`SETUP`; only published C2 intent becomes `SCHEDULED`.

Payment readiness is a persisted local check only: an active Commerce Seller Profile plus
the current A6-B connected-account readiness/local-checkout-enabled evidence. Evaluation
performs no Stripe call and never trusts tenant settings JSON or caller-supplied readiness.

### 7.3 Stable response

Return a typed internal result containing:

```text
effectiveState
isTrading
storeIntent
activeInterventionKind?
projectWindow
readinessStatus
blockers[]
allowedActions[]
evaluatedAt
```

Each blocker has a stable code, responsibility and remediation destination. Responsibility
is one of C1, C2, TIME or LATER_WORKFLOW; UI wording is not stored as authority.

At minimum preserve existing 1R-D readiness codes and add or map:

```text
EVENT_WINDOW_CONFLICT
PROJECT_NOT_ACTIVE
PROJECT_PAUSED
PROJECT_NOT_OPEN
PROJECT_WINDOW_ENDED
C1_EXCEPTION_PAUSE_ACTIVE
C1_EXCEPTION_CLOSED
C2_COMMISSION_ACCEPTANCE_REQUIRED
STORE_PRODUCT_RELEASE_REQUIRED
WORKFLOW_READINESS_REQUIRED
PAYMENT_SETTINGS_NOT_READY
```

The implementation plan must include an explicit compatibility table for every existing
1R-D code rather than silently renaming it.

### 7.4 Allowed actions

Actions are actor-specific and server-derived:

- C2 VIEWER: no mutation action;
- C2 PROJECT_MANAGER/ADMIN on a valid DRAFT Project: ACTIVATE_PROJECT;
- C2 PROJECT_MANAGER/ADMIN on an ACTIVE Project: PAUSE_PROJECT;
- C2 PROJECT_MANAGER/ADMIN on a PAUSED Project: RESUME_PROJECT;
- C2 PROJECT_MANAGER/ADMIN on a DRAFT ready Store with an ACTIVE Project, before Project
  close and no active intervention: PUBLISH_STORE (including future scheduling);
- C2 PROJECT_MANAGER/ADMIN on a PUBLISHED Store before Project close: PAUSE_STORE;
- C2 PROJECT_MANAGER/ADMIN on a PAUSED ready Store with an ACTIVE Project, before Project
  close and no active intervention: RESUME_STORE (including future scheduling);
- C1 with no active intervention on a nonarchived Store before Project close:
  EXCEPTIONAL_CLOSE; EXCEPTIONAL_PAUSE is additionally limited to PUBLISHED or PAUSED C2
  intent and a Project not already CLOSED/COMPLETED/ARCHIVED;
- C1 with an active pause: RELEASE_EXCEPTIONAL_PAUSE or atomically replace it with closure;
- C1 with an active closure: REOPEN_EXCEPTIONAL_CLOSURE; and
- C2 receives no action that bypasses an active C1 intervention.

Allowed-action output is advisory. Every mutation repeats all authority and readiness
checks inside its locked transaction.

## 8. Mutation, Locking, Idempotency And Audit

All lifecycle and intervention mutations must:

1. use SERIALIZABLE isolation;
2. acquire the existing tenant/Project advisory lock;
3. lock Project, Store, active intervention and relevant membership rows in stable order;
4. resolve actor and exact ownership again inside the transaction;
5. evaluate the current authoritative state;
6. apply only an allowed transition;
7. write durable intervention evidence where applicable;
8. write a redacted `AuditLog` in the same transaction; and
9. return the freshly recalculated effective-state contract.

Idempotency rules:

- C2 target-state retries return the current state without duplicate audit;
- tenant-scoped intervention `idempotencyKey` replay returns the original result;
- tenant-scoped `resolutionIdempotencyKey` replay returns the original resolution;
- reuse of either key for a different Store, intervention, kind, resolution or request
  hash fails;
- repeated release/reopen by intervention ID returns the resolved record only when the
  requested resolution and operation key match; and
- concurrent start/release/close/reopen requests serialize through locks and database
  uniqueness.

Audit metadata may contain bounded IDs, enum codes and before/after effective state. It
must not contain internal free-text notes, session data, payment secrets, purchaser data or
provider bodies.

## 9. A7 Availability Alignment

E-A may modify only the dormant A7 authority check needed to consume the shared evaluator.

Initial submission and failed/expired retry must refuse when:

- Store intent is not PUBLISHED;
- an exceptional pause or closure is active;
- Project is not ACTIVE;
- current time is outside the Project window;
- Store or Project is archived;
- readiness is BLOCKED or stale; or
- any exact ownership/configuration authority has changed.

The check occurs before A7 creates or retries Commerce evidence and again in its existing
locked transaction. E-A adds no route, UI, real provider action, Payment transition or
Order operation.

## 10. Planned Application Changes

Exact filenames are confirmed during review, but the accepted implementation is expected
to be limited to:

- `prisma/schema.prisma`;
- one migration directory named
  `20260716003000_fund_1r_e_a_store_authority_intervention_foundation`;
- a FUND Store authority/effective-state policy module;
- the existing Store management service/router split into C1 oversight/intervention and
  exact C2 Client-scoped procedures while retaining shared policy;
- the existing Client dashboard Project lifecycle service/router;
- exact Client-scoped wrappers around the existing Project Product eligibility/selection
  services and the narrowed Store Product ordering/visibility mutation;
- the Event update service envelope guard;
- the existing Project creation date-normalization helper/call sites;
- persisted Commerce Seller Profile/A6-B readiness reads, with no provider call;
- the dormant A7 FUND checkout submission/retry authority check;
- bounded unit, integration and disposable PostgreSQL tests; and
- generated Prisma client artifacts only through the normal generation command.

No UI, route page, public API, upload, provider or unrelated LMSPro file is in scope.

## 11. Migration Plan

### 11.1 Preflight

Before any DDL:

- prove the database is the explicitly disposable `TEST_DATABASE_URL` for validation;
- record the 140-migration baseline;
- count Store rows by status and with non-null `closedAt`;
- fail if any Store uses `CLOSED` or `closedAt`;
- verify exact Store/Project and User tenant keys exist;
- verify no conflicting table, enum, constraint, trigger or index name exists; and
- infer nothing from Store metadata, audit text, paused timestamps or historic free text.

### 11.2 Ordered DDL

One migration must:

1. create the four bounded enums;
2. create `FundProjectStoreIntervention`;
3. add exact foreign keys, checks and ordinary indexes;
4. add tenant idempotency and active-intervention partial uniqueness;
5. add immutability/resolution/deletion triggers;
6. add the Store compatibility check forbidding CLOSED and non-null `closedAt`; and
7. leave every existing Store, Project, Event, member, Order and A1-A7/C1-C6 value
   unchanged.

Zero intervention rows are created. There is no semantic backfill.

### 11.3 Rollback

Rollback is permitted only before any intervention evidence exists and before an E-A
service is deployed. The reviewed down procedure drops the Store compatibility check,
triggers, indexes, table and new enums in reverse order.

Once an intervention row exists, rollback is forward-only remediation: retain evidence,
disable the affected service safely and issue a new migration. Do not delete operational
history to restore an older schema.

## 12. Validation Plan

All database-writing validation uses only `TEST_DATABASE_URL` after proving its normalized
target differs from `DATABASE_URL`. Shared development, staging and production remain
untouched.

### 12.1 Migration and schema

- representative 140-to-141 migration with existing DRAFT/PUBLISHED/PAUSED/ARCHIVED Stores;
- preflight refusal for legacy CLOSED/non-null `closedAt` without data mutation;
- full fresh 141-migration replay;
- Prisma format, validate and generate;
- migration SQL review;
- zero intervention backfill; and
- reviewed rollback on an evidence-free disposable database.

### 12.2 Database constraints

- same-tenant Store/Project and actor ownership;
- one unresolved intervention per Store;
- tenant-scoped idempotency uniqueness;
- tenant-scoped resolution-idempotency uniqueness and conflicting replay refusal;
- kind/reason enum enforcement;
- trimmed/bounded start and resolution notes;
- bounded operation keys and canonical start/resolution request hashes;
- complete resolution shape and chronology;
- PAUSE/RELEASE, PAUSE/SUPERSEDED_BY_CLOSURE and CLOSURE/REOPEN pairing;
- immutable identity/start/reason/previous-state fields;
- no second resolution mutation;
- restrictive Store/Project/User deletion and intervention deletion refusal;
- Store/Project archive refusal while an intervention remains unresolved; and
- Store CLOSED/closedAt retirement constraint.

### 12.3 Service authority

- C1 OWNER/ADMIN overview and exceptional actions;
- C1 non-admin refusal;
- C2 VIEWER read-only behavior;
- C2 PROJECT_MANAGER/ADMIN exact Project activation/pause/resume, safe Product selection,
  Store prepare/refresh/copy/order/visibility and Store publish/pause/resume;
- C2 refusal for Product commercial/source presentation/readiness writes;
- inactive/archived/NONE member refusal;
- cross-tenant and cross-Client not-found behavior;
- dual-role and impersonation isolation;
- exact-organiser workflow action remains unavailable to an ordinary manager/admin where
  later workflow evidence requires the organiser; and
- no routine C1 publication path remains exposed by the aligned Store router.

### 12.4 State and transition matrix

- SETUP, SCHEDULED, OPEN, C2_PAUSED, C1_EXCEPTION_PAUSED, PROJECT_PAUSED,
  PROJECT_INACTIVE, CLOSED_BY_PROJECT_WINDOW, C1_EXCEPTION_CLOSED, BLOCKED and ARCHIVED;
- future DRAFT remains SETUP while future PUBLISHED becomes SCHEDULED;
- exact opening and closing boundary instants;
- standalone and Event-linked Projects;
- C1 pause/release recalculates without forcing OPEN;
- C1 closure/reopen recalculates without bypassing C2 intent;
- pause-to-closure replacement is atomic;
- C2 cannot publish/resume through an active intervention;
- Project end writes no Store closure;
- all existing readiness codes map deterministically;
- payment, commission, Product, media, delivery and later-workflow blockers retain their
  owning authority; and
- fail-closed behavior for impossible persisted shapes.

### 12.5 Event, concurrency and rollback

- Event defaults become explicit Project values;
- narrower Project windows pass;
- outside-envelope creation/update fails;
- widening Event dates succeeds without Project writes;
- narrowing across a Project fails with bounded affected-Project evidence and no cascade;
- same-target retries are idempotent;
- conflicting intervention requests serialize;
- duplicate operation keys replay safely and conflicting reuse fails;
- injected failure after each mutation stage rolls back state, intervention and audit; and
- no partial pause-release/closure replacement survives.

### 12.6 A7 and regression

- A7 initial submission and retry accept only effective OPEN;
- every other effective state refuses before Commerce/provider mutation;
- no real Stripe network call or charge;
- Commerce A1-A7 static/service regressions;
- FUND C1-C6, 1R-D, 1Q-E/1Q-F, K1-F/K2 and R3 regressions;
- production build; and
- zero prefixed test residue.

## 13. Explicit Exclusions

E-A does not add:

- C1 Store portfolio UI or exceptional-action UI (`1R-E-B`);
- C2 Project Store UI (`1R-E-C`);
- public Store/Checkout/return routes or UI (`1R-F` and later);
- Product, Catalogue, price, tax or commercial editing;
- Application/Artwork Template management;
- collective artwork composition/approval or Store Product presentation-release workflow;
- upload, scanning, storage or media processing;
- Order operations, confirmation, Order Code or email;
- real Stripe configuration, Session creation or provider action;
- production, fulfilment or dispatch;
- commission calculation, recognition, statements or settlement;
- Store-specific trading dates or Event-to-Project date cascade; or
- unrelated LMSPro behavior.

## 14. Acceptance Gate

Review must confirm:

1. the intervention model is the minimum durable evidence and cannot be bypassed by Store
   status writes;
2. C2 intent, C1 intervention and effective state remain distinct;
3. C1 is not restored as routine publication authority;
4. C2 member/Client/Project/Store ownership is exact and tenant-safe;
5. Project activation/pause/resume closes the current C2 operating gap without broadening
   close/archive authority;
6. Event defaults are explicit and later Event edits reject rather than cascade;
7. PAUSED retains only C2 intent and CLOSED is safely retired;
8. state precedence, blocker ownership and allowed actions are deterministic;
9. A7 consumes the same fail-closed availability policy;
10. migration preflight/backfill/rollback is non-inferential and non-destructive;
11. concurrency, idempotency, audit and retention are database- and service-enforced; and
12. no E-B/E-C/public Store, artwork, production, commission or UI behavior has leaked
    into E-A.

Acceptance authorises only the bounded E-A implementation described here. It does not
authorise E-B, E-C, 1R-F or any other slice. The completed independent review is recorded
in section 16.

## 15. Single Bounded Review Prompt

```text
Review only FUND Phase 1 Slice 1R-E-A Store Authority, Exceptional Intervention And
Lifecycle Service Alignment Implementation Planning. Do not implement schema or
application code and do not begin 1R-E-B, 1R-E-C, 1R-F, artwork/template implementation,
production, commission or another slice.

Verify the plan against the accepted 1R-E parent, completed 1Q-E/1Q-F, C1-C6, 1R-D,
K1-F/K2, R3-D, Commerce A1-A7 and the current 140-migration Prisma/PostgreSQL contract.
Resolve any conflict in the bounded intervention enums/model; same-tenant Store/Project/
actor ownership; one-active intervention and idempotency evidence; C2 Store intent versus
C1 pause/release and closure/reopen; PAUSED/CLOSED compatibility; C2 Project activation and
normal Store authority; Event defaults and non-cascading envelope guards; effective-state
precedence, blockers and allowed actions; serializable locking, audit, deletion/retention;
A7 non-trading consumption; migration preflight, zero backfill, rollback and disposable
validation.

Confirm E-A adds schema and internal service authority only. It must add no C1/C2 UI,
public Store/Checkout route, real Stripe action, Product/Catalogue commercial editor,
artwork/template workflow, upload, Order operations, production, fulfilment or commission
behavior, and it must not use mutable metadata as authority.

If acceptable, mark only E-A accepted and provide its single bounded implementation
prompt. Make no Prisma, migration, service, router, route, provider, storage or UI change
during review.
```

## 16. Independent Review And Acceptance Outcome

Review result: accepted on 2026-07-15 after reconciliation against the current
140-migration schema and implemented 1R-D, C2 Client-dashboard, Event and A7 services.

The review resolved the following points before acceptance:

- the existing Store `PAUSED` value remains C2 intent, while C1 pause/closure is a separate
  typed and retained overlay;
- Store `CLOSED` and `closedAt` are retired through preflight plus a database check, with no
  inferred intervention or destructive backfill;
- pause-to-closure replacement records `SUPERSEDED_BY_CLOSURE`, not a false normal release;
- start and resolution operations have separate durable idempotency evidence;
- the effective-state precedence distinguishes future DRAFT setup from a published
  scheduled Store and distinguishes paused from closed/completed Projects;
- the legacy mutable `FundProject.lifecycleState` is not authorization evidence;
- C2 alignment includes exact Client-scoped Project Product selection, Store preparation,
  server refresh, Store copy, ordering/visibility and normal lifecycle actions, while
  Product commercial/source presentation/readiness evidence remains C1/server-owned;
- Event-linked defaults become explicit Project values and Event narrowing rejects linked
  Project conflicts without cascade;
- local Seller Profile and A6-B connected-account evidence join Store readiness without a
  Stripe network call; and
- initial A7 submission and payment retry consume the same effective availability policy.

No unresolved business or technical decision blocks this bounded implementation. Review
made no Prisma, migration, service, router, route, provider, storage or UI change.

## 17. Single Bounded Implementation Prompt

```text
Continue only accepted FUND Phase 1 Slice 1R-E-A. Do not begin 1R-E-B, 1R-E-C, 1R-F,
artwork/template implementation, production, commission or another slice.

Starting from the committed application baseline containing Commerce A1-A7 and the
complete 140-migration history, implement only the accepted Store Authority, Exceptional
Intervention And Lifecycle Service Alignment in the current Prisma schema, one migration
and the bounded internal FUND services.

Add only the accepted Fund-prefixed intervention/effective-state enums,
FundProjectStoreIntervention, exact Organization/User/Project/Store reverse relations and
the accepted checks, indexes, partial uniqueness, immutable-resolution/deletion triggers
and Store CLOSED/closedAt retirement constraint. Apply zero semantic backfill. If any
Store uses CLOSED or closedAt, fail preflight without changing or deleting data.

Keep existing PAUSED as C2 intent. Implement typed C1 exceptional pause/release and
closure/reopen, including truthful pause supersession by closure and separate start/
resolution idempotency. Implement exact C2 VIEWER reads and PROJECT_MANAGER/ADMIN Project
activation/pause/resume, safe Project Product selection, Store prepare/refresh/copy/
ordering/visibility and publish/pause/resume through exact tenant/Client/Project/Store
ownership. Do not expose Product commercial/source presentation/readiness writes to C2 and
do not retain routine C1 Store publication authority.

Implement one fail-closed effective-state/readiness/allowed-action policy with the accepted
precedence, Event default/envelope rules, local Seller/A6-B payment-readiness evidence,
serializable Project locking, transactional audit and redaction. Make dormant A7 initial
submission and failed/expired retry consume that same policy before Commerce/provider
mutation. Treat FundProject.lifecycleState and mutable metadata as non-authoritative.

Add no C1/C2 UI, public Store/Checkout route, real Stripe call, Product/Catalogue
commercial editor, artwork/template workflow, upload, Order operations, production,
fulfilment or commission behavior.

Use only TEST_DATABASE_URL after proving it differs from DATABASE_URL. Complete the
representative 140-to-141 migration, fresh replay, preflight refusal, rollback-before-
evidence proof, every planned tenant/actor/intervention/idempotency/status/Event/state/
readiness/action/concurrency/rollback/A7 constraint and service test, A1-A7/C1-C6/1R-D/
1Q-E/1Q-F/K1-F/K2/R3 regressions, Prisma validation/generation, production build and zero
test residue. Do not modify shared development, staging or production databases.

After successful validation, create separate E-A implementation-confirmation and
review/test records, update the FUND, strategic, Commerce and root roadmaps plus planning
README, and stop. Do not start E-B or E-C.
```
