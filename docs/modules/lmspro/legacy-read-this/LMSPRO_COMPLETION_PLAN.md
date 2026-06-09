# LMSPro Implementation Audit & Completion Plan

**Date:** February 2, 2026  
**Status:** Comprehensive Review  
**Purpose:** Single source of truth for completing LMSPro to production-ready status

---

## Executive Summary

**Current Completion: ~35%** (Phase 0-1 foundation complete, Phases 2-8 require work)

### Key Achievements ✅
- Complete database schema with 13 models
- Core CRUD routers (9 routers operational)
- Import system with legacy key mapping (3 handlers)
- 16 dashboard components implemented
- Dynamic dashboard architecture designed
- Key Dates system partially implemented
- Free Days and Disciplinary features complete

### Critical Gaps ❌
- Venues implementation (0% - schema only)
- Referees implementation (0% - blocked, security-sensitive)
- Fixtures system (0% - not started)
- Season rollover automation (0% - critical for production)
- Time-based visibility rules (50% - Key Dates architecture defined, engine needs work)
- Testing coverage (10% - minimal tests exist)
- Documentation (30% - architecture docs exist, user guides missing)

### Production Blockers 🚨
1. **Season Rollover** - Critical for yearly operations
2. **Venues Management** - Required for fixture scheduling
3. **Key Dates Visibility Engine** - Workflow gates not enforced
4. **Testing Suite** - No integration/E2E tests
5. **User Documentation** - No user-facing guides

---

## Implementation Status by Phase

### Phase 0: Foundation ✅ **85% COMPLETE**

#### Database Schema ✅ 100%
**Status:** All models implemented

**Models Implemented (13):**
1. ✅ `LMSProSeason` - Season management with ageGroupTags
2. ✅ `LMSProKeyDate` - Flexible seasonal workflow dates
3. ✅ `LMSProTeamFreeDay` - Free days request/approval system
4. ✅ `LMSProDisciplinaryRecord` - Player/manager suspensions
5. ✅ `LMSProClub` - Club registration with status workflow
6. ✅ `LMSProClubOfficial` - User-club-role linking (deprecated)
7. ✅ `LMSProTeam` - Team registration with manager data
8. ✅ `LMSProAgeGroup` - Flexible string-based age codes
9. ✅ `LMSProAgeGroupGroup` (AGG/Division) - Team divisions
10. ✅ `LMSProVenue` - Venue management with JSON contacts
11. ✅ `LMSProReferee` - Referee data with encryption
12. ✅ `LMSProUserProfile` - Email filtering metadata
13. ✅ `LMSProPageComponent` - DEPRECATED (replaced by ComponentDefinition)

**Schema Quality:**
- ✅ Multi-tenant isolation (`organizationId` on all models)
- ✅ Proper indexes and unique constraints
- ✅ Audit timestamps (createdAt, updatedAt)
- ✅ Enum-based status workflows
- ✅ JSON fields for flexible data
- ✅ Field-level encryption (Referee contactDetails)

#### Module Registration ⚠️ **40% COMPLETE**

**File:** `src/modules/lmspro/module.config.ts`

**Implemented:**
```typescript
export const lmsproModuleConfig: ModuleConfig = {
  id: 'lmspro',
  name: 'LMSPro',
  description: 'League Management System Pro',
  icon: 'IconShield',
  route: '/app/lmspro',
  featureFlag: 'lmspro',
};
```

**Missing (Per Original Plan):**
- ❌ `userMetadataFilters` - Email filtering for targeted communications
- ❌ `metaEmailTemplates` - Automated notifications
- ❌ `optionsSource` - Dynamic filter queries

**Impact:** Cannot send targeted emails (e.g., "all U9 team managers"), no automated notifications

**Action Required:**
1. Add userMetadataFilters configuration
2. Define metaEmailTemplates
3. Implement email filtering logic
4. Test with Resend integration

---

### Phase 1: Core CRUD ✅ **95% COMPLETE**

#### tRPC Routers ✅ 95%

