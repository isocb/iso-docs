# FUND Phase 1 Slice 1J-B - Project Product Membership Manager Proposal

Date: 2026-06-24

Status: Planning only

Target branch:

```text
feature/fund-phase-1-products-catalogues
```

## Source Context

This proposal follows:

- `isodocs/docs/modules/fund/Planning/2026-06-23-fund-phase-1-slice-1j-project-admin-ui-proposal.md`
- `isodocs/docs/modules/fund/implementation/2026-06-24-phase-1-slice-1j-a-project-list-child-management-shell-confirmation.md`
- `isodocs/docs/modules/fund/implementation/2026-06-23-phase-1-slice-1i-project-api-services-confirmation.md`
- `docs/2026-IsoStack-Docs/Standards/ui-ux/isostack-ux-ui-standard.md`
- `docs/2026-IsoStack-Docs/Standards/ui-ux/table-crud-pattern.md`

Slice 1J-A has already implemented the Project list, Project child page, Overview tab, status actions and activation-readiness panel. Slice 1J-B should fill the existing Project child page Products tab with Project Product membership management.

## 1. Slice Goal

Implement the Project Product membership manager inside the existing Project child page Products tab.

The goal is to let a tenant admin select which tenant-owned Products belong to a Project while preserving FUND's architecture:

```text
Project is the operational centre.
Products support Projects.
Stores, Orders, commerce, Events and dashboards remain later layers.
```

This is not a Product editing surface. It is a Project membership surface that uses Product records as selectable inputs and displays Project Product snapshot data as the operational Project record.

## 2. Implementation Boundary

Allowed in Slice 1J-B implementation:

- Replace the 1J-A read-only Products placeholder with a Project Product membership manager.
- Use existing Project/Product API endpoints only.
- Add Product to Project.
- Deactivate Project Product membership.
- Reactivate inactive membership when allowed by the API.
- Reorder Project Product memberships with Move Up / Move Down controls.
- Display active and inactive memberships.
- Display Project Product snapshot values.
- Refresh Project detail and Project list queries after mutations.
- Refresh the activation-readiness panel state after membership mutations.

Not allowed in Slice 1J-B:

- Application schema edits.
- Prisma schema edits.
- migrations.
- `db:push`.
- seed/reset commands.
- new routers, services, Zod schemas or tRPC endpoints.
- Product editor UI inside the Project page.
- live Product edit controls.
- Events.
- Stores.
- Orders.
- commerce.
- payments.
- commissions.
- dashboards.
- production batching.
- SeasonPro integration.
- marketplace exposure.
- media/asset workflows.
- lifecycle tables.
- lifecycle transition engine.
- organiser identity/account linking.
- Project Request/onboarding flows.
- AI workflows.

## 3. Project Child Page Integration

Integrate 1J-B into the existing route:

```text
/app/fund/projects/[id]
```

The existing `ProjectDetailPage` already includes:

- Overview tab.
- Products tab.
- `fund.projects.get` Project detail query.
- activation-readiness panel based on Project detail data.
- status action controls.

Slice 1J-B should replace the Products tab placeholder with a dedicated component, for example:

```text
src/modules/fund/components/projects/ProjectProductsManager.tsx
```

The manager should receive the current Project detail object or `projectId`, and should reuse the same Project detail query where practical. It should not create a separate child route unless implementation discovers the tab becomes too dense for the current page.

Recommended integration:

- Keep the Products tab inside `ProjectDetailPage`.
- Render the membership manager only when Project detail data exists.
- Keep the Overview tab unchanged apart from benefiting from query invalidation after membership changes.
- Use Project status to lock or enable controls.

## 4. Product Picker Design

Use a compact picker at the top of the Products tab for Projects that allow membership mutation.

Recommended UI:

- Searchable Select or Combobox fed by `fund.products.list`.
- Display Product code, Product name, Workflow Class and price/currency where available.
- Include a clear Add Product button beside or below the picker.
- Disable Add until a Product is selected.
- Show loading state while Products are fetched.
- Show "No eligible Products available to add" when nothing can be selected.

Picker option wording should make the source clear:

```text
{product.code} - {product.name} ({workflowClass.code}) - {currency} {price}
```

