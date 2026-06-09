# Time-Sensitive Permissions Architecture

**Status:** SUPERSEDED - See Key Dates Architecture  
**Module:** LMSPro  
**Date:** January 2026  
**Superseded By:** `key-dates-architecture.md`

---

## ⚠️ IMPORTANT: This Document is Outdated

This document describes the original fixed-field approach to season dates. That approach has been **replaced** by the **Key Dates** system, which provides:

- ✅ Flexible, user-defined date ranges instead of hardcoded fields
- ✅ Reusable key date names across season rollovers
- ✅ Table CRUD interface for managing dates
- ✅ Integration with visibility rules via `keyDateId` references

**See:** `key-dates-architecture.md` for the current implementation plan.

---

## Overview (Historical)

This document outlines the **original time-sensitive permission** system for LMSPro - a framework for enforcing seasonal workflow gates based on fixed date fields on the `LMSProSeason` model. This approach was replaced by the Key Dates system for better flexibility and reusability.

---

## Two-Dimensional Permission Model

LMSPro operations require validation across TWO dimensions:

### 1. Role-Based Permissions ("By Whom") ✅ IMPLEMENTED

**Current State:** Fully functional via module component system

- **C1 (League Owner/Administrator):** Full control at all times
  - Components: `teams.manage`, `teams.allocate`, `seasons.manage`, etc.
  - Can override seasonal restrictions (god-mode for league administration)

- **C2 (Club Roles):** Restricted by module access
  - Components: `clubs.teams.view`, `clubs.manage`, etc.
  - Subject to seasonal workflow gates (when implemented)

**Implementation:**
- Module: `lmspro`
- Role Templates: League Administrator, Club Secretary, etc.
- Permission Check: `hasComponentAccess(userId, 'lmspro', 'teams.manage')`

---

### 2. Time-Sensitive Permissions ("When") ⚠️ NOT YET IMPLEMENTED

**Concept:** Certain operations are only permitted during specific seasonal windows, controlled by date fields on `LMSProSeason`.

**Why Delayed?**
To avoid premature complexity before core data model is stable. Phase 2 ensures the structure supports this when ready.

---

## Season Date Fields (Temporal Gates)

The `LMSProSeason` model includes extensive date fields that will eventually gate operations:

### League-Level Dates
```typescript
leagueAgeGroupsConfirms: Date?          // When league confirms age groups
leagueCreateAggsBy: Date?                // Deadline to create AGGs
leagueAllocateTeamsToAggs: Date?         // Deadline to allocate teams
leagueAggsLocked: Date?                  // AGGs become immutable
leagueNewClubRegistrationOpens: Date?
leagueNewClubRegistrationCloses: Date?
leagueNewClubCreationDeadline: Date?
```

### Club-Level Dates
```typescript
clubArchiveTeams: Date?                  // Archive previous season teams
clubSeasonMembershipConfirmation: Date?
clubConfirmOfficials: Date?
clubTeamArchive: Date?
clubConfirmExistingTeams: Date?
clubConfirmNewTeamAdditions: Date?       // Window to add new teams
clubConfirmTeamManagers: Date?
clubFinaliseTeamNamesAgeGroups: Date?    // Window to change age groups
clubTeamsLocked: Date?                   // Teams become immutable
```

---

## Use Case: Team Age Group Changes

**Business Rule:**
- Teams age up each season (U7 → U8) - this is normal
- Clubs need to update age groups but only during a specific window
- League administrators can override at any time

### Phase 2 Implementation (Current)

**What's Enabled:**
- Backend: `teams.update` mutation accepts `ageGroup` field
- Frontend: Age group dropdown visible in edit modal
- Validation: New age group must exist in season
- Business logic: AGG allocation cleared if age group changes

**What's NOT Enforced:**
- No date-based restrictions (any user with `teams.manage` can change at any time)
- No seasonal workflow gates
- No audit trail of workflow violations

**Example Code (Phase 2):**
```typescript
// Current: Only checks role-based permission
const hasAccess = await hasComponentAccess(
  ctx.session!.user.id,
  'lmspro',
  'teams.manage' // ✅ Checks role
);

// Anyone with teams.manage can change age group
if (input.ageGroup) {
  // Validate age group exists
  // Update team.ageGroup and team.ageGroupId
  // Clear AGG allocation
}
```

---

## Future Implementation (Phase 4/5)

### Proposed Time-Sensitive Permission Check

```typescript
// Future: Checks BOTH role and temporal permissions
async function canPerformOperation(
  userId: string,
  operation: string, // e.g., 'teams.changeAgeGroup'
  seasonId: string
): Promise<boolean> {
  // 1. Check role-based permission
  const hasRoleAccess = await hasComponentAccess(userId, 'lmspro', 'teams.manage');
  if (!hasRoleAccess) return false;

  // 2. Check if user is C1 (League Owner) - bypasses time restrictions
  const isLeagueAdmin = await hasComponentAccess(userId, 'lmspro', 'seasons.manage');
  if (isLeagueAdmin) return true; // God-mode

  // 3. Check temporal permission for C2 (Club) users
  const season = await prisma.lMSProSeason.findUnique({
    where: { id: seasonId },
    select: { clubFinaliseTeamNamesAgeGroups: true, clubTeamsLocked: true },
  });

  const now = new Date();
  
  // Example: Age groups can only be changed before clubFinaliseTeamNamesAgeGroups
  if (operation === 'teams.changeAgeGroup') {
    if (season.clubTeamsLocked && now > season.clubTeamsLocked) {
      return false; // Teams are locked
    }
    if (season.clubFinaliseTeamNamesAgeGroups && now > season.clubFinaliseTeamNamesAgeGroups) {
      return false; // Age group window closed
    }
  }

  return true;
}
```

