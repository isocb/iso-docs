# LMSPro Remediation Slice R13-B — Deferred Team Variation Workflow Local Review And Test

Date: 2026-08-24

Review status: **LOCAL B1-B10 PASS; EXACT `06811784` PROMOTED THROUGH STAGING; ALL
SECURITY, STAGING MIGRATION/SCHEMA AND PUBLIC HEALTH/RLS GATES PASS; EXACT RENDER IDENTITY
AND REPRESENTATIVE STAGING S1-S4 HUMAN SMOKE PENDING**

Exact commit: `068117848bc66739a2794c596621f372344a9209`.

Files/change boundary: the bounded schema/migration, Team Variation router/policy, clone,
C1/C2 presentation and test/verifier files recorded in the implementation confirmation. No
Free Day, notification, repair, deployment-configuration or production change. The authorised
staging migration/promotion evidence is recorded below.

Automated checks: **PASS** — focused 13/13, full 484 pass/12 skip, Prisma validate/generate,
read-only DevData migration proof, TypeScript, verifier, production lint, whitespace and Node 22
build.

Human evidence: **PASS** — on 2026-08-25 the control owner reported all B1-B10 checks below green
from the local application/DevData smoke using controlled C1/C2 personas. These are human-reported
observations, not inferred from automation.

Environment proven: local port 3000/DevData and the controlled work-branch/dev/staging corridor.
Exact Git refs align at `06811784`; staging migration/schema verification passes; public staging
health is HTTP 200 with database connected and RLS `11/11`.

Known residual risk: exact Render build identity and environment-specific tenant behavior are still
human-unproved. The smoke also exposed a pre-existing normal-approval consistency concern outside
the Deferred slice; it is captured in the separately registered approval-consistency CR.

Next authorised action: confirm Render displays exact `06811784` and record S1-S4 below using
controlled C1/C2 users and non-sensitive reasons. Do not infer a pass from local or automated proof.

Implementation confirmation:

- [R13-B implementation confirmation](../04-implementation-confirmations/2026-08-24-lmspro-remediation-slice-r13-b-deferred-team-variation-workflow-confirmation.md)

Accepted plan:

- [R13-B planning](../03-slice-planning/2026-08-24-lmspro-remediation-slice-r13-b-deferred-team-variation-workflow-planning.md)

## 1. Review Verdict

No blocking static, migration or automated defect remains. Review tightened the first implementation
so reply writes recheck non-Deferred status, bulk actions refuse stale/non-Pending membership, and
transition/audit pairs roll back together. Deferred is excluded from Pending-only selection and the
Pending-plus-Approved Outstanding aggregate.

## 2. Security And Integrity Findings

- Organisation scope and existing `teams.approve.view` authority guard both League transitions.
- Conditional status writes make one competing transition win; stale operations fail without an
  audit record or Team mutation.
- C2 cancellation requires organisation, exact submitter, current permitted Club and active status.
- Same-Team/type duplicate prevention treats Deferred as active.
- The reason is bounded, optional, retained on return and visible only through existing scoped lists.
- No notification template, recipient resolver or delivery path changed; defer/return call no email.
- Migration SQL is expand-only and leaves existing rows unchanged/null-compatible.

## 3. Controlled Local Human Matrix

Use only the local application, DevData, controlled C1/C2 personas, disposable requests and
non-sensitive reasons. Record observed results; do not infer a pass from automation.

