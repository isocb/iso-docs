# LMSPro Remediation Slice R9-A0 Club Participation Writer, Consumer And Live-State Inventory Planning

Date: 2026-07-27

Module: LMSPro / SeasonPro

Status: ACCEPTED as the selected read-only planning/evidence boundary; inventory execution
and evidence capture remain pending

Parent lifecycle:

```text
R9-A - Club Admission And Seasonal Participation
```

Triage:

`docs/modules/lmspro/02-triage/2026-07-27-lmspro-r9-consolidated-four-item-remediation-triage.md`

Source refinement:

`docs/modules/lmspro/01-cr-inputs/2026-07-27-lmspro-consolidated-four-item-remediation-planning-refinement.md`

## 1. Purpose

Establish the complete evidence needed to define safe R9-A compatibility and implementation
slices without changing application behaviour or persisted state.

The inventory must answer:

1. which paths create or change admission, Club participation, Team status or allocation;
2. which paths interpret those values for access, counts, communication, UI or rollover;
3. which live tenant/season state combinations exist;
4. which records are deterministic under the accepted business contract and which are
   ambiguous; and
5. what additive/expand-contract sequence could move writers and consumers safely.

## 2. Controlling Business Invariants

Use these definitions throughout the inventory:

```text
Registered/admitted Club
+ at least one same-tenant, same-season CURRENT Team
+ valid same-tenant, same-season division/AGG allocation
+ no Suspended/Withdrawn override
= Current Club
= ClubStatus.APPROVED compatibility representation

Registered/admitted Club
+ zero qualifying Current/allocated Teams
= Club Waiting List

Team WAITING_LIST
= explicit authorised Team decision

Team unallocated
= retained allocation-work state
= excluded from Current counts
!= automatically Team WAITING_LIST
```

Waiting List is not suspension, withdrawal or loss of onboarding/C2 authority.

Registration/admission may originate through exactly three accepted routes:

1. a completed validated Club import through the SeasonPro import tool;
2. the linked two-stage Club registration form, where email validation is followed by an
   authorised C1 approval decision; or
3. deliberate direct Club creation by an authorised C1 tenant user.

All three routes are valid ways to establish a Registered/admitted Club. The inventory must
distinguish their durable evidence. Email validation alone, an unreviewed form submission,
mere row existence or Team presence is not a substitute for the applicable completed
registration/admission decision.

## 3. Exact Boundary

### Included

- static writer inventory;
- static consumer inventory;
- current Prisma model, enum, index, migration-history and relation inventory;
- exact branch/deployment ancestry capture;
- read-only tenant/season aggregate state queries when separately authorised;
- non-identifying contradiction and ambiguity counts;
- access, communications, public/directory and season-rollover dependency classification;
- compatibility-option assessment;
- risk, recovery and promotion-order recommendations; and
- a reviewed evidence record proposing later bounded slices.

### Excluded

- product-code changes;
- schema, enum, index, constraint or migration changes;
- inserts, updates, deletes, upserts, relinks or status convergence;
- account, role, membership or Club-official changes;
- write-capable scripts or reconciliation;
- production deployment or environment changes;
- automatic classification of ambiguous records;
- historic closed-season rewrite;
- notification sending; and
- implementation of any provisional successor shape.

## 4. Static Writer Inventory

At minimum, classify:

- Club Application approve, wait-list and reject paths;
- the linked two-stage registration form, including email validation, C1 review and the
  final approved Application-to-Club transition;
- direct C1 Club create/edit/status actions, including how the authorised registration
  decision is distinguished from a draft or incomplete row;
- SeasonPro Club import, validation, source/legacy mapping and primary-C2 provisioning;
- Team import and defaults;
- C1 and C2 Team registration;
- Team approve, wait-list, reject/cancel and bulk-status paths;
- division/AGG allocation, reallocation and de-allocation;
- age-group changes that clear or replace allocation;
- Team variation approval/application;
- Club suspension, withdrawal and reinstatement;
- Team deletion and terminal-state paths;
- season clone, continuation and roll-forward; and
- any background job, repair script or admin action that writes relevant fields.

For each writer record:

| Field | Required evidence |
| --- | --- |
| Path/procedure | File and procedure/action name |
| Actor | P1, C1, C2, public, import, worker or system |
| Tenant/season scope | How it is established and validated |
| Admission effect | Which of the three accepted routes applies and what durable evidence is created or changed |
| Club effect | Status or participation data changed |
| Team effect | Status, age group or allocation changed |
| Transaction | Atomic boundary and concurrency behaviour |
| Audit | Actor, reason and before/after evidence |
| Retry | Idempotency or duplicate risk |
| Contract result | Compatible, contradictory, ambiguous or unrelated |

## 5. Static Consumer Inventory

At minimum, classify:

- C1 Club lists, CRUD, filters, badges, dashboard counts and statistics;
- C1 Team approval, Division Manager and season administration;
- C2 dashboard, profile, Team registration/request and Club Teams;
- Club-official activation/deactivation and access guards;
- communications cohorts, Announcements, key dates and recipient selectors;
- Club and Team summaries used by email templates or shortcodes;
- public/directory eligibility;
- reporting, audit and exports;
- season clone, continuation and roll-forward; and
- tests, fixtures and documentation that encode current semantics.

