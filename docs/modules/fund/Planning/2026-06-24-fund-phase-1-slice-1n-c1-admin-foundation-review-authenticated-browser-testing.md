# FUND Phase 1 Slice 1N - C1 Admin Foundation Review / Authenticated Browser Testing

Date: 2026-06-24

Status: Planning for review/testing only

Target branch:

```text
feature/fund-phase-1-products-catalogues
```

## 1. Slice Goal

Perform an authenticated browser testing pass over the C1 FUND admin foundation before starting the next architectural or feature slice.

This slice verifies that the implemented C1/admin foundation works coherently across:

- Products;
- Catalogues;
- Catalogue Product membership;
- Projects;
- Project Product membership;
- Events;
- Project/Event linkage;
- FUND navigation and feature access.

This is a review/testing slice, not new feature work.

## 2. Implementation Boundary

Do not implement new features during 1N unless defects are reported, agreed and explicitly scoped.

Do not introduce:

- Prisma schema changes;
- migrations;
- `db:push`;
- seed/reset commands;
- routers;
- services;
- Zod schema changes;
- new tRPC endpoints;
- Stores;
- Orders;
- commerce;
- payments;
- commissions;
- production batching;
- SeasonPro integration;
- marketplace exposure;
- media/asset workflows;
- lifecycle engine;
- organiser identity/account linking;
- Project Request/onboarding;
- C2 organiser dashboards;
- organiser invitations;
- Project ownership/access changes;
- AI workflows.

## 3. Prerequisites

Required before testing:

- C1 tenant with FUND enabled through product/module allocation.
- C1 admin or owner test user.
- Optional non-admin tenant user for permission checks.
- Current FUND migrations applied in the target environment.
- At least one DRAFT Event.
- At least one ACTIVE Event.
- At least one CLOSED or ARCHIVED Event for historical/eligibility checks.
- At least one FUND Product with active Workflow Class.
- At least one Catalogue.
- At least one Project in DRAFT.
- At least one Project in ACTIVE or PAUSED.
- At least one Project in CLOSED, COMPLETED or ARCHIVED if available.

## 4. C1/C2 Boundary To Verify

The current UI is C1 tenant/admin foundation only.

Verify:

- C1 admin users can manage FUND admin records.
- C2 organiser dashboard surfaces are not present.
- Project create/edit does not create or invite organiser users.
- Project create/edit does not grant organiser dashboard access.
- Event selection does not expose cross-tenant Events.
- Project/Event linkage does not alter Project ownership/access.

## 5. Navigation And Access Tests

Routes to test:

- `/app/fund`
- `/app/fund/products`
- `/app/fund/projects`
- `/app/fund/projects/[id]`
- `/app/fund/events`
- `/app/fund/events/[id]`

Checks:

- FUND appears only when enabled for the tenant/product.
- FUND navigation includes Projects, Events and Products.
- C1 admin can access all listed FUND admin routes.
- Unauthenticated users are redirected to sign-in.
- Users without FUND access are blocked by feature gating.
- Page headers, table controls and child-page navigation are coherent.

## 6. Products And Catalogues Tests

Products:

- Create Product.
- Edit Product.
- Archive Product.
- Restore Product.
- Activate Product.
- Confirm price, VAT and currency display correctly.
- Confirm Workflow Class display/selection works.

Catalogues:

- Create Catalogue.
- Edit Catalogue.
- Archive Catalogue.
- Restore Catalogue.
- Activate Catalogue.
- Add Product to Catalogue.
- Deactivate Product membership.
- Reactivate Product membership.
- Reorder Catalogue Products with Move Up / Move Down.
- Confirm archived Products are not eligible for new Catalogue membership.
- Confirm inactive memberships remain visible.

## 7. Projects Tests

Project list:

- Fuzzy search works.
- Status filter works.
- Sort selector and direction toggle work.
- Archived Projects are hidden by default.
- Row click opens Project child page.

Project create:

- Create standalone Project with no Event.
- Create Project linked to a DRAFT Event.
- Create Project linked to an ACTIVE Event.
- Confirm CLOSED and ARCHIVED Events are not eligible for new selection.
- Confirm Project close date can remain blank when selected Event has `closesAt`.
- Confirm Project close date cannot be later than selected Event close date.
- Confirm Event dates are not copied into Project date fields.

Project detail:

- Edit normal Project fields.
- Confirm General Save does not mutate status.
- Confirm Event linkage displays in Overview.
- Confirm standalone Project state displays when no Event is linked.
- Confirm DRAFT Project can link/change/unlink Event.
- Confirm non-DRAFT Project shows Event linkage read-only.
- Confirm CLOSED/ARCHIVED linked Event remains visible historically.
- Confirm Event/date helper text remains accurate after link/change/unlink.

## 8. Project Product Membership Tests

In Project Products tab:

- Add eligible Product.
- Confirm archived Products are not eligible.
- Confirm Products already active in Project are not eligible.
- Deactivate Product membership.
- Confirm inactive membership remains visible.
- Reactivate inactive membership where allowed.
- Reorder Project Products with Move Up / Move Down.
- Confirm mutation controls lock for CLOSED, COMPLETED and ARCHIVED Projects.
- Confirm activation readiness refreshes after membership changes.

## 9. Event Admin Tests

Event list:

- Fuzzy search works.
- Status filter works.
- Sort selector and direction toggle work.
- Archived Events are hidden by default.
- Row click opens Event child page.

Event create/edit:

- Create DRAFT Event.
- Edit Event details.
- Confirm General Save does not mutate status.
- Confirm duplicate code/slug errors are clear.
- Confirm Event date validation works.

Event status actions:

- Activate DRAFT Event with `closesAt`.
- Confirm activation disabled or rejected without `closesAt`.
- Close ACTIVE Event.
- Archive Event.
- Restore ARCHIVED Event.
- Confirm invalid status actions are hidden or unavailable.

Linked Projects:

- Confirm linked Projects list is read-only.
- Confirm linked Project row click navigates to Project child page.
- Confirm effective close date distinguishes Project close date, inherited Event close date and missing effective close date.
- Confirm no unlink or Project mutation controls exist on Event page.

## 10. Activation And Readiness Tests

Standalone Project:

- Activation requires Project `closesAt`.
- Activation requires at least one active Project Product.
- Activation blocks archived active Products.
- Activation blocks inactive/missing Workflow Class where applicable.

Event-linked Project:

- Blank Project `closesAt` plus Event `closesAt` satisfies close-date readiness.
- Blank Project `closesAt` plus blank Event `closesAt` shows missing effective close-date blocker.
- Project `closesAt` earlier than Event `closesAt` is valid.
- Project `closesAt` later than Event `closesAt` is rejected.
- Server activation errors are surfaced clearly.

## 11. Tenant And Security Tests

Where practical:

- Confirm Event selector shows only current tenant Events.
- Confirm another tenant's Event cannot be linked by stale/manual `eventId`.
- Confirm Products and Catalogues remain tenant-scoped.
- Confirm Projects remain tenant-scoped.
- Confirm Events remain tenant-scoped.
- Confirm C1 admin access does not create C2 organiser access.

## 12. Regression Tests

Confirm these still work:

- FUND landing page.
- Products/Catalogues admin.
- Project list.
- Project child page.
- Project Products tab.
- Event list.
- Event child page.
- FUND navigation.
- Existing non-FUND modules are not affected by FUND navigation changes.

## 13. Defect Handling

For each defect, record:

- route;
- user/role;
- tenant/environment;
- steps to reproduce;
- expected behaviour;
- actual behaviour;
- screenshot or console/server log if available;
- severity;
- whether it blocks promotion/next slice.

Do not fix defects inside 1N until the fix scope is agreed.

## 14. Go / Amend / Hold Criteria

Proceed if:

- C1 admin can complete Products, Catalogues, Projects and Events core flows.
- Project/Event linkage works for DRAFT Projects.
- Event-linked readiness behaviour is understandable and server-consistent.
- No cross-tenant Event/Product/Project visibility is observed.
- No C2 dashboard/access behaviour has been introduced.
- No blocking regressions are found.

Amend first if:

- UI wording is confusing but data integrity is safe.
- Selector or readiness UX needs small changes.
- Non-critical mutation notification/error handling is unclear.

Hold if:

- cross-tenant data is visible;
- Event linkage can mutate non-DRAFT Projects;
- activation readiness contradicts server behaviour materially;
- Project/Event linkage corrupts or copies dates unexpectedly;
- Products/Catalogues/Projects/Events core admin pages fail to load.

## 15. Recommended Execution Prompt

```text
Proceed with FUND Phase 1 Slice 1N execution: C1 Admin Foundation Review / Authenticated Browser Testing.

Work on:
feature/fund-phase-1-products-catalogues

Use:
- isodocs/docs/modules/fund/Planning/2026-06-24-fund-phase-1-slice-1n-c1-admin-foundation-review-authenticated-browser-testing.md
- Slice 1M-A, 1M-B and 1M-C confirmation documents
- Slice 1J-A and 1J-B confirmation documents
- Slice 1L-A, 1L-B and 1L-C confirmation documents

Review/test only.
Do not implement new features.
Do not edit Prisma schema.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.
Do not create or modify routers, services, Zod schemas or tRPC endpoints.

Run authenticated browser tests for the C1 FUND admin foundation.

Report:
1. Tests completed.
2. Defects found by severity.
3. Any fixes recommended, with exact scope.
4. Confirmation of C1/C2 boundary.
5. Tenant/security observations.
6. Regression results.
7. Recommendation: Proceed, Amend first or Hold.
```

## 16. Recommended Next Slice After 1N

If 1N passes, recommended next planning options are:

- Commerce Core planning outside FUND;
- C2 organiser model / dashboard planning;
- FUND lifecycle/workflow extension planning;
- Store schema planning only after Commerce Core boundary is agreed.

