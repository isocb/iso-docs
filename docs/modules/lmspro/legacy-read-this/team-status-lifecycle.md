# LMSPro Team Status Lifecycle

## Overview

Team status in LMSPro tracks the current state of a team's participation in a season. This document describes the available statuses, when to use them, and typical workflow transitions.

## Status Values

### Active Statuses (Current System)

#### CURRENT
- **Purpose**: Team is actively participating in the current season
- **Key Rule**: **Only CURRENT teams count toward AGG capacity**
- **When to Use**: 
  - Team has confirmed participation
  - Team has been allocated to an AGG
  - Team is actively playing in the league
- **Default**: This is the default status for newly created teams

#### WAITING_LIST
- **Purpose**: Team is registered but not yet allocated to an AGG
- **Key Rule**: Does NOT count toward AGG capacity
- **When to Use**:
  - Team registration received but AGGs are full
  - Team waiting for age group allocation
  - Team pending club approval
- **Typical Next Status**: CURRENT (once allocated) or CANCELLED

#### CANCELLED
- **Purpose**: Team registration has been cancelled or withdrawn
- **Key Rule**: Does NOT count toward AGG capacity
- **When to Use**:
  - Club withdraws team before season starts
  - Team unable to field enough players
  - Administrative cancellation
- **Status Notes**: Should explain cancellation reason

### Legacy Statuses (Backward Compatibility)

These values exist for historical data migration and should not be used for new teams:

#### ACTIVE (Legacy)
- Replaced by CURRENT in new system
- Displayed with green badge (same as CURRENT)

#### INACTIVE (Legacy)
- Replaced by WAITING_LIST in new system
- Displayed with gray badge

#### WITHDRAWN (Legacy)
- Replaced by CANCELLED in new system
- Displayed with red badge (same as CANCELLED)

## Status Transitions

### Typical Workflows

```
Registration → CURRENT
├─ Team registered with immediate AGG allocation
└─ Counts toward capacity immediately

Registration → WAITING_LIST → CURRENT
├─ Team registered but AGGs full
├─ Does NOT count toward capacity while waiting
└─ Moved to CURRENT when AGG space available

CURRENT → WAITING_LIST → CURRENT
├─ Team moved to different age group
├─ AGG allocation cleared during transition
└─ Reallocated to new age group's AGG

CURRENT → CANCELLED
└─ Team withdraws from season

WAITING_LIST → CANCELLED
└─ Team withdraws before allocation
```

### AGG Capacity Rules

**CRITICAL**: Only teams with status CURRENT count toward AGG capacity calculations.

