# CR #18: Unified Email System — Statement of Work

**Change Request ID:** `cmjb88krq00044j7l0xv2fr1a`
**Status:** In Progress
**Last Updated:** 4 March 2026
**Prepared By:** GitHub Copilot AI / Chris (Platform Owner)

---

## 1. Overview

CR #18 delivers a unified email system for the IsoStack platform with two distinct entry points:

| Type | Trigger | Audience |
|---|---|---|
| **Key Date Sequences** | Anchored to Key Date open/close events | Clubs, League Admins, custom cohorts |
| **Manual Communications** | Admin-initiated broadcast | Any filtered recipient set |

Both types share the same underlying `Email` + `EmailRecipient` infrastructure and are delivered via the Resend API.

---

## 2. What Has Been Built

### 2.1 Database Schema (Complete ✅)

The following models are live in the `public` schema:

| Model | Purpose |
|---|---|
| `EmailTemplate` | Reusable templates with shortcode hints (org-scoped) |
| `Email` | A single sent or scheduled email (header record) |
| `EmailAttachment` | File attachments linked to an `Email` via R2 |
| `EmailRecipient` | Individual recipient record per `Email` |
| `EmailSequence` | Drip or Key Date–anchored sequence definition |
| `EmailSequenceStep` | One step within a sequence (delay + content + recipient group) |
| `SequenceEnrollment` | Individual enrollment in a drip sequence |

Key enums: `EmailStatus`, `SequenceStatus`, `SequenceTrigger`, `KeyDateSequenceAnchor`, `KeyDateRecipientGroup`.

**`EmailSequenceStep.firedAt`** — Added March 2026. `NULL` = not yet fired. Set when a Key Date–anchored step fires, preventing re-sends.

### 2.2 Key Date–Anchored Email Sequences (Complete ✅)

Sequences can be attached to a `LMSProKeyDate` via `keyDateId` + `keyDateAnchor` (OPEN or CLOSE).

**Router endpoints** (`key-dates.router.ts`):
- `listEmailSequences` — list sequences for a given key date
- `createEmailSequence` — create sequence + first step
- `updateEmailSequence` — update sequence + first step
- `deleteEmailSequence` — delete sequence and all steps

**Admin UI** (Key Dates tab — `KeyDatesTab.tsx`):
- Email Schedule section per key date card
- `EmailStepCrudModal.tsx` — create/edit/delete steps with recipient group selector

**Background Processor** (`scripts/jobs/processors/key-date-sequences.ts`):
- Runs every 5 minutes via Render cron → `npm run jobs:tick`
- Queries `ACTIVE` sequences where `keyDateId IS NOT NULL`
- Loads only unfired steps (`firedAt IS NULL`)
- Computes `fireAt = anchor datetime + delayDays + delayHours`
- Resolves recipients by `recipientGroup`:
  - `ALL_CLUBS` — approved/waiting-list club primary contacts for the season
  - `LEAGUE_ADMINS` — ADMIN + OWNER users for the organisation
  - `CLUBS_NOT_RESPONDED` — clubs without an approved application
  - `CUSTOM` — `customCohortFilter` JSON (supports `{ clubIds }` or `{ emails }`)
- Sends via Resend, creates `Email` audit record, marks `step.firedAt = now`

### 2.3 Enrollment-Based Drip Sequences (Complete ✅)

For non–Key Date sequences (e.g. triggered on club application approval):

**Processor** (`scripts/jobs/processors/sequences.ts`):
- Claims `SequenceEnrollment` records via `FOR UPDATE SKIP LOCKED` row locking
- Processes per-enrollment with exponential backoff (1m, 5m, 15m, 60m)
- Transaction-safe: rolls back on failure
- Stale lock recovery for crashed workers

### 2.4 Season Rollover — `duplicateToSeason` (Complete ✅)

When duplicating key dates to a new season, the following are now all copied:
- Key dates (with `slug` and `keyDateType` preserved)
- Visibility rules (mapped to new key date IDs)
- Email sequences + all steps (mapped to new key date IDs; `firedAt` reset)

New input param: `includeEmailSequences` (default `true`).

### 2.5 Slug-First Key Date Lookup (Complete ✅)

The `LMSPRO_FORMS` registry now defines `openingKeyDateSlug` / `closingKeyDateSlug` per form. The helper `findKeyDateBySlugOrName()` tries slug first, falls back to name. Applied in:

- `getFormTiming` — controls public-facing form timing (club registration widget)
- `getClubRegistrationConfig` — admin summary card
- `updateClubRegistrationConfig` — creates/updates club registration key dates (now stamps slug on auto-created dates)

---

## 3. What Remains to Be Built

### 3.1 Manual Communications UI (Not Started)

League admins need to compose and send ad-hoc emails to filtered cohorts directly from the admin dashboard.

**Scope:**

| Item | Description |
|---|---|
| Email composer modal | Subject, body (Mantine RichTextEditor), CC/BCC, attachments |
| Cohort filter panel | Filter by club status, age group, division, role, etc. |
| Recipient preview | Count + list before sending |
| Send action | Creates `Email` record, queues batch send via Resend |
| Communications archive tab | Read-only history of sent emails, view/copy content |

**Proposed location:** `src/app/(app)/app/lmspro/communications/`

### 3.2 Email Template Management UI (Not Started)

