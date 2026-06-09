# LMSPro Venues & Referees Implementation Plan

**Module:** League Management System Pro (LMSPro)  
**Feature Scope:** Venues and Referees CRUD  
**Date:** 2025-01-03  
**Status:** Ready for Implementation  
**Exclusions:** Fixtures (managed directly in FA Fulltime - no API available)

---

## Executive Summary

Implement CRUD operations for **Venues** and **Referees** in the LMSPro module. These components complete Phase 2 and Phase 3 of the original LMSPro implementation plan.

**Key Characteristics:**
- **Venues**: Public to all LMSPro users within the organization (read), ADMIN/Venue Coordinator for write
- **Referees**: Sensitive data requiring RBAC restriction (REFEREE_COORDINATOR + ADMIN only)
- **Season-scoped**: Both entities are linked to a specific season (matching teams, clubs pattern)

---

## Current State Analysis

### Database Schema (Already Exists ✅)

**LMSProVenue** (`prisma/schema.prisma` lines 1987-2013):
```prisma
model LMSProVenue {
  id             String @id @default(uuid())
  organizationId String
  seasonId       String

  name           String        // Unique per season
  address        String?
  postcode       String?
  contacts       Json?         // [{type: "main", name, email, phone}, ...]
  facilities     String?       // Free text description
  notes          String?       // Admin notes

  // Relations
  organization   Organization
  season         LMSProSeason

  @@unique([seasonId, name])
  @@index([organizationId, seasonId])
}
```

**LMSProReferee** (`prisma/schema.prisma` lines 2015-2040):
```prisma
model LMSProReferee {
  id             String @id @default(uuid())
  organizationId String
  seasonId       String

  firstName      String
  lastName       String
  contactDetails Json?         // {email, phone, address} - ENCRYPTED/RESTRICTED
  isMinor        Boolean @default(false)
  qualifications String?
  notes          String?

  // Relations
  organization   Organization
  season         LMSProSeason

  @@index([organizationId, seasonId])
}
```

### What Exists Today

| Component | Status |
|-----------|--------|
| LMSProVenue model | ✅ In schema |
| LMSProReferee model | ✅ In schema |
| venues.router.ts | ❌ Not implemented |
| referees.router.ts | ❌ Not implemented |
| /app/lmspro/venues page | ❌ Not implemented |
| /app/lmspro/referees page | ❌ Not implemented |
| Navigation links | ❌ Not implemented |
| RBAC helpers | ✅ `canManageVenues()`, `canManageReferees()` exist in `roles.ts` |
| Component keys | ✅ `venues.manage.view`, `referees.manage.view` exist |

---

## Implementation Plan

### Phase 1: Venues (Estimated: 2-3 hours)

#### 1.1 Create venues.router.ts

**File:** `src/modules/lmspro/routers/venues.router.ts`

**Endpoints:**
| Endpoint | Method | Access | Description |
|----------|--------|--------|-------------|
| `list` | Query | All authenticated | List venues for season |
| `get` | Query | All authenticated | Get single venue by ID |
| `create` | Mutation | ADMIN / venues.manage | Create new venue |
| `update` | Mutation | ADMIN / venues.manage | Update venue details |
| `delete` | Mutation | OWNER only | Delete venue |

**Key Features:**
- Season scoping (optional filter, default to current season)
- Organization scoping (mandatory)
- Contacts stored as JSON array: `[{type, name, email, phone}]`
- Unique name constraint per season enforced at DB level
- Audit logging for mutations

**Input Schemas:**
```typescript
// List input
z.object({
  seasonId: z.string().optional(),
})

// Create/Update input  
z.object({
  seasonId: z.string(),
  name: z.string().min(1),
  address: z.string().optional(),
  postcode: z.string().optional(),
  contacts: z.array(z.object({
    type: z.enum(['main', 'bookings', 'emergencies']),
    name: z.string(),
    email: z.string().email().optional(),
    phone: z.string().optional(),
  })).optional(),
  facilities: z.string().optional(),
  notes: z.string().optional(),
})
```

