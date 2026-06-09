# FUND — Considerations

*Status: Pre-development planning | Date: June 2026*

---

## What is FUND?

FUND is a reusable IsoStack module for fundraising, e-commerce, project lifecycle management, organiser engagement, commission distribution, and production coordination.

It replaces the earlier AMOW-specific module planning scaffold. AMOW remains the founding use case and may be represented as a tenant, catalogue, production partner, or fulfilment partner — but FUND is the platform module.

---

## Platform Decision

**Build on IsoStack Bedrock as a module (`fund`).**

Rationale:

- Multi-tenancy, auth, roles, audit logging, email, file storage, product packaging, and branding are already provided by IsoStack
- Existing module patterns are proven through LMSPro, Pulse, and Bedrock
- FUND can serve AMOW and future fundraising/production tenants without bespoke forks
- AMOW-specific rules should live in configuration/seed data, not module identity

---

## Core Feature Areas

1. **Fundraising product catalogue** — configurable products, categories, availability, personalisation rules
2. **Events/campaigns** — Christmas, Mother's Day, club fundraising, client-defined campaigns
3. **Projects** — operational unit connecting organiser, event, store, lifecycle, production, and commission
4. **Store engine** — tenant/project-specific storefront and order capture
5. **Payments** — Stripe checkout and payment lifecycle
6. **Artwork/data handling** — uploads, validation, source files, generated outputs
7. **PDF/output generation** — proof/final output generation and storage
8. **Production workflow** — batching, fulfilment status, dispatch
9. **Commission engine** — configurable revenue splits and payout reporting
10. **Organiser/client portal** — project status, store link, sales, deadlines, outputs

---

## Key Difference From AMOW Planning

| Earlier AMOW scaffold | FUND module |
|---|---|
| Single business/use-case identity | Reusable product capability |
| AMOW as module name | AMOW as founding tenant/production partner |
| Project delivery focus | Fundraising + commerce + production lifecycle |
| Tool choices framed around AMOW | Tool choices framed around reusable FUND workflows |

---

## Module Structure

```text
src/modules/fund/
├── module.config.ts
├── docs/
├── routers/
├── schemas/
├── services/
├── components/
└── lib/

src/app/(app)/app/fund/
```

---

## Reference

Central project plan:

`docs/2026-IsoStack-Docs/Module Building/FUND_MODULE_PROJECT.md`

Functional specification:

`docs/2026-IsoStack-Docs/Module Building/01-functional-specification-FUND.md`
