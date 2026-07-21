# LMSPro Remediation Slice R8-A2R - Bounded Unscanned Attachment Policy Correction Implementation Confirmation

Date: 2026-07-21
Module: LMSPro / SeasonPro shared communications
Status: Technically complete on the dedicated remediation branch; revised deployed human UI smoke pending

Planning source:

`docs/modules/lmspro/03-slice-planning/2026-07-21-lmspro-remediation-slice-r8-a2r-bounded-unscanned-attachment-policy-correction-planning.md`

## Repository And Commit Evidence

```text
repository: isostack-bedrock
branch: fix/lmspro-r8-a-attachment-delivery
base: origin/dev at e3f44b4b786c74dfcb177f01b3b00a09acf6bbb8
corrective implementation commit:
- e850c47b fix(communications): narrow unscanned attachment policy
```

## Implemented Outcome

R8-A2R removes the LMSPro email-attachment ClamAV runtime and narrows the upload contract to:

- up to three files;
- no more than 10 MB cumulative;
- PDF, JPEG/JPG, PNG, GIF, WebP, UTF-8 TXT and CSV; and
- private R2 persistence with authenticated metadata/byte readback and SHA-256 verification.

Office, ZIP/archive, executable, script, mismatched and unsupported file types are refused.
Type validation is not represented as malware scanning.

The independent maximum of three labelled HTTPS external links is unchanged. Links are
escaped into the message body, are not fetched or verified, and do not select the attachment
job when no uploaded file exists.

## Removed Infrastructure And Evidence

The implementation removes:

- the ClamAV TCP client and its tests;
- the ClamAV Docker image;
- the Render private ClamAV service and signature disk;
- `CLAMAV_HOST`, `CLAMAV_PORT` and `CLAMAV_TIMEOUT_MS`; and
- email-attachment malware status, scanner, result and scan-time schema fields.

The correction does not affect FUND's separate production-asset malware evidence.

## Forward Migration

The earlier R8-A2 migration is retained as immutable migration history. The corrective
migration:

`prisma/migrations/20260721150000_lmspro_r8_a2r_remove_malware_scan_evidence/migration.sql`

drops the email-specific scan evidence and recreates the private-evidence constraint around
the current validation policy, detected MIME, private bucket, checksum, validated timestamp
and null public URL.

## UI And Durable Policy

The compose control now advertises only the accepted formats. File state is shown as
`Validated when saved`, `File validated` or `Replace legacy file`.

The notice has a new version and explicitly says that SeasonPro validates uploaded type and
size but does not malware-scan uploaded files or verify external content. Resource-bearing
send preflight requires current notice acknowledgement.

The validation policy version is also new, so records created under the withdrawn policy
cannot silently satisfy the corrected contract.

## Preserved Safety And Delivery Boundary

R8-A2R retains:

- strict Base64 and content/type agreement;
- private R2 with no public object URL authority;
- authenticated readback and immutable SHA-256 evidence;
- compensating deletion after partial persistence failure;
- exact create, update, reopen and duplicate behaviour;
- attachment/link fingerprinting;
- fail-closed send and resend preflight;
- the no-attachment and links-only batch path; and
- the interim attachment-send refusal until R8-A3 exists.

## Automated Evidence

```text
npx prisma format                                              PASS
npx prisma generate                                            PASS
npx prisma validate                                            PASS
npm run type-check                                             PASS

focused Vitest suites                                          PASS
4 files, 29 tests

broader Vitest regression excluding the unchanged empty FUND
test-file baseline                                             PASS
17 passed files, 1 skipped; 120 passed tests, 12 skipped

npx tsx scripts/verify-critical-files.ts                       PASS
npm run build                                                  PASS
git diff --check                                               PASS
```

## Remaining Gate

Technical implementation is complete. R8-A2R remains awaiting the revised deployed human UI
and private-R2 smoke result. R8-A3 planning must not begin until that result is recorded and
accepted.
