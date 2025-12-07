
### **1. A structured communication protocol between IsoStack and AI**

IsoStack now outputs **machine-readable markdown briefs** that Copilot/ChatGPT can work through systematically.

This solves:

* AI drift
* Re-explaining context
* “What do I work on next?” uncertainty
* Lack of memory in AI agents
* Manual error when switching between tasks

This is, effectively, a **formalised IsoStack → AI API** using markdown as the transport layer.

---

### **2. A unified Issue Manager that supports:**

#### ✔ Issue creation with metadata

Priority, perspective, module, tags, status, created date, author, etc.

#### ✔ AI-batching via *Change Requests (CR#)*

You can group issues into a batch, generate a CR document, commit it to GitHub, and AI works through it.

#### ✔ Stateful progress tracking

Issues move through: Draft → Pending → In Progress → Testing → Complete.

Issues with CR numbers become part of a **traceable audit trail**.

#### ✔ Bulk operations

Bulk selection, bulk status change, fixing the UX so checkboxes don’t conflict with clickable rows.

#### ✔ Progress exports

“Export Issues” produces a live overview of Pending / In Progress issues already handed to AI.

---

### **3. A permanent, searchable evolution history**

Your Completed issues become a **knowledge base** of all changes, discussions, root causes, and fixes.

This will help you:

* Train new developers
* Create release notes
* Audit system change history
* Diagnose regressions
* Understand architectural evolution

---

### **4. You have invented an internal AI-Ops framework for IsoStack**

You're basically building the *equivalent of GitHub Issues + Linear + AI-agents* but **embedded directly inside IsoStack**, tightly coupled to modules and tenants.

This is a **major platform-level feature**.

---

# 🌟 **How It Should Be Documented**

You should document it as a **Core IsoStack Feature**, very similar to:

* “Multi-Tenant Architecture”
* “Tooltip Engine”
* “Feature Flags”
* “Settings Engine”
* “Module Lifecycles”

The Issue Manager sits beside these as an **internal developer-facing platform capability**.

### Recommended Documentation Structure:

```
/docs/core/issue-manager.md
/docs/core/ai-change-requests.md
/docs/core/issue-manager-workflow.md
/docs/core/ai-agent-integration.md
```

However, to keep it simple, you can start with a **single core document**:

> **issue-manager.md**
> (Includes Issue Manager, Change Requests, Export workflows, and AI integration behaviour)

Below is that document, fully written for you, ready to add to your repo.

---

# 🧩 **DROP-IN DOCUMENT:** `docs/core/issue-manager.md`

