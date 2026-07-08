# FUND Phase 1 Slice 1Q-G-R1 - Availability Review And Store/Commerce Readiness Check

Date: 2026-07-07

Status: Complete PASS; promoted to staging

## 1. Slice

```text
1Q-G-R1 - Availability Review And Store/Commerce Readiness Check
```

Reviewed implementation chain:

```text
1Q-C - C1 Event Catalogue Availability API/Services
1Q-D - C1 Event Catalogue Availability UI
1Q-E - Project Product Eligibility API/Services
1Q-F - Catalogue-Centric Project Product Picker UI
```

This is a review and readiness test, not a new implementation slice.

## 2. Purpose

1Q-G proves the full FUND availability-to-selection path before Store, Orders or Commerce
planning begins.

The test answers:

```text
Can C1 configure Product availability and suitability, then select eligible Products into a
Project through the Catalogue-centric picker, without accidentally creating Store,
Commerce, duplication, pricing or commission behaviour?
```

This review should close the 1Q availability lane as a coherent tested baseline.

## Browser Smoke Result

Completed by user on local app `dev` after the 1Q-G remediation pass.

Result: complete PASS.

Accepted baseline:

- C1 can configure Event/Catalogue and standalone Catalogue availability.
- C1 can configure Product Project Type and Organisation Type suitability.
- C1 can create or correct Project Type, Effective Organisation Type, lifecycle state and
  linked Client where the C1 workflow permits it.
- Project Type and Organisation Type changes remove stale selected Project Products rather
  than leaving ineligible Products attached.
- Project Products are selected from eligible Products only.
- Products available through multiple Catalogues appear once in a single filterable table
  with Catalogue badges.
- Selected Project Products are represented once per Product.
- Store, Orders, Commerce, per-Catalogue pricing, commission and production workflow
  behaviour remain out of scope.

Promotion result:

- Completed on 2026-07-08.
- App `dev` commit: `ea4e619`.
- App `staging` commit: `ea4e619`.
- `origin/dev` and `origin/staging` are aligned for staging browser testing.
- Pre-promotion checks passed:
  - `npm run type-check`;
  - `git diff --check`.

## 2A. Operator Testing Finding - 2026-07-08

Operator testing found that the availability and Product picker logic is now testable in
principle, but several C1 configuration surfaces are missing the fields needed to create
clean Project/Product eligibility scenarios.

This is a hold for completing 1Q-G-R1. It is not a Store/Commerce issue and should be
remediated before Store, Orders or Commerce planning proceeds.

Findings:

- Project type / fundraising format is present in the original Project creation modal, but
  is not editable on the Project detail CRUD page.
- Because Project type is not editable on the Project detail page, C1 cannot reliably align
  a Project such as artwork fundraising, group personalised product or bulk/logo order with
  Product Project type suitability during test setup.
- Client organisation type is not currently represented as a tenant-managed option set.
  One Client may reasonably have several types, so a single fixed Client type is unlikely
  to be enough for long-term suitability decisions.
- Product eligibility needs a clear organisation-type evaluation context. This may need a
  Project-level effective organisation type, a multi-type Client model, or both.
- Project status/lifecycle state is not editable in the Project detail UI.
- A closed/completed Project cannot currently be reopened for correction or test
  reconfiguration. The UI has a complete action but no controlled reopen/draft/editable
  state transition.
- A Project cannot currently be re-scoped to a different Client after creation from the C1
  UI, even where it has been misallocated. C1 needs a controlled correction path; C2 should
  not have this ability.
- Product suitability is configurable one Product at a time, but there is no Product
  suitability summary table. This will not scale beyond a few Products because C1 cannot see
  Project type and organisation type suitability coverage at a glance.

Related remediation CR:

```text
docs/modules/fund/01-cr-inputs/2026-07-08-fund-cr-project-context-and-suitability-testability-remediation-input.md
```

Related planning slice:

```text
docs/modules/fund/03-slice-planning/2026-07-08-fund-phase-1-slice-1q-g-a-project-context-and-suitability-testability-remediation-planning.md
```

Implementation confirmation:

```text
docs/modules/fund/04-implementation-confirmations/2026-07-08-phase-1-slice-1q-g-a-project-context-and-suitability-testability-remediation-confirmation.md
```

