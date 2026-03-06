# LMSPro Platform Update — CR-18, CR-19 & CR-20

**Prepared for:** League clients  
**Date:** 6th March 2026  
**Status:** ✅ CR-18 complete — CR-19 and CR-20 complete — awaiting testing

---

## Overview

Three recent change requests extend the LMSPro platform with new capabilities for email communications, club access control, and seasonal club workflows. This document summarises what each change delivers in plain terms.

---

## CR-18 — Unified Email System

**What it does**

LMSPro gains a complete, configurable email system covering two distinct needs:

1. **Automated notifications** — system-triggered emails sent when specific events occur (e.g. a free day request is submitted, a disciplinary record is created). Each event type has a named **template** containing a subject line and body text with variable placeholders (e.g. the club name, team name, or user who submitted the action). Templates are defined at platform level and can be edited per league without affecting the platform default.

2. **Broadcast communications** — league administrators can compose and send emails directly to filtered groups of users (e.g. all club secretaries, or all team managers in a particular age group). Sent emails are archived in a Communications log for future reference.

**How automated notifications work**

Each trigger event (e.g. "free day requested") is linked to:

- A **recipient address** — configured by the league administrator in Module Settings → Emails, categorised by event type (e.g. "Free Days", "Disciplinary"). The system checks for a league-specific address first, then falls back to the platform default.
- A **template** — the subject and body of the email, which can include variable shortcodes such as `{{club.name}}`, `{{team.name}}`, or `{{user.name}}`. Leagues can customise the wording of any template.

The trigger itself is a fixed code-level action — when a specific event completes in the system, the corresponding email is sent automatically. Leagues configure *who receives* it and *what it says*, but not *which events fire emails* (that is defined at platform level).

> **Status:** CR-18 is fully implemented and ready for testing. The email infrastructure (templates, recipients, sending engine, logs) is live, and all LMSPro event triggers are wired — including free day requests/approvals/rejections, team variation requests, disciplinary suspensions, and club application notifications.

**Key benefits for leagues**

- No more manual email outside the system for routine notifications
- Consistent, branded communications from a single place
- Full audit trail of every email sent
- Leagues can tailor template wording to their own voice without affecting the platform defaults

---

## CR-19 — Read-Only Role Flag

**What it does**

A new `Read-Only` flag can be applied to any club role in LMSPro. Users with a read-only role see exactly the same dashboard and data as a full club user — but cannot submit forms, make changes, or send requests.

**Why this matters**

Most clubs have one authorised contact (typically the Club Secretary) who is responsible for all official actions. Other committee members, chairpersons, or parents may need visibility into the club's data without the ability to alter it. The read-only flag gives leagues clean control over this distinction.

- Read-only users see all information normally
- All action buttons, edit forms, and submission controls are hidden or disabled for them
- The distinction is enforced at both the UI and API layer — not just cosmetic

---

## CR-20 — Team Variation Requests & Seasonal Club Capabilities

**What it does**

This is the largest of the three changes. It closes several gaps in what club users can do within LMSPro during a season, and introduces a formal process for clubs to request changes to their registered teams.

### 2a — Team Manager Details (Self-Service, No Approval Needed)

Club secretaries can update the **team manager's name, email address, and phone number** directly at any point in the year, without requiring league approval. These fields are editable in the team detail view on the club dashboard and save immediately. Read-only role users (see CR-19) can view but not edit these fields.

### 2b — Team Variation Requests

For everything beyond manager contact details, once teams are approved by the league, clubs cannot change them directly — this protects the integrity of the registration. However, legitimate changes do arise mid-season. CR-20 introduces a structured **change request** process:

Club secretaries can raise a request for any of the following:

| Request type | Description |
|---|---|
| Name change | Correct or update the team name |
| Age group change | Move a team to a different age group |
| Withdrawal | Remove the team from the current season |
| Reinstatement | Re-enter a previously withdrawn team |
| Other | General query or change not covered above |

Requests are submitted through the team detail view on the club dashboard. The league sees all pending requests in a new **Team Variations** panel (alongside Free Days and Special Free Days) and can approve or reject them individually or in bulk. Approved name changes and withdrawals are applied automatically.

### 2c — Team Continuation (Seasonal)

During the team continuation window (typically May, before the new season begins), clubs are shown a **Team Continuation** action card on their dashboard. Clicking it opens a checklist of all their current teams, where the secretary can confirm which are continuing into the next season. Each tick saves immediately — there is no separate submit step.

- A progress indicator shows how many teams have been confirmed
- A "Confirm All" shortcut ticks all teams at once
- A "Withdraw All" option (with a confirmation step) marks all teams as withdrawing
- Teams not yet responded to are shown clearly as "No response"

### 2d — Seasonal Action Cards on the Club Dashboard

The club dashboard now includes a **Seasonal Actions** section that surfaces time-sensitive tasks at the right moment. Action cards appear, change colour, and become clickable based on configured Key Dates — giving clubs a clear signal of what they need to do *right now*.

| State | How it looks |
|---|---|
| Upcoming | Grey card, "Opens in X days" |
| Open | Coloured card, actionable |
| Closing soon | Amber border, urgency signal |
| Closed | Faded card, locked |

Initially this section includes **Team Continuation** (key-date gated) and **Request a Change** (always visible during a season).

---

## Summary

| CR | Feature | Who benefits | Status |
|---|---|---|---|
| CR-18 | Unified email notifications + broadcast communications | League admins, all users | ✅ Implemented |
| CR-19 | Read-only role flag for club users | Leagues, clubs | ✅ Implemented |
| CR-20 | Team change requests, continuation workflow, seasonal action cards | Clubs, league admins | ✅ Implemented |

These changes are implemented and ready for testing. No configuration changes are required from leagues unless you wish to customise email templates (CR-18) or define new read-only roles (CR-19).
