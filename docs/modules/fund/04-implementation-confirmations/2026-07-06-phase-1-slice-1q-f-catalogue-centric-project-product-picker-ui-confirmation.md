# FUND Phase 1 Slice 1Q-F - Catalogue-Centric Project Product Picker UI Confirmation

Date: 2026-07-06

Status: Implemented locally - functional browser smoke passed; UX refinement deferred

## 1. Slice Summary

Implemented the first 1Q-F UI pass for C1 Project Product selection.

The Project Products tab now consumes the reviewed 1Q-E eligibility service:

```text
fund.productEligibility.listForProject
```

instead of the previous flat tenant Product list:

```text
fund.products.list
```

The picker now exposes eligible Products through source Catalogue context while preserving
`FundProjectProduct` as the selected Product record.

## 2. Behaviour Implemented

Project Product picker behaviour:

- eligible Products are loaded from `fund.productEligibility.listForProject`;
- eligible Products are grouped by source Catalogue;
- Event-linked and standalone source modes are labelled;
- warnings from the eligibility service are surfaced in the Project Products panel;
- Products already selected into the Project show as selected;
- selecting a Product from any source Catalogue still calls the existing Project Product mutation;
- existing add/reactivate behaviour continues to create or reactivate one `FundProjectProduct` row by Product identity;
- existing captured Project Product memberships remain visible below the source picker;
- reordering, deactivation and reactivation of existing memberships continue to use the established Project Product mutations.

Product Manager adjustment:

- Product edit/detail modal now includes a read-only `Catalogue Memberships` section;
- the membership section shows linked Catalogue code/name, Catalogue status, active/inactive membership state, availability scope, default standalone marker and membership sort order;
- full Product-side add/remove membership management remains out of scope.

## 3. Files Changed

Application files:

- `src/modules/fund/components/projects/ProjectProductsManager.tsx`;
- `src/modules/fund/components/products/ProductModal.tsx`;
- `src/modules/fund/services/products.service.ts`.

Documentation files:

- `docs/modules/fund/04-implementation-confirmations/2026-07-06-phase-1-slice-1q-f-catalogue-centric-project-product-picker-ui-confirmation.md`;
- `docs/modules/fund/03-slice-planning/2026-07-01-fund-phase-1-slice-1q-f-catalogue-centric-project-product-picker-ui-planning.md`;
- `docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`.

## 4. Explicit Non-Goals Confirmed

This slice did not implement:

- Prisma schema changes;
- migrations;
- Store;
- Orders;
- Commerce;
- Product duplication;
- Catalogue duplication;
- per-Catalogue pricing;
- per-Catalogue commission;
- Product option modelling;
- Product media galleries;
- production/artwork/dispatch workflows;
- notifications;
- SeasonPro integration.

No `db:push` was run.

No seed or reset commands were run.

## 5. Checks Run

```text
npm run type-check
```

Initial result:

```text
The managed sandbox blocked TypeScript from writing tsconfig.tsbuildinfo.
```

Resolution:

```text
Reran with approval so TypeScript could write its normal compiler cache.
```

Final result:

```text
Passed.
```

```text
npx eslint src/modules/fund/components/projects/ProjectProductsManager.tsx src/modules/fund/components/products/ProductModal.tsx src/modules/fund/services/products.service.ts
```

Result:

```text
Passed.
```

```text
npm run verify
```

Initial result:

```text
The managed sandbox blocked the tsx IPC pipe.
```

Resolution:

```text
Reran with approval.
```

Final result:

```text
Passed.
```

```text
git diff --check
```

Result:

```text
Passed.
```

## 6. Review / Smoke Result

Operator browser smoke was completed on localhost after the local implementation.

Functional browser smoke result:

```text
Passed, subject to later UX refinement.
```

Operator-confirmed observations:

- C1 Project detail Products tab loads the Catalogue-centric eligible Product picker;
- functional aspects of the 1Q-F pass are accepted in browser smoke;
- general UX refinement remains deferred rather than blocking this slice;
- no Store, Orders, Commerce, Product duplication, Catalogue duplication, pricing override or commission behaviour appeared.

New refinement captured from browser review:

```text
Event detail should provide future Event-side Catalogue/Product visibility.
```

This is now parked in the Phase 2 wishlist as:

```text
2R-EVENT-05 - Event Catalogue And Product Visibility Management Planning
```

## 7. Known Boundary

The 1Q-E eligibility router remains C1-admin safe first. If C2 Client/organiser Product
selection is exposed later, a separate C2-safe access policy must derive Project access
from authenticated Client/Project context rather than broad FUND admin authority.

## 8. Review Status

1Q-F-R1 is accepted as functionally passed in browser smoke, with UX refinement deferred.

Review document:

```text
docs/modules/fund/05-review-and-test/2026-07-06-phase-1-slice-1q-f-r1-catalogue-centric-project-product-picker-ui-review-and-smoke-test.md
```
