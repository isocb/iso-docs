# SeasonPro — Functional Benefits Summary

## What is SeasonPro?

SeasonPro is the league administration module within the IsoStack platform. It gives league administrators a single place to run an entire season — from initial setup through club registration, team entry, age group management, and season close — while giving clubs a self-service portal that removes the need for chasing emails and paper forms.

---

## Season Management

- A **season** is the central container for all league activity. It defines the registration window, the age groups in play, divisions, and the clubs and teams that participate.
- Seasons can be set up from scratch or **cloned from a prior season** (see Season Transition below).
- Each season has configurable **open/close dates** — registration activity is automatically gated on these dates, so the league never needs to manually open or close forms.
- Leagues can run **multiple concurrent seasons** (e.g. a summer cup alongside the main winter league) without data crossover.

---

## Club Self-Management

- Registered clubs get their own **club portal** — a scoped view of their own data where they can manage their details, contacts, and team entries without seeing any other club's information.
- Clubs can update contact information, upload documents, and submit registration forms **without emailing the league administrator**.
- The league sets the rules; the club fills in the data. League admins review and approve — or reject with notes — rather than manually re-keying information.
- Club users have a clearly defined role boundary: they can only see and act on their own club and its teams.

---

## Key Dates & Timed Application Forms

- **Key Dates** are named milestones attached to a season — e.g. "Registration Deadline", "Appeal Window Opens", "Team Sheet Submission Due".
- Each key date has a precise **datetime**, optional open/close window, and can trigger **automated email sequences** when the date is reached.
- Email sequences fire at a configured offset before or after the key date (e.g. "7 days before", "1 day after") — fully automated, no manual sending required.
- If a key date changes, **all associated email sequence steps automatically re-arm** — there is no risk of emails firing against a stale date.
- Individual email steps that have already fired can be **reset and re-sent** if needed, giving admins precise control without editing the sequence definition.

---

## Component Gating

- UI components throughout the platform can be **gated on key dates** — forms, buttons, and sections appear or become active only within the configured window.
- This means a registration form is simply unavailable outside the registration window — no confusing "closed" messages need to be written; the interface handles it automatically.
- Gating applies equally to the league admin UI and the club portal, so both sides of the platform respect the same schedule.

---

## User Experience — League Admins

- A single dashboard view of every club's registration status: submitted, pending, approved, rejected.
- Bulk actions reduce repetitive admin: bulk approve, bulk email, bulk reject with notes.
- Audit trail on every significant action — who did what and when — satisfying FA governance and data retention requirements.
- Notifications and email sequences reduce the need to manually chase clubs; the platform does the reminding.

## User Experience — Club Users

- Clean, focused portal showing only what is relevant to their club and the current season.
- Step-by-step guided submission flows rather than blank forms — clubs know exactly what is required and what is still outstanding.
- Instant status feedback: submitted items show their approval status without needing to contact the league.
- Automated email reminders mean clubs are nudged about upcoming deadlines without the league needing to send manual chase emails.

---

## Team Management

- Teams are managed within clubs and linked to both an **age group** and a **division**.
- Age groups follow standard English FA year-group conventions (U7–U18) and are configured at the season level — only the age groups active in that season appear.
- Teams can be promoted, relegated, or moved between divisions by the league admin without creating a new team record.
- Club admins can submit **new team entries** for the season via the portal; the league reviews and allocates to a division.
- Team contact details are tracked separately from club contacts, supporting different managers per team.

---

## Division & Age Group Management

- **Divisions** are structured within age groups, allowing multi-tier leagues (Premier, Division 1, Division 2, etc.) per age group.
- Divisions and age groups are scoped to a season — changing the structure for a new season does not affect historical seasons.
- League admins can reorder, rename, and restructure divisions between seasons without any data migration.
- Team counts per division are visible at a glance, making it easy to balance groups before the season starts.

---

## Season Transition — Clone, Roll-Forward & Continuation

This is one of SeasonPro's most powerful time-saving features.

### Clone
- A new season can be **cloned from any prior season** with a single action.
- The clone copies: season structure, age groups, divisions, clubs, teams, key dates, and email sequence definitions.
- All **operational state is reset**: registration statuses, approval states, `firedAt` timestamps on email steps, and any carry-over data that should not persist.
- The league gets a clean season scaffold in seconds rather than rebuilding from scratch.

### Roll-Forward
- Club and team records from the prior season are carried into the new season as **"pending re-registration"** — existing participants do not lose their history, but must actively confirm participation for the new season.
- This prompts clubs to review and update their details (contacts, team names, age group moves) at the natural renewal point rather than carrying stale data silently.
- Teams that move up an age group (e.g. a U12 squad becoming a U13 squad) can be updated in the re-registration flow.

### Automated Sequence Re-Arm
- Because key date email sequences **reset on clone**, all communication automation is ready to fire on the new season's schedule immediately — no manual reconfiguration of reminder emails.

---

## Summary of Key Value Propositions

| Area | What it replaces |
|---|---|
| Season setup | Spreadsheets, manual folder creation |
| Club registration | Email chains, PDF forms, manual data entry |
| Key date reminders | Manual chase emails, calendar reminders |
| Team entry & division allocation | Separate spreadsheets per age group |
| Season rollover | Starting from scratch each year |
| Club portal | Clubs emailing the league for status updates |
| Audit trail | "Who told us what?" spreadsheet logs |
