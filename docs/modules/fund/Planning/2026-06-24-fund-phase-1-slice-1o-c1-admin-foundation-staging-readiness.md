# FUND Phase 1 Slice 1O - C1 Admin Foundation Staging Readiness

Date: 2026-06-24

Status: Planning only

Target app branch:

```text
feature/fund-phase-1-products-catalogues
```

## 1. Purpose

Plan the clean alignment of the completed FUND C1 admin foundation into staging.

This is a staging-readiness planning slice only. It does not implement new features, change schema, create migrations, run `db:push`, run seed/reset commands, or start C2 dashboard, Store, Order, Commerce Core or organiser onboarding work.

The recommended approach is:

1. Freeze FUND feature work at the current C1 admin foundation.
2. Confirm app and docs commits are clean and intentionally pushed.
3. Record the exact app commit SHA selected for staging deployment.
4. Confirm the staging database backup/snapshot point before migration.
5. Apply pending Prisma migrations to staging using the deploy migration workflow.
6. Confirm FUND module/product allocation for the staging C1 tenant.
7. Run staging smoke checks.
8. Run a human authenticated browser click-through before aligning onward.
9. Confirm rollback options, including whether applied migrations are backward-compatible with the previous deployed app version.

## 2. Current Completed Slice Summary

### Slice 1C - Product Workflow Classes

Completed platform-level protected workflow class defaults:

- `A1` - Individual Artwork Project Product.
- `A2` - Group Artwork Product.
- `B` - Logo / Bulk Mass Customisation Product.
- `C` - Standard Product.

Implemented as system defaults in the `fund` schema with read-only/list access.

### Slice 1D - Tenant-Owned Products and Catalogues Schema

Completed tenant-owned schema foundation for:

- `FundProduct`.
- `FundCatalogue`.
- `FundCatalogueProduct`.
- Product and Catalogue status enums.
- Same-tenant join constraints.

Media/asset workflows were deferred.

### Slice 1E - Products and Catalogues API/Services

Completed tenant-scoped API and service layer for Products and Catalogues, including:

- list/get/create/update.
- activate/archive/restore.
- Catalogue Product membership add/deactivate/reactivate/reorder.
- conflict handling.
- Decimal-safe serialization.
- audit logging.

### Slice 1F-A - Products and Catalogues Core Admin UI

Completed C1 admin UI for Products and Catalogues at:

```text
/app/fund/products
```

Implemented table CRUD pattern with row-click modals, search, sorting, filters and status actions.

### Slice 1F-B - Catalogue Product Membership Manager

Completed Catalogue Product membership manager inside the Catalogue modal, using existing 1E endpoints only.

### Slice 1G - Products/Catalogues Review

Completed review and remediation pass over Products/Catalogues foundation before Project work.

### Slice 1H - Project Schema

Completed schema foundation for:

- `FundProjectStatus`.
- `FundProject`.
- `FundProjectProduct`.
- tenant ownership.
- Project Product snapshot fields.
- same-tenant Product membership constraints.

### Slice 1I - Project API/Services

Completed Project API/services for:

- list/get/create/update.
- activate/pause/close/complete/archive/restore.
- Project Product add/deactivate/reactivate/reorder.
- activation readiness.
- Project Product snapshot population.
- audit logging.

### Slice 1J-A - Project List And Child Management Shell

Completed C1 Project admin UI foundation at:

```text
/app/fund/projects
/app/fund/projects/[id]
```

Includes Project list, create flow, child detail page, status actions and readiness display.

### Slice 1J-B - Project Product Membership Manager

Completed Project Products tab membership manager using existing Project endpoints.

### Slice 1K - Project Admin UI Review

Completed review slice for Project admin UI foundation.

### Slice 1L-A - FundEvent Schema

Completed optional Event schema foundation:

- `FundEventStatus`.
- `FundEvent`.
- optional `FundProject.eventId`.
- Event-linked Project date semantics.

Events are tenant-owned C1/admin grouping and constraint containers.

### Slice 1L-B - FundEvent API/Services

Completed Event API/services and Project/Event linkage service behaviour.

### Slice 1L-C - Event API Manual Review

Completed manual service test pass against local migrated database.

