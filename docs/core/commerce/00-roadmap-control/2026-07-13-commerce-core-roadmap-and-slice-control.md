# IsoStack Commerce Core Roadmap And Slice Control

Date: 2026-07-16

Status: Active Commerce Core roadmap

Parent roadmap:

`docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`

## 1. Mission

Deliver reusable tenant-owned Commerce infrastructure without embedding FUND or another
consumer module into generic checkout, Order, money or payment records.

## 2. Documentation Lifecycle

```text
01-cr-inputs                  raw Commerce change/request inputs
02-triage                     architecture, ownership and decision records
03-slice-planning             bounded executable slice plans
04-implementation-confirmations actual implementation evidence only
05-review-and-test            independent review, tests and deployment gates
```

## 3. Accepted Architecture

Authoritative architecture record:

`docs/core/commerce/02-triage/2026-07-13-isostack-commerce-core-schema-foundation-planning.md`

Accepted direction:

- dedicated `commerce` namespace in the existing IsoStack PostgreSQL database;
- public `Organization` remains the tenant/seller identity;
- generic source references remain opaque to Commerce;
- consumer modules write typed extensions keyed to Commerce IDs;
- checkout, Order, payment, refund and pro-forma states remain separate;
- provider work remains later than provider-neutral schema/service foundations.

## 4. Slice Sequence

```text
COMMERCE-A1 - Schema namespace, Seller Profile and stable enums
COMMERCE-A2 - Checkout, Order and Order-line schema foundation
COMMERCE-A3 - Payment, refund and pro-forma schema foundation
COMMERCE-A4 - Audit and idempotency foundation
COMMERCE-A5 - Provider-neutral services and validation
COMMERCE-A6 - Stripe Connect tenant payments parent plan
  COMMERCE-A6-A - Account and event-inbox schema foundation (implemented/reviewed)
  COMMERCE-A6-B - Tenant payment settings and hosted onboarding (implemented/reviewed)
  COMMERCE-A6-C - Connected-account Checkout adapter (implemented/reviewed)
  COMMERCE-A6-D - Webhook, refund sync and reconciliation (implemented/reviewed)
COMMERCE-A7 - FUND consumer integration (implemented/reviewed; dormant internal boundary;
promoted through staging)
```

Each slice requires its own `03 -> implementation -> 04 -> 05` lifecycle.

## 5. `COMMERCE-A1` Status

Planning:

`docs/core/commerce/03-slice-planning/2026-07-13-isostack-commerce-core-slice-commerce-a1-schema-seller-profile-enums-implementation-planning.md`

Implementation confirmation:

`docs/core/commerce/04-implementation-confirmations/2026-07-13-commerce-a1-schema-seller-profile-enums-implementation-confirmation.md`

Review/test:

`docs/core/commerce/05-review-and-test/2026-07-13-commerce-a1-schema-seller-profile-enums-review-and-test.md`

Current result:

- implemented and reviewed as passed;
- static/generated-client/schema-contract review passed;
- fresh and existing-schema disposable PostgreSQL migration passed;
- rollback-only constraint/default smoke passed with zero residual test rows;
- the dedicated Neon database configured by local `TEST_DATABASE_URL` is retained as
  disposable test infrastructure for future accepted migration-test plans;
- committed with FUND 1R-C1/1R-C2 at application commit `4575d2d` and aligned to
  `origin/dev`;
- no shared development, staging or live database migration/deployment performed.

## 6. `COMMERCE-A2` Entry Gates

Before A2 implementation planning can close, decide:

- whether Commerce persists checkout basket lines or receives an immutable submission from
  the consumer;
- `Int` versus `BigInt` minor-unit money representation;
- initial seller tax-rate/rule representation;
- arithmetic reconciliation and immutable snapshot contract;
- Order-line inheritance of the Order source-module boundary.

A2 must not absorb provider, Stripe, FUND production or commission work.

The 2026-07-14 bounded A2 review resolved these gates as follows:

- Commerce persists the checkout header/submission boundary, not mutable basket lines;
- money uses bounded Prisma `Int` minor units;
- seller profiles gain nullable standard/reduced basis-point rates while Orders/lines hold
  immutable applied snapshots;
- Order arithmetic uses explicit per-row integer reconciliation and later service-level
  aggregate validation;
- Order lines inherit the Order source-module boundary;
- exact same-tenant composite relations are required throughout.

Accepted implementation plan:

`docs/core/commerce/03-slice-planning/2026-07-14-isostack-commerce-core-slice-commerce-a2-checkout-order-order-line-schema-implementation-planning.md`

## 7. Cross-Lane Dependency

FUND implemented `1R-C1` through `1R-C5` inside its own schema lane without Commerce
Orders. FUND `1R-C6` then consumed the completed Commerce A2 Order/line foundation through
typed FUND-owned evidence and exact cross-schema relations. FUND Store `1R-D` subsequently
implemented internal Store readiness/configuration services against that evidence without
creating Commerce Orders, payments or another migration.

The FUND roadmap is a sibling control, not the parent Commerce roadmap:

`docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`

## 7.1 `COMMERCE-A2` Status

Planning:

`docs/core/commerce/03-slice-planning/2026-07-14-isostack-commerce-core-slice-commerce-a2-checkout-order-order-line-schema-implementation-planning.md`

Implementation confirmation:

`docs/core/commerce/04-implementation-confirmations/2026-07-14-commerce-a2-checkout-order-order-line-schema-implementation-confirmation.md`

Review/test:

`docs/core/commerce/05-review-and-test/2026-07-14-commerce-a2-checkout-order-order-line-schema-review-and-test.md`

Current result:

- implemented and reviewed as passed at application commit `3206199` on `origin/dev`;
- representative 135-to-136 and fresh 136-migration disposable lifecycles passed;
- A1 regression, same-tenant, state, arithmetic, tax and deletion suites passed;
- final disposable inventory is 136 applied, zero failed and zero test rows;
- no Commerce-owned database-to-Prisma drift was found;
- no shared database deployment was performed; staging/main remain unchanged.

## 8. Current Next Step

Controlled A7 promotion checkpoint: application `dev`/`origin-dev` and
`staging`/`origin-staging` are aligned at `91e8751c`; the Neon development database reports
all 140 migrations applied with none failed. Dev and staging security/type/schema gates,
staging health/database/RLS checks, FUND administrator login and pre-existing UI smoke
verification passed. Application `main` and live remain unchanged at `ea4e6193`. See
`docs/00-roadmap-control/2026-07-15-commerce-a7-dev-staging-promotion-confirmation.md`.

`COMMERCE-A1` through `COMMERCE-A4` are complete through review/test. The accepted generic
Order/line and same-tenant relation foundation supported FUND `1R-C6 - FUND Commerce
Context Foundation`, which is implemented/reviewed at local application commit `9947669`.
Its representative 136-to-137 and fresh 137-migration disposable lifecycles passed with
zero residue and no shared deployment.

Store `1R-D - Store Readiness And C1 Store Configuration API/Services` is now
implemented/reviewed at local application commit `db85fcc`. Its service/transaction suite
passed against the unchanged 137-migration disposable baseline with zero prefixed residue
and no shared deployment.

`COMMERCE-A3 - Payment, Refund And Pro-forma Schema Foundation` is implemented/reviewed at
local application commit `4a90be1`. Its representative 137-to-138 and fresh 138-migration
disposable lifecycles, A1/A2/C6 regressions and zero-residue checks passed. No shared
database deployment or runtime payment behavior was added.

Planning:

`docs/core/commerce/03-slice-planning/2026-07-14-isostack-commerce-core-slice-commerce-a3-payment-refund-pro-forma-schema-implementation-planning.md`

Implementation confirmation:

`docs/core/commerce/04-implementation-confirmations/2026-07-14-commerce-a3-payment-refund-pro-forma-schema-implementation-confirmation.md`

Review/test:

`docs/core/commerce/05-review-and-test/2026-07-14-commerce-a3-payment-refund-pro-forma-schema-review-and-test.md`

`COMMERCE-A4 - Audit And Idempotency Foundation` is implemented/reviewed at local application
commit `5b69920`. Its representative 138-to-139 and fresh 139-migration disposable
lifecycles, A1/A2/A3/C6 regressions and zero-residue checks passed. No shared database or
runtime service deployment occurred.

Planning:

`docs/core/commerce/03-slice-planning/2026-07-14-isostack-commerce-core-slice-commerce-a4-audit-idempotency-foundation-implementation-planning.md`

Implementation confirmation:

`docs/core/commerce/04-implementation-confirmations/2026-07-14-commerce-a4-audit-idempotency-foundation-implementation-confirmation.md`

Review/test:

`docs/core/commerce/05-review-and-test/2026-07-14-commerce-a4-audit-idempotency-foundation-review-and-test.md`

