# FUND B1-R1 — Catalogue Availability And Workflow Authority Planning

Date: 2026-09-08

Status: **Implemented locally at `51618485`; guarded DevData migration PASS; human smoke steps 1–4 PASS; remaining acceptance continues through B1-R2.**
Control depth: **High**. Work type: production-model correction, not an assumption test.

Authority: [CR-Fix](../01-cr-inputs/CR-Fix-2026-09-08-fund-workflow-authority-and-product-suitability-separation.md)
-> [triage](../02-triage/2026-09-08-fund-b1-r1-catalogue-availability-and-workflow-authority-triage.md)
-> [FUND roadmap](../00-roadmap-control/2026-06-25-fund-roadmap-and-slice-control.md).
This remediation is inside B1's open acceptance outcome. The [B1 controlling plan](2026-09-07-fund-1r-f-b1-individual-offer-and-artwork-journey-development-plan.md)
retains the only restart checkpoint. No code, migration, database reset, fixture recreation,
configuration change, server restart or deployment is performed by this plan.

## 1. Outcome And Entry Boundary

C1 creates one Ceramic Mug without choosing Product Workflow Class or configuring Product
Suitability. C1 includes it in Catalogues and assigns those ranges to Events or standalone
availability. C2 selects a subset; the Event or standalone Project determines how those
selected Products are handled. A manufacturing change is expressed through Catalogue choices
only. An old Product classification cannot secretly prevent selection or sale readiness.

Application source baseline: `57e1454b530ae19dc586768fd996ff230d84421c`.
Documentation pre-triage baseline: `c672af5`. Source migration inventory: 154 (a source count,
not a new connected-database assertion). Staging/live application baseline remains `14077382`
in the preceding evidence; verify exact refs and ledgers again before implementation/promotion.
No FUND users or data require remedial conversion; this remains the owner's position until
he says otherwise. Preserve unrelated module data and any synthetic immutable evidence.

## 2. Decisions And Working Proposals

| Item | Position |
| --- | --- |
| Catalogue membership/availability controls compatibility | Confirmed by Chris; no Product suitability veto |
| Product created once, no mandatory Product Workflow Class | Confirmed |
| Event authority for linked Projects; Project authority for standalone | Confirmed |
| C2 chooses the offered subset; readiness/release remains required | Confirmed |
| Four explicit workflows, including Standard | Confirmed by Chris; one per Event/Project, no mixed workflow; Standard sells an unmodified Product |
| Standalone Catalogue scope | Chris confirms Catalogues are made available to standalone Projects; use existing Catalogue availability controls, no extra per-Project assignment gate |
| Initial default-all once; later additions available but unselected | Planning decision for implementation acceptance; reconciles initial convenience with C2 subset preservation |
| Lost last Catalogue source | Planning decision for implementation acceptance; preserve an explicit unavailable selection and never silently change a locked offer |
| Event workflow edits after Projects exist | Planning decision for implementation acceptance; refuse the edit rather than implicitly reclassify Projects |

The owner has confirmed four explicit workflows and standalone Catalogue availability.
No mixed workflow is required. Source review has also resolved the schema approach: the four
workflow definitions are fixed application behaviour keyed by Event/Project type, not editable
database records. The transition rules below remain reviewable planning decisions for
implementation acceptance; they do not reopen the confirmed Catalogue-led model.

## 3. Workflow Authority And Schema Proposal

### One typed context

Prefer reusing the typed Project context rather than introducing a second independent
workflow selector. The confirmed four-workflow mapping is:

| Project type | Human workflow | Fixed internal code |
| --- | --- | --- |
| ARTWORK_FUNDRAISING | Individual Artwork | A1 |
| GROUP_PERSONALISED_PRODUCTS | Group Artwork | A2 |
| BULK_ORDER_CLUB_FUNDED | Logo/Bulk personalisation | B |
| STANDARD (new enum value) | Standard (unmodified Product) | C |

Make `FundProjectType` the one persisted operational workflow vocabulary: add `STANDARD` and
remove `NOT_SURE`. Add required typed `FundEvent.projectType` using the same enum; do not
treat free-text `eventType` as authority. Every Event and Project therefore has exactly one
of the four workflows. `NOT_SURE` may remain a public Intake response while the request is
unresolved, but C1 must choose one of the four before provisioning; it is not stored as an
Event or Project workflow. A standalone Project owns its type. Do not derive context from a
Product, Catalogue name, browser label or submitted hidden field.

