# LMSPro Remediation Slice R8-A - Attachment-Aware Email Delivery Route And Fail-Closed Evidence Planning

Date: 2026-07-20
Module: LMSPro / SeasonPro
Status: Accepted controlling slice plan; implementation authorised through the bounded R8-A1 to R8-A5 sequence
Accepted: 2026-07-21
Type: High-priority communications integrity remediation
Related CR input: `docs/modules/lmspro/01-cr-inputs/2026-07-20-lmspro-cr-attachment-aware-email-delivery-and-fail-closed-evidence-remediation-input.md`
Prior foundation: LMSPro remediation slice R4-B communications email and announcements workflow

## 1. Purpose

R8-A controls the remediation of a live silent failure in which a C1 League Administrator
selected an attachment, sent an ad-hoc email and received a success indication, while the
delivered message contained no attachment.

The slice introduces a supported, asynchronous attachment-delivery path without changing
the proven live route for emails that contain no attachments.

The controlling split is:

```text
no persisted attachments
-> retain existing Resend batch path

one or more persisted attachments
-> new ordinary-endpoint attachment job path
```

This planning document defines the implementation boundary, sequencing, operational model,
risks and proof obligations. The plan and its proposed sub-slices were accepted by the
business analyst on 2026-07-21, subject to pausing for unresolved business decisions and for
required human UI smoke-test confirmation before creating the next sub-slice.

## 2. Relationship To The Controlled Delivery Cycle

The normal LMSPro cycle remains:

```text
CR input
-> triage/review
-> accepted slice plan
-> implementation
-> implementation confirmation
-> review/test
-> roadmap close-out
```

R8-A has a CR input and this accepted plan because the live incident and provider-contract
finding are sufficiently concrete to define a bounded response.

Accepted implementation baselines:

```text
application repository
branch: fix/lmspro-r8-a-attachment-delivery
base: origin/dev at e3f44b4b786c74dfcb177f01b3b00a09acf6bbb8

documentation repository
branch: fix/lmspro-r8-a-attachment-delivery
base: origin/main at 6190751662af45ebb00df6747ba8478e6945bf9b
```

The documentation repository does not publish an `origin/dev` branch; `origin/main` is its
controlling remote baseline.

## 3. Executive Delivery Decision

R8-A adopts a sender strategy selected from durable server-side state:

```text
                         +-----------------------------+
                         | Finalised Email + Recipients |
                         +---------------+-------------+
                                         |
                              inspect persisted attachments
                                         |
                    +--------------------+--------------------+
                    |                                         |
               zero attachments                         one or more
                    |                                         |
          existing batch sender                    attachment preflight
          max 100 per request                               |
          behaviour preserved                         durable job queued
                                                              |
                                                   ordinary /emails sender
                                                   one recipient/request
```

The existence of only one recipient does not select the ordinary endpoint. Attachment
presence selects the route.

## 4. Settled Principles

The following principles are controlling inputs for R8-A:

1. No-attachment batch sending is already reliable in live use and must receive regression
   protection.
2. The batch sender remains in use for no-attachment emails, including solitary recipients.
3. Resend does not support attachments through its batch endpoint.
4. Every attachment-bearing email must bypass the batch endpoint.
5. One ordinary Resend request carries one personalised recipient.
6. Approximately 300 recipients is a normal supported operating case, not an exceptional
   migration or bulk-import case.
7. A 300-recipient attachment send must run asynchronously.
8. C1 receives job progress and outcomes rather than an immediate unconditional `Email Sent`
   notification.
9. Attachment delivery fails closed if intended, persisted, validated and readable evidence
   does not match.
10. The shared IsoStack communications service remains the architectural home; LMSPro must
    not fork a parallel email platform.
11. Key-date sequence attachment authoring is deferred from R8-A.
12. Historic emails are not automatically resent as part of this slice.

## 5. Evidence And Current Implementation Findings

### 5.1 Provider Contract Mismatch

Current code prepares attachment payloads inside:

```text
src/core/services/communications/lib/send-email.ts
```

but `sendBatchEmails` submits them to:

```text
https://api.resend.com/emails/batch
```