Review result:

- 23 checks passed.
- 0 product defects.
- no schema, migration, router, service or UI changes made during review.

### Slice 1M-A - FundEvent Admin UI

Completed C1 Event admin UI at:

```text
/app/fund/events
/app/fund/events/[id]
```

Includes Event list, create flow, child detail page, status actions, date constraint panel and linked Projects read-only list.

### Slice 1M-B - Project Event Selector UI

Completed Project create/detail Event linkage UI using existing 1L/1I endpoints.

### Slice 1M-C - Project/Event Linkage UI Review

Completed static route/code review pass for Project/Event linkage UI.

Review result:

- no product defects.
- no code fixes required.
- C1/C2 boundary preserved.

### Slice 1N - C1 Admin Foundation Review / Authenticated Browser Testing

Completed authenticated local route smoke review on the FUND C1 admin foundation.

Review result:

- authenticated Acme C1 owner route access passed for core FUND routes.
- unauthenticated FUND route access redirected to sign-in.
- `npm run type-check` passed.
- `npm run verify` passed after unsandboxed rerun for the known `tsx` IPC sandbox limitation.
- no product defects found.
- no code changes made.

Limit:

- no Playwright/browser automation harness exists in the repo, so full click-level browser interaction should still be completed by a human tester on staging.

## 3. App Repo Commit Status

Repository:

```text
/Volumes/isostack/Git/isostack-bedrock
```

Current branch:

```text
feature/fund-phase-1-products-catalogues
```

Observed status at planning time:

```text
## feature/fund-phase-1-products-catalogues
```

No uncommitted app repo changes were present before creating this planning document.

Recent app commits include:

```text
2d0cca6 feat(fund): add event admin and project linkage UI
5ecd96f feat(fund): add event api services
85be74a feat(fund): add event schema foundation
4423f62 feat(fund): add project product membership manager
f667ddf feat(fund): add project admin shell
8356f86 fix(platform): add fund to module catalogue defaults
4c77232 feat(fund): add project api services
8655052 feat(fund): add project schema foundation
```

Before staging alignment:

- confirm the app branch is clean;
- confirm the app branch has been pushed to remote;
- confirm the intended staging source branch or merge target;
- record the exact app commit SHA to deploy;
- do not deploy a moving branch reference without recording the resolved commit SHA;
- avoid mixing additional feature work into the staging-ready batch.

## 4. Docs Repo Commit Status

Repository:

```text
/Volumes/isostack/Git/isodocs
```

Observed status before this 1O document was created:

```text
## main...origin/main [ahead 12]
```

Recent docs commits include:

```text
b785677 docs(fund): plan 1n admin foundation testing
ef35dac docs(fund): capture 1m event linkage review
f3fe8a3 docs(fund): confirm event api services slice
9a9641a docs(fund): plan and confirm event schema slice
d70539d docs(fund): close project admin review
e9bf7b0 docs(fund): plan slice 1j-b project product membership
5b658b2 docs(fund): confirm slice 1j-a project admin shell
50c91c8 docs(modules): update module product allocation guidance
```

After creating this document, commit it separately in `isodocs` if the staging-readiness plan should travel with the work.

Before staging alignment:

- push the docs repo if the team needs access to the current plans and confirmations;
- keep docs commits separate from app deployment commits.

## 5. Migration List And Required Staging Migration Order

Staging must apply the FUND migrations in chronological Prisma migration order using the established deployment workflow.

Use:

```text
npm run db:migrate
```

This maps to:

```text
prisma migrate deploy
```

Do not use:

```text
db:push
npm run db:seed
npm run db:seed:products
reset commands
```

Required FUND migrations:

1. `20260623130000_add_fund_product_workflow_classes`

   Path:

   ```text
   prisma/migrations/20260623130000_add_fund_product_workflow_classes/migration.sql
   ```

   Summary:

   - creates `fund.fund_product_workflow_classes`;
   - inserts protected defaults `A1`, `A2`, `B`, `C`;
   - creates workflow class indexes.

