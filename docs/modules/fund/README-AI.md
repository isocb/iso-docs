# FUND AI Handoff

Use this when resuming FUND work with an AI coding assistant.

## Read First

1. `00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md`
2. `02-triage/2026-06-25-fund-c1-admin-remediation-and-architecture-triage.md`
3. `03-slice-planning/2026-06-24-fund-phase-1-slice-1p-a-c2-project-access-model-proposal.md`
4. `03-slice-planning/2026-06-24-fund-phase-1-slice-1p-c2-organiser-dashboard-proposal.md`
5. `05-fund-open-questions.md`
6. `01-fund-module-brief.md`
7. `02-fund-architecture-principles.md`

Read CR input files only when triage or implementation needs raw issue evidence.

## Current State

The FUND C1 admin foundation has been released and aligned:

```text
main = dev = staging = 62b727e chore(release): promote FUND C1 admin foundation
```

Active app branches:

```text
feature/fund-phase-1-c2-project-access
feature/seasonpro-remediation
```

FUND C1 released/admin foundation includes:

- Products.
- Catalogues.
- Catalogue Product membership.
- Projects.
- Project Product membership.
- Events.
- Project/Event linkage.

Current FUND work is not a greenfield shell. Do not rely on old docs that say FUND has only a shell.

## Current Workflow

```text
CR input -> triage -> slice planning -> implementation confirmation -> review/test confirmation -> roadmap/control update
```

Folder meanings:

- `00-roadmap-control/` controls the current sequence.
- `01-cr-inputs/` stores raw issue/change request exports.
- `02-triage/` stores decision and priority documents.
- `03-slice-planning/` stores active/new slice plans.
- `04-implementation-confirmations/` stores new implementation confirmations.
- `05-review-and-test/` stores new review/test confirmations.

Historical `Planning/` and `implementation/` documents remain valid records but are not the first place to look for current next steps.

## Current Recommended Work

Immediate recommended work is C1 admin remediation:

1. Issue #46 - Event-linked Project close date must not be later than Event closesAt.
2. Issue #50 - Issue Manager module filtering/server render error.
3. Optional small polish if scope remains contained:
   - Project Product activation gate visibility.
   - Product breadcrumb navigation.
   - Sidebar icon specificity and UI guidance.

## FUND UI Guardrails

- Use destination-specific sidebar/navigation icons for FUND surfaces.
- Avoid repeating generic `Home` icons within the same module navigation.
- FUND dashboard cards, including future C2 organiser dashboard cards, should use one consistent card pattern:
  - the whole card should be the navigation click target when the card opens a section page;
  - title and destination-specific section icon in the card header;
  - short body copy beneath the header;
  - one consistent navigation affordance at the bottom, such as `Open <section>` with a small arrow icon;
  - use muted card surfaces with brand primary/secondary accents inherited from the active module/tenant branding;
  - do not assign arbitrary red, blue, green, pink or other decorative colours to peer cards;
  - non-brand colour should indicate RAG status, urgency, error, warning, success, information or action required, not visual decoration;
  - avoid nested link buttons inside clickable cards.
- Shared owner-controlled UI standards in `isostack-bedrock/docs/2026-IsoStack-Docs/Standards/` should not be edited unless owner approval is explicit. Put FUND-specific guardrails here or in active FUND planning/control docs.

## Do Not Start Yet

Do not start these until their planning slices are accepted:

- C2 dashboard implementation.
- Commerce Core.
- Store schema.
- Order schema.
- Payments.
- Commissions.
- Production batching.
- Organiser onboarding.
- Project Request flow.
- Event/Catalogue/Product availability schema.
- Product workflow suitability schema.
- Lifecycle transition engine.
- AI workflows.

## Safe Fresh Prompt

```text
We are working on IsoStack FUND.

Current app branch:
feature/fund-phase-1-c2-project-access

Read first:
- isodocs/docs/modules/fund/00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md
- isodocs/docs/modules/fund/02-triage/2026-06-25-fund-c1-admin-remediation-and-architecture-triage.md
- isodocs/docs/modules/fund/README-AI.md

Proceed with the next recommended remediation/planning slice only.
Do not implement unrelated features.
```
