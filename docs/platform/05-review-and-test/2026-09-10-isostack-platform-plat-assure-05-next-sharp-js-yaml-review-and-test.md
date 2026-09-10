# PLAT-ASSURE-05 — Security Dependency Review And Test

Date: 2026-09-10

Status: **Exact `0397bba9` promoted through main; three local/remote branches aligned; main Security Scan, reported staging UI and public production probes PASS; exact Render/runtime and separate review remain unproven.**

Latest disposition: Chris subsequently requested FUND dev/staging promotion. Those branches
now advance with FUND plus this security correction; main remains security-only `0397bba9`.
The three-branch alignment below is historical security-promotion evidence. Root Now returns
to FUND B1; exact security Render/native-runtime identity and separate review remain unproven.

Candidate: `0397bba9` on `work/platform-security-2026-09-10`, parent `14077382`.
Control depth: **High**. Environment proven: isolated macOS arm64, Node 22.23.2/npm 10.9.8.

## Review Result And Evidence Limits

Implementer source review confirms the five-file change stays within the
[bounded plan](../03-slice-planning/2026-09-10-isostack-platform-plat-assure-05-next-sharp-js-yaml-remediation-planning.md).
The reviewed lock records are exclusively the accepted dependency families and their
native/WASM components. The exact-version and source-context guards still fail closed;
the missing-await correction is present in installed and standalone Next runtimes.

The fresh audit passes the unchanged gate with **0 Critical, 0 High, 30 Moderate and 5 Low**.
The old protected report still fails; no severity threshold or advisory exemption changed.
The remaining Moderate/Low work belongs to PLAT-ASSURE-04-R1, including the Vitest advisory.
No overall zero-vulnerability or compromise investigation claim is made.

Full local regression passes **512 tests**, with **12 database tests skipped**. TypeScript,
131-page production build, critical-file checks, focused script lint, credential/whitespace
review and request-body/image proofs pass. The existing request-body test exercises 22
requests after readiness and stops its loopback server. The new image proof covers:

- installed patched libheif decoding JPEG, PNG and AVIF into resized WebP;
- unsafe/unknown libheif versions refused by the actual Next security guard;
- allowed remote source accepted, unlisted source, wrong scheme and recursive source refused;
- invalid image input refused; and
- standalone JPEG/PNG processing plus blocked AVIF decoding and unchanged pass-through
  when native version metadata is unavailable.

The normal installed and standalone image paths are explicitly distinguished. macOS proof
does not substitute for Linux/native packaging or deployed configuration proof. The build
predates the commit object and embeds its parent build ID; use a fresh exact candidate
build for deployment identity checks. The 04 record retains the detailed validation limits.

## Promotion Authority And Remaining Gates

Chris explicitly instructed publication and promotion to dev/staging, with a specific
approval required before main/live. This resolves the prior automatic-review publication
block and authorises the controlled technical promotion through staging. Independent
review remains unproven and is retained as an open main/live gate; this instruction is
not recorded as an independent source review or human staging PASS.

