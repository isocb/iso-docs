# FUND And Commerce Development Promotion And Migration Confirmation

Date: 2026-07-14

Status: Complete on application `origin/dev` and the Neon development database; staging
and production untouched

## Promotion

- IsoDocs `main` was promoted to `origin/main` through COMMERCE-A5 lifecycle commit
  `5632a7f` before this confirmation was added.
- IsoStack application `dev` was promoted to `origin/dev` at `fd7376b`.
- Application `origin/staging` and `origin/main` remained at `ea4e619` throughout.
- Local environment evidence showed `NODE_ENV=development`,
  `NEXT_PUBLIC_ENV=development`, `NEXT_PUBLIC_APP_URL=http://localhost:3000`, and distinct
  one-way host fingerprints for `DATABASE_URL` and `TEST_DATABASE_URL`.
- The user created a Neon child branch from `devdata` before migration as the recovery
  point.

## Development migration

The configured Neon development database began with 127 of 139 repository migrations
applied. `prisma migrate deploy` applied Commerce A1, FUND C1-C5 and FUND R3-A, then the
R3-D empty-baseline guard stopped safely because disposable FUND test records existed.
The failed R3-D transaction changed no R3-D schema or row data.

Aggregate diagnosis found 3 FUND Clients, 12 Projects, 1 Client Member and 2 Intake
Submissions. The user explicitly confirmed all FUND records were disposable. A dependency
check found no non-FUND table referencing a FUND table. All 33 then-existing FUND tables
were truncated together without `CASCADE`; exact post-check was zero FUND rows. Public,
LMSPro, Commerce, Pulse and migration-ledger data were not cleared.

The failed R3-D attempt was marked rolled back with `prisma migrate resolve --rolled-back`.
The second `prisma migrate deploy` then applied R3-D, Commerce A2, FUND C6, Commerce A3 and
Commerce A4. Final `prisma migrate status` reported all 139 migrations applied and the
ledger contained zero unresolved attempts.

## Verification

Pre- and post-migration public/LMSPro counts matched exactly:

```text
Organizations   6
Users           15
LMSPro Seasons  2
LMSPro Clubs    3
LMSPro Teams    5
```

Representative Organization, Season, Club and Team reads succeeded. Repository critical
file verification and TypeScript checking passed. Static schema-contract verifiers passed
for Commerce A1-A4 and FUND C1-C6. Final database inspection confirmed 37 FUND tables, 9
Commerce tables, zero FUND/Commerce business rows, zero unresolved migrations and one
installed A4 immutable-audit trigger.

No `db push`, `migrate dev`, staging deployment, production deployment, staging-database
migration or production-database migration was performed.

## Control consequence

Earlier roadmap statements describing C1-C6 or Commerce A1-A4 as undeployed to a shared
development database are superseded by this confirmation. They remain undeployed to
staging and production. COMMERCE-A6 remains the single next planning candidate.
