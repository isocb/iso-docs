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
- C5 application schema foundation: implemented/reviewed at `8b5f208`, now included on
  `origin/dev`; not deployed to a shared database;
  staging/main and all shared databases remain unchanged.
- Dedicated Neon `TEST_DATABASE_URL` target: retained as disposable test infrastructure;
  its connection string remains local and uncommitted.
- Shared development, staging and live database deployment: not performed.
- `COMMERCE-A2`: implemented/reviewed at application commit `3206199` on `origin/dev`; representative
  135-to-136 and fresh 136-migration disposable lifecycles passed with zero residue and no
  shared deployment.
- FUND `1R-C6`: implemented/reviewed at local application commit `9947669`; representative
  136-to-137, refusal and fresh 137-migration disposable lifecycles passed with zero residue
  and no shared deployment. The commit is not yet pushed.
- FUND Store `1R-D`: implemented/reviewed at local application commit `db85fcc`; its
  service/transaction lifecycle passed against the unchanged 137-migration disposable
  baseline with zero `fund-1rd-*` residue. The commit is not yet pushed or deployed.

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
  are committed at `8b5f208`, included on `origin/dev` and undeployed to shared databases. It records
  Event-default, standalone Project and flat-only Event-Project override configuration plus
  C2 acceptance/replacement/finalization evidence, but no calculation or Store behaviour.
- `1P-G-R3`: Project Intake Automated Provisioning Alignment parent planning is accepted as
  a non-executable three-child family. It reconciles the complete implemented 1P-G lifecycle, K1-F and
  1R-C2, records the incomplete historic D1/D2 and K1-F-A/B review chain without inventing
  backdated evidence, and authorises no implementation by itself.
- `1P-G-R3-A`: Project Intake Automation Schema And Form Policy Foundation is implemented,
  reviewed at application `4bb7dd9`, included on `origin/dev` and undeployed to shared databases.
- `1P-G-R3-B`: Project Intake Automated Provisioning And Protection Services is implemented,
  reviewed at application `04da074` and included on `origin/dev`; its documentation lifecycle
  is included in the current IsoDocs baseline. It remains undeployed to shared databases.
- `1P-G-R3-C`: form, confirmation and exception-review alignment is implemented/reviewed,
  committed and promoted to application `origin/dev` at `234f115`; it remains undeployed to
  staging/main and shared databases and adds no migration. It invokes
  R3-B only through aligned atomic confirmation and protected C1 review, preserves historic
  null-contract Intake, sends no invitation email and activates no real form.
- `1P-G-R3-D`: Project Creation Contract Alignment is implemented/reviewed against
  migration 135 at application `e1c2d9f`, now included on `origin/dev` at `3206199`; its
  documentation commit `9d140fa` is included on IsoDocs `origin/main`. It remains
  undeployed to shared databases.
- `1R-D`: Store Readiness And C1 Store Configuration API/Services is implemented/reviewed
  at local application commit `db85fcc`, with no migration or shared deployment.
- The all-source Project Creation Contract Alignment requirement is closed by
  `1P-G-R3-D`; staging/main and shared-database promotion remain separate.
- `1R-C6`: implemented and reviewed as passed at local application commit `9947669`. It
  stores typed FUND Commerce evidence only; no runtime Store, checkout, payment,
  production or commission behavior was added.

## 6. Dependency Map

```text
COMMERCE-A1 complete
  -> COMMERCE-A2 Checkout/Order/Order-line foundation
  -> FUND 1R-C6 typed Commerce context
  -> FUND 1R-D Store readiness/configuration services
  -> COMMERCE-A3 payment/refund/pro-forma schema
  -> COMMERCE-A4 audit/idempotency
  -> COMMERCE-A5 provider-neutral services
  -> COMMERCE-A6 Stripe adapter/webhooks
  -> COMMERCE-A7 FUND consumer integration

FUND 1R-C1 -> C2 -> C3 -> C4 -> C5 -> C6 complete
FUND 1P-G-R3-A -> R3-B -> R3-C -> R3-D complete
```

`1R-C1` and `COMMERCE-A1` are independent schema slices. Separate ownership does not permit
different documentation lifecycles.

## 7. Current Parent Control Decision

`1R-C1` through `1R-D`, `1P-G-R3-A`/`R3-B`/`R3-C`/`R3-D`, Commerce A1 and Commerce A2 are
complete through implementation confirmation and review/test. The disposable database is
at the complete 137-migration C6 baseline with zero test residue.

