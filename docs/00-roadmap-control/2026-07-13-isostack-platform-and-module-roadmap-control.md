# IsoStack Platform And Module Roadmap Control

Date: 2026-07-20

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

### 2026-07-14 Development Promotion Checkpoint

Application `dev` is aligned with `origin/dev` at `fd7376b`; all 139 migrations are applied
to the Neon development database. Disposable FUND test rows were cleared only after an
R3-D empty-baseline guard stopped migration and the user explicitly authorised their
removal. LMSPro/public row counts were unchanged, all Commerce A1-A4 and FUND C1-C6
contract verifiers passed, and application staging/main remained at `ea4e619`.

Authoritative deployment evidence:

`docs/00-roadmap-control/2026-07-14-fund-commerce-dev-promotion-and-migration-confirmation.md`

Any older statement below saying these slices remain unpushed or undeployed to the shared
development database is superseded by this checkpoint. Staging and production remain
undeployed.

### 2026-07-15 Commerce A7 Development And Staging Promotion Checkpoint

Application `dev`/`origin-dev` and `staging`/`origin-staging` are aligned at `91e8751c`.
The Neon development database is current at 140 applied migrations with no failed
migration. Dev and staging security/type/schema gates passed; staging reported healthy
with its database connected and RLS enabled on all 11 expected tables; and human FUND
administrator login plus pre-existing UI smoke verification passed.

Application `main`, live deployment and the live database remain unchanged at their prior
boundary. This checkpoint supersedes older statements below that describe A6-A through A7
or retained FUND dependencies as local, unpushed or undeployed to staging.

Authoritative evidence:

`docs/00-roadmap-control/2026-07-15-commerce-a7-dev-staging-promotion-confirmation.md`

### 2026-07-20 FUND 1R-E Development And Staging Promotion Checkpoint

Application `dev`/`origin-dev` and `staging`/`origin-staging` are aligned at `e3f44b4b`.
This promotes completed E-A intervention authority and the E-B/E-C C1/C2 Store surfaces.
Exact dev and staging Security Scans passed, and online staging reported healthy database
connectivity with RLS enabled on all 11 expected tables. The new C1 Store and retained C2
application boundaries returned the expected unauthenticated sign-in redirects.

The Render build contract applies committed migrations through `prisma migrate deploy`
before building. No direct staging migration inventory was queried locally, and the Neon
development database was not migrated in this turn. Authenticated E-B/E-C human UI testing
remains scheduled. Application `main`, live deployment and the live database are unchanged.

Authoritative evidence:

`docs/00-roadmap-control/2026-07-20-fund-1r-e-dev-staging-promotion-confirmation.md`

This checkpoint supersedes the E-A local-only and E-B/E-C unpushed deployment wording in
the older checkpoint and status detail below.

### 2026-07-15 FUND 1R-E-A Local Completion Checkpoint

FUND `1R-E-A - Store Authority, Exceptional Intervention And Lifecycle Service Alignment`
is implemented and independently reviewed as passed at application `dev`/`origin/dev`
commit `daafc349`.
Its bounded migration advances only the retained disposable test database from 140 to 141
applied migrations with zero failures and zero test residue. Representative upgrade, full
fresh replay, preflight refusal, schema/constraint/service/concurrency/rollback, retained
1R-D/A7 regressions, Prisma validation/generation, type-check and production build passed.

The application code is backed up on `origin/dev`, but the shared Neon development
database and staging remain at the previously promoted `91e8751c`/140-migration boundary;
production remains unchanged. GitHub `Security Scan` run `29417617533` passed for exact
application commit `daafc349`. This checkpoint
supersedes older current-action statements below that say E-A implementation has not
started. The bounded `1R-E-B - C1 Store Portfolio Oversight And Exceptional Intervention
Surface` implementation/review lifecycle is complete locally without a migration and is
not yet committed/deployed. `1R-E-C - C2 Project Store Control Surface` is also
implemented/reviewed locally without a migration or shared deployment; its human UI
schedule remains pending. `1R-F - Project Offer And Artwork Readiness Reconciliation` is
reviewed/accepted at
`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-f-project-offer-artwork-readiness-reconciliation-planning.md`.
Its bounded `1R-F-A` real-template/renderer proof is the single next planning candidate;
proof implementation and `1R-G` remain unauthorised.

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
- `COMMERCE-A3`: implemented/reviewed at local application commit `4a90be1`; representative
  137-to-138 and fresh 138-migration disposable lifecycles, A1/A2/C6 regressions and
  zero-residue checks passed. It is not pushed or deployed to a shared database.
