# FUND — Phase 1 Simple Store Launch Plan

Date: 2026-09-16; replaced in place on 2026-09-17 at Chris's request.

Status: **Implementation authorised by Chris on 17 September; paused during focused code review for the first-setup decision in section 6.**
Control depth: **High** because commission configuration, publication authority and preserved
financial evidence change. This requires strong automated proof, not extra user approvals.
Work type: proposed production behaviour, demonstrated locally before controlled promotion.

This replaces the previous proposal for separate C1 commission offers, independent C2
acceptance and manual per-Product logo assignment. It also supersedes those user-workflow
requirements in the historical C5 plan. Existing schema and implementation evidence remain
history, not a reason to retain unnecessary steps. Simplicity is a first-release requirement.

[Root control](../../../00-roadmap-control/2026-07-13-isostack-platform-and-module-roadmap-control.md)
and [FUND control](../00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md) retain
**B1 Now / 1R-G planning Next**. The [B1 plan](2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-journey-development-plan.md)
keeps the sole checkpoint. A0/A/B VAT smoke remains PASS; C/publication smoke stays paused.
Chris authorises implementation of the preparation increment, with a stop for unresolved
business implications. This does not select the later public-release/purchaser work or
authorise deployment. No application or database change has been made at this review pause.

## 1. Client Outcome And Next Demonstration

The complete business journey is:

**C1 sets reusable defaults → C2 creates a Project → reviews its prepared Store and commission
→ checks one launch confirmation → Store publishes, or opens at its configured time.**

For supported intake routes, the review and confirmation finish the intake sequence; there
is no second setup checklist afterward. Event/Project workflow and Catalogue eligibility
provide the eligible Products, all included by default; C2 may optionally remove some. Use existing
branding, dates, prices and template defaults where valid. Only missing business information
or actual exceptions require intervention. Do not make C1 approve every Project.

The first demonstration uses the existing Individual Event-linked and standalone Project
creation routes. The four-workflow model remains unchanged. The next increment is a working
preparation journey: C1 saves a default rate;
C2 creates an Event-linked or standalone Project; selected Products, VAT-inclusive prices,
automatic images and applicable commission appear together; the existing Individual
review/PDF path is usable. No database editing or hidden fixture repair should be needed
for the supported setup. This proves preparation, **not live publication**.

The subsequent release demonstration must prove the same journey through actual publication,
a public Store and a test purchase/Order. Public Store presentation, production Individual
artwork release and purchaser/payment integration are unfinished dependencies. They must be
completed through the existing Phase 1 sequence; a green preparation screen is not their
acceptance. Do not ask Chris to test an unavailable publication path again.

## 2. Minimal Business Behaviour

### Commission: configure once, inherit, confirm with launch

- C1 sets one tenant/producer default flat percentage. An Event may instead have a simple
  dated rate ladder. Standalone Projects inherit the producer default; Event Projects use
  their Event ladder if configured, otherwise that default. Zero is valid; unset is not zero.
- Project creation automatically resolves those terms. Existing Projects that have neither
  started nor launched resolve them during Store refresh/review. There is no C1 per-Project proposal action, separate C2
  acceptance screen, standalone policy editor or Project-specific override in this scope.
- Show the percentage, or complete dated ladder, in ordinary language in the launch review.
  One checkbox confirms the Store and displayed terms; the launch action records actor,
  time and the terms together with publication. Automatic inheritance must not fabricate
  a human acceptance record before that confirmation.
- Chris accepts preventing changes to a Project's commission terms after its start date or
  Store launch. Planning interpretation: the earlier of those two points fixes that Project's
  flat rate or complete ladder. Later C1 default/ladder edits affect only Projects that have
  neither started nor launched; do not reopen the boundary by moving a date or closing a Store.
  Resolve and preserve the applicable terms at the cutoff, not whichever default exists when
  the Project is next viewed. A missing pre-cutoff configuration is a C1 setup exception, not
  permission to fabricate historical terms.
- A scheduled date transition uses the corresponding rate without another acceptance.
  Keep exact percentage arithmetic and explicit boundary dates/timezone. Validate overlapping
  or uncovered dates when C1 saves a ladder, not as repeated C2 setup tasks.
- Calculating earned commission, statements and settlement are later work. Retain existing
  payment-date calculation semantics unless separately changed; the visible launch rate
  must not imply one fixed rate for all future sales under a dated ladder.

### Products and template: include by default, optional removal, no unlock

- At Project creation include all eligible Products from its Event's available Catalogues,
  or from the standalone Catalogues matching its workflow. Deduplicate Products appearing in
  more than one Catalogue. C1 prepares the Event/template and Catalogue set once.