Resend's current documentation states that the batch endpoint:

- accepts at most 100 emails per request; and
- does not support the `attachments` field.

Provider references checked on 2026-07-20:

- <https://resend.com/docs/dashboard/emails/batch-sending>
- <https://resend.com/docs/dashboard/emails/attachments>
- <https://resend.com/docs/api-reference/emails/send-email>

### 5.2 Upload Errors Are Non-Fatal

Current attachment upload/record creation in:

```text
src/core/services/communications/routers/emails.router.ts
```

catches errors and continues. This allows the requested attachment count and durable
attachment count to diverge.

### 5.3 Retrieval Errors Are Non-Fatal

The current send and resend-failed paths fetch `EmailAttachment.fileUrl`, convert failed
fetches to `null`, filter them out and continue sending.

### 5.4 Draft Update Does Not Own Attachments

`ComposeEmailModal` prepares attachment input, but the update schema does not accept it. New
attachments selected while editing a reopened draft can remain browser-only.

### 5.5 Success State Is Too Strong

The current UI treats a resolved send mutation as `Email Sent` without proving attachment
completeness or inspecting every returned failure count.

### 5.6 Test Gap

The R4-B review proved compose, announcement email, draft and duplicate workflows, but it did
not prove:

- attachment persistence;
- attachment delivery through Resend;
- reopened-draft attachment changes;
- provider evidence of attachment receipt;
- storage failure; or
- attachment delivery at representative recipient volume.

R8-A corrects that proof gap without invalidating unrelated R4-B outcomes.

## 6. Slice Goal

R8-A is complete when LMSPro can safely queue and deliver one immutable attachment-bearing
email to at least 300 resolved recipients through supported ordinary Resend requests, with
accurate per-recipient progress, retry and attachment evidence, while all no-attachment
emails continue through the unchanged batch sender.

## 7. Scope

### 7.1 Included

- define one authoritative sender-selection service;
- preserve the current batch call for an email with zero persisted attachments;
- introduce an ordinary `/emails` delivery adapter for attachment-bearing emails;
- finalise and fingerprint the exact attachment set before queueing;
- make attachment upload/validation/readability failure block queueing;
- support add/remove/replace attachment while an email is editable;
- hydrate durable attachments when reopening or duplicating a draft;
- add a database-backed attachment delivery job or accepted equivalent;
- claim work safely across workers;
- process one recipient per ordinary Resend request;
- implement configurable rate limiting and provider-header-aware `429` handling;
- implement bounded retry, stale-claim recovery and per-recipient idempotency;
- expose job and recipient progress to C1;
- distinguish provider acceptance from final mailbox delivery;
- record attachment and provider evidence in history/audit;
- configure the accepted worker runtime with required database, Resend and R2 access;
- add targeted unit/integration tests;
- prove representative delivery through staging and real inboxes; and
- create implementation confirmation and review/test records after implementation.

### 7.2 Excluded

- replacing Resend;
- broadly refactoring the existing no-attachment batch sender;
- changing LMSPro cohort/recipient business rules;
- changing Announcement target resolution;
- adding attachments to Announcement publication unless an existing attachment-bearing path
  is explicitly discovered and accepted during implementation review;
- adding attachments to `EmailSequenceStep` or key-date sequence authoring;
- changing key-date sequence timing/firing behaviour;
- implementing marketing broadcasts/contacts;
- rebuilding the whole `MediaFile`/R2 architecture;
- adding final delivery/bounce webhooks unless needed to prevent an existing status from
  making a false claim;
- deleting or automatically resending historic communications;
- changing unrelated authentication/verification email sending; and
- increasing the Resend plan or rate limit without separate operational approval.

## 8. Required Sender Selection Service

Routing must be performed once, server-side, after the email and exact attachment set are
durably ready.

Conceptual contract:

```text
selectEmailDeliveryMode(emailId)
-> verify tenant/email ownership
-> load durable recipient set
-> load durable active attachment set
-> if attachment count = 0: BATCH
-> otherwise: ATTACHMENT_JOB
```

Requirements:

- browser attachment state is never routing authority;
- the mode is persisted or derivable deterministically from a pinned send snapshot;
- an attachment cannot be added/removed after queueing without cancelling/revising under an
  explicit accepted policy;
- a retry uses the same delivery mode and same attachment fingerprint;
- `resendFailed` cannot accidentally move an attachment email back to the batch path; and
- a no-attachment email never enters the new job merely because it has one recipient.

## 9. Attachment Finalisation Contract

Before an attachment job can enter `QUEUED`, the service must prove:

```text
intended count
= persisted active association count
= validated count
= storage-readable count
```

Every pinned attachment should include or reference:

- attachment ID;
- tenant/organisation ID;
- email ID;
- original filename;
- normalised filename where needed for provider safety;
- accepted MIME/type evidence;
- size in bytes;
- durable object key;
- checksum/fingerprint;
- validation timestamp/version;
- immutable/revision evidence; and
- lifecycle/retention state.

Finalisation should calculate an attachment-set fingerprint from a canonical ordered list.
The job records this fingerprint and refuses to run if the effective set changes.

## 10. Storage Retrieval Decision

The current implementation reads attachments using `fetch(fileUrl)`. That depends on public
URL availability and silently filters failures.

The following alternatives were assessed:

### Option A - Authenticated Read And Base64 Content

```text
worker
-> authenticated GetObject by durable R2 key
-> validate checksum/size
-> Base64 encode
-> ordinary Resend request
```

Benefits:

- private object remains private;
- storage authority stays inside IsoStack;
- content sent is exactly validated bytes.

Costs:

- repeated API payload size for every recipient;
- larger application-to-provider network transfer;
- worker memory and time require bounding.

### Option B - Short-Lived Signed Remote Path

```text
worker
-> validate private R2 object
-> create narrowly scoped short-lived signed GET
-> ordinary Resend request with attachment path
```

Benefits:

- smaller application request payload;
- useful for one common attachment sent to many recipients.

Costs/risks:

- expiry must cover provider fetch and retry;
- signed URL exposure/retention must be reviewed;
- the provider must fetch exactly the intended immutable bytes;
- retry after expiry must mint a replacement path without changing the pinned object.

Accepted decision, 2026-07-21:

- Option B, the short-lived signed remote path, is the controlling delivery direction;
- the object remains private and is read/validated through authenticated storage authority
  before a signed path is minted;
- expiry, provider-fetch and retry-after-expiry behaviour must pass deployed proof;
- every retry mints a new signed path for the same pinned immutable object when required; and
- a permanent raw public R2 URL must never be treated as the security contract.

## 11. Size, Type And Content Validation

Resend currently limits the complete email to 40 MB after Base64 encoding. R8-A must not
assume that the existing 25 MB binary limit is automatically safe for every envelope.

The accepted service rule should cover:

- maximum binary size per attachment;
- cumulative binary size;
- estimated encoded size;
- body, text and letterhead overhead;
- maximum attachment count;
- multi-recipient campaign limit;
- actual content/type inspection rather than filename alone where practical;
- extension/type agreement;
- blocked executable or unsafe formats;
- malware-scanning requirement or explicit deferral; and
- filename sanitisation without losing the user-facing name.

Accepted initial operating envelope:

```text
up to 3 attachments
no more than 10 MB cumulative for a multi-recipient attachment send
```

These are settled application limits for R8-A. Provider and worker testing must still prove
that the accepted envelope remains safely below the complete-email provider limit.

## 12. Job And Recipient Model

### 12.1 Separate Document State From Processing State

Do not collapse email content lifecycle and job execution into one ambiguous status.

The existing `Email.status` may continue to represent the communication-level lifecycle,
but attachment job state should independently distinguish:

```text
QUEUED
RUNNING
SUCCEEDED
PARTIALLY_FAILED
FAILED
CANCELLED, only if accepted before work starts
```

Planning must decide whether to introduce an `EmailDeliveryJob` model or extend an existing
generic job substrate. A dedicated model is acceptable when it remains part of the shared
communications service rather than LMSPro-specific schema.

### 12.2 Minimum Job Evidence

The job should record at least:

- organisation ID;
- email ID;
- delivery mode;
- attachment-set fingerprint;
- recipient total;
- pending/accepted/failed counts;
- state;
- idempotency key or job fingerprint;
- attempt/retry evidence;
- lock/claim owner;
- queued/started/completed timestamps;
- next-attempt timestamp where relevant;
- safe terminal diagnostic; and
- requesting actor.

### 12.3 Recipient Evidence

Existing `EmailRecipient` records should remain the per-recipient business evidence where
safe. Planning should assess whether they need additional fields or a related attempt table
for:

- provider request idempotency key;
- provider message ID;
- attempt count;
- last-attempt time;
- next-attempt time;
- accepted/failed state;
- safe error code/message; and
- exact attachment/job fingerprint used.

Successful recipients must not be included in a later retry.

## 13. Queue And Worker Direction

The existing jobs code demonstrates useful PostgreSQL patterns:

```text
scripts/jobs/processors/sequences.ts
```

including:

- `FOR UPDATE SKIP LOCKED`;
- bounded claims;
- worker identity;
- stale-lock recovery;
- attempt counts;
- retry scheduling; and
- exponential backoff.

R8-A should reuse or deliberately adapt those patterns rather than introduce an unbounded
in-request loop.

The current five-minute cron is not sufficient for an operator who has just queued a live
communication if it is the only processing mechanism. Planning should choose between:

- a dedicated Render background worker polling PostgreSQL;
- a shared communications worker with prompt polling; or
- another already accepted interactive queue mechanism.

Render Workflows remains optional and must not be introduced solely because it exists.

The worker requires explicit environment access for:

- database;
- Resend API key and sender identity;
- R2 account, bucket and object credentials;
- any encryption/signing material; and
- rate-limit configuration.

## 14. Rate Limiting And Capacity

Resend's published default rate limit is currently five API requests per second per team,
shared across all team API keys:

<https://resend.com/docs/api-reference/rate-limit>

The target account's actual value must be captured during implementation/review from:

- Resend Settings/Usage; and
- `ratelimit-*` response headers.

Initial safe direction:

```text
configured maximum: 3 ordinary attachment sends/second
concurrency: bounded
429: honour retry-after/reset
other transactional capacity: reserved
```

Nominal 300-recipient timing:

| Rate | Approximate provider-request time |
| ---: | ---: |
| 1/second | 5 minutes |
| 2/second | 2 minutes 30 seconds |
| 3/second | 1 minute 40 seconds |
| 4/second | 1 minute 15 seconds |
| 5/second | 1 minute |

These figures exclude content preparation, network transfer, retry and provider latency.

The existing sender comment that assumes 25 requests per second is not authoritative and
should be corrected in implementation if the accepted slice touches that comment.

## 15. Idempotency, Retry And Crash Recovery

Each ordinary send should have a stable idempotency identity derived from immutable evidence,
for example:

```text
email ID
+ recipient ID
+ attachment-set fingerprint
+ delivery revision
```

Requirements:

- retries reuse the same provider idempotency key within the provider validity window;
- the system checks local accepted state before retrying after that window;
- `429` and bounded transient `5xx` errors are retryable;
- invalid attachment, invalid recipient and other permanent `4xx` failures are terminal for
  that attempt unless an authorised revision changes the inputs;
- a crashed worker releases or expires its claim safely;
- successful recipients remain successful;
- partial completion is a first-class outcome;
- a job is `SUCCEEDED` only when every intended recipient is accepted; and
- retrying failures does not mutate the historic evidence of prior attempts.

## 16. Draft And Duplication Contract

### New Draft

- Attachment selection initially creates a preparation state.
- `Save Draft` must not claim persistence until the upload and durable association succeed.
- Draft UI shows durable attachments distinctly from files still uploading/validating.

### Reopened Draft

- The get/detail contract returns attachment metadata.
- The compose modal hydrates those durable attachments.
- C1 can add/remove/replace while the draft remains editable.
- Update mutation owns the attachment delta or a dedicated attachment mutation does so.
- Send remains unavailable during an unresolved attachment operation.

### Duplicate Sent Email To Draft

- The original sent record remains immutable.
- A duplicated draft must not merely copy stale metadata to an object whose retention is
  controlled solely by the source association.