**Implemented Routers (11):**
1. ✅ `seasons.router.ts` - Season CRUD + current season management
2. ✅ `clubs.router.ts` - Club registration + status workflow
3. ✅ `club-officials.router.ts` - User-club-role assignments
4. ✅ `teams.router.ts` - Team registration + AGG allocation
5. ✅ `age-groups.router.ts` - Age groups + AGG management + stats
6. ✅ `users.router.ts` - User management queries
7. ✅ `roles.router.ts` - Role management
8. ✅ `components.router.ts` - Component resolution
9. ✅ `key-dates.router.ts` - Key dates CRUD
10. ✅ `freeDays.router.ts` - Free days request/approval
11. ✅ `disciplinary.router.ts` - Suspension management

**Missing Routers (2):**
- ❌ `venues.router.ts` - Venue CRUD operations
- ❌ `referees.router.ts` - Referee management (security-sensitive)

**Router Quality:**
- ✅ Zod validation on all inputs
- ✅ Multi-tenant scoping (`organizationId` filtering)
- ✅ RBAC checks (ADMIN/OWNER permissions)
- ✅ Audit logging on mutations
- ✅ Efficient queries with proper includes/selects

#### UI Pages ✅ 90%

**Location:** `src/app/(app)/app/lmspro/`

**Implemented Pages (11):**
1. ✅ `/page.tsx` - Module entry point
2. ✅ `/dashboard/page.tsx` - League dashboard (shell)
3. ✅ `/seasons/page.tsx` - Season management list
4. ✅ `/clubs/page.tsx` - Club registration list
5. ✅ `/clubs/[clubId]/page.tsx` - Club detail with tabs
6. ✅ `/teams/page.tsx` - Team management list
7. ✅ `/aggs/page.tsx` - AGG Manager with accordion UI ⭐
8. ✅ `/admin/users/page.tsx` - User management
9. ✅ `/admin/roles/page.tsx` - Role assignment
10. ✅ `/settings/page.tsx` - Module settings
11. ✅ `/club/dashboard/page.tsx` - Club-specific view

**Missing Pages (2):**
- ❌ `/venues/page.tsx` - Venue management
- ❌ `/referees/page.tsx` - Referee management

**UI Patterns:**
- ✅ DataTable with search/sort
- ✅ Click-to-modal for CRUD operations
- ✅ Status badges and progress indicators
- ✅ Tab-based navigation in detail views
- ✅ Responsive layouts

#### Dashboard Components ✅ 100%

**Location:** `src/modules/lmspro/components/dashboard/`

**Implemented Components (16):**
1. ✅ `PendingClubsTable.tsx` - Approve new clubs
2. ✅ `PendingTeamsTable.tsx` - Approve team registrations
3. ✅ `AllClubsList.tsx` - View all clubs
4. ✅ `AllTeamsList.tsx` - View all teams
5. ✅ `SeasonOverview.tsx` - Season summary stats
6. ✅ `QuickStats.tsx` - Dashboard KPIs
7. ✅ `FinancialSummary.tsx` - Financial overview
8. ✅ `ClubTeamsView.tsx` - Club's teams list
9. ✅ `ClubOfficialsView.tsx` - Club officials management
10. ✅ `ClubFinancesView.tsx` - Club financial details
11. ✅ `ClubFixturesView.tsx` - Club fixture calendar
12. ✅ `ClubWelfareView.tsx` - Safeguarding compliance
13. ✅ `FreeDaysRequest.tsx` - Request free days (club/league users)
14. ✅ `FreeDaysManage.tsx` - Approve/cancel free days (league admins)
15. ✅ `SuspensionManagement.tsx` - Manage suspensions
16. ✅ `ComponentRenderer.tsx` - Dynamic component resolution

**Component Registry:**
```typescript
// src/modules/lmspro/components/registry.tsx
export const componentRegistry: Record<string, React.ComponentType<ComponentProps>> = {
  'clubs.pending.view': PendingClubsTable,
  'teams.pending.view': PendingTeamsTable,
  'freedays.request': FreeDaysRequest,
  'disciplinary.manage': SuspensionManagement,
  // ... 16 components total
};
```

**Missing Components:**
- ❌ Venue management components
- ❌ Referee pool components
- ❌ Fixture scheduling components

#### Import System ✅ **60% COMPLETE**

**Location:** `src/modules/lmspro/import/`

