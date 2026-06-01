# IsoStack — Timezone & Date Handling: End-to-End Test Plan

**Version:** 1.1  
**Date:** 29 May 2026  
**Author:** IsoStack Engineering  
**Audience:** QA, Client, Internal Testers  
**Related doc:** `docs/core/timezone-handling.md`

**v1.1 changes:** Section 3 updated — ClubRegistrationCard removed from product; replaced with tests for WINDOW key date architecture, `showCountdown` toggle, form gate URL display, and multi-step registration form validation.

---

## Overview

This test plan covers all timezone-sensitive behaviour across LMSPro and Pulse. Dates are **critical** to the operation of the live league system — incorrect timezone handling can cause registration windows to open/close at the wrong time, task deadlines to appear wrong, and suspensions to start on the wrong day.

All tests should be carried out with the organisation's **Display Timezone set to `Europe/London`** (the default). The UK is currently in **BST (British Summer Time, UTC+1)** from late March to late October, which is when issues are most likely to surface.

---

## Test Setup

### Before You Begin

1. Log in as an **OWNER** account (e.g. `owner@acme.com`)
2. Go to **Settings → Branding**
3. Confirm "Display Timezone" is set to `Europe/London`
4. Note the current time in BST (your local time if in the UK, otherwise check a world clock for London)

### Accounts Needed

| Role | Email | Purpose |
|---|---|---|
| Owner | `owner@acme.com` | Admin functions, season management |
| Admin | `admin@acme.com` | Most LMSPro/Pulse tasks |
| Member/Club | `member@acme.com` | Club-facing forms, free day requests |

### Notation

- ✅ = Pass (behaviour correct)
- ❌ = Fail (record issue with screenshot)
- ⏭️ = Skipped (feature not available in this environment)
- **BST** = British Summer Time (UTC+1), current UK time during summer
- **UTC** = Universal Coordinated Time (always 1 hour behind BST in summer)

---

## Section 1 — Season Dates (LMSPro)

### 1.1 Season List — Date Display

**Where:** LMSPro → Seasons

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 1.1.1 | Open the Seasons list | `startDate` and `endDate` columns show dates in `dd MMM yyyy` format (e.g. "01 Aug 2025") | |
| 1.1.2 | Check a season with `startDate = 2025-08-01` | Shows "01 Aug 2025" — not "31 Jul 2025" or "02 Aug 2025" | |
| 1.1.3 | Check the lock date tooltip (hover the padlock icon if present) | Shows the correct calendar date — not one day off | |

---

### 1.2 Season Edit Form

**Where:** LMSPro → Seasons → click a season → Overview tab

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 1.2.1 | Open a season for editing | `startDate` and `endDate` date pickers are pre-filled with the correct dates | |
| 1.2.2 | Change `startDate` to 1 September using the picker | After saving, the list shows "01 Sep" — not "31 Aug" | |
| 1.2.3 | Change `endDate` to 31 May 2026 using the picker | After saving, shows "31 May 2026" | |
| 1.2.4 | Set `Free Day Window Open` to a specific date | Saved correctly — re-open form and same date appears | |
| 1.2.5 | Set `Free Day Window Close` to a specific date | Saved correctly — re-open form and same date appears | |

---

### 1.3 Make-Current Safety Catch (Unlock Date)

**Where:** LMSPro → Seasons → [Season in IN_PREPARATION status] → Overview tab

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 1.3.1 | Find a season with a "Make Current" lock date set | The badge reads "Locked until DD MMM YYYY" with the correct date | |
| 1.3.2 | Click "Change date" and pick a new date using the DateInput | After saving, the lock badge updates to the new date — no day shift | |
| 1.3.3 | Verify in DB (Prisma Studio) | `makeCurrentUnlocksAt` is stored at `T00:00:00.000Z` (UTC midnight) | |

---

### 1.4 Roll-Forward Safety Catch

**Where:** LMSPro → Seasons → [Active current season] → Overview tab (Owner only)

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 1.4.1 | Check the Roll-Forward Safety Catch section | If set, shows "Roll-forward is locked until DD MMM YYYY" with correct date | |
| 1.4.2 | Click "Change date" and set a new date | Lock date updates correctly with no day shift | |
| 1.4.3 | Click "Remove lock" | Section shows "Set lock date" button; no lock date displayed | |

