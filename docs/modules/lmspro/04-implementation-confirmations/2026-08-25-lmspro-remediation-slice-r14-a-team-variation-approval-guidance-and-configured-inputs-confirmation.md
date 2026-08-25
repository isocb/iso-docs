# LMSPro Remediation Slice R14-A — Team Variation Approval Guidance And Configured Inputs Implementation Confirmation

Date: 2026-08-25

Status: **INITIAL HUMAN SMOKE FAILED THREE PRESENTATION/OPTION CHECKS; CORRECTED LOCAL
IMPLEMENTATION `0A6376A2` PASSES AUTOMATED STANDARD-DEPTH GATE; R1-R6 RETEST NOT RUN;
NO PUSH, PROMOTION OR DEPLOYMENT AUTHORISED**

Exact commit: **`0a6376a235dbb97109d894af574d9ef0546ead00`**, superseding initial local
candidate `0700993b16fa83902327eb9e91aa5889e968a383` and built from accepted exact baseline
`068117848bc66739a2794c596621f372344a9209`.

Files/change boundary: one shared six-type Team Variation policy; C2 configured Age Group/Division
selectors without operational guidance; C1 Team Approval CRUD-modal plus Team Variations
single/mixed-bulk guidance; tenant/season/Age-Group-scoped AGG options; numeric Age Group ordering;
server-side configured target resolution; focused policy/router/surface tests. No schema,
migration, authority, notification, historic-row repair, automatic allocation or environment
change.

Automated checks: **PASS** — corrected focused 35/35; full repository 509 pass and 12 intentionally
skipped; TypeScript, critical-file verification, changed production-file ESLint with zero errors,
whitespace and the 131-route production build pass.

Human evidence: **FAIL on superseded `0700993b`** — control-owner smoke found misplaced C2
guidance/missing C1 CRUD-modal guidance, an empty U10 Division selector and lexicographic Age Group
ordering. Corrected candidate R1-R6 are **NOT RUN**; no pass is inferred from automation.

Environment proven: corrected source and automated behaviour on the local work branch. The
control owner manages the browser-facing local server. Remote dev/staging/main remain at the prior
exact `06811784` boundary.

Known residual risk: selector rendering, explanatory copy, post-action refresh and mixed-bulk
presentation still require the controlled local human matrix. Existing stored text remains
backward-compatible; stale configured references are re-resolved at mutation time.

Next authorised action: run and record corrected local R1-R6. A green matrix may support a later
explicit push/security/promotion decision; it does not itself authorise one.

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
- Kept C2 focused on request inputs and moved operational approval/follow-up guidance to both C1
  approval surfaces, including the Team Approval CRUD modal discovered during smoke.
- Scoped the existing AGG list by the selected Team's Age Group and excluded the current Division.
- Reused numeric Age Group ordering with a code-derived fallback for legacy null `ageValue` rows.
- Retained C1 guidance before/after single approval and automatic/manual counts plus distinct manual
  tasks for mixed bulk selection.

## 2. Automated Evidence

| Gate | Result |
| --- | --- |
| Focused policy/router/surface tests | PASS — 35/35 |
| Full repository Vitest | PASS — 509 passed; 12 intentionally skipped |
| TypeScript | PASS |
| Critical-file verifier | PASS |
| Changed production-file ESLint | PASS — zero errors; 16 existing warnings |
| Diff whitespace | PASS |
| Production build | PASS — 131 routes |

## 3. Recovery Position

The change is application-only and preserves the existing text storage contract. Recovery is a
compatible application revert to `06811784`; no migration, data rollback or configured-reference
repair is required.