**Implemented Handlers (3):**
1. ✅ `handlers/club.ts` - Club CSV import with legacy key mapping
2. ✅ `handlers/team.ts` - Team CSV import with FK resolution
3. ✅ `handlers/agg.ts` - AGG import handler

**Import Features:**
- ✅ CSV validation with Zod schemas
- ✅ Legacy key mapping (integer PK → UUID FK resolution)
- ✅ Duplicate detection
- ✅ Transaction-safe imports
- ✅ Audit logging

**Import Order (Critical):**
```
1. Clubs (no dependencies)
2. AGGs (depends on age groups)
3. Teams (depends on clubs + age groups + optional AGG)
```

**Missing Handlers (3):**
- ❌ `handlers/venue.ts` - Venue import
- ❌ `handlers/referee.ts` - Referee import
- ❌ `handlers/player.ts` - Player import (future)

**Action Required:**
1. Implement venue import handler
2. Implement referee import handler (with encryption)
3. Add comprehensive error handling
4. Create import templates documentation

---

### Phase 2: Seasonal Workflows ⚠️ **50% COMPLETE**

#### Key Dates System ⚠️ 50%

**Architecture:** `key-dates-architecture.md` (complete)

**Database Schema:** ✅ 100%
- `LMSProKeyDate` table exists
- `VisibilityRule.keyDateId` field exists
- `VisibilityRule.exemptRoleIds` array exists

**Backend Implementation:** ⚠️ 40%
- ✅ `key-dates.router.ts` - CRUD operations complete
- ⚠️ `visibility-rules.engine.ts` - Partially implemented
  - ✅ Key date lookup logic
  - ✅ Date range checking
  - ❌ Module role exemptions (uses platform roles instead)
  - ❌ Date offset calculations incomplete
  - ❌ Cascade behavior not implemented

**Frontend Implementation:** ⚠️ 30%
- ❌ Key Dates tab not added to Season page
- ❌ Key dates table CRUD UI not implemented
- ❌ Key date selector in VisibilityRulesEditor not implemented
- ✅ ComponentDefinition table exists (ready for visibility rules)

**Critical Issues:**
1. **Wrong Role Model:** Visibility engine checks platform roles (ADMIN, OWNER) instead of LMSPro module role UUIDs
2. **UI Missing:** Cannot create/manage key dates via UI
3. **Not Enforced:** Cards still visible regardless of key dates

**Action Required:**
1. **High Priority:** Fix visibility engine to use module role UUIDs
   ```typescript
   // WRONG (current):
   if (rule.exemptRoles?.includes(context.userRole)) { return visible; }
   
   // CORRECT (needed):
   const userModuleRoles = await getUserModuleRoles(userId, orgId);
   if (rule.exemptRoleIds?.some(id => userModuleRoles.includes(id))) { return visible; }
   ```

2. **High Priority:** Implement Key Dates tab in Season page
   - Add tab to `/app/lmspro/seasons/page.tsx`
   - Create KeyDatesTab component with DataTable
   - Implement create/edit/delete modals

3. **Medium Priority:** Update VisibilityRulesEditor
   - Replace date pickers with key date selector
   - Add date offset configuration UI
   - Add module role selector for exemptions

4. **Low Priority:** Implement cascade behavior
   - Hide child components when parent hidden
   - Add cascade flag to VisibilityRule

**Testing Requirements:**
- Test key date CRUD operations
- Test visibility engine with module roles
- Test date offset calculations
- Test cascade behavior
- Test with multiple roles per user

#### Season Rollover 🚨 **0% COMPLETE**

**Status:** Critical production blocker - not started

**Requirements:**
1. Create new season (copy structure from previous)
2. Duplicate key dates (names copied, dates cleared)
3. Archive previous season's teams (status → ARCHIVED)
4. Reset club statuses (APPROVED → PENDING)
5. Clear AGG allocations
6. Preserve user roles
7. Audit log all changes

**Implementation Plan:**

