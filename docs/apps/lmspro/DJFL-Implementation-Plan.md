# LMSPro Implementation Plan - Derby Junior Football League

**Project:** League Management System Pro (LMSPro)  
**Client:** Derby Junior Football League (DJFL)  
**Platform:** IsoStack Bedrock  
**Start Date:** December 2024  
**Target Completion:** 8 weeks (February 2025)

## Executive Summary

Build LMSPro as an IsoStack module for managing youth football leagues. The system handles season management, club registrations, team allocations, age group groupings (AGGs), and automated email notifications using IsoStack's unified email system.

**Key Principle:** Email is a **platform-level feature** (not module-specific). LMSPro triggers meta-email events; the core platform handles actual email delivery.

## Architecture Overview

### Tech Stack
- **Frontend:** Next.js 15 (App Router), React 18, Mantine 6, TypeScript 5 (strict mode)
- **API:** tRPC 11 with Zod validation, NextAuth.js v5
- **Database:** Prisma 5 + Neon PostgreSQL (serverless) with `lmspro` schema namespace
- **Email:** Platform-level email system (Resend) via meta-email triggers
- **Storage:** Cloudflare R2 (for future document uploads)

### Multi-Tenancy
All LMSPro data is scoped by `organizationId` to ensure tenant isolation. Every database query MUST filter by the user's organization.

### Role-Based Access Control
- **OWNER** - Full access including deletion
- **ADMIN** - Create, update, approve clubs
- **MEMBER** - Read-only access

## Phase 0: Foundation ✅ COMPLETE

**Duration:** 2 days  
**Status:** Committed to dev branch (c818918)

### Deliverables
1. **Prisma Schema** (`lmspro` namespace)
   - 9 models: Season, Club, ClubOfficial, Team, AgeGroup, AgeGroupGroup, Venue, Referee, UserProfile
   - 4 enums: LMSProRole, ClubStatus, TeamStatus, AgeGroupCode
   - Multi-tenant scoping via `organizationId`

2. **Module Registration**
   - `src/modules/lmspro/module.config.ts`
   - Registered in `src/modules/module.registry.ts`
   - Feature flag: `lmspro`

3. **Seed Data**
   - Test organization (Acme)
   - 1 season (2024/2025)
   - 2 clubs, 6 age groups, 2 teams, 2 venues, 2 referees

### Database Models

#### LMSProSeason
```prisma
model LMSProSeason {
  id              String   @id @default(cuid())
  organizationId  String
  name            String   // e.g., "2024/2025"
  startDate       DateTime
  endDate         DateTime
  isCurrent       Boolean  @default(false)
  ageGroupConfig  Json?    // Per-season age group configuration
  feeStructure    Json?    // Registration fees, team fees, etc.
  
  // Relations
  clubs           LMSProClub[]
  teams           LMSProTeam[]
  ageGroups       LMSProAgeGroup[]
  ageGroupGroups  LMSProAgeGroupGroup[]
  venues          LMSProVenue[]
  referees        LMSProReferee[]
}
```

#### LMSProClub
```prisma
model LMSProClub {
  id              String      @id @default(cuid())
  organizationId  String
  seasonId        String
  fullName        String      // e.g., "Derby Juniors Football Club"
  shortName       String      // e.g., "DJFC"
  faNumber        String?     // FA registration number
  status          ClubStatus  @default(PENDING)
  primaryContact  Json?       // {name, email, phone}
  billingContact  Json?       // {name, email, phone}
  
  // Relations
  season          LMSProSeason @relation(fields: [seasonId], references: [id])
  teams           LMSProTeam[]
  officials       LMSProClubOfficial[]
}

enum ClubStatus {
  PENDING
  APPROVED
  SUSPENDED
  WITHDRAWN
}
```

#### LMSProTeam
```prisma
model LMSProTeam {
  id              String        @id @default(cuid())
  organizationId  String
  seasonId        String
  clubId          String
  teamName        String        // e.g., "Derby Juniors U8 Blue"
  ageGroup        AgeGroupCode
  status          TeamStatus    @default(ACTIVE)
  
  // Manager data (non-user - email recipient only)
  managerName     String?
  managerEmail    String?
  managerPhone    String?
  
  aggId           String?       // Age Group Group allocation
  
  // Relations
  season          LMSProSeason @relation(fields: [seasonId], references: [id])
  club            LMSProClub @relation(fields: [clubId], references: [id])
  ageGroupObj     LMSProAgeGroup @relation(fields: [ageGroup, seasonId], references: [code, seasonId])
  agg             LMSProAgeGroupGroup? @relation(fields: [aggId], references: [id])
}

enum TeamStatus {
  ACTIVE
  INACTIVE
  WITHDRAWN
}
```

