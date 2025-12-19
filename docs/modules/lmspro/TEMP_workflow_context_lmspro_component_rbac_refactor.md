# TEMP: LMSPro Component-Based RBAC Refactor - Workflow Context

**Status:** IN PROGRESS - Architecture Pivot During Phase 1.5  
**Date Started:** 2025-12-19  
**Branch:** dev  
**Last Commit:** ad79646 (Task 6 complete - Dynamic League Dashboard)  

---

## Current Status Summary

**✅ COMPLETED:**
- Tasks 1-5: Phase 1.5 foundation (schema, helpers, routers, UI, seeding)
- Tasks 5.5-5.9: Component-Based RBAC refactor (schema migration, seed migration, resolution logic, role CRUD, role helpers)
- Task 6: Dynamic League Dashboard with component registry

**⏳ REMAINING:**
- Task 7: Club Home Page
- Task 8: Update Existing Routers (replace requireRole with hasComponentAccess)
- Task 9: Seed Test Users

---

## What Happened: The Architecture Pivot

**Phase 1.5 was building:** Basic role-based dashboard with hardcoded enum roles  
**Discovery:** Need flexible, tenant-customizable role system for mass-customization SaaS  
**Decision:** Pause at Task 5, refactor to Component-Based RBAC architecture, then complete Phase 1.5 with proper foundation

**Why Now:**
- Pre-launch (no migration debt)
- Task 6 (dynamic dashboard) is EXACTLY what new architecture enables
- LMSPro is reference implementation for all future modules
- Extra 1-2 days now saves weeks of refactor later

---

## Where We Are: Completed Work (Tasks 1-5)

### ✅ Completed and KEEPING:

**Task 1: Schema (RBAC fields added)** - commit 0cf7201
- ✅ `User.lmsproLeagueRoles String[]` - **WILL DEPRECATE but keep temporarily**
- ✅ `User.lmsproClubRole String?` - **WILL DEPRECATE but keep temporarily**
- ✅ `User.lmsproClubId String?` - **WILL DEPRECATE but keep temporarily**
- ✅ `UserStatus` enum (PENDING_PASSWORD_RESET, GDPR_DELETE_REQUESTED)
- ✅ `LMSProLeagueRole` enum (13 roles) - **WILL USE as template seed data**
- ✅ `LMSProClubRole` enum (4 roles) - **WILL USE as template seed data**

**Task 2: Role Helpers** - commit 0cf7201
- ✅ `src/modules/lmspro/lib/roles.ts` (446 lines)
- ✅ 30+ permission functions
- **STATUS:** Will need updates to work with role UUIDs instead of enum strings

**Task 3: User CRUD Routers** - commit 5222d2b
- ✅ `src/modules/lmspro/routers/users.router.ts` (729 lines)
- ✅ 9 endpoints (list, get, create, update, delete, gdprBatchDelete, resendPasswordReset, listByClub)
- **STATUS:** Will need updates to assign role UUIDs instead of enum values

**Task 4: User Management UI** - commit 0af204e
- ✅ `src/app/(app)/app/lmspro/admin/users/page.tsx`
- ✅ Follows UX Standard Section 7.1 (click-to-view-and-edit, NO ICONS)
- ✅ Search + sort controls
- ✅ CRUD modal with role multi-select
- **STATUS:** Will need updates to load/assign role UUIDs from ModuleRole table

**Task 5: Component Catalog Seeding** - commit e6323ad
- ✅ `prisma/seed.ts` - 20 LMSProPageComponent records
- ✅ Platform defaults seeded (organizationId = null)
- ✅ LEAGUE_DASHBOARD (17 components)
- ✅ CLUB_DASHBOARD (3 components)
- **STATUS:** Will migrate to ComponentDefinition model with new fields

---

## What Needs Refactoring: New Architecture

### 📋 Reference Documents (READ THESE FIRST):

1. **[Component-Based RBAC (Authoritative)](/docs/core/component-based-rbac.md)**
   - Complete architecture specification
   - Database schema
   - Resolution algorithm
   - Stage 1 implementation guide

