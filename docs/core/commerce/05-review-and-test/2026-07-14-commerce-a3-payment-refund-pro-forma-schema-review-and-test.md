# Commerce Core COMMERCE-A3 Payment, Refund And Pro-forma Schema Review And Test

Date: 2026-07-14

Status: Passed / complete 138-migration disposable lifecycle

Application commit: `4a90be1`

Implementation confirmation:

`docs/core/commerce/04-implementation-confirmations/2026-07-14-commerce-a3-payment-refund-pro-forma-schema-implementation-confirmation.md`

## 1. Review Scope

Reviewed A3 for provider-neutral ownership, independent commercial states, exact
tenant/Order/currency relations, append-oriented Refund evidence, pro-forma route identity,
bounded monetary shapes, chronology, uniqueness, deletion, zero backfill, migration safety
and absence of runtime/provider/FUND scope.

## 2. Files Reviewed

```text
prisma/schema.prisma
prisma/migrations/20260715001000_commerce_a3_payment_refund_pro_forma_foundation/migration.sql
scripts/verify-commerce-a2-schema.ts
scripts/verify-commerce-a3-schema.ts
scripts/verify-commerce-a3-pre-migration.sql
scripts/verify-commerce-a3-database.sql
scripts/run-commerce-a3-database-tests.ts
```

## 3. Static And Repository Validation

Passed:

```text
npx prisma format
npx prisma validate
npx prisma generate
npx tsx scripts/verify-commerce-a1-schema.ts
npx tsx scripts/verify-commerce-a2-schema.ts
npx tsx scripts/verify-commerce-a3-schema.ts
npm run type-check
npm run verify
git diff --check
```

Repository-wide `npm run lint` was run and remains non-green on established UI files,
including unescaped JSX content and existing warnings. None is in an A3 file and A3 adds no
application/UI code, so this is recorded rather than expanded into unrelated remediation.

## 4. Representative Migration

The runner parsed both database targets and proved `TEST_DATABASE_URL` differed from
`DATABASE_URL` before connecting. It disclosed only target hash `08ec48a4244a` and database
name `neondb`.

Starting state:

```text
137 applied migrations
0 failed migrations
```

Existing Organization, Seller Profile, FUND Client and Commerce Order fixtures were
preserved exactly. Only migration 138 applied and it created no Payment, Refund or
Pro-forma row.

## 5. Constraint And Ownership Evidence

Rollback-only suites passed on representative and fresh databases. They verified valid
Stripe pending/paid/refunded evidence and pro-forma Payment/document lifecycles, and rejected:

- invalid amount/status/timestamp combinations;
- missing or forbidden provider evidence by route;
- invalid hashes, reason codes and chronology;
- duplicate external provider, Refund and pro-forma references;
- unknown/cross-tenant Order or Payment identity;
- Payment currency differing from its Order;
- Refund Payment/Order/currency mismatches;
- pro-forma Payment/Order/currency/route mismatches;
- deletion of Organization, Order or Payment while retained evidence exists.

## 6. Fresh Replay And Regression

All 138 repository migrations replayed successfully from empty on the disposable target.
A1, A2 and FUND C6 database regressions passed on representative and fresh states.

Final inventory:

```text
applied=138,failed=0
a3_rows=0
a3_fixture_orgs=0
```

The retained disposable database remains clean at migration 138.

## 7. Review Finding

The final review strengthened the accepted design: Payment currency is now part of the
physical Payment-to-Order composite foreign key, supported by an exact Order key. This
prevents structurally valid but commercially mismatched Payment currency before services
exist.

The drift inspection found no Commerce-owned difference. Older unrelated repository drift
remains outside A3 and was not concealed by altering historic migrations.

## 8. Verdict

COMMERCE-A3 conforms to its schema-only boundary and passes static, generated-client,
migration, preservation, constraint, tenant, currency, deletion, regression and cleanup
review. No shared database deployment is claimed. A4 is the single next planning candidate;
runtime payment work and FUND Store UI remain separately controlled.
