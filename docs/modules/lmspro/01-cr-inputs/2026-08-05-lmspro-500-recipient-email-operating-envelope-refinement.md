# LMSPro CR Input - 500-Recipient Email Operating-Envelope Refinement

Date: 2026-08-05

Planning status: Planning input for control-window review; not accepted or authorised

Module: LMSPro / SeasonPro using the shared IsoStack communications service

Source request: Assess and document the implications of increasing the supported quantity of
separately addressed cohort email, for example the Team Manager cohort, from approximately 300 to
500 unique recipients

Subsequent business evidence: The control owner reports a successful no-attachment Email to 414
recipients. The unresolved target, maximum and route-specific figures may remain open for later
control-window decision.

Application evidence reviewed at: `7154937c`

Authoritative roadmap:

`docs/modules/lmspro/00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md`

Related live regression `CR-Fix`:

`docs/modules/lmspro/01-cr-inputs/CR-Fix-2026-08-05-lmspro-cohort-email-draft-persistence-and-audience-selection.md`

The `CR-Fix` owns the subsequently proved draft-persistence regression, transaction timing,
role-selector collision, error classification and attachment-only acknowledgement policy
clarification. This document continues to own the distinct question of whether 500 unique
recipients should become an accepted or enforced provider-delivery operating envelope.

## 1. Planning-Only And Non-Authorising Boundary

This document is a change-request and operating-envelope refinement. It records current evidence,
implications, guidance, candidate workstreams and acceptance principles for later reconciliation by
the authoritative LMSPro control window.

It does not:

- change the completed R8-A or R8-A3 status;
- rewrite the accepted 300-recipient implementation or review evidence;
- declare 500 recipients supported in production;
- select or assign an executable slice;
- authorise application code, schema, migration, infrastructure, provider, deployment or
  production-data changes;
- create implementation, testing, staging, promotion or deployment evidence; or
- replace the authoritative LMSPro roadmap.

The separate control window remains responsible for triage, scope acceptance, slice selection,
implementation, testing, lifecycle records, promotion and roadmap reconciliation.

## 2. Purpose And Strategic Decision

The requested change must not be treated as changing a single `300` constant to `500`.

The current application does not enforce a 300-recipient ceiling. The figure of approximately 300
is the accepted and evidenced R8-A3 operating case for attachment-bearing email. A cohort resolving
to 500 unique email addresses may already pass input validation, but that does not make 500 a proven
or supported operating envelope.

The strategic recommendation is therefore:

```text
preserve completed 300-recipient evidence as historical truth
-> treat 500 unique primary recipients as a candidate operating envelope
-> assess no-attachment and attachment-bearing delivery separately
-> prove cohort accuracy, queue construction, transport, recovery and operational capacity
-> only then let the control window decide whether 500 is supported and/or enforced
```

No increase to the accepted three-provider-requests-per-second attachment rate is proposed. The
expected tradeoff is longer completion time and greater queue occupancy, not a faster worker.

## 3. Related And Controlling Documents

### 3.1 Completed R8-A Foundation

- `docs/modules/lmspro/01-cr-inputs/2026-07-20-lmspro-cr-attachment-aware-email-delivery-and-fail-closed-evidence-remediation-input.md`
- `docs/modules/lmspro/03-slice-planning/2026-07-22-lmspro-remediation-slice-r8-a3-durable-attachment-delivery-job-rate-limiter-and-retry-planning.md`
- `docs/modules/lmspro/05-review-and-test/2026-07-22-lmspro-remediation-slice-r8-a3-durable-attachment-delivery-job-rate-limiter-and-retry-review-and-test.md`

These documents control the completed attachment route, its three-request-per-second rate, its
150-recipient cron chunk, its 30-minute signed-path window and the exact scope of the accepted
300-recipient evidence. This refinement consumes those decisions; it does not alter them.

### 3.2 Related Communications And Cohort Integrity Work

- `docs/modules/lmspro/01-cr-inputs/2026-07-22-lmspro-consolidated-email-integrity-club-visibility-and-remedial-work-cr-input.md`
- `docs/modules/lmspro/01-cr-inputs/2026-07-27-lmspro-consolidated-four-item-remediation-planning-refinement.md`

Those documents control prospective Email-to-Club visibility and business-cohort integrity. A
larger delivery envelope must consume their distinctions between delivery identity, Club context
and business cohort; it must not reintroduce address-based C2 visibility inference.

