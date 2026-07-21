# LMSPro Remediation Slice R8-A2R - Bounded Unscanned Attachment Policy Correction Review And Test

Date: 2026-07-21
Module: LMSPro / SeasonPro shared communications
Technical review status: PASS
Deployed human UI smoke status: PENDING
Promotion status: Not yet recommended; R8-A3 planning remains closed

Planning source:

`docs/modules/lmspro/03-slice-planning/2026-07-21-lmspro-remediation-slice-r8-a2r-bounded-unscanned-attachment-policy-correction-planning.md`

Implementation confirmation:

`docs/modules/lmspro/04-implementation-confirmations/2026-07-21-lmspro-remediation-slice-r8-a2r-bounded-unscanned-attachment-policy-correction-confirmation.md`

## Technical Review Findings

### Corrected Policy Authority

PASS.

- service authority limits managed files to three and 10 MB cumulative;
- allowed formats are PDF, JPEG/JPG, PNG, GIF, WebP, UTF-8 TXT and CSV;
- Office and archive formats no longer have parsing or acceptance branches;
- extension, claimed MIME and detected content must agree;
- three external HTTPS links are independently bounded; and
- the policy and responsibility notice use new versions.

### Infrastructure Removal

PASS.

- no LMSPro email-attachment ClamAV client or export remains;
- no ClamAV Docker file remains;
- the Render blueprint has no ClamAV private service or disk;
- ClamAV environment settings are absent from runtime validation and examples; and
- the email-specific malware evidence is removed by a forward migration.

### Private Storage And Fail-Closed Behaviour

PASS.

- uploads use the dedicated private R2 bucket;
- metadata and bytes are read back through authenticated access;
- size, MIME metadata and SHA-256 must match before persistence succeeds;
- partial work is compensated;
- legacy or prior-policy evidence cannot silently satisfy current preflight; and
- attachment-bearing send/resend remains refused until R8-A3.

### User Disclosure

PASS by code review; deployed visual confirmation pending.

- the UI no longer claims malware scanning;
- allowed types are accurately stated;
- C1 responsibility for integrity, suitability and sharing permissions is explicit; and
- external resources are identified as externally hosted and unverified.

## Automated Test Evidence

| Check | Result |
| --- | --- |
| Four focused attachment/R2/provider suites | PASS - 29 tests |
| Broader Vitest regression | PASS - 120 tests, 12 skipped |
| TypeScript type-check | PASS |
| Prisma generate and validate | PASS |
| Critical-file verification | PASS |
| Next production build | PASS |
| Diff whitespace check | PASS |

The broader run excludes the unchanged empty
`src/modules/fund/lib/client-project-store.test.ts` baseline file. This is not an R8-A2R
regression.

## Required Human UI And Private-R2 Smoke

The business/testing team must report:

1. confirm `R2_EMAIL_ATTACHMENT_BUCKET_NAME` points to the dedicated private environment
   bucket and that no `r2.dev` or custom public domain is enabled for it;
2. save and reopen a valid PDF, accepted image, TXT and CSV;
3. add, remove and duplicate files and confirm the exact expected set remains;
4. confirm a fourth file and cumulative content above 10 MB are clearly refused;
5. confirm DOC/DOCX, XLS/XLSX, PPT/PPTX, ZIP/archive, executable/script and mismatched content
   are clearly refused;
6. confirm three HTTPS links are accepted and a fourth is refused;
7. send a links-only message and confirm it uses the working batch route and its received
   links are clickable;
8. confirm the UI explicitly states that uploads are not malware-scanned and external
   resources are not verified;
9. confirm the C1 responsibility acknowledgement is required;
10. attempt an attachment send and confirm the interim message clearly states that no email
    was sent; and
11. repeat a no-attachment batch send as a live regression smoke.

Do not perform ClamAV health, EICAR, scanner-unavailable, Office-clean or ZIP-clean tests.
Those belonged to the withdrawn policy.

## Current Conclusion

R8-A2R passes bounded technical review at application commit `e850c47b`. It is paused at the
revised deployed human UI/private-R2 gate. Do not create or implement R8-A3 until the
business/testing team reports and accepts that result.
