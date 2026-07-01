# FUND Phase 1 Slice 1Q-E - Project Product Eligibility API/Services Planning

Date: 2026-07-01

Status: Planning accepted - ready for implementation

## 1. Slice Goal

Implement tenant-scoped Project Product eligibility API/services.

The service should answer:

```text
For this Project, which Products are eligible to be selected into FundProjectProduct?
```

This slice derives eligibility only. It must not create, update or delete `FundProjectProduct` rows.

## 2. Prior Slice Context

1Q-E follows:

- 1Q-A Product/Catalogue Suitability Schema Options Planning;
- 1Q-B Event/Catalogue Availability Schema Implementation;
- 1Q-C C1 Event Catalogue Availability API/Services;
- 1Q-D C1 Event Catalogue Availability UI;
- 1Q-D-R1 review/test pass, with detailed UI/UX revisions deferred to refinement.

Current implementation foundation:

- `FundEventCatalogue` links active Event Catalogue availability;
- `FundCatalogue.availabilityScope` controls Event/standalone/default availability;
- `FundCatalogue.isDefaultStandalone` identifies default standalone Catalogues;
- `FundProductProjectTypeSuitability` stores optional Project type constraints;
- `FundProductOrganizationTypeSuitability` stores optional Client organisation type constraints;
- `FundProjectProduct` remains the selected Product list for a Project.
- the same Product may belong to more than one Catalogue, so eligibility must preserve source Catalogue context without duplicating the final selected Product.

## 3. Implementation Boundary

Implement only API/services for reading eligibility.

Do not implement:

- C2 Product picker UI;
- Project Product auto-selection;
- `FundProjectProduct` creation or mutation;
- Store;
- Orders;
- Commerce;
- Sales/Reporting;
- Product duplication;
- Catalogue duplication;
- Product media galleries;
- Product option modelling;
- option-to-image mapping;
- production/artwork/dispatch workflows;
- notifications;
- SeasonPro integration.

## 4. Accepted Eligibility Model

Eligibility remains the three-gate model from 1Q-A:

```text
Product source / availability
-> Project type suitability
-> Client organisation type suitability
-> eligible Product response
-> later C2/C1 subset selection into FundProjectProduct
```

`FundProjectProduct` is the operational selected Product list.

Store and Orders must eventually consume `FundProjectProduct`, not raw Event/Catalogue availability.

## 5. Source Availability Policy

For Event-linked Projects:

- load the Project from the current tenant only;
- require the linked Event to belong to the same tenant;
- exclude archived Events;
- use active `FundEventCatalogue` rows for the linked Event;
- respect `availableFrom` and `availableUntil` windows at the evaluation time;
- include Catalogues only when they are active, not archived and Event-available;
- include active `FundCatalogueProduct` rows only;
- include Products only when they are active and not archived.

Event Catalogue source scopes accepted for Event-linked eligibility:

```text
EVENT_ONLY
EVENT_AND_STANDALONE
```

For standalone Projects:

- load the Project from the current tenant only;
- use tenant Catalogues where `isDefaultStandalone = true`;
- include Catalogues only when active, not archived and standalone-available;
- include active `FundCatalogueProduct` rows only;
- include Products only when active and not archived.

Standalone Catalogue source scopes accepted for standalone eligibility:

```text
STANDALONE_ONLY
EVENT_AND_STANDALONE
```

`INTERNAL_ONLY` Catalogues must never feed Project Product eligibility.

## 6. Deduplication And Catalogue Source Context

Catalogue availability is the source of eligibility, but Product identity remains the final selection unit.

Accepted rule:

```text
One Product may be available through many Catalogues.
Eligibility should return that Product once, with all source Catalogue context attached.
```

This means:

- Event-linked Projects may receive several source Catalogues from the linked Event;
- standalone Projects may receive several default standalone Catalogues;
- the same Product may appear in more than one eligible Catalogue;
- the 1Q-E service must deduplicate eligible Products by `productId`;
- each eligible Product should include a `sourceCatalogues` list explaining why it is available;
- grouped Catalogue views may be returned for UI convenience, but shared Products must carry one shared selection state;
- later `FundProjectProduct` selection should create at most one active Project Product membership for a Product;
- Store pages should display each selected Product once, even if it was eligible through multiple Catalogues.

Suggested Product response detail:

```text
eligibleProduct:
  productId
  product summary
  sourceCatalogues[]
  suitability status
  existingProjectProductMembership
```

Suggested Catalogue grouping detail:

```text
sourceCatalogue:
  catalogue summary
  eligibleProductIds[]
```

The Catalogue grouping is for explanation and picker UX. It is not a second Project selection model.

If future Catalogue or Product duplication creates separate Product copies with different pricing, commission, copy, options, media, fulfilment or merchandising behaviour, those copies should be distinct Product records and may therefore appear separately. Shared references to the same Product should still collapse to one Product in Project selection and Store display.

## 7. No Suitability Rows Policy

Suitability rows are optional narrowing rules, not a second required configuration step.

Accepted policy:

```text
If a Product has no active suitability rows for a suitability dimension, that dimension passes as unrestricted.
```

Applied rules:

- if a Product has no active Project type suitability rows, it is broadly eligible for all Project types after passing source availability;
- if a Product has active Project type suitability rows, the Project's Project type must match one active row;
- if a Product has no active organisation type suitability rows, it is broadly eligible for all organisation types after passing source availability;
- if a Product has active organisation type suitability rows and a Client organisation type is available, the Client organisation type must match one active row;
- if a Product has active organisation type suitability rows but no Client organisation type is available, do not silently fail the whole request; return an eligibility warning that organisation type filtering was skipped or could not be fully evaluated.

