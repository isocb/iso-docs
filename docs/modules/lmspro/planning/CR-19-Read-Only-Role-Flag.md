23# CR #19: Read-Only Role Flag for LMSPro

**Status:** Planned  
**Raised:** 4 March 2026  
**Raised By:** Chris (Platform Owner)  
**Prepared By:** GitHub Copilot AI  
**Estimated Effort:** ~4 hours  

---

## 1. Background & Motivation

A new requirement was raised on 4 March 2026: certain users should be able to have full access to the LMSPro club dashboard (view all data, navigate all sections) but be **unable to make any changes**. The canonical use case is:

- **Club Secretary** — the single authorised editor for a club. Only they can submit forms, update registrations, manage officials, etc.
- **Shadow / Viewer users** — committee members, chairpersons, parents with a committee role, etc. who need visibility but must not accidentally (or deliberately) alter data.

This is a clean, widely-understood UX pattern ("view-only" accounts) and maps naturally onto the existing Component-Based RBAC system.

---

## 2. Chosen Approach — Option A: `isReadOnly` flag on `ModuleRole`

### Why this option

The existing `ModuleRole` model already defines what a role *can see*. Adding `isReadOnly` makes it define what a role *can do* — a minimal, non-breaking extension.

Other options considered:

| Option | Description | Verdict |
|--------|-------------|---------|
| **A — `isReadOnly` on ModuleRole** | Single boolean, enforced at middleware + UI | ✅ Chosen |
| B — `canWrite` per component assignment | Per-component write flag | Too granular for this use case |
| C — Dedicated `SHADOW` roleType enum | New role type category | More complexity than needed |

---

## 3. Scope of Changes

### 3.1 Schema — `prisma/schema.prisma`

Add to `ModuleRole`:

```prisma
isReadOnly  Boolean  @default(false)  @map("is_read_only")
```

One migration required. Non-destructive — all existing roles default to `false` (no change in behaviour).

### 3.2 tRPC — `user-context.router.ts`

The `userContext` router already returns the user's active role context. Add:

```typescript
isReadOnly: activeRole?.isReadOnly ?? false,
```

This gives every frontend surface a single source of truth.

### 3.3 tRPC Middleware — mutation guard

In `src/server/core/trpc.ts` (or the `requireRole` helper), add a check on all `mutation` procedures for users whose active LMSPro role has `isReadOnly: true`:

```typescript
if (isLmsproMutation && userActiveRole?.isReadOnly) {
  throw new TRPCError({
    code: 'FORBIDDEN',
    message: 'Your account is read-only. Contact your Club Secretary to make changes.',
  });
}
```

This is the **hard enforcement** — even if UI controls are somehow visible, the server rejects all writes.

### 3.4 Frontend — Club Dashboard

Consume `trpc.lmspro.userContext.useQuery()` → `data.isReadOnly`.

When `isReadOnly: true`:
- All edit/delete/submit buttons are disabled or hidden
- A subtle banner is shown: *"You have view-only access. Contact your Club Secretary to make changes."*
- Row-click CRUD modals open in read-only view mode (no Save/Delete buttons)

### 3.5 Role Management UI — `RolesTab` or equivalent

Add a **Switch** to the role CRUD modal:

```
☐ Read only
   Users with this role can view all data but cannot make any changes.
```

---

## 4. Affected Files

| File | Change |
|------|--------|
| `prisma/schema.prisma` | Add `isReadOnly` to `ModuleRole` |
| `prisma/migrations/YYYYMMDD_add_is_read_only_to_module_role/` | New migration |
| `src/modules/lmspro/routers/user-context.router.ts` | Expose `isReadOnly` |
| `src/server/core/trpc.ts` | Mutation guard for read-only roles |
| `src/modules/lmspro/routers/roles.router.ts` | Accept + persist `isReadOnly` in create/update |
| `src/app/(app)/app/lmspro/club/` (dashboard pages) | Consume `isReadOnly` flag, disable edit surfaces |
| Role management UI component | Add Switch to role CRUD modal |

---

## 5. User-Facing Behaviour Summary

| Scenario | Result |
|----------|--------|
| Club Secretary logs in | Full edit access — no change from today |
| Shadow user (read-only role) logs in | All data visible; all write controls disabled; banner shown |
| Shadow user attempts mutation via API | Server returns `FORBIDDEN` with clear message |
| League admin sets role to read-only | Toggle in role card; takes effect immediately on next login |
| League admin removes read-only flag | User regains write access immediately |

---

## 6. Migration Notes

- **Non-destructive** — `isReadOnly @default(false)` means zero impact on existing roles and users
- Follow standard migration workflow: write SQL manually → `prisma migrate deploy`
- No seed data changes required

---

## 7. Out of Scope

- Granular per-component write permissions (Option B) — can be revisited in a future CR if needed
- Read-only mode for League Admin roles (league-side is implicitly admin-only; this CR targets club-level users)
- Audit logging of read-only access (views are not currently logged)

---

## 8. Implementation Plan

| Phase | Task | Est. |
|-------|------|------|
| 1 | Schema change + migration | 20 min |
| 2 | `user-context` router + `roles` router updates | 20 min |
| 3 | tRPC mutation guard | 20 min |
| 4 | Role CRUD modal — add Switch | 20 min |
| 5 | Club dashboard — consume `isReadOnly`, disable UI | 60 min |
| 6 | Read-only banner component | 20 min |
| 7 | Type-check, test, commit, push | 20 min |
| **Total** | | **~3–4 hrs** |

---

*Last updated: 4 March 2026*
