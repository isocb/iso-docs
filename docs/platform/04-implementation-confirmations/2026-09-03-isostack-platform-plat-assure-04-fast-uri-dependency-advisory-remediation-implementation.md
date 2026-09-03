# Platform Slice PLAT-ASSURE-04 — Fast-URI Dependency Advisory Remediation Implementation

Date: 2026-09-03

Status: **IMPLEMENTED AT EXACT `14077382`; ALIGNED THROUGH STAGING; ALL TECHNICAL GATES
PASS; HUMAN STAGING GATE PENDING**

Plan:

[`PLAT-ASSURE-04 planning`](../03-slice-planning/2026-09-03-isostack-platform-plat-assure-04-fast-uri-dependency-advisory-remediation-planning.md)

Review:

[`PLAT-ASSURE-04 staging gate`](../05-review-and-test/2026-09-03-isostack-platform-plat-assure-04-fast-uri-dependency-advisory-remediation-staging-gate.md)

## Evidence Summary

```text
Exact commit: 14077382b7d397528e96fb6f7bdea978236a4713
Files/change boundary: package.json and package-lock.json only; fast-uri 3.1.5 -> 3.1.7
Automated checks: local dependency/audit, focused 6/6, full 512 pass/12 skip, type, verify, middleware verification and 131-route build PASS; exact work/dev/staging Security Scans PASS
Human evidence: pending four-check staging gate; no user-visible behaviour changed
Environment proven: local Node 22.23.2/npm 10.8.2; origin/dev and origin/staging exact 14077382; two staging public health endpoints HTTP 200/database connected/RLS 11/11
Known residual risk: 28 Moderate and 1 Low findings remain; exact Render deployed-commit dashboard identity and human smoke pending; main remains d78935d4
Next authorised action: control owner completes the recorded staging identity/smoke gate; no main promotion is authorised
```

## 1. Delivered Diff

The isolated application commit changes four added and four removed lines across two files:

```text
package.json       fast-uri override 3.1.5 -> 3.1.7
package-lock.json  fast-uri version, tarball URL and integrity only
```

No application source, workflow, audit validator, schema, migration, environment or
provider configuration changed in this commit.

The exact `dev` to `staging` ancestry also carries two already accepted predecessors:
`f48a2e06` changes only `AGENTS.md`, and `0c7e4848` changes only the closed FUND Stage C
proof runner. Neither adds deployed application behaviour, schema or configuration.

## 2. Dependency And Negative Evidence

The old exact protected baseline `d78935d4` failed scheduled Security Scan
[`33726655633`](https://github.com/isocb/isostack-bedrock/actions/runs/33726655633) with
`0` critical and `2` high findings. The unchanged fail-closed validator therefore supplies
the negative case.

The corrected clean tree resolves only:

```text
react-email -> conf -> ajv-formats -> ajv -> fast-uri 3.1.7
react-email -> conf -> ajv                  -> fast-uri 3.1.7 overridden
```

Fresh local and exact staging audit evidence both report:

```text
0 critical / 0 high / 28 moderate / 1 low / 0 info
npm audit real exit code: 1 because Moderate findings remain
repository High/Critical validator: PASS
```

This proves the security threshold was not weakened and the remaining findings were not
hidden.

## 3. Local Verification

| Gate | Result |
| --- | --- |
| Exact toolchain | PASS — Node 22.23.2, npm 10.8.2 |
| Clean install | PASS — 984 packages from candidate lockfile |
| Resolved tree | PASS — fast-uri 3.1.7 only |
| Audit validator focused tests | PASS — 6/6 |
| Full regression | PASS — 512 passed, 12 retained skips |
| TypeScript | PASS |
| Critical-file verification | PASS, including nested type-check |
| Middleware body-finalisation verification | PASS |
| Production build | PASS — 131 routes/static pages |
| Diff and whitespace review | PASS — expected two-file correction only |

The first script-free install intentionally omitted Prisma generation. A test attempt from
that incomplete node_modules state could not load the generated Prisma client, while the
sandbox also refused Chromium and TSX IPC. The normal post-install middleware patch and
Prisma generation were then run; the same suite passed under exact Node 22 with the required
local process permissions. No tracked file changed and no product failure is inferred from
the incomplete installation attempt.

Expected local build warnings report that optional Upstash credentials are absent locally.
They do not describe staging configuration and did not affect the build.

## 4. Online Gates And Promotion

- work branch Security Scan
  [`33732994236`](https://github.com/isocb/isostack-bedrock/actions/runs/33732994236): PASS;
- protected dev Security Scan
  [`33733261291`](https://github.com/isocb/isostack-bedrock/actions/runs/33733261291): PASS;
- protected staging Security Scan
  [`33733518510`](https://github.com/isocb/isostack-bedrock/actions/runs/33733518510): PASS; and
- `origin/dev` and `origin/staging`: exact `14077382b7d397528e96fb6f7bdea978236a4713`.

At 2026-09-03 08:32 UTC, both `https://staging.seasonpro.co.uk/api/health` and
`https://staging.isostack.app/api/health` returned HTTP 200, database connected and RLS
enabled on 11/11 checked tables.

The available public/GitHub metadata does not expose Render's exact deployed commit. That
identity is retained as the first human dashboard check; it is not inferred from public
health. `main` and `origin/main` remain unchanged at `d78935d4`.

