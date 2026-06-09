# Free Days Feature Implementation - January 14, 2026

## Issues Fixed

### Issue 1: Role Scope Limitation
**Problem**: Roles could only be CLUB or LEAGUE scoped, but Free Days needs to work for both.

**Solution**: 
- Added `BOTH` option to `RoleScope` enum in `prisma/schema.prisma`
- Migration created: `20260114074854_add_both_role_scope_and_freeday_season_fields`
- Roles can now be set to BOTH scope, making components available to both club and league users

### Issue 2: Missing Season Configuration Fields
**Problem**: Season management UI didn't expose Free Day configuration fields (`maxFreeDaysPerTeam`, `freeDayNoticeOffsetDays`), causing system to use hardcoded defaults of 2 free days and 7 days notice.

**Solution**:
- Added NumberInput fields to Season form in `src/app/(app)/app/lmspro/seasons/page.tsx`
- Updated form interface to include `maxFreeDaysPerTeam` and `freeDayNoticeOffsetDays`
- Updated seasons router (`src/modules/lmspro/routers/seasons.router.ts`) to accept and save these fields
- Fields now appear in "Free Days Configuration" alert box in Season Overview tab
- Validation: 0-10 free days, 0-90 days notice period

### Issue 3: League Users Cannot Request Free Days for Clubs
**Problem**: FreeDaysRequest component only worked for club users. League administrators couldn't help clubs request free days.

**Solution**:
- Updated `FreeDaysRequest.tsx` component to detect if user is league-level (ADMIN/OWNER)
- Added club selector for league users (appears first, before team selector)
- Team selector now filters by selected club for league users
- Flow:
  - **Club users**: See only their club's teams directly
  - **League users**: Select club → See that club's teams

## Files Modified

### Database Schema
- `prisma/schema.prisma`
  - Added `BOTH` to `RoleScope` enum (line 1596)

### Migrations
- `prisma/migrations/20260114074854_add_both_role_scope_and_freeday_season_fields/migration.sql`
  - Adds BOTH enum value to RoleScope

### Frontend Components
- `src/app/(app)/app/lmspro/seasons/page.tsx`
  - Added `NumberInput` import
  - Updated `SeasonFormValues` interface with Free Day fields
  - Added fields to form initial values with defaults (2 free days, 7 days notice)
  - Added validation rules (0-10 free days, 0-90 days notice)
  - Added Free Days Configuration alert box with two NumberInput fields
  - Updated `handleOpenEdit` to load existing values
  - Updated `handleSubmit` to include new fields in payload

- `src/modules/lmspro/components/dashboard/FreeDaysRequest.tsx`
  - Added session check to detect league vs club users
  - Added `selectedClubId` state
  - Added clubs query (enabled for league users only)
  - Added club selector UI (visible for league users only)
  - Updated teams query to filter by selected club for league users
  - Updated form reset to clear club selection
  - Team selector now disabled until club selected (league users only)

### Backend Routers
- `src/modules/lmspro/routers/seasons.router.ts`
  - Updated `create` mutation input schema to accept `maxFreeDaysPerTeam` and `freeDayNoticeOffsetDays`
  - Updated `create` mutation data to save Free Day fields
  - Updated `update` mutation input schema to accept Free Day fields (optional)
  - Update mutation automatically includes new fields via spread operator

## Testing Checklist

### Season Configuration
- [x] Create new season
- [x] Verify Free Days Configuration section appears in Overview tab
- [x] Set max free days to 3
- [x] Set notice period to 14 days
- [x] Save season
- [x] Edit season
- [x] Verify values loaded correctly
- [x] Update values
- [x] Verify changes saved

### Role Scope
- [x] Create new role
- [x] Verify role scope dropdown includes BOTH option
- [x] Assign free days components to a BOTH-scoped role
- [x] Verify role appears for both club and league users

### Free Days Request (Club User)
- [ ] Log in as club user
- [ ] Navigate to club dashboard
- [ ] Verify Free Days Request component appears
- [ ] Verify club selector NOT visible
- [ ] Verify team selector shows only user's club teams
- [ ] Select team
- [ ] Verify notice period matches season configuration
- [ ] Verify max free days matches season configuration
- [ ] Request free day
- [ ] Verify success

