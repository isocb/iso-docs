# LMSPro CR-Fix — Team Variation Approval Guidance And Configured Inputs Triage

Date: 2026-08-25

Module: LMSPro / SeasonPro

Status: **ACCEPTED FOR BOUNDED PLANNING; SELECTED BY THE CONTROL OWNER AS PORTFOLIO `NOW`;
STANDARD CONTROL; NO IMPLEMENTATION, SCHEMA, MIGRATION, PROMOTION OR DEPLOYMENT AUTHORITY**

Source CR-Fix:

- [Team Variation Request approval consistency](../01-cr-inputs/CR-Fix-2026-08-25-lmspro-team-variation-request-approval-consistency.md)

Authoritative controls:

- [LMSPro child roadmap](../00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md)
- [root portfolio roadmap](../../../00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md)

## 1. Accepted Decision

Accept the observation as a minimal remedial follow-on to the now-closed R13 lifecycle. The Team
Variation workflow is functional: some approved request types deliberately apply a simple change,
while placement-sensitive changes require a subsequent C1 human decision and operational task.
The defect is the loophole in guidance and input quality, not the existence of that human boundary.

The bounded planning outcome must cover only:

1. request-type-aware UI guidance stating whether approval applies the change or leaves a named C1
   follow-up task; and
2. meaningful configured/reference inputs for Age Group, AGG, Division and any equivalent type,
   reusing the same authoritative option sources and scoping as their existing CRUD inputs.

Free text remains valid where the requested value is genuinely free text, such as a proposed Team
name. Age Group/AGG/Division movement and allocation remain human C1 work and must not be automated
by approval.

## 2. Classification And Portfolio Position

| Dimension | Accepted decision |
| --- | --- |
| Type | Minimal remedial UI-guidance and configured-input correction |
| Control depth | **Standard** — bounded ordinary product behavior; no authority, schema, migration, privacy, finance, integration or environment change is proposed |
| Environment/evidence | Observed during controlled local R13-B smoke; not a newly introduced R13-B defect or confirmed production regression |
| Severity | Bounded usability and input-quality ambiguity; underlying workflow remains functional |
| Workaround | C1 validates requested configured values and completes the known manual move/allocation task after approval |
| Expedite/selection | Control owner explicitly selected this CR-Fix as portfolio `Now` on 2026-08-25; selection reflects desired sequence, not higher technical severity |
| Portfolio `NOW` | This CR-Fix through bounded planning, later implementation only if separately authorised, and proportionate evidence |
| Portfolio `NEXT` | Resume FUND `1R-F-A` Stage C from exact preserved candidate `328aadf0` and its recorded zero-resource checkpoint |

## 3. Planning Questions To Resolve

The bounded `03` plan must resolve:

- the exact automatic-versus-manual request-type matrix and the shortest truthful C1/C2 wording;
- the existing Age Group, AGG and Division CRUD queries/components that can be reused rather than
  duplicated;
- organisation, current-season, active-option and Team-context scoping;
- server-side refusal of a stale, inactive or out-of-scope configured value so the UI cannot be
  bypassed;
- the smallest backward-compatible representation in the existing `requestedValue` field;
- single and bulk review presentation without redesigning approval effects; and
- focused automated checks plus one controlled automatic-type and one manual-follow-up-type human
  proof, followed by proportionate staging evidence if implementation is later authorised.

## 4. Do Not Build

Do not plan or implement:

- automatic Age Group, AGG or Division movement/allocation on approval;
- new approval states, schema or migration;
- Team/fixture/competition lifecycle redesign;
- historic request repair;
- broad notification, bulk workflow or approval-effect redesign;
- weakened organisation, Club, Team or season scope; or
- FUND work in parallel while this CR-Fix is root `Now`.

## 5. Next Gate And Safe Resumption

Next authorised action: produce one concise Standard-depth `03` plan against exact application
baseline `068117848bc66739a2794c596621f372344a9209`. Planning is not implementation authority.

If this CR-Fix closes or is re-disposed, resume FUND Stage C only from exact candidate
`328aadf0a360b4c65837327060302ddc525f6168`: the recorded temporary worker is suspended, no
application secrets are injected, the private proof bucket is empty and existing auto-deploy
services remain untouched.
