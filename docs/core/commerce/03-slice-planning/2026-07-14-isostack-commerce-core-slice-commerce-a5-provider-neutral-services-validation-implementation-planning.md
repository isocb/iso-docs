# IsoStack Commerce Core Slice COMMERCE-A5 — Provider-neutral Services And Validation

Status: Accepted for implementation; implementation is bounded to provider-neutral service primitives and validation. No schema migration is required.

## 1. Purpose and boundary

COMMERCE-A5 turns the A1–A4 Commerce persistence contract into reusable, provider-neutral transaction helpers. It owns idempotency claim/replay, append-only audit emission, order total and line arithmetic validation, payment/refund state transitions, and Pro-Forma settlement reconciliation. A5 does not expose a route, create a checkout, integrate Stripe, or add FUND behaviour.

The service layer is deliberately dormant until a later Commerce route slice calls it. Every mutating operation is tenant-scoped, idempotent where a request key exists, auditable, and executed in one transaction. A5 never trusts provider payloads or client totals without validating currency, amount, and state transitions.

## 2. Accepted contracts

- `CommerceIdempotencyRecord` is claimed by `(organizationId, scope, key)` and bound permanently to the SHA-256 request hash. A matching completed record is replayable; a different hash is a conflict; processing is reported as in progress; failed/expired records may be retried only under an explicit retry policy.
- Claim/retry uses a transaction advisory lock over the tenant, scope, and key. Completion/failure stores only safe response metadata and emits an append-only `CommerceAuditEvent`.
- Order totals are recomputed from persisted line values: quantity and non-negative minor-unit amounts must reconcile to order net/tax/gross totals, with discount and delivery components included. Currency and minor-unit exponent must agree across order, lines, payments, refunds and pro-forma records.
- Payment transitions are monotonic: `PENDING` may become `PAID`, `FAILED`, or `CANCELLED`; paid payments may become `PARTIALLY_REFUNDED` or `REFUNDED`; `NOT_REQUIRED` is terminal. Amount paid/refunded cannot exceed the requested amount.
- Refunds transition through `REQUESTED`, `PROCESSING`, and one terminal outcome. Completed refunds are aggregated under a payment row lock and update payment refund totals/status atomically.
- Pro-Forma transitions are `DRAFT -> ISSUED -> ACCEPTED -> SETTLED` with cancellation only before settlement. Settlement is provider-neutral evidence and atomically reconciles the linked Pro-Forma payment to `PAID` with the same currency and amount.
- Audit events are insert-only; the A4 database trigger remains the final immutability guard. No service updates or deletes audit rows.

## 3. Explicit exclusions

No Prisma schema or migration, checkout/session creation, Order creation route, public/C1 API, provider adapter, Stripe/webhook behavior, payment UI, refund UI, Store readiness/publication, FUND relations, commission calculation, production behavior, or email is included.

## 4. Validation and failure semantics

Pure validators return typed failures for malformed keys/hashes, cross-tenant identifiers, negative or overflowing amounts, inconsistent totals/currency, illegal transitions, duplicate completed refunds, and invalid Pro-Forma/payment combinations. Transaction helpers roll back all writes on any failure. Error responses never expose provider payloads or purchaser secrets.

## 5. Verification

Run unit tests for every validator and transition matrix; static checks and Prisma generation; then run service smoke tests only against `TEST_DATABASE_URL` after proving it differs from `DATABASE_URL`. Cover fresh/representative A1–A4 baseline, idempotency replay/conflict/retry and advisory-lock concurrency, audit append-only behavior, order reconciliation, payment/refund/pro-forma atomic rollback and cross-tenant rejection. Leave zero A5 fixture residue. No shared database deployment is claimed.

## 6. Lifecycle prompt

Implement only the accepted COMMERCE-A5 provider-neutral validation and transaction helpers described above. Use the existing A1–A4 schema without modification, validate only on `TEST_DATABASE_URL`, create separate implementation-confirmation and review/test records, update Commerce/FUND/root roadmaps and README, and stop before COMMERCE-A6.
