# LMSPro Remediation Slice R14-A — Team Variation Approval Guidance And Configured Inputs Implementation Confirmation

Date: 2026-08-25

Status: **R1-R7 CONTROL-OWNER PASS; RESPONSIVE MODAL CORRECTION `B6C35992` PASSES
FOCUSED AUTOMATION; R8 NOT RUN; NO PUSH, PROMOTION OR DEPLOYMENT AUTHORISED**

Exact commit: **`b6c35992959bb2cbdc4c212291fd5be834959e7f`**, which supersedes wrong-target
modal child `7fb6ad792f28d19b2a346b70ee93311b0a6b08e7`, restores the unrelated Assign Division
modal and applies the width to the intended row-click Variation Request detail modal.

Files/change boundary: one shared six-type Team Variation policy; C2 configured Age Group/Division
selectors without operational guidance; C1 Team Approval CRUD-modal plus Team Variations
single/mixed-bulk guidance; tenant/season/Age-Group-scoped AGG options; numeric Age Group ordering;
server-side configured target resolution; a responsive 660px Variation Request detail modal; focused
policy/router/surface tests. No schema, migration, authority, notification, historic-row repair,
automatic allocation or environment change.

Automated checks: **PASS** — exact `b6c35992` focused surface 2/2, TypeScript, critical-file
verifier, changed production-file ESLint with zero errors and whitespace. Parent `66104e35` passed
focused 36/36; parent `0a6376a2` passed full 509 pass/12 skip and the 131-route build.

Human evidence: **PASS R1-R7** — direct control-owner observation. The only R1-R6 remedial finding
was public display of internal role shorthand `C1`; exact `66104e35` renders `League Admin` and R7
passes. Exact `b6c35992` makes the row-click Variation Request detail modal 50% wider on desktop
while retaining the component's viewport cap. R8 is **NOT RUN**.

Environment proven: corrected source and automated behaviour on the local work branch. The
control owner manages the browser-facing local server. Remote dev/staging/main remain at the prior
exact `06811784` boundary.

Known residual risk: only the responsive modal presentation requires R8. C1/C2 remain internal
control notation for League Admin/Club Secretary respectively. Existing stored text remains
backward-compatible; stale configured references are re-resolved at mutation time.

Next authorised action: run and record local R8 only. A green result may support a later explicit
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
- Kept C2 focused on request inputs and moved operational approval/follow-up guidance to both C1
  approval surfaces, including the Team Approval CRUD modal discovered during smoke.
- Scoped the existing AGG list by the selected Team's Age Group and excluded the current Division.
- Reused numeric Age Group ordering with a code-derived fallback for legacy null `ageValue` rows.
- Retained C1 guidance before/after single approval and automatic/manual counts plus distinct manual
  tasks for mixed bulk selection.
- Replaced all rendered `C1` shorthand in those guidance messages, headings and bulk counts with
  the public role name `League Admin`; internal lifecycle/test labels retain C1/C2 notation.
- Increased only the row-click League Admin Variation Request detail modal from 440px to 660px.
  Mantine retains `max-width: 100%`, so narrower viewports constrain it responsively. The unrelated
  Assign Division modal retains its original `md` size.

## 2. Automated Evidence

| Gate | Result |
| --- | --- |
| Exact `b6c35992` focused surface tests | PASS — 2/2 |
| Exact `b6c35992` TypeScript | PASS |
| Exact `b6c35992` critical-file verifier | PASS — pre-commit gate |
| Exact `b6c35992` changed production-file ESLint | PASS — zero errors; six existing warnings |
| Exact `b6c35992` diff whitespace | PASS |
| Parent `66104e35` focused policy/router/surface tests | PASS — 36/36 |
| Parent `0a6376a2` full repository Vitest | PASS — 509 passed; 12 intentionally skipped |
| Parent `0a6376a2` production build | PASS — 131 routes; not repeated for presentation-only children |

## 3. Recovery Position

The change is application-only and preserves the existing text storage contract. Recovery is a
compatible application revert to `06811784`; no migration, data rollback or configured-reference
repair is required.
