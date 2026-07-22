
# This Document explains:

* the purpose of the documentation hub
* how the structure works
* how to navigate it
* conventions for writing docs
* how it fits alongside IsoStack’s tooltip-based help
* how developers should use it with Git, VS Code, and AI tools

It’s written for internal use — by you, Sue, future staff, contractors, or AI agents.

## Quick Map

For quick onboarding, start with [`DOCUMENTATION_MAP.md`](./DOCUMENTATION_MAP.md).


---

## **Isoblue Documentation Hub**

*Internal Development Documentation — Not for External Distribution*

This repository is the **Single Source of Truth (SSOT)** for all internal documentation across:

* **Isoblue** (company-level practices, processes, architecture)
* **IsoStack** (core platform, tenancy, settings, architecture)
* **Official IsoStack Modules** (Bedrock, Tooltips, Branding, etc.)
* **IsoStack Connectors** (Knack, Cloudflare R2, Supabase, Ecwid, etc.)
* **Applications built on IsoStack** (Emberbox, Tailoraid, APIKeyChain, LMSPro)
* **Cross-cutting engineering guides**
* **Changelog and versioning notes**

This documentation is used by:

* Isoblue internal team
* contractors and collaborators
* AI development agents
* platform maintainers
* future technical staff

It complements — but is separate from — the **IsoStack Tooltip Help System**, which provides context-sensitive, in-app help for end-users and tenants.

---

## 📁 **Repository Structure**

The documentation follows a clear, scalable hierarchy:

```
/docs
  /00-overview     → non-executable principles, architecture summaries and orientation
  /00-roadmap-control → root sequencing and cross-lane coordination authority
  /platform        → first-class IsoStack Platform CR-to-review delivery lifecycle
  /core            → reusable technical references and bounded Core domains such as Commerce
  /modules         → official IsoStack modules
  /connectors      → third-party integrations
  /apps            → SaaS apps built using IsoStack
  /guides          → cross-cutting engineering guides
  /changelog       → central change history for platform/modules/apps
```

### Key folders:

### **`00-overview/`**

Global, high-level information applicable to everything:

* architecture overview
* glossary
* conventions

This folder provides principles and orientation. It does not select executable work or
record slice lifecycle status.

### **`00-roadmap-control/`**

Root sequencing and coordination across Platform, Core and module lanes. It identifies the
single cross-lane next-slice authority without replacing each lane's own roadmap.

### **`platform/`**

The first-class management and delivery home for continued shared IsoStack Platform
development, including:

* roadmap control
* CR inputs
* triage
* bounded slice planning
* implementation confirmations
* review and test
* platform assurance and monthly security-review findings

### **`core/`**

Reusable technical references and bounded Core domains, including:

* server architecture
* tenancy model
* settings engine
* security policies
* database schemas
* Commerce Core

### **`modules/`**

Official first-party modules that can be plugged into IsoStack:

* Bedrock
* Tooltips
* Branding
* More to come…

Each module has:

* README (context)
* API reference
* schema extensions
* migration notes

### **`connectors/`**

Documentation for integration layers:

* Knack API proxy
* Cloudflare R2
* Supabase
* etc.

Includes setup, auth/security, rate limits, and usage patterns.

### **`apps/`**

Docs for each SaaS product:

* Emberbox
* Tailoraid
* APIKeyChain
* LMSPro

These include:

* architecture
* onboarding
* API references
* use-cases
* developer notes

### **`guides/`**

Cross-platform engineering documentation:

* Git workflow
* DB migration policy
* coding standards
* common patterns
* tenant onboarding

### **`changelog/`**

Version tracking across:

* core platform
* modules
* apps
* connectors

---

## 📐 **Documentation Conventions**

### **File Format**

All documentation uses **Markdown (`.md`)**.

### **Tone**

* precise
* technical
* terse but clear
* internal audience only
* not a marketing document

### **Headings**

Each file should begin with:

* a short description
* purpose
* scope
* last updated date (optional but encouraged)

### **Cross-Referencing**

Use relative links:

```
See: ../modules/bedrock/api-reference.md
```

### **Naming**

Follow the IsoStack Repository Naming Standard.

### **Folder Hygiene**

* One topic per file
* Do not place architecture in app folders
* Do not duplicate content across sections (link instead)

---

## 🧠 **Using These Docs With AI**

These docs are designed to assist AI tools (including ChatGPT and internal agents) by providing:

* consistent structure
* clear separation of concerns
* predictable paths
* isolated module and connector documentation
* cross-linked guidance

To maximise AI understanding:

* keep content atomic
* avoid long monolithic files
* establish patterns that AI can infer

---

## 🔧 **Working With Docs Locally**

### Clone the repo:

```
git clone https://github.com/isocb/docs.git
```

### Create/edit docs using:

* VS Code
* Obsidian (recommended for browsing and linking)
* any Markdown editor

### Commit workflow:

```
git add .
git commit -m "Update: <section> <topic>"
git push
```

---

## 🔄 **Roadmap**

Planned additions include:

* IsoStack multi-tenancy diagrams
* Settings engine deep-dive
* Bedrock v2 schema
* AI-helper prompt index
* Standardised app architecture template
* Module bootstrapping guide
* Tenant provisioning guide

---

## 🏁 **Purpose**

This documentation hub exists to:

* store every piece of internal technical knowledge
* reduce context fragmentation across apps and modules
* accelerate development
* support AI-assisted engineering
* maintain long-term consistency and architectural integrity

Everything you build in IsoStack or Isoblue should be reflected somewhere in this repository.
