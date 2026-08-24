# CR-Fix Planning Intake — LMSPro Free Day And Team Variation Request Remediation

Date: 2026-08-24

Owning lane: LMSPro / SeasonPro

Planning status: **FORMALLY TRIAGED — ACCEPTED OPERATIONAL EXPEDITE WITH TWO ORDERED
BOUNDED LIFECYCLES; R13-A AND R13-B PLANS ACCEPTED; R13-A IS THE ONLY ACTIVE CHILD;
R13-B IMPLEMENTATION REMAINS LOCKED UNTIL R13-A CLOSURE/RESELECTION; NOT IMPLEMENTATION
AUTHORITY**

Source request: the control owner identified current issues affecting “Free Date Requests”
and “Variation Request”, classified the response as a tactical remediation project and
directed that it must be completed before further FUND work. The control owner subsequently
supplied the two-type Free Date business contract and nine observed/required outcomes
recorded in Section 6.

Controlling terminology:

- **Free Date Request** is the control owner's source/business wording;
- **Free Day Request** is the current application and documentation term and is used in this
  intake when referring to code, schema, routes or existing lifecycle records;
- **Standard Free Day Request** is a C2 Club Secretary request made on behalf of a Team and
  constrained by the League's per-Team, per-season standard allowance;
- **Special Free Day** is a specific exceptional date offered by C1 for which a Club may
  apply on behalf of a Team in addition to the standard allowance; and
- **Team Variation Request** is the application and documentation term for a structured
  Team change request.

## 1. Authority And Planning Boundary

This intake is a planning-only, non-authorising handoff prepared under the Parallel Planning
Persona. It captures the control owner's direct decision and prepares the evidence boundary
for the authoritative control window.

It does not:

- register or select an executable slice;
- perform or claim formal triage acceptance;
- authorise application, schema, migration, environment or data changes;
- change the root or LMSPro portfolio `Now`/`Next` pair;
- create implementation, review/test, promotion or deployment evidence; or
- conclude or supersede any existing accepted lifecycle record.

The controlling documents remain:

- [root portfolio control](../../../00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md);
- [LMSPro / SeasonPro child roadmap](../00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md); and
- [authoritative human/AI working method](../../%3Cmodule%3E/work-method.md).

The authoritative control window subsequently registered this CR in LMSPro Section 0,
accepted the operational expedite and reconciled the root/FUND interruption in the same
local documentation change. The controlling decision is:

- [formal remediation triage](../02-triage/2026-08-24-lmspro-cr-fix-free-day-and-team-variation-request-remediation-triage.md).

This intake remains the source evidence and does not itself acquire implementation or
deployment authority from that later decision.

## 2. Purpose And Strategic Decision

Prepare one evidence-led tactical remediation project for faults in the current Free Day
Request and Team Variation Request workflows.

The settled strategic decision is:

```text
LMSPro tactical remediation
-> exact evidence capture and formal triage
-> one or more bounded corrective plans only where triage proves they are needed
-> implementation, review and controlled release through the normal lifecycle
-> explicit closure and portfolio reconciliation
-> resume FUND 1R-F-A Stage C from its preserved safe checkpoint
```

This remediation must precede further FUND execution. That is a control-owner sequencing
decision to be recorded by the authoritative control window; this PPP input does not itself
rewrite the roadmap.

## 3. Preserved FUND Resumption Boundary

The currently recorded FUND `1R-F-A` Stage C checkpoint must remain unchanged throughout the
LMSPro remediation:

- exact Stage C candidate `328aadf0a360b4c65837327060302ddc525f6168` remains preserved;
- the temporary Render worker remains suspended;
- no application secrets are injected;
- the dedicated private R2 proof bucket remains empty;
- existing Render auto-deploy services remain untouched; and
- no Stage C run, credential minting, teardown claim or later FUND child begins in parallel.

Related FUND authority and pending gate:

- [Stage C accepted plan](../../fund/03-slice-planning/2026-08-12-fund-phase-1-slice-1r-f-a-stage-c-temporary-render-private-object-proof-planning.md); and
- [Stage C exact-candidate and external execution gate](../../fund/05-review-and-test/2026-08-12-fund-phase-1-slice-1r-f-a-stage-c-exact-candidate-and-external-execution-gate.md).

