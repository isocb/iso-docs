# LMSPro R9 Consolidated Four-Item Remediation Triage

Date: 2026-07-27

Module: LMSPro / SeasonPro

Status: ACCEPTED as one coordinated programme with four separately bounded lifecycles;
`R9-A0` selected as the next LMSPro planning/evidence boundary

Source CR:

`docs/modules/lmspro/01-cr-inputs/2026-07-22-lmspro-consolidated-email-integrity-club-visibility-and-remedial-work-cr-input.md`

Controlling refinement:

`docs/modules/lmspro/01-cr-inputs/2026-07-27-lmspro-consolidated-four-item-remediation-planning-refinement.md`

Authoritative roadmap:

`docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md`

## 1. Decision

Accept the complete four-item CR as:

```text
R9 - Consolidated Club Participation, Communications And Remedial UX Programme
```

R9 is one coordinated programme because its items share Club, Team, season, C1/C2,
communications and permission boundaries. It is not one indivisible implementation or
production release. Each accepted item receives an independent planning, implementation,
review, staging and promotion lifecycle.

The C1 League dashboard reorganisation remains separate work and is not a fifth R9 item.
Completed R4 and R8-A remain foundations and are not reopened.

## 2. Accepted Child Lifecycles And Order

The requested decreasing-complexity order controls the LMSPro lane:

| Order | CR item | Lifecycle | Accepted outcome | Current authority |
| --- | --- | --- | --- | --- |
| 1 | Item 3 | `R9-A` — Club Admission And Seasonal Participation | Separate durable admission from truthful season participation while preserving unallocated Team evidence and C2 access | `R9-A0` inventory planning/evidence only |
| 2 | Item 1 | `R9-B` — Club Email Visibility And History Integrity | Explicit same-tenant Email-to-Club visibility with aligned delivery evidence and list/detail authority | Accepted for later bounded planning |
| 3 | Item 4 | `R9-C` — Responsive Team Status Visibility | Shared accessible C1/C2 Team status and waiting-list-position presentation | Accepted for later bounded planning |
| 4 | Item 2 | `R9-D` — Attachment Click-To-Browse Restoration | Restore pointer/keyboard browse while retaining completed R8-A policy and transport | Accepted for later bounded reproduction and planning |

The identifiers follow delivery order rather than the source CR's item numbers. No child
may borrow another child's implementation, evidence or promotion authority.

## 3. Settled Business Contract

The refinement's reconciled decisions are accepted:

- three canonical Club-instantiation routes can create a valid Registered/admitted Club:
  a completed validated SeasonPro import, the linked two-stage registration form after
  email validation and authorised C1 approval, or deliberate direct creation by an
  authorised C1 tenant user;
- each route must retain durable route, tenant, season, actor/controlled-system, timestamp
  and primary-C2 evidence appropriate to that route;
- email validation proves control of the submitted address but is not by itself the Club's
  admission decision; the form route becomes Registered/admitted when C1 approves it;
- direct row creation or the presence of a Team must not be mistaken for admission unless
  the relevant import, approved Application or authorised C1-add evidence exists;
- admission and seasonal participation are separate authorities;
- `ClubStatus.APPROVED` remains the compatibility representation of Current;
- a Club is Current only when it has at least one same-tenant, same-season `CURRENT` Team
  with a valid same-tenant, same-season division/AGG allocation;
- a Registered/admitted Club with no qualifying Team is a Club Waiting List aggregate;
- an unallocated Team is a distinct in-process allocation state, is excluded from Current
  counts and is not automatically Team Waiting List;
- Team Waiting List requires a conscious authorised decision;
- Club Waiting List does not undo onboarding, deactivate officials, remove C2 access or
  prevent authorised Team requests;
- suspended and withdrawn states remain explicit overrides;
- automatic participation convergence sends no Club notification; and
- this first operational season requires no closed-season rewrite.

No remaining business question blocks R9-A0. The inventory may discover technical
ambiguities, but it must report rather than resolve them through mutation or assumption.

