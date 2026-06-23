# FUND Phase 1 Slice 1F - Products and Catalogues Admin UI Proposal

Date: 2026-06-23

Status: Planning only

Target branch:

```text
feature/fund-phase-1-products-catalogues
```

## Source Context

This proposal uses:

- `implementation/2026-06-23-phase-1-slice-1e-products-catalogues-api-crud-confirmation.md`
- active FUND docs in `isodocs/docs/modules/fund/`
- `docs/2026-IsoStack-Docs/Standards/ui-ux/isostack-ux-ui-standard.md`
- `docs/2026-IsoStack-Docs/Standards/ui-ux/table-crud-pattern.md`
- `docs/2026-IsoStack-Docs/Standards/ui-ux/TABLE_CRUD_PATTERN_IMPLEMENTATION.md` as reference only

UI/document hierarchy:

1. `isostack-ux-ui-standard.md` is the owner-controlled UI/UX authority.
2. `table-crud-pattern.md` is the active implementation guide for table-to-CRUD interfaces.
3. `TABLE_CRUD_PATTERN_IMPLEMENTATION.md` is a historical rollout/reference record only.

## 1. Slice Goal

Slice 1F should add the first tenant admin UI for managing FUND Products and Catalogues.

The goal is to prove that the Slice 1E API/service layer can support:

- tenant-owned Product listing;
- tenant-owned Product create/edit/archive/restore/activate;
- workflow class selection and display;
- Product pricing/VAT/currency editing;
- tenant-owned Catalogue listing;
- Catalogue create/edit/archive/restore/activate;
- simple Catalogue/Product membership management;
- standard IsoStack table-to-CRUD UX.

This slice is still foundation work. It must not shift FUND into a shop-first, checkout-first or Store/Order-first module.

## 2. Implementation Boundary

Allowed in Slice 1F:

- UI route for Products/Catalogues administration;
- Product table component;
- Product modal component;
- Catalogue table component;
- Catalogue modal component;
- simple Catalogue Product membership manager if it remains modal-friendly;
- tRPC calls to existing Slice 1E routers only;
- client-side table controls, forms, notifications and loading/empty/error states.

Forbidden in Slice 1F:

- Prisma schema changes;
- migrations;
- `db:push`;
- seed/reset commands;
- Projects;
- Events;
- Stores;
- Orders;
- commerce;
- payments;
- commissions;
- SeasonPro integration;
- cross-tenant sharing;
- AMOW marketplace exposure;
- media/asset library;
- dashboards;
- production batching;
- AI workflows.

## 3. Route And Navigation Recommendation

Recommended route:

```text
/app/fund/products
```

Recommended app file:

```text
src/app/(app)/app/fund/products/page.tsx
```

Recommended page structure:

- one admin management surface;
- page title: `Products and Catalogues`;
- brief context text only if needed;
- primary tabs:
  - `Products`
  - `Catalogues`

Navigation:

- Keep `/app/fund` as the shell/landing page for now.
- Add a module navigation entry for Products/Catalogues only if the current module navigation pattern supports FUND child pages cleanly.
- If navigation registration requires broader module-navigation decisions, implement the route first and defer nav polish to a follow-up.

## 4. Products Tab Design

Purpose:

- manage tenant-owned Products that will later be selected by Projects.

Top controls:

- left: fuzzy search field;
- right: sort selector and sort direction toggle, or DataTable/header sort equivalent with visible reverse-sort control;
- optional status filter:
  - All active/draft;
  - Draft;
  - Active;
  - Archived;
- optional workflow class filter if it remains simple.

Create action:

- `Create Product` button above the table, aligned with the table controls.
- Opens Product modal in create mode.

Product table recommended columns:

- Code;
- Name;
- Workflow Class;
- Status;
- Price;
- VAT;
- Currency;
- Featured;
- Sort Order;
- Updated.

Default sort:

- `Code` ascending, because it is the first stable data column and helps catalogue management.

