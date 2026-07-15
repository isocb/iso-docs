# FUND Phase 1 Slice 1R-E - C1 Store Oversight And C2 Project Store Control Alignment Planning

Date: 2026-07-15

Status: Parent reviewed and accepted; no child planning or implementation authorised

Authoritative controls:

- `docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`
- `docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`
- `docs/modules/fund/00-roadmap-control/2026-07-15-fund-store-artwork-orders-and-production-strategic-completion-roadmap.md`

Completed dependencies:

- FUND `1Q-E`/`1Q-F` Product eligibility and Project Product selection;
- FUND `1R-C1` through `1R-C6` Store, asset, commission and Commerce-context schema;
- FUND `1R-D` Store readiness/configuration/lifecycle services;
- Project Intake/creation `1P-G-R3-A` through `R3-D` and C2 Client dashboard/K2;
- Commerce `A1` through `A7`, including the dormant FUND consumer transaction boundary.

Governed refinements:

- `docs/modules/fund/01-cr-inputs/2026-07-15-fund-application-artwork-template-refinement.md`
- `docs/modules/fund/01-cr-inputs/2026-07-15-fund-project-product-selection-limits-and-template-capacity-cr.md`
- `docs/modules/fund/01-cr-inputs/2026-07-15-fund-collective-project-artwork-composition-approval-and-workflow-aware-product-instructions-remedial-clarification.md`

## 1. Goal

Align the implemented Store service authority with the accepted Project-centred operating
model before exposing Store operations through either C1 or C2 UI.

The intended boundary is:

```text
C1 defines and supplies the commercial/Product/readiness envelope
-> C2 configures and controls its Project Store within that envelope
-> Project dates and lifecycle determine whether trading is currently possible
-> C1 sees every Store and may perform supplier-side actions
-> C1 exceptional intervention is explicit, reasoned and audited
```

This is not a renamed C1 Store-management UI slice. The current C1-only `1R-D` authority
must be corrected first; UI must consume the corrected server contract rather than
recreating authority in client code.

## 2. Accepted Business Authority

### 2.1 Store, Project and Event

1. A Store belongs to exactly one Project.
2. The Store has no independent opening or closing date-times.
3. The Project's explicit `opensAt` and `closesAt` are the Store trading window.
4. A linked Event provides the outer permissible date envelope only.
5. When an Event-linked Project is created, the Event opening and closing instants prefill
   the Project dates by default.
6. Those defaults are copied into explicit Project dates and remain editable by authorised
   C2 members, subject to the Event envelope; the Project may use narrower dates.
7. An Event-date edit does not cascade into existing Project dates.
8. An Event-date edit must not silently leave linked Projects outside the accepted Event
   envelope; the service must reject the change and identify the affected Projects for
   remediation.
9. Reaching the Project closing instant makes the Store non-trading without writing a
   second Store close date or requiring a Store lifecycle mutation.

### 2.2 C2 normal authority

An active same-tenant C2 Client member with `PROJECT_MANAGER` or `ADMIN` access may, for a
Project owned by that exact Client:

- view Store configuration and readiness;
- prepare or refresh the Project Store where safe;
- edit C2-owned Store fundraising copy;
- manage the Project's eligible Product selection through the accepted Product-selection
  contract;
- control allowed Store Product ordering/visibility without changing C1 commercial or
  release evidence;
- accept the exact commission offer through the separate accepted commission contract;
- provide or approve workflow evidence assigned to C2, including exact-organiser approval
  where required; and
- perform normal enable/publish, pause and resume actions after server readiness checks.

C2 authority is Client/Project scoped. It never derives from organiser-name/email
snapshots, a caller-supplied tenant/Client ID or a public Store identifier.

### 2.3 C1 normal authority

C1 is the seller, supplier and fulfilment operator. C1 normally:

- owns Product identity, price, tax, Product media and Catalogue eligibility;
- owns Application Template design/capacity where applicable;
- creates collective Project artwork where applicable;
- releases or holds Store Product presentation/mock-up evidence where required;
- diagnoses all Store and Store Product readiness across the tenant;
- sees Project, Store, Product, payment-readiness and blocking evidence; and
- provides remediation through the owning Product, Event, Project, artwork or payment-
  settings surface.

