# FUND Phase 1 Slice 1P-D - C2 Read-Only Organiser Dashboard UI Confirmation

Date: 2026-06-25

## Slice Name

FUND Phase 1 Slice 1P-D - C2 Read-Only Organiser Dashboard UI.

## Implementation Summary

Implemented the first read-only C2 organiser dashboard surface for assigned FUND Projects.

The UI consumes only the participant-scoped organiser Project endpoints introduced in Slice 1P-C:

- `fund.organiser.projects.list`
- `fund.organiser.projects.get`

The C2 organiser views do not use C1 admin Project endpoints and do not provide mutation controls.

## Routes Created

- `/app/fund/organiser`
- `/app/fund/organiser/projects/[id]`

## Files Changed

App repo:

- `src/app/(app)/app/fund/page.tsx`
- `src/app/(app)/app/fund/organiser/page.tsx`
- `src/app/(app)/app/fund/organiser/projects/[id]/page.tsx`
- `src/modules/fund/components/organiser/OrganiserContextSwitch.tsx`
- `src/modules/fund/components/organiser/OrganiserDashboardPage.tsx`
- `src/modules/fund/components/organiser/OrganiserProjectDetailPage.tsx`
- `src/modules/fund/components/organiser/OrganiserProjectProductsTable.tsx`

Docs repo:

- `isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-d-c2-read-only-organiser-dashboard-ui-confirmation.md`

## Components Created

- `OrganiserDashboardPage`
- `OrganiserProjectDetailPage`
- `OrganiserProjectProductsTable`
- `OrganiserContextSwitch`

## Endpoint Usage Proof

The C2 organiser UI uses:

- `trpc.fund.organiser.projects.list.useQuery`
- `trpc.fund.organiser.projects.get.useQuery`

Grep check found no `trpc.fund.projects.*` or `fund.projects` usage inside:

- `src/app/(app)/app/fund/organiser`
- `src/modules/fund/components/organiser`

## Dual-Role / Context-Switch Handling

The C2 organiser pages show the user that they are viewing organiser Projects.

`OrganiserContextSwitch` provides navigation back to the C1 FUND admin surface only when the existing session indicates platform admin, owner or admin access.

This is navigation only. It does not introduce impersonation, server-side role switching or access-rule changes.

The existing `/app/fund` C1 admin home remains the C1 admin surface. A muted read-only organiser card was added to link to `/app/fund/organiser`.

## Event / Effective Close-Date Display

The organiser dashboard and Project detail page display:

- linked Event name/code/status when present;
- standalone Project status when no Event is linked;
- effective close date;
- close-date source as Project, inherited Event or none;
- Event open/close/deadline context on the Project detail page.

Event dates are not copied into Project fields by the UI.

## Project Product Snapshot Display

The Project detail page renders active Project Product snapshot rows with:

- Product code snapshot;
- Product name snapshot;
- Product short description snapshot when present;
- Workflow Class code/name snapshot;
- unit price net snapshot;
- VAT rate snapshot;
- currency snapshot.

The table is read-only and does not expose Product editing or Project Product membership actions.

## Loading / Empty / Error States

Implemented:

- loading placeholder cards on `/app/fund/organiser`;
- loading panel on organiser Project detail;
- empty state: `No Projects assigned to you yet.`;
- retryable error states for list and detail queries.

## Explicit Non-Goals

This slice did not implement:

- C2 mutations;
- C1 participant management UI;
- organiser invitations;
- Project Request/onboarding;
- Store, Orders or Commerce Core;
- Event/Catalogue/Product availability changes;
- workflow suitability changes;
- Prisma schema changes;
- migrations;
- `db:push`;
- seed/reset commands;
- main branch promotion.

## Checks Run

App repo:

- `npm run type-check` - passed.
- `npm run verify` - passed after rerunning outside the sandbox because `tsx` local IPC pipe creation was blocked by sandbox permissions.
- `git diff --check` - passed.
- grep proof for endpoint boundary - passed.

## Manual Test Checklist

- Visit `/app/fund/organiser` as a user with active Project participant rows.
- Confirm assigned Projects appear.
- Confirm no unassigned Projects appear.
- Confirm empty state appears for users with no assigned Projects.
- Open an assigned Project detail page.
- Confirm Project status/lifecycle/effective close date display.
- Confirm Event context displays when linked.
- Confirm standalone Project context displays when no Event is linked.
- Confirm Project Product snapshot rows display.
- Confirm no edit, archive, membership, invitation or mutation controls appear.
- Confirm `Switch to FUND admin` is visible only for users with existing admin-level access.
- Confirm C1 FUND admin home still loads and links to organiser view.

## Risks / Follow-Ups

- Authenticated browser testing is still required with real C2 participant users.
- The organiser card on `/app/fund` is safe navigation but may be refined later if C1 admins without assigned Projects find it noisy.
- Future slices still need C1 participant management, invitation/onboarding and organiser dashboard mutation planning before any write-capable C2 surface.

## Recommended Next Slice

Proceed to:

```text
FUND Phase 1 Slice 1P-D-R1 - C2 Read-Only Organiser Dashboard UI Review
```

Then continue with controlled planning for C1 participant assignment/management before adding any C2 mutations.
