# FUND Roadmap And Slice Control

Created: 2026-06-25

Last consolidated: 2026-09-07

Status: Active authoritative control for the FUND lane

2026-09-10 portfolio interrupt: root Now is the accepted Platform PLAT-ASSURE-05 security
correction, implemented separately at `0397bba9`; FUND B1/B1-R2 resumption is Next. Chris
continues local human smoke at `29104b55` with the existing DevData and dependencies.
No FUND acceptance or security-fix integration is inferred; the Platform plan owns the
active security checkpoint and publication/review gates.

Parent roadmap:

`docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`

Sibling Commerce Core roadmap:

`docs/core/commerce/00-roadmap-control/2026-07-13-commerce-core-roadmap-and-slice-control.md`

Subordinate strategic completion overview:

`docs/modules/fund/00-roadmap-control/2026-07-15-fund-store-artwork-orders-and-production-strategic-completion-roadmap.md`

Subordinate refinement and pilot-placement register:

`docs/modules/fund/00-roadmap-control/2026-07-20-fund-refinement-wishlist-and-slice-control.md`

The subordinate overview coordinates the longer Store, artwork, Order, production,
fulfilment and commission route and traces the related 2026-07-15 change requests. It does
not replace this document's current slice status, dependency control, live gates or
next-slice authority.

The refinement register reconciles the superseded 2026-06-30 Wishlist, classifies genuinely
absent work and records conditional pilot/wider-rollout placement. It is not an additional
roadmap and cannot authorise or select a slice.

Purpose:

```text
Provide one current roadmap and slice-control view so future FUND work does not depend on reconstructing context from many individual slice documents.
```

This document is planning/documentation only. It does not implement code, change Prisma schema, create migrations, run deployment commands or start new feature work.

This FUND roadmap controls the FUND lane only. It records Commerce dependencies but does not
own or sequence Commerce Core implementation.

## 0. Authoritative CR Inventory And Current FUND Disposition — 2026-09-07

This file is confirmed as the one authoritative FUND child roadmap. The strategic
completion overview and refinement/pilot-placement register remain subordinate. The root
Platform/module roadmap owns the one serial cross-lane `Now` and `Next`.

Every FUND CR input must be registered in this table in the same documentation change that
creates the CR. Registration proves ownership and disposition only; it does not perform
triage, select a slice or authorise implementation. Later lifecycle changes must update the
same row.

| Source CR or governed input | Current disposition | Roadmap treatment |
| --- | --- | --- |
| [`2026-06-25-c2-organisation-scope-clarification.md`](../01-cr-inputs/2026-06-25-c2-organisation-scope-clarification.md) | Consumed by the `1P-D-R1` C2 dashboard review/scope note | Historical architecture clarification; no active implementation candidate |
| [`2026-07-08-fund-cr-availability-management-ui-pattern-remediation-input.md`](../01-cr-inputs/2026-07-08-fund-cr-availability-management-ui-pattern-remediation-input.md) | Planned through `1Q-G-B` and reviewed through the `1Q-G-R1` readiness check | Completed historical remediation input |
| [`2026-07-08-fund-cr-project-context-and-suitability-testability-remediation-input.md`](../01-cr-inputs/2026-07-08-fund-cr-project-context-and-suitability-testability-remediation-input.md) | Planned through `1Q-G-A` and reviewed through the `1Q-G-R1` readiness check | Completed historical remediation input |
| [`2026-07-13-fund-cr-commission-ladder-planner-input.md`](../01-cr-inputs/2026-07-13-fund-cr-commission-ladder-planner-input.md) | Policy/assignment foundation partly incorporated through `1R-C5`; aggregate calculation, statements and settlement remain absent | Parked later commission work, represented by subordinate `2R-PROD-05`; not selected |
| [`2026-07-15-fund-application-artwork-template-refinement.md`](../01-cr-inputs/2026-07-15-fund-application-artwork-template-refinement.md) | Consumed by accepted `1R-F` parent; `1R-F-A` completes at PASS with exact `0c7e4848` and zero residue; `1R-F-B` now reconciles the visible user/workflow framework and smallest vertical outcome | Former ten-record schema proposal retained as unaccepted technical evidence; no production implementation is authorised |
| [`2026-07-15-fund-collective-project-artwork-composition-approval-and-workflow-aware-product-instructions-remedial-clarification.md`](../01-cr-inputs/2026-07-15-fund-collective-project-artwork-composition-approval-and-workflow-aware-product-instructions-remedial-clarification.md) | Consumed as the boundary preventing the Individual proof from absorbing collective/Standard paths; those paths remain readiness branches around the common journey | Detailed collective work remains parked; no former `1R-F-F` through `I` candidate is automatically selected |
| [`2026-07-15-fund-project-product-selection-limits-and-template-capacity-cr.md`](../01-cr-inputs/2026-07-15-fund-project-product-selection-limits-and-template-capacity-cr.md) | `1R-F-A` proved ceilings of ten STANDARD portrait and twelve COMPACT landscape rows for its exact variants; `1R-F-B` now treats their product effect before persistence | Capacity evidence informs the minimum vertical journey; no template-version schema or policy implementation is authorised |
| [`2026-07-15-fund-template-manager-brief.md`](../01-cr-inputs/2026-07-15-fund-template-manager-brief.md) | Retained source brief for the Application/Artwork Template input | Provenance only; not a fourth CR and its provisional `T` labels carry no slice authority |
| [`2026-07-21-fund-default-project-store-and-eligible-product-presumption-input.md`](../01-cr-inputs/2026-07-21-fund-default-project-store-and-eligible-product-presumption-input.md) | Implemented/reviewed as `1R-E-D`; application commit is included by ancestry in current `14077382` | Completed technical correction; E-B/E-C real-workflow human acceptance remains a separate recorded gate and is not invented here |
| [`change-request-cmqt61xmf000612xt5ifl1mdn-2026-06-25.md`](../01-cr-inputs/change-request-cmqt61xmf000612xt5ifl1mdn-2026-06-25.md) | Original issue bundle was triaged and distributed across the historical `1P`/`1Q` lifecycle and later refinement controls | Superseded as a single active queue; retained as source evidence, with any genuinely absent outcome governed by its named current refinement/workstream |

Current FUND portfolio disposition:

```text
ROOT NOW  -> FUND 1R-F-B1 Individual Offer And Artwork Journey technical review and implementation
ROOT NEXT -> unselected pending B1 local human acceptance; no promotion inferred
PARKED ASSURANCE -> PLAT-ROLE-R1 only on an explicit trigger; Role Authority is closed
FUND      -> 1R-F-A COMPLETE AND CLOSED AT PASS; prior Stage C FAIL retained as contained history; Stage C-R1 provider/object/Render/local residue zero
             1R-F-B is the enduring subordinate framework; B1 owns the active development-plan draft and checkpoint; technical review and implementation now authorised
```

[CR-Fix — Catalogue-Led Product Availability and Event/Project Workflow Authority](../01-cr-inputs/CR-Fix-2026-09-08-fund-workflow-authority-and-product-suitability-separation.md)
— **implemented; guarded DevData migration PASS; remaining High-control proof and acceptance pending**, High depth.
[Triage](../02-triage/2026-09-08-fund-b1-r1-catalogue-availability-and-workflow-authority-triage.md); [implementation plan](../03-slice-planning/2026-09-08-fund-b1-r1-catalogue-availability-and-workflow-authority-planning.md); [implementation confirmation](../04-implementation-confirmations/2026-09-08-fund-b1-r1-catalogue-availability-and-workflow-authority-implementation-confirmation.md); [review/test record](../05-review-and-test/2026-09-08-fund-b1-r1-catalogue-availability-and-workflow-authority-review-and-test.md). Confirmed requirement:
one Product reused through Catalogues; retire Product Workflow Class authority and the
separate Product Suitability veto; C2 selects the available subset. Manufacturing changes
are managed through Catalogue membership/availability without a second Product edit.
FUND has no users or data requiring remedial conversion per Chris; dev data may be recreated,
while staging still requires a migration. Triage requires B1-R1 correction, review and human
acceptance before B1 closure. B1 Now includes this authorised remedial planning; 1R-G remains
downstream and unselected. Four workflows and standalone Catalogue availability are confirmed.
The completed plan removes `NOT_SURE` from persisted Event/Project workflow, replaces the
database Workflow Class rows with a fixed code registry, and removes Product and Project-Product
workflow gates. Corrected candidate `51618485` implements the correction, including Event-derived
C2 workflow display, the dedicated C2 Project Products selection surface, truthful draft-Product
guidance and prominent Project lifecycle controls. Its guarded Neon DevData
154-to-155 migration passed after the authorised FUND-only test-data recreation, with all
non-FUND application-table counts unchanged. No promotion has occurred. Negative database/concurrency
proof, independent review and human acceptance remain required.

[CR-Fix — Event Catalogue workflow scope and lifecycle integrity](../01-cr-inputs/CR-Fix-2026-09-10-fund-event-catalogue-workflow-scope-and-lifecycle-integrity.md)
— **implemented locally at `29104b55`; automated/connected proof PASS; human acceptance pending**, High depth.
[Triage](../02-triage/2026-09-10-fund-b1-r2-event-catalogue-workflow-scope-and-lifecycle-integrity-triage.md);
[implementation plan](../03-slice-planning/2026-09-10-fund-b1-r2-event-catalogue-workflow-scope-and-lifecycle-integrity-planning.md).
Human steps 1–4 passed on 10 September before testing exposed the need for Catalogue-level
multi-workflow scope, Event-context assignment, strict Event close/archive order and clear
Product-versus-membership status. B1-R2 stays inside B1 `Now`; it pulls `2R-EVENT-05`'s Event-side
visibility into the active correction without selecting 1R-G. No Product suitability control or
standalone per-Project Catalogue gate returns. Chris authorised implementation; local DevData
migration 156 and disposable eligibility/Event-lifecycle concurrency proof pass with cleanup.
Staging/live remain unchanged and independent review/human acceptance are still required.

Local smoke blocker [CR-Fix — Workflow Class reference data](../01-cr-inputs/CR-Fix-2026-09-08-fund-local-workflow-class-reference-data.md)
has its bounded DevData-only repair/readback PASS within B1 preparation; human Product creation retry remains pending. No new portfolio
selection or application implementation is inferred; B1 remains Now.

Chris is now performing the B1 local test and requested next-slice planning. The reserved
[`1R-G Public Store Presentation` planning draft](../03-slice-planning/2026-09-07-fund-phase-1-slice-1r-g-public-store-presentation-planning.md)
is prepared for review. It is a proposed next candidate, not an already-approved executable
slice; exact Next selection awaits the owner's response. B1 remains Now. The draft records
the unresolved 1R-F release dependency and never promotes B1 emulation to trading authority.

Chris subsequently authorised technical review and implementation on 2026-09-07.
B1 Section 11 records the resolved implementation boundary and current evidence.
The later owner-authorised local smoke setup is ready: existing Neon DevData has migration
154 with preservation checks passed, and localhost:3000 runs with local-only emulation.
The active plan/review records hold exact environment evidence and Project prerequisites.
Independent review and authenticated local human smoke remain pending; automated PASS
does not close either gate. The 04/05 folder indexes link the implementation and review records.
No staging/live promotion is inferred; earlier planning-only wording below is chronology.

The owner requested development planning after recognising B as an enduring framework.
The [B framework](2026-09-07-fund-user-framework-and-individual-artwork-delivery-principles.md)
is a subordinate augmentation of this roadmap; it does not select work or hold an active
slice checkpoint. [B1 development planning](../03-slice-planning/2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-journey-development-plan.md)
is now selected: one draft journey from C1 template assignment through C2 finalisation to a
matching development document download and Store preview. B1 contains four explicit
business decisions, now accepted; technical review remains before implementation. Later pilot
choices do not block drafting this bounded plan.

On 2026-09-07 the owner reconfirmed FUND as the primary planning/delivery focus after
conclusion of LMSPro remediation and requested committed local/online repository alignment.
Application dev/staging/main already match at `14077382`; documentation consolidation
uses the existing main flow. The active plan remains the place to resolve the business
choices and prepare the next bounded implementation outcome; no historic branch or
unaccepted schema option is selected by repository alignment.

### Business Situation Report And Confirmed First Smoke Scope

The existing [business situation report](2026-08-25-fund-complete-module-smoke-readiness-business-overview.md)
is the plain-English companion to this lifecycle. Update it when confirmed business scope,
material progress/blockers or the next owner question changes; it does not select slices
or duplicate the active plan's checkpoint.

The owner confirmed one Individual Artwork journey for Phase 1, ending in a calculated
and finalised commission statement without settlement. Collective/Group/Bulk/Standard
coverage follows later. Simulated external services are acceptable for development staging
before FUND deployment; staging must subsequently reflect actual live services. Actual
deployment still requires proof of the service contracts it enables. The report provides
separate options for unresolved delivery, Products/options, media, setup and messages.
These accepted planning inputs are retained in the B framework Section 1.1. They do not
accept its separate finalisation proposals or authorise B1 implementation.

### Retained 1R-F-A And Interrupt History

The chronology below is retained as historical evidence of the completed assumption test
and subsequent security interruption. The exact current repository, business progress and
permitted action are stated in Sections 2 through 4; this retained chronology cannot
select work.

On 2026-09-01 exact Stage C-R1 deployment `dep-dab9dj142hec73a9vvtg` and the single
one-off job `job-dab9eirtqb8s73f7r5n0` passed at full candidate
`0c7e48489aef697c6f39faf1a081456f9f3858a4`. Six controlled fixtures, six refusals and
six private R2 checksum round trips pass; peak memory ratio is `0.6583`; exact-prefix count
is zero. All twelve direct Render variables were removed and disposable service
`srv-dab9dip42hec73a9vuvg` is deleted/absent. The control owner then confirmed exact bucket
deletion and both provider revocations; retained Cloudflare and Render credentials each
returned HTTP 401. All three exact Keychain records and all five temporary helpers are
absent. `1R-F-A` therefore closes at PASS with zero residue.

Email F3, Role Authority and Support Ticketing are complete and closed. `PLAT-ROLE-R1` is
deferred trigger-based assurance and does not block FUND unless a recorded trigger fires.
The parent LMSPro R13 expedite and follow-on R14-A are complete and closed. Exact R14-A
`d78935d4` aligns through main with local R1-R9, staging S1-S4, production L1-L2, all four Security
Scans and public health green. The control owner restored `1R-F-A` Stage C as root `Now` and its
result reconciliation as root `Next`.
Direct portrait/landscape source inspection
superseded inferred R1A before review. Source-faithful R1B automation and 12/12 PDF/physical
review pass. Stage B Linux parity run `31595635243` and exact dev Security Scan
`31595635276` pass at application `139d09c4`. The accepted Stage C runner was gated and
dev-aligned at exact `328aadf0`; candidate Linux parity `31599134487` and Security Scan
`31599134488` pass. That commit remains preserved in current `d78935d4` ancestry. The
external Stage C result is FAIL because the accepted runner failed before behavioural
proof; zero-residue/revocation passes. Exact candidate
`328aadf0a360b4c65837327060302ddc525f6168` remains preserved as historical evidence. The control owner's
2026-08-26 read-only Render dashboard inspection found no matching Stage C service,
superseding the prior suspended-worker claim; existing auto-deploy services remain untouched.
The control owner's subsequent read-only Cloudflare inspection confirmed account
`43e9ed0a07538f8859168b9c692c91f9`, bucket
`isostack-fund-1r-f-a-stage-c-964210fa`, WEUR placement, zero objects, disabled public
development access, no custom domain/CORS/lock/event notification and only the default
seven-day incomplete-multipart abort rule. Matching parent token
`FUND-1R-F-A-Stage-C-2026-08-12` is active, Object Read & Write scoped only to that bucket
and has a `forever` TTL. It must be revoked before fresh execution-window authority is
created. The control owner then deleted that exact token on 2026-08-26 without creating a
replacement token, service or temporary credential. The control owner subsequently created
fresh token `FUND-1R-F-A-Stage-C-2026-08-26`, Object Read & Write scoped only to the exact
bucket with a 24-hour TTL, and retained its three credential fields as separate named
macOS Keychain records without sharing their values. At that checkpoint, Render operator
authority remained pending. The control owner then created dedicated Stage C Render API key
`FUND-1R-F-A-Stage-C-2026-08-26` for workspace `Isostack` and verified its separate named
macOS Keychain record from Terminal without sharing the value. Phase 3 may now create only
the accepted no-secret background worker and must stop on any exact-commit, auto-deploy,
routing or inert-state mismatch.
The worker was then accidentally created before auto-deploy was set Off. Its supplied build
log proves wrong revision `d78935d4` and no runtime proof or credential activity. The exact
worker is now identified as `srv-da7au58u01pc738qld00`; dashboard evidence proves status
`Suspended`, latest event `Manually Suspended`, auto-deploy Off, the accepted inert command,
and no linked environment group, secret file or disk. The control owner subsequently
confirmed one user-defined variable, reported as `PORT`; its five-digit value was neither
shared nor recorded. The variable is not treated as a credential, but it is unnecessary for
this no-inbound inert worker and violates the accepted empty-worker boundary. The control
owner removed only that variable using Save only and confirmed zero user variables, status
`Suspended`, auto-deploy Off and no unexpected deploy. The empty-worker configuration gate
now passes. The control owner then confirmed that Manual Deploy is not displayed while the
worker is suspended. Phase 3 remains held only on the wrong build and no runtime credential
or one-off job is authorised. Resume only this isolated worker, permit the wrong artifact
to run briefly only under the proved inert/no-secret boundary. The subsequent
specific-commit deploy is green and supplied logs prove full `328aadf0` checkout, accepted
pinned image identities and terminal live state; auto-deploy remains Off, the command is
inert and user variables remain zero. The submitted “Deploy ID” is the GitHub commit link,
not Render's provider identifier. The control owner then supplied exact deployment
`dep-da7b87i3v7hc73et4ui0`, closing Phase 3. Phase 4 may now fix one random UUID-v4 run ID
and exact prefix, mint one 60-minute object-read-write credential restricted to that
bucket/prefix, and retain its three values outside Render until scope/expiry checks pass.
The first local mint request returned Cloudflare HTTP 403/code 10000 before any temporary
credential was returned; the helper therefore wrote no temporary Keychain record and no
Render variable/job exists. The removed Render `PORT` variable is unrelated because the
request ran directly from the control owner's Mac to Cloudflare. Verify the stored parent
token status and token-ID/access-key-ID relationship read-only before choosing replacement
or Cloudflare's documented local-signing path. Read-only verification then returned HTTP
200/success, status `active`, expiry `2026-08-27T08:23:56Z`, and matching returned token ID
and stored access-key ID. This excludes parent expiry/identity drift and confirms an endpoint
refusal. Use documented local signing at the same 60-minute bucket/prefix scope, then
read-only prove exact-prefix empty and out-of-prefix denial before storing/configuring the
three values. The bounded fallback then passed at run ID
`ff63e2ec-528f-45f3-9505-ffe85bdbd59d`, exact matching prefix, permission
`object-read-write`, 3600-second TTL, expiry `2026-08-26T10:59:48Z`, prefix object count zero,
out-of-prefix HTTP 403, and three verified temporary Keychain items. The worker is manually
suspended with auto-deploy Off. The bounded Render helper then configured and read back
exactly the twelve accepted Stage C keys with 3200 credential seconds remaining, without a
deployment or job. Dashboard re-proof of suspension, auto-deploy Off, count twelve and no
unexpected deployment. Two no-cache HTTP 200 reads and a hard-refreshed Environment page
then agreed on exactly twelve keys, resolving the display disagreement without mutation.
The first one-hour credential expired safely before execution. Fresh run
`8ef3e1af-12ad-40b1-987a-de9ec0a9f9cd` passes exact-prefix zero/out-of-prefix 403 and exact
twelve-name/value Render read-back with 3598 seconds remaining. Single Starter job
`job-da7cu29srm7s7385o5g0` then ran the accepted command from the suspended worker and failed
after 61 seconds; final count one/no second job. Its exact log reports `Render commit differs
from Stage C authority`, before renderer/R2-client creation. Do not rerun. Read-only prove
prefix zero. Latest live deployment is `dep-da7ck6u7bikc73a9j7lg`/rejected `d78935d4`; accepted
`dep-da7b87i3v7hc73et4ui0`/`328aadf0` is deactivated. Worker is suspended/auto-deploy no.
Seven-record history proves a second `service_resumed` at `11:12:27Z` replaced the accepted
manual artifact with current `dev` head `d78935d4`. Auto-deploy `no` did not prevent the
resume-triggered deployment. Control owner then authorised the corrected attempt and reports
resume/manual exact deployment green/manual suspension complete. API verification is
required before credential/job action; no further resume is allowed after exact proof. That
verification now passes at latest deployment `dep-da7d78a3v7hc73eug70g`, manual/live/exact,
worker suspended/off and original failed job only. Fresh run
`345d4353-3af7-4a7e-93ba-11c3e1fcf6f9` now passes scope/preflight and exact twelve-value
read-back with 3598 seconds, no deploy/job. Corrected job `job-da7dbsh42hec73b401pg`
passed inline gates with 3387 seconds then failed terminal after 53 seconds; two jobs/no third.
No further attempt. Exact log identifies Playwright `page.evaluate` browser-context
`__name` failure. Final read-only proof returns fresh-prefix zero, suspended/off, exact latest
deployment and two jobs. Clear/verify zero Render variables as the first teardown action.
That zero-residue sequence is now complete without a further job: Render variables changed
from twelve to zero, the exact service returned deletion 204 and is absent by ID/list, and
the complete R2 bucket listed zero objects before control-owner deletion and independent
404 proof. The Cloudflare parent token and Render operator key were deleted/revoked and
subsequently returned HTTP 401; all seven named local credential records and temporary
helpers are absent. Stage C therefore closes at FAIL because the assumption was not proved,
while zero-residue/revocation passes. On 2026-08-26 the control owner separately selected
Stage C-R1 bounded local runner correction/new-candidate work and one conditional fresh
isolated external assumption test. The correction is complete at exact `0c7e4848` with
local, Linux parity `32970902854` and Security Scan `32970902848` PASS, so the fresh
disposable external test advances to root `Now`. Root `Next` is not selected. No later FUND
child or production model is authorised.

