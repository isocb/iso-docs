# FUND Phase 1 Slice 1Q-C - C1 Event Catalogue Availability API/Services Confirmation

Date: 2026-06-30

Status: Implemented

## 1. Slice Summary

Implemented tenant-scoped C1 API/services for configuring Event/Catalogue availability, standalone/default Catalogue availability and Product suitability rules.

This builds on the 1Q-B schema foundation and does not implement UI, Store, Orders, Commerce, Product picker behaviour, Product duplication, Product media galleries, option modelling or production workflows.

## 2. API Surface Added

Added C1 procedures under:

```text
fund.availability.*
```

Procedures:

- `listEventCatalogues`;
- `setEventCatalogues`;
- `updateCatalogueAvailability`;
- `getProductSuitability`;
- `setProductProjectTypes`;
- `setProductOrganizationTypes`.

All procedures:

- use `withFeature('fund')`;
- require authenticated actor context;
- require `assertFundAdmin`;
- derive `organizationId` from actor/effective tenant context;
- never accept `organizationId` from client input.

## 3. Services Added

Added:

```text
src/modules/fund/services/availability.service.ts
```

The service provides:

- Event-to-Catalogue availability listing and replacement;
- standalone/default Catalogue availability updates;
- Product suitability lookup;
- Product Project type suitability replacement;
- Product organisation type suitability replacement.

Removed Event/Catalogue/Product suitability entries are soft-deactivated rather than deleted where applicable, preserving operational history for later review/audit.

## 4. Validation Added

Added:

```text
src/modules/fund/lib/validation/availability.ts
```

Validation includes:

- Event id input;
- Event Catalogue availability entries;
- optional availability dates;
- `availableUntil > availableFrom` check;
- Catalogue availability scope;
- Product id input;
- Project type code validation using the accepted C2 dashboard Project type codes;
- organisation type code validation using stable uppercase string codes.

The slice intentionally does not add tenant-configurable option-set tables.

## 5. Event Catalogue Availability Rules

`setEventCatalogues`:

- validates the Event belongs to the current tenant;
- rejects archived Events;
- validates all Catalogues belong to the current tenant;
- rejects archived Catalogues;
- rejects duplicate Catalogue entries in the submitted set;
- creates new Event/Catalogue availability links;
- updates existing links;
- soft-deactivates previously active links omitted from the replacement set;
- writes an audit event.

This configures eligibility only. It does not create Project Product memberships.

## 6. Standalone Catalogue Availability Rules

`updateCatalogueAvailability`:

- validates the Catalogue belongs to the current tenant;
- rejects archived Catalogues;
- updates `availabilityScope`;
- updates `isDefaultStandalone`;
- writes an audit event.

This establishes standalone/default availability configuration only. It does not expose Products to C2 users by itself.

## 7. Product Suitability Rules

`getProductSuitability` returns:

- Project type suitability rows;
- organisation type suitability rows.

`setProductProjectTypes`:

- validates the Product belongs to the current tenant;
- rejects archived Products;
- uses accepted Project type codes;
- activates submitted codes;
- soft-deactivates omitted active codes;
- writes an audit event.

`setProductOrganizationTypes`:

- validates the Product belongs to the current tenant;
- rejects archived Products;
- uses stable organisation type codes;
- activates submitted codes;
- soft-deactivates omitted active codes;
- writes an audit event.

## 8. Files Changed

Application files:

- `prisma/schema.prisma`;
- `prisma/migrations/20260630183000_add_fund_event_catalogue_availability/migration.sql`;
- `src/modules/fund/lib/validation/availability.ts`;
- `src/modules/fund/services/availability.service.ts`;
- `src/modules/fund/routers/availability.router.ts`;
- `src/modules/fund/routers/index.ts`.

Documentation files:

- `docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`;
- `docs/modules/fund/00-roadmap-control/2026-06-30-fund-phase-2-refinement-wishlist-and-slice-control.md`;
- `docs/modules/fund/03-slice-planning/2026-06-30-fund-phase-1-slice-1q-a-product-catalogue-suitability-schema-options-planning.md`;
- `docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1q-b-event-catalogue-availability-schema-implementation-confirmation.md`;
- `docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1q-c-c1-event-catalogue-availability-api-services-confirmation.md`.

## 9. Explicit Non-Goals Confirmed

This slice did not implement:

- C1 availability UI;
- C2 Product picker;
- Project Product auto-selection;
- Project Product eligibility API for C2;
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

No `db:push` was run.

No seed or reset commands were run.

## 10. Checks Run

```text
npx prisma validate
```

Result: passed.

```text
npm run db:generate
```

Result: previously passed after 1Q-B schema implementation.

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

- 1Q-D must provide a clear C1 UI for Event Catalogue availability and Product suitability without exposing internal jargon to C2 users.
- 1Q-E planning now locks Product eligibility query behaviour: Products with no active suitability rows remain unrestricted for that suitability dimension after source availability passes.
- C2/Product picker work must use eligible Products as the source list, group by source Catalogue for context, deduplicate by Product identity and keep `FundProjectProduct` as the selected subset.
- Store generation must use `FundProjectProduct`, not raw Event/Catalogue availability.

## 12. Recommended Next Slice

```text
1Q-D - C1 Event Catalogue Availability UI
```

Goal:

```text
Implement the C1 Product Manager UI for configuring Event-to-Catalogue availability, standalone/default Catalogue availability and Product suitability rules, without implementing C2 Product picker, Store, Orders or Commerce behaviour.
```