| Ref | Check | Status/evidence |
| --- | --- | --- |
| B1 | C1 opens a disposable Pending request, selects Defer, then cancels the confirmation; status, Team and row remain unchanged. | PASS — control-owner local smoke |
| B2 | C1 defers with a non-sensitive reason; the same row becomes Deferred immediately without hard reload and the Team values remain unchanged. | PASS — control-owner local smoke |
| B3 | Deferred detail shows reason and only `Return to Pending` plus passive `Close`; Approve, Reject, Save Reply, Confirm Updated and bulk selection are absent. | PASS — control-owner local smoke |
| B4 | `All` and `Deferred` include the row; `Outstanding` excludes it; Pending/Approved dashboard counts and pending-only bulk totals remain unchanged. | PASS — control-owner local smoke |
| B5 | C2 Club Dashboard and Club Teams show friendly Deferred status and the same reason. | PASS — control-owner local smoke |
| B6 | A non-submitting C2 user has no Cancel control; another Club cannot see/access the request. | PASS — control-owner local smoke |
| B7 | The exact submitting C2 user cancels one disposable Deferred request; it becomes Cancelled without hard reload. | PASS — control-owner local smoke |
| B8 | On another request, C1 returns Deferred to Pending; the reason remains visible and normal Pending controls return. | PASS — control-owner local smoke |
| B9 | Process the restored request through one existing normal outcome; same row/Team behavior remains correct and no replacement request appears. | PASS — control-owner local smoke; separate normal-approval consistency observation captured in the registered CR |
| B10 | No email is received or shown as queued/delivered for defer or return-to-Pending. | PASS — control-owner local smoke |

## 4. Stop Rules

Any cross-tenant/Club visibility, non-submitter cancellation, Team mutation on defer/return,
duplicate active request, Deferred bulk/reply/approve/reject action, count inclusion, missing audit,
unplanned email or migration discrepancy is a blocker and returns R13-B to implementation.

## 5. Staging Technical And Representative Human Gate

Technical evidence obtained on 2026-08-25:

| Gate | Result |
| --- | --- |
| Exact Git corridor | PASS — origin work branch, dev and staging align at `068117848bc66739a2794c596621f372344a9209` |
| Work-branch Security Scan | PASS — `32822571678` |
| Dev Security Scan | PASS — `32822798627` |
| Staging Security Scan | PASS — `32823100732` |
| Pre-deploy pending-migration boundary | PASS — R13-B was the only pending staging migration |
| Post-deploy migration/schema | PASS — ledger complete, `DEFERRED` present, nullable text column and initial null compatibility |
| Public staging health | PASS — HTTP 200, database connected, RLS enabled `11/11` |

Use controlled staging C1/C2 personas, disposable requests and non-sensitive reasons. Record every
row `PASS`, `FAIL` or `NOT RUN`; do not infer a pass from the green local matrix.

| Ref | Check | Status/evidence |
| --- | --- | --- |
| S1 | Render displays exact commit `068117848bc66739a2794c596621f372344a9209`; the authenticated C1 Variation route loads without migration/runtime or console errors. | NOT RUN |
| S2 | C1 defers one disposable Pending request with a reason; the same row becomes Deferred, Team values remain unchanged, only Return to Pending/Close remain, and All/Deferred/Outstanding plus counts are truthful. | NOT RUN |
| S3 | Authorised C2 sees the same Deferred status/reason; a non-submitter and another Club cannot cancel/access it; the exact submitter can cancel a disposable Deferred request. | NOT RUN |
| S4 | On another disposable request, C1 returns Deferred to Pending; normal Pending controls return, audit evidence exists, and no defer/return email is queued or delivered. | NOT RUN |

Any S1 identity mismatch, migration/runtime error, tenant/submitter escape, Team mutation, forbidden
Deferred action or unplanned email blocks R13-B closure and live consideration.

## 6. Promotion Position

```text
exact local candidate: 068117848bc66739a2794c596621f372344a9209
DevData migration: applied and read-only verified
static/automated/build: PASS
local human B1-B10: PASS — control-owner report 2026-08-25
work branch/dev/staging refs: exact 06811784
work branch/dev/staging Security Scans: PASS — 32822571678 / 32822798627 / 32823100732
staging migration/schema/health: PASS — exact ledger/enum/column/null; database connected; RLS 11/11
exact Render build identity and staging S1-S4: NOT RUN
production migration/promotion/deployment: not authorised or performed
```
