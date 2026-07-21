# LMSPro CR Input - Attachment-Aware Email Delivery And Fail-Closed Evidence Remediation

Date: 2026-07-20
Module: LMSPro / SeasonPro
Source: Live C1 League Administrator ad-hoc email incident and follow-on code/Resend contract review
Status: Accepted as input to controlling remediation plan R8-A on 2026-07-21
Priority: High - silent communication-integrity failure

## Purpose

This CR records a live LMSPro communications defect in which a C1 League Administrator:

- composed an ad-hoc email;
- added an attachment through the visible attachment control;
- sent the email successfully; and
- later discovered that the delivered email did not contain the attachment.

The user received no warning that the attachment had not been delivered. The current
communications history and success feedback also did not distinguish a complete email from
an email accepted without its intended attachment.

The CR establishes a separate attachment-aware delivery route while preserving the
no-attachment Resend batch path that is already operating reliably in live use.

This document is a change-request input. It does not authorise application code, schema,
migration, infrastructure, deployment or production-data changes.

## Related Existing Communications Work

The current communications workflow was refined through LMSPro remediation lane R4:

```text
docs/modules/lmspro/01-cr-inputs/2026-07-06-lmspro-cr-communications-email-announcements-remediation-input.md
docs/modules/lmspro/03-slice-planning/2026-07-06-lmspro-remediation-slice-r4-b-communications-email-announcements-workflow-planning.md
docs/modules/lmspro/04-implementation-confirmations/2026-07-06-lmspro-remediation-slice-r4-b-communications-email-announcements-workflow-confirmation.md
docs/modules/lmspro/05-review-and-test/2026-07-06-lmspro-remediation-slice-r4-b-communications-email-announcements-workflow-review-and-smoke-test.md
```

R4 remains the accepted foundation for email composition, cohort resolution, drafts,
duplication, history and no-attachment batch sending. This CR does not reopen those outcomes
generally. It captures an attachment-specific gap that the R4 smoke scope did not prove.

## Incident Statement

The observed live behaviour was:

```text
C1 sees attachment in compose
-> C1 sends email
-> email body is delivered
-> attachment is absent
-> LMSPro reports success
```

This is more serious than a normal failed send because the system represents an incomplete
communication as complete. A recipient may reasonably act on the email without knowing that
essential supporting material was omitted.

## Confirmed Technical Finding

The current ad-hoc send path loads any persisted `EmailAttachment` records and passes them to
the shared `sendBatchEmails` service. That service constructs attachment payloads but sends
them through Resend's batch endpoint:

```text
src/core/services/communications/routers/emails.router.ts
src/core/services/communications/lib/send-email.ts
```

Resend's current published contract states:

- the batch endpoint supports up to 100 emails in one request; and
- the `attachments` field is not supported by the batch endpoint.

References checked on 2026-07-20:

- <https://resend.com/docs/dashboard/emails/batch-sending>
- <https://resend.com/docs/dashboard/emails/attachments>
- <https://resend.com/docs/api-reference/emails/send-email>

Therefore, the current implementation cannot provide a supported attachment-delivery
contract even when upload, persistence and storage retrieval all succeed.

## Additional Confirmed Silent-Loss Paths

The unsupported batch contract is the first-order blocker. The following findings are not
alternative reasons to postpone that correction. They are requirements that must be closed
inside the new attachment route so it cannot continue to fail silently after moving to the
ordinary endpoint.

### Attachment Upload Failure

`emails.router.ts` currently catches an R2 upload or `EmailAttachment` creation failure,
logs it to the server console and continues creating/sending the email.

The audit metadata records the number of attachments requested by the browser rather than
the number successfully persisted. Requested and durable attachment evidence can therefore
disagree.

### Attachment Retrieval Failure

Before sending, the current router fetches each attachment using its stored public R2 URL.
A failed response or exception is converted to `null`, filtered out and not surfaced to the
C1 sender. The email can then continue with fewer attachments or none.

### Reopened Draft Attachment Loss

The compose modal builds an attachment payload, but the email update schema/path does not
accept attachment changes. A C1 user can therefore reopen a draft, add an attachment in the
browser and send while that new attachment is not persisted.

### Unqualified Success Feedback

The compose UI reports `Email Sent` after the send mutation returns. It does not prove that:

- every requested attachment was persisted;
- every persisted attachment was readable;
- the provider accepted the intended attachments; or
- all recipients were accepted successfully.

## Settled Delivery Decisions

The following decisions control later planning:

1. The existing Resend batch path remains the delivery path for emails with no attachments.
2. This includes a no-attachment email with only one recipient; solitary delivery alone does
   not move an email away from the proven batch path.
3. The batch path must not be broadly refactored as part of attachment remediation.
4. An email with one or more successfully persisted attachments uses a separate
   attachment-aware delivery route.
5. The attachment-aware route uses Resend's ordinary `/emails` endpoint, with one recipient
   per provider request.
6. Large recipient groups, including approximately 300 recipients, are a supported LMSPro
   operating case.
7. Attachment delivery must be asynchronous, rate-controlled, resumable and observable; it
   must not hold one browser request open while all recipients are processed.
