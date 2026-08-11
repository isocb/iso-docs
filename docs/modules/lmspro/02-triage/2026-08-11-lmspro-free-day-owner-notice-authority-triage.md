# LMSPro Free Day Owner Notice Authority Triage

Date: 2026-08-11

Status: **R12-A LOCAL PASS COMPLETE; EXACT `39a25d99` PROMOTED THROUGH STAGING WITH BOTH
EXACT SECURITY SCANS AND PUBLIC HEALTH GREEN; STAGING HUMAN ACCEPTANCE PENDING**

Source:

[`Free Day Owner notice authority CR-Fix`](../01-cr-inputs/CR-Fix-2026-08-11-lmspro-free-day-owner-notice-authority.md)

## 1. Decision

Accept one bounded slice, `R12-A`, because the saved owner policy does not control actual
calendar/server eligibility below 28 days. The defect is narrow, independently testable and
does not require a Free Days redesign.

The previous 28-day UAT requirement is reclassified as default-value intent. The current
0–90 edit surface is also corrected: 0 is no longer valid; 1–90 is authoritative.

## 2. Risk And Expedite Assessment

| Concern | Assessment |
| --- | --- |
| Data loss/privacy | None expected; additive default change plus bounded value normalisation |
| Operational risk | Medium: direct server calls and calendars currently override owner policy |
| Correction risk | Low/medium: duplicated client/server calculations and legacy stored defaults |
| Workaround | Values at or above 28 work, but that denies the accepted owner authority |
| Expedite | Accepted micro expedite; later explicit authority promoted exact `39a25d99` through staging only |
| Displaced work | Platform Support Ticketing resumes after R12-A staging disposition with canonical-P1 discovery/correction now identified |

## 3. Stop Conditions

Stop if implementation requires changing request history, weakening Team/tenant authority,
altering Special Free Days, interpreting a non-integer/out-of-range value as authoritative,
or modifying a shared database. Otherwise proceed through plan, implementation confirmation
and local human gate.

Planning:

[`R12-A planning`](../03-slice-planning/2026-08-11-lmspro-r12-a-free-day-owner-notice-authority-planning.md)
