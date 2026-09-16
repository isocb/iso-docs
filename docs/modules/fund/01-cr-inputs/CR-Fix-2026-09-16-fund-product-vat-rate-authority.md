# CR-Fix — FUND Product VAT Rate Authority

Date: 2026-09-16

Disposition: **Triaged; B1-R3 bounded planning prepared. Not implemented.**
Owner: FUND, with a bounded Commerce Order-evidence dependency.

## Finding And Evidence

During B1-R2 staging smoke at application `e7e8837c`, Chris confirmed the Product-image
correction but reported that refreshing the Store still leaves finalisation blocked by
“Resolve GBP price and Seller tax evidence”. Read-only inspection on 16 September found
the selected test Product at GBP 5 net, VAT 20%, legacy treatment REDUCED and revision 5.
Its current Store configuration contains the same values and reports READY, while the
Seller's configured reduced rate is 5%. No finalised offer exists for that smoke Project.

The editor permits independent percentage/category entry. Offer and checkout calculations
instead resolve the rate from Seller/category and reject disagreement. The generic error
does not identify the mismatch or give C2 a useful C1-owned remedy. This is a current
development design/validation defect; a regression from a correctly implemented rate-only
model is not established. The September 12 prepared fixture passed its earlier inputs;
that does not prove the current human scenario passes.

## Confirmed Business Decision

Chris directs the simplest rate-only model:

- A new Product defaults to **20% VAT**. This is the requested application default.
- C1 may change that percentage when adding or editing the Product.
- The saved Product percentage is the authority for new/draft Store prices and offers.
- Do not ask C1 to choose Standard, Reduced, Zero rated, Exempt or Unclassified separately.
- Do not override or veto that percentage using Seller standard/reduced rates.
- A configurable P1 default may follow later; it is not required for this correction.
- Existing finalised offers and Order evidence retain their recorded prices and tax evidence.

The user requested a formal CR, triage and planning boundary, followed by revised Product
creation and Store-update smoke. This documentation action does not itself perform code,
database work or deployment.

## Impact, Containment And Risk

Severity: blocks current B1 finalisation acceptance and makes ordinary C1 setup confusing;
no live FUND incident or affected production customers has been established. C1 and C2 are
affected in staging. Changing the two fields to match is a possible test workaround but
does not satisfy the accepted one-percentage model. No data workaround was applied here.
Containment: retain the failing finalisation gate and do not claim B1 complete.

Financial arithmetic, snapshots, tenant authority and the Commerce consumer contract make
this High-control work. Do not conceal an invented tax classification behind the new UI,
change other modules' rate semantics, rewrite historical evidence or reset test databases.
No emergency expedite or live hotfix is proposed. This is remediation within FUND B1 Now;
1R-G planning remains Next. The B1 controlling plan retains the single restart checkpoint.

## Lifecycle

[Triage](../02-triage/2026-09-16-fund-b1-r3-product-vat-rate-authority-triage.md)
→ [B1-R3 plan](../03-slice-planning/2026-09-16-fund-b1-r3-product-vat-rate-authority-planning.md)
→ implementation when authorised → 04 confirmation →
[05 review/smoke](../05-review-and-test/2026-09-16-fund-b1-r3-product-vat-rate-authority-review-and-test.md)
→ human acceptance → controlled promotion.

Source: [B1-R2 human comments](../05-review-and-test/2026-09-10-fund-b1-r2-event-catalogue-workflow-scope-and-lifecycle-integrity-review-and-test.md).
Template visual-preview findings remain separately open and must not expand this VAT slice.
