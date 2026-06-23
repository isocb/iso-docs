# Phase 1 Slice 1F-B - Catalogue Product Membership Manager Confirmation

## Date

2026-06-23

## Slice Name

Phase 1 Slice 1F-B - Catalogue Product Membership Manager

## Implementation Summary

Implemented compact Catalogue Product membership management inside the existing Slice 1F-A Catalogue modal.

The manager appears only when editing an existing Catalogue. It is not shown while creating a new Catalogue.

The implementation uses only existing Slice 1E endpoints and does not add schema, migrations, routers, services or new business domains.

## Files Changed

App repository:

- `src/modules/fund/components/catalogues/CatalogueProductsManager.tsx`
- `src/modules/fund/components/catalogues/CatalogueModal.tsx`

Documentation repository:

- `docs/modules/fund/implementation/2026-06-23-phase-1-slice-1f-b-catalogue-product-membership-manager-confirmation.md`

## Components Created / Updated

Created:

- `CatalogueProductsManager`

Updated:

- `CatalogueModal`

## tRPC Endpoints Used

- `fund.catalogues.get`
- `fund.catalogues.addProduct`
- `fund.catalogues.removeProduct`
- `fund.catalogues.reorderProducts`
- `fund.catalogues.setProductActive`
- `fund.products.list`

## Catalogue Modal Integration

The manager is rendered inside `CatalogueModal` only when:

- the modal is in edit mode; and
- an existing Catalogue record is available.

The manager receives:

- Catalogue id;
- Catalogue status;
- Catalogue Product memberships from `fund.catalogues.get`;
- Catalogue detail loading/error state.

It is hidden in create mode so new Catalogues are created first, then membership can be managed after the Catalogue exists.

## Product Picker Behaviour

The picker uses:

```text
fund.products.list({ includeArchived: false })
```

Picker options show:

- Product code;
- Product name;
- Workflow Class code/name;
- price/currency where available.

The picker excludes:

- archived Products;
- Products already active in the Catalogue.

If there are no eligible Products, the UI shows:

```text
No eligible Products available to add.
```

## Membership List Behaviour

The membership list shows:

- Product code;
- Product name;
- Workflow Class;
- price;
- active/inactive status;
- Move Up;
- Move Down;
- Active switch;
- user-facing Deactivate action.

Active memberships display normally.

Inactive memberships display muted with an `Inactive` badge.

When there are no memberships, the UI shows:

```text
No Products in this Catalogue yet.
```

Archived Catalogues show a muted notice and disable membership controls.

## Add / Deactivate / Reactivate / Reorder Behaviour

### Add

`Add Product` calls:

```text
fund.catalogues.addProduct
```

On success:

- success notification is shown;
- selected Product is cleared;
- Catalogue detail and list queries are invalidated.

### Deactivate / Remove

The user-facing `Deactivate` action calls:

```text
fund.catalogues.removeProduct
```

This is a soft removal. It sets the membership inactive and does not hard delete.

A confirmation prompt is shown before deactivation.

### Reactivate

The Active switch calls:

```text
fund.catalogues.setProductActive({ isActive: true })
```

This reactivates inactive membership where API validation allows it.

### Active Switch Off

The Active switch can also call:

```text
fund.catalogues.setProductActive({ isActive: false })
```

The separate `Deactivate` button remains available as the clearer user-facing remove/deactivate action.
Note to watch:
Switch on = immediate reactivation
Switch off = routes through the same confirmation as Deactivate

### Reorder

Move Up and Move Down controls call:

```text
fund.catalogues.reorderProducts
```

The implementation uses simple button controls and does not implement drag-and-drop.

## `stopPropagation()` And Table Action Compliance

Inline controls call `stopPropagation()`:

- Add Product button;
- Active switch;
- Move Up;
- Move Down;
- Deactivate.

The implementation does not add:

- edit/delete `ActionIcon` controls;
- tiny destructive trash icons;
- edit/delete action columns;
- drag-and-drop controls.

