# White Label Phase 7: Branding UI Implementation
**Date:** 7 December 2025  
**Status:** READY FOR IMPLEMENTATION  
**Priority:** HIGH  
**Estimated Time:** 6-8 hours

---

## Overview

Phase 7 builds the user interface for managing White Label branding, including:
- Logo upload (light/dark/favicon)
- Color picker for brand colors
- Typography color selection
- Custom auth slug configuration
- Real-time preview of branding changes

**Dependencies:**
- ✅ Phase 1-6 complete (database schema, middleware, feature flags)
- Cloudflare R2 configuration in `.env`
- File upload infrastructure (MediaFile model)

---

## Architecture

### Component Structure

```
src/
├── app/(app)/settings/
│   └── branding/
│       └── page.tsx          # Main branding settings page
├── components/settings/
│   ├── BrandingAssetUploader.tsx   # Logo upload component
│   ├── ColorPicker.tsx             # Color selection component
│   ├── BrandingPreview.tsx         # Live preview component
│   └── CustomAuthSlugInput.tsx     # Auth URL configuration
└── server/core/routers/
    └── branding.router.ts          # tRPC mutations for branding
```

---

## Phase 7.1: File Upload Infrastructure (2 hours)

### 7.1.1 Cloudflare R2 Upload Utility

**File:** `src/lib/r2.ts`

```typescript
import { S3Client, PutObjectCommand, DeleteObjectCommand } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';

const r2Client = new S3Client({
  region: 'auto',
  endpoint: process.env.CLOUDFLARE_R2_ENDPOINT,
  credentials: {
    accessKeyId: process.env.CLOUDFLARE_R2_ACCESS_KEY_ID!,
    secretAccessKey: process.env.CLOUDFLARE_R2_SECRET_ACCESS_KEY!,
  },
});

export type BrandingAssetType = 'light-logo' | 'dark-logo' | 'favicon';

/**
 * Generate presigned URL for client-side upload
 */
export async function getUploadUrl(
  organisationId: string,
  assetType: BrandingAssetType,
  fileExtension: string
): Promise<{ uploadUrl: string; publicUrl: string; key: string }> {
  const key = `branding/${organisationId}/${assetType}-${Date.now()}.${fileExtension}`;
  
  const command = new PutObjectCommand({
    Bucket: process.env.CLOUDFLARE_R2_BUCKET_NAME,
    Key: key,
    ContentType: getContentType(fileExtension),
  });

  const uploadUrl = await getSignedUrl(r2Client, command, { expiresIn: 3600 });
  
  // Public URL format for R2
  const publicUrl = `${process.env.CLOUDFLARE_R2_PUBLIC_URL}/${key}`;

  return { uploadUrl, publicUrl, key };
}

/**
 * Delete old branding asset from R2
 */
export async function deleteBrandingAsset(key: string): Promise<void> {
  const command = new DeleteObjectCommand({
    Bucket: process.env.CLOUDFLARE_R2_BUCKET_NAME,
    Key: key,
  });

  await r2Client.send(command);
}

function getContentType(extension: string): string {
  const types: Record<string, string> = {
    'png': 'image/png',
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'svg': 'image/svg+xml',
    'webp': 'image/webp',
    'ico': 'image/x-icon',
  };
  return types[extension.toLowerCase()] || 'application/octet-stream';
}
```

**Environment Variables Required:**
```env
CLOUDFLARE_R2_ENDPOINT=https://[account-id].r2.cloudflarestorage.com
CLOUDFLARE_R2_ACCESS_KEY_ID=your_access_key
CLOUDFLARE_R2_SECRET_ACCESS_KEY=your_secret_key
CLOUDFLARE_R2_BUCKET_NAME=isostack-assets
CLOUDFLARE_R2_PUBLIC_URL=https://assets.isostack.app
```

### 7.1.2 MediaFile Integration

Update `MediaFile` model to support branding assets:

```typescript
// Add to existing MediaFile model usage
const mediaFile = await prisma.mediaFile.create({
  data: {
    filename: `${assetType}.${extension}`,
    originalFilename: originalFilename,
    mimeType: contentType,
    size: fileSize,
    storageProvider: 'CLOUDFLARE_R2',
    storageKey: key,
    url: publicUrl,
    uploadedById: session.user.id,
    organizationId: organisationId,
  },
});

// Link to organization via MediaUsage
await prisma.mediaUsage.create({
  data: {
    mediaFileId: mediaFile.id,
    entityType: 'ORGANIZATION_BRANDING',
    entityId: organisationId,
    organizationId: organisationId,
  },
});
```

