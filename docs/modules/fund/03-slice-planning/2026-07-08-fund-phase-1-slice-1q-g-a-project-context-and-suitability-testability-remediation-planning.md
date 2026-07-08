# FUND Phase 1 Slice 1Q-G-A - Project Context And Suitability Testability Remediation Planning

Date: 2026-07-08
Module: FUND
Related CR: `docs/modules/fund/01-cr-inputs/2026-07-08-fund-cr-project-context-and-suitability-testability-remediation-input.md`
Related review hold: `docs/modules/fund/05-review-and-test/2026-07-07-phase-1-slice-1q-g-r1-availability-review-and-store-commerce-readiness-check.md`
Status: Planning ready for review
Priority: High before Store/Orders/Commerce readiness

## 1. Purpose

1Q-G testing found that the availability-to-selection lane cannot be fully tested from C1
UI because key Project context and Product suitability review controls are missing.

1Q-G-A should remediate the C1 configuration surfaces needed to complete 1Q-G. It should
not start Store, Orders or Commerce.

## 2. Goal

Give C1 enough controlled UI to configure and correct the context used by Product
eligibility:

- Project type / fundraising format;
- organisation type suitability context;
- Project lifecycle/status correction;
- Project Client scope correction;
- Product suitability coverage review.

## 3. Product Principle

Eligibility rules are only useful if C1 can see and maintain the data that drives them.

The 1Q-E service and 1Q-F picker are structurally sound, but Store/Commerce planning should
not proceed until the operator can configure realistic Project/Product eligibility scenarios
without database intervention.

Project workflow type is a Product eligibility context, not merely a reporting label.

For example, the same Christmas Catalogue may contain towels and mugs, but a Group Artwork
Project may only be eligible for the towel if the mug cannot support a composite artwork
workflow. An Individual Artwork Project linked to the same Catalogue may be eligible for
both. Standalone Projects also carry one workflow/project type and must apply the same
suitability constraints.

This planning slice therefore preserves the distinction:

- Catalogue availability controls which Products are in the source set;
- Product suitability controls which Products from that source set are appropriate for the
  Project workflow type and organisation context;
- Product `Workflow Class` may describe fulfilment/production behaviour, but it should not
  replace the multi-select Product suitability rules that support multiple Project workflow
  types per Product.

## 4. Scope

### Included

- inspect current Project create/edit/detail model and UI;
- expose Project type / fundraising format on the Project detail edit surface;
- define the minimal organisation type context needed for Product eligibility;
- add controlled C1 Project lifecycle/status correction, including reopen from
  closed/completed where safe;
- add C1-only Project Client re-scope/correction UI;
- add Product suitability summary table in the Product Manager Availability area;
- update 1Q-G review/test checklist after implementation.

### Excluded

- Store;
- Orders;
- Commerce;
- payment flows;
- Product duplication;
- Catalogue duplication;
- per-Catalogue pricing;
- commission ladders;
- Product media galleries;
- Product option modelling;
- production/artwork/dispatch workflows;
- notifications;
- SeasonPro integration;
- C2 ability to move Projects between Clients.

## 5. 1Q-G-A1 - Project Type / Fundraising Format Editability

Problem:

```text
Project type is captured during creation but is not editable on Project detail.
```

Implement:

- show Project type / fundraising format on Project detail;
- allow C1 to edit it through the Project CRUD/detail UI;
- warn C1 when changing Project type would remove active selected Project Products;
- deactivate active selected Project Products when Project type changes;
- refresh Product eligibility after the change so the picker reflects the new Project
  workflow context;
- use the same accepted option labels/codes as Project creation and Product suitability:
  - Individual Artwork Project;
  - Group personalised product project;
  - Bulk order / club-funded project;
  - Not sure yet;
- refresh Product eligibility after Project type change.

Acceptance:

- C1 can change Project type after creation;
- Product suitability filtering reflects the changed Project type;
- Products selected under the previous Project type do not remain active after the change;
- C2 cannot use this as a cross-Client or tenant escape route.

## 6. 1Q-G-A2 - Organisation Type Suitability Context

Problem:

```text
Client organisation type is not tenant-managed and a Client may have several valid types.
```

Planning decision required before implementation:

- should Client carry multiple organisation type tags?
- should Project carry an effective organisation type for Product eligibility?
- should the Project effective organisation type be selected from Client tags, tenant
  options or the stable first-pass option list?

Recommended bounded direction:

- introduce or expose a Project-level effective organisation type for Product eligibility;
- allow later evolution to multi-type Client tags without blocking 1Q-G;
- use the same controlled organisation type option values for Client type, Project
  effective organisation type and Product organisation type suitability;
- replace free-text Client type editing with a dropdown;
- when Client type changes, clear active selected Products for linked Projects that rely on
  Client type rather than a Project-level Effective Organisation Type override;
- keep labels aligned with current Product suitability codes until tenant-managed option
  sets are planned:
  - School;
  - Playgroup;
  - Club;
  - PTA / Friends group;
  - Charity / community group;
  - Other.

Acceptance:

- Product organisation type suitability has a visible evaluation source;
- C1 can configure the source for test Projects;
- missing organisation type context is intentional and visible, not accidental.
- Client type values cannot drift from Product Suitability organisation type values.
- Client type changes do not leave stale active Products selected on Projects that depend
  on the Client type.

## 7. 1Q-G-A3 - Project Lifecycle / Status Correction

Problem:

```text
Closed/completed Projects cannot be reopened or corrected from Project detail.
```

Implement:

- expose current Project lifecycle/status clearly on Project detail;
- add controlled C1-only lifecycle/status correction where safe;
- include a reopen path from closed/completed to an editable state such as draft or active;
- preserve audit/history for lifecycle changes;
- make destructive or Commerce-relevant states safer once Store/Orders exists.

Acceptance:

- C1 can recover a mistakenly closed Project for reconfiguration/testing;
- completion remains deliberate;
- lifecycle correction does not create Store/Order/Commerce side effects.

## 8. 1Q-G-A4 - Project Client Scope Correction

Problem:

```text
Project Client linkage cannot be corrected after creation in C1 UI.
```

Implement:

- show linked Client clearly on Project detail;
- allow C1 to re-scope a Project to a different same-tenant Client;
- require explicit confirmation;
- write an audit event;
- refresh eligibility context after Client change;
- block this ability for C2 users.

Acceptance:

- C1 can correct a misallocated Project;
- C2 cannot move Projects between Clients;
- cross-tenant Client reassignment is impossible.

## 9. 1Q-G-A5 - Product Suitability Summary Table

Problem:

```text
Product suitability is only visible one Product at a time.
```

Implement:

- add a Product suitability summary table to Product Manager Availability;
- show Product code/name/status;
- show Project type suitability summary;
- show organisation type suitability summary;
- make unrestricted dimensions explicit, for example `All / unrestricted`;
- keep existing one-Product-at-a-time edit flow initially unless a small inline edit is
  clearly safer.

Acceptance:

- C1 can review suitability coverage across many Products;
- products with no active suitability rows are visibly unrestricted for that dimension;
- C1 can identify why a Product should or should not appear in a Project picker.

## 10. Review And Test Plan

After implementation:

- rerun 1Q-G-R1;
- create a Project;
- edit Project type from Project detail;
- confirm Product eligibility changes accordingly;
- configure organisation type context;
- confirm Product organisation type suitability filters accordingly;
- close/complete a test Project;
- reopen it to an editable state;
- change linked Client from C1 UI;
- confirm Product eligibility refreshes;
- open Product suitability summary;
- confirm all Products and suitability dimensions are visible at a glance.

Developer checks:

```text
npm run type-check
npm run verify
git diff --check
```

## 11. Risks

- overbuilding tenant-managed option sets before the minimal eligibility context is clear;
- allowing C2 users to change Project ownership or lifecycle inappropriately;
- lifecycle changes becoming unsafe once Store/Orders exists;
- confusing Client type and Project effective organisation type;
- Product suitability summary becoming a large Product management redesign.

## 12. Mitigations

- keep the first implementation C1-only;
- preserve same-tenant checks;
- write audit events for Client and lifecycle corrections;
- keep Product suitability summary read-first;
- defer full tenant-managed option set expansion if needed, but do not hide the current
  effective organisation type from C1.

## 13. Suggested Handoff Prompt

```text
Proceed with FUND Phase 1 Slice 1Q-G-A on local app dev. Keep the work limited to C1
Project context/editability remediation and Product suitability summary visibility needed
to complete 1Q-G. Do not implement Store, Orders, Commerce, Product duplication,
Catalogue duplication, pricing, commission, production, dispatch, notifications or
SeasonPro integration. Stop and report if organisation type context requires a larger
schema/options split before implementation.
```