#### LMSProAgeGroup & LMSProAgeGroupGroup
```prisma
model LMSProAgeGroup {
  id              String        @id @default(cuid())
  organizationId  String
  seasonId        String
  code            AgeGroupCode  // U7, U8, U9, etc.
  capacity        Int?          // Max teams in age group
  managerId       String?       // User assigned as age group manager
  
  // Relations
  season          LMSProSeason @relation(fields: [seasonId], references: [id])
  manager         User? @relation(fields: [managerId], references: [id])
  teams           LMSProTeam[]
  
  @@unique([seasonId, code])
}

model LMSProAgeGroupGroup {
  id              String   @id @default(cuid())
  organizationId  String
  seasonId        String
  name            String   // e.g., "Group A", "Division 1"
  capacity        Int?     // Max teams in this AGG
  displayOrder    Int      @default(0)
  
  // Relations
  season          LMSProSeason @relation(fields: [seasonId], references: [id])
  teams           LMSProTeam[]
}

enum AgeGroupCode {
  U7, U8, U9, U10, U11, U12, U13, U14, U15, U16, U17, U18
}
```

## Phase 1: Core CRUD Operations ✅ COMPLETE

**Duration:** 1 week  
**Status:** Ready for commit

### Backend: tRPC Routers

#### 1. Seasons Router (`src/modules/lmspro/routers/seasons.router.ts`)
**Endpoints:**
- `list()` - Get all seasons with _count aggregations
- `get(id)` - Single season lookup
- `create()` - ADMIN/OWNER only, validates dates, manages isCurrent flag
- `update()` - ADMIN/OWNER only, date validation
- `delete()` - OWNER only, cascade deletes
- `setCurrent(id)` - ADMIN/OWNER only, atomic current season management

**Features:**
- Organization scoping on all queries
- Role-based access control
- Audit logging for all mutations
- Business logic: only one current season per org

#### 2. Clubs Router (`src/modules/lmspro/routers/clubs.router.ts`)
**Endpoints:**
- `list()` - Filter by season/status
- `get(id)` - Single club with teams, officials, season info
- `create()` - ADMIN/OWNER only, unique club name per season
- `update()` - ADMIN/OWNER only
- `approve(id)` - ADMIN/OWNER only, PENDING → APPROVED
- `delete()` - OWNER only, blocks if teams exist

**Features:**
- Status workflow validation
- Duplicate club name prevention
- Primary/billing contact JSON storage
- Approval workflow (triggers email in Phase 2)

#### 3. Teams Router (`src/modules/lmspro/routers/teams.router.ts`)
**Endpoints:**
- `list()` - Filter by season/club/ageGroup/agg/status
- `get(id)` - Single team with relations
- `create()` - ADMIN/OWNER only, validates club approval, checks capacity
- `update()` - ADMIN/OWNER only
- `allocateToAGG()` - ADMIN/OWNER only, capacity validation
- `delete()` - OWNER only

**Features:**
- Age group capacity checks
- AGG capacity validation
- Club must be APPROVED before team creation
- Manager data (non-user fields for email recipients)

#### 4. Age Groups Router (`src/modules/lmspro/routers/age-groups.router.ts`)
**Two sub-routers:**

**ageGroup:**
- `list()` - All age groups for season
- `get(id)` - Single age group with teams
- `create()` - ADMIN/OWNER only, unique code per season
- `update()` - ADMIN/OWNER only, capacity validation
- `delete()` - OWNER only, blocks if teams exist

**agg:**
- `list()` - All AGGs for season
- `get(id)` - Single AGG with teams
- `create()` - ADMIN/OWNER only, unique name per season
- `update()` - ADMIN/OWNER only, capacity validation
- `delete()` - OWNER only, blocks if teams exist

**Features:**
- Manager assignment (User relation)
- Capacity management
- Display order for AGGs

#### Router Registration
```typescript
// src/modules/lmspro/routers/index.ts
export const lmsproRouter = createTRPCRouter({
  seasons: seasonsRouter,
  clubs: clubsRouter,
  teams: teamsRouter,
  ageGroups: ageGroupsRouter,
});

// src/server/core/routers/index.ts
export const appRouter = createTRPCRouter({
  // ... other routers
  lmspro: lmsproRouter,
});
```

