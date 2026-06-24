# FUND Phase 1 Slice 1K - Project Admin UI Review And Manual Testing

Date: 2026-06-24

Status: Planning only

Target branch:

```text
feature/fund-phase-1-products-catalogues
```

## 1. Slice Goal

Slice 1K is a focused review and manual testing pass over the Project Admin UI foundation before FUND moves on to Events, Project Requests, Stores, organiser dashboards or commerce.

It covers Slice 1J-A and Slice 1J-B together because they now form one operational Project workflow:

- Project list;
- Project create;
- Project child management page;
- Overview/edit details;
- status transitions;
- activation-readiness panel;
- Project Product membership add/deactivate/reactivate/reorder;
- snapshot-vs-live Product display;
- locked states after `CLOSED`, `COMPLETED` and `ARCHIVED`.

The output should be a review result and recommendation:

```text
Proceed, Amend first, or Hold.
```

## 2. Implementation Boundary

Slice 1K is not a feature slice.

Allowed:

- targeted code review;
- manual browser testing;
- tRPC behaviour inspection;
- branch/commit readiness checks;
- documenting findings;
- small fixes only if explicitly approved after findings are reported.

Not allowed unless explicitly approved after review:

- Prisma schema edits;
- migrations;
- `db:push`;
- seed/reset commands;
- new routers, services, Zod schemas or tRPC endpoints;
- new UI features beyond fixes;
- Events;
- Project Requests;
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
- organiser dashboard;
- Project Request/onboarding flows;
- AI workflows.

## 3. Source Context

Use:

- `isodocs/docs/modules/fund/Planning/2026-06-23-fund-phase-1-slice-1j-project-admin-ui-proposal.md`
- `isodocs/docs/modules/fund/Planning/2026-06-24-fund-phase-1-slice-1j-b-project-product-membership-manager-proposal.md`
- `isodocs/docs/modules/fund/implementation/2026-06-24-phase-1-slice-1j-a-project-list-child-management-shell-confirmation.md`
- `isodocs/docs/modules/fund/implementation/2026-06-24-phase-1-slice-1j-b-project-product-membership-manager-confirmation.md`
- `isodocs/docs/modules/fund/implementation/2026-06-23-phase-1-slice-1i-project-api-services-confirmation.md`
- active FUND docs in `isodocs/docs/modules/fund/`
- `docs/2026-IsoStack-Docs/Standards/ui-ux/isostack-ux-ui-standard.md`
- `docs/2026-IsoStack-Docs/Standards/ui-ux/table-crud-pattern.md`

## 4. Preconditions

Before manual testing:

- work on `feature/fund-phase-1-products-catalogues`;
- confirm the target environment has the Slice 1H Project schema migration applied;
- confirm P1 can allocate FUND to a product;
- confirm the C1 tenant used for testing has FUND access through the correct product/module allocation;
- confirm the tenant has at least one active FUND Product and Workflow Class available for Project Product testing;
- confirm no unrelated working-tree changes will be mixed into findings or fixes.

## 5. Review Areas

### 5.1 Access And Tenant Scoping

Review:

- FUND module access requires correct product/module allocation;
- Project list only shows current tenant Projects;
- Product picker only lists current tenant Products;
- Project Product memberships cannot cross tenant boundaries;
- API calls never accept `organizationId` from the client.

Manual tests:

- C1 tenant with FUND can open `/app/fund/projects`;
- C1 tenant without FUND is blocked according to existing feature-gate behaviour;
- Product picker does not show Products from another tenant;
- direct URL to another tenant's Project id returns a safe not-found/forbidden state.

### 5.2 Project List And Create

Review:

- fuzzy search;
- status filter;
- sort selector;
- sort direction toggle;
- default archived-hidden behaviour;
- row click to child page;
- no edit/delete row ActionIcons;
- create modal fields and validation;
- duplicate project number/slug error handling.

Manual tests:

- create Project with required fields;
- duplicate project number shows `CONFLICT`;
- duplicate slug shows `CONFLICT`;
- create does not create/invite organiser users;
- create does not expose organiser dashboard access;
- successful create navigates to `/app/fund/projects/[id]`.

### 5.3 Project Child Overview

Review:

- breadcrumb and Project header;
- status/lifecycle badges;
- overview form fields;
- organiser fields remain contact snapshots only;
- General Save does not mutate status;
- Project Number and Slug duplicate conflicts are clear;
- date validation mirrors server rules without overreaching.

Manual tests:

- edit Project name, slug and Project Number;
- update organiser contact snapshot fields;
- update dates;
- invalid date order is blocked or clearly reported;
- General Save leaves status unchanged.

### 5.4 Status Transitions

Review:

- only valid next actions are shown;
- archive has confirmation;
- restore returns Project to `DRAFT`;
- complete sets `COMPLETED`;
- invalid status transitions are not exposed.

Manual tests:

- `DRAFT` shows Activate and Archive;
- `ACTIVE` shows Pause, Close and Archive;
- `PAUSED` shows Activate, Close and Archive;
- `CLOSED` shows Complete and Archive;
- `COMPLETED` shows Archive;
- `ARCHIVED` shows Restore;
- status action success invalidates Project detail/list state.

### 5.5 Activation Readiness

Review:

- readiness panel is advisory;
- server remains authoritative;
- missing close date is visible;
- missing active Project Product is visible;
- archived Product blockers are visible;
- inactive Workflow Class blockers are visible;
- Activate button state updates after membership changes.

Manual tests:

- Project without `closesAt` cannot activate;
- Project without active Product cannot activate;
- Project with active Product and close date can activate;
- archived active Product blocks activation;
- readiness updates after add/deactivate/reactivate.

### 5.6 Project Product Membership

Review:

- Products tab uses Project detail data;
- Product picker uses live Product data only for eligibility;
- membership list displays Project Product snapshot values as the operational record;
- inactive memberships remain visible;
- archived-linked memberships remain visible as historical/snapshot records;
- no Product edit UI is introduced inside the Project page.

Manual tests:

- Products tab loads inside Project child page;
- empty Project shows `No Products in this Project yet.`;
- Product picker lists eligible non-archived Products;
- archived Products are not picker options;
- active Project Products are excluded from picker options;
- Product can be added;
- duplicate active Product membership shows clear `CONFLICT`;
- membership can be deactivated;
- inactive membership can be reactivated when allowed;
- archived-linked inactive membership cannot be reactivated if the API blocks it;
- snapshot labels and values are clear.

### 5.7 Reorder Behaviour

Review:

- Move Up / Move Down controls are clear;
- first row disables Move Up;
- last row disables Move Down;
- reorder sends the full membership id list;
- inactive rows are included in the displayed full membership list;
- reorder success invalidates Project detail/list.

Manual tests:

- reorder two or more memberships;
- confirm order persists after refresh;
- confirm inactive memberships remain included and visible;
- confirm reorder is disabled for locked Project statuses.

### 5.8 Locked Statuses

Review:

- Product membership mutation controls are enabled only for `DRAFT`, `ACTIVE` and `PAUSED`;
- controls are hidden or disabled for `CLOSED`, `COMPLETED` and `ARCHIVED`;
- read-only notice is visible for locked statuses.

Manual tests:

- close a Project and confirm Products tab is read-only;
- complete a Project and confirm Products tab is read-only;
- archive a Project and confirm Products tab is read-only;
- restore archived Project and confirm editable state returns to `DRAFT` rules.

### 5.9 Error Handling And Stale State

Review:

- `CONFLICT`, `BAD_REQUEST`, `NOT_FOUND`, `FORBIDDEN` and fallback errors are user-friendly;
- mutation errors do not reset unrelated form state;
- Project detail/list invalidation is sufficient;
- stale membership/Product records are handled safely.

