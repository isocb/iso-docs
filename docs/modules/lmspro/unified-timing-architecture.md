# Unified Timing Architecture

> **Status:** Phase 1 Complete, Phase 2 Ready | **Last Updated:** 18 Feb 2026

## Executive Summary

LMSPro uses a **unified timing system** built on Key Dates and Visibility Rules to control:
- When public forms are accessible (Pattern A)
- When dashboard action cards are visible/actionable (Pattern B)
- What countdown information appears in the dashboard banner

**Core Principle:** One system, consistent behavior, single admin configuration.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         UNIFIED TIMING SYSTEM                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌──────────────┐         ┌──────────────┐         ┌──────────────┐       │
│   │  KEY DATES   │────────▶│ VISIBILITY   │────────▶│ COMPONENTS   │       │
│   │  (when)      │   1:N   │   RULES      │   N:1   │ (what)       │       │
│   └──────────────┘         │ (link+exempt)│         └──────────────┘       │
│         │                  └──────────────┘                │                │
│         │                         │                        │                │
│         ▼                         ▼                        ▼                │
│   ┌─────────────────────────────────────────────────────────────────┐      │
│   │                    VISIBILITY ENGINE                             │      │
│   │  evaluateComponentVisibility(componentKey, userRoles, now)       │      │
│   │  Returns: { isVisible, isActionable, borderColor, reason,        │      │
│   │            opensAt?, closesAt? }                                 │      │
│   └─────────────────────────────────────────────────────────────────┘      │
│         │                         │                        │                │
│         ▼                         ▼                        ▼                │
│   ┌──────────────┐         ┌──────────────┐         ┌──────────────┐       │
│   │   BANNER     │         │ ACTION CARDS │         │ PUBLIC FORMS │       │
│   │ (countdowns) │         │ (show/grey)  │         │ (countdown)  │       │
│   └──────────────┘         └──────────────┘         └──────────────┘       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Data Model

### Existing Tables (Already Implemented)

```prisma
model LMSProKeyDate {
  id             String   @id @default(uuid())
  seasonId       String
  organizationId String
  name           String                    // e.g., "Team Registration Opens"
  description    String?
  activeFrom     DateTime
  activeFromTime String   @default("00:00")
  activeTo       DateTime
  activeToTime   String   @default("23:59")
  visibleTo      KeyDateVisibility @default(ALL)  // ALL | LEAGUE_ONLY | CLUB_ONLY
  
  visibilityRules VisibilityRule[]
}

model VisibilityRule {
  id            String   @id @default(uuid())
  keyDateId     String
  componentId   String
  exemptRoleIds String[] // Module role IDs that bypass this rule
  offsetDays    Int?     // Shift window by N days
  offsetFromStart Boolean @default(true)  // Apply offset to start (true) or end (false)
  
  keyDate   LMSProKeyDate       @relation(...)
  component ComponentDefinition @relation(...)
}

model ComponentDefinition {
  id            String   @id @default(uuid())
  moduleId      String
  componentKey  String   // e.g., "teams.register", "public.club-registration"
  name          String
  description   String?
  
  visibilityRules VisibilityRule[]
}
```

### Enhanced Component Metadata (Phase 2)

Components need additional metadata for timing behavior:

```typescript
// ComponentDefinition.capabilities JSON field
{
  "timing": {
    "type": "window",              // "window" | "deadline" | "always"
    "opensKeyDateName": "Team Registration Opens",
    "closesKeyDateName": "Team Registration Closes",
    "outsideWindowBehavior": "greyed",  // "hidden" | "greyed" | "readonly"
    "showInBanner": true,
    "bannerIcon": "🏈"
  }
}
```

---

## Two Patterns, One System

| Aspect | Pattern A: Public Forms | Pattern B: Dashboard Cards |
|--------|------------------------|---------------------------|
| **Audience** | Anonymous users | Logged-in users |
| **Location** | Public embed URL | Club/Team dashboard |
| **Timing UI** | Countdown ON the form page | Countdown in dashboard header banner |
| **Outside Window** | Form replaced with message | Card greyed out with "Opens X" badge |
| **Configuration** | Key Dates page with toggle | Visibility Rules (admin UI) |
| **Component Key** | `public.club-registration` | `teams.register`, `squads.submit` |
| **Phase** | ✅ Phase 1 (Complete) | 🔧 Phase 2 (Next) |

---

## Pattern A: Public Forms (Phase 1 ✅)

### Implementation Status: Complete

**What's Built:**
- `LMSPRO_FORMS` registry mapping forms to Key Date names
- `ClubRegistrationCard` on KeyDatesTab for admin configuration
- `getFormTiming` public endpoint (no auth required)
- Club registration form shows countdown/closed states

### How It Works

