# FUND Phase 1 Slice 1R-B - Store And Commerce Planning Handoff

Date: 2026-07-13

Status: Documentation/planning completed; no schema or application implementation

## 1. Summary

Reviewed and accepted FUND Phase 1 Slice `1R-B` Commerce Core And FUND Store Schema Options
Planning.

Created the two accepted follow-on planning documents:

1. FUND `1R-C` Store/Input Schema Foundation Planning for FUND-owned models.
2. Separate IsoStack Commerce Core Schema Foundation Planning for reusable generic
   checkout/Order/payment models.

This handoff records planning-document creation only. It is stored in `02-triage` so the
architecture decision remains traceable without being mistaken for confirmation that Prisma
schema, migrations, services, UI, Commerce Orders or payments were implemented.

## 2. Accepted Review Outcome

The `1R-B` review accepts:

- one IsoStack PostgreSQL database with named module/core schemas;
- a proposed dedicated `commerce` schema for reusable Commerce Core;
- `fund` ownership of Project Store, Store Product and production context;
- generic Commerce source references that treat FUND identifiers as opaque;
- typed FUND extensions keyed to Commerce Order and Order-line identifiers;
- no FUND-owned replacement for generic Commerce Orders or payments;
- separate Store, checkout, Order, payment, production, fulfilment and commission states;
- immutable Store Product configuration and Order snapshots;
- Product-owned commercial/configuration data with no first-pass per-Catalogue overrides;
- Product duplication for distinct seasonal/contextual offerings;
- versioned production assets rather than mutable `MediaFile` references alone;
- authoritative Event commission policy for linked Projects;
- C1-managed flat/ladder commission policy for standalone Projects;
- policy assignment at Store publication and lock no later than the first eligible paid
  sale.

## 3. Planning Documents Created

FUND schema-foundation planning:

```text
docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c-fund-store-input-schema-foundation-planning.md
```

Platform Commerce Core planning:

```text
docs/core/commerce/02-triage/2026-07-13-isostack-commerce-core-schema-foundation-planning.md
```

Accepted source planning:

```text
docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-b-commerce-core-and-fund-store-schema-options-planning.md
```

## 4. `1R-C` Planning Scope Created

The FUND plan splits later schema implementation into bounded sub-slices:

```text
1R-C1 - Product Media, Inputs, Tax Category And Duplication Foundation
1R-C2 - Client Branding, Project Delivery And Event Media Foundation
1R-C3 - Project Store And Store Product Foundation
1R-C4 - Production Asset Version Foundation
1R-C5 - Commission Policy And Assignment Foundation
1R-C6 - FUND Commerce Context Foundation (after Commerce Core exists)
```

The plan explicitly excludes generic Commerce Orders, payments and Stripe from FUND schema
implementation.

## 5. Commerce Core Planning Scope Created

The platform plan proposes a dedicated `commerce` schema and bounded future implementation
sequence for:

- seller/tax profile;
- checkout session;
- Order and Order line;
- payment;
- refund;
- pro-forma invoice;
- audit/idempotency;
- generic consumer references;
- later Stripe provider adapter;
- later FUND consumer integration.

The plan deliberately defers generic Product/price catalogue, inventory, subscriptions,
production, dispatch and commission.

## 6. Files Changed By This Documentation Pass

Created:

- `docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c-fund-store-input-schema-foundation-planning.md`;
- `docs/core/commerce/02-triage/2026-07-13-isostack-commerce-core-schema-foundation-planning.md`;
- `docs/modules/fund/02-triage/2026-07-13-phase-1-slice-1r-b-store-and-commerce-planning-handoff.md`.

Updated during the full `1R-A`/`1R-B` planning pass:

- `docs/modules/fund/03-slice-planning/2026-07-08-fund-phase-1-slice-1r-a-store-orders-commerce-core-planning.md`;
- `docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-b-commerce-core-and-fund-store-schema-options-planning.md`;
- `docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`;
- `docs/modules/fund/00-roadmap-control/2026-06-30-fund-phase-2-refinement-wishlist-and-slice-control.md`.

## 7. Explicit Non-Implementation Declaration

This pass did not change:

- `prisma/schema.prisma`;
- Prisma datasource schema list;
- migrations;
- seed data;
- routers, services or validation schemas;
- C1, C2 or public UI;
- Product duplication behaviour;
- Store or Store Product records;
- Commerce checkout, Orders or Order lines;
- Stripe configuration, SDK or webhooks;
- pro-forma generation;
- file upload/scanning/storage;
- production, dispatch or commission calculation.

No database push, migration, seed or reset command was run.

## 8. Documentation Checks

Completed:

```text
git diff --check
Markdown trailing-whitespace check
Markdown code-fence balance check
```

No application tests were required because this was documentation/planning work only.

## 9. Follow-On At Time Of Handoff

The next controlled work recorded when this handoff was created was:

1. review and accept `1R-C`;
2. review and accept the separate Commerce Core schema-foundation plan;
3. create bounded schema implementation planning for `1R-C1` and `COMMERCE-A1`;
4. keep provider/Stripe implementation out of the first Commerce schema slice;
5. do not create `FundOrder` or `FundPayment` as substitutes for Commerce Core.
