# FUND Phase 1 Slice 1R-F-A-R1B — Source Fidelity And Folding Local Gate

Date: 2026-08-11

Status: **SOURCE-FAITHFUL IMPLEMENTATION, AUTOMATION AND PDF/PHYSICAL HUMAN REVIEW PASS;
APPLICATION PROOF COMMIT `139d09c4` ALIGNED TO DEV; STAGE B LINUX PARITY AND EXACT SECURITY
SCAN PASS; NO DEPLOYMENT**

Source design evidence:

- [portrait reference](https://drive.google.com/file/d/11JtpEq2aO6yC2PAikOa03-gdSQZm67ez/view?usp=drivesdk)
- [landscape folding reference](https://drive.google.com/file/d/1qDHo_2sKX4s3ZipdGyk1QrQONJ7D73jU/view)

Implementation confirmation:

[`1R-F-A implementation confirmation`](../04-implementation-confirmations/2026-08-11-fund-phase-1-slice-1r-f-a-local-template-renderer-proof-implementation-confirmation.md)

## 1. Exact Review Boundary

This gate reviews fidelity to the current client composition and its physical folding
function. It does not invite a general redesign.

- Landscape left panel: organisation/project context, Child First Name, Child Surname,
  Class/Group, Product grid, first rich-text artwork-guidance block, QR/URL, second rich-text
  ordering/return block and six-box Store Order Code.
- Landscape right panel: Project number, closing date and C1 logo above the artwork.
- Portrait: the equivalent content hierarchy compressed into a top band, with artwork below.
- Both rich-text blocks are separately data-driven and sanitised.
- Both outputs remain blank of child, purchaser and Order identity.

## 2. Automated Result

| Gate | Result |
| --- | --- |
| Six valid and six refused fixtures | PASS |
| Portrait artwork target at least `155 × 180 mm` | PASS — `200 × 192 mm` |
| Landscape artwork target at least `155 × 175 mm` | PASS — approximately `171 × 180 mm` |
| Landscape `112 mm` folding/control panel retained | PASS |
| Three separate empty handwritten fields | PASS |
| Two separately sanitised rich-text inputs | PASS |
| Versioned source-derived fixture contract | PASS — `fund-1r-f-a/v2`; stale `v1` fails closed |
| Exact Product order and gross-price strings | PASS |
| Six empty Store Order Code boxes | PASS |
| One-page exact A4 and bounded geometry | PASS |
| 18 mm QR preview/PDF-raster decode and URL equality | PASS |
| No remote resources or shared data | PASS |
| Repeat determinism and bounded retry | PASS |
| Node 22 proof suite | PASS — 3/3 |
| Stage B Linux container execution | PASS — exact run `31595635243` at application `139d09c4` |

## 3. Artefacts And Print Rule

Print only these PDFs at Actual size/100%:

```text
scripts/proofs/fund-1r-f-a/output/portrait-standard-maximum.pdf
scripts/proofs/fund-1r-f-a/output/landscape-compact-maximum.pdf
```

Do not print `-preview.png` or `-pdf.png`. Disable Fit/Scale to fit and borderless
enlargement.

## 4. Human Source-Fidelity Smoke

Record `PASS`, `PARTIAL` or `FAIL`:

1. **[ PASS]** Landscape clearly preserves a fold-aware left control panel and right artwork
   panel rather than presenting a generic two-column page.
2. **[ PASS]** Landscape Project number, closing date and C1 logo sit above the right artwork.
3. **[ PASS]** Landscape left panel presents Child First Name, Child Surname and Class/Group as
   three separate blank handwritten inputs.
4. **[ PASS]** Landscape sequence is Product grid, artwork-guidance rich text, QR/URL,
   ordering/return rich text, then Order Code; no region is moved across the fold.
5. **[PASS ]** Landscape artwork is approximately `171 × 180 mm`, folds/prints correctly and is
   practically adequate.
6. **[ PASS]** Portrait retains the same business hierarchy in its top band, with all content
   above an approximately `200 × 192 mm` artwork area.
7. **[ PASS]** Both PDFs remain sharp and legible at Actual size/100%, including maximum Product
   counts and long controlled content.
8. **[ PASS]** Both rich-text blocks are visibly distinct and contain the expected controlled
   fixture content without clipping.
9. **[ PASS]** Six Order Code boxes and blank Product quantity/total cells are writable.
10. **[ PASS]** Both printed 18 mm QR codes scan to
    `https://store.example.invalid/p/2541` on two representative devices.
11. **[PASS ]** Portrait/no-logo and landscape/C1-logo states remain intentional and undistorted.
12. **[ PASS]** The result is sufficiently faithful that remaining typography/copy refinement
    can be client-led rather than requiring another structural reinterpretation.

## 5. Evidence Record

| Evidence | Result / details |
| --- | --- |
| Portrait PDF physical result | PASS |
| Landscape PDF physical/folding result | PASS |
| Printer make/path | PASS |
| QR device 1 | PASS |
| QR device 2 | PASS |

Overall R1B result: **PASS — 12/12 HUMAN CHECKS, PHYSICAL PORTRAIT/LANDSCAPE AND TWO-DEVICE
QR EVIDENCE GREEN**

The control owner then authorised the documented next gate. Exact proof commit `6f9ef016`
is aligned to `origin/dev`; exact Security Scan
[`31589031306`](https://github.com/isocb/isostack-bedrock/actions/runs/31589031306) passes all
secret, TypeScript, dependency, schema and consolidated-report jobs. This does not close the
Stage B later passed in the dedicated
[`Linux container parity gate`](2026-08-12-fund-phase-1-slice-1r-f-a-stage-b-linux-container-parity-gate.md).
That result does not authorise Render infrastructure, shared data, `1R-F-B`, `1R-G` or
`1R-H-A`.
