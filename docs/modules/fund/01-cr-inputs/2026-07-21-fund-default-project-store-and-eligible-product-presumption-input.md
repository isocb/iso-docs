# FUND Default Project Store And Eligible Product Presumption Input

Date: 2026-07-21

Status: Original default-Store correction implemented as `1R-E-D`; the 2026-09-12 Phase 2
mission clarification below is **captured; awaiting triage and bounded planning**.
The original request and its implementation boundary are retained as history.

## 1. Reason For This Input

Post-promotion review of FUND `1R-E-B` and `1R-E-C` found that their human Store smoke
schedule cannot start from the real empty FUND state:

- C1 Store oversight lists only persisted Stores and intentionally creates none;
- the canonical C1/internal and Project Intake creation paths create a Project and delivery
  profile but no Store;
- the only current Store-instantiation UI requires an already-authorised C2
  `PROJECT_MANAGER` or `ADMIN` to discover the Project Store tab and select `Prepare Store`;
  and
- no live FUND data exists from which a representative Store can already be selected.

The technical E-A/B/C authority split remains correct. The missing contract is the default
Project-to-Store initiation workflow.

## 2. Business Rule

A FUND Project exists in order to operate a Project Store. The Store is therefore mandatory,
not an optional capability that an organiser or C1 operator must remember to add.

Every canonical Project creation/provisioning transaction must create:

1. the Project;
2. its delivery profile;
3. exactly one tenant- and Project-owned `DRAFT` Store; and
4. the default active Project Product and Store Product set derived from every Product the
   canonical eligibility service permits for the Project's type, effective organisation type,
   Event/standalone context, Catalogue availability and suitability rules.

The Store title defaults from the Project name. Creation does not publish the Store, accept
commission terms, bypass readiness or activate public checkout.

## 3. Default Product Presumption

The normal Product selection is:

```text
all currently eligible Products
minus explicit C2 deselections
```

The Project organiser is presumed to have limited time and capacity. No organiser action is
required to obtain the normal Product range. `PROJECT_MANAGER` or `ADMIN` may deselect or
restore Products in the minority of Projects that require a narrower offer. `VIEWER` remains
read-only.

The current durable `FundProjectProduct.isActive = false` membership is suitable evidence of
an explicit deselection:

- eligible Product with no Project membership: add active by default;
- active membership: retain and refresh through existing source authority;
- inactive membership: preserve as an explicit C2 exclusion and never reactivate silently;
- newly eligible Product with no prior membership: add on the next controlled reconciliation;
- active Product that becomes ineligible: prevent Store offering through the existing
  eligibility/readiness gate without erasing its history; and
- re-eligible active Product: permit it again through normal reconciliation.

Browser input never supplies the eligible Product universe, price, tax, media, snapshot,
readiness or configuration authority.

## 4. Default Store Lifecycle

The default operational sequence is:

```text
Project created
-> Store DRAFT with the complete default eligible Product set
-> C2 commission acceptance and Project activation/readiness gates complete
-> Store has default publication intent and is SCHEDULED before Project.opensAt
-> at Project.opensAt, Store is effectively OPEN only if every gate still passes
-> at Project.closesAt, Store is effectively closed by the Project window
```

Project activation may record the existing Store `PUBLISHED` intent, but this is not proof of
trading. Effective state remains server-derived. No timer job needs to mutate a row at the
opening instant.

A separate routine C2 `Publish Store` action must not be required for the default path. C2 may
still voluntarily pause/resume. C1 retains audited exceptional pause/release and
closure/reopen. Date, payment, commission, artwork/release and other accepted readiness gates
remain fail-closed.

## 5. Creation Paths In Scope

The invariant must cover all retained canonical paths:

- C1/internal dashboard Project creation;
- automated aligned Project Intake provisioning;
- C1-reviewed exception/correction provisioning; and
- any retained aligned approval path that is still permitted to create a Project.

Project, delivery, default Products and Store creation are one atomic outcome. Failure at any
stage rolls the transaction back. Idempotent retry and concurrent requests must return the one
existing Project/Store outcome and never create duplicates.

## 6. Existing FUND Data

FUND is not live and current FUND records are disposable test data. Existing Projects may be
reconciled through an explicit, idempotent, audited development/staging operation after a
preflight identifies missing Stores. A schema migration must not infer Product selection or
silently create operational rows.

## 7. Authority Preserved

