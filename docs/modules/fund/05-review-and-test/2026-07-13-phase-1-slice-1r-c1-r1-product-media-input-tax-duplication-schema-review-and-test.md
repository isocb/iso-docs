# FUND Phase 1 Slice 1R-C1-R1 - Product Media/Input/Tax/Duplication Schema Review And Test

Date: 2026-07-13

Status: Passed / disposable PostgreSQL migration and constraint smoke complete

Implementation confirmation:

`docs/modules/fund/04-implementation-confirmations/2026-07-13-phase-1-slice-1r-c1-product-media-input-tax-duplication-schema-implementation-confirmation.md`

## 1. Review Scope

Reviewed the bounded 1R-C1 implementation for:

- accepted Product and Project Product fields/defaults;
- FUND-owned enum separation from Commerce;
- Prisma multi-schema validity;
- same-tenant relation keys and owner constraints;
- partial uniqueness and deletion behavior;
- legacy commercial-value preservation;
- fresh and representative existing-data migration;
- absence of Store, Commerce Order, payment, upload and service/application behavior.

## 2. Static And Repository Checks

Passed:

```text
npx prisma format
npx prisma validate
npx prisma generate
npx tsx scripts/verify-fund-1r-c1-schema.ts
npx tsx scripts/verify-commerce-a1-schema.ts
npx eslint --no-ignore scripts/verify-fund-1r-c1-schema.ts
npm run type-check
npm run verify
git diff --check
```

The 1R-C1 verifier confirmed exactly six accepted enums, four accepted models, required
tenant keys/checks/partial indexes and no Store, Commerce Order, payment, Stripe or Commerce
schema mutation.

## 3. Existing-Data Migration Test

Starting state:

- retained disposable Neon test database;
- 128 successful migrations through Commerce A1;
- 1R-C1 was the only pending migration;
- representative legacy Organizations, Products, Project, Project Product and MediaFiles
  inserted before migration.

The representative data deliberately included:

- zero-rate and non-standard-rate Products;
- GBP and EUR Product currencies;
- a null Product net price;
- a Project Product whose commercial snapshots differed from its live Product.

Result:

- only `20260713150000_fund_1r_c1_product_configuration_foundation` applied;
- Product and Project Product commercial values remained exact;
- all Products/Project Products received only the accepted safe defaults;
- four new child tables began empty;
- all representative rows were removed after testing.

## 4. Constraint And Relation Smoke

Passed database evidence for:

- positive Product configuration revision;
- paired and same-tenant Product copy provenance;
- source deletion clearing both copy-source fields while preserving copied tenant identity;
- Product/media uniqueness and non-negative ordering;
- one active Product primary image;
- restrictive MediaFile deletion;
- exactly one Product or Project Product input owner;
- cross-tenant Product and Project Product owner rejection;
- owner-specific input-code uniqueness;
- positive input revision;
- signed 32-bit option modifier minimum/maximum and overflow rejection;
- definition/choice and choice/media uniqueness;
- one primary image per choice;
- definition-to-choice and Product-to-media cascades;
- zero test-row residue.

The known MediaFile tenant limitation was reproduced conceptually by schema review and is
not misreported as database-enforced isolation. No application write path exists in this
slice.

## 5. Fresh Migration Test

The verified disposable database was reset and all 129 migrations were applied from empty
through:

```text
20260713120000_commerce_a1_schema_seller_profile_enums
20260713150000_fund_1r_c1_product_configuration_foundation
```

Result: passed. Final Prisma migration status reported the database up to date.

The first long reset process was interrupted by the command runner while a migration was
active, leaving a failed disposable run and a pooled advisory lock. The partial test state
was discarded, only the stale test-database lock holder was terminated, and the complete
reset was rerun through the direct test endpoint. The successful rerun applied all 129
migrations with zero failed migrations. This was test-harness handling, not a migration
defect.

## 6. Drift Review

Prisma database-to-schema comparison reported older unrelated drift in LMSPro enum values,
legacy `updated_at` defaults and historic index/constraint names. It reported no 1R-C1
table, column, enum, key or relation mismatch. This slice does not alter unrelated drift.

## 7. Regression And Final Inventory

Commerce A1 static verification and its rollback-only PostgreSQL constraint smoke both
passed after the fresh 1R-C1 rebuild.

Final inventory:

```text
applied migrations: 129
failed migrations: 0
1R-C1 tables: 4
1R-C1 enums: 6
residual FUND/Commerce test Organizations: 0
```

## 8. Boundary Verdict

Passed. `1R-C1` implements only the accepted FUND Product configuration schema foundation.

Not added:

- Project Store or Store Product;
- checkout, Commerce Orders or payments;
- uploads or MediaFile mutation services;
- Product duplication execution;
- APIs, routers, pages or components;
- production, commission or delivery schema;
- `1R-C2` or `COMMERCE-A2` work.

No shared development, staging or production deployment is claimed. The retained test
database remains disposable test infrastructure at the complete 129-migration state.