The picker should use live Product data only for eligibility and selection. It must not edit Products and must not overwrite Project Product snapshots directly.

## 5. Eligible Product Filtering

Use `fund.products.list` for the picker source.

Eligible Products:

- belong to the current tenant by API scoping;
- are not archived;
- are active/available according to Product status rules;
- are not already active in the Project.

When interpreting Product status/eligibility, use the existing Product status enum and service behaviour only. Do not introduce a new `available` state or new Product status rules in this slice.

Products excluded from the picker:

- archived Products;
- Products already represented by an active Project Product membership;
- Products the API later rejects as invalid.

Inactive Project Product memberships require care:

- If the same Product has an inactive membership, adding that Product may be treated by the API as reactivation.
- The UI can either show it as a Reactivate action in the membership list, or allow picker selection and rely on `fund.projects.addProduct` to reactivate.
- Recommendation: prefer explicit Reactivate action in the membership list so users understand they are restoring an existing Project membership.

## 6. Add Product To Project

Endpoint:

```text
fund.projects.addProduct
```

Expected behaviour:

- User selects an eligible Product.
- User clicks Add Product.
- UI calls `fund.projects.addProduct` with Project id and Product id.
- API snapshots Product and Workflow Class data into the Project Product row.
- UI clears selected Product on success.
- UI shows success notification.
- UI invalidates:
  - `fund.projects.get({ id })`
  - `fund.projects.list`
  - Product picker query if active eligibility has changed.

The UI must not collect or send workflow class ids. The service derives Workflow Class from the selected Product.

## 7. Deactivate Project Product Membership

Endpoint:

```text
fund.projects.removeProduct
```

User-facing action label:

```text
Deactivate
```

Reasoning:

- The service uses soft removal by setting `isActive = false`.
- The membership remains visible for Project history and snapshot context.
- "Deactivate" is more accurate than "Delete".

Recommended UX:

- Use an explicit Button/Menu item, not a tiny destructive icon-only button.
- Ask for confirmation if the action is visually destructive or may affect activation readiness.
- On success, show notification and invalidate Project detail/list queries.
- Keep the Project child page open.

## 8. Reactivate Inactive Membership

Endpoint:

```text
fund.projects.setProductActive
```

Input:

```text
{ projectId, membershipId, isActive: true }
```

Expected behaviour:

- Show Reactivate only for inactive memberships when the Project status allows mutation.
- On success, show notification and invalidate Project detail/list queries.
- Service refreshes snapshots from the current Product and Workflow Class on reactivation, according to Slice 1I confirmation.
- UI should explain that reactivation captures current Product details again if useful in helper text.

Do not allow reactivation if the API rejects archived Product, invalid status, missing Product or inactive Workflow Class rules.

## 9. Reorder With Move Up / Move Down

Endpoint:

```text
fund.projects.reorderProducts
```

Use simple Move Up / Move Down controls. Do not implement drag-and-drop in this slice.

Rules:

- Reorder should send the full membership id list for the Project.
- Preserve the list's current active/inactive membership set unless the service expects all current membership rows.
- Recommendation: send every current Project Product membership id in the displayed order, matching Slice 1I's full-list requirement.
- Move Up disabled for the first row.
- Move Down disabled for the last row.
- Reorder disabled after `CLOSED`, `COMPLETED` and `ARCHIVED`.

On success:

- show success notification;
- invalidate Project detail query;
- invalidate Project list query if Product counts or readiness summaries may change.

## 10. Active / Inactive Membership Display

Membership list should show:

- Product code snapshot.
- Product name snapshot.
- Workflow Class snapshot.
- Snapshot price.
- Snapshot VAT rate.
- Snapshot currency.
- Active/Inactive badge.
- Archived/live Product warning where nested Product status indicates archived.
- Move Up / Move Down controls.
- Deactivate or Reactivate action where allowed.

Active memberships:

- display normally;
- show Active badge.

Inactive memberships:

- display muted;
- show Inactive badge;
- remain visible by default so Project history is understandable.

Do not hide inactive memberships behind a default filter in this first slice. If list length becomes a problem later, add a simple "show inactive" toggle in a later refinement.