## 4. Priority And Risk

R9-A is selected first because it carries the programme's broadest domain and live-state
risk. Current code allows or depends on states that contradict the accepted final contract,
including application/import paths that set Clubs `APPROVED`, Teams that are `CURRENT`
without an AGG allocation and consumers that use `APPROVED` as admission, registration,
Current participation or general operational eligibility.

Risk is high for:

- accidental C2 access loss;
- incorrect Club/Team counts and cohorts;
- communications exclusion;
- unsafe season roll-forward;
- silent live-state reclassification;
- cross-tenant or cross-season reconciliation mistakes; and
- incompatible schema/code/data ordering.

This risk requires evidence-first planning. It does not justify an immediate migration or
automatic repair.

## 5. Selected First Boundary

Select:

```text
R9-A0 - Club Participation Writer, Consumer And Live-State Inventory
```

R9-A0 is the next LMSPro planning/evidence boundary. It may:

- inventory application writers and consumers;
- verify all three Club-instantiation routes and the durable registration/admission
  evidence each currently creates;
- classify direct uses of Club and Team status;
- design and execute authorised read-only tenant/season aggregate queries;
- count deterministic, contradictory and ambiguous state combinations without exposing
  personal data;
- document migration ancestry and current branch/deployment baselines; and
- recommend later compatibility and implementation slice boundaries from evidence.

R9-A0 may not:

- change application behaviour;
- add or change schema, enums, constraints or migrations;
- update, insert, delete, relink or reconcile any record;
- run a write-capable backfill, repair or dry-run that stages mutations;
- alter user, role, Club-official or C2 access;
- change environment or deployment state; or
- pre-authorise any successor R9-A implementation slice.

The accepted R9-A0 plan is:

`docs/modules/lmspro/03-slice-planning/2026-07-27-lmspro-remediation-slice-r9-a0-club-participation-writer-consumer-and-live-state-inventory-planning.md`

## 6. Successor Lifecycle Gate

R9-A0 must end with a reviewed evidence record that:

1. enumerates retained writers and consumers;
2. records tenant/season-scoped state counts;
3. separates deterministic corrections from ambiguous records requiring human decision;
4. identifies C2 access, communications, public/directory and season-rollover dependencies;
5. evaluates additive/expand-contract options and ordering constraints;
6. defines recovery, rollback and live preflight requirements; and
7. recommends the smallest separately reviewable compatibility and implementation slices.

Only a later control decision may accept those recommended slices. Their identifiers,
schema boundary, code/data ordering and promotion sequence are deliberately not fixed by
this triage.

## 7. Dependencies And Coordination

- R9-A must consume shared provisioning work under `PLAT-REFINE-02` if later implementation
  changes direct/imported primary-C2 provisioning; it must not create another account
  lifecycle.
- P1 impersonation evidence is affected by `PLAT-REFINE-04`; direct C1/C2 acceptance remains
  mandatory even if impersonation remediation is scheduled separately.
- R9-B must not hard-code the currently overloaded meaning of `ClubStatus.APPROVED`.
- R9-C may gather fixtures independently but must not decide R9-A terminology.
- R9-D consumes the completed R8-A allowlist, private storage, limits, acknowledgement,
  draft and delivery contracts unchanged.
- The root roadmap retains cross-lane sequencing authority. This triage selects R9-A0 as
  the LMSPro lane's next planning boundary; it does not silently displace another lane's
  executable authority.

## 8. Baseline

At triage:

```text
application dev/origin-dev:         df40f45c
application staging/origin-staging: df40f45c
application main/origin-main:       b9287ffa
documentation parent:               409b3b0
```

R9-A0 must record the exact branch and database target used for any later read-only
inventory evidence. No production query is authorised merely by this triage record.

## 9. Disposition

The four-item programme is formally accepted. `R9-A0` is selected and planning-authorised.
No R9 application implementation, schema, migration, reconciliation, live-data mutation,
deployment or production action is authorised.
