# FUND Phase 1 Slice 1R-F-A — Local Template Renderer Proof Implementation Confirmation

Date: 2026-08-11

Status: **STAGES A/B LOCALLY IMPLEMENTED; R1B SOURCE-FAITHFUL AUTOMATION AND HUMAN/PHYSICAL
GATES PASS; STAGE B LINUX CONTAINER PARITY AND EXACT SECURITY SCAN PASS AT APPLICATION
`139d09c4`, ALIGNED TO DEV; STAGE C REMAINS UNAUTHORISED**

Planning authority:

[`1R-F-A Real AMOW Template, Pricing And Deployed Renderer Proof`](../03-slice-planning/2026-08-11-fund-phase-1-slice-1r-f-a-real-amow-template-pricing-and-deployed-renderer-proof-planning.md)

Review gate:

[`1R-F-A-R1 local automated, visual and physical review`](../05-review-and-test/2026-08-11-fund-phase-1-slice-1r-f-a-r1-local-template-renderer-proof-review-and-test.md)

Application baseline: exact `cde4eaff1e14b2f02ba0953fe8693e7feb02bb61`

Commit/promotion state: **APPLICATION PROOF `139d09c4` ALIGNED TO LOCAL/REMOTE DEV; STAGE B
RUN `31595635243` AND EXACT DEV SECURITY SCAN `31595635276` PASS; STAGING/MAIN UNCHANGED**

## 1. Outcome

The proof boundary now composes one controlled AMOW Individual Artwork family into real
one-page A4 portrait and landscape HTML previews and PDFs. It uses only checked-in synthetic
fixtures, an embedded checked-in Geist font, a controlled inline C1 proof logo and a
non-routable `example.invalid` Store URL.

It provides:

- portrait STANDARD and landscape COMPACT compositions;
- ordinary, long-content and measured-maximum controlled fixtures;
- Product rows in exact fixture order with already-resolved representative gross prices;
- blank Child First Name, Child Surname, Class/Group, quantity, total and grand-total spaces;
- exactly six empty Store Order Code boxes;
- a visible Store URL and vector QR generated from the same canonical value;
- strict schema, unknown-field, rich-text, logo allowlist and capacity refusal;
- one-page/A4, layout-boundary, Product membership/order, empty-field, font-load and QR
  checks against both browser preview and rasterised PDF;
- normalised repeat-run hashes and a bounded two-attempt retry proof; and
- a machine-readable local evidence report plus reviewable PDF/PNG artefacts.

The measured capacity candidates are ten STANDARD portrait Product rows and twelve COMPACT
landscape Product rows. They are proof findings only and do not become production limits
until physical/human acceptance and later production-contract planning.

## 2. Exact Change Boundary

Application repository changes are limited to:

```text
package.json / package-lock.json
  exact proof-only Playwright, PNG and QR-inspection development dependencies
  isolated proof/test commands

scripts/proofs/fund-1r-f-a/
  controlled contract and fixtures
  React static composition and embedded print stylesheet/assets
  Playwright renderer, PDF inspection, raster and QR verification
  automated proof suite and machine evidence runner
  immutable-digest Dockerfile, proof-only tsconfig and README
  ignored local output directory
```

No Prisma schema/migration, application route, API, production FUND service, authoritative
`render.yaml`, shared data or shared object-store contract changed. The user's pre-existing
`1july2026.code-workspace` modification was not altered by this slice.

## 3. Runtime Lock

| Element | Exact local proof value |
| --- | --- |
| Node proof run | `v22.23.2` |
| Playwright | `1.62.1` |
| Chromium | `151.0.7922.34` |
| Font | `public/fonts/Geist-Regular.woff2`, SHA-256 `9f72423ca4ffaa679eaa7ee67068124966cbcbc7e8b171182d18fadf3b0f6da0` |
| Linux container | `mcr.microsoft.com/playwright:v1.62.1-noble@sha256:dcc5531e97840b9b5e794f2814476b21571c5124a3fca2267d73041f56e7580e` |
| Linux Node source | `node:22.23.2-bookworm-slim@sha256:d649c27dae7ba0137b3cef5dd75baa422c08dc3d9e3fc0c23dfb172dc3cc6436` |
| PDF raster | macOS `sips`; Linux definition installs `poppler-utils` |

