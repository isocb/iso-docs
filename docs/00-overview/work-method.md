---
title: IsoStack Work Method
version: 1.1.0
status: stable
---

# IsoStack Work Method

This document defines how development, AI collaboration, and architectural changes are made inside IsoStack.

---

# 1. Principles

- **Single source of truth:** `architecture.md` defines how the system works.  
- **Never override patterns:** All modules use the Core AppShell, dashboards, and switcher.  
- **Phase-based work:** Small, testable steps.  
- **Version pinning:** Mantine 7.13.2, Prisma 5.x, Next 15 — pinned for stability.  
- **Infrastructure separation:** Dev → Staging → Production.  
- **Multi-schema database:** Modules get their own schema.

---

# 2. Folder Structure

/app
/(platform)
/(tenant)
/(app modules)
/server
/docs
/prisma

Modules live under `/server/<module>` + `/app/<scope>/<module>`.

---

# 3. Development Phases (Canonical)

### Phase 1 — Documentation  
Update architecture docs before coding.

### Phase 2 — Data Model  
Add models + migrations + seeds.

### Phase 3 — Core UX Shell  
AppShell, context bar, module switcher.

### Phase 4 — Scopes & Dashboards  
Implement `/platform`, `/tenant/[id]`, `/app` routes with dashboards.

### Phase 5 — Modules & Features Manager  
UI + tRPC.

### Phase 6 — Impersonation  
Tenant switch + impersonation flows + audit logging.

### Phase 7 — Module Integration  
Wire modules into routes, dashboards, and switcher.

### Phase 8 — QA + Docs Update  
Stabilise and prepare module author templates.

---

# 4. AI Collaboration Rules

- Everything must follow `architecture.md`.  
- Mantine components must be v7.13.2 syntax.  
- Multi-schema Postgres is required; no shortcuts.  
- All navigation must use scopes and switcher.  
- AI should always use IsoStack patterns, not introduce new UI/UX frameworks.

---

# 5. Commit Style

- Commit per phase  
- 1 change set = 1 commit  
- PR titles follow:  
  - `feat(core): add module switcher`  
  - `feat(platform): implement impersonation`  
  - `docs(architecture): add tenant dashboards`

---

# 6. Summary

The work method ensures:
- predictable builds  
- reliable AI collaboration  
- minimal rework  
- a consistent platform across all modules  

All developers, including AI assistants, must follow this method.