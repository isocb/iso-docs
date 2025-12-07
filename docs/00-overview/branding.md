

# **Branding Specification (Tenant & Module)**

*IsoStack — AI-Ready Briefing Document*
**Status:** Draft
**Version:** 0.1.0

---

## **1. Overview**

IsoStack supports two parallel branding systems:

* **Tenant Branding** – Applied to client-facing experiences for a specific tenant.
* **Module Branding** – Defines how each module presents itself by default.

Branding systems are **feature-flag controlled**, and only apply when the relevant feature flag is enabled.

Both branding systems use uploaded assets (preferably SVG) and colour/typography parameters that apply across UI surfaces, authentication flows, and system emails.

---

## **2. Asset Rules**

### **2.1 Logo Requirements**

* Logos should be **SVG** whenever possible (preferred).
* Other formats (**PNG, JPG, WebP**) are acceptable within size and dimension constraints.
* Logos must be **uploaded**, not linked to external URLs.

### **2.2 Branding Elements (Shared Rules)**

Both Tenant and Module Branding support:

1. **Light Screen Logo**
2. **Dark Screen Logo**
3. **Default Handling:**

   * If only **one** logo is uploaded (typically the light version), it is treated as the **default**.
4. **Favicon**
5. **Primary Accent Colour**
6. **Secondary Colour**
7. **Typography Colour** (greyscale, used for headings/body text balance)

---

## **3. Tenant Branding**

### **3.1 Purpose**

Tenant Branding personalises the experience for **Client Users**, reflecting their organisation identity across:

* Module Home Pages
* Authentication screens (login, set/reset password, magic link pages)
* System-generated emails
* Tenant User dashboards

### **3.2 Branding Application Rules**

* **Tenant Branding supplements (not replaces) Module Branding** within the **Client Admin** world.
* **Tenant Branding replaces Module Branding** entirely in **Client User-facing screens** to create a white-label environment.
* Layout, UX patterns, and typography scale must respect IsoStack design standards.

### **3.3 Tenant Branding Configuration**

Accessible via:

```
Tenant > Settings > Branding
```

Tenant configuration includes:

* Uploading light/dark logos
* Uploading favicon
* Selecting colours
* Selecting typography shade
* Viewing their **dedicated Authentication URL**

### **3.4 Tenant Authentication URL**

Each Tenant receives a branded authentication endpoint:

```
/login?client={tenant_id}
```

This URL:

* Loads Tenant Branding
* Affects login, set-password, reset-password screens
* Passes branding into all Auth-related UI flows

---

## **4. Module Branding**

### **4.1 Purpose**

Module Branding defines:

* Default appearance for the module
* Marketing identity when the module is used standalone
* A consistent look for Platform Owners and multi-module tenants

### **4.2 Configuration**

Accessible through:

```
UI > Platform Management > Modules > [Module] > Settings Tab > Branding (Accordion)
```

Module Branding uses the **same asset and colour rules** as Tenant Branding.

### **4.3 Interaction with Tenant Branding**

* Module Branding is the **fallback** if Tenant Branding is disabled.
* Module Branding is shown to:

  * Platform Owners
  * Client Admins (alongside Tenant Branding)
* Module Branding is **not shown to Client Users** when Tenant Branding is active.

---

## **5. Brand Precedence Rules**

| Context                    | Branding Applied                                            |
| -------------------------- | ----------------------------------------------------------- |
| **Platform Owner UI**      | Module Branding                                             |
| **Client Admin UI**        | Module Branding + Tenant Branding (sympathetic combination) |
| **Client User UI**         | Tenant Branding replaces Module Branding                    |
| **Authentication Screens** | Tenant Branding (via tenant-branded login URL)              |
| **System Emails**          | Tenant Branding                                             |

---

## **6. Design Principles for AI**

When generating UI, documentation, or code:

* Always ensure logos are **uploaded** assets, not external URLs.
* Use **Tenant Branding** for any external-facing or white-label environment.
* Use **Module Branding** for internal or admin-level views.
* If only one logo exists, treat it as the **Light Screen Logo**.
* Typography colour should be applied as a **neutral grey scale**, not a feature or accent colour.
* Prioritise **simplicity, legibility, and contrast** across light/dark contexts.

