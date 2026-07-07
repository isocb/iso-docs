# LMSPro Remediation Slice R7-A - Small UI And Count Polish Confirmation

Date: 2026-07-07
Module: LMSPro / SeasonPro
Related CR: `docs/modules/lmspro/01-cr-inputs/2026-07-07-lmspro-cr-small-remedial-ui-and-count-polish-input.md`
Related plan: `docs/modules/lmspro/03-slice-planning/2026-07-07-lmspro-remediation-slice-r7-a-small-ui-and-count-polish-planning.md`
Status: Implemented locally on app `dev`; browser smoke passed

## Summary

R7-A implements the small operator polish items raised during LMSPro smoke testing:

- removable compose email templates can now be deleted from the template dropdown;
- Change Request Management Variation Requests can be filtered by Age Group;
- Request Type filtering now includes the same Variation Request options available to clubs;
- the C2 Club Dashboard Waiting List count now reads from the actual waiting-list team data.

## Implemented Changes

### Compose Email Template Deletion

- Added a delete icon to each compose email template dropdown option.
- Added a confirmation prompt before deletion.
- Reuses the existing organisation-scoped email template delete route.
- Invalidates the template list after deletion so the dropdown refreshes immediately.
- Leaves sent email history untouched.

### Change Request Management Filters

- Added an Age Group filter to the Team Variations tab on Change Request Management.
- The Age Group filter loads actual season-scoped `LMSProAgeGroup` records through
  `lmspro.ageGroups.ageGroup.list`.
- The filter is not a static enum and should therefore match the league's configured Age
  Groups for the active season.
- Added `ageGroupId` support to the Team Variation Request list router.
- Added `DIVISION_CHANGE` to the Request Type filter.
- Aligned Request Type labels with the club-side Variation Request form:
  - Team Name Change;
  - Change Division / Group;
  - Withdraw Team from Season;
  - Age Group Change;
  - Reinstate / Resurrect Team;
  - Other / General Query.

### Club Dashboard Waiting List Count

- Changed the Waiting List widget to query teams directly with
  `status: TeamStatus.WAITING_LIST`.
- Kept the query scoped to the current club and effective season.
- Renamed the first season stat from `Teams` to `Active Teams` so it reflects the actual
  count being displayed.

## Boundaries

- R5-B notification routing was not changed.
- R5-C role catalogue behaviour was not changed.
- Team waiting-list workflow and state transitions were not changed.
- No email template schema changes were required.
- No platform/system template deletion rules were broadened beyond the existing
  organisation-scoped route behaviour.

## Verification

Developer verification completed:

```text
npm run type-check
git diff --check
```

Result: pass.

Browser smoke is documented separately in the R7-A review/test document.

## Browser Smoke Result

User browser testing completed on local app `dev`.

Result: complete pass.

Confirmed:

- compose email template deletion works as expected;
- Change Request Management Age Group filtering uses actual season-scoped Age Groups;
- Request Type filter includes the full club-side Variation Request option set;
- Club Dashboard Waiting List count is accurate;
- R5-B notification routing and R5-C role catalogue behaviour remain intact.
