# FUND Phase 1 Slice 1J-B - Project Product Membership Manager Confirmation

## Slice Name

Phase 1 Slice 1J-B - Project Product Membership Manager.

## Date

2026-06-24

## Implementation Summary

Implemented the Project Product membership manager inside the existing Project child page Products tab.

This slice replaces the 1J-A read-only Products placeholder with a tenant-admin membership surface that can:

- add eligible Products to a Project;
- deactivate active Project Product memberships;
- reactivate inactive memberships where allowed;
- reorder Project Products with Move Up / Move Down controls;
- show active and inactive memberships;
- show Project Product snapshot values as the operational Project record;
- lock mutation controls after `CLOSED`, `COMPLETED` and `ARCHIVED`;
- refresh Project detail/list state after membership mutations so activation readiness updates.

This slice does not introduce Product editing inside the Project page.

## Files Changed

App repository:

- `src/modules/fund/components/projects/ProjectProductsManager.tsx`
- `src/modules/fund/components/projects/ProjectDetailPage.tsx`

Documentation repository:

- `docs/modules/fund/implementation/2026-06-24-phase-1-slice-1j-b-project-product-membership-manager-confirmation.md`

## Endpoints Used

Existing Slice 1I endpoints only:

- `fund.projects.get`
- `fund.projects.addProduct`
- `fund.projects.removeProduct`
- `fund.projects.setProductActive`
- `fund.projects.reorderProducts`
- `fund.products.list`

No routers, services, Zod schemas or tRPC endpoints were created or modified.

## Project Child Page Integration

The existing `/app/fund/projects/[id]` Products tab now renders `ProjectProductsManager`.

The Overview tab and activation-readiness panel remain on the same Project child page. Membership mutation success invalidates:

- `fund.projects.get({ id })`
- `fund.projects.list`

This keeps the Products tab and activation-readiness panel aligned with the current Project Product state.

## Product Picker Behaviour

The Product picker uses `fund.products.list` with `includeArchived: false`.

Eligible picker options:

- come from the current tenant by API scoping;
- are not archived;
- do not already have an active Project Product membership;
- do not have an inactive Workflow Class when that flag is available in the returned Product data.

The UI uses the existing Product status enum and service behaviour only. It does not introduce a new `available` state or new Product status rules.

Picker options display:

- Product code;
- Product name;
- Workflow Class code/name;
- price/currency where available.

Live Product data is used only for picker eligibility and selection.

## Membership List Behaviour

The membership list displays all current Project Product memberships, including inactive rows.

Rows display:

- Product code snapshot;
- Product name snapshot;
- Product short description snapshot where available;
- Workflow Class snapshot;
- snapshot price;
- snapshot VAT rate;
- snapshot currency;
- active/inactive status;
- archived source Product warning where nested Product data indicates the source Product is archived.

Inactive memberships are muted and remain visible by default.

## Add / Deactivate / Reactivate / Reorder Behaviour

Add:

- calls `fund.projects.addProduct`;
- clears the picker on success;
- invalidates Project detail/list queries.

Deactivate:

- user-facing label is `Deactivate`;
- calls `fund.projects.removeProduct`;
- asks for confirmation;
- keeps the snapshot row visible as inactive.

Reactivate:

- calls `fund.projects.setProductActive({ id, isActive: true })`;
- is shown for inactive rows when Project status allows mutation;
- is disabled when the source Product is archived in the current detail response.

Reorder:

- uses Move Up / Move Down buttons;
- does not use drag-and-drop;
- sends the full displayed membership id list to `fund.projects.reorderProducts`;
- disables Move Up for the first row and Move Down for the last row.

## Snapshot Display Strategy

Project Product snapshot values are treated as the operational Project record.

The UI uses wording such as:

- `Captured for this Project`
- `Snapshot Workflow Class`
- `Snapshot price`

Live Product values are not used to overwrite snapshot display values.

## Locked Project Status Behaviour

Membership mutation controls are enabled only for:

- `DRAFT`
- `ACTIVE`
- `PAUSED`

For these statuses, controls are disabled and a read-only notice is shown:

- `CLOSED`
- `COMPLETED`
- `ARCHIVED`

Locked controls include:

- Product picker;
- Add Product;
- Deactivate;
- Reactivate;
- Move Up;
- Move Down.

## Archived Product Behaviour

Archived Products are not eligible picker options.

Existing memberships linked to an archived source Product remain visible as historical/snapshot records. The row shows a `Source Product archived` badge and explanatory text.

Reactivation is disabled client-side for archived-linked inactive memberships, and the UI still handles server `BAD_REQUEST` responses if the server rejects a mutation.

## Error Handling

Membership mutations show Mantine notifications and keep the Project child page open.

Expected mappings:

- `CONFLICT`: Product is already active in this Project.
- `BAD_REQUEST`: server message is shown directly.
- `NOT_FOUND`: stale/missing Project, Product or membership message.
- `FORBIDDEN`: permission or FUND feature access message.
- fallback: clear generic save/update failure message.

## Loading / Empty / Error States

Implemented:

- picker loading placeholder;
- Product picker load warning while existing memberships remain visible;
- `No Products in this Project yet.`;
- `No eligible Products available to add.`;
- locked Project read-only notice;
- pending mutation disabling for relevant controls.

## Table / Action Pattern Compliance

The Products tab is a child-data manager, not a Product CRUD table.

Compliance notes:

- no Product editor UI was introduced;
- no live Product edit controls were introduced;
- no edit/delete `ActionIcon` buttons were added;
- no tiny destructive icon-only controls were added;
- inline actions use explicit labels: `Deactivate`, `Reactivate`, `Move Up`, `Move Down`;
- inline controls call `stopPropagation()`.

## Deliberately Not Implemented

This slice did not implement:

- Prisma schema edits;
- migrations;
- `db:push`;
- seed/reset commands;
- routers;
- services;
- Zod schemas;
- new tRPC endpoints;
- Product editing inside the Project page;
- Events;
- Stores;
- Orders;
- commerce;
- payments;
- commissions;
- dashboards;
- production batching;
- SeasonPro integration;
- marketplace exposure;
- media/asset workflows;
- lifecycle tables;
- lifecycle transition engine;
- organiser identity/account linking;
- Project Request/onboarding flows;
- AI workflows.

## Checks Run

- `npm run type-check` - passed.
- `npm run verify` - passed after rerunning outside the sandbox because the initial sandboxed run blocked `tsx` IPC pipe creation with `EPERM`.

## Manual Verification Checklist

- Open `/app/fund/projects/[id]`.
- Confirm Products tab loads.
- Confirm empty Project shows `No Products in this Project yet.`
- Confirm Product picker lists eligible non-archived Products.
- Confirm archived Products are not picker options.
- Confirm Products already active in the Project are not picker options.
- Confirm Product can be added to a Project.
- Confirm duplicate active membership shows a clear `CONFLICT` message.
- Confirm membership can be deactivated.
- Confirm inactive membership remains visible.
- Confirm inactive membership can be reactivated where allowed.
- Confirm archived-linked memberships remain visible as snapshot records.
- Confirm archived-linked inactive membership cannot be reactivated.
- Confirm Move Up and Move Down reorder memberships.
- Confirm reorder sends the full displayed membership id list.
- Confirm membership controls are disabled after `CLOSED`, `COMPLETED` and `ARCHIVED`.
- Confirm read-only notice appears after `CLOSED`, `COMPLETED` and `ARCHIVED`.
- Confirm snapshot labels and values display as captured Project values.
- Confirm activation-readiness panel updates after add/deactivate/reactivate.
- Confirm no Product edit UI exists inside the Project page.

## Risks / Follow-Ups

- Manual UI testing is still required with real tenant data and a migrated target environment.
- Product picker filtering depends on the existing Product status enum and returned Workflow Class `isActive` flag; no new status rules were added.
- Reorder uses the displayed full membership list, including inactive rows, to satisfy the Slice 1I service requirement.
- Future UX refinements may add a show/hide inactive toggle if membership lists become long.

## Recommended Next Slice

Phase 1 Slice 1K - Project Admin UI Review and Manual Testing.