The Studio Mac exposes no Docker, Podman, Colima or equivalent runtime. The immutable
container therefore ran in the isolated dev-only GitHub Actions gate. Exact Linux parity run
`31595635243` passes using Node `22.23.2`; the Playwright and Node source images are both
digest-pinned.

No Render Blueprint or Render service was created. Stage C remains unauthorised.

## 4. Controlled Fixtures And Refusals

Accepted fixtures:

1. portrait short content without logo — five Products;
2. landscape short content with controlled C1 logo — six Products;
3. portrait long names/title/instructions — eight Products;
4. landscape long names/title/instructions — nine Products;
5. portrait STANDARD maximum — ten Products; and
6. landscape COMPACT maximum — twelve Products.

Refused before rendering:

- portrait STANDARD eleven-Product one-over fixture;
- landscape COMPACT thirteen-Product one-over fixture;
- script-bearing rich text;
- remote/unallowlisted logo input;
- missing Project number; and
- an unknown template token/field.

## 5. Automated Evidence

Passed locally under Node 22:

```text
npx -y node@22 node_modules/vitest/vitest.mjs run \
  --config scripts/proofs/fund-1r-f-a/vitest.config.ts

Test Files  1 passed
Tests       3 passed
```

The run proved all six valid sheets were one page, exact A4 within one PDF point, inside
their measured page bounds and free of Product/artwork overlap. Both screen and actual PDF
raster QR decoding returned `https://store.example.invalid/p/2541`. The normalised repeat
run produced identical HTML, preview-pixel, PDF-raster-pixel and business/layout hashes.
The controlled transient failure recovered on attempt two; a terminal failure test stopped
after exactly two attempts.

Also passed:

```text
npx tsc --noEmit -p scripts/proofs/fund-1r-f-a/tsconfig.json
npm run type-check
npm audit --audit-level=high  # found 0 vulnerabilities
```

The final pre-commit rerun under Node `22.23.2` / npm `10.9.8` additionally recorded:

```text
proof suite              3 PASS
full application suite   413 PASS / 12 retained SKIP
application TypeScript   PASS
proof TypeScript         PASS
npm audit                0 vulnerabilities
pre-commit gates         PASS
```

The repository ESLint configuration excludes the isolated proof directory, so a direct
directory lint request returned the truthful `all files ignored` configuration result. It
is not represented as an ESLint pass; TypeScript, Vitest and pre-commit gates own this proof
candidate's local static/executable evidence.

Local machine evidence is generated at:

```text
scripts/proofs/fund-1r-f-a/output/evidence-report.json
scripts/proofs/fund-1r-f-a/output/*-preview.png
scripts/proofs/fund-1r-f-a/output/*.pdf
scripts/proofs/fund-1r-f-a/output/*-pdf.png
```

The output directory is intentionally ignored and no generated customer document is being
added to source control.

## 6. Non-Changes And Stop

- no shared database, R2 bucket, customer data or live route was read;
- no Render infrastructure, secret, Blueprint or deployment was created;
- no private-object write/read/delete was attempted because that is Stage C;
- application proof commit `6f9ef016` was created without branch alignment at the time of
  this implementation record update; and
- `1R-F-B`, `1R-G` and `1R-H-A` did not begin.

The linked local visual/physical human gate passed completely. Exact dev alignment and
Security Scan for `6f9ef016` also passed. At that local gate, neither result invented
Linux-container parity.
Stage B container parity is now independently recorded as green; Render/private-object
evidence still requires separate explicit authority.

## 7. R1A Artwork-Area Composition Correction — 2026-08-11

The R1 physical review correctly rejected the available artwork area. A later portrait
sharpness concern was withdrawn when the control owner established that the preview PNG,
not the generated PDF, had been printed. The PDF typography is accepted and was deliberately
not changed.

