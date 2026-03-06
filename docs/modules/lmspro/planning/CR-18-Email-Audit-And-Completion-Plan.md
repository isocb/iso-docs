# CR-18 Email System — Full Audit & Completion Plan

**Date:** 5th March 2026  
**Completed:** 6th March 2026  
**Status:** ✅ Fully implemented  
**Prepared by:** Isoblue Platform Team

---

## 1. Executive Summary

CR-18 is fully implemented and closed. All four planned capability pillars are built and working. This document records the original audit findings, the implementation plan that was followed, and the final implementation details. The commit that closed CR-18 is `b19a5e7` on the `dev` branch (6th March 2026).

---

## 2. What Is Built ✅

### 2.1 Core Sending Infrastructure

**Files:** `src/core/services/communications/lib/send-email.ts`, `src/lib/email-branding.ts`

- `sendEmail()` — single email via Resend API, branding applied per org/module
- `sendBatchEmails()` — bulk send with per-recipient shortcode resolution, batching (10/batch, 100ms gap) and full results tracking
- Supports CC, BCC, attachments (base64)
- Fully typed with `SendEmailParams`, `BatchSendParams`, `SendEmailResult`, `BatchSendResult`
- **Calling interface is stable and ready to use from any router**

### 2.2 LMSPro Recipient Provider

**Files:** `src/modules/lmspro/communications/provider.ts`, `cohort-resolver.ts`, `shortcode-resolver.ts`, `shortcodes.ts`, `register.ts`

The LMSPro module has a complete `RecipientProvider` implementation registered as `'lmspro'`:

**Cohort types available:**
| Key | Resolves to |
|---|---|
| `divisions` | Club officials for teams in selected AGGs |
| `ageGroups` | Club officials for teams in selected age groups |
| `clubs` | All officials for selected clubs |
| `leagueRoles` | Users with selected league roles |
| `clubRoles` | Users with selected club roles |
| `referees` | Individual referees by contactDetails email |
| `venues` | Venue contact person |

**Shortcodes defined:**
| Prefix | Fields |
|---|---|
| `club.*` | `fullName`, `shortName`, `faNumber`, `status`, `primaryContact.name/email/phone` |
| `team.*` | `name`, `ageGroup`, `status`, `club.fullName`, `club.shortName` |
| `ageGroup.*` | `code`, `teamCount` |
| `user.*` | `firstName`, `lastName`, `name`, `email` |
| `organization.*` | `name` |
| `season.*` | `name` |

### 2.3 Email Template Management

**Files:** `src/core/services/communications/routers/templates.router.ts`, platform `EmailManagementPanel.tsx`

- `EmailTemplate` model in schema with `name`, `subject`, `bodyHtml`, `bodyText`, `category`, `shortcodeHints`, `isActive`
- Platform-level template management UI exists
- Templates can be selected in ComposeEmailModal via `TemplateSelector`
- Template saving from compose modal is working

### 2.4 Manual Broadcast Email (Compose & Send)

**Files:** `src/core/services/communications/components/ComposeEmailModal.tsx`, `CohortPicker.tsx`, `RecipientList.tsx`, `ShortcodeInserter.tsx`, `EmailPreview.tsx`, `emails.router.ts`

- League admin can compose email, pick cohort, preview recipients
- Shortcode insertion supported
- Send creates `Email` record, `EmailRecipient` records, delivers via Resend batch
- Full audit trail in `Email` + `EmailRecipient` tables
- **User-confirmed: complete and tested ✅**

### 2.5 Communications Archive (Sent History)

**Files:** `src/modules/lmspro/components/dashboard/CommunicationsSentCard.tsx`, `ClubCommunicationsPanel.tsx`, `lmsproCommuncationsRouter`

- League admin view: full sent email history
- Club view: emails sent to their club (filtered by `entityType: 'Club'`)
- `listForClub` procedure in `lmsproCommuncationsRouter`

### 2.6 Key-Date Sequence Emails

**Files:** `src/core/services/communications/routers/sequences.router.ts`, `src/app/(app)/app/lmspro/seasons/_components/EmailStepCrudModal.tsx`, `KeyDatesTab.tsx`

- `EmailSequence` + `EmailSequenceStep` models in schema
- CRUD for sequences and steps
- Key date is the anchor/trigger; steps fire at `anchor + delayDays + delayHours`
- Recipient groups: `ALL_CLUBS`, `LEAGUE_ADMINS`, `CLUBS_NOT_RESPONDED`, `CUSTOM`
- `SequenceTrigger` enum: `MANUAL`, `ON_COHORT_JOIN`, `ON_EVENT`, `SCHEDULED`
- Job processor (`scripts/jobs/processors/sequences.ts`) runs every 5 min
- **User-confirmed: built and functioning ✅**

---

## 3. What Was Missing ✅ (Now Implemented)

### 3.1 Core Event Notification Emails

This was the **only remaining gap for CR-18 closure**. All items below are now implemented in commit `b19a5e7`.

