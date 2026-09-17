# FUND B1-R3 — Platform VAT Default And Product Rate Authority Review And Test

Date: 2026-09-16

Status: **Chris records A0/A/B PASS locally, including C2 inclusive prices at all four VAT rates and C2 VAT-edit refusal. C remains blocked by missing local Seller profile and Product images; reported readiness instructions point to unavailable C1 controls. B1 acceptance remains open. Not deployed to staging.**
Candidate: `5ffb6cc8ec4594891a5e80356021bca3d75a7a28` on local `work/fund-b1-r3-platform-vat`. DevData is migrated to 157. Online dev/staging remain `e7e8837c`, which still has the reported VAT defect.
Follow-up C2 price-display candidate: local commit `6ebaac46` on the same branch; build/type,
critical-file verification, focused lint and 31 price/VAT tests PASS. Connected C2 price
readback, B1/B1-R3/A7 regressions and disposable database cleanup PASS; Chris records B rerun PASS.
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
recorded candidate, migration and local checks. Preserve Chris's test bed. The previously
assigned tenant-logo Product image and DRAFT synthetic Seller are staging fixtures; they
must not be assumed present locally. Chris confirmed on 16 September that local Products
have no assigned images and local Product media remediation remains outstanding.
For the full Store/offer walkthrough, identify an unfinalised Individual Project with an
image-equipped selected Product, compatible Catalogue, template and other required setup
in the environment actually under test. The prior DRAFT synthetic Seller is for development only; do not edit its category rates
to make the VAT test pass. No real payment or Store publication is required for this smoke. Local DevData is migrated to
157 with protected-row fingerprints unchanged; restart the local Next.js process to load the
regenerated Prisma client before local smoke. Staging remains at the prior candidate.

Continue A0/A using existing and newly added local Products: images are not a prerequisite
for VAT defaults, editing or persistence. Their recorded passes remain valid. After the C2
price-display correction below, B uses the Products and Store Products price summaries and
does not require images or a ready Individual offer. Use an active Event/eligible Product
setup. C still requires all offer prerequisites, including a Product image; record it as
**BLOCKED — missing local Product image fixture**, not a VAT failure or PASS. Do not bypass
readiness. Current staging does not contain this VAT correction.
Record role, tenant, candidate and each actual result. Stop on failure; do not guess PASS.

## A0. P1 Platform Default → FUND And Pulse

Use the agreed test environment only. Record the starting platform default before changing it;
this default affects creation across the platform, not only the FUND test tenant.

1. As P1 open **Platform → Settings → IsoStack Core → Currency and Numbers**.
   Confirm **Default VAT rate (%)** is visible, initially 20 when never configured. Set **21**,
   Save and reload: 21 persists; existing currency, symbol and locale remain unchanged. **CHRIS 16-9-2026 PASS**
2. As C1 open a new FUND Product: VAT is **21%**. Save a labelled test Product with £10 net.
   Reopen: 21 remains. A new Pulse quote also starts at 21%; its rate remains editable.
   Pulse Settings displays the same platform default read-only. **CHRIS 16-9-2026 PASS**
3. Change the platform default to **0**, Save/reload. New FUND Products and Pulse quotes start
   at **0%**, while the saved 21% Product/quote and existing Store/offer totals remain unchanged.
   Duplicate the saved Product: its copy retains 21%. Editing an existing record preserves its
   rate instead of reapplying the platform default.**CHRIS 16-9-2026 PASS**
4. While a new-record form is open, enter a custom rate. A background refresh must not overwrite
   that entry. Blank, negative, over-100 or excessive-precision values are refused.**CHRIS 16-9-2026 PASS**
5. C1/C2 can receive the numeric creation default, but cannot change the platform setting or
   retrieve the full P1 settings object. Automated role tests provide this negative proof.**CHRIS 16-9-2026 PASS**
6. Restore the original platform default and verify it. For the following fixed-price synthetic
   tests use 20 explicitly where stated; if the original platform default differs, expect that
   value for a fresh form and enter 20 only in the test Product.**CHRIS 16-9-2026 PASS**

## A. C1 Product Creation And Editing

1. Open **FUND → Products → Add Product**. VAT is prefilled with the **current P1 default** (20% when unchanged). For this fixture enter 20%. There is no separate tax
   treatment/category question. Enter a clearly labelled test Product and **£10 net**; Save. **CHRIS 16-9-2026 PASS**
2. Reopen it. Confirm VAT remains 20%. Change to **7.5%**, Save and reopen: 7.5% remains.
   Change to **0%**, Save and reopen: 0% remains, not 20%. These are synthetic test inputs. **CHRIS 16-9-2026 PASS**