**Phase 2A: Manual Rollover (MVP)**
```typescript
// src/modules/lmspro/routers/seasons.router.ts
rollover: requireRole([Role.ADMIN, Role.OWNER])
  .input(z.object({
    sourceSeasonId: z.string(),
    newSeasonName: z.string(),
    startDate: z.date(),
    endDate: z.date(),
  }))
  .mutation(async ({ ctx, input }) => {
    // 1. Create new season
    const newSeason = await ctx.prisma.lMSProSeason.create({...});
    
    // 2. Duplicate key dates (names only, dates cleared)
    const sourceKeyDates = await ctx.prisma.lMSProKeyDate.findMany({
      where: { seasonId: input.sourceSeasonId },
    });
    await Promise.all(sourceKeyDates.map(kd => 
      ctx.prisma.lMSProKeyDate.create({
        data: {
          seasonId: newSeason.id,
          name: kd.name,
          description: kd.description,
          activeFrom: null, // User must set dates
          activeTo: null,
          // ...
        },
      })
    ));
    
    // 3. Archive previous season teams
    await ctx.prisma.lMSProTeam.updateMany({
      where: { seasonId: input.sourceSeasonId },
      data: { status: 'ARCHIVED' },
    });
    
    // 4. Reset club statuses (optional - user decision)
    // await ctx.prisma.lMSProClub.updateMany({...});
    
    // 5. Audit log
    await ctx.prisma.auditLog.create({
      data: {
        action: 'SEASON_ROLLOVER',
        entityType: 'LMSProSeason',
        entityId: newSeason.id,
        metadata: { sourceSeasonId: input.sourceSeasonId },
        userId: ctx.session!.user.id,
        organizationId: ctx.session!.user.organizationId,
      },
    });
    
    return newSeason;
  });
```

**Phase 2B: UI Implementation**
- Add "Rollover Season" button to Seasons page
- Create rollover modal with options:
  - Source season selector
  - New season name
  - Date range
  - Options: Reset club statuses? Clear AGG allocations?
- Show progress indicator during rollover
- Display summary: X key dates copied, Y teams archived, etc.

**Phase 2C: Advanced Features (Future)**
- Automated rollover scheduling (cron job)
- Rollback capability (restore previous season)
- Incremental rollover (copy clubs/teams individually)
- Rollover templates (pre-configured workflows)

**Testing Requirements:**
- Test with empty season (no clubs/teams)
- Test with full season (all data types)
- Test key dates duplication
- Test audit logging
- Test rollback scenario

---

### Phase 3: Fixtures & Scheduling 🚨 **0% COMPLETE**

**Status:** Not started - requires Venues implementation first

#### Venues Management ❌ 0%

**Database Schema:** ✅ Complete
```prisma
model LMSProVenue {
  id             String @id @default(uuid())
  organizationId String
  seasonId       String
  name           String
  address        String?
  postcode       String?
  capacity       Int?
  facilities     String[]
  contacts       Json // { primary: {...}, secondary: {...} }
  isActive       Boolean @default(true)
  // ...
}
```

**Missing Implementation:**
1. ❌ `venues.router.ts` - CRUD operations
2. ❌ `/app/lmspro/venues/page.tsx` - Venue management UI
3. ❌ Venue import handler
4. ❌ Venue availability calendar

**Action Required:**

**Step 1: Create Venues Router**
```typescript
// src/modules/lmspro/routers/venues.router.ts
export const venuesRouter = createTRPCRouter({
  list: protectedProcedure
    .input(z.object({ seasonId: z.string() }))
    .query(async ({ ctx, input }) => {
      return await ctx.prisma.lMSProVenue.findMany({
        where: {
          organizationId: ctx.session!.user.organizationId,
          seasonId: input.seasonId,
        },
      });
    }),
  
  create: requireRole([Role.ADMIN, Role.OWNER])
    .input(z.object({
      seasonId: z.string(),
      name: z.string(),
      address: z.string().optional(),
      postcode: z.string().optional(),
      capacity: z.number().optional(),
      facilities: z.array(z.string()).optional(),
      contacts: z.any(), // { primary, secondary }
    }))
    .mutation(async ({ ctx, input }) => {
      const venue = await ctx.prisma.lMSProVenue.create({
        data: {
          ...input,
          organizationId: ctx.session!.user.organizationId,
        },
      });
      
      // Audit log
      await ctx.prisma.auditLog.create({...});
      
      return venue;
    }),
  
  update: requireRole([Role.ADMIN, Role.OWNER])
    .input(z.object({ id: z.string(), ...}))
    .mutation(async ({ ctx, input }) => {
      // Verify ownership
      // Update venue
      // Audit log
    }),
  
  delete: requireRole([Role.ADMIN, Role.OWNER])
    .input(z.object({ id: z.string() }))
    .mutation(async ({ ctx, input }) => {
      // Check for dependencies (fixtures)
      // Soft delete (isActive = false)
      // Audit log
    }),
});
```

