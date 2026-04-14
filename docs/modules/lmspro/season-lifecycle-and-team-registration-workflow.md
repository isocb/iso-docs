# LMSPro: Season Lifecycle & Team Registration Workflow

**Document Type:** Functional Specification  
**Module:** LMSPro  
**Status:** Draft — In Development  
**Created:** March 2026  
**Authors:** IsoStack / DJFL  
**Related Docs:**
- [Unified Timing Architecture](./unified-timing-architecture.md) — Key Dates, Visibility Rules, Action Card gating
- [Season Rollover Process](./season-rollover-process.md) — developer reference: implementation status, gaps, and work threads for the rollover sequence
- [CR-18 Email Notifications](./planning/CR-18-Email-Notifications-System-Development-Plan.md) — email trigger points
- [DJFL Dates 2026](./DJFL%20Dates%202026.csv) — source dates for Key Date configuration

---

## Overview

This document defines the complete season lifecycle for a youth football league managed by LMSPro. It covers the full journey from season creation through to team allocation, including the new club registration process, the returning club confirmation workflow, and the team approval framework.

This document serves as:
- The authoritative functional specification for the team registration and approval system
- The basis for email notification workflow design (see [CR-18 Email Notifications](./planning/CR-18-Email-Notifications-System-Development-Plan.md))
- The refinement foundation for future automation and self-service enhancements

### Core Principle: Everything Is Driven by Key Dates

**All** dates that govern this workflow — including form windows, Action Card visibility, email triggers, and dashboard reminders — are stored as `LMSProKeyDate` records **scoped to the season** (`seasonId`). Nothing is hardcoded to a calendar date.

This means:
- The League Admin configures all dates in the Season → Key Dates page
- Changing a date there immediately changes when forms open, when cards appear, when emails fire
- Key Dates are copied when a season is cloned (with a 12-month offset as a starting point)
- League Admins can override any date each year without any code changes
- All operations, Action Cards, public forms, and email notifications query Key Dates at runtime

Key Dates have three functional types:

| Type | Purpose | System Behaviour |
|------|---------|------------------|
| **Window** | Open/close dates for a form or Action Card | Pattern A (public form) or Pattern B (Action Card) gating |
| **Trigger** | A point-in-time event (e.g., season start) | Email notification sent; banner reminder shown |
| **Reminder** | Informational date with no system action | Dashboard banner countdown only; no form or card gating |

---

## Actors

| Actor | Role | Access Level |
|-------|------|-------------|
| **League Admin** | League administrator — manages the season, approves clubs and teams | LMSPro `OWNER` or `ADMIN` |
| **Club Secretary** | Primary contact for an existing club | `lmsproClubRole: CLUB_SECRETARY` |
| **New Club Applicant** | Person applying to register a new club | Unauthenticated (public form) |
| **FA FullTime** | FA's own player registration system — runs in parallel to LMSPro | External |
| **System** | Automated actions triggered by dates, status transitions, or user actions | N/A |

---

## Season Lifecycle — High-Level Stages

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  PRE-SEASON: End of Current Season                          [April–May]      │
│  All dates stored as Key Dates (type: Reminder or Trigger), scoped to       │
│  the current season. Manageable by League Admin in Key Dates page.          │
│  • season-end          — End of playing season (last Sunday April)          │
│  • player-transfer-deadline  — Player transfer/reg deadline (1 March)       │
│  • trophies-return     — Return of all trophies (1 March)                   │
│  • player-rereg-opens  — Player re-registration opens (1 April)             │
│  • continuation-notice — Club continuation notice (31 March)                │
│  • officer-nominations — Officer nominations deadline (30 April)            │
│  • rules-submission    — Proposed rule changes deadline (1 May)             │
│  • financial-year-end  — End of financial year (31 May)                     │
└──────────────────────────────┬──────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│  STAGE 1: Season Preparation                            [Admin trigger ~May] │
│  SCENARIO A (Steady State): League Admin clones the current season           │
│  SCENARIO B (Bootstrap / First Use): Admin creates a blank season and        │
│    imports existing club/team data via CSV                                   │
│  Both paths produce an IN_PREPARATION season ready for continuation          │
│  See: Season Rollover Process doc for full bootstrap detail                 │
└──────────────────────────────┬──────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│  STAGE 2: Existing Club Team Continuation           [1 May – 15 May]        │
│  Clubs confirm which existing teams are continuing into the new season      │
│  Key Date slug: team-continuation-opens / team-continuation-closes          │
│  ⚠️  Must complete BEFORE Roll Forward (Stage 3) runs                       │
└──────────────────────────────┬──────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│  STAGE 3: Division Roll Forward                         [Admin trigger ~May] │
│  Age groups advance (U7→U8, U8→U9 ... U12→U13 archived)                    │
│  Only CONFIRMED (continuingNextSeason = true) teams are promoted            │
│  WITHDRAWN teams are excluded from roll forward                             │
│  ⚠️  Partial implementation — see Season Rollover Process doc               │
└──────────────────────────────┬──────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│  STAGE 4: Existing Club New Teams & Under 7s        [16 May – 31 May]       │
│  Existing clubs exclusively apply to add new teams + new U7 intake          │
│  New teams added to ROLLED FORWARD age groups (not pre-roll groups)         │
│  Key Date slug: team-registration-opens / team-registration-closes          │
│  (Action Card: teams.register — only visible to existing clubs)             │
└──────────────────────────────┬──────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│  STAGE 5: New Club Applications Open                [1 June – 1 August]     │
│  New clubs apply via public form — in order of application date             │
│  Key Date slug: club-registration-opens / club-registration-closes          │
│  (Public form gated via TimedFormWrapper — Pattern A)                       │
│  NOTE: runs concurrently with Season Start (1 June) and online player       │
│  registration. AGM held no later than end of July during this period.       │
└──────────────────────────────┬──────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│  STAGE 6: Team Edit Window & Final Withdrawals      [1 June – 15 August]    │
│  All clubs can edit team details, add or withdraw teams                     │
│  Key Date slug: team-edit-opens / team-edit-closes (15 August)             │
│  Minimum player registration deadline: 10 August                           │
└──────────────────────────────┬──────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│  STAGE 7: League Team Approval                      [August]                │
│  League Admin reviews all pending teams and makes decisions                 │
│  (Approve / Waiting List / Cancel) — bulk or individual                     │
│  Key Date slug: team-approval-opens / team-approval-closes                  │
└──────────────────────────────┬──────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│  STAGE 8: Division Formation                        [August]                │
│  New U7 Divisions created and teams allocated across divisions               │
└──────────────────────────────┬──────────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│  SEASON START                                       [1st Sunday September]  │
│  Key Date slug: season-start (type: Trigger)                                │
│  Playing season begins. Email notifications sent to all clubs.              │
│  player-registration-opens — FA FullTime reminder (from 1 June)            │
│  player-registration-deadline — Min players registered (10 August)         │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Stage 1: Season Preparation

