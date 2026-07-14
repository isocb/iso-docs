# IsoStack Platform And Module Roadmap Control

Date: 2026-07-14

Status: Active parent roadmap

## 1. Purpose

Provide the missing parent control above platform Core and product-module roadmaps.

The root roadmap coordinates sibling lanes without moving platform ownership into a module
or making a module roadmap authoritative for reusable Core infrastructure.

## 2. Governed Roadmap Tree

```text
IsoStack Root Roadmap
├── Core Commerce roadmap
│   └── reusable checkout, Order, money and payment infrastructure
└── FUND roadmap
    └── Project Store, Product inputs, production and commission context
```

Authoritative child controls:

```text
docs/core/commerce/00-roadmap-control/2026-07-13-commerce-core-roadmap-and-slice-control.md
docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md
```

Other IsoStack Core and module roadmaps may be added as siblings when their work requires
cross-lane coordination.

## 3. Mandatory Slice Lifecycle

Every executable slice in every governed lane follows:

```text
03-slice-planning
-> implementation in the owning application/repository scope
-> 04-implementation-confirmations
-> 05-review-and-test
```

Rules:

- `04-implementation-confirmations` contains only evidence of actual implementation;
- planning decisions and handoffs belong in `02-triage` or the lane roadmap;
- umbrella architecture documents may govern several slices but do not substitute for a
  bounded slice plan;
- implementation confirmation does not substitute for independent review/test evidence;
- a slice is not deployment-complete while a recorded deployment gate remains pending.

## 4. Ownership Boundary

Commerce Core owns generic:

- seller profile;
- checkout and Order lifecycle;
- monetary/tax snapshots;
- payment, refund and pro-forma evidence;
- provider-neutral audit/idempotency contracts.

FUND owns:

- Project Store and Store Product;
- Product inputs and media;
- artwork and production context;
- Project delivery context;
- Event/standalone commission policies;
- typed FUND extensions keyed to generic Commerce records.

Cross-lane references remain generic from Commerce and typed from FUND.

## 5. Current Lane Status

### Commerce Core

- Commerce schema foundation architecture: accepted.
- `COMMERCE-A1`: implemented and reviewed as passed.
- A1 static/generated-client and schema-contract review: passed.
- A1 fresh/existing-schema disposable PostgreSQL migration: passed.
- A1 rollback-only constraint/default smoke: passed with zero residual test rows.
- A1/C1/C2 application schema foundation: committed together at `4575d2d` and aligned to
  `origin/dev`; staging/main remain at `ea4e619`.
- Dedicated Neon `TEST_DATABASE_URL` target: retained as disposable test infrastructure;
  its connection string remains local and uncommitted.
- Shared development, staging and live database deployment: not performed.
- `COMMERCE-A2`: not yet authorised for implementation.

### FUND

- `1R-A`, `1R-B` and `1R-C` architecture planning: accepted.
- `1R-C1`: implemented and reviewed as passed on disposable PostgreSQL; no shared database
  deployment performed.
- `1R-C2`: implemented and reviewed as passed on disposable PostgreSQL; no shared database
  deployment performed. Its required later Project Intake alignment remains separate.
- `1R-C3`: implemented and reviewed as passed on disposable PostgreSQL; application and
  documentation changes remain uncommitted and undeployed to shared databases.
- `1R-C4`: implemented and reviewed as passed on disposable PostgreSQL; application and
  documentation changes remain uncommitted and undeployed to shared databases. It records
  asset/version evidence vocabulary only; media/actor runtime validation, Commerce payment
  authority, physical-artwork checks, explicit backup source selection and production
  authorisation remain later dependencies.
- `1R-C5`: single next FUND planning candidate; planning not started and implementation not
  authorised.
- `1R-C6`: blocked until the required Commerce Order/line schema and relation direction are
  accepted and implemented.

## 6. Dependency Map

```text
COMMERCE-A1 ───────────────┐
                           ├─> later Commerce Order foundation ─> FUND 1R-C6
COMMERCE-A2/A3 planning ───┘

FUND 1R-C1 ─> 1R-C2 ─> 1R-C3 ─> 1R-C4 ─> 1R-C5 planning candidate
```

`1R-C1` and `COMMERCE-A1` are independent schema slices. Separate ownership does not permit
different documentation lifecycles.

## 7. Current Parent Control Decision

`1R-C1` through `1R-C4` are complete through implementation confirmation and review/test.
The latest representative 131-to-132 upgrade, complete 132-migration fresh reset and C4
constraint suite passed on the retained disposable database with zero residue.

No next slice is currently authorised by this completion.

For clarity:

- `1R-B` and the parent `1R-C` architecture planning are already accepted and are not to be
  repeated;
- `COMMERCE-A2` remains future work and is not currently authorised;
- FUND `1R-C1` through `1R-C4` must not be rerun as pending work;
- `1R-C3`/`1R-C4` application/documentation changes are uncommitted and no shared database
  deployment is claimed;
- `1R-C5` is the single next planning candidate, but no plan or implementation has started;
- public backup photographs are conditional production backstops that C1 may explicitly
  select if the physical original is lost or unavailable; their Order-line relation,
  Commerce payment gate, physical-original check and production-source authorisation are
  deferred until the required Commerce and typed FUND foundations exist;
- the Project Intake alignment recorded by `1R-C2` must be separately planned/reviewed and
  must not be folded silently into the schema-only implementation;
- FUND `1R-C6` must not start until the Commerce Order/line foundations exist.

The controlled release sequence is also retained at parent level: promote and verify the
unchanged A1/C1/C2 commit `4575d2d` on staging before combining it with later LMSPro UI
work; then stage and UI-smoke the LMSPro work separately before promotion to main/live.
This is a deployment gate, not a claim that any shared database has been migrated.

## 8. Child Roadmap Discipline

Child roadmaps own detailed slice ordering inside their lanes. This parent roadmap records
only:

- sibling ownership;
- cross-lane dependencies;
- shared gates;
- the currently authorised handoff between lanes.

When a child status changes, update the child roadmap first and then this root summary.
