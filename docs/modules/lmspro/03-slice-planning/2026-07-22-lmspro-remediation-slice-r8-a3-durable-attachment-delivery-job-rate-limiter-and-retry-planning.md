# LMSPro Remediation Slice R8-A3 - Durable Attachment Delivery Job, Rate Limiter And Retry Planning

Date: 2026-07-22

Module: LMSPro / SeasonPro shared communications

Status: Accepted; implementation authorised using the existing Render cron runtime

Controlling parent:

`docs/modules/lmspro/03-slice-planning/2026-07-20-lmspro-remediation-slice-r8-a-attachment-aware-email-delivery-route-and-fail-closed-evidence-planning.md`

Related CR input:

`docs/modules/lmspro/01-cr-inputs/2026-07-20-lmspro-cr-attachment-aware-email-delivery-and-fail-closed-evidence-remediation-input.md`

Human gate evidence:

`docs/modules/lmspro/05-review-and-test/2026-07-22-lmspro-remediation-slice-r8-a2r-f1-draft-resource-state-rehydration-and-attachment-transport-correction-review-and-test.md`

## 1. Purpose

R8-A3 replaces the temporary attachment-send refusal with a durable, asynchronous delivery
route. It connects the already-proven private attachment evidence and ordinary Resend
`/emails` adapter without changing the working no-attachment batch route.

```text
zero persisted attachments
-> existing synchronous batch route

one to three persisted attachments
-> final fail-closed resource proof
-> durable delivery job
-> existing one-minute Render cron
-> one ordinary provider request per primary recipient
-> durable acceptance, retry and terminal evidence
```

R8-A3 owns reliable queueing and processing. R8-A4 continues to own the full C1 progress,
history and operational-control experience.

## 2. Gate And Repository Baseline

The deployed R8-A2R-F1 human smoke is reported PASS, including:

- private PDF/image/TXT/CSV persistence and rehydration;
- the exact three-file and 10 MB envelope;
- three separately persisted HTTPS links;
- links-only and no-resource batch regression;
- the C1 responsibility acknowledgement; and
- the intentional attachment-send fail-closed result.

Expected implementation baseline:

```text
application: origin/dev at 6c5aaa56ffa33ab3bcc2102ff7da6cdc84fda4a4
documentation: origin/main at 62aca8057d3f0560a8764613e644a247fb2ccba4
```

Implementation must use a new dedicated application branch from the exact current
`origin/dev`. It must not begin from an older R8 branch.

## 3. Settled Business And Provider Decisions

The following are already accepted and must not be reopened by implementation:

1. Attachment presence is derived from durable server-side `EmailAttachment` rows.
2. Zero attachments continue through `sendBatchEmails`, including one-recipient messages.
3. One to three attachments use Resend's ordinary `/emails` endpoint.
4. Each ordinary request has exactly one primary recipient.
5. Approximately 300 primary recipients are a supported operating case.
6. Delivery is asynchronous, rate-controlled, resumable and observable.
7. The initial application ceiling is three provider requests per second.
8. Uploaded content remains limited to the accepted R8-A2R types and 10 MB cumulative.
9. Attachments remain private in the dedicated R2 bucket.
10. Up to three external HTTPS links remain separate from attachments and are appended to
    the message body; SeasonPro does not fetch or verify them.
11. Attachment-bearing delivery fails closed if intended, persisted, validated and readable
    resource evidence differs.
12. Provider acceptance is recorded accurately and is not described as inbox delivery.
13. Key-date sequence attachment authoring remains outside this slice.

Resend currently supports `Idempotency-Key` on `POST /emails`, retains keys for 24 hours and
publishes a default team rate limit of five requests per second. Provider response headers
remain the runtime authority:

- <https://resend.com/docs/dashboard/emails/idempotency-keys>;
- <https://resend.com/docs/api-reference/rate-limit>; and
- <https://resend.com/docs/api-reference/emails/send-email>.

## 4. Included Scope

- dedicated shared-communications delivery-job persistence;
- a migration that creates no jobs for historic emails;
- atomic finalisation and idempotent queue creation;
- immutable attachment/resource fingerprint pinning;
- job and per-recipient processing state independent from `Email.status`;
- stable provider idempotency evidence;
- deterministic short-lived private R2 GET paths for an exact job execution window;
- a PostgreSQL-backed attachment processor registered with the existing cron runner;
- exclusive claims using `FOR UPDATE SKIP LOCKED`;
- stale-claim recovery;
- three-per-second ordinary provider throttling;
- durable retry for `429`, concurrent-idempotency, network and provider `5xx` failures;
- terminal treatment for permanent provider validation/authentication failures;
- provider message-ID retention;
- exact accepted/failed/pending count reconciliation;
- safe queue-confirmation copy in the compose flow;
- fail-closed attachment retry until R8-A4 supplies an accepted operator control; and
- focused queue, processor, signing, retry, idempotency and batch-regression tests.