### Frontend: Pages

#### 1. Seasons Page (`/app/lmspro/seasons`)
**Features:**
- Table view with club/team/age group counts
- Add/edit modal with date pickers
- Set current season button (star icon)
- JSON config fields for age groups and fees
- Delete protection with confirmation

**Components:**
- Mantine Table with striped rows
- Modal with useForm validation
- DateInput from @mantine/dates
- Success/error notifications

#### 2. Clubs Page (`/app/lmspro/clubs`)
**Features:**
- Season filter dropdown
- Status badges (PENDING, APPROVED, SUSPENDED, WITHDRAWN)
- Approve button (green checkmark) for pending clubs
- Primary contact and billing contact forms
- Delete protection for clubs with teams

**Components:**
- Select dropdown for season filter
- Card showing selected season
- Color-coded status badges
- Two-step contact forms

#### 3. Teams Page (`/app/lmspro/teams`)
**Features:**
- Season filter dropdown
- AGG allocation modal with capacity display
- Manager data form (non-user fields)
- Age group badges
- Only shows approved clubs in dropdown

**Components:**
- Two modals (add/edit team, allocate AGG)
- Manager contact fields
- AGG capacity indicator: "Group A (5/12 teams)"
- Status badges for team status

### Common Patterns

**tRPC Usage:**
```typescript
const { data, isLoading } = trpc.lmspro.seasons.list.useQuery();

const createMutation = trpc.lmspro.seasons.create.useMutation({
  onSuccess: () => {
    notifications.show({ title: 'Success', color: 'green' });
    utils.lmspro.seasons.list.invalidate();
  },
});
```

**Form Validation:**
```typescript
const form = useForm({
  initialValues: { /* ... */ },
  validate: {
    name: (value) => (value.trim().length === 0 ? 'Name is required' : null),
  },
});
```

## Phase 2: Email Integration (NEXT)

**Duration:** 1 week  
**Status:** Not started

### Meta-Email Architecture

LMSPro triggers **meta-email events**; the platform handles delivery via the unified email system.

#### Meta-Email Event Flow
```
1. LMSPro action (e.g., club approved)
   ↓
2. Create AuditLog entry
   ↓
3. Trigger meta-email event: LMSPRO_CLUB_APPROVED
   ↓
4. Platform email system checks:
   - Organization email settings (enabled/disabled)
   - User notification preferences
   - Email template exists
   ↓
5. Send via Resend using template
   ↓
6. Log delivery in EmailLog table
```

### Email Events

#### 1. Club Approved (`LMSPRO_CLUB_APPROVED`)
**Trigger:** Club status changes to APPROVED  
**Recipients:** Club primary contact, club officials (if users)  
**Template:** `lmspro/club-approved.html`  
**Data:**
```typescript
{
  clubName: string,
  seasonName: string,
  nextSteps: string[],
  leagueContact: { name, email, phone }
}
```

#### 2. Team Registration Confirmed (`LMSPRO_TEAM_REGISTERED`)
**Trigger:** Team created and club is APPROVED  
**Recipients:** Team manager email, club officials  
**Template:** `lmspro/team-registered.html`  
**Data:**
```typescript
{
  teamName: string,
  clubName: string,
  ageGroup: string,
  managerName: string,
  fees: { registration: number, total: number }
}
```

#### 3. AGG Allocation (`LMSPRO_TEAM_ALLOCATED`)
**Trigger:** Team allocated to AGG  
**Recipients:** Team manager, age group manager (if assigned)  
**Template:** `lmspro/team-allocated.html`  
**Data:**
```typescript
{
  teamName: string,
  aggName: string,
  fixturesStartDate: Date,
  venue: string
}
```

#### 4. Season Opening (`LMSPRO_SEASON_OPENED`)
**Trigger:** Season isCurrent flag set to true  
**Recipients:** All club officials, age group managers  
**Template:** `lmspro/season-opened.html`  
**Data:**
```typescript
{
  seasonName: string,
  startDate: Date,
  registrationDeadline: Date,
  importantDates: Array<{ date: Date, event: string }>
}
```

### Implementation Tasks

**2.1: Meta-Email Schema Updates (Platform Core)**
- Add `LMSPRO_*` event types to `EmailEventType` enum
- Create email templates in `src/lib/email/templates/lmspro/`
- Update platform email settings to support module-specific toggles

