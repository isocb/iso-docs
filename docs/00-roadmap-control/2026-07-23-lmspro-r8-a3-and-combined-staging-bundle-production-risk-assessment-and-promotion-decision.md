# LMSPro R8-A3 And Combined Staging Bundle Production Risk Assessment And Promotion Decision

Date: 2026-07-23

Status: Assessment complete; R8-A3 accepted for production in principle; current combined
`staging` to `main` promotion is **HOLD / NOT AUTHORISED**

## 1. Decision

LMSPro `R8-A3` has completed its bounded implementation, automated verification, Platform
dependency correction and staging human acceptance. Its attachment-delivery behaviour is
ready to enter a controlled production release.

The current application `staging` branch must nevertheless **not** be promoted to `main` as
one release at this checkpoint.

The reason is not an unresolved R8-A3 defect. Repository reconciliation proves that the
current `staging` branch is a much larger combined release containing Commerce, FUND,
Platform and LMSPro work whose collective production gates have not all been closed.

This document therefore records:

```text
R8-A3 bounded capability decision: READY IN PRINCIPLE
current staging -> main bundle decision: HOLD / NOT AUTHORISED
live services and live database: UNCHANGED
```

## 2. Mandatory Controls Read

The assessment read:

- `isostack-bedrock/docs/00-READ_THIS/DEPLOY_VERIFY_CHECKLIST.md`;
- `isostack-bedrock/.github/CODEX_OPERATING_CHARTER.md`;
- `isodocs/docs/guides/git-workflow.md`;
- `isodocs/SAFE_DATABASE_WORKFLOW.md`;
- the R8-A3 planning, implementation-confirmation and review/test records;
- the R8-A3 dev/staging promotion record;
- the Platform `PLAT-RUNTIME-01` lifecycle;
- the root Platform/module roadmap;
- the LMSPro controlling roadmap; and
- the current FUND roadmap and 1R-E promotion record.

The accepted sequence remains:

```text
dedicated branch
-> dev
-> origin/dev
-> staging
-> staging acceptance
-> production risk assessment
-> explicit production decision
-> migration-before-code production deployment
-> bounded live smoke
```

No direct remote-ref push, force-push, `prisma db push`, seed, live migration or live
service mutation was performed by this assessment.

## 3. Exact Reconciled Repository Boundary

After committing the deterministic no-network scale proof and using fast-forward-only
branch reconciliation:

```text
application feature branch: 99164dddcc51da0f27864fefc913eb32adb58ef0
application dev/origin-dev:  99164dddcc51da0f27864fefc913eb32adb58ef0
application staging/origin-staging:
                              99164dddcc51da0f27864fefc913eb32adb58ef0
application main/origin-main:
                              ea4e6193a65de97d5cdf622560a5c8921154fc24
```

Commit `99164ddd` adds test evidence only. It changes no production runtime, schema,
migration, environment or UI contract relative to the staging-accepted runtime at
`d14a652f`.

The reconciled `origin/main..origin/staging` range contains:

```text
38 commits
208 changed files
44,109 insertions
2,348 deletions
17 Prisma migrations
```

This is the production release unit produced by an ordinary fast-forward of `main` to the
current `staging`. It cannot accurately be described as an R8-A3-only deployment.

## 4. R8-A3 Readiness Evidence

The bounded R8-A3 evidence is green:

- no-attachment ad-hoc Email remains on the immediate supported batch route;
- one large PDF queued, was claimed by the existing cron, reached `SENT` and arrived intact;
- three permitted attachments totalling no more than 10 MB and three HTTPS links arrived
  intact/clickable;
- one-primary-recipient CC/BCC delivery passed;
- multiple-primary-recipient CC/BCC use failed closed;
- duplicate queue/delivery prevention passed;
- intentional send-again through `Duplicate to Draft` passed with a new Email identity;
- queued/SENDING/SENT reconciliation passed;
- runtime evidence remained bounded and credential/resource safe;
- four-recipient live staging pacing smoke passed;
- the final no-attachment batch regression passed; and
- a deterministic test processed 300 synthetic recipients across two 150-recipient worker
  cycles, proved no more than three mocked provider starts per rolling second and made no
  real network or Email-provider request.

The exact test-evidence commit passed:

- focused worker tests;
- adjacent attachment-delivery regression tests;
- the full Vitest suite: 162 passed and 12 skipped;
- TypeScript;
- critical-file verification;
- Prettier/diff validation; and
- pre-commit verification.

Exact-commit GitHub Security Scans also passed:

- dev run `29988592900`; and
- staging run `29988604215`.

The forced typed-ESLint boundary remains the separately registered
`PLAT-ASSURE-01` test/script parser-project finding; it is not an R8-A3 runtime regression.

## 5. Combined Migration Assessment

The 17 migrations between production `main` and current `staging` span:

- Commerce seller, checkout, Order, payment, refund, pro-forma, audit, idempotency and
  Stripe Connect foundations;
- FUND Product, media, Store, production-asset, commission, intake, Project creation,
  Order-context and Store-intervention foundations; and
- LMSPro attachment evidence, the accepted unscanned-policy correction and durable
  attachment-delivery jobs.

Most changes are additive, but the combined chain contains material production
preconditions:

1. `20260714234500_fund_1p_g_r3_d_project_creation_contract` deliberately refuses to run
   when any FUND Client or FUND Project exists. It then adds required Client/Project
   fields and `NOT NULL` constraints.
