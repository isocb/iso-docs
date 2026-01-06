# Module Catalogue Manager

## Overview

The Module Catalogue Manager is a platform administration tool for managing the available modules in IsoStack. It provides a UI for creating, editing, and deleting platform modules that appear throughout the system (client module assignment, issue tracking, feature bundles, etc.).

**Location:** Platform Management → Modules tab

**Access Level:** Platform Admins only

## Purpose

The Module Catalogue Manager maintains the master list of modules available in the IsoStack platform. This is distinct from:

- **Module table** - Used for tagging/categorization only (deprecated for platform modules)
- **ModuleCatalogue table** - Source of truth for platform modules (Bedrock, LMSPro, IsoCare, etc.)
- **FeatureFlag table** - Controls which modules are enabled per organization

## Architecture

### Database Schema

```prisma
model ModuleCatalogue {
  id              String   @id @default(cuid())
  slug            String   @unique // bedrock, lmspro, isocare, etc.
  name            String   // "Bedrock", "LMSPro", "IsoCare"
  description     String?
  icon            String   @default("IconPuzzle") // Tabler icon name
  logo            String?  // Optional logo URL
  lightLogoUrl    String?
  darkLogoUrl     String?
  primaryColor    String   @default("#228BE6")
  accentColor     String?
  userRoute       String?  // e.g., "/bedrock", "/lmspro"
  platformRoute   String?
  isCore          Boolean  @default(false)
  isEnabled       Boolean  @default(true)
  displayOrder    Int      @default(0)
  tags            String[] @default([])
  metadata        Json?
  version         String?
  minPlatformVersion String?
  
  createdAt       DateTime @default(now())
  updatedAt       DateTime @updatedAt
  
  // Relations
  featureFlags    FeatureFlag[]
  bundleModules   BundleModule[]
  issues          Issue[]
  // ... other relations
}
```

### tRPC Router

**Location:** `src/server/core/routers/module-catalogue.router.ts`

**Endpoints:**

```typescript
moduleCatalogue.listAll    // GET  - List all modules (platform admin only)
moduleCatalogue.create     // POST - Create new module (platform admin only)
moduleCatalogue.update     // PUT  - Update existing module (platform admin only)
moduleCatalogue.delete     // DEL  - Delete module (platform admin only)
```

**Authorization:** All endpoints require platform admin status verified via `PlatformAdmin` table.

### UI Component

**Location:** `src/app/(platform)/platform/_components/ModuleCatalogueTab.tsx`

**Features:**
- DataTable with sortable columns
- Inline edit actions
- Create/Edit modal with form validation
- Delete confirmation
- Color picker for primaryColor
- Real-time updates via tRPC

## Usage Guide

### Accessing the Manager

1. Navigate to **Platform Management** (`/platform`)
2. Click the **Modules** tab (between Features and Tooltips)
3. View the list of all platform modules

### Creating a New Module

