# FUND Phase 1 Slice 1R-F-A Stage C — Isolated Render/Private-Object Proof Implementation Confirmation

Date: 2026-08-12

Status: **BOUNDED RUNNER IMPLEMENTED AND DEV-ALIGNED AT EXACT APPLICATION `328aadf0`;
LOCAL, LINUX AND SECURITY GATES PASS; EXTERNAL EXECUTION EVIDENCE PENDING**

Planning authority:

[`1R-F-A Stage C temporary Render/private-object proof`](../03-slice-planning/2026-08-12-fund-phase-1-slice-1r-f-a-stage-c-temporary-render-private-object-proof-planning.md)

Review and execution gate:

[`1R-F-A Stage C exact-candidate and external execution gate`](../05-review-and-test/2026-08-12-fund-phase-1-slice-1r-f-a-stage-c-exact-candidate-and-external-execution-gate.md)

Application baseline: exact `139d09c476cb7d250eba5e234eefb76f087f9ab5`

Exact candidate: `328aadf0a360b4c65837327060302ddc525f6168`

## 1. Outcome

The accepted Stage C boundary now has a dedicated proof runner. It reuses the accepted six
fixture renderer and adds only the fail-closed identity, temporary-session R2 round trip,
private-access checks, cleanup and bounded machine evidence needed for one isolated Render
execution.

The candidate:

- refuses execution unless `RENDER=true`, the Stage C gate is explicitly enabled and the
  full Render commit equals the authorised full commit;
- accepts only a random UUID-v4 run ID and its exact
  `fund/1r-f-a/stage-c/<run-id>/` prefix;
- refuses a bucket named in the operator-supplied shared/production denylist;
- requires temporary access-key, secret and session-token credentials with between 20 and
  60 minutes remaining;
- proves the temporary credential receives access denial outside the exact run prefix;
- renders the accepted six synthetic PDFs sequentially;
- performs deterministic-key PUT, anonymous refusal, HEAD metadata/length, authenticated
  GET/checksum, exact DELETE, HEAD-not-found and prefix-empty checks;
- retries only classified transient S3 failures, at most once, and resolves an ambiguous
  PUT through exact-key HEAD inspection before retrying;
- runs cleanup in `finally` and refuses to hide a cleanup failure;
- records request identifiers but never credential values;
- enforces a hard 15-minute process deadline and an 80% ceiling against the accepted
  512-MiB Starter envelope; and
- emits `PASS` only after the exact prefix is empty.

## 2. Exact Change Boundary

Application changes are confined to:

```text
package.json
  proof:fund:1r-f-a:stage-c command

scripts/proofs/fund-1r-f-a/stage-c.ts
  isolated runtime/configuration gate, R2 round trip, cleanup and evidence runner

scripts/proofs/fund-1r-f-a/stage-c.test.ts
  in-memory S3 success, refusal, retry, ambiguity, corruption and cleanup paths

scripts/proofs/fund-1r-f-a/run.ts
  exposes the already-measured warm deterministic-repeat timing to Stage C evidence

scripts/proofs/fund-1r-f-a/vitest.config.ts
  includes all isolated proof test files

scripts/proofs/fund-1r-f-a/README.md
  records the operator command and safety boundary
```

No Prisma schema/migration, route, UI, production service, shared R2 utility, root
`render.yaml`, application environment contract or database access changed. The unrelated
local `1july2026.code-workspace` edit remains untouched.

## 3. Local Evidence

| Gate | Result |
| --- | --- |
| Prettier and `git diff --check` | PASS |
| Application TypeScript | PASS |
| Existing renderer plus Stage C Vitest | PASS — 2 files, 9 tests |
| Repository critical-file verification | PASS |
| Production application build | PASS |
| Pre-commit TypeScript/control hook | PASS |
| [Exact Linux container parity `31599134487`](https://github.com/isocb/isostack-bedrock/actions/runs/31599134487) | PASS |
| [Exact Security Scan `31599134488`](https://github.com/isocb/isostack-bedrock/actions/runs/31599134488) | PASS |

The Stage C tests specifically prove:

1. commit, prefix, forbidden-bucket and credential-lifetime drift fail closed;
2. a transient PUT retries once and the successful round trip leaves zero objects;
3. a response-lost ambiguous PUT is accepted only after matching exact-object inspection;
4. GET checksum corruption triggers exact cleanup;
5. a cleanup refusal remains a hard failure; and
6. out-of-prefix access requires explicit authorization denial.

## 4. Commit And Branch State

```text
local dev = origin/dev = 328aadf0a360b4c65837327060302ddc525f6168
origin/staging = origin/main = cde4eaff1e14b2f02ba0953fe8693e7feb02bb61
```

The dev push intentionally triggers exact-candidate GitHub gates and may trigger an
existing dev-linked Render auto-deploy. It does not promote `staging` or `main` and does
not itself execute Stage C. The new temporary Stage C worker must still be created with
auto-deploy disabled and must not modify any existing service.

## 5. Stop Boundary

This implementation result is not a Stage C PASS. The candidate's exact Linux parity and
Security Scan are green. It must still complete the separately controlled temporary
Render/private-R2 run, zero-object proof, service/bucket deletion and credential-revocation
evidence. No later FUND child is authorised by this implementation.
