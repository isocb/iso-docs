# LMSPro Remediation Slice R8-A2 - Attachment Persistence, Drafts And Fail-Closed Preflight Planning

Date: 2026-07-21
Module: LMSPro / SeasonPro shared communications
Status: Planning complete; broad file/link policy accepted; implementation paused for the malware-scanner deployment decision in section 17
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
- broad approved Office/image/ZIP support requires a successful malware scan;
- an external shared-document URL is a supporting link, not an email attachment or remote
  object for SeasonPro to fetch;
- a communication containing external links but no managed binary attachment continues to
  use the proven no-attachment batch route;
- C1 must explicitly accept responsibility for the integrity, suitability and sharing
  permissions of uploaded files and external links;
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
- malware-scan every uploaded file and require `CLEAN` evidence before finalisation;
- reject infected, scan-failed, encrypted or otherwise unscannable content;
- support bounded HTTPS shared-document links without fetching the remote document;
- persist and fingerprint the exact shared-link label and destination;
- show and require the explicit C1 Administrator responsibility notice;
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
- downloading, mirroring, malware-scanning or guaranteeing the availability of external
  shared-document URLs;
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

### EmailSharedDocumentLink

Persist external supporting links separately from binary attachments, including:

- email and tenant ownership;
- C1-authored display label;
- exact normalised HTTPS destination;
- deterministic display order;
- created/updated actor and timestamp evidence; and
- validation/fingerprint policy version.

SeasonPro must not fetch the destination, infer that a Google or Microsoft sharing setting
is correct, copy the remote document into R2 or pass the link to Resend as an attachment
path. The controlled email composition should render it as a normal supporting-document
link. This preserves the distinction between a SeasonPro-managed scanned attachment and an
externally managed resource.

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
malware scanner/policy version
malware scan result and completed timestamp
validation policy version
```

The final communication fingerprint also includes the ordered shared-link IDs, labels and
normalised HTTPS destinations. A linked document can later change outside SeasonPro; the
fingerprint proves the exact URL that C1 supplied, not the remote content at that URL.

The list is ordered deterministically by attachment ID or an explicit stable order and then
hashed. R8-A3 records the exact fingerprint on its delivery job and refuses changed inputs.

## 10. Draft Mutation Contract

The update payload must distinguish existing durable records from new browser files:

```text
retainedAttachmentIds: [existing attachment IDs]
newAttachments: [new Base64 upload inputs]
retainedSharedLinkIds: [existing shared-link IDs]
sharedLinks: [{ label, httpsUrl }]
```

Server rules:

1. verify the email is same-tenant and editable;
2. verify every retained ID belongs to that email;
3. reject duplicate IDs and over-three combined count;
4. validate all new bytes and the 10 MB combined total;
5. validate bounded shared links without requesting their destinations;
6. upload every new object to private storage;
7. malware-scan every new object and require `CLEAN` evidence;
8. verify each uploaded object through authenticated storage access;
9. commit retained/new associations, links, checksum and scan evidence;
10. compensate newly uploaded objects if database persistence fails; and
11. remove superseded draft objects only after the durable replacement commits safely.

No partial attachment replacement may produce a successful draft response.

## 11. Create Atomicity

R2 and PostgreSQL cannot share one transaction. The service must provide compensating
atomicity:

```text
validate every input in memory
-> create draft identity/recipient state
-> upload every private object
-> require a CLEAN malware result for every object
-> verify every private object
-> persist every attachment/link record and fingerprint
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

It should also provide a separate `Add shared document link` control with a display label and
HTTPS URL. A link must be visibly identified as externally hosted and must never be described
as malware-scanned or attached to the email.

Visible rules:

- show uploaded-file count, total supporting-item count and cumulative `x/10 MB` clearly;
- reject extra files rather than silently slicing a drop selection;
- explain the accepted file types from section 16;
- show `Scanning`, `Clean`, `Blocked` or `Scan unavailable` for uploaded files;
- block save/finalisation while a required scan is pending or unavailable;
- reject non-HTTPS, credential-bearing or malformed shared URLs;
- apply the initial working limit of three supporting items in total across uploaded files
  and external links, subject to explicit correction before implementation;
- place the following acknowledgement immediately beside the file/link controls and require
  affirmative acceptance before the communication can be finalised:

  > As the C1 SeasonPro Administrator, you are responsible for the integrity, suitability
  > and sharing permissions of every file or link you provide. SeasonPro scans uploaded
  > files for known malware, but cannot verify the content, availability or access
  > permissions of externally hosted links.

- record acknowledgement actor, timestamp and notice version;
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
- each allowed Office/image/ZIP fixture requires a `CLEAN` result;
- infected, scan-error, encrypted and unscannable fixtures fail closed;
- archive expansion/recursion limits prevent decompression-bomb behaviour.

### Shared Links And Acknowledgement