3. Start another new Product: its default matches P1, not the last Product's edited value.
   Cancel if no second fixture is needed. Confirm an invalid negative/over-100 rate is refused
   with a clear message and no saved invalid value. Automated checks cover precision/blank cases. **CHRIS 16-9-2026 PASS**

## B. C1 Product Change → C2 Draft Store Update

### Local Event blocker investigated — 16 September

Chris reports `C2-20260908-27FF7A1C` blocked at step 5; the original inline finding below
is preserved. Read-only inspection of verified local DevData confirms the Project is ACTIVE
and linked to Event `wf1`, which is ARCHIVED. Both have an effective closing date of
**30 September 2026 at 00:00 Europe/London**. This is a status blocker, not a date-expiry
or DD/MM/YYYY interpretation fault.

The audit records Project activation at 07:10 BST on 10 September, Event closure at
07:31:07 and archive at 07:31:11 that morning. Two linked Projects remain ACTIVE. These
actions predate the lifecycle correction commit `29104b55` at 09:03 BST on 10 September;
the evidence supports a surviving invalid test-data state from before that correction.
The current service refuses Event closure while linked Projects are active, and Product
eligibility excludes archived Events. Focused `event-catalogue-scope.test.ts` rerun on
16 September: **4 tests PASS**. This is not a new connected runtime proof.

Chris explicitly selected **Leave the Event archived** after review. No data was changed.
Do not restore/reactivate this Event or change its dates to force the smoke test through.
Resume C2 Product/Store checks on a suitable Project linked to an ACTIVE Event; its other
readiness prerequisites still apply. The missing local Product image remains a separate
blocker for full offer/finalisation proof. A0/A passes stand; B/C are not accepted by this finding.

### C2 price-display omission and corrected B schedule — 16 September

Chris's finding at step 5 correctly identifies a UI omission: C2 Product cards contain no
prices, the C2 Store response omits configuration prices, and C1 Project tables ambiguously
label net prices as “Price”. The local correction adds current Product prices to C2 Products
and saved configuration prices to C2 Store Products. Following Chris's clarification, C2
sees only “Price per item” and the amount including VAT, without net/VAT analysis. C1 columns now say “Net price (excluding VAT)”. Calculations use the same
server minor-unit/half-up arithmetic as the offer/checkout. No media/Seller readiness bypass
or financial write is added. Finalised offer/PDF evidence remains separate and unchanged.

4. Use a selected Product on an unfinalised test Project linked to an ACTIVE Event in the
   verified local environment. Images are not required for B's read-only price checks. Record
   its starting price/rate. Set **£10 net and 20% VAT**, Save. Do not change Seller rates or
   any hidden category. The known legacy REDUCED/20% setup must no longer block this path.
5. As C2, open **Project → Products → Refresh Product prices**: confirm **£12 including VAT**
   under “Price per item”, with no net/VAT breakdown. Then open **Store → Refresh Store
   configuration** and inspect **Store Products** below the offer panel. Confirm the same
   **£12 including VAT** price per item. Use the Store configuration
   button; the offer itself may remain blocked by missing media or other prerequisites.
   A second refresh must preserve selection, amounts and readiness. No category/Seller-rate
   mismatch is expected; unrelated readiness messages may remain.

   Original finding, preserved: ** BLOCKED Because pridce does not surface in the c2 product listing - it is an omission - - the products listing is incomplete - and a placeholder.  The price is included in the C1 version of the project CRUD but displays the new price excluding VAT, with a statement of the VAT rate... but is not explicit about New price or whether or not the listed price includes VAT.  This is ok being Net price, but sohuld say so. Cant test the impact of VAT on C2** **CHRIS: Remeditation has worked - PASS**
6. As C1 change only VAT to **5%**, Save; as C2 refresh Product prices, then refresh Store
   configuration and compare both displays. Expect **£10.50 including VAT**. **Chris 16/9/2026 - PASS**
   Repeat with **0%** (price **£10**) and **7.5%** (price **£10.75**). C2 sees the inclusive
   price only; C1 net remains **£10** throughout. No category choice or Seller-rate edit. **Chris 16/9/2026 - PASS**
7. Confirm C2 cannot change the Product's VAT. **Chris 16/9/2026 - PASS** If there is another real missing prerequisite,
   record its exact message and responsible role; do not bypass it to complete this schedule. ** Chris 16/9/2026 - offer prerequitie message:
Before you can finalise this offer
C1: configure the organisation’s Seller profile and GBP currency before reviewing prices. (CHRIS: note there is no UI for setting currency for seller)
A.TestCreateProduct: C1: assign a primary image in Products → Edit Product.
Coaster: C1: assign a primary image in Products → Edit Product.
Teatowel: C1: assign a primary image in Products → Edit Product.
Ceramic Mug 2: C1: assign a primary image in Products → Edit Product.
Complete the listed actions, then refresh the Store configuration below to check the offer again.**
8. Restore the intended test price/rate, Save and refresh. Verify the expected gross amount
   before finalisation. Do this before the next section because B1 locks confirmed content. **Chris 16/9/2026 - PASS**