---

## Phase 7.2: tRPC Branding Router (1.5 hours)

**File:** `src/server/core/routers/branding.router.ts`

```typescript
import { z } from 'zod';
import { router, protectedProcedure } from '../trpc';
import { TRPCError } from '@trpc/server';
import { getUploadUrl, deleteBrandingAsset, type BrandingAssetType } from '@/lib/r2';
import { hasWhiteLabelFeature } from '../context';

export const brandingRouter = router({
  /**
   * Get presigned URL for logo upload
   */
  getUploadUrl: protectedProcedure
    .input(z.object({
      assetType: z.enum(['light-logo', 'dark-logo', 'favicon']),
      fileExtension: z.string(),
    }))
    .mutation(async ({ ctx, input }) => {
      const organisationId = ctx.session.user.organizationId;

      // Check White Label feature flag
      if (!await hasWhiteLabelFeature(organisationId)) {
        throw new TRPCError({
          code: 'FORBIDDEN',
          message: 'White Label feature not enabled for this organization',
        });
      }

      return await getUploadUrl(
        organisationId,
        input.assetType as BrandingAssetType,
        input.fileExtension
      );
    }),

  /**
   * Update organization branding after successful upload
   */
  updateBranding: protectedProcedure
    .input(z.object({
      lightLogoUrl: z.string().url().optional(),
      darkLogoUrl: z.string().url().optional(),
      faviconUrl: z.string().url().optional(),
      primaryColor: z.string().regex(/^#[0-9A-Fa-f]{6}$/).optional(),
      secondaryColor: z.string().regex(/^#[0-9A-Fa-f]{6}$/).optional(),
      typographyColor: z.string().regex(/^#[0-9A-Fa-f]{6}$/).optional(),
      customAuthSlug: z.string().regex(/^[a-z0-9-]+$/).optional().nullable(),
    }))
    .mutation(async ({ ctx, input }) => {
      const organisationId = ctx.session.user.organizationId;

      // Check White Label feature flag
      if (!await hasWhiteLabelFeature(organisationId)) {
        throw new TRPCError({
          code: 'FORBIDDEN',
          message: 'White Label feature not enabled',
        });
      }

      // Validate customAuthSlug is unique if provided
      if (input.customAuthSlug) {
        const existing = await ctx.prisma.organization.findFirst({
          where: {
            customAuthSlug: input.customAuthSlug,
            id: { not: organisationId },
          },
        });

        if (existing) {
          throw new TRPCError({
            code: 'CONFLICT',
            message: 'This custom auth slug is already in use',
          });
        }
      }

      const updated = await ctx.prisma.organization.update({
        where: { id: organisationId },
        data: {
          ...input,
        },
        select: {
          id: true,
          name: true,
          lightLogoUrl: true,
          darkLogoUrl: true,
          faviconUrl: true,
          primaryColor: true,
          secondaryColor: true,
          typographyColor: true,
          customAuthSlug: true,
        },
      });

      // Audit log
      await ctx.prisma.auditLog.create({
        data: {
          action: 'BRANDING_UPDATED',
          entityType: 'Organization',
          entityId: organisationId,
          metadata: input,
          userId: ctx.session.user.id,
          organizationId: organisationId,
        },
      });

      return updated;
    }),

  /**
   * Get current branding configuration
   */
  getBranding: protectedProcedure
    .query(async ({ ctx }) => {
      const organisationId = ctx.session.user.organizationId;

      const org = await ctx.prisma.organization.findUnique({
        where: { id: organisationId },
        select: {
          name: true,
          slug: true,
          lightLogoUrl: true,
          darkLogoUrl: true,
          faviconUrl: true,
          primaryColor: true,
          secondaryColor: true,
          typographyColor: true,
          customAuthSlug: true,
        },
      });

      if (!org) {
        throw new TRPCError({ code: 'NOT_FOUND' });
      }

      return org;
    }),

  /**
   * Delete branding asset
   */
  deleteAsset: protectedProcedure
    .input(z.object({
      assetType: z.enum(['light-logo', 'dark-logo', 'favicon']),
      storageKey: z.string(),
    }))
    .mutation(async ({ ctx, input }) => {
      const organisationId = ctx.session.user.organizationId;

      // Delete from R2
      await deleteBrandingAsset(input.storageKey);

      // Update database
      const field = input.assetType === 'light-logo' ? 'lightLogoUrl' :
                    input.assetType === 'dark-logo' ? 'darkLogoUrl' : 'faviconUrl';

      await ctx.prisma.organization.update({
        where: { id: organisationId },
        data: { [field]: null },
      });

      // Audit log
      await ctx.prisma.auditLog.create({
        data: {
          action: 'BRANDING_ASSET_DELETED',
          entityType: 'Organization',
          entityId: organisationId,
          metadata: { assetType: input.assetType },
          userId: ctx.session.user.id,
          organizationId: organisationId,
        },
      });
    }),
});
```