## 5. Excluded Scope

- the full R8-A4 progress/history UI;
- operator cancellation after any recipient processing begins;
- manual partial-failure retry controls;
- mailbox-delivery webhooks;
- automatic resend of historic incomplete emails;
- sequence attachment authoring;
- changing the accepted file/link policy;
- changing the private bucket to public access;
- malware scanning;
- Render Workflows beta adoption;
- replacing Resend; and
- broad refactoring of the proven no-attachment batch route.

## 6. Proposed Persistence Contract

### 6.1 Delivery Job

A shared `EmailDeliveryJob` aggregate should record:

- organisation and Email identity;
- attachment delivery mode;
- `QUEUED`, `RUNNING`, `SUCCEEDED`, `PARTIALLY_FAILED` or `FAILED` state;
- exact attachment/resource fingerprint;
- unique queue idempotency key;
- recipient total and pending/accepted/failed counts;
- processing-cycle count;
- claim owner/time;
- queued, started, completed and next-attempt times;
- fixed attachment-path signing time;
- requesting actor; and
- safe terminal error code/message.

There is one immutable delivery job per finalised attachment-bearing Email. A repeated send
request must return the same job rather than create a second delivery.

### 6.2 Per-Recipient Delivery

A related job-recipient record should pin one existing `EmailRecipient` and record:

- `PENDING`, `PROCESSING`, `RETRY_SCHEDULED`, `ACCEPTED` or `FAILED` state;
- a stable provider idempotency key;
- attempt count;
- provider message ID;
- first/last attempt and next-attempt timestamps;
- accepted timestamp; and
- safe last error code/message.

Successful recipients are terminal and must never be claimed again.

### 6.3 Attempt Evidence

Each provider request should append immutable attempt evidence containing:

- recipient-delivery identity;
- attempt number;
- accepted, retry-scheduled or failed outcome;
- provider message ID where returned;
- safe provider/status classification;
- started/completed time; and
- next-attempt time where relevant.

No attachment bytes, signed URLs, Resend API key or raw provider response body may be stored
in job, attempt, audit or application logs.

## 7. Atomic Queue Contract

The existing `communications.emails.send` procedure should continue the batch route for zero
attachments. For attachment-bearing messages it should:

1. re-check tenant ownership and send authority;
2. run the complete current `assertEmailResourcesReady` proof;
3. require at least one resolved recipient;
4. pin the current resource fingerprint;
5. atomically create the job and exact job-recipient set;
6. atomically move `Email.status` to `SENDING`;
7. write `EMAIL_ATTACHMENT_DELIVERY_QUEUED` audit evidence; and
8. return `ATTACHMENT_JOB`, job ID, recipient total and attachment count.

If an equivalent unique job already exists, the mutation returns it. It does not enqueue a
duplicate. Any attachment, link, recipient or content mutation remains prohibited after
queueing because the Email is no longer `DRAFT`/`SCHEDULED`.

The compose UI must say `Email queued` for this response. It must not say `Email Sent`.

## 8. Private Attachment Path Contract

R8-A3 should add a private-R2 presigning helper that:

- uses only the configured private attachment bucket;
- signs `GetObject` for the exact immutable key;
- supplies the validated filename as attachment disposition;
- returns no public bucket/object identity to C1;
- accepts a fixed job signing timestamp; and
- never logs the resulting URL.

The same job signing timestamp and expiry must reproduce the same provider payload for a
retry using the same Resend idempotency key. The initial execution window should be 30
minutes. The processor must not send or retry after that signed-path window expires; it should
record a safe terminal failure for later R8-A4 operator review.

## 9. Provider Attempt Contract

The ordinary adapter should expose one-attempt delivery for the durable processor while
preserving existing R8-A1 tests and public behaviour.

Each request must include:

```text
Idempotency-Key: email-attachment/<email-id>/<recipient-id>/<fingerprint-version>
```

The key remains under the provider's 256-character bound. Retrying an attempt reuses the
same key and byte-for-byte-equivalent remote-path payload.

Response classification:

| Result | Worker treatment |
| --- | --- |
| Provider `2xx` with message ID | `ACCEPTED` |
| `429` or concurrent idempotent request | retry using provider delay where present |
| network failure or provider `5xx` | bounded retry |
| invalid idempotent request | terminal fail closed |
| invalid recipient/attachment/authentication or other permanent `4xx` | terminal failure |

