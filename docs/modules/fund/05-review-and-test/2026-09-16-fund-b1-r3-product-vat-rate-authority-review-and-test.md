# FUND B1-R3 — Platform VAT Default And Product Rate Authority Review And Test

Date: 2026-09-16

Status: **Local implementation and automated/connected proof PASS; human smoke NOT RUN. Not deployed to staging.**
Candidate: `5ffb6cc8ec4594891a5e80356021bca3d75a7a28` on local `work/fund-b1-r3-platform-vat`. DevData is migrated to 157. Online dev/staging remain `e7e8837c`, which still has the reported VAT defect.
Control depth: High. [Plan](../03-slice-planning/2026-09-16-fund-b1-r3-product-vat-rate-authority-planning.md).
Actual evidence is recorded in the [04 confirmation](../04-implementation-confirmations/2026-09-16-fund-b1-r3-platform-vat-default-and-product-rate-authority-implementation-confirmation.md); separate review and human acceptance remain pending.

## Local Test Preparation

For local smoke, stop the existing Next.js process with **Ctrl+C**, then run `npm run dev`
from the application repository and reload the browser. This reloads the regenerated Prisma
client. Use the migrated DevData test bed; no fixtures were cleared or changed by migration.
For staging smoke, wait for the exact candidate/migration/deployment entry; this commit is
not on staging yet.

## Before Chris Starts

For staging, the agent must first add exact deployment and health evidence to the already
recorded candidate, migration and local checks. Preserve Chris's test bed. Identify the existing unfinalised Individual Project and selected Product with the
assigned tenant-logo placeholder, compatible Catalogue, template and other required setup.
The prior DRAFT synthetic Seller is for development only; do not edit its category rates
to make the VAT test pass. No real payment or Store publication is required for this smoke. Local DevData is migrated to
157 with protected-row fingerprints unchanged; restart the local Next.js process to load the
regenerated Prisma client before local smoke. Staging remains at the prior candidate.

New Product creation below proves defaults/persistence. Store-update tests use the existing
image-equipped Product so a new upload/gallery feature is not silently made a prerequisite.
Record role, tenant, candidate and each actual result. Stop on failure; do not guess PASS.

## A0. P1 Platform Default → FUND And Pulse

Use the agreed test environment only. Record the starting platform default before changing it;
this default affects creation across the platform, not only the FUND test tenant.

1. As P1 open **Platform → Settings → IsoStack Core → Currency and Numbers**.
   Confirm **Default VAT rate (%)** is visible, initially 20 when never configured. Set **21**,
   Save and reload: 21 persists; existing currency, symbol and locale remain unchanged.
2. As C1 open a new FUND Product: VAT is **21%**. Save a labelled test Product with £10 net.
   Reopen: 21 remains. A new Pulse quote also starts at 21%; its rate remains editable.
   Pulse Settings displays the same platform default read-only.
3. Change the platform default to **0**, Save/reload. New FUND Products and Pulse quotes start
   at **0%**, while the saved 21% Product/quote and existing Store/offer totals remain unchanged.
   Duplicate the saved Product: its copy retains 21%. Editing an existing record preserves its
   rate instead of reapplying the platform default.
4. While a new-record form is open, enter a custom rate. A background refresh must not overwrite
   that entry. Blank, negative, over-100 or excessive-precision values are refused.
5. C1/C2 can receive the numeric creation default, but cannot change the platform setting or
   retrieve the full P1 settings object. Automated role tests provide this negative proof.
6. Restore the original platform default and verify it. For the following fixed-price synthetic
   tests use 20 explicitly where stated; if the original platform default differs, expect that
   value for a fresh form and enter 20 only in the test Product.

## A. C1 Product Creation And Editing

1. Open **FUND → Products → Add Product**. VAT is prefilled with the **current P1 default** (20% when unchanged). For this fixture enter 20%. There is no separate tax
   treatment/category question. Enter a clearly labelled test Product and **£10 net**; Save.
2. Reopen it. Confirm VAT remains 20%. Change to **7.5%**, Save and reopen: 7.5% remains.
   Change to **0%**, Save and reopen: 0% remains, not 20%. These are synthetic test inputs.
3. Start another new Product: its default matches P1, not the last Product's edited value.
   Cancel if no second fixture is needed. Confirm an invalid negative/over-100 rate is refused
   with a clear message and no saved invalid value. Automated checks cover precision/blank cases.

## B. C1 Product Change → C2 Draft Store Update

4. Use the existing selected, image-equipped Product on the unfinalised test Project. Record
   its starting price/rate. Set **£10 net and 20% VAT**, Save. Do not change Seller rates or
   any hidden category. The known legacy REDUCED/20% setup must no longer block this path.
5. As C2, open **Project → Store → Refresh Store configuration and offer**. Confirm the
   selected Product shows **£12 including VAT** and no category/Seller-rate mismatch reason.
   A second refresh must preserve selection, amounts and readiness.
6. As C1 change only VAT to **5%**, Save; as C2 refresh. Expect **£10.50**. Repeat with **0%**
   (expect **£10**) and **7.5%** (expect **£10.75**). No category choice or Seller-rate edit.
7. Confirm C2 cannot change the Product's VAT. If there is another real missing prerequisite,
   record its exact message and responsible role; do not bypass it to complete this schedule.
8. Restore the intended test price/rate, Save and refresh. Verify the expected gross amount
   before finalisation. Do this before the next section because B1 locks confirmed content.

## C. Resume The Blocked B1 Offer Test

9. As the exact organiser, review the now-available offer summary, acknowledge and finalise.
   Generate/download the labelled development PDF. Its Product prices must match the reviewed
   summary. Reload and re-download; confirm selection/content remains locked and no purchase
   or Store-publication authority was enabled by this step.
10. For a separate already-finalised test offer, verify a later C1 source-rate edit plus allowed
    refresh does not rewrite its confirmed price or PDF. The agent should prove this first with
    disposable fixtures; avoid changing a shared human fixture without identifying its scope.

This tests the existing text/price development PDF. It does not claim a visual template
preview or production print layout; Chris's separate concern remains unresolved.

## Evidence To Complete After Implementation

| Check | Current result |
| --- | --- |
| Implementation source/financial-contract review | Completed by implementing agent; **separate independent review pending** |
| Shared P1 default, FUND/Pulse creation, validation and tenant/role tests | PASS: full suite 583 passed/12 skipped; connected B1-R3 and Pulse unit adoption checks |
| Store/offer/checkout consistency and frozen-evidence tests | PASS: B1-R3/B1/A7, including frozen PDF bytes and custom-rate Commerce evidence |
| Migration and historical preservation | 156-to-157 upgrade, fresh 157 replay, legacy offer/configuration and Order/line/payment hashes and restricted-role scalar proof PASS; local DevData migration/readback PASS |
| Rollback boundary | Reviewed: retain additive schema and use compatible binary/forward fix once RATE_SPECIFIED is written |
| Build/type/repository checks | PASS: final production build, 131 pages, type and critical-file checks |
| Changed application-source lint | PASS: 21 files, zero errors; 44 warnings |
| Whole-repository lint | FAIL: unrelated existing-page errors; no waiver inferred |
| Exact-commit remote security scan | Not run; local work branch only |
| Disposable cleanup | PASS: zero task databases and VAT proof roles in independent readback |
| Staging deployment, schema and health | Not run for this candidate |
| Human Product creation and Store update, A/B | Pending human run |
| Human resumed B1 finalisation/download, C | Pending human run |

Existing B1/B1-R2 passes remain historical evidence for their scope, not proof of this correction.
