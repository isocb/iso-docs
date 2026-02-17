

# **Branding Architecture & Implementation**

*IsoStack — Technical Specification*  
**Status:** Implemented  
**Version:** 2.1.0  
**Last Updated:** February 2026

---

## **1. Overview**

IsoStack implements a **three-tier branding system** with Product-based feature controls:

1. **Platform Core Branding** – Platform Owner's IsoStack instance branding
2. **Module Branding** – Default branding for each module
3. **Organization Branding** – Client-specific branding (Custom Branding feature)

**Priority Order:** Custom Branding Organization > Module Branding > Platform Core Default

**Feature Access:** Custom Branding is granted via Products containing FeatureSets with `hasCustomBranding: true` (Professional and Enterprise tiers).

---

## **2. Current Implementation (Simplified)**

### **2.1 Asset Types**

**Single Logo Approach (Current):**
* **Logo** – Primary logo (stored as `lightLogoUrl` in database)
* **Favicon** – Browser tab icon (32x32 or 64x64, max 100KB)

**Database Fields (Reserved for Future):**
* `lightLogoUrl` – Currently used as primary logo
* `darkLogoUrl` – Reserved for future dark mode support
* `logo` – Deprecated field (backwards compatibility only)

### **2.2 Color Scheme**

All branding contexts support:
* **Primary Color** – Main brand color (#RRGGBB hex format)
* **Secondary Color** – Accent color (#RRGGBB hex format)  
* **Typography Color** – Text color (greyscale, #RRGGBB hex format)

### **2.3 Upload Constraints**

* **Logos:** Max 2MB, formats: PNG, JPG, WebP, SVG (preferred)
* **Favicon:** Max 100KB, recommended 32x32 or 64x64 pixels
* **Storage:** Cloudflare R2 with presigned URLs (1-hour expiry)
* **Path Structure:** `branding/{organizationId}/{assetType}-{timestamp}.{ext}`

---

## **3. Platform Core Branding**

### **3.1 Purpose**

Platform Core Branding defines the IsoStack Platform owner's brand identity.

### **3.2 Scope**

* **Visible To:** Platform Admins only (when in `/platform` scope)
* **Applies To:** 
  - Platform Manager header
  - Platform administration interfaces
  - Platform Owner context

### **3.3 Configuration**

**Access Path:**
```
/platform → Settings Tab → Branding Accordion → "All Modules" Selected
```

**Upload Interface:**
* Logo uploader (labeled "Logo")
* Favicon uploader
* Primary Color picker
* Secondary Color picker

**Technical Implementation:**
* Updates `Organization` table where `isAppOwner = true`
* tRPC Procedure: `branding.updatePlatformCoreBranding`
* Authorization: Requires entry in `PlatformAdmin` table + belongs to app owner organization

### **3.4 Database Storage**

```prisma
model Organization {
  isAppOwner: Boolean  // true for IsoStack Platform org
  lightLogoUrl: String?
  faviconUrl: String?
  primaryColor: String
  secondaryColor: String
  typographyColor: String
}
```

---

## **4. Module Branding**

### **4.1 Purpose**

Module Branding defines the default appearance for each module:
* Bedrock, API KeyChain, etc.
* Provides visual identity when Platform Owner manages modules
* Default branding inherited by organizations without White Label

### **4.2 Scope**

* **Visible To:** 
  - Platform Admins (module icon next to title in Platform Manager)
  - Standard organization users (in application header when module is active)
* **NOT Visible To:**
  - Platform Admins in header (always see Platform Core branding)
  - White Label organizations (their branding overrides module branding)

### **4.3 Configuration**

**Access Path:**
```
/platform → Module Selector → Select Module (e.g., "Bedrock") → Settings Tab → Branding Accordion
```

**Upload Interface:**
* Logo uploader (labeled "Logo")
* Favicon uploader
* Primary Color picker
* Secondary Color picker
* Typography Color picker

**Visual Cue:**
* Module logo displays next to "{Module} Management" title
* Provides contextual indication of which module's settings are being edited

**Technical Implementation:**
* Updates `module_catalogue` table (specific module row)
* tRPC Procedure: `modules.updateBranding`
* Authorization: Requires Platform Admin status
* Upload component prop: `moduleId={selectedModuleId}`

### **4.4 Database Storage**

```prisma
model ModuleCatalogue {
  id: String @id
  slug: String @unique  // "bedrock", "apikeychain"
  name: String
  lightLogoUrl: String?
  faviconUrl: String?
  primaryColor: String
  secondaryColor: String
  typographyColor: String
}
```

---

## **5. Organization Branding (Custom Branding)**

### **5.1 Feature Access**

**Custom Branding** is controlled via the Product system:

```
FeatureSet.hasCustomBranding: true
    ↓
ProductPackage (references FeatureSet)
    ↓
OrganizationProduct (ACTIVE or TRIAL)
    ↓
features.branding = true
    ↓
hasCustomBrandingFeature() returns true
```

**Feature Tiers:**
- **Starter:** `hasCustomBranding: false` - No custom branding
- **Professional:** `hasCustomBranding: true` - Full custom branding
- **Enterprise:** `hasCustomBranding: true` - Full custom branding

**Note:** White Label (custom domains) is deprecated and not currently offered. Custom Branding provides:
* Upload organization logo (light/dark mode) and favicon
* Customize primary, secondary, and typography colors
* Branded authentication URLs (`/auth/signin?org=<slug>`)
* Embeddable forms with tenant branding (`/embed/register/club?org=<slug>`)

### **5.2 Configuration**

**Access Path:**
```
/settings/branding  (Organization Settings)
```

**Feature Check:**
```typescript
import { hasCustomBrandingFeature } from '@/server/core/context';

// Check if organization has Custom Branding access
const hasBranding = await hasCustomBrandingFeature(organizationId);
```

### **5.3 Technical Implementation**

* Updates `Organization` table (current user's organization)
* tRPC Procedure: `branding.updateBranding`
* Authorization: Requires ADMIN or OWNER role + Custom Branding feature
* Feature validation via `hasCustomBrandingFeature()`

### **5.4 Database Storage**

```prisma
model Organization {
  lightLogoUrl: String?
  darkLogoUrl: String?
  faviconUrl: String?
  primaryColor: String?
  secondaryColor: String?
  accentColor: String?
  typographyColor: String?
  customAuthSlug: String?  // For branded auth URLs
}

model FeatureSet {
  hasCustomBranding: Boolean @default(false)  // Grants Custom Branding access
  // ... other feature flags
}
```
model Organization {
  lightLogoUrl: String?
  faviconUrl: String?
  primaryColor: String
  secondaryColor: String
  typographyColor: String
  customAuthSlug: String?  // White Label only
}

model FeatureFlag {
  organizationId: String
  featureSlug: String  // "customBranding" or "whiteLabel"
  enabled: Boolean
}
```

---

## **6. Branding Resolution Logic**

### **6.1 Priority Hierarchy**

Implemented in `src/lib/branding.ts` → `getActiveBranding()`:

```typescript
// 1. Platform Owner in /platform scope
if (isPlatformOwner && scope === 'platform') {
  return organizationBranding; // IsoStack Platform org
}

// 2. Custom Branding Organization (Professional/Enterprise)
if (await hasCustomBrandingFeature(organizationId)) {
  return organizationBranding; // Overrides module branding
}

// 3. Active Module Branding (Standard Clients)
if (activeModule) {
  return activeModule.branding; // From module_catalogue
}

// 4. Fallback to IsoStack Default
return defaultBranding;
```

### **6.2 Context-Specific Behavior**

| User Context | Scope | Header Logo Displayed |
|--------------|-------|----------------------|
| Platform Admin | `/platform` (All Modules) | Platform Core Logo |
| Platform Admin | `/platform` (Module Selected) | Platform Core Logo (NOT module logo) |
| Standard Org User | `/app` (Single Module) | Module Logo |
| Standard Org User | `/app` (Multi-Module) | Active Module Logo |
| Custom Branding Org User | `/app` | Organization Logo (overrides module) |

### **6.3 Module Logo Visual Cue**

In Platform Manager (`/platform/page.tsx`):
```typescript
const moduleLogo = currentModule?.lightLogoUrl || currentModule?.logo;
// Displays next to "{Module} Management" title
// Visual indicator of which module's settings are being configured
```

---

## **7. Upload Architecture**

### **7.1 Upload Flow**

1. **Client requests presigned URL** from `branding.getUploadUrl`
2. **Server generates presigned URL** (AWS S3 SDK for R2, 1-hour expiry)
3. **Client uploads directly to R2** (no server proxy)
4. **Client calls appropriate mutation** with public URL:
   - Platform Core: `updatePlatformCoreBranding`
   - Module: `updateModuleBranding` (with `moduleId`)
   - Organization: `updateBranding`

### **7.2 Component Architecture**

**BrandingAssetUploader Component:**
```typescript
<BrandingAssetUploader
  assetType="light-logo" | "favicon"
  currentUrl={existingUrl}
  onUploadComplete={setStateFunction}
  isPlatformCore={true}      // For Platform Core branding
  moduleId={moduleId}        // For Module branding
  // Neither flag = Organization branding
/>
```

**Mutation Selection Logic:**
```typescript
if (moduleId) {
  updateModuleBranding.mutateAsync({ id: moduleId, [field]: url });
} else if (isPlatformCore) {
  updatePlatformCoreBranding.mutateAsync({ [field]: url });
} else {
  updateBranding.mutateAsync({ [field]: url }); // Organization
}
```

### **7.3 Query Invalidation**

After successful upload:
* Platform Core → Invalidates `organizations.getCurrent`, `branding.getPlatformCoreBranding`
* Module → Invalidates `modules.getById`, `modules.listAll`
* Organization → Invalidates `organizations.getCurrent`, `branding.getBranding`

### **7.4 Preview Persistence**

`BrandingAssetUploader` uses `useEffect` to sync preview with `currentUrl` prop:
```typescript
useEffect(() => {
  setPreview(currentUrl || null);
}, [currentUrl]);
```

Ensures uploaded logos remain visible after page refresh.

---

## **8. Feature Implementation Status**

### **8.1 Completed (Phase 7)**

✅ Platform Core Branding
- Upload UI in Platform Manager
- Database updates to Organization table (isAppOwner=true)
- Header display integration
- Query caching and invalidation
- Upload persistence across page refreshes

✅ Module Branding
- Upload UI in Platform Manager (per-module)
- Database updates to module_catalogue table
- Module logo visual cue next to title
- Proper isolation (doesn't overwrite Platform Core)
- Upload persistence

✅ Upload Infrastructure
- R2 presigned URL generation
- Direct client-to-R2 uploads
- BrandingAssetUploader component
- File validation and error handling
- CORS configuration (GET, HEAD, PUT)

✅ Branding Resolution
- getActiveBranding() hierarchy logic
- useAppBranding() hook
- useBranding() hook (simplified to lightLogoUrl)
- Header integration

### **8.2 In Progress**

🚧 Organization Branding UI (Custom Branding / White Label)
- Upload interface at `/settings/branding`
- Feature flag checks in UI
- Admin/Owner role restrictions

### **8.3 Planned (Phase 8+)**

📋 Custom Domain Verification (White Label)
- DNS TXT record validation
- SSL certificate detection
- Admin approval workflow
- Domain management UI

📋 Branded Authentication (White Label)
- Custom /login routes with organization branding
- Auth callback handling
- Session preservation across custom domains

📋 Dynamic Favicon
- Inject favicon URL into document head
- Switch based on branding context

📋 Email Template Branding
- Resend template customization with organization logos/colors

---

## **9. Authorization Model**

### **9.1 Platform Admin Check**

**Current Implementation:**
```typescript
// useAppBranding.ts (temporary)
const isPlatformOwner = profile?.email === 'chris@isoblue.com';

// TODO: Replace with proper check
const isPlatformAdmin = await prisma.platformAdmin.findUnique({
  where: { userId: session.user.id }
});
const userOrg = await prisma.organization.findUnique({
  where: { id: session.user.organizationId }
});
if (!userOrg?.isAppOwner) throw FORBIDDEN;
```

**PlatformAdmin Table:**
```prisma
model PlatformAdmin {
  id: String @id
  userId: String @unique
  createdAt: DateTime
}
```

Platform Admin = Entry in `PlatformAdmin` table + belongs to organization where `isAppOwner=true`

### **9.2 Feature Flag Validation**

```typescript
// Check White Label feature
const features = await prisma.featureFlag.findMany({
  where: { 
    organizationId: user.organizationId,
    featureSlug: 'whiteLabel',
    enabled: true 
  }
});

const hasWhiteLabel = features.length > 0;
```

---

## **10. Design Principles**

### **10.1 Simplicity**
* Single logo field (lightLogoUrl) instead of complex light/dark switching
* Clear separation of contexts (Platform Core, Module, Organization)
* No nested branding hierarchies

### **10.2 Isolation**
* Platform Core branding stored separately from module branding
* Module branding stored per-row in module_catalogue
* Organization branding stored per-organization
* Upload mutations target correct table based on context

### **10.3 Performance**
* Direct R2 uploads (no server proxy)
* Query caching with strategic invalidation
* Presigned URLs expire after 1 hour (security)

### **10.4 User Experience**
* Upload preview updates immediately
* Logos persist after page refresh
* Clear visual indicators (module logo next to title)
* Platform Owner always sees Platform Core branding in header

---

## **11. AI Agent Development Notes**

### **11.1 Critical Rules**

1. **Never update organization branding when configuring modules**
   - Use `moduleId` prop to target module_catalogue table
   - Check `isModuleSpecific` before passing `moduleId`

2. **Platform Owner header always shows Platform Core branding**
   - Even when viewing/editing module settings
   - Module logos are for client users, not Platform Owner

3. **Upload persistence requires useEffect**
   - Sync preview state with currentUrl prop
   - Parent component must load query data into state

4. **Query invalidation is mandatory**
   - After every mutation that changes branding
   - Ensures Header sees updated logos

### **11.2 Testing Checklist**

**Platform Core Branding:**
- [ ] Upload logo as Platform Admin
- [ ] Verify database: Organization table (isAppOwner=true) has light_logo_url
- [ ] Refresh page → Logo still visible in upload area
- [ ] Check header → Platform Core logo displays
- [ ] Switch to module → Header STILL shows Platform Core logo

**Module Branding:**
- [ ] Select module in Platform Manager
- [ ] Upload module logo
- [ ] Verify database: module_catalogue table (specific module) has light_logo_url
- [ ] Refresh page → Logo still visible in upload area
- [ ] Check module visual cue → Logo displays next to "{Module} Management" title
- [ ] Switch to "All Modules" → Platform Core logo intact (not overwritten)

**Separation Verification:**
- [ ] Platform Core logo and Module logo are different images
- [ ] Uploading module logo does NOT change Platform Core logo
- [ ] Both logos persist independently across page refreshes