#### 1.2 Register Router

**File:** `src/modules/lmspro/routers/index.ts`

Add:
```typescript
import { venuesRouter } from './venues.router';
// ...
venues: venuesRouter,
```

#### 1.3 Create Venues Page

**File:** `src/app/(app)/app/lmspro/venues/page.tsx`

**UI Components:**
- Season selector dropdown (like clubs/teams pages)
- DataTable with columns: Name, Address, Postcode, Contact (main), Facilities
- Row click opens CRUD modal (per isostack-ux-ui-standard.md Section 7.1)
- Add button opens empty modal
- Delete button in modal footer (OWNER only)

**Modal Fields:**
- Name (required)
- Address
- Postcode
- Contacts section (expandable for 3 contact types: main, bookings, emergencies)
  - Each contact: Name, Email, Phone
- Facilities (textarea)
- Notes (textarea, admin-only field)

#### 1.4 Add Navigation Link

**File:** `src/core/config/module-navigation.ts`

Add to `lmsproNavigation.items` (after Teams):
```typescript
{
  href: '/app/lmspro/venues',
  label: 'Venues',
  icon: 'IconMapPin',
},
```

---

### Phase 2: Referees (Estimated: 3-4 hours)

#### 2.1 Create referees.router.ts

**File:** `src/modules/lmspro/routers/referees.router.ts`

**Endpoints:**
| Endpoint | Method | Access | Description |
|----------|--------|--------|-------------|
| `list` | Query | REFEREE_COORDINATOR / ADMIN | List referees (basic info only) |
| `get` | Query | REFEREE_COORDINATOR / ADMIN | Get single referee with contacts |
| `create` | Mutation | REFEREE_COORDINATOR / ADMIN | Create new referee |
| `update` | Mutation | REFEREE_COORDINATOR / ADMIN | Update referee details |
| `delete` | Mutation | OWNER only | Delete referee |

**Security Requirements:**
1. **RBAC Check:** Use `hasComponentAccess(userId, 'lmspro', 'referees.manage')` OR check platform ADMIN role
2. **Contact Details Restriction:** `contactDetails` field only returned in `get` (not in `list`)
3. **Audit Logging:** Log ALL access to referee records (GDPR compliance)
4. **Minor Flag:** `isMinor` prominently displayed as safety indicator

**Input Schemas:**
```typescript
// List input
z.object({
  seasonId: z.string().optional(),
})

// Create/Update input
z.object({
  seasonId: z.string(),
  firstName: z.string().min(1),
  lastName: z.string().min(1),
  contactDetails: z.object({
    email: z.string().email().optional(),
    phone: z.string().optional(),
    address: z.string().optional(),
  }).optional(),
  isMinor: z.boolean().default(false),
  qualifications: z.string().optional(),
  notes: z.string().optional(),
})
```

**List Response (restricted):**
```typescript
{
  id: string;
  firstName: string;
  lastName: string;
  isMinor: boolean;
  qualifications: string | null;
  // NO contactDetails in list
}
```

**Get Response (full details):**
```typescript
{
  id: string;
  firstName: string;
  lastName: string;
  isMinor: boolean;
  qualifications: string | null;
  notes: string | null;
  contactDetails: { email, phone, address } | null;  // ← Only in get
}
```

#### 2.2 Register Router

**File:** `src/modules/lmspro/routers/index.ts`

Add:
```typescript
import { refereesRouter } from './referees.router';
// ...
referees: refereesRouter,
```

#### 2.3 Create Referees Page

**File:** `src/app/(app)/app/lmspro/referees/page.tsx`

**UI Components:**
- Season selector dropdown
- Access check: If user lacks `referees.manage` access, show "Access Denied" message
- DataTable with columns: Name, Minor (badge), Qualifications
- Row click opens CRUD modal (contact details only visible inside modal)
- Add button opens empty modal
- Delete button in modal footer (OWNER only)

