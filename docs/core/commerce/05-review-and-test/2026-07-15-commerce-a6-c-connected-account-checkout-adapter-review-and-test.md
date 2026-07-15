# COMMERCE-A6-C Connected-account Checkout Adapter Review And Test

Date: 2026-07-15

Status: Passed; A6-C lifecycle complete, A6-D not started

Implementation under review: application commit `34ef64bb`

## Review Result

The implementation conforms to the accepted dormant internal-service boundary. All price,
currency, purchaser, Seller, Order, Payment and connected-account authority is re-read from
the exact tenant-owned persisted chain. The service refreshes canonical Account readiness,
uses a direct charge under the retained connected account and creates one gross card-only
Stripe-hosted Session through an injectable provider.

The provider call occurs outside database transactions. Payment-key A4 idempotency and a
stable provider key make retry convergent; final reference persistence, audit and operation
completion are atomic. Permanent authority loss after provider creation returns no URL and
attempts same-account Session expiry. Completed replay never creates a replacement and can
safely add a later PaymentIntent reference.

The A5 correction now satisfies the existing A4 PostgreSQL status-shape contract for both
FAILED creation and FAILED/expired retry. It changes no schema or business state.

## Automated Evidence

Passed:

- TypeScript type check and repository critical-file verifier;
- targeted Vitest: 3 files, 12 tests;
- fake-provider disposable PostgreSQL service tests covering exact ownership, readiness
  loss and forced disable, arithmetic/amount/currency refusal, stable provider retry,
  Payment-key replay and concurrency, FAILED retry constraints, null/later PaymentIntent,
  permanent authority-loss compensation, cross-tenant refusal, redaction and zero residue;
- complete Next.js production build;
- unchanged disposable inventory: 140 applied and zero failed;
- A6-A drift/residue check: zero connection, attempt and event rows;
- A6-C fixture cleanup: zero residue.

Commands included:

```text
npx tsc --noEmit
npx vitest run src/modules/commerce/services/stripe-checkout.service.test.ts \
  src/modules/commerce/services/stripe-connect.service.test.ts \
  src/modules/commerce/services/commerce-core.service.test.ts
npx tsx --env-file=.env scripts/run-commerce-a6-c-service-tests.ts
npx tsx --env-file=.env scripts/run-commerce-a6-a-database-tests.ts --drift-only
npm run build
npm run verify
git diff --check
```

The production build emitted existing local-environment warnings that Upstash Redis was
not configured with an HTTPS URL. The build passed; the warnings are unrelated to this
dormant Commerce service.

## Safety And Deployment Result

- `TEST_DATABASE_URL` was proved distinct from `DATABASE_URL` before database tests;
- only the retained disposable database received transient fixture rows;
- no migration was added or applied;
- no real Stripe network call or charge occurred;
- no shared development, staging or production database was modified;
- no application push or deployment is claimed.

## Conclusion

A6-C is implemented and reviewed as passed. The single next candidate is bounded A6-D
planning for connected-account webhook, payment/refund synchronization and reconciliation.
A6-D implementation is not authorised by this record.
