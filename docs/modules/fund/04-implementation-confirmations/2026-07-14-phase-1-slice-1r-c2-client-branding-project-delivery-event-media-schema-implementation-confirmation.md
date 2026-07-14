# FUND Phase 1 Slice 1R-C2 - Client Branding/Project Delivery/Event Media Schema Implementation Confirmation

Date: 2026-07-14

Status: Implemented and validated on disposable PostgreSQL / shared deployment not performed

Planning record:

`docs/modules/fund/03-slice-planning/2026-07-14-fund-phase-1-slice-1r-c2-client-branding-project-delivery-event-media-schema-implementation-planning.md`

Review/test record:

`docs/modules/fund/05-review-and-test/2026-07-14-phase-1-slice-1r-c2-r1-client-branding-project-delivery-event-media-schema-review-and-test.md`

## 1. Implemented Boundary

Implemented only the accepted schema foundation for:

- one optional Client-branding record per C2 Client organisation;
- one optional live delivery profile per Project;
- typed Event Store-banner media associations.

No Project Intake alignment, Client-member/User creation, Store, Commerce Order, payment,
upload, production asset, API, service or UI behaviour was added.

## 2. Application-Repository Files

```text
prisma/schema.prisma
prisma/migrations/20260714100000_fund_1r_c2_client_branding_delivery_event_media/migration.sql
scripts/verify-fund-1r-c2-schema.ts
scripts/verify-fund-1r-c2-pre-migration.sql
scripts/verify-fund-1r-c2-database.sql
```

The existing local Commerce A1 and FUND 1R-C1 files were preserved and were not absorbed
into this slice.

## 3. Schema Delivered

Added one FUND enum:

```text
FundEventMediaRole
  STORE_BANNER
```

Added three FUND models/tables:

```text
FundClientBranding          -> fund.fund_client_branding
FundProjectDeliveryProfile -> fund.fund_project_delivery_profiles
FundEventMedia              -> fund.fund_event_media
```

The migration includes:

- same-tenant composite Client, Project and Event owner relations;
- direct C1 tenant relations with tenant-teardown cascades;
- restrictive Client-logo and Event-media `MediaFile` references;
- one branding record per Client and one delivery profile per Project;
- one active `STORE_BANNER` per Event through partial uniqueness;
- unique Event/media associations and non-negative Event-media ordering;
- nonblank recipient, optional attention, address, locality and postal-code checks;
- two-uppercase-letter country-code storage/check;
- no speculative postal/address-search index.

`recipientName` is the effective organisation/body named on the delivery.
`attentionName` is the optional named delivery contact. The schema does not restrict the
C2 Client organisation to a school or club.

## 4. Data Preservation And Backfill

The representative existing-data migration proved that migration did not change:

- Client name, primary contact or metadata;
- Event name, description or metadata;
- Project name, organiser contact snapshots or metadata;
- Organization, Client, Event, Project or MediaFile row counts.

No branding, delivery-profile or Event-media row was inferred. Historic Project Intake
JSON and legacy organiser fields were not parsed or copied.

## 5. Validation Completed

Passed:

- Prisma format, multi-schema validation and client generation;
- 1R-C2 generated-client/schema/migration contract verification;
- Commerce A1 and FUND 1R-C1 static regression verification;
- targeted verifier ESLint;
- TypeScript type-check;
- repository critical-file verification;
- `git diff --check`;
- representative 129-to-130 migration with existing Client/Event/Project/MediaFile rows;
- complete fresh application of all 130 migrations;
- ownership, uniqueness, default, nonblank, country-code, ordering and deletion tests;
- final migration and zero-residue inventory.

Final disposable-database inventory:

```text
applied migrations: 130
failed migrations: 0
1R-C2 tables: 3
1R-C2 enums: 1
residual 1R-C2 test rows: 0
```

## 6. Database Safety

Database validation used only the retained disposable Neon database configured locally by
`TEST_DATABASE_URL`. Before connection, redacted database-identity fingerprints proved it
distinct from `DATABASE_URL`.

The configured test URL was pooled. Migration/reset operations derived the matching direct
Neon hostname in process memory without printing or writing the connection string. No
shared development, staging or production database was contacted or modified.

## 7. Known MediaFile Tenant Gate Preserved

Shared `MediaFile` still lacks a composite `(organizationId, id)` key. The database rejects
unknown files and restricts deletion while referenced, but it cannot enforce that a valid
MediaFile belongs to the same tenant as Client branding or Event media.

The database smoke deliberately reproduced this limitation with an inactive cross-tenant
Event-media association. No media write path was added. Later accepted write services must
query MediaFile by both `id` and actor `organizationId` before create/update.

## 8. Project Intake Alignment Gate

The accepted first-Project contract remains a separate application-workflow dependency:

- typed structured C2 Client organisation/delivery-address capture;
- primary Client organiser/member/User provisioning;
- atomic Client, organiser, Project and initial delivery-profile creation;
- moderation, tenant scope and idempotency preservation.

This implementation supplies the delivery-profile table only. It does not claim that the
current Project Intake approval flow now satisfies that contract.

## 9. Handoff

`1R-C2` is complete through implementation. Its separate review/test record passes. No
Project Intake alignment, `1R-C3`, `COMMERCE-A2` or other slice is authorised by this
confirmation.
