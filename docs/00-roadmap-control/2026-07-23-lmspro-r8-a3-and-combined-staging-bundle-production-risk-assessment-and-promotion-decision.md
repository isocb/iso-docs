# LMSPro R8-A3 And Combined Staging Bundle Production Risk Assessment And Promotion Decision

Date: 2026-07-23

Status: Controlled combined promotion complete at application commit `b9287ffa`; R8-A3 is
present and accepted in staging and live; FUND human testing remains in progress
independently

## 1. Decision

LMSPro `R8-A3` has completed its bounded implementation, automated verification, Platform
dependency correction and staging human acceptance. Its attachment-delivery behaviour is
ready to enter a controlled production release.

The current application `staging` branch is a larger combined release containing Commerce,
FUND, Platform and LMSPro work. It must therefore continue to be promoted as that complete
release unit rather than described as an R8-A3-only deployment.

The Platform Owner has confirmed that FUND is an unfinished development module and that its
availability to live C1 tenants is already controlled through the existing Product/module
assignment controls. Incomplete FUND human testing therefore governs FUND refinement and
unrestricted rollout; it is not, by itself, a blocker to deploying the shared application
or the accepted LMSPro attachment work.

This document therefore records the completed outcome:

```text
R8-A3 bounded capability decision: COMPLETE IN STAGING AND LIVE
FUND E-B/E-C/E-D human testing: IN PROGRESS; not an automatic shared-release blocker
combined staging -> main route: COMPLETED through standard controls
application dev/origin-dev/staging/origin-staging/main/origin-main: b9287ffa
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

The later controlled release added the reviewed security/history-governance corrections
and completed with all application delivery branches aligned at:

```text
application dev/origin-dev:         b9287ffa
application staging/origin-staging: b9287ffa
application main/origin-main:       b9287ffa
```

`d14a652f` remains the accepted R8-A3 runtime ancestor and `99164ddd` remains its
assurance-only pacing-test descendant. The later candidate does not remove or supersede
that evidence.

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

The current staging ancestry also includes FUND `1R-E-D`, while authenticated E-B/E-C/E-D
real-workflow testing remains in progress. Under the Platform Owner's accepted operating
model, that work may remain explicitly incomplete when the shared application is promoted.
The existing Product/module assignment controls determine which C1 tenants, if any, receive
controlled alpha/beta access. No additional FUND route or code-level release gate is
required.

The definitive FUND schedule is:

`docs/modules/fund/05-review-and-test/2026-07-23-fund-phase-1-slice-1r-e-b-through-1r-e-d-consolidated-staging-human-smoke-test-schedule.md`

Open findings continue to generate bounded FUND remediation work on dev/staging and prevent
unrestricted FUND rollout until accepted. R8-A3 acceptance does not claim Stripe, Store,
Project, production-asset, commission or other sibling-lane behaviour complete.

## 7. Risk Register

| Risk | Assessment | Required control |
| --- | --- | --- |
| Promoting 38 commits as though they were one LMSPro fix | High | Treat the full range as the release unit; separately record unfinished FUND as controlled work in progress |
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

### Option A - Controlled Combined Release With FUND Work In Progress

Selected operating model when all 38 commits are deployed together:

1. record FUND E-B/E-C/E-D testing truthfully as in progress and retain Platform Owner
   control over live tenant Product/module assignment;
2. correct and prove the shared scheduled Security Scan;
3. review the exact Commerce/FUND/Platform production environment dependencies without
   enabling unfinished behaviours;
4. run read-only live migration preflights for all data-dependent guards;
5. approve the complete 17-migration/38-commit release and recovery boundary;
6. configure/verify the live R8-A3 cron environment;
7. deploy migrations before code through the accepted Render path;
8. verify health, migration completion and bounded LMSPro/shared-platform smoke; and
9. perform one controlled live attachment delivery followed by a no-attachment regression.

FUND staging testing and bounded remediation then continue during the following week(s).
Incomplete FUND items remain incomplete; they are not converted to PASS by deployment.

### Option B - Plan A Selective LMSPro Production Release

If R8-A3 must ship before the other staging work, create a separate controlled release plan
from `origin/main`. It must identify the exact Platform, security, LMSPro source and
migration dependencies required by R8-A2R, `PLAT-RUNTIME-01`, R8-A3 and R8-A3-F1.

This is not a casual cherry-pick. It requires a fresh branch ancestry audit, fresh migration
replay from the production baseline, full automated verification, a separate staging
environment/deployment proof and updated lifecycle evidence. No such selective release is
authorised by this document.

## 10. Completed Promotion Decision

The Platform Owner authorised Option A after the standard controls were satisfied. The
completed decision is:

```text
shared Security Scan: PASS
read-only live migration preflights: PASS
live snapshot/recovery boundary: CONFIRMED BY PLATFORM OWNER
controlled migration-before-code release: COMPLETE
application branch alignment: b9287ffa
R8-A3 staging/live attachment delivery: PASS
FUND unrestricted production readiness: NOT CLAIMED
```

The scheduled and exact-candidate Security Scans passed after the bounded dependency and
Gitleaks corrections. The combined migration chain initially stopped safely at the R3-D
empty-FUND baseline guard. The Platform Owner had already classified the live FUND records
as disposable development data and held a live database snapshot. The FUND schema was
cleared without deleting LMSPro/public data, the failed R3-D attempt was marked rolled
back, and the same migration-before-code deployment was retried successfully.

After deployment, authentication initially returned HTTP 500 because the configured
Upstash REST URL and REST token did not belong to the same database credential set. The
matching REST token was restored without changing `AUTH_SECRET`, `NEXTAUTH_SECRET` or the
database encryption key, and MAIN returned green.

The first live attachment delivery then failed because the web-service R2 credentials had
been rotated but the separately configured live cron still held stale signing
credentials. The same current R2 account/access-key/secret-key/bucket tuple was applied to
the web and cron consumers without recording its values. Fresh attachment sends
subsequently passed in both staging and MAIN. This closes the R8-A3 live environment and
transport gate.

FUND human testing continues against its recorded staging candidate. Open FUND findings
remain development/remediation work and do not become PASS merely because the shared
application is live.

Exact-candidate Security Scan evidence:

- manual governed branch-diff/current-tree run: `29997153382`;
- `dev`: `29997506649`;
- `staging`: `29997657278`; and
- `main`: `29997904145`.

## 11. Credential-Rotation Operational Note

During the shared Security Scan remediation, the Platform Owner confirmed that resetting
the password for an existing Upstash Redis database successfully regenerates its REST
token without creating a replacement database. The Upstash console may continue to display
the previous token in the current browser session after the success prompt. Log out of
Upstash and sign in again before copying the refreshed token.

After reset:

1. refresh the Upstash session by logging out and back in;
2. copy the newly displayed REST token without placing it in source, documentation, chat
   or screenshots;
3. update every approved Render service or cron that consumes that database;
4. redeploy those consumers; and
5. verify Redis-backed application behaviour before considering the rotation complete.

This note records operating behaviour only. It contains no token, Redis URL, account
identifier or credential evidence.

Cloudflare R2 rotation has the same multi-consumer requirement. Each environment's web
service and attachment-delivery cron are separate Render consumers. The account ID,
access-key ID, secret access key and exact private attachment-bucket name must be updated
and redeployed together for each affected consumer. A successful web upload does not prove
that the cron can sign a valid private-object download.

## 12. Remaining Documentation And Product Work

R8-A3 implementation, deployment and promotion are complete. The next LMSPro email work is
not selected by this record. The consolidated remediation CR was subsequently completed as a
four-item planning input and reconciled by the 2026-07-27 planning refinement:

`docs/modules/lmspro/01-cr-inputs/2026-07-22-lmspro-consolidated-email-integrity-club-visibility-and-remedial-work-cr-input.md`

`docs/modules/lmspro/01-cr-inputs/2026-07-27-lmspro-consolidated-four-item-remediation-planning-refinement.md`

The complete CR is ready for formal control-window triage. No executable slice is selected or
authorised by this production record, the CR or the refinement. Formal triage must preserve one
coordinated programme with separately bounded slices and carry item 3's accepted business
semantics plus mandatory read-only live-state inventory and consumer-classification gates into
bounded planning.
