# LMSPro / SeasonPro Roadmap And Slice Control

Date: 2026-06-29
Last updated: 2026-08-06
Module: LMSPro / SeasonPro
Control status: Active authoritative LMSPro / SeasonPro child roadmap and delivery-cycle control

Parent portfolio control:

`docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`

## 0. Authoritative CR Inventory And Current LMSPro Disposition — 2026-08-06

This file is confirmed as the one authoritative LMSPro / SeasonPro child roadmap. The root
Platform/module roadmap owns the one serial cross-lane `Now` and `Next`. CR inputs, triage,
plans and historic lifecycle records do not independently select work.

Every LMSPro CR input must be registered in this table in the same documentation change
that creates the CR. Registration is traceability, not acceptance or implementation
authority. Later disposition changes must update the existing row.

| Source CR | Current disposition | Roadmap treatment |
| --- | --- | --- |
| [`2026-07-02-lmspro-cr-club-official-removal-access-lifecycle-input.md`](../01-cr-inputs/2026-07-02-lmspro-cr-club-official-removal-access-lifecycle-input.md) | R3 planning completed; no implementation confirmation or review record was located for an executable R3 delivery | Historical planned policy; parked unless a fresh fault or accepted implementation need reopens it |
| [`2026-07-06-lmspro-cr-communications-email-announcements-remediation-input.md`](../01-cr-inputs/2026-07-06-lmspro-cr-communications-email-announcements-remediation-input.md) | R4-A/R4-B implemented with local browser-smoke evidence | Completed at the recorded local evidence boundary; later communications CRs own subsequent changes |
| [`2026-07-06-lmspro-cr-dynamic-age-group-division-role-permissions-routing-input.md`](../01-cr-inputs/2026-07-06-lmspro-cr-dynamic-age-group-division-role-permissions-routing-input.md) | R5-A/R5-B implemented and reviewed; authenticated browser smoke passed, with R5-A routing confidence closed by R5-B | Completed historical remediation |
| [`2026-07-06-lmspro-cr-playing-day-configuration-multi-day-league-architecture-input.md`](../01-cr-inputs/2026-07-06-lmspro-cr-playing-day-configuration-multi-day-league-architecture-input.md) | R6 planning/architecture outcome only | Deferred architecture; no executable implementation selected |
| [`2026-07-07-lmspro-cr-small-remedial-ui-and-count-polish-input.md`](../01-cr-inputs/2026-07-07-lmspro-cr-small-remedial-ui-and-count-polish-input.md) | R7-A implemented, reviewed, browser-smoked and promoted through live | Completed and closed |
| [`2026-07-07-lmspro-cr-tenant-scoped-role-catalogue-legacy-template-pruning-input.md`](../01-cr-inputs/2026-07-07-lmspro-cr-tenant-scoped-role-catalogue-legacy-template-pruning-input.md) | R5-C implemented locally; its review record still says `Ready for browser smoke` | Waiting for evidence reconciliation; not portfolio `Now` and no completion beyond the recorded boundary is claimed |
| [`2026-07-08-lmspro-cr-club-player-management.md`](../01-cr-inputs/2026-07-08-lmspro-cr-club-player-management.md) | PM1-A planning exists but is not accepted for implementation | Parked feature candidate; safeguarding and Team Manager access remain preconditions |
| [`2026-07-20-lmspro-cr-attachment-aware-email-delivery-and-fail-closed-evidence-remediation-input.md`](../01-cr-inputs/2026-07-20-lmspro-cr-attachment-aware-email-delivery-and-fail-closed-evidence-remediation-input.md) | R8-A and its bounded corrections completed through staging/live and human transport evidence | Completed and closed; later operating-envelope changes require a new lifecycle |
| [`2026-07-22-lmspro-consolidated-email-integrity-club-visibility-and-remedial-work-cr-input.md`](../01-cr-inputs/2026-07-22-lmspro-consolidated-email-integrity-club-visibility-and-remedial-work-cr-input.md) | Accepted through consolidated R9 triage and delivered by R9-A through R9-D; production promotion/evidence complete | Completed coordinated programme input |
| [`2026-07-27-lmspro-consolidated-four-item-remediation-planning-refinement.md`](../01-cr-inputs/2026-07-27-lmspro-consolidated-four-item-remediation-planning-refinement.md) | Consumed by the same R9 programme and its bounded plans | Completed/superseded as active planning by the delivered R9 lifecycle; retained as decision provenance |
| [`2026-07-30-lmspro-responsive-c1-club-management-cr-input.md`](../01-cr-inputs/2026-07-30-lmspro-responsive-c1-club-management-cr-input.md) | R10-A implemented, staging-smoked, included by ancestry in live application `7154937` and reported totally green in the control-owner production smoke | Completed and closed on 2026-08-05; no remaining resumption action |
| [`2026-08-05-lmspro-500-recipient-email-operating-envelope-refinement.md`](../01-cr-inputs/2026-08-05-lmspro-500-recipient-email-operating-envelope-refinement.md) | Captured planning input; awaiting formal triage | Registered standard communications/capacity candidate; no limit change, implementation or displacement of `Now`/`Next` authorised |
| [`CR-Fix-2026-08-05-lmspro-cohort-email-draft-persistence-and-audience-selection.md`](../01-cr-inputs/CR-Fix-2026-08-05-lmspro-cohort-email-draft-persistence-and-audience-selection.md) | F1 PASS; F2 superseded; F2.1/F2.2 delivered in `83356030` ancestry; F3 implemented/reviewed at `72c02d92`, aligned across dev/staging, both Security Scans and public staging health PASS; no schema/migration; exact Render identification and human staging smoke pending | F3 remains portfolio `Now`; production is blocked pending human evidence and explicit promotion authority |
| [`2026-08-06-lmspro-recipient-tab-responsive-accordion-ui-cr-input.md`](../01-cr-inputs/2026-08-06-lmspro-recipient-tab-responsive-accordion-ui-cr-input.md) | R11-A implemented with corrected combined Division/Age Group recipient-type widget, session disclosure and responsive layout; focused/full tests, type, verification, lint and 131-page build PASS; authenticated local UI smoke 18/18 and staging smoke all green; exact `83356030` aligned through dev, staging and main; public live health PASS with database connected and RLS 11/11; no schema/API/provider/configuration change | Live branch promotion complete; exact Render live-build identification and focused authenticated production smoke remain before closure; does not displace the current F3/Role Authority `Now`/`Next` |