```md
---
title: IsoStack Issue Manager & AI Change Request System
description: A core IsoStack platform feature enabling structured internal development workflows, AI collaboration, and tracked change management.
version: 1.0.0
status: stable
---

# IsoStack Issue Manager  
**A Core Platform Feature**

The Issue Manager is an internal tool built into IsoStack Core that enables platform owners and module developers to track work, batch changes into structured AI-processable Change Requests, monitor progress, and maintain a permanent evolution history for the platform.

It provides a fully integrated workflow for human developers and AI assistants (GitHub Copilot, ChatGPT, Claude) to collaborate safely, consistently, and with full traceability.

---

# 1. Purpose

IsoStack’s Issue Manager exists to:

1. **Standardise how work is defined, prioritised, and communicated**
2. **Provide a formal protocol for AI-assisted development**
3. **Batch related tasks into Change Requests (CRs)**
4. **Create a machine-readable audit history**
5. **Enable staged progress tracking (Pending → In Progress → Testing → Complete)**
6. **Store all changes in GitHub repos for version control and visibility**

It forms part of IsoStack Core and is available to the Platform Owner for all modules.

---

# 2. Issue Structure

Each issue includes structured metadata:

- **ID**: Internal UUID  
- **Issue #**: Human-readable number  
- **CR #**: Assigned Change Request batch (optional)  
- **Perspective**: PLATFORM_OWNER, MODULE_DEVELOPER, TENANT_ADMIN  
- **Module**: Core or specific module (e.g., Bedrock, APIKeyChain)  
- **Priority**: Low / Medium / High / Critical  
- **Category**: Bug / Feature / Refinement / Architecture  
- **Tags**: Custom descriptors  
- **Status**: Draft → Pending → In Progress → Testing → Complete  
- **Created date**  
- **Created by**  
- **Description** (free text)  
- **Discussion thread** (inline per-issue comments)  

Example (from a live export):  
:contentReference[oaicite:2]{index=2}

---

# 3. Status Workflow



Draft
↓ (promote)
Pending
↓ (assigned to CR)
In Progress
↓ (AI or human work underway)
Testing
↓ (approved)
Complete


**Rules:**

- Only *Pending* issues may be added to a Change Request.
- A Change Request assigns a “CR#” to all included issues.
- When an issue is marked *Complete*, it disappears from day-to-day workflow and becomes part of the permanent audit log.

---

# 4. Change Requests (CR#)

A Change Request is a **batch of related issues grouped together and exported as a markdown brief**.

A CR:

1. Is generated from the UI using “Create Change Request”
2. Includes all *Pending* issues selected for batching
3. Writes a markdown file into the project’s GitHub repo
4. Acts as a brief for Copilot or ChatGPT
5. Receives inline updates from AI as work progresses
6. Stores all outcomes in Git history

Example CR document structure:  
:contentReference[oaicite:3]{index=3}

### Why CRs matter

- They prevent AI drift by giving a **single source of truth** per change batch  
- They force AI to work through tasks **sequentially and accountably**  
- They provide an audit trail: *who changed what, when, and why*

---

# 5. AI Workflow

IsoStack’s Issue Manager implicitly creates a protocol for AI-assisted software development:

### Step 1 — Platform Owner writes issues  
Issues contain clear metadata and descriptions.

### Step 2 — Issues are moved to *Pending*

### Step 3 — A Change Request is created  
IsoStack generates a markdown document including:
- CR number
- Structured issue list
- Required outputs
- Acceptance criteria

### Step 4 — File is saved to GitHub  
Copilot or ChatGPT is instructed:
> “Work through the CR document and update it inline.”

### Step 5 — AI writes progress directly into the CR.md file  
This ensures transparency and keeps all work in Git.

### Step 6 — Platform Owner marks issues as:  
- **In Progress** (once AI begins work)  
- **Testing** (once work is complete)  
- **Complete** (once feature is verified)  

---

# 6. Issue Export View

The *Export Issues* function groups issues into:

- Pending  
- In Progress  
- (optionally) Completed  

This supports:

- **Progress reporting**
- **Reviewing AI changes**
- **Creating testing agendas**
- **Cross-module visibility**

Example export document:  
:contentReference[oaicite:4]{index=4}

---

# 7. Discussion Threads

Each issue supports threaded discussions, enabling:

- Developer clarifications  
- AI diagnostics  
- Root cause notes  
- Implementation details  

These discussions are stored in the audit log of the completed issue.

---

# 8. Bulk Operations

IsoStack supports efficient issue management at scale:

- Checkbox selection that does not interfere with row-click modals  
- “Select all” with indeterminate state  
- Bulk status updates  
- Live notifications and success messages  

This is especially important when preparing batches of issues for a CR.

---

# 9. Benefits to the IsoStack Platform

### **9.1 Efficiency**
- AI receives formal specifications automatically  
- Developers avoid re-explaining context  
- High-quality change briefs are generated in seconds  

### **9.2 Stability**
- CR batching prevents accidental breaking changes  
- Issues carry module association to stop cross-module interference  

### **9.3 Governance**
- You now have a complete, searchable audit log of system evolution  
- Every fix, refinement, feature and root cause is stored permanently  

### **9.4 AI Safety**
- AI is prevented from making unbounded changes  
- Work remains isolated to the scope of the CR document  
- Human validation gates protect stability  

---

# 10. When to Use the Issue Manager

| Scenario | Use |
|---------|-----|
| Fixing bugs | Create issues → Batch via CR → Assign to AI |
| Implementing module designs | Write issues per section → CR |
| Planning roadmap upgrades | Draft issues → Prioritise → CR |
| Multi-phase development | Separate CRs keep phases clean |
| AI request for clarification | Add comments to the issue thread |
| Documenting completed work | Complete issues become immutable history |

---

# 11. Long-Term Vision

The Issue Manager becomes part of IsoStack’s internal AI operating system:

- Every module ships with its own issue space  
- Platform Owner can batch module-specific or core-specific CRs  
- AI executes changes within well-defined scope boundaries  
- Over time, IsoStack gains a complete architectural and behavioural history  

This will be essential when running multiple modules, onboarding developers, or generating automatic release notes.

---

# 12. Future Enhancements (Planned)

- Time estimates + burndown charts
- Automatic CR diff analysis from Git commits
- Linking issues to modules and tenants with filtering logic
- AI-generated test plans based on issue metadata
- Release notes generator based on completed issues
- GitHub Issue sync (optional)
- Webhook events for CR creation

---

# 13. Conclusion

The IsoStack Issue Manager is not just a task list—it is a **governance engine**, **AI interaction protocol**, and **development history system** built directly into the platform.

It gives IsoStack a unique advantage:
> **Repeatable, safe, auditable AI-accelerated software development.**

This system is now a foundational part of IsoStack Core.