- Planning should prefer a new association to the same immutable managed object where the
  retention model supports reference counting/independent retention.
- C1 sees the copied attachment and can deliberately remove/replace it before sending.

### Queued/Sending Email

- Attachment mutation is prohibited after finalisation/queueing.
- Revision requires a conscious cancel/revise flow only if cancellation is accepted before
  any recipient is processed.
- Once any recipient is accepted, ordinary editing cannot rewrite the email or attachment
  set used by that recipient.

## 17. C1 User Experience

### Pre-Send

C1 sees:

- filenames;
- sizes;
- validation/readiness state;
- cumulative size;
- intended recipient count;
- delivery method explanation only where operationally helpful; and
- a blocked-send reason if any attachment is not ready.

### Queue Confirmation

The immediate success copy should be similar to:

```text
Email queued with 2 attachments for 300 recipients.
```

It must not say all emails have been sent before worker completion.

### Progress

The communications surface should show:

- `QUEUED`;
- `SENDING n of total`;
- accepted count;
- failed count;
- attachment count;
- queued/started/completed time; and
- retry availability.

### Completion

Use evidence-calibrated language:

```text
300 emails accepted by the email provider.
```

rather than promising inbox delivery when no delivery event evidence exists.

### Failure

Safe actionable categories should include:

- attachment upload failed;
- attachment validation failed;
- attachment unavailable from storage;
- provider rejected attachment;
- provider rate limited - retry scheduled;
- recipient rejected;
- partial completion; and
- worker/configuration unavailable.

Do not expose storage credentials, provider secrets or raw internal responses containing
sensitive data.

## 18. Audit And Operational Evidence

Audit should distinguish:

- attachment selected/preparation started;
- attachment stored and validated;
- email finalised;
- attachment job queued;
- worker processing started;
- recipient accepted/failed;
- job completed/partially failed/failed;
- retry requested/completed; and
- cancellation/revision if later accepted.

The current `EMAIL_CREATED` audit metadata should record actual durable attachment count,
not only the requested browser count.

The C1 detail view should make it possible to reconcile:

```text
Email
-> attachment set/fingerprint
-> delivery job
-> recipient attempts
-> Resend message IDs
```

Provider message IDs must be retained where returned. Storing a provider acceptance ID does
not imply mailbox delivery.

## 19. Tenant, Permission And Data Boundaries

Existing C1 communications authority remains the starting permission boundary.

Every new query/mutation/job claim must enforce:

- organisation ownership of Email;
- organisation ownership of attachments;
- email/attachment association consistency;
- C1 authority to compose/send/retry;
- no C2 visibility of other communications;
- no cross-tenant job status access; and
- no cross-tenant object retrieval by guessed key/URL.

Planning must verify whether the C1 user who may send an email is also allowed to retry or
cancel a job, or whether those actions require `ADMIN`/`OWNER`.

## 20. Schema And Migration Assessment

Implementation planning should expect a schema proposal, because reliable asynchronous
delivery needs durable job/attempt evidence that current `Email.status` alone does not
provide.

Candidate conceptual additions:

```text
EmailDeliveryJob
EmailRecipientDeliveryAttempt, if existing EmailRecipient fields are insufficient
immutable attachment validation/fingerprint fields or a related snapshot
```

Exact model names are not prescribed here. The accepted schema must:

- use organisation and email foreign keys;
- cascade/restrict deletion deliberately;
- index claimable job state and retry time;
- index email/job and recipient/attempt relationships;
- preserve immutable sent evidence;
- avoid one enum representing both document and processing lifecycle;
- support stale-claim recovery; and
- provide safe migration defaults for existing emails.

Existing historic `EmailAttachment` rows must not be assumed readable or complete. Migration
must not automatically queue or resend them.

## 21. Expected Application Surfaces

Likely existing files to inspect/change after slice acceptance:

```text
src/core/services/communications/components/ComposeEmailModal.tsx
src/core/services/communications/lib/send-email.ts
src/core/services/communications/routers/emails.router.ts
src/core/services/communications/types.ts
src/lib/r2.ts
src/app/(app)/app/lmspro/communications/page.tsx
scripts/jobs/run.ts
scripts/jobs/processors/index.ts
prisma/schema.prisma
prisma/migrations/<accepted-migration>/migration.sql
render.yaml, only if an accepted worker/runtime change requires it
```

Likely new shared communications surfaces:

```text
attachment preflight/finalisation service
delivery-mode dispatcher
ordinary attachment sender
attachment delivery job processor
targeted tests
```

Names and file boundaries should follow current shared service conventions rather than this
document inventing implementation names prematurely.

## 22. Recommended Implementation Sub-Slices

R8-A is one controlling remediation outcome, but implementation should be split to reduce
risk.

### R8-A1 - Provider Contract And Sender Dispatcher

- codify batch versus attachment mode;
- preserve the existing batch function unchanged for zero attachments;
- create an ordinary single-recipient attachment adapter;
- add provider-contract tests with mocked responses;
- correct non-authoritative rate-limit assumptions.

Exit gate:

```text
zero attachments can only select BATCH
one or more attachments can only select ATTACHMENT_JOB/ordinary sender
```

### R8-A2 - Attachment Persistence, Drafts And Fail-Closed Preflight

- make upload failure visible and blocking;
- return/hydrate durable attachments;
- support editable draft attachment changes;
- validate size/type/content/readability;
- pin attachment-set fingerprint;
- prevent mutation after finalisation.

Exit gate:

```text
intended = persisted = validated = readable
```

### R8-A3 - Durable Job, Rate Limiter And Retry

- add accepted schema/migration;
- queue without holding the browser request;
- claim jobs/recipients safely;
- throttle ordinary provider calls;
- honour provider rate headers;
- implement idempotency, bounded retry and stale-claim recovery;
- configure the accepted worker runtime.

Exit gate:

```text
300-recipient test job can complete without duplicates or synchronous request dependence
```

### R8-A4 - C1 Progress, History And Operational Controls

- show queued/running/partial/failed/completed states;
- show attachment evidence;
- expose safe retry for failed recipients under accepted authority;
- make copy evidence-calibrated;
- keep historic sent email immutable.

Exit gate:

```text
C1 can tell exactly what is queued, what was accepted and what failed
```

### R8-A5 - Deployed Provider And Regression Proof

- run no-attachment batch regression;
- run attachment ordinary-send test matrix;
- inspect Resend dashboard attachment evidence;
- inspect physical inbox results;
- prove 429/backoff through controlled simulation;
- prove worker restart/stale claim recovery;
- create implementation confirmation and review/test records.

Exit gate:

```text
live promotion recommendation is evidence-backed and attachment delivery is not inferred
from a green UI notification alone
```

The control window may allocate separate implementation confirmations to A1-A5 while keeping
R8-A as the parent remediation outcome.

## 23. Automated Test Plan

### Sender Selection

- zero attachments and one recipient selects batch;
- zero attachments and 300 recipients selects batch chunks of at most 100;
- one attachment and one recipient selects ordinary sender;
- one attachment and 300 recipients selects queued ordinary sends;
- retry preserves original delivery mode.

### Attachment Preflight

- valid supported file succeeds;
- upload failure blocks queueing;
- attachment record creation failure blocks queueing;
- missing R2 object blocks queueing;
- unreadable/private-object misconfiguration is surfaced safely;
- checksum mismatch blocks queueing;
- unsupported type is rejected visibly;
- individual and cumulative size limits are enforced;
- encoded provider envelope is enforced;
- intended/persisted count mismatch blocks queueing.

### Drafts And Duplication

- save new draft with attachment;
- reopen and see durable attachment;
- add attachment to reopened draft;
- remove attachment from reopened draft;
- replace attachment;
- duplicate sent email with safe object association;
- original sent record remains unchanged;
- queued email refuses attachment mutation.

### Job And Retry

- job claim is exclusive;
- two workers do not send the same recipient;
- successful recipient is not retried;
- retryable `429` honours headers;
- retryable `5xx` backs off;
- permanent provider validation error is terminal/actionable;
- stale claim is recovered;
- worker interruption does not duplicate accepted messages;
- partial completion remains visible;
- terminal job counts reconcile with recipient states.

