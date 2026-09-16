# FUND B1-R3 — Platform VAT Default And Product Rate Authority Implementation

Date: 2026-09-16

Status: **Implemented and locally committed; automated/connected proof PASS. Separate review, human acceptance and promotion pending.**
Control depth: **High**.

Exact commit: `5ffb6cc8ec4594891a5e80356021bca3d75a7a28` on local `work/fund-b1-r3-platform-vat`, based on `e7e8837c`; not pushed or promoted.
Files/change boundary: P1 settings/default lookup, FUND Product/Store/offer/checkout rate authority, Pulse quote defaults, additive evidence migration and bounded tests.
Automated checks: 583 unit/regression tests PASS, 12 skipped; production build/type/critical-file verification PASS. Changed application-source lint: 21 files, zero errors, 44 warnings. Full repository lint fails on unrelated existing pages; no clean full-lint claim.
Human evidence: not run for B1-R3; previous image PASS is retained only for its original scope.
Environment proven: local source/build plus isolated 156-to-157 migration, legacy preservation and restricted-role scalar read PASS; fresh 157-migration replay and local DevData migration/readback PASS; candidate B1/B1-R3/A7 service proof and cleanup PASS.
Known residual risk: old application binaries cannot safely read newly written RATE_SPECIFIED values; use a compatible rollback/forward correction. Separate review and environment/human gates remain pending.
Next authorised action: separate technical review and revised human smoke; controlled promotion follows the recorded gates. No main/live promotion.

[Amended plan](../03-slice-planning/2026-09-16-fund-b1-r3-product-vat-rate-authority-planning.md)
· [Review and human smoke](../05-review-and-test/2026-09-16-fund-b1-r3-product-vat-rate-authority-review-and-test.md)

## What Changed

P1 has **Default VAT rate (%)** under **Platform Settings → Currency and Numbers**. It uses
existing app-owner Organisation settings JSON, preserves other keys, and writes through the
P1-only audited settings transaction. Missing configuration starts at 20%; zero is valid.
Invalid explicit configuration and database failures are reported, never silently defaulted.

A narrow SECURITY DEFINER SQL function returns only this scalar through Organisation RLS.
It has no arguments, a fixed search path and no writes or broader table policy. Authenticated
module consumers receive only the numeric default. No secrets or other platform settings are
exposed. The restricted-role database proof verifies this separation.

FUND Product and Pulse quote creation use the shared source in their forms and omitted-input
server paths. Quick Add quotes omit a fixed rate so the server resolves it. Pulse displays the
shared default read-only. Existing module VAT settings are retained as historical data and
cannot override the platform default. No new tenant-level override or Seller-provisioning flow.

Decimal text such as 0.00 is normalised without treating blank input as zero. Out-of-range
entries are validated rather than silently clamped to another percentage. A creation form
initialises the VAT field once; a late response/background refresh cannot
replace a human-entered rate. Existing Product/quote edits retain their saved percentage;
Product duplication copies the source rate. Changing P1's default never reprices saved records.

FUND no longer asks for a tax-treatment category. Valid saved percentages drive new Store
configuration snapshots, Individual offer prices and checkout adapter evidence. Existing
Seller identity, currency, publication and payment gates remain. New configurations use
RATE_SPECIFIED internally, including Products whose legacy hidden category was REDUCED or
UNCLASSIFIED. Effective representation/hashing is stable on repeated refresh.

Commerce continues receiving explicit applied basis points and reconciled monetary totals;
it does not read the current default during payment. Legacy category-based configurations
retain their old interpretation or refuse explicitly if evidence no longer agrees. Existing
finalised offer reads/downloads continue to use their pinned immutable snapshots.

Product edits now share the availability transaction lock used by Store refresh/finalisation,
with revision and audit updates in the same transaction. Old and new pricing cannot be mixed
inside a committed snapshot; a conflicting transaction may require a retry.

## Migration And Recovery

`20260916120000_fund_b1_r3_explicit_vat_rate` adds RATE_SPECIFIED to the existing FUND and
Commerce enums and the scalar default-read function. It performs no data reset, historical
backfill or settings write. Existing database 20 defaults remain compatibility fallbacks;
application creation writers explicitly persist the resolved platform or user-supplied value.

Before any new enum writes, an old binary may be restored only after compatibility review.
After new values exist, keep the additive schema and use a compatible binary/forward fix.
Never delete immutable evidence or remove enum values to force a downgrade. On migration
failure inspect the ledger and stop; no db:push, seed or reset.

