# LMSPro Remediation Slice R8-A3 - Durable Attachment Delivery Job, Rate Limiter And Retry Review And Test

Date: 2026-07-22

Technical review status: PASS

Deployed human UI/transport status: PASS — all mandatory human checks pass and the final
300-recipient scale/rate gate passes through a deterministic mocked-provider test

Promotion status: STAGING ONLY; runtime accepted at `d14a652f`, evidence reconciled at
test-only `99164ddd`; current combined `staging` to `main` bundle HOLD/NOT AUTHORISED

Resolved Platform dependency:

`docs/platform/03-slice-planning/2026-07-22-isostack-core-platform-slice-plat-runtime-01-node-middleware-request-body-finalisation-backport-planning.md`

Planning source:

`docs/modules/lmspro/03-slice-planning/2026-07-22-lmspro-remediation-slice-r8-a3-durable-attachment-delivery-job-rate-limiter-and-retry-planning.md`

Implementation source:

`docs/modules/lmspro/04-implementation-confirmations/2026-07-22-lmspro-remediation-slice-r8-a3-durable-attachment-delivery-job-rate-limiter-and-retry-confirmation.md`

Staging promotion source:

`docs/00-roadmap-control/2026-07-22-lmspro-r8-a3-dev-staging-promotion-and-migration-confirmation.md`

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

### 2.1 Non-Delivery Scale And Rate Proof

On 2026-07-23 a test-only deterministic worker simulation exercised 300 synthetic recipients
without calling Resend, R2 or any external network:

```text
provider transport: injected mock
real fetch/network calls: 0
cycle 1: 150 recipients processed
cycle 2: 150 recipients processed
unique recipient addresses: 300
unique idempotency keys: 300
duplicate recipient processing: 0
rolling one-second provider starts: maximum 3
terminal job state: SUCCEEDED
accepted/pending/failed: 300/0/0
focused worker tests: 2 PASS
adjacent delivery-contract tests: 22 PASS across 4 files
full Vitest: 162 PASS, 12 intentionally skipped
TypeScript: PASS
critical-file verification: PASS
focused Prettier and diff validation: PASS
```

The simulation used fake time, a mocked Prisma queue, mocked private-path signing and an injected
provider attempt function. A global `fetch` stub was configured to throw if reached and remained
unused. This proves the real worker's two 150-recipient cycles, pacing loop, recipient uniqueness,
idempotency separation and terminal reconciliation without sending any Email.

Focused ESLint reports the pre-existing platform assurance limitation: this
`scripts/**/*.test.ts` file is excluded by the normal lint pattern and is not included in the
typed ESLint project when forced with `--no-ignore`. This is not a new source/test failure and
remains governed by PLAT-ASSURE-01.

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

1. **PASS** — a no-attachment ad-hoc Email was delivered immediately through the existing
   batch route.
2. **PASS** — a fresh one-recipient Email with one large accepted PDF displayed the explicit
   `Email queued` confirmation.
3. **PASS** — after correcting the staging cron's private-bucket name, the existing cron processed
   the queued job, the UI reached the correct terminal state and the recipient received the Email
   with the PDF attached.

4. **PASS** — three permitted attachments totalling no more than 10 MB and three HTTPS links were
   accepted and sent together;
5. **PASS** — all three attachments arrived intact and all three links were clickable;
6. **PASS** — one primary recipient with controlled CC and BCC addresses delivered exactly one
   copy to each intended address. Moving the initially missed `Add CC/BCC` control into the
   Recipients tab remains a non-blocking discoverability wishlist item;
7. **PASS** — multiple primary recipients with CC/BCC failed closed and no Email was sent;
8. **PASS** — duplicate queue prevention passed, and intentional manual send-again through
   `Duplicate to Draft` also delivered successfully under a new Email/delivery identity without
   mutating the original sent Email;
9. **PASS** — the UI remained `SENDING` while queued and updated correctly after terminal
   background delivery;
