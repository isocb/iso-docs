# FUND Phase 1 Slice 1G - Products/Catalogues Review And Manual Testing

Date: 2026-06-23

Status: Planning only

Target branch:

```text
feature/fund-phase-1-products-catalogues
```

## Purpose

Slice 1G is a focused review and manual testing pass over the FUND Products/Catalogues foundation before moving to Project schema planning.

This slice should confirm that Slices 1C through 1F-B form a coherent, tenant-safe foundation:

```text
Product Workflow Classes
  -> Tenant-owned Products
  -> Tenant-owned Catalogues
  -> Catalogue/Product membership
  -> Admin UI for managing the above
```

This slice must not implement Project schema or introduce any new business domain.

## Source Context

Use these implementation confirmations:

- `implementation/2026-06-23-phase-1-slice-1c-product-workflow-classes-confirmation.md`
- `implementation/2026-06-23-phase-1-slice-1d-products-catalogues-confirmation.md`
- `implementation/2026-06-23-phase-1-slice-1e-products-catalogues-api-crud-confirmation.md`
- `implementation/2026-06-23-phase-1-slice-1f-a-products-catalogues-core-admin-ui-confirmation.md`
- `implementation/2026-06-23-phase-1-slice-1f-b-catalogue-product-membership-manager-confirmation.md`

Also use:

- active FUND docs in `isodocs/docs/modules/fund/`
- `docs/2026-IsoStack-Docs/Standards/ui-ux/isostack-ux-ui-standard.md`
- `docs/2026-IsoStack-Docs/Standards/ui-ux/table-crud-pattern.md`

## Implementation Boundary

Allowed:

- inspect code;
- inspect Prisma schema and migrations;
- inspect tRPC routers and services;
- run safe local checks;
- perform manual UI testing;
- document findings and fixes needed.

Not allowed:

- code edits;
- Prisma schema edits;
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
- media or asset workflows;
- production batching;
- dashboards;
- AI workflows.

## Review Outcome Options

The Slice 1G review should end with one of these recommendations:

1. `Proceed` - move to Project schema planning.
2. `Amend first` - fix specific low/medium issues, then proceed.
3. `Hold` - do not move to Project schema planning until blocking issues are resolved.

Blocking issues include:

- tenant data leakage;
- cross-tenant Catalogue/Product joins;
- mutation role checks missing;
- Product Workflow Class not enforced;
- unsafe status transition behaviour;
- broken archive/restore/activate flow;
- Product/Catalogue CRUD unusable in the admin UI;
- catalogue membership manager corrupting order or active state;
- persistent TypeScript or verification failures caused by FUND code.

## 1. Slice 1C Workflow Classes Review

Review items:

- `fund` Prisma schema is registered.
- `FundProductWorkflowClass` exists in the `fund` schema.
- Workflow classes are platform-level and do not include `organizationId`.
- A1, A2, B and C defaults are present in migration SQL.
- Defaults use `ON CONFLICT ("code") DO NOTHING`.
- Defaults are protected with:
  - `isSystemDefault = true`;
  - `isReadOnly = true`;
  - `isActive = true`.
- Behaviour flags match the confirmed Slice 1C table:
  - A1 requires template and artwork only;
  - A2 requires template, artwork and group artwork;
  - B requires personalisation data and production export;
  - C has no special requirements.
- `fund.workflowClasses.list` returns active classes only.
- No create/update/delete endpoint exists for workflow classes.

Manual tests:

- Open Product create modal.
- Confirm Workflow Class options are available.
- Confirm labels show code and name.
- Confirm Product cannot be saved without Workflow Class.

## 2. Slice 1D Product/Catalogue Schema Review

Review items:

- `FundProductStatus` and `FundCatalogueStatus` support `DRAFT`, `ACTIVE`, `ARCHIVED`.
- `FundProduct` includes required `organizationId`.
- `FundCatalogue` includes required `organizationId`.
- `FundCatalogueProduct` includes required `organizationId`.
- Product `code` is unique per tenant.
- Product `slug` is unique per tenant.
- Catalogue `code` is unique per tenant.
- Catalogue `slug` is unique per tenant.
- `FundProduct.workflowClassId` is required.
- Product-to-Workflow-Class relation uses delete restriction.
- Catalogue/Product join has same-tenant composite foreign keys.
- Product/Catalogue archive metadata exists.
- Media relations are absent by design.

Manual tests:

- Confirm Product cannot be created without a Workflow Class.
- Confirm duplicate Product code/slug in the same tenant returns a conflict.
- Confirm duplicate Catalogue code/slug in the same tenant returns a conflict.
- If a second tenant test account is available, confirm tenant A cannot see tenant B Products or Catalogues.