## 1. Control Authority And Reading Rule

Use this document as the authoritative control for FUND slice selection, planning status,
implementation gates and handoff. Use the root roadmap to choose between sibling FUND and
Commerce work:

`docs/00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md`

Authority order:

1. root roadmap for cross-lane selection and dependencies;
2. this roadmap for FUND sequence, current status and permitted next action;
3. bounded `03-slice-planning` documents for an individual slice contract;
4. `04-implementation-confirmations` for implementation evidence;
5. `05-review-and-test` for review, test and deployment gates.

Only sections 1 through 10 of this document are current control. Appendix A is a preserved
historical ledger. Labels such as “current”, “active” or “next” inside Appendix A describe
the position when that material was written and must not select new work.

## 2. Current Control Snapshot

### 2.0 Business Journey And Progress

The common FUND journey is the first current-control view:

```text
C1 configures Events, Products, commercial rules and availability
-> C2 creates or manages a Project
-> suitable Products are selected
-> workflow-specific preparation and review/approval take place
-> Individual Artwork: ready to finalise -> C2 finalises -> matching document generated
-> each branch satisfies its publication-readiness requirements
-> Store becomes publishable
-> purchaser browses, Orders and pays
-> C1 operates and reconciles Orders
-> artwork/production requirements are matched
-> production is authorised and fulfilled
-> dispatch occurs
-> commission is calculated, reported and later settled
```

Readiness is the principal branch around this spine:

```text
                             -> Individual Artwork readiness
                            /
Client -> Project -> Products -> Readiness -> Store -> Order -> Fulfilment -> Commission
                            \
                             -> Collective / Bulk / Standard readiness
```

| Business capability | Current position |
| --- | --- |
| C1 Client/Event/Product/Project foundations | Substantial foundation exists |
| C2 Client/Project management foundation | Exists |
| Project Product selection/eligibility | Exists |
| Project Store/configuration foundations | Exists; consolidated human acceptance remains relevant |
| Workflow-specific artwork readiness | Partial; Individual technical proof only |
| Public purchaser Store | Not built |
| Consumer checkout/Order journey | Backend Commerce machinery exists; public FUND journey is incomplete |
| Physical artwork/Order matching | Not operationally built |
| Production workflow | Not operationally built |
| Dispatch/fulfilment | Not operationally built |
| Commission calculation/statements/settlement | Not operationally complete |
| End-to-end fundraising journey | Not yet reached |

`1R-F-B` is the strategic reconciliation of this framework and its proportionality. It is
not schema implementation. The former ten-record proposal remains an unaccepted technical
option inside the controlling `1R-F-B` document.

Current application repository state:

```text
application local/remote dev/staging/main: exact production 14077382; PLAT-ASSURE-04 complete and closed with all gates PASS
1R-F-A corrected proof commit: exact 0c7e4848; retained in current ancestry
R14-A local R1-R9, staging S1-S4 and production L1-L2: PASS; COMPLETE AND CLOSED
protected work/dev/staging/main Security Scans: PASS; exact-main run 32838343535 complete
Role Authority: COMPLETE AND CLOSED
Support Ticketing: COMPLETE AND CLOSED
FUND 1R-F-A Stage C-R1: COMPLETE AND CLOSED AT PASS on exact 0c7e4848; provider/object/Render/local residue zero
FUND 1R-F-B: enduring subordinate framework; FUND 1R-F-B1: High-control implementation candidate; automated proof and disposable cleanup passed; local human acceptance pending
documentation alignment preflight: clean c295b1e; main/origin-main at 4e4ed16; work branch two ahead of upstream and 72 ahead of main without divergence
documentation publishing target: local main/origin-main and the existing work branch; owner now authorises consolidation/push/readback, superseding local-only instructions; resolve exact refs before resumption
```

Current consolidated delivery state:

- Commerce `A1` through `A7`, FUND `1R-C1` through `1R-D` and Project Intake/creation
  `1P-G-R3-A` through `R3-D` are included in the promoted application ancestry;
- protected application dev, staging and main, local and remote, are aligned at
  `14077382`; its ancestry includes `0c7e4848`, `d78935d4`, E-D and the previously promoted
  FUND/Commerce application work;
- E-D adds no migration and performed no shared database action; shared database state
  remains governed by the preceding promotion records;
- the historical E-D secret detection, schema security and TypeScript CI evidence remains
  unchanged; the later protected `fast-uri` dependency correction at `14077382` is included
  and its exact work/dev/staging/main security and environment gates pass;
- the staging application health check passed with its database connected and RLS enabled
  on all 11 expected tables;
- prior human FUND administrator login and pre-existing UI smoke testing passed; E-B/E-C
  authenticated real-workflow acceptance is technically unblocked by E-D but remains
  pending in the recorded schedule; and
- this reconciliation makes no new database, migration, environment or FUND human-acceptance
  claim; those remain governed by their existing promotion and review records.

Current E-A/E-B/E-C promotion state:

- FUND `1R-E-A - Store Authority, Exceptional Intervention And Lifecycle Service
  Alignment` is implemented and independently reviewed as passed at application commit
  `daafc349`, now included in promoted application `e3f44b4b`;
- its one bounded migration passed representative 140-to-141 and full fresh 141-migration
  disposable lifecycles with zero failed migrations and zero test residue;
- preflight refusal, constraints, intervention/service authority, Event envelope,
  effective-state, concurrency, rollback, 1R-D/A7 regressions and production build passed;
- exact dev/staging Security Scan runs `29729448020` and `29729620299` passed for
  application `e3f44b4b`;
- online staging is healthy with its database connected and RLS enabled on 11/11 expected
  tables; no direct staging migration inventory was queried locally;
- bounded `1R-E-B - C1 Store Portfolio Oversight And Exceptional Intervention Surface`
  implementation, disposable validation and lifecycle records are promoted at `e3f44b4b`
  with no E-B schema/migration;
- bounded `1R-E-C - C2 Project Store Control Surface` planning, implementation, automated
  review and lifecycle records are promoted at `e3f44b4b` with no E-C schema/migration;
- post-promotion human-smoke preparation found that canonical Project creation did not
  instantiate the Store/default eligible Product set, so E-B/E-C human acceptance was blocked
  rather than failed;
- governed `1R-E-D - Default Project Store Instantiation And Eligible Product
  Reconciliation` is implemented/reviewed at `c45a41d9`, integrated/revalidated and included
  in current `dev`/`staging` ancestry; it requires no E-D schema migration. Its dependent
  authenticated E-B/E-C real-workflow acceptance remains pending; and
- `1R-F - Project Offer And Artwork Readiness Reconciliation` is reviewed and accepted as
  the non-executable successor to the three governed CRs; and
- `1R-F-A - Real AMOW Template, Pricing And Deployed Renderer Proof` is complete and closed
  at PASS on corrected exact `0c7e4848`, including disposable external execution and zero
  provider/object/Render/local residue. The control owner selected `1R-F-B` strategic
  user/workflow/proportionality reconciliation only. Its former ten-record proposal is
  unaccepted technical evidence; no Prisma, migration, database, service, UI, provider,
  deployment or later `1R-F` child is authorised.
- the 2026-07-20 refinement reconciliation is accepted as subordinate placement control:
  it must inform `1R-F-A` and be applied before accepting work beyond it, but it does not
  replace the authoritative next-candidate decision or authorise a refinement implementation.

Authoritative promotion evidence:

`docs/00-roadmap-control/2026-07-20-fund-1r-e-dev-staging-promotion-confirmation.md`

Retained historical schema/promotion detail:

The following dated evidence explains how the existing foundation was reached. It does not
override the current repository truth or selected planning outcome above.

- `COMMERCE-A1`: implemented and reviewed as passed;
- FUND `1R-C1`: implemented and reviewed as passed;
- FUND `1R-C2`: implemented and reviewed as passed;
- all three have been validated on the retained disposable Neon test database;
- all three are committed together at application commit `4575d2d`;
- FUND `1R-C3` and `1R-C4` are implemented/reviewed and committed at `686229c`;
- FUND `1R-C5` is implemented/reviewed at `8b5f208`, now included on `origin/dev`;
- FUND `1P-G-R3-A` is implemented/reviewed at `4bb7dd9`, now included on `origin/dev`;
- FUND `1P-G-R3-B` is implemented/reviewed at `04da074`, now included on `origin/dev`;
- FUND `1P-G-R3-C` is implemented/reviewed, committed and promoted to application
  `origin/dev` at `234f115`; staging/main and shared databases remain unchanged;
- FUND `1P-G-R3-D` is implemented/reviewed at `e1c2d9f`, included on `origin/dev` at `3206199`;
- `COMMERCE-A2` is implemented/reviewed and published on `origin/dev` at `3206199`;
- FUND `1R-C6` is implemented/reviewed at local application `9947669`; it is one commit
  ahead of `origin/dev` and has no shared deployment;
- FUND Store `1R-D` is implemented/reviewed at local application `db85fcc`; it adds no
  migration and has no shared deployment;
- Commerce `A3` is implemented/reviewed at local application `4a90be1`, is three commits
  ahead of `origin/dev` with C6/1R-D, and has no shared deployment;
- Commerce `A4` is implemented/reviewed at local application `5b69920`, is four commits
  ahead of `origin/dev` with C6/1R-D/A3, and has no shared deployment;
- local/remote `staging` and `main` remain at `ea4e619`;
- no shared development, staging or production database migration/deployment is claimed.

The R3-B service engine is committed at application `04da074` on top of R3-A baseline
`4bb7dd9`; both are now ancestors of `origin/dev` at `3206199`. R3-B adds no schema or
migration. No shared database deployment is claimed.

Disposable test database state after Commerce A3 review:

```text
applied migrations: 139
failed migrations: 0
residual A4 fixture rows: 0
```

`TEST_DATABASE_URL` remains local and uncommitted. Every destructive test must first prove
it is distinct from `DATABASE_URL`. Prefer the direct Neon endpoint for migration resets so
session advisory locks are not returned to a pool.

## 2.1 Authoritative Neon Development Migration State — 2026-07-14

This subsection is the current migration authority for FUND planning. It supersedes older
entries elsewhere in this roadmap that describe C1-C6, R3-D or Commerce A1-A4 as
undeployed to the shared Neon development database.

```text
Application dev/origin-dev: fd7376b
Repository migration inventory: 139
Neon development applied migrations: 139
Unresolved/failed migration attempts: 0
FUND schema tables: 37
FUND business rows: 0
Commerce schema tables: 9
Commerce business rows: 0
Staging/main application refs: ea4e619 (unchanged)
```

The development database began this promotion at 127 applied migrations. The following 12
were pending and are now applied in repository timestamp order:

1. `20260713120000_commerce_a1_schema_seller_profile_enums`
2. `20260713150000_fund_1r_c1_product_configuration_foundation`
3. `20260714100000_fund_1r_c2_client_branding_delivery_event_media`
4. `20260714150000_fund_1r_c3_project_store_store_product`
5. `20260714200000_fund_1r_c4_production_asset_version`
6. `20260714230000_fund_1r_c5_commission_policy_assignment`
7. `20260714233000_fund_1p_g_r3_a_intake_automation_schema_policy`
8. `20260714234500_fund_1p_g_r3_d_project_creation_contract`
9. `20260714235500_commerce_a2_checkout_order_line_foundation`
10. `20260714235900_fund_1r_c6_commerce_context_foundation`
11. `20260715001000_commerce_a3_payment_refund_pro_forma_foundation`
12. `20260716001000_commerce_a4_audit_idempotency_foundation`

The first deployment stopped at the intentional R3-D empty-FUND-baseline guard. Aggregate
diagnosis found only disposable FUND test data: 3 Clients, 12 Projects, 1 Client Member and
2 Intake Submissions. Following explicit user authorisation, a dependency check confirmed
that no non-FUND table referenced a FUND table; all 33 then-existing FUND tables were
truncated together without `CASCADE`, and an exact check confirmed zero FUND rows. No
public, LMSPro, Commerce, Pulse or migration-ledger business data was removed.

The failed R3-D attempt was marked rolled back, then reapplied successfully before A2, C6,
A3 and A4. Final `prisma migrate status` reported the database up to date. Public/LMSPro
counts were identical before and after migration: 6 Organizations, 15 Users, 2 Seasons, 3
Clubs and 5 Teams. Commerce A1-A4 and FUND C1-C6 schema-contract verifiers, repository
critical-file verification and TypeScript checking all passed.

No staging or production branch/database was migrated. Full evidence is recorded in:

`docs/00-roadmap-control/2026-07-14-fund-commerce-dev-promotion-and-migration-confirmation.md`

## 2.2 Controlled A7 Development And Staging Promotion — 2026-07-15

This subsection is the current application promotion authority and supersedes older
sections that describe Commerce A6-A through A7 or their retained FUND dependencies as
local, unpushed or undeployed.

```text
Application dev/origin-dev:         91e8751c
Application staging/origin-staging: 91e8751c
Application main/origin-main:       ea4e6193 (unchanged)
Neon development migrations:        140 applied, 0 failed
Staging health:                      healthy; database connected; RLS 11/11
Human staging verification:         FUND admin login PASS; existing UI smoke PASS
```

The staging deployment used the normal Render build contract, which runs Prisma migration
deployment before the application build. A direct staging migration-inventory query was
not performed locally, so this record does not invent one. Production remains untouched.

Full evidence is recorded in:

`docs/00-roadmap-control/2026-07-15-commerce-a7-dev-staging-promotion-confirmation.md`

## 2.3 Controlled FUND 1R-E Development And Staging Position — reconciled 2026-07-23

This subsection supersedes 2.2 for current application dev/staging branch state.

```text
Application dev/origin-dev:         99164ddd
Application staging/origin-staging: 99164ddd
Application main/origin-main:       ea4e6193 (unchanged)
Neon development migrations:        140 previously recorded; not changed this turn
Staging health:                      healthy; database connected; RLS 11/11
E-D staging ancestry:                present; no E-D migration
E-B/E-C/D authenticated human UI:    pending consolidated staging smoke schedule
```

Exact dev and staging Security Scans passed. The Render build contract runs committed
Prisma migrations before application build; no direct staging migration inventory was
queried locally. Online health and unauthenticated C1/C2 route-protection checks passed.
Production remains untouched.

The definitive human schedule is:

`docs/modules/fund/05-review-and-test/2026-07-23-fund-phase-1-slice-1r-e-b-through-1r-e-d-consolidated-staging-human-smoke-test-schedule.md`

Full evidence is recorded in:

`docs/00-roadmap-control/2026-07-20-fund-1r-e-dev-staging-promotion-confirmation.md`

