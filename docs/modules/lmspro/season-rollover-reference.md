# LMSPro: Season Rollover — Complete Reference

**Document Type:** Combined Functional Spec, Admin Guide & Developer Reference  
**Module:** LMSPro (SeasonPro)  
**Status:** Current — reflects implementation as of April 2026  
**Replaces:**
- `season-lifecycle-and-team-registration-workflow.md`
- `season-migration-guide.md`
- `season-rollover-process.md`

**Related Docs:**
- [Unified Workflow Gating Architecture](./unified-workflow-gating-architecture.md) — Key Dates, Action Cards, Visibility Rules
- [CR-18 Email Notifications](./planning/CR-18-Email-Notifications-System-Development-Plan.md) — email trigger points

---

## Overview

Season rollover is the annual process of moving from one playing season to the next. It is a structured sequence of steps led by the League Admin, with clubs responding at the right moments. All timing is controlled by **Key Dates** stored against the season — nothing is hardcoded to a calendar date.

There are two paths to the same starting point:

| Scenario | When used |
|---|---|
| **A — Clone** | League already has a previous season in LMSPro. Admin clones it. |
| **B — Bootstrap** | First time using LMSPro. Admin creates a blank season and imports data via CSV. *(UI not yet built — see [Not Yet Implemented](#not-yet-implemented))* |

Both paths produce an `IN_PREPARATION` season. Everything from the continuation window onwards is identical.

---

## The Complete Sequence

```
CURRENT SEASON (status: ACTIVE)
│
└──────── League Admin: CLONE SEASON ────────► NEW SEASON (status: IN_PREPARATION)
                                                │  All teams copied as CURRENT
                                                │  All divisions copied (linked to same age groups)
                                                │
                                                ├── League Admin: ROLL FORWARD AGE GROUPS
                                                │     All CURRENT teams advance one age group
                                                │     Each division re-pointed to the next age group
                                                │     (e.g. "U7 Division 1" → "U8 Division 1")
                                                │     Teams now in correct age groups for new season
                                                │
                                                ├── Continuation Confirmation Processes
                                                │     ├── Club Continuation window
                                                │     │     clubs confirm the club is participating
                                                │     └── Team Continuation window
                                                │           clubs mark each team:
                                                │           Continuing | Withdrawn | No Response
                                                │
                                                ├── League Admin: clean up Withdrawn + No Response
                                                │
                                                ├── New Team Registration (existing clubs)
                                                ├── New Club Application (public form)
                                                ├── League Admin: approve new club teams
                                                ├── New youngest-age Divisions created
                                                │     (e.g. new U7 divisions once full U7 intake known)
                                                └── League Admin: SET AS CURRENT
                                                        │
                                                        ▼
                                                NEW SEASON (status: ACTIVE)
```

> **Clone carries all teams as `CURRENT`.** No pre-clone continuation window is required. Roll Forward runs first so teams are in their correct new age groups before clubs are asked to confirm intentions.
>
> **The continuation window runs on the new `IN_PREPARATION` season** — after Roll Forward. Clubs confirm participation against teams already in their new age groups. The `continuingNextSeason` field name reflects the original design perspective; in practice the window is about the season that is about to start.
>
> **Flexible ordering is supported.** If a league prefers to run the continuation window on the current active season before cloning (to capture early withdrawals), those teams arrive in the new season as `WITHDRAWN`/`NO_RESPONSE` and are skipped by Roll Forward. Both paths lead to the same outcome — a clean `CURRENT` roster before the season goes ACTIVE.

---

## Key Dates That Drive This Process

All dates are stored as `LMSProKeyDate` records scoped to the season. Changing a date immediately changes when forms open, when Action Cards appear, and when emails fire.

| Key Date slug | What it gates | Typical DJFL dates |
|---|---|---|
| `clubs.continuation` | Club Continuation Action Card | 1 March – 31 March |
| `teams.continuation` | Team Continuation Action Card | 1 May – 15 May |
| `teams.register` | New team registration (existing clubs) | 16 May – 31 May |
| `club-registration-opens` / `club-registration-closes` | Public new club application form | 1 June – 1 August |
| `teams.direct-edit` | Team edit window | 1 June – 15 August |
| `season-start` | Season start trigger (email, banner) | 1st Sunday September |

Key Dates are copied when a season is cloned, shifted by the number of days between the old and new season start date. The League Admin adjusts them as needed for the new season's calendar.

---

## Step-by-Step Detail

---

### Step 1 — Configure Key Dates

**Who:** League Admin  
**Where:** Season → Key Dates page (on the current ACTIVE season)  
**When:** February / March — as early as possible

Before anything else, the League Admin reviews and sets the opening/closing dates for each window. Key Dates copied from the previous season are a starting point only — adjust for the new season's calendar.

---

### Step 2 — Club Continuation Window

**Who:** Club Secretaries  
**Where:** Club Dashboard → "Club Continuation" Action Card (gated by `clubs.continuation` Key Date on the **new IN_PREPARATION season**)  
**When:** After Roll Forward — clubs see their teams already in their new age groups

Clubs confirm their intention to participate in the coming season. The system is closed to clubs between seasons; when they next log in they are looking at the new season's data and confirming participation in what is, from their perspective, the upcoming season.

**Before a club can confirm, their Club Profile must be complete:**
- Secretary name and email
- Treasurer name and email
- Chair name and email

Missing any of these blocks confirmation. The club must update their Club Profile first.

**What the league sees:** The Key Date Compliance page shows which clubs have confirmed and which have not. Reminder emails can be sent to non-responding clubs.

---

### Step 3 — Team Continuation Window

**Who:** Club Secretaries  
**Where:** Club Dashboard → "Team Continuation" Action Card (gated by `teams.continuation` Key Date on the **new IN_PREPARATION season**)  
**When:** Concurrent with or after club continuation. Teams are already in their rolled-forward age groups.

Club Secretaries mark each team's intention. Because Roll Forward has already run, clubs see teams in their *new* age groups — they are confirming against the age group the team will actually play in.

**Three states per team:**

| State | `continuingNextSeason` | Meaning | Admin action before ACTIVE |
|---|---|---|---|
| Continuing | `true` | Team is playing | None — stays `CURRENT` |
| Withdrawn | `false` | Team will not play | Bulk-set `WITHDRAWN`/`CANCELLED`, remove |
| No Response | `null` | Club did not respond | Chase up; remove if no reply |

**UI behaviour:**
- Individual team toggles auto-save immediately — no submit button
- "Confirm All" marks every team as continuing in one click
- "Withdraw All" available with an in-line confirmation step
- Clubs can reverse any decision within the open window

---

### Step 4 — Clone the Season

**Who:** League Admin  
**Where:** Seasons page → "Clone Season" button  
**When:** Any time during the current active season — typically several months before the new season starts

This creates the new season from the current one and immediately applies all continuation decisions.

**What is copied:**

| Copied | Detail |
|---|---|
| Age group structure | All age group definitions |
| Divisions | All divisions copied with their full structure, name, and age group association. Teams remain in the same division they were in on the source season. Divisions do not have a status field — they exist as long as the season does. Roll Forward then re-points each division to the next age group (e.g. "U7 Division 1" becomes "U8 Division 1"). |
| Venues | All venues and club associations |
| Referees | All referee records |
| Key Dates | Copied and date-shifted to match the new season's start date |
| Clubs | All clubs copied as `APPROVED` — withdrawal decisions made after clone via continuation process |
| Club officials | All linked user accounts (with `LMSProClubOfficial` records) |
| Teams | All teams copied as `CURRENT` — continuation window then identifies withdrawals, cleaned up before season goes ACTIVE |

**What is NOT copied:**

| Not copied | Reason |
|---|---|
| Free day requests | Season-specific |
| Special free days | Season-specific |
| Disciplinary records | Season-specific |
| Club applications | Season-specific |
| Fixtures and results | Season-specific |

**Guard conditions (clone will be blocked if):**
- Another season is already `IN_PREPARATION` (only one at a time)
- Unresolved club applications in state `PENDING` or `EMAIL_VERIFIED`
- Teams in state `AWAITING_CLUB_APPROVAL`, `NEW_CLUB_PENDING_TEAM`, or `PENDING`

**Team numbers:** Cloned teams **retain their original team number** from the source season. This is vital for alignment with external systems (FA Full-Time, kit suppliers, club records). Team numbers are unique per `organisationId + seasonId` — the same number can exist in two different seasons for the same org. New teams added after cloning (manual add, club registration, new club teams) receive a fresh number: `Max(globalMax across all seasons + 1, season.nextTeamNumber)`.

**User access at clone time:** Users linked to clubs cloned as `WITHDRAWN` are automatically set to `DEACTIVATED` — see [User Access Control](#user-access-control) below.

**Output:** A new `LMSProSeason` with `status: IN_PREPARATION`, `isCurrent: false`. The current season remains active until Step 9.

---

### Step 5 — Clean Up Withdrawn and Non-Responding Teams

**Who:** League Admin  
**Where:** Season → Teams tab (filter by Withdrawn / No Response). TeamsTab bulk update.  
**When:** After the continuation windows close, before the season goes ACTIVE

All teams were promoted by Roll Forward because they were all `CURRENT` at that point. The continuation window has now identified which teams are not actually playing. This step removes them from the playing roster.

**For clubs that did not confirm continuation:**
- Set club status to `WITHDRAWN`, bulk-set their teams to `CANCELLED`/`INACTIVE`
- Exception: extraordinary circumstances — override manually and allow back in

**For teams marked Withdrawn or No Response:**
- Bulk-set to `CANCELLED` or `INACTIVE` via TeamsTab
- Or delete entirely if a clean removal is preferred

> **Why this works:** Roll Forward promoted every `CURRENT` team. The continuation window is what surfaces which of those teams should not be playing. Cleaning up here before the season goes ACTIVE produces an identical end-state to the alternative path (running continuation before Roll Forward and having those teams never promoted). The route doesn't matter — the destination is the same clean `CURRENT` roster.

---

### Step 6 — Roll Forward Age Groups

**Who:** League Admin  
**Where:** Season Detail page → Roll Forward section (on the `IN_PREPARATION` season)  
**When:** After Step 5, before the team edit and new registration windows open

Roll Forward is the automatic age-group progression. Every `CURRENT` team advances one age group simultaneously. Divisions advance with their teams.

**What happens to each age group:**

| Position | Behaviour |
|---|---|
| **Oldest** (e.g. U13) | All `CURRENT` teams → `INACTIVE`. Age group renamed to `(Retired)`. The division(s) for this age group are emptied and effectively retired — their teams' `ageGroupId` and division link (`aggId`) are cleared. |
| **Middle** (e.g. U8–U12) | Each `CURRENT` team's `ageGroupId` and `ageGroup` string advanced by one year (U9 → U10, etc.). `aggId` retained — team stays in its division. |
| **Youngest** (e.g. U7) | No existing teams — new youngest-age entrants come through Steps 8 and 9. |

**Teams NOT promoted:**
- `WITHDRAWN` — left exactly in place
- `NO_RESPONSE` — left exactly in place
- `INACTIVE` — already archived

**Division progression:** Each division's `ageGroupId` is re-pointed to the next age group in the same transaction — "U7 Division 1" becomes "U8 Division 1", and so on. Divisions associated with the oldest age group are left in place but effectively emptied (all their teams are `INACTIVE`). New youngest-age divisions (e.g. new U7 divisions) are created later in Step 11 once the full picture of new entries is known.

**Guard conditions (roll-forward is blocked if):**
- Season status is not `IN_PREPARATION` or `ACTIVE`
- `INACTIVE` teams already exist on this season (idempotency guard — prevents running twice)
- Fewer than two age groups exist on the season

**Preview:** Before running, the Roll Forward panel shows how many teams will be promoted per age group and how many will be skipped. Verify before confirming.

> **This action cannot be undone.**

---

### Step 7 — Team Edit Window

**Who:** Club Secretaries  
**Where:** Club Dashboard → "Edit Teams" Action Card (gated by `teams.direct-edit` Key Date)  
**When:** Typically 1 June – 15 August

After roll-forward, clubs can see their teams in their new age groups and make corrections:
- Rename a team
- Update manager contact details
- Mark a team as withdrawn if circumstances change

This window is for **existing teams only**. New teams are added in Step 8.

---

### Step 8 — New Team Registration (Existing Clubs)

**Who:** Club Secretaries  
**Where:** Club Dashboard → "Register a New Team" Action Card (gated by `teams.register` Key Date)  
**When:** Typically 16 May – 31 May

Existing clubs apply to register additional teams (e.g. a new U7 intake, a second U10 team). These go into `PENDING` state and require league approval in Step 10.

> New teams are added to the **rolled-forward** age groups. Roll Forward (Step 6) should run before this window opens to avoid new teams landing in the wrong age group.

---

### Step 9 — New Club Applications (Public Form)

**Who:** New club applicants (unauthenticated public)  
**Where:** Public form at `seasonpro.co.uk/embed/register/club?org=<league>`  
**When:** Gated by `club-registration-opens` / `club-registration-closes` Key Date (typically 1 June – 1 August)

New clubs apply via a public form. Applications are reviewed by the League Admin and either approved, placed on a waiting list, or rejected. Approved applications create a new club record in `APPROVED` status.

---

### Step 10 — League Team Approval

**Who:** League Admin  
**Where:** Season → Teams page → Pending tab  
**When:** August

The League Admin reviews all pending teams submitted in Steps 8 and 9 and makes decisions: Approve / Waiting List / Cancel. Bulk and individual actions are supported.

---

### Step 11 — Division Formation (New U7 Cohort)

**Who:** League Admin  
**Where:** Season → Division Manager  
**When:** August, after Step 10

New U7 divisions are created and teams allocated across them once the full picture of new U7 entrants is known.

---

### Step 12 — Set New Season as Current

**Who:** League Admin  
**Where:** Seasons page → Edit Season  
**When:** Start of the new playing season (1st Sunday September)

Setting `isCurrent: true` on the new season automatically archives the previous season. All club dashboards now show the new season's data.

---

## User Access Control

Club users (Club Secretaries, Treasurers, Welfare Officers, etc.) are linked to a specific club. Their access to SeasonPro is tied to that club's standing.

### Automatic Deactivation

When a club's status changes to **`WITHDRAWN`** or **`SUSPENDED`**, all users linked to that club are automatically set to `DEACTIVATED`:
- At clone time: users linked to WITHDRAWN clubs (did not confirm continuation) are deactivated within the clone transaction
- Via admin edit: if an admin changes a club's status directly to WITHDRAWN or SUSPENDED
- Via approve mutation: the reverse — approving a club reactivates its users

**Who gets deactivated:** Users linked via `LMSProClubOfficial` (current) or `User.lmsproClubId` (legacy).

**Who is protected from deactivation:**
- Users with a non-empty `lmsproLeagueRoles` array (legacy league role) — **never deactivated by club status changes**
- Users with any `lmsproRoleIds` pointing to a `ModuleRole` with `roleScope = 'LEAGUE'` — **never deactivated by club status changes**
- Users who are officials for a *different* club that is still `APPROVED` — protected from deactivation as long as they have another active club link

**League users are never touched by club status changes.** They must be removed manually if required.

### Re-joining

A DEACTIVATED user can regain access by being invited as a club official for a new legitimate club (same email address). When this happens:
- Their `lmsproClubId` is updated to the new club
- Their status is reset to `PENDING_INVITE`
- They receive the standard invitation flow and can log in again

This applies both via the club officials management page and when a new club is created and an existing email is used as primary contact.

### How Blocking Works

NextAuth checks `user.status` at every sign-in and session callback. Any user whose status is not `ACTIVE` is blocked from logging in. DEACTIVATED users will receive an error on their next login attempt, and their current session (if any) will be invalidated on the next token refresh.

---

## Implementation Status

### ✅ Implemented and current

| Feature | Router / File |
|---|---|
| Clone Season | `seasons.router.ts` → `cloneSeason` |
| Club continuation confirmation | `key-date-confirmations.router.ts` |
| Club status at clone (APPROVED / WITHDRAWN) | `seasons.router.ts` → `cloneSeason` |
| Team status at clone (CURRENT / WITHDRAWN / NO_RESPONSE) | `seasons.router.ts` → `cloneSeason` |
| Team number retention on clone (numbers preserved from source season) | `seasons.router.ts` → `cloneSeason` |
| Team number uniqueness per org+season (not org-wide) | `prisma/schema.prisma` — `@@unique([organizationId, seasonId, teamNumber])` |
| Roll Forward (promotion + inactivation) | `seasons.router.ts` → `rollForwardAgeGroups` |
| Roll Forward preview | `seasons.router.ts` → `getRollForwardPreview` |
| Roll Forward respects continuation — only CURRENT teams promoted | `seasons.router.ts` → `rollForwardAgeGroups` line 1342 |
| Oldest age group renamed `(Retired)` on roll-forward | `seasons.router.ts` → `rollForwardAgeGroups` |
| Division re-pointing during roll-forward (U7 Div 1 → U8 Div 1, etc.) | `seasons.router.ts` → `rollForwardAgeGroups` |
| Team Continuation modal (individual + bulk) | `TeamContinuationModal.tsx` |
| "Confirm All" fix (disabled only when all teams confirmed, not just all responded) | `TeamContinuationModal.tsx` commit `735c506` |
| NO_RESPONSE badge and status filter on Teams page | `teams/page.tsx`, `TeamsTab.tsx` |
| Status filters across all team/club list queries | All affected components (April 2026) |
| Club user deactivation on WITHDRAWN/SUSPENDED | `clubs.router.ts` → `syncClubUserAccess` |
| League user protection from deactivation | `clubs.router.ts` → `syncClubUserAccess` |
| Roll-forward deactivates users of WITHDRAWN clubs | `seasons.router.ts` → `cloneSeason` transaction |
| User reactivation on club re-approval or re-join | `clubs.router.ts`, `club-officials.router.ts` |

---

### ❌ Not Yet Implemented

#### Blank Season Creation (Bootstrap Path)
A UI path to create a new season without a source to clone from. Needed for:
1. First-time league onboarding (no previous LMSPro season)
2. Edge cases where the league wants to start fresh

The router supports creating `LMSProSeason` directly. The gap is a UI affordance — currently only the "Clone" button exists, which requires an existing `ACTIVE` season.

**Suggested approach:** When no `ACTIVE` season exists, show "Create New Season" as the primary CTA instead of "Clone Season".

#### CSV Import Tied to Season Setup Workflow
The CSV import infrastructure exists (`src/modules/lmspro/import/`) but is not integrated as a step in the season setup flow. For the bootstrap scenario, the admin needs a clear guided path:
1. Create blank season
2. Import clubs (CSV)
3. Import teams linked to clubs and age groups (CSV)
4. Proceed to Roll Forward

**Missing:** A guard preventing import into an `ACTIVE` season (should only be allowed on `IN_PREPARATION`), and UI guidance positioning import as a bootstrap step.

#### Workflow Templates (Visibility Rules)
Pre-defined sets of Visibility Rules that auto-populate when a season is cloned. Currently, Key Dates are copied but their Visibility Rule links are not. This means the League Admin must manually re-link Key Dates to Action Card components each season.

See [Unified Workflow Gating Architecture](./unified-workflow-gating-architecture.md) — Phase 3 for design.

---

## Data Model Quick Reference

### Season statuses
| Status | Meaning |
|---|---|
| `IN_PREPARATION` | New season being built — not visible to clubs |
| `ACTIVE` | Current playing season |
| `ARCHIVED` | Previous season — read-only |

### Club statuses
| Status | Meaning |
|---|---|
| `PENDING` | Initial registration, awaiting approval |
| `APPROVED` | Active club — confirmed continuation or newly approved |
| `WITHDRAWN` | Did not confirm continuation, or manually withdrawn |
| `SUSPENDED` | Temporarily inactive — admin action |
| `WAITING_LIST` | Accepted in principle, capacity pending |

### Team statuses
| Status | Meaning |
|---|---|
| `CURRENT` | Active team — included in roll-forward |
| `WITHDRAWN` | Club confirmed this team is not continuing |
| `NO_RESPONSE` | Club did not indicate either way — skipped by roll-forward |
| `INACTIVE` | Archived — was in the oldest age group at roll-forward time |
| `PENDING` | Awaiting league approval (new team application) |
| `AWAITING_CLUB_APPROVAL` | Application submitted by club, pending club confirmation |
| `NEW_CLUB_PENDING_TEAM` | New club application includes team — both awaiting approval |

### User statuses (relevant to club access)
| Status | Can log in? | When set |
|---|---|---|
| `ACTIVE` | ✅ Yes | Normal active user |
| `PENDING_INVITE` | ❌ No (until first sign-in) | Newly invited, has not logged in yet |
| `DEACTIVATED` | ❌ No | Club withdrawn/suspended; or manually deactivated |
| `SUSPENDED` | ❌ No | Admin action |

---

## What Clubs See at Each Stage

| Stage | Club Secretary sees |
|---|---|
| Continuation window open | "Club Continuation" and/or "Team Continuation" Action Cards |
| Between continuation close and clone | Normal current-season dashboard only |
| After clone, before set-as-current | Nothing changes — clubs still see the current season |
| After set-as-current | New season data; team edit / registration cards per Key Dates |
| Club set to WITHDRAWN | Users deactivated — cannot log in |
| Club re-approved | Users reactivated — receive PENDING_INVITE, can log in again |

---

*Last Updated: May 2026*