**Step 2: Create Venues UI Page**
```typescript
// src/app/(app)/app/lmspro/venues/page.tsx
'use client';

export default function VenuesPage() {
  const [opened, { open, close }] = useDisclosure(false);
  const [editingVenue, setEditingVenue] = useState<LMSProVenue | null>(null);
  
  const { data: venues, isLoading } = trpc.lmspro.venues.list.useQuery({
    seasonId: activeSeasonId,
  });
  
  // DataTable with CRUD modals
  return (
    <Stack>
      <Group justify="space-between">
        <Title>Venues</Title>
        <Button onClick={open}>Add Venue</Button>
      </Group>
      
      <DataTable
        records={venues}
        columns={[
          { accessor: 'name', title: 'Venue Name' },
          { accessor: 'address', title: 'Address' },
          { accessor: 'postcode', title: 'Postcode' },
          { accessor: 'capacity', title: 'Capacity' },
        ]}
        onRowClick={(venue) => {
          setEditingVenue(venue);
          open();
        }}
      />
      
      <Modal opened={opened} onClose={close}>
        {/* Venue form */}
      </Modal>
    </Stack>
  );
}
```

**Step 3: Register Router**
```typescript
// src/modules/lmspro/routers/index.ts
import { venuesRouter } from './venues.router';

export const lmsproRouter = createTRPCRouter({
  // ...
  venues: venuesRouter,
});
```

**Step 4: Create Venue Import Handler**
```typescript
// src/modules/lmspro/import/handlers/venue.ts
export async function importVenues(ctx: ImportContext) {
  // Validate CSV
  // Map legacy keys
  // Create venues
  // Return results
}
```

**Testing Requirements:**
- Test venue CRUD operations
- Test postcode validation
- Test capacity constraints
- Test contact JSON structure
- Test soft delete behavior

#### Fixtures System ❌ 0%

**Requirements:**
1. Fixture model (match between two teams at venue)
2. Fixture scheduling algorithm
3. Fixture calendar UI
4. Fixture result recording
5. League table calculation

**Action Required:** Define after Venues complete

---

### Phase 4: Referees ⚠️ **0% COMPLETE (BLOCKED)**

**Status:** Security-sensitive - requires careful implementation

**Database Schema:** ✅ Complete
```prisma
model LMSProReferee {
  id             String @id @default(uuid())
  organizationId String
  seasonId       String
  firstName      String
  lastName       String
  contactDetails String // ENCRYPTED (email, phone)
  level          String?
  isActive       Boolean @default(true)
  // ...
}
```

**Security Requirements:**
1. Field-level encryption for contactDetails
2. RBAC: Only LEAGUE_SECRETARY + REFEREE_COORDINATOR can view
3. Audit logging for all access
4. PII compliance (GDPR, UK DPA 2018)

**Implementation Blocked:**
- Need encryption key rotation strategy documented
- Need PII handling policy approved
- Need RBAC enforcement tested

**Action Required:**
1. Review encryption implementation (`src/lib/encryption.ts`)
2. Test field-level encryption with Referee model
3. Implement strict RBAC checks
4. Add audit logging for PII access
5. Document compliance procedures

---

### Phase 5: Testing ⚠️ **10% COMPLETE**

**Current State:**
- ✅ 1 unit test exists (`club.test.ts`)
- ❌ No integration tests
- ❌ No E2E tests
- ❌ No component tests

**Testing Strategy:**

#### Unit Tests (Target: 80% coverage)
**Location:** `src/modules/lmspro/**/__tests__/`

**Priority Areas:**
1. **Import Handlers** (critical)
   - ✅ `club.test.ts` exists
   - ❌ `team.test.ts` needed
   - ❌ `agg.test.ts` needed
   - ❌ Legacy key mapping tests

