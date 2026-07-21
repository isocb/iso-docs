# LMSPro Remediation Slice R8-A2R - Bounded Unscanned Attachment Policy Correction Planning

Date: 2026-07-21
Module: LMSPro / SeasonPro shared communications
Status: Accepted corrective slice; implementation authorised before promotion
Type: Remedial policy, infrastructure and evidence correction

Controlling parent:

`docs/modules/lmspro/03-slice-planning/2026-07-20-lmspro-remediation-slice-r8-a-attachment-aware-email-delivery-route-and-fail-closed-evidence-planning.md`

Corrected predecessor:

`docs/modules/lmspro/03-slice-planning/2026-07-21-lmspro-remediation-slice-r8-a2-attachment-persistence-drafts-and-fail-closed-preflight-planning.md`

Related CR input:

`docs/modules/lmspro/01-cr-inputs/2026-07-20-lmspro-cr-attachment-aware-email-delivery-and-fail-closed-evidence-remediation-input.md`

## 1. Correction Decision

Before R8-A2 was promoted or passed its deployed human gate, the business analyst withdrew
the broad Office/ZIP and mandatory ClamAV policy after reviewing its cost, operating burden
and marginal benefit for this bounded administrative-email feature.

R8-A2R supersedes only those R8-A2 policy and implementation elements. It preserves the
original attachment-silent-loss remediation, private storage, exact draft persistence,
fail-closed evidence and separate three-link capability.

The corrected contract is:

```text
uploaded files
-> maximum 3
-> maximum 10 MB cumulative
-> PDF, JPEG/JPG, PNG, GIF, WebP, UTF-8 TXT or CSV only
-> strict extension, claimed MIME and detected-content agreement
-> private R2 storage
-> authenticated metadata and byte readback
-> SHA-256 verification
-> explicitly not malware-scanned

external supporting links
-> maximum 3 independently
-> labelled HTTPS URLs
-> not fetched, copied, scanned or permission-tested by SeasonPro
```

## 2. Cost, Benefit And Risk Basis

The private ClamAV direction introduced a dedicated paid Render service with material memory
and disk requirements, signature updates, health monitoring, availability handling and an
additional production dependency. That standing cost and operational responsibility is
disproportionate to the initial use case.

Removing malware scanning increases residual recipient risk: an authorised C1 user can
upload an allowed file whose bytes conform to its type but whose content is harmful. Strict
type validation does not prove a file is malware-free. R8-A2R therefore does not describe
files as safe or scanned.

The accepted risk controls are:

- a narrow non-executable allowlist instead of broad Office/archive support;
- no ZIP or other archive format;
- no Office container or macro-capable format;
- three files and 10 MB cumulative service-authority limits;
- strict actual-type, extension and browser-claim agreement;
- private R2 objects with checksum/readback verification;
- a versioned, explicit C1 responsibility acknowledgement; and
- the existing fail-closed delivery and attachment-set evidence contract.

This is a deliberate product risk decision. It does not assert that permitted PDFs, images
or text files are incapable of carrying harmful content.

## 3. Settled Business Decisions

1. SeasonPro will not run or require ClamAV for LMSPro email attachments.
2. No ClamAV account, Render private service, persistent signature disk, health check or
   ClamAV environment setting is required.
3. A communication may contain up to three uploaded files.
4. Uploaded files may total no more than 10 MB before provider encoding.
5. Allowed uploads are PDF, JPEG/JPG, PNG, GIF, WebP, UTF-8 TXT and CSV.
6. Office documents, ZIP/archive formats, executables and scripts are refused.
7. A communication may separately contain up to three labelled HTTPS external links.
8. External links do not count as uploaded files and a links-only communication remains on
   the proven no-attachment batch route.
9. Uploaded files remain in the dedicated private R2 bucket and are not exposed through a
   public object URL.
10. The C1 SeasonPro Administrator is responsible for file integrity and suitability and
    for external-link content, availability and sharing permissions.
11. The UI and durable acknowledgement must explicitly say SeasonPro does not malware-scan
    uploaded files or verify external resources.
12. Attachment delivery remains blocked until R8-A3 provides the asynchronous ordinary
    `/emails` route. R8-A2R does not send attachments.

## 4. Included Scope

- remove the LMSPro email-attachment ClamAV client, tests and exports;
- remove the ClamAV Render private service and application environment settings;
- remove email-attachment malware-scan fields and enum through a forward corrective
  migration;
