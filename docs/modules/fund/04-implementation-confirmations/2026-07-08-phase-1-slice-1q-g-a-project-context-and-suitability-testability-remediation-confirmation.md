# FUND Phase 1 Slice 1Q-G-A - Project Context And Suitability Testability Remediation Confirmation

Date: 2026-07-08
Module: FUND
Related planning: `docs/modules/fund/03-slice-planning/2026-07-08-fund-phase-1-slice-1q-g-a-project-context-and-suitability-testability-remediation-planning.md`
Status: Implemented on local app `dev`; browser smoke passed; promoted to staging

## Summary

Implemented the C1 Project context controls needed to continue 1Q-G availability and
eligibility testing without database intervention.

## Implemented

- Project detail now exposes Project Type / fundraising format from Project metadata.
- C1 Project creation now captures Project Type / fundraising format into Project
  metadata, including for standalone Projects.
- Changing Project Type now warns C1 if active selected Project Products exist.
- Confirmed Project Type changes deactivate active selected Project Products and refresh
  eligibility.
- Project detail now exposes an Effective Organisation Type override from Project metadata.
- Product eligibility now prefers Project metadata `organizationTypeCode`, then falls back
  to linked Client `clientType`.
- Client type now uses the same controlled organisation type option set as Product
  organisation type suitability.
- Confirmed Client type changes clear active selected Project Products for linked Projects
  that rely on Client type and do not have a Project-level Effective Organisation Type
  override.
- Project lifecycle state is editable from Project detail.
- C1 can correct linked Client for non-archived Projects.
- Closed and completed Projects can be reopened to Draft through the Project status actions.
- Existing Project update auditing continues to record Client link and Project update
  changes.

## Implementation Notes

No schema migration was introduced for this remediation pass.

Project Type already existed as `metadata.projectType` from the client-facing Project flow,
and the eligibility service already used it. The implementation surfaces that existing
context in the C1 Project detail UI.

Project Type is treated as the Project workflow context for Product eligibility. Catalogue
availability supplies the source Products, and Product suitability then filters that set by
Project workflow context. This is important for cases such as a Christmas Catalogue that
contains both towel and mug Products, where a Group Artwork Project may only be eligible
for the towel while an Individual Artwork Project may be eligible for both.

Because Project Type defines the workflow context, changing it invalidates active Project
Product selections. This remediation deactivates those selections instead of leaving stale
Products attached to the Project.

Effective Organisation Type was implemented as `metadata.organizationTypeCode` so one Client
can be evaluated differently per Project while a fuller tenant-managed option-set model is
deferred.

Client type is no longer free text on the C1 Client create/edit surfaces. It now uses the
same `SCHOOL`, `PLAYGROUP`, `CLUB`, `PTA_FRIENDS`, `CHARITY_COMMUNITY` and `OTHER` option
values as Product organisation suitability.

This pass does not change Product `Workflow Class`. That field remains separate from
multi-select Product suitability and should be handled carefully in later production/
fulfilment workflow design.

The Product modal now labels this as `Production Workflow Class` and explains that Project
eligibility is configured through Product Suitability.

## Input Location Map

This section records the Project Type and Organisation Type surfaces so future testing and
refinement do not miss one route.

Project Type / workflow context inputs:

- C1 Project creation:
  `src/modules/fund/components/projects/ProjectCreateModal.tsx`.
- C1 Project detail:
  `src/modules/fund/components/projects/ProjectDetailPage.tsx`.
- C2 / Client Dashboard Project modal:
  `src/modules/fund/components/client-dashboard/ClientProjectModal.tsx`.
- Public Project initiation form:
  `src/modules/fund/components/project-intake-public/PublicProjectInitiationForm.tsx`.
- Product Suitability Project Type multi-select:
  `src/modules/fund/components/availability/AvailabilityManager.tsx`.
- Project intake service labels and normalisation:
  `src/modules/fund/services/project-intake.service.ts`.
- Project/Product eligibility evaluation:
  `src/modules/fund/services/product-eligibility.service.ts`.
- Validation:
  `src/modules/fund/lib/validation/projects.ts`,
  `src/modules/fund/lib/validation/client-dashboard.ts` and
  `src/modules/fund/lib/validation/project-intake.ts`.

Organisation Type / Client Type inputs:

- Shared controlled option list:
  `src/modules/fund/lib/options.ts`.
- C1 Client creation:
  `src/modules/fund/components/clients/ClientCreateModal.tsx`.
- C1 Client detail:
  `src/modules/fund/components/clients/ClientDetailPage.tsx`.
- C1 Project detail Effective Organisation Type override:
  `src/modules/fund/components/projects/ProjectDetailPage.tsx`.
- Product Suitability Organisation Types multi-select:
  `src/modules/fund/components/availability/AvailabilityManager.tsx`.
- C1 Project Intake form create/edit allowed Client Types:
  `src/modules/fund/components/project-intake/ProjectIntakeFormsPage.tsx` and
  `src/modules/fund/components/project-intake/ProjectIntakeFormDetailPage.tsx`.
- Public Project initiation organisation type:
  `src/modules/fund/components/project-intake-public/PublicProjectInitiationForm.tsx`.
- Client type service and clearing behaviour:
  `src/modules/fund/services/clients.service.ts`.
- Project intake service labels, filtering and normalisation:
  `src/modules/fund/services/project-intake.service.ts`.
- Eligibility fallback from Project Effective Organisation Type to linked Client type:
  `src/modules/fund/services/product-eligibility.service.ts`.
- Validation:
  `src/modules/fund/lib/validation/clients.ts` and
  `src/modules/fund/lib/validation/project-intake.ts`.

Known follow-up/watch point:

- Project Intake approval still exposes a `Client Type` text input in
  `src/modules/fund/components/project-intake/ProjectIntakeApprovalPage.tsx`. This route
  should be reviewed before relying on the controlled Organisation Type model for intake
  approval workflows.

Related display-only/read surfaces include:

- `src/modules/fund/components/clients/ClientTable.tsx`;
- `src/modules/fund/components/projects/ProjectClientSelector.tsx`;
- `src/modules/fund/components/client-dashboard/ClientDashboardShell.tsx`.

## Recent UI Behaviour Addendum

The Project Products picker was simplified after operator testing:

- eligible Products now appear once in a single filterable table;
- Catalogue sources are shown as badges in a `Catalogues` column;
- Product search and Catalogue filtering sit above the table;
- adding a Product removes it from the eligible table while it remains selected;
- removed Products reappear if they are still eligible;
- the selected Products table now uses the headings `Product`, `Type` and `Price`;
- historical inactive memberships remain hidden from C1 and are still retained behind the
  scenes for data integrity.

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

Browser smoke should confirm that changing Project Type and Effective Organisation Type
changes Product eligibility in the Project Products tab as expected.
It should also confirm that changing Project Type on a Project with active selected
Products prompts C1, removes the active selections after confirmation and refreshes the
eligible Product list.
It should confirm the same stale-selection protection when Client type changes for linked
Projects that depend on Client type for organisation suitability.
The Project Products picker should also be smoke-tested as a single filterable eligible
Product table: Products available through multiple Catalogues should appear once, with
Catalogue source badges, and the selected Product table should use the simple `Product`,
`Type` and `Price` headings.