### Free Days Request (League User)
- [ ] Log in as league admin/owner
- [ ] Navigate to league dashboard
- [ ] Verify Free Days Request component appears
- [ ] Verify club selector IS visible
- [ ] Verify team selector disabled until club selected
- [ ] Select club
- [ ] Verify team selector shows selected club's teams
- [ ] Select team
- [ ] Verify notice period matches season configuration
- [ ] Request free day on behalf of club
- [ ] Verify success

### Database Verification
- [x] Migration applied successfully
- [x] RoleScope enum includes BOTH value
- [x] LMSProSeason table has maxFreeDaysPerTeam column
- [x] LMSProSeason table has freeDayNoticeOffsetDays column

## Architecture Notes

### Role Scope vs Page Context
- **RoleScope** (CLUB/LEAGUE/BOTH): Determines WHO can have the role
  - CLUB: Role assigned per club (Club Secretary, Club Treasurer)
  - LEAGUE: Role assigned organization-wide (League Admin, Age Group Manager)
  - BOTH: Role can be assigned to both club and league users
  
- **PageContext** (CLUB_DASHBOARD/LEAGUE_DASHBOARD): Determines WHERE component appears
  - CLUB_DASHBOARD: Component on club dashboard (`/app/lmspro/club/[clubId]/dashboard`)
  - LEAGUE_DASHBOARD: Component on league dashboard (`/app/lmspro/dashboard`)

- **Component Behavior**: Components can detect user role and adapt behavior
  - FreeDaysRequest: Shows club selector for league users, hides it for club users
  - Same component code works in both contexts with role-based branching

### Season Configuration Flow
1. Admin creates/edits season in `/app/lmspro/seasons`
2. Admin sets `maxFreeDaysPerTeam` (default 2) and `freeDayNoticeOffsetDays` (default 7)
3. Values saved to `lmspro_seasons` table
4. FreeDaysRequest component reads from active season
5. Component enforces limits and notice period dynamically

### Free Days Request Flow
**Club Users:**
```
Club Dashboard → FreeDaysRequest Component
  ↓
User sees only their club's teams
  ↓
Select team → Select date (min: today + notice period)
  ↓
Submit request → Auto-approved (or pending based on workflow)
```

**League Users:**
```
League Dashboard → FreeDaysRequest Component
  ↓
Select club from dropdown
  ↓
See selected club's teams
  ↓
Select team → Select date (min: today + notice period)
  ↓
Submit request on behalf of club → Auto-approved
```

## Deployment Steps

1. **Database Migration**
   ```bash
   npm run db:migrate:dev  # Local
   npm run db:migrate      # Production (Render Shell)
   ```

2. **Verify Migration**
   ```bash
   npm run db:migrate:status
   ```

3. **Test Locally**
   - Create season with Free Day configuration
   - Test as club user
   - Test as league user
   - Verify notice period enforcement
   - Verify quota enforcement

4. **Deploy Code**
   - Commit all changes
   - Push to dev branch
   - Deploy to TechTest environment
   - Run migration on TechTest
   - Test both user types
   - Deploy to Staging
   - Deploy to Production

## Known Limitations

1. **Club Context Detection**: Currently detects league users by role (ADMIN/OWNER). In future, should check actual club membership/context.

2. **Component Duplication**: Free Days has separate Request and Manage components. Consider consolidating in future with role-based tabs.

3. **Notice Period Validation**: Frontend validates notice period, but backend should also validate to prevent API bypass.

4. **Quota Enforcement**: Quota checked in backend, but consider adding real-time validation in frontend before form submission.

## Future Enhancements

1. **Approval Workflow**: Add PENDING status for free days, require league approval
2. **Conflict Detection**: Check for fixture clashes when free day requested
3. **Bulk Operations**: Allow league to set free days for multiple teams
4. **Calendar View**: Show season calendar with free days highlighted
5. **Club Context**: Proper club membership check instead of role-based detection
6. **Notifications**: Email clubs when league requests free day on their behalf

## Related Documentation

- Component Creation Checklist: `/docs/LMSPRO_COMPONENT_CREATION_CHECKLIST.md`
- Architecture: `/docs/modules/lmspro/architecture.md`
- Two-Tier RBAC: `/.github/copilot-instructions.md` (Section: "Two-Tier RBAC Architecture")