- `COMMERCE-A4`: implemented/reviewed at local application commit `5b69920`; representative
  138-to-139 and fresh 139-migration disposable lifecycles, A1/A2/A3/C6 regressions,
  immutable-audit checks and zero-residue checks passed. It is not pushed or deployed to a
  shared database.
- `COMMERCE-A5`: implemented/reviewed at application commit `fd7376b`, included on
  `origin/dev`; no migration or shared-database deployment was required.
- `COMMERCE-A6-A`: account/onboarding/event-inbox schema foundation is implemented/reviewed
  at local application commit `513cf3a`. Representative 139-to-140 and fresh 140-migration
  disposable lifecycles plus A1-A5/C1-C6 regressions passed with zero residue. It is not
  pushed or deployed to a shared database and adds no Stripe runtime behavior.
- `COMMERCE-A6-B`: tenant payment settings and hosted onboarding is implemented/reviewed at
  local application commit `e8aecea`. The unchanged 140-migration baseline, fake-provider
  lifecycle, tenant/actor boundaries, state, idempotency/concurrency, readiness,
  audit-redaction, build and zero-residue checks passed. It is not pushed or deployed and
  adds no Checkout or Connect webhook behavior.
- `COMMERCE-A6-C`: connected-account Checkout adapter is implemented/reviewed at local
  application commit `34ef64bb`. The unchanged 140-migration baseline, fake-provider
  direct-charge, ownership, readiness, idempotency/concurrency, compensation, redaction,
  build and zero-residue checks passed. It is not pushed or deployed and adds no route,
  UI, webhook or payment transition.
- `COMMERCE-A6-D`: connected-account webhook, Payment/Refund synchronization and
  reconciliation is implemented/reviewed at local application commit `fa670e3c`. The
  unchanged 140-migration baseline, signed fixtures, durable receipt, canonical Payment
  and provider-originated Refund reconciliation, retry/job isolation, A6-B/A6-C
  regressions, build and zero-residue checks passed. It is not pushed or deployed, and no
  shared Connect secret or Event destination was configured.

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
  -> COMMERCE-A3 payment/refund/pro-forma schema complete
  -> COMMERCE-A4 audit/idempotency complete
  -> COMMERCE-A5 provider-neutral services complete
  -> COMMERCE-A6 Stripe Connect tenant-payments parent plan (accepted)
     -> A6-A account/event-inbox schema complete
     -> A6-B tenant settings/hosted onboarding complete at `e8aecea`
     -> A6-C connected-account Checkout adapter complete at `34ef64bb`
     -> A6-D webhook/refund reconciliation complete at `fa670e3c`
  -> COMMERCE-A7 FUND consumer integration complete and promoted through staging
  -> FUND 1R-E C1 Store Oversight And C2 Project Store Control Alignment parent accepted
  -> FUND 1R-E-A Store authority/intervention service implemented/reviewed locally
     -> FUND 1R-E-B C1 Store Portfolio Oversight And Exceptional Intervention Surface
        implemented/reviewed as passed locally; no shared deployment
     -> FUND 1R-E-C C2 Project Store Control Surface
        implemented/reviewed locally; human UI schedule pending
  -> FUND 1R-F Project Offer And Artwork Readiness Reconciliation parent accepted
     -> FUND 1R-F-A Real AMOW Template, Pricing And Deployed Renderer Proof
        single next planning candidate; planning only