1. Admin opens **Key Dates** page for a season
2. **Club Registration** card at top has toggle:
   - "Always open" (default) - no restrictions
   - "Use registration window" - date pickers appear
3. When window is set, auto-creates Key Date records
4. Public form checks timing and shows:
   - **Before window:** Countdown timer + "Opens soon" message
   - **During window:** Full registration form
   - **After window:** "Registration closed" message

### Files

```
src/modules/lmspro/forms/registry.ts           # Form-to-KeyDate mapping
src/modules/lmspro/components/TimedFormWrapper.tsx
src/app/(app)/app/lmspro/seasons/_components/ClubRegistrationCard.tsx
src/app/(embed)/embed/register/club/page.tsx   # Timing checks integrated
src/modules/lmspro/routers/key-dates.router.ts # getFormTiming endpoint
```

---

## Pattern B: Dashboard Action Cards (Phase 2)

### Goal

Dashboard action cards automatically reflect timing windows:
- **Active window:** Card fully clickable (green border optional)
- **Outside window:** Card greyed out with "Opens in X days" badge
- **Closing soon:** Card shows amber border + "Closes in X days"
- **Banner at top:** Shows next opening/closing events with live countdowns

### Dashboard Header Banner

```
┌─────────────────────────────────────────────────────────────────────────────┐
│ ⏰ UPCOMING                                                                  │
│                                                                              │
│  🟢 Team Registration opens in 3 days 14:23:05                              │
│  🔴 Squad Submission closes in 12 days 08:00:00                             │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

**Banner Logic:**
- Shows next **OPENING** event for user's accessible components (green 🟢)
- Shows next **CLOSING** event for user's accessible components (red 🔴)
- Countdowns update in real-time
- When countdown hits zero, dashboard refreshes to reflect new state

### Action Card States

| State | Visual | Badge | Clickable |
|-------|--------|-------|-----------|
| **Active** | Normal | None (or "Open") | ✅ Yes |
| **Closing Soon** | Amber border | "Closes in X days" | ✅ Yes |
| **Not Yet Open** | Greyed out | "Opens in X days" | ❌ No |
| **Closed** | Greyed out | "Closed" | ❌ No |
| **Exempt (Admin)** | Normal + badge | "Admin access" | ✅ Yes |

### Action Card Variants

| Card | Visibility Condition | Outside Window |
|------|---------------------|----------------|
| **View Teams** | Always visible | N/A |
| **Register New Teams** | `team-registration-opens` ≤ now ≤ `team-registration-closes` | Greyed + "Opens X" |
| **Edit Teams** | `team-edit-opens` ≤ now ≤ `team-edit-closes` | Greyed + "Opens X" |
| **Squad Submission** | `squad-submission-opens` ≤ now ≤ `squad-submission-closes` | Greyed + "Closes X" |

---

## Visibility Engine Enhancement

### Current: `evaluateCardVisibility()`

Returns: `{ isVisible: boolean, borderColor?: string, reason?: string }`

### Enhanced: `evaluateComponentTiming()`

```typescript
interface ComponentTimingResult {
  // Current visibility
  isVisible: boolean;
  isActionable: boolean;  // NEW: Can user click/interact?
  
  // Visual feedback
  borderColor?: 'green' | 'amber' | 'red' | 'gray';
  badge?: {
    text: string;      // "Opens in 3 days", "Closes tomorrow"
    color: string;
  };
  
  // Timing info (for banner)
  opensAt?: Date;       // When this component becomes actionable
  closesAt?: Date;      // When this component stops being actionable
  
