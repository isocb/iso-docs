# Phase 1 Slice 1F-A - Products and Catalogues Core Admin UI Confirmation

## Date

2026-06-23

## Slice Name

Phase 1 Slice 1F-A - Products and Catalogues Core Admin UI

## Implementation Summary

Implemented the core FUND Products and Catalogues admin surface at `/app/fund/products`.

The page provides two tabs:

- Products
- Catalogues

Each tab uses a table CRUD pattern where rows open create/edit modals, status changes are handled through dedicated modal footer actions, and table rows do not contain edit/delete action buttons.

Catalogue Product membership management was deliberately deferred to Slice 1F-B.

## Files Changed

- `src/app/(app)/app/fund/products/page.tsx`
- `src/modules/fund/components/products/ProductTable.tsx`
- `src/modules/fund/components/products/ProductModal.tsx`
- `src/modules/fund/components/catalogues/CatalogueTable.tsx`
- `src/modules/fund/components/catalogues/CatalogueModal.tsx`
- `src/modules/fund/components/shared/FundStatusBadge.tsx`
- `src/modules/fund/components/shared/FundTableControls.tsx`
- `src/modules/fund/lib/ui/formatters.ts`

## Components Created

### Products

- `ProductTable`
- `ProductModal`

### Catalogues

- `CatalogueTable`
- `CatalogueModal`

### Shared UI Helpers

- `FundStatusBadge`
- `FundTableControls`

### Formatting Helpers

- `formatMoney`
- `formatVatRate`
- `formatDateTime`
- `compareSortValues`
- `normalizeRowClick`

## tRPC Endpoints Used

### Products

- `fund.products.list`
- `fund.products.get`
- `fund.products.create`
- `fund.products.update`
- `fund.products.activate`
- `fund.products.archive`
- `fund.products.restore`

### Catalogues

- `fund.catalogues.list`
- `fund.catalogues.get`
- `fund.catalogues.create`
- `fund.catalogues.update`
- `fund.catalogues.activate`
- `fund.catalogues.archive`
- `fund.catalogues.restore`

### Workflow Classes

- `fund.workflowClasses.list`

## Table CRUD Pattern Compliance

- Row click opens the relevant CRUD modal.
- Mantine DataTable row click payloads are normalised through `params?.record ?? params`.
- No edit/delete `ActionIcon` buttons were added to table rows.
- No edit/delete actions column was added.
- Destructive Archive actions are placed bottom-left in modal footers.
- Restore and Activate are also modal-level actions.
- Cancel and Save are placed on the right of modal footers.
- Tables use pointer cursor feedback for clickable rows.
- Universal fuzzy search is included on Products and Catalogues.
- Status filtering is included on Products and Catalogues.
- Sort selector and sort direction toggle are included on Products and Catalogues.
- Default sort is Code ascending.

## Status, Archive, Restore and Activate UX

- Products and Catalogues are created as draft records through the existing API.
- General Save updates descriptive fields and does not directly mutate status.
- Archive uses the dedicated archive endpoint.
- Restore uses the dedicated restore endpoint.
- Activate uses the dedicated activate endpoint.
- API errors are shown through notifications and keep modal data intact.
- Activation errors from the API are surfaced clearly, including product readiness or catalogue membership readiness failures.
- Successful mutations invalidate relevant tRPC list/detail queries and close the modal.

## Search, Sort and Filter Behaviour

### Search

- Products search across code, name, slug, description and workflow class labels.
- Catalogues search across code, name, slug and description.
- Search is client-side fuzzy search over the current API result set.

### Status Filter

- All current
- Draft
- Active
- Archived

The default is All current, which excludes archived records.

### Sorting

Products can be sorted by:

- Code
- Name
- Workflow Class
- Status
- Price
- VAT
- Currency
- Featured
- Sort Order
- Updated

Catalogues can be sorted by:

- Code
- Name
- Status
- Product Count
- Featured
- Sort Order
- Updated

Sort direction can be toggled ascending or descending.

## Validation Approach

Client-side validation mirrors Slice 1E constraints where practical:

- Code is required and limited to 64 characters.
- Name is required and limited to 160 characters.
- Slug is required, lower-case URL-safe and limited to 96 characters.
- Product Workflow Class is required for Products.
- Product unit price must be non-negative when supplied.
- VAT must be between 0 and 100.
- Currency must be a three-letter uppercase ISO-style code.

Server-side Slice 1E validation remains authoritative.

## Catalogue Membership Management

Catalogue Product membership management was not implemented in Slice 1F-A.

It is deferred to Slice 1F-B for review and implementation as a separate surface or modal section.

## Deliberately Not Implemented

- Catalogue Product membership manager
- Projects
- Events
- Stores
- Orders
- Commerce
- Payments
- Commissions
- SeasonPro integration
- Cross-tenant sharing
- AMOW marketplace exposure
- Media or asset workflows
- Dashboards
- Production batching
- AI workflows
- Prisma schema changes
- Migrations
- Seed/reset commands
- `db:push`

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

- Open `/app/fund/products`.
- Confirm Products and Catalogues tabs render.
- Confirm Products tab defaults to All current and Code ascending.
- Confirm Catalogues tab defaults to All current and Code ascending.
- Confirm archived records are hidden by default.
- Confirm fuzzy search filters Products.
- Confirm fuzzy search filters Catalogues.
- Confirm sort selector and sort direction toggle work on both tabs.
- Create a draft Product with a valid workflow class.
- Edit an existing Product from row click.
- Confirm Product Save does not directly mutate status.
- Confirm Product Archive is bottom-left in the modal footer.
- Confirm Product Restore and Activate are modal-level actions.
- Confirm Product activation errors are shown clearly when server validation fails.
- Create a draft Catalogue.
- Edit an existing Catalogue from row click.
- Confirm Catalogue Save does not directly mutate status.
- Confirm Catalogue Archive is bottom-left in the modal footer.
- Confirm Catalogue Restore and Activate are modal-level actions.
- Confirm Catalogue activation errors are shown clearly when server validation fails.
- Confirm no edit/delete action icons appear in table rows.
- Confirm Catalogue Product membership management is not present in 1F-A.

## Risks and Follow-Ups

- Product and Catalogue tables currently perform fuzzy search and sorting client-side over the current API result set. This is suitable for Slice 1F-A but may need server-side pagination/search later if tenants hold large catalogues.
- Currency choices are intentionally limited to common options in the UI. The API supports three-letter uppercase currency values.
Known expected limitation:
- Catalogue activation may fail in 1F-A because Catalogue Product membership management is deliberately deferred to 1F-B. This is expected and not a blocker for 1F-A acceptance.
- No navigation sidebar wiring was added in this slice; the route is available directly at `/app/fund/products`.

## Recommended Next Slice

Phase 1 Slice 1F-B - Catalogue Product membership manager.
