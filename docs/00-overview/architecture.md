
# ✅ UPDATEDarchitecture.md (December 2025 Edition)
# IsoStack Architecture Overview
**Internal development documentation — High-level technical summary**

## 1. Purpose & Audience
IsoStack is a **curated full-stack TypeScript framework** designed for:
* solo developers
* small technical teams
* organisations needing bespoke SaaS
* internal business tools
* multi-tenant products with custom modules

⠀IsoStack provides:
* a stable architecture
* strong conventions
* low cognitive load
* fast development cycles
* safe extensibility
* multi-schema modularity
* typed end-to-end development

⠀This document describes the **structural architecture** of the IsoStack platform.Module-specific documentation exists in:
### /docs/core/
### /docs/modules/
### /docs/connectors/
### /docs/apps/

## 2. Architectural Philosophy
IsoStack is built on six strategic principles:
### 1. Type safety end-to-end
The entire stack shares a single type system (TypeScript → tRPC → Prisma → React).
### 2. Convention over configuration
Developers work faster with predictable file structures, naming, and patterns.
### 3. Serverless-native scaling
Neon PostgreSQL provides serverless, branchable, multi-schema databases.
### 4. Low-boilerplate APIs
tRPC replaces REST. Types flow directly between backend and frontend.
### 5. Security by default
NextAuth.js v5, Zod validation, SSR-first UI patterns, and schema isolation.
### 6. Developer ergonomics
Mantine 6 UI, React hooks, clean component primitives, and structured docs.

## 3. High-Level System Diagram
### ┌────────────────────────────────┐
###                      │            FRONTEND             │
###                      │  Next.js 15 (App Router)        │
###                      │  React 18 + Mantine 6           │
###                      │  TypeScript 5.x                 │
###                      └────────────────────────────────┘
###                                    │
###                                    ▼
###                      ┌────────────────────────────────┐
###                      │            API LAYER            │
###                      │  tRPC 11                        │
###                      │  Zod Schemas                    │
###                      │  NextAuth.js v5 (Magic Link)    │
###                      └────────────────────────────────┘
###                                    │
###                                    ▼
###       ┌────────────────────────────────────────────────────────────────────┐
###       │                          DATABASE LAYER                             │
###       │              Prisma 5.x → Neon Serverless Postgres                 │
###       │                                                                    │
###       │  Multi-Schema Architecture:                                        │
###       │   • public   → core IsoStack platform (orgs, users, auth, files)   │
###       │   • bedrock  → Bedrock 3.0 analytics engine                        │
###       │   (future)   → emberbox, api_keychain, billing, support            │
###       └────────────────────────────────────────────────────────────────────┘
###                                    │
###                                    ▼
###                    ┌──────────────────────────────────┐
###                    │        INFRASTRUCTURE Layer      │
###                    │  Render → App hosting            │
###                    │  Cloudflare R2 → File storage    │
###                    │  Resend → email delivery         │
###                    │  GitHub → versioning & CI/CD     │
###                    └──────────────────────────────────┘

# 4. Technology Stack (Current & Stable)
# 4.1 Frontend
| **Component** | **Version** | **Role** |
|:-:|:-:|:-:|
| **Next.js** | 15 | App Router, SSR, server components |
| **React** | 18.3 | UI rendering & hooks |
| **Mantine** | **6.x** | UI component library (pinned by design) |
| **TypeScript** | 5.x | Type safety throughout |
### 👉 Why Mantine 6 (and not 7)?
Mantine 7 introduces:
* breaking API changes
* removal of base styles
* unstable SSR characteristics
* unnecessary cognitive overhead

⠀**IsoStack deliberately standardises on Mantine 6** because it provides:
* stable components
* predictable API
* excellent SSR
* minimal boilerplate
* fast developer experience

⠀**Mantine 6 is the correct choice for IsoStack's architecture.**

# 4.2 API Layer
| **Component** | **Role** |
|:-:|:-:|
| **tRPC 11** | Typed API, zero duplication |
| **Zod** | Input/output validation |
| **NextAuth.js v5** | Magic-link auth, secure sessions |
| **SuperJSON** | Serializable complex types across wire |
API routes live under:
### /server/routers/<module>/
Each module has its own router subtree.

