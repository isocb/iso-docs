# LMSPro Remediation Slice R14-A — Team Variation Approval Guidance And Configured Inputs Implementation Confirmation

Date: 2026-08-25

Status: **COMPLETE AND CLOSED — EXACT `D78935D4` PASSES LOCAL R1-R9, STAGING S1-S4,
PRODUCTION L1-L2, ALL SECURITY SCANS AND PUBLIC HEALTH**

Exact commit: **`d78935d407ace7ebe796a31a13adf3e17dafa758`**, test child of Free Day
presentation implementation `06966d49106f30f7724d6293ac3c31da33de693a` and corrected Variation
Request width parent `b6c35992959bb2cbdc4c212291fd5be834959e7f`.

Files/change boundary: one shared six-type Team Variation policy; C2 configured Age Group/Division
selectors without operational guidance; C1 Team Approval CRUD-modal plus Team Variations
single/mixed-bulk guidance; tenant/season/Age-Group-scoped AGG options; numeric Age Group ordering;
server-side configured target resolution; responsive 660px Variation Request and Free Day detail
modals; a demoted Free Day Save Changes control outside the workflow footer; focused
policy/router/surface tests. No schema, migration, authority, notification, historic-row repair,
automatic allocation or environment change.

Automated checks: **PASS** — exact `d78935d4` focused Free Day surface 2/2, promotion-time
safe-commit, TypeScript, critical-file verifier and whitespace. Parent `06966d49` passed combined
focused 8/8 and changed production-file ESLint with zero errors; earlier parents retain
focused/full/build evidence. Exact work-branch/dev/staging Security Scans
`32835754829`/`32835986995`/`32836190860` all pass, including generated reports.

Human evidence: **PASS R1-R9, S1-S4 AND L1-L2** — direct control-owner observation. The only R1-R6 remedial finding
was public display of internal role shorthand `C1`; exact `66104e35` renders `League Admin` and R7
passes. Exact `b6c35992` makes the row-click Variation Request detail modal 50% wider on desktop;
R8 passes. Exact `06966d49` applies the same responsive width to the Free Day row-click modal and
demotes Save Changes beneath League Notes; R9 passes. The control owner subsequently confirmed
exact staging identity and S1-S4 all green, followed by exact production identity and minimum
non-destructive L1-L2 all green.

Environment proven: corrected source and automated behaviour locally; exact refs align through
origin work branch, dev, staging and main at `d78935d4`. Staging S1-S4 pass. Staging and production
public health are HTTP 200 with database connected and RLS enabled on 11/11 tables. No schema
migration or runtime-configuration action was required.

Known residual risk: no accepted R14-A gate remains. C1/C2 remain internal control notation for
League Admin/Club Secretary respectively. Existing stored text remains backward-compatible; stale
configured references are re-resolved at mutation time.

Next authorised action: none for R14-A. Resume FUND Stage C under its existing exact-candidate and
zero-resource checkpoint; do not extend this closed slice.

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
- Gave the Free Day row-click modal the same 660px responsive width. Moved the single Save Changes
  control from the workflow footer to immediately below League Notes, retained its existing update
  mutation, and rendered it compact/subtle so Cancel, Reject/Approve and Confirm remain the dominant
  status actions.

## 2. Automated Evidence

| Gate | Result |
| --- | --- |
| Exact `d78935d4` focused Free Day surface tests | PASS — 2/2 |
| Exact `d78935d4` TypeScript / critical-file verifier / whitespace | PASS |
| Parent `06966d49` combined focused tests | PASS — 8/8 |
| Parent `06966d49` changed production-file ESLint | PASS — zero errors; four existing warnings |
| Parent `b6c35992` focused Variation surface tests | PASS — 2/2 |
| Parent `66104e35` focused policy/router/surface tests | PASS — 36/36 |
| Parent `0a6376a2` full repository Vitest | PASS — 509 passed; 12 intentionally skipped |
| Parent `0a6376a2` production build | PASS — 131 routes; not repeated for presentation-only children |
| Promotion-time exact `d78935d4` safe-commit | PASS — TypeScript and critical-file verifier |
| Work-branch Security Scan | PASS — `32835754829` at exact `d78935d4` |
| Dev Security Scan | PASS — `32835986995` at exact `d78935d4` |
| Staging Security Scan | PASS — `32836190860` at exact `d78935d4` |
| Public staging health | PASS — HTTP 200; database connected; RLS 11/11 |
| Staging human smoke | PASS — direct control-owner S1-S4 all green |
| Main Security Scan | PASS — `32838343535` at exact `d78935d4` |
| Public production health | PASS — HTTP 200; database connected; RLS 11/11 |
| Production human smoke | PASS — direct control-owner L1-L2 all green at exact `d78935d4` |

## 3. Recovery Position

The change is application-only and preserves the existing text storage contract. Recovery is a
compatible application revert to `06811784`; no migration, data rollback or configured-reference
repair is required.