## 11. Read-Only / Disabled State After Closed, Completed And Archived

Membership mutation controls are allowed only for:

- `DRAFT`
- `ACTIVE`
- `PAUSED`

For these statuses, hide or disable all mutation controls:

- `CLOSED`
- `COMPLETED`
- `ARCHIVED`

Locked controls:

- add picker;
- Add Product button;
- Deactivate action;
- Reactivate action;
- Move Up;
- Move Down.

Show a clear read-only notice:

```text
Project Product membership is locked while this Project is {status}. Snapshot records remain visible for operational history.
```

Do not rely only on server rejection. The UI should make the locked state obvious, while still handling server `BAD_REQUEST` responses.

## 12. Snapshot Display Wording

Project Product snapshot values are the operational display record for the membership list.

Use wording that makes this clear:

- Captured for this Project.
- Snapshot price.
- Snapshot Workflow Class.
- Snapshot Product name.

Snapshot fields to display where present:

- `productCodeSnapshot`
- `productNameSnapshot`
- `productShortDescriptionSnapshot`
- `workflowClassCodeSnapshot`
- `workflowClassNameSnapshot`
- `unitPriceNetSnapshot`
- `vatRateSnapshot`
- `currencySnapshot`

Live Product data may be used for picker eligibility and warnings only. It should not replace snapshot display values in the membership list.

## 13. Archived Product Behaviour

Archived Products must not appear as eligible add options.

Existing Project Product memberships linked to archived Products should remain visible as historical/snapshot records.

Archived-linked memberships:

- show a warning or muted badge such as `Source Product archived`;
- keep snapshot values visible;
- explain that the record remains visible because it was captured for this Project;
- should not be reactivated if the API blocks reactivation.

The UI should surface the server response clearly if reactivation or activation readiness is blocked by archived Product rules.

## 14. Activation Readiness Interaction

Project Product membership directly affects activation readiness.

After these mutations:

- add Product;
- deactivate membership;
- reactivate membership;
- reorder memberships;

invalidate and refresh:

- `fund.projects.get({ id })`
- `fund.projects.list`

The existing 1J-A activation-readiness panel reads from `fund.projects.get`; refreshing Project detail ensures:

- active Product count updates;
- archived Product blockers update;
- inactive Workflow Class blockers update;
- Activate button enabled/disabled state updates.

The client may show immediate optimistic disabled/loading states, but the server remains authoritative.

## 15. Query Invalidation

Use `trpc.useUtils()`.

On every successful membership mutation:

```text
utils.fund.projects.get.invalidate({ id: projectId })
utils.fund.projects.list.invalidate()
utils.fund.products.list.invalidate() // if picker eligibility may be stale
```

Recommendation:

- Always invalidate Project detail.
- Always invalidate Project list because Product counts/readiness summaries can affect list data.
- Invalidate Product list after add/reactivate/deactivate only if implementation caches filtered picker state in a way that might remain stale. If the picker filters from fresh Project detail and existing Product list, Product list invalidation may be optional.

On `NOT_FOUND`, refresh Project detail and list after showing the stale-record notification.

## 16. Error Handling

Use Mantine notifications and keep the Project page open.

Map expected tRPC errors:

| Code | User-facing handling |
| --- | --- |
| `CONFLICT` | Product is already active in this Project. Refresh the Project and try again. |
| `BAD_REQUEST` | Show the server message, especially invalid Project status, archived Product, invalid reorder list or activation-readiness related messages. |
| `NOT_FOUND` | The Project, Product or membership no longer exists or is no longer available. Refresh the Project data. |
| `FORBIDDEN` | You do not have permission or FUND access for this action. |
| fallback | The membership change could not be saved. Please try again. |

Do not close the Project page or reset unrelated form state after errors.

## 17. Loading / Empty / Error States

Products tab states:

- Project detail loading: inherit child page loading state.
- Product picker loading: show disabled picker or loader.
- Membership mutation pending: disable relevant row/action controls.
- Empty membership list: `No Products in this Project yet.`
- No eligible Products: `No eligible Products available to add.`
- Locked Project: show read-only notice and keep membership list visible.
- Error loading Products: show retry action for picker source.
- Error mutating membership: notification plus data refresh where appropriate.

