# Branding Gap Analysis & Implementation Plan

**Date:** 7 December 2025  
**Status:** Gap Analysis Complete  
**Priority:** HIGH - Required for multi-tenant project completion

---

## Executive Summary

The `branding.md` specification defines a comprehensive dual-branding system (**Tenant Branding** + **Module Branding**) with strict asset requirements (SVG uploads, light/dark logos, favicons, color schemes). However, the current implementation in `multi-tenant-project.md` and the codebase has significant gaps:

### Critical Gaps Identified:
1. ❌ **Database schema missing required branding fields** (light/dark logos, favicon, typography color)
2. ❌ **No file upload UI** for logo/favicon management
3. ❌ **Tenant-specific authentication URLs** not implemented (`/login?client={tenant_id}`)
4. ❌ **Module branding UI** not accessible via Platform Management
5. ❌ **Branding precedence rules** not enforced in AppShell
6. ⚠️ **Settings tab UI exists but not connected** to real save mutations

### What Exists:
✅ Cloudflare R2 infrastructure (file storage ready)  
✅ `MediaFile` model for tracking uploads  
✅ Basic color fields in `Organisation` and `ModuleCatalogue`  
✅ Settings tab UI in Client Detail View  
✅ `uploadToR2()` utility function  

---

## Part A: Missing from Multi-Tenant Project

### 1. Branding System Architecture (Not Documented)

**Gap:** The multi-tenant project doc mentions branding superficially but doesn't define:
- How Tenant Branding overrides Module Branding for Client Users
- The two-tier branding system (Tenant supplements vs. replaces Module)
- Tenant-specific authentication URL pattern
- Branding asset upload workflows

**Required Addition to `multi-tenant-project.md`:**

```markdown
### Phase 6.5 – Branding System Implementation

**Dual Branding Architecture:**
- **Module Branding** = Default identity for each module
  - Configurable via Platform Management → Modules → [Module] → Settings → Branding
  - Visible to Platform Owners and Client Admins
- **Tenant Branding** = White-label customization for Client Users
  - Configurable via Tenant Settings → Branding
  - Overrides Module Branding in Client User contexts
  - Enables tenant-specific auth URLs: `/login?client={tenant_id}`

**Branding Precedence Rules:**
| Context | Branding Applied |
|---------|------------------|
| Platform Owner | Module Branding only |
| Client Admin | Module Branding + Tenant Branding (sympathetic) |
| Client User | Tenant Branding replaces Module Branding |
| Auth Screens | Tenant Branding (via `/login?client={tenant_id}`) |
| System Emails | Tenant Branding |

**Asset Requirements:**
- Light Screen Logo (SVG preferred, PNG/JPG/WebP accepted)
- Dark Screen Logo (optional, falls back to light if not provided)
- Favicon (ICO or PNG)
- Primary Accent Color
- Secondary Color
- Typography Color (greyscale)

**Implementation Tasks:**
1. Extend database schema for dual logo support
2. Build file upload UI in Settings tabs
3. Implement tenant-branded auth URL routing
4. Update AppShell branding resolver to apply precedence rules
5. Add branding to system email templates
```

### 2. Feature Flag Dependency (Branding as Optional Feature)

**Gap:** `branding.md` states branding is "feature-flag controlled" but the multi-tenant project doesn't define:
- Which feature set enables Tenant Branding (Professional? Enterprise?)
- Whether Module Branding is always available or gated
- How branding UI visibility is controlled

**Required Addition:**

```markdown
**Feature Set: Branding Capabilities**
- **Starter:** No custom branding (uses default Module Branding)
- **Professional:** Tenant Branding enabled (logo, colors only)
- **Enterprise:** Full Tenant Branding (dual logos, favicon, typography, auth URLs)

Module Branding is **always available** to Platform Owners for module configuration.
```

### 3. Tenant Authentication URL System

**Gap:** `branding.md` specifies `/login?client={tenant_id}` for branded auth flows, but:
- Not mentioned in multi-tenant project phases
- No implementation defined for passing tenant context through auth screens
- No UI for tenants to copy/share their branded auth URL

**Required Addition:**

