# LMSPro / SeasonPro Roadmap And Slice Control

Date: 2026-06-29
Last updated: 2026-07-27
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
dev = origin/dev = staging = origin/staging = df40f45c
main = origin/main = b9287ffa
```

`b9287ffa` remains the completed controlled production release containing R8-A3 and its
Platform/runtime dependencies. Dev/staging subsequently advanced to `df40f45c` through the
separately completed `PLAT-ASSURE-03` security remediation and exact staging human gate.
No R9 application or data change is present in those baselines.

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
R8-A is implemented, technically accepted and deployed through staging and live.
R8-A1 is complete. The technically verified R8-A2 broad-file and ClamAV implementation was
superseded before promotion after cost/benefit and risk/benefit review. R8-A2R and its F1
transport correction are deployed through live and passed the revised human UI smoke:
three PDF/image/text uploads in private R2, 10 MB cumulative, three separate HTTPS links and
no malware-scanning service. R8-A3 runtime is retained at application ancestor `d14a652f`;
test-only evidence was reconciled at `99164ddd`; and the complete controlled application
release is aligned through dev, staging and main at `b9287ffa`. PLAT-RUNTIME-01 and R8-A3-F1
are closed.
A fresh one-recipient large-PDF Email and a three-attachment/three-link Email queued, processed,
reached the correct terminal UI state and arrived with intact resources after the staging cron was
corrected to the exact singular private bucket name. A four-primary-recipient send and the final
no-attachment regression also passed. The targeted CC/BCC contract checks and `Duplicate to Draft`
send-again smoke now pass. The deterministic no-network 300-recipient proof also passes across two
150-recipient cycles with no more than three mocked provider starts per rolling second.
Following promotion, matching R2 credentials were applied to each environment's separate web
and cron consumers; fresh attachment delivery passes in staging and MAIN. The A4 operational
state and A5 deployed-provider/regression exit evidence were satisfied within the completed
R8-A3 lifecycle and require no separate implementation slice.
```

The completed urgent communications-integrity lane was:

```text
R8-A - Attachment-Aware Email Delivery Route And Fail-Closed Evidence
```

R8-A has completed its planning, implementation, review, staging and live gates. Later
email-remediation observations belong to the complete planning-only consolidated CR and do
not reopen R8-A.

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
Accepted 2026-07-21; R8-A1 completed; R8-A2 superseded before promotion in its
broad-file/ClamAV portions; R8-A2R-F1 complete; R8-A3 technical implementation, staging
and live deployment, human transport checks and deterministic no-network 300-recipient
pacing proof pass. Fresh attachment delivery passes in both staging and MAIN after each
environment's web and cron consumers were aligned to the same current R2 credential set.
R8-A3 and the parent R8-A lane are complete.
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
Runtime commit `d14a652f` and final test-evidence commit `99164ddd` are retained ancestors
of the controlled release aligned through `origin/dev`, `origin/staging` and `origin/main`
at `b9287ffa`. The accepted migration-before-code deployment, Platform request-body smoke,
R8-A3-F1 environment retest and live promotion are complete. Multi-resource, links,
duplicate-prevention, status/log, final no-attachment, targeted CC/BCC and `Duplicate to
Draft` checks pass. The deterministic mocked-provider 300-recipient pacing test also passes
without any real Email or network request. Treat intentional send-again as a new immutable
Email/delivery identity, not as permission to weaken duplicate-job prevention.

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

It now records the complete four-item remediation programme:

1. Club dashboard Email visibility and history integrity;
2. attachment dropzone click-to-browse regression;
3. Club admission, Current participation and waiting-list alignment; and
4. responsive Team status and waiting-list-position visibility.

The formerly expected fifth item, C1 League dashboard reorganisation, is standalone work and
requires its own CR lifecycle. Formal triage accepts the four-item CR as coordinated programme
`R9`, with separately bounded children in the requested order:

1. `R9-A` — Item 3, Club admission and seasonal participation;
2. `R9-B` — Item 1, Club Email visibility and history integrity;
3. `R9-C` — Item 4, responsive Team status visibility; and
4. `R9-D` — Item 2, attachment click-to-browse restoration.

