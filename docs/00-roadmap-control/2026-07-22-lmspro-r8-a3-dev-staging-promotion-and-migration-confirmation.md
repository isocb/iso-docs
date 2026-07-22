# LMSPro R8-A3 Development And Staging Promotion And Migration Confirmation

Date: 2026-07-22

Status: Controlled development/staging promotion and migration deployment complete; human
UI/transport testing pending

## 1. Scope

This record controls promotion of LMSPro remediation slice `R8-A3` from its reviewed
implementation branch through application `dev` to the online staging test environment.

It does not authorise or claim application `main`, live deployment, live database change,
human UI/transport acceptance or any later R8 slice.

## 2. Mandatory Control Read

Before promotion, the current control turn read:

- `isostack-bedrock/docs/00-READ_THIS/DEPLOY_VERIFY_CHECKLIST.md`;
- `isostack-bedrock/.github/CODEX_OPERATING_CHARTER.md`;
- `isodocs/docs/guides/git-workflow.md`;
- `isodocs/SAFE_DATABASE_WORKFLOW.md`;
- `isostack-bedrock/scripts/render-build.sh`; and
- relevant prior controlled dev-to-staging promotion confirmations.

The promotion used clean local `dev` and `staging` worktrees and fast-forward-only merges.
It did not use a direct remote-ref push, `db push`, `db seed`, force-push or production
command.

## 3. Repository Evidence

```text
reviewed R8-A3 branch:       90974123fabfce04c68d41895ad3adaa8f57f785
application dev:             90974123fabfce04c68d41895ad3adaa8f57f785
application origin/dev:      90974123fabfce04c68d41895ad3adaa8f57f785
application staging:         90974123fabfce04c68d41895ad3adaa8f57f785
application origin/staging:  90974123fabfce04c68d41895ad3adaa8f57f785
application main:            ea4e6193a65de97d5cdf622560a5c8921154fc24
application origin/main:     ea4e6193a65de97d5cdf622560a5c8921154fc24
```

Both `origin/dev...dev` and `origin/staging...staging` reported zero divergence after the
promotion. Application `main` and `origin/main` remained unchanged.

The controlled sequence was:

```text
fast-forward reviewed branch into local dev
-> push origin/dev
-> pass the Security Scan for the exact dev SHA
-> fast-forward local staging from the same dev SHA
-> push origin/staging
-> pass the Security Scan for the exact staging SHA
-> wait for Render migration/build/deployment
-> verify the online build and health before human testing
```

## 4. Migration Boundary And Ordering

The staging delta contains one Prisma migration:

`20260722120000_lmspro_r8_a3_email_delivery_jobs`

The migration is additive. It creates the typed delivery-job, recipient-attempt and
attachment-snapshot persistence required by R8-A3, with supporting indexes and foreign
keys. It contains no `DROP`, `DELETE`, `TRUNCATE`, destructive seed or semantic business-row
backfill.

The accepted Render build contract executes:

```text
npm ci
-> prisma generate
-> prisma migrate deploy
-> idempotent component-definition sync
-> Next.js build
-> application replacement after a successful build
```

This supplies migration-before-code ordering for staging without pointing a local shell at
an ambiguous remote database. No `prisma migrate dev`, `db push`, seed or manually inferred
staging connection was used.

## 5. Automated Promotion Gates

Exact-commit GitHub gates passed for application commit `90974123`:

- dev Security Scan `29926237990`;
- staging Security Scan `29926544231`;
- secret detection;
- dependency vulnerability audit;
- Prisma/database-schema security review; and
- TypeScript type safety.

The implementation confirmation separately records the successful local Prisma,
TypeScript, focused/full test, critical-file and clean production-build evidence.

## 6. Online Staging Evidence

Before promotion, the staging health endpoint reported healthy database connectivity and
RLS enabled for all `11/11` expected tables. The public staging layout bundle identified
the prior deployed build as `6c5aaa5`.

After Render completed its replacement, the public no-cache layout bundle reported:

```text
BUILD: 9097412
```

The post-deployment health endpoint then reported:

```text
status: healthy
database: connected
RLS: enabled, 11/11 expected tables
```

The unauthenticated LMSPro communications route returned the expected boundary:

```text
HTTP 307
location: /auth/lmspro/login?callbackUrl=%2Fapp%2Flmspro%2Fcommunications
```

Because `scripts/render-build.sh` exits on error and runs `prisma migrate deploy` before the
Next.js build and service replacement, the observed `9097412` replacement is evidence that
the accepted migration-before-code build sequence completed. No direct staging
`_prisma_migrations` query was made from the local workspace, so this record does not invent
an independently observed migration inventory.

The local environment has no Render API credential, so this record will not invent a
Render build identifier, migration inventory or cron log result that was not independently
observed. The human/testing team must additionally confirm in the Render dashboard that the
existing staging `isostack-jobs` cron has its staging-only database and private attachment
bucket variables and runs on the accepted one-minute schedule.

## 7. Remaining Human Gate

Perform the remaining human UI/transport schedule in:

`docs/modules/lmspro/05-review-and-test/2026-07-22-lmspro-remediation-slice-r8-a3-durable-attachment-delivery-job-rate-limiter-and-retry-review-and-test.md`

That schedule remains the authority for no-attachment regression, queued attachment
delivery, exact attachment/link receipt, CC/BCC constraints, idempotency, status
reconciliation, rate limiting, retry and audit/log evidence.

No result in this promotion record substitutes for those authenticated checks. Staging is
ready for that schedule, subject to the Render cron environment/log confirmation described
above.

## 8. Promotion Boundary

Do not promote R8-A3 to `main` or live until the staging human UI/transport checks are
reported PASS or a bounded corrective slice resolves every blocking failure. Application
`main`, live services and the live database remain outside this action.