## 4. Repository And Branch Preparation

The segregated local workflow is prepared as follows:

```text
application repository: isostack-bedrock
base: exact aligned dev fcd162db60956858233821fd3f29c55e17d954dd
local branch: fix/lmspro-free-day-variation-request-remediation

documentation repository: isodocs
base: exact main 4e4ed16aeed53bb5bf6f0598db1c4983c4f43987
local branch: fix/lmspro-free-day-variation-request-remediation
```

Both branches are local only. No commit, push, pull request, deployment or database action
is claimed or authorised by this intake.

## 5. Existing Accepted Foundation

The remediation must preserve and distinguish the following accepted foundations.

### 5.1 Free Day authority already corrected by R12-A

[R12-A Free Day Owner Notice Authority](CR-Fix-2026-08-11-lmspro-free-day-owner-notice-authority.md)
corrected one specific policy fault: the League Owner's configured standard Free Day notice
period is authoritative from 1 through 90 days, with 28 as the unattended default rather
than a hidden minimum.

R12-A does not establish that every Free Day Request behaviour is correct, but it must not
be reopened or altered unless the new evidence proves a regression or a directly coupled
fault. Its exclusions include Special Free Days, request-window policy, quota, Team
eligibility, approval and notification behaviour.

This new CR intentionally includes the separately supplied standard-versus-Special quota
separation and Special Free Day application-list presentation requirements. Those are new
bounded inputs; they do not reopen R12-A's notice-period decision.

### 5.2 Existing team-context notification routing

The completed R5-A/R5-B foundation routes Team-scoped Variation Request and Free Day Request
notifications through event-derived Division/AGG and Age Group responsibility before the
League Admin fallback. A remediation must not replace that architecture merely because a
particular notification is missing, duplicated or misrouted.

Related planning record:

- [R5-B notification manager scoped routing](../03-slice-planning/2026-07-06-lmspro-remediation-slice-r5-b-notification-manager-scoped-routing-and-role-cleanup-planning.md).

### 5.3 Existing workflow and presentation foundation

The current application already contains:

- standard Free Day request submission, season/notice/window/date/quota checks, request
  history, League approval and Team-scoped notification paths;
- Team Variation Request creation, club/team/season scoping, cancellation, League list and
  filtering, replies, individual and bulk review, update-confirmation and notification
  paths; and
- shared operational-Team eligibility rules plus dashboard/count/navigation surfaces.

The older [CR-20 Team Variation Request concept](../planning/CR-20-Team-Variation-Request-And-Seasonal-Club-Capabilities.md)
is provenance and product context. Current source and accepted lifecycle records control
the implemented behaviour; CR-20 must not be treated as a fresh implementation plan.

## 6. Current Evidence Position

### 6.1 Settled Free Day business contract

1. There are two distinct Free Day request types: **standard** and **Special**.
2. C1 configures the maximum number of standard Free Day Requests permitted for each Team
   in a season. The current default is two per Team per season.
3. A C2 Club Secretary submits a standard request on behalf of a Team.
4. C1 sees standard requests in the Free Day dashboard-card summary and the detailed Free
   Day Request management screen.
5. Once a Team's active standard requests consume its configured allowance, both the UI and
   the authoritative server mutation must refuse another standard request for that season.
6. A Special Free Day is a specific exceptional date created by C1. A Club may apply for
   that Special date on behalf of a Team in addition to the Team's standard allowance.
7. Special Free Day applications must never contribute to the standard allowance's used,
   remaining or Teams-at-limit calculations, and must never block another otherwise valid
   standard request.

Active standard `PENDING`, `APPROVED` and `CONFIRMED` requests consume or reserve the
allowance. `CANCELLED` and `REJECTED` requests do not. This preserves the current safe rule
that a Team cannot create excess pending requests while awaiting C1 action.

### 6.2 Supplied observations and required outcomes

#### 6.2.1 Standard quota calculation includes Special Free Days

Observed: a Team's displayed Free Days used/at-limit calculation includes Special Free Day
applications and can indicate that the Team has consumed its standard allowance, currently
often displayed as two of two.

