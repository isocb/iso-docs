# LMSPro / SeasonPro Roadmap And Slice Control

Date: 2026-06-29
Last updated: 2026-07-22
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
origin/dev = origin/staging = 6c5aaa56ffa33ab3bcc2102ff7da6cdc84fda4a4
origin/main = ea4e6193
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
R8-A1 is complete. The technically verified R8-A2 broad-file and ClamAV implementation was
superseded before promotion after cost/benefit and risk/benefit review. R8-A2R and its F1
transport correction are deployed to staging and have passed the revised human UI smoke:
three PDF/image/text uploads in private R2, 10 MB cumulative, three separate HTTPS links and
no malware-scanning service. R8-A3 runtime is technically complete and deployed to staging at
application commit `d14a652f`; final test-evidence reconciliation aligns `origin/dev` and
`origin/staging` at test-only commit `99164ddd`. PLAT-RUNTIME-01 and R8-A3-F1 are closed at
their staging gates.
A fresh one-recipient large-PDF Email and a three-attachment/three-link Email queued, processed,
reached the correct terminal UI state and arrived with intact resources after the staging cron was
corrected to the exact singular private bucket name. A four-primary-recipient send and the final
no-attachment regression also passed. The targeted CC/BCC contract checks and `Duplicate to Draft`
send-again smoke now pass. The deterministic no-network 300-recipient proof also passes across two
150-recipient cycles with no more than three mocked provider starts per rolling second. R8-A3 is
accepted at the staging boundary. The production risk assessment is complete: R8-A3 is ready in
principle, but the current combined `staging` to `main` bundle is HOLD/NOT AUTHORISED because it
also contains unresolved Commerce/FUND/Platform production gates and 17 migrations.
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
Accepted 2026-07-21; R8-A1 completed; R8-A2 superseded before promotion in its broad-file/ClamAV portions; R8-A2R-F1 complete; R8-A3 technical implementation, staging deployment, human transport checks and deterministic no-network 300-recipient pacing proof pass; R8-A3 is staging-accepted and production-ready in principle. The current combined staging bundle is HOLD/NOT AUTHORISED pending cross-lane and live-migration gates.
```

Implementation baselines:

```text
application: new dedicated R8-A3 branch from origin/dev at 6c5aaa56ffa33ab3bcc2102ff7da6cdc84fda4a4
documentation: origin/main at 62aca8057d3f0560a8764613e644a247fb2ccba4 before this gate update
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

R8-A2R narrows managed uploads to PDF, JPEG/JPG, PNG, GIF, WebP, UTF-8 TXT and CSV. Office,
ZIP/archive, executable and script formats are refused. SeasonPro validates type, size,
private R2 readability and checksum but does not malware-scan uploaded files. C1 may also
provide up to three labelled HTTPS shared-document links, which SeasonPro does not fetch,
copy, scan or permission-test. The UI must state and record that the C1 SeasonPro
Administrator is responsible for file/link integrity, suitability and sharing permissions.
Links alone do not select the attachment job and continue through the proven batch route.

R8-A must support approximately 300 attachment recipients through a rate-controlled,
resumable processor in the existing Render cron. It must not hold the C1 browser request
open while sending all messages or require a new paid background-worker service.

The accepted runtime contract is:

```text
ad-hoc email without attachments
-> existing immediate Resend batch route

scheduled/key-date work
-> existing cron processors, checked on a nominal one-minute schedule

attachment-bearing ad-hoc email
-> durable delivery job
-> existing cron, after current processors
-> at most 150 recipients per run at three ordinary requests per second
-> approximately two to three minutes for a representative 300-recipient job
```