## 3. Slice 1E API/Services Review

Review items:

- All Product and Catalogue procedures use `withFeature('fund')`.
- Mutations require platform `OWNER` or `ADMIN`.
- API never accepts client-provided `organizationId`.
- Actor organization is derived server-side.
- Product and Catalogue reads are scoped by actor organization.
- Catalogue membership actions validate same-tenant Catalogue and Product.
- Archive and restore are soft-state changes, not hard deletes.
- Activation validates required Product/Catalogue readiness.
- Product price and VAT are serialized as API-safe numbers.
- Nested Product price and VAT in `catalogues.get` are serialized consistently.
- Prisma `P2002` races become shaped `CONFLICT` errors.
- Meaningful mutations write `AuditLog`.
- Reorder audit event logs against `FundCatalogue`, not misleading empty Product metadata.

Manual tests:

- Create Product.
- Update Product.
- Archive Product.
- Restore Product.
- Activate Product with valid price/workflow class.
- Attempt Product activation without price and confirm clear `BAD_REQUEST`.
- Create Catalogue.
- Update Catalogue.
- Archive Catalogue.
- Restore Catalogue.
- Attempt Catalogue activation with no active Product and confirm clear `BAD_REQUEST`.

## 4. Slice 1F-A Core Admin UI Review

Review items:

- `/app/fund/products` renders.
- Page title is `Products and Catalogues`.
- Products and Catalogues tabs render.
- Product table has required columns.
- Catalogue table has required columns.
- Create Product opens Product modal in create mode.
- Product row click opens Product modal in edit mode.
- Create Catalogue opens Catalogue modal in create mode.
- Catalogue row click opens Catalogue modal in edit mode.
- General Save does not directly mutate status.
- Archive/Restore/Activate are dedicated modal-level actions.
- Errors show notifications and keep modal data intact.

Manual tests:

- Open `/app/fund/products`.
- Confirm both tabs load without console errors.
- Create a draft Product.
- Edit a Product by clicking its row.
- Archive and restore a Product.
- Activate a Product after setting required price/workflow class data.
- Create a draft Catalogue.
- Edit a Catalogue by clicking its row.
- Archive and restore a Catalogue.

## 5. Slice 1F-B Catalogue Product Membership Manager Review

Review items:

- Manager appears only in edit mode for existing Catalogues.
- Manager does not appear while creating a new Catalogue.
- Current memberships come from `fund.catalogues.get`.
- Eligible Product picker uses `fund.products.list`.
- Archived Products are excluded from the picker.
- Products already active in the Catalogue are excluded from the picker.
- Inactive memberships remain visible in the membership list.
- Add Product calls `fund.catalogues.addProduct`.
- Deactivate/Remove calls `fund.catalogues.removeProduct`.
- Reactivation calls `fund.catalogues.setProductActive({ isActive: true })`.
- Active switch changes call `fund.catalogues.setProductActive`.
- Move Up/Move Down calls `fund.catalogues.reorderProducts`.
- Drag-and-drop is not implemented.
- Controls are disabled for archived Catalogues.
- Archived Catalogue notice is shown.
- No tiny destructive trash icons are used.
- No edit/delete ActionIcon controls are added.
- No edit/delete actions column exists.

Manual tests:

- Open an existing Catalogue.
- Confirm empty state: `No Products in this Catalogue yet.`
- Add one Product.
- Confirm Product appears in the membership list.
- Add two more Products.
- Move middle Product up.
- Move first Product down.
- Refresh and confirm order persists.
- Deactivate a Product.
- Confirm row becomes inactive and muted.
- Reactivate it with the Active switch.
- Archive the Catalogue.
- Confirm membership controls are disabled and archived notice appears.

## 6. Tenant Scoping Review

Review items:

- Product list only returns current tenant Products.
- Product get only returns current tenant Product.
- Catalogue list only returns current tenant Catalogues.
- Catalogue get only returns current tenant Catalogue.
- Membership add validates same-tenant Catalogue and Product.
- Membership remove validates same-tenant membership context.
- Membership reorder validates all membership ids belong to the current Catalogue and tenant.
- Membership set-active validates membership belongs to current tenant.
- UI does not pass or expose `organizationId`.

Manual tests if multiple tenants are available:

- Create Product in tenant A.
- Create Product in tenant B.
- Confirm tenant A cannot find tenant B Product.
- Create Catalogue in tenant A.
- Confirm tenant B cannot find tenant A Catalogue.
- Attempt cross-tenant Catalogue/Product membership through API tooling if safe and confirm rejection.

