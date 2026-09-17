# FUND — Simple Store Preparation Review And Smoke

Date: 2026-09-17

Status: **Local human and technical checks PASS. Exact candidate d13ecb39 promoted to dev/staging; both security scans and staging migration/data preservation PASS. Render web/cron deployment and health PASS; staging human acceptance PASS; live configuration prepared; main promotion held.**
Control depth: **High**.
Exact candidate: `d13ecb39fdf592e3a555f96ae64c9763ff73ae16`, consolidated through local dev and staging and pushed to both origins on 17 September; deployment verification follows below.
[Plan](../03-slice-planning/2026-09-16-fund-phase-1-launch-preparation-planning.md)
· [Implementation](../04-implementation-confirmations/2026-09-17-fund-simple-store-preparation-implementation-confirmation.md)
Application behaviour is `3820e304`; `9c09cbe1` only moves the legacy test fixture before finalisation. Its commit hook type check passes. `d13ecb39` adds only the focused regression runner; application behaviour is unchanged.

## Automated Evidence

- 601 unit/regression tests PASS; 12 skipped. Command: `npx vitest run --exclude scripts/proofs/fund-1r-f-a/proof.test.ts`. That existing Chromium proof is excluded after sandbox browser-start failure; no new browser rendering proof is claimed.
- TypeScript, critical-file verification and isolated production build PASS. Changed source/test lint: zero errors, five pre-existing EventDetailPage warnings. No clean whole-repository lint claim.
- Connected candidate `9c09cbe1`: fresh 157-migration replay and exact checksums PASS. New simple-preparation checks PASS: zero/default/Event inheritance, reuse of legacy policy owners, stale terms, failed-launch rollback, concurrent/repeat launch, first-publication lock through pause, optional Product exclusions, effective image snapshots, pre-opening preparation and Seller authority.
- B1-R3 connected rate/default/override/C2/foreign/concurrency checks PASS. Later source VAT edit and Store refresh preserve the finalised offer and downloaded PDF bytes, including the legacy Project initialisation fixture: PASS.
- Eight existing availability/finalisation concurrency cases PASS: Catalogue workflow, channel, Catalogue archive, Product archive, inactive membership, membership removal, inactive Event assignment and removed Event assignment.
- **The full runner did not complete.** After Chris challenged the disproportionate delay, the agent deliberately stopped its B1 child during the remaining legacy matrix. It exited non-zero due to interruption. Future/expired Event availability cases, later selection/context/timeout coverage and the subsequent A7 run are **not claimed for this candidate**; existing older evidence is historical only. That gap is subsequently closed by the focused continuation recorded below; the interrupted run itself remains incomplete. No further broad rerun was started.
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
of the labelled development data preview. The focused technical review and previously
unfinished regression cases now pass. Next is controlled staging/environment validation of
this preparation candidate, retaining migration 157 and the recorded human passes. Follow the existing real-artwork
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

## Focused Technical Review — 17 September, After Local Human PASS

Chris authorises completion of the outstanding review and regression coverage. Application
behaviour remains `3820e304` / candidate `9c09cbe1`; this pass changes test tooling only.
Review is a separate source-review pass by the implementing assistant, not an independent
second-reviewer attestation. B1 remains open and main/live is held.

| Boundary reviewed | Finding |
| --- | --- |
| Tenant and role authority | C1 settings remain tenant-scoped; C2 Project access resolves Client membership before Store operations. Seller writes require the actual Owner and refuse impersonation. No new authority bypass found. |
| Commission and launch | Unpublished terms inherit current defaults; accepted historical terms and first-publication terms are preserved. Launch rechecks reviewed terms/content and authority inside the transaction; failed publication rolls back acceptance and Draft activation. |
| Frozen offer and Order evidence | Refresh retains finalised Product/configuration references; changing defaults does not reprice accepted evidence. Seller setup refuses active or Order-referenced identity changes. No schema or historical-data rewrite is introduced. |
| Preparation and release | Template finalisation does not require launch acceptance/payment setup or an elapsed opening date. The Individual development-release refusal remains intentional. The human difficulty finding C1 defaults and interpreting disabled launch is retained as usability feedback, not a false publication PASS. |

