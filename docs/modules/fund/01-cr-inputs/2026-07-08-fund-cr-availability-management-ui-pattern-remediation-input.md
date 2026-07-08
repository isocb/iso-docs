# FUND CR Input - Availability Management UI Pattern Remediation

Date: 2026-07-08
Module: FUND
Source: 1Q-G operator testing and IsoStack UX/table pattern review
Status: CR input captured for planning
Priority: High before completing 1Q-G readiness

## User Observation

During 1Q-G testing, the Event Catalogue Availability and Product Suitability areas exposed
a deeper UI-pattern problem.

The current Availability tab is selector-centric:

- choose one Event, then see that Event's linked Catalogues;
- choose one Product, then see that Product's suitability rules.

That technically works for a small demo, but it breaks the IsoStack management pattern once
there are multiple Events and Products. The operator cannot see the management set as a
table, compare rows, search/sort/filter, or use row click into a focused edit surface.

## Relevant IsoStack Pattern

From the table CRUD and UX/UI standards:

- table/list rows should be large click targets;
- simple records can use row click to open an edit modal;
- complex parent records should use row click to open a child page;
- Events are complex FUND parent entities and should use child pages;
- search and sort controls are mandatory on table/list management surfaces;
- delete/destructive actions should live in modal footers or child-page action areas, not
  as tiny row icons.

FUND's own Event planning already says:

```text
Events use child pages because they have dates, status, linked Projects and future linked
Catalogues/Products.
```

## Problem

The Event Catalogue Availability UI currently implies:

```text
There is one selected Event, and this Event has Catalogues.
```

The real operator mental model should be:

```text
There are many Events. Each Event has Catalogue availability that must be visible and
manageable as part of Event management.
```

The Product Suitability UI has the same pattern issue:

```text
There are many Products. Each Product has Project type and organisation type suitability
coverage that must be visible and manageable as a Product management set.
```

## Requested Direction

### Mandatory UI Rule

The Availability tab must follow the established IsoStack table CRUD pattern:

- the page-level UI is the table/list plus search/filter/sort controls and any Add button;
- record-specific edit inputs must not sit directly on the page;
- row click opens the relevant edit modal or child page;
- the modal/child page owns Save, Cancel, Delete/Archive/Remove and other management
  actions;
- inline controls on table rows should be avoided except for genuinely small, non-
  destructive quick actions.

This is a platform consistency issue, not a FUND-specific design preference. FUND users
will also use other IsoStack modules, so FUND must not introduce a separate management
grammar.

### Event Catalogue Availability

Replace or supplement the single Event selector pattern with a table/list pattern.

Desired first-pass behaviour:

- show a table of Event Catalogue availability records or Event availability coverage;
- include columns such as Event, Catalogue, active state, sort order and availability window
  where the row is a link record;
- include Event code/name/status, date window, linked Catalogue count and active availability
  count where the row is an Event coverage row;
- provide search/filter/sort controls above the table;
- provide an Add button where the table represents link records;
- row click opens Event availability management in a modal or Event child page;
- preferred longer-term destination is the Event child page because Event is a complex
  parent entity;
- any edit surface should show linked Catalogues, active state, sort order and availability
  windows for that Event or link record;
- the page itself should not expose the Event selector, Catalogue selector, date inputs or
  save buttons for a selected record.

### Product Suitability

Replace or supplement the single Product selector pattern with a Product suitability
summary table.

Desired first-pass behaviour:

- show a table of Products;
- include columns such as Product code/name/status, Catalogue membership count, Project
  type suitability summary and organisation type suitability summary;
- show unrestricted dimensions clearly, for example `All / unrestricted`;
- provide search/filter/sort controls;
- row click opens the Product suitability edit modal;
- the page itself should not expose a Product selector, Project Type multi-select,
  Organisation Type multi-select or save button.

### Standalone Catalogue Availability

The standalone/default Catalogue availability area is closer to the correct pattern because
it already shows the Catalogue set together. It still must not expose inline record edit
inputs on the page. Row click should open a Catalogue availability modal where the
availability scope/default standalone fields are managed.

Standalone setup should also avoid a hidden configuration trap:

- if there is exactly one active standalone-capable Catalogue and no explicit default
  standalone Catalogue, that Catalogue should be treated as the effective standalone
  default for Project eligibility;
- the Availability UI should label this state clearly, for example `Auto default`;
- if there are multiple standalone-capable Catalogues, C1 must explicitly choose the
  default rather than the system guessing.

## Boundaries

This CR should not implement:

- Store;
- Orders;
- Commerce;
- Product duplication;
- Catalogue duplication;
- pricing;
- commission;
- production/artwork/dispatch workflows;
- notifications;
- SeasonPro integration.

It should also avoid large design churn if a bounded table/list remediation can make 1Q-G
testable.

## Acceptance Direction

This CR is complete when:

- C1 can see all active/current Events and their Catalogue availability coverage without
  switching a single Event selector;
- C1 can open one Event's availability configuration from a row click or Event child page;
- C1 can see Product suitability coverage across Products in a table;
- C1 can open one Product's suitability editor from a row click;
- the UI follows IsoStack row-click table/modal or table/child-page guidance;
- a single active standalone-capable Catalogue works as the effective standalone default
  and is visible as such;
- 1Q-G availability-to-selection testing can continue without selector-hopping.
