# LMSPro Remediation Slice R13-B — Deferred Team Variation Workflow Planning

Date: 2026-08-24

Module: LMSPro / SeasonPro

Status: **ACCEPTED SEQUENTIAL PLAN; IMPLEMENTATION INACTIVE AND BLOCKED UNTIL R13-A
CLOSURE/ROADMAP RECONCILIATION PLUS A NEW EXPLICIT CONTROL-OWNER IMPLEMENTATION DECISION**

Control depth: **High** — schema migration, workflow transitions, tenant/Club/Team authority
and C2 cancellation require complete migration, rollback, negative and human evidence. R13-B
is inactive, so the active-slice restart checkpoint remains only in R13-A.

Source CR-Fix:

- [Free Day and Team Variation Request remediation CR-Fix](../01-cr-inputs/CR-Fix-2026-08-24-lmspro-free-day-and-team-variation-request-remediation.md)

Accepted triage:

- [Free Day and Team Variation Request remediation triage](../02-triage/2026-08-24-lmspro-cr-fix-free-day-and-team-variation-request-remediation-triage.md)

Required predecessor:

- [R13-A Free Day integrity and management presentation](2026-08-24-lmspro-remediation-slice-r13-a-free-day-integrity-and-management-presentation-planning.md)

Planning baseline:

```text
repository: isostack-bedrock
branch: fix/lmspro-free-day-variation-request-remediation
commit inspected: fcd162db60956858233821fd3f29c55e17d954dd
implementation baseline: must be re-resolved to the exact accepted R13-A closure commit
```

## 1. Control Decision And Objective

Accept `R13-B` as the second bounded child plan so its schema, transition, authority and
acceptance contract is ready without starting parallel work.

The objective is to add a durable `DEFERRED` Team Variation Request state with the exact
workflow:

```text
PENDING -> DEFERRED -> PENDING
```

Deferral applies no Team change. Once returned to Pending, the existing normal
approve/reject/reply workflow resumes. An authorised C2 submitter can see the Deferred state
and optional reason and can cancel its own Deferred request.

This record does not make `R13-B` active. No schema, migration, Prisma generation,
application edit, database action or implementation test for this child may begin until:

1. `R13-A` has reached accepted implementation/review/test/roadmap closure;
2. the roadmap explicitly selects `R13-B` as LMSPro `Now`;
3. the exact application baseline is re-recorded; and
4. the control owner explicitly instructs `R13-B` implementation.

## 2. Confirmed Source Boundary

Read-only investigation at `fcd162db` established:

- `TeamVariationRequestStatus` contains `PENDING`, `APPROVED`, `UPDATE_CONFIRMED`,
  `REJECTED` and `CANCELLED`, but no `DEFERRED`;
- `LMSProTeamVariationRequest` has League `reviewNotes/reviewedBy/reviewedAt` fields but no
  distinct deferral reason;
- the central `AuditLog` has string actions, actor, organisation, timestamp and JSON
  metadata, so transition history does not need another audit table;
- league `approve`/`reject` and bulk actions are intended to operate on Pending rows;
- `addReply` currently accepts any existing status and therefore needs an explicit Deferred
  refusal, not only a hidden button;
- C2 cancellation currently requires the exact submitter and `PENDING` status;
- the C1 filter and modal have no Deferred presentation, the modal always exposes Save Reply,
  and the `OUTSTANDING` aggregate is deliberately `PENDING + APPROVED`;
- `getPendingCount` returns Pending and Approved-not-confirmed counts, which must continue to
  exclude Deferred;
- C2 Club Teams and Club Dashboard surfaces display Team Variation Requests and require a
  Deferred label/reason presentation; and
- season cloning copies complete Team Variation history and its explicit selected fields,
  so the new status/reason needs compatibility proof without rewriting source rows.

## 3. Accepted Persistence And Transition Design

### 3.1 Smallest additive persistence

Add `DEFERRED` to `TeamVariationRequestStatus` and one nullable text field on
`LMSProTeamVariationRequest` for the most recent optional deferral reason, mapped consistently
with the schema's naming convention.

Do not repurpose `reviewNotes`: it is the existing general League reply and
approval/rejection response field and remains governed by its current workflow. Actor and
timestamp evidence for each defer/return transition belongs in the existing append-only
`AuditLog`; another `deferredBy` relationship or audit table is not required unless later
source proof demonstrates a concrete gap.

