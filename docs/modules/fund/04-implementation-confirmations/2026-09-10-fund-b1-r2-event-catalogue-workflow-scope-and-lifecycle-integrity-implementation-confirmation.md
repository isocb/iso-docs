# FUND B1-R2 — Event Catalogue Workflow Scope And Lifecycle Integrity Implementation Confirmation

Date: 2026-09-10

Status: **Implemented locally at application `29104b55`; DevData migration and connected proof PASS; human acceptance pending.**
Control depth: **High**.

Authority: [CR-Fix](../01-cr-inputs/CR-Fix-2026-09-10-fund-event-catalogue-workflow-scope-and-lifecycle-integrity.md)
-> [triage](../02-triage/2026-09-10-fund-b1-r2-event-catalogue-workflow-scope-and-lifecycle-integrity-triage.md)
-> [plan](../03-slice-planning/2026-09-10-fund-b1-r2-event-catalogue-workflow-scope-and-lifecycle-integrity-planning.md).

## Implemented Behaviour

- `FundCatalogue.supportedProjectTypes` is a required four-value workflow multiselect, independent
  of Event/standalone channel availability. Existing and newly created Catalogues default to all
  four workflows; C1 can narrow the set.
- Event and standalone eligibility require both the correct Catalogue channel and the effective
  Event/Project workflow. Event assignment rejects an incompatible Catalogue on the server.
- Event detail has a Products tab which selects compatible Event Catalogues and displays their
  contributed Products. It uses the same `FundEventCatalogue` records as Product/Catalogue
  Availability and does not edit Catalogue definition or Product membership.
- Catalogue Product management displays Product status separately from membership status. Draft
  Products remain available for Catalogue preparation and are clearly described as unavailable
  to Projects until Product activation.
- Event lifecycle is now `DRAFT -> ACTIVE -> CLOSED -> ARCHIVED`, with the existing explicit
  `ARCHIVED -> DRAFT` restore. Draft/active archive is refused. Active Event close is refused
  while any linked Project is active.
- One transaction-scoped Event lifecycle advisory lock serialises Event close with Project
  creation, Intake provisioning, linkage changes and activation. Project activation rechecks
  that a linked Event is active.
- Catalogue workflow edits take the B1-R1 exclusive availability lock; authoritative eligibility,
  Store refresh, offer finalisation and checkout continue to re-evaluate source availability.

## Schema And Migration

Migration `20260910120000_fund_b1_r2_catalogue_workflow_scope` adds the non-null enum array,
all-four database default and a validated non-empty constraint. The migration changes no Product,
membership, Event assignment, Project, offer or Order row.

Guarded DevData preflight proved target fingerprint `257f63f2e2c2` matched local DevData and
differed from staging/production. Before migration it held 155 applied migrations, two Catalogues,
four active Events, three active Projects, no Individual offers and no FUND Order contexts.
Migration 156 applied successfully. Readback proved the ledger row, enum array/default,
non-empty constraint and both Catalogue rows. A post-proof count returned the same two Catalogues,
four active Events, three active Projects, zero offers and zero Order contexts.

No staging/live database migration, application deployment or branch promotion occurred.

## Validation Evidence

| Check | Result |
| --- | --- |
| Prisma format/validation/client generation | PASS |
| TypeScript | PASS |
| FUND unit tests | PASS — 8 files, 30 tests |
| Focused ESLint | PASS with zero source errors; two proof scripts are excluded by repository lint configuration |
| Production build | PASS — all 131 static pages generated |
| Critical-file verification | PASS, including intentional Prisma schema change |
| DevData guarded migration/readback | PASS |
| Connected disposable service/concurrency proof | PASS |
| Connected cleanup/readback | PASS — original bounded counts restored |
| Whitespace | PASS |
| Credential/environment scan | PASS — no environment file, URL, credential assignment, token or private key included |

The production build emitted the established local warning that Upstash HTTPS configuration is
absent; it did not fail the build and no runtime credential/configuration change was made.

## Connected Proof

The disposable DevData proof used same-tenant synthetic Events, Catalogues and Projects, then
removed them and their audit records. It proved:

- workflow-compatible standalone Catalogue inclusion and incompatible exclusion;
- incompatible Event Catalogue assignment refusal and compatible assignment visibility;
- DRAFT and ACTIVE Event archive refusal;
- active-linked-Project Event close refusal;
- successful Event close followed by archive after Project resolution;
- concurrent Event close and Project activation cannot commit a closed Event with an active
  linked Project.

## Stopping Point

Application `29104b55` is the local B1-R2 candidate. Human smoke is the next gate using the
[review/test schedule](../05-review-and-test/2026-09-10-fund-b1-r2-event-catalogue-workflow-scope-and-lifecycle-integrity-review-and-test.md).
Do not promote or apply migration 156 outside the verified local DevData target on this evidence.
