> **Legacy / archive note**
>
> This document records the June 2026 Codex handoff context for FUND Phase 1 Slice 1A, including the `/app/fund` staging 404 issue and module shell implementation status.
>
> It is retained for historical and diagnostic value only.
>
> It has been superseded for current FUND planning and architecture by:
>
> - `01-fund-module-brief.md`
> - `02-fund-architecture-principles.md`
>
> Do not use this as the current FUND implementation brief or Phase 1 backlog.

# FUND / IsoStack Codex Handoff — Resume Context

**Purpose:**  
This document is a restart note for returning to FUND development with Codex after pausing to work on LMSPro / SeasonPro.

**Current focus when paused:** FUND Phase 1 Slice 1A had been implemented on `dev`, but a staging access issue was observed because `/app/fund` returned 404 on staging.

**Status date:** June 2026  
**Repos involved:**
- `isostack-bedrock` — application/code repo
- `isodocs` / `iso-docs` — canonical documentation repo

---

## 1. Big Picture

FUND is the reusable IsoStack module for:

- fundraising
- e-commerce
- project lifecycle management
- organiser engagement
- commission distribution
- production coordination
- future SeasonPro integration

FUND is **not** an AMOW-only module.

AMOW remains the founding use case / production partner context, but FUND must stay generic, reusable and tenant-safe.

---

## 2. Current Documentation Position

A major documentation cleanup was started before FUND implementation.

The working rule is now:

> `isodocs` is the canonical documentation home.  
> `isostack-bedrock` docs are code-adjacent only.

### Active FUND documents

Canonical FUND docs are in:

```text
isodocs/docs/modules/fund/
```

Important active files:

```text
FUND_MODULE_BRIEF.md
FUND_MODULE_STATUS.md
README.md
README-AI.md
planning/FUND_PHASE1_IMPLEMENTATION_BACKLOG.md
planning/future_phase_notes.md
```

Archived / superseded material is in:

```text
isodocs/docs/modules/fund/archive/
```

Important rule:

> Do not use `archive/FUND_MODULE_PROJECT.md` as the active implementation plan. It is retained for historical reference only.

---

## 3. Documentation Cleanup Completed

The documentation cleanup reached a safe operational baseline before FUND coding started.

### Completed docs cleanup commits

#### `isodocs`

- Commit: `d5ae3f7`
- Operational guidance cleanup:
  - added `DOCUMENTATION_MAP.md`
  - added `SAFE_DATABASE_WORKFLOW.md`
  - updated README pointers
  - updated deployment guidance
  - marked old live/staging notes as legacy where needed

#### `isostack-bedrock`

- Commit: `180f6e3`
- Operational guidance cleanup:
  - root `README.md` simplified as a code-entry point
  - Codex operating charter updated with canonical-doc source order
  - deployment/database docs reframed around migrations
  - TechTest docs marked legacy where appropriate

#### `isodocs`

- Commit: `9139d2e`
- Pre-flight FUND docs tidy:
  - moved documentation audit files into archive
  - normalised Phase 1 backlog location
  - updated FUND status and README pointers

#### `isodocs`

- Commit: `5652e0e`
- FUND moved into Phase 1 Slice 1 planning:
  - `FUND_MODULE_STATUS.md` updated
  - `README.md` updated

#### `isodocs`

- Commit: `a23b1ab`
- FUND backlog updated with:
  - P1/C1/C2/C3 terminology rules
  - FUND domain-role separation
  - table CRUD UI pattern expectations

#### `isodocs`

- Commit: `b705d5e`
- Added canonical new-module architecture template:
  - `docs/core/modules/module-architecture-template.md`
  - updated `module-development-guide.md` to point to it

---

## 4. Current FUND Implementation Status

### Completed in `isostack-bedrock`

FUND Phase 1 Slice 1A was implemented on `dev`.

Commit:

```text
db6ff5f
```

Commit message:

```text
feat(fund): add module shell registration and app entrypoint
```

Pushed to:

```text
origin/dev
```

### Files changed in Slice 1A

```text
src/modules/fund/module.config.ts
src/modules/module.registry.ts
src/core/config/module-navigation.ts
src/app/(app)/app/fund/page.tsx
src/app/(app)/dashboard/page.tsx
```

