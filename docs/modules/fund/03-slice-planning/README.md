# FUND Slice Planning

This folder contains current and future operational slice plans.

Slice planning documents define:

- exact scope;
- implementation boundaries;
- files likely to change;
- checks to run;
- out-of-scope work;
- recommended prompts.

Historical slice plans may remain in `Planning/` until they are next touched. New active slice plans should go here.

Most recently accepted parent planning lifecycle:

`2026-07-15-fund-phase-1-slice-1r-f-project-offer-artwork-readiness-reconciliation-planning.md`

Most recently completed implementation lifecycle:

`2026-07-15-fund-phase-1-slice-1r-e-c-c2-project-store-control-surface-implementation-planning.md`

Current integrated critical-path action:

```text
Create and review only `1R-F-A - Real AMOW Template, Pricing And Deployed Renderer Proof`
planning. Do not implement the proof, production schema or artwork/template behaviour and
do not begin `1R-F-B` through `1R-F-I`, `1R-G` or another slice.
```

Commerce A1-A7 and the retained FUND C1-C6/1R-D/R3 foundations are implemented/reviewed.
The application bundle through E-A/E-B/E-C is promoted through dev/staging at `e3f44b4b`.
Exact dev/staging automated gates passed and online staging is healthy with its database
connected and RLS enabled on 11/11 expected tables. Production remains unchanged. E-A was
validated against the complete 141-migration disposable baseline with zero residue; the
Render staging build contract runs committed migrations through `migrate deploy`, but no
direct staging migration inventory was queried locally. E-B and E-C add no migration. E-C
authenticated human UI stages are scheduled in its R1 record. The non-executable `1R-F` parent is
reviewed/accepted and `1R-F-A` proof planning
is the single next candidate.

This current status supersedes older per-slice deployment wording retained below for
historical context.

Completed C6 plan:

`2026-07-14-fund-phase-1-slice-1r-c6-fund-commerce-context-schema-implementation-planning.md`

Completed 1R-D plan:

`2026-07-14-fund-phase-1-slice-1r-d-store-readiness-c1-configuration-api-services-implementation-planning.md`

Accepted non-executable 1R-E parent plan:

`2026-07-15-fund-phase-1-slice-1r-e-c1-store-oversight-c2-project-store-control-alignment-planning.md`

Completed E-A implementation plan:

`2026-07-15-fund-phase-1-slice-1r-e-a-store-authority-exceptional-intervention-lifecycle-service-alignment-implementation-planning.md`

Completed E-B implementation plan:

`2026-07-15-fund-phase-1-slice-1r-e-b-c1-store-portfolio-oversight-exceptional-intervention-surface-implementation-planning.md`

Completed E-C implementation plan:

`2026-07-15-fund-phase-1-slice-1r-e-c-c2-project-store-control-surface-implementation-planning.md`

`1P-G-R3-A` is implemented and reviewed at application `4bb7dd9`, included on `origin/dev`,
and documented at `65fc243`. `1P-G-R3-B` is implemented, reviewed and committed at application
`04da074` against the retained 134-migration disposable database. `1P-G-R3-C` is implemented
and reviewed in the current worktrees and invokes R3-B only through aligned confirmation
and protected C1 review. It adds no migration, is committed/promoted to application
`origin/dev` (now advanced to `3206199`), remains undeployed to staging/main and shared databases, and
activates no real form.
`1P-G-R3-D` is implemented/reviewed against the complete 135-migration disposable baseline.
It requires structured Client addresses, Client ownership, typed Project type, an exact
organiser member and atomic Project delivery. Application commit `e1c2d9f` is included on
`origin/dev` at `3206199`, documentation commit `9d140fa` is included on IsoDocs
`origin/main`, and shared databases remain undeployed.

`1P-G-R3` uses the implemented `1P-G` intake workflow as its starting point, but the current
Client/organiser/Project/delivery contract takes precedence over preserving the earlier
form shape. Its accepted implementation may rework the existing form and approval surfaces
within the bounded plan; it must not create a parallel intake framework.

Completed R3-A plan:

`2026-07-14-fund-phase-1-slice-1p-g-r3-a-project-intake-automation-schema-form-policy-foundation-implementation-planning.md`

Completed R3-B plan:

`2026-07-14-fund-phase-1-slice-1p-g-r3-b-project-intake-automated-provisioning-and-protection-services-implementation-planning.md`

Completed R3-C plan:

`2026-07-14-fund-phase-1-slice-1p-g-r3-c-project-intake-form-confirmation-exception-review-alignment-implementation-planning.md`

Completed R3-D plan:

`2026-07-14-fund-phase-1-slice-1p-g-r3-d-project-creation-contract-alignment-implementation-planning.md`

Accepted parent:

`2026-07-14-fund-phase-1-slice-1p-g-r3-project-intake-automated-provisioning-alignment-planning.md`