---

## Section 2 — Key Dates & Registration Windows (CRITICAL)

> ⚠️ This is the highest-risk area. A 1-hour error here causes registration windows to open/close at the wrong time for clubs.

### 2.1 Key Date Display

**Where:** LMSPro → Seasons → [Season] → Key Dates tab

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 2.1.1 | Open the Key Dates tab | Dates show in `dd MMM yyyy` format | |
| 2.1.2 | Check the `From Time` and `To Time` columns | Times shown with timezone label (e.g. "09:00 BST" not "08:00 UTC") | |

---

### 2.2 Creating a Key Date (BST Critical Test)

**Where:** LMSPro → Seasons → [Season] → Key Dates tab → Add Key Date

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 2.2.1 | Create a key date with `From Time = 09:00` and `To Time = 17:00` (during BST) | Form label shows "BST" next to the time inputs | |
| 2.2.2 | Save the key date | Success notification shown | |
| 2.2.3 | Re-open the key date for editing | `From Time` shows "09:00 BST" (same as you entered) — **not** "10:00 BST" | |
| 2.2.4 | Verify in Prisma Studio / DB | `activeFromTime` is stored as `"08:00"` (UTC, 1 hour behind BST) | |
| 2.2.5 | Verify in Prisma Studio / DB | `activeToTime` is stored as `"16:00"` (UTC) | |

---

### 2.3 Registration Window — Club View

**Where:** The public club registration embed (or LMSPro → Clubs → Registration)

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 2.3.1 | View the club registration embed during an active window | The "opens at" / "closes at" time shown is in BST (e.g. "Opens at 9:00 BST") | |
| 2.3.2 | Check the `SystemClosedScreen` (if outside window) | Displays the closing time in BST — not UTC | |
| 2.3.3 | Wait until the exact BST open time and refresh | The form becomes accessible at the correct BST time | |

---

### 2.4 Key Date Window Check (Logic Test)

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 2.4.1 | Set a key date window that opened 5 minutes ago (BST) | `isWithinKeyDateWindow` returns true — club form is accessible | |
| 2.4.2 | Set a key date window that closes in 5 minutes (BST) | Form is still accessible; closes at the right BST time | |
| 2.4.3 | Set a key date window that closed 5 minutes ago (BST) | Form shows "window closed" — not still open | |

---

## Section 3 — Key Date WINDOW Architecture & New Features

> ℹ️ The ClubRegistrationCard has been removed. Registration timing is now managed entirely through the Key Dates tab using a single `WINDOW` type key date record per form. All tests below apply to any WINDOW key date (club-registration, team-registration, etc.).

### 3.1 WINDOW Key Date — Admin CRUD

**Where:** LMSPro → Seasons → [Season] → Key Dates tab

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 3.1.1 | Open the Key Dates tab on a season that has club registration configured | A single `club-registration` key date entry exists — NOT separate `club-registration-opens` / `club-registration-closes` records | |
| 3.1.2 | Click the `club-registration` row to open the edit modal | Modal opens with `From Date`, `From Time`, `To Date`, `To Time` fields all pre-filled correctly | |
| 3.1.3 | Check `From Time` and `To Time` labels | Both show timezone abbreviation (e.g. "BST") | |
| 3.1.4 | Change `From Time` to `09:00 BST` and save | Re-open: shows "09:00 BST" — not "08:00" or "10:00" | |
| 3.1.5 | Verify in DB (Prisma Studio) | `activeFromTime` stored as `"08:00"` (UTC); `activeToTime` 1hr behind displayed value | |

---

### 3.2 Show Countdown Toggle

**Where:** LMSPro → Seasons → [Season] → Key Dates tab → edit any WINDOW key date

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 3.2.1 | Open edit modal for a WINDOW key date | "Show countdown timer on public form" switch is visible under the Form gate settings section | |
| 3.2.2 | Toggle the switch OFF and save | Switch stays OFF when modal is re-opened | |
| 3.2.3 | Navigate to the public embed URL for that form (e.g. `/embed/register/club?org=<slug>`) when the window hasn't opened yet | With countdown OFF: form shows a plain "Registration Opens Soon" message with no animated countdown timer | |
| 3.2.4 | Toggle the switch back ON and save | Public embed now shows the day/hour/minute/second countdown blocks | |
| 3.2.5 | Verify in DB | `show_countdown` column is `false` when toggled off, `true` when on | |

