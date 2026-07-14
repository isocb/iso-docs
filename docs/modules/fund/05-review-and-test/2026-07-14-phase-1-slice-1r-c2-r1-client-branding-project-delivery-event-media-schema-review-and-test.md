# FUND Phase 1 Slice 1R-C2-R1 - Client Branding/Project Delivery/Event Media Schema Review And Test

Date: 2026-07-14

Status: Passed / disposable PostgreSQL migration and constraint smoke complete

Implementation confirmation:

`docs/modules/fund/04-implementation-confirmations/2026-07-14-phase-1-slice-1r-c2-client-branding-project-delivery-event-media-schema-implementation-confirmation.md`

## 1. Review Scope

Reviewed the bounded 1R-C2 implementation for:

- exact accepted enum/model/table boundary;
- C1 tenant versus unrestricted C2 Client-organisation terminology;
- Client, Project and Event same-tenant ownership;
- live Project delivery-profile shape and constraints;
- Event Store-banner uniqueness and ordering;
- restrictive MediaFile references and the known tenant limitation;
- fresh and representative existing-data migration;
- absence of Project Intake workflow, Store, Commerce, upload and production changes.

## 2. Static And Repository Checks

Passed:

```text
npx prisma format
npx prisma validate
npx prisma generate
npx tsx scripts/verify-fund-1r-c2-schema.ts
npx tsx scripts/verify-fund-1r-c1-schema.ts
npx tsx scripts/verify-commerce-a1-schema.ts
npx eslint --no-ignore scripts/verify-fund-1r-c2-schema.ts
npm run type-check
npm run verify
git diff --check
```

The verifier confirmed exactly one enum and three new tables, accepted checks and partial
indexes, restrictive MediaFile deletion, no speculative address-search index, and no
Project Intake, Store, Commerce, upload or production mutation.

The sandbox blocked `tsx` IPC during ordinary command execution. The exact static and
repository verifier commands were rerun successfully with the already-approved `npx tsx`
execution allowance. This was an execution-environment restriction, not a code failure.

## 3. Database Target Safety

Before any connection, redacted identity fingerprints proved `TEST_DATABASE_URL` distinct
from `DATABASE_URL`. Only the retained disposable Neon test database was used.

The test URL was pooled; reset and migration operations derived its direct endpoint in
memory. Credentials and connection strings were neither printed nor committed.

## 4. Representative Existing-Data Migration

Starting state:

- disposable database at 129 successful migrations through FUND 1R-C1;
- `20260714100000_fund_1r_c2_client_branding_delivery_event_media` was the only pending
  migration;
- representative Organizations, Clients, Events, Projects and MediaFiles existed before
  migration.

Result:

- only the 1R-C2 migration applied;
- all representative scalar and JSON values remained exact;
- all three new tables began empty;
- no logo, delivery address, organiser or Event banner was inferred;
- the database finished at 130 successful migrations;
- fixture and smoke-test cleanup left zero 1R-C2 rows.

## 5. Constraint, Default And Relation Smoke

Passed database evidence for:

- valid Client branding, Project delivery profile and Event media creation;
- default active Client branding;
- one branding row per Client;
- cross-tenant Client-owner rejection;
- valid/unknown Client-logo MediaFile handling;
- one delivery profile per Project;
- cross-tenant Project-owner rejection;
- nonblank recipient, attention-if-present, address line 1, locality and postal code;
- uppercase two-letter country code;
- default `STORE_BANNER`, sort order zero and active Event media;
- unique Event/media association;
- one active Store banner per Event while inactive associations remain allowed;
- non-negative Event-media ordering;
- cross-tenant Event-owner rejection;
- valid/unknown Event MediaFile handling;
- restrictive deletion of a referenced MediaFile;
- Project-to-delivery, Client-to-branding and Event-to-media cascades;
- zero test-row residue.

## 6. MediaFile Tenant Limitation Evidence

The database accepted an inactive Event-media association whose valid `MediaFile.id`
belonged to another tenant. This is the planned and documented limitation caused by the
absence of a shared composite MediaFile tenant/id key.

The review therefore does not claim database-enforced MediaFile tenant isolation. No write
service/API exists in 1R-C2, and the later service validation gate remains mandatory.

## 7. Fresh Migration Replay

The disposable database was reset and all 130 migrations were applied from empty through:

```text
20260713120000_commerce_a1_schema_seller_profile_enums
20260713150000_fund_1r_c1_product_configuration_foundation
20260714100000_fund_1r_c2_client_branding_delivery_event_media
```

Migration status reported the database up to date. The complete 1R-C2 fixture and
constraint suite then passed again with zero residue.

Final inventory:

```text
applied migrations: 130
failed migrations: 0
1R-C2 tables: 3
1R-C2 enums: 1
residual 1R-C2 test rows: 0
```

## 8. Boundary Verdict

Passed. `1R-C2` implements only the accepted FUND configuration schema foundation.

Not added:

- Project Intake alignment or Client-member/User provisioning;
- Project Store or Store Product;
- checkout, Commerce Orders or payments;
- upload or MediaFile mutation services;
- production assets or commission;
- routers, services, pages or components;
- `1R-C3` or `COMMERCE-A2` work.

No shared development, staging or production deployment is claimed. The retained test
database remains disposable test infrastructure at the complete 130-migration state.
