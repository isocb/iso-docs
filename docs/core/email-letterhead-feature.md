# Email Letterhead — Feature Design & Build Plan

**Status:** 📋 Ready to Execute  
**Created:** April 2026  
**Scope:** Core platform feature — applies to all modules  
**Builds on:** CR-18 Email System (see `docs/modules/lmspro/planning/CR-18-Email-Notifications-System-Development-Plan.md`)

---

## 1. What This Feature Does

Every outgoing email from any IsoStack module (notifications, sequences, manual comms) is automatically wrapped in a consistent branded layout — a **letterhead** — controlled at two levels:

| Level | Who controls it | Where stored |
|---|---|---|
| **Module default** | P1 (Platform Owner) | `ModuleCatalogue` |
| **Tenant override** | C1 (tenant OWNER role) | `OrganisationModule` |

The tenant override wins if set. Falls back to module default. Falls back to blank if neither is set.

**Two configurable elements per letterhead:**

| Element | Options |
|---|---|
| Logo | Image URL + alignment (LEFT / CENTER / RIGHT) |
| Footer | Rich HTML text (bold, italic, links, inline images) + alignment (LEFT / CENTER / RIGHT) |

The logo defaults to the module's existing `lightLogoUrl` from `ModuleCatalogue` — no new P1 config needed for that. Only the footer text is new at module level.

---

## 2. Architecture Overview

```
sendEmail() / sendBatchEmails()              ← entry point for ALL outgoing emails
    │
    ├── getEmailBranding()                   ← already fetches org + module branding
    │       src/lib/email-branding.ts
    │
    └── applyEmailLetterhead(html, branding) ← NEW: wraps bodyHtml with letterhead
            src/lib/email/letterhead.ts
                │
                ├── Fetches OrganisationModule.emailFooterHtml (tenant override)
                ├── Falls back to ModuleCatalogue.emailDefaultFooterHtml
                ├── Logo from branding.logoUrl (already resolved by getEmailBranding)
                └── Returns: <logo block> + bodyHtml + <footer block>
```

The key principle: **one injection point** in `sendEmail()` — no template changes needed individually.

---

## 3. Codebase Context (Read Before Building)

### 3.1 Key Files

| File | Purpose |
|---|---|
| `src/core/services/communications/lib/send-email.ts` | `sendEmail()` and `sendBatchEmails()` — the two main send functions. **This is where letterhead injection goes.** |
| `src/lib/email-branding.ts` | `getEmailBranding(organizationId, moduleId?)` — already resolves logo, primaryColor, orgName with fallback chain. Called inside `sendEmail()`. |
| `src/server/email/send.ts` | Lower-level send functions (magic link, invitation, welcome, verification, club application). These call Resend directly — **also need wrapping.** |
| `src/server/email/templates/` | React Email templates: `MagicLinkEmail.tsx`, `InvitationEmail.tsx`, `WelcomeEmail.tsx`, `VerificationEmail.tsx`, `IssueStatusChangeEmail.tsx`, `TicketNotificationEmail.tsx`, `ClubApplicationVerificationEmail.tsx`, `PasswordResetEmail.tsx` |
| `src/lib/email.ts` | Higher-level wrappers that call `getEmailBranding()` then render templates. Uses `src/server/email/send.ts`. |
| `prisma/schema.prisma` | `ModuleCatalogue` (line ~628), `OrganisationModule` (line ~675) — new fields go here |
| `scripts/jobs/processors/sequences.ts` | Drip sequence processor — calls Resend directly. **Needs wrapping.** |
| `scripts/jobs/processors/key-date-sequences.ts` | Key date sequence processor — calls Resend directly. **Needs wrapping.** |

### 3.2 Current Send Paths (all need letterhead)

There are **three distinct send paths** currently in the codebase:

**Path A — Communications Service** (`sendEmail` / `sendBatchEmails`)  
Used by: manual email compose modal, cohort emails  
File: `src/core/services/communications/lib/send-email.ts`  
Already calls `getEmailBranding()` ✅ — just add wrapping here

**Path B — Server Actions** (`sendMagicLinkEmail`, `sendInvitationEmail` etc.)  
Used by: auth flows, system notifications  
File: `src/server/email/send.ts` + `src/lib/email.ts`  
Takes `primaryColor` as param but not full branding — needs module context threaded through

**Path C — Job Processors**  
Used by: drip sequences, key date sequences  
Files: `scripts/jobs/processors/sequences.ts`, `scripts/jobs/processors/key-date-sequences.ts`  
Calls `resend.emails.send()` directly with `html: currentStep.bodyHtml` — needs wrapping