### Tenant And Permission

- cross-tenant attachment lookup denied;
- cross-tenant job lookup denied;
- cross-tenant retry denied;
- unauthorised C2 user cannot queue/retry;
- accepted C1 sender can access only own-tenant evidence.

### No-Attachment Regression

- existing payload construction unchanged;
- existing cohort resolution unchanged;
- existing single-recipient batch behaviour unchanged;
- existing 100-recipient chunk boundary unchanged;
- existing 300-recipient three-batch behaviour unchanged;
- no attachment worker job created.

## 24. Browser And Deployed Smoke Plan

### Staging Fixture Set

Prepare controlled recipients for:

- one C1 test inbox;
- ten controlled test inboxes/aliases;
- representative 100-recipient load without contacting real Clubs where provider/test
  facilities permit;
- representative 300-recipient load through safe test addresses or provider-approved test
  strategy.

Do not use 300 real Club recipients for the first capacity proof.

### Attachment Fixtures

- small PDF;
- Word document;
- spreadsheet;
- image;
- long filename;
- filename containing spaces/safe punctuation;
- unsupported extension;
- deliberate missing object;
- deliberate checksum mismatch in automated/non-production proof;
- file at accepted size boundary; and
- deliberate over-limit file.

### Browser Flow

- compose new ad-hoc email;
- add file and wait for durable-ready state;
- send to one recipient;
- observe queued rather than sent copy;
- observe progress and terminal state;
- verify attachment in Resend dashboard;
- verify attachment in received physical email;
- repeat through saved/reopened draft;
- repeat through duplicated draft;
- create no-attachment email and confirm existing batch path/history remains normal.

### Operational Proof

- verify target environment Resend quota/rate limit;
- verify worker has exact required environment keys;
- verify private R2 object read;
- verify logs contain job/recipient identifiers but no secret/base64 content;
- verify retry after controlled transient failure;
- verify a deployment/restart does not duplicate accepted recipients;
- verify C1 can diagnose partial completion.

## 25. Performance And Resource Tests

For the accepted Base64 or signed-path strategy, record:

- attachment size;
- recipient count;
- total processing duration;
- ordinary request rate;
- average/provider latency;
- worker memory;
- worker CPU;
- application/provider bytes transferred where observable;
- retry count;
- provider `429` count; and
- final accepted/failed totals.

Minimum volume fixtures:

```text
1 recipient
10 recipients
100 recipients
300 recipients
```

The 300-recipient proof should use a representative attachment rather than only a tiny text
file, while avoiding unnecessary provider/storage cost during repeated development runs.

## 26. Promotion Gates

### Before Staging

- CR/plan accepted;
- schema and worker direction accepted;
- provider limits confirmed;
- automated tests pass;
- no-attachment regression passes;
- application code review confirms no attachment can reach batch;
- migration reviewed where required;
- environment requirements documented without secret values.

### Before Live

- staging ordinary-send attachment appears in Resend and physical inbox;
- reopened-draft attachment proof passes;
- partial failure and retry proof passes;
- representative volume proof passes;
- worker restart/recovery proof passes;
- C1 status language is accurate;
- no-attachment batch smoke passes;
- implementation confirmation exists;
- review/test record exists;
- roadmap is updated with exact promoted commit/environment evidence.

## 27. Historic Data And Incident Handling

R8-A must not automatically resend historic messages.

For the reported incident, an authorised operational investigation may separately identify:

- exact Email record;
- requested audit attachment count;
- actual attachment associations;
- R2 object state;
- Resend provider record; and
- whether the email was created fresh or sent from a reopened draft.

Any decision to contact affected recipients or resend the document is a business/operational
action outside automatic remediation.

Existing `EmailAttachment` rows should be treated as historical metadata until readability
and object ownership are verified. A migration must not rewrite or delete them casually.

## 28. Risks And Mitigations

### Risk: Regression To Proven Batch Sending

Mitigation:

- isolate sender selection;
- leave no-attachment batch function/payload unchanged;
- add explicit route-selection and batch regression tests.