```markdown
### Phase 7.5 – Tenant-Branded Authentication

**Tenant Auth URL Pattern:**
- Each tenant receives: `/login?client={tenant_slug_or_id}`
- Auth middleware detects `?client=` param and loads Tenant Branding
- Applies to: login, set-password, reset-password, magic-link screens

**Tenant Settings UI:**
- Display branded auth URL in Tenant Settings → Branding
- Copy-to-clipboard button
- QR code generator for mobile access (future)

**Implementation:**
1. Update auth middleware to detect `?client=` param
2. Create branding context provider for auth layouts
3. Add branded URL display to Tenant Settings
4. Update NextAuth callbacks to preserve tenant context
```

---

## Part B: Work Required to Comply with Branding Spec

### Database Schema Updates

**Current State:**
```prisma
// Organisation model
logoUrl        String?  // ❌ Single logo only
primaryColor   String @default("#228be6")
secondaryColor String @default("#15aabf")
// ❌ Missing: favicon, lightLogo, darkLogo, typographyColor

// ModuleCatalogue model
logo           String? // ❌ Single logo only
primaryColor   String  @default("#228BE6")
secondaryColor String  @default("#15AABF")
// ❌ Missing: favicon, lightLogo, darkLogo, typographyColor
```

**Required Changes:**

```prisma
model Organisation {
  // ... existing fields ...

  // Branding (updated to match branding.md spec)
  lightLogoUrl    String? @map("light_logo_url")
  darkLogoUrl     String? @map("dark_logo_url")
  faviconUrl      String? @map("favicon_url")
  primaryColor    String  @default("#228be6") @map("primary_color")
  secondaryColor  String  @default("#15aabf") @map("secondary_color")
  typographyColor String  @default("#495057") @map("typography_color") // Greyscale
  
  // Deprecated - keep for migration
  logoUrl         String? @map("logo_url") // TODO: Migrate to lightLogoUrl
  
  // Tenant-specific auth URL
  customAuthSlug  String? @unique @map("custom_auth_slug") // For /login?client={slug}
  
  // ... rest of model ...
}

model ModuleCatalogue {
  // ... existing fields ...
  
  // Module branding (updated to match branding.md spec)
  lightLogoUrl    String? @map("light_logo_url")
  darkLogoUrl     String? @map("dark_logo_url")
  faviconUrl      String? @map("favicon_url")
  primaryColor    String  @default("#228BE6") @map("primary_color")
  secondaryColor  String  @default("#15AABF") @map("secondary_color")
  typographyColor String  @default("#495057") @map("typography_color")
  
  // Deprecated - keep for migration
  logo            String? // TODO: Migrate to lightLogoUrl
  
  // ... rest of model ...
}
```

**Migration Strategy:**
1. Add new fields with `@map()` to avoid breaking existing `logoUrl` references
2. Create data migration script to copy `logoUrl` → `lightLogoUrl`
3. Update all code references gradually
4. Mark `logoUrl` as deprecated in JSDoc comments
5. Remove `logoUrl` in future major version

### File Upload UI Components

**Required Components:**

#### 1. `BrandingAssetUploader.tsx` (Reusable)
```tsx
/**
 * Reusable branding asset uploader
 * Handles: Logo (light/dark), Favicon uploads to R2
 * Validates: File type (SVG, PNG, JPG, WebP, ICO), size limits
 * Features: Preview, drag-and-drop, crop/resize (future)
 */
interface BrandingAssetUploaderProps {
  label: string;
  assetType: 'lightLogo' | 'darkLogo' | 'favicon';
  currentUrl?: string;
  onUpload: (url: string) => void;
  organizationId: string;
  acceptedFormats?: string[]; // Default: ['.svg', '.png', '.jpg', '.webp']
  maxSizeMB?: number; // Default: 2MB
}
```

**Features:**
- SVG preview with proper rendering
- Fallback image preview for raster formats
- Drag-and-drop zone
- File validation (type, size, dimensions)
- Upload progress indicator
- Delete existing asset
- "Use as Dark Logo" quick action (copies light → dark)

#### 2. Update `ClientSettingsTab.tsx`

**Current State:** Basic text input for `logoUrl`

