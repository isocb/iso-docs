# LMSPro Remediation Slice R8-A3-F1 - Attachment Job Claim Eligibility And Runtime Evidence Planning

Date: 2026-07-22

Module: LMSPro / shared communications runtime

Status: Corrective implementation authorised by failed R8-A3 staging item 11

Controlling parent:

`docs/modules/lmspro/03-slice-planning/2026-07-22-lmspro-remediation-slice-r8-a3-durable-attachment-delivery-job-rate-limiter-and-retry-planning.md`

Failure evidence:

`docs/platform/05-review-and-test/2026-07-22-isostack-core-platform-slice-plat-runtime-01-node-middleware-request-body-finalisation-backport-review-and-test.md`

## 1. Purpose

R8-A3-F1 owns the bounded correction required after a fresh attachment Email remained
`SENDING` and was not delivered while three healthy cron ticks reported
`email-attachment-delivery: 0 processed, 0 errors`.

The preceding Platform request-body correction is proven: accepted attachment drafts save and
rehydrate, and the HTML HTTP 500/locked-body signature did not recur. This follow-on therefore
returns ownership to the LMSPro/shared-communications delivery boundary.

## 2. Established Evidence And Remaining Uncertainty

The attachment queue transaction is atomic: a successful `ATTACHMENT_JOB` response commits the
Email `SENDING` state, one delivery job, exact delivery recipients and queue audit evidence
together. The business tester confirms that the fresh pre-correction send displayed:

```text
Email queued
Your attachment email is queued. Delivery normally completes within 2–3 minutes.
```

This proves that the web queue transaction returned successfully. The supplied cron evidence
therefore narrows the remaining fault to cron not seeing that job as claimable: initial due-time
eligibility, another persisted job state, or a different database target from the web runtime.

R2 or Resend failure is not the leading explanation. When either cron dependency is missing and
queued work is visible, the existing processor returns an error rather than the observed green
zero-work result.

## 3. Included Scope

- make a newly created attachment job immediately claimable using database-null due-time semantics
  rather than a web-runtime timestamp;
- add a credential-safe deterministic fingerprint for the configured database target;
- record that fingerprint with job ID, Email ID and bounded counts when the web queues work;
- record the same fingerprint plus bounded queue-state counts when cron finds no claimable job;
- record safe job-claim evidence when cron claims work;
- prove fingerprint redaction/stability and immediate-eligibility behaviour with focused tests;
- retain the existing one-job, 150-recipient and three-provider-starts-per-second bounds; and
- update implementation and review evidence without claiming a deployed PASS.

## 4. Excluded Scope

- changing the accepted file/link policy;
- changing R2, Resend or recipient-copy rules;
- creating a new worker/service;
- changing the no-attachment batch route;
- adding a schema migration or modifying persisted customer data;
- exposing a database URL, credential, attachment byte, signed URL or raw provider response;
- implementing the fuller R8-A4 progress/retry UI; and
- silently changing Render environment values.

## 5. Runtime Evidence Contract

The database-target fingerprint must be derived only from non-secret connection identity material
and hashed before logging. Passwords, query parameters and the raw URL must never be logged.

Expected correlation:

```text
web:  job queued + target fingerprint A
cron: queue scan/claim + target fingerprint A
```

Different fingerprints prove environment misalignment and require correction in Render before
another send. Matching fingerprints with a non-claimable job require inspection of the logged
bounded status counts and the job state. The fingerprint is diagnostic evidence, not an
authentication or tenant boundary.

## 6. Verification And Stop Gate

Implementation must pass:

- focused database-target fingerprint tests, including password/query redaction;
- focused queue eligibility and cron no-work/claim evidence tests;
- existing attachment delivery, resource, R2 and provider tests;
- full repository Vitest and type-check;
- production build and diff/static checks; and
- confirmation that no schema/migration/environment contract changed.

After technical review, stop before staging. Human staging retest must use a fresh attachment
Email, confirm the `Email queued` response, correlate the web and cron fingerprints, and prove the
same job becomes claimed and terminal. PLAT-RUNTIME-01 and R8-A3 remain blocked until that retest
passes.