2. **[Two-Tier Three-Scope Components](/docs/00-overview/ui_ux_components/two_tier_three_scope_components.md)**
   - Conceptual model
   - Tier 1 vs Tier 2 RBAC
   - Core → Module → Tenant scopes

3. **[IsoStack UX Standard](/docs/00-overview/ui_ux_components/isostack-ux-ui-standard.md)**
   - Section 7.1: Click-to-View-and-Edit pattern (already followed in Task 4)
   - Section 7.4: Universal table controls (already followed)

---

## NEW TASKS: Refactor to Component-Based RBAC

### Task 5.5: Schema Migration ⏳ NOT STARTED

**Goal:** Update Prisma schema with new architecture

**Files to Edit:**
- `prisma/schema.prisma`

**Changes Required:**

1. **Rename LMSProPageComponent → ComponentDefinition**
   ```prisma
   // OLD (lmspro schema):
   model LMSProPageComponent { ... }
   
   // NEW (public schema - shared across modules):
   model ComponentDefinition {
     id              String   @id @default(uuid())
     
     // NEW FIELDS:
     moduleKey       String?  // null = Core, "lmspro" = Module
     scope           ComponentScope  // CORE | MODULE | TENANT
     overridesId     String?  // Points to parent component
     capability      ComponentCapability @default(VIEW)
     grantsActions   String[] @default([])
     featureFlagKey  String?
     createdBy       String?
     
     // RENAMED FIELDS:
     organizationId  String?  // (was organization_id)
     componentKey    String   // (was component_key)
     title           String   // (was title, keep)
     description     String?  // (keep)
     pageContext     String   // (was page_context)
     componentType   String   // (was component_type)
     sortOrder       Int      // (was sort_order)
     isEnabled       Boolean  // (was isActive → rename)
     config          Json?    // (keep)
     
     // REMOVE FIELD:
     // requiredRoles   String[]  ← DELETE (moves to ModuleRole)
     
     // NEW RELATIONS:
     overrides       ComponentDefinition? @relation("ComponentOverride", fields: [overridesId], references: [id])
     overriddenBy    ComponentDefinition[] @relation("ComponentOverride")
     
     @@map("component_definitions")
     @@schema("public")  // ← MOVE to public schema (shared)
   }
   
   enum ComponentScope {
     CORE
     MODULE
     TENANT
   }
   
   enum ComponentCapability {
     VIEW    // Phase 1: implies actions
     ACTION  // Phase 2: explicit mutation
     MANAGE  // Phase 2: full CRUD
   }
   ```

2. **Create ModuleRole table**
   ```prisma
   model ModuleRole {
     id              String   @id @default(uuid())
     
     moduleKey       String   // "lmspro", "bedrock"
     organizationId  String?  // null = platform template
     
     name            String   // "League Secretary"
     description     String?
     
     componentKeys   String[] @default([])  // Granted components
     
     isActive        Boolean  @default(true)
     isSystemDefault Boolean  @default(false)
     
     createdAt       DateTime @default(now())
     updatedAt       DateTime @updatedAt
     createdBy       String?
     
     organization    Organization? @relation(fields: [organizationId], references: [id], onDelete: Cascade)
     
     @@unique([organizationId, moduleKey, name])
     @@index([moduleKey, organizationId, isActive])
     @@map("module_roles")
     @@schema("public")
   }
   ```

3. **Update User model**
   ```prisma
   model User {
     // ... existing fields
     
     // ADD NEW FIELDS:
     lmsproRoleIds    String[] @default([])
     bedrockRoleIds   String[] @default([])
     
     // KEEP BUT DEPRECATE (backward compatibility during migration):
     lmsproLeagueRoles String[] @default([])
     lmsproClubRole    String?
     lmsproClubId      String?
   }
   ```

**Migration Steps:**
1. Update schema.prisma with changes above
2. Run `npm run db:push` (dev environment - no formal migration)
3. Database will auto-create new tables, add fields
4. Old LMSProPageComponent data will be lost (acceptable - seed data is disposable)

---

### Task 5.6: Seed Data Migration ⏳ NOT STARTED

**Goal:** Migrate seed data to new ComponentDefinition + ModuleRole structure