## 3. Current Slice Status

| Slice | Lane | Status | Controlling outcome |
| --- | --- | --- | --- |
| `1R-A` | FUND architecture | Accepted | Store/Commerce ownership and business decisions established |
| `1R-B` | FUND/Commerce boundary | Accepted | Generic Commerce and typed FUND ownership separated |
| `COMMERCE-A1` | Commerce | Implemented/reviewed; applied to Neon development | Commerce namespace, Seller Profile and stable enums only |
| `1R-C` | FUND architecture | Accepted | FUND schema foundation split into `1R-C1` through `1R-C6` |
| `1R-C1` | FUND | Implemented/reviewed; applied to Neon development | Product media/input/tax/copy-provenance schema foundation |
| `1R-C2` | FUND | Implemented/reviewed; applied to Neon development | Client branding, Project delivery and Event media foundation; Project Intake alignment dependency preserved |
| `1R-C3` | FUND | Implemented/reviewed; applied to Neon development | Project Store, Store Product, immutable configuration version and Store Product input-owner schema foundation |
| `1R-C4` | FUND | Implemented/reviewed; applied to Neon development | Production Asset Version Foundation; runtime media/actor validation and production authority remain later work |
| `1R-C5` | FUND | Implemented/reviewed; applied to Neon development | Event-default and C1 Project-specific Commission Policy And Assignment Foundation |
| `1P-G-R3` | FUND Project Intake | Parent alignment accepted; non-executable | Automated Event/standalone Project provisioning for new/existing Clients with C1 exception review |
| `1P-G-R3-A` | FUND Project Intake | Implemented/reviewed; migration applied to Neon development | Explicit aligned-form opt-in/version/revision, typed Intake evidence and exact provisioning-result keys only |
| `1P-G-R3-B` | FUND Project Intake | Implemented/reviewed at `04da074`; included on `origin/dev`; shared databases undeployed | Form-policy/protection/atomic-provisioning engine; invoked only through R3-C |
| `1P-G-R3-C` | FUND Project Intake | Implemented/reviewed; committed/promoted to `origin/dev` at `234f115`; shared databases undeployed | Form capture, atomic confirmation invocation and protected exception-review integration |
| `1P-G-R3-D` | FUND Project creation | Implemented/reviewed; migration applied to Neon development | Generic C1/K2 Project creation now requires Client, typed Project type, exact organiser and atomic delivery profile |
| `COMMERCE-A2` | Commerce | Implemented/reviewed; applied to Neon development | Generic checkout header, immutable Order/line and same-tenant schema foundation |
| `1R-C6` | FUND | Implemented/reviewed; application on `origin/dev` and migration applied to Neon development | Typed FUND context keyed to generic Commerce Order/line records; no runtime behavior |
| `1R-D` | FUND Store | Implemented/reviewed; application on `origin/dev`; no migration | Internal C1 Store preparation, readiness, immutable configuration, lifecycle and Product-copy services; no UI/public Store/Commerce payment behavior |
| `COMMERCE-A3` | Commerce | Implemented/reviewed; applied to Neon development | Provider-neutral Payment, Refund and Pro-forma schema evidence; no runtime behavior |
| `COMMERCE-A4` | Commerce | Implemented/reviewed; applied to Neon development | Provider-neutral audit and idempotency evidence foundation; no runtime behavior |
| `COMMERCE-A5` | Commerce | Implemented/reviewed; application on `origin/dev`; no migration | Provider-neutral validation, idempotency and audit service primitives |
| `COMMERCE-A6-A` through `A6-D` | Commerce | Implemented/reviewed; included in dev/staging promotion `91e8751c` | Stripe Connect evidence, onboarding, Checkout adapter and verified webhook/payment/refund reconciliation boundaries |
| `COMMERCE-A7` | Commerce/FUND integration | Implemented/reviewed; dev/staging promotion and smoke gate complete at `91e8751c` | Dormant internal STRIPE_ONLINE integration from an authoritative FUND offer to generic Commerce and typed FUND context |
| `1R-E` | FUND Store | Parent reviewed/accepted; non-executable; corrective E-D appended | C1 Store oversight, C2 normal Project Store control, exceptional C1 intervention and mandatory default Project Store initiation split into bounded E-A/E-B/E-C/E-D lifecycles |
| `1R-E-A` | FUND Store | Implemented/reviewed; included in dev/staging promotion `e3f44b4b`; disposable database 141/0 | Typed C1 intervention evidence, C2 Project/Store authority, Event envelope guards and one effective Store-state/A7 availability policy; no UI |
| `1R-E-B` | FUND Store | Implemented/reviewed; present in current dev/staging ancestry; automated evidence passed; consolidated human acceptance pending | C1 Store portfolio oversight and exceptional intervention surface consuming E-A authority |
| `1R-E-C` | FUND Store | Implemented/reviewed; present in current dev/staging ancestry; automated evidence passed; consolidated human acceptance pending | C2 Project Store control surface consuming E-A authority, bounded C2 commission acceptance and normal Project/Store control |
| `1R-E-D` | FUND Store | Implemented/reviewed at `c45a41d9`; present in current dev/staging ancestry; no E-D migration; consolidated human acceptance pending | Mandatory one DRAFT Store per Project, all-eligible-minus-C2-exclusions defaults, atomic C2 activation/publication intent and real-workflow human testability |
| `1R-F` | FUND artwork readiness | Reviewed/accepted; non-executable parent | Separates the common Project journey from Individual, collective and Standard readiness branches |
| `1R-F-A` | FUND Individual Artwork proof | Complete and closed at PASS on exact `0c7e4848` | Real AMOW template, pricing, Linux, deployed renderer/private-object behaviour and zero external residue proved |
| `1R-F-B` | FUND business framework | Reclassified as subordinate roadmap augmentation | Enduring user/workflow/proportionality context; no active checkpoint or executable slice |
| `1R-F-B1` | FUND Individual offer/document journey | Portfolio `Now`; implementation and validation | C1 assignment, C2 preview/finalisation, emulated authenticated download and matching Store preview; D1–D4 accepted; implementation present, local human acceptance pending; purchaser/operational slices remain in Phase 1 after B1 |

`1R-C1` through `1R-D` and `1P-G-R3-A`/`R3-B`/`R3-C`/`R3-D` must not be rerun as pending work. No next
implementation is authorised merely because the preceding lifecycle completed.

## 4. Current Sequence And Dependency Control

Current repository checkpoint: local and remote application `main`, `dev` and `staging`
are clean and aligned at exact `14077382`. This includes completed Platform security work,
the corrected `1R-F-A` proof ancestry and the prior FUND/Commerce foundations. No
application work branch exists for `1R-F-B` because its present authority is documentation
review only. Historical promotion evidence is
recorded at
`docs/00-roadmap-control/2026-07-20-fund-1r-e-dev-staging-promotion-confirmation.md`, and
the current combined production decision is:
`docs/00-roadmap-control/2026-07-23-lmspro-r8-a3-and-combined-staging-bundle-production-risk-assessment-and-promotion-decision.md`.

Older statements below describing C1-C6/R3-D as unpushed or undeployed to the development
database are superseded by this checkpoint.

```text
COMMERCE-A1 (complete on dev)
  -> COMMERCE-A2 (implementation/review complete on `origin/dev` at `3206199`)
  -> FUND 1R-C6 (implementation/review complete locally at `9947669`)
  -> FUND 1R-D (implementation/review complete locally at `db85fcc`)
  -> COMMERCE-A3 (implementation/review complete locally at `4a90be1`)
  -> COMMERCE-A4 (implementation/review complete locally at `5b69920`)
  -> COMMERCE-A5 (implemented/reviewed: provider-neutral services and validation)
  -> COMMERCE-A6 parent plan (reviewed/accepted)
     -> A6-A account/event-inbox schema (implemented/reviewed at `513cf3a`)
     -> A6-B tenant settings/hosted onboarding (implemented/reviewed at `e8aecea`)
     -> A6-C connected-account Checkout adapter implemented/reviewed at `34ef64bb`
     -> A6-D webhook/refund reconciliation implemented/reviewed at `fa670e3c`
  -> COMMERCE-A7 FUND consumer integration implemented/reviewed at `598305ce`
     and promoted through dev/staging at `91e8751c`
  -> FUND 1R-E C1 Store Oversight And C2 Project Store Control Alignment parent accepted
  -> FUND 1R-E-A Store authority/intervention service implemented/reviewed and promoted
     -> FUND 1R-E-B C1 Store Portfolio Oversight And Exceptional Intervention Surface
        implemented/reviewed and included in current live ancestry; human gate pending
     -> FUND 1R-E-C C2 Project Store Control Surface
        implemented/reviewed and included in current live ancestry; human gate pending
     -> FUND 1R-E-D Default Project Store Instantiation And Eligible Product Reconciliation
        implemented/reviewed at c45a41d9; included in current live ancestry;
        no E-D migration; consolidated E-B/C/D human schedule pending
  -> FUND 1R-F Project Offer And Artwork Readiness Reconciliation parent accepted
     -> FUND 1R-F-A Real AMOW Template, Pricing And Deployed Renderer Proof
        local/physical/Linux gates pass; prior external failure contained; corrected
        Stage C-R1 external behavioural proof PASS at exact 0c7e4848; provider revocation
        and exact-prefix/Render/local zero-residue PASS; COMPLETE AND CLOSED
     -> FUND 1R-F-B User Framework, Project Workflow And Vertical-Slice Reconciliation
        is portfolio NOW for planning/documentation only
        -> control-owner acceptance of business decisions and proportionality
        -> one smallest coherent vertical outcome may be selected separately later
           (root NEXT remains unselected)

FUND 1R-C1 (complete on dev)
  -> 1R-C2 (complete on dev)
  -> 1R-C3 (complete on dev)
  -> 1R-C4 (complete on dev)
  -> 1R-C5 (implementation/review complete; included on origin/dev)
  -> 1R-C6 (implementation/review complete locally at `9947669`)

FUND 1P-G-R3 (parent accepted; non-executable)
  -> 1P-G-R3-A (schema/form-policy implementation/review complete; included on origin/dev)
  -> 1P-G-R3-B (service implementation/review complete; included on origin/dev)
  -> 1P-G-R3-C (implementation/review complete; application `origin/dev` at `234f115`)
  -> 1P-G-R3-D (generic C1/K2 Project-creation alignment; `e1c2d9f` included on `origin/dev`)
```

Rules:

- FUND may proceed through `1R-C2` to `1R-C5` without Commerce Orders;
- `1P-G-R3` parent alignment is accepted and is not an implementation unit;
- `1P-G-R3-A`, `1P-G-R3-B`, `1P-G-R3-C` and `1P-G-R3-D` are complete through review/test and must not be rerun as
  pending work;
- R3-B is now invoked only by the completed R3-C aligned confirmation and protected review
  paths; historic null-contract Intake remains review-only;
- `1P-G-R3-D` closes the direct C1/K2 Project-creation contract gap; staging/main and shared deployment remain separate;
- `COMMERCE-A2` has completed the generic Order/line ownership and exact same-tenant keys;
- `1R-C6` is complete through review/test and must not be rerun as pending work;
- Store `1R-D` is complete through review/test and must not be rerun as pending work;
- `COMMERCE-A3` is complete through review/test and must not be rerun as pending work;
- `COMMERCE-A4` is complete through review/test and must not be rerun as pending work;
- `COMMERCE-A5` is implemented and reviewed at application commit
  `fd7376b`; no migration or shared deployment was performed;
- `COMMERCE-A6-A` through `COMMERCE-A7` are implemented/reviewed and included in the
  completed dev/staging promotion at `91e8751c`;
- FUND `1R-E - C1 Store Oversight And C2 Project Store Control Alignment` is an accepted
  non-executable parent; E-A/E-B/E-C are implemented/reviewed and promoted through
  dev/staging; E-B/E-C automated evidence passes and their connected human acceptance is
  pending under the consolidated E-B/C/D staging schedule;
- `1R-E-D - Default Project Store Instantiation And Eligible Product Reconciliation` is
  implemented/reviewed and present in current `dev`/`staging` ancestry; human acceptance
  remains pending under that same schedule;
- `1R-F - Project Offer And Artwork Readiness Reconciliation` is an accepted
  non-executable parent at
  `docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-f-project-offer-artwork-readiness-reconciliation-planning.md`;
- [`1R-F-A - Real AMOW Template, Pricing And Deployed Renderer Proof`](../03-slice-planning/2026-08-11-fund-phase-1-slice-1r-f-a-real-amow-template-pricing-and-deployed-renderer-proof-planning.md)
  follows E-D; its plan, Stage A evidence, human/physical review and Stage B Linux parity
  pass at exact dev `139d09c4`. The prior Stage C failure is contained. Corrected Stage C-R1
  local/Linux/security gates and the one external behavioural/private-object run pass at
  exact `0c7e4848`; provider revocation and exact-prefix/Render/local zero-residue pass.
  `1R-F-A` is complete and closed. No production implementation, promotion or further run is selected;
- [B — User Framework And Individual Artwork Delivery Principles](2026-09-07-fund-user-framework-and-individual-artwork-delivery-principles.md)
  is the enduring subordinate framework. Its ten-record appendix remains unaccepted;
- [B1 — Individual Offer And Artwork Journey](../03-slice-planning/2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-journey-development-plan.md)
  governs the authorised implementation. D1–D4 and the technical boundary are settled;
  its implementation/review records own automated proof and the remaining human gate;
- [`1R-H-A - Store Order Short Code And Single-Artwork Correlation`](../03-slice-planning/2026-08-11-fund-phase-1-slice-1r-h-a-store-order-short-code-and-single-artwork-correlation-planning.md)
  is a parked downstream planning input after public Store `1R-G`; it records accepted
  policy only and is not `Now`/`Next` or implementation authority;
- the subordinate 2026-07-20 refinement register must inform any later AMOW correction,
  proof or pilot gate, but cannot start work or displace root selection;
- never implement two slices merely because their planning can be discussed together;
- finish one slice lifecycle before selecting another unless the user explicitly changes
  the control decision.

### 4.1 Accepted 1R-E Store Authority Correction — 2026-07-15

The accepted business authority for the next slice is:

- the Store belongs to its Project and has no independent trading dates;
- the Project's explicit opening and closing date-times are the Store trading window;
- a linked Event supplies default Project opening/closing instants at Project creation and
  the outer permissible date envelope; the copied Project dates remain C2-editable within
  that envelope, and later Event-date changes do not cascade automatically;
- authorised C2 Client members perform normal Project Store control, including enable or
  publish, pause and resume within server-enforced commercial, Project and readiness rules;
- C1 has tenant-wide Store overview, supplier-side Product/commercial/readiness and
  presentation-release authority, but is not the routine Store moderator;
- C1 retains exceptional, audited pause, resume, closure and C1-only reopen authority for
  legal, payment, safety or seller-of-record intervention; and
- the current C1-only `1R-D` Store-management service and any dependent Project-lifecycle
  authority must be aligned before either C1 or C2 UI is treated as operational.

This correction supersedes older planning language that assigns ordinary Store publication,
pause or closure to C1. It does not itself authorise implementation.

### 4.2 Pilot Scope And Refinement Placement Control — 2026-07-20

The reconciled placement authority is recorded in:

`docs/modules/fund/00-roadmap-control/2026-07-20-fund-refinement-wishlist-and-slice-control.md`

It informed the completed `1R-F-A` proof/review action and must inform any separately
selected correction/new candidate or later pilot gate, preventing template, Store and
communications decisions from hardening around known pilot gaps:

- before pilot Intake, complete confirmation polish and indispensable organiser
  notifications; add embed/CSP only if AMOW confirms embedded Intake, and add configurable
  Event/Client types only if a pilot option-fit assessment proves current choices
  unsuitable;
- before the public Store pilot, provide only the purchaser-visible option/media authority
  required by the actual pilot Products and immutable Order evidence; rich gallery
  merchandising remains evidence-led;
- before operational UAT, promote Product duplication only if repeated AMOW setup would
  otherwise be materially slow or error-prone;
- before live pilot communications, deliver the bounded transactional and pilot-lifecycle
  messages required by the owning workflows by reusing the existing LMSPro sequence engine,
  Resend delivery and shared communications methods;
- before wider rollout, deliver the general Event/Project campaign editor, promotional
  nudge sequences, aligned editor experience, announcements, richer Catalogue
  merchandising, Catalogue duplication and reusable Product/option templates; and
- schedule tenant terminology and dashboard presentation refinements from pilot evidence.

The general Event/Project campaign editor is a required wider-rollout capability and the
primary planned sales-promotion surface for timely Project-owner nudges. Pilot-critical
Order receipts, confirmations and necessary organiser notifications must not wait for that
general editor.

Every promoted item still requires one bounded lifecycle. Conditional items become pilot
blockers only after the pilot decision record fixes the actual tenant/Client/Event/Project
scenarios, hosted-versus-embedded Intake, Product/media needs, message inventory, roles,
environment/data policy and measurable entry/exit criteria.

## 5. Mandatory Slice Lifecycle

Every executable FUND slice follows:

```text
03-slice-planning acceptance
-> bounded implementation in the owning repository
-> 04-implementation-confirmations
-> 05-review-and-test
-> roadmap status update
-> stop before the next slice
```

Planning must define goal, included models/behavior, exclusions, migration/data policy,
tenant boundary, verification evidence, failure/rollback handling and the single handoff.

Implementation confirmation must record actual files, actual checks, non-goals, database
targets, residual risks and deployment status. It must not claim implementation that has
not occurred.

Review/test must independently verify the accepted boundary, fresh and existing-data
migration where relevant, constraints/tenant isolation, regression safety, zero test
residue and any shared-deployment gate.

## 6. Ownership Boundary

FUND owns:

- Project Store and Store Product configuration;
- Product inputs/media and Project Product snapshots;
- Client branding, Project delivery and Event media;
- production assets and immutable production context;
- Event-default and Project-specific commission policy;
- typed FUND extensions keyed to generic Commerce records.

Commerce owns:

- seller commercial profile;
- checkout, Order and Order-line lifecycle;
- money and tax snapshots;
- payment, refund and pro-forma evidence;
- provider-neutral audit/idempotency and later provider adapters.

Commerce source references remain generic and opaque. FUND validates source identity and
stores typed production/Project context. FUND must not create a substitute generic Order or
payment model.

## 7. Live Gates And Risk Register