---

### 3.3 Form Gate URL Display

**Where:** LMSPro → Seasons → [Season] → Key Dates tab → expand accordion for a form-gated key date

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 3.3.1 | Expand the accordion row for the `club-registration` key date | A read-only URL field appears showing the full embed URL (e.g. `https://app.example.com/embed/register/club?org=<your-org-slug>`) | |
| 3.3.2 | Click the copy button (clipboard icon) next to the URL | URL is copied to clipboard; button briefly shows a green tick | |
| 3.3.3 | Click the external link icon next to the URL | Opens the embed URL in a new tab | |
| 3.3.4 | Verify the URL contains your org's correct slug | URL uses `?org=<your-slug>` — not a hardcoded value | |
| 3.3.5 | Expand the accordion for a non-form-gated key date (e.g. a generic DEADLINE type) | No URL field appears | |

---

### 3.4 Multi-Step Club Registration Form — Next Button Validation

**Where:** `/embed/register/club?org=<slug>` (public embed, window must be open)

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 3.4.1 | Open the form at step 1 (Season selection) | Next button is **greyed out** / disabled | |
| 3.4.2 | Select a season from the dropdown | Next button becomes **enabled** | |
| 3.4.3 | Proceed to step 2 (Club Details) — leave both fields blank | Next button is disabled | |
| 3.4.4 | Enter a club name (≥ 2 chars) but leave Short Name blank | Next button stays disabled | |
| 3.4.5 | Fill in both Club Name and Short Name | Next button becomes enabled | |
| 3.4.6 | Proceed to step 3 (Contact) — leave all fields blank | Next button is disabled | |
| 3.4.7 | Enter name and phone but leave email blank | Next button stays disabled | |
| 3.4.8 | Enter an invalid email (e.g. `notanemail`) | Next button stays disabled | |
| 3.4.9 | Enter a valid email, name ≥ 2 chars, phone ≥ 6 chars | Next button becomes enabled | |
| 3.4.10 | Proceed to step 4 (Officers) — leave all optional fields blank | Next button is **enabled** (officers are optional) | |
| 3.4.11 | Enter an invalid email in the Treasurer email field | Next button becomes disabled | |
| 3.4.12 | Fix or clear the treasurer email | Next button re-enables | |
| 3.4.13 | Proceed to step 5 (Teams) — do not select any age groups | Next button is disabled | |
| 3.4.14 | Check a checkbox for at least one age group (count ≥ 1) | Next button becomes enabled | |
| 3.4.15 | Proceed to step 6 (Review) | Submit button is always visible (no further validation gate) | |

---

## Section 4 — Free Days

**Where:** LMSPro → Clubs → [Club] → Free Days tab, or team-facing free day request form

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 4.1 | Submit a free day request for "14 June 2026" | Stored date is `2026-06-14T00:00:00.000Z` in DB | |
| 4.2 | View the free day in the admin list | Shows "14 Jun 2026" — not "13 Jun 2026" | |
| 4.3 | Test free day window open validation (if window set) | Error message "Window opens DD MMM YYYY" uses correct date format | |
| 4.4 | Test free day window close validation | Error message "The window closed DD MMM YYYY" uses correct date format | |

---

## Section 5 — Suspensions & Disciplinary Records

**Where:** LMSPro → Suspend Management card (dashboard), or Clubs → [Club] → Disciplinary tab

### 5.1 Imposing a Suspension

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 5.1.1 | Impose a suspension with `Start Date = today` | Suspension starts on today's date — not yesterday or tomorrow | |
| 5.1.2 | Set `End Date` using the calendar picker to a specific date | End date saves correctly — re-open form and same date shown | |
| 5.1.3 | Verify in DB | `startDate` stored as `T00:00:00.000Z` (UTC midnight) | |
| 5.1.4 | View the suspension in the table | "Suspension Period" column shows correct start and end dates | |
| 5.1.5 | Auto-calculated end date display | "Suspension will end on: DD MMM YYYY" shows correct date | |

