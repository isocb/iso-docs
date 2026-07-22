# LMSPro Remediation Slice R8-A2R-F1 - Draft Resource State, Rehydration And Attachment Transport Correction Review And Test

Date: 2026-07-22
Module: LMSPro / SeasonPro shared communications
Technical review status: PASS on dedicated corrective branch
Human UI smoke status: PASS on deployed staging
Transport upper-bound status: PASS on deployed staging
Promotion status: R8-A3 planning gate open; production promotion remains separately controlled

Planning source:

`docs/modules/lmspro/03-slice-planning/2026-07-22-lmspro-remediation-slice-r8-a2r-f1-draft-resource-state-rehydration-and-attachment-transport-correction-planning.md`

Implementation confirmation:

`docs/modules/lmspro/04-implementation-confirmations/2026-07-22-lmspro-remediation-slice-r8-a2r-f1-draft-resource-state-rehydration-and-attachment-transport-correction-confirmation.md`

Blocked predecessor review:

`docs/modules/lmspro/05-review-and-test/2026-07-21-lmspro-remediation-slice-r8-a2r-bounded-unscanned-attachment-policy-correction-review-and-test.md`

## Technical Review

### Draft Resource State

PASS by implementation review and focused tests.

- compose mapping is memoised;
- hydration is bound to modal open/draft identity rather than whole-object identity;
- canonical mutation resources replace stale modal state;
- exact draft-query data is reconciled then refreshed; and
- a missing create-query cache is not populated with an incomplete fabricated record.

### File Selection

PASS by deterministic policy tests and implementation review.

- accepted candidates are committed in one state replacement;
- one processing lock prevents overlapping conversions;
- fourth, empty and over-total candidates are refused without consuming a slot;
- later valid candidates remain eligible after an earlier refusal;
- persisted and new sizes share the same cumulative authority; and
- browser/dropzone refusals include filename and reason.

### CSV

PASS for the settled UTF-8 contract.

- ordinary UTF-8 and UTF-8-BOM CSV pass;
- representative browser MIME aliases normalise only for a `.csv` whose content is detected
  as UTF-8 CSV text;
- `.xls` remains refused even when the browser reports the Excel MIME type; and
- UTF-16 remains explicitly refused pending any future business decision.

### Non-JSON Response

PASS for application classification; deployed root status still pending.

Simulated HTML responses at HTTP 413, 502, 504 and 500 produce bounded actionable errors
without invoking the JSON parser or displaying the HTML body. The prior smoke did not record
the actual HTTP status, so this technical proof does not retrospectively label that response
as request-size or timeout failure.

### Delivery Regression

PASS by existing dispatcher/provider regression tests.

No sender-selection, Resend batch adapter, delivery job, schema, environment or R2 publicity
code changed. Links-only and zero-resource delivery continue to select the batch contract;
attachment-bearing delivery remains fail-closed pending R8-A3.

## Automated Evidence

| Check                                  | Result                       |
| -------------------------------------- | ---------------------------- |
| Seven focused communications/R2 suites | PASS - 48 tests              |
| Full Vitest run                        | PASS - 142 tests, 12 skipped |
| TypeScript                             | PASS                         |
| Critical-file verification             | PASS                         |
| Production build                       | PASS                         |
| Focused changed-production-file ESLint | PASS - no errors             |
| Focused formatting                     | PASS                         |
| Application diff whitespace            | PASS                         |

Repository-wide lint is not an F1 acceptance result because it remains blocked by unrelated
pre-existing application errors. No such errors occur in the changed production files.

The resulting cross-cutting platform finding is registered as `PLAT-ASSURE-01` in:

`docs/platform/00-roadmap-control/2026-07-22-isostack-platform-assurance-security-review-and-refinement-roadmap.md`

## Required Human UI Retest

Use fresh drafts and existing drafts. Record each result independently:

1. PASS — save/reopen one small PDF, one accepted image, one TXT and one small UTF-8 CSV;
2. PASS — save/reopen a UTF-8-BOM CSV exported by the representative business tool;
3. PASS — add files one at a time and as one mixed selection, confirming every accepted file stays
   visible and every refused file names its reason;
4. PASS — remove a persisted file, add a replacement, save, close and reopen, confirming the exact
   expected set;
5. PASS — select four permitted small files and confirm the first three are retained and the
   fourth is explicitly refused;
6. PASS — test exactly 10 MB cumulative decoded content and content one byte/one small file above
   the boundary;
7. PASS — confirm prohibited Office/archive/executable/script and mismatched files name their
   refusal rather than disappearing;
8. PASS — add three HTTPS links, save, close and reopen, confirming all three exact labels/URLs;
9. PASS — confirm a fourth link is refused;
10. PASS — send a links-only message and confirm clickable links and batch-route evidence;
11. PASS — reconfirm disclosure and C1 acknowledgement;
12. PASS — reconfirm attachment send states that no email was sent; and
13. PASS — repeat a no-attachment live batch smoke.

The business/testing team reported the complete human smoke as passed on 2026-07-22. Very
minor UI observations remain but do not affect attachment persistence, validation,
rehydration, fail-closed sending or the no-attachment regression contract. They are deferred
to a separately bounded refinement slice and do not block R8-A3 planning.

For any save failure, record from browser Network evidence:

- failing `/api/trpc` request status;
- response `content-type`;
- displayed safe error;
- file names, decoded sizes and browser-reported MIME where available; and
- matching Render log timestamp/request evidence.

Do not copy response HTML, attachment Base64, credentials or private object keys into the
review record.

## Current Conclusion

The bounded correction passes technical and deployed human review, including the 10 MB
transport boundary. The R8-A3 planning gate is open. This result does not itself authorise
production promotion, R8-A3 schema migration or creation of a paid worker service; those
remain governed by their own accepted planning and promotion evidence.
