# FUND Phase 1 Slice 1Q-A - Product/Catalogue Suitability Schema Options Planning

Date: 2026-06-30

Status: Planning

## 1. Slice Goal

Plan the smallest safe schema direction for the Product Manager availability layer.

This layer decides which Products and Catalogues are suitable for:

- Event-linked Projects;
- standalone Projects;
- different fundraising Project types/formats;
- later Store/Orders/Commerce;
- later production and fulfilment workflows.

This is core architecture, not Phase 2 refinement, because selling and making both depend on Product eligibility.

## 2. Product Manager Meaning

In this context, Product Manager means the C1 tenant-facing Product/Catalogue administration surface and supporting data model.

It should let C1 decide:

- which Products exist;
- which Products belong to which Catalogues;
- which Catalogues are available for Events;
- which Catalogues are available for standalone Projects;
- which Products are suitable for which Project type/format;
- which Products can later be selected into a Project.

It should not expose supplier/internal management language to C2 Client users or public form respondents.

## 3. Current Implemented Foundation

Current FUND implementation already has:

- `FundProduct`;
- `FundCatalogue`;
- `FundCatalogueProduct`;
- `FundEvent`;
- `FundProject`;
- `FundProjectProduct`;
- Project type / fundraising format captured in public Project initiation submissions;
- Project type / fundraising format captured in C2 Client dashboard Project metadata.

Current implementation does not yet have:

- Event-to-Catalogue availability;
- Event-to-ad-hoc Product availability;
- standalone/default Catalogue availability;
- Product suitability by Project type/format;
- Product suitability by Client organisation type;
- Project Product inheritance from Event/Catalogue availability;
- Product eligibility warnings before Store launch.

## 4. Why This Comes Next

Product/Catalogue suitability should come before Store/Orders/Commerce and before production implementation because:

- Store must know which Products a Project may sell;
- Orders must reference Project-selected Products, not every tenant Product;
- production must know which Product/workflow rules apply;
- Event-linked Projects need availability inherited from their Event;
- standalone Projects need an explicit tenant-approved Product source;
- C2 Client Project creation already captures Project type/format and will later need Product constraints.

Core rule:

```text
Store exposes Project-selected eligible Products, not every active Product in the tenant.
```

## 5. Project Type / Fundraising Format

The accepted first Project type/format options are:

- Individual Artwork Project;
- Group personalised product project;
- Bulk order / club-funded project;
- Not sure yet.

These are tenant/public-facing fundraising formats, not internal workflow class labels.

The schema planning should decide whether these remain:

- fixed application enum values;
- tenant-configurable option records;
- a hybrid where system defaults can be extended by tenant options.

Preferred planning direction:

```text
Start with stable system codes, but do not block future tenant-configurable labels/descriptions.
```

## 6. Three-Gate Product Eligibility Model

Product eligibility should be understood as three gates before C2 Project organiser selection.

Gate 1: Product source / availability

```text
Event-linked Project
-> Products from Event-linked Catalogues and/or Event ad-hoc Product lists

Standalone Project
-> Products from standalone/default Catalogues or standalone-approved Product lists
```

C1 controls this availability when managing Events, Catalogues and Product Manager configuration.

Gate 2: Project type suitability

```text
Project type / fundraising format
-> only Products suitable for that Project type remain eligible
```

Each Product may be suitable for one or more Project types. The Project itself has one selected Project type/format. For example, an artwork fundraising Project should not expose Products that are not suitable for artwork workflows.

Gate 3: Client organisation type suitability

```text
Client organisation type
-> only Products suitable for that organisation type remain eligible
```

Products may be suitable for one or more organisation types. For example, a Product may be appropriate for primary schools but not appropriate for sports clubs, or suitable for clubs but not for PTA/Friends group workflows.

After those three gates:

```text
Eligible Products
-> C2 Project organiser can accept the full set or deselect Products they do not want to offer
-> selected Products become FundProjectProduct records
```

This means C2 selection is a subset selection from approved eligibility, not unrestricted Product browsing.

## 7. Schema Option A - Minimal Event Catalogue Link

Add:

```text
FundEventCatalogue
```

Purpose:

```text
Event
-> available Catalogues
-> eligible Products
```

Potential fields:

- `id`;
- `organizationId`;
- `eventId`;
- `catalogueId`;
- `isActive`;
- `sortOrder`;
- `availableFrom`;
- `availableUntil`;
- `metadata`;
- `createdById`;
- `updatedById`;
- `createdAt`;
- `updatedAt`.

Pros:

- small;
- matches Event-linked Project inheritance;
- supports multiple Catalogues per Event;
- keeps Product Manager rules out of free-text metadata.

Cons:

- does not solve standalone availability by itself;
- does not solve Project type suitability by itself;
- may need a second pass before Store/Product picker implementation.

## 8. Schema Option B - Catalogue Availability Scope

Add availability fields to `FundCatalogue`, for example:

```text
availabilityScope
```

Potential values:

- `EVENT_ONLY`;
- `STANDALONE_ONLY`;
- `EVENT_AND_STANDALONE`;
- `INTERNAL_ONLY`.

Pros:

- simple standalone Project availability source;
- helps C1 distinguish operational catalogues from sellable/default catalogues.

Cons:

- coarse-grained;
- may not support Event-specific availability windows;
- may not support Project type suitability cleanly.

## 9. Schema Option C - Product/Catalogue Suitability Rules

Add a suitability layer that connects Products and/or Catalogue membership to Project type/format and Client organisation type.

Possible model directions:

```text
FundProductSuitability
```

or:

```text
FundCatalogueProductSuitability
```

Potential fields:

- `id`;
- `organizationId`;
- `productId`;
- `catalogueId` or `catalogueProductId`;
- `projectTypeCode`;
- `organizationTypeCode`;
- `workflowClassId` if needed;
- `isActive`;
- `metadata`;
- timestamps/audit fields.

Pros:

- can make one Product suitable for multiple Project types;
- can make one Product suitable for multiple organisation types;
- does not force Product workflow class to be the only suitability rule;
- supports later Product picker filtering.

Cons:

- more schema and UI work;
- needs careful wording so C1 users understand suitability without seeing internal workflow jargon;
- may be overkill before Store MVP unless Product filtering is needed immediately.

## 10. Schema Option D - Event Ad-Hoc Products

Optionally add:

```text
FundEventProduct
```

Purpose:

```text
Event
-> one-off Product availability
```

Use cases:

- campaign-specific Products;
- temporary Event Products;
- limited edition Products;
- Event override before a Product is curated into a Catalogue.

Guardrail:

This must not bypass Product status, archive state, tenant scope or Project-level Product selection.

## 11. Recommended Initial Direction

Recommended direction for implementation planning:

1. Add `FundEventCatalogue` for Event-to-Catalogue availability.
2. Add a lightweight standalone/default Catalogue availability marker.
3. Keep Project type/format as stable system codes in the first pass.
4. Decide whether Product suitability belongs first at:
   - Product level;
   - Catalogue Product membership level;
   - Event Catalogue availability level.
5. Include Client organisation type suitability in the suitability decision, even if the first implementation keeps organisation types as stable system/default codes.
6. Use `FundProjectProduct` as the selected Product list for a Project.

Do not generate Store Products directly from Event/Catalogue links.

## 12. Product Picker Implications

Future Product picker should use:

```text
Project
-> Event or standalone status
-> available Catalogues
-> eligible Products
-> Project type suitability
-> Client organisation type suitability
-> Project Product selected list
```

C2 Client users should only see tenant-approved Product choices that are safe to expose.

C1 Product Manager users should see more configuration detail, including Product/Catalogue availability and suitability rules.

The C2 Project organiser should then be able to:

- accept the full eligible Product set;
- deselect Products they do not want to offer;
- see clear messaging when no Products are eligible because of Event, Project type or organisation type gates.

## 13. Store/Orders/Production Boundary

This slice does not implement:

- Store;
- Orders;
- Commerce;
- payments;
- Product option ordering;
- production batching;
- dispatch;
- commission.

It should produce the eligibility foundation those later workflows consume.

## 14. Deferred Refinement

Defer to Phase 2 refinement unless Store MVP requires earlier work:

- Product media gallery;
- Product option definition;
- Product option-to-image mapping;
- richer Catalogue presentation;
- campaign merchandising layout;
- Product media upload UX.

These are important, but they are not the same as Product eligibility.

## 15. Security And Tenant Guardrails

Any implementation must preserve:

- same-tenant Event/Catalogue/Product relations;
- archived records not newly selectable;
- inactive availability links not feeding new Project selection;
- no public exposure of supplier/internal Product configuration unless planned;
- C2 Product selection only through authenticated Client context;
- no Client ownership inferred from Product choices.

## 16. Implementation Boundary

Planning only.

Product and Catalogue duplication is deliberately deferred from 1Q. This slice is the availability/eligibility layer: it decides which Catalogues and Products are suitable for Events, standalone Projects and Project types. Duplication belongs to Product Manager authoring refinement, where complex Product details, options, images/media, SKU/reference policy, audit history and idempotency can be planned properly.

Do not implement:

- application code;
- Prisma schema;
- migrations;
- Product picker UI;
- Store;
- Orders;
- Commerce;
- production;
- notifications.

## 17. Accepted Implementation Sequence

```text
1Q-A - Event/Catalogue/Product Availability Schema Options
1Q-B - Event/Catalogue Availability Schema Implementation
1Q-C - C1 Event Catalogue Availability API/Services
1Q-D - C1 Event Catalogue Availability UI
1Q-E - Project Product Eligibility API/Services
1Q-F - Catalogue-Centric Project Product Picker UI Remediation
1Q-G - Availability Review And Store/Commerce Readiness Check
```

This sequence is accepted when Client dashboard/access model planning confirms Product selection is needed before Store/Commerce.

## 18. Recommended Next Slice

```text
1Q-B - Event/Catalogue Availability Schema Implementation
```

Goal:

```text
Implement the first schema foundation for Event-to-Catalogue availability, standalone Catalogue availability and Project type/Product suitability boundaries.
```

Initial implementation should preserve the 1Q-A direction:

- add Event-to-Catalogue availability;
- add the smallest safe standalone/default Catalogue availability support;
- keep Project type/format as stable system codes in this pass;
- do not implement Store, Orders, Commerce, Product picker UI or production workflows yet.

Follow-on slice:

```text
1Q-C - C1 Event Catalogue Availability API/Services
```
