

## Copilot Agent Prompt - i'm sorry to be a bit heavy handed here... but this is a live project. 

YIn this phase you are helping Chris implementation-planning, operating inside the **IsoStack** monorepo. You have full read access to the codebase and its `/docs`. We have a great relationship and a developing ability to deliver very good and fast progress. Your job is to design a *safe, incremental implementation plan* for a new IsoStack module: **LMSPro (Derby Junior Football League)**.

### 0) Non-negotiables (safety + delivery rules)

Follow these rules at all times:

1. **Tenant isolation is mandatory**
   Every query must be scoped by `organizationId` (aka orgId) and follow IsoStack multi-tenant patterns. No cross-org reads/writes.  

2. **Environment discipline**
   We develop locally (dev), then promote to **techtest** for QA. Dev and TechTest use separate Neon branches and separate encryption keys; TechTest data is protected and must not be wiped. Align all work to the branch/deploy pipeline (dev → techtest).  

3. **Schema change workflow**
   In dev: schema changes may use db:push; anything intended to move up the chain must have a proper Prisma migration committed and tested.  

4. **Module contract + UI grammar**
   LMSPro must conform to the IsoStack module specification: AppShell integration, standard list controls, click-to-modal where appropriate, tabs, settings screen, no hard-coded branding, no bespoke nav.  

5. **Working method**
   Optimise for small, testable increments. Produce a plan that maps to short commits that can be merged dev → techtest frequently. 

---

### 1) Context you must use

The DJFL functional requirements include (at minimum): season management, clubs, teams, age groups + AGGs, venues, referees (sensitive data with restricted visibility), billing via Xero, and integrated communications with logging and dynamic recipient sets. Team Managers are *data records*, not login users.  

IsoStack already has (or is planning) a unified email/communications architecture intended to support module-filtered broadcasts (DJFL is referenced as an example). When planning LMSPro communications, align with that system rather than inventing a parallel one. 

---

### 2) What I want you to produce (deliverables)

Return the following in a structured, implementation-ready format:

#### A) LMSPro Delivery Roadmap (phased, safe)

* A phased plan (Phase 0/1/2/…) where each phase is shippable to **techtest**.
* Each phase must list: scope, files/areas likely touched, acceptance checks, and rollback notes.
* Include “what we defer” explicitly (so we don’t boil the ocean).

#### B) Data Model + Tenancy strategy

* Propose a Prisma schema for LMSPro in its own module schema (e.g. `lmspro`), with:

  * core entities: Season, Club, ClubRole/Officials, Team, AgeGroup, AGG, Venue (+ contacts), Referee (sensitive), Communications log, plus minimal TeamManager record
  * `organizationId` everywhere required by tenancy
  * indexes and uniqueness constraints that prevent duplicates per season/org
* Identify which fields require **encryption/obfuscation** (especially referees / minors) and how IsoStack patterns should handle that.

#### C) Permissions / RBAC map

* Map DJFL roles to IsoStack roles & module-level permissions.
* Explicitly call out sensitive areas (referees) and how visibility is constrained.

#### D) UI map (routes, tabs, CRUD modality)

* Proposed routes under `src/modules/lmspro/...` and `src/app/(app)/...` consistent with module spec.
* Tables + search/sort controls, modal/child-page decisions, and required screens (dashboard, primary lists, settings). 

#### E) tRPC API plan

* Routers/procedures for CRUD per entity with Zod validation, audit logging for mutations, and strict org scoping. 
* Note any cross-cutting “service layer” helpers (e.g., season rollover, AGG capacity allocation).

#### F) Communications approach (important)

* Explain how LMSPro will do:

  * operational notifications (system-triggered)
  * broadcast messages to filtered recipients (clubs, age groups, roles)
* Prefer IsoStack’s unified email/communications plan (Resend + logs + filterable module users) rather than re-implementing.  

#### G) Dev → TechTest test plan

* A practical testing checklist for each phase:

  * local dev checks
  * techtest regression checks
  * data safety checks (no accidental resets; encryption key alignment) 

---

### 3) Constraints (what *not* to do)

* Do not invent new platform patterns or a bespoke UI framework.
* Do not bypass tenant scoping.
* Do not implement Xero end-to-end in Phase 1 unless the plan shows a safe stub + interfaces first.
* Do not model Team Managers as authenticated users (they are records managed by Club Secretary). 

---

### 4) Output format

Produce:

1. **Executive plan** (1–2 pages equivalent)
2. **Phase table** (phases, goals, deliverables, promotion criteria)
3. **Proposed Prisma models** (draft)
4. **Routes + UI map**
5. **tRPC router list**
6. **Risks + mitigations** (top 10, with specific mitigations)

Be concrete. Optimise for safe incremental delivery.

---


> “Start with a thin vertical slice: Season + Clubs + Teams + AgeGroups/AGGs (no referees, no Xero), then add Venues, then Referees (sensitive), then Communications, then Billing integration.”

That sequencing matches the DJFL spec’s operational priorities while keeping the risky bits (sensitive data + finance) later.  

