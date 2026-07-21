# FUND Phase 1 Slice 1R-E-C - C2 Project Store Control Surface Implementation Confirmation

Date: 2026-07-15
Status: Implemented and promoted through application dev/staging at `e3f44b4b`; automated review passed; human acceptance blocked pending E-D
Application baseline: committed E-A baseline `daafc349`; E-B/E-C application commit `e3f44b4b`
Migration baseline: unchanged complete 141-migration history

Roadmap renumbering notice: this historical record's `1R-F` public Store reference now
means `1R-G`; current `1R-F` is Project Offer And Artwork Readiness.

## Outcome

The accepted `1R-E-C` application boundary is implemented locally.

The existing C2 Client Project route now has a governed Store tab. It consumes E-A server
authority for effective state, blockers, readiness and normal Store actions. It adds no Prisma
schema or migration, public Store/checkout route, real Stripe action, artwork/template workflow,
Order operation, production, fulfilment or commission calculation.

## Application Changes

Added:

- `ClientProjectStorePanel.tsx` for the C2 Project Store surface;
- `client-project-store.ts` and its pure helper test;
- the E-C static authority/privacy verifier;
- the disposable PostgreSQL E-C integration suite; and
- an exact C2 commission-offer acceptance service and router procedure.

Updated:

- the C2 Project detail tabs from the obsolete Product placeholder to `Details | Store | Orders`;
- the C2 Store read model to return bounded safe evidence instead of the raw internal Store
  configuration object;
- C2 Store authority evaluation so `VIEWER` receives no actions and `PROJECT_MANAGER`/`ADMIN`
  receives only E-A-authorised actions;
- C2 Store validation/services to derive evaluation time on the server;
- normal C2 prepare/refresh/copy/Product-selection/ordering/visibility/publish/pause/resume
  bindings;
- transactional C2 acceptance of the exact proposed commission assignment, including replacement
  supersession, replay, stale-close refusal and redacted audit;
- the retained 1R-D verifier so it recognises the accepted E-A C1/C2 router split; and
- the retained R3-D integration harness so its fresh replay follows 141 migrations and does not
  flood the control process with inherited migration output.

## Security And Ownership

- tenant, user and current time are server derived;
- exact active Client membership is revalidated inside mutations;
- C2 `VIEWER` is read-only;
- only C2 `PROJECT_MANAGER`/`ADMIN` can mutate;
- cross-Client reads and mutations are refused;
- C1 intervention notes, resolution notes, raw snapshots and full configuration hashes are not
  returned to the C2 UI;
- the browser cannot submit readiness, effective state, price, tax, configuration or evaluation
  authority; and
- C1 exception pause/closure cannot be bypassed by C2.

## Commission Boundary

E-C records only explicit acceptance of an already proposed assignment. It does not configure a
policy, choose a rate, calculate commission, finalize terms or create accounting evidence.

Acceptance locks the Project, revalidates exact tenant/Client/Project/Store/member ownership and
the Project-close snapshot, uses the exact `FundClientMember.id`, supersedes a prior accepted row
only through the accepted replacement chain and writes transactional audit evidence.

## Validation Summary

Passed:

- unchanged 141-migration static inventory;
- E-C helper and static route/authority/privacy checks;
- Prisma multi-schema validation and client generation;
- complete TypeScript check;
- disposable E-C C2 isolation, Store read/write and commission lifecycle suite;
- E-A and E-B disposable regression suites;
- 1R-D and Commerce A7 disposable regressions;
- R3-D contract/static regression and current-baseline fresh replay;
- production Next.js build, including `/app/fund/client/projects/[id]`; and
- zero E-C disposable fixture residue.

The build emitted only the established local warning that Upstash Redis environment values are not
configured as HTTPS URLs. That warning is unrelated to E-C and did not fail the build.

## Deployment State

The original implementation turn performed no commit, push, shared migration or deployment.
The later requested commit records E-B/E-C on local application `dev` at `e3f44b4b`; no
push or deployment was performed. The 141st E-A migration must exist on a target environment
before this UI is promoted there. Human UI testing remains explicitly scheduled in the E-C
review/test record rather than being claimed as complete.

Subsequent controlled promotion on 2026-07-20 aligned application dev/origin-dev and
staging/origin-staging at `e3f44b4b`. Exact staging automated and online health gates
passed. Authenticated C2 interaction testing remains scheduled in the R1 record.

Post-promotion preparation on 2026-07-21 found the schedule non-executable from the real
empty FUND workflow: canonical Project creation creates no Store/default eligible Product
set, and the only current Store-instantiation UI is the optional C2 `Prepare Store` action.
This does not invalidate E-C authority/UI automation, but blocks human acceptance pending
corrective `1R-E-D`.

## Stop Boundary

Implementation stopped after the E-C lifecycle. E-D is now the corrective next review
candidate. `1R-F`, public Store/checkout, artwork/template, production, fulfilment and
commission calculation were not started.