### Usage in Mutation

```typescript
// teams.router.ts - update mutation
if (input.ageGroup) {
  const canChange = await canPerformOperation(
    ctx.session!.user.id,
    'teams.changeAgeGroup',
    existingTeam.seasonId
  );

  if (!canChange) {
    throw new TRPCError({
      code: 'FORBIDDEN',
      message: 'Age group changes are not permitted at this stage of the season',
    });
  }

  // Proceed with age group change...
}
```

---

## Workflow Stages (Example)

### Stage 1: Season Setup (League Admin Only)
- Create season
- Define age groups
- Set all workflow dates
- **Operations:** Full control, no restrictions

### Stage 2: Club Registration Window
- **Opens:** `leagueNewClubRegistrationOpens`
- **Closes:** `leagueNewClubRegistrationCloses`
- **Operations:** Clubs can register, submit officials

### Stage 3: Team Submission Window
- **Opens:** `clubConfirmNewTeamAdditions`
- **Closes:** `clubFinaliseTeamNamesAgeGroups`
- **Operations:** Clubs can add teams, change age groups, assign managers

### Stage 4: Team Lock (Pre-Season)
- **Trigger:** `clubTeamsLocked`
- **Operations:** No team changes by clubs (league admin can override)

### Stage 5: AGG Allocation (League Admin Only)
- **Deadline:** `leagueAllocateTeamsToAggs`
- **Operations:** Assign teams to AGGs

### Stage 6: Season In Progress
- **Operations:** Minimal changes, heavy audit trail

---

## Database Schema Impact

### Current State (Phase 2)
```prisma
model LMSProSeason {
  id String @id
  organizationId String
  
  // Dates exist but are not enforced
  leagueAgeGroupsConfirms DateTime?
  clubFinaliseTeamNamesAgeGroups DateTime?
  clubTeamsLocked DateTime?
  // ... 20+ date fields
  
  ageGroups LMSProAgeGroup[]
  teams LMSProTeam[]
}

model LMSProTeam {
  id String @id
  ageGroup String        // ✅ Can be updated
  ageGroupId String?     // ✅ Can be updated
  aggId String?          // ✅ Cleared if age group changes
}
```

### Future Additions (Phase 4/5)
```prisma
model SeasonWorkflowLog {
  id String @id
  seasonId String
  operation String        // e.g., 'teams.changeAgeGroup'
  performedBy String
  performedAt DateTime
  bypassReason String?    // If C1 overrode restrictions
  
  season LMSProSeason @relation(...)
}
```

---

## Migration Path

### Phase 2 (Current) ✅
- **Goal:** Enable structural changes, document architecture
- **Deliverables:**
  - Backend accepts age group changes
  - Frontend allows age group editing
  - AGG de-allocation on age group change
  - This architectural document

### Phase 3 (Next)
- **Goal:** Data integrity
- **Deliverables:**
  - Backfill missing `ageGroupId` on existing teams
  - Database migration to drop `ageGroupTags` column
  - Full removal of deprecated tag system

### Phase 4 (Future)
- **Goal:** Implement basic temporal permissions
- **Deliverables:**
  - `canPerformOperation()` helper function
  - Enforce date restrictions for C2 (Club) users
  - C1 (League Admin) bypass mechanism
  - User-friendly error messages ("This operation is not available until...")

### Phase 5 (Future)
- **Goal:** Advanced workflow management
- **Deliverables:**
  - Workflow stage indicators in UI
  - Visual timeline of season dates
  - Automated notifications (e.g., "Age group window closes in 3 days")
  - Comprehensive audit trail

---

## Benefits of This Approach

1. **Gradual Complexity:** Core data model stabilizes before adding workflow enforcement
2. **Structural Readiness:** Phase 2 ensures when temporal permissions are added, the data model supports them
3. **Flexibility:** League administrators retain override capability for emergency situations
4. **Compliance:** Audit trail supports governance requirements (NHS, safeguarding, etc.)
5. **User Experience:** Clear communication about "when" operations can be performed

---

## Key Takeaways

- **Two-dimensional permissions:** "By Whom" (roles) ✅ + "When" (dates) ⚠️
- **Phase 2 enables structure** without enforcing workflows (intentional)
- **Season dates exist** but are currently informational only
- **Future implementation** will layer temporal checks on top of role checks
- **League administrators** will always be able to override temporal restrictions
- **Clubs** will be gated by seasonal workflow windows (when implemented)

---

## Related Documentation

- `/docs/modules/lmspro/permissions.md` - Role-based permission details
- `/docs/modules/lmspro/workflows.md` - Seasonal workflow design (TBD)
- `/docs/modules/lmspro/audit-compliance.md` - Audit logging requirements

---

**Document Status:** Living document - will be updated as implementation progresses  
**Last Updated:** January 2026 (Phase 2 complete)
