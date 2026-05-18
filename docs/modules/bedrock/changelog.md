# Bedrock Module — Changelog & Decision Log

---

## May 2026 — Floot-Bedrock Analysis & Implementation Strategy

**Status:** Planning (implementation deferred — LMSPro / SeasonPro takes priority)

### Background

A working version of the Bedrock concept was built as a standalone app called **Floot-Bedrock** (React + Remix + Kysely + custom component library). In May 2026, the codebase was reviewed to determine how much could be reused in the native IsoStack module implementation.

### What Floot-Bedrock Contains

**Engine layer (production-ready, framework-agnostic):**

| File | What It Does |
|------|--------------|
| `generateSheetSchema.tsx` | Auto-detects column types (text/number/currency/boolean/date) from sheet data, cleans duplicate headers, produces a schema hash for change detection |
| `syncSheetData.tsx` | Batch sync (500 rows), upsert pattern, separate sync-status tracking in its own transaction so a failed status update never poisons the main sync |
| `virtualColumnCalculator.tsx` | Full formula engine — CONCAT, arithmetic with correct operator precedence (`*/` before `+-`), regex extraction — all column-ID based (~565 lines) |
| `calculateRelatedDataAnalysis.tsx` | SUM/COUNT/AVG per column, currency formatting, column-ID → name resolution |
| `applyRelatedDataFiltersAndAnalysis.tsx` | Analysis at three levels: overall, per-master-record, per-group |
| `GoogleSheetsAPI.tsx` | Service Account (public sheets) + OAuth (user-owned sheets), URL/spreadsheet-ID parsing, base64 key decoding |
| `formatCurrency.tsx` | Currency formatting with symbol, thousands separator, decimal places |

**Database schema (Kysely-generated, translates directly to Prisma):**

Key tables identified: `Projects`, `ProjectSheets`, `SheetColumns`, `SheetRelationships`, `VirtualColumns`, `ProjectAnalysisConfig` (stores groupBy/sortOrder/operations as JSON), `ProjectCharts`, `ProjectEmailFilters`, `sheetSyncStatus` (separate table — smart pattern).

`AnalysisType` enum: `calculation | filtering | grouping | sorting` — aligns exactly with the architecture spec.

**UI components (~50 Bedrock-specific components in a custom CSS-module library):**

Component decomposition is solid and maps to the three-tab editor spec:
- `ProjectSheetsTab`, `SheetForm`, `SheetPreviewTable`
- `VirtualColumnsTab`, `VirtualColumnForm`, `SortableFieldCard`
- `ProjectRelationshipsTab`, `RelationshipForm`, `RelationshipPreviewModal`
- `ProjectAnalysisConfig`, `AnalysisOperationsSection`, `UnifiedSortOrderSection`
- `ProjectDataViewer`, `MasterDetailView`, `GroupedDataSection`, `HierarchicalGroupView`
- `ProjectChartsTab`, `ChartConfigForm`, `ChartPreview`
- `EmailFilterSettings`
- `RelationshipAccordion` (with loading/empty/error/content states)

### Implementation Strategy Decision

**Decision: Hybrid approach — port the engine, rebuild the surface natively.**

Straight porting of the entire Floot codebase would sacrifice key IsoStack platform advantages:

| IsoStack Advantage | Status in Floot-Bedrock | Decision |
|-------------------|------------------------|----------|
| Three-tier tooltip inheritance | Not present | Build in natively from the start |
| Audit logging (`AuditLog` table) | Not present | Add to every mutation as per IsoStack convention |
| Branding inheritance (tenant logo/colours) | Isolated, custom system | Use IsoStack branding module — free |
| Component RBAC (`hasComponentAccess`) | Basic permissions only | Use `bedrock.projects.manage`, `bedrock.views.export` etc. |
| Multi-tenancy via `organizationId` | `Owners → Clients → Users` model (different) | Rewrite FK scoping to IsoStack `organizationId` |

**Layer-by-layer strategy:**

| Layer | Strategy |
|-------|---------|
| Engine logic (virtual columns, analysis, schema detection, sync) | **Port verbatim** — rewrite DB calls from Kysely → Prisma, keep all logic |
| Database schema | **Translate to Prisma** — 1:1 mapping, add `organizationId` scoping |
| tRPC routers | **Write native** — model on Floot endpoint logic, built as proper tRPC procedures with IsoStack auth/audit patterns |
| UI components | **Write native in Mantine** — use Floot component decomposition as a *spec*, not a source |
| Auth, branding, tooltips, RBAC, audit | **Get for free from IsoStack core** — do not replicate Floot versions |

### Next Steps (when resuming Bedrock)

1. Translate `helpers/schema.tsx` (Kysely) → Prisma models in `schema.prisma` (within `bedrock.*` namespace)
2. Create `src/modules/bedrock/` directory structure
3. Port engine helpers (`virtualColumnCalculator`, `generateSheetSchema`, `syncSheetData`, `calculateRelatedDataAnalysis`) as pure TS utility files
4. Create tRPC routers for projects, sheets, relationships, virtual columns, views
5. Build UI tab by tab in Mantine, using Floot component names as the spec

**Floot-Bedrock repo:** `/Volumes/isostack/Git/Floot-Bedrock` (local reference only)
