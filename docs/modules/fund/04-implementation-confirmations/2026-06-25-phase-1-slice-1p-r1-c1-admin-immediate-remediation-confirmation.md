# FUND Phase 1 Slice 1P-R1 — C1 Admin Immediate Remediation Confirmation

Date: 2026-06-25

## Implementation Summary

Implemented targeted C1 admin remediation from the CR triage lane:

- fixed Project/Event date constraint visibility so linked Projects clearly show invalid date relationships before activation;
- tightened Project create/detail date inputs against selected Event constraints where practical;
- improved Project activation readiness so invalid linked Event date constraints block the ready state;
- made the Project Product activation gate more visible from the Project Overview readiness panel;
- fixed Issue Manager module filtering against the `IssueCatalogueModule` relation;
- made Issue Manager module tagging clearer and more reliable for FUND;
- added FUND Products breadcrumb navigation;
- updated FUND sidebar icons to avoid repeated generic Home/Folder icons;
- added a UI standard note that module navigation icons should be destination-specific.

## Files Changed

Application:

- `src/modules/fund/components/projects/ProjectEventSelector.tsx`
- `src/modules/fund/components/projects/ProjectCreateModal.tsx`
- `src/modules/fund/components/projects/ProjectDetailPage.tsx`
- `src/server/actions/issues.ts`
- `src/server/actions/modules.ts`
- `src/app/(app)/platform/issues/components/IssueFilters.tsx`
- `src/app/(app)/platform/issues/components/IssueModal.tsx`
- `src/app/(app)/app/fund/products/page.tsx`
- `src/core/config/module-navigation.ts`
- `docs/2026-IsoStack-Docs/Standards/ui-ux/isostack-ux-ui-standard.md`

Documentation:

- `isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-r1-c1-admin-immediate-remediation-confirmation.md`

## Issue Coverage

### #46 Project/Event Close-Date Constraint

Added shared UI constraint messaging for linked Project/Event dates:

- Project open date cannot be before Event open date.
- Project close date cannot be later than Event close date.
- Project production deadline cannot be later than Event production deadline.
- Project production deadline cannot be before the effective close date.

Activation readiness now treats linked Event date constraint failures as blockers. The server remains authoritative.

### #50 Issue Manager Module Filtering / Server Render

Updated Issue Manager module filtering to use `catalogueModuleId` on the existing `IssueCatalogueModule` relation.

Also made module filtering tolerant of historical issue context fields (`moduleName`, `isocareModule`, `appName`, and application name) where they match the selected module.

The module action path now ensures the FUND module catalogue record exists with an idempotent `upsert` using `update: {}` so existing customisations are not overwritten.

### #47 Product Activation Gate Visibility

Added a visible warning in the Project Overview readiness panel when there are no active Project Products, including a button to jump to the Products tab.

### #44 Product Breadcrumb

Added a simple breadcrumb to `/app/fund/products`.

### #45 Sidebar Icon Polish

Updated FUND sidebar icons:

- FUND overview now uses `IconLayoutDashboard`.
- Projects now uses `IconClipboardList`.

Added a short UI standard note discouraging repeated generic icons in module navigation.

## Schema / Migration Changes

None.

`db:push` was not used.

Seed/reset commands were not used.

## What Was Deliberately Not Implemented

This slice did not implement:

- Event/Catalogue/Product availability model;
- Product Workflow Class suitability architecture;
- C2 organiser dashboard;
- organiser invitations;
- Project Request/onboarding;
- Store, Order or Commerce Core;
- payments;
- commissions;
- production batching;
- lifecycle engine;
- marketplace expansion;
- AI workflows.

## Checks Run

- `npm run type-check` — passed.
- `npm run verify` — first sandboxed run failed because `tsx` could not create a local IPC pipe; rerun with approved escalation passed.

## Manual Verification Checklist

- Create or edit an Event-linked Project and attempt to set Project `closesAt` later than Event `closesAt`; UI should show constraint messaging and readiness should not be ready.
- Confirm server-side Project update/activation still rejects invalid Event-linked dates.
- Confirm standalone Projects still use normal Project date rules.
- Confirm Project Overview shows a visible active Product gate when no active Project Products exist.
- Confirm Issue Manager module filter can filter by FUND without a server render error.
- Confirm selecting FUND as an application/area also tags FUND as an Issue Module when available.
- Confirm `/app/fund/products` shows breadcrumb navigation.
- Confirm FUND sidebar icons are distinct.

## Risks / Follow-Ups

- Issue Manager still has legacy application/module terminology. The remediation clarifies the immediate UI path without redesigning the Issue Manager data model.
- Event/Catalogue/Product availability and workflow suitability remain architecture planning items and should not be implemented ad hoc.

## Recommended Next Slice

Proceed with `Phase 1 Slice 1P-R2 — C1 Admin Immediate Remediation Review`.
