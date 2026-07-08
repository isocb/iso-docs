# FUND Phase 1 Slice 1Q-G-B - Availability Management UI Pattern Remediation Confirmation

Date: 2026-07-08
Module: FUND
Related planning: `docs/modules/fund/03-slice-planning/2026-07-08-fund-phase-1-slice-1q-g-b-availability-management-ui-pattern-remediation-planning.md`
Status: Reworked on local app `dev`; browser smoke passed; promoted to staging

## Summary

Implemented and then reworked the table-first remediation for FUND Availability so the
page-level surface follows the IsoStack table CRUD pattern.

The accepted implementation shape is:

```text
Availability page -> tables/search/filter/sort/add controls only
Row click/Add -> modal
Modal -> record-specific inputs, Save and Cancel
```

## Implemented

- Added Event Catalogue availability summary service/router endpoint.
- Added Product suitability summary service/router endpoint.
- Availability tab now shows an Event Catalogue Availability table at page level.
- Event rows show Event code/name, status, date window, active Catalogue count and active
  Catalogue badges.
- Clicking an Event row opens an Event Catalogue Availability modal.
- Configure Event opens the same modal without preselecting an Event.
- Availability tab no longer silently auto-selects the first Event.
- Product Suitability now shows a Product summary table at page level.
- Product rows show Product code/name, status, workflow class, Project type suitability and
  Organisation type suitability.
- Products with no active suitability rows are shown as unrestricted for that dimension.
- Clicking a Product row opens a Product Suitability modal.
- Standalone Catalogue Availability now shows a Catalogue table at page level.
- Clicking a Catalogue row opens a Standalone Catalogue Availability modal.
- Standalone eligibility now treats exactly one active standalone-capable Catalogue as the
  effective standalone default when no explicit default exists.
- The Catalogue table/modal labels that inferred state as `Auto default`.
- Saving Event availability and Product suitability invalidates the new summaries.

## Implementation Notes

This pass keeps bounded modals rather than moving Event availability onto the Event child
page. Event child-page management remains the preferred later refinement if the Event page
becomes the main operational management unit.

## Developer Checks

Completed:

```text
npm run type-check
git diff --check
```

Result: pass.

Promotion result:

- Promoted to app `staging` on 2026-07-08 as part of commit `ea4e619`.

## Follow-Up

Browser smoke should confirm that Availability page-level sections contain table controls
only, that row click opens modals, and that modal saves refresh the relevant table rows.
It should also confirm that a controlled single standalone-capable Catalogue setup works
without an explicit default and is labelled as `Auto default`.
