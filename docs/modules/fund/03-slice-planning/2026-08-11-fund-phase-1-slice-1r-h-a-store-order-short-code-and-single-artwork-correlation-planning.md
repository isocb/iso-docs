# FUND Phase 1 Slice 1R-H-A — Store Order Short Code And Single-Artwork Correlation

Date: 2026-08-11

Status: **PARKED BOUNDED DOWNSTREAM PLAN; NOT PORTFOLIO NOW/NEXT; NO SCHEMA, SERVICE, UI OR
IMPLEMENTATION AUTHORISED**

Owning lane: FUND consumer Order completion, after public Store `1R-G`

Authoritative controls:

- [`FUND roadmap`](../00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md)
- [`strategic Store/artwork/Order roadmap`](../00-roadmap-control/2026-07-15-fund-store-artwork-orders-and-production-strategic-completion-roadmap.md)
- [`Application and Artwork Template refinement`](../01-cr-inputs/2026-07-15-fund-application-artwork-template-refinement.md)
- [`1R-F parent reconciliation`](2026-07-15-fund-phase-1-slice-1r-f-project-offer-artwork-readiness-reconciliation-planning.md)
- [`1R-F-A renderer proof`](2026-08-11-fund-phase-1-slice-1r-f-a-real-amow-template-pricing-and-deployed-renderer-proof-planning.md)

## 1. Placement And Purpose

This plan preserves the accepted human Store Order Code and one-artwork-per-Order business
contract without implementing it during the renderer proof.

`1R-F-A` proves only the six empty handwriting boxes and the instructions around them.
`1R-H-A`, when selected after `1R-G` and consumer-Order parent reconciliation, will own
allocation, persistence, receipt presentation and operational lookup of the code.

## 2. Accepted Business Contract

1. Each different child's artwork requires a separate Store Order.
2. One Store Order may contain several Product lines/quantities only when they all relate to
   that same single artwork.
3. A completed Store sale allocates a short numeric Store Order number.
4. Purchaser-facing display is always exactly six digits:
   - ordinary four-significant-digit values have two leading zeroes, for example `004271`;
   - five-significant-digit values have one leading zero; and
   - six-significant-digit values have no padding.
5. The purchaser copies all six displayed digits from the confirmation/receipt into the six
   empty boxes on the physical Artwork Template.
6. The short value may be reused across Events/Projects. The human reconciliation key is:

```text
C1 tenant context + tenant-unique Project number + six-digit Store Order Code
```

7. That composite is business uniqueness/correlation, not technical idempotency.
8. Generic Commerce Order identity, provider transaction references and idempotency keys
   remain separate machine authorities and provide the diagnostic fallback.
9. The short code is not an authentication secret and must never grant purchaser, Order or
   payment access by itself.

## 3. Current Schema Findings

The current application already owns the correct generic and FUND boundaries:

- `CommerceOrder.id` is the generic machine Order identity;
- `CommerceOrder.orderNumber` is unique within the tenant and must not be weakened or reused
  as the Event/Project-scoped handwriting code;
- `CommerceOrder.checkoutSessionId` and Commerce idempotency/provider evidence protect
  retry, payment and transaction processing;
- `FundOrderContext` is one-to-one with the Commerce Order and already snapshots
  `projectId`, `eventIdSnapshot`, `projectNumberSnapshot`, `storeId` and `clientId`; and
- `FundProject.projectNumber` is unique within the tenant.

The likely later schema home is therefore `FundOrderContext`, not a new FUND Order aggregate
and not a changed generic `CommerceOrder.orderNumber` contract.

## 4. Proposed Later Data Contract

Exact migration design remains subject to executable-slice review, but the safe direction
is an immutable FUND-specific value such as:

```text
FundOrderContext.storeOrderSequence  integer 1..999999
FundOrderContext.storeOrderCode      six-character zero-padded snapshot
unique(organizationId, projectId, storeOrderCode)
```

Rules:

- allocate atomically inside the same transaction that creates/binds the successful FUND
  Order context;
- use a Project-scoped lock/counter or equivalent concurrency-safe allocator;
- format the immutable display string from the allocated integer with left zero padding;
- fail closed at namespace exhaustion rather than wrap or reuse inside the same Project;
- permit the same display code in another Project/Event namespace;
- preserve `projectNumberSnapshot` and the code together for historic lookup even if names
  or Event context later change;
- never derive payment state from the presence of a short code; and
- never use the short code as the checkout/request idempotency key.

The exact verified payment/sale transition that makes allocation immutable remains a later
Commerce/FUND integration decision. Browser return alone is never authority.

## 5. Bounded Future Outcome

When separately selected and authorised, this slice should provide:

- transactional Project-scoped allocation and immutable six-digit display snapshot;
- one-artwork-per-Order validation for Individual Artwork Projects;
- confirmation/receipt and transactional-email exposure of the display code;
- C1 lookup using Project number plus Store Order Code;
- fallback lookup through generic Order/payment transaction evidence;
- correct privacy scoping and rate limiting; and
- audit evidence for allocation, lookup and exceptional reconciliation.

## 6. Required Automated Evidence

The later executable review must cover:

1. formatting boundaries `000001`, `009999`, `010000`, `099999`, `100000` and `999999`;
2. same-Project concurrent allocation never duplicates a code;
3. retry with the same machine idempotency evidence returns the same Order/code;
4. a distinct Order in the same Project receives a distinct code;
5. the same display code may exist in a different Project/Event without ambiguity;
6. tenant plus Project number plus code resolves exactly one authorised FUND Order context;
7. code-only lookup cannot leak cross-Project or cross-tenant evidence;
8. allocation refuses namespace exhaustion and rolls back cleanly;
9. one Store Order cannot contain two different artwork subjects;
10. several Product lines for one artwork remain valid;
11. the code cannot alter or infer Payment status;
12. confirmation/receipt/email show the same six digits;
13. historic Project-number snapshot plus code remains stable; and
14. provider transaction/Commerce Order fallback finds the same Order without changing the
    human code.

## 7. Explicit Non-Goals

This parked plan does not authorise:

- Prisma schema or migration changes;
- checkout, payment, webhook or public Store implementation;
- Store Order allocation during `1R-F-A`;
- a second generic Order, payment or idempotency model in FUND;
- code-only public Order access;
- product-option/modifier policy;
- production matching UI beyond the bounded lookup contract;
- email, secure-link or retention policy; or
- staging/main deployment.

## 8. Dependencies And Selection Gate

Before implementation planning is accepted:

1. complete and accept `1R-F-A` proof evidence;
2. plan/accept `1R-G` public Store and purchaser option requirements;
3. reconcile the consumer Order-completion parent around current Commerce A2–A7 models and
   verified payment authority;
4. decide the exact successful-sale transition for code allocation;
5. decide receipt/email wording and production lookup permissions; and
6. reconfirm that Project-scoped allocation matches the real AMOW Event operating model.

This slice remains parked until the root and authoritative FUND roadmaps explicitly select
it. Its existence does not alter the current `1R-F-A` plan-review/conditional-proof pair.

## 9. Future Implementation Lifecycle

When selected, use the normal bounded lifecycle:

```text
accepted 1R-H consumer-Order parent
-> refreshed 1R-H-A executable implementation plan and schema diff
-> explicit implementation authority
-> implementation confirmation
-> independent automated/security/database review
-> human receipt/search/physical-correlation smoke
-> separately authorised promotion
-> roadmap reconciliation and closure
```