---

### 5.2 Disciplinary Records in Club Detail

**Where:** LMSPro → Clubs → [Club] → Disciplinary tab

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 5.2.1 | View existing disciplinary records | `Start` and `End` columns show `dd MMM yyyy` format | |
| 5.2.2 | Check a record with `startDate = 2026-06-01` | Shows "01 Jun 2026" — not "31 May 2026" | |

---

## Section 6 — Announcements

**Where:** LMSPro → Communications → Announcements tab

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 6.1 | Create an announcement with `Expiry Date = 30 June 2026` | After saving, expiry shows "30 Jun 2026" | |
| 6.2 | Re-open the announcement for editing | Expiry date picker is pre-filled with 30 June — not 29 June or 1 July | |
| 6.3 | Verify in DB | `expiresAt` stored as `2026-06-30T00:00:00.000Z` | |

---

## Section 7 — Communications (Sent Emails)

**Where:** LMSPro → Communications → Sent tab / Email detail panel

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 7.1 | Send a test email | In the sent list, `sentAt` shows in BST (e.g. "29 May 2026 14:30") | |
| 7.2 | Open the email detail panel | `Sent` field shows date/time in BST — not UTC | |
| 7.3 | Check the Recipients table | Each recipient's `sentAt` shows in BST | |

---

## Section 8 — Team Approval

**Where:** LMSPro → Team Approval

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 8.1 | View pending team registrations | "Registered" timestamp shows in BST with correct format | |
| 8.2 | Open a team for review | "Registered" date in the detail panel shows in BST | |

---

## Section 9 — Pulse: Tasks

**Where:** Pulse → Tasks

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 9.1 | Create a task with `Due At = 10 June 2026, 09:00` | Saved successfully | |
| 9.2 | Verify in DB | `dueAt` stored as `2026-06-10T08:00:00.000Z` (UTC, 1hr behind BST) | |
| 9.3 | Re-open the task for editing | `Due At` picker shows "10 Jun 2026, 09:00" — **not** "08:00" | |
| 9.4 | View task in the table | Due date column shows "10 Jun 2026" | |
| 9.5 | Create a task with `Due At = 10 June 2026, 00:30 BST` | Verify no day-shift: stored as `2026-06-09T23:30:00.000Z` — picker reloads as "00:30" on 10 June | |

---

## Section 10 — Pulse: Leads

**Where:** Pulse → Leads

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 10.1 | Create/edit a lead with `Next Action At = 15 June 2026, 14:00` | Saved successfully | |
| 10.2 | Verify in DB | `nextActionAt` stored as `2026-06-15T13:00:00.000Z` (UTC) | |
| 10.3 | Re-open the lead | `Next Action At` picker shows "15 Jun 2026, 14:00" — not "13:00" | |

---

## Section 11 — Pulse: Time Tracking

**Where:** Pulse → Time

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 11.1 | Log a time entry `Start = 09:00 BST, End = 11:30 BST` on 1 June 2026 | Saved successfully | |
| 11.2 | Verify in DB | `startAt = 2026-06-01T08:00:00.000Z`, `endAt = 2026-06-01T10:30:00.000Z` | |
| 11.3 | Re-open entry for editing | Start shows "09:00", End shows "11:30" — not 08:00/10:30 | |
| 11.4 | View in the time table | Date column shows "01 Jun 2026"; time range shows "09:00 – 11:30" | |
| 11.5 | Try to set end time before start time | Validation error shown — "End time must be after start time" | |

---

## Section 12 — Pulse: Projects

**Where:** Pulse → Projects

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 12.1 | Create a project with `Start Date = 1 July 2026` and `Target End = 31 December 2026` | Saved successfully | |
| 12.2 | Verify in DB | Both stored as `T00:00:00.000Z` (UTC midnight) | |
| 12.3 | Re-open project | Date pickers show 1 Jul and 31 Dec — not 30 Jun / 30 Dec | |
| 12.4 | View in project list | `Target End` column shows "31 Dec 2026" | |

---

## Section 13 — Pulse: Pipeline

