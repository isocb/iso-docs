# PLAT-ASSURE-05 — Security Dependency Implementation Confirmation

Date: 2026-09-10

Status: **Implemented at `0397bba9` and pushed through dev/staging; main/live on hold for specific approval and remaining acceptance.**

Candidate: application `0397bba9`, branch `work/platform-security-2026-09-10`, parent
`14077382`. Control depth: **High**. Work type: production build.

## Delivered Boundary

| File | Actual change |
| --- | --- |
| package.json | Next 15.5.21 -> 15.5.25; Sharp override 0.35.3 -> 0.35.4; js-yaml override 4.3.1 -> 4.3.2 |
| package-lock.json | Updated the corresponding package/native-library records; 40 changed records including root metadata |
| scripts/next-node-middleware-body-finalize-patch.mjs | Exact-version guard moved to 15.5.25; awaited body-finalisation correction retained |
| scripts/next-node-middleware-body-finalize-patch.test.ts | Manifest/guard agreement and refusal of the formerly supported version |
| scripts/security/test-image-runtime.mjs | Benign installed/standalone image-processing proof, unsafe decoder-version checks and source/input refusal |

The lock diff is confined to Next/@next, Sharp/@img (including its nested WASM runtime),
js-yaml and root metadata. Next remains on 15.x; auth/editor dependencies and the audit
validator/workflow are unchanged. No FUND source, schema, migration or environment file is
included. No credential or real configuration was copied into the isolated checkout.

## Local Evidence

| Check | Result and limit |
| --- | --- |
| Toolchain and clean npm ci | PASS — Node 22.23.2/npm 10.9.8; lifecycle scripts applied backport and generated a separate Prisma client |
| Dependency resolution | PASS — Next 15.5.25, Sharp 0.35.4, js-yaml 4.3.2; npm ls exits successfully |
| Fresh audit with unchanged validator | PASS — 0 Critical, 0 High, 30 Moderate, 5 Low; total 35 affected package entries |
| Prior failure evidence | Retained run 34448484097; downloaded report independently refused by the same validator |
| Full suite | PASS — 81 files, 512 tests; 1 file/12 opt-in database tests skipped |
| TypeScript | PASS — production build and commit hook |
| Production standalone build | PASS — all 131 pages; candidate source built before commit, so embedded build ID is the parent and this artefact is not deployment identity evidence |
| Critical files | PASS — verifier run with its redundant type-check skipped; full type-check obtained separately |
| Focused script lint | PASS — explicit ESLint recommended syntax rules, zero errors/warnings; repository config excludes scripts and cannot provide this check |
| Backport runtime | PASS — small body, 20 repeated representative PDF-equivalent bodies, one 10 MB binary/Base64 envelope; isolated random loopback server stopped |
| Installed image runtime | PASS — JPEG/PNG/AVIF -> resized WebP; safe decoder and remote-source/input refusal |
| Standalone image runtime | PASS — JPEG/PNG resize; unknown libheif metadata causes AVIF decoding refusal and unchanged pass-through |
| Diff and credential scan | PASS — five intended files, no environment files, credential assignments, private keys, bearer tokens or database URLs |

The sandbox initially blocked the existing Chromium test and loopback/tsx IPC. Approved
reruns passed. The normal lint command ignores scripts; forcing the repository TypeScript
project configuration also excludes them. An explicit focused script lint was therefore
used without changing repository lint configuration.

## Image Packaging Finding

The installed runtime reports Sharp 0.35.4, libheif 1.23.2 and libvips 8.18.6 on macOS arm64.
Next's standalone trace omits the native libheif version metadata: the packaged Sharp
reports its own/libvips versions but no libheif version. The first proof correctly refused
to claim AVIF decoding support in that artefact. Inspection confirmed the new Next guard
disables the decoder and passes AVIF through unchanged. The final proof explicitly checks
that safe outcome, including a refused Sharp decode, rather than assuming resizing.
Normal Render configuration uses next start with the installed dependency tree; its Linux
native-runtime evidence remains a staging gate.

## Isolation And Next Boundary

Checkout: `/private/tmp/isostack-security-2026-09-10`. All configuration used for runtime
proof was synthetic, with a non-service database target; no database operation was run.
Fixtures are generated in memory, the existing renderer test cleans its temporary output,
and the request-body proof stops its child server. The checkout is retained for review.

FUND remains clean at `29104b55` with its original installed Next 15.5.21. Its server,
dependencies, Prisma output, DevData and ongoing human smoke were not changed. The security
fix is not yet integrated there. Dev/staging and their origins are now `0397bba9`; main and origin/main remain `14077382`.

Historical publication block: automatic approval review rejected `git push -u origin work/platform-security-2026-09-10`
to the verified private `isocb/isostack-bedrock` repository because explicit approval for
that payload/destination was required. No push, remote scan, protected promotion or deploy
occurred during that implementation turn. Chris subsequently explicitly authorised pushing
the correction through dev and staging, then stopping before main/live. Publication and
work-branch Security Scan 34463542270 now pass. Complete the [05 review/test gates](../05-review-and-test/2026-09-10-isostack-platform-plat-assure-05-next-sharp-js-yaml-review-and-test.md)
under that authority; independent review and human staging acceptance remain open before main/live.

The subsequent authorised promotion is recorded in 05: exact work/dev/staging security
scans and Linux renderer parity pass; remaining deployment/acceptance checks are tracked
there. Public staging health/access/image probes pass without a claim of exact
Render deployment identity. Main/live was not promoted.