`COMMERCE-A5 - Provider-neutral Services And Validation` was implemented and reviewed at
application commit `fd7376b`. Pure validation and provider-neutral
transaction helpers passed the retained disposable PostgreSQL smoke suite with zero
residue; no schema migration or shared database deployment was performed.

Planning:

`docs/core/commerce/03-slice-planning/2026-07-14-isostack-commerce-core-slice-commerce-a5-provider-neutral-services-validation-implementation-planning.md`

Implementation confirmation:

`docs/core/commerce/04-implementation-confirmations/2026-07-14-commerce-a5-provider-neutral-services-validation-implementation-confirmation.md`

Review/test:

`docs/core/commerce/05-review-and-test/2026-07-14-commerce-a5-provider-neutral-services-validation-review-and-test.md`

`COMMERCE-A6 - Stripe Connect Tenant Payments` parent planning was reviewed and accepted on
2026-07-14:

`docs/core/commerce/03-slice-planning/2026-07-14-isostack-commerce-core-slice-commerce-a6-stripe-connect-tenant-payments-planning.md`

The accepted plan fixes tenant-owned connected accounts, direct charges, C1
merchant-of-record responsibility, tenant master-settings configuration, hosted onboarding
and a four-child serial delivery. It also preserves subscription-billing isolation and
requires tenants to enter no Stripe secret.

The bounded `COMMERCE-A6-A - Stripe Connect Account And Event-Inbox Schema Foundation`
implementation plan was reviewed and accepted on 2026-07-15:

`docs/core/commerce/03-slice-planning/2026-07-15-isostack-commerce-core-slice-commerce-a6-a-stripe-connect-account-event-inbox-schema-foundation-implementation-planning.md`

`COMMERCE-A6-A - Stripe Connect Account And Event-Inbox Schema Foundation` is implemented
and reviewed as passed at application commit `513cf3a`.

Implementation confirmation:

`docs/core/commerce/04-implementation-confirmations/2026-07-15-commerce-a6-a-stripe-connect-account-event-inbox-schema-foundation-implementation-confirmation.md`

Review/test:

`docs/core/commerce/05-review-and-test/2026-07-15-commerce-a6-a-stripe-connect-account-event-inbox-schema-foundation-review-and-test.md`

Its representative 139-to-140 and full fresh 140-migration disposable lifecycles passed,
including connection/onboarding/event tenant, identity, status, readiness, immutability,
retention and deletion checks plus A1-A5/C1-C6 regressions. Final disposable inventory is
140 applied, zero failed and zero A6-A rows. No shared database or Stripe runtime behavior
was deployed.

`COMMERCE-A6-B - Tenant Payment Settings And Hosted Onboarding` is implemented and reviewed
as passed at local application commit `e8aecea`.

Planning:

`docs/core/commerce/03-slice-planning/2026-07-15-isostack-commerce-core-slice-commerce-a6-b-tenant-payment-settings-hosted-onboarding-implementation-planning.md`

Implementation confirmation:

`docs/core/commerce/04-implementation-confirmations/2026-07-15-commerce-a6-b-tenant-payment-settings-hosted-onboarding-implementation-confirmation.md`

Review/test:

`docs/core/commerce/05-review-and-test/2026-07-15-commerce-a6-b-tenant-payment-settings-hosted-onboarding-review-and-test.md`

A6-B retained the complete 140-migration baseline, used no real Stripe network action and
passed fake-provider lifecycle, tenant/actor, idempotency/concurrency, state, readiness,
audit-redaction, production-build and zero-residue validation. It is not pushed or deployed
to a shared environment.

`COMMERCE-A6-C - Connected-account Checkout Adapter` is implemented and reviewed as passed
at local application commit `34ef64bb`:

`docs/core/commerce/03-slice-planning/2026-07-15-isostack-commerce-core-slice-commerce-a6-c-connected-account-checkout-adapter-implementation-planning.md`

Implementation confirmation:

`docs/core/commerce/04-implementation-confirmations/2026-07-15-commerce-a6-c-connected-account-checkout-adapter-implementation-confirmation.md`

Review/test:

`docs/core/commerce/05-review-and-test/2026-07-15-commerce-a6-c-connected-account-checkout-adapter-review-and-test.md`

A6-C retained the complete 140-migration baseline and passed fake-provider direct-charge,
readiness, ownership, arithmetic, Payment-key idempotency/concurrency, FAILED retry,
rollback/compensation, nullable/later PaymentIntent, audit-redaction, build and zero-residue
validation. No real Stripe call, migration, route, UI, webhook, payment transition or
shared deployment occurred.