### 3.3 Existing Branding Hierarchy (from `getEmailBranding`)

```
1. Org has premium tier + uploaded logo → use org logo + org primaryColor
2. Module has lightLogoUrl → use module logo + module primaryColor  
3. Platform org (isAppOwner: true) has logo → use platform logo
4. Fallback → no logo, #228BE6 blue
```

The letterhead logo follows this same hierarchy — it IS `branding.logoUrl`.

---

## 4. Database Changes

### 4.1 `OrganisationModule` — tenant override fields

```prisma
// Email letterhead — tenant override (C1 controls in Settings → Module → Email)
emailLogoAlign    String?  @default("LEFT") @map("email_logo_align")    // "LEFT" | "CENTER" | "RIGHT"
emailFooterHtml   String?  @db.Text @map("email_footer_html")           // Rich HTML, max ~5KB
emailFooterAlign  String?  @default("LEFT") @map("email_footer_align")  // "LEFT" | "CENTER" | "RIGHT"
```

Note: logo URL comes from `branding.logoUrl` (already resolved) — no separate URL field needed here.

### 4.2 `ModuleCatalogue` — P1 default footer

```prisma
// Email letterhead — module default (P1 sets in Platform → Module config)
emailDefaultFooterHtml String? @db.Text @map("email_default_footer_html")
```

Note: module default logo is already `lightLogoUrl` — no new field needed.

### 4.3 Migration

```bash
npm run db:migrate:dev -- --name add_email_letterhead_fields
```

**Follow the mandatory migration workflow:**
1. Edit `prisma/schema.prisma` with the fields above
2. Run the migrate command
3. Review generated SQL — should be 3 `ALTER TABLE ADD COLUMN` statements, all nullable
4. No data loss risk — all new nullable fields

---

## 5. New File: `src/lib/email/letterhead.ts`

This is the core logic — fetches letterhead config and wraps HTML.

```typescript
/**
 * Email Letterhead
 *
 * Wraps outgoing email HTML with tenant/module branded letterhead.
 * Called from sendEmail() and sendBatchEmails() before sending.
 *
 * Fallback chain:
 *   Tenant override (OrganisationModule) → Module default (ModuleCatalogue) → nothing
 */

import { prisma } from '@/lib/prisma';
import { EmailBranding } from '@/lib/email-branding';

export interface LetterheadConfig {
  logoUrl?: string;
  logoAlign: 'LEFT' | 'CENTER' | 'RIGHT';
  footerHtml?: string;
  footerAlign: 'LEFT' | 'CENTER' | 'RIGHT';
}

const ALIGN_MAP = {
  LEFT: 'left',
  CENTER: 'center',
  RIGHT: 'right',
} as const;

/**
 * Fetch letterhead config for a given org + module combination.
 * Tenant OrganisationModule fields override ModuleCatalogue defaults.
 */
export async function getLetterheadConfig(
  organizationId: string,
  moduleSlug?: string,
  branding?: EmailBranding
): Promise<LetterheadConfig> {
  let logoAlign: 'LEFT' | 'CENTER' | 'RIGHT' = 'LEFT';
  let footerHtml: string | undefined;
  let footerAlign: 'LEFT' | 'CENTER' | 'RIGHT' = 'LEFT';

  if (organizationId && moduleSlug) {
    // Look up OrganisationModule for tenant override
    const orgModule = await prisma.organisationModule.findFirst({
      where: { organizationId, module: { slug: moduleSlug } },
      include: { module: { select: { emailDefaultFooterHtml: true } } },
    });

    if (orgModule) {
      logoAlign = (orgModule.emailLogoAlign as any) ?? 'LEFT';
      footerAlign = (orgModule.emailFooterAlign as any) ?? 'LEFT';
      // Tenant footer wins; fall back to module default
      footerHtml = orgModule.emailFooterHtml ?? orgModule.module.emailDefaultFooterHtml ?? undefined;
    }
  } else if (moduleSlug) {
    // No org context — use module default only
    const module = await prisma.moduleCatalogue.findUnique({
      where: { slug: moduleSlug },
      select: { emailDefaultFooterHtml: true },
    });
    footerHtml = module?.emailDefaultFooterHtml ?? undefined;
  }

  return {
    logoUrl: branding?.logoUrl,
    logoAlign,
    footerHtml,
    footerAlign,
  };
}

/**
 * Wrap email HTML with letterhead (logo header + footer).
 * Safe to call with no config — returns original HTML unchanged if nothing to add.
 */
export function applyLetterhead(bodyHtml: string, config: LetterheadConfig): string {
  const hasLogo = !!config.logoUrl;
  const hasFooter = !!config.footerHtml;

  if (!hasLogo && !hasFooter) return bodyHtml;

  const logoBlock = hasLogo ? `
    <div style="text-align: ${ALIGN_MAP[config.logoAlign]}; padding: 24px 0 16px 0;">
      <img src="${config.logoUrl}" alt="Logo" style="max-height: 48px; max-width: 200px; display: inline-block;" />
    </div>` : '';

  const footerBlock = hasFooter ? `
    <div style="border-top: 1px solid #e9ecef; margin-top: 32px; padding-top: 16px; text-align: ${ALIGN_MAP[config.footerAlign]};">
      <div style="font-size: 12px; color: #868e96; line-height: 1.5;">
        ${config.footerHtml}
      </div>
    </div>` : '';

  return `${logoBlock}${bodyHtml}${footerBlock}`;
}
```

