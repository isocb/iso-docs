# Commerce Core Slice Planning

Each bounded executable Commerce slice begins here and must later receive a matching
implementation confirmation and review/test record.

Completed through review/test:

```text
COMMERCE-A1 - Schema namespace, Seller Profile and stable enums
COMMERCE-A2 - Checkout, Order and Order-line schema foundation
COMMERCE-A3 - Payment, Refund and Pro-forma schema foundation
COMMERCE-A4 - Audit and Idempotency foundation
```

FUND `1R-C6` is implemented/reviewed at local application commit `9947669` against the
completed Commerce A2 foundation. FUND Store `1R-D` is implemented/reviewed at local
application commit `db85fcc` without adding Commerce behavior or another migration.

Commerce A3 is implemented/reviewed at local application commit `4a90be1`; its complete
138-migration disposable lifecycle passed with zero residue and no shared deployment.

Commerce A4 is implemented/reviewed at local application commit `5b69920`; its complete
139-migration disposable lifecycle passed with zero residue and no shared deployment.

Commerce A5 is implemented/reviewed at application commit `fd7376b`.
Its provider-neutral validators and idempotency/audit transaction helpers passed unit,
static and disposable PostgreSQL smoke tests with zero residue and no migration.

COMMERCE-A6 Stripe Connect Tenant Payments parent planning is created at:

`2026-07-14-isostack-commerce-core-slice-commerce-a6-stripe-connect-tenant-payments-planning.md`

It is awaiting explicit review/acceptance. No A6 schema, Stripe call, route, webhook or UI
work is authorised. The single next action is parent-plan review; accepted delivery then
proceeds serially through A6-A account/event schema, A6-B tenant settings/onboarding, A6-C
Checkout adapter and A6-D webhook/refund reconciliation.
