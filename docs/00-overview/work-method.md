
# **IsoStack Working Method Specification**

*How AI and isocb collaborate during development*
*Version 3.0 – Aligned with IsoStack AI Ruleset & Anchor*

---

## **1. Purpose of This Document**

This document defines the **expected behaviour**, **communication style**, and **operational workflow** when AI collaborates with isocb on any IsoStack-based project.
It ensures:

* clarity
* safety
* predictable line-number accuracy
* correct architectural alignment
* efficient testing and iteration
* actionable instructions for a solo developer workflow

This is the **authoritative protocol** for all development tasks.

---

# **2. User Profile & Working Context**

### **2.1 Background**

* Intermediate developer (Next.js, Prisma, tRPC, Neon, Render)
* Strong SQL background; comfortable with relational modelling
* Rapidly progressing with terminal/CLI usage
* Learning full-stack patterns through guided coaching

### **2.2 Tooling**

* **VS Code (local)** — primary editor
* **Terminal** — running dev server, git, package installs
* **GitHub (browser + local sync)** — version control
* **Neon Browser Console** — SQL + schema changes
* **Render Dashboard** — hosting, logs, deploys

### **2.3 Preferences**

* Clear, explicit, step-by-step instructions
* No jargon without explanation
* Full file paths at all times
* Testable phases (max 6–8)
* Reverse-order multi-edit instructions
* Explanations of both *what* and *why*
* Learning-oriented guidance
* Confirm steps before proceeding

---

# **3. AI Conduct Requirements (MANDATORY)**

The AI must **always** comply with the following behaviours.

---

## **3.1 No Cached Files (CRITICAL RULE)**

The AI must **never** assume a file’s contents.
If the file is relevant to the task:

### AI must say:

> “Before I provide line-numbered edits, please paste the current full contents of `<file>` so I can avoid using cached or stale versions.”

No exceptions.

---

## **3.2 Multi-Edit Instructions MUST Be Given in Reverse Order**

When modifying one file in multiple places:

* Provide changes **largest line number → smallest line number**
* This prevents earlier edits from shifting later line numbers

This rule is always required.

---

## **3.3 Mandatory Format for All File Edits**

Every edit must follow this exact format:

````
**File:** /full/path/to/file.ts
**Location:** Lines 145–162

**FIND THIS CODE:**
```typescript
<exact code block>
````

**REPLACE WITH:**

```typescript
<exact replacement>
```

**WHAT CHANGED:**

* <bullet points>

```

Rules:
- FIND blocks must be **exact matches**  
- Never use ellipses inside FIND blocks  
- Always show the full, exact code to be replaced  
- Always show full file path  

---

## **3.4 Clarification Requirement**

AI must pause and ask questions when:

- there is more than one possible interpretation  
- the impact on tenancy/architecture is unclear  
- the file structure is unknown or ambiguous  
- schema or data model is uncertain  
- the requirement conflicts with existing patterns  

Required AI behaviour example:

> “There are two valid interpretations of your request. Before proceeding, I need to confirm which one you intend.”

---

## **3.5 AI Explanation Requirement**

AI must always explain:

- **what** the change does  
- **why** the change is needed  
- **how** the change integrates into IsoStack  

Use plain language.

---

# **4. Development Workflow**

This defines how features, fixes, and refactors must be delivered.

---

## **4.1 Phase-Based Work (MANDATORY)**

Every feature must be split into **6–8 phases**, where each phase:

- is independently testable  
- takes 15–30 minutes of work  
- includes clear before/after context  
- builds on previously confirmed work  

AI must not proceed without:

> “Phase complete — proceed.”

---

## **4.2 Phase Structure Template**

Each phase must follow:

```

## Phase X: <title> (estimated 15–30 minutes)

### Goal

<1–2 sentence purpose>

### Steps

<list of actions with full file paths>

### Code Changes

<reverse-order, structured FIND/REPLACE blocks>

### Test Instructions

<how the user should test>

### What Changed & Why

<short explanation>
```

---

# **5. Engineering Workflow**

### **5.1 Typical Development Flow**

1. **Planning**

   * Clarify requirements
   * Identify scope
   * Split into phases

2. **Database Changes (if required)**

   * Modify schema in Neon
   * Update `prisma/schema.prisma`
   * Run migrations
   * Update TypeScript types if needed

3. **Backend Changes**

   * Add/update tRPC routers
   * Add or adjust Zod schemas
   * Implement Prisma queries
   * Write clear error pathways

4. **Frontend Changes**

   * UI components (Mantine)
   * Hooks / query & mutation bindings
   * Forms / validation
   * Integration with server data

5. **Testing**

   * Local dev server tests
   * API tests
   * Tenant isolation checks
   * Render logs

6. **Deployment**

   * Commit to GitHub
   * Render auto-deploys
   * Confirm live behaviour

7. **Refinement**

   * Fix issues
   * Improve UX
   * Document changes

---

# **6. Architectural Context for AI**

AI must always reason using IsoStack’s actual architecture.

### **6.1 Frontend**

* Next.js 15 (App Router)
* React 18.3
* Mantine 7
* TypeScript strict mode

### **6.2 API**

* tRPC 11
* Zod validation
* NextAuth.js v5

### **6.3 Database**

* Prisma 5.x
* Neon serverless PostgreSQL

### **6.4 Infrastructure**

* Render hosting
* Cloudflare R2
* Resend email

### **6.5 Patterns**

AI must adhere to:

* multi-tenant guarding via `orgId`
* settings engine (Global → Platform → Tenant → User)
* end-to-end type safety
* schema-first workflow
* module architecture (Bedrock, Branding, Tooltips, etc.)
* generateId() prefixing

---

# **7. Technical Rules**

### **7.1 Import Paths**

Use component-level imports:

```
import { Button } from '../Button'
```

Never:

```
./ui/button
```

### **7.2 Serialization**

Always use SuperJSON for request/response bodies.

### **7.3 ID Generation**

Use `generateId(<entityType>)`
AI must reference correct prefixes.

### **7.4 Database Workflow**

1. Change Neon schema
2. Update Prisma schema
3. Run migration
4. Update TypeScript types
5. Test against real data

---

# **8. When AI Must Pause**

AI must pause and seek clarification when:

* multiple possible interpretations exist
* instructions could cause data loss
* tenancy rules may be violated
* incompatible alternatives exist
* uncertainty about file locations
* behaviour contradicts conventions or architecture

---

# **9. Commit Strategy**

* One commit per phase
* Clear, descriptive commit message
* No mixing unrelated changes
* Ask before force pushing

---

# **10. Testing Workflow**

After each phase:

1. Run the local dev server
2. Use the affected feature
3. Check for:

   * UI behaviour
   * API behaviour
   * logs
   * data correctness
4. Only then proceed

AI must not continue until explicitly told:

> “Phase complete — proceed.”

---

# **11. Final AI Conduct Summary (Must Be Memorised by AI)**

1. **Always request the most recent file version** before editing.
2. **All edits must be provided in reverse line order.**
3. **Always give full file paths.**
4. **Use strict FIND/REPLACE/INSERT format.**
5. **Split all work into phases.**
6. **Explain reasoning and intent.**
7. **Pause when ambiguous.**
8. **Follow IsoStack architecture and patterns.**
9. **Never use cached content.**
10. **Never give unordered edits or multi-file changes without sequencing.**


