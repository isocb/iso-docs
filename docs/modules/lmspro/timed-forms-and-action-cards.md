# Timed Forms and Action Cards Architecture

> **⚠️ SUPERSEDED:** This document has been consolidated into [`unified-timing-architecture.md`](./unified-timing-architecture.md)
>
> **Status:** Phase 1 Complete | **Last Updated:** 18 Feb 2026

---

## Overview

This document described the original two-pattern approach. It has been superseded by the **Unified Timing Architecture** which consolidates Patterns A and B into a single system based on Key Dates → Visibility Rules → Components.

**See:** [`unified-timing-architecture.md`](./unified-timing-architecture.md) for the current architecture.

---

## Historical Context (Preserved Below)

The content below is preserved for historical reference.

---

## Two Patterns (Original Design)

### Pattern A: Public Forms (e.g., Club Registration)

**Audience:** Anonymous users (prospective clubs)

| Aspect | Description |
|--------|-------------|
| **Location** | Public embed URL (`/embed/register/club?org=slug`) |
| **Timing UI** | Countdown timer displayed ON the form page itself |
| **Configuration** | Key Dates page with toggle + inline date pickers |
| **States** | Before open (countdown) → During window (form visible) → After close (message) |

**Example Use Case:**
- Club registration opens 1st June, closes 31st July
- Before 1st June: Countdown timer + "Registration opens soon" message
- 1st June - 31st July: Full registration form visible
- After 31st July: "Registration closed" message

### Pattern B: Dashboard Action Cards (e.g., Team Registration)

**Audience:** Logged-in users (club admins, team managers)

| Aspect | Description |
|--------|-------------|
| **Location** | Club/Team dashboard |
| **Timing UI** | Countdown banner in dashboard header |
| **Configuration** | Key Dates drive card visibility automatically |
| **States** | Card hidden → Card visible → Card hidden (or switches to read-only variant) |

**Example Use Case:**
- Team registration window: Cards appear/disappear automatically
- Banner shows: "🟢 Team Registration opens in 3 days" or "🔴 Squad Submission closes in 12 days"

---

## Pattern A: Detailed Specification

### Key Dates Page Enhancement

The Key Dates page displays a **Club Registration** info card above the main table:

```
┌──────────────────────────────────────────────────────────┐
│ 📋 CLUB REGISTRATION                                     │
│                                                          │
│ Control when clubs can register for this season.        │
│                                                          │
│ ○ Always open (no date restrictions)                    │
│ ● Use registration window                               │
│                                                          │
│   Opens:  [01 Jun 2026] [09:00]                         │
│   Closes: [31 Jul 2026] [23:59]                         │
│   ☑ Show countdown timer before opening                 │
│                                                          │
│ ───────────────────────────────────────────────────────  │
│ 🔗 Registration Form Link:                               │
│ https://app.lmspro.co.uk/register/club?org=djfl         │
│                                    [Copy] [Preview]      │
│                                                          │
│ Embed Code:                         [Copy Embed]         │
└──────────────────────────────────────────────────────────┘
```

### Toggle Behavior

**"Always open" selected:**
- No Key Date records created for registration
- Form is always accessible at the public URL
- No restrictions, no countdown

**"Use registration window" selected:**
- Auto-creates two Key Date records:
  - `club-registration-opens`
  - `club-registration-closes`
- User sets dates/times via inline pickers
- Dates appear in the main Key Dates table (tagged as "Registration Window")
- Show countdown checkbox controls timer visibility

### Form Wrapper Component

The public form is wrapped in a `TimedFormWrapper` that:

1. Fetches Key Dates for the organization + current season
2. Determines current state (before/during/after)
3. Renders appropriate content:

```typescript
// Pseudocode
function TimedFormWrapper({ formSlug, orgSlug, children }) {
  const { openDate, closeDate, showCountdown } = useFormTiming(formSlug, orgSlug);
  const now = new Date();
  
  // No dates configured = no restrictions
  if (!openDate && !closeDate) {
    return children;
  }
  
  // Before opening
  if (openDate && now < openDate) {
    return (
      <FormNotYetOpen 
        opensAt={openDate}
        showCountdown={showCountdown}
        leagueLogo={...}
      />
    );
  }
  
  // After closing
  if (closeDate && now > closeDate) {
    return <FormClosed leagueLogo={...} />;
  }
  
  // During window
  return children;
}
```

### Default Behavior (No Key Dates Set)

| Situation | Form Behavior |
|-----------|---------------|
| League hasn't set up Key Dates | Form always open |
| League set opening date only | Countdown → then always open |
| League set closing date only | Open until closing date |
| League set both dates | Full timing: countdown → open window → closed |

**This is by design.** New leagues can use the registration form immediately without setup. Timing is opt-in.

---

## Pattern B: Detailed Specification (Phase 2)

### Dashboard Header Banner

Shows upcoming events with live countdown timers:

```
┌─────────────────────────────────────────────────────────────────┐
│ ⏰ COMING UP                                                    │
│                                                                 │
│  🟢 Team Registration opens in 3 days 14:23:05                 │
│  🔴 Squad Submission closes in 12 days 08:00:00                │
└─────────────────────────────────────────────────────────────────┘
```

**Logic:**
- Shows next **opening** event (green 🟢)
- Shows next **closing** event (red 🔴)
- Countdowns update in real-time
- When countdown hits zero, page auto-refreshes to show/hide relevant cards

### Action Card Variants

