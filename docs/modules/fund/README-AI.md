# FUND AI Handoff

Use this when resuming FUND work with an AI coding assistant.

## Required Reading

1. `FUND_MODULE_BRIEF.md` (canonical product and architecture brief)
2. `planning/FUND_PHASE1_IMPLEMENTATION_BACKLOG.md` (active Phase 1 build plan)
3. `planning/future_phase_notes.md` (future phases only; parking notes)
4. `FUND_MODULE_STATUS.md` (current implementation status)
5. `archive/` (superseded historical material only)

## Current State

FUND is planning-ready but not yet implemented.

- No Prisma models exist yet.
- No Prisma migrations exist yet.
- No tRPC routers or services exist yet.
- No UI routes exist yet.
- AMOW is the founding use case/production partner context, not the FUND module identity.
- Do not use `FUND_MODULE_PROJECT.md` as an active plan; it is historical only.

## Safe Next Prompt

```text
Review and approve FUND_MODULE_STATUS.md and planning/FUND_PHASE1_IMPLEMENTATION_BACKLOG.md first.
Then begin implementation slice 1 only after approval.
Do not use db:push.
Do not run seed or reset commands.
Create the database foundation only through migration-safe planning-to-code flow.
```
