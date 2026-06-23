# FUND Phase 1 Slice 1F-B - Catalogue Product Membership Manager Proposal

Date: 2026-06-23

Status: Planning only

Target branch:

```text
feature/fund-phase-1-products-catalogues
```

## Source Context

This proposal uses:

- `implementation/2026-06-23-phase-1-slice-1f-a-products-catalogues-core-admin-ui-confirmation.md`
- `implementation/2026-06-23-phase-1-slice-1e-products-catalogues-api-crud-confirmation.md`
- active FUND documents in `isodocs/docs/modules/fund/`
- `docs/2026-IsoStack-Docs/Standards/ui-ux/isostack-ux-ui-standard.md`
- `docs/2026-IsoStack-Docs/Standards/ui-ux/table-crud-pattern.md`

Existing Slice 1E endpoints available for this slice:

- `fund.catalogues.get`
- `fund.catalogues.addProduct`
- `fund.catalogues.removeProduct`
- `fund.catalogues.reorderProducts`
- `fund.catalogues.setProductActive`
- `fund.products.list`

## 1. Slice Goal

Slice 1F-B should add compact Catalogue Product membership management to the existing Catalogue modal created in Slice 1F-A.

The goal is to allow a tenant admin to:

- see which Products belong to a Catalogue;
- add eligible Products to a Catalogue;
- deactivate/remove a Product membership without hard deleting;
- reactivate inactive membership;
- reorder Catalogue Products using simple controls;
- understand which Product memberships are active or inactive.

This remains catalogue administration only. It must not introduce Projects, Events, Stores, Orders or commerce behaviour.

## 2. Implementation Boundary

Allowed in Slice 1F-B:

- a Catalogue membership manager component;
- integration of that component into `CatalogueModal` for edit mode only;
- tRPC calls to the existing Slice 1E endpoints listed above;
- local Product picker search/filter controls;
- current membership list/table;
- non-destructive inline quick actions using `stopPropagation()`;
- modal-level confirmation for remove/deactivate if needed;
- loading, empty and error states;
- notifications and query invalidation.

Not allowed in Slice 1F-B:

- Prisma schema changes;
- migrations;
- `db:push`;
- seed/reset commands;
- new routers or services;
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
- media or asset workflows;
- production batching;
- dashboards;
- AI workflows.

## 3. Recommended Location

Default recommendation:

- implement membership management inside `CatalogueModal`;
- render it only when editing an existing Catalogue;
- place it below the core Catalogue fields and above the modal footer.

Recommended component:

```text
src/modules/fund/components/catalogues/CatalogueProductsManager.tsx
```

Why inside the modal:

- Catalogue membership is still a compact child collection at this stage;
- the existing table CRUD pattern opens Catalogue rows directly into the modal;
- admins can edit Catalogue details and membership without losing context;
- Slice 1E already returns membership details through `fund.catalogues.get`.

Child page fallback:

- if the manager becomes visually dense, defer richer membership management to a child page in a later slice;
- do not overload the modal with bulk tools, rich previews, asset workflows or project/store rules.

## 4. Product Picker Design

Use `fund.products.list` to load Products available to the tenant.

Recommended query:

```ts
fund.products.list({ includeArchived: false })
```

This gives Draft and Active Products and excludes Archived Products by default.

Picker layout:

- search input labelled `Find Product`;
- optional status filter if the product set is already large;
- compact Select or Combobox showing:
  - Product code;
  - Product name;
  - Workflow Class code;
  - price/currency where available.

Product eligibility:

- hide Products already active in the Catalogue;
- show inactive existing memberships separately in the membership list, not as primary add candidates;
- exclude archived Products from the picker;
- rely on the API for authoritative tenant and archived Product validation.

Add button:

- enabled only when a Product is selected;
- label: `Add Product`;
- calls `fund.catalogues.addProduct`.

## 5. Current Membership List Design

Use `fund.catalogues.get({ id })` to load the current Catalogue with `catalogueProducts`.

List layout should be compact and scan-friendly:

- Product Code;
- Product Name;
- Workflow Class;
- Price;
- Active status;
- Move controls;
- Membership actions on the far right.

Recommended display:

- active memberships shown normally;
- inactive memberships shown with muted text and an `Inactive` badge;
- archived Product membership should be shown if returned by the API, but activation should be prevented by existing API validation.

Default ordering:

- use the order returned by `fund.catalogues.get`, which is already ordered by `sortOrder` and `addedAt`.

Empty state:

- show a short empty state: `No Products in this Catalogue yet.`;
- keep the Product picker visible so the user can add the first Product.

## 6. Add Product Behaviour

When the user selects a Product and clicks `Add Product`:

1. call `fund.catalogues.addProduct({ catalogueId, productId })`;
2. show a success notification;
3. invalidate:
   - `fund.catalogues.get({ id: catalogueId })`;
   - `fund.catalogues.list`;
4. clear the Product picker selection.

Expected API behaviour:

- if no previous membership exists, create one;
- if an inactive membership exists, reactivate it;
- if an active membership exists, return `CONFLICT`.

UI handling:

- if `CONFLICT`, show `Product is already active in this Catalogue`;
- if `BAD_REQUEST`, show the server message, especially archived Catalogue/Product validation;
- keep modal state intact on error.

## 7. Remove / Deactivate Membership Behaviour

Use the existing soft-remove endpoint:

```ts
fund.catalogues.removeProduct({ catalogueId, productId })
```

This does not hard delete. It sets membership inactive.

UX recommendation:

- do not use a tiny destructive trash icon in the row;
- do not add an edit/delete action column;
- present `Remove` or `Deactivate` as an explicit row quick action only if visually text-labelled and far-right;
- safer default: use a small `Menu` or text button labelled `Deactivate` with confirmation.

Recommended confirmation text:

```text
Remove this Product from the active Catalogue list? The membership can be reactivated later.
```

After success:

- show a success notification;
- invalidate Catalogue detail and Catalogue list queries.

## 8. Reactivate Membership Behaviour

Inactive memberships can be reactivated with:

```ts
fund.catalogues.setProductActive({ id: membershipId, isActive: true })
```

Alternative:

- `fund.catalogues.addProduct` also reactivates an inactive matching membership, but the explicit `setProductActive` endpoint is clearer for a row-level active/inactive toggle.

UX recommendation:

- show inactive rows in the current membership list;
- provide an inline `Active` switch on the far right;
- switching on calls `setProductActive(..., true)`;
- switching off calls `setProductActive(..., false)` or routes through the same deactivation confirmation as Remove.

API validation to surface:

- cannot reactivate membership for an archived Catalogue;
- cannot reactivate membership for an archived Product.

## 9. Reorder Behaviour

Use simple Move Up / Move Down controls rather than drag-and-drop.

Reason:

- it is faster to implement safely;
- it avoids adding drag-drop dependencies;
- it is predictable inside a modal;
- it works well for modest Catalogue sizes.

Implementation plan:

1. maintain the current ordered membership array from `fund.catalogues.get`;
2. Move Up / Move Down creates a new ordered array;
3. call:

```ts
fund.catalogues.reorderProducts({
  catalogueId,
  membershipIds: reorderedMembershipIds,
})
```

4. invalidate Catalogue detail and list queries.

Controls:

- Move Up disabled on the first row;
- Move Down disabled on the last row;
- inactive rows should remain reorderable unless a later rule says active-only ordering matters;
- after reorder, preserve the user's current modal context.

## 10. Active / Inactive Membership Toggle

Use:

```ts
fund.catalogues.setProductActive({ id: membershipId, isActive })
```

Recommended UI:

- a `Switch` in the far-right quick-action area;
- label hidden visually only if table header clearly says `Active`;
- active rows: switch on;
- inactive rows: switch off and muted row text.

Important:

- toggling inactive is not a hard delete;
- if business wording prefers `Remove`, map Remove to `setProductActive(false)` or `removeProduct`, but keep the implementation soft.

## 11. Table CRUD And Inline Quick-Action Compliance

The membership list is a child collection inside a Catalogue CRUD modal, not the parent Catalogue table.

Still follow the IsoStack table guidance:

- no edit/delete ActionIcon buttons for CRUD entity editing;
- no destructive tiny row icons;
- inline quick actions are allowed only for non-destructive high-frequency actions;
- inline quick actions must be far-right;
- inline quick actions must use `stopPropagation()`;
- inline quick actions must not accidentally trigger parent row/modal behaviour.

Allowed inline quick actions for membership rows:

- Active switch;
- Move Up;
- Move Down.

Potentially allowed with care:

- text-labelled `Deactivate` button, with confirmation, far-right.

Avoid:

- tiny trash icon;
- delete icon tooltip;
- hidden destructive action in an icon-only control.

## 12. `stopPropagation()` Requirements

Any row-level control inside the membership manager must call `event.stopPropagation()`.

Controls requiring this:

- Product picker Add button if nested in a clickable surface;
- Active switch;
- Move Up button;
- Move Down button;
- Deactivate/Remove button or menu item trigger;
- any menu trigger.

Example pattern:

```tsx
onClick={(event) => {
  event.stopPropagation();
  moveMembershipUp(membership.id);
}}
```

Switch pattern:

```tsx
onClick={(event) => event.stopPropagation()}
onChange={(event) => setMembershipActive(membership.id, event.currentTarget.checked)}
```

## 13. Search / Filter Behaviour For Eligible Products

Product picker search should filter Products by:

- code;
- name;
- slug;
- workflow class code;
- workflow class name.

Recommended behaviour:

- exclude archived Products by API query;
- exclude active members from the add picker;
- show inactive existing members in the membership list so they can be reactivated;
- if the selected Product becomes ineligible after a refresh, clear the selection.

Optional later enhancement:

- add workflow class filter if tenant product lists become large.

## 14. Error Handling And Notifications

Use Mantine notifications consistently with Slice 1F-A.

Success messages:

- `Product added to Catalogue`;
- `Product removed from Catalogue`;
- `Membership reactivated`;
- `Membership updated`;
- `Catalogue Products reordered`.

Error handling:

- show the server error message;
- keep the Catalogue modal open;
- do not discard Catalogue form values;
- leave the membership list visible if stale data is still available;
- expose `CONFLICT`, `BAD_REQUEST`, `NOT_FOUND` and `FORBIDDEN` messages plainly.

Query invalidation:

- after any membership mutation, invalidate:
  - `fund.catalogues.get({ id: catalogueId })`;
  - `fund.catalogues.list`;
- consider invalidating `fund.products.list` only if Product-side status changes are introduced later.

## 15. Loading, Empty And Error States

Loading states:

- show a compact loader or skeleton inside the membership section while Catalogue detail is loading;
- disable Add/Reorder/Toggle controls while their mutation is pending;
- keep the main Catalogue fields usable unless the operation affects the same record.

Empty states:

- no memberships: show `No Products in this Catalogue yet.`;
- no eligible Products: show `No eligible Products available to add.`;
- Product picker search has no matches: show `No Products match this search.`;
- archived Catalogue: show a muted notice that membership cannot be changed while archived.

Error states:

- if `catalogues.get` fails, show an inline error in the membership section with retry;
- mutation errors should be notifications and should not close the modal;
- if Catalogue was archived elsewhere, refresh detail and respect the new status.

## 16. Manual Test Checklist

### Setup

- Open `/app/fund/products`.
- Create or identify at least two non-archived Products.
- Create or identify a draft Catalogue.
- Open the Catalogue row to edit it.

### Add Product

- Confirm the Product picker lists eligible non-archived Products.
- Add a Product to the Catalogue.
- Confirm the Product appears in the membership list.
- Confirm Catalogue table Product Count updates after modal close/refresh.
- Try adding the same active Product again and confirm the UI prevents it or the API conflict is shown clearly.

### Deactivate / Remove

- Deactivate a Product membership.
- Confirm the row becomes inactive/muted.
- Confirm the membership is not hard deleted from the list if inactive memberships are displayed.
- Confirm the Product becomes eligible for reactivation.

### Reactivate

- Reactivate an inactive membership.
- Confirm the row becomes active.
- Confirm archived Product reactivation errors are shown if applicable.

### Reorder

- Add at least three Products.
- Move the second Product up.
- Confirm the order changes.
- Refresh the Catalogue modal.
- Confirm the order persists.
- Move the first Product down.
- Confirm the order persists after refresh.

### Archived Catalogue

- Archive a Catalogue.
- Open the Catalogue.
- Confirm membership controls are disabled or guarded.
- Confirm API errors are shown clearly if a mutation is attempted.

### Pattern Compliance

- Confirm no tiny destructive trash icon exists.
- Confirm inline quick actions sit far-right.
- Confirm inline quick actions do not trigger unrelated row/modal behaviour.
- Confirm `stopPropagation()` is applied to all inline controls.

## 17. Deliberately Out Of Scope

- Product CRUD changes;
- Catalogue CRUD changes beyond embedding the manager;
- Prisma schema changes;
- migrations;
- `db:push`;
- seed/reset commands;
- new routers;
- new services;
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
- media or asset workflows;
- production batching;
- dashboards;
- AI workflows;
- drag-and-drop reordering;
- bulk add/remove actions;
- Product previews with images/assets;
- Store availability rules;
- Project-specific product selection.

## 18. Recommended Implementation Prompt

```text
Proceed with FUND Phase 1 Slice 1F-B implementation: Catalogue Product membership manager.

Work on:
feature/fund-phase-1-products-catalogues

Implement only Catalogue Product membership management using existing Slice 1E endpoints:
- fund.catalogues.get
- fund.catalogues.addProduct
- fund.catalogues.removeProduct
- fund.catalogues.reorderProducts
- fund.catalogues.setProductActive
- fund.products.list

Do not edit Prisma schema.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.
Do not create Projects, Events, Stores, Orders, commerce, payments, commissions, SeasonPro integration, cross-tenant sharing, AMOW marketplace exposure, media/asset workflows, production batching, dashboards or AI workflows.

Create:
- src/modules/fund/components/catalogues/CatalogueProductsManager.tsx

Update:
- src/modules/fund/components/catalogues/CatalogueModal.tsx

Requirements:
- render the manager only for existing Catalogues;
- use fund.catalogues.get data for current membership;
- use fund.products.list for eligible Product picker;
- exclude archived Products from the picker;
- prevent active duplicate adds in the UI;
- support add Product;
- support soft deactivate/remove membership;
- support reactivation;
- support Move Up / Move Down reorder through fund.catalogues.reorderProducts;
- support active/inactive switch through fund.catalogues.setProductActive;
- invalidate catalogue detail and list queries after membership mutations;
- show Mantine notifications for success/error;
- keep the modal open and preserve form state on mutation errors;
- ensure all inline quick actions are far-right, non-destructive where possible, and call stopPropagation();
- do not use tiny destructive trash icons.

Run:
- npm run type-check
- npm run verify

Create confirmation document:
isodocs/docs/modules/fund/implementation/2026-06-23-phase-1-slice-1f-b-catalogue-product-membership-manager-confirmation.md

Report files changed, checks run, any limitations, and confirm that the implementation remains Slice 1F-B only.
```
