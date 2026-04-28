# LMSPro: Season Migration Guide

**Document Type:** League Administrator Guide  
**Module:** LMSPro  
**Status:** Current — reflects implementation as of April 2026  
**Audience:** League Administrators (OWNER / ADMIN role)  
**Related Docs:**
- [Season Lifecycle & Team Registration Workflow](./season-lifecycle-and-team-registration-workflow.md) — full functional specification
- [Unified Timing Architecture](./unified-timing-architecture.md) — how Key Dates gate the process
- [Season Rollover Process](./season-rollover-process.md) — developer implementation reference

---

## Overview

Season migration is the process of moving from one playing season to the next. In LMSPro, this is a structured sequence of steps that the League Admin leads, with clubs responding at the right moments.

The process has two distinct phases:

| Phase | Who acts | What happens |
|---|---|---|
| **Pre-clone** | Clubs (on the current season) | Clubs confirm whether they are continuing. Teams indicate their intentions. |
| **Post-clone** | League Admin + Clubs (on the new season) | New season is built, aged forward, reviewed, and activated. |

All steps are controlled by **Key Dates**. The League Admin sets these dates at the start of each cycle. Key Dates open and close Action Cards on the club dashboard and control when public forms are available. Nothing is hardcoded — adjusting a Key Date immediately changes what clubs can see and do.

---

## The Complete Sequence at a Glance

```
CURRENT SEASON (ACTIVE)
│
├── Step 1  Set Key Dates for the migration cycle
├── Step 2  Club Continuation window opens
│           Clubs confirm they are continuing (or not responding = withdrawn)
├── Step 3  Team Continuation window opens (while club continuation is still live)
│           Clubs mark each team as continuing, withdrawing, or no response
│
└── Step 4  League Admin clones the season  ◄── ADMIN TRIGGER
                │
                ▼
NEW SEASON (IN_PREPARATION)
│
├── Step 5  League Admin reviews WITHDRAWN clubs and teams
│           Delete or reinstate as appropriate
├── Step 6  League Admin runs Roll Forward  ◄── ADMIN TRIGGER
│           Teams advance one age group; oldest age group archived
├── Step 7  Team Edit window opens
│           All clubs update manager details, rename teams, finalise details
├── Step 8  New Team Registration window opens (for existing clubs only)
│           Clubs add new teams (e.g. new U7 intake, second teams)
├── Step 9  New Club Application form opens (public)
│           New clubs apply; league reviews and approves
├── Step 10 League Admin approves all pending teams
├── Step 11 Division formation for new U7 cohort
│
└── Step 12 League Admin sets new season as Current  ◄── ADMIN TRIGGER
                │
                ▼
NEW SEASON (ACTIVE) — playing season begins
```

---

## Step-by-Step Detail

---

### Step 1 — Set Key Dates

**Who:** League Admin  
**Where:** Season → Key Dates page (on the current ACTIVE season)  
**When:** As early as possible — typically February/March  

Key Dates are the master controls for the whole migration. Before anything else, the League Admin should review and set the opening and closing dates for each window.

When a season is cloned, all Key Dates are copied across and shifted by 12 months as a starting point. The admin then adjusts individual dates as needed for the new season's calendar.

**Key Dates to configure for migration:**

| Key Date slug | Purpose | Typical DJFL dates |
|---|---|---|
| `clubs.continuation` | Opens the Club Continuation Action Card | 1 March – 31 March |
| `teams.continuation` | Opens the Team Continuation Action Card | 1 May – 15 May |
| `teams.register` | Opens new team registration for existing clubs | 16 May – 31 May |
| `club-registration-opens` | Opens the public new club application form | 1 June – 1 August |
| `teams.direct-edit` | Opens the team edit window for all clubs | 1 June – 15 August |
| `season-start` | First day of the new playing season | 1st Sunday in September |