The membership list should still render existing Project Product rows if the picker Product list fails to load.

## 18. Table / Action Pattern Compliance

This tab is a child-data manager, not a table-to-CRUD surface.

Apply the table/action standards as follows:

- Do not create a Product editor inside the Project page.
- Do not expose live Product edit controls.
- Do not add edit/delete `ActionIcon` controls.
- Avoid tiny destructive icon-only buttons.
- Use explicit user-facing action labels: `Deactivate`, `Reactivate`, `Move Up`, `Move Down`.
- Place row actions far-right where practical.
- Call `event.stopPropagation()` from inline controls if the row itself becomes clickable.
- Keep destructive-looking actions separated and confirmed where needed.
- Prefer simple table/list layout with stable columns and readable snapshot labels.

If the membership table uses sortable headers later, follow the current table sort/reverse-sort guidance. Sorting is optional in this slice because reorder order is operationally meaningful.

## 19. Manual Test Checklist

### Products Tab

- Products tab loads inside `/app/fund/projects/[id]`.
- Products tab uses Project detail from `fund.projects.get`.
- Existing memberships display active and inactive rows.
- Empty Project shows `No Products in this Project yet.`

### Product Picker

- Picker lists eligible non-archived Products.
- Archived Products are not eligible add options.
- Active Project Products are excluded from add options.
- No eligible Products state says `No eligible Products available to add.`
- Picker displays Product code, Product name, Workflow Class and price/currency.

### Add / Deactivate / Reactivate

- Product can be added to a Project.
- Duplicate active membership shows clear `CONFLICT` message.
- Membership can be deactivated.
- Inactive membership can be reactivated when allowed.
- Reactivation refreshes snapshot values from the current Product and Workflow Class.
- Archived-linked memberships remain visible as historical/snapshot records.
- Archived-linked memberships are not reactivated if the API blocks reactivation.

### Reorder

- Move Up works for rows after the first row.
- Move Down works for rows before the last row.
- Move Up is disabled for the first row.
- Move Down is disabled for the last row.
- Reorder sends the full membership id list.
- Reorder preserves active/inactive membership visibility.

### Locked Statuses

- Membership mutations are enabled for `DRAFT`, `ACTIVE` and `PAUSED`.
- Membership mutations are hidden or disabled for `CLOSED`, `COMPLETED` and `ARCHIVED`.
- Read-only notice appears for `CLOSED`, `COMPLETED` and `ARCHIVED`.

### Snapshot / Readiness

- Snapshot values display as captured Project values, not live Product edit values.
- Snapshot labels use wording such as `Captured for this Project`, `Snapshot price` and `Snapshot Workflow Class`.
- Activation readiness panel/state refreshes after add, deactivate and reactivate.
- Activation readiness panel still treats server validation as authoritative.

### Pattern Compliance

- No Product edit UI is introduced inside the Project page.
- No live Product edit controls are present.
- No tiny destructive icon-only controls are introduced.
- Inline controls use explicit labels and `stopPropagation()` where row click exists.

## 20. Deliberately Out Of Scope

Slice 1J-B must not implement:

- Project schema changes.
- Product schema changes.
- Prisma migrations.
- `db:push`.
- seed/reset commands.
- routers.
- services.
- Zod schemas.
- new tRPC endpoints.
- Product CRUD editing inside the Project page.
- Event schema or Event-linked Project constraints.
- Stores.
- Orders.
- commerce.
- payments.
- commissions.
- dashboards.
- production batching.
- SeasonPro integration.
- marketplace exposure.
- media/asset workflows.
- lifecycle tables.
- lifecycle transition engine.
- organiser identity/account linking.
- Project Request/onboarding flows.
- AI workflows.

## 21. Risks And Recommendations

### Risk: Snapshot Confusion

Users may assume membership rows show live Product details. Mitigation: use explicit snapshot wording and avoid linking directly into Product edit controls from this manager.

### Risk: Overloading The Project Page

The Products tab could become dense. Mitigation: keep 1J-B to picker, membership list and simple actions only. Defer advanced filtering, drag-and-drop, bulk operations and Product editing.