  // Explanation
  reason?: string;      // "Outside registration window", "Admin bypass"
  isExempt?: boolean;   // User has exempt role
}
```

### Engine Logic

```typescript
function evaluateComponentTiming(
  componentKey: string,
  userModuleRoleIds: string[],
  now: Date = new Date()
): ComponentTimingResult {
  // 1. Find component
  const component = await getComponent(componentKey);
  if (!component) return { isVisible: false, isActionable: false };
  
  // 2. Find visibility rules for this component
  const rules = await getVisibilityRulesForComponent(component.id);
  
  // 3. No rules = always visible and actionable
  if (rules.length === 0) {
    return { isVisible: true, isActionable: true };
  }
  
  // 4. Check each rule
  for (const rule of rules) {
    const keyDate = rule.keyDate;
    
    // Apply offset
    const effectiveStart = applyOffset(keyDate.activeFrom, rule.offsetDays, rule.offsetFromStart);
    const effectiveEnd = applyOffset(keyDate.activeTo, rule.offsetDays, !rule.offsetFromStart);
    
    // Check if user is exempt
    const isExempt = rule.exemptRoleIds.some(id => userModuleRoleIds.includes(id));
    
    // Determine state
    if (now < effectiveStart) {
      // Before window
      return {
        isVisible: true,
        isActionable: isExempt,
        borderColor: 'gray',
        badge: { text: `Opens ${formatDistance(effectiveStart, now)}`, color: 'blue' },
        opensAt: effectiveStart,
        reason: isExempt ? 'Admin early access' : 'Not yet open',
        isExempt,
      };
    }
    
    if (now > effectiveEnd) {
      // After window
      return {
        isVisible: true,
        isActionable: isExempt,
        borderColor: 'gray',
        badge: { text: 'Closed', color: 'gray' },
        reason: isExempt ? 'Admin access after close' : 'Window closed',
        isExempt,
      };
    }
    
    // Within window
    const daysUntilClose = differenceInDays(effectiveEnd, now);
    const isClosingSoon = daysUntilClose <= 7;
    
    return {
      isVisible: true,
      isActionable: true,
      borderColor: isClosingSoon ? 'amber' : 'green',
      badge: isClosingSoon 
        ? { text: `Closes ${formatDistance(effectiveEnd, now)}`, color: 'orange' }
        : undefined,
      closesAt: effectiveEnd,
      reason: 'Active window',
    };
  }
  
  return { isVisible: true, isActionable: true };
}
```

---

## Admin UI for Visibility Rules

### Location: Key Dates Tab → "Linked Components" Modal

When admin clicks on a Key Date, they can link it to components:

```
┌────────────────────────────────────────────────────────────────────────────┐
│ Key Date: Team Registration Window                                          │
│ Active: 1 June 2025 00:00 → 31 July 2025 23:59                              │
├────────────────────────────────────────────────────────────────────────────┤
│ LINKED COMPONENTS                                                           │
│ ┌────────────────────────────────────────────────────────────────────────┐ │
│ │ Component          │ Offset       │ Exempt Roles                        │ │
│ ├────────────────────┼──────────────┼─────────────────────────────────────┤ │
│ │ teams.register     │ None         │ League Admin, League Secretary      │ │
│ │ teams.edit         │ +7 days end  │ League Admin                        │ │
│ └────────────────────────────────────────────────────────────────────────┘ │
│                                                           [+ Add Component] │
└────────────────────────────────────────────────────────────────────────────┘
```

### Already Built (Partially)

`LinkedComponentsModal` exists in `KeyDatesTab.tsx` - needs enhancement to:
- Show current visibility rules
- Add/edit/delete visibility rules
- Select components from dropdown
- Configure exempt roles

---

## Required Key Date Names (Standard)

These are standard Key Date names that the system recognizes:

| Key Date Name | Pattern | Controls |
|---------------|---------|----------|
| `Club Registration Opens` | A | Public club registration form |
| `Club Registration Closes` | A | Public club registration form |
| `Team Registration Opens` | B | teams.register card |
| `Team Registration Closes` | B | teams.register card |
| `Team Edit Window Opens` | B | teams.edit card |
| `Team Edit Window Closes` | B | teams.edit card |
| `Squad Submission Opens` | B | squads.submit card |
| `Squad Submission Closes` | B | squads.submit card |
| `Transfer Window Opens` | B | players.transfer card |
| `Transfer Window Closes` | B | players.transfer card |

**Note:** Admins can create custom Key Dates with any name. Standard names enable auto-linking and banner display.

---

## Implementation Phases

### Phase 1: Public Form Timing ✅ COMPLETE

**Delivered:**
- `LMSPRO_FORMS` registry
- `ClubRegistrationCard` component
- `getFormTiming` public endpoint
- Club registration countdown/closed states
- Documentation

**Files Created:**
- `src/modules/lmspro/forms/registry.ts`
- `src/modules/lmspro/components/TimedFormWrapper.tsx`
- `src/app/(app)/app/lmspro/seasons/_components/ClubRegistrationCard.tsx`

---

### Phase 2: Dashboard Banner & Card Gating

**Goal:** Dashboard shows timing awareness via banner + greyed cards

#### Phase 2.1: Visibility Engine Enhancement (4 hours)

**Tasks:**
1. Enhance `evaluateCardVisibility()` → `evaluateComponentTiming()`
2. Return `isActionable`, `opensAt`, `closesAt`, `badge` info
3. Update `components.listForUser` to return timing data
4. Add unit tests for timing logic

**Files:**
- `src/modules/lmspro/lib/visibilityEngine.ts` (enhance)
- `src/server/core/routers/components.router.ts` (update listForUser)

#### Phase 2.2: Action Card Visual States (4 hours)

**Tasks:**
1. Update `ActionCard` component to support greyed state
2. Add badge display for timing info
3. Disable click when `isActionable: false`
4. Show tooltip explaining why card is greyed

**Files:**
- `src/modules/lmspro/components/dashboard/ActionCard.tsx`
- `src/modules/lmspro/components/dashboard/DashboardActionCards.tsx`

#### Phase 2.3: Dashboard Header Banner (6 hours)

**Tasks:**
1. Create `TimingBannerPanel` component
2. Query for user's components with upcoming opens/closes
3. Display countdown timers (live updating)
4. Green 🟢 for opens, Red 🔴 for closes
5. Add to league and club dashboard layouts

**Files:**
- `src/modules/lmspro/components/dashboard/TimingBannerPanel.tsx` (new)
- `src/app/(app)/app/lmspro/dashboard/page.tsx` (add banner)
- `src/app/(app)/app/lmspro/club/dashboard/page.tsx` (add banner)

#### Phase 2.4: Admin UI - Link Components (8 hours)

**Tasks:**
1. Enhance `LinkedComponentsModal` to show/edit visibility rules
2. Component selector dropdown
3. Exempt roles multi-select
4. Offset configuration
5. CRUD operations via router

**Files:**
- `src/app/(app)/app/lmspro/seasons/_components/LinkedComponentsModal.tsx` (enhance)
- `src/modules/lmspro/routers/visibility-rules.router.ts` (new)

---

### Phase 3: Workflow Templates Enhancement (Future)

**Goal:** Templates include visibility rules for easy season setup

**Tasks:**
1. `duplicateToSeason` also copies visibility rules
2. Template preview shows which cards will be time-gated
3. Common templates: "Standard League", "Competitive League", "Social League"

---

## Testing Checklist

### Phase 2 Tests

**Visibility Engine:**
- [ ] Component with no rules → always actionable
- [ ] Component before window → greyed, shows "Opens in X"
- [ ] Component during window → actionable, green/amber border
- [ ] Component after window → greyed, shows "Closed"
- [ ] Exempt role → always actionable with badge
- [ ] Offset applied correctly

**Action Cards:**
- [ ] Greyed card not clickable
- [ ] Badge displays correctly
- [ ] Tooltip explains state
- [ ] Border colors correct

**Banner:**
- [ ] Shows next opening event
- [ ] Shows next closing event
- [ ] Countdown updates in real-time
- [ ] Only shows events for user's accessible components
- [ ] Hides when no upcoming events

---

## Example: Full Season Timeline

```
        May 1        Jun 1        Jul 31       Aug 15       Sep 1
          │            │            │            │            │
          ├────────────┼────────────┤            │            │
          │    Club Registration    │            │            │
          │         Window          │            │            │
          │            │            │            │            │
          │            ├────────────┼────────────┤            │
          │            │    Team Registration    │            │
          │            │         Window          │            │
          │            │            │            │            │
          │            │            │            ├────────────┤
          │            │            │            │ Squad Sub  │
          │            │            │            │  Window    │
          │            │            │            │            │