## 7. Workflow Class Handling Review

Review items:

- Product create requires `workflowClassId`.
- Product update validates changed `workflowClassId`.
- Product activation validates the workflow class exists and is active.
- UI displays Workflow Class as code and name.
- Workflow Class is selected from platform defaults.
- UI does not allow Workflow Class management.

Manual tests:

- Create one Product for each default class A1, A2, B and C.
- Confirm each class displays clearly in the Product table and Product modal.
- Confirm class displays in Catalogue membership rows.

## 8. Product/Catalogue Status Behaviour Review

Review items:

- New Products default to `DRAFT`.
- New Catalogues default to `DRAFT`.
- Status filter default is All current, excluding archived.
- Archived filter shows archived records.
- Restore returns records to `DRAFT`.
- Activate moves records to `ACTIVE`.
- General Save does not change status.

Manual tests:

- Create Product and confirm draft status.
- Activate Product and confirm active status.
- Archive Product and confirm hidden from All current.
- Filter Archived and confirm Product appears.
- Restore Product and confirm draft status.
- Repeat equivalent flow for Catalogue.

## 9. Archive / Restore / Activate Flow Review

Review items:

- Archive action is bottom-left in modal footer.
- Restore and Activate are modal-level actions.
- Archive does not hard delete Products or Catalogues.
- Product restore clears archive state and requires explicit activation.
- Catalogue restore clears archive state and requires explicit activation.
- Catalogue archive does not archive Products.
- Catalogue activation requires at least one active Product.
- Catalogue activation rejects archived Product membership.

Manual tests:

- Archive Product in a Catalogue and confirm Catalogue activation reacts correctly.
- Restore Product and reactivate if needed.
- Archive Catalogue and confirm membership controls are disabled.
- Restore Catalogue and confirm membership controls become usable.

## 10. Price / VAT / Currency Handling Review

Review items:

- Product draft can be saved without `unitPriceNet`.
- Product activation requires valid `unitPriceNet`.
- VAT accepts 0 through 100.
- Currency is a three-letter uppercase code.
- API serializes Decimal values to numbers.
- UI displays price using currency.
- UI displays VAT clearly.
- Catalogue membership picker/list displays price/currency.

Manual tests:

- Save draft Product with blank price.
- Attempt activation and confirm server validation error.
- Set price to 0 and confirm activation behaviour is acceptable.
- Set VAT to 0, 20 and 100 and confirm save.
- Attempt invalid VAT if UI allows and confirm validation prevents it.
- Confirm GBP/EUR/USD UI options work.

## 11. Catalogue Membership Flow Review

Review items:

- Add Product excludes active duplicates.
- Add Product can reactivate inactive membership only through intentional UI path.
- Deactivate is soft and does not hard delete.
- Inactive membership remains visible.
- Reactivate works when Product and Catalogue are not archived.
- Reorder persists by membership id list.
- Move Up disabled on first row.
- Move Down disabled on last row.
- Archived Catalogue disables all membership controls.

Manual tests:

- Add Product A, B and C to Catalogue.
- Confirm order A, B, C.
- Move C up twice and refresh.
- Confirm order C, A, B.
- Deactivate A.
- Confirm A remains visible as inactive.
- Reactivate A.
- Archive Product B and confirm activation/reactivation errors surface if applicable.

## 12. Table CRUD Pattern Compliance Review

Review items:

- Product table row click opens modal.
- Catalogue table row click opens modal.
- No edit/delete ActionIcon buttons appear in parent tables.
- No edit/delete actions column exists in parent tables.
- Archive action is in modal footer.
- Tables show pointer cursor/hover feedback.
- Fuzzy search exists for Product and Catalogue tables.
- Sort selector exists.
- Sort direction toggle exists.
- Default sort is Code ascending.
- Row click payload is normalized with `params?.record ?? params`.
- Inline membership controls use `stopPropagation()`.
- Inline membership controls are non-destructive where practical and far-right.

Manual tests:

- Click around Product table row and confirm modal opens.
- Click around Catalogue table row and confirm modal opens.
- Confirm no accidental modal close/open occurs from membership controls.
- Confirm search and sorting work on both parent tables.

## 13. Error Handling And Notifications Review

Review items:

- Success notifications appear for create/update/archive/restore/activate.
- Success notifications appear for add/deactivate/reactivate/reorder membership.
- Mutation errors keep modal data intact.
- `CONFLICT` messages are clear.
- `BAD_REQUEST` messages expose server validation where useful.
- `NOT_FOUND` stale/missing record messaging is understandable.
- `FORBIDDEN` messaging is understandable.
- Generic errors have a clear fallback.