The following mutations exist in LMSPro routers and fire at known state-change moments. All now send email notifications.

#### Event Map

| Event | Router | Mutation | Who Needs Notifying |
|---|---|---|---|
| Free day requested | `freeDaysRouter` | `request` | League admins |
| Free day approved | `freeDaysRouter` | `approve` | Club (team manager / club secretary) |
| Free day rejected | `freeDaysRouter` | `reject` | Club (team manager / club secretary) |
| Free day cancelled | `freeDaysRouter` | `cancel` | Club (has TODO comment) |
| Variation request submitted | `teamVariationRequestsRouter` | `create` | League admins |
| Variation request approved | `teamVariationRequestsRouter` | `approve` | Club |
| Variation request rejected | `teamVariationRequestsRouter` | `reject` | Club |
| Club suspended | `disciplinaryRouter` | `suspendClub` | Club primary contact |
| Team suspended | `disciplinaryRouter` | `suspendTeam` | Club primary contact |
| Suspension lifted | `disciplinaryRouter` | `liftSuspension` | Club primary contact |
| Club application email-verified | `club-applications.router` | `verifyEmail` | League admins (TODO comment exists) |
| Club application approved | `club-applications.router` | `approve` | Applicant/club (TODO comment exists at line 828) |
| Club application rejected | `club-applications.router` | `reject` | Applicant (TODO comment exists at line 1044) |

#### Evidence of original intent (all TODOs now replaced)

The `freeDays` cancel mutation had:
```typescript
// TODO: Send email notification when email system is implemented
// await sendFreeDayCancelledEmail(freeDay.team, updated);
```

The `club-applications` router had TODOs at:
- Line 303: `// TODO: Notify league admins of new verified application`
- Line 828: `// TODO: Send approval email with login instructions to club secretary`
- Line 1044: `// TODO: Send rejection email`

All three TODO comments have been replaced with live `sendEmail()` calls.

---

## 4. Architecture Decision — How to Implement

### Approach: Direct `sendEmail()` calls with inline recipient resolution

The existing `sendBatchEmails()` function in `send-email.ts` is the right tool. We do **not** need a new schema model, a new sequence type, or a job processor. Event notifications are:
- Immediate (fire-and-forget at mutation time)
- Small recipient set (1–few people)
- Not deferred/scheduled

The pattern for each event notification is:
1. After the mutation succeeds, resolve the recipient(s) directly from the data already loaded in the mutation
2. Call `sendEmail()` (single) or `sendBatchEmails()` (multiple)
3. Log to `Email` + `EmailRecipient` tables for audit trail (optional but recommended)
4. Never let email failure block the mutation — wrap in `try/catch`

### Approach for template content

Rather than hardcoding HTML in each router, we use a **lightweight notification template utility** — a single file that defines subject/body for each event key, using the existing shortcode syntax. This:
- Keeps all email content in one place
- Allows future admin override via `EmailTemplate` records (same category tagging)
- Keeps routers clean

### Schema: No changes needed

The existing `sendEmail()` function and `Email`/`EmailRecipient` audit tables are sufficient. We **do not** need a new Prisma model for this.

---

## 5. Implementation Record

### Phase A — Notification template utility ✅

**Created:** `src/modules/lmspro/communications/notification-templates.ts`

Exports `getNotificationTemplate(eventKey, data)` returning `{ subject, bodyHtml, bodyText }`. All email content in one place. Exhaustive TypeScript `never` check ensures a compile error if a key is added to the union but not handled.

**Event keys to define:**

```
lmspro.free_day.requested
lmspro.free_day.approved
lmspro.free_day.rejected
lmspro.free_day.cancelled

lmspro.variation_request.submitted
lmspro.variation_request.approved
lmspro.variation_request.rejected

lmspro.disciplinary.club_suspended
lmspro.disciplinary.team_suspended
lmspro.disciplinary.suspension_lifted

lmspro.club_application.verified   (→ notifies league admins)
lmspro.club_application.approved   (→ notifies applicant)
lmspro.club_application.rejected   (→ notifies applicant)
```

Each template receives a typed `data` object (team name, club name, date, reason etc.) and returns shortcode-substituted HTML.

### Phase B — Shared recipient helper ✅

**Created:** `src/modules/lmspro/communications/notification-recipients.ts`

Reusable functions implemented:
- `getLeagueAdminRecipients(organizationId)` — fetches `ADMIN` + `OWNER` users
- `getClubPrimaryContactRecipient(clubId)` — 3-step fallback: `primaryContact` JSON → primary official user → any official
- `getClubOfficialsRecipients(clubId)` — all club officials

### Phase C — Wire free days notifications ✅

**Edited:** `src/server/core/routers/lmspro/freeDays.router.ts`

`sendEmail()` wired after each state-change mutation:

| Mutation | Add after | Recipients | Template key |
|---|---|---|---|
| `request` | Record created | League admins | `lmspro.free_day.requested` |
| `approve` | Record updated | Club primary contact | `lmspro.free_day.approved` |
| `reject` | Record updated | Club primary contact | `lmspro.free_day.rejected` |
| `cancel` | Record updated (replace TODO) | Club primary contact | `lmspro.free_day.cancelled` |

All wrapped in `try/catch` — email failure does not throw.

### Phase D — Wire variation request notifications ✅

**Edited:** `src/modules/lmspro/routers/team-variation-requests.router.ts`

| Mutation | Add after | Recipients | Template key |
|---|---|---|---|
| `create` | Record created | League admins | `lmspro.variation_request.submitted` |
| `approve` | Transaction completes | Club primary contact | `lmspro.variation_request.approved` |
| `reject` | Record updated | Club primary contact | `lmspro.variation_request.rejected` |

### Phase E — Wire disciplinary notifications ✅

**Edited:** `src/server/core/routers/lmspro/disciplinary.router.ts`

| Mutation | Add after | Recipients | Template key |
|---|---|---|---|
| `suspendClub` | Transaction completes | Club primary contact | `lmspro.disciplinary.club_suspended` |
| `suspendTeam` | Transaction completes | Club primary contact | `lmspro.disciplinary.team_suspended` |
| `liftSuspension` | Transaction completes | Club primary contact | `lmspro.disciplinary.suspension_lifted` |

### Phase F — Wire club application notifications ✅

**Edited:** `src/modules/lmspro/routers/club-applications.router.ts`

All 3 existing TODO comments replaced with live `sendEmail()` calls:

| Mutation | Replace TODO at | Recipients | Template key |
|---|---|---|---|
| `verifyEmail` | Line 303 | League admins | `lmspro.club_application.verified` |
| `approve` | Line 828 | Applicant primary contact email | `lmspro.club_application.approved` |
| `reject` | Line 1044 | Applicant primary contact email | `lmspro.club_application.rejected` |

---

## 6. Delivery Summary

| Phase | File | Status |
|---|---|---|
| A — Notification templates | `notification-templates.ts` (new) | ✅ Complete |
| B — Recipient helpers | `notification-recipients.ts` (new) | ✅ Complete |
| C — Free days | `freeDays.router.ts` | ✅ Complete |
| D — Variation requests | `team-variation-requests.router.ts` | ✅ Complete |
| E — Disciplinary | `disciplinary.router.ts` | ✅ Complete |
| F — Club applications | `club-applications.router.ts` | ✅ Complete |
| **TypeScript check** | all files | ✅ Clean (exit 0) |
| **Git commit** | `dev` branch | ✅ `b19a5e7` pushed |

---

## 7. What We Are NOT Building

The following items were mentioned in the original CR-18 planning doc but are explicitly out of scope for this completion work:

- **Unsubscribe mechanism** — no unsubscribe link in event emails (acceptable until send volumes warrant it; CR-18 §3.4)
- **Admin-configurable event templates** — templates are code-defined (hardcoded HTML with shortcodes) in Phase A. An admin UI to edit event email copy would be a separate enhancement
- **Event email scheduling/delay** — all notifications send immediately
- **Cross-module event notifications** — only LMSPro events in scope

---

## 8. CR-18 Closure Checklist

All implementation items complete. Awaiting end-to-end testing in TechTest.

- [x] Free day requested → league admins receive email
- [x] Free day approved → club contact receives email
- [x] Free day rejected → club contact receives email
- [x] Free day cancelled → club contact receives email
- [x] Variation request submitted → league admins receive email
- [x] Variation request approved → club contact receives email
- [x] Variation request rejected → club contact receives email
- [x] Club/team suspended → club contact receives email
- [x] Suspension lifted → club contact receives email
- [x] Club application verified → league admins receive email
- [x] Club application approved → applicant receives email
- [x] Club application rejected → applicant receives email
- [x] TypeScript passes with no new `any` types introduced
- [ ] Emails tested end-to-end in TechTest

---

## 9. Appendix — Calling Pattern (Reference)

The calling pattern for all event notification emails is:

```typescript
// After mutation succeeds, fire notification (non-blocking)
try {
  const { subject, bodyHtml, bodyText } = getNotificationTemplate(
    'lmspro.free_day.approved',
    {
      teamName: freeDay.team.teamName,
      clubName: freeDay.team.club.fullName,
      requestedDate: freeDay.requestedDate,
      reviewNotes: input.reviewNotes,
      seasonName: freeDay.team.season.name,
    }
  );

  const recipient = await getClubPrimaryContactRecipient(freeDay.team.clubId);

  if (recipient) {
    await sendEmail({
      to: recipient.email,
      toName: recipient.name,
      subject,
      bodyHtml,
      bodyText,
      organizationId: ctx.session!.user.organizationId,
      moduleKey: 'lmspro',
    });
  }
} catch (emailError) {
  // Email failure must NEVER block the mutation
  console.error('[LMSPro] Failed to send free day approval email:', emailError);
}
```

No schema changes. No migration. Just wiring the existing infrastructure.