Current LMSPro portfolio disposition:

```text
NOW  -> LMSPro Email CR-Fix F3 accepted bounded implementation
NEXT -> Platform/SeasonPro Role Authority bounded project
THEN -> Platform Support Ticketing client-readiness project
PARKED -> FUND 1R-F-A at its exact pre-planning boundary
```

The control owner completed the displaced R10-A smoke as totally green. The current root/child
pair is therefore:

```text
NOW  -> LMSPro Email CR-Fix F3 accepted bounded implementation
NEXT -> Platform/SeasonPro Role Authority bounded project
THEN -> Platform Support Ticketing client-readiness project
PARKED -> FUND 1R-F-A bounded planning
```

R10-A is complete and closed. Revised business priority selects F3 as formal root `Now`,
Role Authority as `Next`, and Support Ticketing as the required following project. FUND
`1R-F-A` is preserved at its exact pre-planning boundary until those housekeeping outcomes
are complete.

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

Remedial inputs use the `CR-Fix-` filename/title prefix but remain in `01-cr-inputs` and
the same authoritative inventory. The prefix identifies corrective purpose; it does not
create implementation authority or a separate remedial roadmap.

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
- Creating a CR also updates the Section 0 inventory with an explicit disposition in the
  same documentation change.
- Triage decides whether the CR is accepted, deferred, split, rejected or moved to concept
  control.
- Slice planning defines the exact build boundary, risks, data model implications,
  permissions and review expectations.
