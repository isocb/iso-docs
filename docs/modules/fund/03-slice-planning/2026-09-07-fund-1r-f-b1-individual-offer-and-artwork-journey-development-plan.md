# FUND 1R-F-B1 — Individual Offer And Artwork Journey Development Plan

Date: 2026-09-07

Status: **B1-R2 implemented and proved locally; Chris reports local human smoke PASS; independent review and remaining proof/promotion gates open**

Control depth: **High** — this journey introduces persistent offer evidence, exact C2
finaliser authority, tenant-bound document access and failure/retry behaviour.

Work type: plan for a production-model build, initially proved through an emulated
local/development journey. Simulated service responses are test infrastructure; the offer
model and application behaviour would be persistent. No implementation, migration,
provider setup or environment promotion is performed by this planning change.

Owning inputs: the accepted `1R-F` parent and its existing Application/Artwork Template and
Product-selection/capacity CRs; this is their bounded development child, not a new CR.
The enduring [1R-F-B framework](../00-roadmap-control/2026-09-07-fund-user-framework-and-individual-artwork-delivery-principles.md)
augments the [FUND roadmap](../00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md).
[Root control](../../../00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md)
currently selects the Platform security correction as Now and FUND B1/B1-R2 resumption as Next.
This FUND checkpoint is retained for safe resumption; the Platform plan owns the active interrupt.

## Restart Checkpoint

```text
Current state: local B1/B1-R1/B1-R2 human smoke PASS reported by Chris on 2026-09-10 at 29104b55; automated/migration/B1-R2 connected proof PASS; independent review and outstanding B1-R1 connected proof remain open
Last proven commit: application B1-R2 29104b55 on B1-R1 51618485; local DevData target fingerprint 257f63f2e2c2, migration 156; prior connected-proof cleanup PASS is historical, not a fresh readback of the user's populated smoke data
Current environment: primary local checkout work/fund-b1-r1-catalogue-workflow at 29104b55; local Neon DevData through migration 156; separate security correction at dev/staging/main 0397bba9 with all origins aligned and main Security Scan PASS; no FUND promotion or security integration
Next human decision/test: no repeat of the unchanged local smoke requested; remaining independent/connected proof and security integration must establish the combined candidate, followed by environment-specific acceptance; main/live requires Chris's specific approval
Safe resumption point: read B1-R2 04/05 and B1-R1 05; preserve local test data and reported PASS; root Next remains FUND resumption after the security interrupt is closed or safely re-disposed; no new slice or promotion inferred
```

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
| D2 — Assignment and finalisation | Event-linked Projects follow the Event assignment; standalone Projects use an explicit Project assignment or the tenant standalone default. Authorised same-Client managers/admins prepare selection; the exact active organiser alone finalises | No Event-Project override or new permissions system. C1 prepares/oversees but does not impersonate the organiser to finalise | Accepted |
| D3 — First release revision rule | Before finalisation, allow normal edits. After finalisation, refuse changes to the confirmed Project offer/selection; allow controlled regeneration of that same offer only | No unlock or replacement-offer UI in B1. Explain the lock before confirmation; a mistaken finalisation is a visible limitation, not an excuse to alter history or delete data | Accepted |
| D4 — First development result | Implement the complete flow above using deterministic renderer/private-file emulators, authenticated Project download and a Store preview. Use existing test Projects and synthetic representative Products | Emulated documents visibly say “Development preview — not for distribution”. Real production rendering/storage and physical distribution are not proved by B1. Public Store, payment, Order and operational slices remain required in Phase 1, after B1 | Accepted following clarification of Phase 1 versus B1 |

Owner response provenance:

- D1: “Accepted with caveat. Fixed template with editor to be phase 2 development.”
- D2 and D3: “Accepted.”
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
  generate, and the exact organiser alone finalises.
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
