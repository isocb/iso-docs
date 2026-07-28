# LMSPro Remediation Slice R9-A1 Admission Evidence And Derived Participation Compatibility Planning

Date: 2026-07-28

Module: LMSPro / SeasonPro

Status: ACCEPTED PLAN — next exact control may commence one-branch R9-A1 implementation
and STAGING validation; R9-A2 reconciliation execution is not authorised

Parent lifecycle:

```text
R9-A - Club Admission And Seasonal Participation
```

Accepted evidence boundary:

```text
R9-A0 - Club Participation Writer, Consumer And Live-State Inventory
```

Controlling IsoDocs commit:

```text
c7667754d42f2fb6ca115e3c2dbf9c6c4154cc4c
```

Application and deployment recovery baseline:

```text
df40f45cda955ef00e8f790de89a476c2463a629
```

STAGING evidence target:

```text
credential-safe fingerprint d18b9abe1450
latest expected migration 20260722120000_lmspro_r8_a3_email_delivery_jobs
```

R9-A0 evidence:

`docs/modules/lmspro/05-review-and-test/2026-07-27-lmspro-r9-a0-static-writer-consumer-and-live-state-inventory-evidence.md`

## 1. Decision And Recommendation

R9-A0 is formally accepted as sufficient for successor planning. It does not authorise an
application, schema, migration, data, notification, environment, deployment or production
change.

Use one application-remediation slice on one branch for admission evidence, the derived
participation evaluator, prospective writers, consumer alignment and Notification Manager
integration. Keep existing-data reconciliation as one separately approved execution step.
Defer constraint and legacy cleanup indefinitely unless evidence later shows it is needed.

```text
R9-A1 application remediation
-> one branch
-> additive migration and application change
-> notifications off

R9-A2 controlled data reconciliation
-> dry-run
-> separate execution approval
-> notifications suppressed
```

The application and data actions retain different recovery gates, but they do not need
seven separate development lifecycles. Formal control has accepted the exact R9-A1 plan.
The next exact commencement prompt may authorise its implementation and STAGING validation;
R9-A2 execution still requires separate approval after review of its dry-run.

## 2. Accepted Business Contract

1. An accepted or imported Club remains Registered even when it has no allocated Teams.
2. One same-tenant, same-season `CURRENT` Team with a valid same-tenant, same-season
   division/AGG allocation is sufficient to make the Club Current.
3. When the last qualifying Team ceases to qualify, the Club returns to Club Waiting List
   while retaining onboarding, officials, C2 access and Team-request capability.
4. Unallocated Teams remain a distinct allocation-work state, are excluded from Current
   counts and do not become Team Waiting List automatically.
5. Team Waiting List always requires a deliberate authorised league decision.
6. Suspended and withdrawn Club states remain explicit overrides.
7. `ClubStatus.APPROVED` remains the compatibility representation of Current during the
   transition.
8. A real Club Current/Waiting List transition may use the existing Notification Manager.
   User-triggered CRUD retains its existing notification control; automatically derived
   behaviour falls back to the manager's master and per-event controls.
9. Re-evaluation without a category change, evidence collection and dry-run do not notify.
10. Bulk reconciliation notification behaviour requires separate explicit approval.
11. The pre-1 June 2026 Derby JFL Club cohort is accepted for planning as
    control-owner-attested legacy Knack imports, not as automated row-level import evidence.
12. This is the first operational season; no closed-season history rewrite is required.

## 3. Current Constraints Established By Evidence

### 3.1 Model and writer constraints

- `LMSProClub.status` currently carries admission, participation and operational meanings.
- `LMSProTeam.status` defaults to `CURRENT`, while `aggId` remains nullable.
- no route-neutral admission authority exists on or beside the Club;
- form Applications provide the strongest retained approval evidence;
- import and direct-C1 evidence is uneven;
- import, Application and direct-C1 writers do not share one transaction contract;
- generic Team edits can clear allocation without clearing `CURRENT`;
- existing composite relations do not enforce all same-tenant/same-season invariants; and
- current access and Team-request paths sometimes use raw Club status.

### 3.2 STAGING evidence constraints

The accepted tenant/season aggregate contains:

- 61 Clubs and 400 Teams;
- 59 raw `APPROVED`, 1 raw `WAITING_LIST` and 1 `WITHDRAWN` Club;
- 355 `CURRENT`, 40 deliberately `WAITING_LIST` and 5 `CANCELLED` Teams;
- 7 `CURRENT` Teams without allocation;
- 9 `APPROVED` Clubs without a qualifying Team;
- 55 Clubs without automated accepted-route evidence;
- 17 Clubs without a primary official;
- 5 Clubs with a primary official but no active Club role;
- 400 valid Team-to-Club/age-group relations; and
- 40 Team Waiting List records with detected deliberate-decision evidence.

The control-owner attestation explains the 55-Club cohort for planning but does not provide
row-level automated provenance. STAGING is similar to live and must not be represented as
production evidence.

### 3.3 Notification constraints

The current Notification Manager already provides:

- a platform-default template with tenant overrides;
- editable subject, HTML, text and recipient routing;
- a master pause/resume operation;
- a per-event pause/resume operation; and
- tenant-scoped audit of settings changes.

Current source also creates an important safety constraint:

- a newly registered event with no tenant setting is treated as enabled;
- an all-paused tenant is protected when every existing setting is paused;
- ordinary sends are fire-and-forget and have no durable delivery/idempotency record; and
- the Team update/allocation writers already expose actor-selected notification controls.

A new automatic participation event must therefore not rely on the present missing-row
default. It needs an explicitly reviewed safe default and must not send until idempotency,
recipient and delivery evidence are accepted.

## 4. Exact Accepted Boundary

### Included

- one additive append-only admission/provenance relation and migration;
- a side-effect-free named-cohort participation evaluator;
- compatibility behaviour for legacy `ClubStatus`;
- prospective writer transaction and retry implementation;
- ordered consumer alignment;
- two Notification Manager transition events with a safe disabled initial state;
- automated tests, implementation confirmation and technical review;
- a verified STAGING snapshot, additive migration and exact-commit STAGING deployment;
- focused two-route C1/C2 human UI smoke, with import covered by automated integration
  testing instead;
- a tenant/season-bounded R9-A2 reconciliation dry-run that makes no change;
- schema/code/data/deployment ordering;
- recovery point, rollback and forward-recovery design;
- implementation, documentation, STAGING deployment and recovery gates.

### Excluded

- existing-data reconciliation or legacy attestation insertion before separate R9-A2
  execution approval;
- automatic reclassification or status mutation by the additive migration;
- destructive schema change or compatibility cleanup;
- production database queries or mutations;
- production environment or notification change;
- deployment or promotion to `main` or live;
- use of the historic Derby JFL records as human smoke fixtures;
- closed-season rewriting; and
- work outside the accepted R9-A1 application-remediation boundary.

This documentation control update does not itself change application code or schema, create
or apply a migration, query or mutate a database, create, enable or send a notification,
alter an environment or deploy an application. Those bounded R9-A1 actions commence only
under the next exact control prompt.

## 5. Admission And Provenance Representation

### Option A — fields on `LMSProClub`

Add nullable route, admitted-at, actor and source-reference fields directly to the Club.

Advantages:

- simple reads; and
- limited relation count.

Disadvantages:

- one row cannot truthfully retain several evidence routes;
- later corrections overwrite history;
- source-specific fields become sparse and coupled;
- application/import/attestation relationships remain weak; and
- it encourages the Club row to become both business state and audit evidence.

Recommendation: do not select as the primary evidence authority.

### Option B — append-only admission-evidence relation

Add a tenant/season/Club-scoped evidence relation capable of distinguishing:

- validated automated import;
- approved two-stage Application;
- authorised direct-C1 creation; and
- control-owner-attested legacy import.

The relation should retain the evidence type, Club/tenant/season scope, decision/effective
time, recorded time, actor or controlled-system basis, evidence version and an optional
typed source reference. An attestation record must say that automated source evidence is
unavailable; it must not create a synthetic import job.

Evidence should be append-only in ordinary operation. A correction should supersede or
counter-record earlier evidence rather than erase it.

Advantages:

- route-neutral and capable of retaining more than one evidence source;
- clean distinction between automated evidence and human attestation;
- additive and ignored safely by `df40f45c`;
- supports future imports under `LMS-W-IMPORT-01`; and
- provides a durable audit boundary without overloading participation status.

Implementation requirements:

- exact uniqueness and supersession rules;
- typed source relations without cross-tenant linkage;
- deletion/retention behaviour;
- actor identity where the source is a controlled system; and
- privacy-safe metadata constraints.