### 3.3 Application Reference Documentation

- `isostack-bedrock/docs/00-READ_THIS/modules/lmspro/Key_LMSPro_Features/elective-mail.md`

That non-authoritative implementation reference should describe the current split between the
immediate no-attachment batch route and durable attachment job. It must identify 300 as the current
accepted attachment operating case and 500 as a candidate requiring control-window acceptance.

## 4. Existing Accepted Foundation

The following foundation remains accepted:

1. Every final recipient receives a separately addressed and separately tracked Email delivery.
2. A no-attachment Email uses the immediate Resend batch endpoint, including a solitary recipient.
3. The provider batch payload contains at most 100 emails per API request.
4. An attachment-bearing Email uses a durable asynchronous job and one ordinary provider request
   per primary recipient.
5. Attachment work runs in the existing nominal one-minute Render cron after the other registered
   processors.
6. One cron cycle claims at most one attachment job and processes at most 150 due recipients.
7. Ordinary attachment-provider starts are capped at three per second.
8. Attachment recipient attempts are durable, idempotent, resumable and reconciled into accepted,
   pending and failed counts.
9. The signed private-object execution window is 30 minutes.
10. Approximately 300 attachment recipients are the completed supported case, with deterministic
    no-network evidence across two 150-recipient cycles.
11. The completed review did not claim a real-provider 300-business-recipient scale send.
12. The control owner has supplied operational evidence that one no-attachment Email sent
    successfully to 414 recipients. This is direct business evidence for the immediate batch route;
    it is not attachment-route evidence and does not by itself settle a 500-recipient maximum.

## 5. Controlling Terminology

### 5.1 Cohort Member

A Team, Club, role assignment or other domain record that qualifies under a selected cohort.
Cohort-member count is not necessarily provider-recipient count.

### 5.2 Unique Primary Recipient

One case-insensitively deduplicated email address retained as one `EmailRecipient`. The proposed
500 quantity means 500 unique primary delivery addresses after server-side resolution and
deduplication, not 500 Teams or 500 raw cohort matches.

### 5.3 Separately Addressed Email

One personalised provider email and one per-recipient result. On the no-attachment route, up to 100
separately addressed emails share one provider batch API request. On the attachment route, every
separately addressed email uses its own ordinary provider API request.

### 5.4 Supported Operating Envelope

A volume and delivery-mode combination for which the application, provider account, queue runtime,
failure recovery, C1 feedback and operational evidence have been explicitly accepted. Passing input
validation alone is not support evidence.

### 5.5 Hard Maximum

A server-enforced refusal above an agreed unique-recipient count. There is no current 300-recipient
hard maximum. If 500 is intended as a hard maximum rather than an evidence target, later accepted
implementation must add a server-side guard and clear C1 preflight feedback.

## 6. Confirmed Current Findings

### 6.1 There Is No 300-Recipient Guard

The current recipient and cohort arrays have no maximum recipient cardinality. Cohorts are resolved
and merged before `recipientCount` is persisted. Raising the documented envelope without a later
server guard would not prevent 501 or more recipients.

Relevant application evidence:

```text
src/core/services/communications/routers/emails.router.ts
src/core/services/communications/lib/email-club-audience.ts
```

### 6.2 Manager Cohorts Are Deduplicated By Address

The division and age-group resolvers add Team Manager addresses and deduplicate them by trimmed,
lowercase email address. One person managing several Teams receives one provider delivery.

The retained recipient entity is the first matching Team context, while Club IDs are merged. This
can make Team-specific shortcode output represent one Team rather than every Team managed by that
address. The effect already exists at lower volumes but becomes more material in a broad manager
cohort.

The division and age-group manager queries also do not themselves add an explicit Team-status
filter. The selected cohort and current season context may narrow the result, but later acceptance
must prove that inactive, withdrawn or otherwise unintended Teams cannot silently expand the
manager audience.

Relevant application evidence:

```text
src/modules/lmspro/communications/cohort-resolver.ts
src/core/services/communications/components/ComposeEmailModal.tsx
src/core/services/communications/routers/emails.router.ts
```

### 6.3 No-Attachment Route At 500

The immediate route would normally use five provider batch requests instead of three:

```text
300 unique recipients -> 100 + 100 + 100 -> three provider requests
500 unique recipients -> 100 + 100 + 100 + 100 + 100 -> five provider requests
```

