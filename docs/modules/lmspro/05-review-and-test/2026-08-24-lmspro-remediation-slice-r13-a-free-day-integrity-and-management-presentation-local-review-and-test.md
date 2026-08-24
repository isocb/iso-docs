# LMSPro Remediation Slice R13-A — Free Day Integrity And Management Presentation Local Review And Test

Date: 2026-08-24

Review status: **EXACT CANDIDATE PROMOTED TO ORIGIN/STAGING; LOCAL AND SECURITY GATES PASS;
RENDER IDENTITY AND REPRESENTATIVE STAGING HUMAN GATE PENDING**

Exact commit: R13-A runtime `71ed589b9c6c55a8832fbfa1669de143236ec783`; promoted corridor
tip `e7a756cc39eac65b71729490f8c6c26f30435eb6` includes only a later root-AGENTS path
clarification.

Files/change boundary: the bounded R13-A application/test files listed in the implementation
confirmation; no schema, migration, data repair, delivery or R13-B implementation.

Automated checks: **PASS** — focused 35/35; full repository 471 passed and 12 intentionally
skipped; TypeScript, repository verification, targeted production lint, whitespace and the clean
Node 22 production build pass. Work-branch/dev/staging Security Scans pass.

Human evidence: **LOCAL PASS; STAGING PENDING.** The control owner records H1-H11 PASS using
controlled local C1/C2 personas and non-sensitive fixtures. H8 first exposed the Special
Team-selector quota defect; after correction, the control owner reran H8 and recorded PASS.
The proportionate authenticated S1-S4 staging matrix has not yet been reported.

Environment proven: local application/DevData and exact Git alignment through
`origin/staging`. Public staging health is HTTP 200 with database connected and RLS 11/11;
exact Render deployment identity remains pending. No live claim.

Known residual risk: public health cannot prove the deployed commit or authenticated C1/C2
behaviour. R13-A is not closed and R13-B is not active until those focused staging checks pass.

Next authorised action: record Render Live at `e7a756c` and S1-S4 staging results. On PASS,
close/reconcile R13-A and activate R13-B under the control owner's explicit instruction. Do not
promote to live.

Implementation confirmation:

- [R13-A implementation confirmation](../04-implementation-confirmations/2026-08-24-lmspro-remediation-slice-r13-a-free-day-integrity-and-management-presentation-confirmation.md)

Accepted plan:

- [R13-A planning](../03-slice-planning/2026-08-24-lmspro-remediation-slice-r13-a-free-day-integrity-and-management-presentation-planning.md)

## 1. Review Verdict

No blocking static-review or automated-test defect remains. Review found and corrected a valid
zero-allowance edge case: an empty grouped usage result must still classify every Team as at
limit when the configured allowance is zero. It also preserves zero in C1/C2 allowance display
instead of replacing it through a truthy default.

Human H8 then found the Special request modal reused the standard quota-disabled Team options.
The correction separates standard and Special Team-option construction: standard requests still
use the current season's configured allowance, while Special applications do not consume or
apply that allowance. Focused failing-first coverage passes, and the control owner subsequently
recorded H8 PASS.

The implementation passed local acceptance and exact work-branch/dev/staging Security Scans,
and the exact corridor tip is promoted to `origin/staging`. Final R13-A acceptance remains
conditional on exact Render identity and the representative authenticated staging path; this
record does not authorise live promotion.

## 2. Static Review

### PASS — authority and quota

- Standard quota scope includes organisation, season and optional Team at every consumer.
- Special applications are excluded and `PENDING`/`APPROVED`/`CONFIRMED` are included.
- foreign Team/season lookups fail before usage/statistic queries proceed;
- serializable request admission rechecks after a write conflict; and
- notification work happens only after a successful committed create.

### PASS — date-only boundary

- picker conversion reads local calendar components exactly once before transport;
- server normalisation stores UTC components at midnight;
- edit pickers rebuild from stored UTC components;
- list range boundaries compare UTC-midnight domain dates; and
- unrelated notification/timestamp formatting is unchanged.

### PASS — presentation state

- sorting copies arrays and uses stable identity fallbacks;
- summary controls are native keyboard-operable buttons;
- Pending establishes a season-wide request destination;
- Teams-at-limit opens Team aggregate detail; and
- Special filtering does not alter selection membership or server authority.

### PASS — scope containment

No Prisma schema, migration, historical mutation, recipient/routing change, Team Variation
implementation, FUND work or deployment configuration is present.

## 3. Automated Results

| Check | Result |
| --- | --- |
| Focused quota/date/presentation/router/notification/notice matrix | PASS — 35/35 |
| Full repository Vitest suite | PASS — 471 passed; 12 intentionally skipped |
| TypeScript | PASS |
| Critical repository verification | PASS |
| Targeted production lint | PASS — 0 errors; 10 warnings |
| Diff whitespace check | PASS |
| Production build | PASS — clean Next.js 15.5.21 build under Node 22.23.2 |
| Work-branch Security Scan | PASS — `32742731175` at `e7a756cc` |
| Dev Security Scan | PASS — `32743079768` at `e7a756cc` |
| Staging Security Scan | PASS — `32743397739` at `e7a756cc` |