Option B is accepted for R9-A1. Exact table, column and index identifiers are normal
implementation details, but the migration must preserve the tenant/season/Club scope,
append-only correction semantics, typed evidence source, cross-tenant protection and
old-application compatibility defined here. Any implementation that cannot meet those
invariants must stop and return to control rather than substitute Option A or C.

### Option C — audit/import records only

Continue inferring admission from Application, import mapping and general audit records.

Recommendation: reject as the long-term authority. R9-A0 demonstrated that the three
sources are incomplete and semantically uneven.

## 6. Side-Effect-Free Participation Evaluator

The compatibility foundation should expose one pure, tenant/season-bounded result:

```text
admission:
  ADMITTED | NOT_ADMITTED | EVIDENCE_UNRESOLVED

override:
  NONE | SUSPENDED | WITHDRAWN

participation:
  CURRENT | CLUB_WAITING_LIST | OVERRIDE | UNCLASSIFIED

qualifyingCurrentTeamCount
currentUnallocatedTeamCount
deliberatelyWaitlistedTeamCount
```

The evaluator must:

1. require accepted admission evidence before asserting Registered/admitted;
2. require Team `CURRENT`, existing AGG and same Club/Team/AGG tenant and season for a
   qualifying Team;
3. require at least one qualifying Team for Current;
4. return Club Waiting List for an admitted Club with zero qualifying Teams;
5. preserve suspended/withdrawn overrides;
6. retain unallocated and deliberately wait-listed Team counts separately;
7. perform no write, notification, activation or deactivation;
8. return unresolved rather than guessing from raw `APPROVED`; and
9. be deterministic under retry and concurrent reads.

Within the single R9-A1 branch, the evaluator must first pass tests and shadow/diagnostic
comparison before it is connected to live consumers. Existing-data status convergence
remains excluded from R9-A1 and belongs to the separately approved reconciliation step.

`ClubStatus.APPROVED` may later be maintained as a compatibility projection of Current, but
the evaluator—not the stored status—must become the named source of participation truth.

## 7. Prospective Writer Contract

R9-A1 writer work must converge the three admission routes on one transactional service:

### Validated import

- complete validation first;
- create or match the Club idempotently inside the authorised tenant and season;
- retain import provenance and original source reference;
- record primary-C2 outcome;
- do not set Current merely because import completed; and
- place imported Teams into a non-Current allocation-work state until allocation qualifies.

### Approved Application

- keep email validation separate from admission;
- record admission only on authorised C1 approval;
- create/link the Club, evidence, Team requests and primary C2 under one recoverable
  transaction boundary or compensating protocol; and
- do not classify the Club Current until a Team qualifies.

### Direct authorised C1 creation

- require an explicit admission decision rather than treating row creation as sufficient;
- record actor, tenant, season, time and primary-C2 outcome;
- use the same evidence service as import and Application approval; and
- remain fail-closed on cross-tenant identity or source conflicts.

### Team and allocation writers

- validate Club, Team, age group and AGG tenant/season scope;
- prevent `CURRENT` without a valid allocation;
- preserve unallocated as an explicit allocation-work result;
- require an explicit action for Team Waiting List;
- recompute Club participation after the successful Team mutation;
- protect overrides; and
- emit at most one transition event only after the transaction commits.

These contracts are accepted R9-A1 requirements. Their execution begins only under the next
exact commencement prompt.

## 8. Notification Manager Design

Two separately controllable events are confirmed:

```text
Club became Current
Club returned to Club Waiting List
```

Separate events allow different content, recipients and enablement. Exact event keys are an
implementation detail.

The implementation must:

- register each event in the existing Notification Manager;
- retain the existing actor-selected CRUD notification control where the mutation exposes
  one;
- use Notification Manager as the authority for automatically derived transitions;
- support master and individual pause/resume;
- support platform-default and tenant-custom subject/body/recipient routing;
- default new automatic participation events to `OFF` for existing and new tenants until
  explicit enablement is accepted;
- resolve the current missing-setting-means-enabled behaviour before registering the event;
- emit only after an actual committed category transition;
- emit nothing for no-op evaluation, inventory or dry-run;
- create a stable idempotency key from tenant, season, Club, transition and committed
  transition version;
- retain an auditable accepted/skipped/failed delivery boundary; and
- prevent an application retry from sending the same transition twice.

The default recipient is the single authoritative active primary C2 resolved through the
same-tenant Club-official membership and active LMSPro Club-role contract. An explicit
tenant Notification Manager recipient override remains valid. If the default route has no
single authoritative recipient, skip the send, retain a visible auditable exception and do
not roll back the committed Club category. Never fall back silently to JSON contact data, a
cross-tenant user or an arbitrary address.

