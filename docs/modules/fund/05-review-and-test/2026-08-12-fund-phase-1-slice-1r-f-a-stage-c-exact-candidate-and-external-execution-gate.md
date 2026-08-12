# FUND Phase 1 Slice 1R-F-A Stage C — Exact Candidate And External Execution Gate

Date: 2026-08-12

Status: **IN PROGRESS — EXACT `328aadf0` LOCAL, LINUX AND SECURITY GATES PASS AND DEV IS
ALIGNED; RENDER/R2 EXECUTION AND TEARDOWN EVIDENCE PENDING**

Planning authority:

[`1R-F-A Stage C temporary Render/private-object proof`](../03-slice-planning/2026-08-12-fund-phase-1-slice-1r-f-a-stage-c-temporary-render-private-object-proof-planning.md)

Implementation confirmation:

[`1R-F-A Stage C implementation confirmation`](../04-implementation-confirmations/2026-08-12-fund-phase-1-slice-1r-f-a-stage-c-isolated-render-private-object-proof-implementation-confirmation.md)

## 1. Gate Rule

Stage C is one indivisible evidence gate:

```text
exact candidate gates
-> dedicated private bucket and prefix-scoped temporary credentials
-> temporary Render worker, auto-deploy off, exact candidate build
-> one one-off job
-> six private PDF checksum round trips
-> zero exact-prefix objects
-> credential revocation and refusal
-> Render service and R2 bucket deletion/absence
-> PASS
```

A successful renderer/object run without verified cleanup, revocation and resource absence
is **BLOCKED**, not partial acceptance.

## 2. Exact Candidate Gate

| Check | Evidence | Result |
| --- | --- | --- |
| Exact application candidate | `328aadf0a360b4c65837327060302ddc525f6168` | PASS |
| Diff boundary | Proof runner/tests/script/docs only; no schema, route, shared R2 utility or `render.yaml` change | PASS |
| Existing renderer + Stage C tests | 2 files / 9 tests | PASS |
| TypeScript | `npm run type-check` | PASS |
| Repository verification | `npm run verify` | PASS |
| Production build | `npm run build` | PASS |
| Local formatting/diff/pre-commit | Green | PASS |
| Dev alignment | local `dev` = `origin/dev` = exact candidate | PASS |
| Linux container parity | [Run `31599134487`](https://github.com/isocb/isostack-bedrock/actions/runs/31599134487): immutable container build, 9-test proof run and normalised comparison | PASS |
| Exact Security Scan | [Run `31599134488`](https://github.com/isocb/isostack-bedrock/actions/runs/31599134488): dependency, Prisma, TypeScript and Gitleaks jobs | PASS |

The unrelated `1july2026.code-workspace` modification was neither staged nor committed.
Staging and main remain at `cde4eaff1e14b2f02ba0953fe8693e7feb02bb61`.

## 3. Provider Readiness

Read-only readiness inspection found:

- no Render CLI or Wrangler CLI installed;
- no Render/Cloudflare administrative environment-variable names in the current shell;
- no Render/Cloudflare credential records in macOS Keychain;
- no GitHub repository/environment secret names providing those authorities; and
- existing local application R2 S3 credentials, which are deliberately not treated as
  authority to create the proof bucket or as the required dedicated Stage C parent token.

This is not yet a failed gate: no external resource should exist before the exact Linux and
Security gates pass. Before Phase 2 begins, the control window still requires a dedicated
operator-only Render API key and dedicated Cloudflare/R2 administrative parent-token
authority. Neither value may enter Git, documentation, command output or shell history.

## 4. External Execution Evidence — Pending

| Required evidence | Result |
| --- | --- |
| Dedicated bucket identity, empty initial list, no `r2.dev`, domain or CORS | PENDING |
| Dedicated parent token scope retained outside Render | PENDING |
| Temporary worker has no route/disk/database/env group and auto-deploy is off | PENDING |
| Exact Render build commit and inert base process | PENDING |
| One-hour prefix-scoped temporary session credential | PENDING |
| Out-of-prefix and anonymous access denied | PENDING |
| Six PUT/HEAD/GET/checksum/DELETE/not-found/list-empty sequences | PENDING |
| Node/Playwright/Chromium/font/container identity | PENDING |
| Cold/warm/batch timing and peak memory below 80% | PENDING |
| Job terminal success and final exact-prefix object count zero | PENDING |

## 5. Teardown And Revocation Evidence — Pending

| Required evidence | Result |
| --- | --- |
| Exact prefix independently listed as empty | PENDING |
| Dedicated R2 parent token revoked | PENDING |
| Derived temporary credential rejected after revocation | PENDING |
| Stage C variables removed | PENDING |
| Temporary Render service deleted and exact ID/name absent | PENDING |
| Dedicated Render API key revoked and rejected | PENDING |
| Dedicated empty R2 bucket deleted and exact name absent | PENDING |
| No database, disk, hostname, shared data or customer object created | PENDING |

## 6. Current Disposition

Remain at this gate. Do not promote staging/main or start `1R-F-B`, `1R-G` or `1R-H-A`.
The record may become PASS only when every pending exact-candidate, execution and teardown
row is replaced by evidence.