Introduce one server resolver returning effective Project type, workflow code/requirements,
authority source (Event or Project), and source identity. For linked Projects derive from
Event; keep Project type as a consistency mirror for existing consumers, not a second
editable authority. Enforce same-tenant Event linkage and type consistency at service and
database boundaries, covering old/direct write paths. Before writing, lock/re-read the
Event and Project in a declared order; reject stale context rather than silently accepting
browser input. Add a deferred consistency constraint trigger so a committed linked Project
cannot differ from its Event while transactional creation remains possible.

Replace `FundProductWorkflowClass` and its editable/active database rows with one exhaustive,
read-only application registry keyed by `FundProjectType`. The registry supplies the A1/A2/B/C
code, label and fixed requirements such as artwork, group artwork, personalisation data and
production export. It must fail at compile/test time if a Project type has no definition; it
must not query a seed row, accept tenant overrides or expose a workflow-class CRUD/list router.
This removes the missing/inactive reference-data failure that blocked Product setup while
preserving a single vocabulary for downstream displays and readiness rules.

### Remove competing Product authority

Remove `FundProduct.workflowClassId` and its relation/index, required input validation and
Product creation/filter/display dependencies. Retire `FundProductProjectTypeSuitability` and
`FundProductOrganizationTypeSuitability`, their write endpoints and suitability management
surfaces. Remove the now-unreferenced `FundProductWorkflowClass` model/table and router. Keep
unrelated Client type and tenant/role permission logic. Do not leave unused fields mandatory,
return success from obsolete mutation endpoints, or retain hidden filtering in Store refresh
or checkout.

Remove `FundProjectProduct.workflowClassId` and its workflow code/name snapshots. A Product
selection does not have its own workflow: consumers show the effective Project workflow once
at Project level and apply the fixed registry requirements there. Existing FUND Order-line
workflow code/name snapshots remain immutable historical fields, but new Order lines populate
them from `FundOrderContext.projectTypeSnapshot` through the fixed registry, never from Product.
The parent Order context already carries the typed immutable Project workflow. Generic Commerce
identities, amounts and payment statuses remain unchanged.

### Standalone Catalogue scope — confirmed direction

C1 makes Catalogues available to standalone Projects using the existing availability scope
(STANDALONE_ONLY or EVENT_AND_STANDALONE). Resolve the union of all active, unarchived
Catalogues made available that way, with active memberships/Products. C2 selects Products
from that range, not another Catalogue permission list. Event-linked Projects continue to
resolve only their Event's assigned Catalogues within their existing availability windows.

Do not add FundProjectCatalogue, a per-Project source-mode flag or another mandatory Catalogue
assignment step. The old isDefaultStandalone preference and sole-Catalogue fallback currently
suppress other standalone-available ranges; remove that additional source-selection gate and
its misleading UI/API field. Retire the obsolete schema field in the same reviewed correction.
A Catalogue's standalone availability is sufficient; zero available Catalogues returns a
clear empty range. This B1-R1 rule removed Product-level workflow filtering. B1-R2 later added
workflow scope to the Catalogue itself, so the current range is filtered by both standalone
channel availability and the standalone Project workflow without restoring Product suitability.

## 4. Catalogue Delta And C2 Selection Contract

Resolve availability as the deduplicated union of Products supplied through active, in-window
Catalogue assignments and active Catalogue memberships. Active/unarchived Product and source
status rules remain. No Project-type or organisation-type Product Suitability filter remains.
One source withdrawal leaves the Product available if another valid source remains.

Initial convenience and later curation must be explicit. Add nullable
`FundProject.productSelectionInitializedAt`; it is internal state and becomes non-null in the
same transaction as the first default or explicit Product selection:

- At first successful offer initialisation with a non-empty available range, default-select
  that range once and set the marker.
  An empty initial range does not consume this first initialisation.
- If C2 explicitly selects or excludes Products before automatic initialisation, set the marker
  in that mutation so a later refresh cannot overwrite the deliberate subset.
