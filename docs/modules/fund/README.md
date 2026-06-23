# FUND Documentation

**Canonical source:** `isodocs/docs/modules/fund/`  
**Module slug:** `fund`  
**Status:** Planning / ready for phased build

FUND is the reusable IsoStack module for fundraising, e-commerce, project lifecycle management, organiser engagement, commission distribution, and production coordination.

FUND replaces the earlier AMOW-specific planning scaffold. AMOW remains the founding use case / production partner context, but not the module identity.

## Start Here

- `01-fund-module-brief.md` — product, business and strategic overview
- `02-fund-architecture-principles.md` — architecture and Codex guardrails
- `03-fund-functional-specification.md` — functional scope and behavioural requirements
- `04-fund-phase-1-implementation-plan.md` — revised Phase 1 roadmap, slices and tests
- `05-fund-open-questions.md` — decisions to resolve before schema work
- `README-AI.md` — concise AI handoff and operational guardrails

## Active Planning Sources

The active FUND planning sources are:

- `01-fund-module-brief.md`
- `02-fund-architecture-principles.md`
- `03-fund-functional-specification.md`
- `04-fund-phase-1-implementation-plan.md`
- `05-fund-open-questions.md`

Archived documents, including `_archive/FUND_MODULE_PROJECT.md`, are retained for historical reference only and must not be used as active implementation plans.

`_archive/` — superseded historical implementation notes and materials

## Implementation Status

No FUND schema, routers, migrations, or CRUD UI have been built yet. Slice 1A is complete in `isostack-bedrock` commit `db6ff5f`:
- `/app/fund` module shell is in place.
- Module config, registry, and nav registration are aligned.
- The slice is now a gated, visible module shell only.

Current work is revised Phase 1 planning. No FUND schema, router, service or CRUD implementation should begin until the active planning documents and open questions have been reviewed.

## Rule for Future Updates

Add or update FUND documentation here first. Code-adjacent docs in `isostack-bedrock/src/modules/fund/docs/` should be short pointers or implementation notes, not duplicate canonical planning documents.

`FUND_MODULE_PROJECT.md` and older Phase 1 backlog documents are historical and must not be treated as active plan sources.
