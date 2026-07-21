# LMSPro Remediation Slice R8-A2 - Attachment Persistence, Drafts And Fail-Closed Preflight Implementation Confirmation

Date: 2026-07-21
Module: LMSPro / SeasonPro shared communications
Status: Superseded before promotion in its broad-file and ClamAV portions by R8-A2R; retained as historical technical evidence

Planning source:

`docs/modules/lmspro/03-slice-planning/2026-07-21-lmspro-remediation-slice-r8-a2-attachment-persistence-drafts-and-fail-closed-preflight-planning.md`

Controlling parent:

`docs/modules/lmspro/03-slice-planning/2026-07-20-lmspro-remediation-slice-r8-a-attachment-aware-email-delivery-route-and-fail-closed-evidence-planning.md`

> Correction: the business analyst withdrew the broad Office/ZIP and mandatory ClamAV
> policy before promotion. The R8-A2R records supersede this document for current behaviour.
> Private R2, exact persistence, checksum, link and fail-closed evidence remain applicable
> foundations.

## Repository And Commit Evidence

```text
repository: isostack-bedrock
branch: fix/lmspro-r8-a-attachment-delivery
base: origin/dev at e3f44b4b786c74dfcb177f01b3b00a09acf6bbb8
implementation commit:
- 23e87473 feat(communications): persist scanned email resources
```

## Implemented Outcome

R8-A2 makes the resource set represented to C1 durable and fail-closed before a later R8-A3
delivery job is allowed to use it:

```text
intended = persisted = validated = readable
```

It implements two independent allowances:

- up to three uploaded files, no more than 10 MB cumulative; and
- up to three HTTPS externally hosted supporting links.

Links are rendered in the message body and are not treated as managed attachments. A
links-only message remains eligible for the established batch route.

## Persistence And Evidence

The Prisma model and migration add:

- attachment set fingerprint and validation evidence on `Email`;
- versioned C1 responsibility acknowledgement evidence;
- private object identity, detected type, SHA-256, validation policy and malware-scan
  evidence on `EmailAttachment`; and
- a separate `EmailSharedDocumentLink` aggregate.

Legacy public-URL evidence remains readable for migration compatibility but cannot silently
become current validated attachment evidence.

## Validation And Malware Scanning

The shared policy validates strict Base64, normalized filenames, content signatures and
claimed MIME consistency. The broad accepted allowlist includes PDF, common images,
text/CSV, legacy Office, OpenXML Office and bounded ZIP content.

ZIP validation rejects encrypted content and applies path, entry-count, expanded-size and
compression-ratio protections. Managed files must receive a current `CLEAN` result from the
private ClamAV service; infected, failed, unavailable or unscannable results fail closed.

A pinned ClamAV Docker service and private Render service definition were added. Clamd uses
the private TCP `INSTREAM` protocol with bounded chunks and timeouts.

## Private Storage

Email attachments use a dedicated private R2 bucket rather than `R2_PUBLIC_URL`. Upload is
followed by authenticated metadata and byte readback, with SHA-256 verification. Later
failure triggers compensating deletion of newly created private objects.

## Draft And Compose Behaviour

Create and update now persist the exact managed-file and external-link set atomically with
recipient and audit evidence. Reopened drafts hydrate resources; update can retain, add and
remove them; duplication creates independent private attachment objects and blocks invalid
legacy sources.

The compose UI exposes stored/new file state and scan evidence, three-link controls and the
accepted explicit C1 SeasonPro Administrator responsibility notice. Current acknowledgement
is required before a message containing files or links may be sent.

Attachment send/resend remains intentionally fail closed until R8-A3 supplies the durable
job. No-attachment and links-only messages preserve the existing Resend batch path.

## Schema, Infrastructure And Configuration

Added:

```text
prisma/migrations/20260721120000_lmspro_r8_a2_email_attachment_evidence/migration.sql
infra/clamav/Dockerfile
R2_EMAIL_ATTACHMENT_BUCKET_NAME
CLAMAV_HOST
CLAMAV_PORT
CLAMAV_SCAN_TIMEOUT_MS
```

`render.yaml` defines the private ClamAV service and its virus-definition disk.

## Automated Evidence

```text
npx vitest run <five focused R8-A/R2 resource test files>
Test Files  5 passed (5)
Tests       28 passed (28)

npm run type-check
PASS

npx prisma validate
PASS

npx tsx scripts/verify-critical-files.ts
ALL VERIFICATIONS PASSED

npm run build
PASS

npx vitest run --exclude src/modules/fund/lib/client-project-store.test.ts
Test Files  18 passed | 1 skipped (19)
Tests       119 passed | 12 skipped (131)

git diff --check
PASS
```

The critical-file verification required execution outside the local sandbox because the
TypeScript runner could not create its IPC socket inside it; the verification itself passed.

The unfiltered Vitest command retains the unchanged baseline issue in
`src/modules/fund/lib/client-project-store.test.ts`: the file defines no Vitest suite. It is
not an R8-A2 regression.

## Deployment Boundary

Docker is not installed in the local verification environment. The private Render ClamAV
service, signature-update health, private R2 configuration and browser compose workflow
therefore require the planning document's deployed human smoke test.

R8-A2 is technically complete but is not lifecycle-complete. R8-A3 planning must not be
created until the deployed result is reported and accepted.
