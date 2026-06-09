# LMSPro Implementation Plan - Unified with IsoStack Email System

**Module:** League Management System Pro (LMSPro)  
**Client:** Derby Junior Football League (DJFL)  
**Document Version:** 2.0 (Final - Integrated with CR-18)  
**Date:** 2025-12-18  
**Status:** Implementation Ready  

---

## Executive Summary

Build **LMSPro** as a pure IsoStack module that leverages the **unified email system (CR-18)** as a core platform feature, not a module-specific implementation. LMSPro provides league management (seasons, clubs, teams, age groups, venues, referees) with **communications handled entirely by IsoStack's Email System**.

### Key Integration Points

1. **LMSPro defines filterable user metadata** in `module.config.ts` (league roles, age groups, club affiliations)
2. **IsoStack Email System** consumes this metadata to enable targeted broadcasts
3. **No email code in LMSPro** - all email UI/logic lives in core IsoStack
4. **Module-specific meta-email templates** for automated notifications (team registered, AGG allocation changed)

---

## Strategic Approach: Email as Core Platform Feature

**IsoStack Role Model:**
- **OWNER** - Platform administrator (P1 in old docs) - manages all organizations
- **ADMIN** - Organization administrator - manages their organization (e.g., League Secretary)
- **MEMBER** - Organization user - standard access (e.g., Club Secretary, Age Group Manager)

### What LMSPro Provides to Email System