C1 is not the routine moderator of C2 Store publication and must not be introduced as an
ordinary approval gate.

### 2.4 C1 exceptional authority

C1 retains exceptional pause, resume and closure authority for legal, payment, safety or
seller-of-record intervention.

Every exceptional action must:

- require C1 `OWNER` or `ADMIN` authority;
- require a bounded reason category and a nonblank operator note;
- record actor, tenant, Project, Store, previous effective state and timestamp;
- be tenant-safe and transactionally audited;
- be visible to the affected C2 Store operators without exposing internal-only notes;
- prevent C2 from bypassing an active C1 intervention; and
- distinguish C1 release of an exceptional pause from C2's normal resume action.

C1 exceptional resume releases a C1 pause. It must not force the Store into trading when
C2 intent, Project status, Project dates or readiness still prevent trading. Exceptional
closure is a stronger C1 intervention but is reversible by a separate, explicit and
audited C1 reopen action in case of operator error or a later legitimate decision. C2
cannot reopen it. Ordinary end-of-window closure remains a derived Project outcome and
must not use exceptional closure.

## 3. Research Findings Requiring Remediation

The current implementation is safe for its accepted `1R-D` boundary but does not express
the revised operating authority:
1. `fund.storeManagement.*` currently accepts only C1 `OWNER`/`ADMIN` actors. 
2. Store publish, pause, resume, close and archive are therefore C1-only.
3. C2 `PROJECT_MANAGER`/`ADMIN` members can edit Project basics and dates but cannot use
   the current Project activate/pause/close procedures.
4. Store readiness requires Project `ACTIVE`, so C2 cannot complete the normal operating
   path without C1 under the current router contract.
   This is a finding about the current implementation, not the accepted business model:
   C2-created Projects start `DRAFT`; the C2 Client dashboard exposes create/update only;
   the existing activate/pause/close router is C1-only; and `1R-D` rejects publication
   unless the Project is `ACTIVE`. E-A must remove that accidental dependency on C1 by
   granting exact C2 Project lifecycle actions through the Client-owned contract.
5. `FundProjectStoreStatus.PAUSED` does not distinguish a C2 voluntary pause from a C1
   exceptional hold.
6. A single mutable status plus generic audit rows cannot safely prevent C2 from resuming a
   C1 hold or restore the prior C2 intent when C1 releases it.
7. `FundProjectStoreStatus.CLOSED` is currently irreversible and must not be written merely
   because the Project close instant has passed.
8. Event updates validate their own dates but do not currently guard linked Project dates
   against a newly narrowed Event envelope.
9. existing UI copy still refers to future Store-specific close dates, which conflicts
   with Project-date authority.

No C1 or C2 Store UI should be considered operational until the first child slice resolves
these service and evidence gaps.

### 3.1 Remediation mapping

| Current blocker | Required E-A remedy |
| --- | --- |
| C1-only Store router | Split C1 oversight/intervention from exact Client-scoped C2 Store procedures while retaining one server policy |
| C2 cannot make a DRAFT Project operational | Permit C2 `PROJECT_MANAGER`/`ADMIN` to activate its own valid Project and to pause/resume it; ordinary Store ending remains date-derived |
| Ambiguous Store `PAUSED` status | Persist typed C1 intervention separately from C2 Store intent |
| Existing irreversible Store `CLOSED` | Stop using it for date expiry; model exceptional closure and audited C1-only reopen explicitly |
| Event narrowing may invalidate Projects | Reject the Event edit with affected-Project evidence; never cascade Project dates |
| Stale Store-specific-date UI copy | Replace it with Project-window and Event-envelope language in the relevant UI child |
| Public/A7 availability checks know only the old status | Make them consume the same effective availability policy before a public route is activated |

These blockers prevent safe UI implementation, not E-A implementation. E-A exists to
remove them through one independently planned, reviewed and tested schema/service
lifecycle before E-B or E-C starts.

## 4. Effective Store State

The UI and public Store must eventually consume one server-derived state, not infer it
from timestamps independently.

```text
C2 Store intent
+ C1 exceptional intervention
+ Project lifecycle
+ Project date window
+ Store/Store Product readiness
= effective Store state and allowed actions
```

Required effective states or equivalent typed output include:

```text
SETUP
SCHEDULED
OPEN
C2_PAUSED
C1_EXCEPTION_PAUSED
PROJECT_PAUSED
CLOSED_BY_PROJECT_WINDOW
C1_EXCEPTION_CLOSED
BLOCKED
ARCHIVED
```

`BLOCKED` means the Store cannot be enabled or trade because one or more exact readiness
requirements fail. Examples include an absent/ineligible Product, missing price/tax/media,
missing or rejected artwork approval, a held Store Product presentation, missing commission
acceptance, absent delivery evidence or payment settings not ready. It is not a generic
manual decision: the response must include stable reason codes, the responsible actor and
the remediation destination. `SETUP` covers ordinary unfinished preparation before a
publish attempt; E-A must define deterministic precedence when several conditions coexist.

These are service/read-model concepts at parent-plan level. A child schema review must
decide the minimum persisted intervention vocabulary. The implementation must not store
derived time-window states as mutable status merely to simplify UI.

Rules:

- future Project opening gives `SCHEDULED`, not a readiness failure;
- `now >= Project.closesAt` gives `CLOSED_BY_PROJECT_WINDOW` without changing Store dates;
- Project `PAUSED`, `CLOSED`, `COMPLETED` or `ARCHIVED` prevents trading;
- an active C1 exceptional pause overrides C2 publish intent;
- C2 cannot resume an active C1 exceptional pause;
- C1 exceptional resume removes only the C1 hold and then recalculates effective state;
- C1 exceptional closure may be reopened only by a separate audited C1 action; and
- Store readiness never bypasses Product, commission, artwork, delivery, payment or
  Project authority.

## 5. Configuration And Presentation Ownership

The corrected service contract must maintain a field/action matrix rather than treating
all Store configuration as either C1- or C2-owned.

| Capability | Normal authority | Boundary |
| --- | --- | --- |
| Product identity, price, tax, source media and Catalogue eligibility | C1 | C2 cannot override source commercial evidence |
| Project dates and safe Project basics | C2 `PROJECT_MANAGER`/`ADMIN` | Must remain inside Event envelope |
| Eligible Project Product selection | C2 within C1 rules | Product identity deduplicates multi-Catalogue eligibility |
| Store title, introduction and fundraising objective | C2 | C1 overview is read-only except exceptional support explicitly planned later |
| Store Product ordering/visibility | C2 within released/eligible selection | Cannot expose blocked, ineligible or held Product presentation |
| Store Product commercial snapshot/configuration refresh | Server from C1 source authority | Neither UI supplies hashes, revisions, prices or readiness codes |
| Collective artwork composition | C1 | Separate governed artwork capability |
| Exact collective artwork approval | exact C2 Project organiser | Separate governed artwork capability |
| Store Product presentation/mock-up release or hold | C1 | Separate evidence may be consumed as a readiness gate |
| Commission acceptance | authorised C2 evidence | C1 is not an acceptance substitute |
| Normal Store publish/pause/resume | C2 `PROJECT_MANAGER`/`ADMIN` | Always server-gated |
| Exceptional Store pause/resume/closure | C1 `OWNER`/`ADMIN` | Reasoned, audited and visibly exceptional |

Where a later artwork/template child has not yet supplied required evidence, 1R-E may show
the blocker and remediation destination but must not fabricate readiness or absorb the
missing workflow.

## 6. Proposed Bounded Child Sequence

### 6.1 1R-E-A — Store Authority, Exceptional Intervention And Lifecycle Service Alignment

First and blocking child. Plan and implement only after its own explicit review.

It must:

- plan and add the minimum typed persistent C1 intervention evidence because the current
  schema cannot preserve actor/reason/active-release/closure/reopen semantics safely;
- avoid mutable metadata as an authorization source;
- split exact C1 and C2 actor resolution while retaining one server policy;
- add same-tenant Client/member/Project/Store checks for C2 access;
- align normal C2 Store and required Project lifecycle actions;
- preserve exact-organiser-only actions where the governed workflow requires them;
- prevent C1 routine publication from remaining the default path;
- guard Event-window edits without cascading Project dates;
- return one effective state, blockers, action permissions and public-safe intervention
  explanation;
- retain serializable Project locking, readiness recalculation, idempotency and audit;
- update A7/public-checkout authority only if needed to consume the same effective Store
  availability predicate, without activating a route; and