Every consumer must be assigned one named cohort:

- Admitted Clubs;
- Registered Clubs;
- Current Clubs;
- Club Waiting List;
- Clubs with unallocated Teams;
- Current Teams;
- all operational/non-terminal Clubs; or
- an explicit suspended/withdrawn/terminal purpose.

Bare dependence on `APPROVED`, `CURRENT` or a display label is not sufficient
classification.

## 6. Read-Only Live-State Matrix

When an authorised database target and operator are available, collect aggregate counts by
tenant and season for:

1. Clubs by `ClubStatus`;
2. Clubs classified by import, approved two-stage form, authorised direct C1 creation,
   multiple-route or unknown instantiation evidence;
3. Applications by email-validation/review status and whether an approved Application
   created or linked a Club;
4. imported Clubs with completed validation, source mapping and required primary-C2
   evidence;
5. direct C1-created Clubs with actor, timestamp and required primary-C2 evidence;
6. Clubs with zero, one or several qualifying Current/allocated Teams;
7. `APPROVED` Clubs with zero qualifying Teams;
8. `WAITING_LIST` Clubs with one or more qualifying Teams;
9. suspended/withdrawn Clubs with qualifying Teams;
10. Teams by status and allocation-null/valid/invalid classification;
11. `CURRENT` Teams with null, cross-tenant, cross-season or missing AGG allocation;
12. non-`CURRENT` Teams with an allocation;
13. unallocated Teams grouped by their Club aggregate;
14. consciously wait-listed Teams and available position evidence;
15. Clubs without an authoritative primary C2 official;
16. Waiting List Clubs whose officials or Team-request capability would currently fail;
17. communication/public/directory cohorts affected by current status filters; and
18. season-clone/roll-forward states that would carry contradictory authority.

Return counts and bounded classifications only. Do not place names, email addresses, phone
numbers, free text, raw UUIDs or credentials in the evidence record.

## 7. Read-Only Execution Controls

Any database inventory execution requires separate confirmation of the exact target. For
PostgreSQL:

- use a transaction explicitly set to `READ ONLY` where supported;
- use `SELECT`, aggregate and metadata inspection only;
- set a bounded statement timeout;
- avoid temporary tables, materialised views, locks beyond ordinary reads and server-side
  export;
- do not run Prisma mutation helpers, migration commands or application repair scripts;
- do not infer production authority from staging authority;
- record query text or a reviewed query checksum and the non-secret database target
  identity; and
- stop immediately if the target, schema or migration ancestry differs from the recorded
  precondition.

No query may be run against production without explicit production read-only authority.

## 8. Evidence Classification

Each observed state must be classified as:

- **compatible** — already satisfies the accepted contract;
- **deterministic contradiction** — one safe intended result appears derivable, but no
  mutation is authorised;
- **ambiguous** — business or source evidence is insufficient and requires authorised
  human review;
- **override** — suspended/withdrawn or another explicit authority must be preserved;
- **orphan/integrity concern** — missing or cross-boundary relation requires separate
  security/data triage; or
- **unrelated** — inspected but outside R9-A.

Counts do not become a repair list. Any later row-level review needs separately controlled
authority and privacy handling.

## 9. Required Output

Produce one R9-A0 review/evidence record containing:

- exact application and documentation commits;
- exact database environment(s), migration ancestry and query boundary;
- writer inventory;
- consumer/cohort inventory;
- aggregate live-state matrix;
- deterministic/ambiguous/override counts;
- access and communications impact;
- schema/compatibility options;
- recommended code/data/deployment order;
- rollback and recovery implications;
- proposed smallest successor slices; and
- explicit unresolved technical or data decisions.

The evidence must distinguish source-only findings from staging or production observations.

## 10. Successor-Slice Decision Gate

R9-A0 does not pre-name or accept the implementation sequence. Its evidence should determine
whether later bounded work needs separate boundaries for:

- additive admission/participation representation;
- compatibility readers and named cohort resolution;
- prospective writer convergence;
- controlled dry-run and authorised reconciliation;
- UI terminology and generic-CRUD removal;
- constraint enforcement and legacy cleanup; and
- season-rollover convergence.

Formal control must review the evidence and then select the smallest safe slices. No single
compound migration/code/data release should be assumed.

## 11. Acceptance

R9-A0 passes only when:

1. every relevant writer and consumer has an owner and named contract;
2. all direct status/allocation dependencies are classified;
3. live-state evidence, if authorised, is aggregate, tenant/season scoped and demonstrably
   read-only;
4. C2 access and communications consequences are explicit;
5. deterministic and ambiguous records are separated;
6. no data, schema, application, environment or deployment state changed;
7. compatibility options and ordering risks are evidence-based; and
8. successor slices remain proposals until separately accepted.

## 12. Stop Gate

Stop after the reviewed R9-A0 evidence record. Do not implement a schema, compatibility
reader, writer change, reconciliation, UI correction or constraint until the next control
decision accepts its exact bounded plan.