### What Slice 1A did

- Normalised `src/modules/fund/module.config.ts` to current `ModuleConfig` contract.
- Set:
  - `id: 'fund'`
  - `featureFlag: 'fund'`
  - `route: '/app/fund'`
- Registered FUND in the module registry.
- Added minimal FUND navigation item at `/app/fund`.
- Created minimal `/app/fund` shell page.
- Added FUND landing metadata in dashboard for existing module entry behaviour.

### What Slice 1A deliberately did not do

No:

- Prisma schema changes
- migrations
- `db:push`
- seed/reset commands
- tRPC data routers
- CRUD pages
- database calls
- mutations
- forms
- payment/order/commission work
- production workflow
- lifecycle automation
- AI assistant work

### Checks reported by Codex

```text
npm run type-check ✅
npm run verify ❌
```

`npm run verify` failed due to an environment sandbox IPC restriction:

```text
EPERM from tsx trying to open a local .pipe socket
```

This was reported as an environment limitation, not a known Slice 1A code issue.

---

## 5. Important Issue Observed on Staging

After FUND was added as a module in the platform product manager, this staging URL was tested:

```text
https://staging.seasonpro.co.uk/app/fund
```

Result:

```text
404
```

The login callback being generated was:

```text
https://staging.seasonpro.co.uk/auth/lmspro/login?callbackUrl=%2Fapp%2Ffund
```

### Most likely explanation

The platform/product entitlement side may now know about FUND, but the staging app does not yet contain the Slice 1A route code.

Slice 1A was committed to `dev` as:

```text
db6ff5f
```

It may not yet have been merged/deployed to `staging`.

### Key distinction

| Layer | Status / concern |
|---|---|
| Product/module entitlement | FUND may be present in platform product manager |
| Application route | `/app/fund` exists only if Slice 1A code is deployed |
| Staging branch | Must include commit `db6ff5f` |
| Database migration | Not required for Slice 1A |

---

## 6. Safe Next Investigation Prompt for Codex

Use this when returning to this work.

```text
Investigate why `/app/fund` returns 404 on staging.

Do not make changes yet.

Context:
- FUND Slice 1A was committed to `dev` as commit `db6ff5f`.
- `/app/fund` should exist from `src/app/(app)/app/fund/page.tsx`.
- FUND has been added as a module in the platform product manager.
- On staging, visiting `https://staging.seasonpro.co.uk/app/fund` returns 404.
- Login callback URL is `https://staging.seasonpro.co.uk/auth/lmspro/login?callbackUrl=%2Fapp%2Ffund`.

Please check:

1. Is commit `db6ff5f` present on the `staging` branch?
2. Does the `staging` branch contain:
   `src/app/(app)/app/fund/page.tsx`
3. Does the deployed Render staging build include the FUND route?
4. Is the route path definitely `/app/fund` under the current Next.js App Router structure?
5. Is the 404 coming from Next.js route missing, or from module/feature access logic?
6. Does `/app/fund` work locally on `dev`?
7. Does `/app/fund` work locally after checking out `staging`?
8. Are there any build/deploy logs showing the route was not included?

Do not:
- change code
- change Prisma schema
- create migrations
- run db:push
- run seed/reset commands
- merge branches yet

Report findings and recommend the smallest safe next step.
```

---

## 7. If Investigation Confirms Staging Is Missing Slice 1A

If Codex confirms `db6ff5f` is not on `staging`, the likely next step is a controlled `dev → staging` promotion for Slice 1A.

Use this prompt:

```text
Prepare Slice 1A staging promotion plan only.

Do not merge yet.

Review current dev commit `db6ff5f` and confirm:
- files changed
- no schema/migration changes
- no database commands required
- type-check result
- verify limitation
- manual tests completed or still required

Then propose the exact `dev → staging` promotion steps.

Do not:
- merge yet
- change code
- change schema
- create migrations
- run db:push
- run seed/reset commands
```

Only after reviewing the plan should Codex be authorised to merge `dev → staging`.

---

## 8. If Slice 1A Needs Promotion

A later approval prompt may look like this:

```text
Proceed with Slice 1A dev → staging promotion.