| Item | Status | Control |
| --- | --- | --- |
| Application repository | Primary local checkout is B1-R2 candidate `29104b55` on `work/fund-b1-r1-catalogue-workflow`; local DevData migration 156 and connected proof PASS; dev/staging/main unchanged | Restart local server, complete independent review and revised B1-R2/B1-R1 human smoke; no promotion before High-control acceptance |
| Documentation repository | B1-R2 CR/triage/plan/04/05 and revised smoke schedule prepared on main | Commit/publish the lifecycle evidence after validation; recheck exact refs on resumption |
| FUND `1R-F-A` | Complete and closed at PASS on exact `0c7e4848`; zero external residue | Do not rerun or reinterpret the former contained Stage C failure as current state |
| FUND `1R-F-B` / `1R-F-B1` | Enduring framework / B1-R2 source, migration and connected proof PASS after B1-R1 human steps 1–4 PASS | Complete independent review and resumed local human acceptance before promotion |
| Ten-record schema proposal | Unaccepted technical option | Retain in the enduring framework appendix; do not treat it as selected direction |
| E-B/E-C/E-D consolidated human acceptance | Still relevant evidence gate | Complete only through its governed schedule when separately selected; do not infer a new implementation slice |
| Public purchaser and operational journey | Incomplete | Later work must cover Store, checkout, Order operations, artwork matching, production, dispatch and commission in bounded outcomes |
| `2R-ACCESS-01` / `PLAT-REFINE-03` | Parked Platform-parent/FUND-consumer refinement | Elevate only if evidence shows data disclosure or broader authority bypass |
| Real provider or live-data operation | Separately controlled High-risk action | Requires a later accepted outcome with explicit failure, rollback, tenant and environment evidence |

## 8. Current Authoritative Evidence

Architecture and planning:

- `docs/modules/fund/03-slice-planning/2026-07-08-fund-phase-1-slice-1r-a-store-orders-commerce-core-planning.md`
- `docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-b-commerce-core-and-fund-store-schema-options-planning.md`
- `docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c-fund-store-input-schema-foundation-planning.md`
- `docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c1-product-media-input-tax-duplication-schema-implementation-planning.md`
- `docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1r-c2-client-branding-project-delivery-event-media-schema-implementation-planning.md`
- `docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1r-c3-project-store-store-product-schema-implementation-planning.md`
- `docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1r-c4-production-asset-version-schema-implementation-planning.md`
- `docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1r-c5-commission-policy-assignment-schema-implementation-planning.md`
- `docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1r-c6-fund-commerce-context-schema-implementation-planning.md`
- `docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1r-d-store-readiness-c1-configuration-api-services-implementation-planning.md`
- `docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1p-g-r3-project-intake-automated-provisioning-alignment-planning.md`

Completed `1R-C1` lifecycle:

- `docs/modules/fund/04-implementation-confirmations/2026-07-13-phase-1-slice-1r-c1-product-media-input-tax-duplication-schema-implementation-confirmation.md`
- `docs/modules/fund/05-review-and-test/2026-07-13-phase-1-slice-1r-c1-r1-product-media-input-tax-duplication-schema-review-and-test.md`

Completed `1R-C2` lifecycle:

- `docs/modules/fund/04-implementation-confirmations/2026-07-14-phase-1-slice-1r-c2-client-branding-project-delivery-event-media-schema-implementation-confirmation.md`
- `docs/modules/fund/05-review-and-test/2026-07-14-phase-1-slice-1r-c2-r1-client-branding-project-delivery-event-media-schema-review-and-test.md`

Completed `1R-C3` lifecycle:

- `docs/modules/fund/04-implementation-confirmations/2026-07-14-phase-1-slice-1r-c3-project-store-store-product-schema-implementation-confirmation.md`
- `docs/modules/fund/05-review-and-test/2026-07-14-phase-1-slice-1r-c3-r1-project-store-store-product-schema-review-and-test.md`

Completed `1R-C4` lifecycle:

- `docs/modules/fund/04-implementation-confirmations/2026-07-14-phase-1-slice-1r-c4-production-asset-version-schema-implementation-confirmation.md`
- `docs/modules/fund/05-review-and-test/2026-07-14-phase-1-slice-1r-c4-r1-production-asset-version-schema-review-and-test.md`

Completed `1R-C5` lifecycle:

- `docs/modules/fund/04-implementation-confirmations/2026-07-14-phase-1-slice-1r-c5-commission-policy-assignment-schema-implementation-confirmation.md`
- `docs/modules/fund/05-review-and-test/2026-07-14-phase-1-slice-1r-c5-r1-commission-policy-assignment-schema-review-and-test.md`

Completed `1R-C6` lifecycle:

- `docs/modules/fund/04-implementation-confirmations/2026-07-14-phase-1-slice-1r-c6-fund-commerce-context-schema-implementation-confirmation.md`
- `docs/modules/fund/05-review-and-test/2026-07-14-phase-1-slice-1r-c6-r1-fund-commerce-context-schema-review-and-test.md`

Completed `1R-D` lifecycle:

- `docs/modules/fund/04-implementation-confirmations/2026-07-14-phase-1-slice-1r-d-store-readiness-c1-configuration-api-services-implementation-confirmation.md`
- `docs/modules/fund/05-review-and-test/2026-07-14-phase-1-slice-1r-d-r1-store-readiness-c1-configuration-api-services-review-and-test.md`

Completed `1P-G-R3-A` lifecycle:

- `docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1p-g-r3-a-project-intake-automation-schema-form-policy-foundation-implementation-planning.md`
- `docs/modules/fund/04-implementation-confirmations/2026-07-14-phase-1-slice-1p-g-r3-a-project-intake-automation-schema-form-policy-foundation-implementation-confirmation.md`
- `docs/modules/fund/05-review-and-test/2026-07-14-phase-1-slice-1p-g-r3-a-r1-project-intake-automation-schema-form-policy-foundation-review-and-test.md`

Global next planning control:

- `COMMERCE-A6-A - Stripe Connect Account And Event-Inbox Schema Foundation` is
  implemented/reviewed at local application commit `513cf3a`. Its representative and
  fresh 140-migration disposable lifecycles passed with zero residue and no shared
  deployment or runtime Stripe behavior.
- Core Commerce `A6-B - Tenant Payment Settings And Hosted Onboarding` is
  implemented/reviewed at local application commit `e8aecea` on the unchanged 140-migration
  baseline. FUND does not own or duplicate this provider work.
- Core Commerce `A6-C - Connected-account Checkout Adapter` is implemented/reviewed at
  local application commit `34ef64bb` on the unchanged 140-migration baseline. FUND does
  not duplicate this provider work.
- Core Commerce `A6-D - Connected-account Webhook, Payment/Refund Synchronization And
  Reconciliation` is implemented/reviewed at local application commit `fa670e3c` on the
  unchanged 140-migration baseline. FUND consumes later generic Commerce outcomes through
  A7 and does not duplicate Connect receipt or refund synchronization.

Sibling Commerce controls:

- `docs/core/commerce/00-roadmap-control/2026-07-13-commerce-core-roadmap-and-slice-control.md`
- `docs/core/commerce/02-triage/2026-07-13-isostack-commerce-core-schema-foundation-planning.md`

### 8.1 Governed Strategic Completion Inputs — 2026-07-15

The following subordinate strategic view is now registered in this document-control
process:

- `docs/modules/fund/00-roadmap-control/2026-07-15-fund-store-artwork-orders-and-production-strategic-completion-roadmap.md`

It coordinates the route from completed Commerce A6-D through thin A7 integration and the
later Store, artwork, Order operations, production, fulfilment, commission and release
workstreams. It does not select a slice, authorise implementation or supersede this
roadmap.

The strategic view traces these three governed CR inputs:

1. `docs/modules/fund/01-cr-inputs/2026-07-15-fund-application-artwork-template-refinement.md`
2. `docs/modules/fund/01-cr-inputs/2026-07-15-fund-project-product-selection-limits-and-template-capacity-cr.md`
3. `docs/modules/fund/01-cr-inputs/2026-07-15-fund-collective-project-artwork-composition-approval-and-workflow-aware-product-instructions-remedial-clarification.md`

The supporting source brief is retained at:

- `docs/modules/fund/01-cr-inputs/2026-07-15-fund-template-manager-brief.md`

Control treatment:

- the three CRs are planning evidence, not accepted implementation slices;
- their recorded resolved decisions must be preserved by later planning unless explicitly
  superseded through review;
- their open questions remain business-decision gates and must be raised only when a
  bounded slice depends on the answer;
- the source brief's provisional `T1`-`T5` sequence is provenance only and creates no
  executable slice identifiers;
- none of these inputs reopens completed C1-C6, 1R-D or Commerce A1-A6 work; and
- later work must allocate the relevant capability into bounded FUND lifecycles through
  this roadmap rather than implement directly from a CR or the strategic overview.

The immediate A7 planning boundary is deliberately narrow. A7 may consume an authoritative
ready/locked FUND Store offer and preserve exact typed FUND source, workflow,
configuration, input and asset evidence through generic Commerce Order creation and
Checkout invocation. It must not implement the Template Manager, Artwork Template
generation, collective artwork approval, C1/public Store UI, production, fulfilment or
commission capabilities described by the strategic inputs.

## 9. Current Planning Handoff

### 9.1 Current Handoff — 2026-09-07

```text
NOW: FUND 1R-F-B1 Individual Offer And Artwork Journey implementation and validation
NEXT: unselected pending B1 local human acceptance
IMPLEMENTATION AUTHORITY: B1 only, explicitly requested by Chris on 2026-09-07
```

Read the enduring B framework for business context and the B1 draft for the concrete
implementation proposal. B1 is the only active checkpoint. Its D1–D4 decisions cover fixed
initial designs, assignment/finaliser authority, no-unlock first behaviour and the emulated
development result, all now accepted and implemented on the B1 work branch. The
implementation/review records own final automated validation and the local human gate. Purchaser and operational slices remain required in Phase 1 after B1;
the template editor is Phase 2. The longer Phase 1 smoke and later pilot choices remain in the business
situation report. The former C-through-I sequence and ten-model option remain unselected.

### 9.2 Retained Historical Delivery Detail

The following record explains how the existing foundation was reached. Any old branch,
deployment or next-action statement in it is superseded by Sections 0, 2, 4, 7 and 9.1.

No implementation is currently underway. `1P-G-R3-A` is committed at application baseline
`4bb7dd9` with its documentation lifecycle committed at `65fc243`. `1P-G-R3-B` is committed
at application `04da074`, with the R3-B lifecycle and accepted R3-C plan committed at
IsoDocs `6964b58`. `1P-G-R3-C` is complete through implementation confirmation and
review/test and is committed/promoted to application `origin/dev` at `234f115`; it adds no
migration and remains undeployed to staging/main and shared databases. Its atomic confirmation, public-routing, typed-evidence, reviewed-resolution,
legacy regression and complete R3-B regression suites passed against the 134-migration
disposable baseline with zero residue and external email disabled.

The preceding C5 implementation records Event-default, standalone Project and flat-only
Event-Project override configuration plus C2 acceptance/replacement/finalization evidence.
It calculates no commission, creates no Commerce relation and adds no Store service or UI.

The Project Intake alignment exposed by `1R-C2` is now correctly named and initiated as
`1P-G-R3 - Project Intake Automated Provisioning Alignment`. The earlier provisional use of
`1R-D` was invalid because accepted 1R-A architecture already reserves that identifier for
Store Readiness And C1 Store Configuration API/Services.

`1P-G-R3` is an accepted parent reconciliation plan. It traces the complete implemented 1P-G sequence,
K1-F identity/auth contracts and 1R-C2 delivery foundation, and divides future work into
`1P-G-R3-A` schema/form policy, `1P-G-R3-B` automated protection/provisioning services and
`1P-G-R3-C` form/confirmation/exception-review integration. Each child requires its own
full lifecycle. The bounded `1P-G-R3-A` schema/form-policy implementation and independent
review/test are complete. It adds schema evidence only; no form is opted in and no runtime
automation, provisioning, confirmation, moderation, email or UI behaviour was added.

Parent review added three legacy-safety controls to the accepted contract: aligned forms
require an explicit contract/scope/revision marker rather than inference from
`requiresModeration`; submissions snapshot the form contract/revision so confirmation can
detect a changed offer; and provisioning path records `AUTOMATED` versus `C1_REVIEW` while
the separate exception reason distinguishes an actual exception from an intentional manual
form.

The implemented `1P-G` forms, public routes, confirmation and moderation workflow are the
operational baseline for `1P-G-R3`, not an immutable design. The later accepted
Client/organiser/Project/delivery contract takes precedence where necessary; bounded form
and approval-surface rework is allowed, while historic evidence, tenant/Event trust,
confirmation security and stable issued public links are preserved where feasible.

The R3-A/R3-B/R3-C Intake alignment and R3-D direct Project-creation alignment are complete.
R3-D establishes structured Client addresses, required Client ownership, typed Project
type, exact organiser-member identity and atomic Project delivery profiles for C1 and C2
dashboard creation. Its 134-to-135 and fresh 135-migration disposable lifecycles,
R3-B/R3-C regressions and zero-residue cleanup passed. Application commit `e1c2d9f` is
included on `origin/dev` at `3206199`, and documentation commit `9d140fa` is included on
IsoDocs `origin/main`. Shared databases remain undeployed.

`COMMERCE-A2` is implemented/reviewed in its Core lane on `origin/dev` at `3206199`.
Its generic Order/line models and exact same-tenant keys supported completed FUND `1R-C6`.

FUND `1R-C6 - FUND Commerce Context Foundation` is implemented/reviewed at local
application commit `9947669`. Its 136-to-137, refusal and fresh 137-migration disposable
lifecycles passed with zero residue; it is not pushed or deployed to a shared database.

FUND Store `1R-D - Store Readiness And C1 Store Configuration API/Services` is
implemented/reviewed at local application commit `db85fcc`. It consumes the completed
C1-C6 evidence without a schema change, passed its tenant/readiness/version/lifecycle/
duplication/rollback suite against the unchanged 137-migration disposable baseline and
left zero prefixed test residue. It is not pushed or deployed to a shared environment.

Commerce `A3 - Payment, Refund And Pro-forma Schema Foundation` is implemented/reviewed at
local application commit `4a90be1`. Its representative 137-to-138 and fresh 138-migration
disposable lifecycles passed with A1/A2/C6 regressions and zero residue. It is not pushed or
deployed to a shared environment and adds no runtime payment behavior.

Historical reconciled control outcome before the 2026-09-07 correction:

```text
`COMMERCE-A7 - FUND Consumer Integration` is implemented/reviewed as a dormant internal
boundary on the unchanged 140-migration baseline. Its implementation at `598305ce` is
included in application dev/staging commit `91e8751c`; automated gates, staging health,
FUND-admin login and pre-existing UI smoke verification passed. The FUND
`1R-E - C1 Store Oversight And C2 Project Store Control Alignment` parent plan is reviewed
and accepted at
`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-e-c1-store-oversight-c2-project-store-control-alignment-planning.md`.
The bounded E-A plan is created at
`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-e-a-store-authority-exceptional-intervention-lifecycle-service-alignment-implementation-planning.md`
and its local implementation/review lifecycle has passed against the 141-migration
disposable baseline with zero residue. The bounded `1R-E-B - C1 Store Portfolio Oversight
And Exceptional Intervention Surface` implementation/review lifecycle passed locally at
`docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-e-b-c1-store-portfolio-oversight-exceptional-intervention-surface-implementation-planning.md`.
It adds no migration and is promoted through dev/staging in application commit `e3f44b4b`.
The bounded `1R-E-C - C2 Project Store Control Surface` plan and implementation/review
lifecycle are promoted in the same application commit
at `docs/modules/fund/03-slice-planning/2026-07-15-fund-phase-1-slice-1r-e-c-c2-project-store-control-surface-implementation-planning.md`.
E-C adds no migration. Post-promotion review found that its human schedule cannot start from
the real empty FUND state because Project creation creates no Store/default eligible Product
set. E-B/E-C human acceptance is therefore blocked, not failed. The governed E-D input is at
`docs/modules/fund/01-cr-inputs/2026-07-21-fund-default-project-store-and-eligible-product-presumption-input.md`
and the bounded E-D plan is at
`docs/modules/fund/03-slice-planning/2026-07-21-fund-phase-1-slice-1r-e-d-default-project-store-instantiation-eligible-product-reconciliation-implementation-planning.md`.
E-D is implemented/reviewed at `c45a41d9` and is included by ancestry in current application
`83356030`, with no E-D migration or shared reconciliation. Its human schedule is recorded
in the E-D review. The
non-executable `1R-F - Project Offer And Artwork Readiness Reconciliation` parent is
reviewed/accepted and records the separate Individual, collective and Standard readiness
branches. `1R-F-A - Real AMOW Template, Pricing And Deployed Renderer Proof` has green Stage
A, source/physical and Stage B Linux-container evidence at exact dev `139d09c4`. The prior
Stage C runner failure is contained with zero residue. Corrected Stage C-R1 passes its exact
`0c7e4848` local/Linux/security gates and the one authorised external Render/private-R2
behavioural run. Its exact prefix, Render variables/service, bucket, provider authorities,
local credential records and helpers are absent; both retained provider values returned
HTTP 401 before local deletion. `1R-F-A` is complete and closed at PASS. The later
2026-09-07 correction redefines `1R-F-B` as the user/workflow/proportionality review and
retains the former schema draft only as unaccepted evidence. Root `Next` remains
unselected; no `1R-G`, further run or artwork/template production implementation is
authorised.
```

## 10. Roadmap Maintenance Rule

After every planning acceptance, implementation confirmation or review/test outcome:

1. update this current control first;
2. update the root roadmap when lane status or cross-lane dependencies change;
3. update the Commerce roadmap only when Commerce status/dependency statements change;
4. verify that exactly one next candidate is named and that it is not falsely authorised;
5. move superseded operational detail into Appendix A or another archive/triage record;
6. ensure branch, commit, migration and deployment claims match repository evidence;
7. register every new CR or supporting brief in Section 0 in the same documentation change
   that creates it, then reconcile any strategic overview before it can influence a bounded
   plan;
8. reconcile every promoted, deferred or completed refinement with the subordinate
   2026-07-20 register without allowing that register to select the next slice;
9. carry only the decisions relevant to the selected slice and preserve unrelated open
   questions for their owning future workstream; and
