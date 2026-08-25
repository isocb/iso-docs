# LMSPro Remediation Slice R14-A — Team Variation Approval Guidance And Configured Inputs Planning

Date: 2026-08-25

Module: LMSPro / SeasonPro

Status: **READY FOR CONTROL-OWNER ACCEPTANCE; STANDARD-DEPTH PLAN ONLY; NO IMPLEMENTATION,
SCHEMA, MIGRATION, PUSH, PROMOTION OR DEPLOYMENT AUTHORITY**

Control depth: **Standard** — this is bounded ordinary product behaviour affecting C1/C2
guidance, configured-value selection and server validation. Existing organisation, Club, Team and
season authority remains unchanged; no schema, live-data or automatic allocation change is planned.

```text
Current state: bounded R14-A plan created from accepted triage; application unchanged
Last proven commit: 068117848bc66739a2794c596621f372344a9209
Current environment: local/remote dev, staging and main exact 06811784; R13 live and fully green; no R14 work branch or implementation
Next human decision/test: accept, amend or reject this plan; implementation requires a separate explicit instruction
Safe resumption point: if accepted, create a bounded application work branch from exact 06811784 and stop at the local Standard-depth gate
```

Source CR-Fix:

- [Team Variation Request approval consistency](../01-cr-inputs/CR-Fix-2026-08-25-lmspro-team-variation-request-approval-consistency.md)

Accepted triage:

- [Team Variation approval guidance and configured inputs triage](../02-triage/2026-08-25-lmspro-cr-fix-team-variation-request-approval-consistency-triage.md)

## 1. Goal And Proven Baseline

Make the existing Team Variation workflow truthful and input-safe without changing its approval
authority or lifecycle:

1. tell C1 and C2 whether approval applies the requested change automatically or records approval
   for a named C1 follow-up task; and
2. replace raw configured-value text with scoped selections for Age Group and Division/AGG,
   refusing stale or out-of-scope targets server-side.

Read-only inspection of exact baseline `06811784` proves:

- `NAME_CHANGE` approval updates `teamName` automatically;
- `WITHDRAWAL` approval sets Team status to `CANCELLED` automatically;
- `AGE_GROUP_CHANGE`, `DIVISION_CHANGE`, `REINSTATEMENT` and `OTHER` approval do not mutate the Team;
- Age Group is currently raw free text;
- Division already renders an AGG selector but submits only its name and the router accepts an
  arbitrary `requestedValue`; and
- the existing `APPROVED -> UPDATE_CONFIRMED` action records that the operational/system follow-up
  is complete but does not itself apply a Team change.

`DIVISION_CHANGE` is the existing AGG-backed request type. Do not add a separate AGG enum/type.

## 2. Accepted Behaviour Matrix

| Request type | Request input | Approval effect | Truthful UI guidance |
| --- | --- | --- | --- |
| `NAME_CHANGE` | Required trimmed free-text Team name | Automatically updates the Team name | Approval applies the name immediately; C1 verifies any downstream fixture system, then confirms the update |
| `WITHDRAWAL` | No configured target; existing notes remain | Automatically sets Team status to Cancelled | Approval applies the LMSPro status immediately; C1 verifies any downstream fixture system, then confirms the update |
| `AGE_GROUP_CHANGE` | Required current-season Age Group selection, excluding the current and retired target | Records approval only | C1 must move the Team to the selected Age Group, select the appropriate Division/AGG and then confirm the update |
| `DIVISION_CHANGE` | Required Division/AGG selection from the Team's current Age Group, excluding its current Division | Records approval only | C1 must allocate the Team to the selected Division/AGG and then confirm the update |
| `REINSTATEMENT` | No configured target; existing notes remain | Records approval only | C1 must complete the Team reinstatement and valid Age Group/Division allocation, then confirm the update |
| `OTHER` | Existing free-text notes remain | Records approval only | C1 must complete the described manual task, then confirm the update |

The wording may be shortened in implementation, but it must preserve these effects and tasks.
Automatic types must not be described as manual; manual types must not imply that approval changed
the Team.

## 3. Bounded Implementation Contract

### 3.1 Shared policy and presentation

- Add one shared Team Variation policy helper containing the six type labels, input mode,
  automatic/manual classification and concise follow-up text.
- Use it in the C2 Club Teams request form and the routed C1 `TeamVariationsTab`; do not maintain
  separate effect matrices in those surfaces.
- On C2 type selection, show what approval will do and, for configured types, use a searchable
  selector rather than free text.
- On the C1 list/detail view, show `Applied on approval` or `C1 action required` with the exact task
  before approval and while an Approved request awaits `Confirm System Updated`.
- For bulk selection, show the selected automatic/manual counts and the distinct follow-up tasks
  before the existing Approve action. Preserve selection membership and existing atomic/stale
  refusal behaviour; do not redesign bulk approval effects.
- Keep the current status enum and `Confirm System Updated` transition. Clarify its meaning through
  copy only.

### 3.2 Configured target contract

- Reuse current organisation- and season-scoped Age Group/AGG sources; do not create another
  configuration catalogue.
- Submit a configured target reference ID for `AGE_GROUP_CHANGE` and `DIVISION_CHANGE`.
- Resolve that ID inside `teamVariationRequests.create` against the already-authorised Team:
  - Age Group must belong to the same organisation and Team season, differ from the current Age
    Group and not be a retired-marked group;
  - Division/AGG must belong to the same organisation, Team season and current Team Age Group,
    differ from the current AGG and still exist when submitted.