No new blocking application defect was identified in this bounded source review. The
remaining connected evidence was collected with
`node scripts/run-fund-b1-r3-disposable-tests.mjs --remaining-launch-review`. This mode reuses
the original assertions but selects only future/expired Event availability plus the unfinished
selection, refresh, checkout refusal, timeout/retry and Project-context cases, followed by A7.
It uses a minimal isolated fixture, prints safe progress and limits the focused child to six
minutes and A7 to two minutes. Existing application-database refusal and verified cleanup
remain mandatory. **PASS at `d13ecb39fdf592e3a555f96ae64c9763ff73ae16`**, exit code 0. Both remaining
Event-date cases, selection/refresh locking, checkout refusal without provider/Order side effects,
timeout rollback/retry, context locking and stale-context refusal pass. Commerce A7 confirms
atomic Order aggregate creation, FUND-owned idempotency/replay, unchanged 157-migration
inventory and zero fixture residue. The parent removed `fund_b1_disposable_d32f9435ab3f7514`
and independently verified absence. TypeScript and runner syntax/whitespace checks pass.

This completes the explicitly interrupted regression coverage using the earlier eight-case
PASS plus this focused continuation on unchanged application source. The earlier 601-test,
build and human evidence is retained rather than redundantly repeated for test-only changes.
No new blocking finding was identified by the separate technical review pass. No application
code, database schema, runtime configuration, application fixtures or provider state changed.

Earlier completed tests and Chris's local smoke remain valid; there is no repeat of the
whole VAT/preparation/Catalogue matrix, no new planning document and no promotion in this pass.

## 17 September — Controlled Staging Promotion

Chris requested staging validation and documentation publication, with a view to aligning
through main before SeasonPro remedial work. Candidate `d13ecb39` is fast-forwarded through
local dev and staging and pushed to both origins. Dev Security Scan `35201013522` PASS.
No application source change or repeat of the accepted local smoke was needed. Documentation
through `f0eecc5` is published to IsoDocs main. Main/live remains `0397bba9` pending the
staging human result and explicit live-promotion approval required by the Git workflow.

The staging bundle contains five commits since `e7e8837c`, including platform VAT defaults
and Pulse consumers, FUND VAT-inclusive prices and simple preparation. One additive migration,
`20260916120000_fund_b1_r3_explicit_vat_rate`, takes staging from 156 to 157 unique migration
names. Render's existing `npm run render-build` runs Prisma migrate deploy before replacement.
The staging web service is `Staging-IsoStack` (`srv-d4miroogjchc73balrvg`); its cron is
`isostack-bedrock-1` (`crn-d6t7bpf5gffc738vlcn0`). Both target the verified staging database.
Artwork emulation remains staging-only in the intended deployment contract. The cron does
not consume it. No new runtime variable or external provider is introduced by this bundle.

Preflight: staging contains one Event, one Project and no FUND Order contexts. Production
contains no rows in any of its FUND tables and has 153 unique applied migration
names; its later promotion therefore includes all four B1/R1/R2/R3 migrations. No reset,
seed, data reclassification or evidence deletion is authorised or necessary from these
counts. Private hashes cover all 51 staging and 50 production FUND/Commerce tables.
Historical ledgers contain repeated entries and 23 old checksum differences, all against
SQL unchanged from the respective deployed branch; those are not new candidate drift and
are not repaired here. Only the new migration checksum is claimed exact in deployed proof.
Fresh disposable replay/checksum proof for the complete source remains separately recorded.

**Live configuration correction required before main:** authenticated provider readback found
`FUND_INDIVIDUAL_ARTWORK_MODE=emulated` and `FUND_INDIVIDUAL_ARTWORK_TARGET=staging` on production
web service `app` (`srv-d4t6l16uk2gs73ejugg0`). The main-branch guard refuses emulation, but
these settings are still invalid for live. During the authorised live promotion set that
service only to `disabled` / `production`, verify effective readback, and leave staging and
shared groups untouched. Production cron `isostack-bedrock` (`crn-d610l04r85hc739h10e0`) uses
the production database and has neither artwork setting. No live setting changed in this
staging step.

Recovery after RATE_SPECIFIED writes is a compatible forward fix. Do not roll back to a
binary that cannot read those enum values, reverse migrations, delete accepted offers or
replace Order evidence. If migration/build fails, stop promotion and inspect exact failure;
retain the previous serving deployment. B1 remains open; root B1 Now / 1R-G planning Next
is unchanged. This deployment does not release public FUND selling or classroom artwork.

### Short Staging Human Check — PASS, Chris 17 September

After exact deployment verification, use https://staging.seasonpro.co.uk:

1. **SeasonPro:** login/logout, correct Client/dashboard, existing images and one reversible
   edit. This is the shared-app regression check before resuming SeasonPro work. **CHRIS 17-09-2026 PASS**