- C1 owns Product/Catalogue commercial authority, supplier readiness, tenant-wide oversight
  and exceptional intervention.
- C2 owns normal Project/Store copy, Product deselection/restoration and voluntary
  pause/resume within server gates.
- C1 receives no routine Store-create or publish button.
- Store creation alone creates no public route, Order, Payment, upload, production,
  fulfilment or commission calculation behaviour.

## 8. Delivery Control

Create and review one bounded corrective slice:

`1R-E-D - Default Project Store Instantiation And Eligible Product Reconciliation`

Until E-D is implemented and promoted, E-B/E-C automated evidence remains passed but their
human UI acceptance is blocked by the missing real workflow. E-D precedes `1R-F-A`.

## 9. Phase 2 Mission Clarification — 2026-09-12

While smoke testing B1, Chris identified the primary refinement objective: make C1 Event
configuration straightforward for people without technical expertise, and make Store
creation virtually automatic for C2 when using designated intake forms. Existing default
Store creation and eligible Product selection are foundations, not proof of this complete
intake-to-live outcome.

Chris clarified that this is a guided sequence akin to an intake form asking C2 the necessary
questions in order and then finalising Store setup. “No decisions between intake and live”
means no separate setup/approval checklist after completing that guided sequence; it does
not mean omitting the questions or confirmation within intake. **Orders can only be placed
after the Store is published and its trading gates pass.** No pre-publication Order path is
requested or permitted.

For supported, correctly configured intake routes, the target is:

```text
C1 configures a reusable Event/intake setup with valid defaults
-> C2 answers the guided intake questions, reviews and completes the sequence
-> Project and Store are created with the intended eligible Product selection
-> readiness is evaluated automatically from the supplied information and defaults
-> completion finalises Store setup and it becomes live, or opens at its configured time
-> no further C1 or C2 decision is required on the normal successful path
```

This is a **primary Phase 2 mission outcome**, not a promise that every intake type or
exception is immediately automatable. Planning must name the supported form types and
prerequisites. Configure reusable defaults once at the appropriate C1 scope rather than
asking the organiser to repeat setup for each Project. Consider workflow, Catalogues,
Products, commercial terms, branding/media, copy, dates, fulfilment and artwork configuration
together; adding more independent routine approval steps would defeat the objective.

C2 should be able to edit the Store after it is live and before the template has been
circulated. Completing Store setup in the guided sequence must be distinguished from the
later artwork/template content-lock contract. This requested editing window is not delivered
by B1: B1 finalisation locks
selection/content and has no unlock action. Phase 2 planning must explicitly resolve that
difference, define what “template circulated” means and how it is recorded, identify editable
fields, and decide when revisions require regenerated artwork or another review. Orders
start only after publication; if any are placed during the subsequent pre-circulation editing
window, preserve their evidence and all existing finalised offer versions. Do not infer that
editing a live Store permits historical evidence changes.

For each current gate, planning must distinguish an automatic validation, a reusable C1
configuration/default, information or consent collected at intake, and an actual exception
requiring intervention. Retain the necessary authority and commercial evidence without
requiring avoidable follow-up decisions. Consent cannot be inferred from silence. Unready
exceptions must remain unpublished with one clear explanation, a responsible person and a
route back to the normal flow; the default successful path should require none of those
interventions. Catalogue/workflow, tenant, payment and finalised-evidence controls remain
authoritative until an explicitly approved successor contract replaces them.

Required human acceptance examples for the later plan:

- A C1 user without technical expertise can configure an Event and its supported intake
  route from understandable defaults, without hunting through unrelated management screens.
- C2 completes one guided question/review sequence on a supported route and obtains the
  correctly branded and stocked live Store without a separate post-intake decision; a future-dated
  Store opens at the configured time when its prerequisites remain valid.
- Orders are unavailable before publication and become possible only when the published
  Store's applicable trading gates pass.
- C2 can make the permitted edits after publication and before recorded template circulation;
  the appropriate revised view/artwork follows, while earlier offer/Order evidence survives.
- An invalid or incomplete setup explains the actual exception without exposing a Store
  prematurely, and recovery/retry does not duplicate Projects, Stores or publication actions.

This owner clarification is registered in the authoritative FUND roadmap. It does not change
current B1 smoke behaviour, reselect Now/Next, remove gates now, authorise implementation or
claim that public purchasing is already available. Triage must map the remaining gaps and
resolve the publication/finalisation/circulation contracts before bounded Phase 2 planning.