```typescript Note:** 
- **OWNER** = Platform administrator (manages all organizations)
- **ADMIN** = Organization administrator (e.g., League Secretary)
- **MEMBER** = Organization user (e.g., Club Secretary)

```typescript
// src/modules/lmspro/module.config.ts
export const lmsproModuleConfig: ModuleConfig = {
  key: 'lmspro',
  name: 'League Management Pro',
  description: 'League administration and team management',
  
  // USER METADATA FILTERS (for email targeting)
  userMetadataFilters: [
    {
      key: 'leagueRole',
      label: 'League Role',
      type: 'multiselect',
      options: [
        { value: 'league_secretary', label: 'League Secretary' },
        { value: 'age_group_manager', label: 'Age Group Manager' },
        { value: 'venue_coordinator', label: 'Venue Coordinator' },
        { value: 'referee_coordinator', label: 'Referee Coordinator' },
        { value: 'treasurer', label: 'Treasurer' },
        { value: 'club_secretary', label: 'Club Secretary' },
        { value: 'club_treasurer', label: 'Club Treasurer' },
        { value: 'club_welfare_officer', label: 'Club Welfare Officer' }
      ]
    },
    {
      key: 'clubAffiliation',
      label: 'Club',
      type: 'multiselect',
      optionsSource: 'dynamic', // Loaded from LMSProClub table
      query: 'lmspro.clubs.list'
    },
    {
      key: 'ageGroupAssignment',
      label: 'Age Group',
      type: 'multiselect',
      options: [
        { value: 'u7', label: 'Under 7' },
        { value: 'u8', label: 'Under 8' },
        { value: 'u9', label: 'Under 9' },
        { value: 'u10', label: 'Under 10' },
        { value: 'u11', label: 'Under 11' },
        { value: 'u12', label: 'Under 12' },
        { value: 'u13', label: 'Under 13' }
      ]
    },
    {
      key: 'season',
      label: 'Season',
      type: 'select',
      optionsSource: 'dynamic',
      query: 'lmspro.seasons.list'
    },
    {
      key: 'userStatus',
      label: 'User Status',
      type: 'select',
      options: [
        { value: 'active', label: 'Active' },
  // META-EMAIL TEMPLATES (automated notifications)
  // OWNER creates platform defaults in Platform Settings → Email
  // ADMIN can customize org-scoped copies in Module Settings → LMSPro Emails
  metaEmailTemplates: [
    {
      templateKey: 'lmspro_club_approved',
      name: 'Club Application Approved',
      category: 'Club Lifecycle',
      targetRoles: ['club_secretary'],
      defaultSubject: 'Welcome to {{league.name}} - Club Approved',
      defaultBody: `...`
    },name: 'Club Application Approved',
      category: 'Club Lifecycle',
      targetRoles: ['club_secretary'],
      defaultSubject: 'Welcome to {{league.name}} - Club Approved',
      defaultBody: `...`
    },
    {
      templateKey: 'lmspro_team_allocated_to_agg',
      name: 'Team Allocated to Age Group',
      category: 'Team Management',
      targetRoles: ['club_secretary'],
      defaultSubject: '{{team.name}} allocated to {{agg.name}}',
      defaultBody: `...`
    },
    {
      templateKey: 'lmspro_venue_changed',
      name: 'Venue Details Updated',
      category: 'Operations',
      targetRoles: ['club_secretary', 'age_group_manager'],
      defaultSubject: 'Venue Update: {{venue.name}}',
      defaultBody: `...`
    },
    {
      templateKey: 'lmspro_season_rollover_complete',
      name: 'Season Rollover Complete',
      category: 'Season Management',
      targetRoles: ['league_secretary', 'club_secretary'],
      defaultSubject: '{{season.name}} is now active',
      defaultBody: `...`
    }
  ]
};
```

### What IsoStack Email System Provides to LMSPro

**1. User Communications UI** (already in CR-18 plan):
- `src/app/(app)/[module]/users/page.tsx` - Module → Users page
- Email button with filter-driven recipient selection (ADMIN/OWNER only)
- RecipientPreviewModal → EmailComposerModal flow
- Communications tab for sent email archive

**2. Meta-Email Sending Service** (already in CR-18 plan):
- `src/lib/email/send-meta-email.ts` - sendMetaEmail() function
- Template lookup with org/platform cascading
- Shortcode rendering
- Audit logging

**3. Module Settings Email Tab** (already in CR-18 plan):
- `src/app/(app)/[module]/settings/email/page.tsx`
- ADMIN can customize meta-email templates per organization
- OWNER sees platform defaults (read-only in module context)
- Test email functionality

---

## LMSPro Implementation Phases (8 Weeks)

### Phase 0: Foundation (Week 1 - 5 days)

**Goal:** Database schema + module registration

#### 0.1 Prisma Schema - Core Entities

**File:** `prisma/schema.prisma` (add new schema namespace)

```prisma
// ============================================================================
// LMSPRO SCHEMA – League Management Pro
// ============================================================================

// ---------------------------------------------------------
// LMSPro Enums
// ---------------------------------------------------------

enum LMSProRole {
  LEAGUE_SECRETARY
  AGE_GROUP_MANAGER
  VENUE_COORDINATOR
  REFEREE_COORDINATOR
  TREASURER
  CLUB_SECRETARY
  CLUB_TREASURER
  CLUB_WELFARE_OFFICER
  
  @@schema("lmspro")
}

enum ClubStatus {
  PENDING       // Application submitted
  APPROVED      // Approved, not yet active
  ACTIVE        // Currently active in league
  SUSPENDED     // Temporarily suspended
  WITHDRAWN     // Club left league
  ARCHIVED      // Historical record
  
  @@schema("lmspro")
}

enum TeamStatus {
  WAITING_LIST  // Registered, awaiting allocation
  ALLOCATED     // Assigned to AGG
  ACTIVE        // Playing in current season
  WITHDRAWN     // Withdrew from season
  ARCHIVED      // Historical record
  
  @@schema("lmspro")
}

enum AgeGroupCode {
  U7
  U8
  U9
  U10
  U11
  U12
  U13
  
  @@schema("lmspro")
}

// ---------------------------------------------------------
// LMSPro Core Models
// ---------------------------------------------------------

model LMSProSeason {
  id             String   @id @default(cuid())
  
  // Basic Info
  name           String   // "2025/26 Season"
  startDate      DateTime
  endDate        DateTime
  isCurrent      Boolean  @default(false)
  
  // Registration Periods
  clubRegStart   DateTime
  clubRegEnd     DateTime
  teamRegStart   DateTime
  teamRegEnd     DateTime
  
  // Configuration (JSON for flexibility)
  ageGroupConfig Json     // { U7: { capacity: 120, aggCount: 3 }, ... }
  feeStructure   Json     // { clubFee: 100, teamFee: 50, lateFee: 25 }
  
  // Multi-Tenant
  organizationId String
  organization   Organization @relation(fields: [organizationId], references: [id])
  
  // Audit
  createdAt      DateTime @default(now())
  updatedAt      DateTime @updatedAt
  createdById    String
  createdBy      User     @relation("LMSProSeasonCreator", fields: [createdById], references: [id])
  
  // Relations
  clubs          LMSProClub[]
  teams          LMSProTeam[]
  ageGroups      LMSProAgeGroup[]
  
  @@unique([organizationId, name])
  @@index([organizationId, isCurrent])
  @@schema("lmspro")
}

model LMSProClub {
  id             String   @id @default(cuid())
  
  // Club Info
  fullName       String   // "Derby County Youth FC"
  shortName      String   // "Derby County"
  faNumber       String?  // FA Affiliation Number
  address        String?
  website        String?
  
  // Status
  status         ClubStatus @default(PENDING)
  
  // Season
  seasonId       String
  season         LMSProSeason @relation(fields: [seasonId], references: [id])
  
  // Multi-Tenant
  organizationId String
  organization   Organization @relation(fields: [organizationId], references: [id])
  
  // Audit
  createdAt      DateTime @default(now())
  updatedAt      DateTime @updatedAt
  createdById    String
  createdBy      User     @relation("LMSProClubCreator", fields: [createdById], references: [id])
  
  // Relations
  teams          LMSProTeam[]
  officials      LMSProClubOfficial[]
  
  @@unique([organizationId, seasonId, shortName])
  @@index([organizationId, status])
  @@index([seasonId])
  @@schema("lmspro")
}

model LMSProClubOfficial {
  id             String   @id @default(cuid())
  
  // Club Relationship
  clubId         String
  club           LMSProClub @relation(fields: [clubId], references: [id], onDelete: Cascade)
  
  // User Relationship (platform user)
  userId         String
  user           User     @relation(fields: [userId], references: [id])
  
  // Role
  role           LMSProRole
  isPrimaryContact Boolean @default(false)
  
  // Multi-Tenant
  organizationId String
  organization   Organization @relation(fields: [organizationId], references: [id])
  
  // Audit
  createdAt      DateTime @default(now())
  updatedAt      DateTime @updatedAt
  
  @@unique([clubId, userId, role]) // User can have multiple roles per club
  @@index([organizationId])
  @@index([userId])
  @@schema("lmspro")
}

model LMSProTeam {
  id             String   @id @default(cuid())
  
  // Team Info
  name           String   // "Derby County U9 Hawks"
  ageGroup       AgeGroupCode
  
  // Club Relationship
  clubId         String
  club           LMSProClub @relation(fields: [clubId], references: [id])
  
  // Season Relationship
  seasonId       String
  season         LMSProSeason @relation(fields: [seasonId], references: [id])
  
  // AGG Allocation
  aggId          String?
  agg            LMSProAgeGroupGroup? @relation(fields: [aggId], references: [id])
  status         TeamStatus @default(WAITING_LIST)
  allocationDate DateTime?
  
  // Team Manager (data record, not platform user)
  managerFirstName  String?
  managerLastName   String?
  managerMobile     String?
  managerEmail      String?
  
  // Multi-Tenant
  organizationId String
  organization   Organization @relation(fields: [organizationId], references: [id])
  
  // Audit
  createdAt      DateTime @default(now())
  updatedAt      DateTime @updatedAt
  createdById    String
  createdBy      User     @relation("LMSProTeamCreator", fields: [createdById], references: [id])
  
  @@unique([organizationId, seasonId, clubId, ageGroup, name])
  @@index([organizationId, status])
  @@index([clubId])
  @@index([aggId])
  @@index([seasonId])
  @@schema("lmspro")
}

model LMSProAgeGroup {
  id             String   @id @default(cuid())
  
  // Age Group Info
  code           AgeGroupCode
  name           String   // "Under 9"
  capacity       Int      // Total teams this age group can hold
  
  // Manager Assignment
  managerId      String?
  manager        User?    @relation(fields: [managerId], references: [id])
  
  // Season Relationship
  seasonId       String
  season         LMSProSeason @relation(fields: [seasonId], references: [id])
  
  // Multi-Tenant
  organizationId String
  organization   Organization @relation(fields: [organizationId], references: [id])
  
  // Audit
  createdAt      DateTime @default(now())
  updatedAt      DateTime @updatedAt
  
  // Relations
  aggs           LMSProAgeGroupGroup[]
  
  @@unique([organizationId, seasonId, code])
  @@index([organizationId])
  @@index([seasonId])
  @@schema("lmspro")
}

model LMSProAgeGroupGroup {
  id             String   @id @default(cuid())
  
  // AGG Info
  name           String   // "U9 Division 1"
  displayOrder   Int      @default(1)
  capacity       Int      // Max teams per AGG
  
  // Age Group Relationship
  ageGroupId     String
  ageGroup       LMSProAgeGroup @relation(fields: [ageGroupId], references: [id])
  
  // Multi-Tenant
  organizationId String
  organization   Organization @relation(fields: [organizationId], references: [id])
  
  // Audit
  createdAt      DateTime @default(now())
  updatedAt      DateTime @updatedAt
  
  // Relations
  teams          LMSProTeam[]
  
  @@unique([ageGroupId, name])
  @@index([organizationId])
  @@index([ageGroupId])
  @@schema("lmspro")
}

model LMSProVenue {
  id             String   @id @default(cuid())
  
  // Venue Info
  name           String   // "Moorways Sports Village"
  address        String
  postcode       String?
  mapLink        String?  // Google Maps URL
  pitchSummary   String?  @db.Text // "4x 11-a-side, 6x 7-a-side"
  
  // Contacts (stored as JSON for flexibility - 3 contacts)
  contacts       Json     // [{ type: 'primary', name, landline, mobile, email }, ...]
  
  // Multi-Tenant
  organizationId String
  organization   Organization @relation(fields: [organizationId], references: [id])
  
  // Audit
  createdAt      DateTime @default(now())
  updatedAt      DateTime @updatedAt
  createdById    String
  createdBy      User     @relation("LMSProVenueCreator", fields: [createdById], references: [id])
  
  @@unique([organizationId, name])
  @@index([organizationId])
  @@schema("lmspro")
}

model LMSProReferee {
  id             String   @id @default(cuid())
  
  // Basic Info (visible to authorized roles)
  firstName      String
  lastName       String
  refId          String?  // League-issued ID
  qualification  String?  // "Level 7", "Young Referee"
  
  // Sensitive Data (encrypted, restricted access)
  contactDetails String   // Encrypted JSON: { mobile, email, emergencyName, emergencyPhone }
  isMinor        Boolean  @default(false)
  dateOfBirth    DateTime? // For age verification
  
  // Multi-Tenant
  organizationId String
  organization   Organization @relation(fields: [organizationId], references: [id])
  
  // Audit
  createdAt      DateTime @default(now())
  updatedAt      DateTime @updatedAt
  createdById    String
  createdBy      User     @relation("LMSProRefereeCreator", fields: [createdById], references: [id])
  
  @@unique([organizationId, refId])
  @@index([organizationId])
  @@schema("lmspro")
}

// ---------------------------------------------------------
// LMSPro User Profile (for email filtering)
// ---------------------------------------------------------

model LMSProUserProfile {
  id             String   @id @default(cuid())
  
  // User Relationship
  userId         String   @unique
  user           User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  
  // Filterable Metadata (for email targeting)
  leagueRole     LMSProRole[] // Array - user can have multiple roles
  clubAffiliation String[]    // Array of club IDs
  ageGroupAssignment AgeGroupCode[] // Array of age groups they manage
  season         String?      // Current season context
  userStatus     String       @default("active") // "active", "inactive"
  
  // Multi-Tenant
  organizationId String
  organization   Organization @relation(fields: [organizationId], references: [id])
  
  // Audit
  createdAt      DateTime @default(now())
  updatedAt      DateTime @updatedAt
  
  @@index([organizationId])
  @@index([userId])
  @@schema("lmspro")
}
```

**Deliverables:**
- ✅ Prisma schema addition (lmspro namespace)
- ✅ Migration created: `npx prisma migrate dev --name add_lmspro_schema`
- ✅ Seed data for DJFL test organization

---

#### 0.2 Module Registration

**File:** `src/modules/lmspro/module.config.ts`

```typescript
import { ModuleConfig } from '@/types/module';
import { LMSProRole } from '@prisma/client';

export const lmsproModuleConfig: ModuleConfig = {
  key: 'lmspro',
  name: 'League Management Pro',
  description: 'Comprehensive league administration system',
  version: '1.0.0',
  
  // Navigation
  routes: [
    {
      path: '/lmspro',
      label: 'Dashboard',
      icon: 'IconDashboard'
    },
    {
      path: '/lmspro/seasons',
      label: 'Seasons',
      icon: 'IconCalendar'
    },
    {
      path: '/lmspro/clubs',
      label: 'Clubs',
      icon: 'IconUsers'
    },
    {
      path: '/lmspro/teams',
      label: 'Teams',
      icon: 'IconShield'
    },
    {
      path: '/lmspro/age-groups',
      label: 'Age Groups',
      icon: 'IconList'
    },
    {
      path: '/lmspro/venues',
      label: 'Venues',
      icon: 'IconMapPin'
    },
    {
      path: '/lmspro/referees',
      label: 'Referees',
      icon: 'IconWhistle',
      requiredRoles: ['REFEREE_COORDINATOR', 'LEAGUE_SECRETARY']
    },
    {
      path: '/lmspro/users',
      label: 'Users',
      icon: 'IconUserCheck'
    }
  ],
  
  // USER METADATA FILTERS (consumed by IsoStack Email System)
  userMetadataFilters: [
    {
      key: 'leagueRole',
      label: 'League Role',
      type: 'multiselect',
      options: [
        { value: 'LEAGUE_SECRETARY', label: 'League Secretary' },
        { value: 'AGE_GROUP_MANAGER', label: 'Age Group Manager' },
        { value: 'VENUE_COORDINATOR', label: 'Venue Coordinator' },
        { value: 'REFEREE_COORDINATOR', label: 'Referee Coordinator' },
        { value: 'TREASURER', label: 'Treasurer' },
        { value: 'CLUB_SECRETARY', label: 'Club Secretary' },
        { value: 'CLUB_TREASURER', label: 'Club Treasurer' },
        { value: 'CLUB_WELFARE_OFFICER', label: 'Club Welfare Officer' }
      ]
    },
    {
      key: 'clubAffiliation',
      label: 'Club',
      type: 'multiselect',
      optionsSource: 'dynamic',
      queryKey: 'lmspro.clubs.list'
    },
    {
      key: 'ageGroupAssignment',
      label: 'Age Group',
      type: 'multiselect',
      options: [
        { value: 'U7', label: 'Under 7' },
        { value: 'U8', label: 'Under 8' },
        { value: 'U9', label: 'Under 9' },
        { value: 'U10', label: 'Under 10' },
        { value: 'U11', label: 'Under 11' },
        { value: 'U12', label: 'Under 12' },
        { value: 'U13', label: 'Under 13' }
      ]
    },
    {
      key: 'season',
      label: 'Season',
      type: 'select',
      optionsSource: 'dynamic',
      queryKey: 'lmspro.seasons.list'
    },
    {
      key: 'userStatus',
      label: 'Status',
      type: 'select',
      options: [
        { value: 'active', label: 'Active' },
        { value: 'inactive', label: 'Inactive' }
      ]
    }
  ],
  
  // META-EMAIL TEMPLATES (consumed by IsoStack Email System)
  metaEmailTemplates: [
    {
      templateKey: 'lmspro_club_approved',
      name: 'Club Application Approved',
      category: 'Club Lifecycle',
      targetRoles: ['club_secretary'],
      defaultSubject: 'Welcome to {{league.name}} - Club Approved!',
      defaultBody: `
        <h2>Congratulations {{user.name}}!</h2>
        <p>Your club application for <strong>{{club.fullName}}</strong> has been approved.</p>
        <p><strong>Next Steps:</strong></p>
        <ul>
          <li>Register your teams before {{season.teamRegEnd}}</li>
          <li>Pay club fees (£{{fees.club}}) by {{fees.dueDate}}</li>
          <li>Review league rules: <a href="{{league.rulesUrl}}">League Rules</a></li>
        </ul>
        <p>Login to your dashboard: <a href="{{platform.url}}/lmspro">Manage Club</a></p>
      `
    },
    {
      templateKey: 'lmspro_team_allocated_to_agg',
      name: 'Team Allocated to Age Group',
      category: 'Team Management',
      targetRoles: ['club_secretary'],
      defaultSubject: '{{team.name}} allocated to {{agg.name}}',
      defaultBody: `
        <p>Hi {{user.name}},</p>
        <p>Great news! <strong>{{team.name}}</strong> has been allocated to <strong>{{agg.name}}</strong>.</p>
        <p><strong>Team Details:</strong></p>
        <ul>
          <li>Age Group: {{team.ageGroup}}</li>
          <li>AGG: {{agg.name}}</li>
          <li>Capacity: {{agg.currentTeams}}/{{agg.capacity}}</li>
        </ul>
        <p>Team Manager Contact: {{team.managerName}} ({{team.managerEmail}})</p>
        <p><a href="{{platform.url}}/lmspro/teams/{{team.id}}">View Team Details</a></p>
      `
    },
    {
      templateKey: 'lmspro_venue_changed',
      name: 'Venue Details Updated',
      category: 'Operations',
      targetRoles: ['club_secretary', 'age_group_manager'],
      defaultSubject: 'Venue Update: {{venue.name}}',
      defaultBody: `
        <p>Hi {{user.name}},</p>
        <p>The venue details for <strong>{{venue.name}}</strong> have been updated.</p>
        <p><strong>Updated Information:</strong></p>
        <ul>
          <li>Address: {{venue.address}}</li>
          <li>Postcode: {{venue.postcode}}</li>
          <li>Pitches: {{venue.pitchSummary}}</li>
          <li>Map: <a href="{{venue.mapLink}}">View Map</a></li>
        </ul>
        <p><strong>Primary Contact:</strong> {{venue.primaryContact.name}} ({{venue.primaryContact.mobile}})</p>
      `
    },
    {
      templateKey: 'lmspro_season_rollover_complete',
      name: 'Season Rollover Complete',
      category: 'Season Management',
      targetRoles: ['league_secretary', 'club_secretary'],
      defaultSubject: '{{season.name}} is now active',
      defaultBody: `
        <p>Hi {{user.name}},</p>
        <p>The league has been rolled over to the new season: <strong>{{season.name}}</strong>.</p>
        <p><strong>Important Dates:</strong></p>
        <ul>
          <li>Team Registration Opens: {{season.teamRegStart}}</li>
          <li>Team Registration Closes: {{season.teamRegEnd}}</li>
          <li>Season Start: {{season.startDate}}</li>
        </ul>
        <p>Please log in to register your teams: <a href="{{platform.url}}/lmspro/teams">Register Teams</a></p>
      `
    }
  ]
};
```

**File:** `src/modules/module.registry.ts` (update)

```typescript
import { lmsproModuleConfig } from './lmspro/module.config';

export const moduleRegistry = [
  bedrockModuleConfig,
  billingModuleConfig,
  supportModuleConfig,
  lmsproModuleConfig, // ← ADD THIS
];
```

**Deliverables:**
- ✅ Module config with metadata filters
- ✅ Meta-email template definitions
- ✅ Module registered in registry

---

### Phase 1: Core CRUD (Weeks 2-3 - 10 days)

**Goal:** Build foundation - Seasons, Clubs, Teams, Age Groups

**Approach:** Standard IsoStack CRUD pattern for each entity:
1. tRPC router (server/api)
2. Server actions (optional for complex operations)
3. UI pages (list + modal)

#### 1.1 Seasons CRUD

**Files:**
- `src/server/routers/lmspro/seasons.router.ts`
- `src/app/(app)/lmspro/seasons/page.tsx`
- `src/app/(app)/lmspro/seasons/components/SeasonModal.tsx`

**Key Features:**
- List seasons (current highlighted)
- Create new season (form with date pickers)
- Edit season config (age group capacities, fees)
- Set current season (only one at a time)
#### 1.2 Clubs CRUD

**Files:**
- `src/server/routers/lmspro/clubs.router.ts`
- `src/app/(app)/lmspro/clubs/page.tsx`
- `src/app/(app)/lmspro/clubs/[id]/page.tsx` (detail view)
- `src/app/(app)/lmspro/clubs/components/ClubModal.tsx`

**Key Features:**
- List clubs (filter by status, season)
- Create club (form with validation - ADMIN or MEMBER with permission)
- Edit club details
- Approve/suspend/archive workflow (ADMIN only)
- **Trigger meta-email:** `lmspro_club_approved` when status changes to APPROVED
- Approve/suspend/archive workflow
- **Trigger meta-email:** `lmspro_club_approved` when status changes to APPROVED

#### 1.3 Club Officials Management

**Files:**
- `src/server/routers/lmspro/club-officials.router.ts`
- `src/app/(app)/lmspro/clubs/[id]/page.tsx` (officials tab)

**Key Features:**
- Assign platform users to club roles
- **Auto-create LMSProUserProfile** when user assigned to club
- **Update userMetadataFilters** (leagueRole, clubAffiliation)
- Primary contact designation

#### 1.4 Teams CRUD

**Files:**
- `src/server/routers/lmspro/teams.router.ts`
- `src/app/(app)/lmspro/teams/page.tsx`
- `src/app/(app)/lmspro/teams/components/TeamModal.tsx`

**Key Features:**
- List teams (filter by club, age group, status)
- Register team (club secretary = MEMBER with club_secretary role)
- Edit team details + team manager info (club secretary only)
- Team status workflow (Waiting List → Allocated → Active) - ADMIN can change status

#### 1.5 Age Groups & AGGs CRUD

**Files:**
- `src/server/routers/lmspro/age-groups.router.ts`
- `src/app/(app)/lmspro/age-groups/page.tsx`
- `src/app/(app)/lmspro/age-groups/[id]/page.tsx` (AGG management)

**Key Features:**
- List age groups with allocation status (all users can view)
- Manage AGGs (create divisions - ADMIN only)
- Allocate teams to AGGs (drag-drop or bulk action - Age Group Manager or ADMIN)
- **Trigger meta-email:** `lmspro_team_allocated_to_agg` when team allocated
- Waiting list management (Age Group Manager or ADMIN)

**Deliverables Phase 1:**
- ✅ 5 tRPC routers (seasons, clubs, club-officials, teams, age-groups)
- ✅ 5 UI page sets (list + detail + modals)
- ✅ Meta-email integration (2 templates: club_approved, team_allocated)
- ✅ LMSProUserProfile auto-creation logic

**Testing:**
- Create season → Register clubs → Register teams → Allocate to AGGs
- Verify meta-emails sent at approval and allocation
- Verify user profiles updated with correct metadata

---

### Phase 2: Venues & Users (Week 4 - 5 days)

#### 2.1 Venues CRUD

**Files:**
- `src/server/routers/lmspro/venues.router.ts`
- `src/app/(app)/lmspro/venues/page.tsx`
- `src/app/(app)/lmspro/venues/components/VenueModal.tsx`

**Key Features:**
- List venues (all users can view)
- Create/edit venue with 3 contacts (Venue Coordinator or ADMIN only)
- **Trigger meta-email:** `lmspro_venue_changed` when venue updated
- Read-only view for Age Group Managers and Club Secretaries

#### 2.2 Users Page (Email Integration Point)

**File:** `src/app/(app)/lmspro/users/page.tsx`

**THIS IS WHERE ISOSTACK EMAIL SYSTEM INTEGRATES:**

```typescript
// src/app/(app)/lmspro/users/page.tsx
'use client';
import { FilterPanel } from '@/core/features/email/FilterPanel'; // Core IsoStack component
import { EmailButton } from '@/core/features/email/EmailButton'; // Core IsoStack component
import { trpc } from '@/lib/trpc/client';

export default function LMSProUsersPage() {
  const [filters, setFilters] = useState({});
  
  // Query uses LMSProUserProfile + module.config.ts filters
  const { data: users } = trpc.lmspro.users.list.useQuery({
    filters
  });
  
  return (
    <div>
      <PageHeader>
        <Title>LMSPro Users</Title>
        <EmailButton
          moduleKey="lmspro"
          selectedUsers={selectedUserIds}
          filters={filters}
        />
      </PageHeader>
      
      {/* IsoStack core component - reads lmspro module.config.ts */}
      <FilterPanel
        moduleKey="lmspro"
        onFilterChange={setFilters}
      />
      
      <DataTable data={users} />
    </div>
  );
}
```

**tRPC Router:**

```typescript
// src/server/routers/lmspro/users.router.ts
import { router, protectedProcedure } from '@/server/trpc';
import { getFilteredModuleUsers } from '@/lib/email/get-filtered-module-users';

export const lmsproUsersRouter = router({
  list: protectedProcedure
    .input(z.object({
      filters: z.record(z.any()).optional()
    }))
    .query(async ({ ctx, input }) => {
      // Use IsoStack core helper
      return await getFilteredModuleUsers({
        moduleKey: 'lmspro',
        organizationId: ctx.session.user.organizationId,
        filters: input.filters || {}
      });
    })
});
```

**Deliverables Phase 2:**
- ✅ Venues CRUD with meta-email trigger
- ✅ Users page with IsoStack FilterPanel integration
- ✅ tRPC router for filtered user queries

**Testing:**
- Create venue → Verify venue_changed email sent
- Navigate to Users → Apply filters (League Role: Club Secretary) → Click Email button
- Verify RecipientPreviewModal shows correct filtered users
- Send test email → Verify Communications tab shows sent email

---

### Phase 3: Referees (Sensitive Data) (Week 5 - 3 days)

**Goal:** Secure referee management with restricted visibility

#### 3.1 Referees CRUD (Restricted Access)

**Files:**
- `src/server/routers/lmspro/referees.router.ts`
- `src/app/(app)/lmspro/referees/page.tsx`

**Security:**
- **RBAC:** Only users with REFEREE_COORDINATOR role or ADMIN can access
- **Encryption:** Use `@/lib/encryption` for contactDetails field
- **UI:** Contact details hidden in list view, visible only in detail modal
- **Audit:** All referee record access logged (GDPR/compliance requirement)

**Key Features:**
- List referees (name, ID, qualification only)
- Create/edit referee (encrypted contact details)
- Flag minors (isMinor = true)
- Emergency contact handling (encrypted)

**Implementation:**

```typescript
// src/server/routers/lmspro/referees.router.ts
import { encrypt, decrypt } from '@/lib/encryption';

export const lmsproRefereesRouter = router({
  list: requireRole(['REFEREE_COORDINATOR', 'LEAGUE_SECRETARY'])
    .query(async ({ ctx }) => {
      const referees = await ctx.prisma.lMSProReferee.findMany({
        where: { organizationId: ctx.session.user.organizationId },
        select: {
          id: true,
          firstName: true,
          lastName: true,
          refId: true,
          qualification: true,
          isMinor: true,
          // contactDetails NOT included in list
        }
      });
      return referees;
    }),
  
  getById: requireRole(['REFEREE_COORDINATOR', 'LEAGUE_SECRETARY'])
    .input(z.object({ id: z.string() }))
    .query(async ({ ctx, input }) => {
      const referee = await ctx.prisma.lMSProReferee.findUnique({
        where: { id: input.id }
      });
      
      if (!referee) throw new Error('Referee not found');
      
      // Decrypt contact details
      const contactDetails = JSON.parse(decrypt(referee.contactDetails));
      
      // Log access
      await ctx.prisma.auditLog.create({
        data: {
          action: 'REFEREE_VIEWED',
          entityType: 'LMSProReferee',
          entityId: referee.id,
          userId: ctx.session.user.id,
          organizationId: ctx.session.user.organizationId
        }
      });
      
      return { ...referee, contactDetails };
    }),
  
  create: requireRole(['REFEREE_COORDINATOR', 'LEAGUE_SECRETARY'])
    .input(refereeSchema)
    .mutation(async ({ ctx, input }) => {
      // Encrypt contact details
      const encryptedContacts = encrypt(JSON.stringify(input.contactDetails));
      
      const referee = await ctx.prisma.lMSProReferee.create({
        data: {
          ...input,
          contactDetails: encryptedContacts,
          organizationId: ctx.session.user.organizationId,
          createdById: ctx.session.user.id
        }
      });
      
      // Audit log
      await ctx.prisma.auditLog.create({
        data: {
          action: 'REFEREE_CREATED',
          entityType: 'LMSProReferee',
          entityId: referee.id,
          userId: ctx.session.user.id,
          organizationId: ctx.session.user.organizationId
        }
      });
      
      return referee;
    })
});
```

**Deliverables Phase 3:**
- ✅ Referees CRUD with encryption
- ✅ RBAC enforcement at router level
- ✅ Audit logging for all referee access
- ✅ UI with contact details only in detail modal

**Testing:**
- Create referee (as Referee Coordinator) → Verify contactDetails encrypted in DB
- Login as MEMBER (Age Group Manager) → Verify no access to referees page (403 error)
- Login as Referee Coordinator → View referee → Verify audit log created
- Login as ADMIN → Verify can view referees page

---

### Phase 4: Dashboard & Reporting (Week 6 - 5 days)

#### 4.1 LMSPro Dashboard

**File:** `src/app/(app)/lmspro/page.tsx`

**Components:**
- Current season overview
- Pending actions (clubs to approve, teams to allocate)
- Statistics cards (clubs, teams, venues, referees)
- Recent activity feed
- Quick actions (register club, register team)

#### 4.2 Reports & Exports

**Features:**
- Export teams by age group (CSV for FA fixture system)
- Export club directory (PDF)
- Export AGG allocations (CSV)
- Financial summary (club fees, team fees, outstanding)

**Deliverables Phase 4:**
- ✅ Dashboard with stats and activity feed
- ✅ 4 export functions (CSV/PDF)
- ✅ Pending actions widget

---

### Phase 5: Season Rollover & Xero Stub (Week 7 - 5 days)

#### 5.1 Season Rollover Wizard

**File:** `src/server/services/lmspro/season-rollover.ts`

**Process:**
1. Create new season
2. Copy age group configuration
3. Copy active clubs (reset to PENDING)
4. Clear teams (clubs must re-register)
5. Send meta-email: `lmspro_season_rollover_complete` to all club secretaries

#### 5.2 Xero Integration Stub

**File:** `src/server/services/lmspro/xero-billing.ts`

**Stub Functions:**
```typescript
export async function generateClubInvoice(clubId: string) {
  // TODO: Implement Xero API integration
  console.log('Xero invoice generation (stub):', clubId);
  return { invoiceId: 'STUB-001', status: 'pending' };
}

export async function syncPaymentStatus(clubId: string) {
  // TODO: Implement Xero payment sync
  console.log('Xero payment sync (stub):', clubId);
  return { paid: false };
}
```

**Deliverables Phase 5:**
- ✅ Season rollover wizard
- ✅ Xero integration stubs (ready for future implementation)
- ✅ Invoice generation placeholder

---

### Phase 6: Testing & Documentation (Week 8 - 5 days)

#### 6.1 End-to-End Testing

**Test Scenarios:**
1. **Season Management:** Create season → Configure AGGs
2. **Club Lifecycle:** Register club → Approve → Assign officials → Register teams
3. **Team Allocation:** Waiting list → Allocate to AGG → Verify email sent
4. **User Communications:** Filter users (Club Secretaries in U9) → Send email → Verify archive
5. **Meta-Emails:** Trigger all 4 templates → Verify delivery
6. **Referees:** Create referee → Verify encryption → Check audit log
7. **Season Rollover:** Rollover season → Verify clubs reset → Verify email sent

#### 6.2 Documentation

**Files:**
- `docs/modules/lmspro/user-guide.md`
- `docs/modules/lmspro/admin-guide.md`
- `docs/modules/lmspro/email-templates.md`
- `docs/modules/lmspro/api-reference.md`

**Deliverables Phase 6:**
- ✅ All test scenarios passed
- ✅ User documentation
- ✅ Admin documentation
- ✅ API reference

---

## Core vs Module Responsibilities
### What Core IsoStack Provides (DO NOT REBUILD IN LMSPRO)

✅ **Email Infrastructure:**
- Database schema: EmailTemplate, UserEmail, EmailRecipientLog
- tRPC routers: email.templates, email.communications
- UI components: FilterPanel, EmailButton, RecipientPreviewModal, EmailComposerModal
- Service functions: sendMetaEmail(), sendCommunicationEmail(), resend-batch.ts
- Platform Settings → Email (OWNER manages platform defaults)
- Module Settings → Email tab (ADMIN customizes org-scoped copies)

✅ **Platform Features:**
- Authentication (NextAuth)
- User management (invitations, OWNER/ADMIN/MEMBER roles)
- Organization management (multi-tenancy - OWNER creates organizations)
- Audit logging (all mutations tracked)
- Encryption utilities (for sensitive data like referee contacts)
- Encryption utilities

### What LMSPro Provides

✅ **Domain Logic:**
- Season, Club, Team, AgeGroup, AGG, Venue, Referee models
- LMSProUserProfile with filterable metadata
- Module config with userMetadataFilters
- Meta-email template definitions
- CRUD operations for league entities
- Referees encryption/RBAC
- Season rollover logic

✅ **Integration Points:**
- Trigger meta-emails at lifecycle events
- Populate LMSProUserProfile when users assigned to roles
- Define filterable metadata for email targeting
- Use IsoStack FilterPanel/EmailButton in Users page

---

## Migration from v1.0 Plan

**What changed from original LMSPro plan:**

1. **❌ Removed:** All custom email/communications code from LMSPro
2. **✅ Added:** Module config with userMetadataFilters
3. **✅ Added:** LMSProUserProfile model for email filtering
4. **✅ Added:** Meta-email template definitions in module config
5. **✅ Changed:** Users page uses core FilterPanel/EmailButton
6. **✅ Changed:** Communications tab is core feature (no LMSPro code)

**Benefits:**
- No duplicate email code
- Consistent email UI across all modules
- LMSPro is 40% smaller (no email infrastructure)
- Email features available immediately (already built in CR-18)
- Other modules can use same pattern

---

## Dev → TechTest Checklist

### Phase 0-1 (Foundation + Core CRUD)
**Local Dev:**
- [ ] Schema migration applied
- [ ] Seed data created (DJFL org, test users)
- [ ] Module registered in registry
- [ ] Seasons/Clubs/Teams/AGGs CRUD working
- [ ] Meta-emails sent (club_approved, team_allocated)
- [ ] LMSProUserProfile created when user assigned role

**TechTest:**
- [ ] Migration applied without data loss
- [ ] Existing organizations unaffected
- [ ] DJFL can create season → clubs → teams
- [ ] Meta-emails delivered via Resend
- [ ] Audit logs recorded

### Phase 2 (Venues + Users Email Integration)
**Local Dev:**
- [ ] Venues CRUD working
- [ ] Users page with FilterPanel displays correctly
- [ ] Filters work (League Role, Club, Age Group)
- [ ] Email button opens RecipientPreviewModal
- [ ] EmailComposerModal sends test email
- [ ] Communications tab shows sent emails

**TechTest:**
- [ ] Email button visible to ADMIN/OWNER only
- [ ] Filters query LMSProUserProfile correctly
- [ ] Batch emails sent via Resend
- [ ] EmailRecipientLog tracks delivery

### Phase 3 (Referees)
**Local Dev:**
- [ ] Referees CRUD restricted to authorized roles
- [ ] Contact details encrypted in DB
- [ ] Audit log created on referee view
- [ ] Age Group Manager cannot access referees

**TechTest:**
- [ ] Encryption keys match TechTest environment
- [ ] RBAC prevents unauthorized access
- [ ] Audit logs visible in Platform Settings

### Phase 4-6 (Dashboard, Rollover, Testing)
**Local Dev:**
- [ ] Dashboard displays correct statistics
- [ ] Season rollover wizard completes
- [ ] Rollover email sent to all club secretaries
- [ ] Export functions generate correct files

**TechTest:**
- [ ] Dashboard loads <2 seconds
- [ ] Rollover doesn't affect other organizations
- [ ] All test scenarios pass

---

## Risk Assessment

| Risk | Severity | Mitigation |
|------|----------|------------|
| **Email system not ready** | HIGH | CR-18 must complete Phases 1-7 before LMSPro Phase 2 |
| **Referee encryption broken** | HIGH | Use IsoStack standard encryption lib, test key rotation |
| **Multi-tenant data leak** | CRITICAL | Every query includes organizationId, audit all endpoints |
| **Season rollover deletes wrong data** | HIGH | Transaction-safe rollover, backup before execution |
| **Module config not discoverable** | MEDIUM | Test FilterPanel with lmspro filters early |
| **TechTest encryption key mismatch** | HIGH | Document key setup in deployment guide |
| **Performance with large datasets** | MEDIUM | Index all filter fields, test with 1000+ teams |

---

## Dependencies

### Prerequisites (Must be Complete)
1. ✅ CR-18 Phase 1-7 (Email System core infrastructure)
2. ✅ IsoStack module specification finalized
3. ✅ Encryption library in core
4. ✅ FilterPanel component in core
5. ✅ EmailButton component in core

### Parallel Work (Can Proceed Simultaneously)
- LMSPro Phase 0-1 (schema + core CRUD) can start before CR-18 complete
- LMSPro Phase 2 (email integration) waits for CR-18 Phase 6-7

---

## Success Metrics

**Functional:**
- [ ] DJFL can manage full season lifecycle
- [ ] All 4 meta-email templates deliver correctly
- [ ] User communications filtered by league role, club, age group
- [ ] Referees data encrypted and access restricted
- [ ] Season rollover completes without manual intervention

**Technical:**
- [ ] 0 multi-tenant data leaks
- [ ] Page load times <2 seconds
- [ ] Email delivery rate >99%
- [ ] 100% test coverage on sensitive operations (referees, rollover)

**User Experience:**
- [ ] Club secretaries can register teams in <5 minutes
- [ ] Age group managers can allocate teams in <10 minutes
- [ ] Email filtering matches user expectations (e.g., "all U9 club secretaries")

---

## Next Steps

1. **Review this plan with Chris** - confirm approach
2. **Begin Phase 0** - Prisma schema addition
3. **Coordinate with CR-18** - ensure Phase 6-7 complete before LMSPro Phase 2
4. **Create test organization** - DJFL in dev environment
5. **Implement Phase 1** - Core CRUD entities

---

**Document Status:** ✅ Ready for Implementation  
**Integration Strategy:** ✅ Email as Core Platform Feature  
**Safety:** ✅ Incremental, testable phases  
**TechTest Compatible:** ✅ All changes non-destructive