- Subsequent Catalogue additions appear as available choices, not automatically selected.
  Clearing all selections or excluding a Product must not reset initialisation or re-add it.
- Explicit C2 selections, exclusions and ordering survive unrelated refreshes.
- On loss of the last available source, preserve the selected record but show it unavailable,
  exclude it from any saleable projection and block finalisation until C2 resolves the draft
  selection. Returning availability restores eligibility but never reverses a C2 exclusion.
- The marker is internal state, not a new mandatory C1/C2 setup option. Every membership
  mutation/refresh must use the same transactional selection rule.

For finalised B1 offers, do not refresh Product/configuration facts into their frozen rows.
Evaluate current source availability separately. If a confirmed Product loses its final
available source, block future trading of the locked offer with an actionable Catalogue
availability reason; do not silently offer a smaller/different selection. Restoring exactly
that availability can clear the computed blocker; it does not recreate an offer or override
an independent C1 intervention. B1's development-only trading blocker remains in force.

Manufacturing changes do not cancel/refund Orders or alter their snapshots. Existing Orders
require the separately owned operational exception process if fulfilment is affected; this
slice supplies truthful availability/context, not a new production or refund workflow.

Catalogue mutation need not synchronously rewrite every Project. Canonical reads/finalisation/
checkout must revalidate current availability, so safety does not depend on a later manual
refresh or background job. Show affected source/Project counts where existing UI permits;
never expose other tenants' Projects. A cosmetic list cache is not trading authority.

For transaction boundaries, use one transaction-scoped PostgreSQL advisory-lock namespace per
tenant: shared for authoritative availability reads during selection/finalisation/checkout and
exclusive for Catalogue assignment/membership/status/window, Catalogue status/scope, and Product
activation/archive mutations. Acquire this availability lock before Event, Project and Store
row locks in that order. Hold it through source read, validation and commit. This prevents a
last-source withdrawal racing past a successful sale check. Prove timeout/retry behaviour and
retain existing idempotency contracts.

## 5. Creation, Intake And Context Changes

C1 Event form: one workflow choice. C1 Product form: no workflow/suitability classification.
C1 linked Project form: show inherited Event workflow, no conflicting selector. Standalone
Project form: choose its workflow. Labels should explain these relationships in ordinary terms.

Public Event Intake derives workflow from the trusted Event at display, submission and
provisioning. Reject forged/stale type/Event combinations; an Intake form's previous default
or allowed-type policy must not outrank current Event authority. Existing standalone Intake
policy may constrain choices, but must support the agreed vocabulary. Revalidate again at
C1 approval/provisioning, not only when receiving the public form.

C2 Project creation/update and legacy organiser routes must call the same authority resolver.
Do not use impersonation, email snapshots or Client-provided tenant IDs as mutation authority.

Change boundary for implementation acceptance: C1 may change an Event workflow before it has linked Projects;
refuse afterwards with a clear explanation rather than bulk-changing Projects. A standalone
draft may change workflow before finalisation, publication or Orders, then invalidate/rebuild
only unconfirmed readiness/configuration under lock. Changing Event linkage obeys the same
unconfirmed-only boundary and re-evaluates the Catalogue source range. An Intake response of
`NOT_SURE` must be resolved before Project creation. Finalised/Order contexts cannot be
reclassified by these ordinary actions.

## 6. Source Change Inventory

All paths below are relative to isostack-bedrock; inspect exact contents again at implementation.

