# FUND AI Handoff

Use this when resuming FUND work with an AI coding assistant.

## Required Reading

1. `docs/2026-IsoStack-Docs/Module Building/FUND_MODULE_PROJECT.md`
2. `docs/2026-IsoStack-Docs/Module Building/01-functional-specification-FUND.md`
3. `src/modules/fund/docs/FUND-considerations.md`
4. `src/modules/fund/docs/fund-tool-selection-thoughts.md`

## Current State

FUND is planning-only. No database models, migrations, routers, or UI routes have been built yet.

AMOW has been replaced as the module identity. Treat AMOW as a founding use case/production partner, not as the module name.

## Safe Next Prompt

```text
Continue FUND module build from Phase 1 in FUND_MODULE_PROJECT.md.
Create the database foundation models in prisma/schema.prisma under @@schema("fund").
Do not use db:push. Use a Prisma migration only after schema review.
```
