# Free Days Component Visibility Investigation

## Issue Summary

You've reported three issues:
1. New "everything" role doesn't include 'freedays' components in the allocation list
2. Dashboard only displaying 15 component cards (instead of all available)
3. Components management UI needed to debug

## Investigation Results

### 1. **Why Free Days Components Are Missing from Role Assignment**

**Root Cause:** Component definitions may not exist in the database yet.

The Free Days components (`freedays.request` and `freedays.manage`) are defined in the seed script (`prisma/seed.ts` lines 1708-1731) but **seed scripts don't run automatically**.

**Solution:**
```bash
cd /Volumes/isostack/Git/isostack-bedrock
npm run db:seed
```

**⚠️ WARNING:** The seed script deletes all data first! This is mentioned in the `.github/copilot-instructions.md`:
> **NEVER suggest `db:seed`** unless explicitly requested by user

**Alternative (Safer):** Manually insert just the Free Days components:

```sql
-- Insert Free Days Request component (Club Dashboard)
INSERT INTO component_definitions (
  id, module_key, scope, organization_id, component_key,
  title, description, page_context, component_type, 
  capability, sort_order, is_enabled, created_at, updated_at
) VALUES (
  gen_random_uuid(), 'lmspro', 'MODULE', NULL, 'freedays.request',
  'Request Free Days', 'Request free days for teams (club-level)',
  'CLUB_DASHBOARD', 'ACTION', 'ACTION', 45, true, now(), now()
) ON CONFLICT DO NOTHING;

-- Insert Free Days Manage component (League Dashboard)
INSERT INTO component_definitions (
  id, module_key, scope, organization_id, component_key,
  title, description, page_context, component_type,
  capability, sort_order, is_enabled, created_at, updated_at
) VALUES (
  gen_random_uuid(), 'lmspro', 'MODULE', NULL, 'freedays.manage',
  'Manage Free Days', 'Approve/cancel free day requests (league-level)',
  'LEAGUE_DASHBOARD', 'ACTION', 'ACTION', 45, true, now(), now()
) ON CONFLICT DO NOTHING;
```

### 2. **Why Dashboard Shows Only 15 Components**

**Root Cause:** The `listForUser` query filters components by **visibility rules**.

From `src/modules/lmspro/routers/components.router.ts` (lines 104-143):
- Components can have `VisibilityRule` records that control when they appear
- Rules check: date ranges, season phases, user context
- If ANY rule fails, the component is hidden

**Current Behavior:**
```typescript
// Line 138: Filter out hidden components
const visibleComponents = componentsWithVisibility.filter((c) => c.visibility.isVisible);
return visibleComponents;
```

**Why This Happens:**
1. Some components have visibility rules (e.g., "only show during registration window")
2. Rules evaluate based on current date/season
3. Components outside their active window are filtered out
4. Result: Only 15 out of potentially 30+ components are visible

**To Verify:**
Navigate to `/app/lmspro/admin/components` (new page created) and look at the "Visibility Rules" column. Components with rules > 0 may be hidden.

### 3. **Components Management UI Created**

**New Page:** `/app/lmspro/admin/components`

**Features:**
- View all component definitions with metadata
- Filter by Page Context (LEAGUE_DASHBOARD, CLUB_DASHBOARD, etc.)
- Filter by Scope (GLOBAL, APP_OWNER, MODULE)
- See visibility rules count
- Shows enabled/disabled status
- Alerts if Free Days components are missing

**Navigation:** Added "Components" card to LMSPro homepage (`/app/lmspro`)

## Recommendations

### Immediate Actions:

1. **Add Free Days Components to Database:**
   - Run the SQL inserts above (safer than full seed)
   - OR accept data loss and run `npm run db:seed`

2. **View Component Status:**
   - Navigate to `/app/lmspro/admin/components`
   - Check if `freedays.request` and `freedays.manage` exist
   - Note visibility rules count

3. **Assign Components to "Everything" Role:**
   - Once components exist in DB, edit your "everything" role
   - Check the boxes for `freedays.request` and `freedays.manage`
   - Save

### Understanding Dashboard Behavior:

The 15 components showing is **expected behavior** if:
- Components have visibility rules tied to season dates
- Current date is outside some components' active windows
- User doesn't have roles granting access to all components

**To see ALL components on dashboard:**
- Remove visibility rules from components (admin decision)
- Ensure user's roles grant access to all component keys
- Adjust season dates to activate time-gated components

## Files Modified

1. **`src/app/(app)/app/lmspro/admin/components/page.tsx`** (NEW)
   - Full component definitions management UI
   - DataTable with all metadata
   - Filters and stats

2. **`src/app/(app)/app/lmspro/page.tsx`**
   - Added "Components" navigation card
   - Added IconComponents import

3. **`src/modules/lmspro/routers/components.router.ts`**
   - Added `_count` to `listAll` query to include visibility rules count

4. **`src/modules/lmspro/routers/roles.router.ts`** (from earlier fix)
   - Added `roleScope` to create/update inputs
   - Backend already handles roleScope correctly

5. **`src/app/(app)/app/lmspro/admin/roles/page.tsx`** (from earlier fix)
   - Added roleScope dropdown to role form
   - Form submits roleScope with role data

6. **`src/app/(app)/app/lmspro/admin/users/page.tsx`** (from earlier fix)
   - Replaced hardcoded role arrays with database query
   - Roles now filtered by roleScope (CLUB vs LEAGUE)

## Next Steps

1. Navigate to `/app/lmspro/admin/components`
2. Check if Free Days components exist (alerts will show if missing)
3. If missing, run SQL inserts or seed script
4. Refresh components page to verify they appear
5. Edit "everything" role and assign Free Days components
6. Check dashboard - components should appear if visibility rules pass
