# Unified Workflow Gating Architecture

**Purpose:** Integrate Key Dates, Action Cards, and Role-Based Permissions into a cohesive time-sensitive workflow system  
**Status:** Design Document  
**Created:** 11 June 2025  
**Target Module:** LMSPro (extensible to other modules)

---

## Executive Summary

This document describes how to unify three existing systems into a **time-gated, role-aware workflow engine**:

1. **Key Dates** - Named time windows (e.g., "Team Registration Opens")
2. **Visibility Rules** - Link Key Dates to Components with role exemptions
3. **Action Cards** - Dashboard navigation filtered by component permissions

**The result:** Club users see only the Action Cards relevant to their role AND the current point in the season calendar.

---

## Current State Analysis

### What Exists Now

| System | Status | How It Works |
|--------|--------|--------------|
| **Key Dates** | ✅ Implemented | CRUD via `key-dates.router.ts`, stored per season, includes time-of-day |
| **Visibility Rules** | ✅ Schema exists | `VisibilityRule` model links `keyDateId` → `componentId`, supports offsets + role exemptions |
| **Action Cards** | ✅ Implemented | Filtered by `componentKey` via `listForUser` query |
| **Visibility Engine** | ✅ Implemented | `evaluateCardVisibility()` checks date ranges + exemptions |
| **Components Router** | ✅ Implemented | `listForUser` evaluates visibility rules for each component |

### The Gap

The pieces exist but aren't fully connected:

1. **Action Cards don't check visibility rules** - They only check if user has the `componentKey` via role
2. **No admin UI** to link Key Dates → Components (VisibilityRule CRUD)
3. **No workflow templates** - League admins must manually create all visibility rules each season

---

## Architecture Overview

### The Three-Layer Model

```
┌────────────────────────────────────────────────────────────────────────────┐
│                          USER REQUEST                                       │
│                  "Show me the Club Dashboard"                               │
└────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────────┐
│  LAYER 1: ROLE GATE                                                         │
│  ═══════════════════                                                        │
│  User's Module Role → Component Definitions → Allowed componentKeys         │
│                                                                             │
│  Example: Club Secretary role grants: teams.register, teams.list.view       │
│                                                                             │
│  Result: User can potentially see Teams cards (if time gate passes)         │
└────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────────┐
│  LAYER 2: TIME GATE                                                         │
│  ══════════════════                                                         │
│  For each allowed component:                                                │
│    - Find VisibilityRule for this componentId                               │
│    - Get linked Key Date (with optional offset)                             │
│    - Check if TODAY is within the effective window                          │
│    - Check if user has exempt role (bypass time check)                      │
│                                                                             │
│  Example: teams.register has visibility rule linked to                      │
│           "Team Registration Window" (1 June - 31 July)                     │
│           User with "League Admin" role is exempt (always sees it)          │
│                                                                             │
│  Result: Component is VISIBLE or HIDDEN based on date + exemptions          │
└────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────────┐
│  LAYER 3: RENDER                                                            │
│  ═══════════════                                                            │
│  DashboardActionCards receives filtered componentKeys                       │
│  Only cards whose componentKey passed BOTH gates are rendered               │
│                                                                             │
│  Visual feedback:                                                           │
│    - Green border: Active (within window)                                   │
│    - Amber border: Exempt role (visible regardless of date)                 │
│    - Hidden: Failed time gate                                               │
└────────────────────────────────────────────────────────────────────────────┘
```

### Data Flow

```
┌──────────────────┐     ┌────────────────────┐     ┌────────────────────┐
│   LMSProSeason   │────▶│   LMSProKeyDate    │────▶│   VisibilityRule   │
│                  │ 1:N │  - name            │ 1:N │  - keyDateId       │
│  - id            │     │  - activeFrom      │     │  - componentId     │
│  - organizationId│     │  - activeTo        │     │  - exemptRoleIds[] │
│                  │     │  - visibleTo       │     │  - offsetDays      │
└──────────────────┘     └────────────────────┘     └────────────────────┘
                                                              │
                                                              │ N:1
                                                              ▼
                         ┌────────────────────┐     ┌────────────────────┐
                         │  DashboardActionCard│◀────│ ComponentDefinition│
                         │  - componentKey    │     │  - componentKey    │
                         │  - label           │     │  - allowedRoleIds[]│
                         │  - href            │     │  - capabilities[]  │
                         └────────────────────┘     └────────────────────┘
```

---

## Implementation Plan

### Phase 1: Connect Action Cards to Visibility Engine (CURRENT NEED)

**Goal:** DashboardActionCards respects visibility rules already evaluated by `listForUser`

