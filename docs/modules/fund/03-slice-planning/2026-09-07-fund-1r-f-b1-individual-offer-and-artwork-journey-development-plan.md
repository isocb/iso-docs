# FUND 1R-F-B1 — Individual Offer And Artwork Journey Development Plan

Date: 2026-09-07

Status: **Accepted preparation and SeasonPro releases preserved. Connected accepted-PDF local implementation complete at `e8a3c900`; automated proof PASS; 18 September PDF checks 1 and 2 PASS. C1 instruction input-to-PDF human check remains pending. B1 remains open; no new promotion.**

Control depth: **High** — this journey introduces persistent offer evidence, exact C2
finaliser authority, tenant-bound document access and failure/retry behaviour.

Work type: plan for a production-model build, initially proved through an emulated
local/development journey. Simulated service responses are test infrastructure; the offer
model and application behaviour are persistent. The authorised 17 September continuation
connects the accepted layouts locally and proves its migration on disposable databases only.
Retained/shared database changes, provider setup and environment promotion remain outside it.

Owning inputs: the accepted `1R-F` parent and its existing Application/Artwork Template and
Product-selection/capacity CRs; this is their bounded development child, not a new CR.
The enduring [1R-F-B framework](../00-roadmap-control/2026-09-07-fund-user-framework-and-individual-artwork-delivery-principles.md)
augments the [FUND roadmap](../00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md).
[Root control](../../../00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md)
restores FUND B1 resumption at the accepted preparation release boundary as Now, with the existing
1R-G planning proposal Next. This plan owns the sole active restart checkpoint.

## 18 September — Required C1 Authority Correction In Next Planning Cycle

Chris's [owner instruction](../01-cr-inputs/CR-Fix-2026-09-18-fund-c1-proxy-authority-and-project-artwork-files.md) corrects D2: C1 must manage Client/Project inputs and
finalise directly on behalf of the Client using C1 authority. C1 need not become a C2 member
or impersonate the organiser. Retain the normal C2 route, record actual actor and represented
Client, and preserve the exact confirmed offer, readiness, lock and financial evidence.

This is an accepted requirement and outstanding implementation gap in both the released
foundation and candidate `e8a3c900`. The next B1 planning cycle must inspect C1 CRUD input
coverage, finalisation service/API/UI, member-based persisted finaliser evidence and affected
tests, then define the compatible correction and focused proof. Control depth remains High.
No application/schema change is authorised by this planning amendment. Historical PASS is
preserved at its tested boundary and must not be described as C1-proxy acceptance.
Collective proxy approval and the deep-linked Artwork & Files tab belong to the existing
collective parent; do not silently add their implementation to the Individual PDF increment.

## Restart Checkpoint

```text
Current state: Owner accepts C1 finalisation/proxy authority correction for the next planning cycle; current application still has the superseded C2-only restriction. Local accepted-PDF integration implemented at e8a3c900; automated migration/service/render/UI/artifact checks PASS. Chris accepts PDF checks 1 and 2 PASS, including portrait/no-logo, and confirms all handwritten fields present/correct. His outstanding input check concerns the C1 notes above/below the QR. B1 Now / 1R-G planning Next is unchanged; operational classroom distribution and public selling remain unreleased.
Last proven commit: e8a3c900931ae4c28cba04181c2cd00722710ad7, backed up on origin/feature/fund-accepted-pdf-integration. Prior FUND d13ecb39 and SeasonPro c3998084 releases retain their accepted evidence. No accepted release smoke was repeated.
Current environment: Candidate remains on its work branch before dev consolidation. Workspace returned to clean dev; dev/staging/main and all three origins remain c3998084. The new 158th migration was proved only on disposable test databases, which were removed and independently verified absent. Retained DevData/online databases and runtime settings were not changed; production remains at its previously verified 157-migration release.
Next human decision/test: review the bounded C1 authority correction in the next B1 planning cycle before implementing it. The separately pending input smoke remains: prepare the existing C1 Artwork defaults editor-to-PDF smoke on an isolated candidate test target with a fresh unfinalised Project. C1 saves distinct notes in Artwork instructions (above QR) and Ordering instructions (below QR); verify persistence, C2 review and the resulting PDF. This human editing check was not possible from static PDFs and remains pending. Do not repeat accepted layout/handwritten-field checks.
Safe resumption point: Plan the 18 September C1 correction using the linked input and preserve existing evidence; no code or database authority is created by it. Resume PDF work from candidate e8a3c900 and the existing B1 04/05 evidence. No portrait-logo change is required. Preserve old immutable offers/PDFs and the accepted 1/2 PASS. Prepare only an isolated local test target with recorded cleanup; retained/shared migration and promotion remain outside this increment. Durable Store destination and private runtime/storage decisions remain later dependencies. The OOM incident stays separate.

```

## 17 September — Accepted PDF Integration Review And Proposed Next Boundary

Status: **Bounded local implementation authorised by Chris on 17 September; implemented at `e8a3c900`, automated proof PASS; 18 September PDF checks 1 and 2 PASS; C1 instruction-editing human check pending.** This refines the existing B1/1R-F work and coordinates its existing
1R-G dependency; it does not create another lifecycle, checkpoint or portfolio selection.
Control depth remains **High**: immutable offer/document evidence, tenant download access,
a compatible SQL constraint change and the later private-runtime contract are involved.
This is planning for a persistent product capability, not a repeat of the closed assumption test.

### Preserve the work already accepted

