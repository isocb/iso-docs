# Safe Database Workflow

## Canonical rule (live-safe)

Schema changes must use Prisma migrations.

- **Local / Dev:** `npm run db:migrate:dev -- --name <name>`
- **Deployed envs:** `npm run db:migrate` (runs `prisma migrate deploy`)
- **Never** use `db:push` or `db:seed` as part of deployment.

## Recommended environment flow

```text
dev -> staging -> main
```

## Deployment process for schema changes

1. Update `prisma/schema.prisma` on `dev`.
2. Create migration and review SQL.
3. Commit migration files.
4. Merge/align `dev -> staging`.
5. In staging render shell:

```bash
npm run db:migrate
```

6. Validate staging smoke tests and merge `staging -> main`.
7. In live/render shell:

```bash
npm run db:migrate
```

8. Validate live smoke tests.

## Non-production seed usage

`db:seed` is local-only and destructive in effect (rebuild style). Do not run it in deployed environments.

## Legacy note

Any guidance that says to run `db:push` on staging/main is superseded by this workflow.

