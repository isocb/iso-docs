# LMSPro Component Creation Checklist

**Single Source of Truth for Creating and Enabling New Dashboard Components**

Version: 1.0  
Last Updated: January 14, 2026

---

## Overview

This document provides a comprehensive checklist for creating new LMSPro dashboard components. Following these steps ensures that components:
- Deploy correctly across all environments
- Integrate with the permission system
- Support time-based visibility (seasonal key dates)
- Appear in the correct dashboard contexts
- Are assignable to roles

## Module Dashboard Philosophy (Core IsoStack Pattern)

**Principle:** Module dashboards are driven by **Module Roles**, not platform roles.

- **Platform roles** (OWNER/ADMIN/MEMBER/P1) control *access to the module*.
- **Module roles** control *which components appear* on the module dashboard.

**Model:**

```
Person → one or more Module Roles → componentKeys → dashboard components
```

**Implications:**
- A person can hold **multiple module roles**.
- A module role grants **component visibility** (functional areas + data).
- Dashboards render **only the components** granted by the person’s module roles.

This is a foundational IsoStack pattern and should be preserved in every new module.

---

## Table of Contents

1. [Planning Phase](#1-planning-phase)
2. [Component Implementation](#2-component-implementation)
   - 2.4 [Page-Level UI Requirements](#24-page-level-ui-requirements) ← **MANDATORY**
3. [Database Definition](#3-database-definition)
4. [Role & Permission Integration](#4-role--permission-integration)
5. [Time-Based Visibility (Optional)](#5-time-based-visibility-optional)
6. [Testing Checklist](#6-testing-checklist)
7. [Deployment](#7-deployment)

---

## 1. Planning Phase

### 1.1 Define Component Purpose
- [ ] **Component Name**: Clear, descriptive name (e.g., "Request Free Days")
- [ ] **Component Key**: Follow naming convention: `domain.action` (e.g., `freedays.request`)
- [ ] **Primary Use Case**: What problem does this solve for users?
- [ ] **Target Audience**: Club users? League admins? Both?

### 1.2 Determine Dashboard Context
Choose ONE primary context where the component will appear:

- [ ] **LEAGUE_DASHBOARD** - For league administrators (organization-wide view)
- [ ] **CLUB_DASHBOARD** - For club officials (club-specific view)
- [ ] **BOTH** - Requires creating TWO separate components with different keys

**Decision Criteria:**
- If users manage data across multiple clubs → LEAGUE_DASHBOARD
- If users work with their own club's data → CLUB_DASHBOARD

### 1.3 Define Component Type & Capability

**Component Type** (How it looks on dashboard):
- [ ] **WIDGET** - Stats display with 2-4 summary numbers (card pattern)
- [ ] **ACTION** - Actionable card with manage button (card pattern)
- [ ] **TABLE** - ⚠️ Use ACTION + modal instead (follow card pattern)
- [ ] **CHART** - Visual data representation (consider card pattern)
- [ ] **FORM** - ⚠️ Use ACTION + modal instead (follow card pattern)

**⚠️ Dashboard Card Pattern**: Most components should use the card pattern (Card → Modal → Form) unless they're exceptions (Clubs, Teams, AGG Manager use dedicated pages).

**Capability** (What it does):
- [ ] **VIEW** - Read-only display of information
- [ ] **ACTION** - Triggers workflow (approve, reject, create)
- [ ] **MANAGE** - Full CRUD operations (create, edit, delete)
- [ ] **ANALYZE** - Data analysis, reports, charts

**Performance Consideration**: Cards should load minimal data (2-4 stats), not full datasets.

### 1.4 Permission Requirements

**Tier 1: Access Control (Core Roles)**
Who can access this feature at all?
- [ ] **Platform Admin** - Platform-wide super users
- [ ] **OWNER** - Organization owners (full control)
- [ ] **ADMIN** - Organization administrators
- [ ] **MEMBER** - Regular members

**Tier 2: Visibility Control (Module Roles)**
Which module roles should grant this component by default?
- [ ] List all relevant roles (e.g., "League Secretary", "Age Group Manager")
- [ ] Decide if component should be in platform templates

**Backend Permission Checks:**
- [ ] Identify which tRPC endpoints this component calls
- [ ] Document required permission checks for each endpoint
- [ ] Plan for multi-tenant data scoping (organizationId filtering)

---

## 2. Component Implementation

### 2.1 Create Component File
Location: `src/modules/lmspro/components/dashboard/`

**⚠️ CRITICAL**: Dashboard components MUST follow the **Dashboard Card Pattern** (see `docs/00-READ_THIS/DASHBOARD_CARD_PATTERN.md`).

**Dashboard Card Pattern Overview:**
- **Card**: Navigation anchor with 2-4 summary stats (minimal data loading)
- **Management Modal**: Full CRUD interface with DataTable
- **Form Modal**: Create/edit operations (nested within management modal)

**Exceptions**: Clubs, Teams, AGG Manager use dedicated pages (not card pattern)

```tsx
// File: YourComponent.tsx
'use client';

import { Card, Text, Stack, SimpleGrid, Group, Button, Modal, Alert } from '@mantine/core';
import { IconArrowRight, IconAlertCircle } from '@tabler/icons-react';
import { useDisclosure } from '@mantine/hooks';
import type { ComponentDefinition } from '@prisma/client';

interface YourComponentProps {
  config?: any; // From ComponentDefinition.config JSON
  componentDef: ComponentDefinition; // Full component definition
}

export function YourComponent({ config, componentDef }: YourComponentProps) {
  // State for modals
  const [managementModalOpened, { open: openManagement, close: closeManagement }] = useDisclosure(false);
  const [formModalOpened, { open: openForm, close: closeForm }] = useDisclosure(false);
  
  // Query for stats only (minimal data for card)
  const { data: stats } = trpc.lmspro.yourRouter.getStats.useQuery();
  
  // Query for full data (only when modal opens)
  const { data: fullData } = trpc.lmspro.yourRouter.list.useQuery(
    undefined,
    { enabled: managementModalOpened }
  );
  
  // Calculate stats for card display
  const activeCount = stats?.active || 0;
  const totalCount = stats?.total || 0;
  const needsAttention = activeCount > 0;

  return (
    <>
      {/* DASHBOARD CARD - Navigation Anchor with Summary Stats */}
      <Card withBorder padding="lg" radius="md">
        <Stack gap="md">
          {/* Header with Icon */}
          <Group justify="space-between" align="flex-start">
            <div>
              <Title order={4}>{componentDef.title}</Title>
              {componentDef.description && (
                <Text size="sm" c="dimmed" mt={4}>
                  {componentDef.description}
                </Text>
              )}
            </div>
            <IconYourIcon size={28} style={{ color: 'var(--mantine-color-blue-6)' }} />
          </Group>

          {/* Stats Grid - 2-4 summary numbers */}
          <SimpleGrid cols={2}>
            <Card withBorder padding="md" bg={needsAttention ? 'red.0' : 'blue.0'}>
              <Stack gap={4}>
                <Text size="xl" fw={700} c={needsAttention ? 'red' : 'blue'}>
                  {activeCount}
                </Text>
                <Text size="sm" c="dimmed">
                  Active Items
                </Text>
              </Stack>
            </Card>

            <Card withBorder padding="md" bg="gray.0">
              <Stack gap={4}>
                <Text size="xl" fw={700} c="gray">
                  {totalCount}
                </Text>
                <Text size="sm" c="dimmed">
                  Total Records
                </Text>
              </Stack>
            </Card>
          </SimpleGrid>

          {/* Navigation Button */}
          <Button 
            fullWidth 
            onClick={openManagement}
            rightSection={<IconArrowRight size={16} />}
          >
            Manage {componentDef.title}
          </Button>

          {/* Alert (when attention needed) */}
          {needsAttention && (
            <Alert color="red" icon={<IconAlertCircle size={16} />}>
              {activeCount} items require attention
            </Alert>
          )}
        </Stack>
      </Card>

      {/* MANAGEMENT MODAL - Full CRUD Interface */}
      <Modal
        opened={managementModalOpened}
        onClose={closeManagement}
        title={componentDef.title}
        size="xl"
        padding="lg"
      >
        <Stack gap="lg">
          <Group justify="space-between">
            <Button onClick={openForm}>Create New</Button>
            {/* Add filters/actions here */}
          </Group>

          <DataTable
            records={fullData || []}
            onRowClick={(record) => {/* Open edit form */}}
            columns={[
              { accessor: 'name', title: 'Name' },
              // ... other columns
            ]}
            minHeight={300}
          />
        </Stack>
      </Modal>

      {/* FORM MODAL - Create/Edit Operations */}
      <Modal
        opened={formModalOpened}
        onClose={closeForm}
        title="Create/Edit Item"
        size="lg"
      >
        <Stack gap="md">
          {/* Form fields here */}
          
          <Group justify="flex-end">
            <Button variant="subtle" onClick={closeForm}>Cancel</Button>
            <Button onClick={handleSubmit}>Save</Button>
          </Group>
        </Stack>
      </Modal>
    </>
  );
}
```

**Checklist:**
- [ ] File created in `src/modules/lmspro/components/dashboard/`
- [ ] Component accepts `config` and `componentDef` props
- [ ] **Follows Dashboard Card Pattern** (Card → Modal → Form)
- [ ] **Card shows 2-4 summary stats only** (minimal data loading)
- [ ] **Stats are colour-coded** (red.0/orange.0/blue.0/green.0/gray.0)
- [ ] **"Manage" button with right arrow icon** opens modal
- [ ] **Alert shown when attention needed** (e.g., activeCount > 0)
- [ ] **Management modal contains DataTable** with full data
- [ ] **Form modal nested** for create/edit operations
- [ ] **Separate state for each modal** (don't reuse same state)
- [ ] Uses Mantine UI components for consistency
- [ ] Handles loading states
- [ ] Handles error states
- [ ] Displays user-friendly empty states
- [ ] Mobile-responsive design
- [ ] See `docs/00-READ_THIS/DASHBOARD_CARD_PATTERN.md` for full guidelines

### 2.2 Register Component
Location: `src/modules/lmspro/components/registry.tsx`

```tsx
// 1. Import the component
import { YourComponent } from './dashboard/YourComponent';

// 2. Add to componentRegistry
export const componentRegistry: Record<
  string,
  React.ComponentType<ComponentProps>
> = {
  // ... existing components
  'your.component.key': YourComponent,
};
```

**Checklist:**
- [ ] Import added at top of file
- [ ] Component key matches database definition exactly
- [ ] Entry added to componentRegistry object

### 2.3 Create tRPC Endpoints (if needed)
Location: `src/modules/lmspro/routers/yourFeature.router.ts`

```typescript
import { router, protectedProcedure } from '@/server/core/trpc';
import { z } from 'zod';
import { TRPCError } from '@trpc/server';

export const yourFeatureRouter = router({
  getData: protectedProcedure
    .input(z.object({
      // Define input schema
    }))
    .query(async ({ ctx, input }) => {
      // CRITICAL: Always scope by organizationId for multi-tenancy
      const data = await ctx.prisma.yourModel.findMany({
        where: {
          organizationId: ctx.session.user.organizationId,
          // ... other filters
        },
      });
      
      return data;
    }),
    
  performAction: protectedProcedure
    .input(z.object({
      // Define input schema
    }))
    .mutation(async ({ ctx, input }) => {
      // Check permissions (if needed beyond basic auth)
      // Example: Check if user is ADMIN or OWNER
      if (!['ADMIN', 'OWNER'].includes(ctx.session.user.role)) {
        throw new TRPCError({
          code: 'FORBIDDEN',
          message: 'Only admins can perform this action',
        });
      }
      
      // Perform action
      const result = await ctx.prisma.yourModel.create({
        data: {
          organizationId: ctx.session.user.organizationId,
          // ... other fields
        },
      });
      
      // Audit log for important actions
      await ctx.prisma.auditLog.create({
        data: {
          action: 'YOUR_ACTION',
          entityType: 'YourModel',
          entityId: result.id,
          userId: ctx.session.user.id,
          organizationId: ctx.session.user.organizationId,
        },
      });
      
      return result;
    }),
});
```

**Register Router** in `src/server/core/routers/index.ts`:
```typescript
export const appRouter = router({
  // ... existing routers
  yourFeature: yourFeatureRouter,
});
```

**Checklist:**
- [ ] Router file created
- [ ] All queries/mutations use Zod input validation
- [ ] **CRITICAL**: All database queries filtered by `organizationId`
- [ ] Permission checks implemented where needed
- [ ] Audit logs created for sensitive operations
- [ ] Error handling with user-friendly messages
- [ ] Router registered in main appRouter

### 2.4 Page-Level UI Requirements

**🚨 MANDATORY:** All LMSPro pages MUST include the following UI elements unless explicitly requested to be removed.

#### Breadcrumb Navigation (REQUIRED)

Every page must have breadcrumb navigation at the top to provide consistent navigation and user orientation.

**Pattern for Regular Pages (2-level):**
```tsx
import { Breadcrumbs, Anchor, Text } from '@mantine/core';
import Link from 'next/link';

// Inside your component, after opening Stack
<Breadcrumbs>
  <Anchor component={Link} href="/app/lmspro/dashboard" size="sm">
    Dashboard
  </Anchor>
  <Text size="sm">Page Name</Text>
</Breadcrumbs>
```

**Pattern for Admin Pages (3-level):**
```tsx
import { Breadcrumbs, Anchor, Text } from '@mantine/core';
import Link from 'next/link';

// Inside your component, after opening Stack
<Breadcrumbs>
  <Anchor component={Link} href="/app/lmspro/dashboard" size="sm">
    Dashboard
  </Anchor>
  <Text size="sm">Admin</Text>
  <Text size="sm">Page Name</Text>
</Breadcrumbs>
```

**Current Implementation Examples:**
- Regular pages: `/app/lmspro/clubs/page.tsx`, `/app/lmspro/teams/page.tsx`
- Admin pages: `/app/lmspro/admin/roles/page.tsx`, `/app/lmspro/admin/users/page.tsx`

**Breadcrumb Checklist:**
- [ ] Breadcrumbs placed immediately after opening `<Stack gap="lg">` or `<Container>`
- [ ] First item links to Dashboard (`/app/lmspro/dashboard`)
- [ ] Admin pages include "Admin" as middle text item (non-clickable)
- [ ] Current page name is `<Text>` (non-clickable), not `<Anchor>`
- [ ] Uses `size="sm"` for consistent sizing

**Required Imports:**
```tsx
import { Breadcrumbs, Anchor, Text } from '@mantine/core';
import Link from 'next/link';
```

---

## 3. Database Definition

### 3.1 Create Migration for Component Definition

**Option A: Via Migration (Recommended for Production)**

1. Create empty migration:
```bash
npx prisma migrate dev --name add_your_component --create-only
```

2. Edit migration file in `prisma/migrations/XXXXXX_add_your_component/migration.sql`:

```sql
-- Add Your Component Definition
INSERT INTO "public"."component_definitions" (
  id,
  "componentKey",        -- MUST match registry key EXACTLY
  title,                 -- User-friendly display name
  description,           -- Help text (optional)
  "pageContext",         -- LEAGUE_DASHBOARD | CLUB_DASHBOARD
  "componentType",       -- WIDGET | TABLE | CHART | ACTION | FORM
  scope,                 -- MODULE (for module components)
  capability,            -- VIEW | ACTION | MANAGE | ANALYZE
  "moduleKey",           -- 'lmspro' for LMSPro components
  "sortOrder",           -- Display order (10-100 recommended)
  "isEnabled",           -- true to enable immediately
  "createdAt",
  "updatedAt",
  "organizationId"       -- NULL for platform-wide components
) VALUES (
  gen_random_uuid(),
  'your.component.key',  -- CRITICAL: Match registry key
  'Your Component Title',
  'Brief description of what this component does',
  'LEAGUE_DASHBOARD',    -- or CLUB_DASHBOARD
  'ACTION',              -- or WIDGET, TABLE, CHART, FORM
  'MODULE',
  'ACTION',              -- or VIEW, MANAGE, ANALYZE
  'lmspro',
  50,                    -- Adjust sort order as needed
  true,
  NOW(),
  NOW(),
  NULL                   -- NULL = platform-wide
) ON CONFLICT ("organizationId", "moduleKey", "componentKey", "pageContext") DO NOTHING;
```

3. Apply migration:
```bash
npx prisma migrate dev
```

**Option B: Via Seed Script (Development Only)**

Add to `prisma/seed.ts` (NOT recommended for deployed environments):
```typescript
await prisma.componentDefinition.create({
  data: {
    componentKey: 'your.component.key',
    title: 'Your Component Title',
    description: 'Brief description',
    pageContext: 'LEAGUE_DASHBOARD',
    componentType: 'ACTION',
    scope: 'MODULE',
    capability: 'ACTION',
    moduleKey: 'lmspro',
    sortOrder: 50,
    isEnabled: true,
  },
});
```

**⚠️ WARNING**: `npm run db:seed` deletes ALL data first. Use migrations for production!

### 3.2 Database Definition Checklist

- [ ] **componentKey**: Matches registry key EXACTLY (case-sensitive)
- [ ] **title**: Clear, user-friendly name (3-5 words)
- [ ] **description**: Explains purpose (1-2 sentences, optional)
- [ ] **pageContext**: Correct dashboard context (LEAGUE_DASHBOARD or CLUB_DASHBOARD)
- [ ] **componentType**: Matches UI type (WIDGET, TABLE, CHART, ACTION, FORM)
- [ ] **scope**: Set to 'MODULE' for module components
- [ ] **capability**: Matches permission level (VIEW, ACTION, MANAGE, ANALYZE)
- [ ] **moduleKey**: Set to 'lmspro'
- [ ] **sortOrder**: Logical display order (10-100 range)
- [ ] **isEnabled**: Set to `true` to activate
- [ ] **organizationId**: Set to `NULL` for platform-wide components
- [ ] **ON CONFLICT clause**: Prevents duplicate inserts (idempotent)

### 3.3 Verify Component in Database

Run check script:
```bash
node scripts/check-freedays.mjs
```

Or query directly:
```bash
npx prisma studio
# Navigate to component_definitions table
# Filter by componentKey = 'your.component.key'
```

Or use Node.js query:
```bash
node -e "
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function check() {
  const component = await prisma.componentDefinition.findFirst({
    where: { componentKey: 'your.component.key' },
    select: {
      componentKey: true,
      title: true,
      pageContext: true,
      isEnabled: true,
      scope: true,
      organizationId: true,
    }
  });
  console.log(JSON.stringify(component, null, 2));
  await prisma.\$disconnect();
}

check().catch(console.error);
"
```

**Verification Checklist:**
- [ ] Component exists in `component_definitions` table
- [ ] `isEnabled` is `true`
- [ ] `componentKey` matches registry exactly
- [ ] `pageContext` is correct (use comma-separated for multiple: `CLUB_DASHBOARD,LEAGUE_DASHBOARD`)
- [ ] `moduleKey` is 'lmspro'
- [ ] `scope` is 'MODULE'

### 3.4 Restart Development Server

**⚠️ CRITICAL**: After database changes, you MUST restart the dev server for changes to appear!

```bash
# Stop the dev server (Ctrl+C)
npm run dev
```

The dev server caches database queries, so new component definitions won't appear in the role assignment UI until you restart.

**Verification:**
- [ ] Dev server restarted after database migration
- [ ] Navigate to `/app/lmspro/admin/roles` 
- [ ] Click on any role card
- [ ] Scroll through "Granted Components" checklist
- [ ] **Verify your new component appears in the list**

---

## 4. Role & Permission Integration

### 4.1 Assign Component to Roles

Components must be assigned to roles before users can see them on dashboards.

**⚠️ PREREQUISITE**: Ensure dev server has been restarted after database migration (see Section 3.4).

**Via UI (Recommended):**
1. **Restart dev server** if you just created the component
2. Navigate to `/app/lmspro/admin/roles`
3. Click on a role card (e.g., "League Administrator")
4. **Scroll through "Granted Components" checklist** - your component should appear
5. Check the component checkbox
6. Click "Save"

**Troubleshooting**: If component doesn't appear in the list:
- [ ] Verify component exists in database (Section 3.3)
- [ ] **Restart dev server** (Section 3.4) - Most common issue!
- [ ] Check browser console for errors
- [ ] Verify `isEnabled` is `true` in database
- [ ] Check `componentKey` matches registry exactly (case-sensitive)

**Via Migration/Seed (Platform Templates):**

**⚠️ CRITICAL: TWO PLACES MUST BE UPDATED:**

**1. Update `prisma/seed.ts`** (for fresh installs/seeding):
```typescript
// Find the role definition in seed.ts (around line 1165)
// Add your componentKey to the role's componentKeys array:
{
  moduleKey: 'lmspro',
  name: 'League Administrator',
  // ... other fields ...
  componentKeys: [
    // ... existing keys ...
    'your.component.key',  // ← ADD YOUR NEW KEY HERE
  ],
},
```

**2. Create SQL script** (for deployed environments):
```sql
-- File: scripts/add-your-component-to-roles.sql
-- Update existing role templates in deployed databases
UPDATE "public"."module_roles"
SET "componentKeys" = array_append("componentKeys", 'your.component.key'),
    "updatedAt" = NOW()
WHERE name = 'League Administrator' 
  AND "moduleKey" = 'lmspro'
  AND NOT ('your.component.key' = ANY("componentKeys"));
```

Run on deployed environments:
```bash
npx prisma db execute --file scripts/add-your-component-to-roles.sql --schema prisma/schema.prisma
```

**Why Both?**
- `seed.ts` → Ensures fresh installs have the role configured correctly
- SQL script → Updates existing deployed databases without re-seeding

**Checklist:**
- [ ] Identify which roles should grant this component
- [ ] **Update `prisma/seed.ts`** - Add componentKey to relevant role templates
- [ ] **Create SQL script** - For updating deployed environments
- [ ] Assign component to platform templates (if applicable)
- [ ] Assign component to custom organization roles (if needed)
- [ ] Verify component appears in role's component list
- [ ] Test with user who has that role

### 4.2 Permission System Integration

**Understand Two-Tier RBAC:**

**Tier 1: Access Control (Hard Boundary)**
- Platform Admin → Super user across all organizations
- OWNER → Full control within organization
- ADMIN → Admin control within organization  
- MEMBER → Basic access within organization

**Tier 2: Component Visibility (Soft Boundary)**
- User.lmsproRoleIds → Array of role UUIDs
- ModuleRole.componentKeys → Array of component keys
- Dashboard filters components based on user's combined componentKeys

**Key Principle**: Module roles control WHAT users SEE, not WHAT they CAN DO.

**Backend Permission Patterns:**

```typescript
// Pattern 1: Require specific core role
import { requireRole } from '@/server/core/trpc';

export const router = router({
  adminAction: requireRole(['ADMIN', 'OWNER'])
    .mutation(async ({ ctx, input }) => {
      // Only ADMIN/OWNER can call this
    }),
});

// Pattern 2: Check permission in resolver
.query(async ({ ctx, input }) => {
  if (!['ADMIN', 'OWNER'].includes(ctx.session.user.role)) {
    throw new TRPCError({ code: 'FORBIDDEN' });
  }
}),

// Pattern 3: Check platform admin status
import { isPlatformAdmin } from '@/server/permissions';

if (isPlatformAdmin(ctx.session)) {
  // Platform admin has access
}
```

**Checklist:**
- [ ] Document which Tier 1 roles should access backend endpoints
- [ ] Implement permission checks in tRPC resolvers
- [ ] Test that users without permission get proper error messages
- [ ] Verify that component visibility doesn't bypass backend permissions
- [ ] Add audit logging for sensitive operations

---

## 5. Time-Based Visibility (Optional)

Components can be shown/hidden based on seasonal key dates using Visibility Rules.

### 5.1 Seasonal Key Dates Setup

**Pre-requisite**: Season must have key dates configured.

Navigate to `/app/lmspro/admin/seasonal-workflows` (Coming Soon) to configure:
- **Club Registration Opens** - Date when clubs can register
- **Club Registration Closes** - Deadline for club registrations
- **Team Registration Opens** - Date when teams can register
- **Team Registration Closes** - Deadline for team registrations
- **Season Start** - First day of season
- **Season End** - Last day of season
- **Free Days Request Opens** - When clubs can request free days
- **Free Days Request Closes** - Deadline for free day requests

### 5.2 Create Visibility Rule

**Database Schema:**
```typescript
model VisibilityRule {
  id                    String              @id @default(uuid())
  componentDefinitionId String
  seasonKeyDateType     String              // "CLUB_REGISTRATION_OPENS"
  offsetDays            Int                 // +/- days from key date
  isVisible             Boolean             // Show or hide
  
  componentDefinition   ComponentDefinition @relation(...)
}
```

**Example: Show "Request Free Days" only during request window:**

```sql
-- Show component 7 days before Free Days Request Opens
INSERT INTO "public"."visibility_rules" (
  id,
  "componentDefinitionId",
  "seasonKeyDateType",
  "offsetDays",
  "isVisible"
) VALUES (
  gen_random_uuid(),
  (SELECT id FROM component_definitions WHERE "componentKey" = 'freedays.request'),
  'FREE_DAYS_REQUEST_OPENS',
  -7,  -- 7 days before opening
  true
);

-- Hide component after Free Days Request Closes
INSERT INTO "public"."visibility_rules" (
  id,
  "componentDefinitionId",
  "seasonKeyDateType",
  "offsetDays",
  "isVisible"
) VALUES (
  gen_random_uuid(),
  (SELECT id FROM component_definitions WHERE "componentKey" = 'freedays.request'),
  'FREE_DAYS_REQUEST_CLOSES',
  0,  -- On closing date
  false
);
```

**Visibility Rule Patterns:**

| Use Case | Key Date Type | Offset | isVisible |
|----------|---------------|--------|-----------|
| Show during registration window | CLUB_REGISTRATION_OPENS | 0 | true |
| Hide after registration closes | CLUB_REGISTRATION_CLOSES | 0 | false |
| Early access (7 days before) | SEASON_START | -7 | true |
| Late access (remain visible 30 days after) | SEASON_END | +30 | false |

### 5.3 Visibility Rule Checklist

- [ ] Identify if component should be time-scoped
- [ ] Determine which seasonal key date(s) control visibility
- [ ] Calculate offset days (before/after key date)
- [ ] Create visibility rules in database
- [ ] Test visibility changes around key dates
- [ ] Document visibility logic in component description

**Testing Visibility Rules:**
1. Set a season's key date to today
2. Verify component appears/disappears as expected
3. Test with offsets (e.g., set date to tomorrow, verify early access)
4. Check multiple seasons (component should respect current season's dates)

---

## 6. Testing Checklist

### 6.1 Component Registry Test
- [ ] Component appears in registry: `src/modules/lmspro/components/registry.tsx`
- [ ] Component key matches database definition exactly
- [ ] Component file imports successfully (no TypeScript errors)

### 6.2 Database Definition Test
- [ ] Component exists in `component_definitions` table
- [ ] Run: `node scripts/check-freedays.mjs` to verify
- [ ] `isEnabled` is `true`
- [ ] All required fields populated correctly

### 6.3 Role Assignment Test
- [ ] **Restart dev server** after creating component definition
- [ ] Navigate to `/app/lmspro/admin/roles`
- [ ] Click on a role (e.g., "League Administrator")
- [ ] **Verify component appears in "Granted Components" checklist**
  - If not visible: Restart dev server and hard-refresh browser (Cmd+Shift+R)
- [ ] Check the component checkbox
- [ ] Click "Save"
- [ ] Verify role's componentKeys array includes your component
### 6.4 Dashboard Display Test
- [ ] Log in as user with role that grants component
- [ ] Navigate to appropriate dashboard:
  - LEAGUE_DASHBOARD: `/app/lmspro/dashboard`
  - CLUB_DASHBOARD: `/app/lmspro/club/[clubId]/dashboard`
- [ ] Verify component appears on dashboard
- [ ] **Verify card shows 2-4 summary stats** (not full data)
- [ ] **Verify stats are colour-coded correctly** (red/orange/blue/green/gray)
- [ ] **Click "Manage" button** - modal opens
- [ ] **Verify DataTable in modal** - full data loads
- [ ] **Verify modal performs CRUD operations** correctly
- [ ] **Check dashboard loads quickly** (cards should be fast)
- [ ] Verify component renders without errors
- [ ] Check browser console for errorshboard`
  - CLUB_DASHBOARD: `/app/lmspro/club/[clubId]/dashboard`
- [ ] Verify component appears on dashboard
- [ ] Verify component renders without errors
- [ ] Check browser console for errors

### 6.5 Permission Test
- [ ] Log in as user WITHOUT role that grants component
- [ ] Verify component does NOT appear on dashboard
- [ ] Try to call backend endpoint directly (if applicable)
- [ ] Verify proper permission error returned

### 6.6 Data Isolation Test (Multi-Tenancy)
- [ ] Log in as user from Organization A
- [ ] Interact with component
- [ ] Verify only Organization A's data is visible
- [ ] Log in as user from Organization B
- [ ] Verify Organization A's data is NOT visible

### 6.7 Visibility Rule Test (If Applicable)
- [ ] Set season key date to control visibility
- [ ] Verify component appears/disappears based on date
- [ ] Test offset days (set date to trigger early/late access)
- [ ] Verify multiple visibility rules work together correctly

### 6.8 Mobile Responsiveness Test
- [ ] View component on mobile device or browser DevTools
- [ ] Verify layout adapts correctly
- [ ] Test all interactive elements (buttons, forms, etc.)
- [ ] Verify text is readable without horizontal scrolling

---

## 7. Deployment

### 7.1 Code Deployment

**Files to Commit:**
- [ ] Component file: `src/modules/lmspro/components/dashboard/YourComponent.tsx`
- [ ] Registry update: `src/modules/lmspro/components/registry.tsx`
- [ ] tRPC router (if new): `src/modules/lmspro/routers/yourFeature.router.ts`
- [ ] Router registration: `src/server/core/routers/index.ts` (if new router)
- [ ] Migration file: `prisma/migrations/XXXXXX_add_your_component/migration.sql`
- [ ] **Seed update**: `prisma/seed.ts` - Add componentKey to role templates
- [ ] **SQL script**: `scripts/add-your-component-to-roles.sql` - For deployed environments
- [ ] This checklist (if updated): `docs/LMSPRO_COMPONENT_CREATION_CHECKLIST.md`

**Commit Message Format:**
```
feat(lmspro): add Your Component feature

- Create YourComponent dashboard component
- Add tRPC endpoints for data fetching
- Create migration for component definition
- Register component in registry
- Update role componentKeys in seed.ts
- Add SQL script for deployed environment role updates
- Update documentation

Closes #123
```

### 7.2 Database Migration Deployment

**Local Development (dev branch):**
1. Create migration: `npm run db:migrate:dev --name add_your_component`
2. Review generated SQL
3. Test locally
4. Commit migration files

**Deployed Environments (TechTest, Staging, Production):**
1. Merge code to target branch
2. In Render Shell: `npm run db:migrate`
3. **Run role update SQL**: `npx prisma db execute --file scripts/add-your-component-to-roles.sql --schema prisma/schema.prisma`
4. Verify migration applied: `npm run db:migrate:status`
4. Check logs for errors

**⚠️ NEVER on Deployed Environments:**
- `npm run db:seed` - Deletes all data first!
- `npm run db:push` - No audit trail, not idempotent
- `npm run db:migrate:reset` - Nuclear option, wipes database

### 7.3 Post-Deployment Verification

**In Each Environment (TechTest, Staging, Production):**
- [ ] Migration applied successfully: `npm run db:migrate:status`
- [ ] Component appears in Components page: `/app/lmspro/admin/components`
- [ ] Component shows linked roles correctly
- [ ] Test role assignment workflow
- [ ] Test dashboard display with multiple users
- [ ] Check browser console for errors
- [ ] Monitor server logs for backend errors
- [ ] Verify audit logs are created (if applicable)

### 7.4 Rollback Plan

If deployment fails:

**Immediate Rollback:**
```bash
# 1. Revert code deployment via Git
git revert <commit-hash>
git push origin <branch>

# 2. Revert database migration (if needed)
# WARNING: Only if migration has bugs, NOT for data preservation
# Contact platform admin before reverting migrations
```

**Safe Disable (Preserve Data):**
```sql
-- Temporarily disable component without reverting migration
UPDATE component_definitions
SET "isEnabled" = false
WHERE "componentKey" = 'your.component.key';
```

### 7.5 Documentation Updates

- [ ] Update module README with new component
- [ ] Add component to user-facing documentation
- [ ] Update API documentation (if new endpoints)
- [ ] Document any configuration options
- [ ] Update changelog with new feature

---

## Common Patterns & Examples

**⚠️ IMPORTANT**: All dashboard components MUST follow the Dashboard Card Pattern. Legacy patterns below are for reference only.

### Pattern 1: Dashboard Card with Summary Stats (RECOMMENDED)
```typescript
// Component: suspensions.manage
// Type: ACTION
// Capability: MANAGE
// Context: LEAGUE_DASHBOARD
// Pattern: Card → Management Modal → Form Modal

export function SuspensionManagement({ componentDef }: ComponentProps) {
  const [managementModalOpened, { open: openManagement, close: closeManagement }] = useDisclosure(false);
  const [formModalOpened, { open: openForm, close: closeForm }] = useDisclosure(false);
  
  // Stats query for card (minimal data)
  const { data: records } = trpc.lmspro.disciplinary.list.useQuery({ status: null });
  
  const activeCount = records?.filter(r => r.status === 'ACTIVE').length || 0;
  const totalCount = records?.length || 0;

  return (
    <>
      {/* CARD: Navigation Anchor with Stats */}
      <Card withBorder padding="lg" radius="md">
        <Stack gap="md">
          <Group justify="space-between">
            <div>
              <Title order={4}>{componentDef.title}</Title>
              <Text size="sm" c="dimmed">{componentDef.description}</Text>
            </div>
            <IconGavel size={28} style={{ color: 'var(--mantine-color-red-6)' }} />
          </Group>

          <SimpleGrid cols={2}>
            <Card withBorder padding="md" bg={activeCount > 0 ? 'red.0' : 'gray.0'}>
              <Stack gap={4}>
                <Text size="xl" fw={700} c={activeCount > 0 ? 'red' : 'gray'}>
                  {activeCount}
                </Text>
                <Text size="sm" c="dimmed">Active Suspensions</Text>
              </Stack>
            </Card>

            <Card withBorder padding="md" bg="gray.0">
              <Stack gap={4}>
                <Text size="xl" fw={700} c="gray">{totalCount}</Text>
                <Text size="sm" c="dimmed">Total Records</Text>
              </Stack>
            </Card>
          </SimpleGrid>

          <Button fullWidth onClick={openManagement} rightSection={<IconArrowRight size={16} />}>
            Manage Suspensions
          </Button>

          {activeCount > 0 && (
            <Alert color="red" icon={<IconAlertCircle size={16} />}>
              {activeCount} active suspensions require attention
            </Alert>
          )}
        </Stack>
      </Card>

      {/* MANAGEMENT MODAL: Full CRUD Interface */}
      <Modal opened={managementModalOpened} onClose={closeManagement} title="Suspension Management" size="xl">
        <Stack gap="lg">
          <Group justify="space-between">
            <Button onClick={openForm}>Impose Suspension</Button>
            <Select placeholder="Filter by status" data={['ALL', 'ACTIVE', 'LIFTED', 'EXPIRED']} />
          </Group>

          <DataTable
            records={records || []}
            onRowClick={(record) => {/* Open edit */}}
            columns={[
              { accessor: 'entityName', title: 'Entity' },
              { accessor: 'type', title: 'Type' },
              { accessor: 'status', title: 'Status' },
            ]}
            minHeight={300}
          />
        </Stack>
      </Modal>

      {/* FORM MODAL: Create/Edit */}
      <Modal opened={formModalOpened} onClose={closeForm} title="Impose Suspension" size="lg">
        <Stack gap="md">
          {/* Form fields */}
          <Group justify="flex-end">
            <Button variant="subtle" onClick={closeForm}>Cancel</Button>
            <Button onClick={handleSubmit}>Impose Suspension</Button>
          </Group>
        </Stack>
      </Modal>
    </>
  );
}
```

### Pattern 2: Simple Stats Widget (View-Only)
```typescript
// Component: clubs.stats.view
// Type: WIDGET
// Capability: VIEW
// Context: LEAGUE_DASHBOARD

export function ClubStatsWidget({ componentDef }: ComponentProps) {
  const { data } = trpc.lmspro.clubs.getStats.useQuery();
  
  return (
    <Card withBorder padding="lg">
      <Stack gap="md">
        <Text fw={600}>{componentDef.title}</Text>
        
        <SimpleGrid cols={3}>
          <Stack gap={4}>
            <Text size="xl" fw={700} c="blue">{data?.approved || 0}</Text>
            <Text size="sm" c="dimmed">Approved</Text>
          </Stack>
          <Stack gap={4}>
            <Text size="xl" fw={700} c="orange">{data?.pending || 0}</Text>
            <Text size="sm" c="dimmed">Pending</Text>
          </Stack>
          <Stack gap={4}>
            <Text size="xl" fw={700} c="gray">{data?.total || 0}</Text>
            <Text size="sm" c="dimmed">Total</Text>
          </Stack>
        </SimpleGrid>
      </Stack>
    </Card>
  );
}
```

### Pattern 3: Pending Approvals (Action Card)
```typescript
// Component: teams.pending.approve
// Type: ACTION
// Capability: ACTION
// Context: LEAGUE_DASHBOARD

export function PendingTeamsApproval({ componentDef }: ComponentProps) {
  const [managementModalOpened, { open, close }] = useDisclosure(false);
  const { data: pending } = trpc.lmspro.teams.listPending.useQuery();
  
  const pendingCount = pending?.length || 0;

  return (
    <>
      <Card withBorder padding="lg">
        <Stack gap="md">
          <Group justify="space-between">
            <div>
              <Title order={4}>{componentDef.title}</Title>
              <Text size="sm" c="dimmed">Teams awaiting approval</Text>
            </div>
            <IconUsers size={28} style={{ color: 'var(--mantine-color-orange-6)' }} />
          </Group>

          <Card withBorder padding="md" bg={pendingCount > 0 ? 'orange.0' : 'green.0'}>
            <Stack gap={4}>
              <Text size="xl" fw={700} c={pendingCount > 0 ? 'orange' : 'green'}>
                {pendingCount}
              </Text>
              <Text size="sm" c="dimmed">Pending Approval</Text>
            </Stack>
          </Card>

          <Button 
            fullWidth 
            onClick={open} 
            disabled={pendingCount === 0}
            rightSection={<IconArrowRight size={16} />}
          >
            Review Teams
          </Button>

          {pendingCount > 0 && (
            <Alert color="orange" icon={<IconAlertCircle size={16} />}>
              {pendingCount} teams require approval
            </Alert>
          )}
        </Stack>
      </Card>

      <Modal opened={managementModalOpened} onClose={close} title="Pending Teams" size="xl">
        <DataTable
          records={pending || []}
          columns={[
            { accessor: 'name', title: 'Team Name' },
            { accessor: 'club.name', title: 'Club' },
            { 
              accessor: 'actions',
              title: 'Actions',
              render: (team) => (
                <Group gap="xs">
                  <Button size="xs" color="green" onClick={() => approve(team.id)}>
                    Approve
                  </Button>
                  <Button size="xs" color="red" variant="outline" onClick={() => reject(team.id)}>
                    Reject
                  </Button>
                </Group>
              ),
            },
          ]}
        />
      </Modal>
    </>
  );
}
```

### ❌ LEGACY Pattern: Full CRUD in Card (DO NOT USE)
```typescript
// ❌ ANTI-PATTERN: Putting DataTable directly in card
// This violates the Dashboard Card Pattern and should be refactored

export function LegacyTableInCard({ componentDef }: ComponentProps) {
  const { data } = trpc.lmspro.teams.list.useQuery(); // Loads ALL data on dashboard
  
  return (
    <Card withBorder>
      <Stack>
        <Group justify="space-between">
          <Text fw={600}>Teams</Text>
          <Button onClick={openCreateModal}>Create Team</Button>
        </Group>
        
        {/* ❌ Full DataTable in card - loads all data on dashboard */}
        <DataTable
          records={data || []} // Could be 100+ records
          columns={[/* many columns */]}
        />
      </Stack>
    </Card>
  );
}

// ✅ CORRECT: Card with stats, DataTable in modal
export function ModernTeamsCard({ componentDef }: ComponentProps) {
  const { data: stats } = trpc.lmspro.teams.getStats.useQuery(); // Only loads counts
  const [opened, { open, close }] = useDisclosure(false);
  
  return (
    <>
      <Card withBorder>
        <Stack gap="md">
          <Text fw={600}>Teams</Text>
          <SimpleGrid cols={2}>
            <Card withBorder padding="md" bg="blue.0">
              <Text size="xl" fw={700} c="blue">{stats?.active || 0}</Text>
              <Text size="sm" c="dimmed">Active</Text>
            </Card>
            <Card withBorder padding="md" bg="gray.0">
              <Text size="xl" fw={700} c="gray">{stats?.total || 0}</Text>
              <Text size="sm" c="dimmed">Total</Text>
            </Card>
          </SimpleGrid>
          <Button fullWidth onClick={open}>Manage Teams</Button>
        </Stack>
      </Card>
      
      <Modal opened={opened} onClose={close} size="xl">
        {/* DataTable only loads when modal opens */}
        <TeamManagementContent />
      </Modal>
    </>
  );
}
```

---

## Related Documentation

- **⭐ Dashboard Card Pattern**: `/docs/00-READ_THIS/DASHBOARD_CARD_PATTERN.md` (MANDATORY)
- **Architecture**: `/docs/00-overview/architecture.md`
- **Module System**: `/docs/modules/lmspro/architecture.md`
- **Permissions**: `/docs/core/permissions.md`
- **Component System**: `/docs/modules/lmspro/components.md`
- **Seasonal Workflows**: `/docs/modules/lmspro/seasonal-workflows.md`
- **Table CRUD Pattern**: `/docs/guides/table-crud-pattern.md`
   ```bash
   node scripts/check-freedays.mjs
   ```

### Component Not Appearing on Dashboard

**Symptoms**: User has role with component, but component doesn't show on dashboard

**Fixes**:
1. Verify component is registered in registry:
   ```tsx
   // src/modules/lmspro/components/registry.tsx
   'your.component.key': YourComponent,
   ```

2. Check componentKey matches EXACTLY (case-sensitive)

3. Verify user has role with that componentKey:
   ```bash
   # Check user's roles
   # Check roles' componentKeys
   ```

4. Check visibility rules (if any) aren't hiding component

5. Verify correct pageContext:
   - LEAGUE_DASHBOARD: `/app/lmspro/dashboard`
   - CLUB_DASHBOARD: `/app/lmspro/club/[clubId]/dashboard`

### Card Pattern Issues

**Symptoms**: Component shows full DataTable in card, dashboard loads slowly

**Fixes**:
1. **Refactor to Card Pattern**: Move DataTable to modal, show only stats in card
   - See `docs/00-READ_THIS/DASHBOARD_CARD_PATTERN.md`
   - Reference `SuspensionManagement.tsx` for example

2. **Check data queries**: Card should query stats only, not full datasets
   ```tsx
   // ❌ Bad: Loading all records for card
   const { data } = trpc.lmspro.teams.list.useQuery();
   
   // ✅ Good: Loading only stats for card
   const { data: stats } = trpc.lmspro.teams.getStats.useQuery();
   ```

3. **Verify modal state**: Use separate state for management modal and form modal
   ```tsx
   const [managementModalOpened, { open, close }] = useDisclosure(false);
   const [formModalOpened, { open: openForm, close: closeForm }] = useDisclosure(false);
   ```

4. **Conditional data loading**: Load full data only when modal opens
   ```tsx
   const { data: fullData } = trpc.lmspro.teams.list.useQuery(
     undefined,
     { enabled: managementModalOpened } // Only query when modal is open
   );
   ```
   ```bash
   # Check user's roles
   # Check roles' componentKeys
   ```

4. Check visibility rules (if any) aren't hiding component

5. Verify correct pageContext:
   - LEAGUE_DASHBOARD: `/app/lmspro/dashboard`
   - CLUB_DASHBOARD: `/app/lmspro/club/[clubId]/dashboard`

### Permission Errors

**Symptoms**: "FORBIDDEN" errors when accessing component

**Fixes**:
1. Check tRPC resolver has correct permission checks

2. Verify user's core role (OWNER/ADMIN/MEMBER) matches requirements

3. Check that queries filter by `organizationId`

4. Review audit logs for attempted unauthorized access

### Migration Failures

**Symptoms**: `npm run db:migrate` fails with column errors

**Fixes**:
1. Check column names use camelCase (NOT snake_case):
   ```sql
   "componentKey" NOT component_key
   "pageContext" NOT page_context
   ```

2. Verify ON CONFLICT clause matches unique constraint:
   ```sql
   ON CONFLICT ("organizationId", "moduleKey", "componentKey", "pageContext")
   ```

3. Check schema.prisma for @map() directives

4. Regenerate Prisma Client: `npx prisma generate`

---

## Common Issues & Troubleshooting

### Issue: Component Not Appearing in Role Assignment List ⭐ MOST COMMON

**Symptoms**: After creating component definition, it doesn't appear in "Granted Components" checklist at `/app/lmspro/admin/roles`

**Root Cause**: Dev server caches database queries. After database migration, server still has old component list in memory.

**Solution (Works 90% of the time)**:
1. **Stop dev server** (Ctrl+C in terminal)
2. **Restart dev server**:
   ```bash
   npm run dev
   ```
3. **Hard refresh browser** (Cmd+Shift+R on Mac, Ctrl+Shift+R on Windows)
4. Navigate to `/app/lmspro/admin/roles`
5. Click on a role card
6. **Component should now appear** in "Granted Components" checklist

**If Still Not Working - Verification Steps**:

1. **Verify component exists in database**:
   ```bash
   node -e "
   const { PrismaClient } = require('@prisma/client');
   const prisma = new PrismaClient();
   
   async function check() {
     const comp = await prisma.componentDefinition.findFirst({
       where: { componentKey: 'your.component.key' },
       select: {
         componentKey: true,
         title: true,
         pageContext: true,
         isEnabled: true,
         scope: true,
         organizationId: true,
       }
     });
     console.log(comp ? 'Found!' : 'NOT FOUND');
     if (comp) console.log(JSON.stringify(comp, null, 2));
     await prisma.\$disconnect();
   }
   
   check().catch(console.error);
   "
   ```

2. **Check component properties**:
   - [ ] `isEnabled` must be `true`
   - [ ] `scope` must be `'MODULE'`
   - [ ] `moduleKey` must be `'lmspro'`
   - [ ] `organizationId` must be `null` (for platform-wide components)
   - [ ] `componentKey` must match registry exactly (case-sensitive)

3. **Verify component registered in code**:
   ```typescript
   // Check: src/modules/lmspro/components/registry.tsx
   export const componentRegistry = {
     // ...
     'your.component.key': YourComponent,  // Must match database componentKey
   };
   ```

4. **Test tRPC query manually** (browser DevTools console):
   ```javascript
   fetch('/api/trpc/lmspro.components.listAll?input=' + encodeURIComponent(JSON.stringify({ includeDisabled: false })))
     .then(r => r.json())
     .then(data => {
       console.log('Components returned:', data.result.data);
       const found = data.result.data.find(c => c.componentKey === 'your.component.key');
       console.log('Your component:', found || 'NOT FOUND');
     });
   ```

5. **Check server logs** for errors when querying components

### Issue: Component Not Appearing on Dashboard

**Symptoms**: Component assigned to role, but doesn't show on user's dashboard

**Checklist**:
- [ ] User has role that grants this component
- [ ] Component's `pageContext` matches dashboard type:
  - `LEAGUE_DASHBOARD` → appears at `/app/lmspro/dashboard`
  - `CLUB_DASHBOARD` → appears at `/app/lmspro/club/[clubId]/dashboard`
  - `CLUB_DASHBOARD,LEAGUE_DASHBOARD` → appears on both
- [ ] Component is registered in registry (`src/modules/lmspro/components/registry.tsx`)
- [ ] `componentKey` in registry matches database exactly (case-sensitive)
- [ ] Visibility rules (if any) aren't hiding component
- [ ] Dev server restarted after database changes
- [ ] Browser hard-refreshed (Cmd+Shift+R)

**Debug User's Roles**:
```bash
node -e "
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function check() {
  const user = await prisma.user.findFirst({
    where: { email: 'your.email@example.com' },
    include: {
      lmsproRoles: {
        include: {
          role: {
            select: {
              name: true,
              componentKeys: true,
            }
          }
        }
      }
    }
  });
  
  console.log('User roles:', user.lmsproRoles.map(ur => ur.role.name));
  console.log('\\nComponents granted:');
  user.lmsproRoles.forEach(ur => {
    console.log(\`  \${ur.role.name}: \`, ur.role.componentKeys);
  });
  
  await prisma.\$disconnect();
}

check().catch(console.error);
"
```

### Issue: Permission Errors

**Symptoms**: "FORBIDDEN" errors when accessing component

**Fixes**:
1. Check tRPC resolver has correct permission checks
2. Verify user's core role (OWNER/ADMIN/MEMBER) matches requirements
3. Check that queries filter by `organizationId`
4. Review audit logs for attempted unauthorized access

### Issue: Migration Failures

**Symptoms**: `npm run db:migrate` fails with column errors

**Fixes**:
1. Check column names use camelCase (NOT snake_case):
   ```sql
   "componentKey" NOT component_key
   "pageContext" NOT page_context
   ```

2. Verify ON CONFLICT clause matches unique constraint:
   ```sql
   ON CONFLICT ("organizationId", "moduleKey", "componentKey", "pageContext")
   ```

3. Check schema.prisma for @map() directives

4. Regenerate Prisma Client: `npx prisma generate`

---

## Quick Reference

### Component Key Naming Convention
```
domain.action
domain.object.action
domain.object.capability

Examples:
- freedays.request
- freedays.manage
- teams.u7.pending.view
- clubs.approve.action
- seasons.overview.view
```

### Dashboard Contexts
- **LEAGUE_DASHBOARD**: `/app/lmspro/dashboard`
- **CLUB_DASHBOARD**: `/app/lmspro/club/[clubId]/dashboard`

### Component Types
- **WIDGET**: Small info card
- **TABLE**: Data grid
- **CHART**: Visualization
- **ACTION**: Button/trigger
- **FORM**: Data entry

### Capabilities
- **VIEW**: Read-only
- **ACTION**: Trigger workflow
- **MANAGE**: Full CRUD
- **ANALYZE**: Reports/analytics

### Common tRPC Patterns
```typescript
// Query with org scoping
.query(async ({ ctx }) => {
  return await ctx.prisma.model.findMany({
    where: { organizationId: ctx.session.user.organizationId },
  });
})

// Mutation with permission check
.mutation(async ({ ctx, input }) => {
  if (!['ADMIN', 'OWNER'].includes(ctx.session.user.role)) {
    throw new TRPCError({ code: 'FORBIDDEN' });
  }
## Changelog

### Version 1.2 - January 14, 2026
- **Added comprehensive troubleshooting section** with most common issues
- **Highlighted dev server restart requirement** after database changes (90% of "component not showing" issues)
- Added Section 3.4: "Restart Development Server" with clear instructions
- Enhanced Section 4.1 with troubleshooting steps for role assignment
- Enhanced Section 6.3 with dev server restart reminder
- Added database verification scripts for debugging
- Added browser DevTools tRPC query testing instructions
- Emphasized importance of restarting dev server throughout document

### Version 1.1 - January 14, 2026
- **BREAKING CHANGE**: Mandatory Dashboard Card Pattern for all dashboard components
- Added card pattern implementation guidelines and examples
- Updated component type definitions to reflect card pattern
- Added card pattern troubleshooting section
- Updated all code examples to follow card pattern
- Marked legacy patterns as anti-patterns
- Added reference to `DASHBOARD_CARD_PATTERN.md` as mandatory reading
- Updated testing checklist to include card pattern verification

### Version 1.0 - January 14, 2026
- Initial comprehensive checklist
- Covers component creation, permissions, time-scoping, roles, and deployment
- Includes troubleshooting and common patterns
- Based on Free Days component implementation learnings
  id, "componentKey", title, description,
  "pageContext", "componentType", scope, capability,
  "moduleKey", "sortOrder", "isEnabled",
  "createdAt", "updatedAt", "organizationId"
) VALUES (
  gen_random_uuid(),
  'your.component.key',
  'Your Component Title',
  'Brief description',
  'LEAGUE_DASHBOARD', -- or CLUB_DASHBOARD
  'ACTION',           -- or WIDGET, TABLE, CHART, FORM
  'MODULE',
  'ACTION',           -- or VIEW, MANAGE, ANALYZE
  'lmspro',
  50,
  true,
  NOW(),
  NOW(),
  NULL
) ON CONFLICT ("organizationId", "moduleKey", "componentKey", "pageContext") DO NOTHING;
```

---

## Related Documentation

- **Architecture**: `/docs/00-overview/architecture.md`
- **Module System**: `/docs/modules/lmspro/architecture.md`
- **Permissions**: `/docs/core/permissions.md`
- **Component System**: `/docs/modules/lmspro/components.md`
- **Seasonal Workflows**: `/docs/modules/lmspro/seasonal-workflows.md`
- **Table CRUD Pattern**: `/docs/guides/table-crud-pattern.md`

---

## Changelog

### Version 1.0 - January 14, 2026
- Initial comprehensive checklist
- Covers component creation, permissions, time-scoping, roles, and deployment
- Includes troubleshooting and common patterns
- Based on Free Days component implementation learnings
