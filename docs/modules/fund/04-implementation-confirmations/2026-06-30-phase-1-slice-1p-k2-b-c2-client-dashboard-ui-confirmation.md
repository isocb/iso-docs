# FUND Phase 1 Slice 1P-K2-B - C2 Client Dashboard UI Confirmation

## 1. Slice

```text
1P-K2-B - C2 Client Dashboard UI
```

## 2. Implementation Summary

Implemented the first authenticated C2 Client dashboard UI on top of the K2-A Client-scoped API/services.

The dashboard now supports:

- authenticated Client dashboard landing page;
- Client Projects page;
- Client-owned Project create/edit modal;
- row click from Projects table to Client-scoped Project detail;
- Project detail tabs:
  - Details;
  - Products placeholder;
  - Orders placeholder.

Products and Orders remain placeholders only.

## 3. Routes Added

Added C2 Client routes:

```text
/app/fund/client
/app/fund/client/projects
/app/fund/client/projects/[id]
```

Recognised FUND Client members are redirected from `/welcome` to:

```text
/app/fund/client
```

instead of the temporary unavailable page.

## 4. C2 Routing And Navigation

The app shell now hides the tenant admin sidebar on FUND Client routes, matching the intended separation between:

- C1 FUND admin surfaces;
- C2 Client dashboard surfaces.

The C2 pages provide their own simple dashboard/project navigation.

Post-implementation routing fix:

- the legacy `/app/fund/client-unavailable` route is retained only as a compatibility redirect;
- recognised C2 Client members are redirected from `/app/fund/client-unavailable` to `/app/fund/client`;
- middleware now allows `/app/fund/client` and child routes for C2 Client members;
- middleware still blocks C2 Client members from C1 FUND admin routes such as `/app/fund`, `/app/fund/projects` and `/app/fund/clients`.

This resolved a localhost redirect loop where `/app/fund/client` was still being classified by middleware as an unavailable C2 route.

## 5. Project Create/Edit UI

C2 Client members with `PROJECT_MANAGER` or `ADMIN` access can create/edit safe Project basics:

- Project name;
- Project type / fundraising format;
- Event or standalone selection;
- Project start date;
- Project closing date;
- notes/description.

The Project type uses the same option set as the public Project initiation form:

- Artwork fundraising project;
- Group personalised product project;
- Bulk order / club-funded project;
- Not sure yet.

The UI uses the K2-A idempotency key support for Project creation.

## 6. Event Boundary Behaviour

The create/edit modal uses the C2-safe active Event list from K2-A.

When an Event is selected, the modal shows date boundary guidance. Server-side validation remains authoritative.

## 7. Project Detail Tabs

The Details tab shows safe Project basics and status information.

The Products tab is a placeholder only and does not implement:

- Product membership;
- Product selection;
- catalogue availability;
- Product workflow suitability.

The Orders tab is a placeholder only and does not implement:

- Store;
- Orders;
- Commerce;
- sales reporting;
- commission.

## 8. Files Changed

Application files:

- `src/app/(app)/app/fund/client/page.tsx`;
- `src/app/(app)/app/fund/client-unavailable/page.tsx`;
- `src/app/(app)/app/fund/client/projects/page.tsx`;
- `src/app/(app)/app/fund/client/projects/[id]/page.tsx`;
- `src/app/(app)/welcome/page.tsx`;
- `src/core/components/layout/AppShell.tsx`;
- `src/middleware.ts`;
- `src/modules/fund/lib/client-member-routing.ts`;
- `src/modules/fund/components/client-dashboard/ClientDashboardShell.tsx`;
- `src/modules/fund/components/client-dashboard/ClientProjectModal.tsx`.

K2-A application files remain part of the current working set:

- `src/modules/fund/lib/validation/client-dashboard.ts`;
- `src/modules/fund/services/client-dashboard.service.ts`;
- `src/modules/fund/routers/client-dashboard.router.ts`;
- `src/modules/fund/routers/index.ts`.

Documentation files:

- `docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1p-k2-b-c2-client-dashboard-ui-confirmation.md`.

## 9. Explicit Non-Goals Confirmed

This slice did not implement:

- schema changes;
- Prisma migrations;
- Store;
- Orders;
- Commerce;
- Product membership;
- Product/Catalogue suitability;
- notifications;
- invitations;
- email sending;
- C1 admin surfaces;
- public Project initiation changes.

## 10. Checks

Checks run:

```text
npm run type-check
npm run verify
git diff --check
docs git diff --check
```

Result:

```text
Passed after implementation.
```

Additional routing fix checks:

```text
npm run type-check
git diff --check
```

Result:

```text
Passed after middleware route allowance and legacy unavailable-route redirect fix.
```

## 11. Recommended Next Slice

```text
1P-K2-C - C2 Client Dashboard Review And Smoke Testing
```

Goal:

```text
Review Client dashboard access boundaries, C1/C2 separation, row-click behaviour, Project create/edit smoke testing, Project detail tabs and placeholder boundaries.
```
