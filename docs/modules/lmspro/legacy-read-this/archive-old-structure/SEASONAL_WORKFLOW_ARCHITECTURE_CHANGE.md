# Seasonal Workflow Architecture Change

**Date:** January 2026  
**Status:** Design Complete - Implementation Pending  
**Impact:** Breaking change to seasonal workflow system

---

## Summary

The LMSPro seasonal workflow implementation is being redesigned from a **fixed-field** approach to a **Key Dates** approach before going into production.

---

## What Changed?

### Before: Fixed Season Date Fields ❌

**Schema:**
```prisma
model LMSProSeason {
  // 14+ hardcoded date fields
  leagueAgeGroupsConfirms: Date?
  leagueCreateAggsBy: Date?
  clubConfirmExistingTeams: Date?
  clubConfirmNewTeamAdditions: Date?
  // ... etc
}
```

**Problems:**
- Not flexible - limited to predefined field names
- Not reusable - dates don't carry over to new seasons
- Poor visibility - cryptic field names hard to understand
- Mixed system roles with module roles
- Supported unnecessary rule types (DATE_RANGE, INVERSE_DATE_RANGE)

### After: Key Dates Table ✅

**Schema:**
```prisma
model LMSProKeyDate {
  id              String   @id @default(cuid())
  name            String   // User-friendly (e.g., "Club Registration Window")
  description     String?
  activeFrom      DateTime
  activeFromTime  String   @default("00:00")
  activeTo        DateTime
  activeToTime    String   @default("23:59")
  seasonId        String
  organizationId  String
  // ... relationships
}

model VisibilityRule {
  type            String   // "KEY_DATE_RANGE" only
  keyDateId       String?  // Reference to LMSProKeyDate
  offsetDays      Int?     // Optional offset
  exemptRoleIds   String[] // Module role UUIDs (not system roles)
  // ... relationships
}
```

**Benefits:**
- ✅ Flexible - leagues define their own key dates
- ✅ Reusable - key date names duplicate at season rollover
- ✅ Clear - descriptive names and optional descriptions
- ✅ Correct - uses module role UUIDs instead of system role strings
- ✅ Simple - one rule type instead of three
- ✅ Table CRUD - follows established UX pattern

---

## Why the Change?

### User Identified Issues

1. **Wrong Role Model:** Original implementation used system roles (ADMIN, OWNER) instead of LMSPro module role UUIDs
2. **Not Flexible Enough:** Fixed fields don't accommodate varying league workflows
3. **Not Reusable:** Every new season requires reconfiguring all dates from scratch
4. **Mixed Date Types:** Absolute dates AND season phase dates caused confusion

### Designer Response

> "I am wrong. I need to change the way dates are managed for seasons. This will make LMSPro work for all leagues and processes."

**The hybrid solution:**
- Key date **names** are fixed (reusable structure)
- Actual **dates** are variable (flexible data)
- This balances reusability with per-season customization

---

## Implementation Status

### Completed ✅
- [x] Key Dates architecture documented (`key-dates-architecture.md`)
- [x] Schema design finalized
- [x] UI mockups created
- [x] API endpoints specified
- [x] Testing strategy defined
- [x] Migration path planned
- [x] User documentation drafted

### In Progress 🚧
- [ ] Database migration
- [ ] Schema changes applied
- [ ] UI components built
- [ ] Visibility engine updated
- [ ] Tests written
- [ ] Deployed to techtest

### Not Started ⏳
- [ ] Season rollover duplication feature
- [ ] Notification system for upcoming key dates
- [ ] Analytics/reporting on key date usage

---

## Breaking Changes

### Database Schema

**Deleted:**
- All fixed date fields from `LMSProSeason` (14+ fields)

**Added:**
- `LMSProKeyDate` table
- `keyDateId` field to `VisibilityRule`
- `exemptRoleIds` array (replacing `exemptRoles` strings)

**Modified:**
- `VisibilityRule.type` - now only accepts "KEY_DATE_RANGE"

### API Changes

**Removed Endpoints:**
- Season date field updates (no longer exist)

**New Endpoints:**
- `keyDates.list` - Get all key dates for a season
- `keyDates.create` - Create a new key date
- `keyDates.update` - Update a key date
- `keyDates.delete` - Delete a key date (if not referenced)

**Modified Endpoints:**
- `components.listForUser` - Now fetches key dates instead of season fields

### UI Changes

**Removed:**
- Fixed date field inputs in season form
- Absolute date pickers in visibility rule editor
- DATE_RANGE and INVERSE_DATE_RANGE rule type options

**Added:**
- "Key Dates" tab in Season page
- Key dates table with CRUD modal
- Key date selector in visibility rule editor
- Date offset configuration UI