> **Important:** Steps 2 and 3 must be completed on the **current ACTIVE season**, before cloning. The continuation data feeds directly into how the new season is built at clone time.

---

### Step 2 — Club Continuation Window

**Who:** Club Secretaries (with League Admin monitoring)  
**Where:** Club Dashboard → "Club Continuation" Action Card  
**When:** Determined by the `clubs.continuation` Key Date window  

Each club must confirm that they intend to continue into the next season. The Action Card is only visible and actionable while the Key Date window is open.

**Before a club can confirm, their Club Profile must be complete:**
- Secretary name and email
- Treasurer name and email
- Chair name and email

If any of these are missing, the system will not allow the club to confirm. The club must update their Club Profile first.

**What happens when a club confirms:**
- A confirmation record is created and timestamped against the Key Date
- The club is considered compliant for the continuation step

**What happens if a club does not confirm:**
- No action is required from the league during this window
- At clone time, the system will automatically set the club's status to **WITHDRAWN** in the new season
- The league admin reviews and deals with withdrawn clubs after cloning (Step 5)

**League Admin monitoring:**  
The Key Date Compliance page shows which clubs have confirmed and which have not. Reminders can be sent to non-responding clubs via the email system.

---

### Step 3 — Team Continuation Window

**Who:** Club Secretaries  
**Where:** Club Dashboard → "Team Continuation" Action Card  
**When:** Determined by the `teams.continuation` Key Date window  
**Prerequisite:** Club Continuation (Step 2) should be complete or running concurrently  

Once a club has confirmed they are continuing, their Club Secretary can open the Team Continuation card and indicate the intention for each individual team.

**For each team, the club marks one of three states:**

| Team state | What it means | At clone time |
|---|---|---|
| ✅ **Continuing** | Team is confirmed for next season | Cloned as **CURRENT** — included in roll-forward |
| ❌ **Withdrawing** | Team will not play next season | Cloned as **WITHDRAWN** — skipped by roll-forward |
| ⬜ **No response** | Club did not indicate either way | Cloned as **NO_RESPONSE** — skipped by roll-forward |

**Important notes:**
- Individual team checkboxes auto-save immediately — there is no submit button
- Clubs can change their minds within the window and reverse any decision
- "Confirm All" marks every team as continuing in one click
- "Withdraw All" is available with an in-line confirmation step to prevent accidents

**If a whole club is withdrawing**, the natural outcome is that all of their teams will be marked withdrawing or left with no response. All of those teams will arrive in the cloned season as WITHDRAWN or NO_RESPONSE, which means they are excluded from roll-forward and invisible in the default view. The league admin can delete the club and teams entirely in Step 5.

---

### Step 4 — Clone the Season

**Who:** League Admin  
**Where:** Seasons page → "Clone Season" button on the current ACTIVE season  
**When:** After the Club Continuation and Team Continuation windows have closed  

This is the moment the new season is built. The system creates a complete copy of the current season and immediately applies all continuation decisions.

**What the clone copies:**

| Copied | Notes |
|---|---|
| Age group structure | All age group definitions |
| Divisions | All division (AGG) structures |
| Venues | All venues and their club associations |
| Referees | All referee records |
| Key Dates | Copied and shifted +12 months as a starting point — admin adjusts |
| Clubs | All clubs — status set from continuation confirmation (see below) |
| Club officials | All linked user accounts |
| Teams | All teams — status set from continuation responses (see below) |

**Club status in the new season:**

| Club's continuation confirmation | New club status |
|---|---|
| ✅ Confirmed continuation | **APPROVED** — visible in the default clubs list |
| ⬜ Did not confirm | **WITHDRAWN** — hidden from default view; league admin resolves in Step 5 |

**Team status in the new season:**

| Team's continuation response | New team status |
|---|---|
| ✅ Continuing (`continuingNextSeason = true`) | **CURRENT** — included in roll-forward |
| ❌ Withdrawing (`continuingNextSeason = false`) | **WITHDRAWN** — excluded from roll-forward |
| ⬜ No response (`continuingNextSeason = null`) | **NO_RESPONSE** — excluded from roll-forward |