8. The dispatch decision is made from durable server-side attachment evidence, not a browser
   flag or local compose state.
9. An attachment-bearing email fails closed if any intended attachment is missing,
   unvalidated or unreadable.
10. C1 must see queued, sending, completed, partially failed or failed state rather than an
    unconditional immediate success message.
11. Existing no-attachment live behaviour receives explicit regression protection.
12. The shared communications architecture remains authoritative; this is not a second
    LMSPro-only email subsystem.

## Required Sender Selection Contract

The required high-level contract is:

```text
finalised Email
-> inspect durable EmailAttachment set

no attachments
-> existing sendBatchEmails path
-> Resend batch endpoint

one or more attachments
-> validate exact immutable attachment set
-> queue attachment delivery job
-> ordinary Resend /emails endpoint
-> one recipient per request
-> rate limit, retry and record each result
```

The sender must not infer attachment presence only from the original create/update payload.

## Capacity And Provider Constraints

Resend's published default API rate limit is currently five requests per second per team,
shared across the team's API keys. The actual team limit must be read from account settings
and provider response headers:

- `ratelimit-limit`;
- `ratelimit-remaining`;
- `ratelimit-reset`; and
- `retry-after`.

Reference:

- <https://resend.com/docs/api-reference/rate-limit>

At three ordinary sends per second, 300 recipients have a nominal provider-request duration
of approximately 100 seconds before retries and other overhead. That is practical as a
background job but unsuitable as a synchronous dashboard request.

The current sender comment referring to a 25-request-per-second limit must not be treated as
provider authority. Initial planning should reserve capacity for password reset,
verification and other transactional messages rather than consume the complete team rate
limit with one League broadcast.

## Attachment Size And Type Contract

Resend currently limits the complete email to 40 MB after Base64 encoding. A 25 MB binary
file becomes approximately 33.3 MB when Base64 encoded before body and envelope overhead.

The later slice must define:

- an accepted application-level maximum below the provider envelope;
- whether a lower maximum applies to multi-recipient sends;
- cumulative attachment size rules;
- approved file types and extension/content inspection;
- user-facing refusal before queueing;
- whether content is sent as Base64 or through a controlled short-lived remote path; and
- safe treatment of private R2 objects.

The current 25 MB browser/storage limit must not automatically be accepted as the final
multi-recipient operating limit.

### Accepted File, Malware And Shared-Link Clarification

Accepted on 2026-07-21:

- retain broad, explicit support for ordinary Office documents, approved images, PDF,
  text/CSV and ZIP within the accepted three-uploaded-attachment/10 MB operating envelope;
- inspect actual content/type and require a successful malware result of `CLEAN` before any
  SeasonPro-managed upload can be finalised or sent;
- fail closed for infected, scanner-error, encrypted/password-protected or otherwise
  unscannable content;
- allow a C1 SeasonPro Administrator to add a labelled HTTPS link to a suitably shared cloud
  document, including Google Docs;
- model that destination as an externally hosted supporting link rather than a provider
  attachment or SeasonPro-managed binary;
- do not fetch, copy, scan, permission-test or guarantee the availability/content of the
  external resource; and
- keep an email containing links but no managed binary attachment on the proven batch route,
  with the controlled links rendered into the email body; and
- place an explicit acknowledgement beside the file/link controls stating that the C1
  SeasonPro Administrator is responsible for the integrity, suitability and sharing
  permissions of every supplied file or link.

The acknowledgement must not weaken SeasonPro's validation and malware-scanning obligations
for managed uploads. Accepted on 2026-07-21, R8-A2 will use a dedicated private ClamAV
service on Render and must prove its availability, definition health and fail-closed
behaviour before broad files can be marked validated. A message may contain up to three
uploaded attachments plus up to three external links.

## Persistence And Fail-Closed Evidence

Before an attachment email can enter `QUEUED`, the server must prove:

```text
intended attachment count
= persisted attachment count
= validated attachment count
= readable attachment count
```

The exact attachment set should be immutable for the queued send and should record at least:

- durable storage identity/key;
- original filename;
- accepted MIME/type evidence;
- binary size;
- checksum or content fingerprint;
- tenant ownership;
- email ownership; and
- validated/readable state or equivalent evidence.

The job should retain the attachment-set fingerprint so an object cannot be replaced or
silently changed while recipients are being processed.

## Recipient Delivery And Retry Requirements

The attachment route must:

- send one recipient through each ordinary provider request;
- retain existing per-recipient shortcode resolution and tenant branding;
- use a configurable shared rate limiter below the confirmed provider/account limit;
- honour provider `429` response headers;
- retry bounded transient failures with backoff;
- not retry permanent validation/type/size failures as though they were transient;
- never resend recipients already accepted successfully;
- use a stable per-recipient idempotency key where supported;
- recover stale claims after worker interruption; and
- retain safe provider message identifiers and failure codes.

`Accepted by Resend` is not the same as final mailbox delivery. Delivery/bounce webhook
expansion may be planned separately, but the UI must not describe provider acceptance more
strongly than the available evidence permits.

