# FUND 1R-G — Public Store Presentation Planning

Date: 2026-09-07

Status: **Detailed planning resumed by Chris on 2026-09-10; recommended development-preview contract ready for review. B1 closure and implementation selection remain separate gates.**

Control depth: **High** — unauthenticated Store reads introduce tenant, personal-data,
media-release and commercial-authority boundaries.

Work type: proposed production-model feature. Synthetic development fixtures may prove
presentation; they do not create public release authority or operational provider evidence.

Chris requested the next planning slice after reporting local FUND smoke PASS and
IsoStack/LMSPro staging smoke PASS, and explicitly authorising security main/live promotion
on 2026-09-10. This resumes the existing reserved `1R-G` plan. The security-only correction is pushed through main; root Now has returned to FUND B1
dev/staging promotion and acceptance. This existing planning proposal is Next. Planning can advance while those gates are open, but neither B1
closure nor 1R-G implementation is inferred. This document creates no second checkpoint.
No application code, configuration, database or running local-test environment is changed.

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

Application re-inspected on 2026-09-10: `29104b55`, containing B1/B1-R1/B1-R2 on
`work/fund-b1-r1-catalogue-workflow`. Security candidate `0397bba9` remains separate.
The original `57e1454b` inventory is refreshed below against the corrected local source.

| Existing source in isostack-bedrock | Consequence for this plan |
| --- | --- |
| `prisma/schema.prisma`: `FundProjectStore.publicId` is globally unique; Store has tenant/Project lineage and publication state | Resolve public identifier server-side, then derive tenant scope; no new public identifier table is justified |
| `FundStoreProductConfigurationVersion` holds presentation, media, input-contract, price/tax and readiness snapshots | Reuse an explicitly selected version; do not assemble a sale description from unrelated current Product fields |
| `src/modules/fund/services/store-authority.service.ts`: `evaluateFundProjectStoreAuthority` returns effective state, blockers and `isTrading` | One authority source must govern availability; the public endpoint must not return the service's entire internal object |
| `src/modules/fund/services/individual-offer-readiness.ts` always adds `INDIVIDUAL_ARTWORK_DEVELOPMENT_ONLY` for Individual Projects | B1 cannot open a real public Individual Store, even with an AVAILABLE document |
| `src/modules/fund/services/store-checkout.service.ts`: `submitFundStoreOrder` already owns FUND validation and delegates generic Orders/payments to Commerce | Presentation must not build another Order aggregate or turn this service into an unauthenticated endpoint in this slice |
| `src/modules/fund/services/individual-offer.service.ts` creates, and `lib/individual-offer/contract.ts` validates, a deliberately invalid development destination | Do not rewrite confirmed B1 snapshots or claim that their printed destination is a real Store URL |
| `src/middleware.ts` explicitly allowlists public routes; existing FUND Store pages are under authenticated `/app/fund` | Public routing needs a narrowly scoped addition and a public layout; do not expose the administrative route tree |
| `FundProductMedia` links to media files; configured versions snapshot media IDs/roles/alt text but do not establish immutable public delivery/release authority | Resolve exact referenced media under tenant/release checks; a current mutable media URL is not an immutable approved snapshot |
| `availability.service.ts` and `event-catalogue-scope.ts` enforce Catalogue channel plus workflow compatibility, then existing C2 selection | Use canonical eligibility; no Product workflow gate, default-only suppression or new standalone Catalogue assignment |
| `FundIndividualOfferProduct.configurationVersionId` links each finalised row to its exact Store configuration version | Read these versions, not `currentConfigurationVersionId`, for finalised Individual content |

This is read-only technical planning, not a new automated test PASS. Chris's local smoke
PASS at `29104b55` is recorded in B1-R1/B1-R2 05. Independent review, remaining B1-R1
connected proof and security integration/combined-candidate checks remain open.

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

## 7. Planning Decisions And Implementation Gate

1. **Planning continuation confirmed:** Chris has requested the next planning slice; this
   existing 1R-G document is being refined. Its implementation remains unselected while
   B1 review/proof and security integration are unresolved.
2. **Recommended first deliverable:** a connected, authenticated purchaser-view preview for
   the Individual Artwork development journey, using the bounded contract below. This is
   a proposed scope decision for implementation acceptance, not a production-release bypass.
3. **Representative content:** reuse the owner's existing local Mug/Individual Project test
   bed for human comparison; use synthetic fixtures for choice combinations and disclosure
   negatives. Exact Product/Project IDs and media permissions are verified at implementation
   preflight, not guessed or copied into public documentation. No need to rebuild the test bed.

Delivery-address and purchaser-message choices remain later checkout/operations work.
The only material business choice before implementation is whether the first deliverable
should be the connected organiser preview below or whether an actual anonymous, shareable
Individual Store must come first. The latter requires completion of the real-release
prerequisites and would change the implementation sequence.

## 8. Recommended Bounded Development Preview

