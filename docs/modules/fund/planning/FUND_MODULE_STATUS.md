# FUND Module Status

**Date:** 9 June 2026  
**Current phase:** Phase 0 — Planning scaffold replacement

## Completed

- FUND functional specification exists: `01-functional-specification-FUND.md`
- FUND project plan created: `FUND_MODULE_PROJECT.md`
- FUND module scaffold created: `src/modules/fund/`
- AMOW planning has been superseded by FUND

## Not Started

- FUND Prisma schema
- FUND migrations
- FUND tRPC routers/services
- FUND UI routes
- FUND Stripe checkout implementation
- FUND PDF generation spike
- FUND commission engine

## Next Recommended Step

Start Phase 1 from `FUND_MODULE_PROJECT.md`: Database Foundation.

Do not use `db:push`; create a Prisma migration with `db:migrate:dev` once schema changes are ready.
