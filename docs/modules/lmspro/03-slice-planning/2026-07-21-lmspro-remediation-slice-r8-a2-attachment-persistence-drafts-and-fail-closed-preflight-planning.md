# LMSPro Remediation Slice R8-A2 - Attachment Persistence, Drafts And Fail-Closed Preflight Planning

Date: 2026-07-21
Module: LMSPro / SeasonPro shared communications
Status: Planning complete; implementation paused for the explicit attachment security-policy decision in section 16
Type: Durable attachment lifecycle and visible fail-closed remediation

Controlling parent:

`docs/modules/lmspro/03-slice-planning/2026-07-20-lmspro-remediation-slice-r8-a-attachment-aware-email-delivery-route-and-fail-closed-evidence-planning.md`

Completed prerequisite:

`docs/modules/lmspro/05-review-and-test/2026-07-21-lmspro-remediation-slice-r8-a1-provider-contract-and-sender-dispatcher-review-and-test.md`

Related CR input:

`docs/modules/lmspro/01-cr-inputs/2026-07-20-lmspro-cr-attachment-aware-email-delivery-and-fail-closed-evidence-remediation-input.md`

## 1. Purpose

R8-A2 makes the attachment set shown to C1 identical to the durable, validated and readable
attachment set that a later delivery job will pin.

The exit equation is:

```text
intended count
= persisted active association count
= validated count
= storage-readable count
```

The slice corrects the live silent-loss paths before R8-A3 introduces queued delivery.

## 2. Accepted Parent Decisions

The following are already settled and must not be reopened in R8-A2:

- no more than three attachments per email;
- no more than 10 MB cumulative binary size;
- Option B: short-lived signed delivery paths to validated private objects;
- permanent public R2 URLs are not the attachment security contract;
- delivery mode derives from durable server-side attachment evidence;
- attachment-bearing sends fail closed;
- no-attachment batch behaviour remains unchanged; and
- key-date sequence attachment authoring remains outside R8-A.

## 3. Repository Baseline

```text
application repository
branch: fix/lmspro-r8-a-attachment-delivery
current R8-A1 head: 135f6c79
base: origin/dev at e3f44b4b

documentation repository
branch: fix/lmspro-r8-a-attachment-delivery
R8-A1 close-out: e4110d8
base: origin/main at 6190751
```

## 4. Confirmed Current Failures

### Create Upload Failure Is Swallowed

The router creates the Email and recipients first, then catches each upload/record failure and
continues. Audit metadata records browser-requested count rather than durable count.

### Update Does Not Accept Attachments

The compose modal includes local attachment data in its payload builder, but omits it from
the update mutation. A reopened draft can show a newly selected browser-only file that is
never persisted.

### Reopened Drafts Do Not Hydrate Attachments

`toComposeDraft` does not map returned `EmailAttachment` records and the modal initialisation
does not set them. Existing durable attachments therefore disappear from the editable UI.

### Browser And Service Limits Disagree With The Accepted Contract

Current UI and storage helpers allow up to ten files and 25 MB. The accepted R8-A contract is
three files and 10 MB cumulative.

### Type Evidence Uses Filename Extension

The browser MIME claim is submitted, but storage derives MIME from filename extension. The
actual bytes are not inspected and extension/content agreement is not proven.

### Current Email Attachments Use A Public Bucket URL

The existing `EmailAttachment.fileUrl` is built from `R2_PUBLIC_URL`. The accepted Option B
requires validated private objects and narrowly scoped short-lived signed paths. An
unguessable key in a public bucket is not private-object authority.

### Duplicate Shares The Same Storage Object

Duplicating an email creates new attachment rows pointing at the same `r2Key`. Editable draft
removal and immutable history cannot safely share deletion authority without an explicit
object-reference model.

## 5. Included Scope

- align UI and service limits to three attachments and 10 MB cumulative;
- define one shared attachment policy used by browser guidance and server authority;
- strictly decode Base64 and verify decoded byte counts;
- validate filename length/characters and normalise provider-facing names safely;
- inspect actual file signatures/content type under the accepted section 16 policy;
- reject extension, claimed MIME and detected-type disagreement;
- use a genuinely private R2 bucket/configuration for new email attachments;
- persist durable key, size, SHA-256 checksum, detected type and validation evidence;
- make create fail atomically from the user's perspective when any intended upload fails;
- support retain/add/remove semantics for editable draft attachments;
- hydrate exact persisted attachments when a draft reopens;
- preserve exact attachment evidence when an email is duplicated to a draft;
- prevent attachment mutation once the email is no longer editable;
- validate authenticated storage readability and checksum before finalisation;
- compute a canonical attachment-set fingerprint;
- return explicit validation/storage errors to C1;
- ensure successful draft feedback means every intended attachment is durable;
- add service, router and UI-level tests where practical; and
- define and execute technical checks before the required human UI smoke gate.

