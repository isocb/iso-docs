# FUND Documentation

**Canonical source:** `isodocs/docs/modules/fund/`  
**Module slug:** `fund`  
**Status:** Substantial internal foundation exists; `1R-F-B` user/workflow/proportionality
reconciliation is portfolio `Now`; no implementation is selected

FUND is the reusable IsoStack module for fundraising, project lifecycle management, organiser engagement, commerce/store planning, commission distribution and production coordination.

AMOW remains the founding use case / production partner context, but not the module identity.

## Current Strategic Position

FUND is not yet an end-to-end operational module. Its current business spine is:

```text
C1 configuration -> C2 Project -> Products -> workflow preparation/review
-> Individual finalisation/document or other branch approval -> publication readiness -> Store
-> purchaser Order/payment -> Order operations -> artwork/production matching
-> production/fulfilment -> dispatch -> commission
```

C1/C2 administration, Product selection, Store configuration and backend Commerce have
substantial foundations. Individual Artwork has a completed technical proof. The public
Store, complete purchaser journey, operational artwork matching, production, dispatch and
commission outcomes remain incomplete.

The current action is documentation-only Pass 1 in [`1R-F-B - User Framework, Project
Workflow And Vertical-Slice Reconciliation`](03-slice-planning/2026-09-01-fund-phase-1-slice-1r-f-b-individual-artwork-template-offer-lock-schema-foundation-planning.md).
It must agree the C1/C2/purchaser framework, workflow branches and smallest coherent later
vertical outcome. Pass 2 (minimum Individual Artwork journey) and Pass 3 (operational
hardening) are not selected. The retained ten-record schema option is not implementation
authority. The active plan distinguishes ready-to-finalise from ready-to-publish and
contains the proposed user walkthrough and business answers for acceptance. Essential
private access, offer/document consistency, failure handling and recovery belong to the
first usable journey; Pass 3 adds evidence-led operational improvements.

## Business Situation Report

Read the [FUND business situation and Phase 1 smoke report](00-roadmap-control/2026-08-25-fund-complete-module-smoke-readiness-business-overview.md)
for the plain-English position, confirmed decisions and remaining choices. Keep that
existing report aligned with material lifecycle updates; it is not a second roadmap.

The owner confirmed Individual-only Phase 1 smoke, a calculated/finalised commission
statement without settlement, and simulated external services for development staging
before FUND deployment. Staging must later reflect live services. Delivery, Products/buyer
choices, media, setup and messages have separate options in the report; the active plan
retains its still-unaccepted offer/finalisation proposals and no implementation is selected.

## Start Here

Read in this order when resuming work:

1. `00-roadmap-control/` - current master state, branches, lanes and next slices.
2. `02-triage/` - current decisions from issue/change request evidence.
3. `03-slice-planning/` - current active slice plans.
4. `01-cr-inputs/` - raw issue/change request evidence only when needed.
5. `05-fund-open-questions.md` - active/deferred design questions.
6. `README-AI.md` - concise AI handoff and guardrails.

Also apply the shared human/AI portfolio method at `../<module>/work-method.md`. The root
and child roadmaps, not a CR, old plan, chat memory or printable summary, select executable
work.

## Document Workflow

```text
Issue / CR input
  -> triage decision
  -> slice planning
  -> implementation confirmation
  -> review/test confirmation
  -> roadmap/control update
```

Meaning:

- CR inputs are raw observation and evidence.
- Triage documents decide priority, category, blocker status and next action.
- Slice planning documents define what will be built or reviewed.
- Implementation confirmations record what was actually changed.
- Review/test confirmations prove behaviour and record defects.
- Roadmap/control documents maintain the current master sequence.

## Planning Review Rule

For every new FUND planning slice, start with the current roadmap/control document.

The roadmap/control document carries the live issue-status register and current sequence. It should answer:

- which issues are open, remediated, deferred or pending review;
- which issues block C2 planning;
- which issues block Store/Commerce planning;
- which slice should handle each issue next.

Use triage documents as the supporting decision record when background detail is needed. Do not rely on rereading every historical triage document to reconstruct current status.

After each remediation, review/test or architecture-planning slice, update the roadmap/control status register so it remains the single operational view.

## CR Handling Rule

Change requests are treated as development inputs, not direct implementation instructions.

Every CR must pass through triage before implementation. If accepted, it receives the same slice planning, implementation confirmation, review/test confirmation and roadmap update sequence as new feature work.

Standard CR sequence:

```text
1. Log issue / export CR evidence.
2. Triage into immediate remediation, polish, architecture planning or defer.
3. Create or update a named slice planning document.
4. Implement the accepted slice.
5. Create an implementation confirmation.
6. Review/test the remediation.
7. Create a review/test confirmation.
8. Update roadmap/control.
9. Promote only when clean.
```

## Current Folder Roles

- `00-roadmap-control/` - current roadmap and slice-control documents.
- `01-cr-inputs/` - raw issue tracker exports/change request evidence.
- `02-triage/` - prioritisation and decision documents.
- `03-slice-planning/` - current and future active slice plans.
- `04-implementation-confirmations/` - new implementation confirmations.
- `05-review-and-test/` - new review/test confirmations.
- `Planning/` - historical slice planning records retained in place unless actively moved.
- `implementation/` - historical implementation confirmations retained in place unless actively moved.
- `_archive/` - superseded historical implementation notes and materials.

## Active Planning Sources

The canonical product and architecture documents remain:

- `01-fund-module-brief.md`
- `02-fund-architecture-principles.md`
- `03-fund-functional-specification.md`
- `04-fund-phase-1-implementation-plan.md`
- `05-fund-open-questions.md`

Current operational control starts at:

```text
00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md
```

The business completion view is:

```text
00-roadmap-control/2026-07-15-fund-store-artwork-orders-and-production-strategic-completion-roadmap.md
```

## Current Repository Position

Application repository:

```text
local/remote main = dev = staging = 14077382
worktree clean
```

Documentation repository:

```text
working branch = fix/platform-fast-uri-advisory-20260903
reconciliation base/upstream at review = 2f3c09e
main/origin-main at review = 4e4ed16
owner authorised a local documentation commit; no push or main alignment is authorised
inspect current refs before resuming; the amendment is not claimed online
```

There is no application work branch for `1R-F-B`; the selected action authorises
documentation review only.

Separate LMSPro remediation branch retained outside this FUND action:

```text
feature/seasonpro-remediation
```

## Rule For Future Updates

Use the numbered lifecycle folders for current and new operational documents.

Leave older planning/implementation files in place unless they become operationally active again. If a file is moved, leave a small pointer at the old path to avoid context loss.

Code-adjacent docs in `isostack-bedrock/src/modules/fund/docs/` should be short pointers or implementation notes, not duplicate canonical planning documents.
