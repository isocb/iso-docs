# FUND 1R-E Development And Staging Promotion Confirmation

Date: 2026-07-20

Status: Controlled development/staging promotion complete; authenticated E-B/E-C human UI
schedule remains pending

## 1. Scope

This record closes the controlled branch and automated online promotion of completed FUND
`1R-E-A` through `1R-E-C` from application `dev` to `staging`.

It does not authorise or claim application `main`, live deployment, live database change,
`1R-F-A` implementation or public Store work.

## 2. Mandatory Control Read

Before promotion, the current turn read:

- `isostack-bedrock/docs/00-READ_THIS/DEPLOY_VERIFY_CHECKLIST.md`;
- `isodocs/docs/guides/git-workflow.md`;
- `isodocs/SAFE_DATABASE_WORKFLOW.md`; and
- the application deployment and safe-database guidance.

The promotion used a local `staging` branch update and fast-forward merge. It did not use a
direct remote-ref push, `db push`, `db seed`, force-push or production command.

## 3. Repository Evidence

```text
application dev:            e3f44b4b
application origin/dev:     e3f44b4b
application staging:        e3f44b4b
application origin/staging: e3f44b4b
application main:           ea4e6193 (unchanged)
application origin/main:    ea4e6193 (unchanged)
IsoDocs promotion baseline: 57f7cdc
```

The controlled sequence was:

```text
push dev
-> wait for exact dev Security Scan
-> checkout local staging
-> pull origin/staging with --ff-only
-> merge dev with --ff-only
-> push origin/staging
-> return to dev
```

Final remote verification reported zero divergence for both `origin/dev...dev` and
`origin/staging...staging`.

## 4. Migration Boundary

The complete `origin/staging..dev` Prisma delta contained only:

- `20260716003000_fund_1r_e_a_store_authority_intervention_foundation`; and
- its accepted Prisma schema representation.

E-B and E-C add no migration. The E-A migration uses zero semantic backfill, creates typed
intervention evidence and refuses to run if any Store still uses retired `CLOSED` or
`closed_at` evidence. It contains no business-row deletion, truncation or destructive seed.

The Render staging build contract runs `prisma migrate deploy` before the application
build. The online deployment subsequently reported healthy database connectivity. No
direct staging migration-inventory query was made from the local workspace, so this record
does not invent an independently observed staging migration count.

The configured Neon development database was not migrated in this promotion turn and
remains a separate environment concern.

## 5. Automated Evidence

Local pre-promotion gates passed:

- TypeScript type-check;
- repository critical-file verification;
- E-B Store-oversight helper tests;
- E-C client-Store helper test;
- production Next.js build; and
- clean Git diff/working-tree checks.

Exact-commit GitHub gates passed:

- dev Security Scan `29729448020`; and
- staging Security Scan `29729620299`.

Each completed secret detection, dependency audit, Prisma/migration security and TypeScript
jobs successfully for application commit `e3f44b4b`.

## 6. Online Staging Evidence

The staging health endpoint returned:

```text
status: healthy
database: connected
RLS: enabled, 11/11 expected tables
```

Unauthenticated boundary checks returned the expected sign-in redirects:

- `/app/fund/stores` -> `/auth/signin?callbackUrl=%2Fapp%2Ffund%2Fstores`; and
- `/app/fund/client` -> `/auth/signin?callbackUrl=%2Fapp%2Ffund%2Fclient`.

These checks prove online boot, database/RLS health and protected route boundaries. They do
not replace the authenticated C1/C2 interaction schedule in the E-C R1 review.

## 7. Remaining Human Gate And Post-Promotion Finding

The following were scheduled rather than claimed:

- C1 Store portfolio/detail, filtering, readiness refresh and exceptional intervention;
- C2 VIEWER versus PROJECT_MANAGER/ADMIN Store permissions;
- C2 commission acceptance and Project/Store lifecycle actions;
- Event-envelope and blocker presentation; and
- responsive/accessibility/keyboard review.

Preparation on 2026-07-21 established that the schedule cannot begin from the real empty FUND
state: canonical Project creation creates no Store/default eligible Product set, C1 correctly
has no routine Store-create authority and the only creation UI is the optional C2 `Prepare
Store` action. Human acceptance is therefore blocked, not failed, pending corrective E-D.

Human results should be appended to the existing E-B/E-C review records only after E-D makes
the real Project workflow testable.

## 8. Result And Boundary

Application `dev` and `origin/dev` match, and the exact same commit is promoted to online
`staging`/`origin/staging`. Automated staging acceptance and online health checks pass.

Application `main`, live deployment and the live database remain unchanged. The subsequent
E-D plan is now the single next review candidate before `1R-F-A`; this promotion authorises
neither implementation.