- Implementation should not begin until the relevant 03 slice plan is accepted.
- Implementation confirmation records what was actually changed.
- Review/test records browser smoke, scripts, known gaps and promotion confidence.
- This roadmap/control document is updated both at CR capture and at cycle close before the
  next slice begins.

Recommended improvements to the cycle:

- Record branch/environment state in the roadmap before and after promotion.
- Record explicit "Do Not Build" boundaries in each slice.
- Add risk and safeguarding notes whenever minors, personal data, exports or impersonation
  are in scope.
- Keep concept/product strategy documents separate from near-term feature CRs.
- Treat suggested slices in CR inputs as advisory until triage and planning accept them.
- Prefer smaller slices where permission boundaries or sensitive data are involved.
- For `CR-Fix` work, record containment, operational severity, workaround safety, correction
  risk, expedite decision and displaced-work resumption before implementation begins.

## Current App Branch Context

Current app development baseline:

```text
dev
```

Current work should remain on dev/remediation branches until reviewed and explicitly aligned.

Current app alignment:

```text
dev = origin/dev = staging = origin/staging = main = origin/main = 83356030
R11-A staging authenticated smoke = all green
Render live public health = PASS; exact-build identification and authenticated production smoke pending
```

Application `83356030` is the current branch-aligned baseline and includes prior LMSPro,
FUND and Commerce work by ancestry.
The control owner reported the final R10-A production smoke totally green on 2026-08-05.
After all ten F2.1 staging checks passed, the control owner authorised its promotion. F2.2
subsequently passed automated/build gates and all 15 staging human-smoke checks. The control
owner authorised exact `ec7e0cc4`, which was fast-forwarded and pushed through main. Render
live exact-build confirmation remains to be recorded. Exact main Security Scan `31015039314`
is retained as the earlier F2.1 release evidence.

## Current Completed LMSPro Cycle State

Recent LMSPro lanes completed and documented:

- R2 - imported club-user membership and live data repair;
- R3 - club official removal and archived access lifecycle planning;
- R4 - communications, email and announcements remediation;
- R5 - age group/division manager notification routing completed; role-catalogue R5-C is
  implemented locally but its review record still requires browser-smoke reconciliation;
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
through A1E application concerns. Its additive implementation is complete at application
commit `654ec47cb85f710b4fa2055dc8fa28e0a79ed90f`, with exact parent/recovery baseline
`df40f45cda955ef00e8f790de89a476c2463a629`. On 2026-07-29 `dev` and `origin/dev` were
fast-forwarded cleanly to that exact commit, restoring the normal
feature-to-dev-to-STAGING workflow. Exact dev tests, type-check, verification and production
build pass, subject to the recorded pre-existing repository lint debt. The automatic dev
Security Scan is confirmed green by the control owner. The verified recovery-only STAGING
snapshot is recorded, and additive migration
`20260728120000_lmspro_r9_a1_admission_participation` applied successfully at
`2026-07-29T09:29:58Z`. The three new tables are empty, existing scoped status aggregates
are unchanged and no reconciliation or notification occurred. At that implementation checkpoint,
the exact notifications-off STAGING deployment and focused review/human smoke were pending.
Existing-data reconciliation remained one separately approved R9-A2 execution after STAGING
dry-run, and cleanup was deferred indefinitely unless later evidence made it necessary. R9-A2
execution was not yet authorised at that checkpoint.

`origin/staging` subsequently fast-forwarded cleanly from `df40f45c` to exact tested
`origin/dev` commit `654ec47c`. The control owner confirmed Render STAGING `Live` at
displayed commit `654ec47`. Final post-deployment evidence confirms HTTP 200, database
connected, RLS 11/11, the R9-A1 migration finished, unchanged 61/400/8 scoped
Club/Team/Application counts, empty new evidence/outbox tables and both new events safely
default-OFF. The scheduled human smoke was the next controlled action at that checkpoint.

Route A registration, email validation and normal C1 approval subsequently passed in STAGING.
The fixture has one `APPROVED_APPLICATION` evidence row, one active authoritative primary
C2, Club Waiting List participation, one unallocated `NEW_CLUB_PENDING_TEAM` and no
participation-transition outbox row. C2 login/access and participation transitions remain
to test.

