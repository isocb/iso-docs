# CR-Fix Planning Intake — LMSPro Team Variation Request Approval Consistency

Date: 2026-08-25

Owning lane: LMSPro / SeasonPro

Planning status: **CAPTURED AND REGISTERED; AWAITING FORMAL TRIAGE; NO IMPLEMENTATION,
MIGRATION, PROMOTION OR ROADMAP DISPLACEMENT AUTHORISED**

Control depth recommendation: **High** — the investigation crosses League approval authority,
Team status, Age Group/Division allocation, tenant scope, audit and notification truthfulness.

## 1. Source Observation

During controlled local C1/C2 smoke of exact R13-B candidate
`068117848bc66739a2794c596621f372344a9209`, the control owner observed that Team Variation
Request approval does not have one truthful effect across request types.

In particular, `AGE_GROUP_CHANGE` accepts a free-text requested value. The value may not identify
a valid configured Age Group and cannot safely be applied automatically. A real Age Group change
may also require the Team to leave its current Division and current competition state until an
authorised League user reallocates it. The current C1 approval UI does not explain that manual
operational consequence.

Read-only source inspection confirms the broader consistency gap:

- `NAME_CHANGE` approval automatically updates the Team name;
- `WITHDRAWAL` approval automatically changes the Team status to Cancelled;
- `AGE_GROUP_CHANGE`, `DIVISION_CHANGE`, `REINSTATEMENT` and `OTHER` can become Approved without
  an equivalent Team mutation;
- single and bulk approval share that mixed behavior; and
- the approval notification can describe the requested value as approved even when further manual
  Team/competition work is still required.

This is an observed local workflow/design gap, not evidence of a newly introduced R13-B defect or
a confirmed production regression. R13-B changed Deferred handling, not existing approval effects.

## 2. Required Investigation Outcome

Establish and plan one explicit, request-type-specific approval contract so C1 can tell before
approval whether the application will:

1. apply the requested Team change atomically;
2. record League approval but require a named manual follow-up process; or
3. refuse approval until the requested value and allocation decision are valid.

The investigation must determine:

- whether Age Group and Division requests should select authoritative season configuration rather
  than accept free text;
- the correct Team status/current-state and Division-membership transitions for Age Group,
  Division, Withdrawal and Reinstatement changes;
- whether approval and any required reallocation can be one safe atomic operation or must remain a
  deliberately staged manual workflow;
- truthful C1 action labels, confirmation copy, post-approval state, next-action guidance and list
  indicators for manual work;
- truthful C2 status and notification wording so `Approved` is not mistaken for `Applied`;
- whether bulk approval is safe for every request type or must exclude manual/placement-sensitive
  types;
- tenant/Club/Team/season authority, stale-write, audit, notification and failure/rollback behavior;
- compatibility and reconciliation for existing Pending, Approved and Update Confirmed requests;
  and
- focused negative, migration/data, automated and controlled C1/C2 human evidence proportionate to
  the accepted design.

The planning outcome may define distinct `Approved`, `Awaiting manual update` and `Applied` concepts,
but must first prove whether new persistence is necessary. It must not assume an enum/schema change
before source and data investigation.

## 3. Immediate Containment And Workaround

Until this CR is triaged and a plan is accepted, C1 should validate Age Group/Division requests
against current season configuration and treat approval as an administrative decision that may
still require the existing manual Team reallocation/update process. C1 should not assume the
free-text requested value was applied merely because the request status says Approved.

This is a limited operational workaround, not a substitute for truthful UI or an accepted data
contract. No automated repair, bulk processing or direct database editing is authorised.

## 4. Severity, Risk And Expedite Position

Operational severity: **material workflow-integrity and communication ambiguity**. An inaccurate
free-text target or an Approved-but-not-applied request can mislead C1/C2 and create inconsistent
Team, Age Group, Division or current-status state. The existing manual validation/reallocation
route provides containment while the issue is investigated.

Expedite decision: **not proposed at capture**. Finish the already accepted R13-B staging gate,
then formally triage this CR against the restored portfolio queue. Registration does not displace
R13-B or FUND Stage C and is not implementation authority.

## 5. Do Not Build

This intake does not authorise:

- automatic Age Group or Division reassignment from free text;
- destructive removal of a Team from current competition data;
- schema, migration, historic-row repair or direct database changes;
- broad Team registration, fixture, season-rollover or Division-management redesign;
- notification sending or wording changes before the status/effect contract is accepted;
- weakening League, organisation, Club, Team or season authority; or
- implementation, push, promotion or deployment.

## 6. Safe Resumption And Registration

R13-B remains the sole portfolio `Now` through its authorised staging evidence and closure. Its
accepted Deferred boundary and green B1-B10 local evidence remain valid because this finding concerns
the pre-existing normal approval workflow and is excluded from R13-B.

Resume this CR only from formal triage after recording the then-current application baseline,
request-type data examples, Team/Age Group/Division relationships, notification contract and
portfolio decision. The authoritative registration is the LMSPro child roadmap inventory.