**Modal Fields:**
- First Name (required)
- Last Name (required)
- Is Minor (checkbox with warning badge if true)
- Qualifications
- Contact Details section (collapsible/sensitive):
  - Email
  - Phone
  - Address
- Notes (textarea)

**Visual Indicators:**
- Minor referees: Orange warning badge `🔶 Minor (Under 18)`
- Contact details: Locked icon `🔒` indicating sensitive data

#### 2.4 Add Navigation Link

**File:** `src/core/config/module-navigation.ts`

Add to `lmsproNavigation.items` (after Venues):
```typescript
{
  href: '/app/lmspro/referees',
  label: 'Referees',
  icon: 'IconWhistle',
  adminOnly: true,  // Only show for users with appropriate access
},
```

---

## Testing Checklist

### Venues Testing
- [ ] Create venue with all fields populated
- [ ] Create venue with minimal fields (name only)
- [ ] Verify unique name constraint per season
- [ ] Update venue details
- [ ] Delete venue (as OWNER)
- [ ] Verify MEMBER can view but not edit
- [ ] Verify season filter works correctly
- [ ] Verify contacts JSON saves/loads correctly

### Referees Testing
- [ ] Verify access denied for users without `referees.manage` component access
- [ ] Create referee as REFEREE_COORDINATOR
- [ ] Create referee as ADMIN
- [ ] Verify contactDetails NOT returned in list
- [ ] Verify contactDetails IS returned in get (modal open)
- [ ] Update referee details
- [ ] Delete referee (as OWNER only)
- [ ] Verify isMinor badge displays correctly
- [ ] Verify audit log entries created on access
- [ ] Verify season filter works correctly

---

## Files to Create/Modify

### New Files
1. `src/modules/lmspro/routers/venues.router.ts`
2. `src/modules/lmspro/routers/referees.router.ts`
3. `src/app/(app)/app/lmspro/venues/page.tsx`
4. `src/app/(app)/app/lmspro/referees/page.tsx`

### Modified Files
1. `src/modules/lmspro/routers/index.ts` - Add venues and referees routers
2. `src/core/config/module-navigation.ts` - Add navigation links

---

## RBAC Reference

From `src/modules/lmspro/lib/roles.ts`:

```typescript
// Component keys for Venues and Referees
'venues.manage.view'    // Venue Coordinator role
'referees.manage.view'  // Referee Coordinator role

// Helper functions (already exist)
export async function canManageVenues(user: LMSProUser): Promise<boolean>
export async function canManageReferees(user: LMSProUser): Promise<boolean>
```

**Access Matrix:**

| Role | Venues Read | Venues Write | Referees Read | Referees Write |
|------|-------------|--------------|---------------|----------------|
| MEMBER | ✅ | ❌ | ❌ | ❌ |
| ADMIN | ✅ | ✅ | ✅ | ✅ |
| OWNER | ✅ | ✅ | ✅ | ✅ |
| Venue Coordinator | ✅ | ✅ | ❌ | ❌ |
| Referee Coordinator | ✅ | ❌ | ✅ | ✅ |

---

## Out of Scope (Explicitly Excluded)

❌ **Fixtures** - Managed directly in FA Fulltime (no API available)
❌ **Venue-Team linking** - Future enhancement
❌ **Referee-Fixture assignment** - Requires fixtures first
❌ **Encrypted contactDetails** - Using JSON storage; encryption can be added later
❌ **Email notifications** - Meta-email templates exist but not triggered yet

---

## References

- Original implementation plans:
  - `/isodocs/docs/modules/lmspro/planning/LMSPro-Implementation-Plan-FINAL.md`
  - `/isodocs/docs/modules/lmspro/planning/DJFL-Implementation-Plan.md`
- UX/UI Standards: `/docs/00-overview/isostack-ux-ui-standard.md` Section 7.1
- Existing patterns: `src/modules/lmspro/routers/clubs.router.ts`, `teams.router.ts`