**Where:** Pulse → Pipeline

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 13.1 | View a lead card with a `Next Action At` date | Date shown in `dd MMM yyyy` format on the card | |
| 13.2 | Open lead detail panel | `Next Action At` shows full date + time in BST | |

---

## Section 14 — Pulse: Organisations, Notes, Documents, Quotes

**Where:** Pulse → Organisations / Notes / Documents / Quotes

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 14.1 | View organisations list | `createdAt` (or similar) date column shows `dd MMM yyyy` format | |
| 14.2 | View notes list | `Created` date shows correctly — no day shift | |
| 14.3 | View documents list | Upload date shows correctly | |
| 14.4 | View quotes list | Quote date shows correctly | |

---

## Section 15 — Pulse: Dashboard

**Where:** Pulse → Dashboard (main page)

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 15.1 | View the Pulse dashboard | Today's date header shows correct day in BST (e.g. "Friday, 29 May 2026") | |
| 15.2 | View upcoming tasks section | Task due dates shown in `dd MMM yyyy` format | |

---

## Section 16 — Timezone Setting

**Where:** Settings → Branding

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 16.1 | Change Display Timezone to `America/New_York` | Save succeeds | |
| 16.2 | Navigate to Pulse → Tasks | Dates now display in US Eastern time (UTC-4 in summer) | |
| 16.3 | Re-open a task created earlier (BST: 09:00) | Picker now shows "05:00" (New York time) — same UTC moment | |
| 16.4 | Change timezone back to `Europe/London` | All dates revert to BST display | |

---

## Section 17 — Edge Cases

### 17.1 Midnight Boundary (Day-Shift Risk)

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 17.1.1 | Create a season starting 1 August | Shows "01 Aug" — not "31 Jul" | |
| 17.1.2 | Create a key date on 1 September | Shows "01 Sep" — not "31 Aug" | |
| 17.1.3 | Create a Pulse task due at 00:30 BST on 10 June | Task shows due date as "10 Jun" — not "09 Jun" | |

### 17.2 BST/GMT Transition (Clock Change)

> Note: The UK clock changes on the last Sunday of March (GMT→BST) and last Sunday of October (BST→GMT). If possible, test the following:

| # | Action | Expected Result | Pass/Fail |
|---|---|---|---|
| 17.2.1 | A key date window set to open at "09:00 BST" in summer | During winter (GMT), it would appear as "09:00 GMT" — 1hr earlier UTC. This is expected behaviour — the stored UTC value changes with the seasons. | |
| 17.2.2 | A season `startDate` set to 30 March 2026 (clock-change day) | Shows "30 Mar 2026" — not "29 Mar" | |

---

## Defect Reporting

If you find an issue, please record the following:

| Field | Detail |
|---|---|
| **Test #** | e.g. 2.2.3 |
| **Description** | What you expected vs what you saw |
| **Browser** | Chrome/Safari/Firefox + version |
| **Screenshot** | Attach if possible |
| **DB value** | Check in Prisma Studio if accessible — note the raw value |
| **Severity** | P0 (data corruption) / P1 (wrong display) / P2 (cosmetic) |

---

## Quick Reference: What "Correct" Looks Like

| Scenario | Correct behaviour |
|---|---|
| Season `startDate = 2025-09-01T00:00:00Z` | Displays as "01 Sep 2025" everywhere |
| Key date `activeFromTime = "08:00"` (UTC) | Displays as "09:00 BST" in summer |
| Pulse task `dueAt = 2026-06-10T08:00:00Z` | Displays as "10 Jun 2026 09:00" (BST); picker pre-fills to 09:00 |
| Free day request for "14 June" | Stored as `2026-06-14T00:00:00Z`; displays as "14 Jun 2026" |
| Announcement `expiresAt` set to 30 June | Stored as `2026-06-30T00:00:00Z`; picker reloads as 30 June |
| Email `sentAt = 2026-05-29T13:00:00Z` | Displays as "29 May 2026 14:00" (BST) |

---

*Cross-reference: `docs/core/timezone-handling.md`*  
*Last updated: 29 May 2026 (v1.1 — key date WINDOW architecture, showCountdown, form gate URL, next button validation)*
