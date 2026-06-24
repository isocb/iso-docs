# FUND Phase 1 Slice 1I - Project API And Services Confirmation

## 1. Slice Name

Phase 1 Slice 1I - Project API and Services.

## 2. Date

2026-06-23.

## 3. Implementation Summary

Implemented the tenant-scoped Project API/service layer for the Slice 1H Project schema. The slice adds read/write tRPC procedures, Project status transitions, Project Product membership management, Product snapshot population, API-safe Decimal serialization and audit logging.

The implementation keeps Projects as the mandatory operational FUND entity while leaving Events, Stores, Orders and commerce for later slices.

## 4. Files Changed

- `src/modules/fund/lib/validation/projects.ts`
- `src/modules/fund/services/projects.service.ts`
- `src/modules/fund/routers/projects.router.ts`
- `src/modules/fund/routers/index.ts`
- `isodocs/docs/modules/fund/Planning/2026-06-23-fund-phase-1-slice-1i-project-api-services-proposal.md`
- `isodocs/docs/modules/fund/implementation/2026-06-23-phase-1-slice-1i-project-api-services-confirmation.md`

## 5. Validation Schemas Added

Added Project-specific Zod validation schemas for:

- Project list/get/create/update.
- Project archive.
- Project Product add/remove/set-active/reorder.
- Project number, slug, contact fields and nullable date inputs.

The schemas do not accept `organizationId`, status mutation through general update, lifecycle mutation through general update, workflow class ids for Project Product selection, or any Store/Event/Order fields.

## 6. Service Functions Added

Added service functions for:

- `listProjects`
- `getProject`
- `createProject`
- `updateProject`
- `activateProject`
- `pauseProject`
- `closeProject`
- `completeProject`
- `archiveProject`
- `restoreProject`
- `addProductToProject`
- `removeProductFromProject`
- `setProjectProductActive`
- `reorderProjectProducts`

## 7. tRPC Router And Procedures Added

Added `src/modules/fund/routers/projects.router.ts` and registered it under:

```text
fund.projects
```

Procedures:

- `fund.projects.list`
- `fund.projects.get`
- `fund.projects.create`
- `fund.projects.update`
- `fund.projects.activate`
- `fund.projects.pause`
- `fund.projects.close`
- `fund.projects.complete`
- `fund.projects.archive`
- `fund.projects.restore`
- `fund.projects.addProduct`
- `fund.projects.removeProduct`
- `fund.projects.setProductActive`
- `fund.projects.reorderProducts`

All procedures use `withFeature('fund')`. Mutations use the existing FUND admin role gate for `OWNER` or `ADMIN`.

## 8. Tenant Scoping Strategy

All Project and Project Product reads/writes derive `organizationId` from the effective actor context. No client input accepts `organizationId`.

Project Product operations validate:

- Project belongs to the actor tenant.
- Product belongs to the actor tenant.
- Membership belongs to the actor tenant and Project.
- Reorder lists include every current Project Product membership for the Project.

## 9. Access Control Strategy

Reads follow the Products/Catalogues pattern: authenticated users with FUND feature access can list/get tenant Projects.

Mutations require:

- active FUND feature gate; and
- actor role `OWNER` or `ADMIN`.

No module-role redesign was introduced.

## 10. Status Transition Strategy

Implemented dedicated status procedures. General update does not mutate status.

Transition matrix:

| Current | Allowed Next |
| --- | --- |
| `DRAFT` | `ACTIVE`, `ARCHIVED` |
| `ACTIVE` | `PAUSED`, `CLOSED`, `ARCHIVED` |
| `PAUSED` | `ACTIVE`, `CLOSED`, `ARCHIVED` |
| `CLOSED` | `COMPLETED`, `ARCHIVED` |
| `COMPLETED` | `ARCHIVED` |
| `ARCHIVED` | `DRAFT` via restore |

The `complete` procedure explicitly sets `status = COMPLETED`.

## 11. Activation Readiness Rules

Project activation requires:

- valid transition to `ACTIVE`;
- Project name, project number and slug;
- `closesAt`;
- valid date ordering;
- at least one active Project Product;
- no archived Products in active Project Products;
- active Workflow Classes for active Project Products.

## 12. Lifecycle State Strategy

Project create sets:

```text
lifecycleState = SETUP
```

Slice 1I does not expose arbitrary lifecycle updates and does not implement lifecycle tables or a lifecycle transition engine.

## 13. Date Validation Strategy

The service validates:

- `opensAt` must be before `closesAt` when both exist.
- `productionDeadline` cannot be before `closesAt` when both exist.
- `closesAt` may remain nullable in `DRAFT`.
- activation requires `closesAt`.

## 14. Organiser Field Strategy

Organiser fields remain optional contact snapshots:

- `organiserName`
- `organiserEmail`
- `organiserPhone`

They are not authoritative identity records and do not link to user accounts. Changes write a dedicated organiser audit event.

## 15. Project Product Snapshot Strategy

Project Product add snapshots:

- Product code.
- Product name.
- Product short description.
- Workflow Class code.
- Workflow Class name.
- Unit price net.
- VAT rate.
- Currency.

The client cannot provide `workflowClassId`; it is derived from the tenant-owned Product.

Inactive membership reactivation refreshes snapshots from the current Product and Workflow Class, as requested after proposal review.

## 16. Decimal Serialization Strategy

Project Product snapshot Decimal fields are serialized for API consumers:

- `unitPriceNetSnapshot` returns `number | null`.
- `vatRateSnapshot` returns `number | null`.

Raw Prisma Decimal objects are not returned for Project Product snapshot fields.

## 17. Project Product Membership Rules