The accepted parent family is `1P-G-R3 - Project Intake Automated Provisioning Alignment`.
Its A/B/C child lifecycles are complete and included on `origin/dev`. R3-A is committed at `4bb7dd9`, R3-B at
`04da074`, and R3-C is implemented/reviewed and promoted to application `origin/dev` at
`234f115`; shared staging/main and databases remain unchanged. R3-C passed its
134-migration disposable integration lifecycle and the complete R3-B regression with zero
residue and external email disabled.

For clarity:

- `1R-B` and the parent `1R-C` architecture planning are already accepted and are not to be
  repeated;
- `COMMERCE-A2` is implemented/reviewed at application `3206199` on `origin/dev` and must not be rerun
  as pending work;
- FUND `1R-C1` through `1R-C6` and `1P-G-R3-A`/`R3-B`/`R3-C` must not be rerun as pending work;
- `1R-C3`/`1R-C4` application changes are committed at `686229c` on `origin/dev`, lifecycle
  documents are committed at `f230d14` on IsoDocs `origin/main`, and no shared database
  deployment is claimed;
- `1R-C5` implementation/review is complete at `8b5f208`, included on `origin/dev` and
  undeployed to shared databases;
- `1P-G-R3-A` implementation/review is at application `4bb7dd9` and documentation
  `65fc243`; the application commit is included on `origin/dev` and shared databases remain undeployed;
- `1P-G-R3-B` implementation/review is committed at `04da074`; R3-C connects it only for
  aligned Intake confirmation and protected review;
- `1P-G-R3-D` is implemented/reviewed at application `e1c2d9f`, included on `origin/dev`
  at `3206199`, and documented by `9d140fa` on IsoDocs `origin/main`; it is not pending
  planning work and is not deployed to shared databases;
- FUND `1R-C6` is implemented/reviewed at local application `9947669`, has no shared
  deployment and must not be rerun as pending work;
- Store `1R-D` is implemented/reviewed at local application `db85fcc`, adds no migration,
  has no shared deployment and must not be rerun as pending work;
- `COMMERCE-A3 - Payment, Refund And Pro-forma Schema Foundation` is the single next
  planning candidate. It is not yet planned or authorised for implementation;
- Event policies are defaults for linked Projects, while an active C1-managed flat-rate
  override wins only for its owning Event-linked Project; standalone Project policies may
  be flat or stepped;
- C2 organiser acceptance, not C1 acceptance or moderation, gates Store publication;
  accepted replacement terms apply retrospectively to the Project sales window, provisional
  figures recalculate and first sale does not lock the assignment;
- public backup photographs are conditional production backstops that C1 may explicitly
  select if the physical original is lost or unavailable; C6 now stores their immutable
  typed Order-line evidence, while Commerce payment, physical-original checks and
  production-source authorisation remain deferred;
- the Project Intake alignment recorded by `1R-C2` is now separately planned as
  `1P-G-R3`; the provisional `1R-D` assignment was corrected because that identifier is
  already reserved for the accepted Store-readiness lane;
- FUND `1R-C6` used the Commerce Order/line foundation only for typed evidence relations;
  Store `1R-D` now consumes that completed foundation without creating Orders or payments.

The controlled release sequence is also retained at parent level: promote and verify the
schema-foundation baseline through C4 at `686229c` on staging before combining it with later
LMSPro UI work; then stage and UI-smoke the LMSPro work separately before promotion to
main/live. This is a deployment gate, not a claim that any shared database has been
migrated.

### 7.1 Integrated Serial Delivery Control

The root roadmap owns the one serial critical-path queue across sibling lanes. Child
roadmaps continue to own scope and evidence inside their lane, but they must not nominate a
different global next slice.

Default execution for an authorised slice is:

```text
create bounded plan
-> review against accepted architecture/current implementation
-> resolve non-business conflicts and mark accepted
-> implement only accepted scope
-> validate on safe disposable infrastructure
-> create implementation confirmation
-> create review/test record
-> update child and root roadmaps/README
-> stop at the next slice boundary
```

This lifecycle may proceed without repeated user prompts when decisions are already fixed
by accepted architecture and safe local/disposable validation is available. Work must stop
for explicit user input when a genuine business/product choice remains, authority would
expand, destructive/shared-environment work would be required, or the accepted plan cannot
be satisfied safely.

Current single next control action: create and review only the bounded `COMMERCE-A3 -
Payment, Refund And Pro-forma Schema Foundation` plan. Store UI `1R-E` remains queued in
the FUND lane and is not the global next slice.

## 8. Child Roadmap Discipline

Child roadmaps own detailed slice ordering inside their lanes. This parent roadmap records
only:

- sibling ownership;
- cross-lane dependencies;
- shared gates;
- the currently authorised handoff between lanes.

When a child status changes, update the child roadmap first and then this root summary.