## 2B. Operator Testing Finding - Availability UI Pattern

Further operator testing clarified that the Event Catalogue Availability and Product
Suitability issue is not only missing data fields. It is also a UI pattern problem.

The current Availability tab asks C1 to select one Event, then inspect/edit that Event's
Catalogues. Product suitability similarly asks C1 to select one Product, then inspect/edit
that Product's suitability. This hides the total management set and forces the operator to
switch record-by-record.

This conflicts with the IsoStack management pattern for element management:

- lists/tables should expose the management set;
- row click should open a modal for simple records;
- row click should open a child page for complex parent entities;
- Events are already defined in FUND planning as child-page entities;
- search/filter/sort controls should sit above list/table management surfaces;
- destructive or significant actions should not be tiny row icons.

The practical issue:

```text
C1 cannot see "all Events and their linked Catalogues" or "all Products and their
suitability coverage" at a glance.
```

The corrected pattern should be:

- Event Catalogue Availability: show an Event table/list with linked Catalogue counts and
  row click to an Event availability management surface, preferably the Event child page or
  an Event availability modal if kept bounded;
- Product Suitability: show a Product suitability summary table with Project type and
  organisation type coverage, row click to the Product suitability editor;
- standalone/default Catalogue availability: retain a table/list pattern because the whole
  Catalogue set is already visible and editable together.

Related remediation CR:

```text
docs/modules/fund/01-cr-inputs/2026-07-08-fund-cr-availability-management-ui-pattern-remediation-input.md
```

Related planning slice:

```text
docs/modules/fund/03-slice-planning/2026-07-08-fund-phase-1-slice-1q-g-b-availability-management-ui-pattern-remediation-planning.md
```

Implementation confirmation:

```text
docs/modules/fund/04-implementation-confirmations/2026-07-08-phase-1-slice-1q-g-b-availability-management-ui-pattern-remediation-confirmation.md
```

## 2C. Field Location Map - Project Type And Organisation Type

Use this map before future FUND eligibility testing, because Project Type and Organisation
Type are used in several legitimate places.

### Project Type / Workflow Context

Project Type is the single workflow context for a Project. Product Suitability may allow a
Product to be suitable for one or more Project Types.

Active input/edit surfaces:

- C1 Project creation modal:
  `/app/fund/projects`, create Project modal.
- C1 Project detail:
  `/app/fund/projects/[projectId]`, Project detail form.
- C2 / Client Dashboard Project modal:
  client dashboard Project modal.
- Public Project initiation form:
  public intake route generated from a Project Intake form.
- Product Suitability:
  `/app/fund/products`, Availability tab, Product Suitability modal, `Project Types`
  multi-select.

Important source locations:

- `src/modules/fund/components/projects/ProjectCreateModal.tsx`;
- `src/modules/fund/components/projects/ProjectDetailPage.tsx`;
- `src/modules/fund/components/client-dashboard/ClientProjectModal.tsx`;
- `src/modules/fund/components/project-intake-public/PublicProjectInitiationForm.tsx`;
- `src/modules/fund/components/availability/AvailabilityManager.tsx`;
- `src/modules/fund/services/product-eligibility.service.ts`;
- `src/modules/fund/lib/validation/projects.ts`;
- `src/modules/fund/lib/validation/client-dashboard.ts`;
- `src/modules/fund/lib/validation/project-intake.ts`.

Current Product Type labels/codes:

- `ARTWORK_FUNDRAISING` -> Individual Artwork Project;
- `GROUP_PERSONALISED_PRODUCTS` -> Group personalised product project;
- `BULK_ORDER_CLUB_FUNDED` -> Bulk order / club-funded project;
- `NOT_SURE` -> Not sure yet.

Do not confuse Project Type with Product `Production Workflow Class`. The workflow class is
a Product definition/fulfilment concept; eligibility is driven by Product Suitability
Project Type rows.

### Organisation Type / Client Type

Organisation Type is used to constrain Product eligibility by Client/Project context. The
Project Effective Organisation Type override wins first; if blank, eligibility falls back
to linked Client Type.

Active input/edit surfaces:

- C1 Client creation:
  `/app/fund/clients`, create Client modal.