The first user outcome is: the organiser opens **Preview purchaser view** from the Project
Store area and sees the selected, finalised Individual offer as a purchaser would read it.
The page clearly says that it is a development preview and that ordering is unavailable.
It adds no checkout, payment or inert purchase control.

This uses the owner's accepted Phase 1 development-emulation direction. It does not change
the meaning of Store publication or imply that a purchaser without an account can open
the preview. The reusable presentation component and public response shape prepare the
later anonymous Store, whose production authority contract remains Section 3.

### Access and environment contract

- Proposed authenticated route: `/app/fund/projects/[projectId]/store/preview`, subject to
  verifying the existing C1 and C2 route layout before implementation. Reuse the existing
  Project access resolver for both surfaces; C2 must belong to that exact Client.
- The server must require both authorised Project access and the existing explicit
  local/test/staging emulation target. Production/main and missing/invalid targets refuse
  before returning preview data. `NODE_ENV` alone is insufficient.
- The preview reads an existing finalised Individual offer and its AVAILABLE development
  document. An absent offer/document shows a setup message to the authorised organiser.
  Do not create/finalise an offer or regenerate artwork from a read request.
- Existing Store authority continues to report real trading unavailable. Never pass a
  fabricated `paymentReady: true`, remove `INDIVIDUAL_ARTWORK_DEVELOPMENT_ONLY` or write a
  PUBLISHED/ACTIVE state just to make the preview render.
- Do not expose an anonymous route to emulated records, add a share token or change the
  deliberately invalid destination already locked into the B1 PDF.

### Projection and integrity contract

| Displayed information | Authoritative source and failure behaviour |
| --- | --- |
| Store title, Client label, introduction, objective, closing date | Validated finalised offer snapshot; do not overwrite with current Project edits |
| Product order/title and GBP gross price | Finalised offer rows, preserving positions and integer minor units; never recalculate a historical price from current Product tax/price |
| Description and choice labels | Exact configuration versions referenced by the offer; runtime-validate their JSON shape, bound fields and render text safely |
| Product visibility | Current canonical Catalogue channel/workflow eligibility and C2 selection may withhold the preview; a missing source never substitutes a new Product or price |
| Images and branding | Resolve exact referenced media with tenant/access checks. Missing or mutable/unverifiable media uses a neutral placeholder; never fall back to another tenant's/current Product image |
| Internal IDs, role details, commission/payment settings, artwork locators | Never included in the purchaser presentation response; route/access logic retains internal identifiers server-side |

If current eligibility no longer supports the locked selection, withhold the rendered offer
and show an organiser-facing resolution message outside the purchaser projection. Preserve
the immutable offer and PDF. Do not silently shrink the accepted range into a different offer.
Shared authenticated layouts can retain normal organiser navigation; the presentation
component itself must consume only the explicit public-shaped projection.

### Implementation order within the proposed slice

1. Review the exact combined security/FUND candidate and reconcile B1 proof gaps. Confirm
   access helpers, versioned media semantics and the recommended preview scope.
2. Implement a strict projection parser and pure presentation component with synthetic
   fixtures for missing media, long text, multiple Products and supported choice labels.
3. Add the authorised development preview resolver using existing Project/Client access,
   immutable offer joins and canonical eligibility. Avoid read-side writes and shared caches.
4. Add the Project Store entry point and responsive/keyboard-accessible page.
5. Prove the negative boundaries below, run required checks, then create the slice's 04
   confirmation and 05 review/test records with exact candidate and human evidence.

No schema change is currently justified. If media immutability or public-release facts need
new persistence, stop that dependent implementation and return the bounded finding to this
plan. Do not add an approval schema or silently relabel mutable media as immutable.

### Focused acceptance schedule

| Check | Required result |
| --- | --- |
| C1 / correct C2 Client | Preview loads the intended finalised offer with matching rows, order and prices |
| Wrong Client, tenant, signed-out user | No offer, Product or media disclosure; reuse normal access-denial semantics |
| Main/production or disabled emulation | Server refuses preview data, regardless of a visible/stale link or request parameter |
| Missing finalisation/document | Clear organiser setup state; no generation, publication or database mutation |
| Upstream Product price/text changes | Finalised preview remains on its referenced configuration version |
| Catalogue channel/workflow withdrawal | Preview is withheld; locked offer/document remain unchanged; restoration does not undo C2 exclusions |
| Malformed snapshot or foreign/missing media | Fail closed or use the defined safe media placeholder; no raw record/URL fallback |
| Phone, keyboard and long content | Readable Product descriptions, GBP prices and closing date; no misleading purchase action |
| Existing B1/Catalogue/Event paths | Focused regression confirms finalisation, Product selection and Event assignment still behave as accepted |

These are planned checks, not completed smoke results. Local testing proves the detailed
boundary. Any later staging deployment must verify its actual preview configuration, media
access and representative organiser path; live must continue to refuse the development
preview. Actual anonymous trading remains a later accepted release outcome.