Smoke finding `R9-A1-F1` confirms that the Application review modal's separate orange
`Waiting List` button now duplicates normal approval: both accept the Application, provision
C2, record approved-Application evidence and initially place the admitted Club on Club
Waiting List. The redundant action risks divergent audit, review-note and notification
behaviour. Remove the Application-level button and mutation before production promotion;
this does not affect the distinct, deliberately authorised Team Waiting List decision.

Smoke finding `R9-A1-F2` confirms mixed pre-admission authority across Club Applications and
Club Management. A verified Application is `Ready for Review`, while its provisional
`ClubStatus.PENDING` shell is shown and filtered only as `Pending`. That Club row also exposes
a generic approval shortcut which would record the shell as `AUTHORISED_DIRECT_C1` without
reviewing the linked Application. Before production, derive the friendly Club-list
pre-admission label/filter from the linked Application, hide the generic approval shortcut
for linked shells and reject that bypass server-side. Keep `EMAIL_VERIFIED` on the
Application rather than adding it to `ClubStatus`; separately identify any unlinked legacy
Pending Club.

The first pre-deployment attempt published only the dedicated feature branch and stopped
without migration or deployment. Its use of the historic R9-A0 target fingerprint as a
permanent STAGING gate was subsequently corrected. A new read-only preflight against the
current configured target at fingerprint `016aba10adf6` confirms the accepted tenant/season
dataset, exact pre-R9-A1 migration ancestry, 61 Clubs, 400 Teams and 8 Applications, with no
unfinished or unresolved rolled-back migration. The R9-A1 tables are absent and no new
notification-setting row exists. The transaction ended with `ROLLBACK`. The control owner
confirms that a fresh backup snapshot has now been created; its identifier/time and the
automatic dev Security Scan result remain required before migration.

The recovery snapshot is labelled `Snapshot Before Club status update`, was created at
`2026-07-29 07:27:52 +01:00` and has Neon branch ID
`br-gentle-fog-ab8uzsyy`. It is a dormant recovery copy of the current STAGING database,
not a replacement runtime target. Render and the migration continue to use the existing
current STAGING database; no `DATABASE_URL` change is required or authorised.

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

### Club Management UX Wishlist - Visible Cohort Counts

Wishlist identifier:

```text
LMS-W-UX-01
```

R9-A2 post-reconciliation smoke proved that the Club Management status filters return the
correct Current, Club Waiting List and Withdrawn cohorts, but unlike Team Management the page
does not display cohort or total counts. The control owner therefore had to count filtered Club
rows manually to verify the expected 56 Current, seven Club Waiting List, one Withdrawn and 64
total Clubs.

A future bounded presentation refinement should:

- display the total number of Clubs in the current tenant/season;
- display the count for each friendly filter cohort;
- update the visible count immediately when filters or Club participation change;
- use the same named cohort definitions as badges, filters, dashboard summaries and exports;
- make clear whether a count is the whole season or the filtered result; and
- add UI tests proving the displayed counts agree with the underlying tenant/season query.

This is a non-blocking usability and verification improvement. It must not reopen or delay the
completed R9-A1/R9-A2 STAGING result and requires no schema or data reconciliation.

### Club Management UX Wishlist - Consistent Derived Status Presentation

Wishlist identifier:

```text
LMS-W-UX-02
```

Production review identified two inconsistent C1 Club edit surfaces. The Club-list modal uses
the accepted friendly labels `Current (derived)` and `Club Waiting List (derived)`, while the
Club-detail modal retains the older `Approved`/`Pending` choices and omits Club Waiting List.
The server correctly rejects manual changes into either derived participation state, so exposing
them as ordinary editable enum choices is also misleading.

A future bounded presentation correction should:

- show the same friendly derived participation status on both Club surfaces;
- make clear that Current and Club Waiting List follow qualifying Team allocation rather than a
  manual Club decision;
