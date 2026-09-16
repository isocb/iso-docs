# FUND B1-R3 — Platform VAT Default And Product Rate Authority Planning

Date: 2026-09-16

Status: **Amended and implemented locally at `5ffb6cc8`; automated/connected proof PASS. Separate review, human acceptance and promotion pending.**
Control depth: **High**. Work type: production-model correction, first proved in development.
Baseline: application `e7e8837c`; local candidate `5ffb6cc8`, DevData migration 157; no new deployed candidate.

[CR](../01-cr-inputs/CR-Fix-2026-09-16-fund-product-vat-rate-authority.md)
→ [triage](../02-triage/2026-09-16-fund-b1-r3-product-vat-rate-authority-triage.md)
→ [FUND control](../00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md).
The [B1 plan](2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-journey-development-plan.md)
continues to hold the sole five-field checkpoint. This is not a second portfolio outcome.

## 1. Visible Outcome And Fixed Rules

P1 sets Default VAT rate (%) in Platform Settings → Currency and Numbers, initially 20%.
C1 creates a Product with VAT prefilled from that platform default, or enters another percentage, and saves.
There is no second tax-treatment input. A draft Store refreshed from that Product uses the
saved percentage for the displayed gross price and offer, without a Seller-rate mismatch.
C2 never has to repair tax configuration. Checkout uses the same rate and existing money
rounding once its separately controlled trading prerequisites are met.

| Operation | Rule |
| --- | --- |
| New Product | VAT inherits the shared platform default in UI/API; initially 20 |
| C1 edit | Preserve the saved rate, including 0; never replace it with 20 on load/save |
| Valid rate | Finite 0–100 inclusive, at most two decimal places, consistent with existing storage/helpers |
| Missing input | Omitted create value resolves the platform default server-side; blank/invalid explicit input is rejected; an omitted update preserves its prior value |
| Duplicate Product | Copy the source rate, not the create default |
| New/draft Store | Snapshot the Product rate through the normal refresh/version mechanism |
| Seller rate settings | Neither select, override nor veto FUND's Product VAT rate |
| Existing missing snapshot | Report a specific refresh/configuration error; never silently substitute 20 |
| Frozen offer/Order | Retain original configuration references, applied rate, totals and evidence |

20% is an application creation default selected by the owner, not a new statutory-rate
lookup or an assertion that every Product should use it.

## 2. Ordered Implementation Packages

### A0. Shared platform creation default — owner amendment, 16 September

Store `defaultVatRate` in the app-owner Organisation settings JSON beside currency/locale.
Only P1 can write it through the existing audited settings mutation. Expose only the numeric
default to authenticated module consumers; do not grant access to the full P1 settings object.
Use one server resolver and shared 0–100/two-decimal validation. A fixed-search-path, read-only
SECURITY DEFINER function returns only the single VAT JSON value across Organisation RLS,
without caller arguments or a broad table policy. Include it in the additive migration and
prove a restricted database role cannot read the platform row but can read this scalar. Missing setting means 20;
explicit zero is valid; invalid stored configuration fails clearly rather than guessing.
Database/network errors must not silently become 20. Preserve unrelated settings keys.

FUND Product creation and Pulse quote creation are the current application VAT-default writers.
Both forms and omitted-input server writes must use this shared source. Once a human edits
a form rate, a background default refresh must not overwrite it. Preserve saved rates on edit
and duplication. Pulse displays the platform default read-only; its legacy per-module stored
VAT setting is no longer an alternate default authority, without bulk rewriting old records.
Commerce receives explicit applied rates from module adapters: it must never substitute the
current default while processing an Order/payment. Existing Seller category settings and
other-module historical classifications remain stored, but cannot override FUND rates.
Future modules use this shared resolver when creating rate-bearing records; no general tax
engine or speculative Seller provisioning flow is added. No existing VAT-bearing LMSPro
creation path was found in the source inventory.

A platform default change affects subsequent new records only. Existing Products, quotes,
Store snapshots, finalised offers and Orders retain their saved values. SQL defaults of 20
remain compatibility fallbacks for legacy/direct fixtures; application creation paths write
the resolved rate explicitly. A future tenant override can extend the resolver, but is not
built now. Verify P1-only write, signed-out refusal, C1/C2 safe read, zero, invalid/missing
configuration, changed defaults, existing/duplicate preservation and Pulse/Commerce regression.