Required: only active standard Free Day Requests contribute to the standard per-Team,
per-season allowance. Special Free Days remain additional exceptions.

#### 6.2.2 Standard-request gating is not trustworthy at the displayed limit

Observed: the system can still appear to permit a standard Free Day Request when the UI
indicates that the Team has reached its allowance.

Required:

- if the apparent limit is caused only by incorrectly counted Special Free Days, correct
  the indication and continue to allow the valid standard request; and
- if the actual active standard-request count equals the configured allowance, disable the
  C2 submission controls and reject a direct server request without creating a row or
  sending a notification.

The dashboard indication, Team usage result, C2 form and server mutation must use one
standard-only quota definition.

#### 6.2.3 `All` status initially displays no Free Day Requests

Observed: on the C1 Free Day Request list, selecting status `All` can initially show no
requests. Selecting another status causes records to appear, after which `All` works.

Required: `All` must return and display the complete result allowed by the other active
filters on first selection and first load, without requiring a status toggle or stale-query
workaround.

#### 6.2.4 Per-column sorting on the Free Day Request table

Required: enable the normal IsoStack table sort interaction for each meaningful Free Day
Request column. Selecting a column heading sorts ascending, selecting it again sorts
descending, and a visible up/down arrow identifies the active column and direction.
Drag-and-drop physical column rearrangement is not required.

The control owner has also confirmed that this interaction is the default for new tables in
IsoStack modules. It is already authoritative in the mandatory
[Table CRUD Pattern guide](../../../guides/table-crud-pattern.md) and the
[module architecture template](../../../core/modules/module-architecture-template.md). The
remediation therefore conforms to an existing standard; no separate standards change is
required.

#### 6.2.5 Pending Requests summary box navigation

Required: make the C1 pending-request summary box actionable. Selecting it must open or
navigate to the detailed Free Day Request list with the current season and `PENDING` status
filter applied.

#### 6.2.6 Teams At Limit summary box navigation

Required: make the C1 Teams At Limit summary box actionable. Selecting it must display the
Teams genuinely at the standard allowance, using the same standard-only quota definition
as C2 gating and showing enough Team/Club/usage context for C1 to understand the result.

#### 6.2.7 One-day date display offset

Observed: one or more screens display a Free Day date one calendar day earlier or later
than the intended date.

Required: a selected/stored date-only Free Day value must display as the same calendar date
across C1 and C2 lists, forms, modals and notifications, including across GMT/BST boundaries.
The exact operator-observed screen was not available, but source-led investigation has
identified deterministic affected paths and a controlled reproduction in Section 6.5.1.

#### 6.2.8 Special Free Day application ordering and Age Group filter

Required: inside each Special Free Day's application list:

- default to alphanumeric ascending order by Club name; and
- allow C1 to filter applications by Age Group without altering the Special date or
  applications outside the visible filter.

#### 6.2.9 Team Variation Request `DEFERRED` status

Settled workflow requirement:

```text
PENDING
  -> Approve through the existing workflow
  -> Reject through the existing workflow
  -> Defer without applying the requested Team change

DEFERRED
  -> Return to Pending

PENDING (restored)
  -> process through the existing normal workflow
```

The C1 status filter must include `Deferred` and show deferred requests. When a deferred
request is opened, its CRUD modal must expose only the status-changing action `Return to
Pending`; apart from passive close, it must not offer Approve, Reject, Save Reply or another
mutable workflow action until the request has returned to `PENDING`. Deferral and return
must not mutate the Team or create a replacement request.

The new state must be durable, tenant/season scoped, auditable and visible truthfully to
authorised users. Formal planning must define the exact additive schema migration,
transition mutations, status labels/colours, count semantics and retained review-note
behaviour without changing the accepted existing approval/rejection/update-confirmation
workflow.

Additional settled behaviour:

- C1 may provide an optional deferral reason;
- C2 sees both the `DEFERRED` status and any deferral reason on its dashboard;
- C2 may cancel its own request while it is `DEFERRED`;
- `DEFERRED` appears only in `All` and the explicit `Deferred` filter for C1, not in the
  existing `OUTSTANDING` aggregate or C1 dashboard counts; and