| Area | Known source | Required change |
| --- | --- | --- |
| Models/migrations | `prisma/schema.prisma`, new committed migration(s) | Four-value Project/Event enum, remove Product/reference gates; standalone scope simplification and Project initialisation state |
| Product CRUD | `components/products/ProductModal.tsx`, `ProductTable.tsx`; `services/products.service.ts`; `lib/validation/products-catalogues.ts` under `src/modules/fund` | Remove mandatory class, suitability configuration/filtering and copied Product workflow |
| Catalogue/availability | `services/catalogues.service.ts`, `availability.service.ts`; Catalogue/Availability components and routers | Retire suitability endpoints/views; preserve Catalogue membership, assignments, source dates and deduplication |
| Eligibility | `services/product-eligibility.service.ts` | Authoritative Catalogue sources only; derive displayed operational context from Project |
| Event/Project | `services/events.service.ts`, `projects.service.ts`, `organiser-projects.service.ts`; corresponding validation/routers/forms | Trusted workflow inheritance, consistency, change boundaries and permissions |
| Intake | `services/project-intake.service.ts`, `project-intake-provisioning.service.ts`, `lib/project-intake-policy.ts`; public/C1 forms | Same vocabulary and trusted Event context at every stage |
| Selection/configuration | `services/store-management.service.ts`, `lib/project-product-snapshot.ts` | Remove per-Product workflow snapshots, initial-once selection, current availability independent of locked evidence |
| B1 | `services/individual-offer.service.ts`, `individual-offer-readiness.ts`, offer contract/tests | Context-based workflow/readiness, frozen evidence and last-source withdrawal refusal |
| Store authority | `services/store-authority.service.ts`, `store-oversight.service.ts`, C1/C2 Store components | Clear context/availability reasons; no Product-class veto or locked-data rewrite |
| Consumer Orders | `services/store-checkout.service.ts`, FUND context validators | Populate line workflow evidence from the parent Project snapshot/registry; preserve transaction/idempotency and generic Commerce ownership |
| Tests | existing B1, E-A/E-C/E-D, 1R-D and A7 suites; eligibility/Intake tests | Replace Product-class fixtures, prove Catalogue changes and no hidden legacy gate |

Schema-wide and repository-wide searches for workflowClass, suitability, snapshot builders
and raw SQL must complement this inventory. Do not assume the visible modal is the full scope.

## 7. Migration, Failure And Environment Plan

Use reviewed Prisma migrations; never edit an applied migration or run reset/seed on staging.
No legacy FUND reclassification programme is needed. Local development fixtures may be
recreated when required, confined to the declared FUND scope; do not delete shared users,
Clients needed elsewhere, generic Commerce or other modules without a separate concrete scope.

Use one coherent schema/application release. Add required typed Event context, add `STANDARD`,
and remove `NOT_SURE` from the persisted Event/Project enum rather than guessing workflow from
old Products. Retire the obsolete Product/reference relations, suitability tables,
`isDefaultStandalone` and Project Product workflow fields in reviewed migration SQL. PostgreSQL
enum replacement and dependent-column handling must be sequenced explicitly and proved on both
fresh and upgrade paths; do not rely on Prisma-generated ordering without inspecting the SQL.

Preflight each target: identify endpoint and current ledger/checksums; inspect bounded counts
for Events, Projects, `NOT_SURE` Projects, Project Products, suitability/reference rows,
Individual offers and FUND Orders; identify immutable evidence; and prove migration on a fresh
full baseline and an upgrade fixture. The expected staging condition is no operational FUND
rows, based on the owner's statement. If an Event lacks a workflow, a Project is `NOT_SURE`, or
immutable FUND evidence exists unexpectedly, stop before contraction and return the counts for
a business decision. Do not infer or backfill an Event workflow from Product classifications.
Source inventory is 154 now; staging may still need B1 as well as the correction. Derive required
migrations from the actual target ledger. No assumption that all environments have the local
DevData schema.

Because the correction removes old columns, do not run old and new FUND application code
against incompatible schemas during rollout. State the maintenance/startup order and backup/
restore point before staging migration, including non-FUND service impact. No-user FUND does
not mean the whole application has no users. Old-build rollback alone is not a safe rollback
after contraction: prefer forward correction; any database restore/reversal requires its
own verified scope and preservation of later writes. This plan executes neither.

Tests must prove no mutation to unrelated module records and preservation of synthetic
finalised-offer/Order snapshots. If unexpected operational FUND evidence contradicts the
owner's position, stop the destructive step and reconcile; do not silently convert it.

## 8. Implementation Packages And Stopping Points

One proposed B1-R1 slice, no independent partial feature releases:

1. Record implementation acceptance of this completed schema, transition and lock contract.
2. Implement schema and context resolution with meaningful tenant/inheritance tests, then
   Catalogue/selection semantics. Keep the candidate isolated from the user's running app.
3. Update all C1/C2/Intake surfaces and B1/Store/Order consumers together; remove obsolete
   inputs, filters and fixtures. Do not publish a half-migrated workflow contract.