2. `20260623133000_add_fund_products_catalogues`

   Path:

   ```text
   prisma/migrations/20260623133000_add_fund_products_catalogues/migration.sql
   ```

   Summary:

   - creates `FundProductStatus` enum;
   - creates `FundCatalogueStatus` enum;
   - creates `fund.fund_products`;
   - creates `fund.fund_catalogues`;
   - creates `fund.fund_catalogue_products`;
   - adds tenant and same-tenant Product/Catalogue constraints.

3. `20260623170000_add_fund_projects`

   Path:

   ```text
   prisma/migrations/20260623170000_add_fund_projects/migration.sql
   ```

   Summary:

   - creates `FundProjectStatus` enum;
   - creates `fund.fund_projects`;
   - creates `fund.fund_project_products`;
   - adds tenant and same-tenant Project/Product constraints;
   - adds Project Product snapshot fields.

4. `20260624120000_add_fund_events`

   Path:

   ```text
   prisma/migrations/20260624120000_add_fund_events/migration.sql
   ```

   Summary:

   - creates `FundEventStatus` enum;
   - creates `fund.fund_events`;
   - adds optional `fund.fund_projects.event_id`;
   - adds same-tenant Project/Event foreign key;
   - adds Event and Project/Event indexes.

Staging verification after migration:

```text
npm run db:migrate:status
npm run db:generate
npm run type-check
npm run verify
```

Confirm staging database contains:

- `fund.fund_product_workflow_classes`;
- `fund.fund_products`;
- `fund.fund_catalogues`;
- `fund.fund_catalogue_products`;
- `fund.fund_projects`;
- `fund.fund_project_products`;
- `fund.fund_events`;
- optional `fund.fund_projects.event_id` column.

## 6. Environment Assumptions

Staging assumptions:

- staging uses a real staging database, not local development data;
- a database backup/snapshot is confirmed immediately before applying FUND migrations;
- staging has current auth secrets configured;
- staging uses the normal Render/deployment build workflow;
- Prisma migrations are applied by `prisma migrate deploy` through `npm run db:migrate` or the established deployment equivalent;
- `db:push` is not used;
- seed/reset commands are not used;
- FUND local fixture data should not be assumed to exist in staging.

Expected environment variables are the same as the current application baseline. FUND Phase 1 C1 admin foundation does not introduce payment, commerce, Store, Order, production batching or C2 organiser dashboard environment variables.

Local-only warnings seen during 1N were:

- Upstash Redis/rate limiting disabled when Redis is not configured locally;
- session revocation disabled when Redis is not configured locally.

These should be checked against staging expectations. If staging is expected to enforce rate limiting/session revocation, ensure staging Redis variables are configured before declaring staging ready.

## 7. Product / Module Allocation Requirements For FUND

FUND access depends on the product/module allocation model.

Required platform state:

- `ModuleCatalogue.slug` must be exactly `fund`;
- the FUND module catalogue entry must be enabled;
- the FUND module route should be `/app/fund`;
- the relevant staging Product Package must include FUND through `ProductModule`;
- the target C1 tenant must have an active/trial assigned Product Package that includes FUND;
- the tenant must be able to access FUND through the same product gating path as other modules.

The app repo contains the platform fix:

```text
8356f86 fix(platform): add fund to module catalogue defaults
```

Important staging note:

- seed defaults affect only fresh seeded environments;
- existing staging environments may need the idempotent module catalogue/product allocation fix applied through the approved platform maintenance path;
- do not run seed/reset to make FUND appear in staging.

## 8. C1 Tenant Access Requirements

Before staging smoke testing, confirm there is a C1 tenant/admin test account with:

- active user status;
- access to a Product Package that includes FUND;
- sufficient tenant/admin permissions to manage Products, Catalogues, Projects and Events;
- no accidental C2 organiser dashboard requirement.

C1/C2 boundary to preserve:

- current FUND admin UI is C1 tenant/admin foundation only;
- Events are C1 tenant/admin records;
- Projects remain tenant-scoped operational records with organiser snapshot/contact fields;
- C2 organiser dashboards, organiser invitations, Project Request/onboarding and Project ownership/access changes remain future work.

## 9. Required Staging Smoke Tests

Run these after deployment and migration.

### Authentication And Access