FUND 1R-C1 -> C2 -> C3 -> C4 -> C5 -> C6 complete
FUND 1P-G-R3-A -> R3-B -> R3-C -> R3-D complete
```

`1R-C1` and `COMMERCE-A1` are independent schema slices. Separate ownership does not permit
different documentation lifecycles.

## 7. Current Parent Control Decision

`1R-C1` through `1R-D`, `1P-G-R3-A`/`R3-B`/`R3-C`/`R3-D`, Commerce A1 through A7 and
FUND 1R-E-A are complete through implementation confirmation and review/test. The retained
disposable database is at the complete 141-migration E-A baseline with zero test residue.

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
- `COMMERCE-A3 - Payment, Refund And Pro-forma Schema Foundation` is implemented/reviewed
  at local application `4a90be1`, is undeployed to shared databases and must not be rerun;
- `COMMERCE-A4 - Audit And Idempotency Foundation` is implemented/reviewed at local
  application `5b69920`, is undeployed to shared databases and must not be rerun;
- `COMMERCE-A5 - Provider-neutral Services And Validation` is implemented and reviewed at
  application commit `fd7376b`; its provider-neutral validators and
  idempotency/audit helpers passed disposable tests with zero residue and no migration;
- `COMMERCE-A6-A - Stripe Connect Account And Event-Inbox Schema Foundation` is
  implemented/reviewed at local application commit `513cf3a`; its 140-migration disposable
  lifecycle passed with zero residue, no shared deployment and no Stripe runtime behavior;
- `COMMERCE-A6-B - Tenant Payment Settings And Hosted Onboarding` is implemented/reviewed
  at local application commit `e8aecea` and is not pushed or deployed;
- `COMMERCE-A6-C - Connected-account Checkout Adapter` is implemented/reviewed at local
  application `34ef64bb`; it added no migration, route, UI, webhook or payment transition;
- `COMMERCE-A6-D - Connected-account Webhook, Payment/Refund Synchronization And
  Reconciliation` is implemented/reviewed at local application `fa670e3c`; it added no
  migration, real Stripe action, shared configuration, UI, FUND or production behavior;
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

`COMMERCE-A6-D - Connected-account Webhook, Payment/Refund Synchronization And
Reconciliation` is implemented/reviewed at `fa670e3c` against completed A6-A/A6-B/A6-C and
the unchanged 140-migration baseline.

`COMMERCE-A7 - FUND Consumer Integration` is implemented/reviewed as passed at application
commit `598305ce` on the unchanged 140-migration baseline and is included in the completed
dev/staging promotion at `91e8751c`:

`docs/core/commerce/03-slice-planning/2026-07-15-isostack-commerce-core-slice-commerce-a7-fund-consumer-integration-implementation-planning.md`

A7 remains a dormant internal boundary with no route, UI or real Stripe action. Its
staging health and human smoke gates passed. The FUND
`1R-E - C1 Store Oversight And C2 Project Store Control Alignment` parent plan is reviewed
and accepted. The bounded `1R-E-A - Store Authority, Exceptional Intervention And
Lifecycle Service Alignment` lifecycle is implemented/reviewed as passed locally against
the new 141-migration disposable baseline. The bounded `1R-E-B - C1 Store Portfolio
Oversight And Exceptional Intervention Surface` implementation/review lifecycle is
complete and promoted through application dev/staging at `e3f44b4b` without an E-B
schema/migration change. `1R-E-C - C2 Project Store Control Surface` is included in the
same promoted application commit without an E-C migration; its authenticated human UI
schedule remains pending. The non-executable
`1R-F - Project Offer And Artwork Readiness Reconciliation` parent is reviewed/accepted.
`1R-F-A - Real AMOW Template, Pricing And Deployed Renderer Proof` is the single next
planning candidate; no proof implementation, `1R-G` or artwork/template production
implementation is authorised.

`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-e-b-c1-store-portfolio-oversight-exceptional-intervention-surface-implementation-planning.md`

`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-e-c-c2-project-store-control-surface-implementation-planning.md`

`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-e-c1-store-oversight-c2-project-store-control-alignment-planning.md`

`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-e-a-store-authority-exceptional-intervention-lifecycle-service-alignment-implementation-planning.md`

The subordinate FUND strategic completion overview and its three 2026-07-15 CR inputs are
now registered through the authoritative FUND roadmap. A7 planning must read them so the
integration preserves exact workflow and immutable FUND offer evidence, but A7 remains a
thin cross-lane consumer boundary. It must not absorb Template Manager/Artwork Template,
collective artwork approval, C1/public Store UI, production, fulfilment or commission
implementation. CR open questions remain with their later bounded FUND workstreams unless
an answer is strictly required to define the A7 contract.

## 8. Child Roadmap Discipline

Child roadmaps own detailed slice ordering inside their lanes. This parent roadmap records
only:

- sibling ownership;
- cross-lane dependencies;
- shared gates;
- the currently authorised handoff between lanes.

When a child status changes, update the child roadmap first and then this root summary.
