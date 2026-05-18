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

### Normal Season Sequence

The correct order of operations for a new season is:

```
1. CLONE
   └─ League admin clones the current active season
   └─ A new season is created (status: IN_PREPARATION)
   └─ All teams carry over with their existing continuingNextSeason values

2. ROLL FORWARD
   └─ League admin advances age groups (U7 → U8, etc.)
   └─ Season configuration reviewed and updated

3. CONTINUATION CONFIRMATION PROCESSES
   ├─ Club Continuation window opens → clubs confirm the club is continuing
   └─ Team Continuation window opens → clubs declare each team: Continuing | Withdrawn | No Response
        │
        ├─ AUTO-RESET (D-1 trigger — see below)
        │    All teams in the season are reset to continuingNextSeason = null
        │    before the window opens, giving clubs a clean slate to respond
        │
        └─ Window closes → league reviews; teams still null = No Response

4. NEW TEAM APPROVAL PROCESS
   └─ Existing clubs submit new team registrations; league approves/rejects

5. NEW CLUB PROCESS
   └─ New clubs apply via public registration form; league reviews applications

6. NEW CLUB TEAM APPROVAL PROCESS
   └─ Newly approved clubs submit their teams for approval

7. AGE GROUP / DIVISION ALLOCATION PROCESSES
   └─ League assigns teams to age groups and divisions
   └─ Season set to ACTIVE — playing season begins
```

### Auto-Reset at D-1 (System Behaviour)

When the **Team Continuation Key Date** is configured, the system automatically resets all `continuingNextSeason` values to `null` for every team in the season **the day before the window opens** (`activeFrom - 1 day`).

**Why D-1?**  
Teams carry over from the clone with whatever value `continuingNextSeason` held in the previous season. This ensures that when the window opens and clubs log in, every team correctly shows **No Response** — regardless of history — and clubs must actively declare intent.

**How it works:**  
The reset is triggered lazily on the first call to `getContinuationStatus` after D-1. It is idempotent — tracked via an `AuditLog` entry (`LMSPRO_TEAM_CONTINUATION_RESET`) keyed to the key date ID. It fires once per continuation window, never twice.

### Bulk Reset (Admin Fallback)

If an auto-reset fails or league admins need to manually re-open the slate, the **Bulk Update** tool in the TeamsTab (season detail page) can be used:

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

The `continuingNextSeason` field feeds directly into the Clone step. At clone time, each team's status in the new season is set from this field:

| `continuingNextSeason` | Status in cloned season |
|---|---|
| `true` (Continuing) | `CURRENT` — will be promoted by Roll Forward |
| `false` (Withdrawn) | `WITHDRAWN` — skipped by Roll Forward |
| `null` (No Response) | `NO_RESPONSE` — skipped by Roll Forward |

**All teams are always copied on clone** — no team is dropped. The continuation field determines their starting status only.

### Flexible ordering

The ideal sequence is: continuation window closes → clone → Roll Forward. But **clone first is equally valid**. If the league clones before running a continuation window, all teams arrive as `NO_RESPONSE` (since all fields are `null`). The League Admin then uses the TeamsTab bulk update to set the correct statuses before running Roll Forward.

Roll Forward acts only on `CURRENT` teams — it does not care whether that status was set automatically by the continuation window at clone time, or manually corrected by the League Admin afterwards.

See [`season-rollover-reference.md`](./season-rollover-reference.md) for full rollover sequence.

---

## Key Dates Integration

The **Team Continuation Window** is controlled by Key Dates (like all action cards). The card appears on the club dashboard when the window is open and hides automatically when it closes.

See [`unified-timing-architecture.md`](./unified-timing-architecture.md) for how Key Dates drive card visibility.
