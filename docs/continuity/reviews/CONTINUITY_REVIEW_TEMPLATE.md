# IsoStack Continuity Review

Review period:

Review type: Monthly / Quarterly / Six-monthly tabletop / Annual / Event-driven

Review date:

Status: Planned / In progress / Complete

Overall disposition: Not assessed / Green / Amber / Red

Continuity owner:

Deputy:

Participants:

Evidence cutoff:

## 1. Authority And Scope

State:

- who authorised and conducted the review;
- the environments, repositories, providers and business functions in scope;
- exclusions and why;
- whether the review is evidence-only or includes a separately authorised exercise; and
- actions explicitly not authorised.

## 2. Governing Sources Read

- [ ] Continuity And Operational Assurance Cycle
- [ ] Routine IsoStack Management Handbook
- [ ] Technical Continuity And Succession Handbook
- [ ] IsoStack Tools And AI Support Guide
- [ ] Current root roadmap
- [ ] Current Platform Assurance disposition
- [ ] Relevant provider/incident records

List exact paths or links and revision/commit where material:

## 3. Review Evidence

Use `Confirmed`, `Observed`, `Not assessed` or `Not applicable`. Never infer Green from
missing evidence.

| Control                                                                         | Result       | Evidence location or non-secret observation | Checked by | Finding/action |
| ------------------------------------------------------------------------------- | ------------ | ------------------------------------------- | ---------- | -------------- |
| Live website and health result                                                  | Not assessed |                                             |            |                |
| Render live web service identified                                              | Not assessed |                                             |            |                |
| Render scheduled services identified                                            | Not assessed |                                             |            |                |
| Neon live project/branch identity confirmed without recording connection string | Not assessed |                                             |            |                |
| GitHub repositories and protected delivery branches confirmed                   | Not assessed |                                             |            |                |
| Provider billing/payment continuity                                             | Not assessed |                                             |            |                |
| Two administrators for each critical provider                                   | Not assessed |                                             |            |                |
| MFA and company-controlled recovery paths                                       | Not assessed |                                             |            |                |
| Shared operational/security alerts                                              | Not assessed |                                             |            |                |
| Domain/DNS ownership and renewal                                                | Not assessed |                                             |            |                |
| Resend, Upstash, storage and payment dependencies                               | Not assessed |                                             |            |                |
| Restore-window and recovery evidence                                            | Not assessed |                                             |            |                |
| Application rollback plan understood                                            | Not assessed |                                             |            |                |
| Customer/privacy incident contacts                                              | Not assessed |                                             |            |                |
| Handbooks and service card current                                              | Not assessed |                                             |            |                |
| Replacement-maintainer readiness                                                | Not assessed |                                             |            |                |
| Tracked continuity files free of secrets                                        | Not assessed |                                             |            |                |

## 4. Exercise Evidence

Complete for tabletop or annual exercises. Otherwise record `Not applicable`.

Scenario:

Start condition:

Participants:

First ten-minute response:

Escalation route:

Communications tested:

Actions deliberately not performed:

What worked:

What was unclear or unavailable:

## 5. Findings And Corrective Actions

Use identifiers such as `CONT-2026-001`.

| ID  | Finding | Severity | Owner | Correct route | Target date | Status | Closure evidence |
| --- | ------- | -------- | ----- | ------------- | ----------- | ------ | ---------------- |

Severity meanings:

- Red — immediate material continuity, security, data or authority risk;
- Amber — service may continue but a controlled gap requires correction; and
- Green observation — no action required, retained only when useful as evidence.

## 6. Overall Disposition

Overall result:

Reasons:

Accepted Amber risks:

Red escalation performed:

Next required review:

## 7. Attestation

Continuity owner:

Date:

Deputy/reviewer:

Date:

Attestation:

```text
This record distinguishes confirmed evidence from unassessed items. It contains no secret
values or unnecessary customer data. It does not claim that an unperformed deployment,
restore, rollback, test or access check occurred.
```

## 8. Addenda

Add later corrections or closure evidence as dated entries. Do not rewrite signed historical
evidence.
