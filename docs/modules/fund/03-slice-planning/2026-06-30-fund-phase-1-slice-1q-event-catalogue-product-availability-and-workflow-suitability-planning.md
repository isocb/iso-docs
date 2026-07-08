# FUND Phase 1 Slice 1Q - Event/Catalogue/Product Availability And Workflow Suitability Planning

Date: 2026-06-30

Status: Planning

## 1. Slice Goal

Plan the core availability layer that decides which Products are eligible for Event-linked and standalone FUND Projects.

This is a core architecture slice, not Phase 2 polish, because Store, Orders, Commerce, Client dashboard Project creation and production workflows all depend on knowing which Products a Project is allowed to use.

This planning slice does not implement application code, Prisma schema changes, migrations, Store, Orders, Commerce, production workflows, Product media galleries or public Store UI.

## 2. Current Implemented State

Current schema supports:

- Products;
- Product workflow class default;
- Catalogues;
- Catalogue-to-Product membership;
- Events;
- Projects linked to Events;
- Projects linked to Products through Project Product membership.

Current schema does not yet support:

- Event-to-Catalogue availability;
- Event-to-ad-hoc Product availability;
- standalone/default Project Catalogue availability;
- Product suitability sets beyond a Product's default workflow class;
- Event-specific Product eligibility rules;
- Project-level inherited availability snapshots.

## 3. Accepted Product Model Direction

Events were envisaged as fundraising campaigns or operating windows that can expose suitable Catalogues of Products.

Expected concept:

```text
Event
-> one or more available Catalogues
-> Products from those Catalogues
-> Project selects/deselects eligible Products
-> Store/Orders later expose only Project-selected Products
```

Standalone Projects should also be able to select Products, but from standalone/default availability configured by the C1 tenant rather than from an Event.

Both Event-linked and standalone Projects should be able to select or deselect eligible Products based on the Project type, Product suitability and C1 tenant rules.

## 4. Event-Linked Product Availability

Event-linked Projects should normally inherit Product availability from the linked Event.

Planning should decide:

- whether an Event can link to multiple Catalogues;
- whether a Catalogue can be linked to multiple Events;
- whether Event/Catalogue links carry sort order;
- whether Event/Catalogue links can be active/inactive;
- whether Event/Catalogue links can have date windows;
- whether Event/Catalogue links can limit Product workflow suitability;
- whether Product eligibility is recalculated live or snapshotted to the Project at creation/approval.

Recommended initial direction:

```text
FundEventCatalogue
```

as a same-tenant join model between `FundEvent` and `FundCatalogue`.

Potential fields:

- id;
- organizationId;
- eventId;
- catalogueId;
- isActive;
- sortOrder;
- availableFrom;
- availableUntil;
- metadata;
- createdById;
- updatedById;
- createdAt;
- updatedAt.

## 5. Event Ad-Hoc Products

Some Events may need Products that are specific to that Event or campaign and do not justify a broader Catalogue.

Planning should decide whether to support:

```text
FundEventProduct
```

as an optional same-tenant Event-to-Product availability model.

Use cases:

- one-off campaign Product;
- limited Event-only Product;
- temporary Product before Catalogue curation;
- Product override for a specific Event.

Guardrails:

- ad-hoc Event Products should not bypass Product status, archive state or tenant scope;
- ad-hoc Event Products should not create Store/Commerce behaviour by themselves;
- ad-hoc Event Product availability should be visible/auditable to C1 admins.

## 6. Standalone Project Availability

Standalone Projects are not linked to an Event, but they still need an explicit source of eligible Products.

Planning should decide whether standalone availability comes from:

- tenant default Catalogue(s);
- Catalogue flagged as suitable for standalone Projects;
- Project type-specific Catalogue(s);
- explicit C1 Project Product selection;
- future Client dashboard allowed Catalogues.

Recommended initial direction:

- do not assume every active Product is available to standalone Projects;
- define a tenant-controlled standalone/default availability set;
- preserve Project-level selection/deselection before Store generation.

## 7. Project Product Selection And Inheritance

Project Product membership should remain the operational Product selection for a Project.

Availability is the source list; Project Product membership is the selected list.

Concept:

```text
Event/Catalogue/Product availability
-> eligible Product list
-> Project Product picker
-> FundProjectProduct selected Products
```

Planning should decide:

- whether Project creation auto-selects all eligible Products by default;
- whether C1 or C2 can deselect Products;
- whether C2 can add Products beyond inherited availability;
- whether C1 approval is required for ad-hoc Product additions;
- whether the selected Product list is locked once Store/Orders exist;
- whether changing Event/Catalogue availability later affects existing Projects.

Recommended initial direction:

- Project should inherit eligible Products from Event/default availability;
- Project should be able to select/deselect from that eligible set;
- Project should not silently gain or lose Store Products after orders exist;
- Store generation should use `FundProjectProduct`, not raw Event/Catalogue membership.

## 8. Project Type And Workflow Suitability

The public initiation form and Client dashboard will ask for Project type/format.

Client-facing Project types include:

- Individual Artwork Project;
- Group personalised product project;
- Bulk order / club-funded project;
- Not sure yet.

Do not expose internal workflow class names to public respondents or C2 Client users unless deliberately planned.

Planning should decide how Project type maps to Product suitability:

- Product-level suitability;
- Catalogue membership suitability;
- Event availability suitability;
- Project Product workflow snapshot;
- C1 override at Project setup.

Current stabilising interpretation:

- `FundProduct.workflowClassId` is the Product's default/initial operational classification;
- `FundProjectProduct.workflowClassId` is the Project Product operational snapshot;
- a future suitability layer may allow one Product to support multiple Project types/workflows.

## 9. Product Refinement Boundary

Product definition needs more work, but not all of it belongs in this core availability slice.

Core for 1Q:

- Product eligibility;
- Catalogue membership;
- Event availability;
- Project selection/deselection;
- workflow suitability;
- Store/Commerce readiness.

Deferred to refinement unless Store MVP requires it:

- Product image gallery;
- Product option definition;
- Product option-to-image mapping;
- richer Product public presentation;
- catalogue merchandising layout;
- Product media upload UX;
- variant/option visual previews.

Relevant refinement wishlist entries:

```text
2R-PRODUCT-01 - Product Media, Gallery And Option Definition Planning
2R-PRODUCT-02 - Product Option Image Mapping Planning
2R-CATALOGUE-01 - Catalogue Presentation And Availability Refinement
```

## 10. Store/Orders/Commerce Impact

Store and order features should not be implemented until Product eligibility is explicit.

Store generation should answer:

- which Project is this Store for?
- which Client owns the Project?
- is the Project Event-linked or standalone?
- which Products were selected for the Project?
- are the Products active and eligible?
- which Product options are orderable?
- do Product options need images or templates?
- what happens if the Event/Catalogue/Product availability changes after orders exist?

Core rule:

```text
Store exposes Project-selected Products, not every active Product in the tenant.
```

## 11. Client Dashboard Impact

The Client dashboard should eventually support:

- Event-linked Project creation;
- standalone Project creation;
- Product selection/deselection where allowed;
- template/resource downloads;
- later Store/sales monitoring.

Client dashboard Project creation should not expose all Products blindly. It should consume the same availability rules defined by this slice.

## 12. C1 Admin Impact

C1 admins will need to manage:

- Event Catalogue availability;
- Event ad-hoc Product availability if supported;
- standalone/default Catalogue availability;
- Product suitability or workflow compatibility;
- Project Product selection and overrides;
- Product eligibility warnings before Store launch.

These controls should follow existing FUND admin UI patterns and avoid burying availability rules inside free-text metadata.

## 13. Security And Tenant Guardrails

Required guardrails:

- same-tenant Event/Catalogue/Product relations;
- archived Events, Catalogues or Products should not be newly selectable;
- inactive availability links should not feed new Project Product selection;
- C2 users should not access supplier/internal Product configuration unless explicitly exposed;
- public forms should not reveal internal supplier Product records;
- Client dashboard must derive Client/account context from authenticated membership, not request input.

## 14. Implementation Split

Recommended future split:

```text
1Q-A - Event/Catalogue/Product Availability Schema Options
1Q-B - Event/Catalogue Availability Schema Implementation
1Q-C - C1 Event Catalogue Availability API/Services
1Q-D - C1 Event Catalogue Availability UI
1Q-E - Project Product Eligibility API/Services
1Q-F - Catalogue-Centric Project Product Picker UI Remediation
1Q-G - Availability Review And Store/Commerce Readiness Check
```

Only start this implementation sequence when the current Client dashboard/access model planning confirms whether Product selection is needed before Store/Commerce.

## 15. Explicit Non-Goals

This planning slice does not implement:

- schema changes;
- migrations;
- Event-to-Catalogue code;
- Event-to-Product code;
- Product media galleries;
- Product option modelling;
- Store;
- Orders;
- Commerce;
- payments;
- production batching;
- Client dashboard UI;
- SeasonPro integration.

## 16. Recommended Next Step

Keep `1Q` as a core architecture lane that must be resolved before Store/Orders/Commerce implementation.

Do not treat Event/Catalogue/Product availability as Phase 2 polish.

Treat Product image galleries, Product options, option-image mapping and catalogue presentation as Phase 2 refinement unless they become Store MVP blockers.
