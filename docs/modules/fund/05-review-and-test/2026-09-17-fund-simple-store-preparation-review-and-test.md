# FUND — Simple Store Preparation Review And Smoke

Date: 2026-09-17

Status: **Local implementation; bounded automation PASS. Local human preparation smoke 1–5 PASS (Chris, 17 September). Broader regression, separate review and promotion remain open.**
Control depth: **High**.
Exact candidate: `9c09cbe1a9f822ccadde122e1680ab8e513ef9e1`, locally committed on `work/fund-b1-r3-platform-vat`; not pushed or promoted.
[Plan](../03-slice-planning/2026-09-16-fund-phase-1-launch-preparation-planning.md)
· [Implementation](../04-implementation-confirmations/2026-09-17-fund-simple-store-preparation-implementation-confirmation.md)
Application behaviour is `3820e304`; `9c09cbe1` only moves the legacy test fixture before finalisation. Its commit hook type check passes.

## Automated Evidence

- 601 unit/regression tests PASS; 12 skipped. Command: `npx vitest run --exclude scripts/proofs/fund-1r-f-a/proof.test.ts`. That existing Chromium proof is excluded after sandbox browser-start failure; no new browser rendering proof is claimed.
- TypeScript, critical-file verification and isolated production build PASS. Changed source/test lint: zero errors, five pre-existing EventDetailPage warnings. No clean whole-repository lint claim.
- Connected candidate `9c09cbe1`: fresh 157-migration replay and exact checksums PASS. New simple-preparation checks PASS: zero/default/Event inheritance, reuse of legacy policy owners, stale terms, failed-launch rollback, concurrent/repeat launch, first-publication lock through pause, optional Product exclusions, effective image snapshots, pre-opening preparation and Seller authority.
- B1-R3 connected rate/default/override/C2/foreign/concurrency checks PASS. Later source VAT edit and Store refresh preserve the finalised offer and downloaded PDF bytes, including the legacy Project initialisation fixture: PASS.
- Eight existing availability/finalisation concurrency cases PASS: Catalogue workflow, channel, Catalogue archive, Product archive, inactive membership, membership removal, inactive Event assignment and removed Event assignment.
- **The full runner did not complete.** After Chris challenged the disproportionate delay, the agent deliberately stopped its B1 child during the remaining legacy matrix. It exited non-zero due to interruption. Future/expired Event availability cases, later selection/context/timeout coverage and the subsequent A7 run are **not claimed for this candidate**; existing older evidence is historical only. Complete or explicitly assess this remaining coverage during separate promotion review. No further broad rerun was started.
- The parent completed cleanup and independently verified absence of `fund_b1_disposable_afea8de2c139f044`. No application database was used or reset.
- Prior run passed the new preparation/commission/Seller checks, then correctly refused the test fixture’s attempt to change a finalised Project. The fixture now establishes that legacy state before finalisation; no application integrity check was relaxed. Failed runs removed their dedicated databases and verified absence.
- Self-review corrected inactive Product memberships incorrectly contributing to readiness and protected legacy finalised selection during default initialisation. No separate reviewer attestation is claimed.

The synthetic Standard publication fixture exercises server authority/atomicity only; it
makes no provider call and does not prove public FUND selling or enable Individual release.
The database runner recorded verified deletion after the deliberate interruption. Application databases,
local test data, staging and live remain untouched.

## Chris's Short Local Smoke — PASS, 17 September

Use the local candidate, not current staging. Keep VAT A0/A/B PASS; do not repeat that whole
matrix. Use a fresh unfinalised Individual Project with an active Client, eligible active
Catalogue/Products and a C1-assigned Individual template with sufficient capacity. Leave the
old archived wf1 alone. Existing artwork emulation settings remain necessary; no new runtime
setting is introduced here.

1. **C1 → FUND → FUND setup:** save the intended producer default commission. As the organisation
   Owner, complete genuine Seller details if absent; an existing active Seller remains read-only.
   GBP must match the platform setting. No Stripe setup is needed for the development PDF.
   Edit a Product without photography: a tenant logo or neutral placeholder appears automatically. **CHRIS 17-09-2026 - PASS**
