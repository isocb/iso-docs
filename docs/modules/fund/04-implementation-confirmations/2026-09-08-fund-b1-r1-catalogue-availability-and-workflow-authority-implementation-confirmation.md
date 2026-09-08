# FUND B1-R1 — Catalogue Availability And Workflow Authority Implementation Confirmation

Date: 2026-09-08

Status: **Application implementation committed; connected migration and acceptance pending.**

Control depth: **High**. Authority is the accepted B1-R1 [plan](../03-slice-planning/2026-09-08-fund-b1-r1-catalogue-availability-and-workflow-authority-planning.md), its CR-Fix and triage. Application baseline was `57e1454b530ae19dc586768fd996ff230d84421c`. The isolated candidate is `cd72dd780c6fec5b784a00c03a5ebb38133b71ce` on `work/fund-b1-r1-catalogue-workflow`.

## Implemented Result

- `FundProjectType` now has the four operational values Individual, Group, Logo/Bulk and Standard. `NOT_SURE` remains an Intake answer only and provisioning refuses it until resolved.
- Events have one required workflow. Linked Projects inherit and must match it; Event workflow edits refuse once Projects exist. Standalone draft Projects own their workflow and cannot change it after publication, an Order or a finalised offer.
- The Product Workflow Class table, Product and Project-Product workflow foreign keys/snapshots, Product suitability tables, obsolete routers and UI controls were removed. A fixed exhaustive application registry supplies A1, A2, B and C behavior.
- Product availability is the deduplicated union of active Catalogue sources. Event Projects use assigned in-window Event Catalogues. Standalone Projects use every active standalone-capable Catalogue; the old default-only suppression is removed.
- Product selection defaults the first non-empty range once. Explicit selection/exclusion sets the same marker. Later Catalogue additions remain available but unselected. Last-source loss preserves the selected row, marks it unavailable and blocks Store readiness, offer finalisation and checkout through current eligibility checks.
- Tenant-scoped transaction advisory locks are shared by authoritative selection/finalisation/checkout reads and exclusive for Catalogue assignment/scope/membership/status and Product status changes.
- New Order-line workflow evidence comes from the parent Project workflow registry. Existing immutable Order-line fields and finalised offer evidence remain unchanged.

## Schema And Migration

Migration `20260908120000_fund_b1_r1_catalogue_workflow_authority` replaces the persisted enum, adds Event workflow and the Project selection marker, contracts the obsolete Product authority schema and installs deferred Event/Project consistency guards. It stops before contraction if any Event lacks explicit classification, any Project is `NOT_SURE`, or finalised FUND offer/Order evidence exists. This matches the owner's stated no-operational-FUND-data condition without guessing old classifications.

The migration was reviewed as source and the Prisma schema validates. It was **not applied** to local Neon DevData, staging or live. No reset, seed, deployment, environment edit or server restart occurred.

## Verification Obtained

- `npm run type-check`: PASS.
- `npm run build:skip-types`: PASS; 131 static pages generated. Expected missing local Upstash warnings were emitted without build failure.
- `npx vitest run src/modules/fund`: PASS, 7 files and 26 tests.
- `npx prisma validate` with a non-connecting placeholder URL: PASS.
- `npx tsx scripts/verify-critical-files.ts`: PASS, including its TypeScript check.
- `git diff --check`: PASS.
- Focused FUND ESLint: no implementation errors; repository test files are outside the configured ESLint TypeScript project and existing warnings remain.
- Whole-repository `npm run lint`: FAIL on pre-existing non-FUND lint errors. No B1-R1 error was identified in the focused run.
- Staged filename and credential-pattern scans: no environment file, credential, private key or token match.

## Deliberate Boundary And Open Gates

No Product workflow multiselect, replacement suitability flags, per-Project Catalogue assignment, purchaser journey, provider integration, production/refund workflow or promotion was added. Connected fresh/upgrade migration proof, negative fail-closed data proof, advisory-lock concurrency proof, existing database integration scripts, independent review and the scheduled C1/C2 human smoke remain open. B1 and B1-R1 are not accepted or promoted by this confirmation.