- valid HTTPS Google Docs and equivalent shared links persist and render as links;
- SeasonPro makes no request to the shared URL during validation or delivery;
- HTTP, malformed and credential-bearing URLs are refused;
- link label and URL changes alter the final fingerprint;
- the C1 notice is visible beside both upload and link controls;
- finalisation fails until the current notice version is acknowledged; and
- audit evidence records the C1 actor, timestamp and notice version without claiming that
  the external resource was scanned or accessible.

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

## 16. Accepted File, Link And Responsibility Policy

Accepted by the business analyst on 2026-07-21:

1. R8-A retains a broad but explicit Office/image/ZIP upload policy rather than restricting
   the first release to PDF/JPEG/PNG.
2. The initial candidate allowlist is PDF, DOC/DOCX, XLS/XLSX, PPT/PPTX, TXT/CSV,
   JPEG/PNG/GIF/WebP and ZIP. Exact signature detection and browser/service parity must be
   proven before implementation; executable/script formats are not implied by broad support.
3. Every uploaded file requires actual-type validation and a successful malware result of
   `CLEAN` before it can become durable finalisation evidence.
4. Infected, scanner-error, encrypted/password-protected or otherwise unscannable files fail
   closed. ZIP inspection must have recursion, entry-count and expanded-size protections.
5. C1 may add an HTTPS link to a suitably shared cloud document, including Google Docs.
6. A shared URL is a separate externally hosted supporting link. SeasonPro does not fetch,
   copy, scan, validate access permissions for or guarantee the continued content of that
   resource.
7. A message containing external links but no managed file attachment remains eligible for
   the existing batch route because the controlled links are rendered in the email body.
8. The compose experience includes the explicit C1 SeasonPro Administrator responsibility
   acknowledgement defined in section 14. That acknowledgement supplements rather than
   replaces platform validation and malware scanning of uploaded files.
9. The initial working rule is no more than three supporting items combined across uploaded
   files and external links. The 10 MB cumulative limit applies only to uploaded files. This
   combined-count interpretation must be corrected before implementation if the intended
   business rule is instead three attachments plus a separate link allowance.

## 17. Remaining Malware-Scanner Deployment Decision

The business security policy is settled, but its operating authority is not. Implementation
must pause until one of these deployment models is accepted:

### Option A - Dedicated Private ClamAV Service On Render (Recommended)

- deploy a pinned, hardened ClamAV service through a Docker-based Render private service;
- expose it only on Render's private network to the SeasonPro application/worker;
- keep virus definitions current and surface signature age/health;
- stream bounded files for scanning without making private R2 objects public;
- fail closed on timeout, scanner unavailability or stale/unhealthy definitions; and
- provision and monitor the material memory/disk footprint required by ClamAV.

This keeps document bytes within the controlled Render environment, but adds a paid service,
resource cost, signature updates, health monitoring and incident ownership.

### Option B - Contracted External Malware-Scanning API

- select a named provider and complete security/privacy, data-location, retention, DPA,
  availability and cost review;
- send only the minimum required file content/metadata;
- pin the provider/policy version into validation evidence; and
- fail closed on timeout, indeterminate response or provider unavailability.

This may reduce infrastructure ownership but shares potentially sensitive Club documents
with another processor and introduces vendor limits and cost.

Broad unscanned support is no longer an acceptable R8-A2 outcome. The C1 responsibility
notice does not transfer away SeasonPro's accepted obligation to scan managed uploads.

Relevant platform references:

- ClamAV introduction and resource guidance: <https://docs.clamav.net/>
- ClamAV daemon protocol: <https://docs.clamav.net/manual/Usage/ClamdProtocol.html>
- Render private services: <https://render.com/docs/private-services>
- Render Docker deployment: <https://render.com/docs/docker>
- Render private networking: <https://render.com/docs/private-network>

## 18. Technical Exit Gate

Subject to the section 17 deployment decision, R8-A2 is technically complete when:

```text
intended = persisted = validated = readable
```

and:

- draft add/remove/reopen/duplicate evidence is exact;
- three-file and 10 MB limits are enforced at service authority;
- every managed upload has current `CLEAN` evidence and every external link is represented
  accurately as unscanned externally hosted content;
- the C1 responsibility acknowledgement is visible, required and auditable;
- new objects are private and checksum-addressable;
- no partial upload can produce successful feedback;
- invalid legacy evidence blocks rather than silently degrades;
- automated checks pass; and
- implementation confirmation and technical review/test documents exist.

## 19. Required Human UI Smoke Gate

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
10. add a suitably shared Google Docs HTTPS link and confirm it is shown as an external link,
    not an attachment;
11. confirm SeasonPro does not claim to scan or verify the linked document;
12. confirm the C1 responsibility acknowledgement is explicit and required;
13. confirm clean Office and ZIP samples complete scanning and persist;
14. confirm infected, encrypted/unscannable and scanner-unavailable cases fail closed with
    no success message; and
15. attempt send and confirm the interim fail-closed message states that no email was sent.

The reported result must be recorded in `05-review-and-test`. Do not create R8-A3 planning
until that human result is confirmed.
