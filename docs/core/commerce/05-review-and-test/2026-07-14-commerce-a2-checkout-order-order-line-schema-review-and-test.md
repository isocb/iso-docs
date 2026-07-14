# Commerce Core COMMERCE-A2 Checkout/Order/Order-line Schema Review And Test

Date: 2026-07-14

Status: Passed / complete 136-migration disposable lifecycle

Application commit: `3206199`

Implementation confirmation:

`docs/core/commerce/04-implementation-confirmations/2026-07-14-commerce-a2-checkout-order-order-line-schema-implementation-confirmation.md`

## 1. Review Scope

Reviewed A2 for:

- accepted checkout-header versus source-owned basket boundary;
- generic source references and absence of FUND coupling;
- Prisma multi-schema and exact same-tenant relations;
- immutable seller/purchaser/Order-line evidence;
- bounded integer money and row arithmetic;
- seller tax configuration and applied tax snapshots;
- lifecycle/timestamp, uniqueness, deletion and backfill behavior;
- representative and fresh migration safety;
- absence of service/payment/provider scope.

## 2. Files Reviewed

```text
prisma/schema.prisma
prisma/migrations/20260714235500_commerce_a2_checkout_order_line_foundation/migration.sql
scripts/verify-commerce-a2-schema.ts
scripts/verify-commerce-a2-pre-migration.sql
scripts/verify-commerce-a2-database.sql
scripts/run-commerce-a2-database-tests.ts
```

## 3. Static And Repository Validation

Passed:

```text
npx prisma format
npx prisma validate
npx prisma generate
npx tsx scripts/verify-commerce-a2-schema.ts
npx eslint --no-ignore scripts/verify-commerce-a2-schema.ts scripts/run-commerce-a2-database-tests.ts
npm run type-check
npm run verify
git diff --check
```

Static verification confirmed exactly six Commerce enums and four Commerce models after
A2, all required relations/fields/checks, three A2 Commerce tables, and no executable FUND,
payment, refund, pro-forma, provider, webhook or Stripe migration scope.

## 4. Representative Existing-schema Migration

Safety proof compared parsed target identities and confirmed `TEST_DATABASE_URL` differed
from `DATABASE_URL` before connection. Logs exposed only a one-way hostname hash and
database name.

Starting state:

```text
135 applied migrations
0 failed migrations
```

Representative fixtures added before A2:

- one existing Organization;
- one active A1 Seller Profile;
- one existing FUND Client.

Result:

- only migration 136 applied;
- Seller Profile legal identity remained exact;
- FUND Client identity remained exact;
- both new seller rate fields remained null;
- A2 created no operational row;
- post-migration status was current.

## 5. Constraint And Tenant Evidence

Rollback-only suites passed on both representative and fresh databases.

Verified valid behavior:

- configured seller rates;
- submitted and open checkout states;
- one checkout-linked Order and one direct Order;
- multiple standard and zero-rated lines;
- JSON billing/delivery/configuration snapshots;
- intended defaults and arithmetic.

Verified rejection:

- invalid seller rates;
- malformed token/configuration hashes;
- lowercase currency/source codes and invalid exponent;
- invalid checkout status/timestamp/expiry shapes;
- blank Order/contact/seller evidence;
- invalid Order total/status arithmetic;
- duplicate token, tenant Order number and checkout transition;
- cross-tenant seller-profile/checkout/Order relations;
- invalid quantity/unit/net/gross/tax/category/configuration evidence;
- duplicate line sort and unknown/cross-tenant Order ownership;
- seller, linked checkout, Order and Organization deletion while evidence exists.

Every smoke transaction rolled back and left zero rows.

## 6. Fresh Replay And Regression

The disposable target was destructively reset only after the representative test. All 136
repository migrations applied successfully from empty.

The A1 database suite passed before and after the fresh replay, including profile defaults,
tenant uniqueness, country/currency/nonblank checks and restrictive deletion.

Final inventory:

```text
applied=136,failed=0
a2_rows=0
fixture_rows=0
```

The retained test database remains a clean disposable 136-migration target.

## 7. Drift Review Finding

The full Prisma database-to-schema projection reports older differences in LMSPro and FUND
objects, including historic enum/index/default/foreign-key naming. A2 did not create or
change those differences.

The scoped review confirmed no `commerce` schema, Commerce enum or Commerce table drift.
The runner therefore fails on any Commerce-owned projection difference while recording
unrelated pre-existing repository drift as outside A2 scope. No existing migration or
sibling schema was altered to conceal this finding.

## 8. Verdict

COMMERCE-A2 conforms to its accepted schema-only boundary and passes static, generated
client, migration, preservation, tenant, arithmetic, deletion, A1 regression and cleanup
review.

No shared development, staging or production deployment is claimed. FUND `1R-C6` is the
single next critical-path planning slice; A3, Store services and runtime checkout remain
separately controlled.