## Evidence And Limits

The existing baseline candidate is extracted from Git and exercised in a newly created test
database, retaining genuine finalised offers and configurations across the upgrade. Hashes
of those complete rows match before/after migration. A separate restricted role sees no
Organisation rows and receives only the platform VAT scalar. No application database is used
for destructive/rehearsal proof. The runners removed their temporary roles/databases. Independent readback returned **zero
task databases and zero VAT proof roles**.

Test files: `platform-vat.test.ts`, `product-vat.test.ts`, Pulse `vat-default.test.ts`,
`scripts/fund-b1-r3-vat-proof.ts`, amended B1/A7 service proofs and
`scripts/run-fund-b1-r3-disposable-tests.mjs`.

The first sandboxed renderer run could not launch Chromium; the permitted full rerun passed.
The repository verifier required direct `node --import tsx` because the sandbox blocks the
TSX CLI IPC socket; the same verification/type checks passed. Full lint's existing errors are
not waived or represented as new-slice PASS. Remote exact-commit security scan, separate
review, staging deployment and human smoke have not yet been obtained.

## Local Development Readiness

Verified DevData identity `257f63f2e2c2` matches the prior B1-R2 record and both local
configuration files, and differs from the disposable-test, staging and production identities.
The initial conservative preflight stopped on the two matching local files and then on a
historical rolled-back attempt. Read-only reconciliation proved the documented local target,
156 applied migrations, one already rolled-back attempt and **zero unresolved failures**.
No database write occurred during either refused preflight.

The guarded deployment applied only the new migration: **156 → 157**. All existing active
migration checksums matched source; the old rolled-back ledger entry remains intact. Before/
after complete-row fingerprints match for Products, Store configuration versions, finalised
offers/offer rows, Commerce Orders/lines, Pulse quotes and Organisation settings. Both enums
contain RATE_SPECIFIED and the scalar default returns 20. No test-data reset, VAT backfill or
platform setting edit occurred. Staging and main/live databases remain unchanged.

Restart any existing local Next.js process before human testing so it reloads the regenerated
Prisma client. The local runtime has not been restarted on the user's behalf.

## Connected Retest Notes

The first candidate run stopped at a correctly refused C2 update because the new wrapper
threw synchronously; the original asynchronous service contract was restored. The next run
passed the shared defaults, saved overrides and four Store/offer price cases, then its
concurrency assertion expected P2034 but received the existing safe P2028 timeout. The test
now accepts either documented refusal, still verifies coherent snapshots and requires a
successful fresh retry. Both failed-run databases were removed and their absence verified.
The legacy-upgrade, historical preservation and restricted-role proofs had already passed;
candidate-only reruns each replay the complete 157-migration fresh schema.

## Final Connected Evidence

- Fresh replay of all **157** migration names/checksums: PASS.
- **156 → 157** upgrade with previous-candidate finalised offer/price/configuration complete-row
  fingerprints unchanged: PASS.
- Separate previous-candidate STANDARD Order fixture: complete Order, Order-line and payment
  fingerprints unchanged across the same upgrade: PASS.
- Restricted database role cannot read Organisation rows but can read the sole VAT scalar: PASS.
- Platform default 21/zero, omitted Product creation, explicit override, edit and duplicate
  preservation, C2/foreign refusal, missing Seller-category rates: PASS.
- £10 net at 20/5/0/7.5% produces £12/£10.50/£10/£10.75 in refreshed Store/offer evidence;
  unchanged refresh is stable; concurrent edit either commits coherently or refuses safely: PASS.
- Later Product VAT edit and Store refresh preserve the finalised offer and downloaded PDF
  bytes: PASS. Full existing B1 Catalogue/availability, organiser, concurrency, immutability,
  development-trading refusal and document failure/recovery regression: PASS.
- A7 synthetic Commerce submission records RATE_SPECIFIED/750 basis points, £10 net/£0.75
  tax/£10.75 gross despite Seller rates of 20%/5%; atomicity, replay and cleanup: PASS.
- Four task databases removed; independent system-catalogue readback reports zero databases
  and zero VAT proof roles remaining. No real payment/provider request was made.

These are agent-operated technical checks, not an independent review or Chris's human PASS.
Online dev/staging remain `e7e8837c`; main/live remains security-only `0397bba9`.