10. run Markdown fence, path and `git diff --check` validation.

The root roadmap is authoritative when the selected portfolio outcome crosses from FUND to a
sibling Core lane. This FUND roadmap must record the resulting wait state rather than name
an independently available FUND slice as the global next action.

## Appendix A. Historical Roadmap Ledger

The remainder of this file is preserved for decision history only. It is non-authoritative
for current branch state, current slice selection or implementation permission. Refer to
sections 1 through 10 above for all current control decisions.

### A.1 Historical Released Baseline

The FUND Phase 1 baseline has moved beyond 1P-G-C-R1. The current released/live baseline is through the 1P-K2 Client dashboard route fix.

Current released app baseline:

```text
bb50bc6 fix(fund): allow c2 client dashboard route
```

Current remote branch alignment after 1P-K2 live promotion:

```text
main    = bb50bc6 accepted FUND Phase 1 baseline through 1P-K2 route fix
dev     = bb50bc6 accepted FUND Phase 1 baseline through 1P-K2 route fix
staging = bb50bc6 accepted FUND Phase 1 baseline through 1P-K2 route fix
```

Release result:

- FUND Phase 1 baseline through 1P-K2 is aligned to `main`.
- SeasonPro/LMSPro export hotfix is included in the released baseline.
- Staging browser testing found no blocking C1 admin foundation issues before release alignment.
- FUND remains expected to need refinement; the baseline is accepted as the foundation, not as final product polish.
- 1P-R1/1P-R1A remediation, 1P-B schema work and 1P-C read-only organiser Project API/services were aligned to `staging` at `69a9632`.
- 1P-D read-only organiser dashboard UI has been implemented on `feature/fund-phase-1-c2-project-access` at `f43d63b`, reviewed with caveats and aligned to `dev` and `staging`.
- 1P-D staging alignment was pushed by operator request; Render deployment and migration confirmation remain post-deploy checks.
- A post-1P-D C2 organisation/account scope clarification has been raised. The current participant-scoped dashboard remains safe but should be treated as an interim bridge until this is decided.
- Additional correction: C2 is the Project management node, not a passive/read-only recipient of Project information. Future C2 dashboard work must be Client/account scoped, not merely participant scoped.
- AMOW founding-tenant priority has been re-centred on the C1 organisational dashboard: C1 Client management, Products, Events, Projects and the operational framework for managing fundraising Clients and their Projects.
- 1P-D remains technically safe but is not the immediate AMOW product priority.
- 1P-F-C C1 Client Management schema has been implemented and aligned to `dev`/`staging` as part of `da6fd0f`.
- 1P-F-D C1 Client Management API/services has been implemented and aligned to `dev`/`staging` as part of `da6fd0f`.
- 1P-F-E C1 Client Management UI has been implemented, reviewed with caveats and aligned to `dev`/`staging` as part of `da6fd0f`.
- Client is the C2 organisation/account concept. Primary contact fields on `FundClient` are C1 operational contact snapshots only, not the final Client user/member model.
- Client users/members, roles, invitations and notification boundaries require a future planning slice before implementation.
- Client organisation details, structured physical addresses, delivery/fulfilment defaults and Project-level delivery snapshots/overrides require future planning before Store, Orders, Production or Dispatch.
- Existing Client dashboard Project initiation must use trusted Client route, token or authenticated context and should auto-scope requests or Projects to the authenticated Client/account. It must not infer Client ownership from organiser snapshot fields, respondent email alone, proposed Client contact fields alone or user-editable hidden fields.
- 1P-H Project Client selector/linkage planning is complete. 1P-H-A API/services and 1P-H-B UI are committed on `feature/fund-phase-1-c2-project-access` at `536c947` and aligned to `dev`/`staging`.
- 1P-H-C static/code review and authenticated staging browser smoke testing passed. No remedial work is required at this stage.
- 1P-G-A Project Intake Schema And Moderation Model planning is complete. Project Intake remains moderation-first: submissions must not directly create Clients, Client users, Projects, Event links, notifications or invitations.
- 1P-G-B Project Intake Schema Options planning is complete and has led into 1P-G-C schema-only implementation.
- 1P-G-C Project Intake schema-only implementation and 1P-G-C-R1 schema review are complete. Staging deployment/smoke testing passed; pre-existing data loads correctly and no remedial work is required at this stage.
- 1P-G-D0 Client-Scoped Project Initiation And Idempotency planning is complete. Unknown/public intake and new Client onboarding remain moderation-first. Existing authenticated C2 Client users with the correct future Client role/permission create Client-owned Projects directly under `FundProject.clientId` from trusted Client/account context. C1 is the FUND producer tenant/supplier/fulfilment operator, not the default approver of Project existence. Later activation, Store, Commerce, production, dispatch and notification gates may still require C1 approval or separate policy.
- Implementation priority after 1P-G-D0 is the moderated Project initiation form and C1 approval services. Authenticated Client dashboard direct Project creation remains a later Client dashboard / role-permission lane.
- 1P-G-D Project Intake Moderation API/Services planning is complete. The recommended implementation split starts with C1 Project Intake Form API/services, then C1 submission review services, then explicit approval-action planning.
- 1P-G-D1 C1 Project Intake Form API/Services has been implemented. It adds C1 admin form list/get/create/update/activate/pause/archive/restore only.
- 1P-G-D2 C1 Project Intake Submission Review API/Services has been implemented. It adds confirmed-submission queue/detail/review/status services only.
- 1P-G-D3 Project Intake Approval Action Planning is complete. It defines explicit C1 approval actions and records the future C1 approval summary card with row click-through to a dedicated approval page.
- 1P-G-D3-A Project Intake Approval API/Services has been implemented. It adds explicit C1 approval procedures for creating/linking C2 Client organisations and Projects from reviewed submissions.
- 1P-G-D3-A-R1 Project Intake Approval API/Services Review is complete. Verdict: proceed with caveats; no blocking defects were found, but return-to-review status policy and authenticated API smoke testing remain follow-ups before approval UI implementation.
- 1P-G-E C1 Project Intake Moderation And Approval UI has been implemented. It adds the C1 Project Intake dashboard action card, moderation landing page, form admin pages, submission detail/review page and explicit approval page.
- 1P-G-E-R1 C1 Project Intake Moderation And Approval UI Review is complete. Verdict: proceed; authenticated browser smoke testing on dev passed with no remedial work requested before staging promotion.
- 1P-G-F Public Project Initiation Form UI Planning is initiated. It plans the public/client-facing multi-step Project initiation form UI and preserves the moderation-first boundary.
- General email content, trigger behaviour, default recipients and pause/resume controls for FUND must be handled through a dedicated communications/notifications UI, following the SeasonPro/LMSPro communications Notifications tab precedent. Project Intake implementation slices should use placeholder trigger annotations, except that email required for authentication or confirmation steps may use bounded hard-coded transactional copy until the notification lane exists.
- The first visible Project initiation form should use trusted branding/letterhead/footer fallback: trusted Client/tenant branding, then FUND module branding, then IsoStack/platform branding. It should use client-facing sections for Project basics, organisation details and main organiser details. It should include "What kind of fundraising project would you like to run?" with options for artwork fundraising, group personalised products, bulk order / club-funded projects and "not sure yet". It should not ask whether a Store is required.
- Project Intake forms may be general or Event-scoped. Event-scoped forms use the trusted C1 form definition `FundProjectIntakeForm.defaultEventId`; public respondents must not choose or spoof internal Event linkage through editable fields. Approved Projects remain C2 Client-owned through `FundProject.clientId` and may link to the scoped C1 Event.
- C1 Project Intake form admin must expose Default Event selection for Event-scoped forms and provide a clear copy/open public link affordance for `/fund/project-initiation/[formSlug]` to support testing and tenant operation.
- 1P-G-F-A-R1 staging security/pre-live review found staging healthy and C1 Project Intake admin protected, but the intended public Project initiation route `/fund/project-initiation/*` currently redirects unauthenticated users to sign-in. This is safe but blocks the intended public workflow.
- 1P-G-F-A-R2 planning records the required remediation before live promotion: public route allowlisting, vanilla public page without IsoStack marketing navigation, Event-scoped form constraints from trusted `FundProjectIntakeForm.defaultEventId`, Project start/closing date fields and validation, aligned date/time picker usage, bounded allowed Client/organisation type selection and form-field helper text alignment.
- 1P-G-F-A-R2-A implemented the public route and Event-scoped form remediation: `/fund/project-initiation/*` is intentionally public, public pages no longer inherit the generic IsoStack marketing navigation, Event-scoped forms default/constrain Project dates from the linked Event, general forms require Project start/closing dates, and allowed organisation types are bounded in C1 form create/edit and public submission validation.
- 1P-G-F-A-R2-B staging smoke/security review passed with no major blockers. Remaining remedial observations should be captured through a CR and planned as a batch remediation slice rather than blocking live promotion.
- 1P-G-F-A-R2 live promotion target is `b1ee0fd`, aligning `main`, `dev` and `staging` to the public Project initiation remediation.
- Phase 2 refinement wishlist control has been created at `00-roadmap-control/2026-06-30-fund-phase-2-refinement-wishlist-and-slice-control.md`. Use it to park desirable but non-blocking refinements such as Event media/branding, Event type option sets, Client organisation type option sets, embed route/CSP planning, action-widget polish and communications defaults without interrupting Phase 1 structural momentum.
- 1P-K0 Client Dashboard And Client-Owned Project Lifecycle Planning is initiated as the next core planning lane after public Project initiation remediation review. The Client dashboard should allow authenticated C2 Client users to monitor their Projects, create directly Client-owned Projects from trusted Client context, select available live Events or standalone Project creation where allowed, and download Project templates/resources. Sales monitoring is a future dashboard purpose but depends on Store/Orders/Commerce. Communications/announcements and commission payment management are wishlist/future surfaces, not first implementation scope.
- 1P-K1 Client User/Member Access Model And C1 Management Planning is initiated as the practical bridge before the C2 Client dashboard. C1 Client detail should evolve into top-level tabs for Client Details, Projects and Users. The Projects tab should show linked Projects with search/filter/sort and row click to Project detail. The Users tab should allow C1 to manage Client users/members who may later access FUND as C2 users, but onboarding/access email remains a manual operational step until the dedicated 1P-N0 notification/email lane is accepted.
- 1P-K1-A Client User/Member Schema Options Planning recommends a small FUND-specific `FundClientMember` model rather than reusing Project participants or platform Users alone. The model should be tenant-scoped, Client-scoped, optionally linked to a platform `User`, and should separate role labels from access permissions. Schema implementation is the next bounded step, with no automatic email, invitations, C2 dashboard UI or Client-owned Project creation.
- 1P-K1-E Client User/Member Management review confirms the C1 Client detail tabs and member creation/editing work in browser smoke testing after the dev database migration was applied. Client member login/onboarding is not implemented yet; attempted login currently reaches an auth configuration error rather than a C2 Client dashboard, which is expected for K1-B/C/D but must be planned before K2.
- 1P-K1-F Client Member Login/Onboarding And Auth Routing Planning is required before K2. It must define platform User link/create policy, magic-link/manual onboarding boundary, post-auth routing, safe unavailable states and the rule that C2 Client users must not be routed to `/platform`, P1 or C1 dashboards by default.
- 1P-K2 C2 Client Dashboard And Client-Owned Project Management Planning is initiated. K2 should replace the temporary Client unavailable state with the first authenticated C2 dashboard: Client context, Projects list, Client-owned Project create/edit basics, row click to Project detail and Details/Products/Orders tabs. Client-created Projects should capture the same Project type / fundraising format option used by the public Project initiation form so later Product/Catalogue suitability can constrain selectable Products. Products and Orders are placeholders only until Product availability and Store/Orders/Commerce planning is accepted.
- 1P-K2-B C2 Client Dashboard UI is implemented on top of K2-A services. It adds `/app/fund/client`, `/app/fund/client/projects` and `/app/fund/client/projects/[id]`, replaces the temporary C2 unavailable redirect, hides the C1 tenant admin sidebar on FUND Client routes, and keeps Products/Orders as placeholders only pending later Product and Commerce planning.
- 1P-K2 live promotion completed at `bb50bc6`. K2-C review records successful C2 dashboard smoke testing after the middleware route-loop fix. Live smoke should confirm C2 access to `/app/fund/client`, Project create/edit, Project detail row click and C2 denial from C1 admin routes.
- 1Q-A Product/Catalogue Suitability Schema Options Planning is complete.
- 1Q-B Event/Catalogue Availability Schema Implementation is complete as schema foundation.
- 1Q-C C1 Event Catalogue Availability API/Services is implemented in app commit `2bb8db3`.
- 1Q-D C1 Event Catalogue Availability UI is implemented in app commit `28662af` and documented in `04-implementation-confirmations` and `05-review-and-test`.
- 1Q-D-R1 review/test is accepted as passed: static checks, targeted ESLint, `git diff --check`, `npm run type-check`, `npm run verify`, route smoke and operator-confirmed authenticated C1 browser smoke are accepted. Detailed UI/UX revisions are deferred to refinement.
- 1Q-E Project Product Eligibility API/Services planning is created at `03-slice-planning/2026-07-01-fund-phase-1-slice-1q-e-project-product-eligibility-api-services-planning.md`.
- 1Q-E Project Product Eligibility API/Services is implemented and promoted to `origin/dev` / `origin/staging` at app commit `7a7354a`; implementation confirmation is created at `04-implementation-confirmations/2026-07-01-phase-1-slice-1q-e-project-product-eligibility-api-services-confirmation.md`.
- 1Q-E-R1 Project Product Eligibility API/Services Review And Smoke Test is accepted as passed: static checks, type-check, targeted ESLint, `npm run verify`, `git diff --check` and transaction-scoped API/service smoke are documented in `05-review-and-test/2026-07-01-phase-1-slice-1q-e-r1-project-product-eligibility-api-services-review-and-smoke-test.md`.
- 1Q-F Catalogue-Centric Project Product Picker UI planning is created at `03-slice-planning/2026-07-01-fund-phase-1-slice-1q-f-catalogue-centric-project-product-picker-ui-planning.md`.
- 1Q-F Catalogue-Centric Project Product Picker UI implementation is started locally and documented at `04-implementation-confirmations/2026-07-06-phase-1-slice-1q-f-catalogue-centric-project-product-picker-ui-confirmation.md`; 1Q-F-R1 functional browser smoke is operator-confirmed as passed in `05-review-and-test/2026-07-06-phase-1-slice-1q-f-r1-catalogue-centric-project-product-picker-ui-review-and-smoke-test.md`, with broader UX refinement deferred.
- 1Q-F browser review surfaced a future Event-side management refinement: Event detail should expose linked Catalogues and contributed Products so Events become visible C1 management units. This is parked as `2R-EVENT-05`.
- 1Q-G-R1 Availability Review And Store/Commerce Readiness Check passed on local app `dev`
  after Project context, Organisation Type, Availability UI and Project Product picker
  remediation. The accepted picker shape is now a single filterable eligible Product table
  with Catalogue source badges and one selected Product state per Product.
- 1Q-G-R1 accepted app baseline is promoted to `origin/dev` and `origin/staging` at
  `ea4e619` for online staging testing.
- 1R-A Store, Orders And Commerce Core Planning is created at
  `03-slice-planning/2026-07-08-fund-phase-1-slice-1r-a-store-orders-commerce-core-planning.md`.
  This remains Phase 1 structural work rather than Phase 2 refinement because Store and
  Order data contracts must exist before later refinement/UAT polish can safely proceed.
- 1R-A architecture and business decisions are accepted. 1R-B Commerce Core And FUND Store
  Schema Options Planning is created at
  `03-slice-planning/2026-07-13-fund-phase-1-slice-1r-b-commerce-core-and-fund-store-schema-options-planning.md`.
  It keeps generic checkout/Order/payment ownership in a separate reusable Commerce Core
  lane while FUND owns Project Store, Store Product and production context.
- 1R-B planning is accepted. 1R-C FUND Store/Input Schema Foundation Planning is created at
  `03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c-fund-store-input-schema-foundation-planning.md`.
- Separate platform planning for the proposed `commerce` database schema is created at
  `docs/core/commerce/02-triage/2026-07-13-isostack-commerce-core-schema-foundation-planning.md`.
- 1R-C and the separate Commerce Core schema-foundation plan are accepted as architecture
  plans. Their first bounded implementation plans are created for review at
  `03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c1-product-media-input-tax-duplication-schema-implementation-planning.md`
  and
  `docs/core/commerce/03-slice-planning/2026-07-13-isostack-commerce-core-slice-commerce-a1-schema-seller-profile-enums-implementation-planning.md`.
  Neither plan authorises schema or application implementation before its own acceptance.
- COMMERCE-A1 planning is accepted and its bounded application-repository implementation is
  completed and reviewed as passed: the `commerce` namespace, Seller Profile, four A1 enums,
  migration and verification scripts are present. Static/generated-client review, fresh and
  existing-schema disposable PostgreSQL migration, and rollback-only constraint smoke pass.
  The dedicated Neon `TEST_DATABASE_URL` target is retained as disposable test
  infrastructure for future accepted test plans; its URL remains local and uncommitted. No
  shared development, staging or live deployment is claimed. Records are at
  `docs/core/commerce/04-implementation-confirmations/2026-07-13-commerce-a1-schema-seller-profile-enums-implementation-confirmation.md`
  and
  `docs/core/commerce/05-review-and-test/2026-07-13-commerce-a1-schema-seller-profile-enums-review-and-test.md`.
- FUND `1R-C1` is implemented and reviewed as passed. The Product media/input/tax/copy
  provenance schema, migration and verifiers are complete; representative existing-data
  upgrade, all-129-migration fresh reset, constraint/default smoke and zero-residue checks
  passed on the retained disposable Neon test database. No shared deployment occurred.
  Records are at
  `04-implementation-confirmations/2026-07-13-phase-1-slice-1r-c1-product-media-input-tax-duplication-schema-implementation-confirmation.md`
  and
  `05-review-and-test/2026-07-13-phase-1-slice-1r-c1-r1-product-media-input-tax-duplication-schema-review-and-test.md`.
- At the completion of `1R-C1`, no next slice was authorised and `1R-C2` was recorded as
  the next candidate; that historical handoff has since been completed. `COMMERCE-A2`
  remains future work in its sibling lane.