The existing sender places a short local interval between calls and retries `429` responses with
local exponential delay. The current provider documentation states that the default team limit is
five requests per second and that the limit is shared by every API key and service in the team.
Five rapid batch calls may therefore consume the complete default request allowance for the window,
leaving collision risk with password reset, authentication, notification or other transactional
email.

The immediate route also keeps the initiating request open while it:

- resolves recipient-specific shortcode content;
- makes every provider batch request; and
- writes each recipient result back sequentially.

The current focused batch test proves the 100-recipient chunk boundary with 101 recipients. It does
not establish a 500-recipient request-duration, rate-collision, partial-failure or reconciliation
case.

The control owner additionally reports a successful no-attachment send to 414 recipients. Under
the current 100-email chunk contract, that volume requires five provider batch requests
(`100 + 100 + 100 + 100 + 14`). This materially strengthens the operational basis for
no-attachment delivery above 300 recipients and demonstrates a successful five-request send. It
does not prove attachment delivery at that scale, define a hard maximum, or remove the need to
understand shared provider rate, quota, timing and failure behaviour before declaring 500 a
supported envelope.

Provider references checked 2026-08-05:

- <https://resend.com/docs/api-reference/emails/send-batch-emails>
- <https://resend.com/docs/api-reference/rate-limit>
- <https://resend.com/docs/knowledge-base/account-quotas-and-limits>

### 6.4 Attachment Route At 500

The unchanged 150-recipient chunk produces four cron cycles:

```text
cycle 1 -> 150
cycle 2 -> 150
cycle 3 -> 150
cycle 4 -> 50
total   -> 500 unique provider requests
```

Three provider starts per second imply approximately 167 seconds of pacing time before provider
latency, database work, other processors, cron launch delay and retry overhead. Because work is
distributed over four nominal one-minute ticks, planning should present approximately four to five
minutes as a normal expectation, not promise an exact completion time.

Only one attachment job is claimed per cron run. A healthy 500-recipient job therefore occupies two
more attachment cycles than the accepted 300-recipient case and delays later attachment jobs. The
existing sequence, key-date, participation and Commerce processors continue to run first and must
not be displaced.

The 30-minute signed-path window is not an immediate clean-run blocker. It has less contingency,
however, when delayed ticks, transient provider failures and durable retries consume additional
cycles. A 500-recipient acceptance case must prove expiry behaviour rather than infer it from the
300-recipient result.

### 6.5 Queue Construction Is A Separate Scale Boundary

Attachment delivery becomes asynchronous only after the send request has resolved and snapshotted
every recipient and committed the durable job. The current queueing path resolves all recipient
shortcodes concurrently, creates delivery-recipient rows in bulk and then updates each
`EmailRecipient` sequentially inside a serializable transaction.

The existing deterministic 300-recipient worker fixture proves worker pacing and reconciliation;
it does not prove the browser-to-queue transaction at 300 or 500 recipients. Queue-construction
duration, database connection pressure, transaction duration and failure recovery must therefore be
measured independently from provider delivery time.

### 6.6 Provider Quota And Deliverability Exposure

Moving from 300 to 500 consumes 67 percent more provider email quota per full cohort send. The
actual Resend team plan, monthly allowance, overage configuration and current shared request rate are
external operational dependencies and must be confirmed from the target environment rather than
assumed from repository code.

The provider currently requires bounce rate below 4 percent and spam rate below 0.08 percent. A
larger manager cohort increases the consequence of stale addresses, ambiguous Team status,
mis-targeting and missing consent or expectation. The reviewed elective-mail path does not provide
a complete bounce, complaint and suppression feedback loop. That broader capability need not block
all volume refinement, but the residual risk and address-hygiene operating rule must be explicit.

## 7. Ownership Boundaries

### 7.1 C1 League Administration

C1 owns the reviewed cohort selection, message purpose, recipient expectation, visible final unique
recipient count and confirmation that a broad manager communication is appropriate.

### 7.2 LMSPro

LMSPro owns Team Manager cohort semantics, Team/Club/season context, recipient-role labels and
shortcode meaning. It must provide the shared sender with a truthful deduplicated audience.

### 7.3 Shared IsoStack Communications Service

Core communications owns recipient persistence, route selection, provider transport, idempotency,
retry, attachment job state, delivery-result reconciliation and safe operational evidence.

