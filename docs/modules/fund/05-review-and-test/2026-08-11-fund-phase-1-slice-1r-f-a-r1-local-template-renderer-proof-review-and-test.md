# FUND Phase 1 Slice 1R-F-A-R1 — Local Template Renderer Proof Review And Test

Date: 2026-08-11

Status: **HISTORICAL R1 PHYSICAL COMPOSITION FAIL; PORTRAIT TEXT-SHARPNESS CONCERN
WITHDRAWN AFTER CONTROL-OWNER CONFIRMED THE PNG, NOT PDF, WAS PRINTED; INFERRED R1A
SUPERSEDED BEFORE REVIEW; CONTINUE AT SOURCE-FAITHFUL R1B; NO COMMIT OR DEPLOYMENT**

Implementation confirmation:

[`1R-F-A local implementation confirmation`](../04-implementation-confirmations/2026-08-11-fund-phase-1-slice-1r-f-a-local-template-renderer-proof-implementation-confirmation.md)

## 1. Automated Review Result

| Gate | Result |
| --- | --- |
| Six controlled valid fixtures | PASS |
| Six unsafe/incomplete/one-over fixtures refused | PASS |
| One PDF page per valid fixture | PASS |
| A4 portrait/landscape PDF dimensions within 1 point | PASS |
| Page/component bounds and browser overflow | PASS |
| Protected artwork/Product-table separation | PASS |
| Exact ordered Product membership and resolved price strings | PASS |
| Blank child/class/quantity/total fields | PASS |
| Six equal empty Store Order Code boxes | PASS |
| Embedded font loaded; no remote resource request | PASS |
| Visible canonical Store URL equals QR payload | PASS |
| QR decodes from screen preview and rasterised PDF | PASS |
| Normalised local repeat determinism | PASS |
| Two-attempt bounded retry and terminal stop | PASS |
| Proof-specific and full application TypeScript | PASS |
| Dependency advisory scan | PASS — 0 vulnerabilities |
| Immutable Linux Dockerfile definition | PASS — definition only |
| Linux container build/run and cross-platform comparison | PENDING — no local runtime available |
| Private proof-object round trip | NOT RUN — Stage C not authorised |

Automated evidence was generated under Node `v22.23.2`, Playwright `1.62.1`, Chromium
`151.0.7922.34` and the recorded Geist font checksum. The output report truthfully marks
`LOCAL_STAGE_A_PASS_STAGE_B_CONTAINER_EXECUTION_PENDING`.

### 1.1 Control-Owner Evidence Correction — 2026-08-11

The initial follow-up observation that portrait text/Product-grid text was unsharp is
withdrawn. The control owner discovered that the preview PNG had been printed at 100%, not
the generated vector PDF. On inspection/print of the correct portrait PDF, its text is
perfectly legible. This was a test-execution error, not a renderer or font defect.

The valid composition findings remain: portrait must use the lower half of A4 for artwork
with its variables and inputs above; landscape is visually strong but should still give
more space to artwork. Those initial findings produced an inferred R1A composition. Before
its human review, the source folding/layout authority was clarified and R1A was superseded.
Continue at the [`1R-F-A-R1B source-fidelity gate`](2026-08-11-fund-phase-1-slice-1r-f-a-r1b-source-fidelity-and-folding-local-gate.md).

## 2. Local Human Review Preparation

Review these generated files from the application repository:

```text
scripts/proofs/fund-1r-f-a/output/portrait-short-no-logo-preview.png
scripts/proofs/fund-1r-f-a/output/landscape-short-with-logo-preview.png
scripts/proofs/fund-1r-f-a/output/portrait-long-content-preview.png
scripts/proofs/fund-1r-f-a/output/landscape-long-content-preview.png
scripts/proofs/fund-1r-f-a/output/portrait-standard-maximum-preview.png
scripts/proofs/fund-1r-f-a/output/landscape-compact-maximum-preview.png
```

Open the corresponding `.pdf` files from the same directory for PDF/physical review. Use
controlled proof data only. Do not substitute customer, child, Order or payment data.

## 3. Visual Fidelity Smoke

Record `PASS`, `PARTIAL` or `FAIL` beside each item:

1. **[PASS]** Portrait/no-logo and landscape/C1-logo are recognisably two purposeful
   compositions of the supplied AMOW Individual Artwork family, not a rotated single page.
2. **[PARTIAL]** Organisation, Project name, Project number, Project closing date, title and Store
   route are legible, correctly grouped and do not collide at ordinary or long content.
   NOTE: Store closing date should be next to Project number. The supporting text: Create your picture inside the artwork area. Keep names and order details in the labelled boxes only. should be client defined... Child name and Class/Group text entry is too close to the artwork space. The artwork space is critical and should be maximised... the product table should be reduced in width. the store order number and QR/url should be ranged under the product grid to give the artwprk maximum space to fill over half of the portrait sheet.

   That sounds a lot, but the landscape version is brilliant.  The portrait verison - very similar comments.  Without losing the beauty of the work you've done we need to maximise the artwork area (which is the main point of the temaplte.)