> **Developer reference:** See [Season Rollover Process](./season-rollover-process.md) for implementation status, the bootstrap path detail, and outstanding work items.

### Two Paths to the Same Outcome

**Scenario A — Steady-State (Clone):** Used when the league already has a previous season in LMSPro. League Admin clones the current season from the Seasons management page.

**Scenario B — Bootstrap (Blank + Import):** Used when a league is new to LMSPro and has no previous LMSPro season. Admin creates a blank season, then imports existing club and team data via CSV. The result is an `IN_PREPARATION` season in the same state as a clone. *(Blank season creation UI not yet built — see rollover doc.)*

Both paths produce an `IN_PREPARATION` season. The continuation and roll-forward steps (Stages 2–3) operate identically regardless of which path was used.

### What Clone Does
The system creates an **exact copy** of the current season as the working data for the next season. The clone includes:

| Data Copied | Notes |
|-------------|-------|
| Season name | Admin renames to next season (e.g., "2026/27") |
| Age groups | All age group definitions carried forward |
| Divisions (AGGs) | Structure copied — teams re-allocated after roll forward |
| Venues | All venues copied |
| Referees | All referees copied |
| Key Dates | Copied and dates shifted by 12 months (admin adjusts) |
| Clubs | All active clubs copied into the new season |
| Teams | All teams with status `CURRENT` are copied |

| Data **Not** Copied | Notes |
|---------------------|-------|
| Free Days | Season-specific — not carried forward |
| Special Free Days | Season-specific — not carried forward |
| Disciplinary Records | Season-specific — not carried forward |
| Club Applications | Season-specific — not carried forward |
| Team Status history | Each team starts fresh in the new season |

### Output
A new `LMSProSeason` record with `isCurrent: false`. The original season remains current until the League Admin explicitly sets the new one as current (typically at the start of the new season).

---

## Stage 2: Existing Club — Team Continuation

> **Sequence note:** Continuation (Stage 2) must complete **before** Roll Forward (Stage 3) runs. The roll-forward only promotes teams with `continuingNextSeason = true`. Running roll-forward before clubs have responded means all teams get promoted regardless of their continuation intent.

