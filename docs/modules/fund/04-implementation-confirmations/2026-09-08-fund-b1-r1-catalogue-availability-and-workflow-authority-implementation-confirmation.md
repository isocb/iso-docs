# FUND B1-R1 — Catalogue Availability And Workflow Authority Implementation Confirmation

Date: 2026-09-08

Status: **Application implementation committed; local DevData migration PASS; broader connected proof and acceptance pending.**

Control depth: **High**. Authority is the accepted B1-R1 [plan](../03-slice-planning/2026-09-08-fund-b1-r1-catalogue-availability-and-workflow-authority-planning.md), its CR-Fix and triage. Application baseline was `57e1454b530ae19dc586768fd996ff230d84421c`. The corrected candidate is `2cfc89fa` on `work/fund-b1-r1-catalogue-workflow`, comprising implementation `cd72dd780c6fec5b784a00c03a5ebb38133b71ce` and bounded corrections `e00db199`, `8bda74f4` and `2cfc89fa` found during local human smoke.

## Implemented Result

- `FundProjectType` now has the four operational values Individual, Group, Logo/Bulk and Standard. `NOT_SURE` remains an Intake answer only and provisioning refuses it until resolved.
- Events have one required workflow. Linked Projects inherit and must match it; Event workflow edits refuse once Projects exist. Standalone draft Projects own their workflow and cannot change it after publication, an Order or a finalised offer.
- The Product Workflow Class table, Product and Project-Product workflow foreign keys/snapshots, Product suitability tables, obsolete routers and UI controls were removed. A fixed exhaustive application registry supplies A1, A2, B and C behavior.
- Product availability is the deduplicated union of active Catalogue sources. Event Projects use assigned in-window Event Catalogues. Standalone Projects use every active standalone-capable Catalogue; the old default-only suppression is removed.
- Product selection defaults the first non-empty range once. Explicit selection/exclusion sets the same marker. Later Catalogue additions remain available but unselected. Last-source loss preserves the selected row, marks it unavailable and blocks Store readiness, offer finalisation and checkout through current eligibility checks.
- Tenant-scoped transaction advisory locks are shared by authoritative selection/finalisation/checkout reads and exclusive for Catalogue assignment/scope/membership/status and Product status changes.
- New Order-line workflow evidence comes from the parent Project workflow registry. Existing immutable Order-line fields and finalised offer evidence remain unchanged.
- C2 Project creation now treats Event selection as workflow authority: the selected Event's
  workflow is shown read-only, while a standalone Project retains the required four-choice
  workflow field. Creation redirects to Project detail, whose default dedicated Products tab
  exposes the Catalogue-derived eligible range and lets an authorised C2 user maintain the
  Project subset. Store controls no longer obscure that selection task.

## Schema And Migration

Migration `20260908120000_fund_b1_r1_catalogue_workflow_authority` replaces the persisted enum, adds Event workflow and the Project selection marker, contracts the obsolete Product authority schema and installs deferred Event/Project consistency guards. It stops before contraction if any Event lacks explicit classification, any Project is `NOT_SURE`, or finalised FUND offer/Order evidence exists. This matches the owner's stated no-operational-FUND-data condition without guessing old classifications.

The migration was reviewed as source and the Prisma schema validates. On 2026-09-08 a
fail-closed preflight proved that `.env` matched the local Neon DevData identity and differed
from staging and production. DevData was at 154 migrations and contained two Events, one
Project and its small supporting FUND test setup, with zero Products, Catalogues, individual
offers or Order contexts. Under Chris's recorded authority to recreate development FUND data,
only FUND-schema rows were cleared and migration 155 was deployed. The four workflow enum
values, required columns, removed legacy tables and successful ledger row were read back.
Exact counts across every application table outside the FUND schema were unchanged; the
Prisma migration ledger was excluded from that comparison because migration 155 adds its
expected row. Staging and live were not changed.

## Verification Obtained

- `npm run type-check`: PASS.
- `npm run build`: PASS; full type check, optimized production build and all 131 static pages generated. Expected missing local Upstash warnings were emitted without build failure.
- `npx vitest run src/modules/fund`: PASS, 7 files and 26 tests.
- `npx prisma validate` with a non-connecting placeholder URL: PASS.
- `npx tsx scripts/verify-critical-files.ts`: PASS, including its TypeScript check.
- `git diff --check`: PASS.
- Focused FUND ESLint: no implementation errors; repository test files are outside the configured ESLint TypeScript project and existing warnings remain.
- Whole-repository `npm run lint`: FAIL on pre-existing non-FUND lint errors. No B1-R1 error was identified in the focused run.
- Staged filename and credential-pattern scans: no environment file, credential, private key or token match.
- Guarded Neon DevData 154-to-155 migration: PASS at redacted target fingerprint
  `5a235762acc4`; all FUND rows are empty for test-data recreation and unrelated-table count
  digest `6635290daabf` was unchanged.
- Local candidate runtime: PASS; `/api/health` returned HTTP 200 and the authenticated
  `/fund/products` route returned the expected HTTP 307 redirect on localhost:3000.
- Initial human Catalogue assignment at `cd72dd78`: FAIL because the checkbox state updater
  read `event.currentTarget.checked` after the React event target became unavailable.
  `e00db199` captures the boolean before entering the updater. Full TypeScript, focused
  component ESLint and commit-time critical-file checks pass; human retry is pending.
- Intake form creation at `e00db199`: FAIL because Mantine allowed the already selected
  required scope to be deselected to `null`, which the server correctly refused. `8bda74f4`
  makes required scope, provisioning mode and fixed Project type selections non-deselectable
  in create/edit forms and adds client validation. Full TypeScript, focused ESLint and
  commit-time checks pass; human retry is pending.
- C2 Project testing at `8bda74f4`: BLOCKED because Project creation presented Event and
  workflow as independent inputs, while Product selection had no discoverable Project-detail
  surface. `2cfc89fa` derives and locks the workflow when an Event is selected, keeps the
  four-choice selector for standalone Projects, adds the dedicated C2 Products tab and
  redirects successful creation there. Full build, TypeScript, focused ESLint, all 26 FUND
  tests, whitespace and credential-pattern checks pass. Local health is HTTP 200 and the C2
  Projects route reaches its expected authentication redirect; human retry is pending.

## Deliberate Boundary And Open Gates

No Product workflow multiselect, replacement suitability flags, per-Project Catalogue assignment, purchaser journey, provider integration, production/refund workflow or promotion was added. Fresh-database migration proof, negative fail-closed data proof, advisory-lock concurrency proof, existing database integration scripts, independent review and the scheduled C1/C2 human smoke remain open. B1 and B1-R1 are not accepted or promoted by this confirmation.