## C. Resume The Blocked B1 Offer Test

### Local offer prerequisites confirmed by Chris — 16 September

The step 7 finding above does not overturn the VAT/C2-price passes. The exact Seller
message is emitted when the organisation has no Commerce Seller profile; it does not
establish that the P1 currency setting is wrong. The offer still requires Seller identity
and GBP, independently of Product-rate VAT authority. No C1 Seller/currency setup UI is
currently exposed. The Product editor only displays assigned media; its upload/assignment
controls remain deferred. Therefore the reported instructions to configure these through
C1 are not executable in the current UI and must not be treated as user error.

Section C is **BLOCKED — local development fixture setup**, covering a GBP Seller profile
and primary images for the four named Products. The existing synthetic DRAFT Seller and
logo fixtures were approved/provisioned on staging only. No local fixture writes are made
by this review and no staging approval is extended silently. Resume C only after local
setup is explicitly established or the verified candidate is promoted to the prepared
staging environment. Do not alter P1 currency, Seller tax rates or bypass readiness to
force finalisation. Inaccurate application readiness wording remains an identified issue.


9. As the exact organiser, review the now-available offer summary, acknowledge and finalise.
   Generate/download the labelled development PDF. Its Product prices must match the reviewed
   summary. Reload and re-download; confirm selection/content remains locked and no purchase
   or Store-publication authority was enabled by this step. **BLOCKED**
10. For a separate already-finalised test offer, verify a later C1 source-rate edit plus allowed
    refresh does not rewrite its confirmed price or PDF. The agent should prove this first with
    disposable fixtures; avoid changing a shared human fixture without identifying its scope.

This tests the existing text/price development PDF. It does not claim a visual template
preview or production print layout; Chris's separate concern remains unresolved.

## Evidence To Complete After Implementation

### Whole Store-publication review — 16 September, after the 19:49 screenshots

**17 September planning update:** A0/A/B PASS and the observed code findings below remain
valid; C/publication smoke is still paused. Chris has replaced the proposed remedy with the
[simple Store launch plan](../03-slice-planning/2026-09-16-fund-phase-1-launch-preparation-planning.md): reusable commission defaults, automatic images and one
combined launch confirmation. The earlier recommendation to build separate C1 proposals is
superseded. No further implementation, smoke or promotion result is claimed here.

**16 September owner disposition accepted (historical):** Chris accepts the recommended continuation below: preserve
A0/A/B PASS, keep C blocked until deliberate development setup, and prepare the
[bounded launch-preparation plan](../03-slice-planning/2026-09-16-fund-phase-1-launch-preparation-planning.md). The proposal is now
prepared. No repeat publication smoke, new implementation selection, fixture writes or
promotion is authorised; root B1 Now / 1R-G planning Next remain unchanged.

**Conclusion: the connected C1 setup → C2 publication → purchaser journey is not complete.**
The VAT correction passes its bounded human checks. That does not establish Store-publication
readiness or complete B1. This review is by the implementing agent, not a separate reviewer.

Evidence: Chris's two supplied screenshots, application `6ebaac46`, roadmap/lifecycle source,
and a read-only transaction against verified local DevData. Project
`C2-20260916-C3A4CA87` (`5ea07c83-efdc-47fa-9db8-bb22eb7c0474`) is ACTIVE; Event `1wf.2`
is ACTIVE. The Project window is 2–30 September, with close at **00:00 on 30 September**
Europe/London. Its Store is DRAFT. There is one active Project selection and one matching
visible, eligible Store Product: Teatowel, GBP 45 net, VAT 20%, GBP 54 including VAT.
Its only Product readiness reason is `PRIMARY_MEDIA_MISSING`. No missing-selection defect
is reproduced for this Project. The Store Product appears in the second screenshot.

The tenant has no Seller profile, no Stripe connection and no commission policies. This
Project has no commission assignment and no finalised Individual offer. No data, provider
configuration, application code or deployment was changed during this review.