See the [full Stage 2 detail](#stage-3-existing-club--team-continuation-confirmation) below. *(Heading retained as Stage 3 in the detailed section for historical continuity — will be reconciled in a future doc revision.)*

---

## Stage 3: Division Roll Forward

### Trigger
League Admin triggers "Roll Forward Age Groups" from the Season Detail page, **on the `IN_PREPARATION` season**, after the continuation window (Stage 2) has closed.

### Age Group Progression

All age groups advance by one year. The boundary conditions:

| From | To | Notes |
|------|----|-------|
| U6 | U7 | If U6 exists |
| U7 | U8 | Standard progression |
| U8 | U9 | Standard progression |
| U9 | U10 | Standard progression |
| U10 | U11 | Standard progression |
| U11 | U12 | Standard progression |
| U12 | U13 | Standard progression |
| U13 | **Archived** | U13 is the maximum age for junior football; teams graduate out of the league |

> **Note:** The exact upper age boundary is configurable per league. DJFL's upper limit is U13.

### Team Age Group Update
Teams with `continuingNextSeason = true` are automatically reassigned to the next age group (e.g., U9 → U10), across all clubs simultaneously. The team record is updated; the sequential `teamNumber` does not change.

> **⚠️ Known implementation gap:** The current `rollForwardAgeGroups` procedure promotes **all** teams regardless of `continuingNextSeason`. This needs to be updated to respect the continuation flag. See [Season Rollover Process](./season-rollover-process.md) — Work Item 2.

### WITHDRAWN Teams
Teams with `continuingNextSeason = false` (status `WITHDRAWN`) should **not** be promoted. They remain in the system but are excluded from the rolled-forward season's active roster. The League Admin can review and manually override any team's status after roll-forward if needed.

### Division (AGG) Re-allocation
After roll forward, divisions are re-assigned. U7 divisions from the previous season become U8 divisions. New U7 divisions will be created in Stage 8 once the full picture of new U7 teams is known.

---

## Stage 3: Existing Club — Team Continuation Confirmation

> **Sequence note:** In the revised canonical order this is **Stage 2** (before Roll Forward). The heading numbering will be reconciled in a future doc revision.

**DJFL Dates:** 1 May – 15 May  
**Key Date Slugs:** `team-continuation-opens` / `team-continuation-closes`  
**Action Card:** `teams.continuation` (visible to Club Secretaries only during window)  
**Component Key:** `teams.continuation`  
**See Also:** [CR-20 Team Variation Request & Seasonal Capabilities](./planning/CR-20-Team-Variation-Request-And-Seasonal-Club-Capabilities.md) §5

### Trigger
A **Key Date** opens the "Team Continuation" window on **1 May**. Clubs are notified by email (system-triggered meta-email). The corresponding Action Card becomes visible and actionable on the Club Dashboard with an amber "Action Required" state.

### Club Secretary Action
The Club Secretary clicks the Action Card on their dashboard and sees a checklist of their teams (as carried forward into the new season from Stage 1 clone). For each team, they tick: **"Continuing this season"** or leave unchecked.

**Continuation UI (modal or dedicated page):**
- List of all club's `CURRENT` teams from the new season (cloned in Stage 1)
- Per-team row: Team Name, Age Group (read-only), checkbox "Continuing next season ✓"
- Optional notes field per team (unchecked teams only): reason for withdrawal
- Bulk controls: "Tick All" / "Untick All"
- Final **"Confirm & Submit"** button — saves the response atomically
- Form saves state incrementally (per-team autosave) so partial progress is retained if the session is interrupted
- After submission: form becomes read-only (confirmation view); a "Change Submission" option is available while the window is still open

**Action Card states:**
| Phase | State |
|-------|-------|
| Before opens | Grey, countdown "Opens in X days" |
| Open, no response | Amber border, "Action Required" |
| Open, partial response | Amber, "X of Y teams confirmed" |
| Open, all confirmed | Green, "All teams confirmed ✓" |
| Deadline passed | Grey, locked |

- Teams confirmed as continuing → status remains `CURRENT` in new season
- Teams not confirmed by the deadline → status automatically moves to **`WITHDRAWN`**
- Deadline: **15 May 23:59** (Key Date `team-continuation-closes`)

> **`WITHDRAWN` vs `CANCELLED`:** `WITHDRAWN` is set by the system on the deadline when a club has not confirmed — it represents the club's own omission, not a league action. The League Admin can manually override a team back to `CURRENT` after the deadline in cases where a club forgot to respond. `CANCELLED` is reserved for league-initiated cancellations.

> **Design Note:** The checkbox UI is intentionally simple — no explanation is required at this stage. The league may follow up with clubs that have large numbers of withdrawals.

> **DJFL Context:** The DJFL CSV also lists a **"Club continuation notice" deadline of 31 March**, which appears to be an informal/paper notice prior to the formal system-based confirmation window. The 1–15 May window is the authoritative system window.

### Deadline Automation
On `team-continuation-closes`, the system:
1. Finds all teams where the club has not submitted a continuation response (or submitted but left the team unchecked)
2. Sets those team records to `WITHDRAWN` status in the new season
3. Writes an audit log entry per team
4. Triggers CR-18 email: "Teams not confirmed — marked as withdrawn" to Club Secretary

### League Admin Visibility
The League Admin can see team continuation status per club in a read-only summary panel (Admin → Teams → Continuation tab). It shows:
- Clubs that have fully confirmed (green)
- Clubs with partial responses (amber)
- Clubs with no response (red — outstanding)
- Post-deadline: list of all auto-withdrawn teams, with override option per team

### Email Notifications (planned — CR-18)
- **Opening:** Email to all Club Secretaries when the window opens
- **Reminder:** Email 48 hours before closing date
- **Confirmation:** Email to Club Secretary confirming their selections
- **Admin Alert:** Email to League Admin listing clubs that haven't responded by closing date
- **Auto-withdrawn notification:** Email to Club Secretary when system applies `WITHDRAWN`

---

## Stage 4: Existing Clubs — New Teams & New Under 7s

> **Sequence note:** This stage opens after Roll Forward (Stage 3) has run. New teams are added to the **already-rolled-forward** age groups. For example, if roll forward has moved U7 → U8, new teams should be added to U8 — not a pre-roll U7. Opening this window before roll-forward would cause new teams to be incorrectly promoted.

**DJFL Dates:** 16 May – 31 May *(exclusive window — new clubs cannot apply during this period)*  
**Key Date Slugs:** `team-registration-opens` / `team-registration-closes`  
**Action Card:** `teams.register` — visible to Club Secretaries only; exempt role: League Admin  
**Component Key:** `teams.register`  
**See Also:** [CR-20 §4 Add New Teams Action Card](./planning/CR-20-Team-Variation-Request-And-Seasonal-Club-Capabilities.md)

### Trigger
A **Key Date** opens the "New Team Application" window for existing clubs on **16 May**. The Action Card "Register New Teams" becomes visible and actionable on the Club Dashboard for clubs with the `teams.register` component access. New clubs **cannot** submit applications during this window.

### Club Secretary Action
The Club Secretary clicks the **"Register New Teams"** Action Card on their dashboard. This opens a direct "Add New Team" modal (not the My Teams navigation page):

**Add New Team modal fields:**
| Field | Required | Notes |
|-------|----------|-------|
| Age Group | ✅ | Dropdown — restricted to groups where club has fewer than 3 teams |
| Team Name | ✅ | Club's naming choice |
| Manager Name | Optional | Clearly provisional |
| Manager Email | Optional | Clearly provisional |
| Manager Phone | Optional | Clearly provisional |

On submit: team created with `status: PENDING`, `teamNumber` assigned immediately.  
Success toast: "Team submitted for league approval."

The Action Card displays a badge after first submission: "2 teams pending approval" — giving the club visibility of their own queue.

### Action Card States

| Phase | Card State |
|-------|-----------|
| Before `team-registration-opens` | Grey, countdown "Opens in X days" |
| Window open | Green, "Available now" |
| Window open, pending teams exist | Green, badge "X pending" |
| After `team-registration-closes` | Grey, locked — "Closed" |
| League Admin (exempt) | Always actionable |

### Constraints
- Maximum 3 teams per age group per club (existing `CURRENT` + pending `PENDING` combined)
- Applications are processed in the order they are received
- Capacity limits per age group are checked **at approval time**, not at submission time (existing teams from other clubs may still be cancelling)

---

## Stage 5: New Club Applications

**DJFL Dates:** 1 June – 1 August  
**Key Date Slugs:** `club-registration-opens` / `club-registration-closes`  
**Timing System:** Pattern A (Public Form) — the public registration form is gated by `TimedFormWrapper`, which checks the Key Dates via `getFormTiming`. Before 1 June, a countdown is shown. After 1 August, a "Registration closed" message is shown. See [Unified Timing Architecture](./unified-timing-architecture.md).

> **Important:** The new club window (1 June – 1 August) opens on the same date as the formal FA season start (1 June). It does **not** overlap with the existing clubs' exclusive window (16–31 May). Sequencing is preserved.

### Trigger
The **New Club Registration** window opens on **1 June**, after the exclusive existing-club window (16–31 May) has closed. This sequencing ensures existing clubs have first refusal on available capacity before new clubs are considered.

New clubs apply via the **public registration form** (no login required). The order of consideration is the order of application submission — there is no early-bird advantage beyond position in the queue.

### New Club Application — Multi-Step Form

The public form at `/register/club?org=<league-slug>` guides the applicant through the following steps:

#### Step 1: Select Season
The applicant selects the season they wish to register for.

#### Step 2: Club Details
| Field | Required | Notes |
|-------|----------|-------|
| Club Name | ✅ | Must be unique within the season |
| Short Name | ✅ | Used in tables and fixture schedules |
| FA Number | Optional | Validation reference only |

#### Step 3: Primary Contact (Club Secretary)
| Field | Required | Notes |
|-------|----------|-------|
| Full Name | ✅ | Becomes the Club Secretary account name |
| Email Address | ✅ | Receives verification email; becomes login email |
| Phone Number | ✅ | Contact for league use |

> The primary contact will be provisioned as the Club Secretary user account upon club approval.

#### Step 4: Team Registration Requests
The applicant selects which age groups they wish to enter and how many teams in each. 

| Constraint | Value |
|-----------|-------|
| Maximum teams per age group | **3** |
| Minimum teams (total, to submit) | **1** |
| Capacity enforcement at this stage | **None** — checked at approval time |

The applicant specifies counts only at this step (e.g., "3 × U9, 2 × U10"). Individual team naming happens after email verification.

#### Step 5: Review & Submit
Summary of all entered information. Applicant clicks **Submit Application**.

On submission:
- Application record created with status `PENDING`
- Email verification link sent to the contact email address

### Email Verification

The applicant receives an email containing a unique link. Clicking the link:
1. Verifies the email address
2. Updates application status to `EMAIL_VERIFIED`  
3. **Immediately presents the Team Naming form** (see below)

> If the applicant does not complete team naming in the same session, the team naming form is accessible via a link in the verification email, which remains valid until the application is actioned.

---

## Stage 6: Team Edit Window & Final Withdrawals

**DJFL Dates:**
- Edit window: **1 June – 15 August** ("General Teams: Latest date to withdraw / add team")
- Minimum player registration: **By 10 August** ("Team CRUD Ends")

**Key Date Slugs:** `team-edit-opens` / `team-edit-closes`  
**Action Card:** `teams.edit` — visible to all clubs (existing and newly approved) with the `teams.edit` component access; exempt: League Admin

### Purpose
This window allows all clubs to make final adjustments to their team registrations:

1. **Add teams** — last opportunity to register additional teams (any age group)
2. **Withdraw teams** — clubs can remove teams they no longer intend to field
3. **Edit team details** — name changes, manager updates, etc.

### Deadline
The window closes on **15 August**. After this date, no further team add/withdraw operations are possible for the season. The `teams.edit` Action Card is greyed out with "Closed" badge.

> **Note:** The 10 August "minimum players" deadline is an FA FullTime obligation (player registration on the FA system), not an LMSPro action. LMSPro should surface this as a reminder via the dashboard banner countdown.

---

## New Club — Team Naming Form

### Purpose
After verifying their email, the applicant names each team they have requested. This gives each team an identity and triggers assignment of its 5-digit sequential **Team Number** (`teamNumber`).

### Team Naming Flow
For each team slot declared in Step 4 (e.g., 3 × U9 means three separate forms), the applicant provides:

| Field | Required | Notes |
|-------|----------|-------|
| Team Name | ✅ | e.g., "Riverside U9 Blues" — club's choice |
| Manager Name | Optional | Clearly labelled as non-binding at this stage |
| Manager Email | Optional | Clearly labelled as non-binding at this stage |
| Manager Phone | Optional | Clearly labelled as non-binding at this stage |

> **Label guidance:** All optional manager fields carry the description:  
> *"Optional — you are not committing to this manager yet. You can update this after the club is approved."*

### Team Status on Creation
All teams named at this stage are created with status **`AWAITING_CLUB_APPROVAL`**.

This status means:
- The team has been declared by the applicant
- The club application has not yet been approved by the league
- The team cannot be acted upon by the league until the club application is decided

### Team Number Assignment
Each named team is immediately assigned a **5-digit sequential Team Number** at the point of creation (e.g., `00042`). This number is:
- Unique per organisation
- Persistent — it never changes, even across seasons
- Zero-padded for display; stored as a plain integer

---

## New Club Application — Status Transitions

```
Submitted by applicant
        │
        ▼
   PENDING ──────────────────────────── Email not yet verified
        │
        │ (applicant clicks email link)
        ▼
  EMAIL_VERIFIED ────────────────────── Ready for team naming + league review
        │
        │ (league decision)
        ├──────────────────────────────► APPROVED ──► Club created
        │                                              Teams: AWAITING_CLUB_APPROVAL
        │                                                   → NEW_CLUB_PENDING_TEAM
        │
        └──────────────────────────────► REJECTED ──► Application closed
```

---

## Team Status — Full Reference

| Status | Set By | Meaning |
|--------|--------|---------|
| `AWAITING_CLUB_APPROVAL` | System (on team naming) | Team named; parent club application not yet approved |
| `NEW_CLUB_PENDING_TEAM` | System (on club approval) | Club approved; team awaiting league team decision |
| `PENDING` | System / Club Secretary | New team from an **existing** club, awaiting league approval |
| `CURRENT` | League Admin (approval) | Active team, counts toward division capacity |
| `WAITING_LIST` | League Admin | Team accepted in principle but capacity full; placed in queue |
| `CANCELLED` | League Admin / Club Secretary | Team registration cancelled |
| `SUSPENDED` | League Admin | Team suspended (disciplinary or administrative) |

### Priority at Approval Stage

When the League Admin reviews pending teams, the following prioritisation applies:

1. **`NEW_CLUB_PENDING_TEAM`** — considered **after** existing club pending teams
2. **`PENDING`** (existing clubs) — considered **first**, in order of submission

This sequencing reflects the policy that existing clubs have priority over new entrants. The system surfaces this clearly in the approval UI.

---

## Club-Initiated Team Changes: Team Variation Request

> **Full specification:** [CR-20 Team Variation Request & Seasonal Capabilities](./planning/CR-20-Team-Variation-Request-And-Seasonal-Club-Capabilities.md)

Once a team has been approved (`CURRENT` status), clubs **cannot directly edit** the team record for fields that affect league integrity (team name, age group, division). However, clubs retain the right to:

1. **Edit team manager details directly** (self-service, no approval): `managerName`, `managerEmail`, `managerPhone` — updated immediately via the My Teams modal.

2. **Submit a Team Variation Request** for everything else:
   - Team name change
   - Withdrawal from the season
   - Reinstatement after withdrawal
   - Other / general request

**Process:**
- Club Secretary opens a team from My Teams → scrolls to "Request a Change" section
- Selects request type, fills current/requested values, adds notes
- System checks: only one active (`PENDING`) request per team at a time
- League Admin reviews all variation requests in the **Approvals → Team Variations** tab (same panel as Free Days and Club Applications)
- On approval: change is applied automatically to the team record (for name changes and withdrawals)
- On rejection: request closes, club is notified

**This is the canonical path for all club-initiated changes to approved teams.** It ensures all changes have an audit trail and the league retains control of the team register.

---

## Stage 7: League Team Approval

**DJFL Timing:** Runs concurrently with and immediately after the edit window (August), before Season Start (1st Sunday September).  
**Key Date Slugs:** `team-approval-opens` / `team-approval-closes`  
**Type:** Window (Pattern B — League Admin dashboard only)  
**Exempt Roles:** N/A — this panel is always visible to League Admins regardless of Key Date

> The `team-approval-opens` and `team-approval-closes` Key Dates do not gate the League Admin's access to the panel (admins are always exempt). They are used to: (a) drive email reminders to the League Admin that the approval window has opened, and (b) inform the dashboard banner countdown for League Admins.

### Overview
The League Admin reviews all pending teams using the **Team Approval panel**, which mirrors the bulk-action framework used for the Special Free Days approval workflow:

- Teams are grouped by club
- Each club's teams are shown in an accordion panel
- A bulk action bar with checkbox selection allows:
  - **Approve All** (→ `CURRENT`)
  - **Waiting List All** (→ `WAITING_LIST`)
  - **Cancel All** (→ `CANCELLED`)
- Individual decisions can be made per team by clicking the row

### Club-Level Decision (New Club Applications)

When a **new club application** is approved:

| Action | Club Outcome | Team Outcome |
|--------|-------------|--------------|
| **Approve Application** | Club status → `APPROVED` | All `AWAITING_CLUB_APPROVAL` teams → `NEW_CLUB_PENDING_TEAM` |
| **Waiting List Application** | Club status → `WAITING_LIST` | All `AWAITING_CLUB_APPROVAL` teams → `NEW_CLUB_PENDING_TEAM` (still pending league decision) |
| **Reject Application** | Club application → `REJECTED` | All `AWAITING_CLUB_APPROVAL` teams → `CANCELLED` |

> **Propagation rule:** Any change to the club application status propagates atomically to all associated teams.

### Team-Level Decision

Once a club has been approved (or waiting-listed), the League Admin makes individual or bulk decisions on each `NEW_CLUB_PENDING_TEAM` or `PENDING` team:

| Decision | Result |
|----------|--------|
| **Approve** | `CURRENT` — team is active in the season |
| **Waiting List** | `WAITING_LIST` — team is in the queue; will be promoted if space opens |
| **Cancel** | `CANCELLED` — team will not participate |

### Email Notifications (planned — per CR-18)
- **Club Application Approved:** Email to Club Secretary with login instructions
- **Club Application Rejected:** Email to Club Secretary with reason
- **Club on Waiting List:** Email to Club Secretary explaining position
- **Team Approved:** Email to Club Secretary (and optionally team manager)
- **Team on Waiting List:** Email to Club Secretary
- **Team Promoted from Waiting List:** Email to Club Secretary when space opens

---

## Stage 8: Division Formation

### Trigger
After the approval window closes (August), the League Admin initiates division formation for new age groups (primarily U7), before the season start (1st Sunday in September).

### Process
1. **Count confirmed U7 teams** — all teams with status `CURRENT` in the U7 age group
2. **Calculate number of divisions required** — based on team count and the league's preferred division size
3. **Create new U7 divisions (AGGs)** — named (e.g., "U7 Division A", "U7 Division B")
4. **Allocate teams to divisions** — either manually (drag-and-drop) or via suggested allocation (balanced by geography or application order)

> **Future enhancement:** Automated balanced allocation using postcode/geography data from the club application.

---

## Key Dates Reference

**All dates are stored as `LMSProKeyDate` records scoped to `seasonId`.** The League Admin configures every date in the Season → Key Dates page. There are no hardcoded calendar dates in the system — everything queries Key Dates at runtime.

Key Date **slugs** are the standard names recognised by the Unified Timing System to auto-link forms, Action Cards, email triggers, and banner reminders. See [Unified Timing Architecture](./unified-timing-architecture.md) for the full slug registry.

> **Season Scoping:** Every Key Date record has a `seasonId` field. When a season is cloned, all Key Dates are copied to the new season with dates shifted forward by 12 months as a starting point. The League Admin then adjusts them as needed for the new season. This ensures the system is fully configurable year-on-year without any code changes.

### DJFL 2026 Dates — Mapped to LMSPro Key Dates

| DJFL Date | Event | Key Date Slug | Pattern | Stage | Who Notified |
|-----------|-------|--------------|---------|-------|--------------|
| 1 March | Player transfer deadline (FA FullTime) | — | N/A | Pre-season | — |
| 1 March | Return of all trophies | — | N/A | Pre-season | Club |
| 31 March | Club continuation notice (informal) | — | N/A | Pre-season | Club |
| 1 April | Player re-registration opens (FA FullTime) | — | N/A | Pre-season | — |
| 30 April | Officer nominations deadline | — | N/A | Pre-season | League |
| 1 May | Proposed rule changes deadline | — | N/A | Pre-season | Club |
| **1 May** | **Team Continuation Window Opens** | `team-continuation-opens` | B (Action Card) | Stage 3 | All Club Secretaries |
| **15 May** | **Team Continuation Window Closes** | `team-continuation-closes` | B (Action Card) | Stage 3 | Clubs not yet responded |
| **16 May** | **Existing Club New Team Window Opens** | `team-registration-opens` | B (Action Card) | Stage 4 | All Club Secretaries |
| **31 May** | **Existing Club New Team Window Closes** | `team-registration-closes` | B (Action Card) | Stage 4 | — |
| 31 May | End of financial year | — | N/A | — | League |
| **1 June** | **New Club Registration Opens** | `club-registration-opens` | A (Public Form) | Stage 5 | (public — countdown) |
| 1 June | Season Start (FA) | — | N/A | — | — |
| 1 June | Online player registration opens (FA FullTime) | — | N/A | — | — |
| **1 June** | **Team Edit Window Opens** | `team-edit-opens` | B (Action Card) | Stage 6 | All Club Secretaries |
| End of July | AGM (no later than) | — | N/A | — | League |
| **1 August** | **New Club Registration Closes** | `club-registration-closes` | A (Public Form) | Stage 5 | — |
| 10 August | Minimum player registration deadline (FA FullTime) | — | N/A | — | Reminder only |
| **15 August** | **Team Edit Window Closes** | `team-edit-closes` | B (Action Card) | Stage 6 | All Club Secretaries |
| 1st Sunday September | Playing season starts | — | N/A | Season Start | — |
| Last Sunday April | End of playing season | — | N/A | Season End | — |
| 31 May | Season end (FA) | — | N/A | Season End | — |

### Reminder Key Dates (Banner Only — No Form or Card Gating)

Dates marked as type `Reminder` in the table above are stored as Key Dates in LMSPro like any other, but they do **not** gate a form or Action Card. Instead they:
- Appear as countdown items in the **dashboard header banner** for the relevant audience (Club Secretary, League Admin, or both)
- Can trigger **email notifications** if configured in CR-18 email rules
- Are **fully configurable** by the League Admin — they can adjust the date each season or remove the reminder entirely

Even though some of these dates (e.g., player registration) are governed by FA FullTime externally, LMSPro stores them as Key Dates so the League Admin can surface timely reminders to club users through the familiar dashboard interface without relying on clubs to check external systems.

### Key Date Slug Standard Registry

All slugs below are recognised by the Unified Timing System. They are seeded per-season when a season is created or cloned. The League Admin configures the actual dates. Standard slugs enable the system to auto-link Action Cards, forms, banners, and email triggers without any code changes.

**Window slugs** (gate a form or Action Card):

| Slug | Type | Controls | Audience |
|------|------|----------|----------|
| `team-continuation-opens` | Window | `teams.continuation` Action Card | Club Secretary |
| `team-continuation-closes` | Window | `teams.continuation` Action Card | Club Secretary |
| `team-registration-opens` | Window | `teams.register` Action Card | Club Secretary |
| `team-registration-closes` | Window | `teams.register` Action Card | Club Secretary |
| `club-registration-opens` | Window | Public club registration form (Pattern A) | Public |
| `club-registration-closes` | Window | Public club registration form (Pattern A) | Public |
| `team-edit-opens` | Window | `teams.edit` Action Card | Club Secretary |
| `team-edit-closes` | Window | `teams.edit` Action Card | Club Secretary |
| `team-approval-opens` | Window | Team approval admin panel banner/email | League Admin |
| `team-approval-closes` | Window | Team approval admin panel banner/email | League Admin |

**Trigger slugs** (point-in-time, email + banner):

| Slug | Type | Controls | Audience |
|------|------|----------|----------|
| `season-start` | Trigger | Season start email + banner | All clubs |
| `playing-season-start` | Trigger | Playing season start email + banner | All clubs |
| `season-end` | Trigger | Season end email + banner | All clubs |

**Reminder slugs** (banner countdown only, no gating):

| Slug | Type | Banner Label | Audience |
|------|------|-------------|----------|
| `player-transfer-deadline` | Reminder | Player transfer deadline | Club |
| `trophies-return` | Reminder | Trophies return deadline | Club |
| `continuation-notice` | Reminder | Club continuation notice due | Club |
| `player-rereg-opens` | Reminder | Player re-registration opens | Club |
| `officer-nominations` | Reminder | Officer nominations deadline | League |
| `rules-submission` | Reminder | Rule changes submission deadline | Club |
| `financial-year-end` | Reminder | End of financial year | League |
| `player-registration-opens` | Reminder | Online player registration opens | Club |
| `agm-deadline` | Reminder | AGM deadline | League |
| `player-registration-deadline` | Reminder | Min. players registered by | Club |

---

## Data Model Summary

### `LMSProClubApplication`
Key fields relevant to this workflow:

| Field | Type | Notes |
|-------|------|-------|
| `status` | `ClubApplicationStatus` | `PENDING` → `EMAIL_VERIFIED` → `APPROVED` / `REJECTED` |
| `teamRequests` | `Json` | Array of `{ageGroupId, teamCount}` — the declared team counts |
| `createdClubId` | `String?` | Set on approval; links to the created `LMSProClub` |

### `LMSProTeam`
Key fields relevant to this workflow:

| Field | Type | Notes |
|-------|------|-------|
| `teamNumber` | `Int` | Unique per org, sequential, assigned at creation |
| `status` | `TeamStatus` | See status table above |
| `applicationId` | `String?` | *(planned)* Links team back to the originating club application |

### `ClubApplicationStatus` Enum

```
PENDING           — Submitted, email not yet verified
EMAIL_VERIFIED    — Email verified, teams named, ready for league review
APPROVED          — Club approved, club record created
REJECTED          — Application rejected
```

### `TeamStatus` Enum (Complete)

```
AWAITING_CLUB_APPROVAL  — Team named; club application not yet decided
NEW_CLUB_PENDING_TEAM   — Club approved; team awaiting league decision
PENDING                 — New team from existing club; awaiting league decision
CURRENT                 — Active team
WAITING_LIST            — Accepted in principle; queued pending capacity
CANCELLED               — Not participating
SUSPENDED               — Temporarily inactive (disciplinary/admin)
```

### `ClubStatus` Enum (Complete)

```
PENDING         — Initial registration (new clubs awaiting approval)
APPROVED        — Active club in current season
WAITING_LIST    — Club accepted in principle; capacity pending
SUSPENDED       — Temporarily inactive
WITHDRAWN       — Permanently withdrawn from season
```

---

## Implementation Phases

### Phase 1 — Schema & Enum Changes *(current sprint)*
- Add `AWAITING_CLUB_APPROVAL` and `NEW_CLUB_PENDING_TEAM` to `TeamStatus` enum
- Add `WAITING_LIST` to `ClubStatus` enum
- Add `applicationId` to `LMSProTeam` (links team back to its originating application)
- Add `managerPhone` to `LMSProTeam` (missing from current schema — required for team manager self-service)
- Add `LMSProTeamVariationRequest` model (see [CR-20](./planning/CR-20-Team-Variation-Request-And-Seasonal-Club-Capabilities.md) §8)
- Add `TeamVariationRequestType` and `TeamVariationRequestStatus` enums
- Migration file

### Phase 2 — Public Form: Max 3 Per Age Group + Team Naming
- Change `max={10}` → `max={3}` on the team count inputs
- After email verification, present the Team Naming form
- Create `LMSProTeam` records with `AWAITING_CLUB_APPROVAL` and assign `teamNumber`
- Verification email link leads to combined verify + name-teams page

### Phase 3 — Club Application Approval: Status Propagation
- Update `approve` mutation: on approval, transition all club's `AWAITING_CLUB_APPROVAL` teams → `NEW_CLUB_PENDING_TEAM`
- Add `WAITING_LIST` as a new club application outcome (creates club as `WAITING_LIST`, propagates teams)
- Update `reject` mutation: cancel all `AWAITING_CLUB_APPROVAL` teams atomically

### Phase 4 — Team Approval Panel (Free Days Framework)
- New `ClubApplicationsTeamsPanel` component using accordion + checkbox bulk action bar
- Grouped by club, with `NEW_CLUB_PENDING_TEAM` and `PENDING` tabs/sections
- Bulk: Approve / Waiting List / Cancel
- Individual: row click → modal with single-team decision
- Prioritisation: existing club `PENDING` shown first

### Phase 5 — Key Dates & Timing System Integration
- Seed standard Key Date slugs: `team-continuation-opens/closes`, `team-registration-opens/closes`, `team-edit-opens/closes`
- Update `LMSPRO_FORMS` registry with `team-registration` and `team-edit` entries (Pattern B support)
- Link Action Cards to Key Dates via Visibility Rules for: `teams.continuation`, `teams.register`, `teams.edit`
- Add exempt roles (League Admin bypasses all time gates)
- Season Clone: extend `duplicateToSeason` to copy Visibility Rules (per unified-timing-architecture Phase 3)
- Dashboard banner: show upcoming Team Registration, Team Edit, New Club Registration countdowns

### Phase 6 — Team Variation Request (per CR-20)
- tRPC router: `teamVariationRequests` — create, cancel, list, approve, reject, bulk
- Club My Teams modal: editable manager fields (direct save) + "Request a Change" section
- Admin Approvals panel: new "Team Variations" tab (accordion by club, bulk actions)
- Auto-apply logic on approval: name change + withdrawal status transition
- CR-18 email sequences: request received, approved, rejected notifications

### Phase 7 — Action Cards: Add New Teams + Team Continuation (per CR-20)
- `teams.register` Action Card → "Add New Team" modal, key-date gated
- `teams.continuation` Action Card → continuation checklist modal, key-date gated
- Deadline automation: auto-`WITHDRAWN` for unchecked teams at `team-continuation-closes`
- Club Dashboard `ClubActionCards` refactor: two-section layout (seasonal + always-on)
- Component card states: open / closing soon / upcoming / closed / always-on

### Phase 8 — Email Notifications *(planned, per CR-18)*
- Club application received confirmation
- Email verification link
- Team naming confirmation
- Club approval / rejection / waiting list
- Team approval / waiting list / promotion
- Season lifecycle notifications: Team Continuation window open, New Team window open, reminders
- Team Variation Request: received, approved, rejected, auto-withdrawn

### Phase 9 — Season Lifecycle UI *(future)*
- Season Clone button with Visibility Rules copy
- Blank season creation UI (for bootstrap / first-time leagues)
- Import workflow wired into season preparation banner
- Division Roll Forward updated to respect `continuingNextSeason` flag
- Enforce UI ordering: continuation window must close before roll-forward is enabled
- Post-roll-forward AGG management UI (review, reassign, create new youngest-group divisions)
- Waiting List promotion queue
- Dashboard banner: DJFL dates including non-LMSPro reminders (FA FullTime deadlines)

> See [Season Rollover Process](./season-rollover-process.md) for the full work item list and implementation detail.

---

## Open Questions & Design Decisions

| # | Question | Status | Decision |
|---|----------|--------|----------|
| 1 | Should capacity be checked when a club names their teams? | Resolved | **No** — checked at approval time only. Existing teams may cancel before then. |
| 2 | Can the league name teams on behalf of a new club during review? | Deferred | Possible in future; applicant names teams for now. |
| 3 | Does Waiting List position persist across seasons? | Open | TBD |
| 4 | Should team manager details on the application propagate to the created team record? | Resolved | **Yes** — populated from application, clearly labelled as provisional |
| 5 | What happens to a team's `WAITING_LIST` position if the club withdraws mid-season? | Open | TBD |
| 6 | Should the Season Clone include age group capacity values or reset them? | Open | TBD — likely reset to 0 (unconstrained) pending new season planning |
| 7 | How should Division Roll Forward handle cross-age-group AGGs? | Open | TBD — may require manual intervention |
| 8 | What is the exact status for a team whose club does NOT confirm continuation in Stage 3? `WITHDRAWN` or `CANCELLED`? | **Resolved** | **`WITHDRAWN`** — implies the club's own choice, not a league action. Editable by League Admin after the deadline in case of withdrawal by omission (club forgot to respond). |
| 9 | Should LMSPro surface FA FullTime deadline reminders (e.g., 10 Aug player registration) in the dashboard banner, even though they are not LMSPro actions? | **Resolved** | **Yes** — all dates stored as Key Dates. FA FullTime dates stored as type `Reminder` — appear in banner, no form/card gating. Fully configurable by League Admin. |
| 10 | The DJFL CSV lists a "Club continuation notice" on 31 March (paper/informal) and the system window opens 1 May. Should the system send a reminder email on/around 31 March prompting clubs to prepare? | **Resolved** | **Yes** — store `continuation-notice` as a Reminder Key Date (31 March). Attach an `EmailSequence` (anchored to OPEN, `delayDays: 0`) targeting All Club Secretaries. The same Key Date can own multiple sequence steps: e.g. `-3d` advance notice, `0d` reminder on the day. Reuses existing `EmailSequence` processor — no new model needed. See [Key Dates Reference](./key-dates-reference.md). |
| 11 | Stage 5 (new club window) opens on 1 June — same day as FA Season Start. Does the league want the public form live from midnight or from a specific time on 1 June? | **Resolved** | **Specific time** — `activeFromTime` (HH:MM) is always stored and combined with `activeFrom` at runtime. Time of day is critical for race-condition windows. Suggested default: `09:00`. League Admin sets this on the Key Date page. |
| 12 | Should new clubs who apply before 1 August but are not yet actioned by 1 August remain visible in the admin approval queue after the window closes? | **Resolved** | **Yes** — `club-registration-closes` closes the public form only. The admin approval queue is not date-gated. All `EMAIL_VERIFIED` applications remain in the queue until actioned by the League Admin. |
| 13 | The team edit window (`team-edit-closes`, 15 August) — should this apply to the `teams.register` Action Card too (preventing any team additions after 15 August), or are add and edit controlled by separate Key Dates? | **Resolved** | **Single date controls both** — `team-edit-closes` (15 August) closes both `teams.edit` and `teams.register` cards. DJFL uses one date for "add or withdraw". Both cards are linked to the same closing Key Date via VisibilityRules. |

---

*This document should be updated as design decisions are made and implementation progresses. It is the single source of truth for the team registration and approval workflow.*
