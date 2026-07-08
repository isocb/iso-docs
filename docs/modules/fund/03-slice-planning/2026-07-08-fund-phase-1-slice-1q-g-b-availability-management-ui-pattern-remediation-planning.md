# FUND Phase 1 Slice 1Q-G-B - Availability Management UI Pattern Remediation Planning

Date: 2026-07-08
Module: FUND
Related CR: `docs/modules/fund/01-cr-inputs/2026-07-08-fund-cr-availability-management-ui-pattern-remediation-input.md`
Related review hold: `docs/modules/fund/05-review-and-test/2026-07-07-phase-1-slice-1q-g-r1-availability-review-and-store-commerce-readiness-check.md`
Status: Revised after operator pattern review; implementation target corrected
Priority: High before completing 1Q-G readiness

## 1. Purpose

1Q-G testing found that the current Availability UI uses selector-centric editing for Event
Catalogue availability and Product suitability. This makes C1 switch one Event or Product
at a time and hides the management set.

1Q-G-B should reshape those surfaces to follow the IsoStack table/list management pattern.

## 2. Source UX Guidance

Relevant guidance:

- `docs/guides/table-crud-pattern.md`;
- `docs/00-overview/ui_ux_components/isostack-ux-ui-standard.md`;
- `docs/modules/fund/Planning/2026-06-24-fund-phase-1-slice-1m-fund-event-admin-ui-proposal.md`;
- `docs/modules/fund/05-fund-open-questions.md`.

Key rules:

- simple entities: row click opens CRUD modal;
- complex parent entities: row click opens child page;
- Events are complex FUND parent entities and should use child pages;
- table/list management surfaces should show the set, not hide it behind a selector;
- search/sort controls are mandatory;
- destructive actions should not be tiny row icons.

## 3. Goal

Make Event Catalogue availability and Product suitability inspectable as management sets:

```text
Availability page -> tables only
Table row click -> modal or child page
Modal/child page -> record-specific inputs and save/cancel/delete actions
```

The first pass may use bounded modals where safe, but the page itself must not contain the
selected-record form inputs. The design should still point toward Event child-page
management for future Event-linked Catalogue/Product operations.

## 4. Scope

### Included

- Event Catalogue Availability overview table/list;
- linked Catalogue counts and active availability counts per Event;
- row click into one Event's availability configuration;
- Product suitability summary table/list;
- Project type and organisation type suitability summary per Product;
- row click into one Product's suitability configuration;
- preserve existing availability API/services;
- update 1Q-G review/test notes after implementation.

### Excluded

- Store;
- Orders;
- Commerce;
- Product duplication;
- Catalogue duplication;
- pricing;
- commission;
- Product media galleries;
- Product options;
- production/artwork/dispatch workflows;
- notifications;
- SeasonPro integration.

## 5. 1Q-G-B1 - Event Catalogue Availability Table Pattern

Problem:

```text
Event Catalogue Availability is hidden behind a single Event selector or hybrid table plus
inline selected-record editor.
```

Implement:

- show a table/list that exposes the management set;
- preferred first-pass table: Event Catalogue availability link records, with columns:
  - Event code/name;
  - Catalogue code/name;
  - active/inactive;
  - sort order;
  - available from/until;
- optionally also show Event coverage summary, with columns:
  - Event code/name;
  - status;
  - opens/closes date window;
  - linked Catalogue count;
  - active linked Catalogue count;
  - warning/empty indicator where no active Catalogues are linked;
- add search/filter/sort controls consistent with IsoStack table guidance;
- Add opens a create modal for a new Event/Catalogue availability link or an Event
  availability modal;
- row click opens the Event availability edit modal or Event child page.

Editor options:

- bounded first pass: open a modal with the Event/Catalogue availability controls;
- preferred refinement path: Event child page tab for Catalogues/Products, aligned with
  `2R-EVENT-05`.

Do not:

- place Event selector inputs directly on the Availability page;
- place Catalogue selector inputs directly on the Availability page;
- place date/sort/status edit inputs directly on the Availability page;
- place Save Event Catalogues on the Availability page.

Acceptance:

- C1 can scan all Events and see which have Catalogue coverage;
- C1 does not have to switch a single Event selector to discover setup gaps;
- saving one Event's availability does not affect other Events.

## 6. 1Q-G-B2 - Product Suitability Table Pattern