### Risk: Rate Limit Starves Transactional Email

Mitigation:

- use configurable throttling below team maximum;
- reserve capacity;
- honour provider headers;
- consider shared priority/rate coordination if concurrent senders require it.

### Risk: Duplicate Emails After Retry Or Restart

Mitigation:

- per-recipient durable state;
- provider idempotency key;
- exclusive claims;
- never retry accepted recipients;
- stale-claim recovery tests.

### Risk: Large Attachment Resource Consumption

Mitigation:

- lower accepted campaign limit;
- bounded worker concurrency;
- prove Base64 versus signed path;
- load/cache one immutable object safely rather than many database copies.

### Risk: Public Exposure Of Attachment Objects

Mitigation:

- authenticated object access or short-lived signed GET;
- no permanent public URL dependency;
- tenant/key validation;
- safe retention and access audit.

### Risk: UI Claims Completion Too Early

Mitigation:

- queue acknowledgement differs from provider acceptance;
- progress comes from durable job state;
- terminal copy reflects actual evidence.

### Risk: Draft Metadata And Object Lifecycle Diverge

Mitigation:

- durable attachment associations;
- immutable object/version identity;
- reference-aware retention;
- complete draft hydrate/update tests.

## 29. Definition Of Complete

R8-A is complete only when all of the following are true:

- accepted attachment-bearing emails cannot use Resend batch;
- zero-attachment emails continue to use the existing batch path;
- a selected attachment cannot disappear without blocking/error evidence;
- attachment persistence and readability are proven before queueing;
- one recipient per ordinary provider request is enforced;
- a 300-recipient job completes asynchronously within accepted operational bounds;
- provider/account rate limits and quotas are respected;
- retry/restart cannot duplicate accepted recipients;
- drafts and duplicated drafts persist/display exact attachments;
- C1 sees accurate queue, progress and terminal states;
- audit/history reconciles email, attachment set, job and recipient/provider evidence;
- representative attachments appear in the Resend dashboard and recipient inbox;
- no-attachment batch regression passes in staging;
- implementation confirmation and review/test documents exist; and
- the authoritative LMSPro roadmap records completion and promotion evidence.

## 30. Accepted Decisions And Remaining Slice Decisions

Accepted on 2026-07-21:

1. R8-A and sub-slices R8-A1 through R8-A5 are authorised for sequential implementation.
2. Option B, a short-lived signed remote path to a validated private object, controls
   attachment retrieval/delivery.
3. A message may contain at most three attachments.
4. Cumulative attachment size may not exceed 10 MB.
5. The initial worker throttle is three ordinary provider requests per second, while runtime
   handling must respect stricter provider headers or account limits.

The following decisions should be resolved technically inside the relevant bounded slice
where existing IsoStack patterns provide a safe answer. Pause for business input if they
would change user authority, retention, security posture or external operating cost:

1. Confirm the target Resend team's actual requests-per-second limit and paid-plan quota.
2. Select the worker deployment mechanism and expected operator latency.
3. Confirm whether a dedicated `EmailDeliveryJob` and recipient-attempt model are required.
4. Decide authority for retry and any pre-send cancellation.
5. Define sent attachment/job retention.
6. Decide whether malware scanning is required now or explicitly deferred with accepted file
   restrictions.
7. Decide whether a later R8-B should add attachment support to key-date sequences.

## 31. Suggested Control-Window Handoff Prompt

```text
Review LMSPro Remediation Slice R8-A from:
docs/modules/lmspro/03-slice-planning/2026-07-20-lmspro-remediation-slice-r8-a-attachment-aware-email-delivery-route-and-fail-closed-evidence-planning.md

First decide triage/acceptance and the open provider, size, storage and worker choices. Do not
implement until the plan is accepted.

Preserve the existing Resend batch sender for every email with zero persisted attachments,
including solitary recipients. An email with attachments must use an asynchronous ordinary
/emails route, one recipient per provider request, with fail-closed attachment preflight,
durable per-recipient evidence, rate limiting, idempotency and retry. Prove 300-recipient
capacity without using real Club recipients for the first load test. Key-date sequence
attachment authoring remains out of scope.
```