The provider's `retry-after` and rate-limit headers are used when valid. Raw response bodies
must not be surfaced to C1 or stored unbounded.

## 10. Cron Processor And Claim Contract

The accepted runtime is the existing `isostack-jobs` Render cron. Its schedule changes from
every five minutes to every minute. No additional background-worker service is created.

Every cron run should:

1. execute the existing sequence, key-date and Commerce processors first;
2. claim attachment work using `FOR UPDATE SKIP LOCKED`;
3. process at most 150 attachment recipients at three requests per second; and
4. reconcile/release the job before exiting.

The processor should:

- claim at most one attachment job per run using `FOR UPDATE SKIP LOCKED`;
- recover stale job and `PROCESSING` recipient claims;
- validate the pinned Email/resource fingerprint and private objects once per job cycle;
- process the bounded 150-recipient chunk so the provider loop occupies approximately 50
  seconds before retry overhead;
- enforce at most three provider requests per second;
- schedule retry delays of approximately one, two and five minutes, bounded to four total
  provider attempts and the signed-path execution window;
- release claim evidence after every bounded cycle;
- reconcile counts and terminal state transactionally;
- stop cleanly if the cron receives termination and leave resumable durable evidence; and
- return processor error evidence without falsely changing queued jobs to sent.

Render's single-run guarantee prevents overlapping executions of the same cron. A
300-recipient job normally completes across two one-minute runs. The existing scheduled
processors remain first in every run so attachment delivery cannot indefinitely starve
their due work.

## 11. Email And Job State Reconciliation

```text
job QUEUED/RUNNING/retry scheduled
-> Email SENDING

all recipients ACCEPTED
-> job SUCCEEDED
-> Email SENT

some ACCEPTED, remainder terminal FAILED
-> job PARTIALLY_FAILED
-> Email SENT with exact sent/failed counts

no recipients ACCEPTED and no retry remains
-> job FAILED
-> Email FAILED
```

`Email.status` remains the broad communication lifecycle. It does not replace the job's
more precise processing state.

## 12. Configuration And Deployment Boundary

The cron requires the same environment-specific secrets as the web service for:

- `DATABASE_URL`;
- `RESEND_API_KEY` and `EMAIL_FROM`;
- `R2_ACCOUNT_ID`;
- `R2_ACCESS_KEY_ID`;
- `R2_SECRET_ACCESS_KEY`; and
- `R2_EMAIL_ATTACHMENT_BUCKET_NAME`.

Non-secret bounded tuning may use versioned defaults:

```text
EMAIL_ATTACHMENT_SEND_RATE_PER_SECOND=3
EMAIL_ATTACHMENT_SIGNED_URL_TTL_SECONDS=1800
EMAIL_ATTACHMENT_RECIPIENTS_PER_TICK=150
```

The code must cap the send rate at the accepted three-per-second ceiling even if an unsafe
higher environment value is supplied.

No online service creation, paid-plan activation, staging migration or environment mutation
is performed merely by committing this slice. Those actions require the normal controlled
staging migration/runtime gate.

### 12.1 Starter Cron Resource Envelope

The existing cron target remains Render `Starter`: 512 MB RAM and 0.5 CPU. This is a runtime
memory/CPU allowance, not a limit on the installed dependency directory. Render build
pipeline work runs on separate build compute.

Local dependency-import measurements on 2026-07-22 provide preliminary sizing evidence:

| Representative process | Idle RSS | Heap used |
| --- | ---: | ---: |
| Existing sequence/key-date/Commerce processor imports | approximately 148 MiB | approximately 33 MiB |
| Prisma plus R2/presigning/rendering dependencies | approximately 189 MiB | approximately 43 MiB |
| Combined representative cron-process imports | approximately 237 MiB | approximately 69 MiB |

These figures exclude a live Prisma query-engine connection and actual delivery work, so
they are not final deployed proof. They nevertheless leave a credible margin when the
cron process is constrained to:

- one claimed attachment job and one provider request at a time;
- three requests per second by pacing rather than concurrency;
- private signed paths rather than Base64 attachment copies in provider payloads;
- at most one sequential 10 MB cumulative resource verification buffer;
- no Next.js server or `.next` runtime;
- a job-process-specific Node heap ceiling; and
- non-overlapping scheduled processor ticks.

The cron build command remains limited to dependency installation and Prisma generation;
it must not run the memory-intensive Next.js application build. The repository's local
installed dependencies are approximately 1.2 GB on disk, but build disk and build memory are
separate from the 512 MB running-service allowance.

