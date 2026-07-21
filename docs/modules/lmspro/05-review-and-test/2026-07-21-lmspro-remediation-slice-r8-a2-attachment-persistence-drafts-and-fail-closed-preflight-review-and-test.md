# LMSPro Remediation Slice R8-A2 - Attachment Persistence, Drafts And Fail-Closed Preflight Review And Test

Date: 2026-07-21
Module: LMSPro / SeasonPro shared communications
Technical review status: Historical PASS for the superseded implementation
Deployed human UI smoke status: WITHDRAWN; replaced by R8-A2R gate
Promotion status: Superseded before promotion; R8-A3 planning remains closed

Planning source:

`docs/modules/lmspro/03-slice-planning/2026-07-21-lmspro-remediation-slice-r8-a2-attachment-persistence-drafts-and-fail-closed-preflight-planning.md`

Implementation confirmation:

`docs/modules/lmspro/04-implementation-confirmations/2026-07-21-lmspro-remediation-slice-r8-a2-attachment-persistence-drafts-and-fail-closed-preflight-confirmation.md`

> Correction: do not perform this record's ClamAV, EICAR, Office or ZIP smoke steps. The
> R8-A2R review/test record supplies the controlling revised gate after mandatory scanning
> was withdrawn and the file allowlist narrowed before promotion.

## Technical Review Findings

### Resource Limits And Authority

PASS.

- service authority permits no more than three uploaded attachments;
- cumulative managed-file content cannot exceed 10 MB;
- no more than three external HTTPS links are permitted independently;
- links are persisted separately and do not select attachment delivery mode; and
- the compose UI mirrors, but does not replace, service enforcement.

### Content, Archive And Malware Validation

PASS for the implemented contract.

- strict Base64 and actual-content detection are enforced;
- claimed MIME mismatch is rejected;
- broad accepted Office/image/text/ZIP types have explicit detection;
- encrypted or unsafe ZIP content is rejected with bounded archive protections;
- private ClamAV results distinguish clean, infected and failed outcomes; and
- unavailable or failed scanning blocks persistence success.

Deployed scanner health and definition freshness remain part of the human/deployment gate.

### Private Storage And Exact Draft State

PASS.

- the attachment bucket is separate from the public media URL contract;
- authenticated metadata and byte readback verify size and SHA-256;
- partial resource failure is compensated and cannot report success;
- create/update persist exact files, links, recipients and audit evidence atomically;
- reopened drafts hydrate stored resources;
- add/remove/retain and duplication paths preserve exact evidence; and
- invalid legacy attachment evidence blocks rather than silently degrades.

### C1 Communication And Interim Send Safety

PASS.

- files and external links are visibly distinguished;
- the accepted C1 responsibility notice is explicit and versioned;
- acknowledgement is required before resource-bearing send;
- links are escaped and rendered as supporting links in the email body;
- files still select the intentional R8-A1/R8-A2 send refusal; and
- zero-file batch behaviour remains protected.

## Automated Test Evidence

| Check | Result |
| --- | --- |
| Five focused attachment/scanner/R2/provider suites | PASS - 28 tests |
| TypeScript `tsc --noEmit` | PASS |
| Prisma schema validation | PASS |
| Critical-file verification | PASS |
| Production build | PASS |
| Broader suite excluding unchanged suite-less FUND file | PASS - 119 tests, 12 skipped |
| Diff whitespace validation | PASS |
| Unfiltered full Vitest suite | Baseline harness issue in unchanged suite-less FUND file |

## Required Deployed Human UI And Infrastructure Smoke

The business/testing team must report these results before this record can be closed:

1. confirm the private ClamAV service is healthy and definitions update successfully;
2. configure the dedicated private R2 bucket and confirm no public object URL is exposed;
3. create, save, reopen, add, remove and duplicate clean PDF, Office and ZIP attachments;
4. use the standard EICAR test signature and confirm it is blocked without using real
   malware;
5. confirm scanner unavailable, encrypted and otherwise unscannable inputs fail closed;
6. confirm a fourth file and cumulative content above 10 MB are clearly refused;
7. confirm three HTTPS links are accepted and a fourth is clearly refused;
8. confirm a links-only email uses the proven batch route and received links are clickable;
9. confirm the UI identifies links as external/unscanned and displays the C1 integrity and
   sharing-permission responsibility notice;
10. confirm attachment send remains intentionally blocked with an explicit statement that
    no recipients were sent until R8-A3 exists; and
11. repeat a no-attachment batch send as a live regression smoke.

Record each result in this document, together with environment, tester, date and any defect
references.

## Current Conclusion

R8-A2 passes bounded technical review at application commit `23e87473`. It is paused at the
required deployed human UI/infrastructure gate. Do not create or implement R8-A3 until the
business/testing team reports and accepts this smoke result.