- no new or changed automated notification is required for deferral or return-to-pending;
  the League will handle any necessary communication manually.

### 6.3 Read-only source observations for formal triage

Current exact application `fcd162db` provides the following planning evidence:

- `LMSProSeason.maxFreeDaysPerTeam` has a schema and create-path default of two;
- the standard request mutation and Team usage query already exclude rows with a
  `specialFreeDayId` and treat standard `PENDING`/`APPROVED`/`CONFIRMED` rows as consuming
  the allowance;
- the C2 request form already disables date/reason/submit controls from the Team usage
  result, and the server mutation independently checks the allowance;
- the C1 `getSeasonStats` Teams-at-limit loop currently counts every `APPROVED` row without
  excluding `specialFreeDayId` and uses a different status set from the C2 usage query;
- the C1 Free Day summary boxes are currently non-interactive, although the API already
  returns `teamsAtLimitDetails`;
- the Free Day `DataTable` supplies no sort state or sortable-column contract;
- the Special Free Day UI renders each day's applications in returned order and has no Age
  Group filter;
- several Free Day paths contain explicit UTC/date-only normalisation, so the remaining
  one-day offset must be corrected at the specific inconsistent input/display boundaries
  rather than through a broad timezone rewrite;
  and
- `TeamVariationRequestStatus` currently contains `PENDING`, `APPROVED`,
  `UPDATE_CONFIRMED`, `REJECTED` and `CANCELLED`, but not `DEFERRED`.

The `getSeasonStats` divergence is a strong explanation for the false C1 Teams-at-limit
indication and the apparently contradictory C2 ability to submit. It remains a triage
hypothesis until a failing fixture or controlled reproduction proves the complete symptom.

### 6.4 Remaining reproduction evidence

| Evidence field | Required detail |
| --- | --- |
| Environment and exact application commit | Reported in all environments at exact `fcd162db`; retain a controlled synthetic proof for each accepted fault |
| League/tenant, season and Team state | Record synthetic/non-sensitive equivalents, configured cap and standard/Special request statuses |
| Acting persona and component access | Confirm the exact C1 and C2 roles used for each path |
| Initial filters and route | Capture URL, status/time-period filters and first-load state for the empty `All` result |
| Date offset | Reproduce the source-identified BST paths in Section 6.5.1 and record selected, wire, stored and displayed values |
| Frequency and workaround | Validate the source-led containment in Section 6.5.2 against current operations |
| Existing data impact | No existing-data repair is required or authorised; prove the correction does not rewrite existing rows |

No implementation diagnosis should be accepted before this evidence distinguishes the
confirmed summary divergence from any separate query-state, server-policy, persistence,
date-normalisation or notification fault.

### 6.5 Requested investigation results

#### 6.5.1 Former question 14.3 — one-day date offset

Read-only source tracing and a deterministic `Europe/London` calendar simulation identify
two inconsistent input boundaries on exact `fcd162db`:

1. the C1 Free Day management screen's reusable `Request Free Day` modal submits the local
   `DateInput` value directly, after which the standard router derives UTC year/month/day;
2. the C1 Special Free Day create/edit forms submit local picker values directly and the
   Special router persists them without date-only normalisation; while
3. the dedicated C2 Club Free Days standard-request form correctly rebuilds the selected
   local calendar date as UTC midnight before submission.

In UK summer time, selecting `15 August 2026` creates a local instant of
`2026-08-15 00:00 BST`, serialised as `2026-08-14T23:00:00.000Z`. The current Special path
can persist that instant. Its own C1 Special list formats it in local time and still shows
15 August, but UTC-component consumers show 14 August. Susceptible downstream surfaces are:

- C1 Change Request Management -> Free Day Requests list and edit modal;
- C2 Club -> Free Days Special-day options/banner and request-history table;
- any Free Day notification formatted in the runtime timezone; and
- the reusable C1 standard-request submission path, which can normalise the already shifted
  wire value to UTC midnight on 14 August.