Row behaviour:

- whole row click opens Product modal in edit mode;
- row click payload must be normalised with `params?.record ?? params`;
- rows must show pointer cursor and hover feedback;
- no edit/delete ActionIcon buttons;
- no edit/delete actions column.

## 5. Catalogues Tab Design

Purpose:

- manage tenant-owned Catalogues and their Product membership.

Top controls:

- left: fuzzy search field;
- right: sort selector and sort direction toggle, or DataTable/header sort equivalent with visible reverse-sort control;
- optional status filter:
  - All active/draft;
  - Draft;
  - Active;
  - Archived.

Create action:

- `Create Catalogue` button above the table.
- Opens Catalogue modal in create mode.

Catalogue table recommended columns:

- Code;
- Name;
- Status;
- Product Count;
- Featured;
- Sort Order;
- Updated.

Default sort:

- `Code` ascending.

Row behaviour:

- whole row click opens Catalogue modal in edit mode;
- row click payload must be normalised with `params?.record ?? params`;
- rows must show pointer cursor and hover feedback;
- no edit/delete ActionIcon buttons;
- no edit/delete actions column.

## 6. Catalogue Membership Management Design

Preferred Slice 1F approach:

- include a simple membership manager inside the Catalogue modal after core Catalogue fields;
- use `fund.catalogues.get` to load current membership when editing;
- use `fund.products.list` to offer eligible Products for adding;
- show Product rows ordered by membership `sortOrder`;
- allow:
  - add Product;
  - remove/deactivate Product membership;
  - reorder Products;
  - toggle membership active/inactive.

Modal-friendly limit:

- The membership manager is acceptable inside the modal only if it remains compact and easy to scan.
- If membership management needs multi-step filtering, bulk actions, production rules, complex validation or rich Product previews, defer it to a child page or later slice.

Recommended manager layout:

- Product picker/search at top;
- current membership list below;
- compact row display:
  - Product code;
  - Product name;
  - Workflow Class;
  - Price;
  - Active toggle.

Inline quick actions:

- membership active toggle may be inline because it is non-destructive;
- it must sit far-right;
- it must use `stopPropagation()`;
- remove/deactivate should be treated carefully:
  - if it is presented as an immediate destructive-like action, place it in the modal section with explicit confirmation;
  - do not use tiny delete icons in table rows.

## 7. Product Modal Fields

Create/edit modal sections:

### Core

- Code;
- Name;
- Slug;
- Workflow Class;
- Status display;
- Featured;
- Sort Order.

### Descriptions

- Short Description;
- Description.

### Pricing

- Unit Price Net;
- VAT Rate;
- Currency;
- Pricing Notes.

### Production

- Production Notes.

### Metadata

- Metadata should not be exposed as raw JSON in Slice 1F unless there is an established safe JSON editor pattern.
- Prefer deferring metadata editing unless needed for current Product management.

Footer:

- left:
  - Archive for non-archived existing Products;
  - Restore for archived Products;
  - Activate for draft/archived Products where appropriate.
- right:
  - Cancel;
  - Save.

Do not use hard delete.

## 8. Catalogue Modal Fields

Create/edit modal sections:

### Core

- Code;
- Name;
- Slug;
- Status display;
- Featured;
- Sort Order.

### Description

- Description.

### Product Membership

- only when editing an existing Catalogue;
- load via `fund.catalogues.get`;
- use simple manager as described above;
- defer to child page/later slice if it becomes too complex.

### Metadata

- Do not expose raw metadata JSON in Slice 1F unless a safe established pattern exists.

Footer:

- left:
  - Archive for non-archived existing Catalogues;
  - Restore for archived Catalogues;
  - Activate for draft/archived Catalogues where appropriate.
- right:
  - Cancel;
  - Save.

Do not use hard delete.

## 9. Status, Archive, Restore And Activate UX

Status display:

- use badges:
  - Draft: neutral/gray;
  - Active: green;
  - Archived: muted/dark or gray.

Archive:

- modal-level action only;
- bottom-left, red outline;
- ask for optional archive reason if this can be done without overloading the modal;
- call:
  - `fund.products.archive`
  - `fund.catalogues.archive`

Restore:

- modal-level action for archived records;
- restore returns records to Draft;
- call:
  - `fund.products.restore`
  - `fund.catalogues.restore`

Activate:

- modal-level action;
- call:
  - `fund.products.activate`
  - `fund.catalogues.activate`
- show API validation errors clearly:
  - Product missing price;
  - missing/invalid workflow class;
  - Catalogue has no active Product membership;
  - Catalogue includes archived Products.

General update:

- general save must not directly mutate status.
- status changes go through archive/restore/activate actions.

## 10. Workflow Class Display And Selection

Use:

```text
fund.workflowClasses.list
```

Product table:

- show workflow class code and name.

Product modal:

- required Select field for workflow class;
- options should show:
  - A1 - Individual Artwork Project Product;
  - A2 - Group Artwork Product;
  - B - Logo / Bulk Mass Customisation Product;
  - C - Standard Product.

Workflow class should be read from platform defaults only. Do not create UI for workflow class management in Slice 1F.

If the API returns workflow flags, display read-only helper text only if it improves clarity without turning the modal into workflow configuration.

## 11. Price, VAT And Currency Display And Validation

Product table:

- show net price formatted with currency;
- show VAT as percentage;
- show blank/`Not set` for draft Products without price.

Product modal:

- `unitPriceNet` number input;
- `vatRate` number input;
- `currency` select/input defaulting to GBP.

Validation:

- `unitPriceNet` may be blank in Draft;
- `unitPriceNet` must be `>= 0` if supplied;
- activation should surface API rejection if price is missing;
- `vatRate` must be `0-100`;
- `currency` must be 3 uppercase letters.

Do not add:

- gross price storage;
- Stripe price ids;
- GoCardless fields;
- discounts;
- bundles;
- commission rates;
- per-Catalogue price overrides.

## 12. Search, Sort And Filter Behaviour

Mandatory controls:

- fuzzy search field;
- sort selector and sort direction toggle, or approved visible-column/header sorting equivalent;
- visible data columns sortable where practical.

Product search fields:

- code;
- name;
- slug;
- description.

Catalogue search fields:

- code;
- name;
- slug;
- description.

API search:

- initial Slice 1F can pass search to the Slice 1E list endpoints.
- If richer fuzzy search is required, start with local fuzzy filtering over loaded rows only if dataset size remains manageable.

Filters:

- status filter should map to `status` and/or `includeArchived`;
- Product workflow class filter should map to `workflowClassId`.

Default sorting:

- Products: Code ascending;
- Catalogues: Code ascending;
- Membership list: `sortOrder` ascending.

## 13. Table CRUD Pattern Compliance

Slice 1F must follow the IsoStack table CRUD pattern:

- row click opens CRUD modal;
- no edit/delete ActionIcon buttons in CRUD table rows;
- no edit/delete actions column;
- destructive actions such as archive/delete belong bottom-left in modal footer;
- Cancel and Save belong on the right of modal footer;
- universal fuzzy search field is mandatory;
- sort selector and sort direction toggle, or approved visible-column/header sorting equivalent, are mandatory;
- visible data columns should be sortable where practical;
- default sort should be the first data column unless a domain-specific default is documented;
- `mantine-datatable` row click payloads must be normalised with `params?.record ?? params`;
- clickable rows must show pointer cursor/row hover feedback;
- inline quick actions are allowed only for non-destructive high-frequency actions;
- inline quick actions must sit far-right;
- inline quick actions must use `stopPropagation()`;
- inline quick actions must never be destructive.

## 14. Component And File Plan

Likely future files:

```text
src/app/(app)/app/fund/products/page.tsx
src/modules/fund/components/products/ProductTable.tsx
src/modules/fund/components/products/ProductModal.tsx
src/modules/fund/components/catalogues/CatalogueTable.tsx
src/modules/fund/components/catalogues/CatalogueModal.tsx
src/modules/fund/components/catalogues/CatalogueProductsManager.tsx
```

Optional shared helpers if needed:

```text
src/modules/fund/components/shared/FundStatusBadge.tsx
src/modules/fund/components/shared/FundTableControls.tsx
src/modules/fund/lib/ui/formatters.ts
```

Keep abstractions light. Add shared helpers only if they remove real duplication between Products and Catalogues.

## 15. tRPC Usage Plan

Products page/tab:

- `fund.products.list`
- `fund.products.get`
- `fund.products.create`
- `fund.products.update`
- `fund.products.activate`
- `fund.products.archive`
- `fund.products.restore`
- `fund.workflowClasses.list`

Catalogues page/tab:

- `fund.catalogues.list`
- `fund.catalogues.get`
- `fund.catalogues.create`
- `fund.catalogues.update`
- `fund.catalogues.activate`
- `fund.catalogues.archive`
- `fund.catalogues.restore`
- `fund.catalogues.addProduct`
- `fund.catalogues.removeProduct`
- `fund.catalogues.reorderProducts`
- `fund.catalogues.setProductActive`
- `fund.products.list` for Product picker/membership add

Cache invalidation:

- invalidate Product list after Product create/update/archive/restore/activate;
- invalidate Catalogue list after Catalogue create/update/archive/restore/activate;
- invalidate Catalogue detail after membership mutations;
- invalidate Catalogue list after membership mutations if Product count is displayed.

## 16. Form Handling And Validation Plan

Use existing app form conventions.

Recommended:

- Mantine form components;
- local client validation mirroring Slice 1E Zod constraints;
- rely on API validation for final enforcement.

Product form should validate:

- code required/max 64;
- name required/max 160;
- slug lower-case URL-safe/max 96;
- workflow class required;
- unit price non-negative if supplied;
- VAT `0-100`;
- currency three uppercase letters.

Catalogue form should validate:

- code required/max 64;
- name required/max 160;
- slug lower-case URL-safe/max 96.

Do not allow status editing through the general form.

## 17. Error Handling And Notifications Plan

Use Mantine notifications or the existing app notification pattern.

Success notifications:

- Product created;
- Product updated;
- Product archived/restored/activated;
- Catalogue created;
- Catalogue updated;
- Catalogue archived/restored/activated;
- Product added/removed/reordered in Catalogue.

Error handling:

- `CONFLICT`: show duplicate code/slug or duplicate membership message;
- `BAD_REQUEST`: show validation/state message from API;
- `FORBIDDEN`: show permission/feature-access message;
- `NOT_FOUND`: show stale/missing record message and refresh list;
- generic errors: show clear fallback and keep modal data intact.

After archive/restore/activate:

- keep modal open only if useful;
- otherwise close modal and refresh list.

## 18. Loading, Empty And Error States

Products tab:

- loading skeleton/table loading state while `fund.products.list` loads;
- empty state: `No Products yet`;
- filtered empty state: `No Products match these filters`;
- error state with retry.

Catalogues tab:

- loading skeleton/table loading state while `fund.catalogues.list` loads;
- empty state: `No Catalogues yet`;
- filtered empty state: `No Catalogues match these filters`;
- error state with retry.

Modals:

- disable Save while mutation is pending;
- show loading state when fetching detail;
- prevent duplicate submissions.

Membership manager:

- loading state while Catalogue detail and Product picker data load;
- empty state for no membership;
- empty state for no eligible Products.

## 19. Manual Test Checklist

Products:

- open `/app/fund/products`;
- Products tab loads for tenant with FUND enabled;
- tenant without FUND enabled is forbidden or cannot navigate;
- create Product in Draft;
- create rejects missing workflow class;
- duplicate Product code in same tenant shows conflict;
- duplicate Product slug in same tenant shows conflict;
- Product table search filters expected rows;
- Product table sort/reverse-sort works;
- row click opens edit modal with populated form;
- modal row-click payload is normalised with `params?.record ?? params`;
- edit Product details and save;
- archive Product from modal footer;
- restore Product from archived state;
- activate Product rejects missing price;
- activate Product succeeds when required fields and price exist.

Catalogues:

- Catalogues tab loads;
- create Catalogue in Draft;
- duplicate Catalogue code in same tenant shows conflict;
- duplicate Catalogue slug in same tenant shows conflict;
- Catalogue table search filters expected rows;
- Catalogue table sort/reverse-sort works;
- row click opens edit modal with populated form;
- add Product to Catalogue;
- duplicate active membership shows conflict;
- remove/deactivate Product membership;
- reactivate inactive membership;
- reorder membership and confirm order persists;
- activate Catalogue rejects empty Catalogue;
- activate Catalogue rejects archived Product membership;
- archive Catalogue without archiving Products;
- restore Catalogue to Draft.

UX compliance:

- no edit/delete ActionIcon buttons in table rows;
- no edit/delete actions column;
- destructive actions are modal footer left;
- Cancel/Save are modal footer right;
- rows show pointer/hover feedback;
- inline quick actions, if any, use `stopPropagation()` and are non-destructive.

## 20. Deliberately Out Of Scope

Slice 1F must not introduce:

- Projects;
- Events;
- Stores;
- Orders;
- commerce;
- payments;
- commissions;
- SeasonPro integration;
- cross-tenant sharing;
- AMOW marketplace exposure;
- media/asset library;
- dashboards;
- production batching;
- AI workflows;
- Prisma schema changes;
- migrations;
- `db:push`;
- seed/reset commands.

## 21. Risks And Questions

Risks:

- Catalogue membership may become too dense for a modal if Product lists grow or if future Project/Store context is added.
- Search expectations may exceed the current API search behaviour; keep initial implementation simple and document any need for richer fuzzy search.
- Activation errors come from the API and must be presented clearly so users understand why a record remains Draft.
- Metadata exists in the API but should not be exposed raw without a safe UI pattern.

Questions before implementation:

- Should archived records appear by default behind an `Include archived` toggle, or should Archived be a status filter option only?
- Should Product/Catalogue codes be manually entered only, or should the UI offer slug/code generation helpers?
- Should membership reorder use drag-and-drop immediately, or start with simple move up/down controls?
- Should `Activate` be shown as a primary modal action or as a secondary action near archive/restore?
- Should Product workflow class helper text display the requirement flags in Slice 1F, or wait until Project lifecycle screens?

## 22. Recommended Slice 1F Implementation Prompt

```text
Proceed with FUND Phase 1 Slice 1F implementation: Products and Catalogues admin UI.

Work on feature/fund-phase-1-products-catalogues.

Before editing, read:
- isodocs/docs/modules/fund/Planning/2026-06-23-fund-phase-1-slice-1f-products-catalogues-admin-ui-proposal.md
- isodocs/docs/modules/fund/implementation/2026-06-23-phase-1-slice-1e-products-catalogues-api-crud-confirmation.md
- active FUND docs in isodocs/docs/modules/fund/
- docs/2026-IsoStack-Docs/Standards/ui-ux/isostack-ux-ui-standard.md
- docs/2026-IsoStack-Docs/Standards/ui-ux/table-crud-pattern.md

Implement only the Products/Catalogues admin UI using existing Slice 1E routers.

Do not edit Prisma schema.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.
Do not create dashboards, Projects, Events, Stores, Orders, commerce, payments, commissions, SeasonPro integration, cross-tenant sharing, AMOW marketplace exposure, media/asset workflows, production batching or AI workflows.

After implementation, run type-check and verify, then create a Slice 1F implementation confirmation document.
```
