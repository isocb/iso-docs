# Season Preparation Sequence

**Module:** LMSPro / SeasonPro  
**Last Updated:** May 2026  
**Status:** Canonical — supersedes any earlier notes on season rollover

---

## Why This Document Exists

The correct order of events for preparing a new season was not always obvious during early development because real-life time pressures meant some steps were completed out of order. This document records the **definitive sequence** so future development, testing, and support all follow the same mental model.

---

## The Canonical Season Preparation Flow

### Step 0 — Prerequisite: A current season exists

The system must have exactly one season flagged `isCurrent = true`.  
All live club/team data belongs to this season.

---

### Step 1 — League admin clones the current season

The league admin navigates to **Season Management → Clone Season** on the current active season.

What the clone operation does:
- Creates a brand-new `LMSProSeason` row with status `IN_PREPARATION`
- Copies all **clubs** (status reset to pending re-confirmation)
- Copies all **teams** (status reset to pending re-confirmation)
- Copies all **age groups** (with the same codes/age values)
- Copies all **divisions (AGGs)** — empty of teams initially
- Copies all **venues** and **referees**
- Copies **key dates**, shifted forward by one year
- Does **not** copy disciplinary records or free-day history

> **Important:** The cloned season starts with status `IN_PREPARATION` and `isCurrent = false`. The original season remains `isCurrent = true` and continues to run normally.

---

### Step 2 — League admin performs the Age Group Roll-Forward on the cloned season

With the new season `IN_PREPARATION`, the league admin reviews and adjusts the age group structure:
- Rename groups (e.g., move the U9 division up to become U10)
- Add or remove age groups / divisions
- Adjust capacities

This is done **before** any club or team interaction, so there are no teams in the new season yet to be displaced.

> The AGG roll-forward screen operates on the IN_PREPARATION season.  
> Teams from the old season are not affected.

---

### Step 3 — League admin sets the cloned season to `Current`

Once the AGG configuration is correct, the league admin uses **"Set as Current"** on the IN_PREPARATION season.

What happens internally:
- The previous current season is automatically archived (`isCurrent = false`, `status = ARCHIVED`)
- The new season becomes `isCurrent = true`, `status = ACTIVE`

> ⚠️ This happens **before** clubs and teams interact with the new season.  
> Clubs and teams see the new season immediately after this point.

---

### Step 4 — Key Date windows open (configured per-season)

The Key Date Manager controls **when** each self-service action becomes available to clubs:

| Key Date Window          | Effect when open                                                    |
|--------------------------|---------------------------------------------------------------------|
| Club Continuation        | Existing clubs confirm they are continuing                          |
| Team Continuation        | Existing teams confirm they are continuing (or withdrawing)         |
| New Team Requests        | Clubs can request additional teams for the new season               |
| New Club Applications    | New clubs apply to join the league                                  |

These windows are set by the league admin and activate automatically based on date/time.  
**No club or team action is possible before its window opens.**

---

### Step 5 — Clubs confirm continuation

Clubs receive notification (or log in and see the action card) when the **Club Continuation** window opens.

They confirm they are continuing → their club record is re-activated in the new season.

---

### Step 6 — Teams confirm continuation / new teams requested

Once clubs have confirmed:
- **Existing teams** are shown a continuation prompt — they confirm or withdraw.
- **New team requests** can be submitted by clubs that want to enter additional teams.
- Teams submitted appear in the **Team Approval** screen with status `PENDING`.

---

### Step 7 — League admin approves teams and assigns to divisions

In **Team Approval**:
- All Pending tab: approve (→ CURRENT), decline (→ CANCELLED), or waiting list
- Approved & Unallocated tab: click a team row to open the **Assign Division** modal and allocate it to an AGG directly

> Alternatively, teams can be allocated to AGGs from the **Division Manager** screen.

---

## UI Behaviour Notes

### "Planned" prefix on season names

If a season is set `isCurrent = true` but its `startDate` is still in the future, the system automatically prefixes the name with **"Planned:"** in all UI locations (dashboards, banners, summary panels).

This makes it visually clear to staff that the season has been configured and set current, but competition has not yet started.

### Season Banner on dashboards

Both the **League Dashboard** and the **Club Dashboard** show a **Season Banner** near the top of the page. This:
- Shows the active season name (with "Planned:" prefix if applicable)
- Shows the season date range
- For league/admin users: provides a dropdown to navigate to any other season's detail page for historical reference
- For club users: display only (read-only)

### Approved & Unallocated tab

Teams that have been approved but not yet placed in a division appear in the **Approved & Unallocated** tab on the Team Approval screen. Clicking a team row opens a modal where the league admin can:
- Select a division (AGG) from the current season
- Optionally notify the club by email
- Save the allocation

---

## Data Model Summary

```
LMSProSeason
  isCurrent: boolean   — exactly one season is current at any time
  status: IN_PREPARATION | ACTIVE | ARCHIVED
  startDate: Date      — if startDate > today AND isCurrent → display as "Planned"

LMSProTeam
  status: PENDING | CURRENT | WAITING_LIST | CANCELLED | WITHDRAWN
  aggId: string|null   — null = approved but not yet placed in a division
```

---

## Anti-Patterns to Avoid

| ❌ Do not | ✅ Instead |
|-----------|------------|
| Roll forward AGGs after clubs/teams have been activated | Run AGG roll-forward before setting the season current (Step 2 above) |
| Set the cloned season current before AGGs are configured | Configure AGGs on the IN_PREPARATION season first |
| Manually set `isCurrent` in the database | Use "Set as Current" in the UI — it archives the old season atomically |
| Allocate teams to AGGs via database | Use Team Approval modal or Division Manager in the UI |