### 7.4 Platform And Operations

Platform/operations own the actual Render cron configuration, database runtime, Resend team
rate/quota verification, private R2 configuration and environment-specific monitoring. No new paid
worker or blind Blueprint synchronisation is implied by this refinement.

### 7.5 C2, Public, Commerce And FUND

- C2 Club history must continue to use explicit prospective Email-to-Club visibility, not infer
  visibility from a larger recipient list.
- No public LMSPro surface changes are included.
- Commerce and FUND do not acquire a 500-recipient contract from an LMSPro decision. They may
  consume shared core protections only through their own accepted module planning.

## 8. Settled Guidance For Later Triage

1. Completed 300-recipient R8-A3 evidence remains unchanged.
2. There is no current 300-recipient application limit to raise.
3. Five hundred means unique primary addresses after server-side deduplication.
4. No-attachment and attachment-bearing sends require separate capacity and acceptance evidence.
5. The attachment worker remains capped at three provider starts per second unless separately
   reopened through provider and operational evidence.
6. A normal 500-recipient attachment send should be described as approximately four to five
   minutes, subject to cron and provider conditions.
7. The actual Resend team rate, quota and shared sender demand must be checked before acceptance.
8. Manager cohort status semantics and multi-Team personalisation must be reviewed before using a
   broad cohort as scale evidence.
9. A 500-recipient evidence target does not automatically create a hard maximum.
10. A hard maximum, if desired, must be enforced server-side rather than documented only in UI
    copy.
11. No completed lifecycle record should be edited to imply that 500 was previously tested.
12. The successful 414-recipient no-attachment send is settled business-provided operational
    evidence and should remain identified separately from automated or lifecycle evidence.
13. Unresolved target, maximum, timing and route-specific figures may remain unresolved until the
    control window deliberately settles them; this refinement does not force placeholder values.

## 9. Included Scope

- unique-recipient counting and visible C1 preflight meaning;
- no-attachment five-batch transport implications;
- the reported successful 414-recipient no-attachment operating evidence;
- attachment four-cycle queue implications;
- shortcode-resolution and queue-construction performance;
- retry, signed-window and subsequent-job interaction;
- Team Manager cohort accuracy and deduplication semantics;
- provider rate, quota, bounce and spam dependencies;
- operational expectation and documentation alignment; and
- a decision on evidence target versus enforceable maximum.

## 10. Excluded Scope

- changing the email provider;
- increasing the attachment worker rate above three requests per second;
- creating a new paid background-worker service;
- adding attachments to key-date or ordinary sequence authoring;
- redesigning the completed private-R2 attachment policy;
- implementing a complete marketing-contact or broadcast subsystem;
- retroactively mutating historic recipients, Club visibility or delivery evidence;
- granting C2, public, Commerce or FUND new capability; and
- editing completed R8-A3 implementation, review, promotion or roadmap status.

## 11. Dependencies And Retroactive Implications

### 11.1 Provider Account Dependency

Acceptance depends on the actual target environment's Resend plan, team request rate, monthly quota,
overage policy and concurrent transactional demand. Documentation records settings and outcomes,
not secret values.

### 11.2 Cron And Database Dependency

The existing cron must continue its nominal one-minute schedule and non-overlap behaviour. Database
capacity must support 500-recipient preview, draft persistence, queue construction and per-recipient
reconciliation without weakening tenant or transaction boundaries.

### 11.3 Cohort-Integrity Dependency

The selected business cohort must be defined by intended Team/season/status semantics. A broad
technical query result is not sufficient acceptance evidence if it includes stale or ineligible
manager records.

### 11.4 No Automatic Retroactive Change

If 500 is later accepted, historic 300-recipient tests and delivery jobs remain unchanged. No
historic Email, recipient, attempt or Club-visibility data requires backfill solely because the
supported future envelope changes.

## 12. Candidate Workstreams For Control-Window Consideration

These are candidate planning workstreams, not executable slice identifiers or implementation
authority.

### 12.1 Operating Policy And Documentation Alignment

- decide whether 500 is a supported target, a hard maximum or both;
- define route-specific C1 timing copy and operational expectations; and
- align current reference documentation without rewriting historical evidence.

### 12.2 No-Attachment 500-Recipient Evidence