- Sign in as a C1 tenant/admin user with FUND access.
- Confirm `/app/fund` loads.
- Confirm unauthenticated access to `/app/fund/projects` redirects to sign-in.
- Confirm a tenant without FUND product/module allocation cannot access FUND.

### Navigation

- Confirm FUND appears in the app navigation for the authorised C1 tenant.
- Confirm these routes load without missing-table or runtime errors:

```text
/app/fund
/app/fund/products
/app/fund/projects
/app/fund/events
```

### Database-Backed Pages

- Products page loads.
- Catalogues tab/page area loads.
- Projects page loads.
- Project child page loads for an existing Project, if any.
- Events page loads.
- Event child page loads for an existing Event, if any.

### API/Service Smoke

Through UI or targeted checks, confirm:

- `fund.products.list` responds for the C1 tenant;
- `fund.catalogues.list` responds for the C1 tenant;
- `fund.projects.list` responds for the C1 tenant;
- `fund.events.list` responds for the C1 tenant.

### Regression

- Existing SeasonPro/LMSPro admin routes still load.
- Existing platform dashboard still loads.
- Product/module allocation modal still includes FUND where appropriate.

## 10. Human Authenticated Browser Click-Through Checklist

This is the main staging acceptance checklist.

### Products

- Create a Product.
- Select a Workflow Class.
- Confirm price, VAT and currency display correctly.
- Edit Product details.
- Archive Product.
- Restore Product.
- Activate Product.

### Catalogues

- Create a Catalogue.
- Edit Catalogue details.
- Add an active Product to the Catalogue.
- Deactivate Catalogue Product membership.
- Reactivate membership.
- Reorder memberships with Move Up / Move Down.
- Archive, restore and activate Catalogue.

### Projects

- Create a standalone Project with no Event.
- Create a Project linked to a DRAFT or ACTIVE Event.
- Confirm Project close date can be blank when linked Event has `closesAt`.
- Confirm Project close date cannot exceed Event close date.
- Confirm Event dates are not copied into Project fields.
- Open Project child page.
- Edit normal Project details.
- Confirm General Save does not change Project status.
- Add Product to Project.
- Deactivate/reactivate Project Product membership.
- Reorder Project Products.
- Confirm membership controls lock after CLOSED, COMPLETED or ARCHIVED.
- Confirm activation readiness messages are understandable.

### Events

- Create DRAFT Event.
- Edit Event details.
- Confirm duplicate code/slug errors are clear.
- Confirm Event date validation:
  - `opensAt` before `closesAt`;
  - `productionDeadline` not before `closesAt`.
- Activate Event with `closesAt`.
- Confirm activation is blocked without `closesAt`.
- Close Event.
- Archive and restore Event.
- Confirm linked Projects list is read-only.
- Confirm linked Project row click navigates to Project child page.

### Project/Event Linkage

- Confirm Event selector lists only DRAFT and ACTIVE Events for new linkage.
- Confirm CLOSED/ARCHIVED Events are not eligible for new linkage.
- Confirm existing CLOSED/ARCHIVED linked Events remain visible historically.
- Confirm DRAFT Project can link/change/unlink Event.
- Confirm non-DRAFT Project Event linkage is read-only.
- Confirm effective close date display distinguishes:
  - Project close date;
  - inherited Event close date;
  - missing effective close date.

### C1/C2 Boundary

- Confirm Project create/edit does not create organiser users.
- Confirm Project create/edit does not invite organiser users.
- Confirm Project create/edit does not grant organiser dashboard access.
- Confirm no C2 organiser dashboard route or navigation item appears as part of this foundation.

## 11. Rollback / Hold Criteria

Hold staging alignment if any of the following occur:

- any FUND migration fails on staging;
- Prisma migration history is inconsistent;
- any required FUND table is missing after migration;
- `fund.fund_projects` or `fund.fund_events` missing-table errors appear;
- FUND route access fails for an authorised C1 tenant;
- unauthorised users can access FUND admin routes;
- Product/module allocation does not make FUND available to the intended C1 tenant;
- Project/Event same-tenant validation fails;
- Project/Event date constraints contradict the documented rules;
- Project Product or Catalogue Product membership mutation corrupts ordering or visibility;
- archive/restore/activate flows break for Products, Catalogues, Projects or Events;
- `npm run type-check` or `npm run verify` fails with a code issue;
- staging deployment creates Store, Order, commerce, payment, commission, C2 dashboard, organiser onboarding or Project Request behaviour unexpectedly.

