# FUND Phase 1 Slice 1R-F-A-R1A — Artwork-Area Composition Correction Local Gate

Date: 2026-08-11

Status: **SUPERSEDED BEFORE HUMAN REVIEW; INFERRED COMPOSITION REPLACED BY SOURCE-FAITHFUL
R1B FOLDING LAYOUT; NOT AN ACCEPTED DESIGN GATE**

Parent failed gate:

[`1R-F-A-R1 local review`](2026-08-11-fund-phase-1-slice-1r-f-a-r1-local-template-renderer-proof-review-and-test.md)

Implementation confirmation:

[`1R-F-A local implementation confirmation`](../04-implementation-confirmations/2026-08-11-fund-phase-1-slice-1r-f-a-local-template-renderer-proof-implementation-confirmation.md)

## 1. Evidence Correction And Scope

The R1 report of unsharp portrait text was caused by printing the PNG preview at 100%.
The correct vector PDF is perfectly legible. Do not test print quality from a PNG. R1A
changes composition only and preserves the accepted PDF typography.

R1A must prove:

- portrait gives the lower half of physical A4 to full-width artwork;
- all portrait variables, guidance and handwriting inputs remain above artwork;
- landscape retains its accepted visual/type quality while enlarging artwork;
- Product, Order Code, URL and QR remain usable in their consolidated commerce block; and
- none of the established validation, capacity, one-page, QR or deterministic guarantees
regress.

## 2. Automated Result

| Gate | Result |
| --- | --- |
| Six valid and six refused fixtures | PASS |
| Portrait artwork minimum `193 × 149.5 mm` | PASS — measured approximately `194 × 150 mm` |
| Portrait header/metadata/commerce wholly above artwork | PASS |
| Landscape artwork minimum `165 × 127 mm` | PASS — measured approximately `166 × 128 mm` |
| Project closing date adjacent to Project number | PASS |
| One-page exact A4 portrait/landscape | PASS |
| Product membership/order, empty fields and six code boxes | PASS |
| Preview-region and PDF-raster-region QR decoding | PASS |
| No remote resource/shared data | PASS |
| Repeat determinism and bounded retry | PASS |
| Node 22 proof suite | PASS — 3/3 |
| Stage B Linux container execution | PENDING — no local runtime available |

## 3. Correct Artefacts

Review and print the generated **PDFs**, not the PNG previews:

```text
scripts/proofs/fund-1r-f-a/output/portrait-standard-maximum.pdf
scripts/proofs/fund-1r-f-a/output/landscape-compact-maximum.pdf
```

The PNGs may be used only for quick on-screen composition review.

## 4. Focused Human Smoke

Record `PASS`, `PARTIAL` or `FAIL`:

1. **[ ]** Portrait Project number and Store closing date are legible and grouped together.
2. **[ ]** Portrait guidance, Child's Name, Class/Group, Products, Order Code and QR/URL all
   remain above the artwork without crowding its boundary.
3. **[ ]** Portrait artwork occupies the full printable lower half and is practically large
   enough for the child artwork workflow.
4. **[ ]** Portrait PDF Product text is sharp and legible at Actual size/100%; confirm the
   artefact being printed is `.pdf`, not `-preview.png` or `-pdf.png`.
5. **[ ]** Portrait ten-row Product grid, blank quantity/total cells and six Order Code boxes
   remain practically readable/writable after consolidation.
6. **[ ]** Portrait QR scans to the exact controlled URL on two representative devices.
7. **[ ]** Landscape retains the previously accepted sharp typography, logo and Product
   presentation.
8. **[ ]** Landscape's taller artwork area is materially better and practically useful.
9. **[ ]** Landscape Order Code, QR/URL and twelve-row Product grid remain usable.
10. **[ ]** Landscape QR scans to the exact controlled URL on two representative devices.
11. **[ ]** Ordinary and long-content portrait/landscape previews show no collision,
    clipping, hidden important content or malformed logo absence/presence.
12. **[ ]** The instruction content is visibly variable proof data rather than an immutable
    background; production content authority remains later work.

Print settings for both PDFs:

```text
Actual size / 100%
Fit or Scale to fit: OFF
Borderless enlargement: OFF
Correct orientation selected
```

## 5. Evidence Record

| Evidence | Result / details |
| --- | --- |
| Portrait PDF physical result | PENDING |
| Landscape PDF physical result | PENDING |
| Printer make/path | PENDING |
| QR device 1 | PENDING |
| QR device 2 | PENDING |

Overall R1A result: **SUPERSEDED — NOT HUMAN TESTED OR ACCEPTED**

The control owner clarified that the supplied landscape layout is physically fold-aware and
that its content sequence must be retained. The source portrait also uses a materially
larger lower artwork area. R1A was therefore retired rather than tested. Continue only at:

[`1R-F-A-R1B source-fidelity and folding local gate`](2026-08-11-fund-phase-1-slice-1r-f-a-r1b-source-fidelity-and-folding-local-gate.md)

Stop after recording this gate. Do not commit, create Render infrastructure, use shared
data or begin `1R-F-B`, `1R-G` or `1R-H-A` without a new explicit instruction.
