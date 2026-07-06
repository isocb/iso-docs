# FUND Phase 1 Slice 1Q-F - Catalogue-Centric Project Product Picker UI Planning

Date: 2026-07-01

Status: Implemented locally - functional browser smoke passed; UX refinement deferred

## 1. Slice Goal

Update Project Product selection so C1/C2 users choose from the 1Q-E eligible Product source list rather than from the flat tenant Product library.

The UI should make Product eligibility understandable through Catalogue context while keeping `FundProjectProduct` as the final selected Product list.

## 2. Core UX Direction

Project Product selection should be Catalogue-centric for discovery:

```text
Project
-> eligible source Catalogues
-> Products grouped by source Catalogue
-> shared Product selection state
-> FundProjectProduct selected Products
```

This replaces the earlier flat picker pattern:

```text
Project
-> all tenant Products
-> add Product directly
```

The flat tenant Product picker is no longer suitable once Project eligibility depends on Event/standalone Catalogue availability and Product suitability.

## 3. Product Deduplication Rule

The same Product may be available through more than one Catalogue.

Accepted rule:

```text
Catalogue context explains availability.
Product identity controls selection.
```

Therefore:

- a Product available through multiple source Catalogues should appear as one selectable Product identity;
- the UI may show that Product under more than one Catalogue group for context;
- selection state must be shared by `productId` across all groups;
- selecting a Product in one Catalogue group should mark it selected wherever else it appears;
- saving should create or reactivate at most one active `FundProjectProduct` row for that Product;
- Store pages must eventually show the selected Product once, not once per source Catalogue.

Suggested grouped UI behaviour:

```text
Event Catalogue A
- Product X [selected]
- Product Y [not selected]

Event Catalogue B
- Product X [also available here / already selected]
- Product Z [not selected]
```

## 4. Why Project Does Not Need Linked Catalogues

It is acceptable that the Project stores selected Products through `FundProjectProduct` rather than storing linked Catalogues.

This is not a reversal of the Catalogue-centric model:

- Catalogues define the source availability and explain why a Product is eligible;
- `FundProjectProduct` records the Project's operational selected Product set;
- Store and Orders later consume the selected Product set;
- source Catalogue context can remain in the eligibility response and UI explanation without becoming the Project selection record.

If future requirements need to prove the exact source Catalogue used for a selected Product, plan a separate source snapshot model rather than overloading this slice.

## 5. Copy Versus Reference Boundary

Future Product and Catalogue duplication may allow:

- reference mode: a new Catalogue points to the same existing Product records;
- copy mode: a new Catalogue gets copied Product records.

Reference mode means:

```text
Same Product record
-> appears once in Project selection
-> appears once in Store display
```

Copy mode means:

```text
Copied Product record
-> may have different pricing, commission, copy, options, media or fulfilment behaviour
-> is a distinct Product identity
-> may appear separately if both original and copy are eligible
```

1Q-F should not implement duplication, per-Catalogue pricing, commission, Product options or Store display. It should preserve the distinction so those later decisions have room to work safely.

## 6. C1 Product Manager Adjustment

The current Product Manager has a Product list and a Catalogue membership manager inside the Catalogue modal. That is not enough once Products are numerous and Catalogue availability drives Project eligibility.

Accepted Product Manager UX adjustment:

- add a Product-side `Catalogue memberships` view in the Product edit/detail surface;
- show which Catalogues currently contain the Product;
- show active/inactive membership state;
- show Catalogue status and availability scope;
- show default standalone status where relevant;
- provide clear navigation to the relevant Catalogue management surface.

Initial implementation can be read-only if that avoids broadening the slice. Full Product-side add/remove membership management can be planned separately if needed.

Purpose:

```text
C1 users should not have to inspect every Catalogue to understand where a Product is used.
```

## 7. Implementation Boundary

Do not implement in this slice:

- Product eligibility API/services before 1Q-E is complete;
- new schema or migrations unless 1Q-E review finds they are required;
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

## 8. Expected Inputs From 1Q-E

1Q-F should consume a 1Q-E response that includes:

- Project summary;
- source mode;
- source Catalogue groups;
- deduplicated eligible Products;
- source Catalogues per eligible Product;
- existing active Project Product membership state;
- warnings for missing source Catalogues, missing Project type or missing organisation type.

If 1Q-E returns only a flat Product list, 1Q-F should not proceed until source Catalogue context is added.

## 9. Review/Test Expectations

Static review must confirm:

- the Project Product picker no longer uses all tenant Products as its source;
- eligible Products come from 1Q-E only;
- Products are grouped by source Catalogue for context;
- shared Product selection state is keyed by `productId`;
- duplicate source-Catalogue appearances do not create duplicate `FundProjectProduct` rows;
- Product-side Catalogue membership visibility is available or explicitly deferred with a follow-up;
- no Store, Orders, Commerce or duplication behaviour was added.

Smoke expectations:

- Product available through one eligible Catalogue can be selected;
- Product available through two eligible Catalogues appears with both source contexts but one shared selected state;
- selecting/deselecting a shared Product updates the state consistently in all groups;
- saving creates/reactivates one Project Product membership per selected Product;
- a Product outside all eligible Catalogues is not offered;
- existing selected Project Products remain visible even if eligibility changes later, with a clear warning if needed.

## 10. Recommended Next Slice

```text
1Q-G - Availability Review And Store/Commerce Readiness Check
```

Goal:

```text
Review the full availability-to-selection path before Store, Orders or Commerce implementation begins.
```

## 11. Implementation Confirmation

Local implementation confirmation:

```text
docs/modules/fund/04-implementation-confirmations/2026-07-06-phase-1-slice-1q-f-catalogue-centric-project-product-picker-ui-confirmation.md
```

Functional browser smoke is operator-confirmed as passed, subject to later UX refinement.

Related refinement parked during smoke review:

```text
2R-EVENT-05 - Event Catalogue And Product Visibility Management Planning
```