Rollback options should be coordinated with the deployment owner. Avoid destructive database actions. If application rollback is needed, roll back the deployed app version first and assess whether the applied migrations are backward-compatible with the previous app version before proceeding.

Before deploying, explicitly record:

- the staging database backup/snapshot identifier or timestamp;
- the exact app commit SHA being deployed;
- whether each applied FUND migration is backward-compatible with the currently deployed app version;
- the intended rollback app commit, if rollback is needed.

If backward compatibility is unclear, treat rollback as a hold condition and get dev-ops review before deployment.

## 12. What Must Not Be Started Before Staging Alignment

Do not begin these before the C1 admin foundation is staged and accepted:

- C2 organiser dashboard;
- organiser invitations;
- organiser identity/account linking;
- Project Request/onboarding;
- Store schema or Store UI;
- Order schema or Order UI;
- Commerce Core;
- checkout;
- payments;
- commissions;
- production batching;
- fulfilment/shipping;
- SeasonPro integration;
- AMOW marketplace exposure;
- media/asset workflows;
- lifecycle tables or lifecycle transition engine;
- AI workflows.

## 13. Recommended Staging Deployment Prompt

```text
Proceed with FUND Phase 1 C1 Admin Foundation staging alignment.

Work from the reviewed FUND feature branch:
feature/fund-phase-1-products-catalogues

Do not start new feature work.
Do not edit Prisma schema.
Do not create migrations.
Do not run db:push.
Do not run seed/reset commands.
Do not introduce C2 dashboard, Store, Order, commerce, payments, commissions, organiser onboarding, Project Request flows, production batching, marketplace exposure, media/asset workflows, lifecycle engine or AI workflows.

Before deployment:
1. Confirm app repo branch is clean and pushed.
2. Confirm docs repo staging-readiness notes are committed/pushed if required.
3. Confirm staging deployment source branch and exact app commit SHA.
4. Confirm staging database backup/snapshot identifier or timestamp.
5. Confirm staging C1 tenant/admin test account.
6. Confirm FUND module catalogue entry uses slug `fund` and route `/app/fund`.
7. Confirm target staging Product Package includes FUND and is assigned to the C1 tenant.
8. Confirm rollback app commit and migration backward-compatibility notes before deployment.

Apply pending Prisma migrations to staging using the established deploy workflow only:

npm run db:migrate

Expected FUND migrations, in order:
- 20260623130000_add_fund_product_workflow_classes
- 20260623133000_add_fund_products_catalogues
- 20260623170000_add_fund_projects
- 20260624120000_add_fund_events

Then run:
- npm run db:migrate:status
- npm run db:generate
- npm run type-check
- npm run verify

After deployment, run staging smoke tests:
- authenticated C1 access to /app/fund;
- /app/fund/products loads;
- /app/fund/projects loads;
- /app/fund/events loads;
- unauthenticated /app/fund/projects redirects to sign-in;
- authorised C1 can create/edit Products, Catalogues, Projects and Events;
- Project/Event linkage respects same-tenant and date constraint rules;
- no C2 organiser dashboard, Store, Order, commerce or onboarding behaviour is introduced.

Report:
1. Exact app commit SHA deployed.
2. Migrations applied.
3. Smoke tests completed.
4. Human click-through result.
5. Any defects and severity.
6. Backup/snapshot confirmation.
7. Rollback/backward-compatibility confirmation.
8. Recommendation: proceed, amend first or hold.
```

## 14. Recommended Timing For Dev/Staging Alignment

Align dev and staging after:

- this 1O plan is reviewed;
- app branch is clean and pushed;
- docs are committed/pushed if needed;
- staging migration owner is ready;
- C1 test account and FUND product/module allocation are confirmed.

Do not wait for C2 dashboard, Store, Order or commerce planning. The point of this alignment is to stabilise the completed C1 admin foundation before starting those next layers.
