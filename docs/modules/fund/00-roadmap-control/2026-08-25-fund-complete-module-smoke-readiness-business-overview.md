# FUND Complete-Module Smoke Readiness — Business Overview

Date: 2026-08-25

Planning status: **Subordinate business-analysis overview; planning and coordination only**

Source request: provide a one-page, non-technical view of FUND work completed and still
required before the module can be smoke-tested as one connected operating journey.

Authoritative controls and evidence:

- [root portfolio control](../../../00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md);
- [FUND roadmap and slice control](2026-06-25-fund-roadmap-and-slice-control.md);
- [Store, artwork, Orders and production strategic completion overview](2026-07-15-fund-store-artwork-orders-and-production-strategic-completion-roadmap.md);
- [refinement and pilot-placement register](2026-07-20-fund-refinement-wishlist-and-slice-control.md); and
- [existing C1/C2 Store staging smoke schedule](../05-review-and-test/2026-07-23-fund-phase-1-slice-1r-e-b-through-1r-e-d-consolidated-staging-human-smoke-test-schedule.md).

## Authority And Headline

This overview coordinates capabilities only. It is subordinate to the root, FUND and
Commerce controls; it does not select the next slice, change roadmap status or claim
implementation/testing. Its headings are business work areas, not executable slice IDs.

FUND is **well beyond a prototype**, but is **not yet ready for a credible complete-module
smoke test**. Administration, Project setup, Intake, Product eligibility, Store control and
the shared Commerce spine largely exist. The public buying journey and post-payment chain—
artwork, production, dispatch and commission—remain incomplete.

FUND is currently paused while LMSPro remediation is portfolio `Now`. The preserved next
FUND outcome is the isolated deployed-renderer/private-object proof. No FUND work is started
or authorised by this overview.

## Business Capability Position

| Work area | What is already established | What remains before complete-module smoke |
| --- | --- | --- |
| **Administration and onboarding** | C1 Client/user/Product/Catalogue/Event/Project administration, public Intake, automated provisioning, organiser identity, delivery profiles and the C2 dashboard have implemented foundations. | Fix or contain the FUND entitlement-display gap and settle pilot data, roles, hosted/embedded Intake and indispensable organiser messages. |
| **Project Store control** | Projects receive one draft Store and eligible Products. C2 normal control, C1 oversight and exceptional intervention are implemented. | Complete the existing connected C1/C2 staging smoke for creation, selection, readiness, activation, dates, intervention, permissions and responsive use. |
| **Commerce and payment** | Connected-account onboarding, Checkout, verified payment/refund handling and typed FUND Order context exist, but the integration is dormant. | Connect the future public Store and prove safe test-payment success, failure, retry, duplicate and refund outcomes from verified provider events. |
| **Offer and artwork readiness** | Store Product/media/input/asset foundations exist. The AMOW Individual Artwork template passed local automation, physical/PDF review and Linux parity. | Finish the deployed renderer/private-storage proof, then complete the Individual, collective Group/Bulk and Standard Product readiness branches included in the agreed smoke scope. |
| **Public Store** | Readiness/release rules exist; only ready Project Store Products may trade. | Build branding, released Product display, prices, media/options/inputs, unavailable/paused/closed states, selection, mobile/accessibility and Checkout handoff. |
| **Purchaser and Order operations** | Generic Order/payment/refund/audit evidence can retain exact FUND context. | Add purchaser evidence, Order Code, receipt/messages and payment-status experiences; add C1 search/reconciliation/exceptions and correctly limited C2 sales visibility. |
| **Artwork, production and fulfilment** | Asset-version and delivery-profile foundations plus authority/traceability rules exist. | Add secure upload/scanning, private versions, artwork/Order matching, explicit C1 production authority, batches, exceptions and partial/grouped dispatch. |
| **Commission and release readiness** | Commission policy/acceptance foundations, tenant controls, audit patterns and substantial automated evidence exist. | Add aggregate calculation, adjustment/finalisation, statements and settlement evidence; then complete security/role, accessibility, monitoring, recovery, support and staging UAT gates. |

## Recommended Route To Complete-Module Smoke Readiness

The dependency-led planning route is:

1. **Close existing gates:** deployed renderer/private storage and the written C1/C2 Store
   staging smoke; correct only evidenced failures.
2. **Set test scope:** pilot tenant/users, supported Project paths, Products/options/media,
   Intake, payment, fulfilment and essential communications.
3. **Finish the public transaction:** applicable offer/artwork readiness, public Store,
   Checkout, verified payment/refund, Order Code and receipt.
4. **Finish operations:** Order views, secure artwork intake/matching, C1 production
   authorisation, batching, dispatch and commission statement.
5. **Harden and smoke:** complete security/role, accessibility, monitoring/recovery and
   support gates, then run the connected journey and its critical negative paths on staging.

Rich merchandising, general campaign editing, dashboard reorganisation, configurable
terminology and broad duplication tools are not automatically required for the first
complete-module smoke. They become prerequisites only where the agreed pilot cannot be set
up or operated safely without them.

## Definition Of “Ready For Complete-Module Smoke”

A staging tester must be able to follow one documented, realistic chain:

```text
C1 prepares Client/Event/Products/Catalogue
-> Intake or C1/C2 creates a Project, organiser, delivery profile and draft Store
-> C2 selects Products and completes the applicable artwork/readiness work
-> C2 activates the Project/Store within the permitted dates
-> public purchaser sees only the released offer and completes test payment
-> verified payment creates durable Order and Order Code evidence
-> C1 resolves artwork/data, authorises production, batches and dispatches
-> C2 sees permitted progress/sales evidence
-> commission is calculated and statemented from reconciled sales evidence
```

It must also prove tenant/Client isolation, refusal of unready Products, safe failed/
duplicate payment and the separation of payment from production authority.

## Settled Business Boundaries

- **C1** operates commercial readiness, supplier release, production and exceptional
  intervention; **C2** normally operates its Project, eligible Products and Store.
- **Public** users buy released offers; early purchasers need no account unless policy
  changes. **Commerce Core** owns Checkout/Order/payment truth; FUND owns its operational
  meaning.
- Individual, collective and Standard Product readiness remain distinct. Browser return
  does not prove payment, and payment does not authorise production.
- FUND reuses IsoStack communications infrastructure.

## Included, Excluded And Retroactive Implications

Included are smoke-readiness capabilities and dependencies. Excluded are implementation,
slice selection, migration/deployment authority and unproved test claims. Existing
foundations are reused, not rebuilt. Renderer/Store evidence may cause bounded corrections;
pilot choices promote parked refinements only through later authoritative planning.

## Open Business And Planning Questions

1. Is the first “complete” smoke one AMOW Individual journey, or must it represent
   Individual, collective Group/Bulk and Standard Products?
2. Which fulfilment modes, Products/options/media, Intake route and organiser messages are
   in scope?
3. Is a calculated/finalised commission statement sufficient, or must settlement also be
   exercised?
4. Which staging services must be real rather than simulated: Stripe, renderer, private
   storage, malware scanner and email?
