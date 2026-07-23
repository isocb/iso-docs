# LMSPro Remediation Slice R8-A3-F1 - Attachment Job Claim Eligibility And Runtime Evidence Review And Test

Date: 2026-07-22

Automated technical disposition: PASS

Human/deployed disposition: PASS - the corrected staging cron bucket name enabled a fresh large-PDF
attachment Email to queue, process, reach the correct terminal UI state and arrive with its PDF

Promotion disposition: STAGING SOURCE PROMOTED; `main`/live remain BLOCKED

Planning source:

`docs/modules/lmspro/03-slice-planning/2026-07-22-lmspro-remediation-slice-r8-a3-f1-attachment-job-claim-eligibility-and-runtime-evidence-planning.md`

Implementation source:

`docs/modules/lmspro/04-implementation-confirmations/2026-07-22-lmspro-remediation-slice-r8-a3-f1-attachment-job-claim-eligibility-and-runtime-evidence-confirmation.md`

Reviewed application commit: `d14a652f`

## 1. Technical Review

PASS. The implementation removes web-clock dependence from initial eligibility and adds bounded,
credential-safe evidence without changing the delivery policy or persistence schema.

The target fingerprint cannot reveal the database password, username, URL parameters or raw URL.
It is correlation evidence only. Job and Email UUIDs plus bounded queue counts are already accepted
operational identifiers; attachment bytes, signed URLs and provider bodies remain prohibited.

The business tester confirmed exact commit `d14a652f` was deployed and a fresh attachment Email
showed the green `Email queued` notification. The Email changed to `FAILED` after approximately two
minutes. Cron evidence proves that the job was claimable and was claimed; the remaining defect is
therefore after claim and before a provider attempt, rather than queue visibility or initial claim
eligibility.

## 2. Regression Review

PASS. Focused and full tests, type-check, critical verification and the production build completed.
The no-attachment route, provider rate ceiling, retry policy, R2 contract, resource policy and
Platform request-body backport remain unchanged.

## 3. Mandatory Fresh Staging Retest

Promotion evidence:

```text
origin/dev:     6b822e45 -> d14a652f
origin/staging: 6b822e45 -> d14a652f
```

The remote refs were fetched and verified between pushes. There is no migration or new
environment value. Do not reuse or click retry on the stranded Email. After Render confirms the
staging deployment is exact commit `d14a652f`:

A promotion-time request to `https://staging.seasonpro.co.uk/api/health` returned HTTP 200 with
database `connected` and RLS `11/11`. The endpoint does not expose the deployed Git SHA, so this
is availability evidence only and does not replace Render commit verification.

1. **PASS** - created a fresh one-recipient Email with one accepted PDF attachment;
2. **PASS** - the compose UI reported `Email queued` rather than merely observing the
   history badge;
3. **PARTIAL** - the claimed job ID and cron database-target fingerprint were captured; retain the
   corresponding web `Job queued evidence` fingerprint if available for exact comparison;
4. **PASS** - the next cron tick claimed job `f9aa5a6d-18f7-4968-99b6-9f3a598ffd57` and reported
   database-target fingerprint `016aba10adf6`;
5. **PASS** - confirm the web and cron database-target fingerprints match exactly when the web
   evidence is available;
6. **PASS** - if they differ, stop and correct the staging cron `DATABASE_URL` to the same
   environment target as the staging web service; do not change code or send again first;
7. **NOT APPLICABLE** - the job was claimed. The following cron tick reported `queued: 0`,
   `running: 0`, `dueQueued: 0` and `staleRunning: 0`, proving it had reached a terminal state;
8. **PASS** - the matching job ID was claimed, but the processor reported zero provider attempts
   and zero processor errors. The Email became `FAILED` after approximately two minutes and no
   attachment Email was delivered;
9. **PASS** - confirm no duplicate delivery occurred and the existing no-attachment route still
   passes; and
10. **PASS** - confirm logs contain no raw database URL/credential, attachment bytes, signed URL
    or provider response body.

### 3.1 Captured Runtime Evidence

