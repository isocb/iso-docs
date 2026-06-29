# LMSPro Documentation

**Canonical source:** `isodocs/docs/modules/lmspro/`  
**Product name:** LMSPro / SeasonPro  
**Status:** Active module documentation

This folder is the single source of truth for LMSPro documentation. Historical copies in `isostack-bedrock/docs/...` should be treated as redirects/pointers only.

## Core References

- `features.md` — feature inventory and capability overview
- `setup.md` — setup and operating notes
- `key-dates-reference.md` — key date and timing reference
- `season-preparation-sequence.md` — season preparation workflow
- `season-roll-forward-consolidated-requirements.md` — consolidated roll-forward requirements and decisions
- `season-rollover-reference.md` — season rollover / roll-forward reference
- `team-continuation-card.md` — team continuation UI/workflow notes
- `timed-forms-and-action-cards.md` — timed forms and action-card architecture
- `unified-timing-architecture.md` — unified timing model
- `unified-workflow-gating-architecture.md` — workflow gate architecture
- `danger-gate.md` — dangerous operations / safety notes

## Planning

Planning documents are under `planning/`:

- `LMSPro-Implementation-Plan-FINAL.md`
- `LMSPro-Development-Work-Plan-v1.0.txt`
- `DJFL-Implementation-Plan.md`
- `dcfl_functional_specification_v1.2.md`
- `SeasonPropression.md` — season transition and preparation system planning
- CR planning documents (`CR-18`, `CR-19`, `CR-20`, `CR-21`)
- `Venues-Referees-Implementation-Plan.md`

## Operational Workflow

New LMSPro / SeasonPro operational work should use the numbered lifecycle folders:

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

Start current remediation work at:

```text
00-roadmap-control/2026-06-29-lmspro-roadmap-and-slice-control.md
```

Current folder roles:

- `00-roadmap-control/` - current roadmap and slice-control documents.
- `01-cr-inputs/` - raw issue/change request evidence.
- `02-triage/` - prioritisation and decision documents.
- `03-slice-planning/` - current and future active slice plans.
- `04-implementation-confirmations/` - implementation confirmations.
- `05-review-and-test/` - review/test confirmations.
- `planning/` - historical and broader planning records retained in place unless actively moved.

## Legacy Imports

Older files copied from `isostack-bedrock/docs/00-READ_THIS/modules/lmspro/` are preserved under `legacy-read-this/` for searchability and historical context. Prefer newer documents in the root or `planning/` when there is overlap.

Notable legacy files include `user-role-templates.md`, `free-days-system.md`, `team-status-lifecycle.md`, and historical implementation/progress reports.

The older `isostack-bedrock/docs/2026-IsoStack-Docs/Archive/old-structure/modules/lmspro/` tree is preserved under `legacy-read-this/archive-old-structure/`.

## Legal and Marketing

- `legal-documents/` — legal framework, policies, terms, DPA, pilot agreements
- `marketing-content/` — SeasonPro marketing-site copy and supporting terms references
- `marketing-content/SEASONPRO_BENEFITS_SUMMARY.md` — benefits summary migrated from the application repo sample-data folder

## Rule for Future Updates

Add or update LMSPro documentation here first. If code-repository context is needed in `isostack-bedrock`, add a short pointer file linking back to this folder rather than duplicating the document.