The sandbox-only Chromium and `tsx` IPC failures were rerun with the required local permission
and passed. They are environmental evidence, not product failures.

The shell initially supplied Node 24.9.0 despite `.nvmrc` and `package.json` requiring Node 22.x;
two clean-cache build attempts under Node 24 emitted a broken `/_document` chunk location. The
clean build under Node 22.23.2 passed compilation, type validation, page data collection and all
131 static pages. Expected missing-local-Upstash warnings did not alter the result, and no local
credential/configuration change was made.

## 4. Local Human Smoke Matrix

Use the local application and local DevData only. Use controlled C1 and C2 test personas and
non-sensitive Free Day reasons. Record each row `PASS`, `FAIL` or `NOT RUN`; do not infer a pass
from automation.

| Ref | Check | Status/evidence |
| --- | --- | --- |
| H1 | Fresh C1 route loads at the actual default current season, blank status/Club/Age Group and `Future`; selecting each status and returning to `All Statuses` restores every row allowed by the remaining filters. | PASS — control-owner report. |
| H2 | `All Statuses` combines truthfully with Future, Past, All dates, Club and Age Group. | PASS — control-owner report. |
| H3 | Club, Team, Date, Reason, Status and Requested By each sort ascending then descending; keyboard activation and the active direction indicator work; row identity/selection is unchanged. | PASS — control-owner report. |
| H4 | Pending summary activates with pointer and keyboard, retains season, selects Pending + All dates, clears Club/Age Group, focuses results and its non-zero count equals visible rows. | PASS — control-owner report. |
| H5 | Teams At Limit activates with pointer and keyboard and its sorted Club/Team `used/total` detail equals the summary; a Special application alone has no effect. | PASS — control-owner report. |
| H6 | A Team with standard Pending/Approved/Confirmed reservations shows matching C1/C2 used, remaining and at-limit values; a stale/direct extra request is refused with no row/email. | PASS — control-owner report; direct refusal also has automated proof. |
| H7 | A BST standard calendar day survives C1 create/edit, request payload/storage and both C1/C2 displays; repeat a focused GMT case. | PASS — control-owner report. |
| H8 | Special date and apply-by date survive create/edit/display for BST and GMT; existing deadline and Club-scope rules remain unchanged. | PASS — control-owner retest after correction of the Special Team-selector quota defect. |
| H9 | Mixed Special applications appear in deterministic Club then Team order; selecting/resetting a per-day Age Group filter changes only visible applications and preserves selection membership. | PASS — control-owner report. |
| H10 | Disposable create/update/approve/reject/confirm/cancel actions refresh the affected lists, Pending/Approved/Cancelled summaries and Team quota without a hard reload. | PASS — control-owner report. |
| H11 | R12-A minimum-notice and existing Special lifecycle/Club-scope behaviour remain unchanged. | PASS — control-owner human report; automated minimum-notice regression also PASS. |

## 5. Proportionate Staging Gate

Do not repeat H1-H11 mechanically. Use controlled non-sensitive staging fixtures and record
each row `PASS`, `FAIL` or `NOT RUN`:

| Ref | Check | Status/evidence |
| --- | --- | --- |
| S1 | Render staging displays exact `Live at e7a756c`; public health is HTTP 200 with database connected and RLS 11/11. | PARTIAL — public health PASS at 2026-08-24T15:14:52Z; Render identity pending. |
| S2 | C1 quota/list summaries agree; C2 shows the same configured seasonal allowance and a Special request Team remains selectable at standard quota. | NOT RUN. |
| S3 | One existing GMT/BST Free Day displays the same calendar date in C1 and C2. | NOT RUN. |
| S4 | One disposable status/request action refreshes the affected list, summary and Team quota without hard reload. | NOT RUN. |

## 6. Stop And Escalation Rules

Any cross-tenant detail, count disagreement, Special-derived standard limit, accepted over-cap
request, one-day date shift, stale post-mutation summary or action on a hidden/unselected row is a
release blocker and returns R13-A to implementation.

Do not delete controlled test rows through direct database access. Use an already accepted UI/API
lifecycle, or leave fixture identifiers recorded for controlled cleanup.

## 7. Promotion Position

```text
exact R13-A runtime commit: 71ed589b9c6c55a8832fbfa1669de143236ec783
promoted corridor tip: e7a756cc39eac65b71729490f8c6c26f30435eb6
static/automated review: PASS
local fixture-backed human acceptance: PASS (H1-H11)
production build: PASS under repository-required Node 22.23.2
work-branch/dev/staging Security Scans: PASS
dev and origin/dev: MATCH
staging and origin/staging: MATCH; promoted
public staging health: PASS; Render exact identity and S1-S4 human gate pending
live promotion: not authorised and not performed
R13-B: remains inactive
```

Local acceptance and Git promotion through `origin/staging` pass. R13-A closure and R13-B
activation remain gated only on Render identity and the proportionate S1-S4 staging evidence.