**Required Changes:**
```tsx
<Stack gap="md">
  <Title order={4}>Branding</Title>
  <Text size="sm" c="dimmed">
    Customize the appearance for this client. SVG format recommended.
  </Text>

  {/* Basic Info */}
  <TextInput label="Organization Name" ... />
  <TextInput label="Slug" ... />

  {/* Logo Uploads */}
  <BrandingAssetUploader
    label="Light Screen Logo"
    assetType="lightLogo"
    currentUrl={organization.lightLogoUrl || organization.logoUrl}
    onUpload={(url) => handleBrandingUpdate({ lightLogoUrl: url })}
    organizationId={organization.id}
  />

  <BrandingAssetUploader
    label="Dark Screen Logo (Optional)"
    assetType="darkLogo"
    currentUrl={organization.darkLogoUrl}
    onUpload={(url) => handleBrandingUpdate({ darkLogoUrl: url })}
    organizationId={organization.id}
  />

  <BrandingAssetUploader
    label="Favicon"
    assetType="favicon"
    currentUrl={organization.faviconUrl}
    onUpload={(url) => handleBrandingUpdate({ faviconUrl: url })}
    organizationId={organization.id}
    acceptedFormats={['.ico', '.png']}
    maxSizeMB={0.5}
  />

  {/* Colors */}
  <Group grow>
    <ColorInput label="Primary Color" ... />
    <ColorInput label="Secondary Color" ... />
    <ColorInput 
      label="Typography Color" 
      description="Greyscale only (for text contrast)"
      defaultValue={organization.typographyColor}
    />
  </Group>

  {/* Branded Auth URL */}
  <Card withBorder padding="sm" bg="gray.0">
    <Stack gap="xs">
      <Text size="sm" fw={500}>Branded Authentication URL</Text>
      <Group>
        <TextInput
          readOnly
          value={`${window.location.origin}/login?client=${organization.slug}`}
          style={{ flex: 1 }}
        />
        <Button 
          variant="light" 
          leftSection={<IconCopy size={14} />}
          onClick={copyToClipboard}
        >
          Copy
        </Button>
      </Group>
    </Stack>
  </Card>

  {/* Save Actions */}
  <Group justify="flex-end">
    <Button variant="default">Reset</Button>
    <Button onClick={saveBrandingChanges}>Save Changes</Button>
  </Group>
</Stack>
```

#### 3. Create Module Branding UI

**Location:** Platform Management → Settings Tab → Branding Accordion (per branding.md)

**New File:** `src/app/(platform)/platform/_components/ModuleBrandingSection.tsx`

```tsx
/**
 * Module Branding Configuration
 * Accessible to Platform Owners only
 * Allows uploading logos, colors for each module
 */
export function ModuleBrandingSection({ moduleId, module }) {
  return (
    <Accordion.Item value="branding">
      <Accordion.Control>Branding</Accordion.Control>
      <Accordion.Panel>
        <Stack gap="md">
          {/* Same UI as ClientSettingsTab branding section */}
          <BrandingAssetUploader ... />
          <ColorInput ... />
          {/* No branded auth URL for modules */}
        </Stack>
      </Accordion.Panel>
    </Accordion.Item>
  );
}
```

### Backend: tRPC Mutations

**Required Endpoints:**

#### 1. File Upload Endpoint
```typescript
// src/server/core/routers/media.router.ts
export const mediaRouter = router({
  uploadBrandingAsset: protectedProcedure
    .input(z.object({
      file: z.string(), // Base64 encoded file
      fileName: z.string(),
      assetType: z.enum(['lightLogo', 'darkLogo', 'favicon']),
      targetType: z.enum(['organization', 'module']),
      targetId: z.string(),
    }))
    .mutation(async ({ ctx, input }) => {
      // 1. Validate file type and size
      // 2. Convert base64 to Buffer
      // 3. Upload to R2 using uploadToR2()
      // 4. Create MediaFile record
      // 5. Return public URL
      // 6. Log to audit trail
    }),
});
```

#### 2. Branding Update Endpoint
```typescript
// src/server/core/routers/organizations.router.ts
export const organizationsRouter = router({
  updateBranding: requireRole([Role.OWNER])
    .input(z.object({
      organizationId: z.string(),
      lightLogoUrl: z.string().url().optional(),
      darkLogoUrl: z.string().url().optional(),
      faviconUrl: z.string().url().optional(),
      primaryColor: z.string().regex(/^#[0-9A-F]{6}$/i).optional(),
      secondaryColor: z.string().regex(/^#[0-9A-F]{6}$/i).optional(),
      typographyColor: z.string().regex(/^#[0-9A-F]{6}$/i).optional(),
    }))
    .mutation(async ({ ctx, input }) => {
      // 1. Check permissions
      // 2. Update organization record
      // 3. Invalidate branding cache
      // 4. Log to audit trail
    }),
});
```

