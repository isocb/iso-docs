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
├── Key Dates configured for the rollover cycle
├── Club Continuation window opens   ← clubs confirm they are continuing
└── Team Continuation window opens   ← clubs mark each team: continuing / withdrawing
                                        (runs concurrently with, or after, club continuation)
│
└──────── League Admin: CLONE SEASON ────────► NEW SEASON (status: IN_PREPARATION)
                                                │
                                                ├── Review: withdrawn clubs & teams
                                                ├── League Admin: ROLL FORWARD AGE GROUPS
                                                ├── Team Edit window (clubs update details)
                                                ├── New Team Registration window (existing clubs)
                                                ├── New Club Application form (public)
                                                ├── League Admin: approve pending teams
                                                └── Division formation for new U7 cohort
                                                │
                                                └── League Admin: SET AS CURRENT
                                                        │
                                                        ▼
                                                NEW SEASON (status: ACTIVE)
                                                Playing season begins
```

> **Ideal sequence:** Club and Team Continuation windows run and close on the current ACTIVE season *before* cloning. The continuation data is then read at clone time to automatically set club and team statuses in the new season.
>
> **Clone first is also valid.** If the league clones before the continuation window has run (or at all), all teams arrive in the new season as `NO_RESPONSE` (since `continuingNextSeason = null`). The League Admin then corrects statuses manually via the TeamsTab bulk update before running Roll Forward. This is functionally identical — Roll Forward only ever acts on `CURRENT` teams, regardless of how they got there.
>
> **What clone carries forward:** All teams are copied. Their status in the new season is determined entirely by `continuingNextSeason` at clone time — it is not a separate step. If no continuation window ran, all teams arrive as `NO_RESPONSE` and must be manually triaged before Roll Forward.

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
**Where:** Club Dashboard → "Club Continuation" Action Card (gated by `clubs.continuation` Key Date)  
**When:** Typically 1 March – 31 March

Each club confirms their intention to continue into the next season. The Action Card is only available while the Key Date window is open.

**Before a club can confirm, their Club Profile must be complete:**
- Secretary name and email
- Treasurer name and email
- Chair name and email

Missing any of these blocks confirmation. The club must update their Club Profile first.

**What the league sees:** The Key Date Compliance page shows which clubs have confirmed and which have not. Reminder emails can be sent to non-responding clubs.

**At clone time:**
| Club's confirmation | Club status in new season |
|---|---|
| ✅ Confirmed | `APPROVED` — visible in all default views |
| ⬜ Did not confirm | `WITHDRAWN` — hidden from default views; League Admin reviews in Step 5 |

> If no `clubs.continuation` Key Date exists for the season (league did not run a continuation window), **all clubs are cloned as APPROVED**.

---

### Step 3 — Team Continuation Window

**Who:** Club Secretaries  
**Where:** Club Dashboard → "Team Continuation" Action Card (gated by `teams.continuation` Key Date)  
**When:** Typically 1 May – 15 May. Can run concurrently with club continuation.

Once a club has confirmed they are continuing, their Club Secretary marks the intention for each individual team.

**Three states per team:**

| Team state | Meaning | Status in new season |
|---|---|---|
| ✅ Continuing (`continuingNextSeason = true`) | Team is playing next season | `CURRENT` — included in roll-forward |
| ❌ Withdrawing (`continuingNextSeason = false`) | Team will not play | `WITHDRAWN` — excluded from roll-forward |
| ⬜ No response (`continuingNextSeason = null`) | Club did not respond | `NO_RESPONSE` — excluded from roll-forward |

**UI behaviour:**
- Individual team toggles auto-save immediately — no submit button
- "Confirm All" marks every team as continuing in one click (only disabled if all teams are already confirmed as continuing)
- "Withdraw All" available with an in-line confirmation step to prevent accidents
- Clubs can reverse any decision within the open window

**If a whole club is withdrawing:** All their teams will arrive in the cloned season as WITHDRAWN or NO_RESPONSE and will be excluded from roll-forward. The League Admin can delete the club and all teams in Step 5.

---

### Step 4 — Clone the Season

**Who:** League Admin  
**Where:** Seasons page → "Clone Season" button  
**When:** After the Club and Team Continuation windows have closed

This creates the new season from the current one and immediately applies all continuation decisions.

**What is copied:**

| Copied | Detail |
|---|---|
| Age group structure | All age group definitions |
| Divisions (AGGs) | All division structures |
| Venues | All venues and club associations |
| Referees | All referee records |
| Key Dates | Copied and date-shifted to match the new season's start date |
| Clubs | All clubs — status set from continuation confirmation |
| Club officials | All linked user accounts (with `LMSProClubOfficial` records) |
| Teams | All teams — status set from team continuation responses |

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

**Team numbers:** All cloned teams receive new sequential team numbers, globally unique per organisation. The source season's team numbers are not reused.

**User access at clone time:** Users linked to clubs cloned as `WITHDRAWN` are automatically set to `DEACTIVATED` — see [User Access Control](#user-access-control) below.

**Output:** A new `LMSProSeason` with `status: IN_PREPARATION`, `isCurrent: false`. The current season remains active until Step 9.

---

### Step 5 — Review Withdrawn Clubs and Teams

**Who:** League Admin  
**Where:** Clubs page (filter "Withdrawn") and Teams page (filter "Withdrawn" / "No Response")  
**When:** Immediately after cloning, before running Roll Forward

The League Admin reviews what the continuation responses produced.

**For clubs marked WITHDRAWN:**
- Default action: delete the club and all their teams from the new season
- Exception: if a club has extraordinary circumstances (e.g. new leadership), change status back to `APPROVED`, correct team statuses manually, and allow them back in

**For teams marked WITHDRAWN or NO_RESPONSE:**
- Already excluded from roll-forward — no action required unless reinstating
- If the parent club is being deleted, deleting the club removes all their teams automatically
- If a team is being reinstated, set its status to `CURRENT` before running Roll Forward

> **Rule:** Run Roll Forward only after this triage is complete. Only `CURRENT` teams at that point will be promoted — regardless of whether their `CURRENT` status came from the continuation window at clone time, or was set manually by the League Admin after cloning. The mechanism is the same either way.

---

### Step 6 — Roll Forward Age Groups

**Who:** League Admin  
**Where:** Season Detail page → Roll Forward section (on the `IN_PREPARATION` season)  
**When:** After Step 5, before the team edit and new registration windows open

Roll Forward is the automatic age-group progression. Every `CURRENT` team advances one age group simultaneously. Divisions advance with their teams.

**What happens to each age group:**

| Position | Behaviour |
|---|---|
| **Oldest** (e.g. U13) | All `CURRENT` teams → `INACTIVE`. Age group renamed to `(Retired)` in Division Manager. Teams' `ageGroupId` and `aggId` cleared. |
| **Middle** (e.g. U8–U12) | Each `CURRENT` team's `ageGroupId` and `ageGroup` string advanced by one year (U9 → U10, etc.). `aggId` retained — team stays in its division. |
| **Youngest** (e.g. U7) | No existing teams — new youngest-age entrants come through Steps 8 and 9. |

**Teams NOT promoted:**
- `WITHDRAWN` — left exactly in place
- `NO_RESPONSE` — left exactly in place
- `INACTIVE` — already archived

**Division (AGG) progression:** Each division's `ageGroupId` is re-pointed to the next age group in the same transaction. A "U7 Division 1" becomes a "U8 Division 1". New U7 divisions are created in Step 9 once the full picture of new entries is known.

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
**Where:** Division Manager (AGGs page)  
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
| Roll Forward (promotion + inactivation) | `seasons.router.ts` → `rollForwardAgeGroups` |
| Roll Forward preview | `seasons.router.ts` → `getRollForwardPreview` |
| Roll Forward respects continuation — only CURRENT teams promoted | `seasons.router.ts` → `rollForwardAgeGroups` line 1342 |
| Oldest age group renamed `(Retired)` on roll-forward | `seasons.router.ts` → `rollForwardAgeGroups` |
| Division (AGG) re-pointing during roll-forward | `seasons.router.ts` → `rollForwardAgeGroups` |
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

*Last Updated: April 2026*
