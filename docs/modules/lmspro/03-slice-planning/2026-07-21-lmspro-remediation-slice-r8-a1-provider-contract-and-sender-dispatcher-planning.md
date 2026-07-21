# LMSPro Remediation Slice R8-A1 - Provider Contract And Sender Dispatcher Planning

Date: 2026-07-21
Module: LMSPro / SeasonPro shared communications
Status: Implemented and technically reviewed; bounded exit gate passed
Type: Provider-contract and fail-closed routing remediation

Controlling plan:

`docs/modules/lmspro/03-slice-planning/2026-07-20-lmspro-remediation-slice-r8-a-attachment-aware-email-delivery-route-and-fail-closed-evidence-planning.md`

Related CR input:

`docs/modules/lmspro/01-cr-inputs/2026-07-20-lmspro-cr-attachment-aware-email-delivery-and-fail-closed-evidence-remediation-input.md`

## 1. Purpose

R8-A1 establishes one explicit delivery-mode contract before attachment persistence, job
processing or C1 progress UI are changed.

The slice must make these states unambiguous:

```text
zero durable attachments
-> BATCH
-> existing Resend /emails/batch sender

one or more durable attachments
-> ATTACHMENT_JOB
-> ordinary Resend /emails sender
-> one recipient per request
```

The existence of one recipient does not select the ordinary route. Durable attachment
presence selects it.

## 2. Accepted Parent Decisions

R8-A was accepted on 2026-07-21 with these controlling decisions:

- preserve the existing no-attachment batch route, including solitary recipients;
- attachment-bearing messages must never use Resend batch;
- Option B, short-lived signed paths to validated private objects, controls later attachment
  retrieval and delivery;
- no more than three attachments per message;
- no more than 10 MB cumulative attachment size;
- ordinary attachment delivery is asynchronous and initially throttled to three provider
  requests per second; and
- human UI smoke-test gates apply before a later slice is opened when a slice changes visible
  C1 behaviour.

R8-A1 does not implement storage signing, attachment validation, persistence mutation, jobs
or progress UI.

## 3. Repository Baseline

```text
repository: isostack-bedrock
branch: fix/lmspro-r8-a-attachment-delivery
base: origin/dev at e3f44b4b786c74dfcb177f01b3b00a09acf6bbb8

repository: isodocs
branch: fix/lmspro-r8-a-attachment-delivery
base: origin/main at 6190751662af45ebb00df6747ba8478e6945bf9b
accepted R8-A documentation commit: 3b92a7a
```

The documentation repository does not have an `origin/dev` branch.

## 4. Confirmed Starting Condition

The current shared sender:

- sends no-attachment and attachment-bearing ad-hoc emails through `sendBatchEmails`;
- includes an unsupported `attachments` property in batch payloads;
- documents an obsolete/non-authoritative 25-requests-per-second assumption; and
- already has an ordinary `/emails` function, but not a dedicated remote-path adapter with
  the attachment-job contract.

The current ad-hoc router must not continue silently through batch while later R8-A slices
are under construction.

## 5. Included Scope

- define a stable `BATCH` versus `ATTACHMENT_JOB` delivery mode;
- select mode only from a validated non-negative durable attachment count;
- expose an explicit dispatcher/selection function to shared communications consumers;
- prevent `sendBatchEmails` from sending any non-empty attachment collection;
- keep zero-attachment batch payloads and batching behaviour otherwise unchanged;
- add a dedicated ordinary single-recipient adapter accepting remote attachment paths;
- ensure the adapter cannot be invoked with zero attachments;
- ensure the adapter posts to `/emails`, never `/emails/batch`;
- retain recipient-specific shortcode resolution and shared letterhead/branding;
- remove the unsupported attachment field from prepared batch payloads;
- correct comments that present 25 requests per second as provider authority;
- fail closed at the current ad-hoc send boundary until the durable job path exists; and
- add focused automated provider-contract tests.

## 6. Excluded Scope

- R2 authenticated reads or signed URL creation;
- attachment upload/update/delete remediation;
- count, MIME, content, checksum or cumulative-size validation;
- attachment-set fingerprinting;
- schema or migration changes;
- delivery jobs, workers, throttling or stale-claim recovery;
- per-recipient retry/idempotency persistence;
- C1 progress/history UI;
- key-date sequence attachments;
- deployed Resend proof; and
- broad refactoring of transactional or no-attachment sending.