2. `20260714235900_fund_1r_c6_commerce_context_foundation` refuses pre-existing
   FUND-source Commerce Orders without typed context.
3. `20260716003000_fund_1r_e_a_store_authority_intervention_foundation` refuses Stores
   carrying retired `CLOSED` or `closed_at` evidence.
4. `20260721150000_lmspro_r8_a2r_remove_malware_scan_evidence` drops only the temporary
   malware-scan columns/type introduced by the immediately preceding, unpromoted R8-A2
   migration. Sequential deployment makes that pair internally coherent, but it still
   prevents describing the whole production migration range as purely additive.

Staging success does not prove the three data-dependent production preconditions against
the live database. The safe database workflow requires explicit live preflight evidence
before authorising this migration chain.

## 6. Outstanding Cross-Lane Gates

The current staging ancestry also includes FUND `1R-E-D`, but the FUND roadmap and 1R-E
promotion record still identify authenticated E-B/E-C real-workflow acceptance as pending.
Those documents must be reconciled with completed human evidence or the tests must be run
before the combined bundle can be accepted for production.

The definitive FUND schedule is:

`docs/modules/fund/05-review-and-test/2026-07-23-fund-phase-1-slice-1r-e-b-through-1r-e-d-consolidated-staging-human-smoke-test-schedule.md`

Commerce and FUND production environment/configuration gates must also be reviewed for the
exact 38-commit bundle. R8-A3 acceptance cannot implicitly authorise Stripe, Store, Project,
production-asset, commission or other sibling-lane behaviour.

## 7. Risk Register

| Risk | Assessment | Required control |
| --- | --- | --- |
| Promoting 38 commits as though they were one LMSPro fix | High | Treat the full range as the release unit and close every owning-lane gate |
| Live FUND data violates R3-D empty-baseline guard | Critical until checked | Read-only live preflight; stop on any FUND Client or Project |
| Existing FUND-source Orders or retired Store state block later migrations | High until checked | Run the exact accepted preflight queries before deployment |
| Seventeen migrations run before a large code replacement | High | Approved maintenance window, migration-before-code ordering, logs and abort criteria |
| Schema/code rollback after migrations | Medium/High | Roll forward by default; do not assume Git rollback reverses database changes |
| Live attachment cron points at wrong database or bucket | High | Verify service-local names and values immediately before deployment |
| Singular/plural bucket drift recurs | High but controllable | Confirm actual private bucket identity; expected current name is `seasonpro-email-attachment-live` |
| Cron name differs from checked-in Blueprint | Medium | Use existing live cron `isostack-bedrock`; do not casually Blueprint-sync `isostack-jobs` |
| Shared R2 credential crosses staging/live | Medium, business-accepted | Keep distinct private buckets, least privilege where possible and no public domain |
| Test-only assurance commit changes deployed runtime | Low | Commit is test-only; verify candidate diff before promotion |

## 8. Live R8-A3 Environment Gate

If and only if a later production decision authorises the relevant release, the existing
live cron `isostack-bedrock` must independently have:

- the live `DATABASE_URL`;
- the production `RESEND_API_KEY`;
- the approved production sender/`EMAIL_FROM`;
- `R2_ACCOUNT_ID`;
- `R2_ACCESS_KEY_ID`;
- `R2_SECRET_ACCESS_KEY`;
- the exact private live `R2_EMAIL_ATTACHMENT_BUCKET_NAME`;
- the one-minute schedule `* * * * *`; and
- no public `r2.dev` or custom public domain for the attachment bucket.

The expected bucket name from the accepted environment work is singular:

`seasonpro-email-attachment-live`

That value must be confirmed against the actual Cloudflare bucket rather than copied from
documentation. Evidence records variable names and PASS/FAIL only, never secrets, complete
database URLs or signed object URLs.

## 9. Promotion Options

### Option A - Complete The Combined Release Gate

Preferred when all 38 commits are intended for production:

1. reconcile the FUND staging status and complete/record E-B/E-C/E-D human acceptance;
2. review all Commerce/FUND/Platform production environment dependencies;
3. run read-only live migration preflights for all data-dependent guards;
4. approve the complete 17-migration/38-commit release;
5. configure/verify the live R8-A3 cron environment;
6. deploy migrations before code through the accepted Render path;
7. verify health, migration completion and bounded cross-lane smoke; and
8. perform one controlled live attachment delivery followed by a no-attachment regression.

### Option B - Plan A Selective LMSPro Production Release

If R8-A3 must ship before the other staging work, create a separate controlled release plan
from `origin/main`. It must identify the exact Platform, security, LMSPro source and
migration dependencies required by R8-A2R, `PLAT-RUNTIME-01`, R8-A3 and R8-A3-F1.

This is not a casual cherry-pick. It requires a fresh branch ancestry audit, fresh migration
replay from the production baseline, full automated verification, a separate staging
environment/deployment proof and updated lifecycle evidence. No such selective release is
authorised by this document.

## 10. Promotion Decision And Next Controlled Action

The production decision is:

```text
DO NOT fast-forward current staging to main.
DO NOT run the 17-migration chain against live.
DO NOT change live cron or live R2 settings under this assessment alone.
```

R8-A3 remains staging-accepted and production-ready in principle. The next controlled
decision is to choose and authorise either:

- completion of the full combined release gate under Option A; or
- a newly planned selective LMSPro release under Option B.

Until that decision and its prerequisites are complete, `origin/main`, live services and
the live database remain unchanged.
