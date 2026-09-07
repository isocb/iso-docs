# FUND 1R-G — Public Store Presentation Planning

Date: 2026-09-07

Status: **Planning draft for the reserved next outcome; exact Next selection pending owner response. No implementation authority.**

Control depth: **High** — unauthenticated Store reads introduce tenant, personal-data,
media-release and commercial-authority boundaries.

Work type: proposed production-model feature. Synthetic development fixtures may prove
presentation; they do not create public release authority or operational provider evidence.

Chris requested planning for the next approved slice while testing B1. Source/control review
found `1R-G` reserved as Public Store Presentation but root Next explicitly unselected.
This draft progresses that request without inventing prior slice acceptance. B1 remains
portfolio Now and retains the sole active restart checkpoint. No code, configuration,
database or running local-test environment is changed by this planning pass.

Authority and inputs:

- [Root portfolio](../../../00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md)
- [FUND roadmap](../00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md)
- [Accepted Store/Commerce planning handoff](../02-triage/2026-07-13-phase-1-slice-1r-b-store-and-commerce-planning-handoff.md)
- [1R-F readiness parent](2026-07-15-fund-phase-1-slice-1r-f-project-offer-artwork-readiness-reconciliation-planning.md)
- [Enduring business framework](../00-roadmap-control/2026-09-07-fund-user-framework-and-individual-artwork-delivery-principles.md)
- [B1 plan](2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-journey-development-plan.md)
- [English business report](../00-roadmap-control/2026-08-25-fund-complete-module-smoke-readiness-business-overview.md)

## 1. Proposed User Outcome

A purchaser opens a Project Store link and sees only the offer that the organiser has
released and the server currently permits: Project/Client branding, Store introduction,
Product presentation, supported buyer-choice descriptions and correctly formatted GBP
prices. On mobile or desktop, the buyer can understand what is offered and the relevant
closing date. A Store that is not available produces an understandable unavailable page.

This slice stops at read-only Store presentation. It does not collect purchaser details,
submit an Order or pretend to complete a purchase. Checkout/payment and Order confirmation
remain required Phase 1 outcomes after presentation; this is not a redefinition of Phase 1.
The eventual purchase control must be added with its actual consumer-Order slice, not as a
working-looking button that cannot complete its action.

C2 publication remains an explicit existing organiser action. Visiting a link, assigning a
template, finalising an offer or generating a PDF must never publish a Store.

## 2. Current Source Evidence

Application inspected: `57e1454b530ae19dc586768fd996ff230d84421c`, B1 work branch.

| Existing source in isostack-bedrock | Consequence for this plan |
| --- | --- |
| `prisma/schema.prisma`: `FundProjectStore.publicId` is globally unique; Store has tenant/Project lineage and publication state | Resolve public identifier server-side, then derive tenant scope; no new public identifier table is justified |
| `FundStoreProductConfigurationVersion` holds presentation, media, input-contract, price/tax and readiness snapshots | Reuse an explicitly selected version; do not assemble a sale description from unrelated current Product fields |
| `src/modules/fund/services/store-authority.service.ts`: `evaluateFundProjectStoreAuthority` returns effective state, blockers and `isTrading` | One authority source must govern availability; the public endpoint must not return the service's entire internal object |
| `src/modules/fund/services/individual-offer-readiness.ts` always adds `INDIVIDUAL_ARTWORK_DEVELOPMENT_ONLY` for Individual Projects | B1 cannot open a real public Individual Store, even with an AVAILABLE document |
| `src/modules/fund/services/store-checkout.service.ts`: `submitFundStoreOrder` already owns FUND validation and delegates generic Orders/payments to Commerce | Presentation must not build another Order aggregate or turn this service into an unauthenticated endpoint in this slice |
| `src/modules/fund/lib/individual-offer/contract.ts` pins a deliberately invalid development destination | Do not rewrite confirmed B1 snapshots or claim that their printed destination is a real Store URL |
| `src/middleware.ts` explicitly allowlists public routes; existing FUND Store pages are under authenticated `/app/fund` | Public routing needs a narrowly scoped addition and a public layout; do not expose the administrative route tree |
| `FundProductMedia` links to media files; configured versions contain media snapshots | Existing media presence does not alone prove consent/release for anonymous disclosure |

This is read-only technical planning, not a new test PASS. B1's outstanding independent
review and human smoke are still outstanding; Chris's current testing is not recorded as
acceptance before his result arrives.

## 3. Proposed Technical Boundary

### Public resolution and projection

Proposed route: `/fund/store/[publicId]`, subject to route review. A bounded server query
resolves the Store, derives organization/Project context, evaluates canonical authority and
projects an explicit public response. Never accept a browser-supplied organization ID as
scope authority. An authenticated preview, if retained, must use the same presentation
projection while retaining its distinct access checks.

The response allowlist contains public Store text, approved Client branding, closing date,
ordered released Products, their approved display descriptions/images/alt text, currency,
gross price and supported choice labels/price modifiers. Bound list sizes and text lengths.
Never serialize members, organiser contact details, Client addresses, internal notes,
commission rates, provider settings, private artwork locators, database record graphs or
internal diagnostic blockers. Treat stored rich text as untrusted input.