The issue is deterministic for those input paths during BST; the same UK local-midnight
selection does not shift during GMT. Commit `9bd6baed` (5 May 2026) added correct client-side
normalisation to the dedicated C2 standard form and UTC-based display to several standard
surfaces, but it did not cover the reusable C1 request component or Special create/edit
paths. Formal triage should reproduce these exact synthetic paths and inspect notification
rendering; it does not need another control-owner answer before doing so.

#### 6.5.2 Former question 14.11 — containment, urgency and last-known-good boundary

No single workaround fully and safely restores the requested behaviour. The proportionate
temporary containment is:

- treat the C1 `Teams At Limit` summary as non-authoritative and verify the active standard
  `PENDING`/`APPROVED`/`CONFIRMED` count without Special applications; do not bypass an
  authoritative server refusal;
- for the initially empty list, use an explicit status and date-period filter, then return
  to `All` if needed; note that source currently defaults the time period to `Future`, even
  when status, Club and Age Group are blank;
- use the detailed lists and explicit filters instead of relying on non-clickable summary
  boxes or unavailable column sorting/Age Group filtering;
- treat a Special Free Day date shown across mixed C1/C2 surfaces as untrusted during BST,
  cross-check it against the intended League date and communicate that date manually; avoid
  unnecessary create/edit re-entry until the path is corrected; and
- leave a request `PENDING` and track a temporary deferral manually rather than approving or
  rejecting it, accepting that it will remain visible in current pending/outstanding counts.

The remediation is time-critical because these are live current-season operational paths:
quota misinformation can misdirect Club submissions and League decisions, an empty list can
hide work awaiting action, and a one-day date discrepancy can communicate the wrong fixture
date. The repository contains no evidence of a security incident, production outage or
required historic-data repair, and it does not establish a separate calendar deadline; the
control owner's sequencing decision that this work precedes further FUND execution is the
current expedite basis.

There is no single last-known-good application boundary for the combined project:

- the C1 `getSeasonStats` implementation has used its `APPROVED`-only calculation since the
  original Free Days commit `540b46f3` on 14 January 2026;
- Special Free Days and their unnormalised create/edit path arrived in `7b888814` on
  3 March 2026, after which the pre-existing C1 statistic could include Special approvals;
- `9bd6baed` on 5 May 2026 was a partial standard-path date correction, not a proven good
  boundary for Special dates or every request entry point; and
- summary navigation, column sorting, Special-list filtering and `DEFERRED` are new required
  capabilities and therefore have no earlier good implementation to restore.

Exact `fcd162db` is consequently the reproduction baseline, not a regression boundary from
which the combined remediation can safely be reverted.

#### 6.5.3 Former question 14.12 — bounded-plan recommendation

Formal triage should retain one tactical CR/project but authorise two ordered bounded plans:

1. **Free Day integrity and management presentation** — observations 6.2.1 through 6.2.8,
   including the standard-only quota, first-load/list state, table sorting, summary
   navigation, date-only consistency and Special-list presentation; then
2. **Deferred Team Variation workflow** — observation 6.2.9, including the additive schema
   migration, transitions, optional reason, C1 filtering/count exclusions, C2 visibility and
   cancellation, audit and regression proof.

The split is warranted because the first plan can remain within the Free Day query/UI/date
boundary without an intended schema change, while the second requires an additive enum or
equivalent persistence migration and has a distinct transition/rollback gate. The second
plan should follow the first, and FUND `1R-F-A` Stage C should resume only after both are
closed and the portfolio is reconciled. If controlled date reproduction unexpectedly proves
that stored-data compatibility requires migration or repair, triage must stop and re-scope;
it must not silently add that work to the first plan.

## 7. Included Planning Scope

This remediation intake includes planning for:

- exact reproduction of the nine supplied observations/requirements;
- one canonical standard-only per-Team, per-season quota calculation shared by C1 summary,
  Team usage and authoritative C2 gating;
- explicit exclusion of Special Free Day applications from that standard quota;
- first-load and `All`-status Free Day list correctness;
- normal per-column Free Day Request sorting;
- actionable Pending Requests and Teams At Limit summary boxes with truthful filtered
  destinations;
- date-only consistency across affected C1/C2 screens and messages;
- per-Special-date Club-name ordering and Age Group filtering;
- durable `DEFERRED` Team Variation Request state and the exact
  `PENDING -> DEFERRED -> PENDING` workflow;