**What Already Works:**
- `components.listForUser` already evaluates visibility rules
- Returns `visibility: { isVisible, reason, borderColor }` for each component

**What Needs to Change:**
- `DashboardActionCards` currently only checks `userComponentKeys.includes(card.componentKey)`
- It should also check if the component passed visibility evaluation

**Code Change (Minimal):**

```typescript
// DashboardActionCards.tsx
function ActionCardsSection({ cards, userComponentKeys, components, isAdmin }) {
  const visibleCards = cards.filter((card) => {
    // Gate 1: Role check
    if (card.componentKey) {
      if (!userComponentKeys.includes(card.componentKey)) return false;
      
      // Gate 2: Visibility rule check (NEW)
      const component = components.find(c => c.componentKey === card.componentKey);
      if (component && !component.visibility?.isVisible) return false;
    }
    
    // Admin-only check
    if (card.adminOnly) return isAdmin;
    
    return true;
  });
  
  return /* render visibleCards */;
}
```

**Effort:** ~2 hours

---

### Phase 2: Admin UI for Visibility Rules

**Goal:** League admins can link Key Dates to Components via a UI

**Location:** Season detail page → Key Dates tab → "Link Components" action

**UI Design:**

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
│ │ teams.approve.view │ +7 days end  │ League Admin                        │ │
│ └────────────────────────────────────────────────────────────────────────┘ │
│                                                           [+ Add Component] │
└────────────────────────────────────────────────────────────────────────────┘
```

**New Router Endpoints:**

```typescript
// visibility-rules.router.ts
visibilityRules: {
  listForKeyDate: (keyDateId) => VisibilityRule[]
  listForComponent: (componentId) => VisibilityRule[]
  create: (keyDateId, componentId, exemptRoleIds[], offsetDays?, offsetFromStart?)
  update: (id, data)
  delete: (id)
}
```

**Effort:** ~8 hours

---

### Phase 3: Workflow Templates

**Goal:** Pre-defined sets of visibility rules that can be applied to a season

**Concept:**

```typescript
// WorkflowTemplate - stored at organization level
{
  id: "wft_standard_league",
  name: "Standard League Workflow",
  description: "Pre-season registration → Mid-season fixtures → End of season awards",
  rules: [
    { keyDateName: "Team Registration Window", componentKey: "teams.register", exemptRoles: ["League Admin"] },
    { keyDateName: "Team Registration Window", componentKey: "teams.approve.view", offsetDays: 7, offsetFromStart: false },
    { keyDateName: "Transfer Window", componentKey: "players.transfer" },
    // ...
  ]
}
```

**Workflow:**
1. Admin creates new season
2. Selects "Apply Workflow Template"
3. Template creates Key Dates + Visibility Rules automatically
4. Admin can then customize dates and rules

**Effort:** ~16 hours

---

### Phase 4: Season Rollover Enhancement

**Current:** `keyDates.duplicateToSeason` copies key dates only

**Enhancement:** Also duplicate visibility rules linked to those key dates

```typescript
duplicateToSeason: async (input) => {
  // 1. Copy key dates (existing)
  const newKeyDates = await copyKeyDates(sourceSeasonId, targetSeasonId);
  
  // 2. Copy visibility rules (NEW)
  for (const keyDate of newKeyDates) {
    const sourceKeyDate = findSourceKeyDate(keyDate.name);
    const rules = await getVisibilityRulesForKeyDate(sourceKeyDate.id);
    
    for (const rule of rules) {
      await ctx.prisma.visibilityRule.create({
        data: {
          ...rule,
          id: undefined, // Generate new ID
          keyDateId: keyDate.id, // Link to new key date
        }
      });
    }
  }
}
```

**Effort:** ~4 hours

---

## Example Workflow: Club Team Registration

### Key Dates Configuration

| Key Date Name | Active From | Active To | Visible To |
|---------------|-------------|-----------|------------|
| Team Registration Window | 1 Jun 00:00 | 31 Jul 23:59 | ALL |
| Team Registration Review | 15 Jul 00:00 | 15 Aug 23:59 | LEAGUE_ONLY |
| Season Locked | 1 Sep 00:00 | 31 May 23:59 | ALL |

### Visibility Rules

| Component | Key Date | Offset | Exempt Roles |
|-----------|----------|--------|--------------|
| `teams.register` | Team Registration Window | None | League Admin |
| `teams.approve.view` | Team Registration Review | None | None |
| `teams.list.view` | (no rule = always visible) | - | - |

### Timeline Visualization

```
June 1     July 15    July 31    Aug 15    Sep 1
    │          │          │          │         │
    ├──────────┼──────────┤          │         │
    │  Registration Window │          │         │
    │  (Club can register) │          │         │
    │          │          │          │         │
    │          ├──────────┼──────────┤         │
    │          │     Review Period    │         │
    │          │  (League approves)   │         │
    │          │          │          │         │
    │          │          │          │         ├──────────▶
    │          │          │          │         │ Season Active
    │          │          │          │         │ (Changes locked)
    ▼          ▼          ▼          ▼         ▼
