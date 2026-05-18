# Team Continuation Card

> **Status:** Implemented — dev branch  
> **Last Updated:** 18 May 2026  
> **Related Docs:** [`unified-timing-architecture.md`](./unified-timing-architecture.md) · [`season-rollover-reference.md`](./season-rollover-reference.md)

---

## Overview

The **Team Continuation Card** is a dashboard action card visible to club admins/managers during the **team continuation window**. It allows clubs to declare whether each of their registered teams intends to participate in the following season.

This is distinct from team *registration* (which is about joining the current season) — continuation is about forward-looking intent for the *next* season.

---

## The `continuingNextSeason` Field

**Prisma model:** `LMSProTeam`  
**Field name:** `continuingNextSeason`  
**Column:** `continuing_next_season`  
**Type:** `Boolean?` (nullable — three-state)

This field represents a **club's declared intention** for a team in the following season. It is not the same as `status`, which reflects the team's standing in the *current* season.

### Values

| Value | UI Label | Meaning |
|-------|----------|---------|
| `null` | **No Response** | Default. No indication given yet — club has not declared intent |
| `true` | **Continuing** | Club has confirmed this team will re-register for next season |
| `false` | **Withdrawn** | Club has indicated this team will not return next season |

### Default Behaviour

- **New team registrations** (`submitRegistration`) always default to `null` (No Response)
- `null` is the correct starting state for all teams at the opening of the continuation window
- The league should not assume continuation — clubs must actively confirm or withdraw

---

## Workflow

### Normal Season Flow

```
Season Opens
  └─ All teams: continuingNextSeason = null (No Response)

Continuation Window Opens
  └─ Club Continuation Card becomes visible on dashboard
  └─ Clubs review each team and set: Continuing | Withdrawn

Continuation Window Closes
  └─ League reviews responses
  └─ Teams still on null = No Response → league follows up or treats as withdrawn
  └─ Season Rollover begins using continuation data to pre-populate next season
```

### Exceptional Bulk Reset (Admin Tool)

In cases where teams have been incorrectly pre-set (e.g., a data migration or an exceptional year), league admins can use the **Bulk Update** tool in the TeamsTab (season detail page):

1. Navigate to **Seasons → [Season] → Teams**
2. Select affected teams using row checkboxes
3. Use the bulk action bar → **Set No Response** (resets to `null`)

This is also used to bulk-set **Continuing** or **Withdrawn** for groups of teams.

---

## UI: TeamsTab (Season Detail Page)

**Location:** `src/app/(app)/app/lmspro/seasons/[seasonId]/_components/TeamsTab.tsx`

### Column Display

The `continuingNextSeason` column displays a badge per team:

| Value | Badge |
|-------|-------|
| `null` | Grey — "No Response" |
| `true` | Green — "Continuing" |
| `false` | Red — "Withdrawn" |

### Filters

- **Status filter** — filter by team status (Current, Pending, Cancelled, etc.)
- **Continuation filter** — filter by `continuingNextSeason` value (All / Continuing / Withdrawn / No Response)
- Default view shows **all statuses** (not filtered to Current only)

### Edit Modal

Click any row to open the team edit modal. Fields include:

- Team Name, Age Group, Division
- **Team Status** (current season)
- **Continuing Next Season** — Select: Continuing / Withdrawn / No Response
- Manager contact details, Status Notes

### Bulk Actions

When one or more rows are selected (checkbox), a bulk action bar appears:

**Continuation:**
- Set Continuing (`true`)
- Set Withdrawn (`false`)
- Set No Response (`null`)

**Status:**
- Set Current
- Set Cancelled

---

## UI: Club Page Teams Table

**Location:** `src/app/(app)/app/lmspro/clubs/[clubId]/page.tsx`

The club page teams table also reflects `continuingNextSeason`. Key behaviours:

- Shows **all team statuses** by default (not filtered to Current)
- A **status filter Select** allows narrowing by team status
- Row click opens the team edit modal (same as TeamsTab)

---

## tRPC API

### `teams.bulkUpdateContinuation`

Bulk-sets `continuingNextSeason` for a list of teams.

```typescript
// Input
{
  teamIds: string[];      // Array of LMSProTeam IDs
  continuing: boolean | null;  // true | false | null
}

// Access: LEAGUE_ADMIN and above only
// Audit log: LMSPRO_TEAMS_BULK_CONTINUATION_UPDATE
```

### `teams.update`

Single-team update (called from edit modal). Accepts `continuingNextSeason: boolean | null`.

### `teams.submitRegistration`

New team registration. Always sets `continuingNextSeason: null` (No Response). Clubs declare continuation intent separately via the Continuation Card.

---

## Season Rollover Integration

During season rollover, `continuingNextSeason` data is used to:

1. **Pre-populate** the next season's team list with confirmed `true` teams
2. **Flag** `null` (No Response) teams for league follow-up
3. **Exclude** `false` (Withdrawn) teams from the new season automatically

See [`season-rollover-reference.md`](./season-rollover-reference.md) for full rollover sequence.

---

## Key Dates Integration

The **Team Continuation Window** is controlled by Key Dates (like all action cards). The card appears on the club dashboard when the window is open and hides automatically when it closes.

See [`unified-timing-architecture.md`](./unified-timing-architecture.md) for how Key Dates drive card visibility.