- C1 Client detail:
  `/app/fund/clients/[clientId]`, Client detail form.
- C1 Project detail Effective Organisation Type override:
  `/app/fund/projects/[projectId]`, Project detail form.
- Product Suitability:
  `/app/fund/products`, Availability tab, Product Suitability modal, `Organisation Types`
  multi-select.
- C1 Project Intake form create/edit:
  Project Intake form `Allowed Client Types`.
- Public Project initiation form:
  visible organisation type options are filtered by the Project Intake form definition.

Important source locations:

- `src/modules/fund/lib/options.ts`;
- `src/modules/fund/components/clients/ClientCreateModal.tsx`;
- `src/modules/fund/components/clients/ClientDetailPage.tsx`;
- `src/modules/fund/components/projects/ProjectDetailPage.tsx`;
- `src/modules/fund/components/availability/AvailabilityManager.tsx`;
- `src/modules/fund/components/project-intake/ProjectIntakeFormsPage.tsx`;
- `src/modules/fund/components/project-intake/ProjectIntakeFormDetailPage.tsx`;
- `src/modules/fund/components/project-intake-public/PublicProjectInitiationForm.tsx`;
- `src/modules/fund/services/clients.service.ts`;
- `src/modules/fund/services/product-eligibility.service.ts`;
- `src/modules/fund/services/project-intake.service.ts`;
- `src/modules/fund/lib/validation/clients.ts`;
- `src/modules/fund/lib/validation/project-intake.ts`.

Current Organisation Type labels/codes:

- `SCHOOL` -> School;
- `PLAYGROUP` -> Playgroup;
- `CLUB` -> Club;
- `PTA_FRIENDS` -> PTA / Friends group;
- `CHARITY_COMMUNITY` -> Charity / community group;
- `OTHER` -> Other.

Known follow-up/watch point:

- Project Intake approval still has a `Client Type` text input in
  `src/modules/fund/components/project-intake/ProjectIntakeApprovalPage.tsx`. Before using
  intake approval as part of controlled Organisation Type testing, either remediate that
  route or explicitly record it as out of scope.

## 3. Source Documents

Implementation confirmations:

- `docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1q-c-c1-event-catalogue-availability-api-services-confirmation.md`
- `docs/modules/fund/04-implementation-confirmations/2026-07-01-phase-1-slice-1q-d-c1-event-catalogue-availability-ui-confirmation.md`
- `docs/modules/fund/04-implementation-confirmations/2026-07-01-phase-1-slice-1q-e-project-product-eligibility-api-services-confirmation.md`
- `docs/modules/fund/04-implementation-confirmations/2026-07-06-phase-1-slice-1q-f-catalogue-centric-project-product-picker-ui-confirmation.md`
- `docs/modules/fund/04-implementation-confirmations/2026-07-08-phase-1-slice-1q-g-a-project-context-and-suitability-testability-remediation-confirmation.md`
- `docs/modules/fund/04-implementation-confirmations/2026-07-08-phase-1-slice-1q-g-b-availability-management-ui-pattern-remediation-confirmation.md`

Prior review/test documents:

- `docs/modules/fund/05-review-and-test/2026-07-01-phase-1-slice-1q-d-r1-c1-event-catalogue-availability-ui-review-and-smoke-test.md`
- `docs/modules/fund/05-review-and-test/2026-07-01-phase-1-slice-1q-e-r1-project-product-eligibility-api-services-review-and-smoke-test.md`
- `docs/modules/fund/05-review-and-test/2026-07-06-phase-1-slice-1q-f-r1-catalogue-centric-project-product-picker-ui-review-and-smoke-test.md`

## 4. Review Scope

Included:

- Product to Catalogue membership visibility;
- Event to Catalogue availability;
- standalone/default Catalogue availability;
- Product Project type suitability;
- Product organisation type suitability;
- `fund.productEligibility.listForProject` behaviour as exposed through the Project
  Products tab;
- single-table eligible Product picker with Product search, Catalogue filter and Catalogue
  source badges;
- `FundProjectProduct` selected Product behaviour;
- warning/empty-source behaviour;
- boundary checks before Store/Orders/Commerce.

Excluded:

- Store;
- Orders;
- Commerce;
- payment flows;
- per-Catalogue pricing;
- commission ladders;
- Product duplication;
- Catalogue duplication;
- Product media galleries;
- Product option modelling;
- production/artwork/dispatch workflows;
- notifications;
- SeasonPro integration;
- Event-side Catalogue/Product management refinement parked as `2R-EVENT-05`.

## 5. Test Data Setup Recommendation

Use a small controlled set of test records so the behaviour is easy to see:

- one active Event;
- one Event-linked Project;
- one standalone Project;
- at least three active Catalogues:
  - one `EVENT_ONLY` or `EVENT_AND_STANDALONE`;
  - one `STANDALONE_ONLY` or `EVENT_AND_STANDALONE`;
  - one `INTERNAL_ONLY` Catalogue for exclusion checks;
- at least four Products:
  - Product A in one eligible Catalogue;
  - Product B in two eligible Catalogues;
  - Product C outside all eligible Catalogues;
  - Product D with restrictive suitability rules;
- at least one Product with no active suitability rows.

Avoid using real Store/Commerce concepts in the test notes. At this stage, the tested
output is selected Project Products only.

## 5A. Retest Addendum - 2026-07-08 Implementation Unblockers

Before rerunning the original 1Q-G smoke, confirm the remediation controls now work:

- create a standalone Project from the C1 Project creation modal;
- confirm Project Type is present during creation and is required;
- choose `Bulk order / club-funded project`, save, and confirm the Project detail page
  carries that same Project Type;
- open a Project detail page;
- confirm Project Type is visible and editable;
- confirm Effective Organisation Type is visible and editable;
- change Project Type to a value that should include/exclude a Product suitability rule;
- save and confirm the Project Products eligibility view reflects the change;
- in controlled data, use the same Catalogue for two Projects with different Project
  workflow types and confirm Product suitability changes the eligible Products within that
  same Catalogue;
- example: a Group Artwork Project linked to a Christmas Catalogue may see towel only,
  while an Individual Artwork Project linked to the same Christmas Catalogue may see towel
  and mug;
- confirm Product `Production Workflow Class` does not by itself make a Product eligible;
- confirm eligibility is driven by the Product Suitability Project Type values matching
  the Project Type;
- add one or more Products to a controlled Project;
- confirm eligible Products appear once in a single filterable table, with source Catalogues
  shown as badges in the Catalogue column;
- confirm added Products move out of the eligible Product list and appear only in the
  selected Project Products table;
- remove a Product from the Project;
- confirm it is removed from the selected Project Products table and reappears in the
  eligible Product list if still eligible;
- confirm inactive historical memberships are not presented to C1 as separate
  deactivate/reactivate rows;
- change the Project Type to a different value;
- confirm C1 is warned that selected Products will be removed;
- confirm save deactivates/removes active Project Product selections;
- confirm the Project Product picker refreshes and shows Products eligible for the new
  Project Type only;
- open a Client detail page;
- confirm Client Type is a dropdown using the same values as Product Suitability
  Organisation Types;
- with a linked Project that relies on Client type and has selected Products, change Client
  Type;
- confirm C1 is warned that affected Project Products will be removed;
- confirm affected linked Projects have active selected Products cleared and eligibility
  refreshes;
- confirm linked Projects with a Project-level Effective Organisation Type override are not
  cleared by the Client Type change;
- change Effective Organisation Type and confirm organisation suitability filtering reacts;
- confirm lifecycle state can be edited and saved;
- close or complete a controlled test Project, then use Reopen to Draft;
- confirm the Project becomes editable again;
- change linked Client on a non-archived Project as C1 and save;
- confirm cross-tenant Clients are not offered.

Availability pattern retest:

- open `/app/fund/products`;
- open Availability;
- confirm the page-level Availability surface contains tables, search/filter/sort controls
  and Add/configure buttons only;
- confirm Event Catalogue Availability has no page-level selected Event/Catalogue/date/edit
  inputs;
- confirm Product Suitability has no page-level selected Product or suitability multi-select
  inputs;
- confirm Standalone Catalogue Availability has no inline availability scope/default
  standalone edit inputs;
- in a controlled setup with exactly one active standalone-capable Catalogue and no
  explicit default standalone Catalogue, confirm the row is labelled `Auto default`;