2. **C1 → Event → Commission:** keep the producer default or save an optional dated ladder. **CHRIS 17-09-2026 - PASS**
   Create one Event-linked and one standalone Project through supported screens. **C2 → Products /
   Store** should show the eligible included Products, VAT-inclusive prices, images and the right
   inherited flat rate/complete ladder. No separate commission offer needs creating or accepting. **CHRIS 17-09-2026 - PASS**
   **Do not tick the launch confirmation or attempt Launch Store for this preparation step. - Chris Noted!!**
   Commission acceptance is saved atomically with publication, which remains unavailable for
   Individual Artwork. Its absence does not block template preparation. **NOTED**
3. Leave **Remove Products** off on one Project. On a second unfinalised Project enable it,
   remove one Product, then refresh Store configuration. The removal persists and the remaining
   Products alone determine readiness. Changing C1 defaults before publication is picked up
   by Store refresh, including when the Project start date is already in the past. **CHRIS 17-09-2026 - PASS**
4. **First, as C1:** open **FUND → Projects → the Individual Project**
   (`/app/fund/projects/[projectId]`, not the `/client/projects/` route). The **Individual offer
   and artwork** panel is above the Overview/Products tabs. Choose a Template with sufficient
   capacity. For standalone Projects choose **Assignment → Tenant standalone default** and
   **Save template assignment** to establish the reusable default; **This standalone Project**
   is available for a specific assignment. Event-linked Projects use **Save Event assignment**.
   C2 does not assign the underlying template.

   Then, as the exact C2 organiser, return to **Project → Store**, refresh Store configuration
   and offer, review/finalise and download. Use an Individual Project whose opening date is in the future but
   whose Event/Catalogue availability permits preparation. Refresh/review/finalise and download
   its **labelled development PDF**. No commission acceptance, Store publication or live Stripe
   onboarding is required. Re-download preserves the evidence and Product removal is locked. **CHRIS 17-09-2026 - PASS**
   This tests preparation; do not distribute this emulator PDF to classrooms. **CHRIS 17-09-2026 - PASS**
5. Confirm readiness explains the future opening date and the unfinished Individual release
   honestly. One combined Store/commission launch confirmation is visible; publication remains
   unavailable while those real prerequisites are absent. Do not try to complete a public
   purchase or report an end-to-end Store launch PASS for this increment. **CHRIS 17-09-2026 - PASS**

Record PASS/FAIL beside steps 1–5 with any concrete message. Do not change dates or reset data
merely to test commission locking; automated fixtures cover that boundary. A normal opening
date may be used if a future-dated test Project is inconvenient, recording step 4's date
boundary as automated-only.

## Next Action And Limits

Chris has completed the local preparation demonstration, including finalisation and download
of the labelled development data preview. Separate review must address the
explicitly unfinished regression coverage before promotion. Then follow the existing real-artwork
release/public Store/purchaser dependencies. The actual classroom printable template is still
required before operational circulation. No new planning layer or public launch smoke is
needed until those outputs exist. B1 stays open; root B1 Now / 1R-G planning Next is unchanged.

Local preparation acceptance is recorded above. Staging/environment proof and release acceptance remain pending; main/live is held. Any later
promotion must include the compatible B1-R3 VAT schema and exact-candidate checks. Existing
Orders and accepted/finalised evidence must survive; recovery is a compatible forward fix,
not deletion or replacement of that evidence.

## 17 September — Smoke Blocker Clarification

Chris reports standalone commission inheritance working, but the launch checkbox leaves
Launch Store disabled, and the C2 page offers no template assignment. The supplied screen
reports five selected Products and no assigned Individual template. Source review confirms
that commission acceptance is not a preparation prerequisite and template assignment is
C1-only, with both standalone Project and tenant-default scopes already implemented. The
smoke instructions omitted the concrete C1 assignment route; steps 2 and 4 above now clarify
it. Existing human PASS annotations are retained. Chris subsequently set the standalone default, finalised the offer and downloaded the
development data preview, then marked steps 1–5 PASS. This resolves the preparation blocker.
The repeated confusion about the disabled launch control remains usability feedback for
release work; this PASS does not demonstrate publication or a classroom-ready print layout.
No application-code, agent database or permission change was needed for this resolution.