**Register Router:**
```typescript
// In src/server/core/routers/index.ts
import { brandingRouter } from './branding.router';

export const appRouter = router({
  // ... existing routers
  branding: brandingRouter,
});
```

---

## Phase 7.3: BrandingAssetUploader Component (2 hours)

**File:** `src/components/settings/BrandingAssetUploader.tsx`

```typescript
'use client';

import { useState } from 'react';
import { Stack, Text, Group, Button, Image, Paper, Alert } from '@mantine/core';
import { Dropzone, IMAGE_MIME_TYPE, FileWithPath } from '@mantine/dropzone';
import { IconUpload, IconX, IconPhoto, IconTrash } from '@tabler/icons-react';
import { trpc } from '@/lib/trpc/client';
import { notifications } from '@mantine/notifications';

type AssetType = 'light-logo' | 'dark-logo' | 'favicon';

interface BrandingAssetUploaderProps {
  assetType: AssetType;
  currentUrl?: string | null;
  onUploadComplete: (url: string) => void;
}

export function BrandingAssetUploader({
  assetType,
  currentUrl,
  onUploadComplete,
}: BrandingAssetUploaderProps) {
  const [uploading, setUploading] = useState(false);
  const [preview, setPreview] = useState<string | null>(currentUrl || null);

  const deleteAsset = trpc.branding.deleteAsset.useMutation({
    onSuccess: () => {
      setPreview(null);
      notifications.show({
        title: 'Success',
        message: 'Asset deleted successfully',
        color: 'green',
      });
    },
  });

  const handleDrop = async (files: FileWithPath[]) => {
    const file = files[0];
    if (!file) return;

    setUploading(true);

    try {
      // Get presigned upload URL from backend
      const extension = file.name.split('.').pop() || 'png';
      const { uploadUrl, publicUrl, key } = await trpc.branding.getUploadUrl.mutate({
        assetType,
        fileExtension: extension,
      });

      // Upload file directly to R2
      const uploadResponse = await fetch(uploadUrl, {
        method: 'PUT',
        body: file,
        headers: {
          'Content-Type': file.type,
        },
      });

      if (!uploadResponse.ok) {
        throw new Error('Upload failed');
      }

      // Update branding in database
      const field = assetType === 'light-logo' ? 'lightLogoUrl' :
                    assetType === 'dark-logo' ? 'darkLogoUrl' : 'faviconUrl';

      await trpc.branding.updateBranding.mutate({
        [field]: publicUrl,
      });

      setPreview(publicUrl);
      onUploadComplete(publicUrl);

      notifications.show({
        title: 'Success',
        message: `${getAssetLabel(assetType)} uploaded successfully`,
        color: 'green',
      });
    } catch (error) {
      notifications.show({
        title: 'Upload Failed',
        message: error instanceof Error ? error.message : 'Failed to upload asset',
        color: 'red',
      });
    } finally {
      setUploading(false);
    }
  };

  const handleDelete = async () => {
    if (!currentUrl) return;

    try {
      const key = currentUrl.split('/').slice(-3).join('/'); // Extract storage key
      await deleteAsset.mutateAsync({ assetType, storageKey: key });
      onUploadComplete('');
    } catch (error) {
      notifications.show({
        title: 'Delete Failed',
        message: 'Failed to delete asset',
        color: 'red',
      });
    }
  };

  const maxSize = assetType === 'favicon' ? 100 * 1024 : 2 * 1024 * 1024; // 100KB for favicon, 2MB for logos
  const recommendedSize = assetType === 'favicon' ? '32x32 or 64x64' :
                         assetType === 'light-logo' ? '200x60 (transparent PNG)' :
                         '200x60 (transparent PNG)';

  return (
    <Stack gap="sm">
      <Text size="sm" fw={500}>
        {getAssetLabel(assetType)}
      </Text>
      
      {preview ? (
        <Paper withBorder p="md">
          <Group justify="space-between">
            <Image
              src={preview}
              alt={getAssetLabel(assetType)}
              h={60}
              w="auto"
              fit="contain"
            />
            <Button
              leftSection={<IconTrash size={14} />}
              variant="light"
              color="red"
              size="sm"
              onClick={handleDelete}
              loading={deleteAsset.isPending}
            >
              Delete
            </Button>
          </Group>
        </Paper>
      ) : (
        <Dropzone
          onDrop={handleDrop}
          accept={IMAGE_MIME_TYPE}
          maxSize={maxSize}
          loading={uploading}
        >
          <Group justify="center" gap="xl" style={{ minHeight: 120, pointerEvents: 'none' }}>
            <Dropzone.Accept>
              <IconUpload size={50} stroke={1.5} />
            </Dropzone.Accept>
            <Dropzone.Reject>
              <IconX size={50} stroke={1.5} />
            </Dropzone.Reject>
            <Dropzone.Idle>
              <IconPhoto size={50} stroke={1.5} />
            </Dropzone.Idle>

            <div>
              <Text size="xl" inline>
                Drag image here or click to select
              </Text>
              <Text size="sm" c="dimmed" inline mt={7}>
                Recommended size: {recommendedSize}
              </Text>
              <Text size="xs" c="dimmed" inline mt={4}>
                Max file size: {maxSize / 1024 / 1024}MB
              </Text>
            </div>
          </Group>
        </Dropzone>
      )}

      <Alert color="blue" variant="light" style={{ fontSize: 12 }}>
        {assetType === 'favicon' && 'Upload a square .ico or .png file (32x32 or 64x64 pixels)'}
        {assetType === 'light-logo' && 'Upload a logo for light mode (transparent background recommended)'}
        {assetType === 'dark-logo' && 'Upload a logo for dark mode (transparent background recommended)'}
      </Alert>
    </Stack>
  );
}

function getAssetLabel(type: AssetType): string {
  const labels = {
    'light-logo': 'Light Mode Logo',
    'dark-logo': 'Dark Mode Logo',
    'favicon': 'Favicon',
  };
  return labels[type];
}
```

