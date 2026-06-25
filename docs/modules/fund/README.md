# FUND Documentation

**Canonical source:** `isodocs/docs/modules/fund/`  
**Module slug:** `fund`  
**Status:** C1 admin foundation released; C1 remediation and C2 access planning active

FUND is the reusable IsoStack module for fundraising, project lifecycle management, organiser engagement, commerce/store planning, commission distribution and production coordination.

AMOW remains the founding use case / production partner context, but not the module identity.

## Start Here

Read in this order when resuming work:

1. `00-roadmap-control/` - current master state, branches, lanes and next slices.
2. `02-triage/` - current decisions from issue/change request evidence.
3. `03-slice-planning/` - current active slice plans.
4. `01-cr-inputs/` - raw issue/change request evidence only when needed.
5. `05-fund-open-questions.md` - active/deferred design questions.
6. `README-AI.md` - concise AI handoff and guardrails.

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

## Current App Branches

Released baseline:

```text
main = dev = staging = 62b727e chore(release): promote FUND C1 admin foundation
```

Active FUND branch:

```text
feature/fund-phase-1-c2-project-access
```

Separate SeasonPro remediation branch:

```text
feature/seasonpro-remediation
```

## Rule For Future Updates

Use the numbered lifecycle folders for current and new operational documents.

Leave older planning/implementation files in place unless they become operationally active again. If a file is moved, leave a small pointer at the old path to avoid context loss.

Code-adjacent docs in `isostack-bedrock/src/modules/fund/docs/` should be short pointers or implementation notes, not duplicate canonical planning documents.