3. **[Pass]** The landscape C1 logo is contained without distortion; the portrait absent-logo
   state is deliberate and leaves no broken-image or misleading placeholder.
4. **[PARTIAL: Move slightly further up and awaty from the artwork space.]** Child's Name and Class/Group remain empty, clearly labelled and practically
   writable; no child identity is generated.
5. **[ PARTIAL - needs to be enlarged]** The protected artwork area is visually dominant, unobstructed and usable in both
   orientations, including at the candidate maximum Product count.
6. **[PASS]** Every selected Product appears once, in the shown order, with an unambiguous gross
   price; quantity, total and grand total remain empty for handwriting.
7. **[PASS]** Ten-row STANDARD portrait and twelve-row COMPACT landscape tables remain readable.
   Treat either as a rejected capacity if its type or writing cells are too small in print.
8. **[PASS]** Exactly six empty Store Order Code boxes are visually distinct from the printed
   Project number and are large enough for manual six-digit transcription.
9. **[PASS]** The visible URL and QR are clear, separated from writable fields and consistent
   between screen preview and PDF.
10. **[PASS]** Long titles/instructions/Product names wrap or truncate only where visually
    acceptable; no important content is hidden.

## 4. Actual-Size Physical Print Gate

Print these two PDFs at **Actual size / 100%**, explicitly disabling `Fit`, `Scale to fit`
and borderless enlargement:

```text
portrait-standard-maximum.pdf
landscape-compact-maximum.pdf
```

Then record:

1. **[PASS]** Paper measures A4: portrait `210 × 297 mm`; landscape `297 × 210 mm`.
2. **[PASS]** The intended outer safe inset is approximately `8 mm`; no line, word, QR module
   or writing box is clipped by the printer's non-printable area.
3. **[PASS]** Portrait code boxes are approximately `11 × 13 mm`; landscape boxes are
   approximately `12 × 12 mm`; all six accept clear handwritten digits.
4. **[PASS]** Child/Class, quantity, total and grand-total areas accept ordinary handwriting.
5. **[PARTIAL - No minimum order text yet]** Minimum Product/instruction text is comfortably legible under normal office light.
6. **[FAIL - Too small]** Protected artwork areas remain practically useful after real printer margins.
7. **[PASS]** Scan each printed QR using two representative phones/devices. Both must resolve
   the exact controlled text `https://store.example.invalid/p/2541`. Because `.invalid` is
   intentionally non-routable, a browser DNS failure after displaying that exact URL is
   expected; the scan text, not navigation success, is the test.
8. **[PASS]** If possible, repeat on a second ordinary office-printer path. If only one printer
   is available, record the physical-printer result as `PARTIAL`, not a universal pass.

Printer/device evidence — complete during review:

| Evidence | Result / details |
| --- | --- |
| Printer 1 make/path | PENDING |
| Printer 2 make/path, if available | PENDING |
| QR device 1 | PENDING |
| QR device 2 | PENDING |
| Portrait physical result | PENDING |
| Landscape physical result | PENDING |

## 5. Negative Review

1. Run `npm run test:proof:fund:1r-f-a` under Node 22 and confirm the six refusal records
   remain present in `output/evidence-report.json`.
2. Confirm neither one-over fixture produces an HTML, PNG or PDF artefact.
3. Confirm the report says shared data `false`, Render infrastructure `false` and private
   object round trip `NOT_AUTHORISED_STAGE_C`.
4. Confirm no generated sheet contains real child, customer, Order, payment or tenant data.

## 6. Stage B Container Evidence Gap

The repository contains the accepted immutable-digest Dockerfile, but the Studio Mac has no
container runtime. Do not mark Stage B execution green from the Dockerfile alone. When a
local Docker-compatible runtime becomes available, use the two documented README commands,
capture the Linux runtime identity/report, and compare:

- Node, Playwright, Chromium and font identities;
- six fixture/refusal outcomes;
- page dimensions, component geometry and Product ordering;
- screen/PDF QR payloads; and
- normalised Linux repeat determinism.

Raw macOS and Linux raster hashes are diagnostic and need not be byte-identical. Any
material geometry, line-wrap, capacity or QR difference is a Stage B failure and requires a
bounded correction before Stage C.

## 7. Control-Owner Result

Overall R1 local human result: **FAIL — ARTWORK-AREA COMPOSITION ONLY; PDF TYPE LEGIBILITY
PASS AFTER EVIDENCE CORRECTION**

Notes:

```text
R1 identified insufficient physical artwork area. The reported portrait text-sharpness
problem is void because the wrong artefact type was printed. The inferred R1A correction
was superseded before review; source-faithful R1B is the current bounded gate.
```

Stop after recording the result. Do not commit, create Render infrastructure, use shared
data or begin `1R-F-B`, `1R-G` or `1R-H-A` without a new explicit instruction.