Membership changes are allowed only while Project status is:

- `DRAFT`
- `ACTIVE`
- `PAUSED`

Membership changes are rejected after:

- `CLOSED`
- `COMPLETED`
- `ARCHIVED`

Duplicate active Product membership returns `CONFLICT`. Inactive existing membership is reactivated with refreshed snapshots.

Removal sets `isActive = false`; no hard delete is used.

Reorder requires a full membership id list for the Project.

## 18. Audit Logging

Implemented audit events for:

- `FUND_PROJECT_CREATED`
- `FUND_PROJECT_UPDATED`
- `FUND_PROJECT_ACTIVATED`
- `FUND_PROJECT_PAUSED`
- `FUND_PROJECT_CLOSED`
- `FUND_PROJECT_COMPLETED`
- `FUND_PROJECT_ARCHIVED`
- `FUND_PROJECT_RESTORED`
- `FUND_PROJECT_PRODUCT_ADDED`
- `FUND_PROJECT_PRODUCT_REMOVED`
- `FUND_PROJECT_PRODUCT_REACTIVATED`
- `FUND_PROJECT_PRODUCT_REORDERED`
- `FUND_PROJECT_ORGANISER_CHANGED`
- `FUND_PROJECT_DATES_CHANGED`
- `FUND_PROJECT_STATUS_CHANGED`

Reorder audit is logged against `FundProject`.

## 19. Error Handling

Implemented user-facing tRPC errors:

- `UNAUTHORIZED` for missing user context.
- `FORBIDDEN` for mutation role failures.
- `NOT_FOUND` for missing tenant-scoped Project, Product or membership.
- `BAD_REQUEST` for invalid dates, invalid transitions, activation readiness failures, archived Product selection and Project membership mutation after closed/completed/archived.
- `CONFLICT` for tenant-unique Project number/slug races and duplicate active Project Product membership.

Prisma `P2002` unique race conditions are converted to shaped `CONFLICT` errors.

## 20. What Was Deliberately Not Implemented

Slice 1I did not add:

- Prisma schema edits.
- migrations.
- `db:push`.
- seed/reset commands.
- UI.
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
- AI workflows.
- lifecycle tables.
- lifecycle transition engine.
- organiser identity/account linking.

## 21. Checks Run And Results

- `npm run type-check` - passed.
- `npm run verify` - passed after rerunning outside the sandbox because the initial sandboxed run blocked `tsx` IPC pipe creation with `EPERM`.

## 22. Manual Verification Checklist

- Create a DRAFT Project and confirm `lifecycleState = SETUP`.
- Confirm duplicate project number returns `CONFLICT`.
- Confirm duplicate slug returns `CONFLICT`.
- Update organiser fields and confirm audit is written.
- Update date fields and confirm date validation/audit.
- Attempt activation without `closesAt`; expect `BAD_REQUEST`.
- Attempt activation without active Project Products; expect `BAD_REQUEST`.
- Add a tenant Product to a Project and confirm snapshot fields are populated.
- Deactivate a Project Product membership.
- Reactivate a Project Product membership and confirm snapshots refresh.
- Attempt duplicate active Product membership; expect `CONFLICT`.
- Reorder with a full membership list.
- Attempt partial reorder; expect `BAD_REQUEST`.
- Activate Project with `closesAt` and active Product.
- Pause Project.
- Reactivate paused Project.
- Close Project.
- Confirm Product membership changes are blocked after `CLOSED`.
- Complete closed Project and confirm status becomes `COMPLETED`.
- Confirm Product membership changes are blocked after `COMPLETED`.
- Archive Project.
- Confirm Product membership changes are blocked after `ARCHIVED`.
- Restore Project and confirm status returns to `DRAFT`.
- Confirm tenant A cannot read or mutate tenant B Project or Project Products.

## 23. Risks And Follow-Ups

- Project UI is not yet available, so manual API testing should use tRPC callers or a future admin surface.
- Activation readiness may need workflow-class-specific production deadline requirements in a later lifecycle slice.
- Product snapshot refresh is implemented on reactivation, but existing active snapshots remain intentionally stable.
- FUND module roles may later replace the current OWNER/ADMIN mutation gate.
- Post-review DB-backed tRPC smoke testing could not be completed locally because the current database has not yet had the Slice 1H migration applied; `fund.fund_projects` does not exist in the current database. No migration, `db:push`, seed or reset command was run during this review.

## 24. Post-Review API Pass

Completed a focused Slice 1I API review before Project UI planning.

Review covered:

- `fund.projects` router registration.
- FUND feature gating on all Project procedures.
- OWNER/ADMIN mutation role checks.
- Tenant scoping in Project and Project Product service methods.
- Status transition matrix, including `complete` setting `COMPLETED`.
- Product membership mutation blocking after `CLOSED`, `COMPLETED` and `ARCHIVED`.
- Product snapshot refresh when reactivating inactive Project Product membership.
- Project Product reorder requiring a full membership id list.
- Project/Product same-tenant validation.
- Audit logging for Project, status and Project Product mutations.
- tRPC error code usage for `NOT_FOUND`, `FORBIDDEN`, `BAD_REQUEST` and `CONFLICT`.

Post-review correction:

- Project detail serialization now serializes nested Product Decimal fields through the existing Product serializer, so nested `product.unitPriceNet` and `product.vatRate` do not leak raw Prisma Decimal objects through `fund.projects.get`.

## 25. Recommended Next Slice

Proceed to Slice 1J planning for Project admin UI after the 1H/1I branch commits are in place. DB-backed API smoke testing should be completed after the Slice 1H migration is applied in the target environment.
