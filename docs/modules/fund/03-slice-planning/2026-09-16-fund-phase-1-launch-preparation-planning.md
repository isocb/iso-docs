# FUND — Phase 1 Launch Preparation: Bounded Planning Proposal

Date: 2026-09-16

Status: **Planning continuation accepted by Chris; proposal prepared for implementation
selection. No new implementation slice selected or authorised.**
Control depth: **High** — tenant financial configuration, commission terms/acceptance,
media ownership and preservation of confirmed evidence.
Work type: proposed production-model services/UI, with a separately labelled development
image bridge. This is not an external-service assumption test or a permission to publish.

Chris accepts retaining B1-R3 A0/A/B PASS, leaving C blocked until deliberate development
setup exists, and reconciling the missing C1 setup into this plan. Root **B1 Now / 1R-G
planning Next stays unchanged**. The [B1 plan](2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-journey-development-plan.md)
retains the only restart checkpoint. No repeated publication smoke is requested meanwhile.

## 1. Authority, Inputs And Disposition

- [Root control](../../../00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md)
  and [FUND control](../00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md).
- [Whole-publication review and human VAT passes](../05-review-and-test/2026-09-16-fund-b1-r3-product-vat-rate-authority-review-and-test.md#whole-store-publication-review--16-september-after-the-1949-screenshots).
- [Commission input](../01-cr-inputs/2026-07-13-fund-cr-commission-ladder-planner-input.md)
  and the accepted [C5 business contract](2026-07-14-fund-phase-1-slice-1r-c5-commission-policy-assignment-schema-implementation-planning.md).
- [Product-media input](../01-cr-inputs/2026-09-12-fund-product-media-gallery-options-and-option-image-refinement-input.md).
- [Commerce control](../../../core/commerce/00-roadmap-control/2026-07-13-commerce-core-roadmap-and-slice-control.md)
  and [business situation report](../00-roadmap-control/2026-08-25-fund-complete-module-smoke-readiness-business-overview.md).

This reconciles existing requirements; it does not introduce a parallel roadmap or duplicate
commission/media CR. Triage disposition: C1 policy/proposal is an undelivered Phase 1
pre-publication dependency; Seller identity is a shared Commerce setup dependency; the
existing temporary-logo requirement can support development without selecting the full
media gallery. Misleading responsibility/action messages are acceptance defects in the
existing Store journey. Their bounded correction belongs with this proposed outcome.

## 2. Visible Outcome And Limit

C1 can prepare the organisation and Project through supported screens. C2 can see the
selected Products and inclusive prices, see and accept actual commission terms, and see
which next actions are possible. For Individual development Projects, the exact organiser
can finish the existing labelled offer/PDF test once its own prerequisites are met.

The screen must clearly say that real publication remains a later release capability. A
complete development setup is not a publishable Store, an ACTIVE Seller or payment approval.
Development fixtures must never be represented as production onboarding.

## 3. Proposed Delivery Order Within This Boundary

These are ordered implementation increments for review, not additional portfolio selections.

### A. Accurate readiness and action ownership

- Present development offer preparation/finalisation separately from future Store publication.
  Keep one server-owned blocker model; do not create a second client-side authority engine.
- Distinguish no commission offer (C1 setup), PROPOSED current offer (C2 acceptance), a stale
  proposal (C1 refresh), accepted effective terms, and finalised/protected terms. A proposed
  replacement must not falsely remove the prior accepted assignment's effect.
- Show `INDIVIDUAL_ARTWORK_DEVELOPMENT_ONLY` as a development/release limitation, not an
  ordinary C1 task. It remains enforced server-side for every Individual Project.
- Name the affected Product and the real action/route available to the authorised actor.
  Do not instruct C1 to upload in a display-only editor or configure a nonexistent screen.
- Link existing payment status to `/settings/payments` where authorised; explain OWNER-only
  onboarding. Do not make Stripe setup a prerequisite of the development PDF test.
- Preserve C2 inclusive-price-only display and existing Product selection. Readiness never
  removes a selected Product merely to make the checklist green.

### B. Seller and temporary Product-image preparation

**Seller identity:** add a narrow shared Commerce profile service/router and a clearly named
Seller details section alongside existing Payments settings; FUND links to that surface.
Reuse `CommerceSellerProfile`, not FUND metadata or a second Seller table. Proposed access
is tenant OWNER creation/editing and ADMIN read access, consistent with payment setup;
confirm this boundary at implementation selection. C2 and foreign-tenant access are refused.

Capture the existing required legal/trading identity and address fields, with validation and
audited tenant-scoped writes. Prefill only genuine available organisation values; missing
legal details require input. Never invent real Seller identity. Initial save remains DRAFT.
No activation, provider account creation, checkout enabling or automatic publication occurs.
Already ACTIVE or Order-referenced profiles need a separately reviewed edit contract; this
bounded first-create/DRAFT-edit path must refuse to overwrite them.

Proposed currency behaviour: initialise from the existing shared platform currency and
validate the current FUND GBP-only contract. Show currency clearly without another C1
currency selector. An unsupported platform value gives an explicit limitation, not a silent
GBP fallback. Preserve any existing Seller currency and historical Order snapshots; later
platform changes do not rewrite them. Do not expose Seller tax-category defaults or restore
their former veto over the saved Product VAT percentage.

**Temporary primary image:** in Product create/edit, provide an explicit “Use tenant logo
temporarily” action for an already saved Product in the recognised development/staging
context. Show its thumbnail and temporary status there. This is the existing requested
bridge, not a generic Media-library selector or acceptance of permanent Product photography.
Do not assign images to every Product or mutate Chris's fixtures automatically.

Resolve only the current tenant's existing managed logo. Validate ownership, usable stored
asset and supported delivery; arbitrary URLs/foreign files must not be fetched or accepted.
The current image setter accepts JPEG/PNG/WebP/GIF, whereas earlier managed-logo fixtures can
be SVG: explicitly review this mismatch. Do not widen general SVG upload/assignment as a
shortcut. If the tenant has no safely reusable logo, show a precise setup blocker and stop
that action; do not claim the bridge works for an unprepared tenant.

Preserve old media references, obtain the existing availability lock, advance Product
configuration revision and audit assignment. Refresh creates a new draft Store configuration;
finalised offers/documents and Order evidence retain their previous references and bytes.
For new Products, save identity first and make retry safe if subsequent logo assignment fails.
Full uploads/gallery/folders/options remain with the media input and pilot-scope assessment.

Completion of this increment may unblock B1 section C. Commission/Stripe gates must not be
silently added to that development offer test. Actual local fixture creation remains a
separate explicit action; earlier staging-only fixture approval is not extended by this plan.

### C. C1 commission configuration → proposed terms → C2 acceptance

Reuse C5 policy, immutable version/step and assignment models and accepted semantics:

- Event defaults and standalone Project policies support flat or stepped terms. An
  Event-linked Project override is flat only and takes precedence over its Event default.
  Clearing an override resolves back to the Event policy; absence remains an explicit blocker.
- Add Commission controls to C1 Event/Project context: configure/version terms, inspect
  inherited versus overridden terms and acceptance/history, and propose the resolved offer.
  This is commercial preparation, not another C1 Project-publication approval gate.
- Use C5's one-decimal percentage input (0.0–100.0 in 0.1 increments) and exact integer basis
  points. Stepped terms have one timing method, strictly decreasing ordered rates, a final
  step, and an immutable timezone; preserve calendar-day/DST and Project-close semantics.
- On Project creation, a context-valid active policy may resolve automatically into a
  PROPOSED assignment inside the existing atomic Store provisioning. Never auto-accept.
  Existing Projects use an explicit, idempotent proposal action. Avoid adding an unbounded
  Event-wide rewrite/bulk migration when C1 changes an Event policy.
- C2 must see the actual flat percentage or complete ladder rates, date boundaries/timezone,
  source, version and Project close before accepting. The current “N commission steps” text
  is insufficient. Keep effective accepted terms and a proposed replacement distinguishable.
- Reuse and review the C2 acceptance transaction. Recheck tenant/Client role, current Event/
  Project context, version validity, close snapshot and replacement chain on the server.
  Concurrent proposals/acceptance/context edits either commit one coherent result or refuse
  with a recoverable conflict; no stale proposal or implicit acceptance is permitted.
- A replacement does not affect the accepted assignment until explicit C2 acceptance.
  Retain superseded history and the C5 retrospective whole-Project semantics; this increment
  does not calculate any sales amount or commission payable. Finalised commission terms
  remain protected; no reopening/adjustment workflow is added.

Do not restrict the accepted C5 model to flat-only without a recorded scope decision. Source
review of migrations/indexes/triggers and the lock order is required before implementing
proposal replacement, particularly the single-effective/successor constraints.

## 4. Data, Ownership And Recovery Assessment

Baseline: application `6ebaac46`, local DevData 157; online dev/staging remain `e7e8837c`.
Local Project `C2-20260916-C3A4CA87` is the current review fixture. Old `wf1` remains archived
at Chris's direction. Preserve existing data, A0/A/B evidence and all confirmed artifacts.

No schema change is assumed: Seller, Product media, policy/version/steps and assignments
already exist. Implementation preflight must inspect current constraints and audit/idempotency
support. If a missing integrity constraint requires migration, revise this plan explicitly
and follow [Safe Database Workflow](../../../../SAFE_DATABASE_WORKFLOW.md); never db:push,
seed/reset, mass-backfill guessed terms, or delete history to get a test green.

FUND owns policies, proposals, Product assignment and readiness. Commerce owns Seller
identity and payment status; Core owns platform defaults/shared media storage. Keep shared
changes narrow and register them in Commerce control. No new provider or credential is needed.

Rollback must preserve every new accepted assignment/media reference and use a compatible
binary or forward fix. A revert of UI may remove access to setup without undoing configuration.
Do not delete accepted terms, Seller records used by Orders or media referenced by frozen
evidence. Prove partial-save/network retry behaviour and truthful failed-action messages.

## 5. Proof And Future Human Smoke

Automated proof after implementation must cover tenant/role refusal; DRAFT-only Seller writes;
missing/unsupported currency; image ownership/type/absence and failed assignment; correct
scope precedence and flat/step validation; exact proposed terms; close-date/DST cases;
idempotent replay and concurrency; retained accepted/finalised evidence; and refusal to
publish/trade an Individual Store even when all development setup succeeds. Exercise Core
changes with their relevant consumers. Run relevant type/lint/build/repository checks.

Use disposable fixtures for destructive/concurrency proofs with verified cleanup. Preserve
Chris's local test bed. Establish local behaviour first, staging environment differences
after controlled promotion, and no real payments or live changes through this proposal.

Only after automated review and usable controls exist, issue one concise replacement smoke:

1. C1 sees correct action ownership; absent commission shows “Awaiting supplier offer”.
2. Tenant OWNER saves the agreed DRAFT Seller fixture; C1 assigns the temporary tenant logo
   through Product edit. Verify reload/retry and no unintended changes to other Products.
3. Exact organiser completes B1 development offer/PDF, re-download and lock checks, with
   publication still unavailable and no request to connect live payments.
4. C1 configures Event terms and a standalone policy; C2 sees exact terms and accepts.
   Test one Project override and proposed replacement; prior accepted evidence persists.
5. Confirm publication remains explicitly deferred; the screen offers no impossible C1/C2
   action. Already accepted VAT smoke is repeated only if implementation introduces a real
   pricing regression risk; otherwise retain A0/A/B PASS.

No new human run is requested now. Record implementation in 04 and technical/human evidence
in 05 when performed; do not pre-create PASS records. Separate review, human acceptance and
controlled promotion remain gates. Main/live requires its specific approval.

## 6. Do Not Build And Stopping Point

No commission calculation, earned/paid totals, statements, settlement or payout. No real
Seller activation, Stripe onboarding execution or payment enablement. No public Store route,
checkout/purchaser/Order UI, production artwork service, readiness bypass, unlock of confirmed
Individual offers or implicit Store publication. No gallery/folder/option-image implementation
or wholesale intake-to-live automation. Essential pilot media/options still require their own
scope assessment; the temporary logo does not declare them complete.

This turn stops with a reviewable plan. The next implementation decision is whether to select
this bounded launch-preparation outcome and accept its proposed role/currency/media boundaries.
It must be reconciled in root control before execution; no automatic reordering is inferred.
Then follow the existing production-release, public Store, purchaser/Order and operational
dependencies. Do not promise that this preparation plan alone makes an Individual Store live.
