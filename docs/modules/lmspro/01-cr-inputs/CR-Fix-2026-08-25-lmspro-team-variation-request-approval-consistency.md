# CR-Fix Planning Intake — LMSPro Team Variation Request Approval Consistency

Date: 2026-08-25

Owning lane: LMSPro / SeasonPro

Planning status: **INITIAL `0700993B` HUMAN SMOKE FOUND THREE DEFECTS; CORRECTED EXACT
LOCAL `0A6376A2` PASSES AUTOMATED STANDARD-DEPTH GATE; R1-R6 NOT RUN; NO PUSH,
PROMOTION OR DEPLOYMENT AUTHORITY**

Control depth recommendation: **Standard** — this is a bounded UI-guidance and requested-value
input correction using existing scoped configuration/CRUD sources. It does not propose changing
approval authority, Team mutation behavior, schema or the human allocation decision.

Accepted triage:

- [Team Variation approval guidance and configured inputs triage](../02-triage/2026-08-25-lmspro-cr-fix-team-variation-request-approval-consistency-triage.md)

Proposed bounded plan:

- [R14-A Team Variation approval guidance and configured inputs](../03-slice-planning/2026-08-25-lmspro-remediation-slice-r14-a-team-variation-approval-guidance-and-configured-inputs-planning.md)

## 1. Source Observation

During controlled local C1/C2 smoke of exact R13-B candidate
`068117848bc66739a2794c596621f372344a9209`, the control owner observed a small loophole in an
otherwise functional Team Variation Request workflow: the implications of approval differ by
request type but the UI does not explain the difference.

In particular, `AGE_GROUP_CHANGE` accepts a free-text requested value even though Age Group is
configured data. The text can therefore be inaccurate or not match a valid current option. A real
Age Group change is intentionally a human C1 task: it can require a multi-step decision to move the
Team and select an appropriate Division/AGG. That decision is beyond automatic application approval.

Read-only source inspection confirms the broader consistency gap:

- `NAME_CHANGE` approval automatically updates the Team name;
- `WITHDRAWAL` approval automatically changes the Team status to Cancelled;
- placement-sensitive request types can become Approved while the required C1 operational change
  remains manual; and
- the UI does not currently tell C1 which follow-up task is required after approval.

This is an observed local workflow/design gap, not evidence of a newly introduced R13-B defect or
a confirmed production regression. R13-B changed Deferred handling, not existing approval effects.

## 2. Required Minimal Outcome

Investigate and plan only these two corrections:

1. Add concise request-type-aware UI text explaining whether approval applies the variation or
   records the decision and leaves a named C1 task. For Age Group/Division-style changes, explain
   that C1 must complete the appropriate Team move and Division/AGG allocation after approval.
2. For requested values backed by configured/reference values — including Age Group, AGG and
   Division where applicable — replace free text with meaningful inputs sourced and scoped in the
   same way as the existing CRUD inputs for those values. Preserve genuinely free-text inputs, such
   as a proposed Team name, where they remain appropriate.

Triage/planning should confirm the exact request-type matrix, reuse the existing CRUD option source,
labels, identifiers, active/current-season and tenant scoping, and determine the smallest compatible
way to retain the current `requestedValue` contract. It should cover invalid/stale option refusal,
C1/C2 display, single and bulk approval presentation, focused automated checks and one controlled
human create/approve proof for an automatic type and a manual-follow-up type.

The accepted design must preserve the existing human decision. It must not automate Age Group,
AGG or Division allocation merely because a request is approved.

## 3. Immediate Containment And Workaround

Until this CR is triaged and a plan is accepted, C1 should validate configured-value requests
against current season data and complete the existing manual Team move/allocation task after
approving a placement-sensitive variation. C1 should not infer that approval performed that task.

This is a limited operational workaround, not a substitute for truthful UI or an accepted data
contract. No automated repair, bulk processing or direct database editing is authorised.

## 4. Severity, Risk And Expedite Position

Operational severity: **bounded usability and input-quality ambiguity**. The underlying workflow is
functional and its human allocation boundary is intentional. The gap is that free text can be
meaningless and the C1 follow-up task is not explained. The existing manual validation/allocation
route provides a safe workaround.

Expedite/selection decision: after R13-B closed successfully at staging, the control owner
explicitly selected this CR-Fix as portfolio `Now` on 2026-08-25 and retained preserved FUND Stage C
as `Next`. This is a sequencing decision, not a claim of higher severity. Formal triage authorises
bounded planning only; implementation still requires an accepted `03` plan and explicit instruction.

## 5. Do Not Build

This intake does not authorise:

- automatic Age Group, AGG or Division reassignment on approval;
- a Team status, placement, fixture or competition-lifecycle redesign;
- new approval states, schema, migration, historic-row repair or direct database changes unless
  later investigation proves a specific unavoidable need and triage separately accepts it;
- broad Team registration, fixture, season-rollover or Division-management redesign;
- broad notification, bulk workflow or approval-effect redesign;
- weakening League, organisation, Club, Team or season authority; or
- implementation, push, promotion or deployment.

## 6. Safe Resumption And Registration

R13-B is complete and closed at staging. Its accepted Deferred boundary and green local/staging
evidence remain valid because this finding concerns the pre-existing normal approval workflow and
is excluded from R13-B.

The accepted bounded R14-A plan was first implemented at `0700993b`; direct smoke found misplaced
C2/C1 guidance, empty Division options and incorrect numeric Age Group ordering. Corrected exact
local `0a6376a2` passes focused/full automation, TypeScript, verifier, production-file lint,
whitespace and production build. The next action is direct corrected R1-R6 local smoke; no pass is
inferred and no push or promotion is authorised. FUND Stage C remains portfolio `Next` at its
preserved checkpoint.