- retain private R2 identity, detected MIME, byte size, SHA-256, validation-policy and
  validated-at evidence;
- narrow service and browser file allowlists to the accepted formats;
- remove Office/ZIP parsing, policy branches, fixtures and UI claims;
- issue new validation-policy and responsibility-notice versions;
- update create, update, reopen, duplicate and send-preflight logic to use the corrected
  evidence contract;
- retain three-upload/10 MB and three-link limits;
- retain external-link escaping and batch-route behaviour;
- update planning, implementation and review evidence without deleting R8-A2 history; and
- repeat technical checks before the revised human UI smoke gate.

## 5. Excluded Scope

- implementing R8-A3 attachment delivery jobs;
- weakening private R2 or checksum/readback controls;
- permitting Office, archive, executable or script formats;
- claiming that type validation is malware detection;
- fetching or inspecting external linked content;
- changing the no-attachment Resend batch sender;
- adding key-date sequence attachments;
- automatically resending historic emails; and
- changing unrelated FUND production-asset malware policy.

## 6. Persistence And Migration Contract

The already-authored R8-A2 migration remains immutable migration history. R8-A2R adds a
forward corrective migration that:

- drops the email-attachment malware evidence check;
- removes the email-attachment malware status, scanner, result and timestamp columns;
- removes the email-specific malware-status enum; and
- recreates the private-evidence check around validation policy, detected type, private
  bucket, SHA-256, validated timestamp and absence of a public `fileUrl`.

This sequencing supports a database that has applied R8-A2 as well as a fresh database that
applies both migrations in order. It must not affect FUND's separate production-asset
malware-scan models.

## 7. UI And Acknowledgement Contract

The upload control must say:

```text
Max 3 files and 10 MB total - PDF, text/CSV, JPEG, PNG, GIF and WebP
```

New local files should be described as `Validated when saved`; durable current-policy files
as `File validated`; legacy evidence as requiring replacement.

When a file or external link is present, the UI must require acknowledgement equivalent to:

> As the C1 SeasonPro Administrator, you are responsible for the integrity, suitability and
> sharing permissions of every file or link you provide. SeasonPro validates uploaded file
> type and size but does not malware-scan uploaded files or verify the content, availability
> or access permissions of externally hosted links.

The acknowledgement receives a new notice version. Earlier acknowledgement of the withdrawn
scanning notice is not authority under the corrected policy.

## 8. Automated Verification

At minimum prove:

- PDF, JPEG, PNG, GIF, WebP, TXT and CSV accepted with matching byte/type evidence;
- Office, ZIP/archive, executable, script and mismatched content refused;
- malformed Base64 and invalid UTF-8 refused;
- fourth file and content above 10 MB refused at service authority;
- fourth external link, HTTP and credential-bearing links refused;
- private upload, authenticated Head/Get and SHA-256 readback retained;
- persisted resources reopen and duplicate with exact independent evidence;
- current notice acknowledgement remains a send precondition;
- attachment-bearing send/resend remains explicitly blocked pending R8-A3;
- links-only and zero-resource messages preserve batch behaviour;
- Prisma schema/migrations validate; and
- type-check, focused suites, regression tests and production build pass.

## 9. Revised Human UI Smoke Gate

Before R8-A3 planning begins, the business/testing team must report:

1. the dedicated email-attachment R2 bucket is private and exposes no public object URL;
2. a valid PDF, accepted image, TXT and CSV can be saved and reopened;
3. add, remove and duplicate preserve the exact file set and independent object evidence;
4. a fourth file and cumulative content above 10 MB are clearly refused;
5. Office, ZIP/archive, executable/script and content/type mismatch are clearly refused;
6. three HTTPS links are accepted and a fourth is clearly refused;
7. a links-only email uses the proven batch route and received links are clickable;
8. the UI explicitly says uploaded files are not malware-scanned and linked content is not
   verified;
9. the C1 responsibility acknowledgement is visible and required;
10. attachment send remains blocked with an explicit statement that no email was sent; and
11. a no-attachment batch send still succeeds as a live regression smoke.

ClamAV health, EICAR and scanner-unavailable testing are withdrawn and must not appear in
the revised gate.

## 10. Exit And Sequencing Gate

R8-A2R is technically complete only when implementation and review/test records exist and
all automated checks pass. It becomes lifecycle-complete only after the revised human UI
smoke result is recorded and accepted.

R8-A3 planning remains closed until that human result. No ClamAV setup should be performed
in local, development, staging or live environments for this LMSPro route.