#### 3. Module Branding Endpoint
```typescript
// src/server/core/routers/modules.router.ts
export const modulesRouter = router({
  updateModuleBranding: requirePlatformAdmin()
    .input(z.object({
      moduleId: z.string(),
      // Same branding fields as organization
    }))
    .mutation(async ({ ctx, input }) => {
      // Similar to updateBranding but for ModuleCatalogue
    }),
});
```

### Frontend: Branding Context & Resolution

**Current Gap:** Branding is partially implemented in `useAppBranding()` but doesn't follow branding.md precedence rules.

**Required Updates:**

#### 1. Enhanced Branding Hook
```typescript
// src/core/hooks/useAppBranding.ts
interface BrandingAssets {
  logo: string; // Selected from light/dark based on color scheme
  lightLogo?: string;
  darkLogo?: string;
  favicon?: string;
  primaryColor: string;
  secondaryColor: string;
  typographyColor: string;
}

export function useAppBranding(): BrandingAssets {
  const session = useSession();
  const { colorScheme } = useMantineColorScheme();
  const activeModule = useActiveModule();
  
  // Apply branding.md precedence rules:
  // 1. Platform Owner in /platform → IsoStack Core branding
  if (isPlatformOwner && scope === 'platform') {
    return CORE_BRANDING;
  }
  
  // 2. Client User → Tenant Branding (overrides module)
  if (scope === 'app' && !isAdmin) {
    const tenantBranding = getTenantBranding(session.user.organizationId);
    if (tenantBranding?.hasCustomBranding) {
      return resolveBranding(tenantBranding, colorScheme);
    }
  }
  
  // 3. Client Admin → Module Branding + Tenant Branding (sympathetic)
  if (scope === 'tenant' || (scope === 'app' && isAdmin)) {
    const moduleBranding = getModuleBranding(activeModule);
    const tenantBranding = getTenantBranding(session.user.organizationId);
    return blendBranding(moduleBranding, tenantBranding, colorScheme);
  }
  
  // 4. Default → Active Module Branding
  return resolveBranding(activeModule.branding, colorScheme);
}

function resolveBranding(branding: any, colorScheme: string): BrandingAssets {
  return {
    logo: colorScheme === 'dark' 
      ? (branding.darkLogoUrl || branding.lightLogoUrl || branding.logo)
      : (branding.lightLogoUrl || branding.logo),
    lightLogo: branding.lightLogoUrl || branding.logo,
    darkLogo: branding.darkLogoUrl,
    favicon: branding.faviconUrl,
    primaryColor: branding.primaryColor,
    secondaryColor: branding.secondaryColor,
    typographyColor: branding.typographyColor || '#495057',
  };
}
```

#### 2. Authentication Layout with Tenant Branding
```typescript
// src/app/(auth)/login/page.tsx
export default async function LoginPage({ searchParams }: { searchParams: { client?: string } }) {
  const tenantBranding = searchParams.client 
    ? await getTenantBrandingBySlug(searchParams.client)
    : null;
  
  return (
    <BrandingProvider branding={tenantBranding}>
      <AuthLayout>
        <LoginForm />
      </AuthLayout>
    </BrandingProvider>
  );
}
```

### System Emails with Branding

**Required:** Update email templates to use Tenant Branding

```typescript
// src/lib/email/templates/WelcomeEmail.tsx
import { getTenantBranding } from '@/lib/branding';

export async function WelcomeEmail({ userId }: { userId: string }) {
  const user = await prisma.user.findUnique({ where: { id: userId }, include: { organization: true } });
  const branding = await getTenantBranding(user.organizationId);
  
  return (
    <Html>
      <Head>
        <link rel="icon" href={branding.favicon} />
      </Head>
      <Body>
        <Img src={branding.logo} alt="Logo" width={120} />
        <Heading style={{ color: branding.primaryColor }}>
          Welcome to {user.organization.name}!
        </Heading>
        {/* ... */}
      </Body>
    </Html>
  );
}
```

---

## Implementation Phases

### Phase 1: Database & Schema (2-3 hours)
- [ ] Update `Organisation` model with new branding fields
- [ ] Update `ModuleCatalogue` model with new branding fields
- [ ] Create migration script
- [ ] Run migration on dev database
- [ ] Test in Prisma Studio

