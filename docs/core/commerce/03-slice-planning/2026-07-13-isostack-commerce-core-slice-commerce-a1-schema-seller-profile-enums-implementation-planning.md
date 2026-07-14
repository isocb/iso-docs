# IsoStack Commerce Core Slice COMMERCE-A1 - Schema/Seller Profile/Enums Implementation Planning

Date: 2026-07-13

Status: Accepted, implemented and reviewed as passed / shared deployment not performed

Roadmap control:

`docs/core/commerce/00-roadmap-control/2026-07-13-commerce-core-roadmap-and-slice-control.md`

Parent plan:

`docs/core/commerce/02-triage/2026-07-13-isostack-commerce-core-schema-foundation-planning.md`

## 1. Goal

Define the smallest safe platform migration that establishes:

- the `commerce` PostgreSQL/Prisma schema namespace;
- one tenant-scoped `CommerceSellerProfile` per seller Organization;
- only the stable seller, price-basis, tax-treatment and rounding enums required by that
  foundation;
- Prisma multi-schema and public-Organization relation validation.

This plan does not authorise schema implementation. It must be reviewed and accepted first.

## 2. Independent Platform Boundary

`COMMERCE-A1` is an IsoStack platform slice, not a FUND migration.

It must not add:

- checkout sessions or basket lines;
- Orders or Order lines;
- payment, refund or pro-forma records;
- provider or Stripe configuration;
- webhook or idempotency event tables;
- generic Product, Catalogue, inventory or subscription records;
- FUND Store, Project, artwork, delivery, commission or production fields;
- cross-schema relations from Commerce to FUND.

The independent FUND `1R-C1` plan may proceed through review in parallel. Neither migration
depends on the other.

## 3. Existing Platform Constraints

- Prisma already uses multi-schema preview support.
- The datasource currently lists `public`, `bedrock`, `lmspro`, `pulse` and `fund`.
- `Organization` remains in the `public` schema and is the tenant/seller boundary.
- Commerce records will use the existing Organization ID; a second tenant identity must not
  be invented.
- No `commerce` schema or Commerce model exists in the accepted baseline.

## 4. Accepted A1 Schema Direction

### 4.1 Datasource Namespace

Add `commerce` to the Prisma datasource schema list and create the corresponding PostgreSQL
schema through one reviewed migration.

Conceptual result:

```text
schemas = ["public", "bedrock", "lmspro", "pulse", "fund", "commerce"]
```

The schema is a namespace in the existing database, not a separate database.

### 4.2 Stable A1 Enums

Add only:

```text
CommerceSellerProfileStatus
- DRAFT
- ACTIVE
- INACTIVE

CommercePriceEntryBasis
- TAX_EXCLUSIVE
- TAX_INCLUSIVE

CommerceTaxTreatment
- STANDARD
- REDUCED
- ZERO_RATED
- EXEMPT

CommerceRoundingMethod
- HALF_UP
```

`HALF_UP` is the accepted first conventional minor-unit rounding method. Additional methods
require a later compatibility use case and tests; do not add speculative enum values.

Do not add checkout, Order, payment, refund or pro-forma enums in A1. Those belong to the
slice that implements their corresponding records, after the open lifecycle questions are
resolved.

### 4.3 `CommerceSellerProfile`

Planned fields:

```text
id
organizationId
status
legalName
tradingName?
addressLine1
addressLine2?
addressLine3?
locality
region?
postalCode
countryCode
taxRegistrationNumber?
defaultCurrency
priceEntryBasis
roundingMethod
createdById?
updatedById?
createdAt
updatedAt
```

Contract:

- one profile per Organization through a unique `organizationId`;
- Organization is the seller tenant and must match every later Commerce record;
- Organization deletion is restricted while a seller profile exists;
- status defaults to `DRAFT`;
- `DRAFT` may be incomplete for checkout but the schema fields listed as required must be
  supplied when the profile is deliberately created;