`R9-A0` was the selected LMSPro planning/evidence boundary. It is a read-only writer,
consumer and live-state inventory. It preserves Item 3's accepted distinction: validated
SeasonPro import, the linked two-stage form after email validation and C1 approval, and
authorised direct C1 creation are the three valid Registered/admission routes;
`ClubStatus.APPROVED` represents Current only with a qualifying Current/allocated Team; a
Club with no qualifying Team is Club Waiting List while its unallocated Teams remain
distinct. An actual automatic Club Current/Waiting List transition may use the existing
Notification Manager: user-triggered CRUD retains its on-CRUD notification control and
automatically derived behaviour falls back to the manager's master/per-event switches,
default-or-custom content and recipient routing. No application implementation, schema,
migration, reconciliation, live-data mutation, notification sending or deployment is
authorised by R9-A0.

The exact-commit static writer/consumer inventory is now complete at application commit
`df40f45c`. It confirms the three routes and identifies overloaded status writers and
consumers, uneven admission evidence, Current/unallocated Team paths, access coupling,
cross-season cohort risks and season-clone/roll-forward dependencies.

The first authorised STAGING snapshot fingerprint `6ee30baaf29f` stopped before Q1 because
its tenant/season and migration ancestry did not match. The corrected STAGING target
fingerprint `d18b9abe1450` and corrected season subsequently passed every precondition at
application commit `df40f45c`. Q1-Q15 completed in an explicitly read-only transaction and
ended with `ROLLBACK`; only tenant/season-scoped aggregate evidence was retained.

The combined evidence identifies seven Current/unallocated Teams, nine Approved Clubs with
no qualifying Team, 55 Clubs without detectable accepted-route evidence, 22 Clubs without a
fully authoritative active primary C2, and a 59 raw-Approved versus zero evidence-derived
Current cohort delta. All 400 scoped Team-to-Club/age-group relations are valid and all 40
Team Waiting List records have detected authorised-decision evidence. R9-A0 is
evidence-complete and was formally accepted for successor planning at controlling IsoDocs
commit `c7667754d42f2fb6ca115e3c2dbf9c6c4154cc4c`; no automatic classification, repair or
successor implementation slice is authorised by that acceptance.

The control owner subsequently attested that the 55 evidence-free Clubs are the pre-1 June
2026 Derby JFL legacy Knack import cohort. This resolves their business explanation for
planning but remains distinct from row-level automated provenance. Wishlist item
`LMS-W-IMPORT-01` registers the future import-evidence capability.

R9-A1 is accepted as one `Admission Evidence And Derived Participation Compatibility`
application-remediation slice on one branch. It combines the previously proposed A1A
through A1E application concerns. The next exact control may commence its additive
implementation, automated tests, implementation confirmation, verified STAGING snapshot,
notifications-off STAGING deployment and focused review/human smoke lifecycle. Existing-data
reconciliation remains one separately approved R9-A2 execution after STAGING dry-run, and
cleanup is deferred indefinitely unless later evidence makes it necessary. R9-A1 has not
commenced and R9-A2 execution is not authorised.

The legacy-attestation representation is now accepted: R9-A1 may add capability for one
`LEGACY_ATTESTED_IMPORT` admission-evidence row per verified Club linked to one bounded
attestation/reconciliation batch. It must preserve that automated historic source evidence
is unavailable and must not fabricate an import job or unsupported provenance. R9-A1 does
not insert these rows. The R9-A2 dry-run must show the exact proposed membership and counts,
and reconciliation execution remains separately controlled.

Planning refinement:

`docs/modules/lmspro/01-cr-inputs/2026-07-27-lmspro-consolidated-four-item-remediation-planning-refinement.md`

Formal triage:

`docs/modules/lmspro/02-triage/2026-07-27-lmspro-r9-consolidated-four-item-remediation-triage.md`

Selected R9-A0 plan:

`docs/modules/lmspro/03-slice-planning/2026-07-27-lmspro-remediation-slice-r9-a0-club-participation-writer-consumer-and-live-state-inventory-planning.md`

Accepted R9-A1 plan:

`docs/modules/lmspro/03-slice-planning/2026-07-28-lmspro-remediation-slice-r9-a1-admission-evidence-and-derived-participation-compatibility-planning.md`

Static evidence:

`docs/modules/lmspro/05-review-and-test/2026-07-27-lmspro-r9-a0-static-writer-consumer-and-live-state-inventory-evidence.md`

Executed bounded query pack:

`docs/modules/lmspro/05-review-and-test/2026-07-27-lmspro-r9-a0-bounded-read-only-live-state-query-pack.md`

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
- Notification sending or communication automation outside a separately accepted lifecycle.
- Attachment authoring for key-date email sequences; reconsider only after R8-A proves the
  reusable ordinary-endpoint attachment sender.