---

## 6. Injection Points

### 6.1 Path A — `sendEmail()` in Communications Service

**File:** `src/core/services/communications/lib/send-email.ts`

Find the section after `getEmailBranding()` is called and before `resend.emails.send()`. Add:

```typescript
// Apply letterhead wrapper
const { getLetterheadConfig, applyLetterhead } = await import('@/lib/email/letterhead');
const letterheadConfig = await getLetterheadConfig(organizationId, moduleKey, branding);
const wrappedHtml = applyLetterhead(bodyHtml, letterheadConfig);

// Then use wrappedHtml instead of bodyHtml in the Resend call
```

Same pattern for `sendBatchEmails()` — apply per-email before sending.

### 6.2 Path B — Server Action templates

**File:** `src/server/email/send.ts`

These functions render React Email templates to HTML then call Resend. After `render()`, before `resend.emails.send()`:

```typescript
const html = await render(MagicLinkEmail({ ... }));

// Add letterhead (needs organizationId + moduleSlug threaded in)
const { getLetterheadConfig, applyLetterhead } = await import('@/lib/email/letterhead');
const letterheadConfig = await getLetterheadConfig(organizationId, moduleSlug);
const wrappedHtml = applyLetterhead(html, letterheadConfig);

return resend.emails.send({ ..., html: wrappedHtml });
```

**Note:** Some of these functions don't currently receive `organizationId` — it will need adding to their params. For auth emails (magic link, verification) where org context may not be available, pass `undefined` — `applyLetterhead` returns unchanged HTML gracefully.

### 6.3 Path C — Job Processors

**File:** `scripts/jobs/processors/sequences.ts` and `key-date-sequences.ts`

Both call `resend.emails.send({ html: step.bodyHtml })`. The sequence already has `organizationId` and `moduleKey` in scope. Add:

```typescript
const { getLetterheadConfig, applyLetterhead } = await import('../../src/lib/email/letterhead');
const letterheadConfig = await getLetterheadConfig(sequence.organizationId, sequence.moduleKey);
const wrappedHtml = applyLetterhead(step.bodyHtml, letterheadConfig);

// Use wrappedHtml in send call
```

---

## 7. Settings UI

### 7.1 Location

**Route:** `src/app/(app)/settings/<module-slug>/page.tsx` — the existing module settings page for C1 tenants.

For LMSPro this is: `src/app/(app)/settings/lmspro/page.tsx`

Add a new **"Email Letterhead"** section/tab within that settings page.

### 7.2 Fields

| Field | Component | Notes |
|---|---|---|
| Logo alignment | `SegmentedControl` with Left/Center/Right | Saves to `emailLogoAlign` |
| Footer text | Tiptap rich text editor (constrained) | Saves to `emailFooterHtml` |
| Footer alignment | `SegmentedControl` with Left/Center/Right | Saves to `emailFooterAlign` |
| Preview | Read-only rendered preview | Shows letterhead around sample text |

**Tiptap constraints** — only allow these extensions to keep email-safe HTML:
- `Bold`, `Italic`, `Link` (with `target="_blank"` forced)
- `Image` (inline only, from R2 — use existing media upload)
- No tables, no arbitrary CSS, no `<div>` structures

### 7.3 tRPC Endpoint

Add to the appropriate settings router (or create `src/server/core/routers/email-letterhead.router.ts`):