- add no C1/C2 Store UI.

E-A therefore requires one bounded schema migration. Its planning review must define a
non-inferential backfill/preflight for any existing non-live FUND Store test rows, use the
retained disposable database and keep schema/service implementation under one separately
accepted E-A plan.

### 6.2 1R-E-B — C1 Store Portfolio Oversight And Exceptional Intervention Surface

Begins only after E-A completes its lifecycle.

Candidate scope:

- tenant-wide Store table with Project, Client, Event, effective state, Project window,
  Product/readiness counts and payment-readiness summary;
- search/filter/sort and Project Store drill-down;
- immutable configuration-version and blocking-evidence inspection;
- links to Product, Event, Project, artwork and Stripe settings remediation;
- C1 supplier-side release/hold actions only where an accepted underlying service exists;
- exceptional pause, release/resume, closure and C1-only reopen with confirmation and
  reason; and
- no routine C1 publish action.

### 6.3 1R-E-C — C2 Project Store Control Surface

Begins only after E-A completes; it may follow E-B or be separately selected by the
authoritative roadmap.

Candidate scope:

- Store tab in the existing C2 Client Project detail route;
- Project dates with linked Event boundary explanation;
- Store copy and allowed Product ordering/visibility;
- selected Product and workflow/readiness summary;
- commission acceptance and artwork/presentation readiness status with bounded links;
- normal publish/enable, pause and resume actions based on server permissions;
- clear scheduled, Project-closed and C1-intervention states; and
- no exposure of C1 internal notes, cross-Client Store identities or commercial controls.

Each child requires its own `03 -> implementation -> 04 -> 05 -> roadmap` lifecycle. Parent
acceptance does not authorise any child implementation.

## 7. Access And Security Contract

All children must preserve:

- session-derived tenant and user identity;
- C1 `OWNER`/`ADMIN` for tenant-wide overview and exceptional intervention;
- active, unarchived `FundClientMember` with dashboard access for C2;
- C2 `VIEWER` as read-only where a Store read is allowed;
- C2 `PROJECT_MANAGER`/`ADMIN` for normal mutation;
- exact same-tenant member/Client/Project/Store ownership;
- not-found behavior for cross-tenant and cross-Client identifiers;
- no caller-supplied `organizationId`, authoritative readiness, status, price, tax,
  version, hash or actor;
- Project-scoped advisory locks and serializable lifecycle mutations;
- action-specific authorization repeated inside the locked transaction; and
- redacted audit metadata and C2-safe error responses.

Impersonation and dual-role behavior must use the established effective actor/tenant
contract. A C1 user who also has a C2 membership must not gain C2 Project authority merely
from the C1 role, or vice versa.

## 8. Readiness And Action Contract

The E-A service must return stable machine codes plus allowed actions. UI does not invent
business logic.

Additional parent-level blocker/action concepts include:

```text
EVENT_WINDOW_CONFLICT
PROJECT_NOT_ACTIVE
PROJECT_NOT_OPEN
PROJECT_WINDOW_ENDED
C1_EXCEPTION_PAUSE_ACTIVE
C1_EXCEPTION_CLOSED
C2_COMMISSION_ACCEPTANCE_REQUIRED
STORE_PRODUCT_RELEASE_REQUIRED
WORKFLOW_READINESS_REQUIRED
PAYMENT_SETTINGS_NOT_READY
```

The exact code set belongs in E-A review and must preserve existing 1R-D codes or provide
an explicit compatibility mapping. Human copy remains a UI concern, but every blocker must
identify whether C1, C2, time or a later governed workflow can resolve it.

## 9. Parent Validation Expectations

### 9.1 E-A service/schema proof

- exact C1/C2 tenant and Client/Project isolation;
- C2 viewer versus Project manager/admin permissions;
- C2 normal publish/pause/resume and forbidden exceptional actions;
- C1 overview and exceptional pause/release/closure/reopen, with required reasons;
- C2 cannot bypass a C1 intervention;
- C1 release recalculates rather than forces OPEN;
- Project future/open/ended and paused/closed/completed/archived effective states;
- Event envelope narrowing rejects affected Projects and never cascades dates;
- standalone Project behavior;
- Store readiness and commission acceptance remain mandatory;
- A7 checkout/retry refuses every non-trading effective state;
- concurrency, idempotency, rollback and transactional audit;
- no cross-tenant or cross-Client data leakage;
- current 140-migration baseline plus any separately accepted E-A migration;
- A1-A7, C1-C6, 1R-D, K1-F/K2 and R3 regressions; and
- zero disposable test residue.