10. **PASS** — reviewed cron/application evidence contained bounded job/count/status identifiers
    without API keys, attachment bytes, signed URLs or raw provider bodies;
11. **PASS** — a controlled four-primary-recipient delivery passed, and the deterministic
    no-network worker simulation proved 300 unique recipients across two 150-recipient cycles
    with no more than three mocked provider starts in any rolling one-second window;
12. **PASS** — the final no-attachment Email used the existing immediate batch route successfully.

The accepted full 300-recipient case used the deterministic mocked-provider fixture rather than
real business recipients. It demonstrated two 150-recipient cycles without duplicate acceptance
or any external provider request.

### 4.1 Required Manual Send-Again Smoke

The historic three-dot-menu resend requirement is satisfied through the safer immutable-history
pattern now labelled `Duplicate to Draft`. The business tester reports the complete send-again
smoke PASS:

1. **PASS** open the three-dot menu on a successfully sent Email and choose `Duplicate to Draft`;
2. **PASS** confirm a new editable draft opens and the original Email remains unchanged;
3. **PASS** confirm subject, body, recipients, validated attachments and links are copied;
4. **PASS** change the primary recipient to an alternative controlled address, or retain the
   original controlled address for an intentional second delivery;
5. **PASS** review and acknowledge the copied resources, then send the new draft;
6. **PASS** confirm the new Email has its own history row/status and reaches the intended recipient once;
7. **PASS** confirm the original Email and its recipient/provider evidence remain unchanged; and
8. **PASS** confirm no idempotency collision or suppression occurs between the original and new Email.

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

Human failure simulation was not run. This is recorded as **NOT RUN**, not as a human PASS. The
technical suite already supplies bounded retry, idempotency, stale-claim, resource-readiness and
expiry evidence. Because this section is explicitly conditional on what the controlled environment
can simulate safely, the absence of destructive human simulation does not require unsafe staging
interference.

## 6. Acceptance Gate

Record the human result in this document. Do not merge or promote beyond the controlled test
environment until all mandatory items pass or a specifically bounded defect slice is opened.
Minor unrelated UI observations may be deferred, but missing attachments, duplicate
recipients, incorrect CC/BCC copies, premature `SENT` state, public object exposure or leaked
signed URLs are blocking failures.

## 6A. Platform Runtime Blocker

Subsequent staging evidence established that a PDF-bearing draft request can fail before the
tRPC procedure with an HTML HTTP 500 and:

```text
TypeError: Response body object should not be disturbed or locked
at fromNodeNextRequest
at app/api/trpc/[trpc]/route
```

The installed `next@15.5.21` runtime contains the upstream unawaited Node middleware
request-body finalisation defect. Because all `/api/` requests traverse the shared middleware
boundary, ownership has moved to Platform corrective slice `PLAT-RUNTIME-01`. The cron reports
zero attachment jobs for this attempt because no draft/job was persisted; this is not evidence
that the R8-A3 worker rejected a queued job.

This blocker is closed. The Platform slice passed its automated and staging review, and the
accepted attachment drafts no longer reproduce the HTML HTTP 500 or disturbed-body signature.

Platform implementation and automated review pass at dedicated-branch application commit
`6b822e45`. That exact commit was subsequently fast-forwarded through `origin/dev` to
`origin/staging`. This R8-A3 block remains in force until the staging deployment is verified and
the Platform review record's mandatory human smoke passes.

The Platform request-body retest subsequently passed, but attachment delivery item 11 remained
failed: a fresh Email stayed `SENDING` while healthy cron ticks processed no attachment recipient.
Bounded corrective follow-on R8-A3-F1 is controlled by:

`docs/modules/lmspro/03-slice-planning/2026-07-22-lmspro-remediation-slice-r8-a3-f1-attachment-job-claim-eligibility-and-runtime-evidence-planning.md`