```

### What Club Secretary Sees

| Date | Dashboard Cards Visible |
|------|------------------------|
| May 15 | Teams List (no time gate) |
| June 5 | Teams List, **Register Team** (registration open) |
| Aug 1 | Teams List (registration closed) |
| Sep 15 | Teams List (season active) |

### What League Admin Sees (Exempt Role)

| Date | Dashboard Cards Visible |
|------|------------------------|
| Any | Teams List, Register Team, Approve Teams, Free Days, etc. |

*(Exempt roles bypass time gates)*

---

## Technical Details

### Visibility Rule Evaluation Order

```typescript
async function evaluateVisibility(componentId, userId, organizationId, seasonId) {
  // 1. Get all visibility rules for this component
  const rules = await getVisibilityRulesForComponent(componentId);
  
  // 2. If no rules, component is always visible (no time gate)
  if (rules.length === 0) {
    return { isVisible: true, reason: 'No time restrictions' };
  }
  
  // 3. Evaluate each rule (AND logic - all must pass)
  for (const rule of rules) {
    const result = await evaluateRule(rule, userId, organizationId);
    if (!result.isVisible) {
      return result; // First failing rule stops evaluation
    }
  }
  
  return { isVisible: true, reason: 'All rules passed' };
}

async function evaluateRule(rule, userId, organizationId) {
  // 1. Check role exemption first
  if (userHasExemptRole(userId, rule.exemptRoleIds)) {
    return { isVisible: true, reason: 'Exempt role', exempt: true };
  }
  
  // 2. Get key date and calculate effective window
  const keyDate = await getKeyDate(rule.keyDateId);
  const window = calculateEffectiveWindow(keyDate, rule.offsetDays, rule.offsetFromStart);
  
  // 3. Check if now is within window
  const now = new Date();
  const isWithin = now >= window.start && now <= window.end;
  
  return {
    isVisible: isWithin,
    reason: isWithin ? `Active: ${keyDate.name}` : `Outside: ${keyDate.name}`,
    keyDateName: keyDate.name,
    window,
  };
}
```

### Performance Considerations

**Caching Strategy:**
- Key Dates rarely change during a season → Cache for 5 minutes
- Visibility Rules rarely change → Cache for 5 minutes
- User Module Roles change occasionally → Cache for 1 minute

**Query Optimization:**
- Batch load all visibility rules for dashboard in single query
- Include key dates in the same query (JOIN)
- Evaluate rules in parallel with `Promise.all()`

---

## Migration Path

### For Existing Leagues

1. **No breaking changes** - Components without visibility rules remain always visible
2. **Gradual adoption** - Admins can link key dates to components incrementally
3. **Season rollover** - New seasons can inherit rules from previous season

### Schema Changes Required

**None** - All schema already exists:
- `LMSProKeyDate` ✅
- `VisibilityRule` ✅
- `ComponentDefinition` ✅

Only code changes needed:
- Update `DashboardActionCards` to respect visibility
- Add admin UI for managing visibility rules

---

## Success Criteria

| Metric | Target |
|--------|--------|
| Club users only see relevant actions | ✅ Filtered by role + time |
| League admins can configure workflows | ✅ Via Key Dates + Visibility Rules UI |
| Season rollover preserves rules | ✅ Duplicate copies rules too |
| No performance regression | ✅ < 100ms additional latency |
| Exempt roles work correctly | ✅ Bypass time gates |

---

## Immediate Next Steps

1. **Phase 1 implementation** (2 hours)
   - Update `DashboardActionCards.tsx` to check `visibility.isVisible`
   - Test with manually created visibility rules

2. **Create test visibility rules** (manual via Prisma Studio)
   - Link a Key Date to a component
   - Verify dashboard respects the rule

3. **Document admin workflow** (user guide)
   - How to create key dates
   - How to link key dates to components (future UI)

---

## Related Documentation

- `/docs/00-READ_THIS/feb_26_work/03-KEY_DATES_SYSTEM.md` - Key Dates implementation details
- `/docs/modules/lmspro/TEMP_workflow_context_lmspro_component_rbac_refactor.md` - Component RBAC context
- `/docs/00-overview/ui_ux_components/two-tier-tabbed-layout-pattern.md` - UI patterns

---

*Last Updated: 11 June 2025*
