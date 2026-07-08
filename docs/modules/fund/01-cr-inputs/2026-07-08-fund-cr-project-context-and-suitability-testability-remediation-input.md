# FUND CR Input - Project Context And Product Suitability Testability Remediation

Date: 2026-07-08
Module: FUND
Source: 1Q-G operator testing
Status: CR input captured for planning
Priority: High before Store/Orders/Commerce planning

## User Observation

During 1Q-G availability-to-selection testing, several data configuration roadblocks were
found. The core availability and eligibility implementation can work, but C1 does not yet
have enough Project and Product suitability controls to configure clean test cases or
correct real operational data safely.

The issue is not that Store or Commerce is missing. The issue is that the Project/Product
eligibility context is not yet fully maintainable from C1 UI.

## Findings

### Workflow / Project Type Clarification

The Project type / fundraising format is not a loose label. It is a workflow context that
constrains Product eligibility.

Example:

- a towel may be suitable for a Group Artwork Project because it can accommodate a
  composite of many images;
- a mug may be suitable for an Individual Artwork Project but not for Group Artwork;
- a Christmas Catalogue can still include both towel and mug Products;
- an Individual Artwork Project linked to the Christmas Catalogue may see both towel and
  mug;
- a Group Artwork Project linked to the same Christmas Catalogue may see only the towel
  because Product suitability filters the Catalogue contents by Project type.

This means:

- a Project should have one workflow/project type context;
- a Product may be suitable for several Project workflow types;
- standalone Projects still have a Project workflow type and must apply the same Product
  suitability constraints;
- Catalogue availability decides which Product set is in scope, while Product suitability
  decides which of those Products are appropriate for the Project workflow context.

`Workflow Class` on a Product should be treated carefully in later design. It may describe
the Product's operational/production workflow, but it must not replace the multi-select
Product suitability rules that decide which Project workflow types can use the Product.

### 1. Project Type Is Not Editable On Project Detail

Project type / fundraising format appears in the original Project creation modal, but is
not available on the Project detail CRUD page.

Impact:

- C1 cannot correct a Project after creation;
- C1 cannot reliably test Product suitability rules against Project type;
- a Project cannot be reclassified from, for example, artwork fundraising to bulk/logo
  order after discovery or correction.
- selected Project Products can persist after a Project type change, creating a production
  risk if Products that were valid for the previous Project workflow remain attached to the
  reclassified Project.

Safety rule:

```text
Project Type change invalidates active Project Product selections.
```

For the Phase 1 testing/configuration phase, C1 may change Project Type but the system must
clear active selected Project Products and refresh eligibility. Once Store, Orders or
Commerce exist, Project Type should become locked or require a dedicated guarded
reclassification workflow.

### 2. Client Organisation Type Needs Better Modelling

There is no tenant-managed Client type option set suitable for Product eligibility.

A Client may be several things at once, for example:

- school;
- playgroup;
- PTA / friends group;
- club;
- charity / community group;
- other.

Impact:

- a single fixed Client type may be too crude;
- Product organisation type suitability needs a clear evaluation context;
- C1 needs a way to decide which organisation context applies to a specific Project.
- free-text Client type can drift away from Product Suitability organisation type codes,
  leaving Projects with no matching eligibility context;
- changing Client type can invalidate active Project Product selections for linked Projects
  that rely on Client type rather than a Project-level override.

Possible direction:

- introduce tenant-managed Client organisation type options;
- allow a Client to carry multiple organisation type tags;
- allow a Project to carry an effective organisation type / suitability context for Product
  eligibility evaluation.

Phase 1 safety direction:

- Client type should use the same controlled organisation type options as Product
  Suitability;
- changing Client type should clear active selected Products for linked Projects that do
  not have a Project-level Effective Organisation Type override;
- Projects with an Effective Organisation Type override should not be changed by a Client
  type update.

### 3. Project Status And Lifecycle Are Not Correctable

Project status and lifecycle state are not editable in the Project detail UI.

Once a Project has been closed/completed, it cannot be reopened for correction or
reconfiguration. The UI currently has a complete action but not a controlled reopen/draft
path.

Impact:

- operator test Projects can become stuck;
- real Projects may require correction after accidental closure;
- later Store/Commerce readiness testing will need controlled lifecycle state management.

### 4. Project Client Scope Cannot Be Corrected After Creation

A Project cannot currently be re-scoped to a different Client after creation in the C1 UI.

This should be possible for C1 where a Project is misallocated. It should not be available
to C2 users.

Impact:

- Project ownership/context mistakes cannot be fixed cleanly;
- Product eligibility context can be wrong if the wrong Client remains linked;
- operational support requires database/manual intervention instead of controlled UI.

### 5. Product Suitability Needs A Summary Table

Product suitability is configurable from the Availability UI one Product at a time, but
there is no summary table showing Product suitability coverage.

Impact:

- C1 must open each Product settings surface individually;
- suitability management will not scale beyond a small Product set;
- testing becomes slow and error-prone because there is no at-a-glance view of which
  Products are restricted/unrestricted by Project type or organisation type.

Desired direction:

- add a Product suitability summary table;
- show each Product with Project type suitability and organisation type suitability;
- make "no active suitability rows" visibly mean unrestricted for that dimension;
- preserve one-at-a-time editing initially if that keeps the remediation bounded.

## Requested Outcome

Create a bounded remediation slice before Store/Orders/Commerce planning that gives C1
enough Project context and Product suitability visibility to complete 1Q-G.

The slice should make these actions possible:

- edit Project type / fundraising format from Project detail;
- clear active selected Project Products when Project type changes;
- model and select organisation type context in a way that supports multi-type Clients;
- use controlled organisation type choices for Client type, Project effective organisation
  type and Product organisation type suitability;
- clear affected Project Products when Client type changes and the Project depends on that
  Client type for eligibility;
- correct Project lifecycle/status, including controlled reopen from closed/completed;
- correct Project Client scope from C1 UI;
- review Product suitability in a summary table.

## Boundaries

This CR should not implement:

- Store;
- Orders;
- Commerce;
- payment flows;
- production/artwork/dispatch workflows;
- Product duplication;
- Catalogue duplication;
- per-Catalogue pricing;
- commission ladders;
- C2 permission to re-scope Projects between Clients.

## Acceptance Direction

This CR is ready for closure when:

- 1Q-G test data can be configured entirely through C1 UI;
- Product eligibility can be tested against editable Project type context;
- active Project Products are removed/refreshed when Project type changes;
- organisation type suitability has a clear Project/Client evaluation source;
- Client type cannot be mistyped into a value Product Suitability cannot match;
- Client type changes do not leave stale active Products on affected linked Projects;
- C1 can reopen/correct a Project lifecycle state where appropriate;
- C1 can correct Client scoping errors;
- Product suitability coverage can be reviewed without opening each Product individually.
