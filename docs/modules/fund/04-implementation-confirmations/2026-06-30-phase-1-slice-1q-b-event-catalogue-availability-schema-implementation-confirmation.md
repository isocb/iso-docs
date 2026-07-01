# FUND Phase 1 Slice 1Q-B - Event/Catalogue Availability Schema Implementation Confirmation

Date: 2026-06-30

Status: Implemented - schema only

## 1. Slice Summary

Implemented the first schema foundation for FUND Product/Catalogue availability and suitability.

This establishes the data layer needed for:

- Event-to-Catalogue availability;
- standalone/default Catalogue availability;
- Product suitability by Project type;
- Product suitability by Client organisation type;
- later C2 Project Product selection from eligible Products.

This slice does not implement Product picker UI, Store, Orders, Commerce, Product duplication, Product media galleries, option modelling or production workflows.

## 2. Accepted Eligibility Model

The implemented schema supports the 1Q-A three-gate eligibility model:

```text
Product source / availability
-> Project type suitability
-> Client organisation type suitability
-> C2 organiser subset selection
-> FundProjectProduct selected Products
```

C2 organisers should later be able to select only from Products that pass the approved eligibility gates. Product choices must not become unrestricted Product browsing.

## 3. Files Changed

App/schema:

- `prisma/schema.prisma`;
- `prisma/migrations/20260630183000_add_fund_event_catalogue_availability/migration.sql`.

Documentation:

- `isodocs/docs/modules/fund/03-slice-planning/2026-06-30-fund-phase-1-slice-1q-a-product-catalogue-suitability-schema-options-planning.md`;
- `isodocs/docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`;
- `isodocs/docs/modules/fund/00-roadmap-control/2026-06-30-fund-phase-2-refinement-wishlist-and-slice-control.md`;
- `isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1q-b-event-catalogue-availability-schema-implementation-confirmation.md`.

## 4. Migration

Migration created:

```text
20260630183000_add_fund_event_catalogue_availability
```

The migration adds:

- `fund.FundCatalogueAvailabilityScope`;
- `fund.fund_event_catalogues`;
- `fund.fund_product_project_type_suitabilities`;
- `fund.fund_product_organization_type_suitabilities`;
- `fund_catalogues.availability_scope`;
- `fund_catalogues.is_default_standalone`.

Existing records are not backfilled beyond safe column defaults.

No `db:push` was run.

No seed or reset commands were run.

## 5. Schema Added

New enum:

```text
FundCatalogueAvailabilityScope:
- EVENT_ONLY
- STANDALONE_ONLY
- EVENT_AND_STANDALONE
- INTERNAL_ONLY
```

Catalogue additions:

- `availabilityScope`;
- `isDefaultStandalone`.

New models:

- `FundEventCatalogue`;
- `FundProductProjectTypeSuitability`;
- `FundProductOrganizationTypeSuitability`.

## 6. Availability And Suitability Rules

`FundEventCatalogue` provides same-tenant Event-to-Catalogue availability.

It supports:

- multiple Catalogues per Event;
- active/inactive links;
- sort order;
- optional availability windows;
- metadata;
- created/updated audit ids.

`FundCatalogue.availabilityScope` and `FundCatalogue.isDefaultStandalone` provide the smallest safe standalone/default Catalogue availability foundation.

`FundProductProjectTypeSuitability` stores Product suitability for stable Project type / fundraising format codes.

`FundProductOrganizationTypeSuitability` stores Product suitability for stable Client organisation type codes.

The slice intentionally uses stable string codes rather than adding configurable option-set tables. Tenant-configurable labels/descriptions remain a later planning concern.

## 7. Relations And Tenant Scope

Added same-tenant relations through `organizationId` for:

- Event-to-Catalogue availability;
- Product-to-Project-type suitability;
- Product-to-organisation-type suitability.

Added relation fields on:

- `Organization`;
- `FundProduct`;
- `FundCatalogue`;
- `FundEvent`.

The new schema follows the existing FUND same-tenant pattern:

```text
fields: [organizationId, relatedId]
references: [organizationId, id]
```

## 8. Indexes And Constraints

Added constraints and indexes for:

- unique Event/Catalogue availability per tenant;
- Event availability filtering by Event, active state and sort order;
- Catalogue availability lookup;
- Product suitability lookup by Project type;
- Product suitability lookup by organisation type;
- Product suitability lookup by Product.

Short explicit database names are used for longer suitability indexes and foreign keys to avoid generated-name truncation/collision issues.

## 9. Explicit Non-Goals Confirmed

This slice did not implement:

- app services;
- routers;
- Zod schemas;
- UI;
- C1 Event Catalogue availability management;
- C2 Product picker;
- Project Product auto-selection;
- Store;
- Orders;
- Commerce;
- Sales/Reporting;
- Product duplication;
- Catalogue duplication;
- Product media galleries;
- Product option modelling;
- option-to-image mapping;
- production/artwork/dispatch workflows;
- notifications;
- SeasonPro integration.

## 10. Checks Run

```text
npx prisma validate
```

Result: passed.

```text
npm run db:generate
```

Result: passed.

```text
npm run type-check
```

Result: passed.

```text
npm run verify
```

Initial result: sandbox `tsx` IPC pipe error.

Resolution: reran outside the sandbox.

Final result: passed.

```text
git diff --check
```

Result: passed.

```text
docs git diff --check
```

Result: passed.

## 11. Risks And Follow-Ups

- 1Q-C services must not expose inactive, archived or cross-tenant Catalogues/Products as eligible.
- Product suitability codes must match the accepted Project type and Client organisation type codes used by the Project and Client flows.
- If no suitability rows exist for a Product, 1Q-C must decide whether that means broadly eligible or not eligible until explicitly configured.
- Product picker implementation must use eligible Products as the source list and `FundProjectProduct` as the selected subset.
- Store generation must use `FundProjectProduct`, not raw Event/Catalogue availability.

## 12. Recommended Next Slice

```text
1Q-C - C1 Event Catalogue Availability API/Services
```

Goal:

```text
Implement tenant-scoped C1 API/services for configuring Event-to-Catalogue availability, standalone/default Catalogue availability and Product suitability rules without implementing UI, Store, Orders, Commerce or Product picker behaviour.
```