2. **P1/C1:** confirm Platform Settings shows the VAT default; a new FUND Product starts with
   it and permits an override. Confirm an existing Product price is retained, and its editor
   shows its real image or automatic placeholder. Check FUND setup/commission loads. If Pulse
   is in use, open a new quote and confirm its VAT default; otherwise record not applicable. **CHRIS 17-09-2026 PASS**
3. **C2:** on one fresh unfinalised test Project, confirm included Products, gross prices,
   images and inherited commission; optionally remove one Product and refresh. With a C1
   template assignment, finalise/download the labelled development preview. An existing
   finalised Project remains locked and re-downloads. Individual Store publication remains
   unavailable. No public purchase or classroom print acceptance is requested. **CHRIS 17-09-2026 PASS**

Record the three results here. Existing local detailed matrix PASS remains accepted; only
staging's representative path and environment-specific behaviour need human confirmation.

### Staging Database Readback

Migration 157 completed through the Render build. Its recorded checksum matches the exact
candidate SQL; both RATE_SPECIFIED enum additions are present, and the scalar platform VAT
read returns 20. All 51 FUND/Commerce table counts and content fingerprints match the private
pre-deployment baseline. No existing data or financial evidence was rewritten. The local
DevData test bed is untouched. Web/cron deployment and human checks remain pending at this
readback; migration completion alone is not deployment acceptance.

### Final Staging Technical Result — PASS

- Web `dep-dalqga0u01pc73fkc0gg`: Live at exact `d13ecb39`, provider updated
  2026-09-17T08:50:10Z. Cron `dep-dalqga8u01pc73fkc110`: Live at the same commit,
  provider updated 08:48:44Z.
- Exact GitHub dev/staging Security Scans `35201013522` / `35201206533`: PASS,
  including secret detection, dependency audit, TypeScript and schema checks.
- `staging.seasonpro.co.uk`, `staging.isostack.app` and `sating-isostack.onrender.com`:
  HTTP 200 healthy, database connected, RLS 11/11; placeholder bytes match the committed
  SVG; signed-out `fund.launchSettings.commission` returns 401 on all three.
- Initial default Python-user-agent probes returned 403. Retest with a browser user agent
  passed on the same endpoints; no application change was made to obtain that result.
- The bounded post-deployment web/cron log window contains no Prisma validation,
  missing-schema, emulation-refusal or `Error:` matches. This is limited runtime evidence,
  not an authenticated business smoke or a guarantee of zero errors.
- The three human checks above remain **pending**. Main branch, production database and
  live configuration remain unchanged. No live promotion is claimed.

Before live, refresh the production baseline; correct only the live web artwork settings;
verify production web/cron database identity; obtain the recorded staging acceptance and
explicit main authority; fast-forward local main from the accepted staging candidate and
push normally. Monitor exact web/cron deployment and all four migration checksums, preserve
existing Commerce evidence and run the minimum non-destructive SeasonPro live check.
The source/old-binary compatibility boundary prevents returning to the old binary after
RATE_SPECIFIED writes. Stop on any unexplained migration/data difference rather than reset.

### Live Configuration Preparation And Staging Acceptance — 17 September

Chris marked all three staging checks PASS and authorised non-destructive configuration to
enable main promotion. His annotations above are retained. This completes staging human
acceptance of this preparation bundle; B1/public selling/classroom artwork remain open.

Updated only production web service `app` (`srv-d4t6l16uk2gs73ejugg0`) through Render's
individual-variable API:

- `FUND_INDIVIDUAL_ARTWORK_MODE=disabled`
- `FUND_INDIVIDUAL_ARTWORK_TARGET=production`

Independent API readback verifies both saved values. Full before/after service variable
comparison proves every other production web setting unchanged, including the database;
staging web and production cron variables are identical to their respective baselines.
Production web/cron target the verified production database, distinct from staging. No shared
environment group, credential, application code or database was changed.

The API update did not start a deployment. These saved settings take effect on the next
deployment; no claim is made that the currently running process reloaded them. Live remains
`0397bba9`, deployment `dep-dahb2jpt0dsc73fb70i0`. After the update, production health is HTTP
200, database connected, RLS 11/11. Staging remains the accepted `d13ecb39`.

Ready for explicit main-promotion approval under `docs/guides/git-workflow.md`. That step
must deploy the accepted candidate with all four committed migrations, verify effective
live configuration/deployment and preserve existing Commerce evidence. No main push,
redeploy, migration or data reset was performed by this configuration request.
