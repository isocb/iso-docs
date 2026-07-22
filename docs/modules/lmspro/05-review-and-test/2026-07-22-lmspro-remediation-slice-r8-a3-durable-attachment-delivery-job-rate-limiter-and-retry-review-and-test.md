# LMSPro Remediation Slice R8-A3 - Durable Attachment Delivery Job, Rate Limiter And Retry Review And Test

Date: 2026-07-22

Technical review status: PASS

Deployed human UI/transport status: PENDING

Promotion status: Not authorised

Planning source:

`docs/modules/lmspro/03-slice-planning/2026-07-22-lmspro-remediation-slice-r8-a3-durable-attachment-delivery-job-rate-limiter-and-retry-planning.md`

Implementation source:

`docs/modules/lmspro/04-implementation-confirmations/2026-07-22-lmspro-remediation-slice-r8-a3-durable-attachment-delivery-job-rate-limiter-and-retry-confirmation.md`

## 1. Technical Review Result

The dedicated implementation branch proves the bounded R8-A3 contract:

- no-attachment messages remain on the existing immediate batch path;
- attachment-bearing browser requests stop after durable queue creation;
- job and recipient uniqueness prevent duplicate queueing;
- recipient payloads are resolved and snapshotted before queueing;
- one-recipient CC/BCC is permitted and multi-recipient CC/BCC fails closed;
- the existing cron remains the only asynchronous runtime;
- existing scheduled processors run before attachment work;
- each cron cycle claims one job and at most 150 due recipients;
- ordinary provider requests are rate-limited to three starts per second;
- accepted recipients cannot be selected again;
- transient outcomes receive bounded durable retry using the same idempotency key;
- private signed attachment paths are deterministic and expire after 30 minutes; and
- final Email totals are reconciled from recipient evidence.

## 2. Automated Evidence

```text
Prisma format/validate/generate: PASS
TypeScript: PASS
Focused tests: 48 PASS
Full Vitest: 153 PASS, 12 skipped
Critical-file verification: PASS
Clean Next production build: PASS
Whitespace/diff validation: PASS
```

The first build attempt was invalid evidence because two build commands overlapped and
produced an incomplete generated JSON file. The generated `.next` directory was isolated
and one clean build then completed successfully. No source correction was required for that
tooling incident.

## 3. Required Deployment Sequence

Use the normal controlled promotion sequence, but maintain this hard order within the test
environment:

1. deploy `20260722120000_lmspro_r8_a3_email_delivery_jobs` to the environment database;
2. confirm migration success before the web or cron process starts querying new tables;
3. configure the existing cron with `DATABASE_URL`, `RESEND_API_KEY`, `EMAIL_FROM`,
   `R2_ACCOUNT_ID`, `R2_ACCESS_KEY_ID`, `R2_SECRET_ACCESS_KEY` and
   `R2_EMAIL_ATTACHMENT_BUCKET_NAME`;
4. confirm the attachment bucket remains private with no `r2.dev` or custom public domain;
5. deploy the reviewed application commit to the web and existing cron runtime; and
6. confirm cron logs show the existing processors before `email-attachment-delivery`.

Do not create a second Render service. Do not point the cron at the production attachment
bucket while testing staging.

## 4. Human UI And Transport Smoke

Use controlled recipients and fresh drafts. Record each result independently:

1. send a no-attachment ad-hoc Email and confirm it is delivered immediately through the
   existing batch route;
2. send a one-recipient Email with one accepted attachment and confirm the UI says
   `Email queued`, not `Email Sent`;
3. confirm the cron claims the job on its one-minute schedule and the received Email contains
   the exact attachment;
4. repeat with three accepted attachments totalling no more than 10 MB and three HTTPS links;
5. confirm all attachments are present and all links are clickable;
6. send one primary recipient with controlled CC and BCC addresses and confirm each receives
   exactly one copy;
7. prepare multiple primary recipients with CC or BCC and confirm queueing fails closed with
   the explicit copy-recipient guidance and no Email is sent;
8. repeat the send action for an already queued attachment Email and confirm no second job or
   duplicate recipient delivery is created;
9. confirm the Email remains `SENDING` while queued and becomes `SENT` only after terminal
   recipient reconciliation;
10. confirm cron/application/audit evidence contains job/count/status identifiers but no API
    key, attachment bytes, signed URL or raw provider body;
11. observe a representative bounded multi-recipient test and confirm provider starts do not
    exceed three per second; and
12. repeat the no-attachment batch smoke after all attachment checks.

The full 300-recipient case may use an approved controlled load fixture rather than real
business recipients. It should demonstrate two 150-recipient cron chunks and the accepted
approximately two-to-three-minute completion envelope without duplicate acceptance.

## 5. Failure And Recovery Checks

Where the controlled environment permits safe simulation:

- cause a transient provider/network failure and confirm `RETRY_SCHEDULED`, later acceptance
  and one stable provider idempotency key;
- interrupt a claimed test job before recipient reconciliation and confirm stale recovery
  does not duplicate provider acceptance;
- remove one test object's readability before queueing and confirm no job is created;
- make an object unavailable after queueing and confirm the job fails closed without claiming
  successful delivery; and
- confirm a job cannot retry after its 30-minute private-path window.

These simulations must use test recipients and test objects only.

## 6. Acceptance Gate

Record the human result in this document. Do not merge or promote beyond the controlled test
environment until all mandatory items pass or a specifically bounded defect slice is opened.
Minor unrelated UI observations may be deferred, but missing attachments, duplicate
recipients, incorrect CC/BCC copies, premature `SENT` state, public object exposure or leaked
signed URLs are blocking failures.