- Store the resolved human-readable code/name snapshot in the existing `requestedValue` text field.
  Do not store an ID in that field and do not add a column or migration.
- Do not trust a raw client label for configured types: missing, stale, wrong-tenant, wrong-season,
  wrong-Age-Group, current or retired targets must fail before request/audit/email creation.
- Preserve existing historic rows and display their stored text without repair or reinterpretation.

### 3.3 Existing approval effects

- Keep single and bulk `NAME_CHANGE` and `WITHDRAWAL` mutations exactly as they work now.
- Keep all four manual types non-mutating on approval.
- Centralise the effect classification so single approval, bulk approval and UI guidance cannot
  silently drift, but do not redesign transactions, notifications or audit events.

## 4. Likely Application Boundary

- `src/modules/lmspro/lib/team-variation-request-policy.ts` — new shared matrix/resolver metadata;
- `src/app/(app)/app/lmspro/club/teams/page.tsx` — C2 guidance and configured selectors;
- `src/modules/lmspro/components/dashboard/TeamVariationsTab.tsx` — C1 single/bulk guidance;
- `src/modules/lmspro/routers/team-variation-requests.router.ts` — scoped reference resolution and
  normalised snapshot storage;
- focused policy/router/component tests, including the existing
  `team-variation-requests.router.test.ts`.

Touch another surface only if source inspection proves it is currently routed and displays the same
approval decision. Do not revive or redesign an unused legacy component merely for consistency.

## 5. Standard-Depth Evidence Gate

### Automated

- failing-first tests for the policy matrix and arbitrary/stale configured target acceptance;
- all six types classified exactly once;
- correct Age Group and Division targets resolve to human-readable stored snapshots;
- missing, current, retired, deleted, wrong-organisation, wrong-season and wrong-Age-Group targets
  refuse with no request, audit or email;
- `NAME_CHANGE` and `WITHDRAWAL` single/bulk effects remain unchanged;
- four manual types remain Team-non-mutating on approval;
- focused tests, full relevant Vitest suite, TypeScript, critical-file verifier, changed-file lint,
  whitespace and production build pass.

### Controlled local human smoke

Use local application/DevData, controlled C1/C2 personas and disposable non-sensitive requests.
Record each row `PASS`, `FAIL` or `NOT RUN`; do not infer a pass from automation.

| Ref | Check |
| --- | --- |
| H1 | C2 selects each request type and sees truthful automatic/manual approval guidance. |
| H2 | Age Group uses a current-season selector excluding the Team's current/retired group; the selected label survives create and C1/C2 display. |
| H3 | Division uses a required selector limited to the Team's current Age Group and excluding its current AGG; the selected label survives create and display. |
| H4 | C1 single approval shows the exact effect/task before action; one automatic disposable request changes the Team and one manual request does not. |
| H5 | Approved manual detail retains the named task until C1 completes it and selects `Confirm System Updated`; automatic detail states that the LMSPro change was already applied. |
| H6 | Mixed bulk selection truthfully reports automatic/manual counts and tasks, preserves selection, and retains existing approval effects. |

Server refusal of forged/stale references is automated negative evidence and must not be simulated
by manipulating DevData through the browser.

### Staging, only after local acceptance and explicit promotion authority

- exact Render identity, exact protected-branch Security Scan and public health;
- one configured manual-type create/display/approve proof with no Team mutation; and
- one automatic-type approval proof plus the mixed-bulk guidance display.

Live, if later authorised, is limited to exact-build confirmation and a non-destructive read-only
guidance/selector check. Do not create a production variation request solely for proof.

## 6. Recovery And Risk

- No schema/migration/data repair: application rollback is a compatible revert.
- Existing and newly stored `requestedValue` remains human-readable and backward-compatible.
- The principal correction risk is client/server matrix drift; one shared policy and exhaustive
  six-type tests contain it.
- The principal validation risk is accepting a target that became stale after render; resolve and
  validate again inside the create mutation.
- Any authority, cross-tenant/season option exposure, unexpected Team mutation, notification
  redesign or migration finding raises the control depth and returns the slice to planning.

## 7. Do Not Build

Do not implement:

- automatic Age Group, Division/AGG, reinstatement or `OTHER` action on approval;
- a new request type, status, schema field, migration or historic-row repair;
- Team/fixture/competition/season lifecycle redesign;
- notification-template or recipient-routing changes;
- broad Team CRUD or AGG-management refactoring;
- a new configuration source or duplicated option catalogue;
- weaker organisation, Club, Team or season scope;
- production data creation for testing; or
- FUND work while this CR-Fix remains portfolio `Now`.

## 8. Acceptance And Stopping Point

Acceptance of this `03` record authorises no code by itself. A separate explicit control-owner
instruction is required before implementation.

If implementation is authorised, start from exact `06811784`, create a bounded local work branch,
implement only Sections 2–4, create the paired `04`/`05` evidence and stop after the local
Standard-depth gate. Do not push, migrate, promote or deploy without a later explicit decision.

If this CR-Fix closes or is re-disposed, resume FUND Stage C only from exact candidate
`328aadf0a360b4c65837327060302ddc525f6168`: temporary worker suspended, no application secrets,
private proof bucket empty and existing auto-deploy services untouched.