### 9.2 E-B/E-C browser proof

- C1 sees all and only tenant Stores;
- C2 sees all and only Stores for its active Client memberships;
- viewer and mutation roles render correctly and remain server-enforced;
- date and effective-state copy matches the server result at boundary instants;
- blockers identify the responsible actor and remediation path;
- destructive/exceptional actions require confirmation and accessible reason input;
- C1 internal notes are absent from C2 responses and UI;
- desktop/mobile, keyboard, focus, loading, empty, error and stale-mutation behavior;
- no public Store/Checkout UI activation; and
- human C1 and C2 staging smoke before later promotion.

All database-writing tests use only `TEST_DATABASE_URL` after proving it differs from
`DATABASE_URL`. No shared development, staging or production database is modified during
slice implementation/testing unless a later separately controlled promotion explicitly
authorises it.

## 10. Explicit Exclusions

1R-E does not implement:

- the public Store or public checkout/return pages (`1R-F` and later);
- real Stripe configuration or provider action;
- Product price/tax/Catalogue management already owned by C1 surfaces;
- the complete Application Template or Artwork Template manager;
- collective artwork composition, approval or Store Product release persistence not yet
  supplied by an accepted child;
- upload, malware scanning or artwork intake;
- Order confirmation, Order Code or email;
- Order operations, production, fulfilment or dispatch;
- commission calculation, accrual, statements or settlement;
- automatic Event-to-Project date propagation;
- Store-specific opening or closing date fields; or
- unrelated LMSPro work.

## 11. Documentation And Delivery Control

Before each child implementation:

1. create the bounded child implementation plan;
2. review it against current schema/code and this accepted parent;
3. mark only that child accepted;
4. implement and validate only the accepted boundary;
5. create separate implementation-confirmation and review/test records;
6. update the FUND, strategic and root roadmaps plus planning README; and
7. stop before the next child unless explicitly authorised.

Before any promotion, re-read the IsoStack controlled-promotion documents and follow the
recorded branch, migration, staging-health and human-smoke gates.

## 12. Parent Review Gate

Review must confirm:

1. ordinary Store control belongs to C2, not C1;
2. C1 retains only supplier-side normal authority and exceptional audited intervention;
3. exceptional pause/release and closure/reopen cannot be represented ambiguously or
   bypassed by C2;
4. Project dates remain the only Store trading dates;
5. Event dates constrain but never cascade into Project dates;
6. ordinary Project-window ending is not written as exceptional Store closure;
7. the current C1-only 1R-D and Project lifecycle boundaries are remediated before UI;
8. configuration, artwork, release and commission authorities remain separate;
9. E-A, E-B and E-C are individually bounded lifecycle units; and
10. no public Store, checkout UI, artwork workflow, production or commission behavior has
    leaked into the parent.

The completed review outcome is recorded in section 14. Parent acceptance authorises only
creation and review of an E-A implementation plan; it does not authorise E-A implementation.

## 13. Review Prompt Used

```text
Review only FUND Phase 1 Slice 1R-E C1 Store Oversight And C2 Project Store Control
Alignment Planning. Do not implement schema or application code and do not begin 1R-E-A,
1R-E-B, 1R-E-C, 1R-F, artwork/template implementation, production, commission or another
slice.

Verify the parent against completed 1Q-E/1Q-F, C1-C6, 1R-D, K1-F/K2, R3-D, Commerce A1-A7,
the current 140-migration Prisma/PostgreSQL contract and the three governed 2026-07-15 CRs.
Resolve any conflict in C2 normal Project Store authority, C1 supplier-side oversight,
audited exceptional C1 pause/resume/closure, Project and Event date authority, effective
Store state, Project lifecycle, Store copy/Product presentation ownership, exact Client
member/organiser permissions, readiness/action codes, A7 availability and the E-A/E-B/E-C
delivery boundaries.

Confirm Event dates are an outer envelope with no automatic Project cascade; Project dates
are the only Store trading dates; ordinary Project-window ending is not exceptional Store
closure; C1 is not a routine publication moderator; and no UI may expose the current C1-
only lifecycle contract before E-A alignment.

If acceptable, mark only the 1R-E parent accepted and provide the single bounded 1R-E-A
planning prompt. Make no Prisma, migration, service, router, route, provider, storage or UI
change during review.
```

