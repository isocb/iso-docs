# LMSPro Remediation Slice R8-A3 - Durable Attachment Delivery Job, Rate Limiter And Retry Confirmation

Date: 2026-07-22

Module: LMSPro / SeasonPro shared communications

Implementation status: Technically complete on dedicated branch; not merged or deployed

Planning source:

`docs/modules/lmspro/03-slice-planning/2026-07-22-lmspro-remediation-slice-r8-a3-durable-attachment-delivery-job-rate-limiter-and-retry-planning.md`

Application evidence:

```text
branch: fix/lmspro-r8-a3-cron-attachment-delivery
baseline: origin/dev at 6c5aaa56ffa33ab3bcc2102ff7da6cdc84fda4a4
implementation commit: 90974123
remote branch: origin/fix/lmspro-r8-a3-cron-attachment-delivery
```

## 1. Implemented Outcome

R8-A3 replaces the intentional attachment-send refusal with a durable queued route while
preserving immediate no-attachment delivery:

```text
zero attachments
-> existing synchronous Resend batch endpoint

one to three attachments
-> final private-resource proof
-> immutable delivery job and recipient payload snapshot
-> existing Render cron
-> one ordinary Resend request per primary recipient
-> durable recipient acceptance, retry and terminal evidence
```

No new paid background service, malware scanner, public attachment bucket or sequence
attachment-authoring path was introduced.

## 2. Persistence And Migration

Migration `20260722120000_lmspro_r8_a3_email_delivery_jobs` adds:

- `EmailDeliveryJobStatus`, `EmailDeliveryRecipientStatus` and
  `EmailDeliveryAttemptStatus` enums;
- one `EmailDeliveryJob` per attachment-bearing Email;
- one `EmailDeliveryRecipient` per exact primary recipient;
- immutable per-attempt evidence;
- unique Email/job, job/recipient and provider-idempotency constraints; and
- due-work, stale-lock and recipient-claim indexes.

Historic Emails are not backfilled. The migration has been schema-validated but has not
been applied to dev, staging or production by this implementation window.

## 3. Queue And Copy-Recipient Contract

The authenticated send mutation now:

- returns an existing job for an idempotent repeated request;
- re-proves the exact private attachment/link set;
- requires at least one primary recipient;
- allows CC/BCC for one primary recipient;
- fails closed before queueing when multiple primary recipients also have CC/BCC;
- resolves shortcodes, links and letterhead before queueing;
- stores a stable recipient-specific provider payload;
- atomically creates the job/recipients, changes Email to `SENDING` and records audit
  evidence; and
- returns `ATTACHMENT_JOB` rather than claiming that the Email was sent.

The compose UI reports `Email queued` with the accepted two-to-three-minute expectation.
No-attachment success copy remains `Email Sent`.

## 4. Existing Cron Runtime

The existing `isostack-jobs` cron is changed from five-minute to one-minute scheduling. Each
run preserves this order:

1. email sequences;
2. key-date sequences;
3. Commerce Stripe events; and
4. one attachment-delivery job.

The attachment processor claims work with PostgreSQL `FOR UPDATE SKIP LOCKED`, recovers
stale claims, processes at most 150 recipients per run and starts no more than three
ordinary provider requests per second. This supports the accepted representative
300-recipient job across approximately two cron cycles without creating another Render
service.

The Render cron definition now declares the four existing private-R2 environment values.
It never requires an `r2.dev` or custom public attachment domain.

## 5. Private Attachment And Provider Contract

The shared R2 utility now creates deterministic 30-minute signed GET paths using a fixed job
signing time. The path:

- uses only the dedicated private attachment bucket;
- pins the immutable R2 key and validated filename;
- is supplied only to Resend;
- is never returned to C1 or persisted; and
- is reproducible for a retry with the same provider idempotency key.

The new one-attempt adapter calls only `POST /emails`, includes the stable
`Idempotency-Key`, stores the provider message ID on acceptance and leaves all retry policy
to durable cron state. `429`, `409`, network and `5xx` outcomes are retryable; permanent
provider `4xx` outcomes fail closed. Retry is bounded to four attempts and the signed-path
window.

## 6. Verification Completed

The implementation window completed:

- Prisma format, validate and client generation: PASS;
- TypeScript type check: PASS;
- focused communications/R2 suite: 48 tests PASS;
- repository Vitest suite: 153 PASS, 12 pre-existing/intentional skips;
- standalone cron-processor import through `tsx`: PASS;
- repository critical-file verification: PASS;
- clean optimized Next production build: PASS; and
- `git diff --check`: PASS before commit.

`npm run lint` exits successfully but reports that `next lint` is deprecated and the Next
plugin is not detected. A direct ESLint invocation also confirms the existing test-project
exclusion and existing warnings in older communications files. R8-A3 introduces no
TypeScript or production-build failure; repository lint modernization remains governed by
the platform assurance lane.

## 7. Remaining Deployment Gate

This confirmation does not authorise promotion. Before deployed human smoke:

1. align the branch with current `origin/dev` if that baseline moves;
2. deploy the migration before code that queries the new tables;
3. confirm the existing cron has Resend and private-R2 variables;
4. confirm the cron schedule is one minute and overlapping runs are prevented by Render;
5. deploy the same reviewed commit to the controlled test environment; and
6. complete the linked human smoke record.

R8-A4 remains responsible for fuller C1 progress/history and manual partial-failure controls.