Its technical implementation passes at application commit `d14a652f`; that exact commit was
subsequently fast-forwarded through `origin/dev` to `origin/staging` and passed its fresh deployed
retest after the cron's bucket name was corrected.

## 6B. Closed R8-A3-F1 Environment Blocker

The F1 diagnostics proved the job was created and claimed, then failed closed with:

```text
ATTACHMENT_RESOURCE_NOT_READY
The specified bucket does not exist.
```

The staging cron used plural `seasonpro-email-attachments-staging`, while the existing private
bucket is singular `seasonpro-email-attachment-staging`. Correcting that environment value and
rebuilding the cron enabled the green large-PDF test recorded at items 2, 3 and 9. No application
code, schema, bucket rename or object migration was required for this final operational defect.

## 7. Required Staging-To-Live Environment Gate

Render environment values are not migrated by Git or Prisma. R8-A3 therefore requires a
separate configuration check for the actual cron services:

```text
staging cron: isostack-bedrock-1
live cron:    isostack-bedrock
```

Before continuing staging testing, confirm the Render service named
`isostack-bedrock-1` is of type **Cron Job** and has, directly or through an explicitly
identified Environment Group:

```text
DATABASE_URL
RESEND_API_KEY
EMAIL_FROM
R2_ACCOUNT_ID
R2_ACCESS_KEY_ID
R2_SECRET_ACCESS_KEY
R2_EMAIL_ATTACHMENT_BUCKET_NAME
```

The staging cron must use the same staging database target as the web service serving
`staging.seasonpro.co.uk` and the exact dedicated private staging attachment bucket:

```text
R2_EMAIL_ATTACHMENT_BUCKET_NAME=seasonpro-email-attachment-staging
```

The bucket name is singular. `PORT` is not attachment-delivery configuration. Do not add
`R2_PUBLIC_URL` or the general public `R2_BUCKET_NAME` for this private route.

Do not configure or change the live cron merely to complete staging testing. After every
mandatory staging test passes and live promotion is explicitly authorised, repeat the same
variable-name inventory on the live **Cron Job** `isostack-bedrock`, using only:

- the live database target;
- the exact private live attachment bucket name;
- the accepted live sender/provider values; and
- the accepted R2 credential, which may be shared only under the recorded business decision
  while the staging and live bucket names remain distinct.

The live environment gate must be completed immediately before the authorised `main`
promotion and followed by migration-before-code deployment, one controlled cron invocation,
live log review and a bounded delivery smoke. Documentation records variable names and
PASS/FAIL evidence only; it must never record secret values or complete database URLs.

The checked-in `render.yaml` currently calls the declared cron `isostack-jobs`, which does
not match the two actual Render service names above. Do not blindly synchronise that
Blueprint because it may create a second cron. Reconcile this naming/configuration drift in
a separate controlled infrastructure refinement.

## 8. Final Staging Gate Decision

PASS. R8-A3 technical evidence, deployed human UI/transport smoke, F1 correction, resource
delivery, CC/BCC controls, duplicate prevention, intentional `Duplicate to Draft` send-again,
status reconciliation, safe logs, immediate no-attachment regression and non-delivery
300-recipient pacing proof are complete.

R8-A3 is accepted at the staging boundary. This document does not itself authorise `main`/live
promotion. Production requires the separately controlled risk assessment, exact source and
documentation commit reconciliation, live cron environment inventory, migration-before-code
sequence and bounded post-deployment smoke described above.

Those reconciliation and risk-assessment steps are now complete:

`docs/00-roadmap-control/2026-07-23-lmspro-r8-a3-and-combined-staging-bundle-production-risk-assessment-and-promotion-decision.md`

The decision accepts R8-A3 for production in principle but places the current combined staging
bundle on HOLD because it includes 38 commits, 208 changed files and 17
Commerce/FUND/LMSPro migrations with outstanding cross-lane/live-data gates. No live promotion
or migration is authorised.
