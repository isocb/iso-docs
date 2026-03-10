# CR: Impersonation — Option A Full Refactor Plan
**Status:** Planned — NOT started  
**Created:** 9 March 2026  
**Author:** AI / Architecture review  
**Depends on:** Impersonation foundation (committed, deployed to techtest — safe for non-P1 users)

---

## Background

The IsoStack platform requires P1 (Platform Admin / isocb) to be able to impersonate any tenant user for testing purposes. The impersonation foundation has been built:

- `impersonation_context` HTTP-only cookie stores `impersonatedUserId` + `impersonatedOrganizationId`
- `context.ts` reads this cookie at tRPC request time and exposes `ctx.effectiveUserId` / `ctx.effectiveOrgId`
- Routing, module switching, and sign-out cookie cleanup are all working correctly

**The remaining problem:** Every router procedure still reads `ctx.session!.user.id` and `ctx.session!.user.organizationId` directly for data scoping, access control, and audit logging. These always refer to P1's identity, not the impersonated user. This means P1 sees P1's data (empty, because P1 has no LMSPro roles) rather than the impersonated user's data.

The two values serve **different purposes** and must never be conflated:

| Value | Meaning | When to use |
|---|---|---|
| `ctx.session!.user.id` | The real authenticated user (always P1 when impersonating) | Audit logs, `createdBy`, `reviewedBy`, `requestedBy` — who actually performed the action |
| `ctx.effectiveUserId` | The user being represented (impersonated user when active) | Data lookups, role checks, access gates, tenant scoping — whose data to show |
| `ctx.session!.user.organizationId` | P1's organisation (IsoStack) | Never use for tenant data scoping |
| `ctx.effectiveOrgId` | The impersonated user's organisation | All tenant-scoped queries |

---

## Scope

### Files requiring changes

**63 router files total.** Broken down by domain:

#### LMSPro module routers (`src/modules/lmspro/routers/`) — 20 files

| File | `ctx.session` references | Priority |
|---|---|---|
| `components.router.ts` | 18 | 🔴 CRITICAL — blocks all dashboard tiles |
| `clubs.router.ts` | 18 | 🔴 CRITICAL — "no access to club" error |
| `key-dates.router.ts` | 41 | 🔴 HIGH — season page broken |
| `team-variation-requests.router.ts` | 28 | HIGH |
| `workflow-templates.router.ts` | 29 | HIGH |
| `roles.router.ts` | 24 | HIGH |
| `age-groups.router.ts` | 23 | HIGH |
| `teams.router.ts` | 22 | HIGH |
| `seasons.router.ts` | 17 | HIGH |
| `visibility-rules.router.ts` | 16 | HIGH |
| `users.router.ts` | 16 | HIGH |
| `club-applications.router.ts` | 16 | HIGH |
| `referees.router.ts` | 14 | MEDIUM |
| `club-officials.router.ts` | 13 | MEDIUM |
| `venues.router.ts` | 11 | MEDIUM |
| `notification-settings.router.ts` | 7 | MEDIUM |
| `key-date-confirmations.router.ts` | 7 | MEDIUM |
| `announcements.router.ts` | 7 | MEDIUM |
| `communications.router.ts` | 2 | MEDIUM |
| `user-context.router.ts` | 3 | ✅ Already fixed |

#### Core platform routers (`src/server/core/routers/`) — 26 files

