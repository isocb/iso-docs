# Import/Export System

**Status:** 📋 PLANNING  
**Priority:** HIGH  
**Owner:** Platform (P1 & C1 only)  
**Est. Duration:** 5-7 days

---

## Overview

The Import/Export system enables organizations to migrate legacy data from existing systems into IsoStack, preserving foreign key relationships while converting integer-based primary keys to UUID format.

### Key Features
- **Idempotent imports** - Can re-run without creating duplicates
- **Legacy key mapping** - Stores original PK/FK pairs for reference
- **Hierarchical imports** - Parent entities before children (Clubs → Teams)
- **Validation-first** - Detects errors before database writes
- **Rollback capability** - Can undo failed imports completely
- **Audit trail** - Every import logged for compliance
- **Filterable exports** - Export by season, club, age group
- **Module registry** - Extensible architecture for adding new entity types

---

## When to Use Import/Export

### ✅ Use Import When:
- Onboarding new organization with existing data in spreadsheets
- Migrating from legacy system (integer PKs → UUIDs)
- Bulk data entry (100+ records)
- Converting data from incompatible format

### ✅ Use Export When:
- Backing up organization data
- Sharing subset of data with external party (e.g., specific season)
- Data verification and auditing
- Migrating to another system
- Creating reports for compliance

### ❌ Don't Use Import/Export When:
- Adding single records (use normal UI instead)
- Data is already in IsoStack UUID format (use direct DB migration)
- Real-time sync needed (use webhooks/API instead)
- Making small updates to existing records (use edit UI)

---

## Use Cases

### Primary: League Migration
When onboarding new sports leagues (Derby Rangers, etc.), they have existing data in spreadsheets or legacy systems with integer IDs. This system:
1. Imports clubs (legacy ID 1 → UUID abc-123)
2. Imports teams linked to clubs (legacy club_id 1 → UUID abc-123)
3. Preserves relationships while meeting IsoStack's UUID requirement

### Secondary: Data Portability
- **Export current data** for backup or migration to new systems
- **Re-import** data after system upgrades
- **Data verification** - Compare legacy vs imported records

---

## Quick Start

### For Developers
```bash
# 1. Review architecture
docs/core/features/import-export/architecture.md

# 2. Follow implementation plan
docs/core/features/import-export/implementation-plan.md

# 3. Run tests
docs/core/features/import-export/testing.md
```

### For Platform Admins (P1)

**Import Data:**
```
1. Navigate to /app/admin/import
2. Create import job (select entity type: Clubs, Teams, etc.)
3. Upload CSV/JSON file
4. Review validation results
5. Execute import
6. Verify in Prisma Studio
```

**Export Data:**
```
1. Navigate to /app/admin/export
2. Select entity type (Clubs, Teams, etc.)
3. Apply filters:
   - Season (optional)
   - Club (optional, for teams)
   - Age Group (optional, for teams)
4. Choose format (CSV or JSON)
5. Click Export → File downloads
6. Use in Excel, Google Sheets, or other tools
```
### Import Flow
```
1. Upload CSV/JSON
2. Validate data
3. Create ImportJob (status: VALIDATING)
4. For each row:
   - Create entity with new UUID
   - Store legacy_id → new_uuid in LegacyKeyMapping
   - Log to AuditLog
5. Update ImportJob (status: COMPLETED)
```

### Export Flow
```
1. Select entity type and filters
2. Query database with filters applied
3. Fetch entities + related data (optional)
4. Include legacy IDs if they exist
5. Transform to CSV/JSON format
6. Download file
```acyKeyMapping   → Maps old IDs to new UUIDs
  ↓
Entity Tables      → Actual data (Club, Team, etc.)
```

### Import Flow
```
1. Upload CSV/JSON
2. Validate data
3. Create ImportJob (status: VALIDATING)
4. For each row:
   - Create entity with new UUID
   - Store legacy_id → new_uuid in LegacyKeyMapping
   - Log to AuditLog
5. Update ImportJob (status: COMPLETED)
```

---

## Documentation Index

| Document | Purpose |
|----------|---------|
| [README.md](./README.md) | This file - overview & quick start |
| [architecture.md](./architecture.md) | Technical design & data model |
| [implementation-plan.md](./implementation-plan.md) | Phase-by-phase work plan |
| [testing.md](./testing.md) | Test scenarios & validation |

---

### Completed
- [x] Requirements gathering
- [x] Architecture design (import + export)
- [x] Documentation structure
- [x] Module registry pattern defined
- [x] Export filtering specification

### In Progress
- [ ] Database schema design
- [ ] tRPC router implementation
- [ ] CSV parser integration (Papa Parse)

### Planned
- [ ] Frontend wizard UI (import)
- [ ] Frontend export UI with filters
- [ ] Import handlers for Clubs, Teams
- [ ] Export functionality (filterable)
- [ ] Scheduled imports (future)ucture

### In Progress
- [ ] Database schema design
- [ ] tRPC router implementation

### Planned
- [ ] Frontend wizard UI
- [ ] CSV parser utility
- [ ] Export functionality
- [ ] Scheduled imports

---

## Change Log

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-05 | Chris | Initial documentation created |

---

## Questions & Support

**For implementation questions:**  
Review `implementation-plan.md` for detailed phase-by-phase guidance.

**For architectural questions:**  
Review `architecture.md` for technical design details.

**For testing:**  
Review `testing.md` for validation scenarios.