Dashboard View on May 15:
┌─────────────────────────────────────────────────────────────┐
│ ⏰ 🟢 Club Registration closes in 2.5 months               │
│    🟢 Team Registration opens in 17 days                   │
└─────────────────────────────────────────────────────────────┘
│ [Register Club ✓]  [Register Teams - Opens Jun 1]          │
│ [Edit Teams - Opens Jun 1]  [Squad Submission - Opens Aug] │
└─────────────────────────────────────────────────────────────┘

Dashboard View on Jul 1:
┌─────────────────────────────────────────────────────────────┐
│ ⏰ 🔴 Club Registration closes in 30 days                  │
│    🔴 Team Registration closes in 45 days                  │
└─────────────────────────────────────────────────────────────┘
│ [Register Club ✓]  [Register Teams ✓]                      │
│ [Edit Teams ✓]  [Squad Submission - Opens Aug 15]          │
└─────────────────────────────────────────────────────────────┘
```

---

## Migration Path

### From Current State

1. **Existing Visibility Rules** - Already work, just not displayed in cards
2. **Action Cards** - Need update to read `isActionable` from components
3. **No data migration** - Just UI changes

### Rollout

1. Deploy Phase 2 code
2. Cards that have no visibility rules = unchanged (always actionable)
3. Admins can link Key Dates → Components via UI
4. Banner appears automatically when timing data exists

---

## Related Documentation

- `/docs/modules/lmspro/key-dates.md` - Key Dates feature
- `/docs/modules/lmspro/unified-workflow-gating-architecture.md` - Original design doc
- `/docs/modules/lmspro/timed-forms-and-action-cards.md` - Previous version (superseded)

---

## Changelog

| Date | Change |
|------|--------|
| 18 Feb 2026 | Phase 1 complete - public form timing |
| 18 Feb 2026 | Architecture consolidated into single document |
| 18 Feb 2026 | Phase 2 plan defined |