# 4.3 Database Layer
IsoStack uses **Neon serverless PostgreSQL** with a **multi-schema architecture**, managed entirely through Prisma.
### Current Schemas:
| **Schema** | **Purpose** |
|:-:|:-:|
| **public** | Core platform (orgs, users, tooltips, auth) |
| **bedrock** | Bedrock 3.0 (projects, sheets, views) |
### Why multi-schema?
* Clean separation of concerns
* Module isolation
* Safer migrations
* Future modules (emberbox, api_keychain) can be added without collisions
* More maintainable over long time horizons
* Enables IsoStack’s “plug-in module” philosophy

⠀Prisma configuration:
### datasource db {
###   provider = "postgresql"
###   url      = env("DATABASE_URL")
###   schemas  = ["public", "bedrock"]
### }
Each model includes @@schema() to define its namespace.

# 4.4 Infrastructure Layer
| **Service** | **Purpose** |
|:-:|:-:|
| **Render** | Hosting + cron jobs |
| **Neon** | Serverless Postgres DB |
| **Cloudflare R2** | File, image & media storage |
| **Resend** | Transactional email |
| **GitHub** | Source control & CI/CD |

# 5. IsoStack Application Patterns
IsoStack enforces strict patterns to maximise developer speed and minimise errors.

# 5.1 File-Based Routing
Next.js App Router used for all routes, SSR where possible.
# 5.2 Module-Oriented Architecture
Modules each contain:
### /server/routers/<module>/
### /prisma/<module>/
### /docs/modules/<module>/
Bedrock is the first fully isolated module using its own schema (bedrock).
# 5.3 tRPC Router Organisation
### /server
###   /routers
###     core/
###     bedrock/
###     (future modules)
Modules do not interfere with each other.
# 5.4 Prisma Organisation
All models live in one file but are grouped and schema-scoped:
### model User             @@schema("public")
### model BedrockProject   @@schema("bedrock")
# 5.5 Tenancy Model
IsoStack uses **organisation-scoped tenancy**:
* All module data includes organisationId
* tRPC middleware ensures tenant isolation
* Platform owner organisations supported (isAppOwner = true)

⠀
# 6. Tooltip System (3-tier Inheritance)
IsoStack provides a unique multi-layer tooltip system:
| **Layer** | **Purpose** |
|:-:|:-:|
| **Global** | Default platform tooltips |
| **App Owner** | Overrides for a specific industry/vertical |
| **Tenant** | End-organisation customisation |
### Features:
* Visual element picker (CSS selector identification)
* Tooltip categories
* Tooltip “function” field
* R2-hosted media (PDF/video embeds inside tooltips)
* Complete SSOT repository accessible programmatically
* Toggle visibility via user preference (“Help Mode”)
* Keyboard activation (Ctrl+Shift+?)

⠀
# 7. Security Architecture
IsoStack ensures:
* SSR-first rendering
* NextAuth secure session model
* Prisma protects against SQL injection
* Zod validates all input
* Organisation-first tenancy model
* Audit logs for admin actions
* Token-based magic-link authentication
* Secrets stored in environment variables
* Optional migration to **Postgres RLS** if needed

⠀
# 8. Deployment Lifecycle
Standard flow:
### dev → staging → production
Neon branching makes DB state safe:
* Dev branches for experiments
* Staging mirrors production
* Production stable

⠀Render handles CI/CD from GitHub.

# 9. Why IsoStack Works for Solo Developers
* Soft opinions, strong defaults
* End-to-end type safety reduces bug surface
* Clear conventions minimise mental overhead
* Multi-schema separation stops domain sprawl
* tRPC makes API design nearly frictionless
* Mantine 6 gives productive UI patterns
* Future modules plug in cleanly

⠀IsoStack is **the smallest possible system that scales to complex SaaS**.

# 10. Related Documentation
* /docs/00-overview/conventions.md
* /docs/core/security-policies.md
* /docs/core/tenancy-model.md
* /docs/modules/bedrock/architecture.md
* /docs/modules/tooltips/manifesto.md
* /docs/modules/api-keychain/architecture.md

⠀
# 11. Update Policy
This document must be updated when:
* Dependencies change (Next.js, Prisma, Neon, Mantine)
* Schema architecture expands (new modules)
* Tooltip or settings engines evolve
* Security model changes

⠀**Maintainer:** Isoblue / IsoStack Platform Team**Status:** Active (Dec 2025)
