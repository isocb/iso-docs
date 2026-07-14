# Commerce Core COMMERCE-A1 Schema/Seller Profile/Enums Implementation Confirmation

Date: 2026-07-13

Status: Implemented and validated on disposable PostgreSQL / shared deployment not performed

Planning source:

`docs/core/commerce/03-slice-planning/2026-07-13-isostack-commerce-core-slice-commerce-a1-schema-seller-profile-enums-implementation-planning.md`

## 1. Outcome

Implemented the accepted bounded `COMMERCE-A1` schema foundation in the IsoStack application
repository.

The implementation adds only:

- the `commerce` Prisma/PostgreSQL namespace;
- four accepted A1 enum types;
- `CommerceSellerProfile`;
- one generic reverse relation on public `Organization`;
- one additive migration;
- one reproducible A1 schema-contract verification script;
- one rollback-only database constraint/default smoke script.

The migration was applied only to the explicitly disposable Neon test database. The
configured development, staging and live databases were not accessed or modified.

## 2. Application Files Changed

Updated:

```text
prisma/schema.prisma
```

Created:

```text
prisma/migrations/20260713120000_commerce_a1_schema_seller_profile_enums/migration.sql
scripts/verify-commerce-a1-schema.ts
scripts/verify-commerce-a1-database.sql
```

No service, router, API, page, component, seed, provider or generated-client file is part of
the tracked implementation diff.

## 3. Prisma Schema Implementation

Datasource schema list now includes:

```text
commerce
```

Added enums:

```text
CommerceSellerProfileStatus
CommercePriceEntryBasis
CommerceTaxTreatment
CommerceRoundingMethod
```

Added model:

```text
CommerceSellerProfile
```

The model contains:

- one required unique `organizationId`;
- legal and optional trading name;
- structured seller address;
- country and default-currency codes;
- optional tax-registration reference;
- default price-entry basis and rounding method;
- profile status and audit timestamps/actor IDs;
- a cross-schema relation to `public.Organization` with restrictive deletion.

The reverse Organization relation is generic:

```text
commerceSellerProfile
```

It has no FUND name or dependency.

## 4. Migration Implementation

The additive migration creates:

- schema `commerce`;
- four enum types;
- table `commerce.commerce_seller_profiles`;
- unique Organization ownership index;
- Organization/status lookup index;
- public Organization foreign key with `ON DELETE RESTRICT`;
- uppercase ISO-shaped country/currency checks;
- nonblank checks for required seller identity/address text.

The migration inserts or updates no data. Existing Organizations are not converted into
seller profiles and no profile becomes active automatically.

## 5. Tenant Boundary

Tenant/seller identity remains `public.Organization.id`.

Enforcement implemented in A1:

- seller profile `organizationId` is required;
- `organizationId` is unique, allowing at most one seller profile per Organization;
- the database foreign key rejects unknown Organization IDs;
- Organization deletion is restricted while its seller profile exists;
- the generated Prisma client exposes the Organization relation;
- no second tenant identifier or FUND relation was introduced.

Authorization and C1 profile-management services remain later work.

## 6. Explicit Scope Confirmation

Not implemented:

- checkout sessions or basket lines;
- Orders or Order lines;
- payment, refund or pro-forma records;
- idempotency/audit event records;
- providers, Stripe or webhooks;
- Product/Catalogue/inventory/subscription models;
- FUND Project, Store, artwork, delivery, production or commission relations;
- seller-profile service/API/UI;
- seller-profile seed or backfill.

## 7. Validation Summary

Passed:

- Prisma formatting;
- Prisma schema validation;
- Prisma client generation;
- generated DMMF enum/model/relation inspection;
- A1 migration-contract verification;
- tenant unique/FK/restrictive-delete contract inspection;
- forbidden-scope inspection;
- TypeScript type-check;
- targeted verification-script ESLint with ignored-file override;
- repository critical-file verification;
- complete 128-migration fresh-database deployment on PostgreSQL 18.4;
- rebuild to the 127-migration pre-A1 baseline;
- isolated existing-schema application of only `COMMERCE-A1`;
- valid `DRAFT` and `ACTIVE` Seller Profile insertion;
- default status/currency/price-basis/rounding verification;
- duplicate and unknown Organization rejection;
- Organization deletion restriction;
- country, currency and required-text check rejection;
- transaction rollback and zero smoke-row residue;
- final Prisma migration status (`128`, up to date);
- `git diff --check`.

Database validation used only `TEST_DATABASE_URL`. URL identity checks confirmed it was
distinct from `DATABASE_URL` before any connection. The test database began empty with only
the `public` schema and zero tables.

The dedicated Neon test database is intentionally retained for future bounded migration and
constraint testing. It remains disposable test infrastructure, not a shared development,
staging or production target. Its URL remains local and uncommitted, and future use must
repeat the database-identity safety check before any destructive operation.

## 8. Handoff

`COMMERCE-A1` implementation and its disposable-database review are complete. Promotion to
development, staging or live remains a separate operator-controlled deployment action
through the normal reviewed migration path. No later Commerce or FUND slice is authorised by
this confirmation.
