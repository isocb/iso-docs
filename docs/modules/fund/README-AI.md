# FUND AI Handoff

Do not implement from old Phase 1 backlog documents.
The next task is schema design proposal only, not implementation.
Use this when resuming FUND work with an AI coding assistant.

## Required Reading

1. `01-fund-module-brief.md`
2. `02-fund-architecture-principles.md`
3. `03-fund-functional-specification.md`
4. `04-fund-phase-1-implementation-plan.md`
5. `05-fund-open-questions.md`
6. `_archive/` only when historical context is needed

## Current State

FUND has a shell only and is otherwise planning-ready.

- No Prisma models exist yet.
- No Prisma migrations exist yet.
- No tRPC routers or services exist yet.
- No FUND CRUD UI exists yet.
- `/app/fund` exists as a shell page only.
- AMOW is the founding use case/production partner context, not the FUND module identity.
- Do not use `FUND_MODULE_PROJECT.md` as an active plan; it is historical only.
- Do not use old Phase 1 backlog documents as active implementation plans.

## Safe Next Prompt

```text
Review and approve the active FUND documentation set:
- 01-fund-module-brief.md
- 02-fund-architecture-principles.md
- 03-fund-functional-specification.md
- 04-fund-phase-1-implementation-plan.md
- 05-fund-open-questions.md

Then produce a schema design proposal only.

Do not edit code.
Do not edit Prisma schema.
Do not create migrations.
Do not use db:push.
Do not run seed or reset commands.
Do not create routers, UI pages or services.
```
