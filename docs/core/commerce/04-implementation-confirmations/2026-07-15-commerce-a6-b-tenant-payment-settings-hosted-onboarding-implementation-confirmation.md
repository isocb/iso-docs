# COMMERCE-A6-B Tenant Payment Settings And Hosted Onboarding Implementation Confirmation

Date: 2026-07-15

Status: Implemented at application commit `e8aecea`; independently reviewed and tested

Planning authority:

`docs/core/commerce/03-slice-planning/2026-07-15-isostack-commerce-core-slice-commerce-a6-b-tenant-payment-settings-hosted-onboarding-implementation-planning.md`

## Implemented

- a narrow injectable Accounts v1 Stripe Connect provider boundary;
- safe full-Dashboard connected-account normalization and readiness synchronization;
- OWNER-only idempotent account creation/resume and local checkout enable/disable;
- hashed, expiring, single-use onboarding state with same-tenant/same-OWNER return and
  refresh handling;
- fixed server-owned return/refresh URLs and production HTTPS validation;
- OWNER/ADMIN safe status through a Commerce-owned protected router;
- append-only Commerce audit plus core tenant audit evidence;
- an Organisation Payments settings tab with hosted onboarding, readiness and local
  checkout controls;
- fake-provider unit/integration coverage and zero-residue disposable tests.

## Preserved Boundaries

- no Prisma model or migration was added; the migration inventory remains 140;
- no real Stripe account, Account Link or other Stripe network action occurred in tests;
- tenants enter no secret, KYC, bank or card information into IsoStack;
- `Organization.stripeCustomerId` and the subscription webhook remain unchanged;
- no Connect webhook, Checkout Session, PaymentIntent, Commerce Order/payment/refund
  transition, email, FUND behavior, account deletion or Express login link was added;
- A6-C and A6-D remain separate future slices.

## Application Evidence

Application commit:

```text
e8aecea feat(commerce): add Stripe Connect tenant onboarding
```

The implementation is committed locally on application `dev`. No push, shared-database
migration, staging deployment or production deployment is claimed by this record.