Staging must capture idle and 300-recipient peak RSS/CPU. The initial acceptance targets are:

```text
sustained RSS below 400 MiB
no out-of-memory restart
existing scheduled processors execute first on every cron run
no overlap of the scheduled full processor tick
```

If staging approaches 430 MiB sustained RSS or experiences memory restarts, stop rather
than automatically upgrading the instance. First inspect imports, buffering, Prisma client
count and processor overlap; any higher paid plan then requires an explicit cost decision.

## 13. Expected Code Surfaces

Likely changed:

```text
prisma/schema.prisma
prisma/migrations/<r8-a3-migration>/migration.sql
src/lib/r2.ts
src/core/services/communications/lib/send-email.ts
src/core/services/communications/routers/emails.router.ts
src/core/services/communications/components/ComposeEmailModal.tsx
scripts/jobs/processors/email-attachment-delivery.ts
package.json
render.yaml, subject to the runtime decision
```

Likely new shared library/test surfaces:

```text
src/core/services/communications/lib/email-attachment-delivery-job.ts
src/core/services/communications/lib/email-attachment-delivery-processor.ts
focused queue/retry/signing/processor tests
```

## 14. Automated Verification

Required evidence includes:

- Prisma format, validate and generated-client checks;
- migration SQL review and empty-history safety;
- zero attachments still select batch;
- attachment send creates one job and does not call Resend in the browser request;
- repeated queue request does not create a duplicate job;
- one and 300 recipient job construction;
- deterministic signed paths for one job execution window;
- signed-path expiry refusal;
- provider `Idempotency-Key` header proof;
- exclusive claim and stale recovery;
- accepted recipient never retried;
- `429`, concurrent idempotency, network and `5xx` retry classification;
- permanent `4xx` terminal classification;
- rate ceiling under a fake clock;
- crash-window retry uses the same key and payload;
- partial and complete state/count reconciliation;
- tenant/job ownership query tests where exposed;
- links are appended to attachment-message HTML;
- attachment queue copy says queued, not sent;
- no-attachment batch regression;
- focused and full Vitest;
- type-check, critical-file verification and production build; and
- security/dependency gate before any promotion.

## 15. Deployment And Human Evidence Gate

After local technical completion, stop before promotion. A controlled staging cycle must:

1. back up and migrate the staging database;
2. deploy the exact application commit;
3. configure the existing staging cron with the staging-only attachment bucket values;
4. prove the cron cannot address live data or the live bucket;
5. send representative one-recipient and multi-recipient attachment jobs;
6. inspect Resend provider attachment/message-ID evidence;
7. inspect physical inbox attachments and clickable links;
8. simulate retry and interrupted cron recovery without duplicate accepted recipients;
9. repeat a links-only and no-resource batch regression; and
10. record the result before R8-A4 begins or production promotion is considered.

## 16. Exit Gate

R8-A3 is technically complete when:

```text
an exact immutable attachment message can be queued once,
processed asynchronously at the accepted rate,
retried without duplicating accepted recipients,
and reconciled to durable provider-acceptance evidence
```

Technical completion does not claim deployed provider proof; that remains the explicit
staging gate above and the broader R8-A5 outcome.

## 17. Business And Runtime Decisions

### 17.1 CC/BCC On Multi-Recipient Attachment Jobs

The ordinary route sends one provider request per primary recipient. Repeating the existing
CC/BCC values on every request means each CC/BCC address receives one copy for every primary
recipient and may see recipient-specific content repeatedly.

Decision accepted 2026-07-22:

```text
one primary recipient
-> CC/BCC permitted under the existing contract

more than one primary recipient
+ any CC or BCC address
-> fail closed before queue creation
```

This prevents accidental copy amplification without inventing summary-email content. A
future refinement may define a separate one-copy summary/audit-recipient contract.

### 17.2 Existing Cron Runtime And Accepted Delay

Decision accepted 2026-07-22:

```text
service: isostack-jobs
type: Render cron
new schedule: every minute
command: npm run jobs:tick
behaviour: existing processors first, then one bounded attachment-delivery chunk, then exit
```

No additional paid background-worker service is created. Attachment-bearing ad-hoc email is
queued immediately and normally completes in approximately two to three minutes for up to
300 recipients. This is accepted as the cost/reliability tradeoff.

Zero-attachment ad-hoc email remains immediate through the existing batch route; it does
not wait for cron. Existing sequence/key-date email becomes eligible on the nominal
one-minute cron schedule, subject to Render delaying a tick while the previous single cron
run is still completing.

Render Workflows remains excluded because the controlling plan does not accept a beta
orchestration dependency for this remediation.
