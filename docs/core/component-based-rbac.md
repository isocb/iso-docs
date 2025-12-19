# Component-Based RBAC System

**Version:** 1.0  
**Status:** Core Architecture - Authoritative Reference  
**Scope:** IsoStack Core + All Modules  
**Last Updated:** 2025-12-19

---

## Executive Summary

IsoStack implements a **Two-Tier RBAC system with Three-Scope Component Architecture** that separates:

1. **Security boundaries** (who can access what data)
2. **UX composition** (what features/actions users see)

This enables **mass customization** - tenants inherit sensible defaults but can create custom roles, disable unwanted features, and add organization-specific components without touching code.

**This is THE defining characteristic of IsoStack as a multi-tenant modular SaaS platform.**

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Tier 1: Security RBAC](#tier-1-security-rbac)
3. [Tier 2: UX Composition RBAC](#tier-2-ux-composition-rbac)
4. [Component Scopes](#component-scopes)
5. [Component Types](#component-types)
6. [Role System](#role-system)
7. [Resolution Algorithm](#resolution-algorithm)
8. [Database Schema](#database-schema)
9. [Implementation Stages](#implementation-stages)
10. [Developer Guide](#developer-guide)
11. [Tenant Admin Guide](#tenant-admin-guide)

---

## Architecture Overview

### The Two Tiers

```
┌─────────────────────────────────────────────────────────────┐
│ TIER 1: Security RBAC (Hard Boundary)                      │
│ ─────────────────────────────────────────────────────       │
│ Core Role: OWNER | ADMIN | MEMBER                          │
│ Platform Flag: platformAdmin boolean                        │
│                                                             │
│ Enforced: tRPC context + Prisma filters + RLS              │
│ Controls: Data access + Multi-tenancy boundary             │
│ Question: "What data can this user ever touch?"            │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ TIER 2: UX Composition RBAC (Mass Customization Layer)     │
│ ─────────────────────────────────────────────────────       │
│ Module Roles: Custom per organization                      │
│ Component Grants: Role → Components mapping                │
│                                                             │
│ Enforced: UI rendering + Feature flags + Action checks     │
│ Controls: Feature visibility + Workflow access             │
│ Question: "What does this user's experience look like?"    │
└─────────────────────────────────────────────────────────────┘
```

**Critical Rule:** Tier 2 NEVER overrides Tier 1. Security always wins.

---

## Tier 1: Security RBAC

### Purpose
Protect data boundaries and enforce multi-tenancy isolation.

### Core Role Enum
```typescript
enum Role {
  OWNER   // Full organization control
  ADMIN   // User management + configuration
  MEMBER  // Standard user access
}
```

### Platform Admin Flag
```typescript
User {
  platformAdmin: PlatformAdmin?  // Relation to P1 super-user table
}
```

### Enforcement Points

1. **tRPC Context**
   ```typescript
   export const protectedProcedure = t.procedure.use(async ({ ctx, next }) => {
     if (!ctx.session) throw new TRPCError({ code: 'UNAUTHORIZED' });
     return next({ ctx: { ...ctx, session: ctx.session } });
   });
   
   export const requireRole = (roles: Role[]) => 
     protectedProcedure.use(async ({ ctx, next }) => {
       if (!roles.includes(ctx.session.user.role)) {
         throw new TRPCError({ code: 'FORBIDDEN' });
       }
       return next();
     });
   ```

2. **Prisma Filters**
   ```typescript
   // ALWAYS scope by organizationId
   const items = await prisma.item.findMany({
     where: { 
       organizationId: session.user.organizationId,
       // ... other filters
     }
   });
   ```

3. **Row-Level Security (Optional)**
   ```sql
   -- PostgreSQL RLS policy
   CREATE POLICY tenant_isolation ON items
     USING (organization_id = current_setting('app.current_org_id')::uuid);
   ```

### What Tier 1 Controls

✅ Can user read organization data?  
✅ Can user create/update/delete records?  
✅ Can user manage other users?  
✅ Can user access platform admin features?  

❌ Does NOT control which UI components user sees  
❌ Does NOT control which module features are enabled  
❌ Does NOT determine dashboard layout  

---

## Tier 2: UX Composition RBAC

### Purpose
Enable mass customization - tenants configure their own role structures and feature access without code changes.

### Module Roles (Organization-Scoped)

Unlike Core Roles (fixed enum), **Module Roles are data-driven records**:

```typescript
model ModuleRole {
  id              String   @id @default(uuid())
  moduleKey       String   // "lmspro", "bedrock", "tailoraid"
  organizationId  String?  // null = platform template, uuid = tenant custom
  
  name            String   // "League Secretary", "Data Analyst"
  description     String?
  
  componentKeys   String[] // Components this role can access
  isActive        Boolean  @default(true)
  isSystemDefault Boolean  @default(false)  // Platform template
  
  createdAt       DateTime @default(now())
  updatedAt       DateTime @updatedAt
  
  @@unique([organizationId, moduleKey, name])
}
```

### Component Grants

**Role → Component mapping is the core of Tier 2:**

```typescript
// Platform seeds default role
{
  moduleKey: "lmspro",
  organizationId: null,  // Platform template
  name: "League Secretary",
  componentKeys: [
    "clubs.list.view",
    "clubs.approve.action",
    "teams.list.view",
    "teams.approve.action",
    "financial.summary.view"
  ]
}

// Tenant creates custom role
{
  moduleKey: "lmspro",
  organizationId: "tenant-uuid",
  name: "Assistant Secretary",
  componentKeys: [
    "clubs.list.view",        // View only, no approve
    "teams.list.view",
    "financial.summary.view"  // Subset of Secretary access
  ]
}
```

### What Tier 2 Controls

✅ Which dashboard components user sees  
✅ Which module features are available  
✅ Which actions/buttons appear in UI  
✅ Which pages are accessible  

❌ Does NOT bypass Tier 1 data access rules  
❌ Does NOT grant cross-organization access  
❌ Does NOT override security policies  

---

## Component Scopes

Components exist at **three inheritance levels**:

### Scope A: Core Components (P0)
**Provided by:** IsoStack Core Platform  
**Organization:** null  
**Module:** null or "core"  

**Examples:**
- `notifications.panel.view` - Notification center
- `activity.recent.view` - Recent activity widget  
- `help.tooltips.view` - Contextual help system
- `audit.logs.view` - Audit trail viewer
- `account.switcher.view` - Organization switcher

**Characteristics:**
- Available to all organizations
- Cannot be disabled (except by platform policy)
- Can be overridden at tenant scope (metadata only)

### Scope B: Module Components (P1)
**Provided by:** Module owner (platform)  
**Organization:** null  
**Module:** "lmspro", "bedrock", etc.

**Examples (LMSPro):**
- `clubs.list.view` - Club registry table
- `clubs.approve.action` - Approve club button
- `teams.pending.view` - Pending team approvals widget
- `financial.summary.view` - Financial dashboard
- `referees.pool.manage` - Referee management

**Characteristics:**
- Default templates seeded by platform
- Organizations inherit automatically
- Can be overridden at tenant scope
- Can be disabled by tenant
- Supports "reset to default"

### Scope C: Tenant Components (C1)
**Provided by:** Organization/tenant  
**Organization:** tenant-uuid  
**Module:** "lmspro", "bedrock", etc.

**Examples:**
- `sponsors.widget.view` - Sponsor-funded feature
- `custom.kpi.view` - League-specific KPI dashboard
- `match-day.coordinator.view` - Custom workflow panel

**Characteristics:**
- Created by tenant admin
- Not available to other organizations
- Can reference platform/module components
- Can be disabled/deleted by tenant

### Inheritance Hierarchy

```
Resolution Order (most specific wins):

1. Tenant Component (C1, orgId=X, overridesId=Y)
   ↓ if not found
2. Tenant Override (C1, orgId=X, overridesId=Y)
   ↓ if not found
3. Module Component (P1, orgId=null)
   ↓ if not found
4. Core Component (P0, orgId=null)
```

**Override Rules:**
- Tenant can override: title, description, sortOrder, config params
- Tenant CANNOT override: componentKey, componentType, grantsActions
- "Reset to default" = delete tenant override record

---

## Component Types

### Phase 1: View Components (MVP)

**In Phase 1, VIEW components imply ACTION capability.**

```typescript
enum ComponentCapability {
  VIEW    // Dashboard visibility + implied actions
  ACTION  // Explicit mutation operation (future)
  MANAGE  // Full CRUD scope (future)
}
```

**Phase 1 Behavior:**
- All components have `capability = VIEW`
- If user can see a component, they can use its actions
- Server still validates via Tier 1 RBAC
- Simpler mental model for MVP

**Example:**
```typescript
{
  componentKey: "clubs.pending.view",
  capability: "VIEW",
  title: "Pending Club Approvals",
  componentType: "TABLE",
  
  // Phase 1: No separate action grants needed
  // Seeing the table = can approve clubs (if Tier 1 allows)
}
```

### Phase 2+: Explicit Action Components (Future)

**Post-MVP, separate VIEW and ACTION:**

```typescript
// View component (read-only)
{
  componentKey: "clubs.list.view",
  capability: "VIEW",
  grantsActions: []  // No mutations
}

// Action component (explicit capability)
{
  componentKey: "clubs.approve.action",
  capability: "ACTION",
  grantsActions: ["CLUB_APPROVE", "CLUB_REJECT"]
}

// Manage component (full CRUD)
{
  componentKey: "referees.pool.manage",
  capability: "MANAGE",
  grantsActions: [
    "REFEREE_VIEW", 
    "REFEREE_CREATE", 
    "REFEREE_UPDATE", 
    "REFEREE_DELETE"
  ]
}
```

**Use Cases for Separation:**
- Read-only analyst roles (view but not edit)
- Approval workflows (see requests but can't create)
- Audit compliance (view logs but can't delete)

### Component Naming Convention

**Format:** `<domain>.<object>.<capability>`

**Domains:** clubs, teams, fixtures, venues, referees, payments, safeguarding  
**Objects:** list, pending, summary, pool, calendar, dashboard  
**Capabilities:** view, action, manage

**Examples:**
```
clubs.list.view              // Club registry table
clubs.approve.action         // Approve club operation
teams.pending.view           // Pending approvals widget
teams.assign.action          // Assign team to age group
financial.summary.view       // Financial dashboard
financial.export.action      // Export financial report
referees.pool.manage         // Full referee CRUD
venues.contacts.manage       // Venue contact management
```

**Rules:**
- Always lowercase
- Always dot-separated
- Domain comes first (groups related components)
- Capability suffix makes type explicit
- Consistent across all modules

---

## Role System

### Platform Role Templates (P1)

**Seeded at platform level** (`organizationId = null`):

```typescript
// Platform default roles for LMSPro
const LMSPRO_ROLE_TEMPLATES = [
  {
    name: "League Secretary",
    componentKeys: [
      "clubs.list.view",
      "clubs.pending.view",
      "clubs.approve.action",
      "teams.list.view",
      "teams.pending.view",
      "teams.approve.action",
      "financial.summary.view",
      "season.overview.view"
    ]
  },
  {
    name: "Treasurer",
    componentKeys: [
      "financial.summary.view",
      "financial.export.action",
      "payments.list.view",
      "season.overview.view"
    ]
  },
  {
    name: "Age Group Manager U9",
    componentKeys: [
      "teams.u9.pending.view",
      "teams.u9.approve.action",
      "season.overview.view"
    ]
  }
];
```

### Tenant Custom Roles (C1)

**Created by tenant admin** (`organizationId = tenant-uuid`):

```typescript
// Tenant creates custom role
{
  organizationId: "acme-uuid",
  moduleKey: "lmspro",
  name: "Assistant Secretary",
  componentKeys: [
    "clubs.list.view",        // No approve action
    "teams.list.view",        // No approve action
    "season.overview.view"
  ]
}

// Tenant creates club-specific role
{
  organizationId: "acme-uuid",
  moduleKey: "lmspro",
  name: "Match Day Coordinator",
  componentKeys: [
    "fixtures.calendar.view",
    "venues.contacts.view",
    "referees.pool.view"
  ]
}
```

### User Role Assignment

**Array of role IDs on User model:**

```typescript
model User {
  // ... existing fields
  
  // Module role assignments (per module)
  lmsproRoleIds    String[] @default([])
  bedrockRoleIds   String[] @default([])
  tailoraidRoleIds String[] @default([])
  
  // Legacy fields (deprecated after Phase 1.5)
  // lmsproLeagueRoles String[]
  // lmsproClubRole    String?
}
```

**Example:**
```typescript
{
  id: "user-123",
  email: "jane@djfl.com",
  role: Role.MEMBER,  // Tier 1
  organizationId: "djfl-uuid",
  
  // Tier 2 - multiple module roles
  lmsproRoleIds: [
    "role-league-secretary",
    "role-u9-manager",
    "role-treasurer"
  ]
}
```

### Role Management UI

**Platform Owner:**
- Views all role templates
- Creates new platform templates
- Cannot edit tenant custom roles

**Tenant Admin:**
- Views inherited platform templates (read-only)
- Creates custom roles for their organization
- Clones platform templates and modifies
- Assigns roles to users
- Can "reset role to template" (destructive overwrite)

---

## Resolution Algorithm

### Effective Components for User

**On page load** (`pageContext = "LEAGUE_DASHBOARD"`):

```typescript
async function getEffectiveComponents(
  userId: string,
  moduleKey: string,
  pageContext: string
): Promise<ComponentDefinition[]> {
  
  // 1. Get user's organization and assigned roles
  const user = await prisma.user.findUnique({
    where: { id: userId },
    include: { organization: true }
  });
  
  const roleIds = user[`${moduleKey}RoleIds`] || [];
  
  // 2. Resolve role definitions (tenant custom or platform templates)
  const roles = await prisma.moduleRole.findMany({
    where: {
      id: { in: roleIds },
      OR: [
        { organizationId: user.organizationId },  // Tenant custom
        { organizationId: null }                   // Platform template
      ]
    }
  });
  
  // 3. Collect unique component keys from all roles
  const componentKeys = [
    ...new Set(roles.flatMap(r => r.componentKeys))
  ];
  
  // 4. Resolve effective components (with tenant overrides)
  const components = await resolveComponents(
    user.organizationId,
    moduleKey,
    pageContext,
    componentKeys
  );
  
  // 5. Filter by enabled + sort
  return components
    .filter(c => c.isEnabled)
    .sort((a, b) => a.sortOrder - b.sortOrder);
}

async function resolveComponents(
  organizationId: string,
  moduleKey: string,
  pageContext: string,
  componentKeys: string[]
): Promise<ComponentDefinition[]> {
  
  // Load module defaults
  const moduleComponents = await prisma.componentDefinition.findMany({
    where: {
      moduleKey,
      scope: ComponentScope.MODULE,
      organizationId: null,
      pageContext,
      componentKey: { in: componentKeys }
    }
  });
  
  // Load tenant overrides
  const tenantOverrides = await prisma.componentDefinition.findMany({
    where: {
      moduleKey,
      scope: ComponentScope.TENANT,
      organizationId,
      pageContext,
      OR: [
        { componentKey: { in: componentKeys } },      // Tenant original
        { overridesId: { in: moduleComponents.map(c => c.id) } }  // Overrides
      ]
    }
  });
  
  // Apply overrides (tenant overrides win)
  return moduleComponents.map(moduleComp => {
    const override = tenantOverrides.find(
      t => t.overridesId === moduleComp.id || 
           t.componentKey === moduleComp.componentKey
    );
    return override || moduleComp;
  }).concat(
    // Add tenant-original components (no overridesId)
    tenantOverrides.filter(t => !t.overridesId && 
      componentKeys.includes(t.componentKey))
  );
}
```

### Action Authorization (Phase 2+)

**When user attempts mutation:**

```typescript
async function requireAction(
  userId: string,
  moduleKey: string,
  actionKey: string
): Promise<void> {
  
  // 1. Check Tier 1 RBAC first
  const user = await getUser(userId);
  if (!user) throw new TRPCError({ code: 'UNAUTHORIZED' });
  
  // 2. Get user's effective components
  const components = await getEffectiveComponents(
    userId, 
    moduleKey, 
    null  // Action checks don't need pageContext
  );
  
  // 3. Check if any component grants this action
  const hasGrant = components.some(c => 
    c.grantsActions?.includes(actionKey)
  );
  
  if (!hasGrant) {
    throw new TRPCError({ 
      code: 'FORBIDDEN',
      message: `Missing required action: ${actionKey}`
    });
  }
}

// Usage in tRPC router
export const clubsRouter = router({
  approve: protectedProcedure
    .input(z.object({ clubId: z.string() }))
    .mutation(async ({ ctx, input }) => {
      
      // Tier 1: Check data access
      const club = await ctx.prisma.club.findFirst({
        where: { 
          id: input.clubId, 
          organizationId: ctx.session.user.organizationId 
        }
      });
      if (!club) throw new TRPCError({ code: 'NOT_FOUND' });
      
      // Tier 2: Check action grant (Phase 2+)
      await requireAction(
        ctx.session.user.id, 
        'lmspro', 
        'CLUB_APPROVE'
      );
      
      // Proceed with approval...
    })
});
```

---

## Database Schema

### Core Tables

```prisma
// Component definitions (Core, Module, Tenant)
model ComponentDefinition {
  id              String   @id @default(uuid())
  
  // Scope identifiers
  moduleKey       String?  // null = Core, "lmspro" = Module
  scope           ComponentScope
  organizationId  String?  // null = platform-wide
  
  // Component identity
  componentKey    String   // "clubs.list.view"
  overridesId     String?  // Points to parent component
  
  // Metadata
  title           String
  description     String?
  pageContext     String   // "LEAGUE_DASHBOARD", "CLUB_DASHBOARD"
  componentType   String   // "WIDGET", "TABLE", "CHART", "ACTION"
  capability      ComponentCapability @default(VIEW)
  sortOrder       Int      @default(0)
  isEnabled       Boolean  @default(true)
  
  // RBAC (Phase 2+)
  grantsActions   String[] @default([])  // Server action grants
  
  // Configuration
  config          Json?    // Component-specific params
  
  // Feature flags
  featureFlagKey  String?  // Optional entitlement gate
  
  // Audit
  createdAt       DateTime @default(now())
  updatedAt       DateTime @updatedAt
  createdBy       String?
  
  // Relations
  organization    Organization? @relation(fields: [organizationId], references: [id], onDelete: Cascade)
  overrides       ComponentDefinition? @relation("ComponentOverride", fields: [overridesId], references: [id])
  overriddenBy    ComponentDefinition[] @relation("ComponentOverride")
  
  @@unique([organizationId, moduleKey, componentKey, pageContext])
  @@index([moduleKey, scope, pageContext, isEnabled])
  @@map("component_definitions")
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

// Module roles (platform templates + tenant custom)
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
}

// User model updates
model User {
  // ... existing fields
  
  // Module role assignments (per module)
  lmsproRoleIds    String[] @default([])
  bedrockRoleIds   String[] @default([])
  tailoraidRoleIds String[] @default([])
  
  // DEPRECATED (remove after migration)
  // lmsproLeagueRoles String[]
  // lmsproClubRole    String?
  // lmsproClubId      String?
}
```

### Migration Strategy

**Phase 1.5 → Phase 1.6:**

1. Add new tables: `ComponentDefinition`, `ModuleRole`
2. Add `*RoleIds` fields to User model
3. Seed platform role templates
4. Migrate existing LMSProPageComponent → ComponentDefinition
5. Keep deprecated User fields (backward compatibility)
6. Update UI to use new role system
7. After validation, remove deprecated fields

---

## Implementation Stages

### Stage 1: Core + Module Components (Current)
**Goal:** Module defaults working with clean resolution

**Deliverables:**
- [x] ComponentDefinition model (schema)
- [x] ModuleRole model (schema)
- [x] Platform role templates (seed data)
- [x] Component resolution logic (getEffectiveComponents)
- [x] Role CRUD API (tRPC routers)
- [x] User role assignment UI
- [x] Dashboard dynamic rendering

**Simplifications:**
- `capability = VIEW` for all components
- View implies action (no separate action checks)
- No tenant overrides yet (all use defaults)
- No tenant-created components

**Status:** In Progress (Phase 1.5)

### Stage 2: Tenant Overrides + Disable (Phase 2)
**Goal:** Tenant customization without breaking module

**Deliverables:**
- [ ] Tenant override UI (customize component metadata)
- [ ] Disable component toggle
- [ ] Reset to default button
- [ ] Override resolution in getEffectiveComponents
- [ ] Audit trail for customizations

**Features:**
- Tenant can rename components
- Tenant can change sort order
- Tenant can disable unwanted features
- Tenant can reset to module defaults

### Stage 2.5: Time-Based Visibility Rules (Phase 2.5)
**Goal:** Conditional component visibility based on dates, season phases, or other dynamic context

**Use Case (LMSPro):**
- "Team Registration" visible only during Season.registrationStartDate → registrationEndDate
- Different rules for club users vs league admins
- Component auto-hides when registration window closes

**Schema Addition:**
```prisma
model ComponentDefinition {
  // ... existing fields
  visibilityRules Json?  // Optional conditional visibility
}
```

**Example Rule:**
```json
{
  "type": "date_range",
  "startField": "season.registrationStartDate",
  "endField": "season.registrationEndDate",
  "applyToRoles": ["Club Secretary"],
  "exemptRoles": ["League Secretary"]
}
```

**Other Rule Types:**
- `season_phase`: "only_active_season" | "only_offseason"
- `capacity_limit`: Hide when max reached (e.g., team limit)
- `feature_flag`: Show only if feature enabled
- `custom_function`: Call registered validation function

**Deliverables:**
- [ ] Add `visibilityRules` field to ComponentDefinition
- [ ] Update `getEffectiveComponents()` to evaluate rules
- [ ] Rule evaluation engine (date ranges, custom functions)
- [ ] Context data passing (season, club, etc.)
- [ ] UI for configuring visibility rules (admin panel)

**Resolution Logic Update:**
```typescript
getEffectiveComponents(
  userId: string,
  moduleKey: string,
  pageContext: string,
  contextData?: {  // NEW
    season?: Season,
    club?: Club,
    // ... other dynamic context
  }
)
```

### Stage 3: Tenant-Created Components (Phase 3)
**Goal:** Custom tenant widgets and panels

**Deliverables:**
- [ ] Component creation wizard
- [ ] Simple component types (HTML, iframe, link grid)
- [ ] Component preview
- [ ] Component marketplace (future)

**Features:**
- Sponsor-funded widgets
- League-specific KPIs
- Custom workflow shortcuts
- Organization branding components

### Stage 4: Explicit Action Grants (Phase 4)
**Goal:** Separate view from action capability

**Deliverables:**
- [ ] `capability` field enforcement
- [ ] `grantsActions` field population
- [ ] `requireAction()` middleware
- [ ] Action registry per module
- [ ] Server-side action validation

**Features:**
- Read-only analyst roles
- Approval-only workflows
- Audit compliance roles
- Fine-grained permission control

### Stage 5: Scoped Role Assignments (Phase 5)
**Goal:** Granular role scoping (e.g., "U9 Age Group Manager")

**Deliverables:**
- [ ] UserRoleAssignment junction table
- [ ] Scope JSON field (clubId, ageGroup, etc.)
- [ ] Scoped component resolution
- [ ] Scoped action validation

**Features:**
- Age-group-specific managers
- Club-specific secretaries
- Team-level coordinators
- Venue-specific staff

---

## Developer Guide

### Creating a New Module Component

**1. Define component in seed:**

```typescript
// prisma/seed.ts
{
  moduleKey: "lmspro",
  scope: ComponentScope.MODULE,
  organizationId: null,  // Platform default
  
  componentKey: "fixtures.calendar.view",
  capability: ComponentCapability.VIEW,
  
  title: "Fixture Calendar",
  description: "Monthly fixture schedule with filtering",
  pageContext: "LEAGUE_DASHBOARD",
  componentType: "WIDGET",
  sortOrder: 15,
  
  config: {
    defaultView: "month",
    showPastFixtures: true
  }
}
```

**2. Create component widget:**

```typescript
// src/modules/lmspro/components/widgets/FixtureCalendar.tsx
export function FixtureCalendar({ config }: ComponentProps) {
  const { data: fixtures } = trpc.lmspro.fixtures.list.useQuery();
  
  return (
    <Card>
      <Title order={3}>Fixture Calendar</Title>
      {/* Calendar UI */}
    </Card>
  );
}
```

**3. Register in component registry:**

```typescript
// src/modules/lmspro/components/registry.ts
export const LMSPRO_COMPONENTS = {
  'fixtures.calendar.view': FixtureCalendar,
  'clubs.list.view': ClubsList,
  'teams.pending.view': PendingTeams,
  // ...
};
```

**4. Add to role template:**

```typescript
{
  name: "Fixture Coordinator",
  componentKeys: [
    "fixtures.calendar.view",
    "fixtures.create.action",  // Phase 2+
    "venues.list.view",
    "referees.pool.view"
  ]
}
```

### Checking Component Access (Frontend)

```typescript
// src/modules/lmspro/hooks/useComponentAccess.ts
export function useComponentAccess(componentKey: string) {
  const { data: components } = trpc.lmspro.components.listForUser.useQuery();
  
  return {
    hasAccess: components?.some(c => c.componentKey === componentKey),
    component: components?.find(c => c.componentKey === componentKey)
  };
}

// Usage in page
function LeagueDashboard() {
  const { hasAccess } = useComponentAccess('clubs.approve.action');
  
  return (
    <>
      {hasAccess && (
        <Button onClick={approveClub}>Approve Club</Button>
      )}
    </>
  );
}
```

### Server-Side Action Check (Phase 2+)

```typescript
// src/modules/lmspro/lib/actions.ts
export const LMSPRO_ACTIONS = {
  CLUB_APPROVE: 'clubs.approve',
  TEAM_APPROVE: 'teams.approve',
  FIXTURE_CREATE: 'fixtures.create',
  PAYMENT_RECORD: 'payments.record'
} as const;

// src/server/lib/requireAction.ts
export async function requireAction(
  ctx: Context,
  moduleKey: string,
  actionKey: string
) {
  const components = await getEffectiveComponents(
    ctx.session.user.id,
    moduleKey,
    null
  );
  
  const hasGrant = components.some(c => 
    c.grantsActions?.includes(actionKey)
  );
  
  if (!hasGrant) {
    throw new TRPCError({ 
      code: 'FORBIDDEN',
      message: `Action not permitted: ${actionKey}`
    });
  }
}

// Usage in router
export const clubsRouter = router({
  approve: protectedProcedure
    .input(z.object({ clubId: z.string() }))
    .mutation(async ({ ctx, input }) => {
      await requireAction(ctx, 'lmspro', LMSPRO_ACTIONS.CLUB_APPROVE);
      // ... proceed with approval
    })
});
```

---

## Tenant Admin Guide

### Creating a Custom Role

**1. Navigate to:** `/app/lmspro/admin/roles`

**2. Click:** "Create Custom Role"

**3. Fill form:**
- Name: "Assistant Treasurer"
- Description: "Handles day-to-day payments but cannot export reports"
- Base Template: "Treasurer" (optional)

**4. Select components:**
- ✅ Financial Summary (view)
- ✅ Payments List (view)
- ✅ Record Payment (action)
- ❌ Export Financial Report (action)  ← Removed from template

**5. Save → Assign to users**

### Customizing a Component

**1. Navigate to:** Dashboard page

**2. Hover over component → Click "Customize"**

**3. Edit modal:**
- Title: "Club Approvals" → "Pending Club Registrations"
- Description: Update help text
- Sort Order: 5 → 2 (move up)

**4. Save → Component updates for all users**

**5. Reset:** Click "Reset to Default" to restore module settings

### Disabling a Component

**1. Navigate to:** `/app/lmspro/admin/components`

**2. Find component:** "Referee Pool"

**3. Toggle:** "Enabled" → Off

**4. Confirm:** "This will hide the component for all users. Continue?"

**5. Result:** Referee Pool disappears from all dashboards

---

## Key Principles (Immutable)

1. **Tier 2 NEVER overrides Tier 1** - Security always enforced
2. **Server validates everything** - UI composition is UX, not security
3. **Tenant overrides are reversible** - "Reset to default" always available
4. **Component keys are stable** - Never change after creation
5. **Platform owns defaults** - Tenants customize, platform maintains
6. **Resolution is predictable** - Clear inheritance: Tenant → Module → Core
7. **Phase 1: View = Action** - Simplifies MVP, enables rapid development

---

## Related Documentation

- [Two-Tier Three-Scope Components](/docs/00-overview/ui_ux_components/two_tier_three_scope_components.md)
- [IsoStack UX/UI Standard](/docs/00-overview/ui_ux_components/isostack-ux-ui-standard.md)
- [Platform RBAC Architecture](/docs/core/roles-and-permissions.md)
- [Module Development Guide](/docs/guides/module-development.md)

---

**This document is the authoritative reference for IsoStack's Component-Based RBAC system.**  
**All implementation must adhere to these principles.**  
**Last Updated:** 2025-12-19
