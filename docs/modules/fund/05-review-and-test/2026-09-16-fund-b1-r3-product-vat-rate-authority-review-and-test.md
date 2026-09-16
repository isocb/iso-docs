# FUND B1-R3 — Product VAT Rate Authority Review And Test

Date: 2026-09-16

Status: **Planned smoke schedule; NOT RUN. Not ready to execute against current staging.**
Candidate/deployment: pending implementation; `e7e8837c` still has the reported VAT defect.
Control depth: High. [Plan](../03-slice-planning/2026-09-16-fund-b1-r3-product-vat-rate-authority-planning.md).
No implementation confirmation, migration PASS or human acceptance is implied by this file.

## Before Chris Starts

The agent must first record the implemented commit, required migration/readback, local
automated and connected checks, exact staging deployment and health. Preserve Chris's test
bed. Identify the existing unfinalised Individual Project and selected Product with the
assigned tenant-logo placeholder, compatible Catalogue, template and other required setup.
The prior DRAFT synthetic Seller is for development only; do not edit its category rates
to make the VAT test pass. No real payment or Store publication is required for this smoke.

New Product creation below proves defaults/persistence. Store-update tests use the existing
image-equipped Product so a new upload/gallery feature is not silently made a prerequisite.
Record role, tenant, candidate and each actual result. Stop on failure; do not guess PASS.

## A. C1 Product Creation And Editing

1. Open **FUND → Products → Add Product**. VAT is prefilled **20%**. There is no separate tax
   treatment/category question. Enter a clearly labelled test Product and **£10 net**; Save.
2. Reopen it. Confirm VAT remains 20%. Change to **7.5%**, Save and reopen: 7.5% remains.
   Change to **0%**, Save and reopen: 0% remains, not 20%. These are synthetic test inputs.
3. Start another new Product: its default is still 20%, not the last Product's edited value.
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
| Source/financial-contract review | Pending |
| Rate/default/validation and tenant/role tests | Not run |
| Store/offer/checkout consistency and frozen-evidence tests | Not run |
| Migration, historical preservation and rollback boundary | Not run |
| Build/type/lint/repository and exact-commit security checks | Not run |
| Staging deployment, schema and health | Not run |
| Human Product creation and Store update, A/B | Pending implementation |
| Human resumed B1 finalisation/download, C | Pending implementation |

No 04 confirmation is created until there is an actual implementation to confirm. Existing
B1/B1-R2 passes remain historical evidence for their scope, not proof of this correction.
