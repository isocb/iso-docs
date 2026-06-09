# LMSPro Free Days System

## Overview

The Free Days system allows teams to request scheduled breaks from league obligations. Teams run by volunteers may need time off for holidays, player shortages, or other circumstances. The league sets a maximum number of free days per season and a minimum notice period.

## Architecture

### Component-Based Access Control

The system uses **role-based component access**, NOT platform access permissions. This allows league owners to flexibly assign capabilities to different roles.

**Components:**
- `freedays.request` (CLUB_DASHBOARD, ACTION) - Request free days for teams
- `freedays.manage` (LEAGUE_DASHBOARD, ACTION) - Cancel/manage free day requests

**Role Scopes:**
- `CLUB` - Club Secretary, Club Treasurer (can request)
- `LEAGUE` - League Admin, League Secretary (can manage/cancel)

### Database Schema

**Season Configuration:**
```prisma
model LMSProSeason {
  maxFreeDaysPerTeam      Int @default(2)  // League-wide limit
  freeDayNoticeOffsetDays Int @default(7)  // Minimum days notice required
}
```

**Free Day Requests:**
```prisma
model LMSProTeamFreeDay {
  id             String @id @default(uuid())
  organizationId String
  teamId         String
  seasonId       String
  
  requestedDate  DateTime        // The date team wants off
  reason         String?         // Optional context
  status         FreeDayStatus   // PENDING, APPROVED, CANCELLED, REJECTED
  
  // Audit trail
  requestedById  String
  requestedAt    DateTime
  reviewedById   String?
  reviewedAt     DateTime?
  reviewNotes    String?
}

enum FreeDayStatus {
  PENDING    // Request submitted (future-proof for approval workflow)
  APPROVED   // Auto-approved or manually approved
  CANCELLED  // Cancelled by league admin (quota refunded)
  REJECTED   // Rejected (future-proof)
}

enum RoleScope {
  CLUB   // Club-level roles
  LEAGUE // League-level roles
}
```

## Business Rules

### Request Validation

1. **Notice Period**: Requests must be submitted at least `freeDayNoticeOffsetDays` in advance
   - Configurable per season (default: 7 days)
   - Prevents last-minute requests

2. **Date Boundaries**: Requested date must be within season start/end dates

3. **Quota Enforcement**: Teams cannot exceed `maxFreeDaysPerTeam` approved requests
   - Only APPROVED status counts toward quota
   - CANCELLED requests refund the quota automatically

4. **Duplicate Prevention**: Teams cannot request the same date twice (if already APPROVED or PENDING)

### Auto-Approval Workflow

**Current Implementation:**
- All requests are auto-approved (status = APPROVED immediately)
- No manual approval step required
- League admins can cancel approved requests

**Future Enhancement:**
- Can switch to approval workflow by defaulting status to PENDING
- Add approval/rejection endpoints
- Email notifications on status changes

### Cancellation & Quota Refund

**Who Can Cancel:**
- Only users with `freedays.manage` component access (league-level roles)
- NOT club users - prevents abuse

**Quota Refund:**
- Quota counts only APPROVED requests: `count({ status: APPROVED })`
- When cancelled, status changes to CANCELLED
- Automatically removes from quota count
- Team can request new free day with refunded quota

## tRPC API Endpoints

### `lmspro.freeDays.request`

**Access:** Requires `freedays.request` component (CLUB_DASHBOARD)

**Input:**
```typescript
{
  teamId: string
  requestedDate: Date
  reason?: string
}
```

**Validation:**
- Team exists and belongs to user's organization
- Date is at least `freeDayNoticeOffsetDays` days in future
- Date is within season boundaries
- No existing request for this date (APPROVED or PENDING)
- Team has not reached `maxFreeDaysPerTeam` limit

**Response:** Created `LMSProTeamFreeDay` with status APPROVED

---

### `lmspro.freeDays.list`

**Access:** Requires authentication

**Input:**
```typescript
{
  teamId?: string      // Filter by team
  clubId?: string      // Filter by club
  seasonId?: string    // Filter by season
  status?: FreeDayStatus // Filter by status
}
```

**Response:** Array of free day requests with team, club, and user details

---

### `lmspro.freeDays.getTeamUsage`

**Access:** Requires authentication

**Input:**
```typescript
{
  teamId: string
}
```

**Response:**
```typescript
{
  used: number      // Count of APPROVED requests
  total: number     // Season's maxFreeDaysPerTeam
  remaining: number // total - used
}
```

**Used in Teams table badge:** Shows "2/3 used"

---

### `lmspro.freeDays.cancel`

**Access:** Requires `freedays.manage` component (LEAGUE_DASHBOARD)

**Input:**
```typescript
{
  freeDayId: string
  reviewNotes?: string // Optional cancellation reason
}
```

**Validation:**
- Request exists
- Not already cancelled
- User has league-level permissions

**Response:** Updated request with status CANCELLED, reviewedBy, reviewedAt

**Side Effect:** Quota automatically refunded (counts only APPROVED)

---