## C1 Experience

For an attachment-bearing send, C1 should see a lifecycle such as:

```text
Preparing attachments
Queued
Sending - 126 of 300
Completed - 300 accepted
Partially completed - 297 accepted, 3 failed
Failed - no recipients accepted
```

C1 must also be able to see:

- exact attachment names and sizes pinned to the email;
- recipient totals;
- accepted/failed counts;
- whether retry is available;
- a safe reason when queueing or sending is blocked; and
- final attachment evidence in communication history.

Closing the browser must not cancel or duplicate the queued job.

## Draft And Duplicate Behaviour

The remedial route must reconcile attachments across:

- a newly composed ad-hoc email;
- Save Draft;
- reopen/edit draft;
- remove/replace/add attachment while still editable;
- duplicate sent email to draft; and
- send from a duplicated draft.

The UI must display durable stored attachments separately from files still being prepared in
the browser. Sending is unavailable until every intended attachment is durably ready.

Duplicating attachment metadata must not create unsafe shared lifecycle semantics. Planning
must decide whether a duplicated draft:

- references the same immutable stored object safely; or
- creates an independent managed-object association without duplicating the binary.

## Key-Date Sequence Boundary

The current `EmailSequenceStep` schema, CRUD and key-date worker do not provide an attachment
field or attachment send contract.

Adding attachments to key-date sequence authoring is not part of the first ad-hoc attachment
remediation slice. The new ordinary-endpoint sender should be reusable later, but sequence
attachment support requires a separate decision covering:

- attachment versioning across recurring/seasonal sends;
- sequence-step editing and immutability;
- cron/worker R2 configuration;
- validation before the due date;
- failure/re-arm behaviour; and
- C1 visibility of sequence attachment readiness.

## Security And Storage Boundary

Email attachments may contain personal, club, competition or child-related information.
The slice must not require permanent public R2 readability merely so the application can
read its own objects.

Planning should prefer:

- authenticated object retrieval by durable R2 key; or
- a narrowly scoped short-lived signed GET when provider remote-path delivery is accepted.

The raw public storage URL must not become the durable access-control contract.

Retention and deletion behaviour must also avoid breaking historic sent-email evidence or
future retry attempts.

## Acceptance Principles

The remediation is successful when:

- every no-attachment email continues to use the existing batch route;
- batch behaviour remains unchanged for one, ten, 100 and 300 no-attachment recipients;
- every attachment-bearing email bypasses the batch endpoint;
- an attachment-bearing send can reach at least 300 recipients through queued ordinary
  sends without keeping the browser request open;
- all attachments are validated, persisted and readable before queueing;
- no requested attachment can be silently removed from the final send;
- reopened and duplicated drafts display and persist their exact attachment set;
- provider rate limits and `429` responses are handled safely;
- successful recipients are not duplicated during retry or crash recovery;
- C1 sees accurate progress, attachment evidence and partial/failed outcomes;
- tenant boundaries apply to email, recipient, job and attachment access;
- Resend dashboard/provider evidence confirms the expected attachment on representative
  sent messages; and
- targeted automated, staging and physical-inbox tests cover the failure modes that escaped
  R4 smoke testing.

## Out Of Scope For The First Remedial Slice

- replacing Resend;
- changing the proven no-attachment batch payload or cohort resolution;
- changing announcement targeting;
- adding attachments to key-date sequence authoring;
- redesigning all generic managed media;
- adding marketing contacts/broadcasts;
- introducing final mailbox-delivery webhooks unless required for safe existing status
  semantics; and
- automatically resending historic incomplete emails.

## Operational Follow-Up For The Reported Incident

When the exact incident email subject/time is available, operational review should compare:

- requested attachment count in audit metadata;
- actual `EmailAttachment` rows;
- R2 object existence/readability;
- Render log messages for upload/fetch failure;
- Resend sent-email attachment evidence; and
- whether the message was new or reopened from a draft.

This investigation is useful for incident evidence, but it does not change the confirmed
need to remove attachment-bearing sends from the unsupported batch endpoint.

## Proposed Planning Slice

```text
LMSPro Remediation Slice R8-A
Attachment-Aware Email Delivery Route And Fail-Closed Evidence
```

Planning document:

```text
docs/modules/lmspro/03-slice-planning/2026-07-20-lmspro-remediation-slice-r8-a-attachment-aware-email-delivery-route-and-fail-closed-evidence-planning.md
```

R8-A remains planning-only until reviewed and explicitly accepted through the controlled
LMSPro delivery cycle.

## Open Planning Questions

1. What is the current Resend team rate limit and paid-plan quota in the target environment?
2. Should the initial worker rate be three requests per second, or lower to reserve more
   transactional capacity?
3. Should one immutable attachment object be referenced by duplicated drafts, or should the
   association create a separately retained object version?
4. What retention period applies to sent-email attachments and delivery-attempt evidence?
5. Which C1 roles may retry a partially failed attachment job?
6. Is explicit cancellation required after queueing but before the first recipient send?
7. Should key-date sequence attachment authoring become a later R8-B candidate after R8-A is
   proven?