2. **Business Logic** (high priority)
   - ❌ Team status transitions
   - ❌ AGG capacity enforcement
   - ❌ Free days quota validation
   - ❌ Suspension calculations

3. **Visibility Rules Engine** (critical)
   - ❌ Key date evaluation
   - ❌ Date offset calculations
   - ❌ Module role exemptions
   - ❌ Cascade behavior

#### Integration Tests (Target: Key workflows)
**Tool:** Vitest + Prisma test database

**Test Scenarios:**
1. Season creation → Club registration → Team registration → AGG allocation
2. Key date creation → Visibility rule creation → Component visibility check
3. Free day request → Auto-approval → Quota enforcement
4. Suspension creation → Active period check → Automatic expiry

#### E2E Tests (Target: Critical user journeys)
**Tool:** Playwright (recommended)

**User Journeys:**
1. **League Secretary:**
   - Login → Create season → Add key dates → Add clubs → Approve clubs
   
2. **Club Secretary:**
   - Login → View dashboard → Add team → Request free day → View approval

3. **Age Group Manager:**
   - Login → View pending teams → Create divisions → Allocate teams

#### Component Tests (Target: All dashboard components)
**Tool:** React Testing Library

**Components to Test:**
- All 16 dashboard components
- Component registry resolution
- Dynamic dashboard rendering

**Action Required:**
1. Set up Vitest + Prisma test database
2. Write unit tests for import handlers
3. Write integration tests for key workflows
4. Set up Playwright for E2E tests
5. Achieve 80% coverage before production

---

### Phase 6: Documentation ⚠️ **30% COMPLETE**

**Existing Documentation:**
- ✅ `DYNAMIC_DASHBOARD_ARCHITECTURE.md` - Complete
- ✅ `key-dates-architecture.md` - Complete
- ✅ `LMSPRO_AGG_DIVISION_TERMINOLOGY.md` - Complete
- ✅ `LMSPRO_COMPONENT_CREATION_CHECKLIST.md` - Complete
- ✅ `FREEDAYS_IMPLEMENTATION_FIXES.md` - Complete
- ✅ `SEASONAL_WORKFLOW_ARCHITECTURE_CHANGE.md` - Complete
- ✅ `PROGRESS-REPORT-2026-01-11.md` - Outdated (this doc replaces it)

**Missing Documentation:**

#### User Guides (0%)
**Location:** `docs/00-READ_THIS/modules/lmspro/user-guides/`

**Needed Guides:**
1. ❌ **League Secretary Guide**
   - Creating seasons
   - Managing key dates
   - Approving clubs/teams
   - Managing divisions
   - Season rollover process

2. ❌ **Club Secretary Guide**
   - Registering club
   - Adding teams
   - Managing officials
   - Requesting free days
   - Viewing fixtures

3. ❌ **Age Group Manager Guide**
   - Creating divisions
   - Allocating teams
   - Managing age group teams
   - Viewing statistics

4. ❌ **Quick Start Guide**
   - New season setup checklist
   - Import process walkthrough
   - Common workflows

#### API Documentation (0%)
**Location:** `docs/00-READ_THIS/modules/lmspro/api/`

**Needed Docs:**
1. ❌ **Router Reference**
   - All endpoints documented
   - Input/output schemas
   - Permission requirements
   - Example usage

2. ❌ **Import System Guide**
   - CSV format specifications
   - Import order requirements
   - Error handling
   - Legacy key mapping

#### Developer Documentation (50%)
**Location:** `docs/00-READ_THIS/modules/lmspro/`

**Needed Docs:**
1. ✅ Architecture documentation (complete)
2. ❌ **Setup Guide** - Local development setup
3. ❌ **Testing Guide** - Running tests, writing tests
4. ❌ **Deployment Guide** - Production deployment checklist

**Action Required:**
1. Write user guides (prioritize League Secretary)
2. Document all API endpoints
3. Create CSV import templates
4. Write developer setup guide
5. Record video tutorials (optional)

---

## Production Readiness Checklist

### Critical (Must-Have for Feature Complete) 🚨

**Phase 1: Core Features (First)**

- [ ] **Venues Management** - Complete implementation
  - [ ] Create venues router
  - [ ] Build venues UI
  - [ ] Implement import handler
  - [ ] Test CRUD operations
  