- prevent either modal from presenting a derived state as a normal manual correction;
- retain explicit supported handling for Suspended and Withdrawn overrides;
- define the supported route for removing an override and re-running participation derivation;
- refresh the displayed Club status immediately after a qualifying Team mutation; and
- add UI tests proving the list, detail, badge and filter presentations agree.

This is a non-blocking UI consistency item. It does not reopen the completed R9-A evidence or
production reconciliation and requires no additional data correction.

### Club Management UX Wishlist - Responsive C1 Club Presentation

Wishlist identifier:

```text
LMS-W-UX-03
```

The control owner accepted the responsive Team card/table pattern delivered by R9-C and asked
for the same clear small-screen treatment on the C1 Club Management view.

The next small code-only planning candidate should:

- adapt the C1 Club Management list to the proven compact-card/mobile and full-table/desktop
  pattern;
- retain Club-name sorting, search, filters, totals, derived status meanings and existing
  actions;
- keep complete Club identity and friendly Current, Club Waiting List, Suspended and Withdrawn
  presentation visible without clipping;
- preserve keyboard operation and expose the existing Club detail action with a clear accessible
  name;
- cover mobile, tablet, desktop and 200% zoom without page-wide horizontal scrolling; and
- reuse shared presentation helpers where proportionate.

It must not change Club admission, participation derivation, Team allocation, access, schema,
migrations or data. It is a distinct post-R9 presentation CR/planning slice and was not added to
the already tested `fbab1862` production promotion.

Lifecycle commencement on 2026-07-30:

- `LMS-W-UX-03` was accepted as code-only slice `R10-A`;
- the exact recovery baseline is
  `fbab1862fa8124ae3990cc6a9dcda5f35748e570`;
- source review found no unresolved business decision and no server, schema, migration or data
  requirement;
- the accepted implementation boundary is one responsive C1 Club card, the retained desktop
  table, responsive controls, one matching-results count and focused presentation tests; and
- the control owner authorised local implementation, automated dev validation and exact
  staging promotion before stopping for focused C1 human smoke.

Implementation update:

- exact application candidate `4ecf49f2` implements only the accepted presentation boundary;
- focused tests, 267 full-suite tests, type checking, critical-file verification, changed-file
  lint and the production build pass;
- no schema, migration, database, environment, job or notification change exists; and
- exact dev/staging Security Scan and staging health gates remain before human smoke.

Pre-smoke design correction:

- control-owner review found that the first compact card unnecessarily repeated Edit and Delete
  icon actions below `More details`;
- compact Club cards retain the helpful Notes shortcut above `More details`;
- generic Edit and Delete remain in the dedicated detail/modal workflow and are removed from
  the compact card; and
- the reusable responsive data-display rule is recorded in
  `docs/guides/table-crud-pattern.md`.

The control owner then applied the same rule to the desktop table: its Actions column and small
generic Edit/Delete/Approve targets are removed, the complete row opens Club detail, the Club
name remains the keyboard route and Notes remains the explicit evidence shortcut.

Exact design-corrected candidate: `f374b61a`, a direct child of first candidate `4ecf49f2`.

Promotion evidence:

- local/origin dev and staging are exact `f374b61a`;
- exact dev Security Scan `30521487931` passed;
- exact staging Security Scan `30521622851` passed;
- public staging health is HTTP 200 with database connected and RLS 11/11;
- main remains the unchanged recovery baseline `fbab1862`; and
- Render's displayed exact commit and focused C1 human smoke are the remaining gates.

Human staging and correction update:

- the control owner confirmed every responsive, zoom, search, filter, sort, compact-card and
  desktop-row requirement at `f374b61a`;
- the only partial result was the Club-list Notes shortcut, whose editor did not expose the
  Note Date, Next Action Date and attachment behaviour available from Club detail;
- direct child `cf04d3dc` aligns the shortcut editor with the established Note dates, pinning,
  file/URL attachment, removal and archive contracts;
- focused tests, the full 270-test suite, type checking, changed-production lint and production
  build pass;