**Files to Edit:**
- `prisma/seed.ts`

**Changes Required:**

1. **Update cleanup section:**
   ```typescript
   // OLD:
   await prisma.$executeRaw`DELETE FROM lmspro.lmspro_page_components`;
   
   // NEW:
   await prisma.componentDefinition.deleteMany({ 
     where: { moduleKey: 'lmspro' } 
   });
   await prisma.moduleRole.deleteMany({ 
     where: { moduleKey: 'lmspro' } 
   });
   ```

2. **Seed platform role templates (NEW):**
   ```typescript
   // After organization creation, before component seeding
   
   console.log('🎭 Creating LMSPro role templates...');
   
   const roleLeagueSecretary = await prisma.moduleRole.create({
     data: {
       moduleKey: 'lmspro',
       organizationId: null,  // Platform template
       isSystemDefault: true,
       name: 'League Secretary',
       description: 'Full access to league management',
       componentKeys: [
         'clubs.list.view',
         'clubs.pending.view',
         'teams.list.view',
         'teams.pending.view',
         'season.overview.view',
         'quick.stats.view'
       ]
     }
   });
   
   const roleTreasurer = await prisma.moduleRole.create({
     data: {
       moduleKey: 'lmspro',
       organizationId: null,
       isSystemDefault: true,
       name: 'Treasurer',
       description: 'Financial oversight and reporting',
       componentKeys: [
         'financial.summary.view',
         'season.overview.view'
       ]
     }
   });
   
   // Create role for each age group manager (U7-U13)
   const ageGroupRoles = ['U7', 'U8', 'U9', 'U10', 'U11', 'U12', 'U13'].map(ag => ({
     moduleKey: 'lmspro',
     organizationId: null,
     isSystemDefault: true,
     name: `Age Group Manager ${ag}`,
     description: `Manages ${ag} team approvals`,
     componentKeys: [
       `teams.${ag.toLowerCase()}.pending.view`,
       'season.overview.view',
       'quick.stats.view'
     ]
   }));
   
   await prisma.moduleRole.createMany({ data: ageGroupRoles });
   
   // Add more roles: Safeguarding Officer, Venue Coordinator, Referee Coordinator
   
   console.log('✅ LMSPro role templates created (16 roles)');
   ```

3. **Migrate component seed data:**
   ```typescript
   // OLD:
   await prisma.lMSProPageComponent.createMany({ data: [...] });
   
   // NEW:
   await prisma.componentDefinition.createMany({
     data: [
       {
         moduleKey: 'lmspro',
         scope: 'MODULE',
         organizationId: null,  // Platform default
         
         componentKey: 'clubs.pending.view',  // NEW naming convention
         capability: 'VIEW',
         
         title: 'Pending Club Approvals',
         description: 'Clubs waiting for approval to join the league',
         pageContext: 'LEAGUE_DASHBOARD',
         componentType: 'TABLE',
         sortOrder: 1,
         isEnabled: true,
       },
       // ... convert all 20 existing components
     ]
   });
   ```

**Component Key Migration Map:**
```
OLD → NEW (domain.object.capability pattern)

pending-club-approvals     → clubs.pending.view
pending-team-approvals     → teams.pending.view
all-clubs                  → clubs.list.view
all-teams                  → teams.list.view
financial-summary          → financial.summary.view
safeguarding-dashboard     → safeguarding.dashboard.view
venue-management           → venues.management.view
referee-pool               → referees.pool.view
u7-team-approvals          → teams.u7.pending.view
u8-team-approvals          → teams.u8.pending.view
u9-team-approvals          → teams.u9.pending.view
u10-team-approvals         → teams.u10.pending.view
u11-team-approvals         → teams.u11.pending.view
u12-team-approvals         → teams.u12.pending.view
u13-team-approvals         → teams.u13.pending.view
season-overview            → season.overview.view
quick-stats                → quick.stats.view
club-teams                 → club.teams.view
club-officials             → club.officials.view
club-payments              → club.payments.view
```

4. **Test seed:**
   ```bash
   npm run db:seed
   ```

---

### Task 5.7: Component Resolution Logic ⏳ NOT STARTED