Manual tests:

- Trigger duplicate Product code/slug conflict.
- Trigger duplicate Catalogue code/slug conflict.
- Trigger Product activation missing price.
- Trigger Catalogue activation with no active Product.
- Trigger duplicate active Product membership if possible.
- Confirm modal stays open after each error.

## 14. Query Invalidation And Stale State Review

Review items:

- Product mutations invalidate Product list and detail as appropriate.
- Catalogue mutations invalidate Catalogue list and detail as appropriate.
- Membership mutations invalidate Catalogue detail.
- Membership mutations invalidate Catalogue list so Product Count updates.
- Product picker clears selected Product after add.
- Archived state changes reflect in tables after mutation.
- Detail modal is not populated from stale pre-mutation data after success.

Manual tests:

- Add Product to Catalogue and confirm Product Count updates after close/refresh.
- Deactivate membership and confirm picker/list state updates.
- Reactivate membership and confirm picker/list state updates.
- Archive Product and confirm Product table status/filter state updates.
- Restore Product and confirm Product table status/filter state updates.

## 15. Known Limitations

Known and acceptable before Project schema planning:

- Product/Catalogue search and sort are client-side over current API result sets.
- Catalogue membership manager is modal-based and may need a child page for large Catalogues later.
- Product media/assets are deferred.
- Catalogue media/assets are deferred.
- Product sharing and AMOW marketplace exposure are deferred.
- FUND-specific module roles are deferred; current mutation access uses platform `OWNER`/`ADMIN`.
- No Project, Event, Store or Order schema exists yet.
- Catalogue activation may fail until at least one active Product membership exists.
- Currency UI is currently limited to common options while API validates generic three-letter codes.

Potential issue to inspect:

- Confirm Active switch off behaviour uses the intended confirmation path. If switching off bypasses confirmation, either document as acceptable or amend before promotion.

## 16. Fixes Required Before Project Schema Planning

Record findings in this section during review.

Use this severity model:

- `Blocker`: must fix before Project schema planning.
- `Important`: should fix before Project schema implementation, but planning may continue if documented.
- `Minor`: can be deferred.

Initial expected fixes:

- None known from implementation confirmations.

Review placeholders:

| Severity | Area | Finding | Recommended Action | Blocks Project Schema Planning |
| --- | --- | --- | --- | --- |
| TBD | TBD | TBD | TBD | TBD |

## 17. Recommendation Gate

At the end of Slice 1G, write one of:

### Proceed

Use when:

- all blocking checks pass;
- tenant safety is confirmed;
- Product/Catalogue workflows are usable enough;
- known limitations are documented and do not affect Project schema planning.

Recommended next slice:

```text
FUND Phase 1 Slice 1H - Project Schema Planning
```

### Amend First

Use when:

- minor or medium defects exist in Products/Catalogues administration;
- defects are fixable without changing the fundamental model;
- Project schema planning would be clearer after the fixes.

Document:

- exact fixes;
- files likely to change;
- manual retest scope.

### Hold

Use when:

- tenant scoping is unsafe;
- schema constraints are wrong;
- workflow class model is incorrect;
- Product/Catalogue API cannot be trusted;
- admin UI is not usable enough to validate the foundation;
- tests/checks fail due to FUND code.

Do not proceed to Project schema planning until hold issues are resolved.

## Recommended Slice 1G Execution Prompt

```text
Proceed with FUND Phase 1 Slice 1G execution: Products/Catalogues administration review and manual testing.

Work on:
feature/fund-phase-1-products-catalogues

Do not edit code unless explicitly asked after reporting findings.
Do not edit Prisma schema.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.
Do not create Projects, Events, Stores, Orders, commerce, payments, commissions, SeasonPro integration, cross-tenant sharing, AMOW marketplace exposure, media/asset workflows, production batching, dashboards or AI workflows.

Use:
- isodocs/docs/modules/fund/Planning/2026-06-23-fund-phase-1-slice-1g-products-catalogues-review-and-manual-testing.md
- Slices 1C, 1D, 1E, 1F-A and 1F-B confirmation documents
- active FUND docs
- IsoStack UI standards

Perform a targeted code review and manual testing pass over Products/Catalogues administration.

Report:
1. Findings by severity.
2. Manual tests completed.
3. Checks run.
4. Known limitations.
5. Recommendation: Proceed, Amend first or Hold.
6. If Amend first, provide exact fix scope.
```