- exercise exactly five 100-recipient provider batches under deterministic transport;
- prove shortcode resolution, result ordering and complete reconciliation;
- exercise `429`, permanent batch refusal, partial operational failure and initiating-request
  interruption; and
- measure request duration and database write cost.

### 12.3 Attachment 500-Recipient Evidence

- exercise 500 unique recipients across four bounded cron cycles;
- prove pacing, idempotency, accepted-recipient exclusion and terminal reconciliation;
- measure browser-to-queue construction independently;
- exercise delayed tick, retry and signed-window expiry boundaries; and
- queue a second attachment job to prove delay, fairness and operator-visible state.

### 12.4 Manager Cohort Accuracy And Hygiene

- define eligible Team statuses and current-season authority;
- prove unique-address count separately from raw Team count;
- decide the intended message/shortcode result for one manager linked to several Teams; and
- establish stale/invalid address review and broad-send confirmation rules.

### 12.5 Enforceable Maximum And Operational Guarding

- add a server-side maximum only if the control window accepts one;
- refuse over-limit preview/create/update/send consistently;
- preserve an exact visible unique-recipient count before C1 commits the send; and
- define monitoring/alerting for queue age, retries, rate limits, quota and terminal failures.

## 13. Acceptance Principles

A later 500-recipient operating envelope should not be accepted unless evidence proves all of the
following applicable outcomes:

1. The C1 preview, persisted `recipientCount`, delivery job and final counts agree on exactly 500
   unique primary recipients.
2. Raw Team matches and deduplicated provider-recipient count are distinguishable.
3. A manager associated with multiple Teams receives one intended message with correct and
   non-misleading personalisation.
4. Ineligible Team statuses and wrong-season records do not enter the selected manager cohort.
5. A no-attachment send creates five provider requests containing no more than 100 emails each.
6. Later controlled evidence preserves the business-reported successful 414-recipient
   no-attachment case without overstating it as automated, provider-log or attachment evidence.
7. The no-attachment path handles the actual shared team rate without starving critical
   transactional email or falsely reporting failed/accepted state.
8. The initiating request and sequential result persistence complete within the accepted runtime
   envelope, or later planning introduces a safer durable boundary.
9. An attachment send creates one immutable job and 500 unique delivery-recipient identities.
10. Four clean attachment cycles process `150 + 150 + 150 + 50` recipients at no more than three
    provider starts per rolling second.
11. Accepted recipients are never duplicated after retry, interruption or stale-claim recovery.
12. Delayed ticks and bounded retry remain safe inside the signed-path window, while expiry fails
    closed with truthful evidence.
13. A second queued attachment job remains visible and eventually progresses without state loss.
14. Existing scheduled processors retain priority and complete truthfully.
15. Provider quota, rate, bounce and spam dependencies are recorded for the target environment.
16. No secret, full database URL, signed attachment path, raw provider body or personal recipient
    list enters planning or lifecycle documentation.
17. Existing one-, 101- and 300-recipient regression evidence continues to pass under the later
    controlled test plan.

## 14. Planning Handoff

The control window may later reconcile this input by:

1. deciding whether the desired policy covers no-attachment email, attachment email or both;
2. deciding whether 500 is an evidence target, a hard maximum or both;
3. accepting, revising or declining the candidate workstreams;
4. assigning any accepted work through the normal bounded LMSPro lifecycle; and
5. updating the authoritative roadmap only after the normal control decision.

No application implementation, lifecycle evidence, current-slice selection or roadmap status
change follows from this document.

## 15. Open Business And Planning Questions

1. Is 500 intended to be the maximum permitted unique-recipient count, or only the next supported
   operating case?
2. Should the 500-recipient policy apply to both no-attachment and attachment-bearing ad-hoc email,
   or should attachment email retain a lower supported envelope?
3. Is approximately four to five minutes an acceptable normal C1 expectation for a clean
   500-recipient attachment job?
4. Which exact Team statuses qualify for a broad Team Manager communication in the current season?
5. When one address manages several Teams, should the message use no Team-specific shortcodes, one
   explicitly identified Team, or a complete multi-Team summary?
6. What are the current target-environment Resend team rate, plan quota, overage policy and
   concurrent critical-email demand?
7. What operator action is expected when a second attachment job waits behind a large job or when a
   job approaches the signed-path expiry boundary?

These figures and choices are intentionally left unresolved until the control window requires a
decision. The successful 414-recipient no-attachment evidence does not require them to be settled
now.