Scope:
- Merge the approved Slice 1A commit from `dev` to `staging`.
- No code changes beyond the merge.
- No Prisma schema changes.
- No migrations.
- No db:push.
- No seed/reset commands.

After merge:
- Push `staging`.
- Confirm Render staging deployment status if available.
- Verify `/app/fund` on staging once deployed.
- Report exact commit hash, branch status, checks, and manual test results.
```

---

## 9. Important IsoStack / FUND Conventions Locked In

### IsoStack persona terminology

Use these as platform/persona/access terms:

| Term | Meaning |
|---|---|
| P1 | Platform Admin / Isoblue super-user |
| C1 | Tenant Owner / Client Super Admin |
| C2 | Tenant Admin / Client Admin |
| C3 | Tenant Member / Client User |

### FUND business/domain roles

Keep these separate from P1/C1/C2/C3:

- Producer
- Production Partner
- Organiser
- League
- Club
- Customer
- Parent
- Supporter

Do not model Producer, Organiser, League or Club as replacements for P1/C1/C2/C3.

They are FUND business roles or contextual roles within tenant-scoped data.

### Table CRUD standard

When FUND reaches CRUD UI work:

- row click opens edit modal
- no inline edit/delete action icon columns
- delete belongs in modal footer
- normalise Mantine DataTable row payloads with:

```ts
params?.record ?? params
```

- use existing Mantine/AppShell/navigation patterns

---

## 10. Database / Migration Guardrails

Do not use:

```bash
db:push
```

Do not run destructive seed/reset commands unless explicitly approved.

For schema work later:

- update `prisma/schema.prisma`
- create a reviewed Prisma migration
- inspect generated SQL
- use deploy-safe migration process

Remember:

> PostgreSQL schemas separate modules.  
> `organizationId` separates tenant data.

FUND should use a dedicated `fund` schema where consistent with current IsoStack conventions, but every tenant-owned record still needs explicit tenant scoping.

---

## 11. Suggested Next Step After Staging Issue Is Resolved

Do not jump to full Phase 1.

After Slice 1A is confirmed on staging, move to **Slice 1B planning**, not implementation.

Likely Slice 1B:

```text
Database foundation planning only
```

This should decide:

1. exact Prisma models
2. `fund` schema usage
3. tenant scoping fields
4. Project Number strategy
5. Project Type strategy
6. Store placeholder depth
7. image/file handling depth
8. migration plan
9. seed/demo data strategy
10. acceptance criteria

No migration should be created until schema is reviewed.

---

## 12. Open Questions Carried Forward

From Slice 1 planning:

1. Should `FundProjectType` be static seeded values in Slice 1, or configurable by organisation?
2. Should `Project.projectNumber` be globally unique per tenant or scoped by Event?
3. Is Store a placeholder shell or a first-class launch surface in Slice 1B/1C?
4. Do we need product image upload in Slice 1, or is URL-only enough?
5. Should FUND support module-specific business roles beyond `OWNER` / `ADMIN` / `MEMBER` in early phase?

Suggested initial answers:

| Question | Suggested answer |
|---|---|
| ProjectType | Start with seeded/default reference values, model to become configurable later |
| Project Number | Unique per tenant initially, with optional Event prefix later |
| Store | Placeholder shell only at first |
| Product images | URL/string placeholder first; upload pipeline later |
| Extra roles | No; use OWNER/ADMIN/MEMBER first |

---

## 13. Recommended Restart Sequence

When resuming FUND work:

1. Read this handoff.
2. Check `isostack-bedrock` branch status.
3. Check whether `db6ff5f` is on staging.
4. Investigate staging `/app/fund` 404.
5. If needed, promote Slice 1A to staging.
6. Verify `/app/fund` on staging.
7. Update FUND status docs.
8. Only then start Slice 1B planning.

---

## 14. Short Human Summary

We cleaned up the docs enough to make Codex safe.

We created and committed FUND Slice 1A on `dev`.

FUND now exists as a module shell in code, but staging returned 404 for `/app/fund`, probably because the Slice 1A code had not yet been promoted/deployed to staging.

Do not start schema or CRUD work until Slice 1A is confirmed on staging.