- Show that included set in the Product summary. A simple **“Remove Products”** switch exposes
  removal controls only when C2 wants them. Leaving it unused satisfies the Product-selection
  step without another save, selector visit or acceptance checkbox. Actual eligibility and
  readiness still apply; an empty eligible set is a C1 configuration problem.
- Build the offer/template content from the resulting accepted Product set. Default selection
  is not an immediate immutable lock: optional removal happens before existing finalisation.
  After finalisation, keep the selection/content lock. **No unlock or new circulation/version
  workflow is in this delivery.** This supersedes the earlier proposal to develop one to
  support post-finalisation, pre-circulation Product editing.
- Refresh/retry must preserve C2 removals, not reselect everything. Later Catalogue edits must
  not rewrite finalised evidence. Check that the prepared C1 set fits the assigned template
  capacity; surface an actual mismatch to C1 without silently dropping Products or asking
  every C2 to trim an otherwise valid default set.

### Images and Seller setup: remove routine preparation chores

- A real Product image takes precedence. Otherwise use the tenant logo automatically as a
  temporary placeholder, visible on Product and Store. Recommended fallback when no usable
  logo exists: a bundled neutral Product image, so missing photography does not block launch.
  No library browsing or per-Product assignment button is needed for this bridge.
- Readiness, presentation and generated evidence must use the same effective image rule.
  Resolve only trusted assets; preserve the image used in finalised evidence. Full Product
  upload/gallery/options work remains separate and is not declared complete by a placeholder.
- Reuse the producer's shared Seller identity and existing Payments settings. Prefill genuine
  organisation details; ask C1 once for genuinely missing required details. Do not invent
  identity or require a general Seller administration subsystem to prepare each Project.
  Reuse existing authorised roles; any proposed extra role or setup stage needs justification.
- Development PDF preparation must work without live Stripe onboarding. Production publication
  still needs valid Seller/payment readiness. Explain an unavailable release capability as
  unfinished development, not a task assigned to an ordinary C1 or C2 user.

## 3. Delivery Sequence And Technical Boundary

Implement the preparation increment as a connected path: C1 defaults and minimal Seller setup,
automatic commission/image resolution and Product inclusion, then C2 Store review and actions. Demonstrate
it before expanding scope. Connect that same review to one launch confirmation when the
existing real-release/public Store dependencies are delivered; do not build a second journey.

Reuse existing commission version/assignment evidence internally where practical. C5 currently
has Event/Project policy ownership, not a producer default: implementation must assess the
smallest tenant-scoped default storage and adaptation of assignment/acceptance constraints.
Do not pretend no migration can be needed or expose internal record states as extra UI steps.
Keep one source of commission authority. Any migration follows the
[Safe Database Workflow](../../../../SAFE_DATABASE_WORKFLOW.md); no reset, guessed bulk terms
or rewriting accepted evidence. Existing unfinalised test Projects must have a supported route.

Publication rechecks permissions, current terms, eligible Products, dates and payment/release
readiness on the server. A stale launch review requires refresh, not publication on different
terms. Confirmation and publication must be atomic and retry-safe. Preserve existing Orders,
finalised offers and prior accepted terms; a failure must leave recoverable configuration and
no false acceptance/publication. Rollback uses compatible code or a forward correction,
never deletion of evidence. Preserve Chris's test bed and leave old wf1 archived.

## 4. Complexity Explicitly Presented For Chris's Judgement

