# Protected-Branch Security Scan Advisory Refresh Implementation

Date: 2026-08-10

Status: **IMPLEMENTED AS DEPENDENCY CHILD `60ac76c1` AFTER ROLE CHILD `b1ede26f`; EXACT
DEV/STAGING/MAIN SECURITY SCANS, STAGING 8/8 AND STAGING/PRODUCTION PUBLIC HEALTH PASS;
PRODUCTION RENDER IDENTITY AND NON-MUTATING ROUTE SMOKE REMAIN**

Plan:

[`Protected-Branch Security Scan Advisory Refresh Planning`](../03-slice-planning/2026-08-10-isostack-platform-protected-branch-security-scan-advisory-refresh-planning.md)

Review:

[`Protected-Branch Security Scan Advisory Refresh Local Gate`](../05-review-and-test/2026-08-10-isostack-platform-protected-branch-security-scan-advisory-refresh-local-gate.md)

## 1. Delivered Outcome

The dependency graph now resolves:

```text
@eslint/eslintrc -> js-yaml 4.3.1 overridden
postcss 8.5.23   -> nanoid 3.3.18 overridden
```

`package.json` adds exactly those two overrides. `package-lock.json` changes only each
package's version, resolved tarball and integrity value: 12 lockfile lines, six removed and
six added. No parent package, workflow, validator or application file belongs to the
dependency child.

## 2. Reproducibility And Security Evidence

- toolchain: Node 22.18.0 and npm 10.9.8;
- isolated clean install: 978 packages installed from the candidate lockfile;
- resolved tree: patched versions only;
- clean-install audit: zero vulnerabilities;
- retained audit-validator input: npm audit report v2 with 1,127 dependency nodes and zero
  info, low, moderate, high or critical findings; and
- repository validator: PASS, `Dependency security gate passed`.

Authenticated Actions review also confirms latest scheduled run
[`31366209496`](https://github.com/isocb/isostack-bedrock/actions/runs/31366209496)
failed only its dev/staging/main dependency-validation steps against old exact
`72c02d92`; TypeScript, secret detection, schema security and report generation passed.

The local host default was Node 24/npm 11, so the accepted Node 22/npm 10 toolchain was
invoked explicitly. This avoided the broad optional-platform lockfile churn identified by
triage.

## 3. Combined Automated Evidence

| Gate | Result |
| --- | --- |
| Full Vitest regression | PASS — 372 passed, 12 retained skips |
| TypeScript | PASS |
| Critical-file verification | PASS |
| Next.js request-body finalisation verification | PASS |
| Production build | PASS — 131 routes/static pages |
| Dependency diff review | PASS — two manifest lines and two package lock records only |
| Diff whitespace validation | PASS |

The ordinary `npm run verify` script nests `npx tsx`; under the temporary outer
Node/npm-toolchain wrapper, npm rejected that nested invocation before the verifier ran.
The exact underlying local `tsx` CLI was then run directly under Node 22/npm 10 and passed,
including its TypeScript sub-gate. This is a wrapper invocation issue, not a verification
failure or application change.

Expected local Upstash warnings remain during build because local Redis credentials are not
configured. No deployed configuration or security claim is inferred from those warnings.

## 4. Release Packaging

The Role Authority child `b1ede26f` and dependency child `60ac76c1` remain separately
reviewable in the combined release. Exact `60ac76c1` is aligned across local/remote dev,
staging and main. Exact Security Scans pass on dev (`31384553388`), staging (`31384766945`)
and main (`31387014370`). Staging human smoke passed 8/8 and both staging and production
public health report HTTP 200, database connected and RLS 11/11.

This record does not infer the live Render SHA from public health. Production exact-build
identity and the bounded non-mutating route smoke remain in the combined promotion record.