**What is not copied:**
- Free day requests (season-specific)
- Special free days (season-specific)
- Disciplinary records (season-specific)
- Club applications (season-specific)
- Fixtures and results

**Guard conditions — the clone will be blocked if:**
- Another season is already in `IN_PREPARATION` state (only one can exist at a time)
- There are pending club applications that have not been reviewed
- There are pending team applications that have not been reviewed

The new season is created with status `IN_PREPARATION` and `isCurrent: false`. The current season remains active. The new season will not be visible to clubs until the League Admin sets it as current in Step 12.

---

### Step 5 — Review Withdrawn Clubs and Teams

**Who:** League Admin  
**Where:** Clubs page (filter by "Withdrawn") and Teams page (filter by "Withdrawn" / "No Response")  
**When:** Immediately after cloning, before running Roll Forward  

After cloning, the League Admin should review what the continuation responses produced.

**For clubs marked WITHDRAWN:**
- These clubs did not confirm continuation during the window
- Default action: delete the club and all their teams from the new season
- Exception: if a club has a change of leadership or other extraordinary circumstances, the admin can change the club status back to APPROVED and correct the team statuses manually, then allow them to re-enter via the normal process

**For teams marked WITHDRAWN or NO_RESPONSE:**
- These teams are already excluded from roll-forward — they will not be promoted
- If they belong to a club that is being reinstated, the admin can manually set the team status to CURRENT before running roll-forward
- If the club is being deleted, deleting the club removes all associated teams automatically

> **Rule:** Roll Forward (Step 6) should only be run once this triage is complete. Any team with status CURRENT at that point will be promoted. WITHDRAWN and NO_RESPONSE teams will be left exactly where they are and must be deleted manually afterwards if not needed.

---

### Step 6 — Roll Forward Age Groups

**Who:** League Admin  
**Where:** Season Detail page → Roll Forward section (on the IN_PREPARATION season)  
**When:** After Step 5 (withdrawn clubs/teams resolved), before team edit and new registration windows open  

Roll Forward is the automatic age progression step. Every team that is CURRENT moves up one age group simultaneously across all clubs. Divisions travel with their age group.

**What happens to each age group:**

| Position | What happens |
|---|---|
| **Oldest age group** (e.g. U13) | All CURRENT teams are archived (`status: INACTIVE`). Their age group and division links are cleared. These teams have completed their journey in the league. |
| **Middle age groups** (e.g. U8–U12) | Each CURRENT team's age group is advanced by one year (U8 → U9, U9 → U10, etc.). The team's division assignment is kept — teams travel with their division. |
| **Youngest age group** (e.g. U7) | No existing teams are in this group yet (new U7 entrants come in through Steps 8 and 9). |

**Teams excluded from roll-forward:**
- `WITHDRAWN` — not promoted, left in place
- `NO_RESPONSE` — not promoted, left in place
- `INACTIVE` — already archived

**Divisions (AGGs):**
Each division is re-pointed to the next age group at the same time. A U7 division becomes a U8 division. New U7 divisions are created in Step 11 once the full picture of new entries is known.

**Guard conditions — roll-forward will be blocked if:**
- The season is not `IN_PREPARATION`
- The season is already set as current (`isCurrent: true`)
- Roll-forward has already been run (INACTIVE teams already exist on this season)

**Preview:**  
Before running, the Roll Forward panel shows a preview of how many teams will be promoted per age group, and how many will be skipped (WITHDRAWN/NO_RESPONSE). Review this before confirming.

> **This action cannot be undone.** Verify the preview looks correct before proceeding.

---

### Step 7 — Team Edit Window