### A. One rate resolver and truthful persisted evidence

Reuse `percentToBasisPoints`, integer minor-unit arithmetic and existing HALF_UP calculation.
Centralise FUND's rate validation/resolution so Store readiness, Individual preview and
checkout do not implement competing tax rules. Do not derive a new rate from gross price,
browser checkout payloads or Seller categories. Preserve existing per-unit display and
per-line quantity rounding contracts; test them explicitly rather than changing them here.

Proposed schema amendment: add `RATE_SPECIFIED` to `FundProductTaxTreatment` and
`CommerceTaxTreatment` using one reviewed additive Prisma migration. The neutral value means
“use the recorded percentage”; it makes no standard/reduced/exemption classification claim.
There is no new tax-category control, table or percentage column. The platform default uses existing settings JSON.
Retain existing enums/columns and immutable rows. Do not update all Products or historical
snapshots merely to replace their old labels. Keep the existing database VAT default of 20.

New Product writes and new/rebuilt draft configuration snapshots use RATE_SPECIFIED internally.
An existing Product's valid percentage remains authoritative even if its obsolete hidden
category is REDUCED, UNCLASSIFIED or another legacy value. Draft refresh must produce a new
rate-only version without requiring a manual category edit. Use the effective rate-only
representation consistently in Project Product reconciliation and configuration hashing;
do not create a new version on every unchanged refresh because raw legacy labels differ.

Review all enum consumers, generated Prisma types, SQL checks and Commerce submission
validation before applying this design. Commerce's zero-category constraint remains intact
for historical ZERO_RATED/EXEMPT rows. New neutral rows use the explicit numeric rate and
`taxCategoryCode` reflecting RATE_SPECIFIED, not a fabricated old classification. Other
modules retain their existing category-based behaviour. This is the bounded Commerce
dependency registered in its own roadmap, not permission to change shared tax policy broadly.

### B. Integrate Product, Store, offer and FUND checkout

- `ProductModal.tsx`, Product schemas/services: remove category selection from the FUND user
  contract; resolve the platform default for creation, retain explicit validation, permissions, revisions and audit. Remove
  obsolete client instructions about classification. Do not accept a hidden client category
  as an alternate authority; define stale-client handling explicitly in technical review.
- `store-management.service.ts`: remove classification-only blocking from rate-only drafts;
  snapshot and hash the effective saved percentage. Invalid monetary evidence must yield a
  specific reason rather than READY followed by an unexplained offer rejection. Preserve
  selection, Catalogue eligibility, media requirements and immutable older versions.
- `individual-offer.service.ts`: calculate from the pinned rate snapshot, not Seller standard/
  reduced rates. Preserve applicable Seller identity/currency checks; do not require a Seller
  rate setting solely to calculate VAT. Show actionable Product-specific failures with C1
  responsibility. Refresh must invalidate both Store and Individual offer queries.
- `store-checkout.service.ts`: resolve tax from the server's authorised configuration version;
  pass exact applied rate/net/tax/gross evidence to Commerce. Keep active Seller, payment,
  publication, tenant and emulation gates. Never enable B1 purchases to prove this change.
- Review snapshots, copy/duplication, public display, receipts/Order readers and tests for
  remaining classification-only assumptions. Do not silently alter currency or price basis.

### C. Historical safety, proof and controlled delivery

New rate-only snapshots are distinguishable from legacy snapshots by RATE_SPECIFIED.
Never reinterpret or mutate a finalised offer's old version as if it used the new rule.
Resolve reads/downloads from recorded immutable evidence. Any future action relying on a
legacy frozen configuration must preserve its original pricing contract or refuse explicitly;
do not generate a newly priced Order against an older confirmed offer. Document the exact
legacy-consumer strategy in implementation review before modifying checkout.

Test rate edits racing with Store refresh/finalisation against existing locks/revision checks.
The result must be a coherent old or new snapshot, or an explicit stale retry, never mixed
rate/price evidence. Keep existing access and exact-organiser protections.

## 3. Database And Environment Boundary

