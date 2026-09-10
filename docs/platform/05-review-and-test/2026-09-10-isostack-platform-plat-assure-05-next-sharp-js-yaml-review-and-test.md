# PLAT-ASSURE-05 — Security Dependency Review And Test

Date: 2026-09-10

Status: **Local technical proof PASS; publication, independent review and staging/live gates pending.**

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

## Remaining Gates

| Gate | Current result | Required evidence |
| --- | --- | --- |
| Publish isolated candidate | BLOCKED by automatic approval review | Explicit approval to push `0397bba9` on `work/platform-security-2026-09-10` to private `isocb/isostack-bedrock` |
| Exact work-branch Security Scan | NOT RUN | Publish, dispatch existing workflow with dev as bounded secret-scan base, obtain exact candidate PASS |
| Independent source/security review | PENDING | Review dependency diff, guarded backport, image proof, residual risk and recovery; implementer review above is not independent acceptance |
| Protected dev/staging scans | NOT RUN | Pass required review, consolidate exact ancestry, obtain both protected scans |
| Linux/native image/runtime proof | NOT RUN | Verify actual Sharp/libheif versions, benign image proof and request-body behaviour in the relevant Linux build |
| Staging human smoke | NOT RUN | H1–H6 below with exact deployed commit |
| Main promotion/live verification | NOT AUTHORISED OR RUN | Separate authority after staging acceptance, exact scan/deploy identity and minimum safe live checks |
| FUND integration | NOT RUN | Preserve current smoke at `29104b55`; integrate at its safe stopping point and prove combined candidate |

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

Obtain the explicit publication approval required by automatic review, publish the exact
candidate and run its Security Scan. Arrange independent review before protected promotion.
The Platform plan holds the only active restart checkpoint. FUND remains the recorded Next
outcome and its user-operated smoke continues on the unchanged checkout.
