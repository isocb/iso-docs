# FUND — Phase 1 Simple Store Launch Plan

Date: 2026-09-16; replaced in place on 2026-09-17 at Chris's request.

Status: **Owner-directed planning revision; implementation not yet selected.**
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
No application, fixture, environment or promotion change is authorised by this revision.

## 1. Client Outcome And Next Demonstration

The complete business journey is:

**C1 sets reusable defaults → C2 creates a Project → reviews its prepared Store and commission
→ checks one launch confirmation → Store publishes, or opens at its configured time.**

For supported intake routes, the review and confirmation finish the intake sequence; there
is no second setup checklist afterward. Event/Project workflow and Catalogue eligibility
continue to select the available Products, with C2 choosing the permitted subset. Use existing
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
- Project creation automatically resolves those terms. Existing unlaunched Projects resolve
  them during Store refresh/review. There is no C1 per-Project proposal action, separate C2
  acceptance screen, standalone policy editor or Project-specific override in this scope.
- Show the percentage, or complete dated ladder, in ordinary language in the launch review.
  One checkbox confirms the Store and displayed terms; the launch action records actor,
  time and the terms together with publication. Automatic inheritance must not fabricate
  a human acceptance record before that confirmation.
- A scheduled date transition uses the corresponding rate without another acceptance.
  Keep exact percentage arithmetic and explicit boundary dates/timezone. Validate overlapping
  or uncovered dates when C1 saves a ladder, not as repeated C2 setup tasks.
- Calculating earned commission, statements and settlement are later work. Retain existing
  payment-date calculation semantics unless separately changed; the visible launch rate
  must not imply one fixed rate for all future sales under a dated ladder.

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
automatic commission/image resolution, then C2 Store review and accurate actions. Demonstrate
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

These are recommendations or unresolved delivery costs, not silently accepted extra scope.
Apply [the simplicity requirement](../../%3Cmodule%3E/work-method.md#11-simplicity-and-demonstrable-delivery)
to any further material complexity discovered during implementation.

| Issue | Client value and cost | Simpler recommendation / decision boundary |
| --- | --- | --- |
| Changing a ladder after a Store launches | Renegotiation, retrospective changes and replacement acceptance would add UI, evidence and substantial testing. | Keep the published schedule for that Store; normal date transitions still apply. C1 edits affect unlaunched Projects. This is a proposed first-release limitation for Chris to judge, not an accepted permanent restriction. |
| Individual template circulation and editing | Current B1 finalisation locks content earlier than the requested pre-circulation editing window. An unlock/version workflow adds user steps and development. | Preserve current evidence while delivering preparation. Present the smallest editing/circulation rule before real release; do not claim one launch checkbox resolves this automatically or silently add another approval. |
| Public Store, artwork release and payments | These are actual missing capabilities needed for a usable selling service; they cannot be replaced by a checkbox or environment toggle. | Reuse existing Commerce/payment services and the existing 1R-G/Phase 1 work. Prove one supported workflow end to end before extending it; estimate remaining delivery from that concrete scope, without another foundation-only detour. |

Out of scope: per-Project commission negotiation/overrides, general replacement-proposal
management, retrospective recalculation, statements/payouts, gallery/folders/Colour images,
new approval roles, speculative multi-country configuration and wholesale intake redesign.
Do not add any of these merely because the old schema can represent them.

## 5. Completion Evidence And Smoke

Automated checks must prove default/Event precedence (including zero/unset), ladder boundaries,
image fallback and trusted asset handling, tenant/role refusal, stale/concurrent launch refusal,
retry behaviour and unchanged frozen financial/artwork evidence. Test affected shared Commerce
consumers and any migration/rollback boundary. Run relevant type/lint/build checks. Keep live
publication disabled until actual release prerequisites are delivered and verified.

After the preparation increment and review, give Chris one short demonstration/smoke:

1. C1 sets a flat default and one Event ladder using supported screens; completes any genuine
   one-time producer setup. Create a Product without uploading an image: its fallback appears.
2. C2 creates a standalone and an Event Project. Each shows the right Products, gross prices,
   images and inherited terms without commission proposal/acceptance or image-assignment chores.
3. For the supported Individual Project, review/finalise the development offer and download
   its labelled PDF. Check preserved content and truthful release status. This does not prove
   purchaser layout or production print quality; those still need their own delivered output.

Request the launch/public Store/test-Order smoke only when those capabilities exist. The
launch review must then have one combined Store/commission confirmation. Preserve A0/A/B PASS
unless a relevant pricing change warrants regression checks. Record actual changes in 04 and
proof in 05; no premature PASS. Use normal human acceptance and controlled promotion, with
specific main/live approval. This revision stops at the updated plan; implementation selection
remains the next delivery decision, without a new CR or another planning layer.