Use a small durable participation-transition outbox as the idempotency boundary. Create one
row in the same transaction as the category change with a unique key covering tenant,
season, Club, from-category, to-category and triggering mutation identity. Record
`SUPPRESSED`, `PENDING`, `SENT` or `FAILED`; claim/retry the row idempotently; and pass the
same stable key to the delivery layer where supported. This replaces fire-and-forget for
these two new events only and does not require redesign of every existing notification.

Bulk reconciliation must default to notifications suppressed. Any exception requires a
separate explicit decision covering volume, content, recipient review and recovery. An
email already delivered cannot be rolled back.

## 9. Existing Data Treatment

No existing scoped record is authorised for reconciliation or attestation insertion by
R9-A1. Disposable, tenant/season-bounded STAGING fixtures may be created or updated only by
the scheduled prospective-writer smoke tests and must follow the recorded reset steps.

### 55 legacy Clubs

- treat the cohort as control-owner-attested legacy Knack imports for planning;
- preserve `automated source evidence unavailable`;
- define a separately authorised, row-bounded corroboration and attestation-capture
  procedure;
- do not fabricate import jobs or claim production equivalence; and
- do not switch strict admission-dependent consumers before acceptable evidence coverage
  exists.

### 7 Current/unallocated Teams

- retain as deterministic aggregate contradictions;
- perform a separately authorised row-level review before selecting the correct
  allocation-work status;
- do not convert them to Team Waiting List automatically; and
- do not notify during evidence review or dry-run.

### 9 Approved/no-qualifying-Team Clubs

- derive Club Waiting List only after admission evidence and overrides are confirmed;
- preserve access and Team-request capability;
- do not use the stored status change as an access deactivation trigger; and
- require a reversible, measured reconciliation plan before mutation.

### Primary-C2 concerns

- coordinate with `PLAT-REFINE-02`;
- separate missing membership, inactive account and missing/invalid module-role cases;
- do not create another LMSPro-specific account lifecycle; and
- do not delete/recreate users as a routine repair method.

## 10. Proportionate Delivery Boundaries

### R9-A1 — one application-remediation slice

R9-A1 should be implemented on one feature branch and reviewed as one application change.
It combines the previously proposed R9-A1A through R9-A1E concerns:

- additive route-neutral admission evidence;
- the side-effect-free participation evaluator;
- prospective import, Application, direct-C1, Team and allocation writer alignment;
- access-safe consumer, count, UI, communications, directory, reporting and rollover
  alignment;
- two Notification Manager transition events deployed off; and
- automated tests and a focused C1/C2 STAGING smoke schedule.

The branch may use ordered commits for review and recovery, but it does not require a
separate lifecycle for every internal component.

R9-A1 explicitly excludes:

- bulk or historic Club/Team reclassification as part of migration or deployment;
- legacy attestation insertion;
- reconciliation execution;
- automatic notification enablement;
- destructive schema cleanup; and
- production data action.

Recovery:

- the additive schema remains safe if application code returns to `df40f45c`;
- migration/deployment itself changes no existing status or access record; normal
  user-triggered transitions begin only through the tested R9-A1 writers;
- new prospective evidence can remain safely ignored by the old application;
- notification events remain off; and
- R9-A1 must establish and record an access-safe application baseline before R9-A2 may
  change existing Club statuses.

### R9-A2 — one separately approved data-reconciliation execution

R9-A2 is not a second development programme. It is the controlled execution step for
existing data after R9-A1 passes STAGING.

It consists of:

- a tenant/season-bounded read-only dry-run;
- aggregate and row-count review without unnecessary personal data;
- explicit approval of the exact proposed changes;
- a verified database snapshot immediately before execution;
- one idempotent reconciliation run with before/after audit evidence;
- notifications suppressed; and
- focused post-execution smoke testing.

R9-A2 remains unauthorised until its dry-run is reviewed and explicitly approved.

### Cleanup

Constraint tightening, compatibility removal and legacy cleanup are deferred indefinitely.
They should be reopened only if operational evidence shows that the retained additive
compatibility creates a real maintenance, integrity or security problem.

## 11. Required Ordering