4. Prove full candidate, produce 04 implementation confirmation and 05 independent review,
   run the human schedule, then reconcile B1 before controlled promotion.

The human smoke exposed two missing C2 surfaces in addition to the earlier interaction
defects. Project creation presented Event and workflow as independent choices, and Product
selection was obscured inside Store controls. Corrected candidate `2cfc89fa` now makes Event
the workflow authority in the C2 create/edit modal, retains the four-choice workflow control
only for standalone Projects, redirects creation to Project detail, and exposes a dedicated
Products tab for the Catalogue-derived C2 subset. These are implementations of the planned
Event/Project authority and C2-selection contract, not an expansion of the slice. Human retry
remains required.

The next C2 retry established that an active Catalogue can legitimately yield no eligible
Products when its Product is still draft, but the API/UI described that state as if no source
Catalogue existed. It also established that the Project lifecycle action was hidden inside
Store controls and that the current C2 role was unclear. Candidate `51618485` preserves an
empty active Catalogue in eligibility results, gives the correct Product-activation guidance,
shows the current C2 access level, and places Project activation at the Project-page level.
C2 cannot elevate its own role; C1 Client user management remains the authority. These changes
make the already-planned selection and activation sequence testable without changing authority.

A worktree can isolate future code from active local testing; no new checkout is created
for this documentation pass. No persistent branch or separate schema-only lane is needed
merely to sequence these packages.

## 9. Validation And Human Acceptance

| Test | Required result |
| --- | --- |
| One Product, four confirmed workflow contexts | Same Product ID; correct Event/Project-derived workflow in each; no Product classification or workflow reference-row step |
| C1/public Intake/approval/C2 creation | All resolve the same Event authority; stale/forged/cross-tenant context refuses |
| Catalogue sources | Multiple Catalogues deduplicate; removing one source preserves availability; losing the last source withholds it |
| Standalone scope | All Catalogues marked available to standalone resolve; no obsolete default-only suppression or per-Project gate; zero available gives an empty range |
| C2 selection | Initial default-all once; later additions unselected; exclusions/order/empty curated subset survive refresh |
| Manufacturing delta | C1 Catalogue edit is sufficient; draft selection shows actionable unavailability, no second Product suitability action |
| Frozen evidence | Withdrawal blocks future trading without changing locked offer, price, workflow or Order snapshots; no automatic refund/unlock |
| Legacy paths | Old suitability/workflow-class mutations and routes removed; no fallback Product or reference-row authority; raw conflicting Event/Project writes refuse |
| Concurrency | Selection/finalise/context/availability races cannot commit or sell inconsistent evidence; retries remain idempotent |
| Migration | Fresh and upgrade replay, no failed/unknown ledger entries, unrelated data untouched, synthetic immutable evidence preserved |
| Existing behaviour | B1 fixed capacities/download/recovery and A7/Store/Intake authority tests still pass; emulation never grants trading |

Human schedule: C1 creates Mug once; puts it in two Catalogues; assigns them to Events with
different workflows and a standalone context; public Intake creates linked and standalone
Projects; C2 confirms the right offered range and selects a subset. C1 removes one source,
then the last source, and C2 sees the specified results. Restore availability, finalise an
Individual offer as the organiser, repeat withdrawal and verify immutable preview/document
with future sale refusal. Record exact candidate, identities by role, dates, PASS/FAIL and
issues in 05; synthetic checks do not replace these human results.

Do detailed negative proof locally/disposably, staging-specific schema/routing/configuration
proof in staging and only the minimal non-destructive critical path on authorised live.
The current local DevData health's RLS 0/11 result is not a tenant-isolation PASS; independent
role/tenant tests and the appropriate staging gates remain required. No provider/physical
print or production readiness is claimed by this correction.

## 10. Do Not Build

No Product workflow multiselect, replacement hidden suitability flags, per-Product Event
exceptions, duplicate Product catalogue, generic workflow engine, editor, real artwork
infrastructure, public Store/checkout UI, payment/refund provider work, production/dispatch
operations or commission settlement. Do not rebuild those downstream features just because
their context consumers must be corrected. No migration, reset or deployment in this pass.
