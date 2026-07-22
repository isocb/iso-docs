# IsoStack Platform Slice PLAT-RUNTIME-01 - Node Middleware Request-Body Finalisation Backport Review And Test

Date: 2026-07-22

Automated technical disposition: PASS

Human/deployed disposition: PENDING — source promoted to staging; deployment verification and
human smoke remain outstanding

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

Do not promote to `main`/live. Do not resume the LMSPro R8-A3 human checklist until all mandatory
Platform checks below pass and the deployed commit is confirmed as `6b822e45`.

### 4.2 Human Checklist

After confirming the staging deployment completed at `6b822e45`, record each result:

1. **PENDING** — confirm `/api/health` is HTTP 200, database connected and expected RLS checks
   pass before testing;
2. **PENDING** — confirm ordinary login/session continuity;
3. **PENDING** — perform one safe Platform body-bearing mutation and confirm structured success;
4. **PENDING** — perform one safe LMSPro non-attachment mutation;
5. **PENDING** — perform one safe FUND mutation where an authorised fixture exists;
6. **PENDING** — save and reopen an Email draft containing a small PDF;
7. **PENDING** — repeat with a representative PDF;
8. **PENDING** — exercise the accepted three-file cumulative 10 MB boundary;
9. **PENDING** — confirm no HTML HTTP 500 or disturbed/locked-body signature appears;
10. **PENDING** — confirm a no-attachment Email still uses the immediate batch route;
11. **PENDING** — confirm a valid attachment send persists exactly one job and the existing cron
    claims it;
12. **PENDING** — inspect web/cron logs for unexpected Prisma connection-close errors during the
    smoke; and
13. **PENDING** — repeat `/api/health` after testing.

Use controlled recipients and disposable drafts. Do not continue the remaining LMSPro R8-A3
attachment-delivery checklist until items 1 through 13 pass.

## 5. Gate Decision

Automated technical review is PASS for exact application commit `6b822e45`, and that commit is now
the source head of both `origin/dev` and `origin/staging`. The slice is not deployment-complete
until the staging deployment is verified and the mandatory human smoke passes. No live promotion
is authorised.

LMSPro R8-A3 remains explicitly blocked by this Platform slice until the staging smoke is recorded
as PASS. If body-stream failure or a reproducible database failure appears, stop testing and open a
separately evidenced corrective/triage record rather than expanding this implementation silently.