| Stage | Observed implementation and current blocker | Disposition / responsible work |
| --- | --- | --- |
| Event/Project and Product selection | Active Event and Project; selected Teatowel is present and correctly priced | Working on this fixture; no need to recreate it again |
| Product presentation | Product editor displays assigned images but cannot upload/assign them; readiness nevertheless says to assign one there | Missing local fixture plus misleading action text; existing media-refinement input owns the finished UI. Development placeholders do not deliver that UI |
| Seller identity/currency | Offer generation requires a GBP Seller profile. No C1 Seller-profile provisioning UI/write path was found | Missing setup capability, distinct from P1 currency/VAT defaults and Stripe onboarding. Explicit local fixture preparation can support B1 only |
| Commission proposal | Policy/version/assignment schema exists (`1R-C5`); no C1 create/propose runtime path or UI found in application source | Required Phase 1 pre-publication dependency, not delivered by the schema slice; use the existing commission input and its reserved C1 UI contract for bounded follow-on planning |
| Commission acceptance | C2 review/accept UI and guarded mutation exist (`1R-E-C`), but only appear for a PROPOSED assignment | Correctly awaiting an offer. Top-level “Accept the current commission offer / C2” is wrong when none exists: readiness collapses absent and unaccepted offers into one reason. A missing offer needs C1/setup ownership; only an existing offer needs C2 acceptance |
| Individual offer/document | C1 template assignment exists and the screenshot confirms it. C2 finalisation/download exists but requires the missing Seller/image setup | B1 section C remains blocked. Commission and live Stripe setup are publication gates, not prerequisites to the bounded development PDF test |
| Individual real release | `INDIVIDUAL_ARTWORK_DEVELOPMENT_ONLY` is added unconditionally for Individual Projects, including those with an available PDF | Intentional B1 boundary; this cannot be cleared by ordinary C1 setup. Displaying it as another C1 task is misleading. Later Phase 1 production readiness/release is required |
| Payment setup | Shared `/settings/payments` has Stripe Connect status/onboarding and checkout controls; changes require the organisation OWNER, not impersonation. Publication also requires an ACTIVE Seller profile | Existing Commerce A6 capability, unconfigured here; connecting Stripe alone cannot supply the missing Seller record or remove the B1 release restriction. No real-provider setup requested by this review |
| Publication and purchaser access | C2 Publish/Resume actions and server guards exist but are withheld while blockers remain; no public FUND Store presentation route is implemented | `1R-G` is the next planning proposal, initially read-only/development preview. Public release, purchaser checkout and Order operations remain later Phase 1 outcomes; passing these local VAT tests does not deliver them |

Source trace: `services/store-management.service.ts` readiness and Store transitions;
`services/store-authority.service.ts` publication/payment authority;
`services/individual-offer-readiness.ts` unconditional development restriction;
`services/individual-offer.service.ts` actual finalisation prerequisites;
`services/client-dashboard.service.ts` commission acceptance;
`components/client-dashboard/ClientProjectStorePanel.tsx` conditional acceptance/Publish UI;
`components/products/ProductPrimaryImagePanel.tsx` display-only media;
`src/app/(app)/settings/payments/page.tsx` and Commerce Stripe router/service. FUND paths are
under `src/modules/fund` in isostack-bedrock.

Focused review checks: **16 tests PASS** across Individual readiness, Client Store controls,
Store configuration and Store oversight. They confirm bounded rules, including refusal of
live Individual trading; they are not an end-to-end publication PASS or browser observation.

**Recommended continuation:** retain A0/A/B PASS; keep C blocked until deliberate development
setup is available. Reconcile the missing C1 commission and Seller setup into a bounded
Phase 1 launch-preparation plan, with truthful staged readiness and supported media setup.
Keep commission policy/proposal/acceptance separate from later calculation/statements/settlement.
Then follow the existing real-release, public Store and purchaser/Order dependencies. Do not
ask Chris to repeatedly smoke-test publication while those paths are absent. No new slice is
selected and root B1 Now / 1R-G planning Next remain unchanged by this review.

| Check | Current result |
| --- | --- |
| Follow-up C2 price-display correction | Local `6ebaac46`: 31 focused tests, build/type/critical-file verification and lint PASS; connected C2 price readback/B1/B1-R3/A7 and verified disposable cleanup PASS; Chris records B rerun PASS |
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
| Human platform defaults and Product creation/editing, A0/A | Chris records PASS locally on 16 September; inline results preserved |
| Human Store update, B | Chris records PASS: price-display correction, 5%/0%/7.5% changes, C2 VAT-edit refusal and restored intended rate/price. Original findings and inline results preserved |
| Human resumed B1 finalisation/download, C | BLOCKED: local Seller profile and four Product images missing; no C1 setup controls for the reported instructions. No finalisation PASS inferred |

Existing B1/B1-R2 passes remain historical evidence for their scope, not proof of this correction.

## 17 September — Supported Preparation Follow-up

Chris authorised the simpler preparation increment after this review. The new
[preparation implementation and smoke record](2026-09-17-fund-simple-store-preparation-review-and-test.md)
covers C1 defaults/Seller setup, automatic Product images and the C2 development-template
journey. Retain the human A0/A/B VAT passes and all comments above. Do not interpret the
new code as a C/publication PASS: its human preparation smoke and separate review are still
pending, and Individual live publication/public purchasing remain unavailable.