### `lmspro.freeDays.getSeasonStats`

**Access:** Requires authentication

**Input:**
```typescript
{
  seasonId: string
}
```

**Response:**
```typescript
{
  totalRequests: number
  approvedRequests: number
  cancelledRequests: number
  teamsAtLimit: number
  teamsAtLimitDetails: Array<{ id, teamName, used }>
}
```

**Use Case:** League dashboard overview of free day usage

## User Interface

### Teams Table - Free Days Column

**Location:** `/app/lmspro/teams`

**Display:**
- Badge showing "X/Y used" (e.g., "2/3 used")
- Color-coded:
  - Green: Days remaining (`remaining > 0`)
  - Orange: At limit (`remaining === 0`)
  - Red: Over limit (`remaining < 0` - should not happen)

**Interaction:**
- Click badge to open Free Days History Modal
- Uses `stopPropagation()` to prevent row click (edit modal)

**Component:**
```tsx
<FreeDaysBadge 
  team={team} 
  onOpenModal={() => {
    setSelectedTeamForFreeDays(team);
    setFreeDaysModalOpened(true);
  }} 
/>
```

---

### Free Days History Modal

**Opened by:** Clicking badge in Teams table

**Displays:**
- Team name in title
- Usage summary badge: "2/3 used"
- Table of all requests:
  - Date (formatted: DD/MM/YYYY)
  - Reason (optional text)
  - Status badge (APPROVED = green, CANCELLED = red, PENDING = yellow)
  - Requested date and by whom

**Future Enhancement:**
- Add "Request Free Day" button if user has component access
- Show cancellation notes for cancelled requests
- Filter by date range or status

## Configuration & Setup

### Season Setup

When creating a new season, set:

```typescript
{
  maxFreeDaysPerTeam: 2,      // Typically 2-3 per season
  freeDayNoticeOffsetDays: 7  // Typically 7-14 days
}
```

**League-specific examples:**
- Youth leagues: 3 free days, 7 days notice
- Adult leagues: 2 free days, 14 days notice
- Competitive leagues: 1 free day, 21 days notice

### Role Assignment

**For Club Officials to Request:**
1. Navigate to LMSPro Roles
2. Edit "Club Secretary" or "Club Treasurer" role (roleScope = CLUB)
3. Add `freedays.request` to componentKeys array
4. Save

**For League Admins to Manage:**
1. Navigate to LMSPro Roles
2. Edit "League Admin" or "League Secretary" role (roleScope = LEAGUE)
3. Add `freedays.manage` to componentKeys array
4. Save

### Seed Data

Component definitions are seeded automatically:

```typescript
// prisma/seed.ts
{
  componentKey: 'freedays.request',
  title: 'Request Free Days',
  pageContext: 'CLUB_DASHBOARD',
  capability: 'ACTION',
}
{
  componentKey: 'freedays.manage',
  title: 'Manage Free Days',
  pageContext: 'LEAGUE_DASHBOARD',
  capability: 'ACTION',
}
```

## Implementation Notes

### Why Component-Based Access?

**Problem:** Using platform roles (OWNER, ADMIN, MEMBER) is too rigid:
- Doesn't support club vs league distinction
- Can't be time-based (e.g., only during registration window)
- Not flexible for different league structures

**Solution:** Component-based RBAC:
- League owner decides who gets what access
- Supports club-level and league-level roles separately
- Can be time-gated using VisibilityRules (future)
- Module-specific permissions stay in module context

### Permission Check Pattern

**❌ WRONG (Platform Permissions):**
```typescript
if (user.role !== 'OWNER' && user.role !== 'ADMIN') {
  throw new TRPCError({ code: 'FORBIDDEN' });
}
```

**✅ CORRECT (Component Access):**
```typescript
const hasAccess = await hasComponentAccess(
  userId,
  'freedays.request',
  'CLUB_DASHBOARD'
);
if (!hasAccess) {
  throw new TRPCError({ code: 'FORBIDDEN' });
}
```

### Migration History

**Migration 1:** `20260114051427_add_free_days_system`
- Added `maxFreeDaysPerTeam` and `freeDayNoticeOffsetDays` to `LMSProSeason`
- Created `LMSProTeamFreeDay` table
- Added `FreeDayStatus` enum
- Added relations to User, Organization, Season

**Migration 2:** `20260114053150_add_role_scope_to_module_roles`
- Added `RoleScope` enum (CLUB, LEAGUE)
- Added `roleScope` field to `ModuleRole` (default: LEAGUE)
- Enables proper club vs league role distinction

## Future Enhancements

### Phase 2: Approval Workflow

**Change:** Default status to PENDING instead of APPROVED

**New Endpoints:**
- `lmspro.freeDays.approve` - Approve pending request
- `lmspro.freeDays.reject` - Reject pending request

**UI Changes:**
- League dashboard view of pending requests
- Approval/rejection buttons with notes
- Email notifications on status changes

### Phase 3: Club Dashboard Request Form

**Location:** `/app/club/freedays` or section on club dashboard