**Goal:** Build resolution algorithm for effective components

**Files to Create:**
- `src/modules/lmspro/lib/componentResolution.ts`

**Reference:** See [component-based-rbac.md § Resolution Algorithm](/docs/core/component-based-rbac.md#resolution-algorithm)

**Functions to Build:**

```typescript
// Core resolution function
export async function getEffectiveComponents(
  userId: string,
  moduleKey: string,
  pageContext: string
): Promise<ComponentDefinition[]>;

// Helper: Resolve with tenant overrides
async function resolveComponents(
  organizationId: string,
  moduleKey: string,
  pageContext: string,
  componentKeys: string[]
): Promise<ComponentDefinition[]>;

// Helper: Check if user has component access
export async function hasComponentAccess(
  userId: string,
  moduleKey: string,
  componentKey: string
): Promise<boolean>;
```

**tRPC Router:**
- `src/modules/lmspro/routers/components.router.ts`
- Endpoints: `listForUser`, `listAll`, `override`, `resetToDefault`

---

### Task 5.8: Role CRUD ⏳ NOT STARTED

**Goal:** Build role management UI and API

**Files to Create:**

1. **tRPC Router:** `src/modules/lmspro/routers/roles.router.ts`
   - Endpoints: `list`, `get`, `create`, `update`, `delete`, `cloneTemplate`

2. **Role Management Page:** `src/app/(app)/app/lmspro/admin/roles/page.tsx`
   - List platform templates (read-only)
   - List tenant custom roles (editable)
   - Create/edit modal with component checklist
   - "Clone from template" feature
   - "Reset to template" destructive action

3. **Update User Management Page:** `src/app/(app)/app/lmspro/admin/users/page.tsx`
   - Replace enum role dropdowns with ModuleRole selection
   - Load roles from `trpc.lmspro.roles.list.useQuery()`
   - Save `user.lmsproRoleIds` instead of enum arrays

**Reference:** [component-based-rbac.md § Developer Guide](/docs/core/component-based-rbac.md#developer-guide)

---

### Task 5.9: Update Role Helpers ⏳ NOT STARTED

**Goal:** Make role helpers work with UUIDs instead of enums

**Files to Update:**
- `src/modules/lmspro/lib/roles.ts` (446 lines - already exists)

**Changes Required:**

1. **Update LMSProUser type:**
   ```typescript
   // OLD:
   type LMSProUser = {
     lmsproLeagueRoles: string[];  // Enum values
     lmsproClubRole: string | null;
   };
   
   // NEW:
   type LMSProUser = {
     lmsproRoleIds: string[];  // Role UUIDs
     organizationId: string;
   };
   ```

2. **Refactor permission checks to query ModuleRole:**
   ```typescript
   // OLD:
   export function hasLeagueRole(user: LMSProUser, role: string) {
     return user.lmsproLeagueRoles.includes(role);
   }
   
   // NEW:
   export async function hasComponentAccess(
     user: LMSProUser,
     componentKey: string
   ): Promise<boolean> {
     const roles = await prisma.moduleRole.findMany({
       where: { id: { in: user.lmsproRoleIds } }
     });
     return roles.some(r => r.componentKeys.includes(componentKey));
   }
   ```

3. **Keep backward compatibility helpers temporarily:**
   ```typescript
   // For migration period - convert enum to role lookup
   export async function migrateEnumToRoleIds(
     organizationId: string,
     enumRoles: string[]
   ): Promise<string[]> {
     const roles = await prisma.moduleRole.findMany({
       where: {
         organizationId,
         name: { in: enumRoles }
       }
     });
     return roles.map(r => r.id);
   }
   ```

---

## ORIGINAL TASKS: Complete After Refactor

### Task 6: Dynamic League Dashboard ✅ COMPLETE (commit ad79646)

**NOW BUILDS ON:** Component resolution system

**Files Created:**
- `src/app/(app)/app/lmspro/dashboard/page.tsx` - Dynamic dashboard using component resolution
- `src/modules/lmspro/components/ComponentRenderer.tsx` - Renders components based on definitions
- `src/modules/lmspro/components/registry.tsx` - Maps componentKeys to React components
- `src/modules/lmspro/components/dashboard/PendingClubsTable.tsx`
- `src/modules/lmspro/components/dashboard/PendingTeamsTable.tsx`
- `src/modules/lmspro/components/dashboard/AllClubsList.tsx`
- `src/modules/lmspro/components/dashboard/AllTeamsList.tsx`
- `src/modules/lmspro/components/dashboard/QuickStats.tsx`
- `src/modules/lmspro/components/dashboard/SeasonOverview.tsx`
- `src/modules/lmspro/components/dashboard/FinancialSummary.tsx`

**Implementation:**
```typescript
export default function LeagueDashboard() {
  const { data: components } = trpc.lmspro.components.listForUser.useQuery({
    pageContext: 'LEAGUE_DASHBOARD'
  });
  
  return (
    <Container>
      <Title>League Dashboard</Title>
      <SimpleGrid cols={{ base: 1, md: 2, lg: 3 }}>
        {components?.map(comp => (
          <ComponentRenderer 
            key={comp.id} 
            component={comp} 
          />
        ))}
      </SimpleGrid>
    </Container>
  );
}
```

**Component Registry:**
- Maps componentKey → React component
- Example: `'clubs.pending.view': PendingClubsTable`
- 7 dashboard components implemented
- Shows "Coming Soon" placeholder for unimplemented components

**Status:** Dashboard navigation added to LMSPro main page. Fully functional role-based rendering.

---

### Task 7: Club Home Page ⏳ NOT STARTED

**File to Create:**
- `src/app/(app)/app/lmspro/club/[clubId]/page.tsx`

**Implementation:**
- Similar to Task 6, but `pageContext: 'CLUB_DASHBOARD'`
- Club-scoped data only
- Auto-redirect club secretaries here from main dashboard

---

### Task 8: Update Existing Routers ⏳ NOT STARTED

**Files to Update:**
- `src/modules/lmspro/routers/seasons.router.ts`
- `src/modules/lmspro/routers/clubs.router.ts`
- `src/modules/lmspro/routers/teams.router.ts`
- `src/modules/lmspro/routers/age-groups.router.ts`

**Changes:**
- Replace `requireRole([Role.ADMIN])` with component/action checks
- Use `hasComponentAccess()` helper
- Keep Tier 1 RBAC (organizationId scoping)

---

### Task 9: Seed Test Users ⏳ NOT STARTED

**File to Update:**
- `prisma/seed.ts`

**Add Test Users:**
```typescript
// Platform admin (already exists)
// chris@isoblue.com

// League Secretary
const leagueSecretary = await prisma.user.create({
  data: {
    email: 'secretary@djfl.com',
    name: 'League Secretary',
    organizationId: acme.id,
    role: Role.ADMIN,
    lmsproRoleIds: [roleLeagueSecretary.id],
    // ... hash password
  }
});

// Age Group Manager
const ageGroupManager = await prisma.user.create({
  data: {
    email: 'u9manager@djfl.com',
    name: 'U9 Age Group Manager',
    organizationId: acme.id,
    role: Role.MEMBER,
    lmsproRoleIds: [roleU9Manager.id],
  }
});

// Club Secretary
const clubSecretary = await prisma.user.create({
  data: {
    email: 'jane@rangers.com',
    name: 'Jane Doe',
    organizationId: acme.id,
    role: Role.MEMBER,
    lmsproRoleIds: [roleClubSecretary.id],
  }
});
```

---

## Testing Checklist

After completing all tasks:

- [ ] Run `npm run db:push` successfully
- [ ] Run `npm run db:seed` successfully
- [ ] Login as chris@isoblue.com (platform admin)
- [ ] Login as secretary@djfl.com (league secretary)
- [ ] Verify dashboard shows different components per role
- [ ] Create custom role as tenant admin
- [ ] Assign custom role to user
- [ ] Verify user sees correct components
- [ ] Override component metadata (rename title)
- [ ] Verify override appears for all users
- [ ] Reset override to default
- [ ] Verify module default restored
- [ ] Run `npx tsc --noEmit` (no TypeScript errors)

---

## Key Files Reference

**Schema:**
- `prisma/schema.prisma` - Lines 1681-1710 (LMSProPageComponent - OLD)

**Seed:**
- `prisma/seed.ts` - Lines 1267-1467 (LMSPro section with component seeding)

**Existing Code (keeping):**
- `src/modules/lmspro/lib/roles.ts` (446 lines - needs updates)
- `src/modules/lmspro/routers/users.router.ts` (729 lines - needs updates)
- `src/app/(app)/app/lmspro/admin/users/page.tsx` (needs updates)

**Phase 0-1 Routers (keeping, will update in Task 8):**
- `src/modules/lmspro/routers/seasons.router.ts` (358 lines)
- `src/modules/lmspro/routers/clubs.router.ts` (288 lines)
- `src/modules/lmspro/routers/teams.router.ts` (420 lines)
- `src/modules/lmspro/routers/age-groups.router.ts` (641 lines)

**Phase 0-1 Pages (keeping, no changes needed):**
- `src/app/(app)/app/lmspro/page.tsx` (module dashboard)
- `src/app/(app)/app/lmspro/seasons/page.tsx` (320 lines)
- `src/app/(app)/app/lmspro/clubs/page.tsx` (380 lines)
- `src/app/(app)/app/lmspro/teams/page.tsx` (491 lines)

---

## Critical Reminders

1. **Phase 1: VIEW = ACTION** - Don't overcomplicate with action grants yet
2. **Keep deprecated fields temporarily** - For backward compatibility during migration
3. **Seed is disposable** - No migration scripts needed, just re-seed
4. **Follow naming convention** - `domain.object.capability` for all component keys
5. **Test each task** - Run seed + dev server after each completed task
6. **UX Standard compliance** - Section 7.1 (click-whole-row), Section 7.4 (search+sort)

---

## When You Return to This Work

**Start here:**
1. Read this document (you're here!)
2. Read [component-based-rbac.md](/docs/core/component-based-rbac.md) (full architecture)
3. Check `git log --oneline` to see what's committed
4. Start with Task 5.5 (schema migration)
5. Work sequentially through tasks 5.5 → 5.9 → 6 → 7 → 8 → 9

**Git Branch:** dev  
**Last Commit:** e6323ad (Task 5 complete)  
**Next Commit:** Task 5.5 (schema migration)

---

**This document will be deleted after Phase 1.5 is complete.**  
**All permanent documentation lives in `/docs/core/component-based-rbac.md`**


# **Note from the Architect: Time-Based Component Visibility**

**Requirement:** Component visibility needs time/date scoping for LMSPro (and likely other modules).

**Example:** "Team Registration" component should only be visible:
- Between `Season.registrationStartDate` and `Season.registrationEndDate`
- For club users only (league admins always see it)

**Impact on Current Refactor:** NONE - Phase 1 proceeds as planned.

**Phase 2 Enhancement:** Add `visibilityRules Json?` field to ComponentDefinition model.

**Example Rule Structure:**
```json
{
  "type": "date_range",
  "startField": "season.registrationStartDate",
  "endField": "season.registrationEndDate",
  "applyToRoles": ["Club Secretary", "Club Treasurer"],
  "exemptRoles": ["League Secretary", "Assistant Secretary"]
}
```

**Resolution Logic Update:**
```typescript
// Phase 1 (current):
getEffectiveComponents(userId, moduleKey, pageContext)

// Phase 2 (with rules):
getEffectiveComponents(userId, moduleKey, pageContext, {
  season: currentSeason,  // Provides date fields for rule evaluation
  club: userClub
})
```

**Temporary Workaround (Phase 1):** Components check dates in their own code:
```typescript
// Inside TeamRegistrationWidget.tsx
const { data: season } = trpc.lmspro.seasons.getCurrent.useQuery();
const isWithinWindow = season && 
  new Date() >= season.registrationStart && 
  new Date() <= season.registrationEnd;

if (!isWithinWindow && !isLeagueAdmin) return null;
```

**Migration Path:**
1. Phase 1: Ship without time rules (manual checks in components)
2. Phase 2a: Add `visibilityRules` field to schema
3. Phase 2b: Update `getEffectiveComponents()` to evaluate rules
4. Phase 2c: Migrate hardcoded date checks to visibility rules
5. Phase 2d: Add UI for admins to configure rules (advanced feature)

**Other Potential Rule Types:**
- `season_phase`: "only during season" vs "only in off-season"
- `capacity_limit`: "hide when max teams reached"
- `feature_flag`: "show only if feature X enabled"
- `custom_function`: "call registered validation function"

This is noted for future implementation. **Phase 1 refactor continues as planned.** 

Notes following F**k up.

What I Now Understand (Critical Correction)
TIER 1: Core IsoStack Security RBAC (Platform Level)
Purpose: Authentication, organization boundaries, data isolation
Enforcement: requireRole([Role.ADMIN, Role.OWNER]) checks User.role (C1/C2/C3)
Scope: Platform-wide, applies to ALL modules

Core's responsibilities:

✅ User authentication (magic link, WebAuthn, OAuth)
✅ Multi-tenancy isolation (organizationId scoping)
✅ Platform admin access (P1 impersonation)
✅ Organization management (create/delete orgs, billing)
✅ User CRUD (C1/C2 manage organization users)
✅ Feature flags (enable/disable modules per org)
Core NEVER:

❌ Knows about LMSPro clubs, teams, seasons
❌ Defines module-specific permissions
❌ Controls which dashboard components users see
❌ Manages module business logic
TIER 2: Module UX Composition RBAC (Feature Level)
Purpose: Feature visibility, workflow access, granular module permissions
Enforcement: hasComponentAccess(userId, 'lmspro', componentKey) checks User.lmsproRoleIds → ModuleRole.componentKeys
Scope: Per-module, tenant-customizable

Module's responsibilities:

✅ Define components (clubs.approve.view, teams.manage, etc.)
✅ Create role templates ("League Secretary", "Treasurer", "Age Group Manager U9")
✅ Check component access for feature gates
✅ Render dynamic dashboards based on user's components
✅ Allow tenant admins to create custom roles
Modules NEVER:

❌ Bypass organizationId scoping (always enforced by Tier 1)
❌ Grant cross-organization access
❌ Control Core platform features (user management, billing)
The Problem With Current LMSPro Routers
What's happening:

Why this is wrong:

Module operations should NOT care about Core roles (C1/C2/C3)
A C3 user with "League Secretary" LMSPro role SHOULD be able to approve clubs
A C2 user with NO LMSPro roles should NOT see LMSPro features
Using Core roles for module features breaks the Two-Tier architecture
What should happen:

The Correct Architecture Flow
P1 (Platform Admin):

Impersonates C1 user via Core authentication
Inherits C1's organizationId (Tier 1 boundary enforced)
Inherits C1's lmsproRoleIds (Tier 2 permissions)
Sees same LMSPro components as C1
C1 (Organization Owner - role: OWNER):

Tier 1: Can manage users, org settings, billing (Core functions)
Tier 2: Needs lmsproRoleIds assigned (e.g., "League Administrator" role)
Without LMSPro roles: Can't access LMSPro features (correct!)
With "League Administrator" role: Has full LMSPro access via componentKeys
C2 (Organization Admin - role: ADMIN):

Tier 1: Can manage users, org settings (but not billing)
Tier 2: May or may not have LMSPro access (depends on assigned roles)
Could have "Treasurer" role (financial view only)
Could have NO LMSPro roles (can't see module at all)
C3 (Organization Member - role: MEMBER):

Tier 1: Standard user access (can't manage users/org)
Tier 2: Can have powerful LMSPro roles! ("League Secretary", "Age Group Manager")
Core role (C3) doesn't limit module capabilities
Component-based permissions determine feature access
What Task 8 Actually Needs to Do
Add MANAGE component definitions for CRUD operations
Create "League Administrator" platform role template with all componentKeys
Refactor 23 mutation endpoints to use hasComponentAccess() instead of requireRole()
Update seed data to assign C1 users the "League Administrator" role
Keep ALL Tier 1 scoping (organizationId checks remain unchanged)