Inline controls are grouped far-right where practical.

## Error Handling And Notifications

The manager uses Mantine notifications for mutation success and failure.

Specific error handling includes:

- `CONFLICT`: Product is already active in this Catalogue.
- `BAD_REQUEST`: server message is shown, including archived Catalogue/Product validation.
- `NOT_FOUND`: stale/missing record message is shown.
- `FORBIDDEN`: permission/feature access message is shown.
- Generic errors: clear fallback message is shown.

Mutation errors keep the Catalogue modal open and preserve form state.

## Loading / Empty / Error States

Loading states:

- Catalogue membership loading shows an inline loader.
- Product picker loading shows a loading placeholder.
- mutation controls are disabled while relevant mutations are pending.

Empty states:

- no memberships: `No Products in this Catalogue yet.`
- no eligible Products: `No eligible Products available to add.`
- picker search no matches: `No Products match this search.`

Error states:

- Catalogue detail loading errors show an inline alert in the membership section.
- mutation errors show notifications without closing the modal.

## Deliberately Not Implemented

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
- bulk membership actions;
- Product image/asset previews;
- Store availability rules;
- Project-specific product selection.

## Checks Run

### `npm run type-check`

Result: Pass.

### `npm run verify`

Initial sandboxed run failed because `tsx` could not create its temporary IPC pipe in the restricted sandbox:

```text
listen EPERM ... /var/folders/.../tsx-502/...pipe
```

The same command was rerun with approved escalation.

Result: Pass.

The escalated verification also ran the repository type check and passed.

## Manual Verification Checklist

### Catalogue Modal Integration

- Open `/app/fund/products`.
- Open the Catalogues tab.
- Create a Catalogue.
- Confirm the membership manager is not shown in create mode.
- Open an existing Catalogue row.
- Confirm the membership manager appears in edit mode.

### Product Picker

- Confirm archived Products do not appear.
- Confirm Products already active in the Catalogue do not appear.
- Confirm picker options show code, name, Workflow Class and price/currency.
- Confirm `No eligible Products available to add.` appears when appropriate.

### Add Product

- Add an eligible Product.
- Confirm it appears in the membership list.
- Confirm duplicate active add is prevented or shows a clear conflict message.
- Confirm Catalogue detail/list refresh after success.

### Deactivate / Remove

- Deactivate an active membership.
- Confirm the confirmation prompt appears.
- Confirm the row becomes inactive/muted after success.
- Confirm the membership is not hard deleted.

### Reactivate

- Toggle an inactive membership active.
- Confirm the row becomes active after success.
- Confirm archived Product/Catalogue validation errors are shown clearly if applicable.

### Reorder

- Add at least three Products.
- Confirm Move Up is disabled on the first row.
- Confirm Move Down is disabled on the last row.
- Move a Product up and refresh.
- Confirm order persists.
- Move a Product down and refresh.
- Confirm order persists.

### Archived Catalogue

- Archive a Catalogue.
- Open it in edit mode.
- Confirm membership controls are disabled.
- Confirm the muted archived notice appears.

### Pattern Compliance

- Confirm no tiny destructive trash icon appears.
- Confirm no edit/delete `ActionIcon` controls were added.
- Confirm no edit/delete actions column was added.
- Confirm inline controls do not accidentally trigger unrelated row/modal behaviour.

## Risks And Follow-Ups

- The manager is modal-friendly for modest Catalogue sizes. If tenants build very large Catalogues, a child page may be more ergonomic.
- The Product picker is client-side over the current Product list. Server-side search/pagination may be needed later.
- The Active switch can deactivate immediately, while the Deactivate button uses an explicit confirmation. If this feels too easy in testing, the switch-off path should be changed to confirmation-only.
- Catalogue activation may still fail if all memberships are inactive or Products are archived; this is expected API validation.

## Recommended Next Slice

Phase 1 Slice 1G - review and manual testing of Products/Catalogues administration before moving to Project schema planning.
