# IsoStack Commerce Core Slice COMMERCE-A4 - Audit And Idempotency Foundation Implementation Planning

Date: 2026-07-14

Status: Implemented and reviewed as passed at application commit `5b69920`

Parent architecture:

`docs/core/commerce/02-triage/2026-07-13-isostack-commerce-core-schema-foundation-planning.md`

Completed prerequisites:

- `COMMERCE-A1` Seller Profile and stable Commerce enums;
- `COMMERCE-A2` Checkout, Order and Order-line schema foundation;
- `COMMERCE-A3` Payment, Refund and Pro-forma schema foundation;
- FUND `1R-C6` and Store `1R-D` consumer evidence/services remain separate.

## 1. Goal

Add generic, tenant-owned Commerce evidence for request replay and lifecycle audit without
adding payment services, provider webhooks or module-specific behavior.

The bounded chain is:

```text
request scope + idempotency key
-> one CommerceIdempotencyRecord
-> zero or more linked CommerceAuditEvent rows
```

Idempotency records are mutable state evidence for a later service. Audit events are
append-only evidence. A4 creates the persistence contract only; A5 owns service transitions,
claim/replay behavior and validation.

## 2. Entry Baseline And Migration Boundary

Implementation begins from application commit `4a90be1`, with the complete 138-migration
history. A4 adds one bounded migration, advancing 138 to 139.

The migration must:

- create two Commerce-prefixed enums and two Commerce tables;
- add only the exact Organization/idempotency reverse relations required by the models;
- create no operational audit or idempotency rows;
- alter no existing Commerce, FUND or LMSPro value;
- contain no provider-event, Stripe, Order, Payment or FUND relation.

## 3. Accepted Vocabulary

### 3.1 `CommerceAuditActorType`

```text
SYSTEM
USER
SERVICE
PROVIDER
GUEST
```

The actor ID is opaque evidence. A4 does not relate it to a platform User or provider
account.

### 3.2 `CommerceIdempotencyStatus`

```text
RECEIVED
PROCESSING
COMPLETED
FAILED
EXPIRED
```

The status records the later service lifecycle; A4 does not implement transitions.

## 4. `CommerceIdempotencyRecord`

Purpose: one tenant/scope/key request identity with safe replay evidence.

Fields:

```text
id, organizationId, scope, key, requestHash, status
responseStatus?, responseBody?, resourceType?, resourceId?, errorCode?
firstSeenAt, processingAt?, completedAt?, expiresAt?, lastSeenAt
createdAt, updatedAt
```

Contracts:

- `organizationId + scope + key` is unique;
- scope is a bounded uppercase code and key is nonblank bounded opaque input;
- requestHash is exactly 64 hexadecimal characters;
- response status/body/resource/error fields are safe replay evidence only, never secrets;
- `COMPLETED` requires a bounded response status and completion timestamp;
- `FAILED` requires completion timestamp and a nonblank error code;
- `RECEIVED` has no processing/completion evidence;
- `PROCESSING` has processing evidence and no completion evidence;
- `EXPIRED` is a terminal status whose expiry evidence is retained;
- expiry, processing and completion timestamps preserve chronology where present.

## 5. `CommerceAuditEvent`

Purpose: append-only tenant audit evidence for Commerce lifecycle changes and replay links.

Fields:

```text
id, organizationId, actorType, actorId?, sourceCode, eventCode
entityType, entityId?, idempotencyRecordId?, metadata
occurredAt, recordedAt
```

Contracts:

- every row belongs to exactly one Organization;
- source, event and entity type are bounded uppercase codes;
- metadata is a JSON object containing safe evidence only;
- an optional idempotency link must share the exact tenant;
- database trigger rejects UPDATE and DELETE, preserving append-only evidence;
- Organization and linked idempotency deletion are restricted;
- actor identity remains opaque and does not create User, provider or FUND relations.

## 6. Keys, Indexes And Deletion

```text
CommerceIdempotencyRecord:
  unique (organizationId, id)
  unique (organizationId, scope, key)

CommerceAuditEvent:
  unique (organizationId, id)
  optional FK (organizationId, idempotencyRecordId)
```

Indexes cover tenant/status/expiry, tenant/request hash, tenant/entity/time,
tenant/event/time and tenant/idempotency reference. Organization deletion is restricted by
both tables. Idempotency deletion is restricted while audit evidence references it.

## 7. Migration, Rollback And Backfill

- migration `20260716001000_commerce_a4_audit_idempotency_foundation` advances 138 to 139;
- no existing row receives inferred audit or idempotency data;
- failed migration replay must leave no A4 table, enum, trigger or migration residue;
- rollback testing drops only A4 fixtures/objects on the disposable target;
- existing A1/A2/A3 and FUND C6 values must remain unchanged.

## 8. Explicit Exclusions

Do not implement:

- idempotency claim/replay/expiry services;
- audit write service or authorization policy;
- checkout, Order, Payment, Refund or Pro-forma transitions;
- Stripe/provider webhooks or signature verification;
- API, routes, UI, email, FUND relations or Store behavior;
- provider secrets, raw request bodies or purchaser PII;
- A5 service-level validation and transaction orchestration.

## 9. Disposable Validation

Use only `TEST_DATABASE_URL` after proving it differs from `DATABASE_URL`.

Required evidence:

- representative 138-to-139 migration preserves existing A1/A2/A3/C6 values and creates
  zero A4 rows;
- fresh replay of all 139 migrations;
- valid idempotency status shapes and audit events;
- duplicate scope/key and cross-tenant rejection;
- hash/code/blank/metadata/chronology checks;
- exact tenant-linked idempotency FK rejection;
- audit UPDATE/DELETE trigger rejection;
- Organization/idempotency restrictive deletion;
- A1/A2/A3/C6 regressions, Commerce-owned drift review and zero residue.

## 10. Acceptance Outcome

The plan is accepted for implementation on 2026-07-14. The implementation boundary is
schema/migration/verifier only. A5 remains responsible for all runtime behavior.

## 11. Single Bounded Implementation Prompt

```text
Continue only accepted IsoStack Commerce Core Slice COMMERCE-A4. Implement only the
CommerceAuditActorType and CommerceIdempotencyStatus enums, CommerceIdempotencyRecord and
CommerceAuditEvent schema foundation, immutable audit trigger, exact tenant/scope/key and
tenant-linked idempotency contracts, checks, indexes and restrictive deletion in one
138-to-139 migration.

Create no idempotency or audit service, claim/replay behavior, checkout/Order/payment/
refund/pro-forma transitions, provider/Stripe/webhook code, API, route, UI, email, FUND
relation or Store behavior. Preserve all existing values and create no A4 rows by migration.
Use only TEST_DATABASE_URL after proving it differs from DATABASE_URL. Complete representative
upgrade, fresh replay, constraints, immutable-audit, deletion, A1/A2/A3/C6 regression, drift
and zero-residue validation, then create separate implementation-confirmation and review/test
records and update the Commerce, FUND and root roadmaps. Stop before A5.
```

## 12. Lifecycle Outcome

The accepted scope was implemented at application commit `5b69920`. Representative 138-to-139
and fresh 139-migration disposable lifecycles, A1/A2/A3/C6 regressions, tenant/key/status
constraints, immutable audit trigger tests, drift review and zero-residue checks passed on
the distinct disposable `TEST_DATABASE_URL`. Separate implementation-confirmation and
review/test records complete A4. No shared database or runtime idempotency/audit service was
changed.
