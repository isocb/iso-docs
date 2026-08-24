# LMSPro Remediation Slice R13-A — Free Day Integrity And Management Presentation Planning

Date: 2026-08-24

Module: LMSPro / SeasonPro

Status: **ACCEPTED BOUNDED PLAN; FIRST AND ONLY ACTIVE CHILD; IMPLEMENTATION NOT STARTED
AND REQUIRES AN EXPLICIT CONTROL-OWNER IMPLEMENTATION INSTRUCTION**

Control depth: **High** — tenant/Club/Team authority, operational quota integrity and
notification date rendering require complete negative, role/tenant and human evidence.

```text
Current state: Accepted plan; implementation not started or authorised
Last proven commit: fcd162db60956858233821fd3f29c55e17d954dd
Current environment: Local documentation and clean local application baseline only
Next human decision/test: Explicit control-owner decision whether to begin R13-A implementation
Safe resumption point: Start the Section 3 failing-first reproduction matrix at exact fcd162db
```

Source CR-Fix:

- [Free Day and Team Variation Request remediation CR-Fix](../01-cr-inputs/CR-Fix-2026-08-24-lmspro-free-day-and-team-variation-request-remediation.md)

Accepted triage:

- [Free Day and Team Variation Request remediation triage](../02-triage/2026-08-24-lmspro-cr-fix-free-day-and-team-variation-request-remediation-triage.md)

Sequential child:

- [R13-B Deferred Team Variation workflow](2026-08-24-lmspro-remediation-slice-r13-b-deferred-team-variation-workflow-planning.md)

Exact application baseline:

```text
repository: isostack-bedrock
branch: fix/lmspro-free-day-variation-request-remediation
commit: fcd162db60956858233821fd3f29c55e17d954dd
state at planning: clean
```

## 1. Control Decision And Objective

Accept `R13-A` as the first bounded child of the tactical remediation CR-Fix. It is the only
active LMSPro delivery candidate.

The objective is to make standard Free Day quota, C1 list/summary presentation, Special
application presentation and Free Day date-only behaviour truthful and mutually consistent,
without changing the already accepted R12-A notice-period policy or adding a schema/data
repair.

Creating this record moves the child into accepted slice planning. It does not authorise
application edits, a commit, push, migration, database action, environment action or
deployment. The control owner must explicitly instruct implementation before work begins in
the application repository.

## 2. Confirmed Source Boundary

Read-only investigation at exact `fcd162db` established:

- `freeDays.request` and `freeDays.getTeamUsage` already exclude rows with a
  `specialFreeDayId` and treat standard `PENDING`, `APPROVED` and `CONFIRMED` requests as
  reserving/using the seasonal allowance;
- `freeDays.getSeasonStats` diverges by counting `APPROVED` rows without excluding Special
  applications, which can create a false C1 Teams At Limit result;
- the request table has no sort state and the Pending Requests and Teams At Limit summaries
  are not actionable, although `teamsAtLimitDetails` already exists;
- the first-load query has a current-season selection, blank status/Club/Age Group and
  `Future` time period, so `All` must mean all rows permitted by every still-active filter;
- the C1 reusable standard request form and the C1 Special create/edit forms send picker
  `Date` objects without consistently converting the selected local calendar day to UTC
  midnight;
- the dedicated C2 standard request form already performs that conversion and must remain a
  known-good sibling;
- a UK BST selection of 15 August 2026 can otherwise travel as
  `2026-08-14T23:00:00.000Z`, producing a one-day discrepancy in UTC-component consumers;
- notification templates currently format Free Day values through runtime-local date
  formatting; and
- each Special-day application list uses returned order and has no Age Group filter.

No source evidence requires a Prisma schema change or historic-row rewrite for this child.

## 3. Required Failing-First Reproduction Matrix

Before corrective implementation, record focused synthetic evidence for each row. Fixtures
must use non-sensitive organisations, Clubs, Teams, users, reasons and notes.

| Ref | Synthetic precondition and action | Baseline failure to capture | Corrected result |
| --- | --- | --- | --- |
| A1 | Cap 2; Team has one standard approved request and one approved Special application | C1 can show the Team at limit while C2 usage/gating still permits a standard request | used 1, remaining 1, not at limit everywhere; Special row has no quota effect |
| A2 | Cap 2; Team has standard requests across `PENDING` and `APPROVED` or `CONFIRMED` | Divergent summary/status semantics | used/reserved 2 and at limit everywhere; UI disables and direct request refuses with no row/email |
| A3 | C1 opens the actual default current-season/`Future` list and selects `All` | Initial `All` can render no rows until another status is selected | first load and return to `All` show every row allowed by the active season/time/Club/Age Group filters |
| A4 | At least two distinct values in every meaningful displayed request column | Heading clicks do not sort | first click ascending, second descending, active heading shows direction; selection/action behaviour is unchanged |
| A5 | Season contains pending requests and multiple true at-limit Teams | Summary cards do not navigate | Pending opens a truthful season-wide Pending list; Teams At Limit opens a truthful Team-detail list |
| A6 | C1 selects/edits standard and Special dates in GMT and BST, including 15 August 2026 | selected, wire, stored or displayed calendar dates can differ | picker day, wire/storage UTC date-only value, C1/C2 display and Free Day notification rendering retain the same calendar date |
| A7 | One Special day has applications from mixed-case/alphanumeric Club names and multiple Age Groups | returned order is unstable and no Age Group filter exists | default Club ordering is deterministic alphanumeric and the per-day Age Group filter shows only matching applications |