- activation readiness is a later service invariant;
- `countryCode` uses uppercase ISO 3166-1 alpha-2 shape;
- `defaultCurrency` uses uppercase ISO 4217 three-character shape;
- price basis defaults to `TAX_EXCLUSIVE` for compatibility with current FUND prices;
- rounding defaults to `HALF_UP`;
- tax registration is stored as restricted seller data and is not assumed to be a VAT
  number in every jurisdiction;
- historic Orders later snapshot seller identity and never render from the live profile.

Use explicit short foreign-key, unique, check and index names.

### 4.4 Tax Boundary In A1

A1 defines shared tax-treatment vocabulary but does not create a tax rules engine.

It does not decide:

- jurisdictional rate lookup;
- effective-dated tax-category tables;
- tax point;
- product tax selection;
- line arithmetic or reconciliation.

Those decisions remain prerequisites for `COMMERCE-A2`. FUND continues to own Product tax
selection; Commerce will later snapshot the applied treatment and rate.

## 5. Prisma Relation Validation Spike

A1 must validate the first required cross-schema platform relation:

```text
commerce.CommerceSellerProfile.organizationId
-> public.Organization.id
```

The implementation review must confirm:

- Prisma accepts the relation with both schemas in the datasource;
- the generated client exposes the expected relation without changing module ownership;
- the reverse `Organization` field is named generically for Commerce, not for FUND;
- migration SQL creates the intended cross-schema foreign key;
- Organization deletion is restricted;
- no relation or import to a FUND model appears.

This spike informs—but does not decide—the later consumer-to-Commerce relation direction for
typed FUND Order extensions.

## 6. Migration Plan

After plan acceptance:

1. Add `commerce` to the Prisma datasource schema list.
2. Add the accepted A1 enums with `@@schema("commerce")`.
3. Add `CommerceSellerProfile` with `@@schema("commerce")` and an explicit table name.
4. Add the generic reverse relation field to `Organization` if Prisma requires it.
5. Generate one named migration that creates the namespace, enums, table, checks, indexes
   and public-schema foreign key.
6. Review generated SQL before applying it to a disposable database.
7. Validate fresh-database and existing-multi-schema-database application.
8. Record schema inventory before and after migration.

Do not combine A1 with `COMMERCE-A2` or any FUND migration.

## 7. Backfill And Seed Policy

No seller profile is auto-created.

Reasons:

- current Organization display names are not guaranteed legal seller names;
- legal/trading addresses must not be guessed from unrelated records;
- tax registration and country cannot be inferred safely;
- automatic active profiles could make an unreviewed seller appear checkout-ready.

Expected post-migration state:

- all existing Organization rows remain unchanged;
- `commerce.commerce_seller_profiles` exists and is empty;
- profile creation is a later controlled C1 service/UI concern;
- no Organization is considered Commerce-ready solely because the schema exists.

No Commerce seed data is added in A1 unless a later accepted test-fixture-only change is
clearly isolated from production seed behaviour.

## 8. Check And Index Plan

Database enforcement:

- primary key on profile ID;
- unique Organization/profile ownership;
- index by Organization and status where not already covered by uniqueness;
- uppercase/two-character country-code check;
- uppercase/three-character currency check;
- trimmed non-empty legal name and required address components;
- restrictive Organization foreign key;
- enum-backed status, price basis and rounding method.

Service enforcement reserved for later:

- authorization to create/edit/activate a profile;
- jurisdiction-specific postal/address validation;
- tax registration format;
- activation completeness;
- audit event emission;
- seller-profile versioning or effective dates.

## 9. Expected Implementation Files

Only after acceptance:

- `prisma/schema.prisma`;
- one new
  `prisma/migrations/<timestamp>_commerce_a1_schema_seller_profile_enums/` migration;
- narrowly scoped multi-schema migration/constraint verification following repository
  convention;
- platform implementation-confirmation and review/test documentation in an appropriate
  core Commerce documentation location.

No FUND schema, API route, UI, provider adapter or Stripe file belongs to A1.

## 10. Validation Matrix

Required evidence:

- `prisma format` produces only intended formatting;
- `prisma validate` passes with `commerce` in the datasource;
- Prisma client generation passes;
- generated migration SQL is manually reviewed;
- migration applies to a fresh disposable database;
- migration applies to a representative existing database containing all current schemas;
- existing schema/table/row counts are unchanged;
- the `commerce` namespace and A1 objects alone are added;
- seller profile creation succeeds for a valid Organization;
- a second profile for the same Organization is rejected;
- an unknown Organization ID is rejected;
- deletion of an Organization with a profile is restricted;
- invalid country/currency shapes and empty legal names are rejected;
- valid `DRAFT` and `ACTIVE` records persist with expected defaults;
- generated client relation access is validated;
- schema inspection confirms no checkout, Order, payment, provider or FUND relation;
- `git diff --check`, type-check and repository verification commands pass.

All database-backed validation uses disposable/test databases. Do not run migration tests
against shared development, staging or production databases.

## 11. Failure And Rollback Strategy

- Review SQL before the first persistent application.
- During development, correct the unapplied migration rather than stacking repair noise.
- Recreate only disposable databases when migration trials fail.
- Because A1 adds an empty namespace/table, an operator-approved rollback may drop A1
  objects only after proving the seller-profile table is empty and no later Commerce
  migration depends on them.
- Once data or later migrations exist, prefer a reviewed forward migration or database
  restore plan; do not casually drop the Commerce schema.
- Record migration identifier, pre/post inventory and validation output in confirmation.

## 12. Explicit Deferrals

### `COMMERCE-A2`

- decide persisted Commerce basket lines versus consumer-owned basket state;
- add checkout, Order and Order-line models;
- enforce Order-line inheritance of the Order `sourceModuleCode`;
- choose `Int` versus `BigInt` money representation;
- complete tax-rule and arithmetic design.

### `COMMERCE-A3`

- define refund states;
- define pro-forma/manual-payment evidence linkage;
- add payments, refunds and pro-forma records.

### Later

- provider-neutral services;
- Stripe/webhooks;
- typed FUND Commerce extensions;
- production/fulfilment/commission integration.

## 13. Acceptance Criteria

Accept A1 only when:

- `commerce` is confirmed as a namespace in the existing database;
- Organization remains the single seller tenant identity;
- seller profile fields and safe defaults are accepted;
- no legal/tax/address data is guessed or backfilled;
- only stable A1 enums are introduced;
- the public-Organization cross-schema Prisma spike is explicit;
- fresh and existing-database migration checks are required;
- rollback is bounded to empty/unconsumed A1 objects;
- checkout, Orders, payments, providers and FUND relations are excluded;
- no schema or application implementation has occurred before acceptance.

## 14. Recommended Next Prompt

```text
Review and accept IsoStack Commerce Core Slice COMMERCE-A1 Schema/Seller Profile/Enums
Implementation Planning. Implement only the accepted commerce namespace, seller profile and
A1 enums, then create separate implementation-confirmation and review/test records. Do not
add checkout, Orders, payments, providers, Stripe or FUND relations.
```

## 15. Acceptance Record

Accepted on 2026-07-13 for the bounded A1 implementation described in this document.

Acceptance confirms:

- only the `commerce` namespace, `CommerceSellerProfile` and four A1 enum types may be
  implemented;
- seller profiles are not backfilled or seeded from existing Organization data;
- database checks enforce stable country/currency shape and nonblank required seller text;
- the only cross-schema relation is Commerce Seller Profile to public Organization;
- checkout, Orders, payments, refunds, pro-forma, providers, Stripe and FUND relations remain
  excluded;
- implementation confirmation and review/test evidence must be recorded separately.

Implementation records:

```text
docs/core/commerce/04-implementation-confirmations/2026-07-13-commerce-a1-schema-seller-profile-enums-implementation-confirmation.md
docs/core/commerce/05-review-and-test/2026-07-13-commerce-a1-schema-seller-profile-enums-review-and-test.md
```

The implementation passes static/generated-client review, fresh and existing-schema
disposable PostgreSQL migration, and rollback-only constraint/default smoke. Shared
development, staging and live deployment are not claimed.