### User Management Wishlist - Unified Provisioning And Repairable Unassigned Users

Wishlist identifier:

```text
LMS-W-USERS-01
```

Platform parent/refinement identifier:

```text
PLAT-REFINE-02
```

An investigation on exact application dev/staging baseline `df40f45c` confirmed that P1
and C1 user creation currently produce different records:

- P1 correctly assigns the selected `organizationId`, but creates a Core tenant user with
  legacy `PENDING` status and no LMSPro `ModuleRole`;
- the authenticated user consequently receives the handled `No LMSPro Access` outcome;
- C1 User Management defaults to active users and divides visible rows into League and
  Club scopes, so a status-pending or scope-`NONE` partial user is not repairable there;
- C1 creation safely detects the globally existing email but returns a conflict rather
  than completing the compatible same-tenant record; and
- creating through C1 succeeds because that path creates an active user and applies the
  configured scoped LMSPro role.

The LMSPro consumer outcome should:

1. When P1 intends to create an LMSPro user, require a valid LMSPro role and any required
   club affiliation, or explicitly create an `Unassigned` user that remains visible and
   repairable.
2. Add an `Unassigned` table/tab for same-tenant users with no valid LMSPro scope,
   including clear status, role and affiliation diagnostics.
3. Consume the shared Platform transactional provisioning service rather than creating a
   second account lifecycle inside LMSPro.
4. Support safe same-tenant partial-account completion while preserving fail-closed
   cross-tenant email conflicts; LMSPro must never silently move a user between tenants.
5. Preserve role-assignment permissions, current-season club affiliation and audit
   evidence when completing or repairing a user.
6. Add integration tests covering P1 creation -> C1 visibility -> LMSPro login,
   role-required and explicit-unassigned outcomes, partial-account completion,
   cross-tenant conflict and the Platform-owned authentication-status matrix.
7. Require an exact human P1/C1 smoke schedule before promotion, including an unassigned
   recovery path and a fully assigned successful-login path.

The Platform lane owns the reusable provisioning transaction, account-status and
authentication contract, global email/tenant safety, shared audit boundary and read-only
partial-account inventory. LMSPro owns module-role selection/defaults, `Unassigned`
visibility and repair UX, affiliation behaviour and module acceptance evidence.

The prerequisite data audit must be read-only and identify users in LMSPro-enabled
organisations with empty, invalid or orphaned `lmsproRoleIds`, including their account
status and affiliation. No bulk repair, activation, relinking or deletion is authorised by
this wishlist entry.

Temporary operating rule:

```text
Until the controlled Platform and LMSPro remediation is reviewed and promoted,
create LMSPro users through C1 LMSPro User Management.
```

Existing partial accounts should be reviewed and repaired in place under explicit
authority rather than routinely deleted and recreated.

This is a registered high-priority wishlist/finding only. It requires CR capture, formal
cross-lane triage, a Platform parent/contract slice and separately bounded LMSPro consumer
planning before implementation.

### Import Wishlist - Durable Club And Team Provenance Evidence

Wishlist identifier:

```text
LMS-W-IMPORT-01
```

R9-A0 source evidence shows that the current Club and Team import paths do not always leave
enough durable evidence to identify the accepted instantiation route later. The bounded
STAGING inventory found 55 Clubs without detectable import, approved-form or direct-C1
evidence. The control owner subsequently attested that the pre-1 June 2026 Derby JFL Club
cohort was imported personally from the legacy Knack system and that later applicant Clubs
used the new application route. That attestation is valid planning evidence, but it must not
be misrepresented as automated evidence already stored against each Club.

A future bounded import-provenance lifecycle should make every successful Club and Team
import automatically retain:

- the fact that it was created or matched through an authorised import;
- the import job, source-system label, tenant, season, operator and completion time;
- the original source identifier where one exists;
- validation outcome and any warnings or incomplete mappings;
- whether each source row created, matched, updated, skipped or rejected a record;
- the resulting Club/Team and age-group/division/AGG mapping outcome; and
- immutable audit evidence sufficient to trace the imported record back to the import
  decision without retaining unnecessary source personal data.

The application should expose a system-generated provenance classification such as:

```text
Imported and validated — automated source evidence available
```

The facility should also provide:

1. tenant/season-scoped aggregate import evidence and exception reporting;
2. a controlled review path for incomplete or conflicting mappings;
3. genuinely idempotent same-tenant/same-season retry behaviour;
4. fail-closed handling of cross-tenant or cross-season matches;
5. preservation of provenance when a record is edited, allocated or rolled forward; and
6. integration tests for Club/Team creation, matching, rejection, retry, partial failure and
   evidence retention.

Import provenance is registration/admission evidence. It must not itself classify a Club or
Team as Current. Club Current participation continues to require at least one qualifying
same-tenant, same-season Current Team with valid allocation, and imported Teams must not
default silently into Current when their allocation is absent or invalid.

Legacy records may use a separately authorised classification such as:

```text
Control-owner-attested legacy import — automated source evidence unavailable
```

That classification must preserve the difference between human attestation and automated
import evidence. It must not fabricate an import job, infer production equivalence from
STAGING, alter status or trigger reconciliation.

This is a registered wishlist item linked to the R9-A0 evidence. It requires CR capture,
formal triage and separately bounded planning before any application, schema, migration or
data work. It is not an accepted R9-A implementation slice.

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
Commence the accepted R9-A1 implementation and STAGING validation boundary
```

Goal:

R9-A0 evidence is accepted at controlling IsoDocs commit
`c7667754d42f2fb6ca115e3c2dbf9c6c4154cc4c`, and the one-branch R9-A1 application plan is
accepted. The next exact control may implement R9-A1, pass automated tests, create the
implementation confirmation, verify a STAGING snapshot, apply the additive migration,
deploy to STAGING with both new notification events off and execute the focused review and
human smoke lifecycle. The UI smoke covers the linked two-stage registration/approval route
and direct authorised C1 creation; import is covered by automated integration tests and is
excluded from UI human smoke.

The lifecycle ends with an evidenced STAGING verdict. The R9-A2 dry-run may inform the
separate reconciliation approval, but existing-data mutation remains prohibited until that
approval. Do not promote to `main` or live, query or mutate production, or enable production
notifications. This LMSPro lane action does not override the root roadmap's cross-lane
execution authority.

## Fresh Chat Prompt

```text
Proceed with the controlled LMSPro / SeasonPro R9-A1 implementation from:
isodocs/docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md

Next step:
Use the accepted R9-A1 planning boundary:
isodocs/docs/modules/lmspro/03-slice-planning/2026-07-28-lmspro-remediation-slice-r9-a1-admission-evidence-and-derived-participation-compatibility-planning.md

Before implementation, verify that the accepted R9-A1 plan and reconciled roadmap are
committed in IsoDocs and record that exact controlling commit. Stop if the documents are
uncommitted or differ from the accepted boundary.

Application starting baseline:
df40f45cda955ef00e8f790de89a476c2463a629

Create one dedicated R9-A1 feature branch from that exact baseline. Do not implement on
`main`, `staging` or a production worktree.

Goal:
Commence the accepted one-branch R9-A1 application-remediation slice. Implement the
additive admission evidence, derived participation compatibility, prospective writer and
consumer alignment, and the two safely disabled Notification Manager transition events.
Pass the required automated tests and create the implementation-confirmation record.

Before deployment, create the review/test record with the focused human UI smoke schedule.
Use the exact lifecycle records required by Section 13.1 of the accepted plan:

- `docs/modules/lmspro/04-implementation-confirmations/2026-07-28-lmspro-remediation-slice-r9-a1-admission-evidence-and-derived-participation-compatibility-confirmation.md`
- `docs/modules/lmspro/05-review-and-test/2026-07-28-lmspro-remediation-slice-r9-a1-admission-evidence-and-derived-participation-compatibility-review-and-staging-smoke-test.md`

Create and verify the STAGING database snapshot, apply the additive migration and deploy the
exact R9-A1 commit to STAGING with both new events off. Execute and record human C1/C2 UI
smoke for exactly these two Club-instantiation routes:

1. the linked two-stage registration form after email validation and authorised C1
   approval; and
2. deliberate direct Club creation by an authorised C1 tenant user.

Do not perform the import route through the UI; retain it as mandatory automated integration
coverage. After the first smoke pass, run only the tenant/season-bounded R9-A2 reconciliation
dry-run and stop for explicit review and execution approval.

This is a STAGING-only lifecycle. Do not query or mutate production, promote to `main` or
live, enable production notifications, or execute R9-A2 reconciliation. Stop with the
implementation confirmation, completed STAGING review/smoke record, dry-run evidence and
an explicit R9-A1 STAGING implementation/smoke verdict. This is not a reconciliation,
promotion or production verdict.
```
