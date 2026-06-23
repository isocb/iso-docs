# Phase 1 Slice 1G - Products/Catalogues Review Closeout

## Date

2026-06-23

## Slice Name

Phase 1 Slice 1G - Products/Catalogues Administration Review And Manual Testing

## Status

Closed with amendments completed.

## Review Summary

Slice 1G reviewed the FUND Products/Catalogues foundation from Slice 1C through Slice 1F-B before moving to Project schema planning.

Reviewed areas:

- Product Workflow Classes;
- Product/Catalogue schema;
- Product/Catalogue API and services;
- Products/Catalogues admin UI;
- Catalogue Product membership manager;
- tenant scoping;
- Workflow Class enforcement;
- archive, restore and activate flows;
- price, VAT and currency handling;
- Catalogue membership add, deactivate, reactivate and reorder;
- table CRUD pattern compliance;
- error handling and query invalidation.

## Findings

No blocker was found in:

- tenant scoping;
- same-tenant Catalogue/Product membership validation;
- Workflow Class enforcement;
- Product/Catalogue archive, restore and activate flows;
- core table CRUD pattern compliance;
- Product/Catalogue schema constraints.

Three amend-first findings were identified:

1. Active switch could deactivate a membership without confirmation.
2. Archived Catalogue membership immutability was enforced by the UI but not fully by the API.
3. Catalogue Product reorder accepted partial membership lists through direct API use.

## Amendments Completed

App commit:

```text
193aede fix(fund): harden catalogue membership management
```

Files changed:

- `src/modules/fund/components/catalogues/CatalogueProductsManager.tsx`
- `src/modules/fund/services/catalogues.service.ts`

Fixes:

- Active switch-off now asks for confirmation before deactivating membership.
- Archived Catalogues now reject membership remove/deactivate.
- Archived Catalogues now reject membership reorder.
- Archived Catalogues now reject membership active-state changes.
- Reorder now requires the submitted membership id list to include every membership for the Catalogue.

## Checks Run

Passed:

```text
npx prisma validate
npm run type-check
npm run verify
```

Note:

- `npm run verify` initially failed in the sandbox because `tsx` could not create its temporary IPC pipe.
- The same command passed when rerun with approved local escalation.

## Manual Testing Status

Browser-click manual testing in an authenticated tenant session was not completed during this closeout.

Recommended before promotion:

- open `/app/fund/products`;
- create Product;
- activate/archive/restore Product;
- create Catalogue;
- add Products to Catalogue;
- deactivate/reactivate membership;
- reorder memberships;
- archive Catalogue and confirm membership controls are disabled;
- confirm archived Catalogue membership API errors surface clearly if attempted.

## Known Limitations

Accepted before Project schema planning:

- Product/Catalogue search and sort are client-side over current API result sets.
- Catalogue membership management remains modal-based.
- Product/Catalogue media and asset workflows are deferred.
- FUND-specific module roles are deferred.
- Store, Order, commerce, payment and commission models are deferred.

## Recommendation

Proceed to:

```text
FUND Phase 1 Slice 1H - Project Schema Planning
```

Rationale:

- the Product Workflow Class, Product, Catalogue and Catalogue membership foundation is coherent;
- tenant-safety checks are in place at schema and service level;
- outstanding limitations are documented and do not block Project schema planning;
- the completed amendments remove the main API/UX hardening concerns from Slice 1G.
