# FUND B1-R3 — Platform VAT Default And Product Rate Authority Review And Test

Date: 2026-09-16

Status: **Chris records A0/A PASS locally. C2 price-display omission corrected locally; automated/connected proof PASS and human B rerun pending. Owner retains the old archived Event and is creating a new test setup. Missing local Product media remains a prerequisite for C. Not deployed to staging.**
Candidate: `5ffb6cc8ec4594891a5e80356021bca3d75a7a28` on local `work/fund-b1-r3-platform-vat`. DevData is migrated to 157. Online dev/staging remain `e7e8837c`, which still has the reported VAT defect.
Follow-up C2 price-display candidate: local commit `6ebaac46` on the same branch; build/type,
critical-file verification, focused lint and 31 price/VAT tests PASS. Connected C2 price
readback, B1/B1-R3/A7 regressions and disposable database cleanup PASS; human rerun pending.
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
7. Confirm C2 cannot change the Product's VAT. If there is another real missing prerequisite,
   record its exact message and responsible role; do not bypass it to complete this schedule. **Chris 16/9/2026 - PASS**
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
| Follow-up C2 price-display correction | Local `6ebaac46`: 31 focused tests, build/type/critical-file verification and lint PASS; connected C2 price readback/B1/B1-R3/A7 and verified disposable cleanup PASS; human rerun pending |
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
| Human Store update, B | C2 price omission confirmed and corrected locally; rerun revised B on new active-Event setup. Price display no longer depends on a ready offer or Product image. Human PASS pending |
| Human resumed B1 finalisation/download, C | Blocked on reported fixture by archived Event and missing local Product image; no VAT failure or finalisation PASS inferred |

Existing B1/B1-R2 passes remain historical evidence for their scope, not proof of this correction.