| Card | When Visible | Key Date Condition |
|------|-------------|-----------|
| **View Teams (read-only)** | Always | Default state outside windows |
| **Register New Teams** | During registration window | `team-registration-opens` ≤ now ≤ `team-registration-closes` |
| **Edit Teams** | During edit window | `team-edit-opens` ≤ now ≤ `team-edit-closes` |
| **Squad Submission** | During squad window | `squad-submission-opens` ≤ now ≤ `squad-submission-closes` |

### Key Date Type Flags

Key Date types need metadata to support this:

```typescript
interface KeyDateType {
  slug: string;
  name: string;
  isOpeningEvent?: boolean;  // Shows green in banner
  isClosingEvent?: boolean;  // Shows red in banner
  linkedActionCard?: string; // Which card this controls
  linkedFormSlug?: string;   // For Pattern A (public forms)
}
```

---

## Form Registry (Code-Defined)

Forms are registered in code with mappings to Key Date type slugs:

```typescript
// src/modules/lmspro/forms/registry.ts

export const LMSPRO_FORMS = {
  'club-registration': {
    name: 'Club Registration',
    route: '/embed/register/club',
    isPublic: true,
    openingKeyDateSlug: 'club-registration-opens',
    closingKeyDateSlug: 'club-registration-closes',
    showCountdown: true,
    messageBeforeOpen: 'Club registration opens soon. Check back on the date below.',
    messageAfterClose: 'Club registration is now closed for this season. Contact the league for assistance.',
  },
  'team-registration': {
    name: 'Team Registration',
    route: '/app/lmspro/teams/register',
    isPublic: false,
    openingKeyDateSlug: 'team-registration-opens',
    closingKeyDateSlug: 'team-registration-closes',
  },
} as const;

export type FormSlug = keyof typeof LMSPRO_FORMS;
```

### ⚠️ EXCEPTION: Hardcoded Mappings

This is a **documented exception** to our database-driven architecture.

**What's hardcoded:**
- Form slug → Key Date type slug mapping (in `LMSPRO_FORMS`)
- Key Date type slugs must exist (seeded)

**Why:**
- Forms are code, Key Dates are data
- This registry bridges them
- Keeps it simple without needing a FormCatalogue table

**If adding a new timed form:**
1. Add form config to `LMSPRO_FORMS` registry
2. Create corresponding `KeyDateType` records (seed or migration)
3. Update this documentation
4. Wrap form component with `<TimedFormWrapper>`

---

## Required Key Date Types

These must be seeded or created via admin:

| Slug | Name | Pattern | Phase |
|------|------|---------|-------|
| `club-registration-opens` | Club Registration Opens | A | 1 |
| `club-registration-closes` | Club Registration Closes | A | 1 |
| `team-registration-opens` | Team Registration Opens | B | 2 |
| `team-registration-closes` | Team Registration Closes | B | 2 |
| `team-edit-opens` | Team Edit Window Opens | B | 2 |
| `team-edit-closes` | Team Edit Window Closes | B | 2 |
| `squad-submission-opens` | Squad Submission Opens | B | 2 |
| `squad-submission-closes` | Squad Submission Closes | B | 2 |

---

## Implementation Phases

### Phase 1: Club Registration Timing ✅ Current

1. **Key Date Types** - Seed `club-registration-opens` and `club-registration-closes`
2. **Key Dates Page** - Add Club Registration info card with toggle + date pickers
3. **Form Registry** - Create `LMSPRO_FORMS` with club-registration config
4. **TimedFormWrapper** - Component that handles before/during/after states
5. **Update Club Registration Form** - Wrap with TimedFormWrapper
6. **API Endpoints** - Get/update registration config for organization

### Phase 2: Dashboard Action Cards (Future)

1. **Dashboard Banner** - Countdown component showing upcoming events
2. **Action Card Visibility** - Hook that determines if card should show
3. **Card Variants** - Read-only vs editable variants
4. **Key Date Type Flags** - Add `isOpeningEvent`, `isClosingEvent`, `linkedActionCard`

---

## API Endpoints (Phase 1)

```typescript
// Get club registration config for an organization
trpc.lmspro.clubRegistration.getConfig({ orgSlug: string })
// Returns: { enabled: boolean, opensAt?: Date, closesAt?: Date, showCountdown: boolean }

// Update club registration config
trpc.lmspro.clubRegistration.updateConfig({
  enabled: boolean,
  opensAt?: Date,
  closesAt?: Date,
  showCountdown?: boolean,
})
// Auto-creates or deletes Key Date records as needed

// Get form timing for public form (no auth required)
trpc.lmspro.forms.getTiming({ formSlug: string, orgSlug: string })
// Returns: { openDate?: Date, closeDate?: Date, showCountdown: boolean, currentState: 'before' | 'during' | 'after' }
```

---

## Testing Checklist

### Phase 1 Tests

- [ ] New league with no Key Dates → Form always visible
- [ ] League enables registration window → Key Dates auto-created
- [ ] League disables registration window → Key Dates auto-deleted
- [ ] Before opening date → Countdown displays (if enabled)
- [ ] During window → Form displays
- [ ] After closing date → Closed message displays
- [ ] Countdown timer updates in real-time
- [ ] League logo displays on all states
- [ ] Copy link button works
- [ ] Preview button opens form in new tab
- [ ] Embed code generates correctly

---

## Related Documentation

- `/docs/modules/lmspro/key-dates.md` - Key Dates feature overview
- `/docs/modules/lmspro/club-registration.md` - Club registration flow
- `/docs/modules/lmspro/action-cards.md` - Dashboard action cards (Phase 2)