CC/BCC is permitted only when the attachment job has one primary recipient. An attachment
job with multiple primary recipients and any CC/BCC address fails closed before queueing so
each copied address cannot receive hundreds of duplicate messages.

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
Runtime commit `d14a652f` and final test-evidence commit `99164ddd` are aligned through
`origin/dev` and `origin/staging`. The accepted
migration-before-code deployment, Platform request-body smoke and R8-A3-F1 environment retest are
complete. The staging cron now uses the exact private bucket name
`seasonpro-email-attachment-staging`. Multi-resource, links, duplicate-prevention, status/log and
final no-attachment, targeted CC/BCC and `Duplicate to Draft` manual send-again checks now pass.
The deterministic mocked-provider 300-recipient pacing test also passes without any real Email or
network request. Treat intentional send-again as a new immutable Email/delivery identity, not as
permission to weaken duplicate-job prevention. Test and documentation reconciliation is complete.
The controlled production assessment records R8-A3 as ready in principle but the exact current
staging bundle as HOLD/NOT AUTHORISED because it spans 38 commits, 208 changed files and 17
Commerce/FUND/LMSPro migrations with unresolved sibling-lane/live-data gates.

R8-A3 planning:

`docs/modules/lmspro/03-slice-planning/2026-07-22-lmspro-remediation-slice-r8-a3-durable-attachment-delivery-job-rate-limiter-and-retry-planning.md`

R8-A3 implementation and review evidence:

```text
04-implementation-confirmations/2026-07-22-lmspro-remediation-slice-r8-a3-durable-attachment-delivery-job-rate-limiter-and-retry-confirmation.md
05-review-and-test/2026-07-22-lmspro-remediation-slice-r8-a3-durable-attachment-delivery-job-rate-limiter-and-retry-review-and-test.md
```
```

R8-A2 planning:

```text
03-slice-planning/2026-07-21-lmspro-remediation-slice-r8-a2-attachment-persistence-drafts-and-fail-closed-preflight-planning.md
```

The prior dedicated private ClamAV direction is withdrawn and must not be configured. The
three-link cap remains independent from the three-upload/10 MB allowance. R8-A2R preserves
private R2 and fail-closed evidence while narrowing file types and explicitly disclosing
that uploaded files are not malware-scanned.

R8-A2R corrective planning:

```text
03-slice-planning/2026-07-21-lmspro-remediation-slice-r8-a2r-bounded-unscanned-attachment-policy-correction-planning.md
```

R8-A2R completion evidence:

```text
implementation:
04-implementation-confirmations/2026-07-21-lmspro-remediation-slice-r8-a2r-bounded-unscanned-attachment-policy-correction-confirmation.md

review/test:
05-review-and-test/2026-07-21-lmspro-remediation-slice-r8-a2r-bounded-unscanned-attachment-policy-correction-review-and-test.md
```

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

## Registered Consolidated Email Remediation CR

The following planning-only CR input is now registered:

`docs/modules/lmspro/01-cr-inputs/2026-07-22-lmspro-consolidated-email-integrity-club-visibility-and-remedial-work-cr-input.md`

It captures the first of five expected email-remediation concerns: explicit many-to-many
Email-to-Club visibility, audience-context preservation, shared delivery-result reconciliation
and cursor-based unique Email history with bounded scroll/load-more behaviour.

R8-A staging acceptance satisfies the CR's prior capture prerequisite. The CR is eligible for
later triage but has no executable slice, does not infer the four reserved business concerns and
does not supersede the current production HOLD decision.

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

### Communications Wishlist - Links-First, Opt-In Uploaded Attachments

Wishlist identifier:

```text
LMS-W-COMMS-01
```

Future refinement should make external HTTPS document links the default supporting-document
mode while uploaded email attachments are disabled and hidden by default.

The intended future policy is:

```text
default C1 organisation policy
-> up to three labelled HTTPS external links remain available
-> uploaded-attachment control is hidden and server-side upload/send authority is disabled

authorised C1 Owner/Administrator explicitly enables uploaded attachments
-> display the current formal risk and responsibility notice
-> require affirmative organisation-level acceptance
-> record organisation, actor, timestamp and policy version
-> expose the uploaded-attachment control for authorised communications users

