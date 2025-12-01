

# **IsoStack Architecture Overview**

*Internal Development Documentation – High-Level Technical Summary*

---

## **1. Purpose & Audience**

IsoStack is a **curated full-stack TypeScript framework** designed for **solo developers and small teams** who need to build **multi-tenant SaaS applications** rapidly, safely, and at production quality.

This document provides a **structural overview** of the platform.
Detailed module or technology documentation lives in:

* `/docs/core/`
* `/docs/modules/`
* `/docs/connectors/`
* `/docs/apps/`

---

## **2. Architectural Goals**

IsoStack is engineered around six core principles:

1. **Type safety end-to-end** (compile-time confidence)
2. **Convention over configuration** (faster iteration)
3. **Serverless-native scaling** (Neon + Render)
4. **Minimal boilerplate** (tRPC + Prisma)
5. **Secure-by-default** (NextAuth, Prisma, SSR)
6. **Developer ergonomics** (Mantine + strict TypeScript)

---

## **3. High-Level Architecture Diagram**

```
                      ┌─────────────────────────────────┐
                      │           FRONTEND               │
                      │   Next.js 15 (App Router)        │
                      │   Mantine 7 UI                   │
                      └─────────────────────────────────┘
                                      │
                                      ▼
                      ┌─────────────────────────────────┐
                      │             API LAYER            │
                      │   tRPC 11                        │
                      │   Zod Validation                 │
                      │   NextAuth.js v5                 │
                      └─────────────────────────────────┘
                                      │
                                      ▼
                      ┌─────────────────────────────────┐
                      │          DATABASE LAYER          │
                      │   Prisma 5.x ORM                 │
                      │   Neon Serverless PostgreSQL     │
                      └─────────────────────────────────┘
                                      │
                                      ▼
                      ┌─────────────────────────────────┐
                      │       INFRASTRUCTURE LAYER      │
                      │   Render (hosting)              │
                      │   Cloudflare R2 (file storage)  │
                      │   Resend (email)                │
                      │   GitHub (CI/CD, versioning)    │
                      └─────────────────────────────────┐
```

---

## **4. Stack Components (Succinct Overview)**

### **4.1 Frontend Layer**

| Component          | Role              | Why Chosen                                              |
| ------------------ | ----------------- | ------------------------------------------------------- |
| **Next.js 15**     | Routing, SSR, RSC | Industry standard, server components, simple API routes |
| **React 18.3**     | UI framework      | Mature, widely supported                                |
| **Mantine 7**      | UI components     | Complete, accessible, productive                        |
| **TypeScript 5.x** | Type safety       | Prevents runtime bugs                                   |

---

### **4.2 API Layer**

| Component          | Role                                       | Why Chosen                                           |
| ------------------ | ------------------------------------------ | ---------------------------------------------------- |
| **tRPC 11**        | Typed API → frontend & backend share types | Zero-duplicate types, fast development               |
| **Zod**            | Input validation                           | Runtime safety + schema-generated types              |
| **NextAuth.js v5** | Authentication                             | Secure, Next.js-native, supports magic links & OAuth |

---

### **4.3 Database Layer**

| Component           | Role                             | Why Chosen                             |
| ------------------- | -------------------------------- | -------------------------------------- |
| **Prisma 5.x**      | ORM, migrations, type generation | Excellent DX, strong type inference    |
| **Neon PostgreSQL** | Serverless SQL database          | Scales to zero, Postgres compatibility |

---

### **4.4 Infrastructure Layer**

| Component         | Role                             |
| ----------------- | -------------------------------- |
| **Render**        | Hosting (web app, cron, workers) |
| **Cloudflare R2** | File, asset, and blob storage    |
| **Resend**        | Transactional email              |
| **GitHub**        | Version control, CI/CD pipeline  |

---

## **5. Application Patterns**

IsoStack enforces consistent patterns across all apps:

### **5.1 File-Based Routing**

Next.js App Router defines pages via folder structure.

### **5.2 Module-Oriented Architecture**

Core modules (e.g. Bedrock, Tooltips, Branding) can be enabled per tenant.

### **5.3 tRPC Router Organisation**

API logic follows this structure:

```
/server
  /routers
    user.ts
    tenant.ts
    settings.ts
    dashboard.ts
  trpc.ts
```

### **5.4 Prisma Models**

Stored in a single `schema.prisma` file with:

* strict naming conventions
* consistent relational design
* shared model patterns (timestamps, soft-delete, ownership)

### **5.5 Tenancy Pattern**

Uses **org_id** or **tenant_id** fields combined with:

* Prisma filters
* RLS-style application logic
* consistent middleware patterns

### **5.6 Settings Engine**

Global → Platform → Tenant → User overrides.

Defined separately in:
`/docs/core/config-settings-engine.md`

---

## **6. Security Model**

IsoStack hardens security via:

* SSR-first rendering (reduces client attack surface)
* No custom auth (NextAuth only)
* Zod validation for every API input
* Prisma → SQL injection impossible without raw SQL
* Serverless database connections pooled by Neon
* Secrets stored in environment variables only
* Optional audit logging via middleware

More details in:
`/docs/core/security-policies.md`

---

## **7. Deployment Lifecycle**

IsoStack uses a three-stage environment pattern:

```
dev → staging → production
```

Render deploys on GitHub push or manual triggers.

Neon supports branching for safe schema migrations.

---

## **8. Why IsoStack Works Well for Solo Developers**

* Low cognitive load
* Minimal boilerplate
* Strong conventions
* Serverless = cheaper and simpler
* Excellent tooling
* Easy debugging (typed APIs)
* Scales with your skill level
* Small but complete ecosystem

---

## **9. Related Documents**

* `/docs/00-overview/conventions.md`
* `/docs/core/tenancy-model.md`
* `/docs/core/security-policies.md`
* `/docs/modules/bedrock/overview.md`
* `/docs/modules/tooltips/overview.md`

---

## **10. Update Policy**

This document should be updated when:

* a core dependency changes (Next.js, tRPC, Prisma, Neon)
* a new module is added
* the IsoStack architecture or conventions evolve

**Maintainer:** Isoblue Platform Team
**Status:** Active

---