| Gate | Current result | Required evidence |
| --- | --- | --- |
| Publish isolated candidate | PASS | Chris explicitly authorised publication and dev/staging promotion; remote work branch is exact `0397bba9` |
| Exact work-branch Security Scan | PASS | [Run 34463542270](https://github.com/isocb/isostack-bedrock/actions/runs/34463542270), exact `0397bba9`; dependency, secret, schema, TypeScript and summary jobs pass |
| Independent source/security review | NOT OBTAINED | Implementer re-review and exact automated evidence retained; Chris reaffirmed execution after this limit was disclosed. No separate review PASS is claimed |
| Protected dev/staging scans | PASS | Exact `0397bba9`; dev run 34463792299 and staging run 34464073290 |
| Linux/native image/runtime proof | PARTIAL | Exact Linux renderer parity run 34463792371 PASS; this does not prove the Next image decoder. Deployed Linux Sharp/libheif identity and image/runtime proof remain open |
| Staging human smoke | PASS — reported UI scope | Chris confirms IsoStack/LMSPro entry, login/logout, correct Client dashboard, images and reversible saves on 2026-09-10; prior public unauthenticated-denial probe PASS. Deployment identity and native image proof remain separate technical gates |
| Main promotion/live verification | MAIN PUSH PASS; LIVE IDENTITY PENDING | Three local/remote branches at 0397bba9; main scan 34481778012 PASS; public production health/access/image probes PASS, exact Render deployment not yet verified |
| FUND integration | NOT RUN | Preserve current smoke at `29104b55`; integrate at its safe stopping point and prove combined candidate |

## Owner Staging Report — 2026-09-10

Chris reports that staging opens and login/logout work correctly. He subsequently confirms
that images display correctly, edits save and are reversible, and the dashboard shows the
correct Client. The tested application is **IsoStack with the LMSPro module on staging**.
Record these human UI checks as PASS. FUND remains in local development and is not part of
this staging security release.

Earlier public unauthenticated-denial and image-source-refusal probes retain their PASS;
a separate human protected-page retry after logout is not claimed or requested as a duplicate
of the existing denial proof. No exact image formats, per-step timestamps or browser session
identity are invented. The reported image display does not establish deployed native decoder
versions or all JPEG/PNG/AVIF paths. Exact Render deployment identity, remaining native-runtime
proof and independent source/security review remain open technical gates. No repeat of these
passed human UI checks is requested for the unchanged candidate.

Chris separately reported local FUND testing all green, now recorded in the FUND 05 records
at `29104b55`. This supports H6 local preservation; combined-candidate integration proof is
still not run. His question about whether login/logout suffices is not specific main/live
promotion approval. The remaining technical gates and specific main/live approval stay open.

## Human Staging Requirements

Record exact commit, tenant/role, time and PASS/FAIL. Use existing authorised staging test
accounts and benign assets; the agent obtains available technical evidence directly.

1. **H1 — Identity and entry:** verify the exact deployed correction, public health and
   sign-in page with expected branding/images.
2. **H2 — Authentication:** sign in, load the authorised dashboard and confirm the expected
   tenant/module context. Sign out and confirm a protected page requires authentication.
3. **H3 — Request body:** save one reversible, ordinary staging edit through an authorised
   UI and read it back. Confirm no request-body stream error. Agent uses synthetic local
   proof for repeated large payloads rather than sending them to production.
4. **H4 — Images:** display a known JPEG and PNG plus an approved benign AVIF where the UI
   supports it. The agent checks the installed/native decoder and optimiser behaviour;
   pass-through is acceptable only when recorded as the deliberate safety fallback.
5. **H5 — Denial:** an unauthenticated protected request remains refused. The agent verifies
   disallowed image origins are rejected using benign local/staging requests.
6. **H6 — FUND preservation:** confirm the current local C1/C2 smoke session and data remain
   intact. Keep its findings at the original candidate; after security integration repeat
   representative Catalogue selection, Event assignment and an authorised save on the
   combined candidate. Do not repeat the whole FUND matrix without a new failure/risk.

## Failure And Recovery

A failed audit, request-body correction, image guard, independent review or environment gate
stops forward promotion. Reverting the isolated commit can restore prior application
behaviour but also restores known vulnerabilities; assess image-path containment if needed.
There is no schema/data rollback. No exploit payload is authorised against shared services.

## Next Action

Main promotion is now executed under Chris’s reaffirmed instruction. Finish main scan and
production deployment readback; retain the explicit review/runtime evidence limits below.
No promotion approval is pending. FUND remains Next with local human smoke PASS at `29104b55`
and its existing 1R-G planning refinement prepared; FUND has not been included in this release.

## Dev And Staging Promotion Evidence — 2026-09-10

The complete release bundle is one commit, `0397bba9`, changing five files. The schema,
migration directory and Render build script have zero diff against `14077382`. Source
preflight re-read the canonical Git workflow, deployment checklist and database rules.
The existing Render build contract may run its idempotent migration/reference-data steps;
no new migration or manual database operation accompanies this security correction.

The isolated checkout performed local `dev` and `staging` fast-forward merges before each
push. No direct remote-ref replacement, force-push or FUND cherry-pick was used. GitHub API
readback confirms work branch, dev and staging at full
`0397bba958862f1f61c16d405fdfe60ae7c13f50`; main remains
`14077382b7d397528e96fb6f7bdea978236a4713`.

- [Work-branch Security Scan 34463542270](https://github.com/isocb/isostack-bedrock/actions/runs/34463542270): PASS.
- [Dev Security Scan 34463792299](https://github.com/isocb/isostack-bedrock/actions/runs/34463792299): PASS.
- [Dev Linux renderer parity 34463792371](https://github.com/isocb/isostack-bedrock/actions/runs/34463792371): PASS.
- [Staging Security Scan 34464073290](https://github.com/isocb/isostack-bedrock/actions/runs/34464073290): PASS.

Public probes at 10:05 UTC, after the staging push, pass on both staging.isostack.app and
staging.seasonpro.co.uk: health HTTP 200/database connected/RLS 11/11; root/sign-in pages
HTTP 200; an unauthenticated /app request redirects to the respective sign-in surface;
a known public PNG optimises to WebP (HTTP 200); an unlisted image origin is refused (400).
Only public assets and read-only endpoints were used.

These probes do not establish that Render has finished deploying this exact commit.
Neither the public pages nor GitHub deployment metadata exposed the current Render Git
identity; authenticated Render access is unavailable in this session. The control owner
must verify staging is Live/green at `0397bba9` before completing H1. No production probe,
main push or live deploy was performed. No agent-operated authenticated staging mutation is claimed; Chris’s reversible UI save is recorded above.

## Approved Main Promotion Preflight — 2026-09-10

Chris explicitly authorises main/live promotion of the security patch and ordinary document
commits. The human UI report above applies to IsoStack/LMSPro staging; FUND remains local
development at `29104b55`. No additional promotion approval is requested.

Fresh branch/CI readback confirms dev/staging and origins at exact `0397bba9`, main and
origin/main at `14077382`, and all four recorded scan/parity runs successful. The full
main-to-staging bundle is five reviewed security files; schema, migrations and deployment
configuration have no change. No unrelated FUND commit is included.

Public staging probes at 11:00 UTC again pass on both staging domains: health 200, database
connected, RLS 11/11, expected sign-in routing, protected `/app` redirected to sign-in,
known PNG optimised to WebP, unlisted image origin refused with 400. These requests do not
mutate data or establish the deployed Git identity/native decoder version.

No GitHub PR review/deployment record exists for the candidate; no Render CLI, configured
Render credentials or provider tool is available. Exact staging identity/native-runtime
proof and independent source review remain pending. The owner has been asked for the
provider readback and permission for a separate review agent; no promotion has been run
while those existing gates are unresolved. The original smoke evidence remains accepted.

## Main Promotion And Minimum Production Proof — 2026-09-10

Chris again directed safe promotion and alignment after receiving the explicit status that
main was still `14077382` and the independent/Render evidence was unproven. The controlling
plan records this instruction as superseding the earlier pre-push hold. High control depth
and truthful evidence limits remain; no separate source review or provider readback is invented.

Immediately before promotion, refreshed GitHub readback showed all work/dev/staging
security scans and Linux parity PASS. The complete main-to-staging bundle remained the
five reviewed security files. Forty lockfile records change only within the accepted
dependency families; credential-pattern review and whitespace checks pass. The guarded
request-body correction, installed/standalone benign image proof and all five backport
unit tests pass again in the isolated Node 22 environment. No source/dependency/Prisma
output in the user's FUND checkout was touched. This is implementer verification.

The isolated checkout switched to local main, fast-forwarded from local staging and
pushed main normally. No force push, selective reimplementation or remote-ref substitution
was used. Independent remote readback confirms all three branches at:

```text
dev     0397bba958862f1f61c16d405fdfe60ae7c13f50
staging 0397bba958862f1f61c16d405fdfe60ae7c13f50
main    0397bba958862f1f61c16d405fdfe60ae7c13f50
```

The new exact [main Security Scan 34481778012](https://github.com/isocb/isostack-bedrock/actions/runs/34481778012)
passes every applicable job: dependency vulnerability, secret detection, schema security,
TypeScript and the summary. Main previously failing at `14077382` is retained as historical evidence.

At 13:18 UTC after the push and again at 13:20 UTC after main CI PASS, the documented production endpoint `app.seasonpro.co.uk`
returns healthy HTTP 200, database connected, RLS 11/11; root and protected `/app` lead
to the expected LMSPro sign-in surface; a known public PNG optimises to WebP; an unlisted
image source is refused with 400. These are benign non-destructive reads only. An inferred
`app.isostack.app` hostname returned 403 and is not treated as the established production
endpoint or a regression; no deployment claim is based on that hostname.

Git alignment and public health do not prove which Render commit is serving. Authenticated
Render access is unavailable, GitHub exposes no deployment identity, and public responses
contain no exact build marker. Production Live/green at `0397bba9` has been requested from
the owner. Deployed Linux decoder identity and separate independent source review also
remain unproven. Promotion is completed at the Git boundary; full exact-live verification
is not claimed. No new migration, runtime configuration or manual database action occurred.
