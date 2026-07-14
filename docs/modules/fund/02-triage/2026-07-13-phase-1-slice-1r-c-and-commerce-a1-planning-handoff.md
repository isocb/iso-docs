# FUND 1R-C And Commerce A1 Planning Handoff

Date: 2026-07-13

Status: Documentation/planning completed; no schema or application implementation

## 1. Summary

Reviewed and accepted:

- FUND Phase 1 Slice `1R-C` Store/Input Schema Foundation Planning;
- the separate IsoStack Commerce Core Schema Foundation Planning.

Created two independent bounded implementation plans for later review:

1. FUND `1R-C1` Product Media/Input/Tax/Duplication Schema Implementation Planning.
2. Commerce Core `COMMERCE-A1` Schema/Seller Profile/Enums Implementation Planning.

At the time of this handoff neither new plan was accepted for implementation. Each was
created as `Implementation planning only / awaiting acceptance / no implementation`.

## 2. Review Gates Incorporated

The accepted parent documents now record that:

- Project Product tax treatment and price-entry basis must be snapshotted with its existing
  price, VAT and currency evidence;
- checkout basket persistence is a later Commerce decision, not FUND schema work;
- Commerce Order lines inherit the Order source-module boundary;
- refund and pro-forma/manual-payment lifecycle details wait for `COMMERCE-A3`;
- typed FUND Commerce extensions wait for the Commerce schema and the Prisma cross-schema
  relation decision.

## 3. `1R-C1` Planning Created

Path:

```text
docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c1-product-media-input-tax-duplication-schema-implementation-planning.md
```

The plan is limited to:

- Product tax treatment, price-entry basis, copy provenance and configuration revision;
- matching Project Product tax and price-basis snapshots;
- Product media associations;
- typed Product/Project Product input definitions and choices;
- choice-linked Product imagery;
- additive migration, safe `UNCLASSIFIED` tax backfill and explicit data-review checks.

It excludes Store, checkout, Orders, payments, upload services and Product-copy execution.

## 4. `COMMERCE-A1` Planning Created

Path:

```text
docs/core/commerce/03-slice-planning/2026-07-13-isostack-commerce-core-slice-commerce-a1-schema-seller-profile-enums-implementation-planning.md
```

The plan is limited to:

- adding the `commerce` namespace to Prisma/PostgreSQL;
- `CommerceSellerProfile` linked to the public `Organization` tenant;
- stable seller-profile, price-basis, tax-treatment and rounding enums;
- Prisma multi-schema, migration and tenant-relation validation;
- an empty-table/no-guessed-legal-data backfill policy.

It excludes checkout, Orders, payments, refunds, pro-forma records, providers, Stripe and
all FUND relations.

## 5. Explicit Non-Implementation Declaration

This documentation pass did not change:

- `prisma/schema.prisma`;
- the Prisma datasource schema list;
- any migration;
- seed data;
- generated Prisma client output;
- service, router, API, UI or provider code;
- any database record or schema.

No schema/application validation is claimed because there was no implementation. Document
validation is limited to formatting, links, boundary checks and working-tree inspection.

## 6. Next Control Point At Time Of Handoff

Review and accept each implementation plan independently before changing schema:

```text
1R-C1 -> FUND Product configuration schema migration only
COMMERCE-A1 -> commerce namespace/seller profile/enums migration only
```

Acceptance of one does not authorise implementation of the other.
