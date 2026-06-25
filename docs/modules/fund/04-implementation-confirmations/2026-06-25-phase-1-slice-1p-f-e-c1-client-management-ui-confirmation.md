# FUND Phase 1 Slice 1P-F-E - C1 Client Management UI Confirmation

Date: 2026-06-25

## Slice Summary

Slice 1P-F-E implemented the first C1/admin Client Management UI on top of the existing `fund.clients.*` API/service layer.

This creates the C1 operational surface for managing FUND Clients as fundraising organisations such as schools, clubs, PTAs, charity branches and customer accounts.

## Routes Created

- `/app/fund/clients`
- `/app/fund/clients/[id]`

## Files Changed

App UI:

- `src/app/(app)/app/fund/page.tsx`
- `src/app/(app)/app/fund/clients/page.tsx`
- `src/app/(app)/app/fund/clients/[id]/page.tsx`
- `src/core/components/layout/Navbar.tsx`
- `src/core/config/module-navigation.ts`
- `src/modules/fund/components/clients/ClientCreateModal.tsx`
- `src/modules/fund/components/clients/ClientDetailPage.tsx`
- `src/modules/fund/components/clients/ClientTable.tsx`
- `src/modules/fund/components/shared/FundStatusBadge.tsx`

## Endpoints Used

The Client UI uses only:

- `fund.clients.list`
- `fund.clients.get`
- `fund.clients.create`
- `fund.clients.update`
- `fund.clients.archive`
- `fund.clients.restore`

The UI does not use C2 organiser endpoints and does not use Project mutation endpoints for Client linkage.

## List Behaviour

`/app/fund/clients` provides:

- fuzzy Client search;
- status/archive filtering;
- column-header sorting with active sort indicators;
- row-click navigation to Client detail;
- no row edit/delete/archive action icons;
- muted operational styling consistent with the current FUND admin tables.

Archived Clients are hidden by default and available through the explicit Archived filter.

## Detail Behaviour

`/app/fund/clients/[id]` provides:

- Client profile display;
- Client profile editing;
- primary contact snapshot fields;
- internal C1 notes;
- status display;
- archive/restore actions in the detail action area;
- linked Project summary rows when returned by `fund.clients.get`.

Archived Clients are read-only until restored.

Linked Project rows navigate only to `/app/fund/projects/[id]`.

## Create/Edit/Archive/Restore Behaviour

Create Client supports:

- code;
- name;
- slug;
- client type;
- description;
- primary contact name;
- primary contact email;
- primary contact phone;
- internal notes.

Edit Client supports:

- code;
- name;
- slug;
- client type;
- description;
- status `ACTIVE` or `INACTIVE`;
- primary contact name;
- primary contact email;
- primary contact phone;
- internal notes.

Archive and restore use the dedicated API procedures. API archive blockers, including active/paused linked Projects, are surfaced through error notifications.

Metadata editing is not exposed in this slice.

## Dashboard And Navigation

The C1 FUND home now includes a Client Management card using whole-card navigation and brand-primary action treatment.

The FUND module sidebar now includes a distinct Clients navigation item.

## UI Standard Compliance

This slice follows the current IsoStack/FUND table CRUD pattern:

- row click opens the child/detail page;
- sortable columns are handled by column headers;
- destructive/archive controls are not placed in table rows;
- semantic colour is reserved for status/action meaning;
- Client remains a C1 admin surface, not a C2 organiser surface.

## Explicit Out Of Scope

This slice did not implement:

- Project Client selector/linkage;
- Project create/edit changes;
- Client users;
- Client roles;
- invitations;
- C2 dashboard expansion;
- C2 mutations;
- Project Request/onboarding;
- Store;
- Orders;
- Commerce Core;
- Sales/Reporting;
- Communications;
- key-date automation;
- SeasonPro Club mapping;
- reusable core Client/account model;
- Prisma schema changes;
- migrations.

## Checks Run

- `npm run type-check` - passed.
- `npm run verify` - passed after rerunning with elevated permissions because the sandbox blocked the `tsx` IPC pipe.
- `git diff --check` - passed in the app repo.

## Risks And Follow-Ups

- Client-to-Project linkage is intentionally not wired into Project create/edit yet.
- Client users, C2 account roles and C1 Client View remain future architecture slices.
- Authenticated browser testing should verify the Client list/detail flows once the deployed environment includes the 1P-F-C Client migration and 1P-F-D API layer.

## Recommended Next Slice

Recommended next slice:

`1P-F-E-R1 - C1 Client Management UI Review and Authenticated Smoke Testing`

After review, proceed to Project Client selector/linkage planning only if the Client UI and API behaviour are accepted.