The detailed portrait and landscape PDFs have not been lost or superseded by the simple
B1 download. Reuse `scripts/proofs/fund-1r-f-a/template.tsx`, `renderer.ts`, the versioned
fixture contract and `accepted-local-evidence.json`. The final
[R1B source-fidelity record](../05-review-and-test/2026-08-11-fund-phase-1-slice-1r-f-a-r1b-source-fidelity-and-folding-local-gate.md)
records 12/12 human checks PASS, actual-size portrait/landscape printing, folding and QR
scans. The later Linux and completed Stage C-R1 results remain evidence at their recorded
boundaries. Temporary provider resources were removed; no production service survives that proof.
The generated maximum-capacity portrait/landscape PDFs also remain in the ignored local
`output/` directory. Source and accepted evidence, rather than ignored files, are the durable assets.

The unchanged designs retain portrait STANDARD / ten Products and landscape COMPACT /
twelve Products, blank child/class and Order Code fields, separate instructions, folding
geometry and artwork area. No template editor or layout redesign is proposed.

### Smallest useful demonstration

From the existing Project flow, C2 finalises a **new** controlled Individual offer and
obtains the approved detailed PDF populated from that offer. The PDF can be opened and
printed at actual size; its content and prices match the confirmed Project. Preparation
works before Store opening, without commission acceptance or payment-provider activation
becoming print gates. Existing Seller identity/currency and content checks still apply.

The first implementation recommendation is local integration with a bounded separate renderer
process and private local storage. It proves the connection between the existing application
and accepted layout. It is not permission to distribute development sheets in classrooms.
Real classroom distribution additionally requires the operational gates below. Keep the
existing authenticated download UI; do not add a separate purchaser-preview screen first.

### Source findings and proposed contracts

