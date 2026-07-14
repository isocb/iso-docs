# Commerce Core COMMERCE-A1 Schema/Seller Profile/Enums Review And Test

Date: 2026-07-13

Status: Passed / disposable PostgreSQL migration and constraint smoke complete

Implementation confirmation:

`docs/core/commerce/04-implementation-confirmations/2026-07-13-commerce-a1-schema-seller-profile-enums-implementation-confirmation.md`

## 1. Review Scope

Reviewed the local `COMMERCE-A1` implementation for:

- adherence to the accepted A1 boundary;
- Prisma multi-schema validity;
- schema/migration agreement;
- generated-client model and relation shape;
- tenant ownership and restrictive deletion evidence;
- migration check/index/foreign-key coverage;
- absence of checkout, Order, payment, provider, Stripe and FUND records;
- repository type and critical-file health.

## 2. Files Reviewed

```text
prisma/schema.prisma
prisma/migrations/20260713120000_commerce_a1_schema_seller_profile_enums/migration.sql
scripts/verify-commerce-a1-schema.ts
scripts/verify-commerce-a1-database.sql
```

## 3. Commands And Results

### Prisma format

```text
npx prisma format
```

Result: passed.

### Prisma validation

```text
npx prisma validate
```

Result: passed; Prisma reported the schema valid with `commerce` in the multi-schema
datasource.

### Prisma client generation

```text
npx prisma generate
```

Result: passed with Prisma Client `5.22.0`.

### A1 contract verification

```text
npx tsx scripts/verify-commerce-a1-schema.ts
```

Result: passed.

Verified:

- exactly four Commerce enums with accepted values;
- exactly one Commerce model: `CommerceSellerProfile`;
- required/unique Organization ownership in generated Prisma metadata;
- public Organization foreign key with `ON DELETE RESTRICT` in migration SQL;
- all six accepted check constraints;
- only `commerce_seller_profiles` is created as a Commerce table;
- no executable migration reference to FUND;
- no checkout, Order, payment, refund, pro-forma or Stripe object.

### TypeScript

```text
npm run type-check
```

Result: passed.

### Targeted verification-script lint

```text
npx eslint --no-ignore scripts/verify-commerce-a1-schema.ts
```

Result: passed with no errors or warnings.

### Repository verification

```text
npx tsx scripts/verify-critical-files.ts
```

Result: passed, including its internal TypeScript check.

### Diff hygiene

```text
git diff --check
```

Result: passed.

### Prisma SQL projection review

```text
npx prisma migrate diff --from-empty --to-schema-datamodel prisma/schema.prisma --script
```

Result: passed and produced a complete SQL projection. Inspection confirmed the generated
cross-schema foreign key:

```text
commerce.commerce_seller_profiles.organization_id
-> public.organizations.id
ON DELETE RESTRICT
```

The committed migration remains intentionally hand-reviewed because Prisma schema syntax
does not express the accepted text/country/currency check constraints.

## 4. Migration SQL Review

The migration contains exactly:

- one `CREATE SCHEMA IF NOT EXISTS commerce` statement;
- four Commerce enum creations;
- one Commerce table creation;
- one unique index;
- one Organization/status index;
- six check constraints;
- one cross-schema Organization foreign key.

It contains no data manipulation statement and no FUND relation.

Constraint names are explicit and short enough for PostgreSQL identifier limits.

## 5. Tenant-Isolation Evidence

Passed at schema-contract level:

- `organizationId` is required in Prisma and SQL;
- a mapped unique index enforces one profile per Organization;
- the foreign key prevents profiles for unknown Organizations;
- `ON DELETE RESTRICT` protects seller identity while a profile exists;
- generated Prisma metadata contains the expected Organization relation;
- no caller-supplied alternative tenant key exists.

This is persistence-boundary evidence, not authorization-service evidence. A1 contains no
seller-profile API, so route/user-permission tests are correctly out of scope.

## 6. Disposable-Database Migration And Constraint Smoke

Test target:

- explicitly configured `TEST_DATABASE_URL`;
- PostgreSQL `18.4` on a separate Neon test host;
- identity/fingerprint confirmed distinct from `DATABASE_URL` before connection;
- initial inventory: `public` schema only and zero tables.

Fresh-database result:

- `npx prisma migrate deploy` applied all 128 repository migrations successfully;
- `COMMERCE-A1` created one Commerce table and four Commerce enum types;
- no seed or Seller Profile data was created.

Existing-schema upgrade result:

- the disposable database was reset using a copied migration history excluding A1;
- all 127 pre-A1 migrations applied successfully;
- inventory confirmed 127 completed migrations, zero Commerce tables/enums and zero
  Organizations;
- the normal repository migration deployment then applied only
  `20260713120000_commerce_a1_schema_seller_profile_enums`;
- post-upgrade inventory confirmed 128 migrations, one Commerce table, four Commerce enums
  and unchanged Organization count.

The temporary baseline reset's trailing Prisma client-generation step could not infer the
repository package root from `/tmp`. This occurred after the database reset reported success
and did not affect migration state; direct database inventory proved the required
127-migration baseline before A1 was applied.

Constraint/default smoke:

```text
scripts/verify-commerce-a1-database.sql
```

Result: passed inside one transaction and rolled back.

Verified:

- valid `DRAFT` Seller Profile creation;
- valid explicit `ACTIVE` Seller Profile creation;
- defaults `DRAFT`, `GBP`, `TAX_EXCLUSIVE` and `HALF_UP`;
- duplicate Organization rejection;
- unknown Organization rejection;
- Organization deletion restriction;
- lowercase country rejection;
- lowercase currency rejection;
- blank legal name, address line 1, locality and postcode rejection;
- exactly two valid profiles existed before rollback;
- zero test Organizations and zero test Seller Profiles remained after rollback.

Final migration status reported 128 migrations and `Database schema is up to date`.

### Retained test database

The Neon database referenced locally by `TEST_DATABASE_URL` is intentionally retained as
the dedicated disposable migration and constraint-test target for later bounded slices.

Its retention does not promote it to a shared development, staging or production database:

- destructive reset/rebuild operations are permitted only when a future accepted test plan
  explicitly requires them;
- every use must first confirm that `TEST_DATABASE_URL` is distinct from `DATABASE_URL`;
- test credentials and the connection string remain local environment configuration and
  must not be copied into documentation or committed;
- tests must continue to clean up or roll back test records and record the resulting
  database state.

## 7. Review Findings

No blocking static/schema-contract defect was found.

The first verification-script run exposed a test implementation mismatch: Prisma DMMF enum
values are objects rather than strings. The verifier was corrected to compare each value's
`name`, then passed. This changed verification code only, not the schema or migration.

The first database-smoke run confirmed deletion restriction but PostgreSQL reported
`restrict_violation`, while the verifier initially expected only `foreign_key_violation`.
PostgreSQL automatically rolled back the failed transaction; zero smoke rows remained. The
verifier was corrected to accept the precise restrictive-deletion SQLSTATE and then passed.

## 8. Verdict

`COMMERCE-A1` passes static, generated-client, boundary, migration-SQL, fresh-database,
existing-schema-upgrade and transaction-scoped constraint review.

No shared development, staging or live database deployment is claimed or required for this
test verdict. Only the explicitly disposable test database was migrated; it is retained for
future controlled migration tests under the safeguards above.

`COMMERCE-A2` must not be implemented merely because A1 static review passed; it requires
its own accepted planning and must preserve the outstanding checkout ownership decisions.