For Individual Projects, presentation must match the confirmed offer and exact referenced
configuration versions. Changed upstream prices or images cannot silently alter a locked
offer. Product hold or loss of eligibility can withhold exposure; it cannot silently replace
the offer with newer content. Resolve that case through the existing authority/exception
workflow. Do not reinterpret a development PDF as production release evidence.

### Availability, privacy and caching

Start with the conservative rule: display a real offer only when canonical authority permits
trading and applicable Product/media release checks pass. Unknown IDs and withheld Stores
receive a consistent non-disclosing unavailable response. Draft, paused, closed, archived,
pre-opening, expired and C1-held Stores do not disclose their unreleased catalogue or internal
reason. More informative public states require an explicit business decision about what may
be disclosed before/after trading.

Initially use private/no-store response caching so a tenant mix-up or stale cache cannot
outlive a pause/hold. Re-evaluate authority on requests. Do not copy authenticated session
responses into public caches. Audit public media delivery separately: anonymous access is
limited to approved presentation media, never production artwork or source uploads. Existing
signed/public URL semantics and revocation must be verified before implementation acceptance.

### Data and ownership

Propose no schema change: existing Store identity and versioned data should support a read
projection. Any demonstrated missing immutable media/price/release fact must return to the
plan as a bounded dependency rather than be hidden in JSON or a new duplicate catalogue.
FUND owns Store presentation/eligibility; Commerce remains the generic financial authority.

## 4. Dependency And Development Demonstration Gate

B1 acceptance is necessary context but does not finish the full 1R-F readiness parent.
Individual real release, private managed output, approved public media and cross-workflow
release rules must not be asserted complete from the B1 emulation result.

A presentation component can be demonstrated with clearly synthetic local fixtures while
real Individual requests remain unavailable. That proves layout only. If the owner wants
a connected development-only purchaser journey against B1's emulated records, define and
accept its explicit environment/fixture/release contract first; never achieve it by deleting
`INDIVIDUAL_ARTWORK_DEVELOPMENT_ONLY`, fabricating payment readiness or changing the live
Store status directly. No such bypass is accepted by this draft.

Before implementation selection: confirm whether 1R-G is the intended Next; reconcile B1
review/smoke findings; identify the first supported workflow and its actual release evidence;
then decide whether a remaining 1R-F prerequisite must precede public presentation. Any
ordering change belongs in root/FUND controls. Do not resurrect the historical F-C through
F-I allocation automatically or label it the next approved implementation sequence.

## 5. Planned Evidence And Human Smoke

| Boundary | Required proof |
| --- | --- |
| Tenant resolution | Cross-tenant IDs/forged tenant input cannot reveal another unpublished Store; public identifier reveals only the intended released projection |
| Projection | Exact field allowlist; no member/contact/payment/private-asset data; hostile stored text cannot execute |
| State transitions | Draft, pause, intervention, close, archive and date boundaries withhold content immediately; unknown IDs do not disclose state |
| Version integrity | Public titles, order, gross prices and choices match selected immutable evidence; upstream changes cannot silently replace it |
| Product/media release | Hidden, unready, held or unapproved content is absent; artwork/source media remain private |
| B1 emulation | Production requests remain blocked; synthetic presentation fixtures do not create Order/payment or release evidence |
| Regression | Existing C1/C2 publication/intervention, B1 lock and A7 authority checks remain intact |
| Human | C1/C2 compare permitted released presentation with the intended offer; purchaser view works on mobile/keyboard; pause/closed/unavailable screens are understandable |

Run focused unit/service/route tests and required repository checks once implemented.
Use disposable fixtures for detailed negative cases. Any future change to retained DevData
needs an explicit target/cleanup boundary; this draft does not alter Chris's current test.
Record exact commit, environment, automated results and human outcomes in new 04/05 records
only when implementation/review happens. A planning draft does not justify implementation
confirmations or completed smoke claims.

## 6. Do Not Build And Failure Boundary

No checkout submission, payment provider call, receipt/email send, purchaser personal-data
collection, six-digit Order Code allocation, upload, production, dispatch, commission
settlement, real artwork infrastructure, template editor or ordinary offer unlock.
[1R-H-A Order code/correlation](2026-08-11-fund-phase-1-slice-1r-h-a-store-order-short-code-and-single-artwork-correlation-planning.md)
remains downstream and parked. No new operational account, credentials, deployed flags,
shared-database migration or branch promotion during planning.

If public projection/release checks fail, withhold the Store. Proposed rollback is disabling
or withdrawing the new public route without deleting Store/offer/Order evidence or changing
C1/C2 authority. A route/DTO disclosure failure must stop release, not degrade to returning
raw records. Exact implementation rollback and environment gates belong in technical review.

## 7. Decisions Still Needed

1. Confirm the reserved 1R-G presentation slice as Next; the roadmap did not already approve it.
2. Select the first demonstration contract: synthetic read-only presentation, or a separately
   bounded connected development journey after resolving the 1R-F release dependency.
3. Name representative Products, essential buyer choices and approved image expectations.
   The business report's suggestions remain proposals; do not reduce real Product needs to
   make the implementation appear smaller.

Delivery-address and purchaser-message choices belong to later checkout/operations planning
and do not block this read-only draft. Stop at a reviewable plan until scope and selection
are resolved. B1 remains Now and its local test continues unchanged.
