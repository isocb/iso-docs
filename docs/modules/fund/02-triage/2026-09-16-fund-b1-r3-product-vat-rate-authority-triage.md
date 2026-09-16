# FUND B1-R3 — Product VAT Rate Authority Triage

Date: 2026-09-16

Disposition: **Accept for bounded B1-R3 planning; required before B1 acceptance.**
Control depth: **High** — financial calculations, immutable evidence, schema compatibility
and a narrow shared Commerce contract are involved. No implementation or deployment here.

Source: [CR-Fix](../01-cr-inputs/CR-Fix-2026-09-16-fund-product-vat-rate-authority.md).

## Decision And Proportionate Boundary

Use a new B1-R3 remedial child rather than rewriting B1-R2's Catalogue/workflow/lifecycle
scope. Preserve its earlier PASS results and Chris's newly confirmed image result. The
VAT defect blocks the current Product-to-offer journey and must not be postponed as Phase 2
polish. B1 remains the one portfolio Now; 1R-G planning remains Next.

Accept the owner's rate-only rule without reopening tax-category choices: create defaults
to 20%; C1 edits the Product percentage; draft Store refresh, offer preview and prospective
checkout use the saved rate consistently. Seller commercial identity, currency and payment
readiness remain separate; Seller category rates cease to control FUND VAT calculations.

The default already exists in the Product UI, API and database. Reuse those foundations.
The substantive correction is authority propagation and removal of conflicting gates, not
a new settings system. No mass Product reset/backfill or arbitrary category inference.

## Technical Assessment

- Product creation/update validates percentage and category independently today.
- Store refresh snapshots both and rejects UNCLASSIFIED, but does not check Seller-rate
  consistency, producing a READY Product followed by a blocked offer.
- Individual preview and FUND checkout each resolve Seller/category rates; both must change.
- Commerce already accepts explicit `appliedTaxRateBps` and monetary evidence from the FUND
  adapter, but requires a categorical enum on Order lines. Existing enum choices cannot
  truthfully describe an arbitrary user-specified rate without additional assumptions.
- Proposed minimal compatibility change: add a neutral `RATE_SPECIFIED` enum value to the
  existing FUND and Commerce tax-treatment enums. Use it internally for new rate-only
  configuration/evidence; no new C1 choice. Preserve all historical category values.
- This narrow additive migration is preferable to labelling every rate STANDARD or
  guessing ZERO_RATED versus EXEMPT. Verify all enum consumers before implementation;
  broaden the plan only if evidence requires it, not merely to redesign Commerce.

The [Commerce roadmap](../../../core/commerce/00-roadmap-control/2026-07-13-commerce-core-roadmap-and-slice-control.md)
registers this dependency. FUND owns the user journey and adapter; Commerce retains ownership
of its generic evidence contract. One integrated candidate and one B1-R3 lifecycle suffice.

## Delivery And Stopping Point

The [bounded plan](../03-slice-planning/2026-09-16-fund-b1-r3-product-vat-rate-authority-planning.md)
contains three ordered work packages: rate model/evidence compatibility; Product/Store/offer/
checkout integration; automated and human proof. Do not ship a UI-only removal first.

Business direction is accepted. Implementation technical review must confirm the additive
enum approach, historical-version handling and safe rollback. Until implementation is
authorised, only planning and the future smoke schedule are prepared. No 04 confirmation
or new PASS is created in anticipation. Main/live remains held.