- [ ] **Key Dates Visibility Engine** - Fix module role enforcement
  - [ ] Update visibility engine to use module role UUIDs
  - [ ] Implement Key Dates tab in Season page
  - [ ] Update VisibilityRulesEditor
  - [ ] Test with multiple roles
  
- [ ] **Testing Suite** - Achieve 80% coverage
  - [ ] Write unit tests for import handlers
  - [ ] Write integration tests for key workflows
  - [ ] Set up E2E tests
  - [ ] Document testing procedures

**Phase 2: Final Polish (After Feature Complete)**

- [ ] **Season Rollover** - Implement after all features complete
  - [ ] Create rollover mutation
  - [ ] Build rollover UI
  - [ ] Test with sample data
  - [ ] Document process
  - [ ] **Rationale:** Deferred to end since other features need rollover logic added
  
- [ ] **User Documentation** - Create after app is stable
  - [ ] League Secretary Guide
  - [ ] Club Secretary Guide
  - [ ] Quick Start Guide
  - [ ] API Reference
  - [ ] **Rationale:** Defer until app complete to avoid documentation rewrites

### High Priority (Should-Have) ⚠️

- [ ] **Referees Implementation** - Security-sensitive
  - [ ] Review encryption strategy
  - [ ] Implement referees router
  - [ ] Build referees UI
  - [ ] Test PII handling
  
- [ ] **Fixtures System** - Core feature
  - [ ] Design fixtures schema
  - [ ] Implement scheduling algorithm
  - [ ] Build fixture calendar UI
  - [ ] Test with real data
  
- [ ] **Email Integration** - Automated notifications
  - [ ] Complete module.config.ts
  - [ ] Implement userMetadataFilters
  - [ ] Create email templates
  - [ ] Test with Resend
  
- [ ] **Performance Testing** - Ensure scalability
  - [ ] Load testing with 100+ clubs
  - [ ] Database query optimization
  - [ ] Frontend rendering performance
  - [ ] Caching strategy

### Nice-to-Have (Could-Have) ✨

- [ ] **Advanced Season Rollover** - Automated scheduling
- [ ] **Fixture Optimization** - AI-powered scheduling
- [ ] **Mobile Responsive** - Improved mobile UX
- [ ] **Reporting Dashboard** - Analytics and insights
- [ ] **Export Features** - PDF reports, CSV exports
- [ ] **Notifications System** - Real-time alerts

---

## Estimated Effort & Timeline

### Critical Path (Feature Complete)

**Total: 5-7 weeks**

1. **Venues Management** - 1 week
   - Router + UI + import handler + tests

2. **Key Dates Visibility** - 2 weeks
   - Week 1: Fix visibility engine + module role logic
   - Week 2: UI implementation + comprehensive testing

3. **Referees Implementation** - 2 weeks
   - Security review + implementation + testing

4. **Fixtures System** - 3 weeks (can overlap with above)
   - Schema + algorithm + UI + testing

5. **Testing Suite** - 2 weeks (ongoing during above)
   - Week 1: Unit + integration tests
   - Week 2: E2E tests + documentation

### Final Polish (After Feature Complete)

**Total: 3-4 weeks**

1. **Season Rollover** - 2 weeks
   - Week 1: Backend implementation + testing (all features)
   - Week 2: UI implementation + comprehensive testing
   - **Deferred because:** Other features (venues, fixtures, referees) need rollover logic added

2. **User Documentation** - 1-2 weeks
   - Essential guides + API docs + video tutorials
   - **Deferred because:** App needs to be stable to avoid documentation rewrites

### Total Estimate: 8-11 weeks to production-ready

**Phased Rollout Recommendation:**
- **Phase 1 (Feature Complete):** Venues + Key Dates + Referees + Fixtures + Testing (5-7 weeks)
- **Phase 2 (Production Polish):** Season Rollover + User Documentation (3-4 weeks)
- **Phase 3:** Advanced features + optimizations (ongoing)

---

## Risk Assessment

### High Risk 🔴