**Who:** Club Secretaries  
**Where:** Club Dashboard → "Edit Teams" Action Card  
**When:** Determined by the `teams.direct-edit` Key Date window (typically 1 June – 15 August)  

After roll-forward, clubs can see their teams in their new age groups and make administrative corrections:

- Rename a team
- Update the team manager's name, email, and phone
- Mark a team as withdrawn (if circumstances change after roll-forward)

This window is for existing teams only. New teams are added via the Team Registration window (Step 8).

---

### Step 8 — New Team Registration (Existing Clubs)

**Who:** Club Secretaries  
**Where:** Club Dashboard → "Register a New Team" Action Card  
**When:** Determined by the `teams.register` Key Date window (typically 16 May – 31 May)  

Existing clubs apply to register additional teams for the new season — for example, a second U10 team, or a new U7 intake team. These applications go into a PENDING state and require league approval in Step 10.

New teams are added directly into the rolled-forward age groups — if a club is adding a new U8 team, it is registered in the U8 group as it exists after roll-forward.

> **Sequence note:** Roll Forward (Step 6) should run before this window opens. If a club registers a new team in an age group before roll-forward runs, that team will be promoted along with the existing teams, potentially landing in the wrong age group.

---

### Step 9 — New Club Applications (Public Form)

**Who:** New club applicants (public, unauthenticated)  
**Where:** Public registration form at `seasonpro.co.uk/embed/register/club?org=<league>`  
**When:** Determined by the `club-registration-opens` / `club-registration-closes` Key Date window (typically 1 June – 1 August)  

Entirely new clubs apply to join the league via the public form. Applications are reviewed in order of submission date. The League Admin processes these applications and approves, waitlists, or rejects each one.

Approved club applications create a new Club record and send a welcome email to the applicant with instructions to set up their SeasonPro account.

This window typically runs concurrently with the Team Edit window and New Club Application processing can overlap with existing club team approval.

---

### Step 10 — League Approves Pending Teams

**Who:** League Admin  
**Where:** Teams management page → filter by "Pending"  
**When:** August (after all application windows close, before season start)  

The League Admin reviews all teams with status PENDING — these are:
- New teams registered by existing clubs (Step 8)
- Teams from approved new club applications (Step 9)

**Decisions available for each team:**

| Decision | What it does |
|---|---|
| **Approve** | Team status → CURRENT; team is active for the new season |
| **Waiting List** | Team status → WAITING_LIST; held pending capacity |
| **Cancel/Reject** | Team removed from the system |

Approvals can be done individually or in bulk. The league should target having all approvals complete before the season start date.

---

### Step 11 — Division Formation for New Intake

**Who:** League Admin  
**Where:** Season Detail → Divisions (AGGs) management  
**When:** August, once the full picture of approved new teams is known  

New U7 divisions are created to accommodate the new youngest age group intake. Once all new U7 teams are approved and the count is known, the League Admin:

1. Creates the appropriate number of U7 divisions (typically named by colour or number)
2. Assigns each new U7 team to a division
3. Reviews division sizes across all age groups to ensure balance

This step may also involve reviewing division sizes across other age groups if the roll-forward has left any divisions under or over capacity.

---

### Step 12 — Activate the New Season

**Who:** League Admin  
**Where:** Seasons page → "Set as Current" on the IN_PREPARATION season  
**When:** Typically the week before the first playing date (end of August)  

