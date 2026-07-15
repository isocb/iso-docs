# COMMERCE-A6-B Tenant Payment Settings And Hosted Onboarding Review And Test

Date: 2026-07-15

Status: Passed; A6-B lifecycle complete, A6-C not started

Implementation under review: application commit `e8aecea`

## Review Result

The implementation conforms to the accepted A6-B boundary. Tenant and actor identity are
derived from protected session context, mutations refuse impersonated context, and service
authorization re-reads the exact active User role. OWNER controls onboarding and local
enablement; ADMIN receives safe status only; MEMBER and cross-tenant access are rejected.

The provider adapter uses the pinned stable Accounts v1 full-Dashboard controller contract,
card-payments capability request and `account_onboarding` links. It uses Stripe idempotency
keys, validates account/controller/mode identity, derives livemode from the deployment
secret and stores only bounded readiness evidence. No secret, KYC value, Account Link,
state token or full provider body enters persistence or audit metadata.

Return and refresh use fixed deployment-owned URLs, SHA-256 state hashes, expiry,
single-use terminal evidence, transaction locking and initiating-OWNER ownership. The
normal settings redirect contains no state. Provider-side account deletion and Express
login links are absent; local disable remains available immediately.

## Automated Evidence

Passed:

- TypeScript type check;
- targeted Vitest: 2 files, 7 tests;
- fake-provider disposable integration covering new account, resume, OWNER/ADMIN/MEMBER,
  cross-tenant refusal, stable replay, concurrent duplicate convergence, return, refresh,
  expiry, replay, controller/mode safety, READY enablement, non-ready refusal, readiness
  loss forcing checkout off, local disable and audit redaction;
- complete Next.js production build, including the Payments page and both Connect routes;
- repository critical-file verifier;
- unchanged disposable database inventory: 140 applied, zero failed;
- A6-A-owned drift/residue check: zero connection, attempt and event rows;
- A6-B fixture cleanup: zero residue.

Commands included:

```text
npx vitest run src/modules/commerce/services/stripe-connect.service.test.ts \
  src/modules/commerce/services/commerce-core.service.test.ts
npx tsx --env-file=.env scripts/run-commerce-a6-b-service-tests.ts
npx tsx scripts/run-commerce-a6-a-database-tests.ts --drift-only
npx tsc --noEmit --pretty false
npm run build
npx tsx scripts/verify-critical-files.ts
git diff --check
```

The production build emitted existing local-environment warnings that Upstash Redis was
not configured with an HTTPS URL. The build passed; those warnings are unrelated to A6-B
and do not weaken its protected service authorization.

## Safety And Deployment Result

- `TEST_DATABASE_URL` was proved distinct from `DATABASE_URL` before integration tests;
- the retained disposable database alone received transient A6-B fixture rows;
- no database migration was needed or applied;
- no real Stripe API call or account was created;
- no shared development, staging or production database was modified;
- no application push or deployment is claimed.

## Conclusion

A6-B is implemented and reviewed as passed. The single next candidate is bounded A6-C
planning for the connected-account Checkout adapter. A6-C implementation is not authorised
by this record.
