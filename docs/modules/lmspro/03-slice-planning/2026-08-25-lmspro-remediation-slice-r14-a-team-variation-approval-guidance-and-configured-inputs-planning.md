# LMSPro Remediation Slice R14-A — Team Variation Approval Guidance And Configured Inputs Planning

Date: 2026-08-25

Module: LMSPro / SeasonPro

Status: **EXACT `D78935D4` IS ALIGNED THROUGH MAIN; LOCAL R1-R9, STAGING S1-S4, ALL
SECURITY SCANS AND PUBLIC HEALTH PASS; PRODUCTION IDENTITY/L1-L2 PENDING**

Control depth: **Standard** — this is bounded ordinary product behaviour affecting C1/C2
guidance, configured-value selection and server validation. Existing organisation, Club, Team and
season authority remains unchanged; no schema, live-data or automatic allocation change is planned.

```text
Current state: exact d78935d4 is aligned through origin work branch, dev, staging and main; local R1-R9, staging S1-S4, all four Security Scans and staging/production public health pass
Last proven commit: d78935d407ace7ebe796a31a13adf3e17dafa758
Current environment: exact refs align through main; production deployment triggered and public health green; no migration or runtime-configuration change
Next human decision/test: confirm exact production Render d78935d4 identity and run minimum non-destructive L1-L2
Safe resumption point: inspect production deployment identity and authenticated read-only guidance/selector path, record L1-L2 PASS/FAIL/NOT RUN, then close/reconcile R14-A only if both pass
```

Source CR-Fix:

- [Team Variation Request approval consistency](../01-cr-inputs/CR-Fix-2026-08-25-lmspro-team-variation-request-approval-consistency.md)

Accepted triage:

- [Team Variation approval guidance and configured inputs triage](../02-triage/2026-08-25-lmspro-cr-fix-team-variation-request-approval-consistency-triage.md)

## 1. Goal And Proven Baseline

Make the existing Team Variation workflow truthful and input-safe without changing its approval
authority or lifecycle:

1. tell C1, at each approval/review surface, whether approval applies the requested change
   automatically or records approval for a named C1 follow-up task; and
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
- Use it for C2 labels/input modes and for guidance in the routed C1 `TeamVariationsTab` and the C1
  Team Approval CRUD modal; do not maintain separate effect matrices in those surfaces.
- On C2 type selection, show only the meaningful input required to submit the request. Operational
  approval/follow-up guidance belongs to C1 and must not be shown to C2.
- On both C1 approval surfaces, show `Applied on approval` or `League Admin action required` with the exact
  task before approval; retain the guidance while an Approved request awaits
  `Confirm System Updated` in the routed management detail.
- Treat C1/C2 as internal lifecycle shorthand only. User-facing copy uses `League Admin` and `Club
  Secretary` where a role name is required.
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

### 3.4 Directly authorised adjacent Low presentation correction

The control owner explicitly added one adjacent presentation-only correction while this local
corridor remained active. Give the Free Day row-click modal the same responsive 660px width as the
Variation Request detail modal. Move its existing Save Changes control directly beneath League
Notes and render it as a compact subtle/link-style control, outside the footer's status actions.
Preserve the update mutation and every Cancel, Reject, Approve and Confirm action unchanged.

## 4. Likely Application Boundary

- `src/modules/lmspro/lib/team-variation-request-policy.ts` — new shared matrix/resolver metadata;
- `src/app/(app)/app/lmspro/club/teams/page.tsx` — C2 configured selectors and shared labels/input modes;
- `src/app/(app)/app/lmspro/team-approval/page.tsx` — C1 Team Approval CRUD-modal guidance;
- `src/modules/lmspro/components/dashboard/TeamVariationsTab.tsx` — C1 single/bulk guidance;
- `src/modules/lmspro/routers/age-groups.router.ts` — existing AGG list receives an optional
  tenant/season-scoped Age Group filter;
- `src/modules/lmspro/routers/team-variation-requests.router.ts` — scoped reference resolution and
  normalised snapshot storage;
- `src/modules/lmspro/components/dashboard/FreeDaysManage.tsx` — adjacent responsive modal width
  and Save Changes hierarchy only;
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
| R1 | C2 selects each request type and sees only the relevant request input, with no C1 operational approval/follow-up guidance. |
| R2 | Age Group uses a numerically ordered current-season selector (`U1`, `U2`, `U11`, `U111`) excluding the Team's current/retired group; the selected label survives create and C1/C2 display. |
| R3 | Division uses a required non-empty selector limited to the Team's current Age Group and excluding its current AGG; the selected label survives create and display. |
| R4 | Both C1 Team Approval CRUD modal and Team Variations management detail show the exact effect/task before approval; one automatic disposable request changes the Team and one manual request does not. |
| R5 | Approved manual management detail retains the named task until C1 completes it and selects `Confirm System Updated`; automatic detail states that the LMSPro change was already applied. |
| R6 | Mixed bulk selection truthfully reports automatic/manual counts and tasks, preserves selection, and retains existing approval effects. |
| R7 | User-facing guidance in both League Admin approval surfaces and the mixed-selection summary says `League Admin`, never internal shorthand `C1` or `C2`. |
| R8 | From `/app/lmspro/free-days?tab=variations`, row-clicking a Variation Request opens a 660px desktop detail modal with reduced guidance wrapping; it remains inside a narrow/mobile viewport with usable controls and no horizontal clipping. |
| R9 | From `/app/lmspro/free-days`, row-clicking a Free Day opens the same responsive 660px desktop width; Save Changes appears once as a compact link-style control immediately beneath League Notes, saves date/reason/notes without a status action, and is absent from the footer while the applicable Cancel Request, Reject/Approve or Confirm action remains clear and usable. |

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

The control owner accepted this plan and explicitly authorised implementation/documentation on
2026-08-25. Exact local candidate `0700993b` has completed the automated Standard-depth gate; the
paired `04`/`05` records hold the implementation and test evidence.

The local stop completed at exact `d78935d4` with R1-R9 passed. The control owner explicitly
authorised the normal staging promotion on 2026-08-25. Exact work branch, dev and staging Security
Scans `32835754829`/`32835986995`/`32836190860` pass; refs align through staging and public staging
health is green. The control owner confirmed exact staging identity and S1-S4 all green and
authorised live promotion. Exact `d78935d4` now aligns through main; exact-main Security Scan
`32838343535` and production public health pass. Stop for exact production Render identity and
minimum non-destructive L1-L2 before closing the slice.

If this CR-Fix closes or is re-disposed, resume FUND Stage C only from exact candidate
`328aadf0a360b4c65837327060302ddc525f6168`: temporary worker suspended, no application secrets,
private proof bucket empty and existing auto-deploy services untouched.