- confirm standalone Project Product eligibility uses that Catalogue as the effective
  default;
- add or activate a second standalone-capable Catalogue in controlled test data only and
  confirm C1 must explicitly select a default rather than the system guessing;
- confirm clicking an Event row opens the Event Catalogue Availability modal;
- confirm `Configure Event` opens the same modal without preselecting an Event;
- confirm clicking a Product row opens the Product Suitability modal;
- confirm clicking a Catalogue row opens the Standalone Catalogue Availability modal;
- confirm modals own Save and Cancel actions;
- confirm modal saves refresh the page-level table summaries.

## 6. Product Manager Configuration Smoke

Route:

```text
/app/fund/products
```

Smoke steps:

1. Open the Products and Catalogues page as a FUND C1 admin.
2. Confirm Products, Catalogues and Availability tabs load.
3. Open a Product detail/edit modal.
4. Confirm the read-only Catalogue Memberships section shows linked Catalogues.
5. Open the Availability tab.
6. In Event Catalogues:
   - select the active Event;
   - add an active eligible Catalogue;
   - set active state;
   - set sort order;
   - optionally set availability dates;
   - save;
   - refresh and confirm the state reloads.
7. In Standalone Catalogue Availability:
   - set a Catalogue to a standalone-supporting scope;
   - mark one Catalogue as default standalone;
   - save;
   - refresh and confirm the state reloads.
8. In Product Suitability:
   - select a Product;
   - add matching Project type suitability;
   - add matching organisation type suitability;
   - save;
   - refresh and confirm the state reloads.

Expected result:

- configuration can be saved and reloaded;
- archived/inactive Events, Catalogues and Products are not offered through the default
  current-list UI;
- no Project Product rows are created by configuration alone.

## 7. Event-Linked Project Product Picker Smoke

Route shape:

```text
/app/fund/projects/[projectId]
```

Use an Event-linked Project where the linked Event has at least one active eligible
Catalogue.

Smoke steps:

1. Open the Project detail page.
2. Open the Products tab.
3. Confirm the Product picker loads from eligibility, not from the flat tenant Product list.
4. Confirm the source mode is Event-linked or otherwise clearly reflects Event Catalogue
   availability.
5. Confirm eligible Products appear once in a single table, with source Catalogue badges.
6. Confirm Product search and Catalogue filter narrow the eligible Product list.
7. Confirm Product A appears with its source Catalogue badge.
8. Confirm Product C, which is outside all eligible Catalogues, is not offered.
9. Select Product A.
10. Confirm one active `FundProjectProduct` membership is created/reactivated for Product A.
11. Remove/deactivate Product A from the selected Project Product list.
12. Reactivate Product A.
13. Reorder selected Products if more than one is present.

Expected result:

- Event Catalogue availability drives the source list;
- `FundProjectProduct` remains the selected Product list;
- selecting a Product creates/reactivates one selected Product membership;
- no Store, Orders or Commerce behaviour appears.

## 8. Standalone Project Product Picker Smoke

Use a standalone Project with no Event link.

Smoke steps:

1. Open the standalone Project detail page.
2. Open the Products tab.
3. Confirm the source mode is standalone/default Catalogue availability.
4. Confirm Products from active default standalone Catalogues are offered.
5. Confirm Event-only and internal-only Catalogues do not feed the standalone source list.
6. Select one eligible standalone Product.
7. Confirm the selected Product appears in the existing Project Product membership list.

Expected result:

- standalone/default Catalogue availability drives the source list;
- Event-only/internal-only source leakage does not occur.

## 9. Multi-Catalogue Deduplication Smoke

Use Product B, available through more than one eligible source Catalogue.

Smoke steps:

1. Confirm Product B appears with multiple source Catalogue references or contextual source
   display.
2. Confirm Product B appears once in the eligible Product table, with multiple Catalogue
   badges.
3. Select Product B.
4. Save or allow the existing mutation to complete.
5. Confirm only one selected Project Product membership exists for Product B.
6. Confirm Product B is removed from the eligible Product table while selected.
7. Remove/deactivate Product B.
8. Confirm Product B reappears once in the eligible Product table if still eligible.

Expected result:

```text
Catalogue context explains availability.
Product identity controls selection.
```

