# LMSPro / SeasonPro Roadmap And Slice Control

Date: 2026-06-29
Last updated: 2026-07-21
Module: LMSPro / SeasonPro
Control status: Active roadmap and delivery-cycle control

## Purpose

This document is the current operational control point for LMSPro / SeasonPro remediation, slice planning and review.

Use it to resume work without reconstructing context from legacy planning notes.

It is now the governing progress document for active LMSPro / SeasonPro work. It should be
updated after every completed delivery cycle and before opening a new substantive lane.

## Current Documentation Structure

Current and new operational work should use:

- `00-roadmap-control/` - master state, current lanes and next slices.
- `01-cr-inputs/` - raw issue/change request evidence.
- `02-triage/` - decision and priority records.
- `03-slice-planning/` - scoped build/review plans.
- `04-implementation-confirmations/` - records of completed implementation.
- `05-review-and-test/` - review and smoke-test evidence.

Existing broad/historical planning remains in `planning/` unless it becomes operationally active.

## Controlled Delivery Cycle

Use this cycle for all non-trivial LMSPro / SeasonPro work:

```text
01-cr-inputs
-> 02-triage
-> 03-slice-planning
-> implementation in app repo
-> 04-implementation-confirmations
-> 05-review-and-test
-> roadmap/control update
```

Gate rules:

- A CR input is evidence and intent. It is not an implementation plan.
- Triage decides whether the CR is accepted, deferred, split, rejected or moved to concept
  control.
- Slice planning defines the exact build boundary, risks, data model implications,
  permissions and review expectations.
- Implementation should not begin until the relevant 03 slice plan is accepted.
- Implementation confirmation records what was actually changed.
- Review/test records browser smoke, scripts, known gaps and promotion confidence.
- This roadmap/control document is updated at cycle close before the next slice begins.

Recommended improvements to the cycle:

- Record branch/environment state in the roadmap before and after promotion.
- Record explicit "Do Not Build" boundaries in each slice.
- Add risk and safeguarding notes whenever minors, personal data, exports or impersonation
  are in scope.
- Keep concept/product strategy documents separate from near-term feature CRs.
- Treat suggested slices in CR inputs as advisory until triage and planning accept them.
- Prefer smaller slices where permission boundaries or sensitive data are involved.

## Current App Branch Context

Current app development baseline:

```text
dev
```

Current work should remain on dev/remediation branches until reviewed and explicitly aligned.

Latest known app alignment from prior cycle:

```text
origin/main = origin/staging = origin/dev = ea4e619
```

This alignment included the completed LMSPro remediation and FUND availability baseline
promotions before returning to LMSPro development planning.

## Current Completed LMSPro Cycle State

Recent LMSPro lanes completed and documented:

- R2 - imported club-user membership and live data repair;
- R3 - club official removal and archived access lifecycle planning;
- R4 - communications, email and announcements remediation;
- R5 - age group/division manager notification routing and role catalogue polish;
- R6 - playing-day mitigation and architecture overview planning;
- R7 - small UI/count polish promoted through staging and live.

Current posture:

```text
R8-A is the active accepted LMSPro remediation lane.
R8-A1 is complete on the remediation branch. R8-A2 is implemented and technically verified
on that branch with the accepted broad file/malware/shared-link policy, private
Render-hosted ClamAV direction and independent limits of three uploaded attachments and
three external links. R8-A2 is paused at its required deployed human UI smoke-test gate.
```

An urgent communications-integrity candidate now precedes optional feature implementation:

```text
R8-A - Attachment-Aware Email Delivery Route And Fail-Closed Evidence
```

R8-A has a captured CR input and accepted controlling slice plan. Sequential implementation
of R8-A1 through R8-A5 is authorised, subject to the plan's business-decision and human UI
smoke-test pause gates.

## Immediate Remedial Candidate Lane

### R8-A - Attachment-Aware Email Delivery Route And Fail-Closed Evidence

Priority:

```text
High - live silent communication-integrity failure
```

Source incident:

- a C1 League Administrator composed an ad-hoc email;
- the compose UI showed an added attachment;
- the email body was delivered;
- the attachment was absent; and
- the UI gave no warning that the communication was incomplete.

CR input:

```text
01-cr-inputs/2026-07-20-lmspro-cr-attachment-aware-email-delivery-and-fail-closed-evidence-remediation-input.md
```

Accepted controlling plan:

```text
03-slice-planning/2026-07-20-lmspro-remediation-slice-r8-a-attachment-aware-email-delivery-route-and-fail-closed-evidence-planning.md
```

Status:

```text
Accepted 2026-07-21; R8-A1 completed; R8-A2 technically complete on the remediation branch and awaiting deployed human UI smoke confirmation.
```

Implementation baselines:

```text
application: fix/lmspro-r8-a-attachment-delivery from origin/dev at e3f44b4b
documentation: fix/lmspro-r8-a-attachment-delivery from origin/main at 6190751
```