The deferral reason is trimmed, optional and bounded to a proportionate server-validated
length. Returning to Pending retains the most recent reason on the row for evidence; a later
deferral may replace the current displayed reason while both transition events remain in
`AuditLog`. No existing row is backfilled or rewritten.

### 3.2 Expand-compatible migration

Create one additive migration that:

1. adds the `DEFERRED` enum value; and
2. adds the nullable deferral-reason column.

Existing rows remain valid and unchanged. The implementation/release plan must respect
PostgreSQL enum transaction constraints and the repository's Prisma migration conventions.
Migration verification must prove the enum/column additions, null compatibility and absence
of row updates.

Before shared deployment, record the exact expand/application ordering and a forward-fix
posture. After a row is stored as `DEFERRED`, rolling application code back to a client that
cannot parse or present that enum is unsafe; the deployment gate must prevent mixed-version
use and must not claim that simply dropping the enum value is a safe database rollback.

### 3.3 Authoritative transitions

Add two league-authorised server mutations protected by the existing
`teams.approve.view` component authority and organisation scope:

```text
defer:          PENDING  -> DEFERRED
returnToPending: DEFERRED -> PENDING
```

Each mutation must atomically enforce the source status, update the same request row and add
an organisation-scoped audit event containing request type, from/to status and the optional
reason where relevant. It must be safe under duplicate clicks and competing actions: exactly
one valid transition wins, a stale transition fails truthfully, and no orphan audit event is
created.

Deferral/return must not mutate `LMSProTeam`, create a replacement request, change
`reviewNotes`, send email or invoke approval/rejection logic. Existing direct and bulk
approve/reject paths must continue to refuse anything not Pending; `confirmUpdate` remains
Approved-only; `addReply` must refuse Deferred at the server even if called directly.

C2 `cancel` may accept the exact submitter's request in either Pending or Deferred while
preserving organisation, Team/Club access and request identity checks. Cancellation writes
the existing cancellation audit event and no new Deferred notification.

## 4. C1 And C2 Presentation Contract

### 4.1 C1 League management

Add the `Deferred` label/colour and a `Deferred` status filter. C1 `All` includes Deferred.
The existing `OUTSTANDING` aggregate remains exactly Pending plus Approved, and dashboard
Pending/Approved-not-confirmed counts remain unchanged.

On a Pending request, add `Defer` beside the existing actions. Deferral may collect the
optional reason and must require a deliberate confirm action.

On a Deferred request, the detail modal may show read-only request context, existing historic
League reply and the deferral reason, but its only workflow-changing control is `Return to
Pending`. Apart from passive `Close`, it must not display or permit Approve, Reject, Save
Reply, Confirm System Updated or bulk selection. After a successful return and refetch, the
same row is Pending and receives the existing normal Pending actions.

The pending-only bulk management surface remains pending-only. Deferred rows cannot be
selected or included in bulk approve/reject operations.

### 4.2 C2 Club visibility and cancellation

The Club Dashboard variation list/detail and Club Teams request detail must show a friendly
Deferred status and the optional reason only to users already authorised to see that Club's
request. The exact submitting user may cancel its own Deferred request through the existing
cancel interaction. Other Club users or another Club/organisation cannot cancel it.

A Deferred request remains an active request for duplicate-request eligibility: returning it
to Pending must not allow or require creation of a replacement request. Any existing
"one pending request per type" check must explicitly treat Deferred as still open where
necessary to prevent a duplicate of the same Team/request type.

## 5. Expected Application Files

Likely bounded files are:

```text
prisma/schema.prisma
prisma/migrations/<timestamp>_lmspro_r13_b_deferred_team_variation_status/migration.sql
src/modules/lmspro/routers/team-variation-requests.router.ts
src/modules/lmspro/routers/seasons.router.ts
src/modules/lmspro/components/dashboard/TeamVariationsTab.tsx
src/modules/lmspro/components/dashboard/TeamVariationRequestsManage.tsx
src/modules/lmspro/components/dashboard/TeamVariationsCard.tsx
src/modules/lmspro/components/dashboard/ClubCommunicationsPanel.tsx
src/app/(app)/app/lmspro/club/teams/page.tsx
```

Focused policy/transition tests may introduce a small pure state helper and test beside
`src/modules/lmspro/lib/`. Other C1 request-status consumers such as Team/Division RAG
presentation may require a bounded label/colour compatibility update if exact implementation
inspection proves they render every status. They must not be redesigned.

`notification-templates.ts` and notification recipient/routing code are explicitly not
expected to change.

## 6. Failing-First And Automated Acceptance