The bounded R1A correction:

- places Project closing date immediately beside Project number;
- keeps the existing controlled, data-driven instruction content;
- places every portrait variable/input above the artwork;
- uses a two-column portrait upper band for instructions/handwriting fields and the Product/
  Order/QR block;
- gives portrait a full-width `194 × 150 mm` lower artwork area;
- retains the successful landscape type/table proportions while increasing artwork to
  approximately `166 × 128 mm`;
- ranges Store Order Code and QR/URL beneath the Product grid; and
- strengthens automation to refuse portrait artwork below `193 × 149.5 mm`, landscape
  artwork below `165 × 127 mm`, or any portrait supporting block extending into artwork.

The same six accepted and six refused fixtures pass under Node 22. Both preview-region and
PDF-raster-region QR decoding pass after the supporting QR was compacted. Normalised repeat
determinism remains green. No capacity, schema, API, shared-data or production contract was
changed.

The now-superseded R1A human review would have been controlled by:

[`1R-F-A-R1A artwork-area composition correction local gate`](../05-review-and-test/2026-08-11-fund-phase-1-slice-1r-f-a-r1a-artwork-area-composition-correction-local-gate.md)

## 8. R1B Source-Faithful Folding Correction — 2026-08-11

Before R1A human review, the control owner clarified the physical folding authority and
asked that the supplied client composition be followed rather than reinterpreted. Direct
inspection of both supplied source PDFs established:

- landscape is a fold-aware two-panel sheet: organisation, three handwriting fields,
  Product grid, artwork guidance, QR/URL, ordering/return guidance and Order Code on the
  left; Project/date/logo and artwork on the right;
- portrait uses a compact top information/order band and a large lower artwork field;
- Child First Name, Child Surname and Class/Group are three distinct blank fields; and
- artwork guidance and ordering/return guidance are two independently controlled rich-text
  regions.

R1A was therefore superseded before human review. R1B implements the source hierarchy rather
than extrapolating from general layout preferences. The fixture contract now validates and
sanitises both rich-text values independently and rejects either unsafe value.

The fixture contract is now `fund-1r-f-a/v2`. The version increment records the material
source-derived schema change from one instruction field and two handwritten identity fields
to two independent rich-text instruction fields plus Child First Name, Child Surname and
Class/Group. A `v1` fixture therefore fails closed rather than being silently interpreted by
the revised renderer.

Measured R1B artwork is `200 × 192 mm` portrait and approximately `171 × 180 mm` landscape.
Landscape retains a `112 mm` left control panel, an explicit panel gap/fold allowance and a
right artwork panel. QR remains in the source-derived control region but is `18 mm`, the
smallest size proven decodable from the generated preview and the 72-DPI PDF raster.

All six accepted fixtures, six refusal fixtures, one-page A4, bounds, three empty child/class
fields, Product ordering, QR equality, repeat determinism, retry and TypeScript checks pass.
No production content authority, schema, API, shared data or later slice was introduced.

R1B human review is controlled by:

[`1R-F-A-R1B source-fidelity and folding local gate`](../05-review-and-test/2026-08-11-fund-phase-1-slice-1r-f-a-r1b-source-fidelity-and-folding-local-gate.md)

## 9. Stage B Linux Container Parity — 2026-08-12

The dev-only workflow, retained diagnostic evidence and immutable Node 22 runtime correction
are recorded in the dedicated
[`Stage B Linux container parity gate`](../05-review-and-test/2026-08-12-fund-phase-1-slice-1r-f-a-stage-b-linux-container-parity-gate.md).

Exact application `139d09c4` is aligned to local/remote dev. Linux run `31595635243` passes
all six accepted fixtures, all six refusals, exact normalised business/layout comparison,
repeat determinism, QR and strict portrait monochrome checks. Exact Security Scan
`31595635276` also passes. Staging/main are unchanged, no shared data or Render infrastructure
was used, and Stage C remains unauthorised.
