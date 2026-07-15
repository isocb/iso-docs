# Commerce A6-D Connected-account Webhook, Payment/Refund Synchronization And Reconciliation Review And Test

Date: 2026-07-15

Status: Passed; application commit `fa670e3c`; no shared deployment or Stripe
configuration performed

## 1. Review Scope

Reviewed application commit `fa670e3c` against the accepted A6 parent and A6-D plan,
completed A1-A5/A6-A-A6-C contracts, the unchanged 140-migration Prisma/PostgreSQL model,
the subscription webhook, shared job runner and pinned Stripe API contract.

## 2. Boundary Review

Passed:

- dedicated Connect route, current/previous secret handling and subscription isolation;
- raw-body signature verification before account resolution or persistence;
- exact account/livemode ownership and unknown-account no-row behavior;
- immutable-envelope receipt, provider-event deduplication and collision refusal;
- allowlist, ignored-event and unsupported-API-version terminal handling;
- 25-row `FOR UPDATE SKIP LOCKED` claims, five-minute lease token, bounded retry and
  eight-attempt quarantine;
- provider retrieval outside claim transactions and SERIALIZABLE final mutation;
- exact Payment/Order/Checkout/Seller/account, amount, currency and arithmetic authority;
- non-terminal failed attempts, successful Payment, canceled PaymentIntent and terminal
  Checkout expiry, including expiry before a PaymentIntent exists;
- provider-originated Refund forward transitions and atomic completed-refund aggregates;
- append-only provider audit and A4 idempotency evidence;
- no forbidden persistence, logging, schema, UI, FUND or subscription mutation.

## 3. Executed Validation

Passed:

- `npm run type-check`;
- 17 Commerce unit tests across Commerce Core, A6-B, A6-C and A6-D;
- official Stripe signed-header fixtures for current, previous, tampered, unrelated and
  stale-secret cases;
- repository critical-file verifier;
- A6-D disposable PostgreSQL receipt, duplicate/collision, Payment, Refund,
  ignore/quarantine, retry/job-isolation, redaction and zero-residue suite;
- A6-B fake-provider lifecycle regression with zero residue;
- A6-C direct-charge/idempotency/compensation regression with zero residue;
- two successful production builds, including the new Connect route;
- `git diff --check` and explicit confirmation of 140 migration directories.

The legacy A6-A installer harness was not treated as a current regression runner because
it intentionally asserts a 139-migration pre-A6-A database before installing migration
140. It correctly refused the already-complete 140 baseline. A6-D's service suite directly
asserted the current 140 inventory, while A6-B/A6-C regressions confirmed retained A6
behavior.

The production build emitted the existing local warning that Upstash Redis is not
configured; this is unrelated to A6-D and did not fail the build.

## 4. Disposable Database Evidence

- `TEST_DATABASE_URL` and `DATABASE_URL` target identities differed.
- Applied migration inventory remained exactly 140.
- No migration or schema write occurred.
- No real Stripe provider action occurred.
- All prefixed Organizations, users, Commerce records, inbox rows, A4 operations and audit
  fixtures were removed.

## 5. Review Outcome

A6-D satisfies its accepted boundary and is complete through review/test at application
commit `fa670e3c`.

A7 remains a separate, unauthorised slice. A6-D is also not deployment-complete: Connect
secrets, an Event destination, shared database state, application promotion and operational
monitoring remain controlled deployment work.