- Planning handoffs are recorded in `02-triage`, not implementation confirmations:
  `02-triage/2026-07-13-phase-1-slice-1r-b-store-and-commerce-planning-handoff.md` and
  `02-triage/2026-07-13-phase-1-slice-1r-c-and-commerce-a1-planning-handoff.md`.
- Commission Ladder Planner input is captured at
  `01-cr-inputs/2026-07-13-fund-cr-commission-ladder-planner-input.md` and must be
  considered inside 1R-A because aggregate Project-sales commission calculation depends on
  reliable Order sales evidence and ladder/version auditability.
- Recommended major core sequence after 1Q-G remains: Store/Orders/Commerce core planning,
  with C1 production/dispatch/commission constraints considered before implementation.
- 1P-G-C2-A Project Intake Email Confirmation Schema Addendum is implemented as schema-only work. It adds `CONFIRMATION_PENDING`, confirmation token/hash expiry fields, confirmation/submitted timestamps and idempotency/fingerprint fields so future public form services can separate unconfirmed records from actionable C1 moderation submissions.
- 1P-K2 live/main alignment target was `bb50bc6`; K2 live promotion is confirmed in `05-review-and-test/2026-06-30-phase-1-slice-1p-k2-live-promotion-confirmation.md`.
- Future Client dashboard is not merely passive Project display. It is expected to become the Client Project initiation, engagement, announcements, special offers/campaign prompts, 1:1 communication and dashboard-visible communications surface.
- C1 dashboard is the Project administration, artwork checking, production grouping, dispatch/fulfilment and commission workflow surface.
- Store, Orders and Commerce must align with the future Client dashboard and C1 production/admin workflow surfaces rather than proceeding as isolated features.
- 1P-I C1 Production, Dispatch And Commission Workflow planning note is created to protect production/admin design before Store/Commerce implementation.
- 1P-J SeasonPro Club to FUND Project Initiation planning placeholder is created to preserve the future Club-originated intake path without implementing SeasonPro integration.
- Project Intake and Commerce must not proceed as isolated features without preserving the future Client dashboard engagement surface and C1 production/admin workflow surface.
- Project Intake / Project Request forms are a future critical lane. C1-created forms may eventually collect external or Client-originated Project requests and, after C1 moderation, create or link Client/account, C2 user/member, Project and Event records.
- SeasonPro Club-originated Project initiation is a future intake path. It depends on SeasonPro League FUND/Fundraising module entitlement, League configuration of approved FUND producer tenant(s), catalogue availability to Clubs, sale method planning and explicit Club-to-FUND Client/account mapping.
- Notification management remains deferred. Project intake, Client creation, C2 user creation and Project approval must not accidentally send notifications until controlled communications are explicitly planned.
- Staging `/api/health` returned HTTP 200 after alignment.
- Current app refs after 1Q-G-R1 staging promotion: local `dev`, `origin/dev`,
  local `staging` and `origin/staging` are aligned at `ea4e619`.
- Docs repo local `main` records the accepted 1Q-G-R1 browser PASS and staging promotion.

### A.2 Historical Branch Landscape

#### Historical Release Branches

```text
main
dev
staging
```

Current state:

```text
origin/main    live baseline at bb50bc6
origin/staging 1Q-E Project Product Eligibility API/Services at 7a7354a
origin/dev     aligned with local dev at 7a7354a
local dev      aligned with origin/dev at 7a7354a
```

Use:

- `main` is the live/release baseline through accepted 1P-K2 work.
- `staging` carries the 1Q-E Project Product Eligibility API/Services at `7a7354a` for staging test.
- local `dev` is aligned with `origin/dev` at `7a7354a`.
- If the app checkout is on `staging`, switch to `dev` before implementing 1Q-F.

#### Former FUND Working Branch

```text
dev
```

Purpose:

- FUND Product/Catalogue suitability 1Q work.
- Local implementation and verification before staging/live promotion.
- At that historical point, the next slice was 1Q-F Catalogue-Centric Project Product
  Picker UI Remediation.
- Its historical follow-on was 1Q-G Availability Review And Store/Commerce Readiness
  Check.

#### Historical FUND Feature Branch

```text
feature/fund-phase-1-c2-project-access
```

Purpose:

- Historical FUND C2 organiser/client access and Project Intake work.
- No longer the current Product/Catalogue suitability working lane.

This branch should not absorb unrelated SeasonPro remediation unless intentionally cherry-picked.

#### Former SeasonPro Remediation Branch

```text
feature/seasonpro-remediation
```

Purpose:

- SeasonPro/LMSPro fixes that should be testable/promotable without carrying unfinished FUND work.

This branch exists so SeasonPro remediation can move independently of future FUND C2 development.

#### Retired / Historical FUND Feature Branch

```text
feature/fund-phase-1-products-catalogues
```

Purpose:

- Historical branch used for the C1 admin foundation.
- It has been promoted into the release baseline.

Recommendation:

```text
Do not continue new work on this branch.
```

### A.3 Completed C1 Admin Foundation Slices

The completed C1 foundation is documented across planning and implementation confirmation files in:

```text
isodocs/docs/modules/fund/Planning/
isodocs/docs/modules/fund/implementation/
```

#### Completed Slice Summary

| Slice | Area | Status |
| --- | --- | --- |
| 1C | Product Workflow Classes | Complete |
| 1D | Products/Catalogues schema | Complete |
| 1E | Products/Catalogues API/services | Complete |
| 1F-A | Products/Catalogues core admin UI | Complete |
| 1F-B | Catalogue Product membership manager | Complete |
| 1G | Products/Catalogues review/remediation | Complete |
| 1H | Project schema | Complete |
| 1I | Project API/services | Complete |
| 1J-A | Project list and child management shell | Complete |
| 1J-B | Project Product membership manager | Complete |
| 1K | Project admin UI review/manual testing | Complete |
| 1L-A | FundEvent schema | Complete |
| 1L-B | FundEvent API/services | Complete |
| 1L-C | FundEvent API/manual review | Complete |
| 1M-A | FundEvent admin UI | Complete |
| 1M-B | Project Event selector/linkage UI | Complete |
| 1M-C | Project/Event linkage UI review | Complete |
| 1N | C1 admin foundation authenticated review | Complete |
| 1O | C1 admin foundation staging readiness/release alignment | Complete |
| 1P-A | C2 Project Access Model Planning | Complete |
| 1P-B | C2 Project Participant Schema | Complete / aligned to dev+staging |
| 1P-C | C2 Read-Only Project API/Services | Complete / reviewed / aligned to dev+staging |
| 1P-C-R1 | C2 Read-Only Project API/Services Review | Complete / proceed with caveats |
| 1P-D | C2 Read-Only Organiser Dashboard UI | Implemented / reviewed with caveats |
| 1P-D-R1 | C2 Dashboard UI Review And C2 Organisation Scope Note | Complete / proceed with caveats |
| 1P-D0 | C2 Organisation Scope Clarification | Active planning clarification |
| 1P-F | C2 Client/Account Organisation Model Planning | Active architecture planning |
| 1P-F-CORR | C2 Client/Account As Project Management Node Planning | Active architecture correction |
| 1P-F-A | C1 Client Management Foundation For AMOW | Planning complete |
| 1P-F-B | C1 Client Management Schema Options | Planning complete |
| 1P-F-C | C1 Client Management Schema | Implemented / aligned to dev+staging |
| 1P-F-D | C1 Client Management API/Services | Implemented / aligned to dev+staging |
| 1P-F-E | C1 Client Management UI | Implemented / reviewed with caveats / aligned to dev+staging |
| 1P-F-F | Client Organisation Details, Users, Roles And Notification Planning | Future planning note created |
| 1P-H | Project Client Selector And Linkage Planning | Planning complete |
| 1P-H-A | Project Client Linkage API/Services | Implemented / aligned to dev+staging |
| 1P-H-B | Project Client Selector UI | Implemented / aligned to dev+staging |
| 1P-H-C | Project Client Linkage UI Review | Complete / accepted |
| 1P-G-A | Project Intake Schema And Moderation Model Planning | Planning complete |
| 1P-G-B | Project Intake Schema Options Planning | Planning complete |
| 1P-G-C | Project Intake Schema | Implemented / reviewed / accepted |
| 1P-G-C2-A | Project Intake Email Confirmation Schema Addendum | Implemented schema-only |
| 1P-G-D0 | Client-Scoped Project Initiation And Idempotency Planning | Planning complete |
| 1P-G-D | Project Intake Moderation API/Services Planning | Planning complete |
| 1P-G-D1 | C1 Project Intake Form API/Services | Implemented |
| 1P-G-D2 | C1 Project Intake Submission Review API/Services | Implemented |
| 1P-G-D3 | Project Intake Approval Action Planning | Planning complete |
| 1P-G-D3-A | Project Intake Approval API/Services | Implemented |
| 1P-G-D3-A-R1 | Project Intake Approval API/Services Review | Complete / proceed with caveats |
| 1P-G-E | C1 Project Intake Moderation And Approval UI | Implemented / reviewed / staging candidate |
| 1P-G-E-R1 | C1 Project Intake Moderation And Approval UI Review | Complete / proceed |
| 1P-G-F | Public Project Initiation Form UI Planning | Planning initiated |
| 1P-N0 | FUND System Notifications And Editable Email Defaults Planning | Future planning lane |
| 1P-I | C1 Production, Dispatch And Commission Workflow Planning | Planning note created |
| 1P-J | SeasonPro Club To FUND Project Initiation Planning | Future planning placeholder created |

#### C1 Admin Surfaces Released

Released C1/admin routes include:

```text
/app/fund
/app/fund/products
/app/fund/projects
/app/fund/projects/[id]
/app/fund/events
/app/fund/events/[id]
```

Released C1/admin domains include:

- Products.
- Catalogues.
- Catalogue Product membership.
- Projects.
- Project Product membership.
- Events.
- Project/Event linkage.
- Activation readiness basics.
- FUND module/product allocation foundation.

### A.4 Historical Remediation Lane

Source triage document:

```text
isodocs/docs/modules/fund/02-triage/2026-06-25-fund-c1-admin-remediation-and-architecture-triage.md
```

Source issue export:

```text
isodocs/docs/modules/fund/01-cr-inputs/change-request-cmqt61xmf000612xt5ifl1mdn-2026-06-25.md
```

#### Historical Immediate Remediation

These have been handled at code/static-check level and should receive an authenticated browser spot-check before staging promotion:

1. Issue #46 - Project close date after linked Event close date accepted.
2. Issue #50 - Issue Manager module filtering/server render error.

#### Historical Near-Term UI/UX Remediation

These were included because scope remained small:

1. Issue #47 - Adding a Project Product is an activation gate but not intuitive.
2. Issue #44 - Product breadcrumb navigation.
3. Issue #45 - Sidebar icons repeated; update UI guidance.

#### 1P-R1A UI Consistency Addendum

An iterative UI consistency addendum was documented retrospectively as:

```text
03-slice-planning/2026-06-25-fund-phase-1-slice-1p-r1a-c1-admin-ui-consistency-remediation.md
04-implementation-confirmations/2026-06-25-phase-1-slice-1p-r1a-c1-admin-ui-consistency-remediation-confirmation.md
```

It covers:

- whole-card FUND dashboard navigation;
- brand/semantic colour use instead of decorative peer-card colours;
- column-header sort/reverse-sort;
- consistent breadcrumbs;
- destination-specific navigation icons;
- Issue Manager `Modules` CRUD field consolidation to match filtering, badges and CR exports.

Historical branch used for this remediation:

```text
feature/fund-phase-1-c2-project-access
```

Recommended remediation principle:

```text
Fix the C1 foundation in place before exposing dependent behaviour to C2 organisers.
```

#### C2 Access Lane Status

Current branch state is controlled by section 2. Historical branch state at the earlier C2 planning point was:

```text
feature/fund-phase-1-c2-project-access = historical C2/Project Intake branch
```

Current C2 lane status through K2:

- 1P-A access model planning is complete.
- 1P-B participant schema is implemented.
- 1P-C read-only organiser Project API/services are implemented and reviewed.
- 1P-D read-only organiser dashboard UI is implemented and statically reviewed with caveats.
- 1P-D0 C2 organisation/account scope clarification has been raised and must be decided before C2 expansion.
- 1P-H-A Project Client linkage API/services are implemented, static-check passed and committed.
- 1P-H-B Project Client selector UI is implemented, static-check passed and committed.
- 1P-H-C review and authenticated staging smoke testing are complete and accepted.
- 1P-H alignment status: feature branch, `dev` and `staging` are aligned at `536c947`.
- 1P-G-A Project Intake schema/moderation model planning is complete.
- 1P-G-B Project Intake schema options planning is complete.
- 1P-G-C Project Intake schema-only implementation and 1P-G-C-R1 schema review are complete and accepted.
- 1P-G-D0 Client-scoped Project initiation and idempotency planning is complete.

Staging migration note:

- Render build runs `prisma migrate deploy` through `scripts/render-build.sh`.
- Neon Prisma migrations are expected to happen automatically during Render deployment because the Render build executes `prisma migrate deploy`.
- Direct staging `_prisma_migrations` inspection was not available from the local shell.
- Local shell checks found no Render CLI, no Neon CLI and no exposed staging database environment variable.
- Migration `20260625143000_add_fund_project_participants` exists locally.
- 1P-D staging alignment has been pushed; confirm in Render/Neon that deployment completed and `20260625143000_add_fund_project_participants` has applied before authenticated smoke testing.
- Lightweight staging health check after alignment returned HTTP 200 for `/api/health`.

#### Historical Issue Status Register

This table is the current compact issue-status view for planning. It should be updated after remediation, review or architecture-planning slices so future planning does not require rereading every triage note.

| Issue | Current Status | Category | Next Action | Blocks C2? | Blocks Store/Commerce? | Current / Suggested Slice |
| --- | --- | --- | --- | --- | --- | --- |
| #46 Project/Event close-date constraint | Remediated in 1P-R1; 1P-R2 static/check review passed | Immediate remediation | Authenticated browser spot-check before staging promotion | No for planning; spot-check before promotion | No, but must remain clean before Store date generation | Browser spot-check / next promotion gate |
| #50 Issue Manager module filtering/server render error | Remediated in 1P-R1; module-field confusion corrected in `ce65830` | Immediate platform remediation | Smoke-test Issue Manager module filter and modal field behaviour on staging | No | No | Staging smoke test |
| #47 Product activation gate visibility | Small UX remediation included in 1P-R1; 1P-R2 static/check review passed | UI/UX polish | Browser spot-check Project Overview affordance | No | No | Browser spot-check / next promotion gate |
| #44 Product breadcrumb navigation | Small UI polish included in 1P-R1/1P-R1A; 1P-R2 static/check review passed | UI polish | Browser spot-check Products, Projects and Events breadcrumbs | No | No | Browser spot-check / next promotion gate |
| #45 Sidebar icons repeated | Small UI polish included in 1P-R1/1P-R1A; 1P-R2 static/check review passed | UI polish | Browser spot-check FUND navigation icons | No | No | Browser spot-check / next promotion gate |
| #48 Events should link to one or more Product Catalogues | Implemented/reviewed through 1Q-E-R1; 1Q-F UI pending | Core architecture implementation | 1Q-B added Event/Catalogue schema, 1Q-C added C1 services, 1Q-D added C1 UI and 1Q-E exposes reviewed Project Product eligibility services. Next: make eligibility visible in the Catalogue-centric Project Product picker. | Yes for Client dashboard Project creation where Event/product selection is exposed until 1Q-F is complete | Yes until 1Q-G readiness review | 1Q-F Catalogue-centric picker UI |
| #49 Product Workflow Class suitability | Implemented/reviewed through 1Q-E-R1; 1Q-F UI pending | Core architecture implementation | 1Q-B added Product suitability schema, 1Q-C added C1 services, 1Q-D added C1 UI and 1Q-E implements the accepted eligibility behaviour, including the locked no-suitability-rows policy. Next: consume eligibility in the Project Product picker. | Yes for Project creation/product selection where Project type constrains Products until 1Q-F is complete | Yes until 1Q-G readiness review | 1Q-F Catalogue-centric picker UI |

Planning rule:

```text
For every new FUND planning slice, read this status register first. Use the detailed triage documents only when the register points to an issue or decision needing background evidence.
```

#### CR Handling Rule

Change requests are treated as development inputs, not direct implementation instructions.

Every CR must pass through triage before implementation. If accepted, it receives the same slice planning, implementation confirmation, review/test confirmation and roadmap update sequence as new feature work.

Current CR workflow:

```text
CR input
  -> triage decision
  -> slice planning
  -> implementation confirmation
  -> review/test confirmation
  -> roadmap/control update
```

For the current CR batch:

```text
01-cr-inputs/change-request-cmqt61xmf000612xt5ifl1mdn-2026-06-25.md
  -> 02-triage/2026-06-25-fund-c1-admin-remediation-and-architecture-triage.md
  -> 03-slice-planning/2026-06-25-fund-phase-1-slice-1p-r1-c1-admin-immediate-remediation.md
```

### A.5 Historical C2 Access-Model Planning Lane

Current C2 planning documents:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-24-fund-phase-1-slice-1p-c2-organiser-dashboard-proposal.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-24-fund-phase-1-slice-1p-a-c2-project-access-model-proposal.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-d0-c2-organisation-scope-clarification.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-f-c2-client-account-organisation-model-planning.md
```

Recommended model:

```text
IsoStack User for authentication
+ FundProjectParticipant for Project access
+ optional future FundOrganiserProfile for reusable organiser identity/contact history
```

Key decision:

```text
C2 Project access must not derive from organiserName/organiserEmail/organiserPhone snapshot fields.
```

Current C2 recommendation:

- Treat the implemented 1P-D read-only dashboard as a safe participant-scoped interim bridge.
- Treat 1P-D smoke testing as technical validation only, not decisive product validation.
- Decide the C2 organisation/account scope before adding C2 mutations, participant management UI, C2 client/account management UI, C1 Client view, invitations, Project Request/onboarding, sales/order/reporting views, Store or Commerce coupling.
- Do not assume direct `FundProjectParticipant` access is the final C2 operating model.
- Likely long-term direction to evaluate: C2 Client/account owns Projects, C2 users belong to that Client/account, and `FundProjectParticipant` remains for named contacts, overrides, exceptions and transition access.
- 1P-F is the active architecture planning slice for the C2 Client/account organisation model.

#### C2 Organisation / Account Scope Clarification

Post-1P-D clarification:

```text
Current interim model:
User -> FundProjectParticipant -> FundProject