## 7. Proposed Code Surfaces

```text
src/core/services/communications/lib/email-delivery-contract.ts
src/core/services/communications/lib/email-delivery-contract.test.ts
src/core/services/communications/lib/send-email.ts
src/core/services/communications/lib/send-email.test.ts
src/core/services/communications/lib/index.ts
src/core/services/communications/index.ts
src/core/services/communications/routers/emails.router.ts
```

File names may adjust to existing conventions, but the contract must remain in shared
communications rather than an LMSPro-only service.

## 8. Delivery Mode Contract

The selector must behave deterministically:

| Durable attachment count | Mode             |
| ------------------------ | ---------------- |
| `0`                      | `BATCH`          |
| `1` to `3`               | `ATTACHMENT_JOB` |
| negative/non-integer     | reject           |
| above `3`                | reject           |

The upper bound is part of the accepted application contract even though full preflight is
implemented in R8-A2.

## 9. Ordinary Attachment Adapter Contract

The adapter receives one resolved recipient and one to three remote attachments:

```text
recipient + subject/body + tenant/module + signed attachment paths
-> resolve recipient shortcodes
-> apply shared tenant/module letterhead
-> POST one payload to Resend /emails
-> return provider acceptance ID or safe failure evidence
```

R8-A1 tests use representative signed URLs but do not mint them. R8-A2/R8-A3 own the
validated private-object and job integration.

The adapter must not:

- accept multiple primary recipients;
- call the batch endpoint;
- log signed URLs, attachment contents or the Resend API key;
- claim mailbox delivery from provider acceptance; or
- invent retries beyond the current bounded ordinary-send behaviour.

## 10. Transitional Fail-Closed Behaviour

Until R8-A3 connects durable attachment jobs, the ad-hoc send procedure should:

```text
inspect persisted EmailAttachment count
-> BATCH: continue existing batch send
-> ATTACHMENT_JOB: refuse synchronously with an explicit remediation-in-progress error
```

This temporarily prevents attachment delivery rather than continuing the confirmed silent
loss. It must not affect any email with zero persisted attachments.

The visible C1 workflow correction and durable attachment handling remain R8-A2 scope. If
this temporary refusal results in a visible error through the existing generic mutation
handling, it does not create a separate R8-A1 human smoke gate; the comprehensive compose UI
smoke gate follows R8-A2.

## 11. Automated Test Contract

### Selector

- zero selects `BATCH`;
- one, two and three select `ATTACHMENT_JOB`;
- negative, fractional, non-finite and above-three counts reject.

### Batch Guard And Regression

- a non-empty attachment collection never reaches `fetch`;
- zero attachments preserve `/emails/batch`;
- one no-attachment recipient still uses batch;
- 101 no-attachment recipients create two batch calls of at most 100;
- prepared batch payloads contain no `attachments` property; and
- no-attachment success/failure accounting remains intact.

### Ordinary Adapter

- one to three path attachments use `/emails` exactly once;
- payload contains the intended filename/path pairs;
- zero or more than three attachments reject before provider access;
- recipient shortcode resolution is preserved;
- provider success ID is returned;
- provider error becomes safe failure evidence; and
- the batch endpoint is never called.

### Static/Type Checks

- targeted Vitest suite;
- full TypeScript type-check; and
- repository critical-file verification.

## 12. Exit Gate

R8-A1 is complete when:

```text
zero attachments can only select BATCH
one to three attachments can only select ATTACHMENT_JOB/ordinary sender
unsupported attachment counts fail closed
no attachment-bearing payload can reach Resend batch
```

Completion also requires:

- automated tests passing;
- an implementation confirmation in `04-implementation-confirmations`;
- technical review/test evidence in `05-review-and-test`;
- clean commits in both dedicated repositories; and
- the roadmap advanced to R8-A2 only after R8-A1 evidence is complete.

## 13. Human Test Gate

R8-A1 introduces no new supported UI workflow and therefore does not require a standalone
human UI smoke test before planning R8-A2.

R8-A2 changes draft attachment behaviour, validation and visible failure handling. Its
review document must define the human smoke script, and progress must pause for the reported
result before R8-A3 planning is created.