- an optional deferral reason, C2 Deferred visibility and C2 cancellation while Deferred;
- exclusion of Deferred requests from C1 `OUTSTANDING` and dashboard-count semantics;
- C1 League and C2 Club authority, component access, tenant, Club, Team and season scoping;
- request create/list/cancel/review/approve/reject/update-confirmation behaviour where
  directly implicated by evidence;
- status, quota, pending-count, filter, cache/invalidation and navigation truthfulness where
  directly implicated;
- date-only notification rendering where directly implicated, while preserving existing
  notification events, recipients and routing;
- safe handling of individual and bulk actions, retries, partial failure and concurrency;
  and
- proportionate automated, human, staging and production acceptance boundaries for the
  eventual corrective work.

Formal triage should validate and authorise the two-plan boundary recommended in Section
6.5.3. It must stop and re-scope if reproduction proves that boundary unsafe.

## 8. Explicitly Excluded Scope

Unless exact evidence and accepted triage prove inseparable, exclude:

- a Free Days or Team Variation redesign;
- new seasonal workflow, continuation, registration or automation capability;
- new request types, dashboards or general communications features beyond the accepted
  `DEFERRED` state and filtered summary/list navigation;
- Special Free Day creation, availability, application-deadline, approval, confirmation or
  Club-scope policy beyond standard-quota exclusion, date-only input/display consistency
  and list ordering/filter presentation;
- broad Notification Manager or role-model refactoring;
- new Deferred notification events or changes to existing notification recipients/routing;
- historic request reconciliation, bulk data repair or status rewriting;
- schema changes beyond the smallest accepted additive `DEFERRED` persistence migration;
- weakening component, C1/C2, tenant, Club, Team or season authority;
- customer/child/purchaser data use in tests;
- FUND, Commerce, Render Stage C or R2 implementation; and
- staging, production or shared-database action before separate control-window authority.

## 9. Candidate Planning Workstreams

These are non-executable planning workstreams, not slice identifiers or implementation
authority:

1. **Evidence and reproduction** — capture one minimal deterministic failing case per
   distinct symptom and the last known good boundary where available.
2. **Authority and data-boundary review** — prove C1/C2, tenant, Club, Team and season
   ownership for every implicated query and mutation.
3. **Standard quota source of truth** — align standard-only calculation, C1 summary details,
   C2 display and direct server refusal without changing R12-A notice policy.
4. **Free Day management presentation** — correct first-load filtering, sortable columns,
   summary-box navigation, date-only presentation and filtered Teams-at-limit detail.
5. **Special application presentation** — add deterministic Club ordering and Age Group
   filtering within each Special Free Day while preserving workflow semantics.
6. **Deferred Variation state** — plan the smallest durable enum/schema, transition,
   audit, filter, modal-action and regression boundary for `DEFERRED`.
7. **Shared consistency review** — determine whether a genuinely shared query-state,
   eligibility, routing, transaction or date-only cause warrants one coupled correction.
8. **Acceptance and recovery design** — define failing-first automated evidence, controlled
   role-specific human smoke, rollback, data-repair refusal and promotion gates.

Formal triage should map workstreams 1 through 5, 7 and 8 into the first bounded plan, and
workstreams 2, 6 and 8 into the second where they concern Deferred Variations. This CR does
not itself authorise either plan or an implementation.

## 10. Risk And Expedite Considerations