`EmailTemplate` records exist in the database but there is no admin UI to create or manage them.

**Scope:**

| Item | Description |
|---|---|
| Templates tab in LMSPro Settings | DataTable of org-scoped templates |
| Create/Edit modal | Name, category, subject, body (rich text), shortcode hints |
| Shortcode picker | Helper listing available shortcodes |
| Preview pane | Render template with sample data |
| Delete (with usage check) | Block delete if template linked to active sequences |

### 3.3 Automated Meta-Emails (Not Started)

System-triggered notification emails on key platform events (issue created, user invited, etc.) are **not yet wired up**. The `sendMetaEmail` service function and shortcode template engine described in the original planning document have not been built.

**Out of scope for current sprint.** To be scoped separately.

### 3.4 Unsubscribe & Preferences (Future)

No unsubscribe mechanism exists. To be addressed in a future CR once send volumes warrant it.

---

## 4. Architecture

### Email Delivery Flow

```
Key Date event fires
       │
       ▼
processKeyDateSequences() [cron, every 5 min]
       │
       ├─ Resolve recipients (ALL_CLUBS / LEAGUE_ADMINS / CLUBS_NOT_RESPONDED / CUSTOM)
       ├─ Create Email + EmailRecipient records
       ├─ Send via Resend API
       └─ Set step.firedAt = now
```

```
Admin composes broadcast
       │
       ▼
EmailComposerModal → sendCommunicationEmail() [tRPC mutation]
       │
       ├─ Create Email record (status = SENDING)
       ├─ Create EmailRecipient records
       ├─ Send batches via Resend (100/batch, 500ms delay)
       └─ Update Email.status = SENT / PARTIAL / FAILED
```

### Recipient Group Resolution

| Group | Query |
|---|---|
| `ALL_CLUBS` | `LMSProClub` where `seasonId`, `status IN (APPROVED, WAITING_LIST)` → `primaryContact.email` |
| `LEAGUE_ADMINS` | `User` where `organizationId`, `role IN (ADMIN, OWNER)`, `status = ACTIVE` |
| `CLUBS_NOT_RESPONDED` | Clubs in season with no approved `LMSProClubApplication` |
| `CUSTOM` | `customCohortFilter.clubIds[]` or `customCohortFilter.emails[]` |

---

## 5. Technical Constraints

- **Resend rate limit:** 2 API requests/second → batches of 100, 500ms between batches
- **Deduplication:** `EmailSequenceStep.firedAt` prevents re-sending Key Date steps; enrollment-based sequences use `SequenceEnrollment.status`
- **Multi-tenancy:** Every query scoped by `organizationId` — no cross-org data access
- **Audit trail:** Every send creates an `Email` record + per-recipient `EmailRecipient` records
- **No drafts:** Emails send immediately or are scheduled; no draft state for broadcast emails
- **Job runner:** `npm run jobs:tick` → `tsx scripts/jobs/run.ts` — runs both `processSequences` and `processKeyDateSequences`

---

## 6. Key Files

| File | Purpose |
|---|---|
| `prisma/schema.prisma` | `EmailSequence`, `EmailSequenceStep`, `Email`, `EmailRecipient`, `EmailTemplate` models |
| `src/modules/lmspro/routers/key-dates.router.ts` | Email sequence CRUD endpoints + `duplicateToSeason` |
| `src/modules/lmspro/forms/registry.ts` | `LMSPRO_FORMS` with slug fields for timing lookups |
| `src/app/(app)/app/lmspro/seasons/_components/KeyDatesTab.tsx` | Admin UI — Email Schedule section |
| `src/app/(app)/app/lmspro/seasons/_components/EmailStepCrudModal.tsx` | Step create/edit modal |
| `scripts/jobs/run.ts` | Job runner entry point |
| `scripts/jobs/processors/key-date-sequences.ts` | Key Date broadcast processor |
| `scripts/jobs/processors/sequences.ts` | Enrollment-based drip processor |

---

## 7. Migrations Applied

| Migration | Change |
|---|---|
| `20260203102126_add_communications_service` | `Email`, `EmailRecipient`, `EmailTemplate`, `EmailAttachment` models |
| `20260203131639_add_sequence_retry_fields` | Retry fields on `SequenceEnrollment` |
| `20260205082254_add_email_attachments_cc_bcc` | CC/BCC + attachment fields on `Email` |
| `20260303130000_add_key_date_type_email_sequence_anchors_team_status` | `EmailSequence.keyDateId`, `keyDateAnchor`; `KeyDateSequenceAnchor` enum |
| `20260303160000_add_fired_at_to_email_sequence_step` | `EmailSequenceStep.firedAt` for dedup |

---

## 8. Acceptance Criteria (Remaining Work)

### Manual Communications UI
- [ ] Admin can compose an email with subject, rich-text body, optional CC/BCC
- [ ] Admin can filter recipients by club status, role, or custom criteria
- [ ] Recipient count shown before send
- [ ] Send queues background batch (UI returns immediately)
- [ ] Sent email appears in Communications archive
- [ ] Email record + per-recipient records created in database

### Email Template Management UI
- [ ] Admin can create/edit/delete org-scoped `EmailTemplate` records
- [ ] Template can be previewed with sample data
- [ ] Template linked to a sequence step shows usage warning on delete


---

