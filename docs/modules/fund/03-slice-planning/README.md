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

Most recently completed planning/implementation lifecycle:

`2026-07-14-fund-phase-1-slice-1p-g-r3-d-project-creation-contract-alignment-implementation-planning.md`

Current integrated critical-path action returns to FUND:

```text
1R-C6 - FUND Commerce Context Foundation
```

Commerce A2 is implemented/reviewed at local application `3206199` and supplies the generic
Order/line contract required by C6. Store `1R-D` remains the queued FUND service slice after
the typed C6 schema handoff; it is not discarded or authorised by this queue change.

`1P-G-R3-A` is implemented, reviewed and committed locally at application `4bb7dd9` and
documentation `65fc243`. `1P-G-R3-B` is implemented, reviewed and committed at application
`04da074` against the retained 134-migration disposable database. `1P-G-R3-C` is implemented
and reviewed in the current worktrees and invokes R3-B only through aligned confirmation
and protected C1 review. It adds no migration, is committed/promoted to application
`origin/dev` at `234f115`, remains undeployed to staging/main and shared databases, and
activates no real form.
`1P-G-R3-D` is implemented/reviewed against the complete 135-migration disposable baseline.
It requires structured Client addresses, Client ownership, typed Project type, an exact
organiser member and atomic Project delivery. It is committed locally at application
`e1c2d9f` and documentation `9d140fa`, unpushed and undeployed.

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