Chris has answered the first two issues below. His annotations are retained as source
comments; the operative decisions are in section 2 and the final column. The start/launch
cutoff and default-versus-finalisation distinction are stated explicitly above. The third
row remains a delivery dependency, not another requested approval.
Apply [the simplicity requirement](../../%3Cmodule%3E/work-method.md#11-simplicity-and-demonstrable-delivery)
to any further material complexity discovered during implementation.

| Issue | Client value and cost | Simpler recommendation / decision boundary |
| --- | --- | --- |
| Changing a ladder after a Store launches **Chris - Prevent** | Renegotiation, retrospective changes and replacement acceptance would add UI, evidence and substantial testing. **No retrospective changes after project start date/launch**| Accepted: freeze this Project's terms at start or launch, whichever occurs first. Scheduled transitions still apply. C1 edits affect only Projects neither started nor launched. No retrospective changes or replacement acceptance. **Chris: Agreed** |
| Individual template circulation and editing | Current B1 finalisation locks content earlier than the requested pre-circulation editing window. **Chris: Agreed - the current system locks the template on project ingest - but the template is manually changed for each event to prepare available products.  We are creating the template based on accepted products.  It is likely that the C2 will default to the products in the cataglogue and actually much more likely to accept all... the product selector is a n ice to have.  Suggest a simple switch/check box on the product summary to enable product removal - if this is not used the product selection gate is satisfied**  An unlock/version workflow adds user steps and development. **no Unlock, and simply locking by making event/chosen catalogue products the default** | Accepted: include all eligible Catalogue Products automatically; optional removal before finalisation via the Product summary. No mandatory selector step and no unlock. Clarification: existing code locks at offer finalisation; default inclusion alone is not that lock. |
| Public Store, artwork release and payments | These are actual missing capabilities needed for a usable selling service; they cannot be replaced by a checkbox or environment toggle. | Reuse existing Commerce/payment services and the existing 1R-G/Phase 1 work. Prove one supported workflow end to end before extending it; estimate remaining delivery from that concrete scope, without another foundation-only detour. |

Out of scope: per-Project commission negotiation/overrides, general replacement-proposal
management, retrospective recalculation, unlock/circulation workflows, statements/payouts, gallery/folders/Colour images,
new approval roles, speculative multi-country configuration and wholesale intake redesign.
Do not add any of these merely because the old schema can represent them.

## 5. Completion Evidence And Smoke

Automated checks must prove default/Event precedence (including zero/unset), ladder boundaries
and the start/launch cutoff (including edits before first later access), default inclusion,
deduplication, optional removal preserved on refresh and finalised-selection refusal,
image fallback and trusted asset handling, tenant/role refusal, stale/concurrent launch refusal,
retry behaviour and unchanged frozen financial/artwork evidence. Test affected shared Commerce
consumers and any migration/rollback boundary. Run relevant type/lint/build checks. Keep live
publication disabled until actual release prerequisites are delivered and verified.

After the preparation increment and review, give Chris one short demonstration/smoke:

1. C1 sets a flat default and one Event ladder using supported screens; completes any genuine
   one-time producer setup. Create a Product without uploading an image: its fallback appears.
2. C2 creates a standalone and an Event Project. Each shows the right Products, gross prices,
   images and inherited terms. Leave “Remove Products” off: all eligible Products are included
   without a selector/save step. On a second draft, enable it and remove one Product; refresh
   preserves that choice and the prepared offer uses the resulting set.
3. For the supported Individual Project, review/finalise the development offer and download
   its labelled PDF. Check the selection lock, preserved content and truthful release status. This does not prove
   purchaser layout or production print quality; those still need their own delivered output.

Use automated dated fixtures to prove commission edits cannot affect a Project after its
start/launch cutoff while scheduled rate transitions still work; do not make Chris wait for
calendar dates or reset his Projects to prove this.

Request the launch/public Store/test-Order smoke only when those capabilities exist. The
launch review must then have one combined Store/commission confirmation. Preserve A0/A/B PASS
unless a relevant pricing change warrants regression checks. Record actual changes in 04 and
proof in 05; no premature PASS. Use normal human acceptance and controlled promotion, with
specific main/live approval. The preparation increment is now authorised; the review pause
below must be resolved before proceeding. No new CR or planning layer is needed.


## 6. Focused Code Review — 17 September Implementation Start

Chris authorised implementation and explicitly requested a stop for unresolved implications.
Source baseline: local application `6ebaac46`. This is a focused review, not an implementation
or independent acceptance result. No runtime, data or environment changes have been made.

**Business decision pending — first commission setup after a past start date.**
`src/modules/fund/services/projects.service.ts:196` checks date order and Event boundaries,
but permits a Project start date in the past. The existing review fixture also has a past
start and no commission configuration. Strictly forbidding any first assignment after that
start leaves an unpublished Project unable to use the new setup, even without any Orders or
prior accepted terms. The plan identified missing setup as an exception but did not define
how C1 could resolve it. This needs a business decision, not another technical approval layer.

Recommendation sent to Chris: permit one-time initial inheritance of today's configured terms
only when there has been no publication, commission acceptance or Order; record setup now
and immediately lock those terms. Never backdate acceptance or replace protected evidence.
Alternative: require a new Project with a future start. Implementation is paused for the
answer under Chris's express stop instruction; the exception is not assumed approved.

Reuse confirmed during review:

- `store-management.service.ts:275` and `lib/project-product-selection.ts` already initialise
  eligible Products once and preserve exclusions. C1 creation and intake call this path.
  Reuse it and simplify the C2 controls; do not build another selection mechanism.
- `individual-offer.service.ts:388` finalises and locks the offer; intake itself is not that
  lock. The existing template-capacity check can support C1 setup feedback.
- `store-management.service.ts:566` currently requires a primary media row; the automatic
  image bridge must update readiness and snapshots as well as presentation.
- Commission models have Event/Project ownership but no producer-default mode. Adaptation is
  already within the approved assessment; it is not by itself a further business question.

No automated or human tests were run: application code is unchanged. A0/A/B PASS remains;
C/publication smoke stays paused. The B1 checkpoint remains the only restart checkpoint.