| File | `ctx.session` references | Priority |
|---|---|---|
| `users.router.ts` | 37 | HIGH |
| `support.router.ts` | 35 | MEDIUM |
| `modules.router.ts` | 32 | ✅ Already fixed |
| `lmspro/freeDays.router.ts` | 29 | HIGH |
| `branding.router.ts` | 22 | LOW — P1 impersonation doesn't need branding ops |
| `features.router.ts` | 20 | MEDIUM |
| `api-keys.router.ts` | 18 | LOW — P1 wouldn't manage API keys as impersonated user |
| `tooltips.router.ts` | 17 | MEDIUM |
| `organizations.router.ts` | 17 | MEDIUM |
| `lmspro/clubNotes.router.ts` | 17 | HIGH |
| `lmspro/disciplinary.router.ts` | 13 | HIGH |
| `lmspro/specialFreeDays.router.ts` | 10 | HIGH |
| `platformEmails.router.ts` | 10 | LOW — platform admin only |
| `domain.router.ts` | 10 | LOW |
| `products.router.ts` | 14 | LOW — platform admin only |
| `settings.router.ts` | 9 | MEDIUM |
| `platform-orgs.router.ts` | 9 | LOW — platform admin only |
| `webauthn.router.ts` | 11 | LOW — auth flows, not data |
| `videos.router.ts` | 7 | MEDIUM |
| `two-factor.router.ts` | 7 | LOW — auth flows |
| `security.router.ts` | 7 | LOW — auth flows |
| `media.router.ts` | 7 | MEDIUM |
| `encryption.router.ts` | 7 | LOW — crypto ops |
| `module-catalogue.router.ts` | 4 | LOW |
| `issues.router.ts` | 4 | MEDIUM |
| `impersonation.router.ts` | 2 | ⚠️ Must stay as `session.user.id` — this IS the auth router |
| `devices.router.ts` | 3 | LOW |
| `auth.router.ts` | 2 | ⚠️ Must stay as `session.user.id` |

#### Pulse module routers (`src/modules/pulse/routers/`) — 13 files

| File | `ctx.session` references | Priority |
|---|---|---|
| `time.router.ts` | 16 | MEDIUM |
| `timer.router.ts` | 15 | MEDIUM |
| `projects.router.ts` | 12 | MEDIUM |
| `quotes.router.ts` | 10 | MEDIUM |
| `tasks.router.ts` | 7 | MEDIUM |
| `settings.router.ts` | 8 | MEDIUM |
| `organisations.router.ts` | 6 | MEDIUM |
| `notes.router.ts` | 6 | MEDIUM |
| `leads.router.ts` | 6 | MEDIUM |
| `documents.router.ts` | 5 | MEDIUM |
| `contacts.router.ts` | 5 | MEDIUM |
| `reports.router.ts` | 4 | MEDIUM |
| `search.router.ts` | 1 | LOW |

---

## The Decision Every Call Site Requires

For **every single** `ctx.session!.user.id` usage in every router, the developer must answer:

**"Is this recording WHO DID THE ACTION, or is this SCOPING WHAT DATA TO SHOW?"**

- **Scoping data / checking access** → replace with `ctx.effectiveUserId` / `ctx.effectiveOrgId`
- **Recording the actor** (audit logs, `createdBy`, `requestedBy`, `reviewedBy`, `submittedBy`) → keep as `ctx.session!.user.id`

This decision cannot be automated. It requires reading every call site.

---

## Approach

### Step 1: Introduce named aliases in `protectedProcedure` (`src/server/core/trpc.ts`)

Add explicit named aliases to the context that `protectedProcedure` exposes, so every router gets
them without any changes to `context.ts`:

```typescript
// In trpc.ts — update protectedProcedure middleware
export const protectedProcedure = t.procedure.use(async ({ ctx, next }) => {
  if (!ctx.session?.user) {
    throw new TRPCError({ code: "UNAUTHORIZED" });
  }
  return next({
    ctx: {
      ...ctx,
      // actorUserId / actorOrgId — the REAL authenticated user (P1 when impersonating)
      // Use these for: audit logs, createdBy, requestedBy, reviewedBy, submittedBy
      actorUserId: ctx.session.user.id,
      actorOrgId: ctx.session.user.organizationId,
      // effectiveUserId / effectiveOrgId are already set in context.ts
      // Use these for: data lookups, role checks, access gates, tenant scoping
    }
  });
});
```

With `actorUserId` explicitly named, the intent is self-documenting at every call site.

### Step 2: Per-router refactor (one router at a time, in priority order)

Each router is a self-contained unit. They can be done in any order without risk to each other.