For A3, record route, initial URL state, selected season, status, time period, Club and Age
Group. Do not classify rows excluded by the still-active `Future` filter as an `All` defect.

For A6, record the picker value, serialised request value, stored value and every affected
display. Existing off-midnight rows may be read for compatibility proof but must not be
changed.

## 4. Implementation Contract

### 4.1 One standard-only quota policy

Introduce one small pure Free Day quota policy or query-building helper, with focused tests,
and use it from the authoritative standard-request gate, Team usage and season-summary
calculation.

The accepted policy is:

```text
scope       = same organisation + season + Team
kind        = standard only (specialFreeDayId is null)
quota state = PENDING or APPROVED or CONFIRMED
used        = count(quota state)
remaining   = max(0, season cap - used)
at limit    = used >= season cap
```

Special applications never change standard used, remaining, at-limit or request-gating
outcomes. The direct server mutation remains authoritative and must fail closed under a
stale browser or concurrent submission. It must create neither a request nor a notification
when the quota is exhausted.

The summary query must remain organisation- and season-scoped, include the Club identity
needed for a useful Team-detail list, and avoid an avoidable per-Team count loop if a bounded
grouped query can express the same policy safely.

### 4.2 First-load, `All` and cache truthfulness

Keep the existing filter meanings. Blank status means no status predicate; it must not be
represented by an invalid enum or stale cached status. `All` returns every request permitted
by the selected season, time period, Club and Age Group.

Prove initial query enablement, controlled-season selection and mutation invalidation. A
successful create/update/approve/reject/confirm/cancel action must refresh the list and the
summary values that it can affect without requiring a hard browser reload.

### 4.3 Canonical table sorting

Apply the canonical IsoStack sortable-table interaction documented in:

- [table CRUD pattern](../../../guides/table-crud-pattern.md); and
- [module architecture template](../../../core/modules/module-architecture-template.md).

Every meaningful displayed request column—Club, Team/Age Group, Date, Reason, Status and
Requested By/submitted date—must have a deterministic comparator. The first heading click
sorts ascending, the second descending, and only the active heading shows its direction.
Sorting is local presentation over the complete server-filtered result and must not change
row identity, checkbox selection, available actions or tenant scope. Null/blank values and
case differences require a deterministic order.

### 4.4 Actionable summary destinations

The Pending Requests summary must act as a keyboard-operable control and establish a
truthful season-wide destination state: selected season retained, status `PENDING`, time
period `All`, and Club/Age Group cleared so the visible list reconciles to the summary count.
Focus or scroll should move to the resulting request list.

The Teams At Limit summary must be keyboard-operable and show a dedicated season-wide detail
list from corrected `teamsAtLimitDetails`. Each row shows at least Club, Team and standard
used/cap values, with deterministic Club then Team order. It must not pretend that a single
request-table status filter represents a Team-level aggregate. An empty result is represented
truthfully, and the detail must not expose another organisation.

### 4.5 Date-only boundary

Use an explicitly named date-only helper to convert a calendar picker selection by its local
year/month/day to UTC midnight before transport. Apply it to the proven inconsistent C1
standard request and C1 Special create/edit paths; preserve the already-correct C2 standard
path.

Both standard and Special server create/update boundaries must defensively persist accepted
date-only values at UTC midnight. Render these domain date-only values from UTC calendar
components on the accepted C1/C2 Free Day surfaces. Format only Free Day notification date
fields with date-only semantics; do not alter the shared semantics of disciplinary,
timestamp or unrelated notification fields.

Cover both `specialDate` and `applyByDate`. Preserve R12-A notice arithmetic, season
boundaries and Special deadline rules.

### 4.6 Special application ordering and filter

For each Special Free Day, present applications by Club name using a deterministic
case-insensitive alphanumeric comparison, with Team name as a stable tie-break. Add an Age
Group filter whose options derive from that day's authorised applications or a safely shared
season list. `All Age Groups` restores the complete per-day list.

Filtering and ordering are presentation-only. They must not alter selection, bulk
approve/reject/confirm membership, Special availability, scoped-Club policy or lifecycle
rules.

## 5. Expected Application Files

Likely bounded files are:

```text
src/modules/lmspro/lib/free-day-quota-policy.ts
src/modules/lmspro/lib/free-day-quota-policy.test.ts
src/modules/lmspro/lib/free-day-date-only.ts
src/modules/lmspro/lib/free-day-date-only.test.ts
src/server/core/routers/lmspro/freeDays.router.ts
src/server/core/routers/lmspro/specialFreeDays.router.ts
src/modules/lmspro/components/dashboard/FreeDaysManage.tsx
src/modules/lmspro/components/dashboard/FreeDaysRequest.tsx
src/modules/lmspro/components/dashboard/SpecialFreeDaysManage.tsx
src/app/(app)/app/lmspro/club/free-days/page.tsx
src/modules/lmspro/communications/notification-templates.ts
```

Focused router/component tests or a small presentation helper test may be added beside the
affected source. `src/lib/timezone.ts` may be consumed if its existing date-only contract is
proved exact, but a broad rewrite of that shared file is not expected.

No Prisma schema or migration file is expected. Stop if one becomes necessary.

## 6. Automated Acceptance

The implementation lifecycle must record:

1. failing-first and corrected focused tests for A1–A7 where automation is proportionate;
2. direct-server quota proof for false-Special limit, true standard limit and concurrent or
   stale-client refusal;
3. organisation/season/Team negative-scope tests;
4. GMT/BST date-only fixtures for standard create/edit, Special create/edit/list and Free Day
   notification rendering;
5. unchanged R12-A notice-policy tests;
6. changed-file lint;
7. `npm run type-check`;
8. `npm test -- --run`;
9. `npm run verify`;
10. `npm run build`;
11. `git diff --check`; and
12. exact-commit Security Scan at each later authorised promotion boundary.

No automated test sends real email or mutates shared/staging/production data.

## 7. Human Acceptance Schedule

Use controlled synthetic C1 and C2 accounts and a disposable season/Teams. At local before
any promotion, and later on staging only if separately authorised:

1. prove A1 and A2 counts, remaining values, C2 disabled state and direct refusal;
2. load the C1 list fresh at its actual defaults, select every status and return to `All`;
3. combine `All` with Future/Past/All dates, Club and Age Group filters;
4. sort every meaningful column ascending and descending and verify the direction indicator;
5. activate both summaries with pointer and keyboard and reconcile visible destinations to
   their numbers;
6. create and edit one C1 standard request date in a BST fixture and verify C1/C2 displays;
7. create and edit one Special date/deadline in BST and one in GMT, then verify Special
   options, banner, history, management list and previewed notification content;
8. prove Special applications sort by Club and filter/reset by Age Group;
9. approve/reject/confirm only disposable requests and verify summary/list invalidation; and
10. confirm R12-A minimum-notice and existing Special lifecycle/Club-scope behaviour remain
    unchanged.

Record exact commit, environment, role/component access, fixture identifiers and observed
values. Delete disposable data only through an already accepted UI/API lifecycle; otherwise
leave it identified for controlled cleanup rather than performing an unplanned direct edit.

## 8. Do Not Build

`R13-A` must not:

- change `maxFreeDaysPerTeam` defaults or R12-A notice authority;
- change Special availability, application deadline, approval, confirmation or Club-scope
  policy;
- add schema, migration, historic-row repair or bulk reconciliation;
- add/change notification events, recipients, routing or real delivery;
- perform a general timezone/date-library rewrite;
- redesign Free Day screens or add unrelated dashboard capability;
- weaken organisation, season, Club, Team, component or role authority;
- implement `DEFERRED` or otherwise change Team Variation Requests;
- touch FUND, Commerce, Render Stage C or the private R2 proof resources; or
- commit, push, promote or deploy without the relevant explicit control decision.

## 9. Recovery, Promotion And Stop Conditions

The child is intended to be an application-only correction with no data migration. Recovery
is therefore a revert of the one bounded candidate, subject to confirmation that no
incompatible state was introduced.

If implementation is later authorised, the controlled sequence is:

```text
exact fcd162db remediation baseline
-> failing-first evidence
-> bounded R13-A application change
-> focused/full local gates
-> 04 implementation confirmation
-> independent 05 review-and-test plus human local acceptance
-> explicit promotion decision and exact-commit gates
-> explicit R13-A closure/reconciliation
-> only then unlock R13-B implementation
```

Stop and return to triage if:

- existing rows require repair or compatibility mutation;
- a Prisma/schema migration is needed;
- the date fault is not reproducible at the named boundaries;
- the initial `All` symptom is materially an authority/data fault rather than query state;
- correct summary navigation requires broader dashboard redesign;
- notification recipient/routing behaviour is defective rather than date rendering;
- a correction would weaken any access boundary; or
- the preserved FUND checkpoint changes.

## 10. Exit Gate

`R13-A` closes only when implementation confirmation, automated evidence, C1/C2 human
acceptance, exact promotion evidence required by the control owner and roadmap reconciliation
all pass with no open incident-ending defect.

Planning completion alone does not close the child and does not unlock `R13-B` implementation.
The immediate next action is an explicit control-owner decision whether to begin `R13-A`
implementation.