1. **Key Dates Visibility Engine**
   - **Risk:** Module role logic incorrect, components visible when shouldn't be
   - **Impact:** Workflow gates ineffective, users can perform actions outside allowed windows
   - **Mitigation:** Comprehensive testing with multiple user roles, peer review of logic

2. **Season Rollover**
   - **Risk:** Data loss during rollover, incorrect archiving
   - **Impact:** Critical data loss, league operations disrupted
   - **Mitigation:** Transaction safety, rollback capability, extensive testing

3. **Referees PII Handling**
   - **Risk:** Unencrypted PII exposure, compliance violation
   - **Impact:** GDPR breach, legal consequences
   - **Mitigation:** Field-level encryption, strict RBAC, audit logging

### Medium Risk 🟡

1. **Import System**
   - **Risk:** Legacy key mapping failures, data corruption
   - **Impact:** Import failures, manual data entry required
   - **Mitigation:** Comprehensive validation, dry-run mode, error reporting

2. **Fixtures Scheduling**
   - **Risk:** Algorithm complexity, performance issues
   - **Impact:** Slow fixture generation, poor quality schedules
   - **Mitigation:** Algorithm testing, optimization, manual override capability

3. **Email Integration**
   - **Risk:** Spam filtering, delivery failures
   - **Impact:** Users don't receive critical notifications
   - **Mitigation:** Resend deliverability best practices, retry logic

### Low Risk 🟢

1. **Documentation**
   - **Risk:** Incomplete or unclear documentation
   - **Impact:** User confusion, support burden
   - **Mitigation:** User testing, feedback incorporation, video tutorials

2. **UI/UX**
   - **Risk:** Unintuitive interfaces, poor mobile support
   - **Impact:** User frustration, adoption resistance
   - **Mitigation:** User testing, iterative improvements

---

## Success Criteria

### Phase 1 (MVP) Success Metrics

1. **Functional Completeness**
   - ✅ All critical features implemented
   - ✅ No production blockers remaining
   - ✅ 80%+ test coverage

2. **User Adoption**
   - ✅ 3+ leagues onboarded successfully
   - ✅ Season rollover completed without issues
   - ✅ <5% support ticket rate per user

3. **Performance**
   - ✅ Page load times <2 seconds
   - ✅ API response times <500ms
   - ✅ Import success rate >95%

4. **Documentation**
   - ✅ All user guides complete
   - ✅ API documentation complete
   - ✅ Developer setup documented

### Phase 2 Success Metrics

1. **Advanced Features**
   - ✅ Referees management operational
   - ✅ Fixtures system generating schedules
   - ✅ Email notifications working

2. **Scalability**
   - ✅ 100+ clubs supported
   - ✅ 1000+ teams supported
   - ✅ No performance degradation

3. **Quality**
   - ✅ <1% bug rate
   - ✅ Zero security incidents
   - ✅ >90% user satisfaction

---

## Conclusion

LMSPro has a **solid foundation (35% complete)** with core CRUD, dynamic dashboard architecture, and key workflow features implemented. However, **critical production blockers remain**:

1. Season rollover (essential for yearly operations)
2. Venues management (required for fixtures)
3. Key Dates visibility enforcement (workflow gates not working)
4. Comprehensive testing (currently minimal)
5. User documentation (no guides exist)

**Recommended Path Forward:**

1. **Immediate Focus (Next 2 weeks):** Fix Key Dates visibility engine + Venues Management
2. **Next Priority (Weeks 3-4):** Referees implementation + testing suite foundation
3. **Feature Complete (Weeks 5-7):** Fixtures system + comprehensive testing
4. **Production Polish (Weeks 8-11):** Season Rollover (all features) + User Documentation
5. **Deploy to Production:** After Phase 2 complete and tested

With focused effort, LMSPro can reach **feature-complete status in 5-7 weeks** and **production-ready status in 8-11 weeks**.

**Key Changes from Original Plan:**
- **Season Rollover deferred to end** - Needs all features implemented first before rollover logic can be comprehensive
- **User Documentation deferred to end** - Prevents documentation rewrites as features stabilize
- **Fixtures moved up** - Core feature needed before rollover testing

---

**Document Status:** ✅ Updated - Phasing adjusted per user feedback  
**Last Updated:** February 2, 2026  
**Next Review:** After app review on techtest environment