Wider likely model:
C1 Producer/Admin Tenant
-> C2 Client / Account / Fundraising Organisation / School / Club / PTA / Customer Account
-> C2 users
-> Projects
-> future Project sales/orders/reporting
```

Important correction:

```text
C2 is the Project management node.
C2 Clients/accounts own and manage Projects.
C2 users operate within the Client/account organisation.
FundProjectParticipant is not the strategic Project ownership model.
```

Client organisation / user clarification:

```text
FundClient = organisation/account.
Client user/member = future login-capable person linked to Client.
User = authenticated platform identity.
Client role = future role label or access role within the Client/account.
```

Primary contact fields on `FundClient` are C1 operational contact snapshots only. They are not full user accounts, login identity, invitation state, role membership, notification consent, access control or the final C2 user model.

Future Client organisation details need structured physical address and delivery/fulfilment support. Projects should be able to default or inherit delivery address from the linked Client where appropriate, but Project-level delivery snapshots and overrides require separate planning before Store, Orders, Production or Dispatch.

SeasonPro precedent:

```text
C1 League Tenant
-> C2 Club
-> Teams
-> Club users
```

Integrated SeasonPro + FUND may use the SeasonPro Club as the fundraising Project creator/account.

Terminology note:

```text
Client may be the user-facing/admin term for the C2 organisation/account.
In SeasonPro, Client is synonymous with Club.
In FUND, Client may be a school, club, PTA, charity branch, fundraising organisation or customer account.
```

C1 Client view note:

```text
C1 should eventually be able to enter a managed Client/account view for support, preview or administration.
This must be distinct from hat-swapping and must not rely on unsafe impersonation.
```

Open decision:

```text
Should FUND create a FUND-specific C2 organisation/account model, a reusable IsoStack C2 organisation/account model, or a hybrid that retains FundProjectParticipant for Project-level exceptions?
```

Control rule:

```text
Further C2 dashboard expansion must pause before write-capable or commercially meaningful surfaces until this is resolved.
```

#### AMOW Founding-Tenant Priority

The immediate AMOW presentation priority is the C1 organisational dashboard, not expansion of the interim C2 read-only dashboard.

AMOW needs to be able to explain and demonstrate the operating model:

```text
AMOW manages Clients, Products, Events and Projects.
Clients are fundraising organisations such as schools, clubs or PTAs.
Projects belong to Clients.
Future Store, Orders, Sales, Communications and Reporting sit naturally under the Client and Project structure.
```

Current priority slice:

```text
1P-F-A - C1 Client Management Foundation
```

Control decision:

- 1P-D remains technically safe as a read-only participant-scoped interim dashboard.
- 1P-D is not the immediate AMOW product priority.
- Further C2 dashboard expansion remains paused.
- C2 mutations, invitations, Project Request/onboarding, Store, Orders, Commerce, Sales/Reporting and Communications remain deferred.
- C1 Client management is the next priority planning lane.
- C1 Client management UI can proceed without Client user provisioning because organisation/account management and user/member management are separate concerns.
- A future planning slice is required for Client organisation details, Client users/members, roles and notification boundaries.

#### Project Intake / Client Onboarding Clarification

Future FUND Project creation has three important lanes:

```text
Unknown / public intake:
external or unknown respondent -> C1 Project Intake form -> C1 moderation -> Client/account + C2 user/member + Project

New Client / first Project:
new organisation / first Project -> intake/onboarding submission -> C1 moderation -> Client/account + first user + Project

Existing Client / additional Project:
authenticated C2 Client user -> Client dashboard -> New Project -> direct Client-owned FundProject creation under authenticated Client/account context

SeasonPro Club:
SeasonPro Club user -> Club view -> Project request/create flow -> C1 moderation or trusted direct creation only if policy allows
```

Project Intake / Project Request forms may later be:

- embedded on websites;
- linked from emails;
- linked from campaign pages;
- linked from SeasonPro Club views;
- used from future Client dashboards only where a deliberate request/intake path is needed instead of direct Client-owned Project creation.

Control rules:

- C1 users may create/manage Project Intake forms in a future slice.
- Unknown/public and new Client form submissions must be moderated before operational records are created or linked.
- The moderated initiation form is the next implementation priority and remains moderated for both new and existing Client respondents.
- If an existing Client/contact uses the initiation form, email/Client matching may flag likely linkage or an additional Project, but it must not bypass C1 approval.
- The initiation form should follow the proven SeasonPro-style pattern: multi-step form -> email confirmation midpoint -> confirmed submission -> C1 moderation -> create/link Client, Client user/member and Project.
- Approval may create/link Client/account, C2 user/member, Project and Event linkage for moderated intake.
- Existing authenticated Client dashboard Project initiation is not an intake submission by default.
- Existing authenticated C2 Client users should be able to create Client-owned Projects directly once the Client user/member and role/permission model exists.
- Direct Client-created Projects should start in a safe pre-operational state and remain subject to later gates before activation, Store launch, public ordering, production batching, dispatch/fulfilment, notification sending or commerce/payment activity.
- Client-scoped Project initiation must use trusted Client route, token or authenticated Client context. Existing Client dashboard initiation should auto-scope the Project to the authenticated Client/account.
- Client ownership must not be inferred from organiser snapshot fields, respondent email alone, proposed Client contact fields alone or user-editable hidden fields.
- New Client / first Project intake may create or match Client/account, create or link a primary Client login user/member and create a Project linked through `FundProject.clientId` only after explicit C1 moderation/approval or a separately planned trusted direct-creation policy.
- The C2 Client user is the Project manager and may later plan, update, cancel, archive or manage the Project within operational rules.
- C1 is the FUND producer tenant/supplier/fulfilment operator. C1 manages Products/Catalogues, Event/Product availability, artwork checking, production, dispatch, commission, order/commerce oversight and supplier-side exceptions rather than approving every authenticated C2 Project by default.
- Future direct Client Project creation idempotency must account for double-click/retry protection and authenticated Client user/member audit. Future moderation approval idempotency must account for initiator email matching and/or future Client user/member matching.
- The future Client dashboard is also the intended Client engagement surface for C1 announcements, special offers/campaign prompts, dashboard-visible messages and 1:1 communication.
- Client dashboard communications must follow a controlled SeasonPro-style communications pattern and must not be implied by Project Intake schema alone.
- Projects may be linked to a C1 Event or may be standalone depending on campaign/form policy.
- Existing SeasonPro Clubs may later act as the FUND Client/account and Project creator.
- SeasonPro Club-originated Project initiation depends on the League tenant having the FUND / Fundraising module enabled through subscription, League configuration of approved FUND producer tenant(s), catalogue availability to Clubs, sale method planning and explicit Club-to-FUND Client/account mapping.
- Club-facing product options should be presented as fundraising products available through the SeasonPro/League context, not as supplier-management records or producer internals.
- Until trusted direct creation is deliberately planned, SeasonPro Club-originated Project initiation should create or route through a moderated Project Intake submission with source `SEASONPRO_CLUB`.
- Notification/invitation sending is deferred and must follow a controlled SeasonPro-style communications pattern.
- 1P-F-E Client UI remains C1 admin only and does not implement Project Intake forms, Client users, invitations or automatic Project creation.

### A.6 Historical Architecture Planning Before Store / Commerce

The first remediation CR surfaced two architecture questions that should be resolved before Store, Order, Commerce or production workflow work.

#### Event / Catalogue / Product Availability

Source issue:

```text
Issue #48 - Events should link to one or more Product Catalogues
```

Design question:

```text
How should Event-linked Projects and standalone Projects determine eligible Products?
```

Planning needed:

- Event-to-Catalogue links.
- Optional Event-to-ad-hoc Product links where a Product should be available for one Event without first creating a broader Catalogue.
- Standalone Project Catalogues.
- Catalogue type/scope.
- Whether Events can use multiple Catalogues.
- Whether Catalogues can serve multiple Events.
- Project Product picker eligibility.
- Project inheritance from linked Event availability.
- Project ability to select or deselect Products from inherited Event/standalone availability.
- Project type and workflow suitability constraints that limit the eligible Product list.
- Future Store generation eligibility.

Accepted conceptual direction:

- Event-linked Projects should normally inherit eligible Products from the Event's linked Catalogue(s).
- Standalone Projects should choose from tenant-approved standalone/default Catalogue(s) or explicitly configured Products.
- Events may need ad-hoc Product availability where a Product is specific to a campaign/Event.
- Product selection and deselection should happen at the Project level, because individual Projects may not use every Product available from the Event or Catalogue.
- Store/Orders/Commerce must not be implemented until Product eligibility for a Project is explicit and auditable.
- Rich Product media, image galleries, option definitions and option-image mapping are important but belong to Product/Catalogue refinement planning unless they become Store MVP blockers.

#### Product Workflow Suitability

Source issue:

```text
Issue #49 - Product Workflow Class suitability
```

Design question:

```text
Is a Product's workflow class a default, a suitability set, or a Project-specific operational choice?
```

Superseded interpretation — 2026-09-08:

The earlier stabilising interpretation recorded in this section was implemented provisionally and is now
superseded by the triaged [B1-R1 correction](../03-slice-planning/2026-09-08-fund-b1-r1-catalogue-availability-and-workflow-authority-planning.md):

- Product and Project Product do not own workflow or suitability.
- Catalogue membership and availability define which Products can be offered.
- Event owns workflow for linked Projects; a standalone Project owns its workflow.
- One fixed application registry maps the four Project types to their operational
  A1/A2/B/C requirements.
- Order evidence snapshots the Project workflow; it is not re-derived from Product.

#### C1 Production / Dispatch / Commission Workflow

Source clarification:

```text
C1 dashboard is the Project administration and production workflow surface.
```

Planning needed before Store/Commerce implementation:

- Project artwork checking and approval.
- Project-level production status.
- Grouping similar Products across Projects for production efficiency.
- Maintaining Project context while batching production across Projects.
- Dispatch/fulfilment by Project and Client.
- Commission model under the Client/Project/Order/Commerce structure.
- Relationship between Project Product membership, Orders and production outputs.

Control rule:

```text
Store, Orders and Commerce must preserve the C1 production/admin workflow and future Client dashboard engagement surface. They must not be designed as isolated checkout/order features.
```

### A.7 Commerce Core Separation Decision

Commerce Core should be treated as a reusable IsoStack platform lane, not a FUND-only implementation detail.

Future Commerce Core lane should cover:

- provider-neutral Products/Prices/Orders/Payments/Subscriptions where appropriate;
- payment providers such as Stripe and GoCardless;
- VAT/tax model;
- checkout/session lifecycle;
- payment status and webhooks;
- subscription and usage billing options;
- audit and tenant safety.

FUND Store planning should depend on, or at least align with, this future platform lane.

### A.8 SeasonPro Remediation Branch/Lane History

SeasonPro/LMSPro fixes should use:

```text
feature/seasonpro-remediation
```

Purpose:

- keep SeasonPro remediation testable and promotable without unfinished FUND C2 work;
- cherry-pick specific fixes into FUND branches only when needed;
- avoid using FUND feature branches as a holding area for unrelated SeasonPro fixes.

Recent example:

- `fix(lmspro): support team data export` was first isolated as a SeasonPro-only hotfix, then absorbed into FUND before release.

Recommended rule:

```text
SeasonPro fixes start in the SeasonPro remediation lane unless the fix is genuinely FUND-dependent.
```

### A.9 Historical Deferred Items

Deferred until explicitly planned:

- C2 organiser dashboard mutations or expansion beyond the implemented read-only interim participant-scoped view.
- C2 organisation/account model implementation beyond controlled Client-management planning.
- Client users/members, Client roles, invitation state and notification consent.
- C2 organiser invitations.
- Project Intake / Project Request / onboarding forms.
- Organiser account provisioning.
- FundOrganiserProfile.
- Store schema.
- Order schema.
- Commerce Core implementation.
- Payments.
- Subscriptions.
- Commissions.
- Production batching.
- C1 artwork checking and production workflow implementation.
- C1 dispatch/fulfilment workflow implementation.
- Fulfilment/distribution workflows.
- Client dashboard announcements, special offers/campaign prompts and 1:1 communications.
- Artwork/data/template submission workflows.
- Media/asset library.
- Marketplace / AMOW product sharing.
- SeasonPro integration/distribution channel.
- SeasonPro Club-to-FUND Project initiation implementation.
- SeasonPro League approved FUND producer/catalogue configuration UI.
- SeasonPro Club sale method workflows.
- AI workflows.
- Lifecycle transition engine.
- Lifecycle tables/templates.

### A.10 Historical Do-Not-Build List

Until explicit future slices are accepted, do not build:

- Project Product eligibility services beyond the accepted 1Q-E scope.
- C2 Product picker UI before 1Q-F.
- Store generation.
- Order management.
- Commerce checkout.
- Payment webhooks.
- Production export/batching.
- C2 dashboard mutation/management expansion.
- Client dashboard communications, announcements, special offers or 1:1 messaging.
- C2 organisation/account schema before the Client/account schema-options slice is accepted.
- C2 invitation/onboarding flow.
- new Project Intake / Project Request / onboarding flows beyond the current public Project initiation implementation.
- SeasonPro Club-to-FUND Project initiation flow.
- SeasonPro League producer/catalogue availability configuration.
- Sale method selection workflows.
- Organiser dashboard actions.
- C1 production batching/artwork checking/dispatch/commission workflow.
- Product marketplace/sharing.
- Any schema migration for the above without a planning slice first.

### A.11 Superseded Slice Recommendations

#### Historical Next 1 - C1 Admin Immediate Remediation

Suggested slice:

```text
Slice 1P-R1 - C1 Admin Immediate Remediation
Slice 1P-R1A - C1 Admin UI Consistency Remediation
```

Status:

```text
Implemented and check-passed.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-r1-c1-admin-immediate-remediation.md
```

Scope:

- Issue #46 Project/Event date constraint fix.
- Issue #50 Issue Manager module filtering/server render fix.
- Issue #47 Project Product activation gate visibility.
- Issue #44 breadcrumbs.
- Issue #45 sidebar icon specificity.
- Dashboard card interaction/colour consistency.
- Column-header sort alignment.
- Issue Manager module field consolidation.

Branch:

```text
feature/fund-phase-1-c2-project-access
```

#### Historical Next 2 - C2 Read-Only Organiser Dashboard UI

Suggested slice:

```text
Slice 1P-D - C2 Read-Only Organiser Dashboard UI
```

Status:

```text
1P-A planning complete.
1P-B participant schema implemented and aligned to dev/staging.
1P-C read-only organiser Project API/services implemented, reviewed and aligned to dev/staging.
1P-D implemented on feature/fund-phase-1-c2-project-access.
1P-D-R1 review complete with caveats.
```

Scope:

- implement C2 read-only organiser landing page;
- implement C2 read-only assigned Project detail page;
- consume only `fund.organiser.projects.list/get`;
- include C1/C2 context navigation for dual-role users;
- no C2 mutations, invitations, participant management, Store, Orders or Commerce.

Pre-implementation note:

```text
Confirm staging has applied 20260625143000_add_fund_project_participants before authenticated staging testing.
```

#### Historical Next 3 - C1 Client Management Foundation For AMOW

Suggested slice:

```text
Slice 1P-F-A - C1 Client Management Foundation
```

Scope:

- plan the AMOW-facing C1 Client management foundation;
- decide how `Client` should be presented as the C2 organisation/account concept;
- define the minimal Client record needed for AMOW explanation and near-term implementation;
- define Client to Project relationship expectations;
- document how future Orders, Sales, Reporting, Communications and key-date automation sit under Client and Project;
- defer schema implementation until schema-options planning is accepted.

Status:

```text
Active priority planning.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-f-a-c1-client-management-foundation-planning.md
```

#### Historical Next 4 - C1 Client / Account Schema Options

Suggested slice:

```text
Slice 1P-F-B - C1 Client Management Schema Options
```

Scope:

- decide whether Client/account should be FUND-specific, reusable IsoStack core, or hybrid;
- define tenant scoping and same-tenant Project linkage;
- decide Project `clientId` / `clientAccountId` direction;
- define migration/backfill approach for existing Projects;
- define SeasonPro Club mapping guardrails;
- define C1 Client list/detail UI implications.

Status:

```text
Implemented, reviewed with caveats and aligned to dev/staging as da6fd0f.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-f-b-c1-client-management-schema-options.md
```

Recommended next implementation slice:

```text
Slice 1P-F-C - C1 Client Management Schema
```

Status:

```text
Implemented locally as schema-only work.
```

Confirmation document:

```text
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-f-c-c1-client-management-schema-confirmation.md
```

#### Historical Next 5 - C1 Client Management API/Services

Suggested slice:

```text
Slice 1P-F-D - C1 Client Management API/Services
```

Scope:

- plan C1 tenant-scoped Client list/get/create/update/archive/restore services;
- plan Client search/filter/sort behaviour;
- plan Client detail payload with linked Project summaries;
- plan same-tenant enforcement and archived Client behaviour;
- plan audit events and error handling;
- keep UI, Project Client selector, Client users, invitations, Store, Orders, Commerce, Sales/Reporting, Communications and SeasonPro mapping out of scope.

Status:

```text
Implemented locally as API-services only.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-f-d-c1-client-management-api-services-planning.md
```

Confirmation document:

```text
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-f-d-c1-client-management-api-services-confirmation.md
```

#### Historical Next 6 - C1 Client Management UI

Suggested slice:

```text
Slice 1P-F-E - C1 Client Management UI
```

Scope:

- build C1 Client list;
- build C1 Client detail;
- consume `fund.clients.*` only;
- show linked Project summaries;
- support create/update/archive/restore;
- keep Client users, invitations, Project Request/onboarding, Store, Orders, Commerce, Sales/Reporting, Communications and SeasonPro mapping out of scope.

Status:

```text
Planning document created.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-f-e-c1-client-management-ui-planning.md
```

Confirmation document:

```text
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-f-e-c1-client-management-ui-confirmation.md
```

Review document:

```text
isodocs/docs/modules/fund/05-review-and-test/2026-06-25-phase-1-slice-1p-f-e-r1-c1-client-management-ui-review.md
```

#### Historical Next 7 - Project Client Selector And Linkage

Suggested slice:

```text
Slice 1P-H - Project Client Selector And Linkage
```

Scope:

- plan how C1 admins link Projects to Clients;
- plan Project create/update API/service changes for `clientId`;
- plan DRAFT-only link/change/unlink rule;
- plan read-only historical display for non-DRAFT and archived linked Clients;
- plan Project create/detail Client selector UI;
- keep Client users, invitations, notification sending, Project Intake forms, Store, Orders, Commerce, Sales/Reporting and Communications out of scope.

Status:

```text
1P-H planning complete.
1P-H-A API/services implemented and static-check passed.
1P-H-B UI implemented and static-check passed.
1P-H-C review and authenticated staging smoke testing complete.
Accepted with no remedial work required at this stage.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-h-project-client-selector-linkage-planning.md
```

Confirmation documents:

```text
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-h-a-project-client-linkage-api-services-confirmation.md
isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-25-phase-1-slice-1p-h-b-project-client-selector-ui-confirmation.md
```

Review document:

```text
isodocs/docs/modules/fund/05-review-and-test/2026-06-25-phase-1-slice-1p-h-c-project-client-linkage-ui-review.md
```

Alignment recommendation:

```text
1P-H-A/1P-H-B are committed and aligned to dev/staging at `536c947`. Authenticated staging smoke testing passed.
```

#### Historical Next 8 - Project Intake / Client Onboarding Planning

Suggested slice:

```text
Slice 1P-G - Project Intake, Client Onboarding And Moderation Planning
```

Scope:

- plan C1-created Project Intake forms;
- plan embedded public forms and email/campaign links;
- plan SeasonPro Club-view Project creation entry points;
- plan future Client-dashboard additional Project initiation;
- plan unknown respondent and existing C2 user flows;
- plan C1 moderation before creating/linking operational records;
- plan approval creating/linking Client/account, C2 user/member, Project and Event linkage;
- define notification/invitation boundary;
- treat email trigger points as placeholders until the dedicated editable notifications lane is implemented;
- defer Store, Orders, Commerce, Sales/Reporting and Communications implementation.

Status:

```text
1P-G future lane documented.
1P-G-A schema and moderation model planning complete.
1P-G-B schema options planning complete.
1P-G-C schema implementation and 1P-G-C-R1 review complete.
1P-G-C2-A email confirmation schema addendum implemented as schema-only work.
1P-G-D0 client-scoped initiation/idempotency planning complete.
1P-G-D Project Intake Moderation API/Services planning complete.
1P-G-D1 C1 Project Intake Form API/Services implemented.
1P-G-D2 C1 Project Intake Submission Review API/Services implemented.
1P-G-D3 Project Intake Approval Action Planning complete.
1P-G-D3-A Project Intake Approval API/Services implemented.
1P-G-D3-A-R1 Project Intake Approval API/Services Review complete with caveats.
1P-G-E C1 Project Intake Moderation And Approval UI implemented.
1P-G-E-R1 C1 Project Intake Moderation And Approval UI Review complete with a proceed verdict.
1P-G-F Public Project Initiation Form UI Planning initiated.
1P-N0 FUND System Notifications And Editable Email Defaults Planning added as a future communications lane.
Resume context after SeasonPro/auth remediation is documented.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-g-project-intake-client-onboarding-and-moderation-planning.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-25-fund-phase-1-slice-1p-g-a-project-intake-schema-and-moderation-model-planning.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-b-project-intake-schema-options-planning.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-d-project-intake-moderation-api-services-planning.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-d1-c1-project-intake-form-api-services-planning.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-d2-c1-project-intake-submission-review-api-services-planning.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-d3-project-intake-approval-action-planning.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-e-c1-project-intake-moderation-and-approval-ui-planning.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-g-f-public-project-initiation-form-ui-planning.md
isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-resume-context-after-seasonpro-remediation.md
```

Recommended next implementation slice:

```text
1P-G-F-A - Public Project Initiation Form UI Implementation
```

Implementation goal:

```text
Build the public multi-step Project initiation form UI using the approved client-facing field set, trusted branding fallback and confirmation-state screens. Use email trigger placeholders, with a narrow permitted hard-coded transactional exception for required confirmation/authentication email.
```

Required parallel/follow-up planning lane:

```text
1P-N0 - FUND System Notifications And Editable Email Defaults Planning
```

Communications goal:

```text
Plan FUND notification trigger keys, editable default email content, recipient rules, pause/resume controls and audit/test behaviour using the SeasonPro/LMSPro communications Notifications tab as the precedent.
```

Deferred later lane:

```text
1P-K0 - Client-Owned Project Lifecycle And Dashboard Management Planning
```

#### Historical Next 9 - SeasonPro Club To FUND Project Initiation Planning

Suggested slice:

```text
Slice 1P-J - SeasonPro Club To FUND Project Initiation Planning
```

Scope:

- preserve the future SeasonPro Club-originated fundraising Project initiation path;
- record dependency on SeasonPro League FUND/Fundraising module entitlement;
- record League configuration of approved FUND producer tenant(s), such as AMOW;
- record catalogue/product availability to Clubs;
- protect the supplier/producer visibility boundary;
- require explicit SeasonPro Club to FUND Client/account mapping;
- preserve `SEASONPRO_CLUB` as a Project Intake submission source;
- preserve sale method options for later Store/Orders/Commerce planning;
- keep implementation deferred.

Status:

```text
Planning placeholder created. Do not implement yet.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-j-seasonpro-club-to-fund-project-initiation-planning.md
```

#### Historical Next 10 - C1 Production / Dispatch / Commission Workflow Planning

Suggested slice:

```text
Slice 1P-I - C1 Production, Dispatch And Commission Workflow Planning
```

Scope:

- record C1 Project administration and production workflow expectations;
- plan artwork checking as Project-linked;
- plan grouping similar Products across Projects for production efficiency;
- plan Project-level production status;
- plan dispatch/fulfilment as Project/client-linked;
- plan commission under the Client/Project/Order/Commerce structure;
- keep implementation deferred until Store, Orders and Commerce planning can align to the production surface.

Status:

```text
Planning note created. Do not implement yet.
```

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-06-29-fund-phase-1-slice-1p-i-c1-production-dispatch-commission-workflow-planning.md
```