---

## Phase 7.4: Color Picker Component (1 hour)

**File:** `src/components/settings/ColorPicker.tsx`

```typescript
'use client';

import { useState } from 'react';
import { Stack, Text, Group, ColorInput, Button } from '@mantine/core';

interface ColorPickerProps {
  label: string;
  value: string;
  onChange: (value: string) => void;
  description?: string;
}

export function ColorPicker({ label, value, onChange, description }: ColorPickerProps) {
  const [localValue, setLocalValue] = useState(value);

  return (
    <Stack gap="xs">
      <ColorInput
        label={label}
        description={description}
        value={localValue}
        onChange={(val) => {
          setLocalValue(val);
          onChange(val);
        }}
        format="hex"
        swatches={[
          '#228be6',
          '#15aabf',
          '#1971c2',
          '#495057',
          '#fa5252',
          '#fd7e14',
          '#fab005',
          '#40c057',
          '#be4bdb',
        ]}
      />
    </Stack>
  );
}
```

---

## Phase 7.5: Branding Settings Page (1.5 hours)

**File:** `src/app/(app)/settings/branding/page.tsx`

```typescript
'use client';

import { Container, Stack, Title, Text, Divider, Button, Group, Paper, SimpleGrid } from '@mantine/core';
import { IconDeviceFloppy } from '@tabler/icons-react';
import { BrandingAssetUploader } from '@/components/settings/BrandingAssetUploader';
import { ColorPicker } from '@/components/settings/ColorPicker';
import { trpc } from '@/lib/trpc/client';
import { notifications } from '@mantine/notifications';
import { useState, useEffect } from 'react';

export default function BrandingSettingsPage() {
  const { data: branding, isLoading } = trpc.branding.getBranding.useQuery();
  const updateBranding = trpc.branding.updateBranding.useMutation();

  const [lightLogo, setLightLogo] = useState('');
  const [darkLogo, setDarkLogo] = useState('');
  const [favicon, setFavicon] = useState('');
  const [primaryColor, setPrimaryColor] = useState('#228be6');
  const [secondaryColor, setSecondaryColor] = useState('#15aabf');
  const [typographyColor, setTypographyColor] = useState('#495057');

  useEffect(() => {
    if (branding) {
      setLightLogo(branding.lightLogoUrl || '');
      setDarkLogo(branding.darkLogoUrl || '');
      setFavicon(branding.faviconUrl || '');
      setPrimaryColor(branding.primaryColor);
      setSecondaryColor(branding.secondaryColor);
      setTypographyColor(branding.typographyColor);
    }
  }, [branding]);

  const handleSave = async () => {
    try {
      await updateBranding.mutateAsync({
        primaryColor,
        secondaryColor,
        typographyColor,
      });

      notifications.show({
        title: 'Success',
        message: 'Branding colors updated successfully',
        color: 'green',
      });
    } catch (error) {
      notifications.show({
        title: 'Error',
        message: 'Failed to update branding colors',
        color: 'red',
      });
    }
  };

  if (isLoading) {
    return <Container><Text>Loading...</Text></Container>;
  }

  return (
    <Container size="lg" py="xl">
      <Stack gap="xl">
        <div>
          <Title order={2}>White Label Branding</Title>
          <Text c="dimmed" size="sm">
            Customize your organization's branding with custom logos and colors
          </Text>
        </div>

        <Divider />

        {/* Logo Uploads */}
        <Paper withBorder p="xl">
          <Stack gap="xl">
            <Title order={3}>Brand Assets</Title>

            <SimpleGrid cols={{ base: 1, md: 2 }}>
              <BrandingAssetUploader
                assetType="light-logo"
                currentUrl={lightLogo}
                onUploadComplete={setLightLogo}
              />

              <BrandingAssetUploader
                assetType="dark-logo"
                currentUrl={darkLogo}
                onUploadComplete={setDarkLogo}
              />
            </SimpleGrid>

            <BrandingAssetUploader
              assetType="favicon"
              currentUrl={favicon}
              onUploadComplete={setFavicon}
            />
          </Stack>
        </Paper>

        {/* Color Configuration */}
        <Paper withBorder p="xl">
          <Stack gap="md">
            <Title order={3}>Brand Colors</Title>

            <SimpleGrid cols={{ base: 1, md: 3 }}>
              <ColorPicker
                label="Primary Color"
                description="Main brand color"
                value={primaryColor}
                onChange={setPrimaryColor}
              />

              <ColorPicker
                label="Secondary Color"
                description="Accent color"
                value={secondaryColor}
                onChange={setSecondaryColor}
              />

              <ColorPicker
                label="Typography Color"
                description="Text color"
                value={typographyColor}
                onChange={setTypographyColor}
              />
            </SimpleGrid>

            <Group justify="flex-end" mt="md">
              <Button
                leftSection={<IconDeviceFloppy size={16} />}
                onClick={handleSave}
                loading={updateBranding.isPending}
              >
                Save Colors
              </Button>
            </Group>
          </Stack>
        </Paper>
      </Stack>
    </Container>
  );
}
```

---

## Testing Checklist

### Unit Tests
- [ ] R2 upload URL generation
- [ ] File type validation
- [ ] Color hex validation
- [ ] Custom auth slug uniqueness

### Integration Tests
- [ ] Upload logo → verify in database
- [ ] Update colors → verify in database
- [ ] Delete asset → verify removed from R2 and database
- [ ] Feature flag check → deny if not enabled

### Manual Tests
- [ ] Upload light logo (PNG with transparency)
- [ ] Upload dark logo (PNG with transparency)
- [ ] Upload favicon (ICO or PNG 32x32)
- [ ] Change all three colors
- [ ] Delete uploaded logo
- [ ] Try uploading oversized file (should reject)
- [ ] Try uploading wrong format (should reject)

---

## Success Criteria

✅ Logo upload works for all three asset types  
✅ Uploaded assets appear in organization branding  
✅ Color changes save and persist  
✅ Preview shows uploaded logos  
✅ Delete removes asset from R2 and database  
✅ Feature flag properly restricts access  
✅ Audit logs created for branding changes  

---

## Next Steps

After Phase 7 completion:
- **Phase 8:** Custom domain verification workflow
- **Phase 9:** Branded authentication pages
- **Future:** Live preview of branding in iframe