**2.2: Email Templates (React Email)**
```tsx
// src/lib/email/templates/lmspro/club-approved.tsx
export function ClubApprovedEmail({ 
  clubName, 
  seasonName, 
  nextSteps 
}: ClubApprovedEmailProps) {
  return (
    <Html>
      <Head />
      <Body>
        <Container>
          <Heading>Club Approved: {clubName}</Heading>
          <Text>Congratulations! Your club has been approved for {seasonName}.</Text>
          {/* ... */}
        </Container>
      </Body>
    </Html>
  );
}
```

**2.3: Email Triggers in LMSPro Routers**
```typescript
// clubs.router.ts - approve endpoint
const updatedClub = await ctx.prisma.lMSProClub.update({
  where: { id: input.id },
  data: { status: ClubStatus.APPROVED },
});

// Trigger meta-email event
await ctx.prisma.emailQueue.create({
  data: {
    organizationId: user.organizationId,
    eventType: 'LMSPRO_CLUB_APPROVED',
    recipients: [club.primaryContact.email],
    templateData: {
      clubName: club.fullName,
      seasonName: season.name,
      /* ... */
    },
  },
});
```

**2.4: Email Preferences UI**
- Add LMSPro section to organization email settings
- Per-user notification preferences (opt-out)
- Email preview/test functionality

## Phase 3: Advanced Features

**Duration:** 2 weeks  
**Status:** Not started

### 3.1: Venues & Referees
- CRUD operations for venues (name, address, facilities)
- CRUD operations for referees (name, contact, isMinor flag)
- Encrypted storage for referee contact details (PII protection)

### 3.2: Fixture Management (Basic)
- Create fixtures (home team, away team, date, time, venue)
- Assign referees to fixtures
- Fixture status workflow (SCHEDULED → COMPLETED → VERIFIED)
- Calendar view integration

### 3.3: Dashboard & Reporting
- Season overview dashboard (clubs, teams, fixtures by status)
- Age group capacity visualization
- AGG balance report (ensure even distribution)
- Club registration timeline

### 3.4: Document Management
- Club document uploads (insurance, FA affiliation)
- Player registration forms (stored in R2)
- Document approval workflow
- Document expiry tracking

## Phase 4: Compliance & Security

**Duration:** 1 week  
**Status:** Not started

### 4.1: GDPR Compliance
- Data retention policies for historical seasons
- Personal data export (club contacts, managers)
- Right to erasure implementation
- Audit log retention (7 years minimum)

### 4.2: Security Enhancements
- Rate limiting on club registration endpoints
- Email verification for club contacts
- Two-factor authentication for OWNER/ADMIN roles
- IP whitelisting for platform admin access

### 4.3: Audit Logging
**All mutations already log to AuditLog table:**
```typescript
await ctx.prisma.auditLog.create({
  data: {
    action: 'LMSPRO_CLUB_APPROVED',
    entityType: 'LMSProClub',
    entityId: club.id,
    metadata: { clubName: club.fullName },
    userId: ctx.session.user.id,
    organizationId: user.organizationId,
  },
});
```

**Audit log viewer UI:**
- Filter by entity type, action, date range
- Export to CSV for compliance
- Real-time activity feed

## Phase 5: Testing & Deployment

**Duration:** 1 week  
**Status:** Not started

### 5.1: Unit Tests
- tRPC router tests (Vitest)
- Validation logic tests (Zod schemas)
- Multi-tenancy isolation tests

### 5.2: Integration Tests
- End-to-end user flows (Playwright)
- Email delivery tests (mock Resend)
- Role-based access control tests

### 5.3: Load Testing
- Season creation with 50+ clubs
- AGG allocation for 200+ teams
- Concurrent club registrations

### 5.4: Deployment
- Feature flag: `lmspro` enabled for DJFL organization
- Database migration review (production)
- Rollback plan
- User training documentation

## Development Guidelines

### Multi-Tenancy (CRITICAL)
```typescript
// ✅ CORRECT - scoped to user's organization
const clubs = await prisma.lMSProClub.findMany({
  where: { organizationId: user.organizationId }
});

// ❌ WRONG - returns data from ALL organizations
const clubs = await prisma.lMSProClub.findMany({});
```

