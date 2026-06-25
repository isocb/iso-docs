# FUND Phase 1 Slice 1P-F-E-R1 - C1 Client Management UI Review

Date: 2026-06-25

Status: Review / static smoke confirmation

## Verdict

Proceed with caveats.

The C1 Client Management UI is code/static-review ready for dev alignment as part of the 1P-F-C/D/E batch.

Authenticated browser testing was not completed in this review because no authenticated C1 browser session was available from the current shell. Staging/browser validation should happen after the 1P-F-C Client migration and 1P-F-D/1P-F-E app changes are deployed together.

## Routes Reviewed

- `/app/fund/clients`
- `/app/fund/clients/[id]`

The route files exist and are wired to the implemented Client components:

- `src/app/(app)/app/fund/clients/page.tsx`
- `src/app/(app)/app/fund/clients/[id]/page.tsx`

## Files / Components Reviewed

- `src/modules/fund/components/clients/ClientTable.tsx`
- `src/modules/fund/components/clients/ClientCreateModal.tsx`
- `src/modules/fund/components/clients/ClientDetailPage.tsx`
- `src/app/(app)/app/fund/page.tsx`
- `src/core/config/module-navigation.ts`
- `src/core/components/layout/Navbar.tsx`
- `src/modules/fund/components/shared/FundStatusBadge.tsx`

Related API/service dependencies reviewed from prior confirmation:

- `src/modules/fund/lib/validation/clients.ts`
- `src/modules/fund/services/clients.service.ts`
- `src/modules/fund/routers/clients.router.ts`
- `src/modules/fund/routers/index.ts`

## Endpoint Usage Proof

Static search found only the allowed Client endpoints inside the Client UI:

- `trpc.fund.clients.list`
- `trpc.fund.clients.get`
- `trpc.fund.clients.create`
- `trpc.fund.clients.update`
- `trpc.fund.clients.archive`
- `trpc.fund.clients.restore`

No Client UI usage was found for:

- `trpc.fund.organiser.*`
- `trpc.fund.projects.*`
- Project create/update/archive/restore/status/Product mutation procedures.

Linked Project summary rows only navigate to:

```text
/app/fund/projects/[id]
```

They do not mutate Project Client linkage.

## List Behaviour Assessment

Static review confirms `/app/fund/clients` provides:

- fuzzy search using `Fuse`;
- status/archive filter with `All current`, `Active`, `Inactive` and `Archived`;
- archived Clients hidden by default through `includeArchived: false`;
- explicit Archived filter using `includeArchived: true`;
- column-header sorting using `FundSortableHeader`;
- reverse sorting by clicking the same header again;
- row click to Client detail;
- no row edit/delete/archive `ActionIcon` buttons.

List columns include:

- code;
- name/slug;
- client type;
- status;
- primary contact;
- project count;
- updated date.

## Detail Behaviour Assessment

Static review confirms `/app/fund/clients/[id]` provides:

- breadcrumb navigation;
- Client header with status badge;
- Client code/project count/updated summary cards;
- profile edit form;
- contact snapshot fields;
- internal notes;
- linked Project summary table;
- archived Client read-only state;
- restore action for archived Clients.

The detail page uses the Client API only.

## Create / Edit / Archive / Restore Assessment

Create:

- uses `fund.clients.create`;
- supports code, name, slug, client type, description, primary contact fields and internal notes;
- navigates to `/app/fund/clients/[id]` on success;
- does not expose metadata editing;
- does not create users, invitations, Projects or notifications.

Edit:

- uses `fund.clients.update`;
- supports allowed profile/contact/internal-note fields;
- limits status selection to `ACTIVE` and `INACTIVE`;
- does not offer direct `ARCHIVED` update.

Archive:

- uses `fund.clients.archive`;
- is located in the detail action area;
- uses confirmation before mutation;
- surfaces API errors through notifications.

Restore:

- uses `fund.clients.restore`;
- is only shown when the Client is archived;
- uses confirmation before mutation.

Untested without live data:

- duplicate code/slug conflict display;
- successful create/save/archive/restore with authenticated C1 session;
- active/paused linked Project archive blocker.

## Navigation / Sidebar / Dashboard Assessment

Static review confirms:

- FUND dashboard includes a whole-card `Client Management` link to `/app/fund/clients`;
- dashboard card uses brand-primary action treatment, not decorative random colour;
- FUND sidebar includes a distinct `Clients` item;
- `IconBuildingCommunity` is included in the dynamic navbar icon map;
- existing Products, Projects and Events route files remain present.

## Explicit Out-Of-Scope Confirmation

No evidence found in the Client UI of:

- C2 organiser endpoints;
- Project Client selector/linkage;
- Project create/edit changes;
- Client users;
- Client roles;
- invitations;
- Project Intake / Project Request forms;
- Store;
- Orders;
- Commerce Core;
- Sales/Reporting;
- Communications;
- key-date automation;
- SeasonPro Club mapping;
- metadata editing.

No new schema changes or migrations were introduced by this review. The current app working tree still contains the expected 1P-F-C schema/migration foundation that this UI depends on.

## Authenticated Smoke Test Results

Authenticated browser smoke testing was not completed in this review.

Items requiring authenticated C1 staging/local browser testing:

- `/app/fund/clients` loads for C1 admin with FUND access;
- create Client flow succeeds;
- duplicate code/slug conflict message is clear;
- row click opens Client detail;
- save updates allowed fields;
- archive/restore flows succeed;
- archive blocker appears for active/paused linked Projects if test data permits;
- archived filter shows archived Clients;
- Products, Projects and Events C1 pages still load in browser.

## Checks Run

- `npm run type-check` - passed.
- `npm run verify` - passed after rerunning with elevated permission because the sandbox blocked the `tsx` IPC pipe.
- `git diff --check` - passed in the app repo.

## Defects / Follow-Ups

No code/static defects found.

Follow-ups:

- perform authenticated browser smoke testing after deploying the 1P-F-C/D/E batch to an environment with the Client migration applied;
- test archive blocker with an active/paused linked Project once Project Client linkage/test data exists;
- plan Project Client selector/linkage separately;
- keep Project Intake, Client users, invitations and notifications deferred.

## Recommendation On Dev / Staging Alignment

Recommended:

```text
Proceed with caveats.
```

Dev alignment is reasonable after committing the 1P-F-C/D/E batch.

Staging alignment should deploy the schema migration, API/services and UI together, then run the authenticated C1 browser smoke checklist above before treating the UI as AMOW presentation-ready.

## Recommended Next Slice

Recommended next slice:

```text
1P-F-E-R2 - C1 Client Management Authenticated Browser Smoke Testing
```

After that passes, proceed to Project Client selector/linkage planning.
