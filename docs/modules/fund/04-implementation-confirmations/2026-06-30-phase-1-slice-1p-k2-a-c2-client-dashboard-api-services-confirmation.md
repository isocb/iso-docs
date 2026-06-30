# FUND Phase 1 Slice 1P-K2-A - C2 Client Dashboard API/Services Confirmation

## 1. Slice

```text
1P-K2-A - C2 Client Dashboard API/Services
```

## 2. Implementation Summary

Implemented authenticated Client-scoped FUND dashboard API/services for C2 Client members.

The new service surface resolves Client context from:

```text
authenticated User
-> active FundClientMember
-> active FundClient
-> linked FundProjects
```

It does not accept Client ownership as proof from client input. Optional `clientId` input is only a context selector and is validated against the authenticated user's active Client memberships.

## 3. API Surface Added

Added C2-safe procedures under:

```text
fund.clientDashboard.*
```

Procedures:

- `getContext`;
- `listEvents`;
- `listProjects`;
- `getProject`;
- `createProject`;
- `updateProject`.

## 4. Client Context Rules

The Client dashboard context requires:

- authenticated session;
- FUND feature access;
- same-tenant User;
- active `FundClientMember`;
- `dashboardAccessEnabled = true`;
- non-`NONE` access level;
- active, non-archived `FundClient`.

If no valid Client membership exists, the API returns a forbidden state rather than falling back to P1/C1 surfaces.

## 5. Project Create/Update Rules

C2 Project creation now:

- creates a `FundProject` directly under the authenticated Client via `FundProject.clientId`;
- sets tenant scope from the authenticated User / effective tenant context;
- starts Projects in the existing safe `DRAFT` setup state;
- generates Project number and slug server-side;
- captures organiser snapshot fields from the authenticated Client member;
- captures the Project type / fundraising format in Project metadata using the same option set as the public Project initiation form;
- supports an optional idempotency key so repeated create retries can return the existing Client-owned Project rather than creating another record.

C2 Project update allows safe Project basics only:

- Project name;
- Project type / fundraising format;
- Event link where allowed by Project state;
- Project start date;
- Project closing date;
- notes/description.

Project Client ownership, tenant scope, Store settings, Orders, Commerce, Product membership, production, dispatch, commission and notifications are not exposed.

## 6. Project Type Clarification

Project type is the fundraising Project type/format and matches the public initiation form options:

- Artwork fundraising project;
- Group personalised product project;
- Bulk order / club-funded project;
- Not sure yet.

In this slice the value is stored as safe Project metadata. A later Product/Catalogue suitability slice should use the value to constrain selectable Products.

## 7. Event Selection Rules

Added a C2-safe selectable Event list for dashboard Project creation/editing.

Client-created Projects may link only to same-tenant active Events. Event date boundaries are enforced:

- Project start cannot be before the linked Event start/open date;
- Project closing date cannot be after the linked Event closing/end date;
- Project closing date may be earlier than the Event close date.

Standalone Projects require their own start and closing dates.

## 8. Files Changed

Application files:

- `src/modules/fund/lib/validation/client-dashboard.ts`;
- `src/modules/fund/services/client-dashboard.service.ts`;
- `src/modules/fund/routers/client-dashboard.router.ts`;
- `src/modules/fund/routers/index.ts`.

Documentation files:

- `docs/modules/fund/03-slice-planning/2026-06-30-fund-phase-1-slice-1p-k2-c2-client-dashboard-and-client-owned-project-management-planning.md`;
- `docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`;
- `docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1p-k2-a-c2-client-dashboard-api-services-confirmation.md`.

## 9. Explicit Non-Goals Confirmed

This slice did not implement:

- schema changes;
- Prisma migrations;
- Store;
- Orders;
- Commerce;
- Product membership selection;
- Product/Catalogue suitability;
- notifications;
- invitations;
- email sending;
- C1 admin surfaces;
- public Project initiation changes;
- C2 dashboard UI.

## 10. Checks

Checks run:

```text
npx prisma validate
npm run db:generate
npm run type-check
npm run verify
git diff --check
docs git diff --check
```

Result:

```text
Passed after implementation.
```

## 11. Recommended Next Slice

```text
1P-K2-B - C2 Client Dashboard UI
```

Goal:

```text
Implement the authenticated Client dashboard UI, Projects page, Project create/edit UI and Project detail tabs with Details, Products and Orders. Products and Orders remain placeholders only.
```