When the child is later activated, capture failing-first proof and corrected evidence for:

1. additive migration and Prisma enum/client compatibility with every existing status;
2. Pending -> Deferred with/without a reason, same row ID, unchanged Team snapshot and one
   audit event;
3. Deferred -> Pending, retained reason, unchanged Team, same row ID and one audit event;
4. duplicate/stale/concurrent defer, return, approve and reject attempts allowing only one
   valid transition;
5. direct approve/reject/addReply/confirm refusal while Deferred;
6. C1 `Deferred` and `All` inclusion, with `OUTSTANDING`, Pending counts and Approved counts
   excluding Deferred;
7. Deferred rows absent from bulk selections/actions;
8. exact-submitter C2 cancellation while Deferred and refusal for sibling Club user,
   another Club and another organisation;
9. C2 status/reason visibility only within authorised Club/Team scope;
10. duplicate request prevention while an equivalent request is Deferred;
11. season-clone compatibility for the new status/reason under the existing full-history
    copy contract; and
12. no notification template, event, recipient or delivery call on defer/return.

Then run:

```text
npx prisma validate
npx prisma generate
focused migration verification
focused router/state/presentation tests
changed-file lint
npm run type-check
npm test -- --run
npm run verify
npm run build
git diff --check
```

Use an isolated/local test database for migration proof. No shared database action is
authorised by this planning record.

## 7. Human Acceptance Schedule

With controlled synthetic C1/C2 users and a disposable Pending request:

1. C1 opens Pending, enters no reason, cancels the UI action and proves no change;
2. C1 defers with a reason and sees Deferred immediately without a hard reload;
3. verify the Team and request ID/value fields did not change;
4. open Deferred and confirm the only workflow action besides Close is Return to Pending;
5. select `All`, `Deferred` and `OUTSTANDING` and prove the accepted inclusion/exclusion;
6. reconcile dashboard counts and pending-only bulk panels;
7. C2 Club Dashboard and Club Teams show Deferred and the reason;
8. a non-submitting C2 user and another Club cannot cancel or access the request;
9. the submitting C2 user cancels a disposable Deferred request successfully;
10. on a separate request, C1 returns Deferred to Pending and the existing approve/reject/
    Save Reply controls return;
11. process that restored request through one existing normal outcome and prove no replacement
    row was created; and
12. confirm no defer/return email was delivered or queued.

Record exact application/schema commit, migration state, roles, fixture IDs, before/after
Team/request snapshots, audit IDs and count/filter results.

## 8. Do Not Build

`R13-B` must not:

- begin before accepted `R13-A` closure and explicit reselection;
- redesign approval, rejection, update-confirmation, reply or season-roll-forward workflows;
- allow approve/reject/reply directly from Deferred;
- mutate a Team or create a replacement request on defer/return;
- add a Deferred notification event or change recipients/routing;
- rewrite/backfill existing Team Variation rows;
- add another audit table or unnecessary user relationship;
- weaken organisation, Club, Team, season, submitter or component authority;
- include Free Day corrections, FUND, Commerce, Render Stage C or R2 work; or
- commit, push, migrate a shared database, promote or deploy without the relevant explicit
  decision.

## 9. Recovery And Stop Conditions

Before implementation, rebase the plan's file inventory and migration assumptions against
the exact accepted R13-A closure commit. Do not silently implement from `fcd162db` if that is
no longer the branch head.

Stop and return to triage if:

- `DEFERRED` requires a Team lifecycle redesign or replacement-request model;
- existing rows require data repair/backfill;
- the additive migration cannot be ordered safely for the deployed topology;
- an audit requirement cannot be met by the existing AuditLog plus one reason field;
- authorised C2 visibility/cancellation requires weakening current Club/submitter scope;
- existing notification routing must change; or
- R13-A is not closed or the FUND checkpoint has changed.

After a Deferred row exists in any shared environment, recovery is forward-fix or an exact
compatible application revert; destructive enum removal/data rewriting is outside this plan
and requires separate authority.

## 10. Exit Gate And Parent Closure

`R13-B` closes only after its implementation confirmation, isolated migration proof,
automated gates, C1/C2 human acceptance, exact authorised promotion evidence and roadmap
reconciliation pass.

Only then may the parent tactical CR-Fix close. Parent closure must re-verify the preserved
FUND `1R-F-A` Stage C candidate/worker/secret/bucket checkpoint and explicitly restore FUND
as portfolio `Now`; it must not infer authority for a later FUND child.