| Risk | Planning control |
| --- | --- |
| Cross-tenant or cross-Club request visibility/action | Fail closed; use exact tenant, permitted-Club, Team and season fixtures |
| Special applications consume the standard allowance | Use one standard-only predicate and prove Special rows never affect used/remaining/at-limit/gating |
| Incorrect Team lifecycle mutation | Snapshot expected/current values; prove atomic transition and rollback |
| Duplicate request or bulk partial completion | Exercise concurrency, idempotency and all-or-truthful-partial-failure behaviour |
| Date display correction changes otherwise working notifications | Preserve current events, recipients and routing; test only the accepted date-only rendering boundary without real delivery |
| `DEFERRED` is treated as actionable `PENDING` | Allow only explicit return-to-pending; prevent approve/reject and Team mutation while deferred |
| Additive enum migration leaves incompatible application/schema state | Validate exact migration order, rollback posture and current-row compatibility before shared deployment |
| UTC/local conversion changes the intended date | Use date-only fixtures across GMT/BST boundaries and refuse broad timezone rewrites without reproduction |
| Historic request/data corruption | No repair or rewrite without separately accepted evidence and recovery plan |
| Personal data exposure | Use synthetic users, Teams, Clubs, reasons and notes; retain no sensitive exports |
| Scope expansion into seasonal redesign | Stop at the smallest incident-ending correction |
| FUND resource drift during interrupt | Preserve and re-verify the recorded Stage C no-secret/empty-bucket checkpoint |

The control owner has decided that this tactical remediation precedes FUND. Formal triage
must still record operational severity, workaround safety, correction risk and whether the
project is an accepted expedite or an ordinary reselection. The root roadmap must express
that decision rather than allowing two simultaneous portfolio `Now` outcomes.

## 11. Acceptance Principles For Later Planning

Any accepted corrective plan should require, in proportion to the evidenced faults:

- a failing-first reproduction for every accepted symptom;
- unchanged R12-A Free Day notice authority unless a regression is explicitly proved;
- Special Free Day applications excluded from every standard used, remaining and at-limit
  calculation;
- standard `PENDING`/`APPROVED`/`CONFIRMED` quota semantics applied consistently;
- a true standard at-limit Team disabled in C2 UI and refused by direct server call with no
  new row or notification;
- a Team falsely shown at limit only because of Special applications corrected and still
  able to make its remaining standard request;
- `All` displaying the complete result permitted by active filters on first load/selection;
- meaningful Free Day Request columns sorting ascending/descending on successive heading
  selections, with a visible direction arrow on the active column;
- Pending Requests and Teams At Limit boxes navigating to truthful filtered results;
- every accepted date-only fixture displaying the same calendar date across affected C1/C2
  surfaces and GMT/BST boundaries;
- each Special Free Day application list sorting Club names alphanumerically and filtering
  by Age Group;
- `PENDING -> DEFERRED` causing no Team mutation, and a deferred modal exposing only
  `Return to Pending` as its workflow action apart from passive close;
- `DEFERRED -> PENDING` restoring the existing normal workflow without a replacement row,
  duplicate notification or loss of request evidence;
- an optional deferral reason retained and shown to the authorised C2 submitter;
- C2 being able to cancel its own Deferred request without first returning it to Pending;
- Deferred filter, labels, audit and authorised C2 visibility behaving truthfully while
  C1 `OUTSTANDING` and dashboard counts exclude Deferred;
- no new Deferred notification event and no change to existing notification recipients or
  routing;
- UI and direct server calls enforcing the same accepted policy;
- exact C1/C2, tenant, permitted-Club, Team and season boundaries;
- truthful pending/approved/rejected/cancelled/update-pending states and counts;
- no duplicate active request or unintended Team mutation;
- atomic or explicitly truthful bulk behaviour;
- exact notification recipients with no duplicate send;
- focused regression coverage for the unaffected sibling workflow and Special Free Days;
- no schema change beyond the accepted additive Deferred-state migration and no unplanned
  historic data correction;
- a controlled local human matrix before staging consideration; and
- explicit closure/reconciliation before FUND Stage C resumes.

## 12. Settled Business And Planning Decisions

1. The reported work is a tactical LMSPro remediation project.
2. Standard and Special Free Days are distinct request paths.
3. The League-configured standard allowance is per Team and per season, with a current
   default of two.
4. Special Free Day applications are additional exceptions and never consume or block the
   standard allowance.
5. A Team at its true standard allowance must be gated in both C2 UI and the authoritative
   server mutation.
6. The C1 Free Day list must load `All` correctly, support normal per-column sorting and
   present consistent date-only values.
7. The Pending Requests and Teams At Limit summary boxes must be actionable and open
   truthful filtered details.
8. Each Special Free Day's application list must default to alphanumeric Club order and be
   filterable by Age Group.