The final admin trigger. Setting the new season as Current:
- Sets `isCurrent: true` on the new season
- The previous season is no longer current (clubs will now see the new season's data on their dashboard)
- The new season status changes from `IN_PREPARATION` → `ACTIVE`

From this point, the new season is live. Fixtures can be issued, results recorded, and the playing season begins.

---

## Key Date Summary

| Step | Key Date / slug | Default DJFL timing |
|---|---|---|
| 2 — Club Continuation | `clubs.continuation` | 1 March – 31 March |
| 3 — Team Continuation | `teams.continuation` | 1 May – 15 May |
| 7 — Team Edit | `teams.direct-edit` | 1 June – 15 August |
| 8 — New Team Registration | `teams.register` | 16 May – 31 May |
| 9 — New Club Applications | `club-registration-opens` | 1 June – 1 August |
| 12 — Season Start | `season-start` | 1st Sunday September |

All Key Dates are configured per season and can be adjusted each year without any involvement from the IsoStack team.

---

## What Clubs See at Each Stage

| Stage | What appears on the Club Dashboard |
|---|---|
| Before Step 2 window | No seasonal action cards |
| Step 2 window open | **Club Continuation** card — amber (action required) |
| Step 3 window open | **Team Continuation** card — amber (action required) |
| Step 7 window open | **Edit Teams** card |
| Step 8 window open | **Register a New Team** card |
| Post-activation | Standard club dashboard; playing season management |

Action Cards only appear when their associated Key Date window is open. Outside of windows, the Seasonal Actions section of the club dashboard is empty.

---

## Troubleshooting

### "Clone Season" button is greyed out or blocked

Check the following:
- Is there already a season in `IN_PREPARATION` state? Only one can exist at a time. You must activate or delete it before cloning again.
- Are there pending club applications? Approve, reject, or waitlist them first.
- Are there pending team applications? Approve or reject them first.

### A club that should be active is showing as WITHDRAWN after cloning

The club did not complete the Club Continuation step before the clone was run. The League Admin can:
1. Change the club's status to APPROVED manually
2. Review the club's teams and change any WITHDRAWN/NO_RESPONSE teams to CURRENT as appropriate
3. Ensure the club completes their continuation steps and team edit before roll-forward if timing allows

### A team has been promoted to the wrong age group after roll-forward

This can happen if a new team was registered in the wrong age group before roll-forward ran. The League Admin can manually update the team's age group directly in the team record.

### Roll Forward is blocked

Check:
- Is the season in `IN_PREPARATION` state? Roll Forward only works on preparation seasons.
- Is the season already set as Current? It must not be current yet.
- Has roll-forward already run? If INACTIVE teams already exist on this season, the guard will block a second run. Contact IsoStack support if a re-run is needed.

### A club wants to re-join after being set to WITHDRAWN

If a club missed the continuation window but still intends to continue (e.g. change of leadership):
1. Find the club on the Clubs page (filter: Withdrawn)
2. Change the club status to APPROVED
3. Review their teams — change any WITHDRAWN/NO_RESPONSE teams to CURRENT if they should be included in roll-forward
4. Ensure you do this before running Roll Forward (Step 6)

---

## Appendix: Status Reference

### Club Status

| Status | Meaning | Visible in default filter? |
|---|---|---|
| `APPROVED` | Active club in the season | ✅ Yes |
| `PENDING` | Awaiting league approval (new applications only) | ✅ Yes |
| `WITHDRAWN` | Did not confirm continuation, or club has withdrawn | ❌ No — must filter explicitly |
| `SUSPENDED` | Temporarily inactive by league action | ❌ No — must filter explicitly |
| `WAITING_LIST` | Accepted in principle; capacity pending | ✅ Yes |

### Team Status

| Status | Meaning | Included in roll-forward? |
|---|---|---|
| `CURRENT` | Active team in the season | ✅ Yes — promoted to next age group |
| `WITHDRAWN` | Club confirmed this team is not continuing | ❌ No |
| `NO_RESPONSE` | Club did not respond for this team | ❌ No |
| `INACTIVE` | Archived (oldest age group graduates) | ❌ No |
| `PENDING` | New team registration awaiting approval | ❌ No (not yet CURRENT) |
| `WAITING_LIST` | Approved in principle; capacity pending | ❌ No |

---

*Last updated: April 2026 — reflects Season Rollover implementation after April 2026 fixes (commits `49091de`, `ff59f06`, `5e4ed65`)*
