# FUND Phase 1 Slice 1R-E-D - Default Project Store Instantiation And Eligible Product Reconciliation Implementation Confirmation

Date: 2026-07-21

Status: Implemented on isolated application branch; not promoted

Application baseline: `origin/dev` `e3f44b4b`

Application implementation: `c45a41d9` on `feature/fund-1r-e-d-default-store`

Migration baseline: 141 applied migrations; no schema or migration added

## Outcome

E-D closes the missing Project-to-Store workflow without changing the database contract.
Every retained Project aggregate now creates or replays the delivery profile, one DRAFT Store,
the complete canonically eligible default Product membership set, Store Product rows,
immutable configuration/readiness evidence and bounded audit in the same transaction.

The shared initializer is called by:

1. direct C1 Project creation;
2. C2 dashboard New Project; and
3. R3-B automatic and C1-reviewed Intake provisioning.

Automatic Intake retains truthful null User evidence. Interactive paths retain their exact
same-tenant actor. No User is invented.

## Authority And Lifecycle Changes

- `FundProjectProduct.isActive` is now the serialized selected/excluded authority.
- A retained Store Product does not make an inactive membership selected.
- Controlled refresh adds a newly eligible Product only where no membership history exists;
  exclusions are never silently reactivated and ineligible history is retained.
- C2 Project activation, readiness refresh and first PUBLISHED Store intent now share one
  SERIALIZABLE transaction. A failed gate rolls both Project and Store intent back.
- Routine C2 Prepare Store and Publish Store router/UI actions are retired. C2 voluntary
  pause/resume and C1 exceptional intervention remain.
- C1 receives no routine Store creation or publication authority.

## Reconciliation Boundary

`scripts/reconcile-fund-1r-e-d-missing-project-stores.ts` is internal and non-routed. It:

- requires a target URL separate from `DATABASE_URL`;
- defaults to dry-run;
- reports missing Stores and canonical eligible counts;
- requires explicit execute, target confirmation and same-tenant OWNER/ADMIN evidence; and
- creates only missing DRAFT Store/default evidence through the shared transaction service.

It was not run against development, staging, production or any shared database.

## Explicit Non-Changes

No public Store, checkout, Stripe action, Order, Payment, commercial Product editor, upload,
Template/artwork, production, fulfilment, commission calculation or LMSPro behavior was added.
The active LMSPro remediation worktree was not switched, staged, edited or committed.

## Stop Boundary

E-D is complete locally. No promotion, shared reconciliation or `1R-F-A` work was started.