Reason:

```text
C1 has already controlled Product source availability through Event/default Catalogue configuration. Suitability rows should safely narrow that source list without making every existing Product disappear until manually configured.
```

## 8. Project Type And Organisation Type Inputs

Project type should be resolved in this order:

1. accepted explicit service input override, if provided for an admin/test path;
2. `FundProject.metadata.projectType`, as used by the C2 Client dashboard;
3. `null` with a response warning if no Project type is available.

Organisation type should be resolved in this order:

1. accepted explicit service input override, if provided for an admin/test path;
2. linked `FundProject.client.clientType`, if the Project has a Client;
3. `null` with a response warning if no organisation type is available.

Project type codes must use the existing accepted C2/public codes:

```text
ARTWORK_FUNDRAISING
GROUP_PERSONALISED_PRODUCTS
BULK_ORDER_CLUB_FUNDED
NOT_SURE
```

Organisation type codes must use the uppercase stable first-pass form used by 1Q-C/1Q-D suitability configuration.

## 9. Proposed Service Contract

Add validation and service files along these lines:

```text
src/modules/fund/lib/validation/product-eligibility.ts
src/modules/fund/services/product-eligibility.service.ts
src/modules/fund/routers/product-eligibility.router.ts
```

Expose the router under:

```text
fund.productEligibility.*
```

Minimum procedure:

```text
fund.productEligibility.listForProject
```

Input:

```text
projectId: uuid
evaluationAt?: date
projectTypeCode?: accepted Project type code
organizationTypeCode?: uppercase organisation type code
```

Output should include:

- Project summary: id, projectNumber, name, eventId, clientId, projectTypeCode, organizationTypeCode;
- source mode: `EVENT` or `STANDALONE`;
- source Catalogue groups for explanation and future picker UI;
- eligible Products deduplicated by `productId` and ordered by first source Catalogue sort order, Catalogue Product sort order and Product sort order/name;
- Product summary: id, code, name, slug, shortDescription, workflowClass, price/currency snapshots where available;
- source Catalogue summaries on each eligible Product for explainability;
- active Project type suitability codes;
- active organisation type suitability codes;
- existing active `FundProjectProduct` membership state where useful for later picker UI;
- warnings for missing Project type, missing organisation type, no source Catalogues or no eligible Products.

Suggested response shape:

```text
{
  project,
  sourceMode,
  evaluationAt,
  sourceCatalogues: [...],
  eligibleProducts: [...],
  warnings: [...]
}
```

## 10. Access And Tenant Guardrails

The API must:

- use `withFeature('fund')`;
- require authenticated actor context;
- derive `organizationId` from actor/effective tenant context;
- never accept `organizationId` from client input;
- preserve same-tenant Project, Event, Client, Catalogue and Product joins;
- reject or return not-found for cross-tenant Projects;
- exclude archived/inactive source records from eligibility;
- avoid exposing supplier/internal Product configuration to public unauthenticated contexts.

Initial access should be C1 admin safe.

If a C2-facing procedure is added in this slice, it must derive Project access from authenticated Client membership/context rather than request input alone.

## 11. Service Behaviour

The service should return an empty eligible Product list, not throw, when:

- a standalone Project has no default standalone Catalogues;
- an Event-linked Project has no active Event Catalogue availability;
- source availability exists but all Products are filtered out by status/archive/suitability.

The service should throw for:

- missing Project;
- cross-tenant Project;
- archived Project;
- invalid override Project type code;
- invalid override organisation type code.

No audit event is required for read-only eligibility queries.

## 12. Checks To Run

Recommended checks after implementation:

```text
npx prisma validate
npm run type-check
npx eslint src/modules/fund/lib/validation/product-eligibility.ts src/modules/fund/services/product-eligibility.service.ts src/modules/fund/routers/product-eligibility.router.ts src/modules/fund/routers/index.ts
npm run verify
git diff --check
```

If `npm run verify` fails inside the managed sandbox with the known `tsx` IPC pipe issue, rerun outside the sandbox and record both results in the implementation confirmation.

## 13. Review/Test Expectations

Static review must confirm:

- source availability is mandatory;
- eligible Products are deduplicated by Product while retaining source Catalogue context;
- Products available through multiple Catalogues do not produce duplicate selectable/store Products;
- no suitability rows means unrestricted for that suitability dimension;
- active suitability rows narrow eligibility;
- same-tenant checks are preserved;
- archived/inactive Events, Catalogues, Catalogue Product memberships and Products are excluded;
- the service does not create `FundProjectProduct` rows;
- no Store, Orders, Commerce or picker UI behaviour was added.

Smoke/API expectations:

- Event-linked Project with active Event Catalogue returns eligible Products;
- standalone Project with default standalone Catalogue returns eligible Products;
- Product available through multiple eligible Catalogues appears once with multiple source Catalogue references;
- Product with matching Project type suitability remains eligible;
- Product with non-matching active Project type suitability is filtered out;
- Product with no suitability rows remains eligible after source availability passes;
- missing standalone/default source returns an empty list plus warning;
- cross-tenant Project access is rejected/not found.

## 14. Recommended Next Slice

```text
1Q-F - Catalogue-Centric Project Product Picker UI Remediation
```

Goal:

```text
Update the Project Product picker UI to use the 1Q-E eligible Product source list, group eligible Products by source Catalogue for clarity, keep one shared Product selection state across groups and keep FundProjectProduct as the selected subset, without implementing Store, Orders or Commerce.
```
