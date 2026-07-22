# IsoStack Platform Slice PLAT-RUNTIME-01 - Node Middleware Request-Body Finalisation Backport And Production-Runtime Assurance Planning

Date: 2026-07-22

Status: Accepted bounded corrective slice; implementation authorised by the user

CR input:

`docs/platform/01-cr-inputs/2026-07-22-isostack-platform-node-middleware-request-body-finalisation-defect-cr.md`

Triage:

`docs/platform/02-triage/2026-07-22-isostack-platform-node-middleware-request-body-finalisation-defect-triage.md`

Blocked consumer evidence:

`docs/modules/lmspro/05-review-and-test/2026-07-22-lmspro-remediation-slice-r8-a3-durable-attachment-delivery-job-rate-limiter-and-retry-review-and-test.md`

## 1. Objective

Apply and continuously verify the exact upstream Next.js correction that awaits Node middleware
request-body finalisation before invoking the destination handler. Prove the production build
and standalone runtime sufficiently to allow controlled staging smoke and, only after that
passes, continuation of LMSPro R8-A3 testing.

## 2. Current-State Evidence

At exact application baseline `90974123`:

- `package-lock.json` resolves `next@15.5.21`;
- its runtime contains `requestData.body.finalize();` without `await`;
- `src/middleware.ts` sends all `/api/` requests through Node middleware and rate limiting;
- `src/app/api/trpc/[trpc]/route.ts` then delegates to the tRPC fetch adapter;
- the deployed failure occurs in `fromNodeNextRequest` before structured tRPC handling; and
- the cron correctly reports zero attachment jobs when the draft request never persists.

## 3. In Scope

Application work is limited to:

- pinning the exact supported Next.js version while the backport is active;
- a repository-owned install-time patch script containing the exact upstream semantic change;
- deterministic fail-closed version/context/patch verification;
- package scripts needed to apply and verify the patch;
- focused tests for the patch applicator/verifier;
- a production/standalone request-body regression harness that sends requests through the real
  built middleware boundary; and
- minimal test-only fixtures required for small, representative and accepted maximum body
  envelopes.

Documentation work is limited to this Platform lifecycle, roadmap/blocker reconciliation,
implementation evidence and review/test evidence.

## 4. Explicit Non-Goals

- no major Next.js upgrade or canary adoption;
- no direct untracked edit to installed dependencies;
- no middleware, authentication or rate-limit bypass;
- no module business-logic change;
- no schema, migration, database-data or RLS change;
- no environment-variable or infrastructure change;
- no R2, Resend, cron or Email delivery change;
- no UI change; and
- no private-upload redesign in this slice.

## 5. Compatibility And Risk Boundary

The backport has global technical scope for POST, PUT, PATCH and DELETE bodies traversing Node
middleware. Its intended semantic effect is only to wait for the existing asynchronous clone to
finish. It does not alter request content, destination selection or domain logic.

Primary risks are:

- an incorrect or stale dependency patch;
- silent loss of the patch after installation;
- production/standalone behaviour differing from unit tests;
- latency or timeout at the accepted maximum envelope; and
- an unrelated body-bearing API regression hidden by attachment-only testing.

Mitigations are exact version pinning, fail-closed patch context, deterministic installed-runtime
inspection, repeated production-runtime tests and representative cross-module/API regressions.

## 6. Data, Security And Failure Behaviour

There is no schema or migration. Tests must use disposable/local fixtures and must not send
real Email or mutate shared databases.

If the Next.js version, runtime file or expected source context changes, installation or
verification must fail with actionable output rather than silently claiming the correction.
Secrets, attachment bytes, signed URLs and database URLs must not appear in committed evidence.

The observed Prisma connection-close messages remain an operational observation. Automated and
staging checks must confirm database health before and after representative body-bearing
requests. Any reproducible database failure stops this slice and enters separate triage.

## 7. Implementation Sequence

1. Create a dedicated branch from exact baseline `90974123`.
2. Pin `next@15.5.21` while the patch is active.
3. add an idempotent, fail-closed install/verification script for the exact upstream `await`;
4. run the script during `postinstall` before application build;
5. add patch-unit tests and a static installed-runtime verification command;
6. add a production/standalone middleware request-body regression harness;
7. run focused tests, representative shared/module POST checks, the full suite, type-check,
   critical-file verification and a clean production build;
8. create implementation and independent review/test evidence; and
9. stop before staging deployment for explicit promotion authority.

## 8. Required Automated Evidence

The slice cannot be staging-eligible unless all of the following pass:

1. clean `npm ci`, including patch application and Prisma generation;
2. exact Next.js version and installed-runtime patch verification;
3. patch applicator tests for unpatched, already patched, wrong-version and unexpected-context
   cases;
4. production/standalone requests with small JSON, representative PDF-equivalent and accepted
   10 MB binary/Base64-envelope payloads;
5. repeated representative requests sufficient to exercise the former race;
6. structured JSON responses rather than HTML 500/truncated bodies;
7. existing attachment policy, selection, persistence, R2 and delivery tests;
8. representative non-attachment shared/LMSPro/FUND tRPC or API POST regressions where they can
   run without unsafe external effects;
9. full Vitest run;
10. TypeScript type-check and critical-file verification;
11. clean production build and standalone start; and
12. diff/whitespace and dependency-tree review.

An assertion that only inspects source is insufficient; at least one test must traverse the
built Node middleware boundary.

## 9. Required Human Staging Smoke

After separately authorised staging promotion:

1. confirm `/api/health` is green before testing;
2. confirm ordinary login/session and one safe platform mutation;
3. confirm one safe LMSPro mutation and one safe FUND mutation where available;
4. save/reopen an Email draft with a small PDF;
5. repeat with a representative PDF;
6. exercise the accepted three-file/10 MB boundary;
7. confirm failures return structured safe UI messages rather than HTML HTTP 500;
8. confirm no-attachment Email remains on its existing immediate route;
9. confirm the attachment request creates exactly one durable job and the cron claims it;
10. inspect web/cron logs for locked/disturbed body errors and unexpected Prisma connection
    failure; and
11. confirm `/api/health` remains green after the smoke.

R8-A3 resumes at its existing pending test item only after this platform smoke passes.

## 10. Rollback And Stop Conditions

Rollback removes the install-time patch mechanism and restores the prior package contract on the
dedicated branch. No data rollback is required.

Stop and return to planning if:

- the exact patch cannot be reproduced from a clean install;
- a major dependency upgrade becomes necessary;
- tests identify a business-behaviour, authentication, rate-limit or database change;
- the production/standalone harness cannot prove the body boundary; or
- any required automated gate fails for a change-related reason.

Implementation stops after technical review evidence. Staging deployment, human smoke, R8-A3
resumption and live promotion remain separate controlled actions.
