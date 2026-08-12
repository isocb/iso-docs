# FUND Phase 1 Slice 1R-F-A — Stage B Linux Container Parity Gate

Date: 2026-08-12

Status: **PASS — EXACT APPLICATION COMMIT `139d09c4` IS ALIGNED TO LOCAL/REMOTE DEV;
LINUX CONTAINER PARITY RUN `31595635243` AND EXACT SECURITY SCAN `31595635276` PASS;
STAGING/MAIN UNCHANGED; STAGE C REMAINS A SEPARATE AUTHORITY DECISION**

Planning authority:

[`1R-F-A Real AMOW Template, Pricing And Deployed Renderer Proof`](../03-slice-planning/2026-08-11-fund-phase-1-slice-1r-f-a-real-amow-template-pricing-and-deployed-renderer-proof-planning.md)

Implementation confirmation:

[`1R-F-A implementation confirmation`](../04-implementation-confirmations/2026-08-11-fund-phase-1-slice-1r-f-a-local-template-renderer-proof-implementation-confirmation.md)

Accepted source/physical gate:

[`1R-F-A-R1B source-fidelity and folding local gate`](2026-08-11-fund-phase-1-slice-1r-f-a-r1b-source-fidelity-and-folding-local-gate.md)

## 1. Exact Boundary

Stage B executed the six accepted and six refused synthetic fixtures in an immutable Linux
container through a dev-only GitHub Actions workflow. It compared the Linux result with the
accepted Mac evidence and retained synthetic evidence for 30 days.

It did not:

- deploy the application or promote `staging`/`main`;
- create a Render worker, Blueprint, secret or shared service;
- read or write customer, child, Order, payment, database or shared object-store data;
- perform the separately controlled Stage C private-object round trip; or
- start `1R-F-B`, `1R-G` or parked `1R-H-A`.

## 2. Reproducible Diagnostic Sequence

The gate was allowed to fail closed while its environment assumptions were proved:

| Exact commit / run | Result | Finding and bounded response |
| --- | --- | --- |
| `c35887a3` / `31594584036` | FAIL | Linux stopped at the portrait monochrome assertion before retaining enough detail. No acceptance claim was made. |
| `6c2de315` / `31594977537` | FAIL | Retained evidence proved the PDF raster had zero non-neutral pixels and the PDF had no pattern/shading resources; only the Linux screen preview used coloured LCD subpixel antialiasing. |
| `fd73a1ba` / `31595277972` | FAIL | Grayscale preview antialiasing allowed all six renders to pass, but the comparator correctly refused the Playwright image's bundled Node 24 runtime against the application Node 22 contract. |
| `139d09c4` / `31595635243` | **PASS** | Official Node `22.23.2` was added as an immutable pinned source layer; the complete render, comparison and evidence workflow passed. |

The acceptance assertion was not weakened. Preview pixels, PDF-raster pixels and PDF
pattern/shading checks all remain mandatory for portrait output. The correction removed
platform-specific LCD colour fringes from the evidence preview and pinned the required Node
runtime explicitly.

## 3. Exact Runtime Identity

| Element | Successful Linux value |
| --- | --- |
| Platform | `linux/x64`; kernel `6.17.0-1020-azure` |
| Node | `v22.23.2` |
| Playwright / Chromium | `1.62.1` / `151.0.7922.34` |
| Font | `public/fonts/Geist-Regular.woff2`, SHA-256 `9f72423ca4ffaa679eaa7ee67068124966cbcbc7e8b171182d18fadf3b0f6da0` |
| Playwright image | `mcr.microsoft.com/playwright:v1.62.1-noble@sha256:dcc5531e97840b9b5e794f2814476b21571c5124a3fca2267d73041f56e7580e` |
| Node source image | `node:22.23.2-bookworm-slim@sha256:d649c27dae7ba0137b3cef5dd75baa422c08dc3d9e3fc0c23dfb172dc3cc6436` |

## 4. Acceptance Evidence

| Gate | Result |
| --- | --- |
| Six accepted fixtures | PASS |
| Six unsafe/overflow refusal fixtures | PASS |
| Linux repeat determinism | PASS |
| Contract, capacity, scope and runtime-identity comparison | PASS |
| Exact normalised business/layout hash equality | PASS — 6/6 fixtures |
| Portrait preview pixel neutrality | PASS — 3/3 portrait fixtures |
| Portrait PDF-raster pixel neutrality | PASS — 3/3 portrait fixtures |
| Portrait PDF pattern/shading resources absent | PASS — 3/3 portrait fixtures |
| Preview and PDF-raster QR equality with the controlled Store URL | PASS — 6/6 fixtures |
| Artwork dimensions | PASS — portrait `200 × 192.01 mm`; landscape approximately `171.01 × 180.01 mm` |
| Shared data / Render infrastructure | PASS — neither used nor created |

Raw Mac/Linux preview and PDF-raster hashes differ, as the accepted comparison policy
anticipated for different operating-system rasterisers. They are retained as diagnostic
evidence and are not substituted for the mandatory exact normalised business/layout hash.
Direct inspection of the retained maximum portrait and landscape previews found no material
composition, wrapping, capacity or artwork-area regression.

Successful evidence artifact:

```text
fund-1r-f-a-stage-b-139d09c476cb7d250eba5e234eefb76f087f9ab5
```

It contains the Linux machine report, Stage B parity report and the synthetic HTML, preview,
PDF, PDF raster and QR crop for every accepted fixture.

## 5. Required Exact-Commit Gates

- [Linux Container Parity `31595635243`](https://github.com/isocb/isostack-bedrock/actions/runs/31595635243) — **PASS**;
- [Security Scan `31595635276`](https://github.com/isocb/isostack-bedrock/actions/runs/31595635276) — **PASS**; and
- local TypeScript, three-proof Vitest suite and pre-commit checks — **PASS**.

Application repository state at closure:

```text
local dev = origin/dev = 139d09c476cb7d250eba5e234eefb76f087f9ab5
origin/staging = origin/main = cde4eaff1e14b2f02ba0953fe8693e7feb02bb61
```

The unrelated local `1july2026.code-workspace` modification remains untouched.

## 6. Disposition And Stop

Stage B is complete and green. The next portfolio action is the explicit Stage C authority
decision already required by the accepted plan. A Stage B pass does not silently authorise
temporary Render infrastructure or private-object credentials.

If Stage C is authorised, execute only that isolated one-run/zero-residue proof and then
conclude `1R-F-A`. If Stage C is declined, record that decision, conclude `1R-F-A` on its
accepted local, physical and Linux evidence, and deliberately select the next bounded FUND
slice. In either case, stop before `1R-F-B`, `1R-G` or `1R-H-A` without new authority.
