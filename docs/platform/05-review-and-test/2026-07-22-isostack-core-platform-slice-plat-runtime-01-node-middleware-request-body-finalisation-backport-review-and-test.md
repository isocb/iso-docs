# IsoStack Platform Slice PLAT-RUNTIME-01 - Node Middleware Request-Body Finalisation Backport Review And Test

Date: 2026-07-22

Automated technical disposition: PASS

Human/deployed disposition: PASS for the Platform request-body correction; dependent LMSPro
attachment-delivery item 11 remains FAIL

Promotion disposition: STAGING SOURCE PROMOTED; `main`/live remain BLOCKED

Planning source:

`docs/platform/03-slice-planning/2026-07-22-isostack-core-platform-slice-plat-runtime-01-node-middleware-request-body-finalisation-backport-planning.md`

Implementation source:

`docs/platform/04-implementation-confirmations/2026-07-22-isostack-core-platform-slice-plat-runtime-01-node-middleware-request-body-finalisation-backport-confirmation.md`

Reviewed application commit:

`6b822e45`

## 1. Scope And Requirement Review

PASS. The implementation follows the accepted smallest safe boundary:

- exact Next.js `15.5.21` is pinned;
- the upstream missing-`await` correction is applied without a framework upgrade;
- installation and build fail closed if the expected dependency context changes;
- middleware routing and rate limiting remain unchanged;
- no module business logic is changed;
- no schema, migration, data or environment change is introduced; and
- the dedicated private-upload redesign remains a separate wishlist item.

The change has global technical scope for body-bearing requests traversing Node middleware, but no
intended domain/business behaviour change.

## 2. Automated Review Evidence

### 2.1 Clean Installation And Patch Durability

PASS under Node `22.23.1` and npm `11.18.0`.

- clean `npm ci` completed;
- `postinstall` applied the patch;
- Prisma Client generation completed;
- installed Next version was exactly `15.5.21`; and
- `prebuild` verified the installed patched context before both builds.

### 2.2 Patch Failure Paths

PASS — five focused cases prove:

1. exact unpatched context becomes exact patched context;
2. already patched context is idempotent;
3. missing/changed context fails closed;
4. mixed patched/unpatched context fails closed; and
5. any dependency version other than `15.5.21` fails closed.

### 2.3 Production Runtime

PASS. Both the ordinary Render-compatible production build and opt-in standalone build completed
under Node 22. The standalone harness verified its copied Next runtime and then passed:

```text
small JSON body:                                      1/1
representative 2 MiB binary/Base64 envelope:        20/20
accepted 10 MiB binary/Base64 envelope:              1/1
HTTP 5xx responses:                                    0
non-JSON/malformed responses:                          0
disturbed/locked-body log signatures:                  0
```

The tRPC probe uses an intentionally unknown procedure so it traverses shared API middleware and
structured tRPC response handling without invoking a domain mutation, external provider or shared
database write.

### 2.4 Wider Regression

PASS within the available automated boundary:

```text
Vitest files: 24 passed, 1 intentionally skipped
Tests:        158 passed, 12 intentionally skipped
TypeScript:   PASS
Critical files: PASS
FUND helper/policy regressions: PASS within full suite
LMSPro provisioning/import regressions: PASS within full suite
Communications/attachment/R2/delivery regressions: PASS within full suite
Commerce service/provider regressions: PASS within full suite
```

No automated test or build produced a Prisma connection-close failure. This does not close the
separate staging observation; it remains part of operational smoke.

### 2.5 Static And Dependency Evidence

- new executable JavaScript syntax: PASS;
- focused formatting: PASS;
- whitespace/diff validation: PASS;
- dependency audit at high/critical threshold: PASS;
- two moderate transitive PostCSS findings retained without forced/breaking remediation; and
- repository script/test typed-lint boundary remains the pre-existing PLAT-ASSURE-01 limitation.

## 3. Risk Review

Residual risk is low but not zero. The exact correction changes only asynchronous ordering, but it
operates in a shared framework boundary. The highest residual risks are environment-specific
middleware behaviour, an untested authenticated mutation, and recurrence of the separate Prisma
connection observation under deployed traffic.

These risks require staging smoke; they do not justify speculative application/database changes.
Rollback is source-only and requires no data reversal.

## 4. Mandatory Human Staging Smoke

### 4.1 Promotion Evidence

On 2026-07-22 the reviewed application commit was promoted by fast-forward in the accepted
sequence:

```text
origin/dev:     90974123 -> 6b822e45
origin/staging: 90974123 -> 6b822e45
```

The remote refs were fetched and verified between the two pushes. There is no Prisma migration
and no new environment value in this corrective slice. This evidence confirms source promotion;
it does not by itself claim that Render deployment completed successfully or that the staging
runtime passed smoke.

A promotion-time request to `https://staging.seasonpro.co.uk/api/health` returned HTTP 200 with
database `connected` and RLS `11/11`. The endpoint does not expose the deployed Git SHA, so this is
recorded as a green availability observation only. Checklist item 1 remains PENDING until Render
confirms that the responding deployment is exact commit `6b822e45`.

Do not promote to `main`/live. Do not resume the LMSPro R8-A3 human checklist until all mandatory
Platform checks below pass and the deployed commit is confirmed as `6b822e45`.

### 4.2 Human Checklist

After confirming the staging deployment completed at `6b822e45`, record each result:

1. **PASS** — `/api/health` returned HTTP 200 with database `connected` and RLS `11/11`
   before testing at `2026-07-22T15:56:28.058Z`;
2. **PASS** — ordinary login/session continuity was confirmed;
3. **PASS** — a safe Platform body-bearing mutation returned structured success;
4. **PASS** — a safe LMSPro non-attachment mutation succeeded;
5. **PASS** — a safe FUND mutation succeeded against an authorised fixture;
6. **PASS** — an Email draft containing a small PDF saved and reopened;
7. **PASS** — the draft save/reopen check passed with a representative PDF;
8. **PASS** — the accepted three-file cumulative 10 MB boundary passed;
9. **PASS** — no HTML HTTP 500 or disturbed/locked-body signature appeared while saving and
   reopening the accepted small, representative and boundary attachment drafts. The original
   shared Platform request-body defect did not recur;
10. **PASS** — a no-attachment Email continued to use the immediate batch route;
11. **FAIL** — an attachment Email submitted at approximately 17:12 BST remained `SENDING` with
    the refresh icon and was not delivered. Three subsequent healthy cron ticks reported
    `email-attachment-delivery: 0 processed, 0 errors`. The business tester confirms the compose
    flow first displayed the green `Email queued` response. Under the atomic queue contract, the
    web runtime therefore committed the job; the remaining failure is that cron did not see it as
    claimable;
12. **PASS** — the supplied cron interval and reviewed staging evidence contained no unexpected
    Prisma connection-close error, and each cron tick completed successfully; and
13. **PASS** — post-test `/api/health` remained healthy.

Use controlled recipients and disposable drafts. Do not continue the remaining LMSPro R8-A3
attachment-delivery checklist until items 1 through 13 pass.

### 4.3 Attachment Queue Failure Evidence

The cron ran after the approximately 17:12 BST send and again during the following four minutes.
Its earlier processors completed normally on every supplied tick, but the attachment processor
consistently returned:

```text
email-attachment-delivery: 0 processed, 0 errors
```

This is materially different from the corrected Platform request-body failure. The request no
longer returned an HTML HTTP 500, attachment drafts persisted and the cron itself remained green.
The current blocker is that the web runtime confirmed queue creation, but the worker claimed no
attachment job during the observed interval. Initial due-time, persisted job state and web/cron
database alignment are the bounded remaining causes. Do not retry repeatedly or promote to live.
Use the R8-A3-F1 correlation evidence before resuming the R8-A3 transport checklist.

Corrective follow-on:

`docs/modules/lmspro/03-slice-planning/2026-07-22-lmspro-remediation-slice-r8-a3-f1-attachment-job-claim-eligibility-and-runtime-evidence-planning.md`

R8-A3-F1 technical implementation and automated review pass at local dedicated-branch commit
`d14a652f`. That exact commit was subsequently fast-forwarded through `origin/dev` to
`origin/staging`. The failed item remains open pending Render deployment verification and its
fresh staging retest.

## 5. Gate Decision

Automated and deployed human review PASS for the Platform request-body correction at exact
application commit `6b822e45`. The dependent LMSPro attachment-delivery handoff remains failed at
item 11 and is owned by R8-A3-F1. No live promotion is authorised while that corrective follow-on
remains undeployed and unproven.

LMSPro R8-A3 remains explicitly blocked by R8-A3-F1. If the body-stream failure recurs or a
reproducible database failure appears, stop testing and open a separately evidenced Platform
corrective/triage record rather than expanding the LMSPro implementation silently.