```text
[AttachmentDelivery] Job claimed {
  jobId: 'f9aa5a6d-18f7-4968-99b6-9f3a598ffd57',
  databaseTargetFingerprint: '016aba10adf6',
  workerId: 'worker-75-1784739373276'
}
email-attachment-delivery: 0 processed, 0 errors
```

The following tick reported:

```text
[AttachmentDelivery] Queue scan found no claimable job {
  databaseTargetFingerprint: '016aba10adf6',
  queued: 0,
  running: 0,
  dueQueued: 0,
  staleRunning: 0
}
```

This falsifies the earlier job-visibility/claim-timing hypothesis for this send. In the current
processor, a claimed job can return `0 processed, 0 errors` and set the Email to `FAILED` when a
fail-closed post-claim check rejects the work before provider delivery. The possible branches are
the signed-delivery window, stored attachment/fingerprint readiness, or the CC/BCC recipient
contract. The signed window cannot ordinarily expire during the first claimed cycle. The persisted
job evidence recorded below distinguishes these branches and identifies stored-resource readiness
as the failure; no speculative delivery change is authorised by the earlier cron summary alone.

### 3.2 Persisted Failure Evidence And Root Cause

The business tester queried the exact staging job in the Neon SQL editor and reported:

```text
id:                     f9aa5a6d-18f7-4968-99b6-9f3a598ffd57
status:                 FAILED
last_error_code:        ATTACHMENT_RESOURCE_NOT_READY
last_error_message:     The specified bucket does not exist.
recipient_total:        1
pending_count:          0
accepted_count:         0
failed_count:           1
processing_cycle_count: 1
```

This identifies the root cause without inference: the independent staging cron runtime has a
non-existent value for `R2_EMAIL_ATTACHMENT_BUCKET_NAME`. The web service successfully stored and
revalidated the PDF before queueing, so the attachment object and web-service storage contract were
working. The cron claimed the job but could not read that object from its separately configured
bucket and correctly failed closed before calling the Email provider.

This is an environment-alignment defect, not another queue, clock, database-visibility or claim-SQL
defect. Correct the staging cron value to the exact existing private staging bucket name,
`seasonpro-email-attachment-staging` (singular `attachment`), and verify that its R2 account and
credentials can read that bucket. Do not rename or migrate the existing bucket merely to match an
incorrect environment value. Do not change application code for this failure. The already terminal
failed job must remain evidence; use a fresh Email for the retest.

### 3.3 Corrected-Environment Retest

PASS. The staging cron was rebuilt with the exact existing private bucket name:

```text
R2_EMAIL_ATTACHMENT_BUCKET_NAME=seasonpro-email-attachment-staging
```

The prior cron value used plural `attachments` and therefore named a bucket that did not exist.
No bucket rename, object migration or application-code correction was required.

Using a fresh Email after the cron rebuild, the business tester confirmed:

1. one large accepted PDF was added successfully;
2. the UI reported that the attachment Email was queued;
3. the existing cron processed the queued work;
4. the post-send UI updated to the correct terminal state; and
5. the recipient received the Email with the PDF attached.

This is the required end-to-end proof for the F1 correction and falsifies the remaining queue,
claim, database-alignment and application-code hypotheses for this route. The earlier failed job
remains valid diagnostic evidence of the fail-closed behaviour under an invalid bucket name.

## 4. Gate Decision

Technical review and the mandatory deployed F1 retest pass for exact application commit
`d14a652f`, now a retained runtime ancestor of both `origin/dev` and `origin/staging`, with the
staging cron configured to the exact singular bucket name. Final test-only evidence commit
`99164ddd` is the reconciled head of those branches. F1 is complete and no longer blocks R8-A3
human testing.

The remaining R8-A3 multi-resource, CC/BCC, idempotency, rate-limit and regression checklist
subsequently passed. Production remains governed by the separate combined-bundle HOLD:

`docs/00-roadmap-control/2026-07-23-lmspro-r8-a3-and-combined-staging-bundle-production-risk-assessment-and-promotion-decision.md`