#### Historical Next 11 - Event / Catalogue / Product Availability Planning

Suggested slice:

```text
Slice 1Q-F - Catalogue-Centric Project Product Picker UI Remediation
```

Current 1Q status:

- 1Q-A Product/Catalogue Suitability Schema Options Planning is complete.
- 1Q-B Event/Catalogue Availability Schema Implementation is complete.
- 1Q-C C1 Event Catalogue Availability API/Services is complete in app commit `2bb8db3`.
- 1Q-D C1 Event Catalogue Availability UI is complete in app commit `28662af`.
- 1Q-D implementation confirmation and R1 review/test documents are created.
- 1Q-D static/type/verify checks passed.
- 1Q-D authenticated C1 browser smoke is accepted as passed by operator confirmation; detailed UI/UX revisions are deferred to refinement.
- 1Q-E planning is created and locks the no-suitability-rows policy and service contract.
- 1Q-E is implemented and promoted to `origin/dev` / `origin/staging` at `7a7354a`, with implementation confirmation created.
- 1Q-E-R1 developer API/service review/test is accepted as passed and documented in `05-review-and-test/2026-07-01-phase-1-slice-1q-e-r1-project-product-eligibility-api-services-review-and-smoke-test.md`.
- 1Q-E has no operator-visible browser UI; operator/browser Product picker testing resumes in 1Q-F.

Accepted implementation sequence:

```text
1Q-A - Event/Catalogue/Product Availability Schema Options
1Q-B - Event/Catalogue Availability Schema Implementation
1Q-C - C1 Event Catalogue Availability API/Services
1Q-D - C1 Event Catalogue Availability UI
1Q-E - Project Product Eligibility API/Services
1Q-F - Catalogue-Centric Project Product Picker UI Remediation
1Q-G - Availability Review And Store/Commerce Readiness Check
```

1Q-E scope:

- derive eligible Products for a Project from linked Event Catalogue availability or standalone/default Catalogue availability;
- apply Product Project type suitability;
- apply Product organisation type suitability where Client organisation type is available;
- treat missing active suitability rows for a Product as unrestricted for that suitability dimension, after source availability passes;
- deduplicate eligible Products by Product while retaining all source Catalogue context;
- preserve same-tenant checks;
- exclude archived/inactive Events, Catalogues, Catalogue memberships and Products;
- return eligibility data only;
- do not create Project Product memberships;
- do not implement C2 Product picker UI, Store, Orders or Commerce.

1Q-E-R1 review/test result:

- operator-visible browser smoke was confirmed not applicable to the new 1Q-E behaviour;
- browser scope is limited to negative/regression confirmation because 1Q-E intentionally adds no visible browser surface;
- `fund.productEligibility.listForProject` is read-only;
- source availability is mandatory;
- no-suitability-rows means unrestricted for that suitability dimension after source availability passes;
- active suitability rows narrow eligibility;
- Products available through multiple source Catalogues appear once with all source Catalogue references;
- same-tenant checks and archived/inactive exclusions are covered;
- no C2 Product picker UI, Store, Orders or Commerce behaviour was added.

1Q-F direction:

- consume the 1Q-E eligible Product response rather than `fund.products.list`;
- group eligible Products by source Catalogue for discovery and explanation;
- share selection state by `productId` across Catalogue groups;
- create/reactivate at most one `FundProjectProduct` row per selected Product;
- display a Product-side Catalogue memberships view in Product Manager, or explicitly defer full bidirectional management with a follow-up;
- preserve the rule that Store pages should eventually display each selected Product once.

Duplication/copy boundary:

- referenced Products shared across multiple Catalogues remain one Product identity and should collapse to one selection/store row;
- copied Products are distinct Product records and may drift in pricing, commission, copy, options, media or fulfilment behaviour;
- Product/Catalogue duplication policy belongs to refinement planning unless Store readiness makes it a blocker.
- per-Catalogue pricing, commission and display-copy override policy is future commercial-terms work tracked in the Phase 2 wishlist, not part of 1Q-F.

#### Historical Next 12 - Store, Orders And Commerce Core Planning

Suggested slice:

```text
Slice 1R-A - Store, Orders And Commerce Core Planning
```

Rationale:

- 1Q-G closes the availability-to-selection lane;
- Store/Orders/Commerce is structural Phase 1 work, not Phase 2 polish;
- selected `FundProjectProduct` rows must become the Store Product source;
- Order snapshots must preserve Product, price, VAT, option/personalisation and Project
  context safely;
- Product options are treated as Store MVP behaviour, while reusable Product Type / Option
  Template modelling remains later C1 configuration refinement;
- Commission Ladder Planner requirements must be resolved far enough to know which
  aggregate sales evidence, ladder references and audit inputs need preserving;
- C1 production, dispatch and commission constraints must be visible before implementation.

Planning document:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-07-08-fund-phase-1-slice-1r-a-store-orders-commerce-core-planning.md
```

Schema-options follow-on created for review:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-b-commerce-core-and-fund-store-schema-options-planning.md
```

Accepted follow-on planning created from 1R-B:

```text
isodocs/docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c-fund-store-input-schema-foundation-planning.md
isodocs/docs/core/commerce/02-triage/2026-07-13-isostack-commerce-core-schema-foundation-planning.md
isodocs/docs/modules/fund/03-slice-planning/2026-07-13-fund-phase-1-slice-1r-c1-product-media-input-tax-duplication-schema-implementation-planning.md
isodocs/docs/core/commerce/03-slice-planning/2026-07-13-isostack-commerce-core-slice-commerce-a1-schema-seller-profile-enums-implementation-planning.md
```

Commission Ladder Planner context:

```text
isodocs/docs/modules/fund/01-cr-inputs/2026-07-13-fund-cr-commission-ladder-planner-input.md
```

The previous C2 dashboard foundation-expansion note remains conceptually useful, but it is
not the next active `1R` lane because K2 has already supplied the first authenticated C2
Client dashboard foundation and Store/Orders/Commerce now blocks meaningful expansion.

### A.12 Superseded 1R-C1 Completion Prompt

```text
FUND Phase 1 Slice 1R-C1 is complete through implementation confirmation and review/test.
Do not rerun 1R-C1 and do not begin 1R-C2, COMMERCE-A2 or another slice without a separate
explicit instruction. Read the FUND and root roadmaps before selecting the next bounded
planning task.
```

### A.13 Superseded Historical Resume Prompt

The prompt below predates completion of the 1Q sequence and Commerce A1. It is retained only
as historical context and must not be used to select current work.

```text
We are working on IsoStack FUND.

Current app branch:
dev

Current released baseline:
bb50bc6 fix(fund): allow c2 client dashboard route

Current local app state:
- local dev is aligned with origin/dev at 7a7354a feat(fund): add project product eligibility services;
- local staging is aligned with origin/staging at 7a7354a feat(fund): add project product eligibility services;
- 1Q-C C1 Event Catalogue Availability API/Services is implemented at 2bb8db3;
- 1Q-D C1 Event Catalogue Availability UI is implemented at 28662af;
- 1Q-E Project Product Eligibility API/Services is implemented, committed, promoted to origin/dev and origin/staging, and reviewed at 7a7354a;
- unrelated untracked local files may exist and must not be reverted unless explicitly requested.

Read first:
- isodocs/docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md
- isodocs/docs/modules/fund/00-roadmap-control/README.md
- isodocs/docs/modules/fund/03-slice-planning/2026-06-30-fund-phase-1-slice-1q-event-catalogue-product-availability-and-workflow-suitability-planning.md
- isodocs/docs/modules/fund/03-slice-planning/2026-06-30-fund-phase-1-slice-1q-a-product-catalogue-suitability-schema-options-planning.md
- isodocs/docs/modules/fund/03-slice-planning/2026-07-01-fund-phase-1-slice-1q-e-project-product-eligibility-api-services-planning.md
- isodocs/docs/modules/fund/03-slice-planning/2026-07-01-fund-phase-1-slice-1q-f-catalogue-centric-project-product-picker-ui-planning.md
- isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1q-b-event-catalogue-availability-schema-implementation-confirmation.md
- isodocs/docs/modules/fund/04-implementation-confirmations/2026-06-30-phase-1-slice-1q-c-c1-event-catalogue-availability-api-services-confirmation.md
- isodocs/docs/modules/fund/04-implementation-confirmations/2026-07-01-phase-1-slice-1q-d-c1-event-catalogue-availability-ui-confirmation.md
- isodocs/docs/modules/fund/04-implementation-confirmations/2026-07-01-phase-1-slice-1q-e-project-product-eligibility-api-services-confirmation.md
- isodocs/docs/modules/fund/05-review-and-test/2026-07-01-phase-1-slice-1q-d-r1-c1-event-catalogue-availability-ui-review-and-smoke-test.md
- isodocs/docs/modules/fund/05-review-and-test/2026-07-01-phase-1-slice-1q-e-r1-project-product-eligibility-api-services-review-and-smoke-test.md

Context:
- K2 Client dashboard live promotion completed at bb50bc6.
- 1Q-A planning, 1Q-B schema, 1Q-C API/services and 1Q-D C1 UI are complete/documented.
- 1Q-D static/type/verify checks passed; authenticated C1 browser smoke is accepted as passed by operator confirmation.
- Detailed 1Q-D UI/UX revisions are deferred to refinement and should not block 1Q-E.
- 1Q-E planning is accepted and locks the no-suitability-rows policy.
- 1Q-E implementation adds read-only `fund.productEligibility.listForProject` and is promoted to `origin/dev` / `origin/staging` at `7a7354a`.
- 1Q-E-R1 developer/API service review passed with transaction-scoped smoke coverage and no `FundProjectProduct` mutation.
- 1Q-E has no operator-visible browser UI; operator-visible picker testing belongs to 1Q-F.
- 1Q-F/1Q-G picker behaviour is accepted as Catalogue-aware but not Catalogue-grouped: a
  single filterable eligible Product table shows Catalogue source badges, dedupes by
  Product identity and keeps one shared selected Product state.
- Availability is the Product source list. Source Catalogues explain eligibility. FundProjectProduct remains the selected Product list.
- Store pages should eventually display each selected Product once, even if it was eligible through multiple Catalogues.
- Future duplication can create referenced Catalogues that share Product records or copied Product records that drift in pricing, commission, copy, options, media or fulfilment behaviour.
- Future commercial terms, including buyer-facing pricing, VAT/tax policy and display-copy overrides, are tracked in Phase 2 refinement as `2R-CATALOGUE-04` and must be decided before Orders.
- Commission Ladder Planner input is captured as a Phase 1 Store/Orders/Commerce planning dependency at `01-cr-inputs/2026-07-13-fund-cr-commission-ladder-planner-input.md`; planning must distinguish C1 ladder configuration, buyer-facing sales evidence, aggregate Project sales calculation and later commission accounting/payment.
- Store, Orders, Commerce, production, dispatch, notifications and SeasonPro integration remain out of scope unless separately planned.

Immediate recommended work:
Close and promote the accepted 1Q-G availability-to-selection baseline, then plan
Store/Orders/Commerce core with C1 production, dispatch and commission constraints visible
before implementation.

1Q-F goal:
Make the reviewed 1Q-E eligibility service visible in the Project Product picker while preserving the Catalogue-centric source explanation and one selected Product state.

1Q-F should consume `fund.productEligibility.listForProject` rather than `fund.products.list`.

1Q-F/1Q-G accepted picker behaviour:
- show eligible Products once in a single filterable table;
- show all source Catalogue references as Catalogue badges;
- deduplicate shared Products by Product identity;
- keep one shared selected state per `productId`;
- create/reactivate at most one `FundProjectProduct` row per selected Product;
- avoid duplicating Products merely because they appear in more than one Catalogue;
- keep Store pages out of scope, while preserving the later rule that Store pages should display each selected Product once;
- add or explicitly defer a Product-side Catalogue memberships view so Products do not become an unmanageable flat list.

Do not start:
- Commerce Core;
- Store;
- Order;
- Sales/Reporting implementation;
- Communications implementation;
- Client dashboard announcements, special offers/campaign prompts or 1:1 messaging;
- payments;
- per-Catalogue pricing or commission overrides;
- commission implementation, including ladder configuration UI, commission accounting and
  payment/settlement workflows;
- production batching;
- artwork checking/production/dispatch workflow implementation;
- Product media galleries;
- Product option modelling;
- SeasonPro integration;
until their planning slices are accepted.

Process rule:
After implementation, add a labelled implementation confirmation in 04-implementation-confirmations, add a review/test summary in 05-review-and-test, then recursively update the roadmap-control document and README if the process/current status changed.
```