Manual tests:

- duplicate membership conflict;
- attempt invalid mutation after locked status if practical;
- simulate stale state by refreshing after mutation in another tab if practical;
- confirm notifications are clear.

### 5.10 UX Pattern Compliance

Review:

- Project list follows child-page pattern, not modal edit;
- Project table has no edit/delete row icons;
- Products tab is a child-data manager, not Product CRUD;
- no tiny destructive icon-only controls;
- inline actions are explicit and far-right where practical;
- `stopPropagation()` is used where inline actions exist;
- Product snapshots are visually distinguished from live Product picker data.

Manual tests:

- row click opens Project child page;
- no Product edit controls appear in Project Products tab;
- Deactivate/Reactivate/Move actions are labelled clearly;
- snapshot wording is understandable to a tenant admin.

## 6. Checks To Run

Run:

```bash
npm run type-check
npm run verify
```

If `npm run verify` fails in the sandbox with the known `tsx` IPC `EPERM` issue, rerun with appropriate approval and report both the sandbox limitation and the final result.

Optional if a dev server is needed:

```bash
npm run dev
```

Manual browser testing should use the local or target environment where FUND entitlement and the Slice 1H migration are in place.

## 7. Findings Report Format

Produce a review report with:

1. Findings by severity:
   - Critical
   - High
   - Medium
   - Low
2. Manual tests completed.
3. Checks run and results.
4. Known limitations.
5. Branch/commit readiness.
6. Recommendation:
   - Proceed;
   - Amend first;
   - Hold.
7. If Amend first, exact fix scope.

## 8. Go / No-Go Criteria

### Proceed

Use `Proceed` if:

- no Critical or High findings remain;
- Project create/edit/status flows work;
- Project Product membership flows work;
- activation readiness is accurate enough for Phase 1;
- tenant scoping and feature access look correct;
- checks pass.

### Amend First

Use `Amend first` if:

- UI defects or confusing wording remain but are contained;
- query invalidation needs adjustment;
- status/readiness display needs small fixes;
- membership actions need small UX fixes.

### Hold

Use `Hold` if:

- tenant isolation is questionable;
- status transition behaviour is wrong;
- Project Product membership can cross tenants;
- activation readiness is materially misleading;
- checks fail due code issues;
- schema/API mismatch blocks reliable testing.

## 9. Deliberately Out Of Scope

Do not start:

- Event schema;
- Event-linked Project constraints;
- Project Request schema;
- public or organiser-led Project initiation;
- organiser identity/account linking;
- organiser dashboard;
- Store schema;
- Order schema;
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
- AI workflows.

## 10. Recommended Next Prompt

```text
Proceed with FUND Phase 1 Slice 1K execution: Project Admin UI review and manual testing.

Work on:
feature/fund-phase-1-products-catalogues

Use:
- isodocs/docs/modules/fund/Planning/2026-06-24-fund-phase-1-slice-1k-project-admin-ui-review-and-manual-testing.md
- 1J-A and 1J-B confirmation documents
- Slice 1I Project API/services confirmation
- active FUND docs
- IsoStack UX/UI and table CRUD standards

Do not edit code unless explicitly asked after reporting findings.
Do not edit Prisma schema.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.
Do not create Events, Project Requests, Stores, Orders, commerce, payments, commissions, dashboards, production batching, SeasonPro integration, marketplace exposure, media/asset workflows, lifecycle tables, lifecycle transition engine, organiser identity/account linking, organiser dashboard, onboarding flows or AI workflows.

Perform a targeted code review and manual testing pass over Project Admin UI 1J-A and 1J-B.

Report:
1. Findings by severity.
2. Manual tests completed.
3. Checks run.
4. Known limitations.
5. Branch/commit readiness.
6. Recommendation: Proceed, Amend first or Hold.
7. If Amend first, exact fix scope.
```