Review baseline: `c3998084`. The proposals below were subsequently implemented at `e8a3c900`
within the local/disposable boundary; the existing [implementation](../04-implementation-confirmations/2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-implementation-confirmation.md)
and [review with human smoke](../05-review-and-test/2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-review-and-test.md#18-september--human-acceptance-and-c1-instruction-input-check) record actual results.

| Boundary | Current source | Proposed integration |
| --- | --- | --- |
| PDF generation | `individual-offer.service.ts` invokes `renderDevelopmentOffer`; the emulator explicitly omits logo imagery and print layout | Adapt the accepted detailed renderer; retain the v1 emulator for existing offers and use explicit version dispatch for new finalisations |
| Content | B1 captures selected Product titles/order/gross prices, but the proof also expects Product codes, Project number, two instruction regions and a template title | Resolve and freeze these additional inputs at finalisation; use existing Product codes and Project number, fixed template copy and reusable C1 instruction defaults. Never read mutable Product text while regenerating |
| Branding | The proof's accepted logo is C1; B1 currently stores a C2 Client logo reference | Preserve the accepted C1 logo rule for the new contract. Freeze validated image content/hash, not merely a mutable URL; retain the deliberate no-logo layout. Do not change old snapshots |
| Store identity | `FundProjectStore.publicId` already exists; the current snapshot requires `store.example.invalid` | Reuse that public ID with one server-controlled canonical Store address; never derive printed origins from request Host or use an expiring signed address |
| Preservation | One immutable offer per Project and one immutable document identity/output hash per offer | Existing finalised Projects keep their v1 data/PDFs. New contracts apply only to future finalisations. No bulk conversion, ordinary unlock, replacement-offer UI or reinterpretation of old bytes |
| Database constraint | Migration `20260907120000_fund_b1_individual_offer` restricts `b1_document_contract` to `EMULATED` and `fund-b1-emulated/v1` | A small reviewed follow-on migration must admit the explicit new local render contract while retaining v1 and all status/hash/identity guards. Do not edit the applied migration, drop immutable triggers or permit arbitrary provider/contract strings |
| Generation/storage | Existing dependency seams, lease/attempt tracking and private local files are available; both put/get and generation impose a 256,000-byte limit | Reuse orchestration; measure detailed-PDF sizes and set bounded limits from evidence. Isolate Chromium from the web request process, bound concurrency/time/memory, recheck access, verify stored hashes and clean failed attempt files |

The new snapshot needs a versioned schema. Existing JSON storage may accommodate its fields;
the SQL constraint still requires a migration regardless. Review any further schema need
before expanding the boundary. Prices reuse the accepted gross-price resolver and immutable
configuration references; do not reopen VAT or commission calculations.

Instruction defaults should be configured once at C1 and inherited, with two sanitised text
regions matching the approved design. Missing required copy produces a useful preparation
message, not fixture text silently treated as real client instructions. Keep child identity
blank for handwriting and avoid collecting child data for generation.

### Operational gates before real classroom distribution

1. **Durable destination:** recommend one canonical route derived from the existing Store
   public ID, with the actual host/path agreed before any distributable PDF is finalised.
   Scanning before opening must reach a truthful non-selling page. Unknown, archived or
   disallowed Stores must not expose private Project, offer, child or contact data. The same
   printed URL must later resolve the released Store. This narrow destination dependency
   belongs with the existing 1R-G plan; it does not authorise full checkout or publication.
2. **Retained private document:** the completed temporary worker/R2 proof is not a production
   operating model. Before deploying, specify the isolated renderer owner/runtime, bounded
   jobs/retries, authenticated same-tenant download, private storage and credential boundary,
   retention, recovery and monitoring. Prefer the proven architecture where suitable, but
   do not reuse its revoked credentials or substitute public media/email-attachment storage.
   No new service, bucket, credential or runtime setting is created by this plan.
3. **Truthful release:** versioned local proof stays development-only. A later accepted real
   renderer/provider contract must distinguish operational output from emulation without
   changing old evidence. Printable availability must not automatically publish a Store or
   remove the unconditional Individual development-only trading blocker. Public presentation,
   purchasing and Order correlation remain separately bounded dependencies.

### Focused proof and recovery for the proposed implementation

First prove the compatibility migration and old/new contract behaviour in a disposable
database. Applying it to retained DevData or an online database needs the specific target
and existing safe-database workflow; no reset/seed or live-data work is included here.

Reuse the accepted layout fixtures and compare integrated output for unchanged geometry,
fonts, Product order/prices, fields and QR text. Add tests for missing instructions/logo,
unsafe assets/HTML, over-capacity, stale finalisation, foreign tenant/member access, duplicate
attempts, timeout/oversize and file loss. Verify old snapshots/document hashes remain unchanged
and regeneration uses the correct renderer version. Do not repeat the entire accepted FUND
or SeasonPro smoke. Human proof is one representative integrated Project PDF and its printed
QR/content; broaden physical checks only if renderer/layout/runtime changes warrant it.

If new generation fails, leave a truthful failed/pending document and preserve the confirmed
offer for bounded same-version retry. Never fall back to an emulated PDF labelled as real.
After new-contract evidence exists, recovery is a compatible forward fix or disabling new
generation while retaining download support; do not roll back to a binary unable to read it.

### Value, cost and decision

This delivers the PDF Chris already approved through the existing user journey. It adds no
C2 setup or acceptance screen; C1 supplies reusable instructions once. The extra work is the
versioned adapter, immutable content/assets, compatibility migration and bounded generation.
A cheaper separate purchaser preview would leave the classroom print gap unresolved; rebuilding
the design would discard accepted value. Production worker/storage adds ongoing operating
cost and must be made concrete before its separate deployment decision.

**Accepted implementation authority (17 September):** Chris requested implementation, lifecycle
updates and a human smoke test after reviewing this proposal. Implement only the bounded local
integration and disposable migration proof above, then stop for the integrated-PDF review and
operational decisions. No infrastructure purchase/deployment,
shared database migration, public Store release, payment, Order-code allocation, email send,
OOM remediation or historical-document replacement is included.

## 1. One Visible Outcome

For an existing Individual Artwork Project with a valid organiser and eligible Products:

```text
C1 chooses one validated template variant for the Event/standalone assignment
-> C2 sees the selected Products and capacity feedback
-> C2 previews the exact offer
-> the authorised organiser finalises it
-> generation shows pending, failed or available for that offer
-> authorised C2 downloads the matching development artwork document
-> the Project Store preview shows the same confirmed Products/prices
```

Before: existing users can manage Projects and Stores, but cannot complete that connected
Individual offer/document journey. After: they can exercise it on controlled test data,
with clearly labelled emulated service evidence and without opening public trading.

The first implementation gate ends at the local automated and C1/C2 human result. A later
explicit promotion may prove the same emulated journey on development staging. A real
production renderer/storage deployment remains a separate operating decision. Neither
successful download nor this slice's artwork status publishes the Store.

## 2. Four Accepted Business Decisions

Chris accepted D1–D3 in this document and confirmed D4 in conversation on 2026-09-07.
These decisions settle B1's business scope. The four-record technical proposal and
environment contract still require technical review; the business questions need not be
asked again.

| Decision | Accepted B1 boundary | Consequence | Owner response |
| --- | --- | --- | --- |
| D1 — Initial template choices | C1 selects from the two already proved variants: portrait STANDARD, maximum ten Products; landscape COMPACT, maximum twelve. Use a versioned code registry for these fixed designs, with persisted tenant-owned assignment | No visual editor, arbitrary template upload or full reusable-template administration in B1. A future changed variant needs its own capacity/layout proof | Accepted: fixed templates initially; template editor in Phase 2 |
| D2 — Assignment and finalisation | Event-linked Projects follow the Event assignment; standalone Projects use an explicit Project assignment or the tenant standalone default. Authorised same-Client managers/admins prepare selection; normal C2 finalisation and authorised C1 finalisation on behalf of the Client must both be supported | Record the actual C1 operator and represented Client without impersonation; retain assignment/readiness/lock controls | Corrected by Chris, 18 September; implementation pending |
| D3 — First release revision rule | Before finalisation, allow normal edits. After finalisation, refuse changes to the confirmed Project offer/selection; allow controlled regeneration of that same offer only | No unlock or replacement-offer UI in B1. Explain the lock before confirmation; a mistaken finalisation is a visible limitation, not an excuse to alter history or delete data | Accepted |
| D4 — First development result | Implement the complete flow above using deterministic renderer/private-file emulators, authenticated Project download and a Store preview. Use existing test Projects and synthetic representative Products | Emulated documents visibly say “Development preview — not for distribution”. Real production rendering/storage and physical distribution are not proved by B1. Public Store, payment, Order and operational slices remain required in Phase 1, after B1 | Accepted following clarification of Phase 1 versus B1 |

Owner response provenance:

- D1: “Accepted with caveat. Fixed template with editor to be phase 2 development.”
- D2 and D3: “Accepted.” D2 finaliser restriction was subsequently corrected by Chris on 18 September as recorded above.
- D4 initially requested clarification because Public Store/payment/Order operations are
  required in this phase. The final response was: “Retain B1 with purchaser and operational
  slices in phase one but not B1 specifically. Accepted.”

B1 is the first bounded delivery slice within Phase 1. Phase 1 continues through the
purchaser journey, payment/Order operations, artwork matching, production, dispatch and a
calculated/finalised commission statement; settlement remains later. The template editor
belongs to Phase 2. Neither these later Phase 1 slices nor Phase 2 is selected as root Next
by this acceptance.

The code registry preserves design identity/version without requiring the former ten-table
option. The accepted development document is intended to prove the confirmed content and download flow;
production print suitability and actual provider operation require their own evidence.

Delivery mode, purchaser options/media, Intake and outbound-message choices for the full
Phase 1 smoke are **not blockers to drafting B1**. B1 adds no buyer checkout, fulfilment,
Intake path or email. The [business situation report](../00-roadmap-control/2026-08-25-fund-complete-module-smoke-readiness-business-overview.md)
retains those later decisions. Existing delivery-profile/commission/Store blockers must
remain visible even though B1 does not resolve them.

## 3. Inspected Application Foundation

Read-only inspection at `14077382` found 153 migration directories; this is a source count,
not an assertion about a connected database's migration ledger. These existing files own
the behaviour to extend, with paths relative to `isostack-bedrock`:

| Existing source | Reuse / observed gap |
| --- | --- |
| `prisma/schema.prisma` — `FundProject`, `FundProjectProduct`, `FundProjectStore`, `FundProjectStoreProduct`, `FundStoreProductConfigurationVersion` | Reuse tenant/Project identity, the one Store per Project and immutable commercial/configuration versions. No Application Template, Project Offer or Artwork Template model currently exists |
| `src/modules/fund/services/client-dashboard.service.ts` and `routers/client-dashboard.router.ts` | Reuse Client-member context and Project/Store/Product operations; add organiser-only finalisation checks without turning the C2 account into a new Project owner |
| `src/modules/fund/services/projects.service.ts` | C1 Project/Product add/remove/active/order paths exist and also need confirmed-offer mutation protection |
| `src/modules/fund/services/store-management.service.ts` | Reuse `getStoreForProject`, `refreshStoreConfiguration` and transactional Store mechanisms. `deriveFundStoreReadiness` currently checks existing Store gates; Individual offer/document readiness must be composed into this policy, not become a parallel Store state machine |
| `src/modules/fund/services/store-authority.service.ts` | Existing Store authority is consumed by operations and must remain authoritative; no browser readiness flag may publish a Store |
| `src/modules/fund/components/projects/ProjectDetailPage.tsx`, `ProjectProductsManager.tsx` and `components/client-dashboard/ClientProjectStorePanel.tsx` | Add narrow assignment/offer/status controls to existing Project surfaces; no dashboard replacement |
| `scripts/proofs/fund-1r-f-a/contract.ts`, `template.tsx`, `renderer.ts` | Proof uses synthetic inputs, a fixed proof-logo identity, a non-routable `store.example.invalid` URL and local output paths. It is not a ready-made production renderer or URL/branding contract |

The proof validates ten/twelve-row capacities for its exact variants and already-resolved
GBP gross-price strings. B1 must resolve prices from existing commercial authority; never
turn the proof's sample prices, logo identity, URL or fixture IDs into business defaults.

## 4. User And Service Behaviour

### C1 preparation and C2 preview

Add a minimal assignment control using the existing C1 administration shell. Its server
resolves Event/standalone hierarchy; the client never supplies tenant or finaliser identity.
The template registry carries immutable variant ID/version, content hash, orientation,
validated capacity and render-contract version. Availability can change prospectively;
already finalised offers retain their exact variant snapshot.

Start a new selection with every distinct eligible Product, preserving existing defaults.
Show an over-capacity warning without silently truncating it; C2 deselects until one through
the variant maximum remain. Existing Group/Bulk/Standard selection is unchanged.

Preview returns the exact ordered Product/configuration-version references, titles,
resolved gross prices/currency, required Project content, branding inputs and template
contract. Missing required configuration is a named blocker. In emulated mode, a clearly
identified non-trading Store destination is acceptable; it is not a promised public URL.
Use a server-computed input fingerprint to detect changes between preview and finalisation.

### Finalisation and generation

Inside a bounded transaction, re-resolve tenant, active membership, organiser identity,
assignment, selected Products and commercial/configuration versions. Lock/revalidate the
Project using the existing transaction conventions. Reject stale preview or concurrent
conflicting finalisation with a refresh instruction. The same idempotency key and same
request return the existing result; changed input with that key is refused.

Commit the immutable offer and its Product rows atomically before beginning document work.
Generation consumes that persisted offer, never current mutable Product values. A small
persisted claim/lease and compare-and-set completion protect retry/concurrency without a
separate general-purpose job system. Interrupted work can be retried against the same
offer after its claim expires; stale completion cannot replace a newer claim's result.

Record pending/failed/available status, bounded redacted failure reason, input/offer hash,
renderer contract, output hash and byte count. Only a complete matching file may become
available. A failed render/store operation leaves the confirmed offer intact and cannot
satisfy artwork readiness. An orphaned emulator output must be removed by bounded cleanup;
if deletion fails, retain its exact non-secret locator for retry and report the failure.

### Access, preview and existing mutations

Download resolves the session and current Client/Project membership server-side, then loads
the exact offer/document relationship. No bearer grant, public object URL, arbitrary file
path or browser-provided storage key is accepted. Serve a deterministic download with a
safe filename and no shared cache. A lost emulator file shows regeneration required, not a
successful download or a pointer to another document. Same-offer regeneration must
reproduce the recorded deterministic output hash; if it cannot, refuse availability and
report the mismatch instead of changing the established document identity.

The confirmed Store preview consumes the same offer rows and prices as the document. Later
Product edits or Store refresh may create new source versions, but cannot rewrite the
confirmed offer. B1 must protect Project selection, order and confirmed Project content
through every existing C1/C2 mutation path. Upstream Product/branding edits for other
Projects remain possible; the confirmed snapshot stays stable.

Unconfigured Individual Projects gain explicit missing-template/offer/document blockers.
Compose these with existing Store authority/readiness checks, including activation and
publication paths. Do not mark a Project publishable merely because its document exists.
Emulated output must never satisfy readiness for live trading; production-mode validation
refuses it. A7 must still consume canonical readiness and cannot acquire checkout authority
from a B1 preview. Other workflow branches retain their existing policy.

## 5. Persistence Proposal — Four Records, Each Tied To The Journey

These are proposed implementation contracts, not migration authority. Exact Prisma/SQL
must be reviewed against the current baseline when implementation is accepted.

| Proposed record | Minimum purpose and evidence | Former option treatment |
| --- | --- | --- |
| `FundIndividualTemplateAssignment` | Tenant-owned Event, standalone-default or exact standalone-Project assignment to a registry variant/version; actor/time and mutually exclusive scope references | Reusable design identity/version stay in the immutable code registry initially. One active assignment per scope; richer assignment-history UI/table deferred |
| `FundIndividualOffer` | Tenant/Project/Store identity; finaliser and timestamp; idempotency/input hash; pinned registry/render contract; validated Project/branding/content snapshot and destination; immutable commercial offer evidence | Keep the needed offer identity. No editable lock boolean; B1 permits one finalised offer per Project and no replacement/unlock |
| `FundIndividualOfferProduct` | Ordered exact Project Product and Store Product/configuration-version references plus resolved display/price evidence | Retain typed row lineage and exact ordering; reuse existing commercial versions instead of duplicating generic Product/pricing authority |
| `FundIndividualArtworkDocument` | One document lifecycle for an exact offer: generation state/claim expiry, current attempt identity, bounded failure, storage-provider kind/opaque locator, hash/size/render contract | Combine first-document identity and execution status. Once available, output identity is immutable; retry cannot silently change the confirmed offer. Full attempt-history and multi-version administration deferred |

Use tenant-scoped composite keys/FKs for all relations; validate that Store, Project,
Product and configuration-version references describe the same lineage. Enforce assignment
scope uniqueness, unique offer-per-Project/idempotency and ordered non-duplicate offer rows.
Offer snapshots use named, strictly validated schemas rather than unstructured metadata.
Currency/precision follows the current commercial contract. Snapshot fields are immutable;
only document execution fields follow their defined state transitions.

No generic FUND Order/Payment model, access-grant table, duplicate production asset or
unbounded generation-attempt history is introduced. Existing audit records carry actor
operations where appropriate. Test fixtures begin explicitly configured; no inferred
assignments or silent finalisation of existing Projects.

## 6. Emulation And Environment Boundary

Use narrow renderer and private-document-store interfaces with deterministic test adapters.
They must exercise success, refusal, failure, timeout, lost file and retry cases. The
emulated renderer produces a valid downloadable PDF from the confirmed fields, visibly
marked as a development preview; this proves data consistency and delivery interaction,
not production layout, QR or physical-print fitness. Private emulated storage is outside
public assets, tenant-scoped and accessible only through the authorised application path.

Proposed application mode: `FUND_INDIVIDUAL_ARTWORK_MODE=disabled|emulated`, default disabled.
Startup/service validation must refuse emulated mode on the production deployment target;
`NODE_ENV` alone is insufficient because staging also uses production builds. The accepted
implementation must use the repository's actual deployment-target contract, or explicitly
plan a validated target setting if none exists. This configuration is High-control evidence,
not permission to edit any deployed environment in this planning turn.

The disposable test operator owns emulator setup and cleanup; no provider credential,
public bucket, live email or external worker is required. Persisted offer evidence belongs
to the selected database and its recovery contract. Files in disposable emulator storage
are recoverable by same-offer regeneration; record that limitation and test it before any
shared development use. Disablement preserves offers and makes unavailable operations
clear. Actual service adapters, credentials, retention/recovery ownership and environment
parity require a later accepted deployment outcome; completed 1R-F-A provider tests are not
rerun to manufacture B1 evidence.

## 7. Expected Change Boundary And Implementation Order

Keep one bounded lifecycle; the following are implementation steps, not new roadmap slices:

1. Implement the fixed variant registry, preview/capacity rules and service interfaces with
   representative fixtures; review the precise four-record schema and migration.
2. Add one additive migration, typed offer/assignment/document services and transactional
   authority/idempotency/mutation guards; validate on a positively identified disposable DB.
3. Wire C1 assignment and C2 preview/finalise/status/download to the existing Project UI,
   with authenticated transport following current C1/C2 actor-resolution patterns.
4. Add emulated generation/private storage, canonical readiness composition and the same
   offer-driven Store preview; prove failure/recovery, then the local human journey.

Expected application paths: `prisma/schema.prisma`, one new `prisma/migrations/*/migration.sql`,
new focused `src/modules/fund/services/individual-offer*` and `lib/individual-offer*` code,
existing Project/Client/Store services and routers named in Section 3, relevant C1/C2 Project
components, one authenticated download handler, and focused tests/verification scripts.
Exact route and file names must follow current repository conventions; no new public Store
route, generic reporting system or framework-wide refactor is included.

The later implementation must inspect every existing write path named in Section 3 rather
than protecting only the new UI. If that inspection finds a necessary cross-module schema
or authority change outside this boundary, amend the plan before that change.

## 8. Acceptance And Proof

| Proof | Required result |
| --- | --- |
| C1 assignment and C2 selection | Event/standalone hierarchy works; invalid assignment blocks; one/ten/twelve boundaries and over-capacity feedback are exact; unrelated workflow selection unchanged |
| Authority | Wrong tenant/Client/Project, inactive member and non-organiser finalisation are refused; authorised Project viewers/downloaders follow the accepted role contract |
| Stale or duplicate actions | Price/selection/template/organiser changes invalidate stale preview; duplicate identical requests converge; conflicting requests create no partial or second offer |
| Consistency | Offer, Store preview and downloaded PDF agree on ordered Products, prices and content; later upstream edits never silently change confirmed evidence |
| Failure and recovery | Inject render/store/transaction failure, timeout, lost file and concurrent retry; only one valid completion, no false readiness, bounded cleanup and recoverable status |
| Existing-path protection | C1/C2 Project/Product/copy/order mutations cannot bypass the confirmed-offer rule; canonical Store activation/publication and A7 never trust simulated output for real trading |
| Migration | Representative 153-to-candidate and fresh replay preserve existing records; no backfill guesses; tenant/FK/uniqueness and rollback-before-use proven on disposable DB |
| Human local journey | C1 selects variant; C2 sees capacity, previews and finalises; status/error/retry is understandable; matching PDF downloads; remaining Store blockers and development-preview limitation are clear |
| Environment | Emulation disabled by default, production target refuses it, no shared credential/provider use; test fixtures and emulator outputs removed with evidence |

After focused tests, run the relevant existing E-D default-Store, E-C Client-Store, E-A
Store-authority, Store-readiness and A7 regression checks; TypeScript, existing verification,
changed-scope lint and build. Run the normal repository suite once for this High-control
boundary. Do not repeat the completed external renderer proof; real-render extraction or
print-layout changes are outside this emulated first result.

A local pass is not a staging or live pass. If later promoted to development staging, prove
its exact mode/target, isolated database/storage and representative C1/C2 path; do not
mechanically repeat pure tests. Preserve the separate E-B/E-C/E-D human acceptance record:
B1 may supply directly overlapping evidence only when those checks are actually observed.

## 9. Migration, Failure And Rollback

Follow [SAFE_DATABASE_WORKFLOW.md](../../../../SAFE_DATABASE_WORKFLOW.md). Planning does
not connect to any database. After implementation acceptance, create/review a Prisma
migration from the then-current baseline, positively identify the disposable target, and
check its ledger before applying or resetting anything. No ordinary local `DATABASE_URL`
is assumed safe. No shared migration or reset is authorised here.

Stop on existing-data incompatibility; do not guess template, offer or workflow state.
Before persistent use, prove disposable rollback/replay and remove test fixtures. After
accepted evidence exists, disable new actions and use a forward correction preserving
confirmed offers; dropping evidence tables or changing finalised snapshots is not ordinary
rollback. A deployment plan must explicitly reconcile any newly blocked existing
Individual Store before activation; no automatic publication or legacy backfill is allowed.

## 10. Do Not Build And Review Gate

No public Store, checkout/payment, Order Code, artwork/Order matching, production, dispatch,
commission or settlement implementation. No collective/Standard redesign, Intake or
communications expansion. No visual template designer, external access links/email,
ordinary unlock/replacement-offer UI, real provider/worker/storage deployment, secret or
runtime environment changes in this planning turn. Do not adopt all ten Appendix A models.

Planning validation obtained: source/path and migration-directory inspection only; document
structure/link checks recorded at commit. Application tests, migration proof and human
behavioural proof: **not run; no B1 implementation exists**.

D1–D4 business scope is accepted. Complete technical review of the persistence, authority
and environment contracts against that settled scope before implementation.
The drafting-stage technical-review gate is superseded by the owner’s explicit review and
implementation instruction in Section 11; root Next is not filled with another workstream. No implementation confirmation or PASS record is created early.


## 11. Technical Review And Implementation Authority — 2026-09-07

Chris explicitly requested B1 technical review and implementation after accepting D1–D4.
This authorises resolving routine technical choices and implementing this bounded journey;
the earlier planning-only statements record the drafting stage and are superseded here.
No deployed configuration change, production provider or staging/live promotion is included.

Source review resolutions:

- Use the four proposed records with tenant-composite foreign keys and typed offer rows.
  Scope keys enforce Event/Project/default assignment uniqueness. A deferred database
  constraint checks complete offer/document/row creation at commit.
- Reuse the Project Store advisory lock. Database triggers protect all existing C1/C2
  Project content/selection/copy/order paths and immutable evidence, with readable service
  prechecks where appropriate. Source configuration may refresh without rewriting offers.
- Use existing GBP minor-unit and half-up tax helpers plus Seller tax evidence. The fixed
  emulator preserves exact text or refuses unsupported font characters; it does not silently
  substitute content. Logo identity/alt text are pinned; actual imagery/layout remain outside
  this explicitly emulated document result.
- Add `FUND_INDIVIDUAL_ARTWORK_TARGET=local|test|staging|production`; emulation requires
  an explicit non-production value. Known production provider signals also refuse emulation.
  Default mode stays disabled. No deployed setting is changed.
- Reuse authenticated feature-gated tRPC mutations for download (bounded base64 payload),
  rather than duplicating session/tenant resolution in a REST route. No public locator or
  shared cache is introduced. Reject impersonated finalisation; the organiser uses their
  own session. Current Client membership controls viewing/downloading; managers/admins
  generate, and the exact organiser alone finalises. This describes the implemented baseline;
  the 18 September amendment requires a distinct C1-authorised path in the next correction.
- Use deterministic PDFs/private temporary files, persisted claims and comparison before
  completion. Lost files can regenerate only to the same output hash. Retain cleanup locators
  until deletion succeeds. No real provider is needed for the accepted development result.
- Compose Individual blockers into canonical Store authority and readiness, including A7.
  B1 emulated evidence never enables actual trading; existing Individual Stores need a later
  deployment reconciliation before promotion. Other Project branches retain their rules.

Validation remains pending until recorded below and in the implementation/review records.
The next human gate is the implemented C1/C2 local journey; D1–D4 will not be asked again.


Implementation and test evidence now reside in the
[implementation confirmation](../04-implementation-confirmations/2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-implementation-confirmation.md)
and [review/test record](../05-review-and-test/2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-review-and-test.md).
Final review added explicit immediate aggregate validation before success because Prisma 5
can hide a deferred COMMIT error, and cleanup retry for already-available documents.


### Local DevData Smoke Preparation Authority — 2026-09-07

Chris subsequently identified the existing online Neon database assigned to local work and
asked the assistant to prepare it for B1 human smoke. This authorises applying the already
reviewed B1 migration to that positively identified DevData database and enabling local
emulation, superseding the earlier disposable-only preparation restriction for this action.
It does not authorise staging/live changes, a reset, seed, branch promotion or role bypass.

Read-only preflight identified the configured DevData endpoint by fingerprint `0970d1fe7a73`;
Next development resolves the same target, distinct from configured staging and production.
Its ledger has 153 completed migrations, matching source checksums, no failed migration,
and only `20260907120000_fund_b1_individual_offer` pending. Apply that existing migration
through Prisma deploy without creating a new migration or invoking reset/seed. Check existing
Project/Product/Store content before/after and independently verify the four new tables,
triggers and 154-entry ledger. On failure, stop and inspect; do not reset or blindly rerun.
Disable local emulation if rollback is needed; preserve any subsequently confirmed evidence.

Preparation outcome: PASS — migration ledger 154, four new tables and nine enabled B1
triggers independently read back; existing Project/Product/Store counts and content hashes
unchanged. Prisma client regenerated. Local ignored configuration enables emulation with
target local; no credential values changed. HTTP login/database checks pass. The review
record holds the local smoke entry points, data prerequisite and health-check qualification.

Chris subsequently reported local testing in progress and requested next-slice planning.
The [reserved 1R-G draft](2026-09-07-fund-phase-1-slice-1r-g-public-store-presentation-planning.md) is subordinate preparation, with exact Next selection pending. B1 retains this sole active checkpoint; no human PASS or promotion is inferred.


### Local Workflow Class Blocker — 2026-09-08

The [reference-data CR-Fix](../01-cr-inputs/CR-Fix-2026-09-08-fund-local-workflow-class-reference-data.md)
is a High-control bounded repair under accepted local smoke preparation: restore only the
four missing canonical Workflow Classes from the committed migration, preserving all user
work. The 04/05 B1 records hold the outcome; no reset/seed or new application slice.

Repair outcome: four canonical defaults restored and independently verified. Product creation
through the human C1 session remains pending; application and existing user records unchanged.


### Catalogue/Workflow Authority Finding — 2026-09-08

The [refined CR-Fix](../01-cr-inputs/CR-Fix-2026-09-08-fund-workflow-authority-and-product-suitability-separation.md) captures Chris's confirmed simplification:
Catalogue membership/availability determines Product scope; Event/Project determines workflow;
remove Product Workflow Class authority and the separate Product Suitability veto. Existing
B1 technical evidence remains valid within its recorded scope but does not prove conformance
to this corrected business model. Acceptance remains pending; triage must explicitly decide
correction sequencing before B1 closure. No new implementation or second checkpoint is created.

B1-R1 is now [triaged](../02-triage/2026-09-08-fund-b1-r1-catalogue-availability-and-workflow-authority-triage.md) with a [detailed remedial plan](2026-09-08-fund-b1-r1-catalogue-availability-and-workflow-authority-planning.md). Triage requires its correction before B1 business acceptance. Corrected candidate `8bda74f4` implements the plan and its guarded DevData migration now passes; this record retains the only restart checkpoint while human and remaining High-control proof stays open.


## C2 Finalisation Correction And Staging Authority — 2026-09-12

Chris requested resolution, commit and promotion to staging for testing. Read-only diagnosis
of staging Project fingerprint `a15cde9b` confirms exact-organiser permission and template
assignment, but selected Product source data has no active primary image and tax treatment
`UNCLASSIFIED`. These are real existing gates. The Product editor omits both setup controls;
the offer returns only a generic Product-readiness reason. Refreshing the Store also fails
to invalidate the separate offer query. This is a bounded B1 smoke-path correction, High control.

Implement explicit existing tax-treatment selection, C1 primary-image assignment from the
tenant media library (uploads remain in the existing Media UI), actionable offer blockers
beside finalisation and offer-query invalidation after Store edits/refresh. Image assignment
must enforce C1 role, tenant ownership, supported image MIME, transactional revision/audit
and preservation of existing media references and finalised evidence. Do not choose a tax
classification or image on the user's behalf, weaken any gate, add schema/runtime settings,
build a template editor or enable public purchasing. Validate negative permissions/tenancy,
assignment revision/rollback boundaries and query-state/UI behavior. Existing connected
proof remains applicable to unchanged code; add focused tests for the new boundary.

Authorised corridor: commit tested work, consolidate local dev, push origin/dev, locally merge
the exact candidate into staging and verify deployment/health/scans. Publish lifecycle docs.
Chris completes Product setup and the C1/C2 finalisation/download smoke on staging; that
human outcome remains pending. Main/live remains held. This extends the existing correction
record and does not create a new roadmap selection or checkpoint.

### Temporary Product Image And Media Refinement — 2026-09-12

Chris subsequently rejected the generic Media-library route as the final Product setup UX
and authorised the tenant logo as a temporary primary image to continue smoke testing.
This supersedes the earlier instruction to leave image choice entirely to C1 for this
specific staging fixture. The selected test Product now has user-configured STANDARD tax
treatment. Assign only the existing same-tenant light-logo MediaFile to the selected Product
on staging Project fingerprint `a15cde9b`; refuse an existing primary image or finalised offer.
Preserve selection, media references, tax settings and immutable evidence. Increment the
Product configuration revision and record a labelled staging-placeholder audit entry.

The existing managed branding logo is SVG. This bounded fixture may reference that exact
asset; it does not widen the application image selector's raster-only MIME policy or allow
arbitrary SVG uploads. Verify the staging database differs from local/live before writing,
use transaction locks and independently read back the association. Refresh only the draft
Store configuration through its existing service, preserving selection; never finalise,
publish or purchase. If checks fail, stop without a partial assignment. Retain the placeholder
for human smoke; replacement later must preserve any frozen evidence and media references.
Rollback, if required, removes only this still-current placeholder association, increments
the revision and refreshes an unfinalised draft; do not delete the underlying tenant logo.

Capture Product-owned uploads/gallery, storage organisation, options and option-image links
as a roadmap-linked refinement input awaiting triage. The generic library route remains an
interim implementation, not accepted final UX. No gallery implementation, schema change,
Now/Next reselection or main/live promotion is authorised by this workaround.

Outcome: controlled staging assignment and draft refresh committed atomically; independent
read-only verification PASS. Product revision is 3, selection remains one, exact-organiser
permission passes, zero offer reasons and valid snapshot/input hash are returned. Store
remains DRAFT with no publication timestamp; no finalised offer or FUND Order was created.
The [media refinement input](../01-cr-inputs/2026-09-12-fund-product-media-gallery-options-and-option-image-refinement-input.md)
is registered in the owning roadmap. Human visual/finalisation/download proof remains pending.

### Product Modal Placeholder Visibility Correction — 2026-09-12

Chris's next staging smoke reports the unchanged library link and empty image dropdown.
The fixture resolved readiness but did not deliver the expected temporary Product-editor
experience. Correct this within the existing B1 smoke outcome and staging promotion authority:
show the assigned primary image and its temporary-logo label directly in the Product modal;
remove the generic library prompt, selector and separate-save controls from this interim panel.
Return only the Product's active same-tenant primary media, including the existing managed
SVG logo, from the C1 read endpoint. Show honest loading/error/unassigned states. Retain
existing write permissions and raster validation; do not change data, frozen offers, schema,
runtime settings or implement the captured gallery/upload refinement.

Control remains High because this extends a tenant-scoped media read. Verify C2 refusal,
Product/media tenant filters, assigned SVG and missing-image responses; run focused tests,
type/lint/build and normal repository checks. Commit through the existing work/dev/staging
corridor and verify exact staging deployment. Chris then confirms the image/label in the
modal and resumes the C2 walkthrough. Main/live remains held. Rollback is the preceding
application commit `3379c4e9`; the existing staging placeholder requires no reversal.

Outcome: `e7e8837c` committed via the existing work/dev/staging corridor; exact Render
deployment and three-domain health/anonymous-access proof PASS. Seven focused tests, build,
lint/type/verify, read-only staging media/authority checks and exact dev/staging security
scans PASS. Human modal display and C2 finalisation/download remain pending. No data changes.

## B1-R3 VAT Authority Amendment — 2026-09-16

Chris directs the single Product-percentage model and requests CR, triage, planning and
revised smoke. The [B1-R3 plan](2026-09-16-fund-b1-r3-product-vat-rate-authority-planning.md) is the bounded remedial child. It supersedes earlier
B1 instructions to make Product category/percentage agree with Seller rates for new rate-only
configuration; current deployed code still has those rules until corrected. Preserve prior
PASS scope and immutable evidence. The root/child/Commerce roadmaps register the dependency;
this record retains the only restart checkpoint. No code, migration, database or deployment
change has occurred through this planning action.
