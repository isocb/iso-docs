# FUND Phase 1 Slice 1R-E-D - Default Project Store Instantiation And Eligible Product Reconciliation Implementation Planning

Date: 2026-07-21

Status: Awaiting explicit review and acceptance

Parent: `1R-E - C1 Store Oversight And C2 Project Store Control Alignment`

Depends on: completed/promoted `1R-E-A` through `1R-E-C`; completed `R3-B` through `R3-D`,
`1Q-E/1Q-F`, `1R-D`, `C1-C6`, K1-F/K2 and Commerce A1-A7

Governed input:

`docs/modules/fund/01-cr-inputs/2026-07-21-fund-default-project-store-and-eligible-product-presumption-input.md`

## 1. Objective

Close the operational gap discovered during post-promotion human-smoke preparation: a FUND
Project currently has no Store until an authorised C2 member manually selects `Prepare Store`.

Implement the invariant that each canonical new FUND Project atomically receives one DRAFT
Store and the complete default eligible Product set. Preserve E-A authority, E-B C1 oversight
and E-C C2 control. Do not redesign Product commerce, public Store or checkout behaviour.

## 2. Accepted Business Contract To Implement

For every retained canonical Project creation path:

```text
Project
+ delivery profile
+ one DRAFT Store
+ all canonically eligible active Project Products
+ corresponding Store Product/configuration evidence that can be derived safely
= one atomic, idempotent provisioning outcome
```

The default Store is the purpose and presumed consequence of Project creation. The organiser
does not opt in to having a Store and does not build the normal Product set one item at a time.

## 3. Canonical Eligibility And Default-Minus-Exclusions

Use the existing `1Q-E` server eligibility service as the only authority for the possible
Product universe. Do not duplicate Project-type, effective organisation-type, Event,
Catalogue or suitability rules.

Reconciliation must distinguish:

| Evidence | Required result |
| --- | --- |
| eligible Product; no membership exists | create active `FundProjectProduct` and derived Store Product evidence |
| eligible Product; active membership exists | retain; refresh accepted source snapshots/readiness |
| eligible Product; inactive membership exists | preserve explicit C2 deselection; do not reactivate |
| active membership becomes ineligible | prevent offering through existing eligibility/readiness evidence; retain history |
| active membership becomes eligible again | permit normal readiness reconciliation |
| new eligible Product appears later; no membership history | add by default on controlled refresh |

Existing Store-owned copy, Product ordering/visibility choices and immutable configuration
versions must not be overwritten except where the accepted refresh contract already creates a
new version from changed source authority.

## 4. Atomic Creation Paths

Review and align all retained Project writers, including:

1. C1/internal dashboard `createProject`;
2. automated Project Intake provisioning;
3. reviewed exception/correction provisioning; and
4. retained aligned approval writers that remain authorised after R3-C/R3-D.

Refactor one transaction-safe internal initializer/reconciler rather than duplicating Store or
eligibility logic in each writer. It must accept the exact transaction, tenant, Project and
trusted actor evidence supplied by the owning creation path.

Required chronology inside the owning transaction:

1. create/replay the exact Project;
2. create/replay its delivery profile;
3. resolve canonical eligibility from the persisted Project context;
4. create/replay active default Project Product memberships without reactivating exclusions;
5. create/replay the unique DRAFT Store;
6. derive Store Products and initial readiness/configuration evidence through the accepted
   1R-D service boundary; and
7. write bounded audit evidence before commit.

Any failure rolls back the entire new-Project outcome. Same-request retry and concurrent paths
must converge on one Project and the schema's one Store per Project.

## 5. Lifecycle Alignment

Store creation never means that the Store is trading.

- while the Project remains DRAFT, the Store remains setup/DRAFT;
- C2 commission acceptance and Project activation remain explicit gates;
- normal Project activation establishes default Store publication intent without requiring a
  second routine `Publish Store` action;
- before `Project.opensAt`, effective state is SCHEDULED;
- at/after `opensAt`, effective state becomes OPEN only while Project status, payment,
  commission, Product/artwork/release and intervention gates all pass;
- voluntary C2 pause/resume and exceptional C1 intervention remain separate; and
- `Project.closesAt` remains the automatic trading-window boundary.

Prefer the existing persisted Store statuses plus the E-A server-derived effective-state
contract. Add schema only if review proves typed evidence is genuinely required; do not add a
time-triggered mutation job merely to open a Store.

## 6. UI Alignment

E-D may make only the bounded adjustments required by the new invariant:

- remove the normal empty-Project `Prepare Store` expectation from the C2 workflow;
- retain an idempotent missing-Store recovery only as an explicit diagnostic/remediation path,
  not the normal business flow;
- show the default Product set immediately after Project creation;
- present active selection as all eligible Products minus C2 exclusions;
- preserve C2 deselect/restore, ordering, visibility, copy and voluntary pause/resume; and
- keep C1 portfolio oversight read-only for normal control, with exceptional actions only.

Do not add a C1 routine Store-create or publish action.

## 7. Existing Test-Data Reconciliation

FUND has no live operational data. Define an explicit idempotent reconciliation command or
bounded service operation for controlled development/staging use:

1. prove the target environment and operator authority;
2. report Projects missing Stores and the default eligible Product counts;
3. require explicit execution after review;
4. create only missing DRAFT Store/default-selection evidence;
5. preserve every existing Store, Project Product exclusion, configuration and commercial
   value; and
6. report created/replayed/refused counts with audit evidence.

Do not perform semantic row creation in a Prisma migration. Do not reset or delete LMSPro or
shared tenant data.

## 8. Validation

Use only `TEST_DATABASE_URL` after proving it differs from `DATABASE_URL`.

Automated coverage must include:

- every canonical Project creation path creates Project, delivery, one Store and the complete
  eligible default Product set;
- zero-eligible-Product Project still receives a DRAFT Store and remains visibly blocked;
- exact tenant, Client, organiser, Project, Product and Store ownership;
- idempotent retry and cross-path/concurrent duplicate convergence;
- injected rollback after Project, delivery, Product, Store, configuration and audit stages;
- C2 deselection persists through refresh;
- C2 restoration works explicitly;
- newly eligible Product with no prior membership is added by default;
- ineligible and later re-eligible Product behaviour;
- source commercial changes create only accepted immutable refresh evidence;
- Project activation produces scheduled/default publication intent without trading before
  `opensAt`;
- payment, commission, readiness and C1 intervention remain fail-closed;
- C1 portfolio sees the new DRAFT Store without gaining routine creation/publication authority;
- E-A/E-B/E-C, R3-B/R3-C/R3-D, 1Q-E/1Q-F, 1R-D, C1-C6 and A1-A7 regressions; and
- full cleanup with zero reserved residue.

Human validation after controlled promotion must start by creating Projects through the real
C1 and Intake workflows, then prove C1 visibility and C2 default/deselection/lifecycle
behaviour. Hand-created Store fixtures cannot substitute for this proof.

## 9. Explicit Exclusions

E-D adds no:

- public Store or checkout route;
- real Stripe action, Order, Payment or refund behaviour;
- Product price/tax/Catalogue commercial editor;
- upload, template, artwork composition/approval or production workflow;
- commission calculation, settlement or accounting;
- C1 routine publication authority; or
- LMSPro change.

## 10. Rollback And Stop Boundary

Before shared promotion, rollback is code reversion plus removal only of explicitly identified
E-D disposable-test evidence. Once a real environment has created Project Stores through this
contract, do not delete those rows as rollback; disable the new creation path and retain/audit
the evidence pending a corrective plan.

Stop after E-D implementation/review/documentation and the revised E-B/E-C human gate. Do not
begin `1R-F-A`, public Store, artwork/template production or another slice.

## 11. Review Prompt

```text
Review only FUND Phase 1 Slice 1R-E-D Default Project Store Instantiation And Eligible
Product Reconciliation Implementation Planning. Do not implement schema or application code
and do not begin 1R-F-A, public Store, artwork/template implementation, production,
commission or another slice.

Verify the plan against the governed default-Store input, completed/promoted E-A through
E-C, R3-B through R3-D, 1Q-E/1Q-F, 1R-D, C1-C6, K1-F/K2, Commerce A1-A7 and the current
141-migration contract. Resolve any conflict in mandatory one-Store-per-Project creation,
canonical eligibility, all-eligible-minus-explicit-deselections, newly eligible and later
ineligible Products, immutable commercial/configuration evidence, atomic creation across
every retained Project writer, actor/audit ownership, idempotency/concurrency, default
scheduled/open lifecycle, commission/readiness/intervention gates, existing test-data
reconciliation, rollback and human testability.

Confirm E-D preserves C1 oversight/exceptional authority and C2 normal Store control, creates
no C1 routine Store/publish action, and adds no public Store, checkout, real Stripe, Order,
Payment, upload, template/artwork, production, fulfilment, commission calculation or LMSPro
behaviour.

If acceptable, mark only E-D accepted and provide its single bounded implementation prompt.
Make no Prisma, migration, service, router, route, UI or shared-environment change during
review.
```