Follow [Safe Database Workflow](../../../../SAFE_DATABASE_WORKFLOW.md). Review SQL, rehearse
fresh and current-ledger upgrade paths on an isolated disposable database, and verify older
offers/Orders and other-module rows are unchanged. Apply through Prisma migrate deploy only
after implementation authority and environment checks. No db:push, reset, blanket seed,
backfill of historical rates or deletion of the user's smoke bed is needed.

Run schema/client and relevant Core/FUND regression checks. Application-only rollback becomes
unsafe once RATE_SPECIFIED values have been written if the old binary cannot read them.
Prefer a forward correction. Before any such writes, assess whether rollback to the prior
binary is safe; after them, require a compatible binary or reviewed recovery. Do not remove
enum values or rewrite immutable evidence to force rollback. On migration failure stop,
inspect the ledger and preserve data; no blind rerun/reset.

Development and staging retain existing emulation and test fixtures. No Seller-rate edits
are needed to make the new percentage work. New Product-creation smoke and existing Product
Store-update smoke can be separate: the latter uses the already assigned tenant-logo image
so the deferred image-upload UI does not obstruct VAT proof. Human-visible tests remain on
staging after local proof and exact deployment verification. Main/live requires separate approval.

## 4. Required Evidence And Smoke

- Default 20, saved 0/5/7.5/custom values, edit/duplicate preservation; blank, non-finite,
  out-of-range and excessive-precision refusals; C2/foreign-tenant mutation refusal.
- A valid 20% Product with stale REDUCED or UNCLASSIFIED metadata works without category repair.
- Missing/different Seller rates cannot change a rate-only Product's totals; unrelated Seller
  and trading gates remain enforced.
- Product → Project Product → Store version → offer → test Commerce submission uses identical
  rate authority; use disposable synthetic checkout fixtures, never real payments.
- £10 net produces £12 at 20%, £10.50 at 5%, £10 at 0% and £10.75 at 7.5%; include penny/quantity
  rounding, overflow, stale refresh and idempotency cases in automated checks.
- Unchanged refresh is stable; changed rate creates a new draft version; frozen evidence and
  previously downloaded document hashes remain unchanged after later source edits.
- Migration negative/rollback boundaries, other-module regression, build/type/lint/verify,
  secret review and exact candidate/deployment checks as applicable to this High-control change.

The [B1-R3 05 schedule](../05-review-and-test/2026-09-16-fund-b1-r3-product-vat-rate-authority-review-and-test.md)
has automated results and revised human steps; human smoke is NOT RUN. The matching
[04 confirmation](../04-implementation-confirmations/2026-09-16-fund-b1-r3-platform-vat-default-and-product-rate-authority-implementation-confirmation.md) records the actual candidate, migration and proof.
Do not mark the existing B1 finalisation journey passed before its retest succeeds.

## Implementation Review Decisions — 16 September

The additive RATE_SPECIFIED model is retained after reviewing Core enum/SQL consumers.
New effective snapshots and hashes use that neutral value; stale client taxTreatment keys
are stripped by input validation and never become authority. Legacy frozen configurations
keep their category/rate contract or refuse explicitly; no missing historical rate is
substituted. Product rate changes join the existing availability lock and revision/audit
transaction, preserving the asynchronous update-service contract.

P1 writes use one audited transaction. The narrow scalar SQL function supplies defaults
through RLS without elevating the tenant request or disclosing other settings. The plan now
includes this function in the migration, in addition to enum compatibility. Current consumers
are FUND Product create, Pulse quote forms/API/Quick Add, and Pulse's read-only default display.
Commerce receives recorded explicit rates and does not acquire a moving-default dependency.

## 5. Do Not Build And Completion Boundary

No tenant VAT override, tax-category selector, tax engine, jurisdiction lookup, template preview/
editor, Product gallery, automatic Store publication, payment enablement or general price-basis
redesign. The user's separate template-preview concern remains open; this VAT correction does
not claim to deliver a visual artwork preview. No unrelated LMSPro changes or production reset.

Chris explicitly authorised this amended plan and implementation on 2026-09-16. Complete local
implementation, migration rehearsal and automated proof plus 04/05 records. Human acceptance
and controlled promotion remain separate; this instruction does not authorise main/live.
