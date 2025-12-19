Two tiers + three scopes
Tier 1: Security RBAC (hard boundary)

Core Role enum (OWNER/ADMIN/MEMBER) + platformAdmin

Organisation membership is the tenancy boundary

Enforced in tRPC + Prisma filters (and RLS if you use it)

This answers: “What data and admin operations can this user ever touch?”

Tier 2: UX Composition RBAC (mass customisation layer)

Roles defined at module level (e.g., LMSProRole) that grant:

components (what the user sees)

optionally actions (what workflows are enabled)

optionally scopes (which club/team/age group the role applies to)

This answers: “What does this user’s experience look like inside the allowed security envelope?”

Component scopes: Core → Module → Tenant

Think “catalogue + overrides”, not “single catalogue”.

Scope A: Core components (P0)

Provided by IsoStack itself

e.g. Notifications panel, recent activity, “help/tooltips”, account switcher, audit log viewer (if permitted)

Scope B: Module components (P1)

Provided by the module owner (you / platform owner)

e.g. LMSPro: fixtures summary, referee allocations, discipline, league table tools

Scope C: Tenant components (C1)

Defined by an organisation (league/tenant)

e.g.

Sponsor-funded widget (“Acme Sponsor of the Week”)

League-specific KPI component

Custom report block

A league-only workflow shortcut panel

This is exactly what enables “mass customised” software: the module remains robust, but the tenant can tailor their UI/UX with safe building blocks — and even add their own.

How to implement this without chaos: component identity + inheritance rules
1) A single component record type, with scope fields

A component must always have:

moduleKey (or core)

scope = CORE | MODULE | TENANT

organisationId nullable

componentKey (stable key) or componentId (UUID) plus codeKey

metadata (name, description, pageContext, sort hints, icon, etc.)

optional featureFlagKey

optional definition JSON (for tenant-built components)

2) Override model (reset becomes a first-class action)

For predictable behaviour:

A tenant can override a module component by creating a tenant-scoped record with:

overridesComponentId (points to module component)

changes: title, description, default placement, maybe parameter defaults

A tenant can disable a module component:

isEnabled=false at tenant scope, or a TenantComponentPolicy record

“Reset” = delete/disable tenant override so resolution falls back to module default

That gives you:

defaults that you control

tenant customisation that is safe and reversible

a clean audit trail of changes

Roles and grants: also scoped and inheritable

Same idea as components:

Platform/module defaults (P1 templates)

Seed “typical” roles and mappings:

League Secretary, Treasurer, Age Group Manager, Club Secretary, etc.

Seed role → component grants

Tenant roles (C1)

Tenant can:

clone a template role then tweak it

create brand new roles (“Match Day Coordinator”)

assign roles to users

optionally apply role scopes (club/team/age group)

Reset idea applies here too:

“Reset role to template”

or “Rebuild from template” (safe destructive overwrite)

Resolution algorithm: “effective components” for a user/page

On page load for a given pageContext:

Identify user’s organisation + module

Load user’s assigned module roles (and any scopes)

Resolve effective role grants (tenant overrides + template defaults)

Resolve effective component catalogue for that module+page:

start with Core + Module components

apply tenant overrides (replace metadata/params)

apply tenant disables

add tenant-created components

Intersect grants ∩ effective catalogue

Render in chosen order

This is how you get dynamic dashboards without hardcoding, while still keeping a stable module.

Sponsor-funded / tenant-specific features: where they fit

Your example (“tenant sponsors a LMSPro feature for their league”) fits neatly:

The feature is gated by a feature flag or entitlement record at tenant scope

The UI appears via a tenant component (or a tenant override enabling a module component)

The server actions are still protected by:

tenant entitlement checks

Tier 1 RBAC

action grants (Tier 2 capability)

So the sponsor pays → tenant gets entitlement → component appears → authorised users can use it.

What I would change in my earlier recommendation
I now agree with:

tenant-defined components are valid and valuable

a three-scope component model (Core/Module/Tenant) is the right “IsoStack way”

“reset to defaults” is essential because you’re allowing customisation

I would still keep as non-negotiable:

server-side authorisation must not depend on UI composition

introduce action-level grants sooner than later for anything that mutates data

keep the model simple at first (checklist > drag-drop; overrides later)

So… should you proceed with this architecture now?

Yes — if your objective is “mass customised” SaaS modules.

But implement it in a staged way so you don’t drown:

Core + Module components working (no tenant components yet)

Tenant can override and disable module components + reset

Tenant can create new tenant components (simple types first)

Add action grants and enforce them server-side

Add scoped roles/assignments (club/team/age group)

That gets you the power you want, without turning Phase 1 into a platform rewrite.

If you want next, paste (or summarise) your current tables/models for:

current “page components”

how dashboards are built today


One crucial addition: actions vs components

Components alone are fine for visibility, but most real systems need capabilities:

FIXTURE_APPROVE

PAYMENTS_EXPORT

CLUB_EDIT

TEAM_SQUAD_MANAGE

You can:

either treat actions as another type of “componentKey”

or add a parallel RoleActionGrant. I think the two combine, we just need to use the naming convention for components to indicate VIEW and ACTION components?
current LMSPro role enums