## 6. Excluded Scope

- creating or processing `EmailDeliveryJob` records;
- sending attachment emails;
- worker throttling, idempotency or retry;
- C1 queued/running/per-recipient progress UI;
- deployed Resend path-fetch proof;
- key-date sequence attachment authoring;
- automatic migration or deletion of historic public attachment objects;
- automatic resend of any historic message; and
- unrelated media/R2 redesign.

## 7. Private Storage Direction

The accepted Option B requires a separate private attachment storage authority.

Recommended technical contract:

```text
R2_EMAIL_ATTACHMENT_BUCKET_NAME
-> private bucket, no r2.dev/public custom-domain exposure
-> same narrowly scoped R2 credentials only if those credentials are authorised for it
-> durable object key stored in EmailAttachment
-> authenticated Head/GetObject for validation
-> signed GET minted only by the later worker
```

`R2_PUBLIC_URL` must not be used for new email attachments. `fileUrl` should become nullable
and deprecated for this aggregate so historic records remain readable for audit without
making it the authority for new records.

This is the necessary technical consequence of the already accepted private-object
decision, not a new public-link option.

## 8. Proposed Persistence Contract

### EmailAttachment

Add or refine durable evidence for:

- private storage key;
- original filename;
- normalised provider filename;
- binary size;
- detected MIME type;
- SHA-256 checksum;
- validation policy version;
- validated timestamp;
- source attachment ID for duplication traceability where useful; and
- created timestamp.

The existing public `fileUrl` remains nullable legacy evidence only.

### Email

Add nullable draft/finalisation evidence for:

- canonical attachment-set fingerprint; and
- attachment-set validated timestamp.

R8-A3 may extend this with job/finalisation state. R8-A2 must not overload `Email.status` with
job processing states.

## 9. Canonical Attachment Fingerprint

The fingerprint input should be a stable ordered list such as:

```text
attachment ID
storage key
normalised filename
byte size
detected MIME type
SHA-256 checksum
validation policy version
```

The list is ordered deterministically by attachment ID or an explicit stable order and then
hashed. R8-A3 records the exact fingerprint on its delivery job and refuses changed inputs.

## 10. Draft Mutation Contract

The update payload must distinguish existing durable records from new browser files:

```text
retainedAttachmentIds: [existing attachment IDs]
newAttachments: [new Base64 upload inputs]
```

Server rules:

1. verify the email is same-tenant and editable;
2. verify every retained ID belongs to that email;
3. reject duplicate IDs and over-three combined count;
4. validate all new bytes and the 10 MB combined total;
5. upload every new object to private storage;
6. verify each uploaded object through authenticated storage access;
7. commit retained/new associations and checksum evidence;
8. compensate newly uploaded objects if database persistence fails; and
9. remove superseded draft objects only after the durable replacement commits safely.

No partial attachment replacement may produce a successful draft response.

## 11. Create Atomicity

R2 and PostgreSQL cannot share one transaction. The service must provide compensating
atomicity:

```text
validate every input in memory
-> create draft identity/recipient state
-> upload every private object
-> verify every private object
-> persist every attachment record/fingerprint
-> return success

any failure
-> delete newly uploaded objects best-effort
-> remove or restore incomplete database state
-> return explicit failure
```

Logs and audit evidence must distinguish successful compensation from an orphan requiring
operator cleanup without exposing attachment bytes or signed paths.

## 12. Duplicate-To-Draft Contract

A duplicate must not create mutable deletion authority over the source's historic object.

Recommended first implementation:

- authenticated read and checksum verification of every source attachment;
- write a new private object under the new draft ID;
- persist new attachment identity/checksum evidence;
- retain `sourceAttachmentId` traceability if added; and
- fail the whole duplicate operation if any attachment cannot be copied and validated.

Historic legacy/public attachments that lack accepted validation evidence must fail closed
with an instruction to create a clean draft and add the files again. They must not be silently
copied or treated as validated.

## 13. Legacy Record Policy

Existing attachment rows must be audited, not automatically trusted.

For an editable historic draft:

- show the legacy attachment as requiring replacement/removal;
- do not permit send/finalisation while it remains unvalidated; and
- allow the C1 user to remove it and add a new validated private attachment.

For a sent historic email:

- preserve the row and history;
- do not automatically migrate, resend or delete it; and
- label its delivery evidence as legacy/unknown where later history UI exposes it.

## 14. UI Contract

The compose modal should distinguish:

- persisted validated attachment;
- newly selected attachment awaiting save;
- legacy attachment requiring replacement;
- validation/upload failure; and
- removal pending save.

