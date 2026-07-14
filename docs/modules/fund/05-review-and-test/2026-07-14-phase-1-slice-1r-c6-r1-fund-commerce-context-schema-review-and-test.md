# FUND Phase 1 Slice 1R-C6-R1 - FUND Commerce Context Schema Review And Test

Date: 2026-07-14

Status: Passed / disposable PostgreSQL migration, constraint and regression lifecycle complete

Implementation confirmation:

`docs/modules/fund/04-implementation-confirmations/2026-07-14-phase-1-slice-1r-c6-fund-commerce-context-schema-implementation-confirmation.md`

## 1. Review Scope

Reviewed application commit `9947669` against accepted 1R-B/1R-C architecture, Commerce
A2, FUND C1-C5/R3-D and the current Prisma multi-schema contract.

The review covered exact tenant/Order/line/Store/Project/Product/configuration identity,
typed delivery and provisional commission evidence, status vocabulary, multi-select and
signed input snapshots, immutable multi-file asset versions, artwork-backup semantics,
zero backfill, refusal, deletion, rollback and database safety.

## 2. Accepted Review Decisions

- The generic Commerce Order-line composite support key is included atomically in C6. It
  adds no Commerce field or behavior and is required by the physical exact foreign key.
- Reverse Prisma fields are navigation/client-generation support only; Commerce remains the
  sole generic Order/line owner.
- The exact Store Product support tuple prevents mismatched Store, Project, Project Product
  or Product context.
- Delivery values are immutable submission snapshots; operational delivery authority is
  deferred.
- Commission assignment at submission is optional observation, never final rate/amount or
  a per-Order lock. C5 replacement/finalization remains authoritative.
- Signed input modifiers are preserved. Negative values cannot be placed in A2's
  non-negative unit-modifier field and must later map to discount evidence.
- Multiple asset versions are separate rows. Backup presence does not prove payment,
  physical-artwork receipt or production-source authorization.
- All evidence/source deletions are restrictive and the migration performs zero backfill.

## 3. Static And Repository Checks

Passed:

```text
npx prisma format
npx prisma validate
npx prisma generate
npx tsx scripts/verify-fund-1r-c6-schema.ts
npx tsx scripts/verify-commerce-a1-schema.ts
npx tsx scripts/verify-commerce-a2-schema.ts
npx tsx scripts/verify-fund-1r-c1-schema.ts
npx tsx scripts/verify-fund-1r-c2-schema.ts
npx tsx scripts/verify-fund-1r-c3-schema.ts
npx tsx scripts/verify-fund-1r-c4-schema.ts
npx tsx scripts/verify-fund-1r-c5-schema.ts
npx tsx scripts/verify-fund-1p-g-r3-a-schema.ts
npx tsx scripts/verify-fund-1p-g-r3-d-contract.ts
npx eslint --no-ignore scripts/verify-fund-1r-c6-schema.ts scripts/run-fund-1r-c6-database-tests.ts
npm run type-check
npm run verify
git diff --check
```

## 4. Database Target Safety

The runner compared protocol, user, host, port and database identity and refused execution
unless `TEST_DATABASE_URL` differed from `DATABASE_URL`. It reported only a one-way hash of
the direct test host plus the database name.

Only the retained disposable Neon test database was used. No shared development, staging
or production database was contacted or modified.

## 5. Representative Migration And Refusal

Starting state was the complete 136-migration Commerce A2 baseline with representative
R3-D Client/Project/delivery, C1-C5 Store/Product/input/asset/commission sources and one
generic non-FUND Commerce Order/line.

Passed:

- a deliberately pre-existing FUND-source Commerce Order caused the expected migration
  exception before any C6 object was committed;
- the failed attempt was marked rolled back only after removing its refusal fixture;
- the same migration then applied cleanly from 136 to 137;
- every representative value remained exact;
- generic non-FUND Commerce evidence remained unchanged;
- all four C6 tables began empty.

## 6. Constraint And Deletion Evidence

Passed on representative and fresh paths:

- valid Event-scoped context with provisional assignment observation;
- valid standalone context without Event or commission observation;
- exact default production/fulfilment state;
- exact parent context, Commerce line/Order and Store Product/configuration identity;
- duplicate context/line rejection;
- cross-tenant, wrong Project/delivery/commission, wrong Store Product and wrong
  configuration rejection;
- nonblank project/workflow/configuration and delivery country checks;
- provided multi-select with signed `-50` modifier evidence;
- omitted optional, provided file and explicitly incomplete required input shapes;
- non-array choice, invalid revision and inconsistent presence/validation rejection;
- two immutable purchaser backup asset versions on one Order line;
- wrong asset/version, duplicate asset-version/role and backup role/purpose rejection;
- restrictive deletion of Commerce Order/line, Project, Store, Store Product,
  configuration version, input definition, asset/version and Organization evidence.

## 7. Fresh Replay, Drift And Regression

The disposable database was reset and all 137 migrations replayed from empty. The same
source fixtures and complete C6 constraint/deletion suite then passed.

Commerce A1/A2, FUND C1-C5, R3-A and R3-D static regressions passed after the two historical
verifiers were made lifecycle-aware. C6-owned database-to-Prisma drift inspection passed;
unrelated pre-existing repository drift remains outside this slice.

Final inventory:

```text
applied migrations: 137
failed migrations: 0
residual C6 rows: 0
residual C6 fixture rows: 0
```

## 8. Test-harness Refinements

Four safe disposable-only refinements preceded the final pass:

- asset fixtures now create a version before selecting `NOT_REQUIRED` review state;
- clean malware-scan fixtures now include scanner and scanned-at evidence;
- the wrong-asset test avoids colliding with uniqueness before reaching the intended FK;
- cleanup clears existing C4 current/review pointers before deleting asset versions.

These were fixture/isolation corrections exposing existing C4 rules, not migration
defects. The final representative and fresh suites both passed with zero residue.

## 9. Scope Verdict

The implementation contains no checkout/Order service, mutable basket, Store readiness or
publication, payment/refund/pro-forma/provider/Stripe, upload/scanning, production
authorization/projection, commission calculation, API, route or UI behavior.

`1R-C6-R1` passes. Application commit `9947669` is local on `dev` and no shared deployment
is claimed. Store `1R-D - Store Readiness And C1 Store Configuration API/Services` is the
single next planning candidate, but is not started or authorised by this review.