The documentation repository has no `origin/dev`; `origin/main` is its controlling remote
baseline.

Confirmed provider boundary:

- Resend batch supports up to 100 emails per request;
- Resend batch does not support attachments;
- the current shared sender nevertheless passes attachment payloads to the batch endpoint;
- attachment-bearing sends therefore do not have a supported delivery contract.

Controlling delivery decision:

```text
zero persisted attachments
-> preserve existing Resend batch path, including solitary recipients

one or more persisted attachments
-> fail-closed attachment finalisation
-> asynchronous delivery job
-> ordinary Resend /emails endpoint
-> one recipient per provider request
-> up to 3 attachments and 10 MB cumulative
-> short-lived signed path to each validated private object
```

R8-A2 also retains broad Office/image/ZIP support subject to actual-type validation and a
mandatory `CLEAN` malware result. C1 may provide a controlled HTTPS shared-document link,
which is rendered as an externally hosted link and is not fetched, copied, scanned or
permission-tested by SeasonPro. The compose UI must explicitly state and record that the C1
SeasonPro Administrator is responsible for the integrity, suitability and sharing
permissions of supplied files and links. This notice does not replace malware scanning for
SeasonPro-managed uploads. Links alone do not select the attachment job: a communication
with no managed binary attachment continues to use the proven batch route. Malware scanning
will use a dedicated private ClamAV service on Render. The three uploaded attachments and
external-link allowance are independent; three external links is the accepted initial cap.

R8-A must support approximately 300 attachment recipients through a rate-controlled,
resumable worker. It must not hold the C1 browser request open while sending all messages.

Required protection:

- do not broadly refactor the proven no-attachment batch sender;
- select delivery mode from durable server-side attachment evidence;
- block queueing when intended, persisted, validated and readable attachment counts differ;
- preserve exact attachment evidence across new, reopened and duplicated drafts;
- expose queued, sending, partial, failed and completed state to C1;
- prevent successful recipients being duplicated during retry/restart; and
- prove no-attachment batch regression alongside attachment delivery.

Key-date sequence attachment authoring remains outside R8-A. The new ordinary attachment
sender should be reusable by a later bounded sequence-attachment slice if that outcome is
accepted.

Next action:

```text
Deploy the R8-A2 branch and record the required human UI, private R2 and private ClamAV smoke
results. Do not create R8-A3 planning until that evidence is reported and accepted.
```

R8-A2 planning:

```text
03-slice-planning/2026-07-21-lmspro-remediation-slice-r8-a2-attachment-persistence-drafts-and-fail-closed-preflight-planning.md
```

The dedicated private ClamAV service on Render is accepted so potentially sensitive Club
documents remain inside the controlled environment. Its paid-service and operational
resource/signature-health ownership are therefore accepted R8-A2 implications. The
three-link cap is accepted and implemented independently from the three-upload/10 MB
allowance. R8-A2 is now paused for its deployed human UI smoke-test result before R8-A3
planning may be created.

R8-A2 completion evidence:

```text
planning:
03-slice-planning/2026-07-21-lmspro-remediation-slice-r8-a2-attachment-persistence-drafts-and-fail-closed-preflight-planning.md

implementation:
04-implementation-confirmations/2026-07-21-lmspro-remediation-slice-r8-a2-attachment-persistence-drafts-and-fail-closed-preflight-confirmation.md

review/test:
05-review-and-test/2026-07-21-lmspro-remediation-slice-r8-a2-attachment-persistence-drafts-and-fail-closed-preflight-review-and-test.md
```

R8-A1 completion evidence:

```text
planning:
03-slice-planning/2026-07-21-lmspro-remediation-slice-r8-a1-provider-contract-and-sender-dispatcher-planning.md

implementation:
04-implementation-confirmations/2026-07-21-lmspro-remediation-slice-r8-a1-provider-contract-and-sender-dispatcher-confirmation.md

review/test:
05-review-and-test/2026-07-21-lmspro-remediation-slice-r8-a1-provider-contract-and-sender-dispatcher-review-and-test.md

application commits:
5ca66f28, 135f6c79
```

## Existing Feature Candidate Lane

### Club Operational Player Management / Team Manager Access

CR input:

```text
01-cr-inputs/2026-07-08-lmspro-cr-club-player-management.md
```

Triage:

```text
02-triage/2026-07-08-lmspro-triage-club-player-management.md
```

Status:

```text
PM1-A planning created; not yet accepted for implementation.
```

Working boundary:

- This is a SeasonPro / LMSPro club-value extension.
- It is not a league-wide player registration system.
- It is not the standalone ClubPro product.
- Player records are club-controlled operational data.
- Team Manager access must be designed before exposing player data to delegated users.

Next action:

```text
Review and accept, revise or split PM1-A before any implementation.
```

Current planning document:

```text
03-slice-planning/2026-07-08-lmspro-feature-slice-pm1-a-club-player-management-foundation-planning.md
```

Initial planning should cover Team Manager access and the Player data model together, but
implementation should remain split so sensitive player data is not exposed before scoped
permissions, audit and safeguarding controls are proven.

## Product Concept Boundary

ClubPro is tracked separately as a product concept, not as an LMSPro implementation slice:

```text
docs/modules/clubpro/00-roadmap-control/2026-07-08-clubpro-concept-development-and-product-boundary.md
```

ClubPro may inform long-term platform design, but it must not expand the immediate LMSPro
Club Player Management CR.

## Historical Remediation Lane Notes

### R1 - Playing Season Date Boundaries

Status: R1-A reviewed on staging and approved for live promotion

Goal:

Separate the technical/admin season boundary from the effective playing-season boundary.

Current distinction:

- Season Start Date / End Date = technical/admin season container.
- Playing Season Start / Playing Season End = effective playing period used for countdowns and season-progress calculations.

Recommended first planning document:

```text
03-slice-planning/2026-06-29-lmspro-remediation-slice-r1-playing-season-date-boundaries-planning.md
```

Accepted first implementation slice:

```text
LMSPro R1-A - Playing Season Date Fields And Season Admin Display
```

Scope:

- Add nullable `playingSeasonStartsAt` and `playingSeasonEndsAt` fields.
- Keep existing seasons blank until manually set.
- Add fields to Season CRUD modal.
- Display technical/admin and playing-season ranges on the Season admin page.
- Update `% season remaining` to use playing-season dates only when both are set and the playing season has started.
- Keep announcement/countdown automation deferred.

Implementation confirmation:

```text
04-implementation-confirmations/2026-06-29-lmspro-remediation-slice-r1-a-playing-season-date-fields-and-season-admin-display-confirmation.md
```

Review confirmation:

```text
05-review-and-test/2026-06-29-lmspro-remediation-slice-r1-a-r1-playing-season-date-boundaries-review.md
```

Review notes:

- Dev database initially lacked the new migration, causing the Seasons list to appear empty.
- The migration was applied with `npx prisma migrate deploy`.
- Playing-season dates initially displayed one day prior in UK summer time.
- DateInput values are now normalised to UTC midnight immediately on selection and on save.
- Final browser re-test should confirm exact selected dates display after re-saving.

Live promotion:

```text
05-review-and-test/2026-06-29-lmspro-r1-a-and-branding-live-promotion-confirmation.md
```

Promotion target:

```text
main = dev = staging = 682ddb4
```

This promotion also carries the SVG branding upload fix to live.

## Deferred Items

- Dashboard announcement automation from playing-season offsets.
- C2 Club dashboard countdown display.
- C1 dashboard countdown display beyond basic season-admin visibility.
- General key-date automation changes unless explicitly scoped.
- Notification sending or communication automation.
- Attachment authoring for key-date email sequences; reconsider only after R8-A proves the
  reusable ordinary-endpoint attachment sender.

## Do Not Build Yet

Do not implement these until slice planning accepts them:

- automatic dashboard announcements;
- countdown timers on Club dashboards;
- offset-triggered communications;
- season automation rules beyond date storage/display/progress calculation;
- broad key-date architecture changes;
- do not send any attachment-bearing email through Resend batch;
- do not replace or broadly refactor the live no-attachment batch route inside R8-A;
- do not add key-date sequence attachments as an unplanned expansion of R8-A;
- do not represent an attachment job as sent merely because it has been queued.

## Recommended Next Slice

```text
R8-A2 - Attachment Persistence, Drafts And Fail-Closed Preflight (deployed human smoke gate)
```

Goal:

Run and report the accepted R8-A2 deployed human UI smoke script against the configured
private R2 bucket and private ClamAV service. Keep R8-A3 planning closed until the result is
recorded and accepted.

## Fresh Chat Prompt

```text
Proceed with LMSPro / SeasonPro remediation planning from:
isodocs/docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md

Next step:
Review the bounded R8-A2 planning slice:
isodocs/docs/modules/lmspro/03-slice-planning/2026-07-21-lmspro-remediation-slice-r8-a2-attachment-persistence-drafts-and-fail-closed-preflight-planning.md

Goal:
Deploy and smoke-test the technically complete R8-A2 implementation. Confirm exact draft
resource persistence, independent three-upload/10 MB and three-link limits, private R2
readability, private ClamAV clean/infected/unavailable behaviour, explicit C1 responsibility
acknowledgement and the interim attachment-send refusal.

Do not create R8-A3 planning until R8-A2 implementation and technical review are complete and
the business/testing team has reported the required human UI smoke result. Do not broaden the
batch sender, add key-date sequence attachments, change recipient/cohort rules, automatically
resend historic messages, alter season automation or change FUND logic.
```