Visible rules:

- show `n/3 files` and cumulative `x/10 MB`;
- reject extra files rather than silently slicing a drop selection;
- explain the accepted file types from section 16;
- disable save/send while browser conversion is active;
- on save, replace local items with returned durable attachment identities;
- reopen the saved draft with the same exact file list;
- remove/add/save/reopen with exact reconciliation;
- do not say `Email Sent` for an attachment-bearing message while R8-A3 is absent; and
- show the R8-A1 fail-closed provider message accurately if send is attempted.

## 15. Automated Test Plan

### Policy And Content

- zero, one, two and three files accepted subject to cumulative size;
- fourth file rejected server-side and in UI guidance;
- exactly 10 MB accepted and above 10 MB rejected;
- malformed Base64 rejected;
- extension/claimed MIME/detected signature mismatch rejected;
- unsafe filename normalised without losing the displayed original;
- accepted signature matrix follows section 16 decision.

### Storage

- new upload uses private attachment bucket, never `R2_PUBLIC_URL`;
- Get/Head failure blocks persistence success;
- returned bytes/metadata mismatch blocks validation;
- SHA-256 evidence is deterministic;
- compensation deletes newly uploaded objects after later failure;
- no signed URL or object bytes appear in logs/audit.

### Create And Update

- one failed file makes the whole intended set fail;
- audit requested/persisted counts cannot disagree on success;
- retained IDs must belong to the same email and tenant;
- add/remove/replace preserves exact durable set;
- non-editable emails reject mutation;
- repeated identical update is safe;
- fingerprint changes only when the effective set changes.

### Draft And Duplicate

- saved attachments hydrate on reopen;
- newly added reopened-draft file persists;
- removed file stays removed after reopen;
- duplicate receives independent private objects and exact metadata;
- invalid legacy attachment blocks duplication with an actionable reason.

### Regression

- no-attachment draft create/update/send remains unchanged;
- R8-A1 batch guard and ordinary adapter tests remain green;
- recipient/cohort resolution remains unchanged.

## 16. Required Business Security Decision

R8-A2 cannot honestly mark an attachment `validated` until the accepted file-type and malware
policy is explicit. The current broad allowlist includes Office documents and ZIP archives,
which can carry active or concealed malicious content.

Choose one of these policies:

### Option A - Restricted Initial Allowlist Without Malware Scanner (Recommended)

```text
PDF
JPEG
PNG
maximum 3 files
maximum 10 MB cumulative
actual signature and extension/type agreement required
```

Benefits:

- smallest safe remediation boundary;
- no new scanning service or operational dependency;
- covers the most common supporting-document/image use case; and
- can ship before broader file support is planned.

Trade-off:

- Word, Excel, PowerPoint, text/CSV, GIF/WebP and ZIP are refused initially.

### Option B - Broad Office/Archive Support With Malware Scanning

Preserve a broader approved allowlist only after a malware-scanning service is selected and
integrated. `CLEAN` becomes a precondition for durable validation/finalisation.

Benefits:

- retains current broad business formats.

Trade-offs:

- new scanner/service, infrastructure, failure states and operational cost;
- encrypted/password-protected archives require a refusal policy; and
- slice scope and deployed proof increase materially.

### Option C - Broad Allowlist Without Scanning

Not recommended. This would require explicit business risk acceptance and would weaken the
meaning of `validated`.

Implementation must pause here until the business analyst selects A, B or explicitly accepts
C.

## 17. Technical Exit Gate

Subject to the section 16 decision, R8-A2 is technically complete when:

```text
intended = persisted = validated = readable
```

and:

- draft add/remove/reopen/duplicate evidence is exact;
- three-file and 10 MB limits are enforced at service authority;
- new objects are private and checksum-addressable;
- no partial upload can produce successful feedback;
- invalid legacy evidence blocks rather than silently degrades;
- automated checks pass; and
- implementation confirmation and technical review/test documents exist.

## 18. Required Human UI Smoke Gate

After technical completion, the business/testing team must test in the deployed target
environment:

1. create a draft with one accepted attachment;
2. close and reopen it and confirm the same name/size is present;
3. add a second attachment, save, close and reopen;
4. remove the first attachment, save, close and reopen;
5. confirm a fourth attachment is refused clearly;
6. confirm cumulative content above 10 MB is refused clearly;
7. confirm a disallowed/mismatched file is refused clearly;
8. simulate or observe an upload failure and confirm no success message;
9. duplicate a valid draft/email and confirm independent exact attachments; and
10. attempt send and confirm the interim fail-closed message states that no email was sent.

The reported result must be recorded in `05-review-and-test`. Do not create R8-A3 planning
until that human result is confirmed.
