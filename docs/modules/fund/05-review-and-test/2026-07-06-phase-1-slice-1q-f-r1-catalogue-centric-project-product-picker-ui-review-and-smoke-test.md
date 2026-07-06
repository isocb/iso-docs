# FUND Phase 1 Slice 1Q-F-R1 - Catalogue-Centric Project Product Picker UI Review And Smoke Test

Date: 2026-07-06

Status: Passed - functional browser smoke; UX refinement deferred

## 1. Slice

```text
1Q-F-R1 - Catalogue-Centric Project Product Picker UI Review And Smoke Test
```

Reviewed implementation slice:

```text
1Q-F - Catalogue-Centric Project Product Picker UI Remediation
```

Implementation confirmation:

```text
docs/modules/fund/04-implementation-confirmations/2026-07-06-phase-1-slice-1q-f-catalogue-centric-project-product-picker-ui-confirmation.md
```

## 2. Review Scope

Reviewed the first operator-visible Project Product picker pass after 1Q-E:

- C1 Project detail Products tab;
- eligible Product loading from `fund.productEligibility.listForProject`;
- Catalogue-grouped Product discovery;
- shared Product selected state by Product identity;
- existing `FundProjectProduct` add/reactivate/deactivate/reorder behaviour;
- Product-side read-only Catalogue membership visibility;
- explicit boundary against Store, Orders, Commerce, duplication, per-Catalogue pricing and commission behaviour.

## 3. Static Checks

Implementation checks already recorded in the 1Q-F confirmation:

```text
npm run type-check
npx eslint src/modules/fund/components/projects/ProjectProductsManager.tsx src/modules/fund/components/products/ProductModal.tsx src/modules/fund/services/products.service.ts
npm run verify
git diff --check
```

Result:

```text
Passed.
```

## 4. Browser Smoke

Browser smoke route:

```text
http://localhost:3000/app/fund/events/99a51bfd-0596-44bc-89ce-df6dd5f4643e
```

Operator smoke result:

```text
Functional aspects of the 1Q-F pass browser smoke test are accepted as passed, subject to broader UX refinement.
```

Confirmed outcome:

- C1 can see the 1Q-F Product/Catalogue selection behaviour in the browser;
- the functional Product selection path is accepted for this first pass;
- general UX refinement remains deferred;
- no Store, Orders, Commerce, Product duplication, Catalogue duplication, per-Catalogue pricing or commission behaviour was introduced.

## 5. Refinement Raised During Smoke

Browser review surfaced an Event-side management need:

```text
Events should expose linked Product Catalogues and contributed Products.
```

Reason:

- Events are becoming visible management units for C1;
- current Product/Catalogue linkage is visible primarily via Products, Catalogues and availability management;
- Event detail should eventually provide C1 insight into linked Catalogues and Products from the Event itself;
- future Event-side linkage management should operate on Event-to-Catalogue availability, not duplicate Product/Catalogue membership or Project Product selection.

This is now parked in the Phase 2 wishlist as:

```text
2R-EVENT-05 - Event Catalogue And Product Visibility Management Planning
```

## 6. Review Outcome

1Q-F-R1 review outcome:

```text
Pass for functional browser smoke. Defer UX refinement and Event-side Catalogue/Product visibility to future refinement planning.
```

Recommended next core slice remains:

```text
1Q-G - Availability Review And Store/Commerce Readiness Check
```

