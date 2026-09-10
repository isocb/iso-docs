# PLAT-ASSURE-05 — Security Dependency Review And Test

Date: 2026-09-10

Status: **Exact `0397bba9` aligned through dev/staging; all three Security Scans and Linux parity PASS; main/live explicitly on hold.**

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
| Independent source/security review | PENDING | Review dependency diff, guarded backport, image proof, residual risk and recovery; implementer review above is not independent acceptance |
| Protected dev/staging scans | PASS | Exact `0397bba9`; dev run 34463792299 and staging run 34464073290 |
| Linux/native image/runtime proof | PARTIAL | Exact Linux renderer parity run 34463792371 PASS; this does not prove the Next image decoder. Deployed Linux Sharp/libheif identity and image/runtime proof remain open |
| Staging human smoke | PARTIAL | Chris reports staging opens and login/logout PASS on 2026-09-10; remaining save, image, context/denial and deployment identity requirements below remain open |
| Main promotion/live verification | NOT AUTHORISED OR RUN | Separate authority after staging acceptance, exact scan/deploy identity and minimum safe live checks |
| FUND integration | NOT RUN | Preserve current smoke at `29104b55`; integrate at its safe stopping point and prove combined candidate |

## Owner Staging Report — 2026-09-10

Chris reports that staging opens and login/logout work correctly. Record those interactions
as owner-reported PASS. This report does not specify dashboard tenant/module context,
a protected-page retry after logout, an ordinary save/readback, representative image display
or the Render deployment commit; those requirements are not silently marked complete.
Earlier public unauthenticated-denial and PNG probes retain their recorded evidence.

Chris separately reported local FUND testing all green, now recorded in the FUND 05 records
at `29104b55`. This supports H6 local preservation; combined-candidate integration proof is
still not run. His question about whether login/logout suffices is not specific main/live
promotion approval. The remaining technical and human gates stay open.

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

Publication and dev/staging promotion are authorised and carried out. Complete independent review and remaining deployment/human checks; pause for Chris’s
specific approval before any main/live promotion. The Platform plan holds the only active
restart checkpoint. FUND remains Next and user-operated smoke continues unchanged.

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
main push or live deploy was performed. No authenticated staging mutation is claimed.