- local/origin dev and staging are exact `cf04d3dc`;
- exact dev Security Scan `30523034889` and staging Security Scan `30523036190` pass;
- public staging health remains HTTP 200 with database connected and RLS 11/11; and
- Render's displayed `cf04d3d` confirmation and the focused Notes parity retest are the only
  remaining R10-A staging gates.

Second human staging correction:

- the control owner confirmed `cf04d3d` and passed the complete field, date persistence,
  pinning, attachment, removal, clearing, unpinning and archive schedule;
- the remaining partial result was confined to interaction presentation: small Note-row
  Edit/Archive icons, a short non-sticky modal and a competing Add Note action during edit;
- direct child `cc4b4dc8` makes the complete Note row the pointer/Enter/Space edit target,
  removes those row icons, uses the mandatory sticky Archive/Cancel/Save footer, suppresses Add
  Note during editing and sizes the modal responsively to the viewport;
- no query, mutation, schema, migration, data, environment or business rule changes; and
- exact dev Security Scan `30524100833` and staging Security Scan `30524101351` pass;
- public staging health is HTTP 200 with database connected and RLS 11/11.

Final staging result and promotion:

- Render staging displayed `Live at cc4b4dc`;
- the complete Note-row, keyboard, selected-record, action-suppression, responsive-modal,
  sticky-footer, footer-placement and Cancel/Add-mode schedule passed;
- the first `cc4b4dc8` Render build timed out before migration execution on Prisma's advisory
  lock; the candidate has no migration delta and a safe retry-latest-commit completed without
  any lock bypass, ledger repair, URL change or manual database action;
- the control owner accepts R10-A staging evidence and authorises the exact clean fast-forward
  of main from `fbab1862` to `cc4b4dc8`; and
- exact main Security Scan, production deployment health and focused read-only live smoke
  remain before lifecycle closure.

Production promotion update:

- local/origin dev, staging and main are exact
  `cc4b4dc8332f0bdc994c7c2609d2ece873a74087`;
- main advanced by controlled local `--ff-only` from `fbab1862`;
- exact main Security Scan `30527463001` passes;
- public production health is HTTP 200 with database connected and RLS 11/11;
- no migration, schema, database, environment or data action occurred; and
- Render's displayed exact commit plus focused read-only production smoke remain before R10-A
  closure.

Controlling records:

1. `docs/modules/lmspro/01-cr-inputs/2026-07-30-lmspro-responsive-c1-club-management-cr-input.md`;
2. `docs/modules/lmspro/02-triage/2026-07-30-lmspro-r10-a-responsive-c1-club-management-triage.md`;
3. `docs/modules/lmspro/03-slice-planning/2026-07-30-lmspro-remediation-slice-r10-a-responsive-c1-club-management-planning.md`.
4. `docs/modules/lmspro/04-implementation-confirmations/2026-07-30-lmspro-remediation-slice-r10-a-responsive-c1-club-management-confirmation.md`.
5. `docs/modules/lmspro/05-review-and-test/2026-07-30-lmspro-remediation-slice-r10-a-responsive-c1-club-management-review-and-staging-smoke-test.md`.

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
Complete the accepted Email F3 bounded implementation through staging human smoke and the
explicit production gate. Then open Role Authority as the separately bounded root `Next`.
```

Goal:

R9-A is complete in production at exact application commit
`15559f1275d7f8ae3990cc6a9dcda5f35748e570`. R9-A1 promotion, additive migrations, Security
Scan, health and initial live smoke pass. The separately approved R9-A2 combined reconciliation
recorded 54 attested legacy-import and nine deterministic approved-Application evidence rows,
changed nine Clubs to Club Waiting List, suppressed every transition notification and changed no
Team, allocation, official, user or access record. Independent verification, a repeat no-op
dry-run and focused post-reconciliation C1/C2 smoke all pass.

The remaining three accepted programme items were reviewed in one proportionate administrative
planning boundary and are now implemented locally:

`docs/modules/lmspro/03-slice-planning/2026-07-29-lmspro-remediation-slices-r9-b-to-r9-d-combined-planning.md`

Exact application commit `58ef44fd7c91e2c5932f0634bfa803bbfa13dd55` implements the three
independently testable outcomes. The one additive R9-B migration is applied only to the authorised
local development database. R9-C and R9-D remain code-only. Schema validation, 261 runnable tests,
type checking, critical-file verification, production build, dependency audit and the
workflow-pinned bounded Gitleaks scan pass.

The combined implementation confirmation and local review/human schedule are:

- `docs/modules/lmspro/04-implementation-confirmations/2026-07-29-lmspro-remediation-slices-r9-b-to-r9-d-combined-confirmation.md`; and
- `docs/modules/lmspro/05-review-and-test/2026-07-29-lmspro-remediation-slices-r9-b-to-r9-d-combined-local-review-and-smoke-test.md`.

The control owner accepted that historic Emails remain deliberately excluded and authorised the
exact candidate to progress through `dev` to STAGING. The complete human browser schedule will
run once on STAGING as the authoritative runtime proof; duplicate complete local browser smoke
is not required. Production and historic reconciliation remain unauthorised.

Implementation started from exact aligned application commit
`15559f1275d7f8ae3990cc6a9dcda5f35748e570`. Tracked dev, staging and main remain at that parent;
the candidate initially exists only on `fix/lmspro-r9-b-d-remediation`. No STAGING or production
database was queried during implementation. The authorised release sequence must fast-forward
`dev`, pass the exact dev Security Scan, preserve a fresh dormant STAGING database snapshot,
fast-forward STAGING, verify its additive migration and exact Security Scan, then stop for the
control owner's focused smoke. No historic reconciliation is planned or authorised.

The Render cron subsequently reported a startup failure before database access because the
standalone `tsx` process reached a Next.js `server-only` Prisma import through the LMSPro
participation-notification path. Direct child
`f321eb07936ec546e8738c22709809b2704be5ed` passes the worker Prisma client through branding
and letterhead resolution, preserves web defaults and all notification/delivery rules, and adds
a real standalone processor-import regression test. A complete local cron tick loaded all five
processors and completed with zero queued work, zero errors and no provider send.

Local `dev` and `origin/dev` are now exact
`f321eb07936ec546e8738c22709809b2704be5ed`. Replacement exact dev Security Scan run
`30513826659` passed. Local/remote STAGING and main remain at
`15559f1275d7f8ae3990cc6a9dcda5f35748e570`.
The next gate is the fresh recovery-only snapshot of the current STAGING database; the active
STAGING database URL must remain unchanged.

The aggregate-only STAGING preflight passed in an explicitly read-only transaction and ended
with `ROLLBACK`: application fingerprint `016aba10adf6`, correct authorised tenant/season, 147 successful
migrations, zero unfinished or unresolved rolled-back migration names, and no R9-B candidate
table or ledger row. The fresh recovery snapshot remains required before the staging push.

The recovery gate is now satisfied. The control owner confirmed dormant STAGING snapshot branch
`br-long-glade-abv9jrk0`, named `Staging Snaphot before cronjob fix 2026-07-30`, created
`2026-07-30 05:34:51 +01:00`. It is a recovery copy only; the active STAGING database and URL
remain unchanged.

Local/remote STAGING then fast-forwarded cleanly to exact `f321eb07`. Exact staging Security
Scan run `30514385014` passed; Render's compiled public build is `f321eb0`; public health is
HTTP 200 with its database connected and RLS 11/11. Independent read-only ledger verification
records 148 successful migrations, the R9-B candidate migration finished without rollback, both
additive tables present, zero historic audience rows and unchanged existing
Email/recipient/resource aggregates.

The control owner confirmed STAGING Cron Job build `bld-d9lda6142hec73civ1tg` succeeded for
exact displayed `f321eb0`. A complete invocation matched database fingerprint
`016aba10adf6`, loaded every registered processor, processed zero work with zero errors, fired no
key-date Email and finished successfully. Focused R9-B/R9-C/R9-D human smoke was then the next
controlled action.

Initial human smoke identified bounded Waiting List selector/status-presentation defects and a
prospective Email Club-audience nested-write defect. Corrective commit
`fbab1862fa8124ae5f1d64df1b2741fdb19761fc` resolved those defects without a new migration or
data change. Local/remote `dev` and `staging` are exact `fbab1862`; exact dev Security Scan run
`30516436459` and exact staging Security Scan run `30516573670` pass; Render STAGING is confirmed
Live at `fbab1862`; and public health remains green.

Focused R9-B Club Email visibility and cross-Club Email/detail/attachment authority passed.
R9-C C1/C2 responsive Team presentation passed at mobile, tablet, desktop and 200% zoom,
including keyboard `More details`. R9-D pointer, Enter/Space, drag/drop, validation,
save/reopen and duplicate passed in Chrome, with reduced activation also passing in Safari.
The combined R9-B-to-R9-D STAGING human boundary is PASS. Historic Emails remain deliberately
outside C2 history, and no historic reconciliation is planned. Production remains unchanged at
`15559f1275d7f8ae3990cc6a9dcda5f35748e570` pending a separately controlled promotion.

The control owner subsequently authorised that production promotion. Repository alignment and
fast-forward checks passed. An explicitly read-only, forced-rollback preflight against configured
active production endpoint `ep-autumn-silence-abep1qat`, fingerprint `fc6d0a8f1bc7`, confirmed
147 successful migrations, zero unfinished migrations, no R9-B candidate ledger row and neither
candidate table. This is the expected pre-promotion state. `main`, production schema and
production data remain unchanged while a fresh dormant production snapshot is obtained.
The control owner confirmed seven-day recovery snapshot `br-mute-paper-abuiyyj1`, named
`Main - snaphot before fbab1862fa8124ae5f1d64df1b2741fdb19761fc`, created
`2026-07-30 07:13:14 +01:00`. It is a dormant recovery copy only; the active production target
and URL remain unchanged.

Local/remote `main` subsequently fast-forwarded without merge commit from `15559f12` to exact
`fbab1862`; local/remote `dev` and `staging` already matched. Exact main Security Scan run
`30519008355` passed. Read-only production verification records 148 successful migrations, zero
unfinished migrations, the one R9-B additive migration finished without rollback, both
candidate tables present and zero prospective audience rows. No historic reconciliation ran.
Public production health is HTTP 200 with database connected and RLS 11/11. Render exact-commit
confirmation and non-mutating live smoke subsequently passed.

The control owner confirmed Render Live at exact `fbab1862`. Existing C1/C2 login, Club
Management, Team Management, Communications, friendly Team statuses, Club Waiting List
selectors and correct C2 Club scope passed. Historic C2 Email absence remained the expected
prospective-only result. No Email, notification or production record was created or changed.
R9-B, R9-C and R9-D production promotion is COMPLETE.
Wishlist items `LMS-W-UX-01`, `LMS-W-UX-02` and `LMS-W-UX-03` remain non-blocking
presentation follow-ups.

## Fresh Chat Prompt

```text
Formally triage LMS-W-UX-03 as the next small LMSPro planning candidate: responsive C1 Club
Management presentation using the proven R9-C Team card/table pattern.

Authoritative records:

1. isodocs/docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md
2. isodocs/docs/modules/lmspro/05-review-and-test/2026-07-30-lmspro-r9-b-to-r9-d-live-promotion-confirmation.md
3. the current C1 Club Management source and the completed R9-C shared Team presentation
   components/tests

Exact aligned application baseline:
fbab1862fa8124ae5f1d64df1b2741fdb19761fc

Create one proportionate code-only planning record. Preserve Club admission, derived Current and
Club Waiting List meanings, Team allocation, existing filters/totals/actions, permissions and
data. Define the reusable card/table presentation, responsive breakpoints, keyboard/accessibility
expectations, focused automated tests and a short C1 human smoke matrix.

Do not change application code, schema, migrations, database records, environment values or
deployment state. Stop after the bounded plan and exact implementation-approval prompt.
```
