# LMSPro CR-Fix — Free Day And Team Variation Request Remediation Triage

Date: 2026-08-24

Module: LMSPro / SeasonPro

Status: **ACCEPTED OPERATIONAL EXPEDITE AS ONE TACTICAL PROJECT WITH TWO ORDERED BOUNDED
LIFECYCLES; R13-A AND R13-B PLANS NOW ACCEPTED BY SUBSEQUENT CONTROL-OWNER INSTRUCTION;
R13-A IS THE ONLY ACTIVE CHILD; R13-B IMPLEMENTATION IS LOCKED UNTIL R13-A CLOSURE AND
RESELECTION; NO APPLICATION, SCHEMA, MIGRATION, DATA, DEPLOYMENT OR EXTERNAL ACTION IS
AUTHORISED BY THIS TRIAGE OR PLANNING UPDATE**

Source CR-Fix:

- [Free Day and Team Variation Request remediation CR-Fix](../01-cr-inputs/CR-Fix-2026-08-24-lmspro-free-day-and-team-variation-request-remediation.md)

Authoritative controls:

- [LMSPro / SeasonPro child roadmap](../00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md)
- [root portfolio control](../../../00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md)

Displaced FUND authority:

- [accepted FUND `1R-F-A` Stage C plan](../../fund/03-slice-planning/2026-08-12-fund-phase-1-slice-1r-f-a-stage-c-temporary-render-private-object-proof-planning.md)
- [FUND Stage C exact-candidate and external-execution gate](../../fund/05-review-and-test/2026-08-12-fund-phase-1-slice-1r-f-a-stage-c-exact-candidate-and-external-execution-gate.md)

## 1. Control-Owner Decision

Accept the CR-Fix as an operational expedite that must complete before further FUND
execution.

Accept one tactical remediation project with two separately bounded, sequential lifecycles:

```text
Child 1 — Free Day integrity and management presentation
  -> observations 6.2.1 through 6.2.8 in the source CR-Fix
  -> bounded planning, implementation, review and controlled release
  -> explicit child closure

Child 2 — Deferred Team Variation workflow
  -> observation 6.2.9 in the source CR-Fix
  -> bounded planning, additive-migration control, implementation, review and release
  -> explicit child and parent CR-Fix closure

Then
  -> reconcile portfolio control
  -> resume FUND 1R-F-A Stage C from its preserved exact checkpoint
```

The Free Day child is first because it addresses current operational truthfulness: quota,
request visibility and date-only integrity. The Deferred Variation child follows because it
adds a durable workflow state and therefore requires a distinct schema/migration,
transition and rollback gate.

This triage originally authorised preparation of the first bounded `03-slice-planning`
record only. The control owner's subsequent 2026-08-24 instruction explicitly authorises
planning records for both children. It does not allow R13-B to run in parallel, borrow
implementation authority from R13-A or start either application's implementation.

## 2. Classification And Portfolio Decision

| Dimension | Accepted decision |
| --- | --- |
| Type | Tactical `CR-Fix` containing corrective Free Day work and one explicitly accepted, bounded Deferred Variation workflow addition |
| Evidence depth | `High` — tenant/Club/Team authority and operational date/quota correctness apply throughout; R13-B additionally changes schema/migration state. This depth does not change expedite priority or create another lifecycle. |
| Owning lane | LMSPro / SeasonPro |
| Application baseline | Exact aligned application `fcd162db60956858233821fd3f29c55e17d954dd` |
| Environments | Reported across all environments; controlled synthetic reproduction remains mandatory |
| Operational severity | Medium/High: current-season quota/list/date truth can misdirect or conceal operational action |
| Security/privacy/tenancy severity | No active exposure reported; High correction sensitivity requires existing tenant/Club/Team/season authority to remain fail-closed |
| Data integrity | No existing-data repair is required or authorised |
| Workaround | Incomplete manual containment only; no complete safe operational substitute |
| Correction risk | Medium for Free Day query/date consistency; Medium/High for additive Deferred persistence and transitions |
| Expedite | Accepted by the control owner because this work must precede further FUND execution |
| Portfolio `NOW` | R13-A Free Day integrity/presentation is the only active child; implementation decision/reproduction is next, while accepted R13-B remains locked |
| Portfolio `NEXT` | Resume FUND `1R-F-A` Stage C from the exact preserved safe checkpoint |
| Last-known-good | No single combined boundary exists; exact `fcd162db` is the reproduction baseline |

The former FUND `NEXT`—Stage C reconciliation and deliberate reselection—remains registered
but temporarily loses formal `Next` position while the displaced FUND `Now` occupies it.

## 3. Evidence Supporting Acceptance And Expedite

Read-only source investigation at exact `fcd162db` established:

- the standard Free Day request mutation and Team usage query already exclude Special Free
  Day rows and reserve quota for standard `PENDING`, `APPROVED` and `CONFIRMED` requests;
- the C1 `getSeasonStats` Teams-at-limit calculation instead counts `APPROVED` rows without
  excluding Special applications, explaining the false C1 limit while C2 can still submit;
- the C1 summary boxes are non-interactive even though Teams-at-limit details already exist;
- the Free Day request table has no sort-state or sortable-column contract;
- the Special Free Day application list has no deterministic Club sort or Age Group filter;
- the source-default Free Day list has blank status/Club/Age Group filters but selects the
  current season and `Future` time period, requiring reproduction of the initially empty
  `All` symptom from the actual first-load state;
- the reusable C1 standard-request and C1 Special create/edit date paths do not consistently
  rebuild picker calendar values as UTC midnight;
- a `Europe/London` simulation proves that `15 August 2026 00:00 BST` serialises as
  `2026-08-14T23:00:00.000Z`, after which mixed local/UTC displays can show different dates;
- the dedicated C2 standard-request form already performs the correct client-side
  local-calendar-to-UTC-midnight conversion, so the remedy must be boundary-specific rather
  than a broad timezone rewrite; and
- `TeamVariationRequestStatus` has no `DEFERRED` state and the current cancellation and C1
  filtering/action paths do not implement the settled Deferred contract.

The faults affect live operational workflows and the workaround is incomplete. The
accepted expedite is not based on a security incident, outage or historic-data-repair need;
it is based on current-season operational correctness and the control owner's explicit
cross-lane sequencing decision.

## 4. Containment And Workaround Decision

Until a reviewed correction is released:

1. C1 must treat `Teams At Limit` as non-authoritative and manually distinguish active
   standard requests from Special applications.
2. An authoritative server refusal must never be bypassed.
3. C1 may use explicit status/date-period filters and the known toggle-to-`All` workaround,
   while recognising that it is not equivalent to correct first-load behaviour.
4. Non-clickable summaries and unavailable sorting/filtering may be worked around only by
   opening and manually reviewing the detailed lists.
5. Special Free Day dates shown across mixed C1/C2 surfaces during BST must be cross-checked
   against the intended League calendar date and communicated manually; unnecessary
   create/edit re-entry should be avoided.
6. A request that operationally needs deferral remains `PENDING` and is tracked manually;
   it must not be approved or rejected merely to remove it from the pending queue.

These measures reduce risk but do not constitute a complete safe workaround. They do not
authorise direct data edits, schema changes or an environment action.

## 5. Accepted Child 1 Boundary — Free Day Integrity And Management Presentation

The first bounded plan may include:

- one canonical standard-only, per-Team, per-season quota definition used by C1 summary,
  C2 usage and the authoritative request mutation;
- exclusion of every Special Free Day application from standard used, remaining,
  at-limit and gating outcomes;
- failing-first proof for a false Special-derived at-limit Team and a true standard
  at-limit Team;
- correct first-load and `All` behaviour under the actual active season/time-period/Club/
  Age Group filters;
- meaningful-column click sorting with ascending first click, descending second click and
  a visible active-column direction arrow under the canonical IsoStack table pattern;
- actionable Pending Requests and Teams At Limit summaries with truthful filtered detail;
- consistent date-only input, persistence and rendering across the accepted C1/C2 Free Day
  forms, lists, modals and notifications, including GMT/BST fixtures;
- default alphanumeric Club ordering and Age Group filtering within each Special Free Day;
  and
- focused tenant, Club, Team, season, role, cache/invalidation, concurrency and unaffected-
  sibling regression evidence.

The first plan may not:

- reopen R12-A notice-period authority;
- redesign Free Days or Special Free Days;
- change Special availability, deadline, approval, confirmation or Club-scope policy;
- add or rewrite historic data;
- change notification events, recipient resolution or routing;
- perform a broad shared timezone rewrite;
- add schema or migration work unless triage is explicitly reopened; or
- implement any Deferred Variation behaviour.

## 6. Accepted Child 2 Boundary — Deferred Team Variation Workflow

The later bounded plan may include:

- the smallest additive persistence representation for `DEFERRED` and its safe migration;
- explicit `PENDING -> DEFERRED -> PENDING` server transitions;
- an optional deferral reason retained for audit and visible to the authorised C2
  submitter;
- no Team mutation or replacement request during defer/return transitions;
- C1 `Deferred` filtering and `All` visibility;
- exclusion from C1 `OUTSTANDING` and dashboard counts;
- a Deferred modal whose only status-changing workflow action is `Return to Pending`, apart
  from passive close;