Problem:

```text
Product suitability is hidden behind a single Product selector.
```

Implement:

- show a Product suitability summary table/list;
- include columns:
  - Product code/name;
  - status;
  - workflow class where useful;
  - Catalogue membership count;
  - Project type suitability summary;
  - organisation type suitability summary;
  - unrestricted flags where no active rows exist;
- add search/filter/sort controls;
- row click opens the Product suitability edit modal for that Product.

Do not:

- place a Product selector directly on the Availability page;
- place Project Type or Organisation Type multi-select edit controls directly on the
  Availability page;
- place Save Product Suitability on the Availability page.

Acceptance:

- C1 can scan suitability coverage across Products;
- unrestricted dimensions are explicit;
- C1 can quickly identify why a Product should or should not appear in eligibility.

## 7. 1Q-G-B3 - Standalone Catalogue Availability Pattern Check

Problem:

```text
Standalone Catalogue availability is closer to the correct pattern but should be checked
against the table/list rules.
```

Additional operator finding:

```text
Where there is only one active standalone-capable Catalogue, failing to mark it as the
default standalone Catalogue creates a hidden setup failure. The operator reasonably
expects the only possible standalone Catalogue to be used.
```

Implement:

- preserve the visible Catalogue set;
- ensure search/filter/sort controls are available or planned;
- row click opens a Catalogue availability modal;
- move availability scope/default standalone edit controls into that modal;
- avoid replacing a visible table/list with a single-selector pattern.
- treat exactly one active standalone-capable Catalogue as the effective standalone default
  when no explicit default exists;
- show that inferred state in the Catalogue table/modal as `Auto default`.

Do not:

- place availability scope selects, default standalone toggles or Save buttons directly in
  table rows.
- infer a default when multiple standalone-capable Catalogues exist.

Acceptance:

- standalone/default Catalogue setup remains visible as a set.
- a one-Catalogue standalone configuration does not block Project Product eligibility.

## 8. Review And Test Plan

Browser smoke:

- open `/app/fund/products`;
- open Availability;
- confirm Event Catalogue Availability is table-only at page level;
- confirm Add opens a modal or row click opens a modal/child page;
- confirm Event/Catalogue/date/sort/status edit inputs appear only inside the modal/child
  page;
- edit linked Catalogues and save from the modal/child page;
- close the modal/child page and confirm the table updates;
- confirm another Event's availability was not overwritten;
- open Product Suitability summary;
- confirm Product Suitability is table-only at page level;
- confirm Product suitability coverage is visible across Products;
- row click a Product;
- edit suitability inside the modal;
- return to the summary and confirm the row updates.
- remove any explicit standalone default in a controlled single-Catalogue setup;
- confirm the lone active standalone-capable Catalogue is labelled `Auto default`;
- confirm standalone Project Product eligibility uses that Catalogue.

Regression smoke:

- 1Q-E eligibility still uses Event/standalone availability and suitability;
- 1Q-F Project Product picker still groups eligible Products by source Catalogue;
- no Store, Orders, Commerce, duplication, pricing or commission behaviour appears.

Developer checks:

```text
npm run type-check
npm run verify
git diff --check
```

## 9. Risks

- creating a large Event child-page redesign when a bounded table/modal fix would unblock
  testing;
- duplicating Event-side Catalogue management and Product/Catalogue membership management;
- making the Availability tab too dense;
- implementing row action icon clutter instead of row-click surfaces.

## 10. Mitigations

- keep 1Q-G-B focused on visibility and row-click edit surfaces;
- preserve existing service/API boundaries;
- keep Catalogue-to-Product membership in Catalogue/Product management;
- keep Project selection in `FundProjectProduct`;
- park full Event child-page Catalogue/Product management under `2R-EVENT-05` if it grows
  beyond the first remediation pass.

## 11. Suggested Handoff Prompt

```text
Proceed with FUND Phase 1 Slice 1Q-G-B on local app dev. Keep the work limited to
Availability UI pattern remediation: Event Catalogue Availability overview with row-click
management, Product Suitability summary table with row-click editing, and a quick
standalone Catalogue availability pattern check. Preserve existing availability services
and 1Q-F Project Product picker behaviour. Do not implement Store, Orders, Commerce,
Product/Catalogue duplication, pricing, commission, production, dispatch, notifications or
SeasonPro integration.
```