**Modified:**
- Visibility rule editor - simplified to single rule type
- Card impact visualizer - shows key date names instead of field names

---

## Migration Path

### Phase 1: Schema Migration

**File:** `prisma/migrations/YYYYMMDDHHMMSS_key_dates_migration/migration.sql`

```sql
-- 1. Create LMSProKeyDate table
CREATE TABLE "lmspro_key_dates" (
  "id" TEXT PRIMARY KEY,
  "name" TEXT NOT NULL,
  "description" TEXT,
  "active_from" TIMESTAMP(3) NOT NULL,
  "active_from_time" TEXT DEFAULT '00:00',
  "active_to" TIMESTAMP(3) NOT NULL,
  "active_to_time" TEXT DEFAULT '23:59',
  "season_id" TEXT NOT NULL,
  "organization_id" TEXT NOT NULL,
  "created_at" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
  "updated_at" TIMESTAMP(3),
  "created_by" TEXT,
  CONSTRAINT "fk_season" FOREIGN KEY ("season_id") REFERENCES "lmspro_seasons"("id") ON DELETE CASCADE,
  CONSTRAINT "fk_org" FOREIGN KEY ("organization_id") REFERENCES "organizations"("id") ON DELETE CASCADE
);

-- 2. Add keyDateId to visibility_rules
ALTER TABLE "visibility_rules" ADD COLUMN "key_date_id" TEXT;
ALTER TABLE "visibility_rules" ADD CONSTRAINT "fk_key_date" 
  FOREIGN KEY ("key_date_id") REFERENCES "lmspro_key_dates"("id") ON DELETE CASCADE;

-- 3. Add exemptRoleIds array
ALTER TABLE "visibility_rules" ADD COLUMN "exempt_role_ids" TEXT[];

-- 4. Migrate existing season dates to key dates
-- (See data migration script)

-- 5. Drop old season date fields
ALTER TABLE "lmspro_seasons" 
  DROP COLUMN "league_age_groups_confirms",
  DROP COLUMN "league_create_aggs_by",
  DROP COLUMN "club_confirm_existing_teams",
  -- ... (all 14+ fields)
```

### Phase 2: Data Migration

**Script:** `scripts/migrate-season-dates-to-key-dates.ts`

```typescript
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function migrateSeasonDates() {
  const seasons = await prisma.lMSProSeason.findMany({
    include: { organization: true }
  });

  for (const season of seasons) {
    // Map old field names to friendly key date names
    const fieldMappings = {
      leagueAgeGroupsConfirms: 'League Confirms Age Groups',
      leagueCreateAggsBy: 'League Creates AGGs Deadline',
      clubConfirmExistingTeams: 'Club Confirm Existing Teams',
      // ... etc
    };

    for (const [fieldName, keyDateName] of Object.entries(fieldMappings)) {
      const dateValue = season[fieldName];
      if (dateValue) {
        // Create key date from old field
        await prisma.lMSProKeyDate.create({
          data: {
            name: keyDateName,
            activeFrom: dateValue,
            activeFromTime: '00:00',
            activeTo: dateValue,
            activeToTime: '23:59',
            seasonId: season.id,
            organizationId: season.organizationId
          }
        });
      }
    }
  }

  console.log('Migration complete');
}

migrateSeasonDates();
```

### Phase 3: Update Existing Visibility Rules

**Script:** `scripts/update-visibility-rules-for-key-dates.ts`

```typescript
// For each visibility rule that uses SEASON_PHASE:
// 1. Find the corresponding key date by name
// 2. Update rule to reference keyDateId
// 3. Change type to KEY_DATE_RANGE
// 4. Convert exemptRoles strings to exemptRoleIds UUIDs

// For each visibility rule that uses DATE_RANGE or INVERSE_DATE_RANGE:
// 1. Create a new key date with the absolute dates
// 2. Update rule to reference new keyDateId
// 3. Change type to KEY_DATE_RANGE
```

---

## Testing Checklist

### Database Tests
- [ ] LMSProKeyDate CRUD operations
- [ ] Unique constraint on (seasonId, name)
- [ ] Cascade delete when season deleted
- [ ] Cascade delete of visibility rules when key date deleted
- [ ] Validation: activeTo >= activeFrom

### API Tests
- [ ] Create key date with valid data
- [ ] Reject key date with end before start
- [ ] Prevent duplicate key date names in same season
- [ ] Prevent deleting key date referenced by visibility rules
- [ ] List key dates scoped to organization
- [ ] Update key date fields

### Visibility Engine Tests
- [ ] Card visible when current time within key date range
- [ ] Card hidden when outside key date range
- [ ] Exempt roles always see card
- [ ] Date offsets applied correctly
- [ ] Time components (HH:MM) respected
- [ ] Module role UUID lookup works