### Role-Based Access Control
```typescript
// Protect mutations with role checks
export const clubsRouter = router({
  approve: requireRole([Role.ADMIN, Role.OWNER])
    .input(z.object({ id: z.string() }))
    .mutation(async ({ ctx, input }) => { /* ... */ }),
});
```

### Audit Logging
**Every mutation must create an audit log entry:**
```typescript
await ctx.prisma.auditLog.create({
  data: {
    action: 'LMSPRO_TEAM_CREATED',
    entityType: 'LMSProTeam',
    entityId: team.id,
    metadata: { teamName: team.teamName },
    userId: ctx.session.user.id,
    organizationId: user.organizationId,
  },
});
```

### Email as Platform Feature
**LMSPro never sends emails directly:**
```typescript
// ❌ WRONG - module-specific email code
import { sendEmail } from '@/modules/lmspro/lib/email';
await sendEmail({ to: '...', subject: '...' });

// ✅ CORRECT - platform email event
await ctx.prisma.emailQueue.create({
  data: {
    organizationId: user.organizationId,
    eventType: 'LMSPRO_CLUB_APPROVED',
    recipients: [club.primaryContact.email],
    templateData: { /* ... */ },
  },
});
```

## Testing Accounts

**Seed data creates test users for Acme organization:**
- `owner@acme.com / password123` (OWNER role)
- `admin@acme.com / password123` (ADMIN role)
- `member@acme.com / password123` (MEMBER role)

**Test flow:**
1. Login as `admin@acme.com`
2. Navigate to `/app/lmspro/seasons`
3. Create new season "2024/2025"
4. Navigate to `/app/lmspro/clubs`
5. Add club "Test FC" (status: PENDING)
6. Approve club (green checkmark)
7. Navigate to `/app/lmspro/teams`
8. Register team "Test FC U8" for approved club
9. Allocate team to AGG "Group A"

## Success Criteria

### Phase 1 (Complete)
- ✅ 4 tRPC routers with full CRUD operations
- ✅ 3 frontend pages with Mantine components
- ✅ Multi-tenancy scoping on all queries
- ✅ Role-based access control
- ✅ Audit logging for all mutations
- ✅ TypeScript compilation passes
- ✅ Next.js production build succeeds

### Phase 2 (Email Integration)
- [ ] 4+ email templates created
- [ ] Meta-email events trigger correctly
- [ ] Email queue processes successfully
- [ ] Email logs track delivery status
- [ ] Users can opt-out of notifications

### Phase 3 (Advanced Features)
- [ ] Venues and referees management
- [ ] Basic fixture scheduling
- [ ] Dashboard with key metrics
- [ ] Document upload/approval

### Phase 4 (Compliance)
- [ ] GDPR data export functionality
- [ ] Audit log viewer UI
- [ ] Security hardening complete
- [ ] Penetration testing passed

### Phase 5 (Production Ready)
- [ ] 80%+ test coverage
- [ ] Load testing completed
- [ ] User documentation written
- [ ] DJFL organization onboarded

## Progress Tracking

**Git Commits (dev branch):**
- Phase 0: `c818918` - "Phase 0: Add LMSPro module foundation"
- Phase 1: [PENDING] - "Phase 1: Add LMSPro tRPC routers and frontend pages"

**Todo List Status:**
See `manage_todo_list` tool output for real-time task tracking.

## Known Issues / Future Enhancements

1. **JSON Config Fields** - Seasons page has JSON text areas for ageGroupConfig and feeStructure. Consider replacing with structured form fields in Phase 3.

2. **Club Officials** - `LMSProClubOfficial` model exists but no UI for managing officials yet. Add in Phase 3.

3. **Referee Contact Encryption** - Schema supports encrypted JSON for referee contacts, but encryption implementation deferred to Phase 4.

4. **Fixture Scheduling** - Basic fixture model exists but no scheduling algorithm. Manual fixture creation only in Phase 3.

5. **Email Attachments** - No support for email attachments (e.g., season calendar PDF). Add in Phase 3 if required.

6. **Mobile Responsive** - Pages built with Mantine's responsive props but not tested on mobile devices. Requires testing in Phase 5.

## Contact & Support

**Project Lead:** Chris (Isoblue)  
**Development Branch:** `dev`  
**Documentation:** `/Users/chris/Documents/GitHub/iso-docs/docs/apps/lmspro/`  
**Repository:** `isostack-bedrock`

---

**Last Updated:** 18 December 2024  
**Version:** 1.0  
**Status:** Phase 1 Complete, Phase 2 Ready to Start