```text
record the accepted plan, exact branch and baselines
-> implement on one branch
-> pass automated tests
-> create and verify the STAGING database snapshot
-> apply the additive migration
-> deploy R9-A1 to STAGING with new notifications off
-> run focused C1/C2 smoke tests
-> run the R9-A2 reconciliation dry-run
-> stop for explicit reconciliation approval
-> execute the approved reconciliation with notifications suppressed
-> repeat the focused smoke tests
-> record STAGING PASS
-> stop before main/live promotion
```

The application work remains one branch and one reviewable remediation slice. The single
separation retained is between reversible application deployment and mutation of existing
data.

## 12. Safety And Recovery Contract

### 12.1 Recovery point

Before any later schema or data execution:

1. record the exact application, documentation and migration commits;
2. require a clean feature worktree;
3. verify the exact target and tenant/season;
4. create a database snapshot/child branch;
5. verify the snapshot can be connected to and its migration ancestry matches;
6. record privacy-safe aggregate before-state counts; and
7. define the operator, time window and stop authority.

### 12.2 Application rollback

`df40f45c` is a safe code rollback only while changes remain additive and existing Club/Team
statuses and access semantics have not been converged.

It is not automatically safe after changing an `APPROVED` Club to `WAITING_LIST`, because
the old C2 Team-request path requires raw `APPROVED`. Before any status mutation, a newer
access-safe application commit must become the recorded rollback baseline or the mutation
must have a tested targeted reversal.

### 12.3 Database recovery

- additive schema should normally remain during an application rollback;
- do not use destructive down-migrations as the routine recovery mechanism;
- before-state evidence is required for every authorised data change;
- reconciliation must be idempotent and resumable;
- targeted forward correction is preferred after unrelated live writes occur;
- whole-snapshot restore is a last-resort incident decision because it can erase legitimate
  writes made after the snapshot; and
- no production procedure may rely solely on STAGING similarity.

### 12.4 Notification recovery

- deploy new participation events disabled;
- verify the disabled state before any transition trigger is activated;
- master/per-event pause is the immediate operational stop;
- retain an event/delivery record for diagnosis and retry;
- never resend blindly after an uncertain provider outcome; and
- document that delivered email is irreversible.

## 13. Automated Test Requirements

At minimum:

1. all three admission routes create the right provenance once under retry and partial
   failure creates no false admission;
2. cross-tenant and cross-season evidence/allocation fails closed;
3. one valid Current/allocated Team makes the Club Current and removal of the last one
   returns it to Club Waiting List;
4. unallocated Team and deliberate Team Waiting List remain distinct;
5. suspended/withdrawn overrides win;
6. Club Waiting List preserves C2 access and Team-request capability;
7. legacy attestation never appears as automated import evidence;
8. new notification events default off, respect master/per-event controls and do not
   duplicate on no-op or retry;
9. custom notification content/routing works and delivery failure does not roll back the
   committed category; and
10. season rollover derives destination participation from destination evidence.

### 13.1 Documentation lifecycle

R9-A1 must produce:

Implementation confirmation:

`docs/modules/lmspro/04-implementation-confirmations/2026-07-28-lmspro-remediation-slice-r9-a1-admission-evidence-and-derived-participation-compatibility-confirmation.md`

The confirmation must record the exact branch and commit, changed files, additive migration,
implemented behaviour, notification default-off evidence, automated-test commands/results
and known limitations.

Review, test and human STAGING smoke:

`docs/modules/lmspro/05-review-and-test/2026-07-28-lmspro-remediation-slice-r9-a1-admission-evidence-and-derived-participation-compatibility-review-and-staging-smoke-test.md`

The review record must contain technical review, exact STAGING deployment/migration
evidence, the UI smoke schedule and reported results, reconciliation dry-run/execution
evidence if separately approved, recovery disposition and an explicit STAGING verdict.
It must be created with the scheduled fixtures, actors, expected results and reset steps
before the STAGING deployment, then completed with actual results and evidence references
after each smoke pass.

## 14. Human STAGING Smoke Schedule Required Before Any Enablement

The implementation record must name actors, fixtures, expected evidence and reset steps for
a focused schedule:

1. use the linked two-stage registration form through email validation and authorised C1
   approval; confirm Registered provenance, primary-C2 access and initial non-Current
   participation where no Team qualifies;
2. use C1 Club Management to create a direct authorised Club; confirm Registered provenance,
   primary-C2 access and initial non-Current participation where no Team qualifies;
