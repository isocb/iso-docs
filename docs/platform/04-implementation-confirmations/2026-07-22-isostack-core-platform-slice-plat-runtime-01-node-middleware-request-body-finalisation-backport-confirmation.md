# IsoStack Platform Slice PLAT-RUNTIME-01 - Node Middleware Request-Body Finalisation Backport Implementation Confirmation

Date: 2026-07-22

Status: Implemented and committed; subsequently promoted by fast-forward through `origin/dev` to
`origin/staging`; mandatory staging deployment and human smoke passed

Planning source:

`docs/platform/03-slice-planning/2026-07-22-isostack-core-platform-slice-plat-runtime-01-node-middleware-request-body-finalisation-backport-planning.md`

Application branch:

`fix/platform-plat-runtime-01-node-middleware-body-finalize`

Application baseline:

`90974123`

Implementation commit:

`6b822e45`

## 1. Implemented Correction

The application now pins `next@15.5.21` and applies the exact semantic correction merged in
upstream `vercel/next.js#85418` during every dependency installation:

```text
requestData.body.finalize();
->
await requestData.body.finalize();
```

The repository-owned applicator is idempotent and fails closed when:

- the installed Next.js version is not exactly `15.5.21`;
- the expected unpatched source occurs other than exactly once;
- patched and unpatched contexts coexist; or
- the expected patched context cannot be verified.

`postinstall` applies the correction before Prisma generation. `prebuild` verifies the installed
runtime, so a missing or stale backport prevents production build.

## 2. Files Changed

```text
package.json
package-lock.json
next.config.js
scripts/next-node-middleware-body-finalize-patch.mjs
scripts/next-node-middleware-body-finalize-patch.test.ts
scripts/test-next-node-middleware-request-body.mjs
scripts/test-support/mock-upstash-fetch.mjs
```

`next.config.js` adds only an opt-in `NEXT_OUTPUT_STANDALONE=1` build setting used by the
production-runtime assurance harness. The ordinary Render build remains on its existing
`next start` contract.

The runtime harness:

- asserts that the generated standalone artefact itself contains the corrected Next runtime;
- starts that production artefact on loopback only;
- provides a local in-process Upstash REST mock so no real external service or credential is
  required;
- sends requests through the actual `/api/trpc` middleware boundary; and
- refuses 5xx, non-JSON, malformed JSON and locked/disturbed-body evidence.

## 3. Explicit No-Change Evidence

The implementation changes no:

- application or module business service;
- middleware route, authentication, permission or rate-limit rule;
- Prisma schema, migration, SQL, RLS or database data;
- tRPC router/procedure contract;
- LMSPro R8-A3 queue, cron, R2 or Resend logic;
- environment-variable requirement or Render configuration;
- application UI; or
- live/staging deployment state.

No shared database or external Email/storage service was used by the runtime harness.

## 4. Automated Evidence

The accepted production engine was exercised using ephemeral `node@22.23.1` and `npm@11.18.0`.

```text
Clean Node 22 npm ci: PASS
Postinstall backport application: PASS
Installed runtime verification: PASS
Patch unit tests: 5 PASS
Full Vitest: 158 PASS, 12 intentionally skipped (24 files passed, 1 skipped)
Critical-file verification: PASS
TypeScript type-check: PASS
Ordinary Node 22 production build: PASS
Node 22 standalone production build: PASS
Standalone artefact patch assertion: PASS
Small request-body runtime probe: 1 PASS
Representative 2 MiB binary/Base64-envelope runtime probes: 20 PASS
Accepted 10 MiB binary/Base64-envelope runtime probe: 1 PASS
JavaScript syntax checks: PASS
Focused Prettier check: PASS
Git whitespace/diff check: PASS
Dependency audit high/critical gate: PASS
```

The dependency audit retains two moderate PostCSS findings in the pinned Next.js dependency
chain. The audit proposes a breaking framework downgrade and was not force-fixed. No high or
critical finding was introduced.

## 5. Verification Limitations And Deviations

Repository ESLint intentionally ignores `scripts/`. Forcing the new scripts through the current
typed ESLint configuration produces the already registered PLAT-ASSURE-01 parser-boundary error
because scripts/test files are outside its TypeScript project. No lint rule was weakened and no
new exclusion was added. Syntax checks, Prettier, executable unit tests and runtime integration
tests cover the new scripts within this slice.

The first standalone harness attempts stopped before functional evidence because local production
startup correctly required valid Upstash configuration. The final harness uses a host-restricted
in-process fetch mock for one non-routable `.invalid` Upstash hostname and delegates every other
request to native fetch. This is test support only and is never loaded by the application build or
normal runtime.

## 6. Promotion State And Stop Boundary

The implementation is application commit `6b822e45` on its dedicated branch. On 2026-07-22 the
same reviewed commit was fast-forwarded first to `origin/dev` and then to `origin/staging` from
baseline `90974123`.

There is no migration and no new environment setting to deploy. Source promotion does not prove
that Render deployment completed or that runtime smoke passed. `main`/live remain untouched and
unauthorised. The mandatory Platform staging smoke subsequently passed on 2026-07-22. LMSPro
R8-A3 is no longer blocked by this Platform slice and has resumed its module-owned human tests.
