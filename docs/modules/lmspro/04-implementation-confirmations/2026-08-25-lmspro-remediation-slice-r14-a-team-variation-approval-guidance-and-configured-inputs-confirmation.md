# LMSPro Remediation Slice R14-A — Team Variation Approval Guidance And Configured Inputs Implementation Confirmation

Date: 2026-08-25

Status: **LOCAL IMPLEMENTATION COMPLETE; AUTOMATED STANDARD-DEPTH GATE PASS; CONTROLLED
C1/C2 HUMAN H1-H6 NOT RUN; NO PUSH, PROMOTION OR DEPLOYMENT AUTHORISED**

Exact commit: **`0700993b16fa83902327eb9e91aa5889e968a383`**, built from accepted exact
baseline `068117848bc66739a2794c596621f372344a9209`.

Files/change boundary: one shared six-type Team Variation policy; C2 approval guidance and
configured Age Group/Division selectors; C1 single and mixed-bulk guidance; server-side configured
target resolution; focused policy/router tests. No schema, migration, authority, notification,
historic-row repair, automatic allocation or environment change.

Automated checks: **PASS** — focused 31/31; full repository 505 pass and 12 intentionally skipped;
TypeScript, critical-file verification, changed production-file ESLint with zero errors, whitespace
and the 131-route production build pass. The first sandboxed full run had one infrastructure-only
Chromium launch refusal in the unrelated FUND proof; the same full suite passed outside that
sandbox.

Human evidence: **NOT RUN** — H1-H6 require direct observation with local DevData and controlled
C1/C2 personas. No pass is inferred from automation.

Environment proven: exact candidate running on local port 3000/DevData; health reports healthy and
database connected, with established local RLS `0/11`. Remote dev/staging/main remain at the prior
exact `06811784` boundary.

Known residual risk: selector rendering, explanatory copy, post-action refresh and mixed-bulk
presentation still require the controlled local human matrix. Existing stored text remains
backward-compatible; stale configured references are re-resolved at mutation time.

Next authorised action: run and record local H1-H6. A green matrix may support a later explicit
push/security/promotion decision; it does not itself authorise one.

Accepted plan:

- [R14-A planning](../03-slice-planning/2026-08-25-lmspro-remediation-slice-r14-a-team-variation-approval-guidance-and-configured-inputs-planning.md)

Review and test:

- [R14-A local review and test](../05-review-and-test/2026-08-25-lmspro-remediation-slice-r14-a-team-variation-approval-guidance-and-configured-inputs-local-review-and-test.md)

## 1. Implemented Behaviour

- Centralised the labels, input modes, automatic/manual classification, approval description and
  C1 follow-up task for all six request types.
- Kept `NAME_CHANGE` and `WITHDRAWAL` as the only automatic approval effects; the other four types
  remain Team-non-mutating.
- Replaced Age Group free text and client-trusted Division text with required searchable configured
  selectors.
- Submitted a configured target ID and resolved it again in the create mutation against the
  authorised Team's organisation, season and current Age Group.
- Refused missing, stale/out-of-scope, current and retired Age Group targets and missing,
  stale/out-of-scope, wrong-Age-Group and current Division targets before request/audit/email.
- Stored the resolved configured code/name snapshot in the existing `requestedValue` field; raw
  configured labels supplied by a client are ignored.
- Added truthful C2 guidance before submission, C1 guidance before/after single approval and
  automatic/manual counts plus distinct manual tasks for mixed bulk selection.

## 2. Automated Evidence

| Gate | Result |
| --- | --- |
| Focused policy/router tests | PASS — 31/31 |
| Full repository Vitest | PASS — 505 passed; 12 intentionally skipped |
| TypeScript | PASS |
| Critical-file verifier | PASS |
| Changed production-file ESLint | PASS — zero errors; 12 existing `any` warnings |
| Diff whitespace | PASS |
| Production build | PASS — 131 routes |

## 3. Recovery Position

The change is application-only and preserves the existing text storage contract. Recovery is a
compatible application revert to `06811784`; no migration, data rollback or configured-reference
repair is required.