**Features:**
- Select team (dropdown of club's teams)
- Date picker (validates notice period and season boundaries)
- Reason text field
- Shows current usage: "2/3 free days used"
- Real-time validation feedback

### Phase 4: League Dashboard Overview

**Features:**
- Calendar view of all free days across all teams
- Conflict warnings (too many teams off on same date)
- Statistics dashboard (usage by club, age group)
- Bulk cancellation for rescheduled match days

### Phase 5: Email Notifications

When email system is implemented:

**On Request:**
- Email club admin confirming request
- Email league admin (if approval required)

**On Cancellation:**
- Email club admin with reason
- Email team manager contact

**Template Placeholders:**
```typescript
sendFreeDayRequestedEmail(team, freeDay);
sendFreeDayCancelledEmail(team, freeDay, reviewNotes);
```

## Testing

### Test Scenarios

1. **Happy Path - Request Free Day:**
   - Club secretary requests free day 10 days in advance
   - Status immediately APPROVED
   - Quota count increases
   - Badge updates in teams table

2. **Quota Limit:**
   - Team uses all allowed free days (e.g., 2/2)
   - Attempt to request another fails with error
   - Badge shows orange "2/2 used"

3. **Cancellation & Refund:**
   - League admin cancels approved request
   - Status changes to CANCELLED
   - Quota count decreases
   - Team can request new free day

4. **Notice Period Validation:**
   - Attempt to request free day 5 days ahead (when offset = 7)
   - Request fails with error message
   - No record created

5. **Date Boundaries:**
   - Attempt to request date before season start
   - Attempt to request date after season end
   - Both fail validation

### Test Users

**Seed Data Provides:**
- Club admin (Club Secretary role) - Can request
- League admin (League Admin role) - Can cancel
- Regular member - No access to free days

## Troubleshooting

### "You do not have permission to request free days"

**Cause:** User lacks `freedays.request` component access

**Fix:**
1. Check user's assigned role(s)
2. Verify role has `freedays.request` in componentKeys
3. Ensure role is active (`isActive: true`)
4. Confirm user is assigned to club (LMSProClubOfficial table)

### "Team has reached maximum free days"

**Cause:** Team has used all allocated free days

**Options:**
1. League admin cancels an approved request (refunds quota)
2. League admin increases season's `maxFreeDaysPerTeam`
3. Wait for new season

### Badge Not Showing Usage

**Cause:** Query may be disabled or team doesn't have season set

**Debug:**
1. Check team has valid `seasonId`
2. Verify season has `maxFreeDaysPerTeam` set (not null)
3. Check browser console for tRPC errors
4. Ensure `getTeamUsage` query is enabled

### Free Days Not Appearing in Modal

**Cause:** Query disabled or no requests exist

**Debug:**
1. Check `teamFreeDays` query enabled when modal opens
2. Verify team has requests in `lmspro_team_free_days` table
3. Check organizationId scoping is correct
4. Look for tRPC errors in console

## Related Documentation

- [Component-Based RBAC System](/docs/00-overview/component-rbac.md)
- [LMSPro Roles & Permissions](/docs/modules/lmspro/roles-permissions.md)
- [Season Configuration](/docs/modules/lmspro/seasons.md)
- [Team Management](/docs/modules/lmspro/teams.md)

## Database Queries

### Count Free Days by Status

```sql
SELECT 
  status,
  COUNT(*) as count
FROM lmspro.lmspro_team_free_days
WHERE organization_id = '<org_id>'
  AND season_id = '<season_id>'
GROUP BY status;
```

### Teams at Free Day Limit

```sql
SELECT 
  t.team_name,
  t.age_group,
  c.full_name as club_name,
  COUNT(fd.id) as used_free_days,
  s.max_free_days_per_team as limit
FROM lmspro.lmspro_teams t
JOIN lmspro.lmspro_clubs c ON t.club_id = c.id
JOIN lmspro.lmspro_seasons s ON t.season_id = s.id
LEFT JOIN lmspro.lmspro_team_free_days fd 
  ON t.id = fd.team_id AND fd.status = 'APPROVED'
WHERE t.organization_id = '<org_id>'
  AND t.season_id = '<season_id>'
GROUP BY t.id, t.team_name, t.age_group, c.full_name, s.max_free_days_per_team
HAVING COUNT(fd.id) >= s.max_free_days_per_team;
```

### Upcoming Free Days

```sql
SELECT 
  t.team_name,
  c.short_name as club,
  t.age_group,
  fd.requested_date,
  fd.reason
FROM lmspro.lmspro_team_free_days fd
JOIN lmspro.lmspro_teams t ON fd.team_id = t.id
JOIN lmspro.lmspro_clubs c ON t.club_id = c.id
WHERE fd.organization_id = '<org_id>'
  AND fd.status = 'APPROVED'
  AND fd.requested_date >= CURRENT_DATE
ORDER BY fd.requested_date ASC;
```

---

**Last Updated:** January 14, 2026  
**Version:** 1.0  
**Module:** LMSPro  
**Status:** Production Ready