**Example Scenario**:
- Age Group U7 has 3 AGGs, each with capacity 8 (total 24)
- 20 teams have status CURRENT → capacity 20/24 (83%)
- 5 teams have status WAITING_LIST → capacity still 20/24 (waiting list teams don't count)
- When space opens: Promote WAITING_LIST team to CURRENT, capacity becomes 21/24 (87%)

## Status Management UI

### Teams List Page

**Status Filter Dropdown** (defaults to CURRENT):
- **All Statuses**: Show all teams regardless of status
- **Current**: Show only actively participating teams (typical view)
- **Waiting List**: Show teams awaiting allocation
- **Cancelled**: Show withdrawn teams (for record-keeping)

**Status Column**: Color-coded badges
- CURRENT/ACTIVE → Green
- WAITING_LIST → Orange
- CANCELLED/WITHDRAWN → Red
- INACTIVE → Gray

### Team CRUD Modal

**Status Field**: Required dropdown with 3 active values:
- Current
- Waiting List
- Cancelled

**Status Notes Field**: Optional textarea
- Recommended for CANCELLED teams (explain reason)
- Useful for WAITING_LIST teams (expected allocation date)
- Optional for CURRENT teams (any special circumstances)

## Administrative Guidelines

### When to Change Status

**CURRENT → WAITING_LIST**:
- Team moves to different age group (AGG allocation cleared)
- AGG restructuring requires temporary reallocation
- Always add Status Notes explaining reason

**WAITING_LIST → CURRENT**:
- AGG space becomes available
- Age group allocation confirmed
- Team assigned to specific AGG
- Clear Status Notes when transitioning

**ANY → CANCELLED**:
- Team withdraws from season
- Club closes/merges
- Insufficient players
- **REQUIRED**: Add Status Notes with cancellation reason and date

### Capacity Planning

1. **View Current Load**: Filter by CURRENT status to see teams counting toward capacity
2. **View Waiting List**: Filter by WAITING_LIST to identify teams needing allocation
3. **AGG Management**: Use AGG capacity calculations (based on CURRENT teams only)
4. **Bulk Allocation**: Promote multiple WAITING_LIST teams to CURRENT in one operation

## Integration Points

### AGG Capacity Calculations
- Backend validation checks CURRENT team count before allocating
- Frontend displays capacity as: `{currentTeams} / {aggCapacity}`
- Only CURRENT status teams included in `currentTeams` count

### Reporting & Analytics
- Season statistics should filter by CURRENT teams
- Historical reports may need to map legacy statuses:
  - ACTIVE → count as CURRENT
  - INACTIVE → count as WAITING_LIST
  - WITHDRAWN → count as CANCELLED

### Email Notifications
- **Team Created**: Welcome email for all new teams
- **Status → CURRENT**: "Team Allocated" email with AGG details
- **Status → WAITING_LIST**: "Waiting List Position" email with estimated timeline
- **Status → CANCELLED**: "Cancellation Confirmation" email

## Database Schema

```prisma
model LMSProTeam {
  // ... other fields
  status      TeamStatus @default(ACTIVE)  // Note: Will be CURRENT for new teams
  statusNotes String?    @db.Text @map("status_notes")
  // ... relations
}

enum TeamStatus {
  CURRENT      // Current: counts toward AGG capacity
  WAITING_LIST // Waiting List: team on waiting list
  CANCELLED    // Cancelled: team registration cancelled
  ACTIVE       // Team actively participating (legacy)
  INACTIVE     // Team temporarily inactive (legacy)
  WITHDRAWN    // Team withdrawn from season (legacy)
}
```

## API Usage

### List Teams with Status Filter

```typescript
// Get only current teams
const teams = trpc.lmspro.teams.list.useQuery({
  seasonId: seasonId,
  status: TeamStatus.CURRENT,
});

// Get waiting list
const waitingList = trpc.lmspro.teams.list.useQuery({
  seasonId: seasonId,
  status: TeamStatus.WAITING_LIST,
});
```

### Create Team with Status

```typescript
// Create team directly as CURRENT (default)
trpc.lmspro.teams.create.useMutation({
  seasonId: seasonId,
  clubId: clubId,
  teamName: "Derby Juniors U8 Blue",
  ageGroup: "U8",
  status: TeamStatus.CURRENT, // Optional - this is default
  aggId: aggId, // Assign to AGG
});

// Create team on waiting list
trpc.lmspro.teams.create.useMutation({
  seasonId: seasonId,
  clubId: clubId,
  teamName: "Derby Juniors U8 Red",
  ageGroup: "U8",
  status: TeamStatus.WAITING_LIST, // No AGG yet
  statusNotes: "Waiting for U8 AGG space - expected Feb 2025",
});
```

### Update Team Status

```typescript
// Promote from waiting list to current
trpc.lmspro.teams.update.useMutation({
  id: teamId,
  status: TeamStatus.CURRENT,
  aggId: newAggId, // Assign to AGG
  statusNotes: "", // Clear waiting list notes
});

// Cancel team
trpc.lmspro.teams.update.useMutation({
  id: teamId,
  status: TeamStatus.CANCELLED,
  statusNotes: "Team withdrawn by club - insufficient players (Jan 13, 2025)",
});
```

## Migration Notes

**Default Status Change**: As of January 2025, the default status changed from `TeamStatus.ACTIVE` (legacy) to `TeamStatus.CURRENT`. This ensures new teams immediately count toward AGG capacity calculations.

**No Existing Teams**: Since there are currently no teams in the database, no data migration is required. All future teams will use the new CURRENT/WAITING_LIST/CANCELLED workflow.

**Legacy Status Support**: The ACTIVE/INACTIVE/WITHDRAWN values remain in the enum for potential future data imports from legacy systems. They map as follows:
- ACTIVE → CURRENT (green badge, counts toward capacity)
- INACTIVE → WAITING_LIST (gray badge, does not count)
- WITHDRAWN → CANCELLED (red badge, does not count)

---

**Last Updated**: January 13, 2025  
**Version**: 1.0  
**Related Docs**: 
- `/docs/modules/lmspro/architecture.md` - LMSPro module architecture
- `/docs/modules/lmspro/agg-system.md` - AGG capacity and allocation