```typescript
// GET
getLetterhead: protectedProcedure
  .query(async ({ ctx }) => {
    // Returns OrganisationModule fields for current org + module
  })

// UPDATE  
updateLetterhead: requireRole([Role.OWNER, Role.ADMIN])
  .input(z.object({
    moduleSlug: z.string(),
    emailLogoAlign: z.enum(['LEFT', 'CENTER', 'RIGHT']).optional(),
    emailFooterHtml: z.string().max(10000).optional(),
    emailFooterAlign: z.enum(['LEFT', 'CENTER', 'RIGHT']).optional(),
  }))
  .mutation(async ({ ctx, input }) => {
    // Upsert OrganisationModule fields
    // Audit log: EMAIL_LETTERHEAD_UPDATED
  })
```

### 7.4 P1 Module Default Footer

**Route:** `src/app/(platform)/platform/modules/[id]/page.tsx` or equivalent platform admin module config page.

Add "Email Default Footer" textarea (can be plain Tiptap or raw HTML at P1 level). Saves to `ModuleCatalogue.emailDefaultFooterHtml`.

---

## 8. Build Phases

### Phase 1 — Schema migration (30 min)
1. Add 3 fields to `OrganisationModule` in `prisma/schema.prisma`
2. Add 1 field to `ModuleCatalogue`
3. Run `npm run db:migrate:dev -- --name add_email_letterhead_fields`
4. Verify in Prisma Studio: columns exist, all nullable

### Phase 2 — Core letterhead logic (1 hr)
1. Create `src/lib/email/letterhead.ts` with `getLetterheadConfig()` and `applyLetterhead()`
2. Write unit tests: no config → unchanged HTML; logo only; footer only; both

### Phase 3 — Inject into Path A (1 hr)
1. Edit `src/core/services/communications/lib/send-email.ts`
2. Add letterhead wrapping after `getEmailBranding()` in `sendEmail()`
3. Add same wrapping in `sendBatchEmails()`
4. Test: send a manual email from the UI, verify logo/footer appear

### Phase 4 — Inject into Path C — Job Processors (1 hr)
1. Edit `scripts/jobs/processors/sequences.ts`
2. Edit `scripts/jobs/processors/key-date-sequences.ts`
3. Test: trigger a test sequence step, verify letterhead in received email

### Phase 5 — Inject into Path B — Server Action templates (1 hr)
1. Edit `src/server/email/send.ts` — add `organizationId` + `moduleSlug` params where missing
2. Apply letterhead after `render()` in each function
3. Test: trigger an invitation email, verify letterhead

### Phase 6 — Settings UI (2-3 hrs)
1. Install Tiptap if not already present: `npm install @tiptap/react @tiptap/starter-kit @tiptap/extension-link @tiptap/extension-image`
2. Create `EmailLetterheadSettings` component
3. Add to LMSPro settings page (and any other active module settings pages)
4. Wire to tRPC `updateLetterhead` mutation
5. Add live preview panel
6. Test: update footer in settings, send email, verify footer matches

### Phase 7 — P1 module default footer UI (30 min)
1. Add "Email Default Footer" field to Platform → Module config page
2. Wire to `ModuleCatalogue` update mutation
3. Test: set module default, verify it appears in tenant emails when no override set

---

## 9. Fallback Behaviour Summary

| Scenario | Logo shown | Footer shown |
|---|---|---|
| Tenant has set footer HTML | `branding.logoUrl` (existing hierarchy) | Tenant footer |
| Tenant has no footer; module has default | `branding.logoUrl` | Module default footer |
| Neither set | `branding.logoUrl` (if org has logo) | Nothing |
| No org logo, no module logo | Nothing | Nothing |
| `organizationId` not available (some auth emails) | Nothing | Nothing |

`applyLetterhead()` always returns valid HTML — if both logo and footer are absent it returns the original `bodyHtml` unchanged. Zero risk of breaking existing emails.

---

## 10. Out of Scope

- Per-template letterhead opt-out (all emails get letterhead if configured)
- System/security alert emails (`src/lib/security-alerts.ts` — internal only, no letterhead needed)
- Unsubscribe link injection (separate feature)
- Dark mode email letterhead variants

---

## 11. Related Docs

- `docs/modules/lmspro/planning/CR-18-Email-Notifications-System-Development-Plan.md` — full email system architecture
- `docs/modules/lmspro/planning/CR-18-Email-Audit-And-Completion-Plan.md` — what's built vs planned
- `docs/00-overview/conventions.md` — naming conventions
- `prisma/schema.prisma` lines ~628 (`ModuleCatalogue`), ~675 (`OrganisationModule`)
- `src/lib/email-branding.ts` — existing branding resolution logic
- `src/core/services/communications/lib/send-email.ts` — primary send function