### UI Tests
- [ ] Key Dates tab appears in Season page
- [ ] Add Key Date button opens modal
- [ ] Row click opens edit modal (Table CRUD pattern)
- [ ] Delete button in modal footer
- [ ] Date validation shows error
- [ ] Key date selector in visibility rule editor
- [ ] Offset configuration UI works
- [ ] Module role multi-select shows correct roles

---

## Rollback Plan

If critical issues discovered after deployment:

1. **Database:** Keep migration files but don't drop old season date fields yet
2. **Code:** Git tag the last working commit before Key Dates
3. **UI:** Feature flag to toggle between old/new UI
4. **Data:** Backup all organizations before migration

**Rollback Command:**
```bash
git revert <key-dates-commit-range>
npx prisma migrate rollback --to <previous-migration>
git push origin dev --force
```

---

## Documentation Updates Needed

### Developer Docs
- [x] Key Dates architecture (`key-dates-architecture.md`)
- [x] Migration guide (this document)
- [ ] API reference for key dates router
- [ ] Component library - KeyDatesTab component
- [ ] Testing guide updates

### User Docs
- [ ] Season setup guide - Key Dates section
- [ ] Seasonal workflows configuration guide
- [ ] Video tutorial - Setting up key dates
- [ ] FAQ - Why did season date fields disappear?

### External Docs (iso-docs)
- [ ] Update architecture.md to reference Key Dates
- [ ] Update conventions.md with Key Date naming
- [ ] Update glossary.md with Key Date definition

---

## Questions & Decisions

### Resolved ✅

**Q:** Should we use fixed season date fields or dynamic key dates?  
**A:** Key Dates (flexible, reusable)

**Q:** Should visibility rules use system roles or module roles?  
**A:** Module roles (UUIDs)

**Q:** How many rule types should we support?  
**A:** One - KEY_DATE_RANGE only

**Q:** Should key dates be duplicatable at season rollover?  
**A:** Yes - names/descriptions copy, dates reset to null

### Open ❓

**Q:** Should we provide key date templates for common league types?  
**A:** TBD - could speed up setup but adds complexity

**Q:** Should key dates support notifications/reminders?  
**A:** TBD - useful feature but separate concern

**Q:** Should we allow cascading key dates (e.g., "7 days after X")?  
**A:** TBD - offset configuration partially addresses this

**Q:** Should we track analytics on key date usage?  
**A:** TBD - helpful for understanding league workflows

---

## Timeline

| Phase | Tasks | Duration | Status |
|-------|-------|----------|--------|
| Design | Architecture docs, schema design | 2 days | ✅ Complete |
| Schema | Database migration, Prisma updates | 1 day | ⏳ Not Started |
| Backend | API endpoints, visibility engine | 2 days | ⏳ Not Started |
| Frontend | UI components, Table CRUD | 3 days | ⏳ Not Started |
| Testing | Unit, integration, E2E tests | 2 days | ⏳ Not Started |
| Migration | Data migration scripts, validation | 1 day | ⏳ Not Started |
| Deploy | Techtest deployment, monitoring | 0.5 days | ⏳ Not Started |
| **Total** | | **11.5 days** | **~9% complete** |

---

## Success Criteria

**Must Have:**
- [x] Architecture documented and approved
- [ ] Schema migration created and tested
- [ ] All 14+ fixed date fields removed from LMSProSeason
- [ ] Key Dates CRUD working via Table CRUD pattern
- [ ] Visibility rules reference key dates correctly
- [ ] Module role UUIDs used (not system role strings)
- [ ] Zero TypeScript errors
- [ ] All tests passing
- [ ] Deployed to techtest without breaking existing functionality

**Nice to Have:**
- [ ] Key date templates for common league types
- [ ] Notification system for upcoming key dates
- [ ] Analytics dashboard for key date usage
- [ ] CSV import/export for key dates

---

## Stakeholder Sign-Off

- [ ] **Product Owner:** Approved architecture change
- [ ] **Technical Lead:** Reviewed schema design
- [ ] **UX Designer:** Approved UI mockups
- [ ] **QA Lead:** Reviewed testing strategy
- [ ] **DevOps:** Reviewed migration plan

---

## Related Documents

- `key-dates-architecture.md` - Full architectural specification
- `time-sensitive-permissions-architecture.md` - Original (superseded) design
- `team-status-lifecycle.md` - Related workflow feature
- `/docs/00-READ_THIS/TABLE_CRUD_PATTERN_IMPLEMENTATION.md` - UI pattern guide
- `.github/copilot-instructions.md` - Development guidelines

---

**Last Updated:** January 2026  
**Author:** GitHub Copilot (with human guidance)  
**Status:** Ready for Implementation
