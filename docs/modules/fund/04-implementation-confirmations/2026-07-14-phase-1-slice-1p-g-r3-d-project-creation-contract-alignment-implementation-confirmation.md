# FUND Phase 1 Slice 1P-G-R3-D - Project Creation Contract Alignment Implementation Confirmation

Date: 2026-07-14

Status: Implemented / bounded lifecycle complete and published on application `origin/dev`

Planning source:

`docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1p-g-r3-d-project-creation-contract-alignment-implementation-planning.md`

## 1. Implemented Outcome

R3-D replaced the older C1/K2 Project-row-only writers with the current aggregate contract.
Every new direct FUND Project is now Client-owned, has a typed Project type, an exact
login-capable Client-member organiser, required dates and an initial Project-owned delivery
profile created transactionally from structured Client/member defaults.

## 2. Schema And Migration

Added migration:

`prisma/migrations/20260714234500_fund_1p_g_r3_d_project_creation_contract/migration.sql`

The 135th migration adds:

- `FundProjectType` with the four bounded current values;
- required structured primary-address fields on `FundClient`;
- required `FundProject.clientId`, `projectType`, `organiserMemberId`, organiser snapshots,
  opening date and closing date;
- the exact `(organizationId, organiserMemberId, clientId)` relation to
  `FundClientMember`;
- nonblank address/organiser checks, uppercase country-code check, date-order check and
  organiser index.

The migration first refuses a non-empty `fund_clients` or `fund_projects` baseline. It does
not delete or invent FUND data. This follows the explicit confirmation that FUND has no
live operational data while protecting any unexpected rows from silent destruction. No
LMSPro object is changed.

## 3. Application Alignment

Implemented:

- C1 Client create/edit validation, services and UI for the structured primary address;
- Intake new-Client provisioning of that structured address;
- typed Intake Project creation and exact organiser-member ownership;
- shared C1/C2 direct Project creation through one serializable aggregate transaction;
- active Client, member, linked User and `PROJECT_MANAGER`/`ADMIN` authority checks;
- server-generated Project identifiers with bounded unique retry;
- Event/standalone date authority and duplicate detection;
- atomic delivery-profile and audit creation;
- transaction advisory locking, evidence comparison and bounded `P2034` retry for exact
  C2 idempotency under concurrency;
- typed Project-type reads/writes in C1, C2 and Product eligibility;
- C1 Project creation UI requiring Client, eligible organiser, type and both dates;
- fixed Client ownership after creation;
- explicit retirement of the obsolete clientless legacy Intake approval writer in favour
  of the aligned reviewed provisioning path.

## 4. Scope Preserved

R3-D adds no Store, public Store route, Commerce Order/line, checkout, payment, Stripe,
upload, production workflow, commission calculation, invitation email or LMSPro change.
It activates no Intake form and deploys no shared database.

The Project delivery profile is guaranteed at creation. A general C1/C2 delivery editor
remains a later bounded application surface; R3-D does not expand into Store readiness.

## 5. Implementation Files

Primary files include:

- `prisma/schema.prisma`;
- the bounded R3-D migration;
- `src/modules/fund/services/projects.service.ts`;
- C2 dashboard, Client, Product-eligibility and Intake services;
- Client/Project validation and C1/C2 UI surfaces;
- `scripts/run-fund-1p-g-r3-d-integration-tests.ts`;
- `scripts/verify-fund-1p-g-r3-d-contract.ts`.

## 6. Deployment State

Implementation commit `e1c2d9f` is included on application `origin/dev` at `3206199`.
Documentation commit `9d140fa` is included on IsoDocs `origin/main`. Migration 135 has not
been applied to shared development, staging or production databases; it was applied only
to the retained disposable database identified by `TEST_DATABASE_URL`.