Product B must not create duplicate `FundProjectProduct` rows merely because it is available
through multiple Catalogues.

## 10. Suitability Smoke

Use Products with known Project type and organisation type suitability rules.

Smoke steps:

1. Configure Product D with a Project type suitability that does not match the Project.
2. Confirm Product D is not offered after source availability passes.
3. Change Product D suitability to match the Project type.
4. Confirm Product D becomes eligible.
5. Configure Product D with an organisation type suitability that does not match the
   Project/Client context.
6. Confirm Product D is filtered out where organisation type context is available.
7. Use a Product with no active Project type suitability rows.
8. Confirm that Product remains eligible after source availability passes.
9. Use a Product with no active organisation type suitability rows.
10. Confirm that Product remains eligible after source availability passes.

Expected result:

- active suitability rows restrict eligibility;
- no active suitability rows mean unrestricted for that dimension;
- source availability remains mandatory.

## 11. Warning And Empty-State Smoke

Smoke steps:

1. Open an Event-linked Project where the Event has no active source Catalogues.
2. Confirm the Products tab shows an empty source/eligible Product result with a warning.
3. Open a standalone Project where no default standalone Catalogue exists.
4. Confirm the Products tab shows an empty source/eligible Product result with a warning.
5. Open a Project where organisation type context is missing but otherwise valid.
6. Confirm a warning appears rather than a total failure.

Expected result:

- missing source availability does not create Products;
- warnings are visible enough for C1 diagnosis;
- the picker does not silently fall back to all tenant Products.

## 12. Regression Boundary Smoke

Confirm the following are not introduced:

- automatic `FundProjectProduct` creation before Product selection;
- Product duplication;
- Catalogue duplication;
- per-Catalogue pricing;
- per-Catalogue commission;
- Store display;
- Orders;
- Commerce;
- payment surfaces;
- production/artwork/dispatch surfaces;
- notifications;
- SeasonPro integration.

## 13. Recommended Developer Checks

If code has changed since the last accepted 1Q-F smoke, rerun:

```text
npm run type-check
npm run verify
git diff --check
```

If no code has changed and this is operator browser testing only, record:

```text
No code changes in 1Q-G-R1. Review/test only.
```

## 14. Pass / Hold Criteria

Pass when:

- C1 can configure Event Catalogue availability and standalone/default availability;
- C1 can configure Product suitability;
- Event-linked Project Product picker offers only eligible Event Catalogue Products;
- standalone Project Product picker offers only eligible standalone/default Catalogue Products;
- multi-Catalogue Product availability deduplicates by Product identity;
- selected Products create/reactivate one `FundProjectProduct` membership per Product;
- warnings appear for missing source availability;
- no Store/Orders/Commerce or duplication/pricing/commission behaviour appears.

Hold if:

- Project type/fundraising format cannot be edited after Project creation;
- Project lifecycle/status cannot be corrected or reopened by C1;
- Project Client scoping cannot be corrected by C1 after creation;
- Product suitability can only be inspected one Product at a time and there is no summary
  table for test setup/review;
- Event Catalogue availability can only be inspected by switching a single Event selector
  and there is no table/list overview of Events and linked Catalogue coverage;
- the picker falls back to all tenant Products;
- source Catalogue context is missing or misleading;
- selecting the same Product through multiple Catalogues creates duplicate selected Product
  memberships;
- suitability rules are ignored;
- unavailable Products can be selected;
- Store/Orders/Commerce behaviour appears before the readiness decision.

## 15. Expected Review Outcome

If passed, record:

```text
1Q-G-R1 passes. The 1Q availability-to-selection lane is accepted as a tested baseline.
Proceed to Store/Orders/Commerce readiness planning or a bounded UX refinement slice.
```

If partially passed, record exact defects and decide whether they are:

- blockers before Store/Commerce planning;
- deferred UX refinements;
- Phase 2 wishlist items.

## 16. Likely Next Planning Options After Pass

Option A - core next step:

```text
Store/Orders/Commerce readiness planning.
```

Option B - bounded refinement before Commerce:

```text
Event-side Catalogue/Product visibility refinement (`2R-EVENT-05`).
```

Option C - Product Manager refinement:

```text
Product-side Catalogue membership management, Product media/options planning or Catalogue
presentation polish.
```
