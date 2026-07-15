# COMMERCE-A6-A Stripe Connect Account And Event-Inbox Schema Foundation — Review And Test

Date: 2026-07-15

Status: Passed; A6-A lifecycle complete

Application commit reviewed: `513cf3a`

## Review Outcome

The implementation matches the accepted schema-only boundary. It introduces retained,
tenant-owned Stripe Connect account identity, hashed onboarding-attempt evidence and a
safe deduplicated event inbox without coupling generic Commerce Payment to Stripe.

Review confirmed:

- exact same-tenant Organization, User, connection, account and mode ownership;
- globally unique connected-account and provider-event identities;
- one current connection per tenant and one open onboarding attempt per connection;
- fixed full-Dashboard/controller evidence and conservative checkout readiness;
- server-derived immutable `livemode` evidence;
- bounded safe identifiers, hashes, counts and timestamps only;
- retained connection/event evidence with immutable identity/envelope triggers;
- zero migration backfill and no operational/runtime Stripe behavior.

## Validation Evidence

Only the local `TEST_DATABASE_URL` target was used after normalized target comparison
proved it differed from `DATABASE_URL`.

Passed:

- Prisma format, validation and client generation;
- TypeScript compilation;
- A5 provider-neutral service unit tests: 3/3;
- representative 139-to-140 migration with existing Organization, User, subscription
  customer, Seller, Order, Payment provider-reference and FUND Client evidence preserved;
- full fresh replay of all 140 migrations;
- all six connection statuses and all five capability values through valid/invalid cases;
- controller/readiness/checkout, country/currency, count/fingerprint and chronology checks;
- global account, one-current, tenant actor and restrictive deletion checks;
- pending, consumed, expired and cancelled onboarding attempts, hash/expiry/single-open/
  terminal/tenant/immutability checks;
- all six Event Inbox statuses, provider-event deduplication, exact account/mode/tenant,
  hash/object/status/retry/chronology and immutable-envelope/deletion checks;
- Commerce A1-A4 database regression suites and A5 provider-neutral static/service tests;
- FUND C1-C6 schema regression suites;
- subscription Stripe integration static boundary check;
- A6-A-scoped database-to-Prisma drift check.

The drift projection reported only previously documented unrelated LMSPro/FUND
name/default differences and no A6-A-owned difference.

Final disposable inventory:

```text
applied=140
failed=0
a6a_rows=0
a6a_fixture_orgs=0
```

## Delivery Gate

A6-A is complete through planning, implementation confirmation and review/test. No shared
database deployment occurred. `COMMERCE-A6-B - Tenant Payment Settings And Hosted
Onboarding` becomes the single next planning candidate; it is not authorised for
implementation by this record.