### Risk: Archived Source Product Edge Cases

Archived Products may exist in historic Project memberships. Mitigation: keep rows visible, mark source Product archived and rely on the API for reactivation rules.

### Risk: Readiness State Staleness

Activation readiness may not update if queries are not invalidated correctly. Mitigation: invalidate Project detail after every membership mutation and keep readiness sourced from `fund.projects.get`.

### Risk: Reorder Payload Errors

The API expects a full membership id list. Mitigation: generate reorder payload from the currently displayed full membership list and test list completeness.

Recommendation: proceed to Slice 1J-B implementation after this plan is accepted. Keep the implementation to a single Project Products manager component plus a small integration change in `ProjectDetailPage`.

## 22. Recommended Implementation Prompt For 1J-B

```text
Proceed with FUND Phase 1 Slice 1J-B implementation: Project Product membership manager.

Work on:
feature/fund-phase-1-products-catalogues

Before editing, read:
- isodocs/docs/modules/fund/Planning/2026-06-24-fund-phase-1-slice-1j-b-project-product-membership-manager-proposal.md
- isodocs/docs/modules/fund/implementation/2026-06-24-phase-1-slice-1j-a-project-list-child-management-shell-confirmation.md
- isodocs/docs/modules/fund/implementation/2026-06-23-phase-1-slice-1i-project-api-services-confirmation.md
- docs/2026-IsoStack-Docs/Standards/ui-ux/isostack-ux-ui-standard.md
- docs/2026-IsoStack-Docs/Standards/ui-ux/table-crud-pattern.md

Implement only the Project Product membership manager inside the existing Project child page Products tab.

Use only existing endpoints:
- fund.projects.get
- fund.projects.addProduct
- fund.projects.removeProduct
- fund.projects.setProductActive
- fund.projects.reorderProducts
- fund.products.list

Create:
- src/modules/fund/components/projects/ProjectProductsManager.tsx

Update:
- src/modules/fund/components/projects/ProjectDetailPage.tsx

Requirements:
- Display Project Product snapshot values as the operational membership record.
- Use live Product data only for picker eligibility.
- Add eligible non-archived Products.
- Exclude archived Products and already active Project Products from picker.
- Show active and inactive memberships.
- Deactivate memberships through fund.projects.removeProduct.
- Reactivate inactive memberships through fund.projects.setProductActive.
- Reorder with Move Up / Move Down controls using the full membership id list.
- Disable or hide all mutation controls after CLOSED, COMPLETED and ARCHIVED.
- Show a clear read-only notice for locked Project statuses.
- Invalidate Project detail and Project list queries after membership mutations.
- Refresh activation-readiness state after membership mutations.
- Map CONFLICT, BAD_REQUEST, NOT_FOUND, FORBIDDEN and generic errors to clear notifications.
- Avoid tiny destructive icon-only controls.
- Do not introduce Product edit UI.
- When interpreting Product status/eligibility, use the existing Product status enum and service behaviour only; do not introduce a new "available" state or new status rules.

Do not edit Prisma schema.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.
Do not create or modify routers, services, Zod schemas or tRPC endpoints.
Do not create Events, Stores, Orders, commerce, payments, commissions, dashboards, production batching, SeasonPro integration, marketplace exposure, media/asset workflows, lifecycle tables, lifecycle transition engine, organiser identity/account linking, Project Request/onboarding flows or AI workflows.

Run:
- npm run type-check
- npm run verify

Create confirmation document:
isodocs/docs/modules/fund/implementation/2026-06-24-phase-1-slice-1j-b-project-product-membership-manager-confirmation.md

The confirmation document should include:
- slice name and date;
- implementation summary;
- files changed;
- endpoints used;
- Project child page integration;
- Product picker behaviour;
- membership list behaviour;
- add/deactivate/reactivate/reorder behaviour;
- snapshot display strategy;
- locked Project status behaviour;
- archived Product behaviour;
- query invalidation/readiness refresh;
- error handling;
- deliberately out-of-scope items;
- checks run and results;
- manual verification checklist;
- risks/follow-ups;
- recommended next slice.
```
