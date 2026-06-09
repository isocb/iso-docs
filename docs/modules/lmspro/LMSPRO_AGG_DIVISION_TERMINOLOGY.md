# LMSPro Terminology Guide

## UI vs Backend Terminology

### Division (UI) = AGG (Backend/Database)

**User-Facing Term:** **Division** or **Divisions**  
**Backend/Database Term:** **AGG** (Age Group Group)

---

## What is a Division/AGG?

A **Division** (called AGG in the backend) is a grouping of teams within an age group for competitive play. For example:
- U9 Inner Ring Division
- U9 Outer Ring Division  
- U11 Division 1
- U11 Division 2

### Key Concepts

1. **Multi-tier structure:**
   - Season contains multiple Age Groups (U7, U9, U11, etc.)
   - Each Age Group can have multiple Divisions (AGGs)
   - Each Division contains multiple Teams

2. **Cross-age divisions:** Some divisions can span multiple age groups (e.g., "Mixed Age Friendly League")

3. **Capacity management:** Each division has a capacity limit (max number of teams)

---

## Backend Implementation

### Database Schema (`prisma/schema.prisma`)

```prisma
model LMSProAgeGroupGroup {  // ⚠️ Database name (AGG)
  id             String  @id
  organizationId String
  seasonId       String
  ageGroupId     String?  // Nullable for cross-age divisions
  
  name         String    // Display name (e.g., "Division 1")
  capacity     Int?      // Max teams in this division
  displayOrder Int
  
  // Relations
  season    LMSProSeason
  ageGroup  LMSProAgeGroup?
  teams     LMSProTeam[]   // Teams allocated to this division
  
  @@map("lmspro_age_group_groups")  // Table name
}
```

### Team Allocation

```prisma
model LMSProTeam {
  id           String
  aggId        String?  // ⚠️ Field name (aggId, not divisionId)
  
  agg          LMSProAgeGroupGroup?  // Relation to division
}
```

---

## Code References

### tRPC Routers

**Location:** `src/modules/lmspro/routers/age-groups.router.ts`

```typescript
// AGG-related endpoints (backend terminology)
export const ageGroupRouter = createTRPCRouter({
  // ... age group endpoints ...
  
  agg: ageGroupGroupRouter,  // Sub-router for AGG operations
});

export const ageGroupGroupRouter = createTRPCRouter({
  list: ...,      // List all AGGs
  get: ...,       // Get single AGG
  create: ...,    // Create new AGG
  update: ...,    // Update AGG
  delete: ...,    // Delete AGG (if no teams allocated)
});
```

**Usage in frontend:**
```typescript
// Backend uses 'agg' terminology
const { data: divisions } = trpc.lmspro.ageGroups.agg.list.useQuery({
  seasonId: activeSeasonId,
});
```

### Import System

**Entity Type:** `LMSPRO_AGG` (not `LMSPRO_DIVISION`)

**CSV Template:**
```csv
agg_id,agg_name,age_group_code,capacity
201,Inner Ring Tyres U9s,U9,12
202,Outer Ring U9s,U9,12
```

**Handler:** `src/modules/lmspro/import/handlers/agg.ts`

---

## UI Display Guidelines

### ✅ User-Facing Labels (Use "Division")

```typescript
// In UI components
<Title>Division Manager</Title>
<Text>Select a division for this team</Text>
<Select 
  label="Division" 
  placeholder="Choose a division"
  data={divisions.map(div => ({ value: div.id, label: div.name }))}
/>
```

### ⚠️ Backend Code (Use "agg")

```typescript
// In routers, services, database queries
const agg = await prisma.lMSProAgeGroupGroup.findFirst({
  where: { id: aggId },
  include: { teams: true },
});

const team = await prisma.lMSProTeam.update({
  where: { id: teamId },
  data: { aggId: divisionId },  // Field name is 'aggId'
});
```

---

## Common Operations

### Creating a Division

```typescript
// Backend (router)
const agg = await ctx.prisma.lMSProAgeGroupGroup.create({
  data: {
    organizationId,
    seasonId,
    ageGroupId: ageGroupId || null,  // Null for cross-age
    name: "Division 1",  // User-friendly name
    capacity: 12,
  },
});

// UI displays as "Division 1"
```

### Allocating Teams to Divisions

```typescript
// Backend
await ctx.prisma.lMSProTeam.update({
  where: { id: teamId },
  data: { aggId: divisionId },  // AGG terminology in code
});

// UI shows: "Team allocated to Division 1"
```

### Capacity Checking

```typescript
// Backend logic
const agg = await ctx.prisma.lMSProAgeGroupGroup.findFirst({
  where: { id: aggId },
  include: { _count: { select: { teams: true } } },
});

if (agg.capacity && agg._count.teams >= agg.capacity) {
  throw new TRPCError({
    code: 'BAD_REQUEST',
    message: `Division "${agg.name}" is at full capacity`,  // User message uses "Division"
  });
}
```

---

## Migration Path (Future)

If we ever rename AGG → Division in the backend:

### Phase 1: Prisma Schema
1. Rename `LMSProAgeGroupGroup` → `LMSProDivision`
2. Rename `aggId` → `divisionId` in all models
3. Update table name `lmspro_age_group_groups` → `lmspro_divisions`
4. Generate migration: `npx prisma migrate dev --name rename_agg_to_division`

### Phase 2: Code
1. Update all routers (`agg` → `division`)
2. Update tRPC endpoints (`ageGroups.agg.*` → `ageGroups.division.*`)
3. Update import handlers (`LMSPRO_AGG` → `LMSPRO_DIVISION`)

### Phase 3: Data
1. Update CSV templates
2. Update audit log action names (`AGG_CREATED` → `DIVISION_CREATED`)
3. Update any hardcoded strings in seed data

**Estimated Effort:** 4-6 hours + thorough testing  
**Risk:** Medium (affects team allocation logic)

---

## Why Keep AGG in Backend?

1. **Stability:** Existing imports and data use AGG terminology
2. **Testing:** Allocation logic is complex and well-tested
3. **Migration Risk:** Renaming requires database migration on all environments
4. **Legacy Data:** Historical imports reference AGG entity types

The UI abstraction provides user-friendly terminology without risking backend stability.

---

## Quick Reference

| Context | Term | Example |
|---------|------|---------|
| **User sees** | Division | "Select a division for your team" |
| **Developer writes** | AGG | `aggId`, `lMSProAgeGroupGroup` |
| **Database stores** | agg_id | `lmspro_age_group_groups` table |
| **API endpoint** | agg | `/lmspro/ageGroups/agg/list` |
| **Import CSV** | agg_id | `agg_id,agg_name,capacity` |

---

## Component Documentation Additions

When documenting division-related features for users:

✅ **Use:** "Divisions organize teams within age groups for competitive play"  
✅ **Use:** "Allocate your team to a division"  
✅ **Use:** "Each division has a capacity limit"

❌ **Avoid:** "AGG", "Age Group Group", technical database terminology

---

Last Updated: January 14, 2026  
Maintained by: Development Team