### Phase 2: File Upload Infrastructure (4-6 hours)
- [ ] Create `BrandingAssetUploader` component
- [ ] Add file validation utilities (type, size, dimensions)
- [ ] Create tRPC `media.uploadBrandingAsset` endpoint
- [ ] Add upload progress tracking
- [ ] Test SVG and raster uploads to R2

### Phase 3: UI Integration (6-8 hours)
- [ ] Update `ClientSettingsTab` with new branding UI
- [ ] Add branded auth URL display and copy functionality
- [ ] Create `ModuleBrandingSection` for Platform Settings
- [ ] Add branding preview component (shows how it will look)
- [ ] Connect save buttons to real mutations

### Phase 4: Backend Mutations (3-4 hours)
- [ ] Implement `organizations.updateBranding` mutation
- [ ] Implement `modules.updateModuleBranding` mutation
- [ ] Add audit logging for all branding changes
- [ ] Add permission checks (Tenant Admin for org, Platform Admin for modules)

### Phase 5: Branding Resolution (4-6 hours)
- [ ] Enhance `useAppBranding()` hook with precedence rules
- [ ] Update AppShell to use light/dark logo switching
- [ ] Implement `blendBranding()` for Client Admin views
- [ ] Add favicon injection based on active branding
- [ ] Test branding switching between modules

### Phase 6: Tenant Auth URLs (3-4 hours)
- [ ] Update auth middleware to detect `?client=` param
- [ ] Create `BrandingProvider` for auth layouts
- [ ] Update all auth pages (login, signup, reset-password)
- [ ] Test branded auth flow end-to-end

### Phase 7: Email Templates (2-3 hours)
- [ ] Update all email templates with branding support
- [ ] Add logo and color injection
- [ ] Test email rendering with different brandings

### Phase 8: Testing & Documentation (4-6 hours)
- [ ] Test single vs multi-module branding
- [ ] Test light/dark logo switching
- [ ] Test tenant-branded auth URLs
- [ ] Document branding upload process for users
- [ ] Create video tutorial (optional)

**Total Estimated Time:** 28-40 hours (3.5 - 5 days)

---

## Success Criteria

✅ **Schema Compliance**
- All branding fields from branding.md spec present in database
- Light/dark logos supported with proper fallback logic

✅ **Upload Workflow**
- Platform Owners can upload module branding via Settings tab
- Tenant Admins can upload tenant branding via Tenant Settings
- SVG files preferred, raster formats accepted with validation

✅ **Branding Precedence**
- Platform Owner in `/platform` → IsoStack Core branding
- Client Admin → Module + Tenant branding (sympathetic blend)
- Client User → Tenant branding only (module hidden)

✅ **Tenant Auth URLs**
- Each tenant has `/login?client={slug}` with their branding
- Auth URL displayed in Tenant Settings with copy button
- Branding persists through entire auth flow

✅ **Visual Consistency**
- Light/dark mode logo switching works seamlessly
- Favicon updates based on active branding
- Colors applied consistently via CSS variables
- System emails use tenant branding

---

## Risk Mitigation

**Risk:** Existing `logoUrl` references break during migration  
**Mitigation:** Use `@map()` to keep old column, create data migration, deprecate gradually

**Risk:** Large file uploads timeout  
**Mitigation:** Client-side compression, chunk uploads (future), 2MB limit enforced

**Risk:** SVG security vulnerabilities  
**Mitigation:** Server-side SVG sanitization, strip `<script>` tags, validate XML structure

**Risk:** Branding cache invalidation issues  
**Mitigation:** Use tRPC query invalidation, add versioning to branding URLs (`?v={timestamp}`)

**Risk:** Multi-module branding conflicts  
**Mitigation:** Clear precedence rules documented, visual preview before save

---

## Next Steps

1. **Prioritize based on MVP timeline:** If branding is critical for launch, start Phase 1-3 immediately
2. **Assign ownership:** Determine who implements backend vs frontend
3. **Create sub-tasks:** Break phases into smaller tickets in project management tool
4. **Set deadline:** Based on multi-tenant project MVP date (5 Dec 2025 - already passed, needs update)
5. **Communication:** Update stakeholders on branding implementation timeline

---

**Document Status:** Ready for review and approval  
**Next Action:** Review with team, prioritize phases, assign tasks