1. Click the **+ Create Module** button (green, top-right)
2. Fill in the form:
   - **Slug** (required) - Unique identifier (e.g., `lmspro`, `support-tickets`)
   - **Name** (required) - Display name (e.g., "LMSPro", "Support Tickets")
   - **Description** (optional) - Brief description of the module
   - **Icon** (default: IconPuzzle) - Tabler icon name (e.g., `IconSchool`, `IconTicket`)
   - **Primary Color** (default: #228BE6) - Module brand color
   - **User Route** (optional) - Route path (e.g., `/lmspro`, `/support`)
3. Click **Save** to create the module

**UI Tags (Location Identifiers):**
- Form fields have ui-tags (`data-tooltip-target="platform.modules.create-modal.*"`) enabling tooltips and issue reporting

### Editing an Existing Module

1. Locate the module in the table
2. Click the **Edit** icon (pencil) in the Actions column
3. Modify the fields as needed
4. Click **Save** to update

**Note:** Editing a module does NOT affect existing client assignments or feature flags - it only updates the module definition.

### Deleting a Module

1. Locate the module in the table
2. Click the **Delete** icon (trash) in the Actions column
3. Confirm the deletion in the modal

**⚠️ Warning:** Deleting a module:
- Removes it from the module catalogue
- May break references in FeatureFlag, BundleModule, Issue tables
- Should only be done for test/unused modules
- Production modules should be disabled via `isEnabled` instead

### Module Properties

| Field | Purpose | Example |
|-------|---------|---------|
| **slug** | Unique identifier, used in code | `bedrock`, `lmspro`, `isocare` |
| **name** | User-facing display name | "Bedrock", "LMSPro", "IsoCare" |
| **description** | Brief explanation of module | "Core platform features" |
| **icon** | Tabler icon name | `IconDatabase`, `IconSchool` |
| **primaryColor** | Brand color (hex) | `#228BE6`, `#7950F2` |
| **userRoute** | User-facing route | `/bedrock`, `/lmspro` |
| **isCore** | Is this a core platform module? | `true` for Bedrock |
| **isEnabled** | Is module active? | `true` (visible), `false` (hidden) |
| **displayOrder** | Sort order in lists | `0`, `10`, `20` |

## Integration Points

### Issue Modal Module Dropdown

**File:** `src/server/actions/modules.ts`

The `getModules()` function queries `ModuleCatalogue` to populate the module dropdown in the Issue Modal:

```typescript
export async function getModules() {
  return await prisma.moduleCatalogue.findMany({
    where: { isEnabled: true },
    orderBy: { displayOrder: 'asc' },
    select: {
      id: true,
      slug: true,
      name: true,
      primaryColor: true,
      icon: true,
    },
  });
}
```

**Impact:** When you create/edit/delete modules in the Manager, the Issue Modal dropdown updates automatically.

### Client Module Assignment

**File:** `src/app/(platform)/platform/clients/[id]/_components/ClientModulesTab.tsx`

The Module Access Manager uses `ModuleCatalogue` to show available modules when assigning modules to clients.

### Feature Bundles

**File:** Bundle system queries `ModuleCatalogue` via `BundleModule` relation to show available modules for bundling.

## Common Tasks

### Add a New Production Module

1. **Design Phase:**
   - Choose a unique slug (e.g., `support-tickets`)
   - Select an appropriate Tabler icon
   - Define brand colors and routes
   
2. **Create in Manager:**
   - Use Module Catalogue Manager UI to create entry
   - Set `isEnabled: true`, `isCore: false`
   - Set appropriate `displayOrder`

3. **Seed Data (Optional):**
   - Add to `prisma/seed.ts` for reproducibility:
   ```typescript
   await prisma.moduleCatalogue.upsert({
     where: { slug: 'support-tickets' },
     update: {},
     create: {
       slug: 'support-tickets',
       name: 'Support Tickets',
       description: 'Customer support ticketing system',
       icon: 'IconTicket',
       primaryColor: '#FA5252',
       userRoute: '/support',
       isEnabled: true,
       displayOrder: 40,
     },
   });
   ```

4. **Verify Integration:**
   - Check Issue Modal dropdown shows new module
   - Test client module assignment
   - Verify feature bundle integration

### Temporarily Disable a Module

Instead of deleting, set `isEnabled: false`:

1. Edit the module in Manager
2. Toggle `isEnabled` to false (requires manual field if not in UI)
3. Module will be hidden from dropdowns but data remains intact

**Recommended:** Add an "Enabled" toggle to the UI form for this use case.

### Change Module Display Order

1. Edit each module
2. Set `displayOrder` values (0, 10, 20, 30, etc.)
3. Modules sort by `displayOrder` ASC in all dropdowns/lists

### Update Module Branding

1. Edit the module
2. Update `primaryColor` using color picker
3. Update `icon` to new Tabler icon name
4. Changes reflect immediately in UI

## Security & Permissions

### Platform Admin Only

All Module Catalogue Manager operations require:

1. **Authentication** - Valid NextAuth session
2. **Platform Admin** - Entry in `PlatformAdmin` table

**Verification logic:**
```typescript
const user = await ctx.prisma.user.findUnique({
  where: { id: ctx.session!.user.id },
  include: { platformAdmin: true },
});

if (!user?.platformAdmin) {
  throw new TRPCError({ code: 'FORBIDDEN', message: 'Platform admin only' });
}
```

### Regular Users

Regular organization admins/owners **cannot** access the Module Catalogue Manager. They can only:
- View modules assigned to their organization via `FeatureFlag`
- See modules in Issue Modal dropdown
- Assign modules to clients (if they have client management permissions)

## Troubleshooting

### Module Not Appearing in Issue Dropdown

**Check:**
1. Is `isEnabled: true`?
2. Is the module in `ModuleCatalogue` table (not old `Module` table)?
3. Browser cache cleared?
4. tRPC query invalidated after creation?

**Fix:**
- Verify in Prisma Studio (`npm run db:studio`)
- Check `moduleCatalogue` table has entry
- Restart dev server if needed

### "Platform admin only" Error

**Cause:** User is not in `PlatformAdmin` table

**Fix:**
```typescript
// Add user as platform admin in Prisma Studio or seed:
await prisma.platformAdmin.create({
  data: {
    userId: '<user-id>',
    permissions: { manage_modules: true },
  },
});
```

### Module Deletion Fails

**Cause:** Foreign key constraints (module referenced in other tables)

**Fix:**
- Check `FeatureFlag`, `BundleModule`, `Issue` tables for references
- Delete/reassign references first
- Or use `isEnabled: false` instead of deletion

### TypeScript Errors After Adding Module

**Cause:** Prisma Client not regenerated after schema changes

**Fix:**
```bash
npm run db:generate  # Regenerate Prisma Client
```

## Development Notes

### Adding New Fields to ModuleCatalogue

1. Update `prisma/schema.prisma`:
   ```prisma
   model ModuleCatalogue {
     // ... existing fields
     newField  String?
   }
   ```

2. Push schema change:
   ```bash
   npm run db:push
   npm run db:generate
   ```

3. Update tRPC router input schemas:
   ```typescript
   create: protectedProcedure
     .input(z.object({
       // ... existing fields
       newField: z.string().optional(),
     }))
   ```

4. Update UI form in `ModuleCatalogueTab.tsx`:
   ```tsx
   <TextInput
     label="New Field"
     value={formData.newField}
     onChange={(e) => setFormData({ ...formData, newField: e.target.value })}
     data-tooltip-target="platform.modules.create-modal.new-field"
   />
   ```

### Testing

**Manual Testing:**
1. Create a test module: `test-module-001`
2. Verify appears in Issue Modal dropdown
3. Edit the module, verify changes save
4. Delete the module, verify removed from dropdown

**Automated Testing (TODO):**
- Unit tests for tRPC router authorization
- Integration tests for CRUD operations
- E2E tests for UI workflows

## Integration with ProductPackage System

**As of January 2026:** ModuleCatalogue is the **master catalog** used by the ProductPackage access control system.

**How they work together:**
- ModuleCatalogue = Master list of available modules (this page)
- ProductPackage = Sellable combinations of modules + pricing (see `/docs/PRODUCT_ACCESS_CONTROL.md`)
- When P1 creates a product, they SELECT modules from ModuleCatalogue
- When product assigned to client, creates OrganisationModule records

**Key principle:** ModuleCatalogue is **platform-wide configuration**, ProductPackage is **client-specific access control**.

**No changes required to Module Manager** - it continues to serve as the source of truth for module metadata.

## Related Documentation

- [Product Access Control System](/docs/PRODUCT_ACCESS_CONTROL.md) ⭐ NEW
- [Module System Architecture](/docs/00-overview/architecture.md#module-system)
- [Feature Flags & Module Assignment](/docs/core/feature-flags.md)
- [Bundle System](/docs/core/bundles.md)
- [Platform Administration](/docs/guides/platform-admin.md)
- [Issue Tracking (IsoCare)](/docs/modules/isocare/ISOCARE_SPECIFICATION.md)

## Change History

| Date | Change | Author |
|------|--------|--------|
| 2026-01-05 | Initial implementation | System |
| 2026-01-05 | Documentation created | System |

---

**Status:** ✅ Production Ready  
**Last Updated:** 2026-01-05  
**Maintainer:** Platform Team
