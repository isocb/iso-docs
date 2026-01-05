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
```
1. Navigate to /app/admin/import
2. Create import job (select entity type: Clubs, Teams, etc.)
3. Upload CSV/JSON file
4. Review validation results
5. Execute import
6. Verify in Prisma Studio
```

---

## Architecture Summary

### Three-Table Pattern

```
ImportJob          → Tracks each import batch
  ↓
LegacyKeyMapping   → Maps old IDs to new UUIDs
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

## Related Core Features

- **Audit Logging** - Every import is logged (`/docs/core/audit-logging/`)
- **Permissions** - P1 & C1 roles only (`/docs/core/roles-and-permissions.md`)
- **Multi-Tenancy** - All imports scoped by `organizationId`

---

## Status

### Completed
- [x] Requirements gathering
- [x] Architecture design
- [x] Documentation structure

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