- C2 Deferred status/reason visibility and authority to cancel its own Deferred request;
- restoration of the existing normal Pending workflow after return; and
- tenant/Club/Team/season authority, audit, concurrency, migration-order, rollback and
  unaffected existing-status regression evidence.

The second plan may not:

- redesign the accepted approval/rejection/update-confirmation workflow;
- approve or reject directly from Deferred;
- offer Save Reply or another mutable C1 workflow action while Deferred;
- introduce a new Deferred notification event or change existing notification routing;
- rewrite existing Team Variation rows; or
- begin before the first child reaches its accepted closure/reconciliation gate.

## 7. Risk And Required Planning Controls

| Risk | Required control in the later bounded plan |
| --- | --- |
| Special applications still affect standard quota | One canonical predicate plus failing-first standard/Special fixtures across C1, C2 and direct server calls |
| The `All` correction hides records through another default filter | Record route and every active initial filter; prove first load, toggles and cache invalidation |
| Date correction shifts another valid surface | Record picker, wire, stored and displayed values across GMT/BST; change only proven inconsistent boundaries |
| Existing off-midnight rows tempt a repair | No mutation or repair; stop if compatibility cannot be achieved without separately accepted data work |
| Summary navigation exposes another tenant/Club | Retain server-side organisation, season and permitted-scope authority; never rely on browser filtering |
| Deferred is treated as Pending | Separate transition checks and modal/server refusal for approve/reject while Deferred |
| C2 cancels another Club's Deferred request | Exact submitter/Club/Team/season authority and direct-server negative proof |
| Additive migration and application order diverge | Expand-compatible migration sequence, exact deployment gate and documented rollback posture |
| Working notifications regress | Preserve events, recipients and routing; use no real delivery in local acceptance |
| FUND checkpoint drifts during interruption | Re-verify suspended worker, no secrets, empty private bucket and exact candidate before FUND resumes |

## 8. FUND Interruption And Resumption Contract

The accepted CR-Fix temporarily displaces FUND `1R-F-A` Stage C. Throughout both LMSPro
children:

- exact Stage C candidate `328aadf0a360b4c65837327060302ddc525f6168` remains preserved;
- the temporary Render worker remains suspended;
- no application secrets are injected;
- the dedicated private R2 proof bucket remains empty;
- existing Render auto-deploy services remain untouched; and
- no Stage C run, credential minting, teardown claim or later FUND child begins in parallel.

After both LMSPro children close, the control window must verify this checkpoint before
restoring FUND as portfolio `Now`. It must not infer `1R-F-B`, `1R-G` or `1R-H-A`.

## 9. Branch And Repository Boundary

At triage:

```text
application repository: isostack-bedrock
branch: fix/lmspro-free-day-variation-request-remediation
exact HEAD: fcd162db60956858233821fd3f29c55e17d954dd
state: clean

documentation repository: isodocs
branch: fix/lmspro-free-day-variation-request-remediation
base HEAD: 4e4ed16aeed53bb5bf6f0598db1c4983c4f43987
state: CR-Fix and this control reconciliation are local documentation work
```

No commit, push, pull request, deployment, migration, database action or external message is
authorised or claimed by this record.

## 10. Exit And Next Action

Triage is accepted and complete.

The two accepted planning records are:

- [R13-A Free Day integrity and management presentation](../03-slice-planning/2026-08-24-lmspro-remediation-slice-r13-a-free-day-integrity-and-management-presentation-planning.md); and
- [R13-B Deferred Team Variation workflow](../03-slice-planning/2026-08-24-lmspro-remediation-slice-r13-b-deferred-team-variation-workflow-planning.md).

R13-A is the only active child; its explicit implementation decision is the next control
action. R13-B is plan-ready but is not an active implementation boundary and remains locked
until R13-A implementation/review/test/roadmap closure plus a new explicit decision.

## 11. Stop Conditions

Stop and return to triage if:

- the Free Day correction requires existing-row mutation, repair or a schema migration;
- the date fault cannot be reproduced at the source-identified boundaries;
- the empty-`All` symptom is caused by a materially different authority or data problem;
- a correction requires weakening tenant, Club, Team, season or component access;
- notification routing or delivery, rather than date rendering, proves defective;
- the Deferred workflow requires a broader Team lifecycle redesign or existing-row rewrite;
- the additive migration cannot be safely ordered and rolled back; or
- FUND's preserved worker/secret/bucket/candidate checkpoint changes during the interruption.

## 12. Remaining Questions

No control-owner business question blocks the accepted plans. The exact synthetic fixtures,
first-load query state, date wire/storage values and final R13-B migration ordering are
implementation evidence to capture at the relevant active boundary; they are not reasons to
reopen the settled business contract or begin R13-B early.