each attachment-bearing email
-> retain the separate per-email acknowledgement
-> record actor, timestamp, notice version and exact attachment-set fingerprint
```

This is an organisation policy, not merely an individual user-interface preference. The
server must enforce it independently of whether the control is visible in the browser.

The later bounded planning slice should preserve:

- the R8-A2R narrow PDF/image/text allowlist;
- strict extension, claimed MIME and detected-content agreement;
- private R2 storage and no public object URL;
- maximum three uploaded files and 10 MB cumulative content;
- maximum three separate HTTPS links;
- no server-side preview, rendering, extraction or parsing beyond bounded type validation;
- immutable checksum and audit evidence; and
- explicit wording that SeasonPro does not malware-scan uploads or verify external content.

It should also define:

- the exact C1 role authorised to enable or revoke uploaded attachments;
- whether enablement applies to the whole C1 organisation or may be further scoped;
- reacceptance when the formal notice or security policy materially changes;
- revocation behaviour for existing editable drafts containing attachments;
- immutable treatment of historic sent-email evidence;
- independent enable/disable controls for external links if later required; and
- audit and operator visibility for enablement, reacceptance and revocation.

This wishlist item is not part of R8-A2R or R8-A3 and must not delay the current silent-loss
remediation. It requires a future CR/triage/bounded planning cycle before implementation.

### Communications Wishlist - Recipient Controls And Send-Again Discoverability

Wishlist identifier:

```text
LMS-W-COMMS-02
```

The compose modal currently places the collapsed `Add CC/BCC` control beneath Subject on the
Compose tab. The control exists and the accepted server contract remains valid, but human testing
showed that a competent C1 tester looked for copy recipients in the Recipients tab and concluded
that CC/BCC had been removed. A future UI refinement should move or clearly surface CC/BCC in the
Recipients tab while preserving:

- one-primary-recipient CC/BCC support;
- fail-closed refusal of CC/BCC with multiple primary recipients; and
- the current server-side enforcement independent of UI placement.

The three-dot menu's `Duplicate to Draft` action is the accepted safe manual send-again route. It
creates a new Email UUID and delivery/idempotency boundary, copies validated resources to new
private objects, permits recipient review or replacement and preserves the original sent record.
A later UI refinement may label or explain this as `Send Again (creates a new draft)` so the
historic manual resend capability is discoverable without introducing direct re-delivery of an
already accepted immutable Email.

This is a non-blocking presentation refinement. It must not delay R8-A3 production readiness once
the existing CC/BCC and Duplicate-to-Draft contracts pass their targeted smoke tests.

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

## Recommended Next Controlled Action

```text
Combined release-gate decision after the R8-A3 production HOLD
```

Goal:

R8-A3 is accepted at staging and production-ready in principle. Test/lifecycle evidence is
committed and `origin/dev`/`origin/staging` are reconciled at `99164ddd`. The production assessment
found that an ordinary `staging` to `main` promotion would also release 38 commits and 17
Commerce/FUND/LMSPro migrations. Choose either completion of the full combined release gate or a
newly planned selective LMSPro release. No live promotion or migration is currently authorised.

## Fresh Chat Prompt

```text
Proceed with LMSPro / SeasonPro remediation planning from:
isodocs/docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md

Next step:
Review the R8-A3 technical and human-test handoff:
isodocs/docs/modules/lmspro/05-review-and-test/2026-07-22-lmspro-remediation-slice-r8-a3-durable-attachment-delivery-job-rate-limiter-and-retry-review-and-test.md

Goal:
Read the completed production assessment:
isodocs/docs/00-roadmap-control/2026-07-23-lmspro-r8-a3-and-combined-staging-bundle-production-risk-assessment-and-promotion-decision.md

Choose and explicitly authorise either the full combined release gate or a newly planned
selective LMSPro release. For the full bundle, first close the outstanding FUND/Commerce/Platform
gates and run the read-only live migration preflights. For a selective release, require a fresh
dependency, migration, staging and lifecycle plan.

Do not promote current staging or run its migrations while the production assessment is HOLD.
Do not broaden the batch sender, add key-date sequence attachments, change
recipient/cohort rules, automatically resend historic messages, alter season automation or
change FUND logic.
```