For each router:
1. Destructure at the top of each procedure:
   ```typescript
   const { effectiveUserId, effectiveOrgId } = ctx;
   const actorUserId = ctx.session!.user.id; // until Step 1 is done
   ```
2. Replace data-scoping usages with `effectiveUserId` / `effectiveOrgId`
3. Keep `actorUserId` (or `ctx.session!.user.id`) for all audit/ownership fields
4. Run `npm run type-check` after each file
5. Test the specific feature manually or via Vitest

### Step 3: Update `componentResolution.ts` lib

`getEffectiveComponents` and `hasComponentAccess` in `src/modules/lmspro/lib/componentResolution.ts`
are called by multiple routers. They accept a `ComponentResolutionContext` with a `userId` field.
All callers must pass `effectiveUserId` instead of `session.user.id`.

The `ComponentResolutionContext` interface shape is already correct — only the callers change.

### Step 4: Verify with grep

After all routers are done, run:
```bash
grep -rn "session!.user.id\|session!.user.organizationId" \
  src/modules src/server/core/routers
```
Review every remaining result and confirm it is an audit/actor usage, not a data-scoping usage.

---

## Work Estimate

| Group | Files | Estimated effort |
|---|---|---|
| Step 1: `trpc.ts` helper | 1 | 30 min |
| LMSPro — critical (components, clubs, key-dates, seasons) | 4 | 2–3 hours |
| LMSPro — remaining 15 routers | 15 | 1 day |
| Core — lmspro sub-routers (freeDays, clubNotes, disciplinary, specialFreeDays) | 4 | 2–3 hours |
| Core — general routers (users, settings, features, issues, tooltips, media) | 6 | 3–4 hours |
| Core — low priority (auth, security, api-keys, platform-admin-only) | 16 | Review only — most stay as `session.user.id` |
| Pulse — all routers | 13 | 1 day |
| Testing each area | — | 1 day |
| **Total** | **~59 files** | **~4–5 days focused work** |

---

## Risks

| Risk | Severity | Mitigation |
|---|---|---|
| Audit log misattribution — recording `effectiveUserId` where `actorUserId` should be used | HIGH | Per-call-site human review. The `actorUserId` alias makes it obvious which is which. |
| Tenant data leak — showing org A data to a user in org B | HIGH | `effectiveOrgId` is always derived from the impersonation cookie which is validated server-side. Gated by `platformAdmin` check — cannot be spoofed by a regular user. |
| Breaking non-impersonation flows | LOW | `effectiveUserId` = `session.user.id` for all non-P1 users. Zero behaviour change. |
| Missing a router that still uses `session.user.id` for data scoping | MEDIUM | Post-refactor grep (Step 4) catches any remaining cases. |
| Scope creep — touching mutations that don't need changing | MEDIUM | Only change read/access-gate usages. Leave all mutation `requestedBy`/`createdBy` fields alone unless they are also wrong. |

---

## Out of Scope for This CR

- **Server Actions** (`src/server/actions/`) — Next.js server functions, not tRPC. Own session access pattern. Separate audit required.
- **Server Components** that call Prisma directly (e.g. `welcome/page.tsx` — already handled separately for the impersonation routing fix)
- **Frontend components** — impersonation context is purely a server-side concern

---

## Definition of Done

- [ ] `actorUserId` / `actorOrgId` aliases added to `protectedProcedure` in `trpc.ts`
- [ ] All 58 in-scope router files reviewed and updated
- [ ] `components.router.ts` passes `effectiveUserId`/`effectiveOrgId` to `getEffectiveComponents`
- [ ] All `hasComponentAccess` call sites use `effectiveUserId`/`effectiveOrgId`
- [ ] `npm run type-check` passes clean with zero errors
- [ ] P1 impersonating a Derby JFL user sees: correct dashboard tiles, correct season data, correct club data
- [ ] Regular tenant user (e.g. `admin@acme.com`) behaviour is unchanged — verified by manual test
- [ ] Post-refactor grep confirms all remaining `session!.user.id` usages are audit/actor-only
