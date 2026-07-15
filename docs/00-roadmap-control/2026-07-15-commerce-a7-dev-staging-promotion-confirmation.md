# Commerce A7 Development And Staging Promotion Confirmation

Date: 2026-07-15

Status: Completed development and staging promotion evidence

## 1. Scope

This record closes the controlled promotion of the completed Commerce A6-A through A7
application bundle and its retained FUND dependencies from `dev` to `staging`.

It records deployment evidence only. It does not authorise or claim promotion to
application `main` or the live database.

## 2. Control Preflight

Before promotion, the current deployment turn re-read:

- `isostack-bedrock/docs/00-READ_THIS/DEPLOY_VERIFY_CHECKLIST.md`;
- `isodocs/docs/guides/git-workflow.md`; and
- `isodocs/SAFE_DATABASE_WORKFLOW.md`.

The application and IsoDocs controls were amended so this current-turn control read is a
mandatory first step for every future promotion.

## 3. Repository Evidence

```text
application dev:            91e8751c
application origin/dev:     91e8751c
application staging:        91e8751c
application origin/staging: 91e8751c
application main:           ea4e6193 (unchanged)
application origin/main:    ea4e6193 (unchanged)
IsoDocs main/origin-main:   9cf27a5
```

Application `91e8751c` contains the completed A7 implementation at `598305ce`, the complete
A6-A through A6-D ancestry and the narrow Gitleaks allowlist correction for the fixed,
non-credential A6-D webhook test fixture.

The allowlist is limited to the exact fixture line and file. The repeated dev and staging
Secret Detection jobs then passed.

## 4. Database And Automated Verification

- the configured Neon development database advanced from 139 to 140 applied migrations;
- `20260716002000_commerce_a6_a_stripe_connect_account_event_inbox_foundation` applied
  successfully through Prisma migration deployment;
- final development `prisma migrate status` reported the 140-migration schema up to date;
- no failed development migration remained;
- application `safe-commit`, TypeScript and critical-file verification passed;
- GitHub dev Security Scan run `29410890740` passed Secret Detection, dependency,
  database-schema and TypeScript checks; and
- GitHub staging Security Scan run `29411065003` passed the same complete gate.

The staging Render build contract runs Prisma migration deployment before application
build. No direct staging migration-inventory query was performed from the local workspace.

## 5. Staging Verification

The deployed staging health endpoint returned:

```text
status: healthy
database: connected
RLS: enabled, 11/11 expected tables
```

Human verification supplied by the user then passed:

- FUND administrator login; and
- smoke testing of the pre-existing UI.

No A7 public UI was expected because A7 remains a dormant internal Commerce/FUND
transaction boundary.

## 6. Result And Boundary

The controlled dev-to-staging promotion and its available automated and human staging
verification are complete.

Production `main` and live deployment remain unchanged and require their own explicit
controlled promotion. The single next planning candidate is FUND
`1R-E - C1 Store Oversight And C2 Project Store Control Alignment`.
