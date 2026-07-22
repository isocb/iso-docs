# LMSPro Remediation Slice R8-A2R - Bounded Unscanned Attachment Policy Correction Review And Test

Date: 2026-07-21
Module: LMSPro / SeasonPro shared communications
Technical review status: PASS
Deployed human UI smoke status: FAIL - corrective slice required
Promotion status: Blocked at this boundary; superseded for retest by `R8-A2R-F1`

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

1. **PASS** — `R2_EMAIL_ATTACHMENT_BUCKET_NAME` pointed to the dedicated private
   environment bucket, with no `r2.dev` or custom public domain enabled.
2. **FAIL** — saving and reopening the expected PDF, image, TXT and CSV set was not
   reliable. A CSV attempt returned `Unexpected token '<', "<!DOCTYPE "... is not valid
   JSON` rather than a controlled JSON error.
3. **PARTIAL / FAIL** — individual add, remove and duplicate interactions could succeed,
   but the exact expected multi-file set was not retained reliably. Additional files could
   appear accepted and then fail to display or disappear. Rejected/failed attempts appeared
   capable of affecting the effective count.
4. **NOT COMPLETED** — fourth-file and cumulative-size refusal could not be assessed
   meaningfully until the retained-set defect was corrected.
5. **NOT COMPLETED** — the full refused-type and mismatched-content matrix was paused at
   the blocking multi-file/transport failure.
6. **FAIL** — up to three HTTPS links were accepted initially but were not rehydrated after
   saving and reopening the draft.
7. **NOT COMPLETED** — links-only delivery regression remained pending correction.
8. **PASS** — the UI stated that uploads are not malware-scanned and external resources
   are not verified.
9. **PASS** — C1 responsibility acknowledgement was required.
10. **PASS** — attachment send remained fail-closed and no email could be sent without the
    required acknowledgement; attachment-bearing delivery remained an interim refusal.
11. **NOT COMPLETED** — the no-attachment live batch regression was deferred until the
    blocking draft/resource defects were corrected.

Do not perform ClamAV health, EICAR, scanner-unavailable, Office-clean or ZIP-clean tests.
Those belonged to the withdrawn policy.

## Current Conclusion

R8-A2R passed bounded technical review at application commit `e850c47b`, but deployed human
UI/private-R2 testing failed at the draft resource and transport boundary. Those findings
triggered the bounded `R8-A2R-F1 - Draft Resource State Rehydration And Attachment Transport
Correction` lifecycle. R8-A3 remains closed until the F1 human UI retest is accepted.