## 14. Independent Review And Acceptance Outcome

Review result: accepted as the non-executable 1R-E parent on 2026-07-15.

The review reconciled the parent against the current 140-migration schema, implemented
`1R-D` router/service, C2 Client dashboard and Project services, A7 Store checkout boundary
and the three governed CRs. It confirmed:

- the current C1-only Store and Project lifecycle routes are implementation facts that E-A
  must correct, not accepted business authority;
- Event-linked Project creation should prefill explicit Project dates from the Event, while
  C2 may narrow those dates and later Event edits never cascade;
- Event edits that would invalidate linked Project envelopes must fail with affected-
  Project evidence;
- C2 `PROJECT_MANAGER`/`ADMIN` is the normal Project Store mutation authority, while exact-
  organiser-only approval remains separate where a workflow requires it;
- C1 owns supplier/commercial/release authority and tenant-wide oversight, not routine
  Store publication moderation;
- C1 exceptional pause/release and closure/reopen require typed durable evidence separate
  from C2 Store intent; C2 can never release or reopen a C1 intervention;
- Project dates are the only Store trading dates, and passing `Project.closesAt` is a
  derived non-trading state rather than a Store closure mutation;
- `BLOCKED` is a reason-coded effective state for failed readiness authority, including
  Product, commercial, media, artwork approval/release, commission, delivery or payment-
  readiness failures;
- A7/public availability must consume the same effective-state policy before any route is
  activated; and
- E-A service/schema alignment, E-B C1 oversight UI and E-C C2 Project Store UI remain
  separate bounded lifecycles.

No unresolved business decision blocks creation of the E-A implementation plan. This
acceptance adds no Prisma, migration, service, router, route, provider, storage or UI
change and authorises no E-A implementation.

## 15. Single Bounded 1R-E-A Planning Prompt

```text
Continue only accepted FUND Phase 1 Slice 1R-E-A planning. Do not implement schema or
application code and do not begin 1R-E-B, 1R-E-C, 1R-F, artwork/template implementation,
production, commission or another slice.

Create one bounded Store Authority, Exceptional Intervention And Lifecycle Service
Alignment implementation plan against the accepted 1R-E parent, completed 1Q-E/1Q-F,
C1-C6, 1R-D, K1-F/K2, R3-D, Commerce A1-A7 and the current 140-migration
Prisma/PostgreSQL contract.

Resolve the minimum typed persistent evidence needed to keep C2 Store intent separate from
C1 exceptional pause/release and closure/reopen; exact C1 and C2 actor/tenant/Client/
Project/Store ownership; C2 PROJECT_MANAGER/ADMIN activation and normal Project Store
publish/pause/resume authority; C2 VIEWER reads; exact-organiser-only workflow actions;
Event-date defaulting and non-cascading envelope guards; one server-derived effective Store
state and allowed-action contract; reason-coded readiness ownership; serializable locking,
idempotency and audit; compatibility or retirement of the current PAUSED/CLOSED semantics;
and A7 checkout/retry consumption of the same non-trading policy.

Plan no C1 or C2 UI. Add no public Store/Checkout route, real Stripe action, Product/
Catalogue commercial editor, artwork/template workflow, upload, Order operations,
production, fulfilment or commission behavior. Do not use mutable metadata as authority.

Define one bounded migration, non-inferential backfill/preflight and rollback for the typed
intervention evidence, and define disposable PostgreSQL validation for the complete
baseline, C1/C2 isolation,
Project/Event boundaries, every intervention/effective-state transition, concurrency,
rollback, A1-A7/C1-C6/1R-D/K2/R3 regressions and zero residue.

Leave the new E-A implementation plan awaiting explicit review and acceptance and provide
its single bounded review prompt. Make no Prisma, migration, service, router, route,
provider, storage or UI change.
```