3. allocate the first qualifying Team and confirm the Club becomes Current;
4. remove the last qualifying allocation and confirm Club Waiting List with C2 access and
   Team-request capability retained;
5. confirm unallocated and deliberately wait-listed Teams remain distinct and that C1/C2
   displays and counts use the correct cohorts;
6. confirm both new transition notifications are off;
7. enable one event, verify default/custom content and exactly one send, then pause it; and
8. repeat/no-op the transition and confirm no duplicate.

The validated import route remains mandatory automated integration coverage but is
explicitly excluded from this UI human smoke schedule.

No smoke step may use production or the historic Derby JFL records unless separately
authorised.

## 15. STAGING And Reconciliation Gates

### STAGING

- exact commit and migration ancestry verified;
- snapshot/recovery point verified;
- additive migration applies without changing existing rows;
- automated suite passes;
- C1/C2 human smoke passes;
- C2 access is unchanged for Registered Waiting List Clubs;
- notification events remain disabled until their separate enablement gate; and
- no unexplained tenant/season delta exists.

### R9-A2 reconciliation

- dry-run output is reviewed;
- exact changes and recovery point are approved;
- execution is idempotent and notifications are suppressed;
- before/after aggregates reconcile; and
- the focused smoke schedule passes again.

### End boundary

This lifecycle ends with an evidenced STAGING verdict. It does not merge or deploy to
`main`, query or mutate production, enable production notifications or authorise live
reconciliation. Any later live work requires a new explicit request and is not a remaining
decision for this STAGING plan.

## 16. Resolved Decisions

The control review resolves the R9-A1 decisions as follows:

1. The one-branch R9-A1 application-remediation plan is accepted.
2. The append-only evidence relation is accepted as the schema direction.
3. Two separately controlled Club transition events are confirmed.
4. Both events default to off for every existing and new tenant.
5. The default recipient is exactly one authoritative active primary C2 resolved through
   same-tenant Club-official membership and an active LMSPro Club role. An explicit
   Notification Manager recipient override remains valid. If no single authoritative
   default recipient exists, the send is skipped and an auditable exception is recorded;
   the committed Club category is not rolled back and no unsafe fallback recipient is used.
6. A small durable participation-transition outbox is accepted for these two events. Its
   transaction, uniqueness, suppression, claim, retry and delivery rules are those in
   Section 8; this does not authorise a general Notification Manager redesign.
7. A tested post-`df40f45c` access-safe application commit must be recorded as the rollback
   baseline before R9-A2 may mutate existing Club status.
8. This lifecycle is STAGING-only. A production read-only inventory, live deployment or
   live reconciliation is neither required nor authorised here and must be considered by a
   later, separately controlled lifecycle.
9. The legacy-attestation representation is accepted as one `LEGACY_ATTESTED_IMPORT`
   evidence row per verified Club, linked to one bounded attestation/reconciliation batch.
   The batch records the tenant, season, attesting authority, time, scope and evidential
   basis. Each evidence row must state that automated historic source evidence is
   unavailable. No historic import job, automated provenance or unsupported source
   reference may be fabricated, and uniqueness/retry controls must make later insertion
   idempotent.

R9-A1 adds the accepted schema capability but does not insert legacy evidence. The R9-A2
dry-run must present the exact proposed membership and counts. Writing those rows or
executing any other reconciliation still requires separate explicit R9-A2 approval.

No R9-A1 business or implementation-control decision remains open.

## 17. Acceptance And Stop Gate

Accepted control shape:

```text
R9-A1
-> one application-remediation branch and slice
-> additive migration, application behaviour and automated tests
-> implementation confirmation
-> verified STAGING snapshot and notifications-off STAGING deployment
-> review/test record and focused two-route C1/C2 human UI smoke
-> reconciliation dry-run only

R9-A2
-> one separately approved existing-data reconciliation execution after dry-run review
-> notifications suppressed

cleanup
-> deferred indefinitely unless later evidence makes it necessary
```

The R9-A1 plan is accepted. Implementation does not commence from this planning edit alone:
the next exact control prompt must identify the branch and baselines and authorise the
bounded R9-A1 implementation, documentation and STAGING sequence. It must stop after the
STAGING verdict and must not promote to `main` or live.

Stop here. Do not change application code, create a migration, query or mutate a database,
send a notification, alter an environment or deploy until the next exact control prompt.
R9-A2 mutation remains prohibited until its dry-run is reviewed and explicitly approved.
Production access, deployment and mutation remain outside this lifecycle.
