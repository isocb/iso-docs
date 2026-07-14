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
- Event-default and Project-specific commission policies;
- typed FUND extensions keyed to generic Commerce records.

Cross-lane references remain generic from Commerce and typed from FUND.

## 5. Current Lane Status

### Commerce Core

- Commerce schema foundation architecture: accepted.
- `COMMERCE-A1`: implemented and reviewed as passed.
- A1 static/generated-client and schema-contract review: passed.
- A1 fresh/existing-schema disposable PostgreSQL migration: passed.
- A1 rollback-only constraint/default smoke: passed with zero residual test rows.
- A1/C1/C2 application schema foundation: committed together at `4575d2d`;
- C3/C4 application schema foundation: committed at `686229c`, with `dev` and `origin/dev`
  aligned; staging/main remain at `ea4e619`.
- C5 application schema foundation: implemented/reviewed and committed locally at
  `8b5f208`; not pushed or deployed to a shared database;
  staging/main and all shared databases remain unchanged.
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
- `1R-C3`: implemented and reviewed as passed on disposable PostgreSQL; committed on
  application `dev` and documented on IsoDocs `main`; undeployed to shared databases.
- `1R-C4`: implemented and reviewed as passed on disposable PostgreSQL; committed on
  application `dev` and documented on IsoDocs `main`; undeployed to shared databases. It records
  asset/version evidence vocabulary only; media/actor runtime validation, Commerce payment
  authority, physical-artwork checks, explicit backup source selection and production
  authorisation remain later dependencies.
- `1R-C5`: implemented and reviewed as passed on disposable PostgreSQL; application changes
  are committed locally at `8b5f208`, remain unpushed and are undeployed to shared databases. It records
  Event-default, standalone Project and flat-only Event-Project override configuration plus
  C2 acceptance/replacement/finalization evidence, but no calculation or Store behaviour.
- `1P-G-R3`: Project Intake Automated Provisioning Alignment parent planning is accepted as
  a non-executable three-child family. It reconciles the complete implemented 1P-G lifecycle, K1-F and
  1R-C2, records the incomplete historic D1/D2 and K1-F-A/B review chain without inventing
  backdated evidence, and authorises no implementation by itself.
- `1P-G-R3-A`: Project Intake Automation Schema And Form Policy Foundation is implemented
  and reviewed as passed; application changes remain uncommitted and undeployed.
- `1P-G-R3-B`: Project Intake Automated Provisioning And Protection Services planning is
  accepted; implementation has not started and first requires a committed R3-A baseline.
- `1R-D`: remains reserved by accepted 1R-A architecture for Store Readiness And C1 Store
  Configuration API/Services; it is future and not authorised.
- A separate all-source Project Creation Contract Alignment plan is still required because
  implemented K2 C2 creation and generic C1 creation predate Project delivery profiles; it
  is a recorded dependency, not an authorised slice.
- `1R-C6`: blocked until the required Commerce Order/line schema and relation direction are
  accepted and implemented.

## 6. Dependency Map

```text
COMMERCE-A1 ───────────────┐
                           ├─> later Commerce Order foundation ─> FUND 1R-C6
COMMERCE-A2/A3 planning ───┘

FUND 1R-C1 ─> 1R-C2 ─> 1R-C3 ─> 1R-C4 ─> 1R-C5 complete locally

FUND 1P-G-R3 parent accepted ─> R3-A complete/uncommitted ─> R3-B accepted/not started ─> R3-C future
```

`1R-C1` and `COMMERCE-A1` are independent schema slices. Separate ownership does not permit
different documentation lifecycles.

## 7. Current Parent Control Decision

`1R-C1` through `1R-C5` and `1P-G-R3-A` are complete through implementation confirmation
and review/test. The latest representative 133-to-134 upgrade, complete 134-migration fresh
reset, R3-A constraint suite and A1/C1/C2/C3/C4/C5 regressions passed on the retained
disposable database with zero R3-A residue.

The accepted parent family is `1P-G-R3 - Project Intake Automated Provisioning Alignment`.
It is non-executable. `1P-G-R3-A - Project Intake Automation Schema And Form Policy
Foundation` is implemented and reviewed, with its application changes uncommitted. R3-A,
R3-B and R3-C each require their own complete lifecycle. R3-B is the single accepted next
implementation candidate, but its entry gate requires separate committed R3-A application
and documentation baselines plus an explicit implementation instruction. R3-C remains
unstarted and unauthorised.

For clarity:

- `1R-B` and the parent `1R-C` architecture planning are already accepted and are not to be
  repeated;
- `COMMERCE-A2` remains future work and is not currently authorised;
- FUND `1R-C1` through `1R-C5` and `1P-G-R3-A` must not be rerun as pending work;
- `1R-C3`/`1R-C4` application changes are committed at `686229c` on `origin/dev`, lifecycle
  documents are committed at `f230d14` on IsoDocs `origin/main`, and no shared database
  deployment is claimed;
- `1R-C5` implementation/review is complete and committed locally at `8b5f208`; it remains
  unpushed and undeployed;
- `1P-G-R3-A` implementation/review is complete in the application and documentation
  worktrees; those changes remain uncommitted and undeployed;
- Event policies are defaults for linked Projects, while an active C1-managed flat-rate
  override wins only for its owning Event-linked Project; standalone Project policies may
  be flat or stepped;
- C2 organiser acceptance, not C1 acceptance or moderation, gates Store publication;
  accepted replacement terms apply retrospectively to the Project sales window, provisional
  figures recalculate and first sale does not lock the assignment;
- public backup photographs are conditional production backstops that C1 may explicitly
  select if the physical original is lost or unavailable; their Order-line relation,
  Commerce payment gate, physical-original check and production-source authorisation are
  deferred until the required Commerce and typed FUND foundations exist;
- the Project Intake alignment recorded by `1R-C2` is now separately planned as
  `1P-G-R3`; the provisional `1R-D` assignment was corrected because that identifier is
  already reserved for the accepted Store-readiness lane;
- FUND `1R-C6` must not start until the Commerce Order/line foundations exist.

The controlled release sequence is also retained at parent level: promote and verify the
schema-foundation baseline through C4 at `686229c` on staging before combining it with later
LMSPro UI work; then stage and UI-smoke the LMSPro work separately before promotion to
main/live. This is a deployment gate, not a claim that any shared database has been
migrated.

## 8. Child Roadmap Discipline

Child roadmaps own detailed slice ordering inside their lanes. This parent roadmap records
only:

- sibling ownership;
- cross-lane dependencies;
- shared gates;
- the currently authorised handoff between lanes.

When a child status changes, update the child roadmap first and then this root summary.