9. Team Variation Requests require a durable `DEFERRED` state.
10. C1 may move a `PENDING` request to `DEFERRED`; the deferred modal exposes only `Return
    to Pending` as its workflow action apart from passive close; return restores the
    existing normal pending workflow without applying a Team change.
11. This remediation must be handled before further FUND work.
12. FUND `1R-F-A` Stage C remains preserved at its recorded safe checkpoint during the
   interrupt.
13. Application and documentation work use matching local segregated branches named
   `fix/lmspro-free-day-variation-request-remediation`.
14. Existing accepted R12-A, R5 and current Team Variation foundations are preserved unless
   failing evidence proves a regression or inseparable correction.
15. No implementation, commit, push, deployment, migration or data repair is authorised by
   this intake.
16. The faults are reported across all environments at exact application `fcd162db`; formal
    triage must retain synthetic reproduction evidence rather than treating that report as
    implementation proof.
17. The empty-`All` symptom occurs from the default listing state with status, Club and Age
    Group blank; source shows that the current season is selected automatically and the time
    period defaults to `Future`, which controlled reproduction must make explicit.
18. Table sorting means heading-click ascending, second-click descending and a visible
    up/down direction arrow; it does not mean drag-and-drop column rearrangement. This is
    also the control owner's default requirement for new IsoStack module tables.
19. The summary boxes must produce their settled filtered outcomes; the smallest consistent
    existing-screen, inline or modal presentation remains a bounded planning decision.
20. A deferral reason is optional.
21. Deferred requests appear to C1 only in `All` and the explicit `Deferred` filter, not in
    `OUTSTANDING` or C1 dashboard counts.
22. C2 sees the Deferred status and reason and may cancel its own request while Deferred.
23. Existing data requires no remediation and must not be rewritten by this work.
24. Existing notifications and routing are working. Deferred creates no new automated
    notification requirement; necessary communication will be handled manually.
25. Source-led investigation has identified deterministic BST-sensitive standard and Special
    date input/display paths; another control-owner answer is not required before formal
    reproduction.
26. There is no single last-known-good boundary for the combined project; exact `fcd162db`
    is the reproduction baseline.
27. The planning recommendation is one tactical CR/project with two ordered bounded plans:
    Free Day integrity/presentation first, then the Deferred Variation workflow.

## 13. Triage Disposition And Next Handoff

The authoritative control window has registered this CR, accepted the expedite, reconciled
the root/LMSPro/FUND controls and accepted two sequential child plans. The resulting handoff
is:

1. use [R13-A](../03-slice-planning/2026-08-24-lmspro-remediation-slice-r13-a-free-day-integrity-and-management-presentation-planning.md)
   as the only active child and stop for its explicit implementation decision;
2. carry the remaining synthetic reproduction details in Section 6.4 into R13-A, using
   the exact date paths and containment findings in Section 6.5 and reconciling the reported
   blank default filters with the source-default `Future` time period;
3. retain [R13-B](../03-slice-planning/2026-08-24-lmspro-remediation-slice-r13-b-deferred-team-variation-workflow-planning.md)
   as accepted planning but keep its implementation inactive until R13-A closure,
   reconciliation and a new explicit control-owner decision;
4. use the existing canonical Table CRUD Pattern and module architecture template as the
   sorting acceptance authority;
5. preserve the matching local application/documentation branch boundary; and
6. stop for explicit implementation authority before application or data changes.

## 14. First-Child Planning Evidence Actions

Former questions 14.3, 14.11 and 14.12 have been investigated in Section 6.5. No further
control-owner answer is required for them. The accepted first-child plan must:

1. create one synthetic tenant/season/Team fixture for each distinct accepted fault and
   record the exact C1/C2 persona and component access;
2. reproduce the empty-`All` symptom from the actual initial route and distinguish blank
   status from the source-default current season and `Future` time-period filter;
3. reproduce the C1 reusable standard-request and Special create/edit date paths during BST,
   record selected/wire/stored/displayed values, and inspect notification rendering without
   sending a real message;
4. confirm that no existing-row rewrite or repair is required, consistent with the settled
   control-owner direction; and
5. retain the accepted operational-expedite and FUND-resumption boundary without inventing
   a separate calendar deadline.