`COMMERCE-A6-D - Connected-account Webhook, Payment/Refund Synchronization And
Reconciliation` is implemented and reviewed as passed at local application commit
`fa670e3c`:

`docs/core/commerce/03-slice-planning/2026-07-15-isostack-commerce-core-slice-commerce-a6-d-connected-account-webhook-payment-refund-reconciliation-implementation-planning.md`

Implementation confirmation:

`docs/core/commerce/04-implementation-confirmations/2026-07-15-commerce-a6-d-connected-account-webhook-payment-refund-reconciliation-implementation-confirmation.md`

Review/test:

`docs/core/commerce/05-review-and-test/2026-07-15-commerce-a6-d-connected-account-webhook-payment-refund-reconciliation-review-and-test.md`

A6-D retained the complete 140-migration baseline and passed signed current/previous/
tampered/stale fixtures, immutable receipt/deduplication, canonical Payment and
provider-originated Refund reconciliation, bounded retry/quarantine, shared-job isolation,
A6-B/A6-C regressions, production build and zero-residue validation. No real Stripe call,
shared secret/Event destination, deployment, schema, UI, FUND or production behavior was
added.

The bounded `COMMERCE-A7 - FUND Consumer Integration` lifecycle is implemented/reviewed:

`docs/core/commerce/03-slice-planning/2026-07-15-isostack-commerce-core-slice-commerce-a7-fund-consumer-integration-implementation-planning.md`

A7 passed type/static/build, disposable atomic/replay and retained A6-C/A6-D regression
validation on the unchanged 140-migration baseline with zero A7 residue.

Application implementation `598305ce` is included in the completed dev/staging promotion
at `91e8751c`. The Commerce lane is complete through A7's dormant transaction boundary.
The FUND `1R-E - C1 Store Oversight And C2 Project Store Control Alignment` parent plan is
reviewed and accepted. The bounded E-A Store authority/intervention service lifecycle is
implemented/reviewed at application `dev`/`origin/dev` commit `daafc349` against a complete
141-migration disposable baseline; it
changes no generic Commerce ownership. The bounded `1R-E-B` portfolio-oversight
implementation/review lifecycle is complete locally with no Commerce schema or migration
change. `1R-E-C - C2 Project Store Control Surface` is implemented/reviewed locally with
no Commerce schema/migration or shared deployment; its human UI schedule remains pending.
FUND E-D is implemented/reviewed on isolated application commit `c45a41d9` with no Commerce
schema/migration change, no promotion and no shared reconciliation. Its human Store workflow
schedule remains pending controlled promotion. The non-executable FUND `1R-F - Project Offer
And Artwork Readiness Reconciliation` parent is reviewed/accepted at
`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-f-project-offer-artwork-readiness-reconciliation-planning.md`.
`1R-F-A - Real AMOW Template, Pricing And Deployed Renderer Proof` remains the single next
cross-lane planning candidate; no proof implementation, `1R-G` or artwork/template production
implementation is authorised.

`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-e-c1-store-oversight-c2-project-store-control-alignment-planning.md`

`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-e-a-store-authority-exceptional-intervention-lifecycle-service-alignment-implementation-planning.md`

`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-e-c-c2-project-store-control-surface-implementation-planning.md`

A7 planning must also read the subordinate FUND Store/artwork strategic completion
overview and its three registered 2026-07-15 CR inputs through the authoritative FUND
roadmap. They inform exact workflow and immutable offer-evidence preservation; they do not
expand A7 into Template Manager/Artwork Template, collective artwork approval, Store UI,
production, fulfilment or commission work. Generic Commerce retains Order, Checkout,
Payment and refund ownership, while later bounded FUND slices retain those business
capabilities and their unresolved decisions.

The plan proposes an internal/no-migration `STRIPE_ONLINE` boundary: FUND revalidates one
published/open immutable Store offer, generic Commerce creates Checkout/Order/lines/PENDING
Payment, FUND creates typed contexts in the same transaction and A6-C is invoked only after
commit. Public Store/UI, pro-forma, upload, Order Code/email, production, fulfilment and
commission remain excluded. Review also fixes FUND ownership of FUND idempotency scopes,
tenant-scoped guest eligibility without a fabricated User, exact file/asset-version
evidence and immutable-Order payment retry without repricing.
