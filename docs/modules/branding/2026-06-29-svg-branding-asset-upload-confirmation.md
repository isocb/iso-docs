# SVG Branding Asset Upload Confirmation

Date: 2026-06-29

Status: Implemented on dev branch, pending review/commit

## Goal

Enable SVG uploads for IsoStack branding assets while keeping SVG blocked for general media uploads.

## Scope

This is a platform branding remediation used by:

- P1 Platform Core / app branding;
- P1 module branding;
- tenant organization branding;
- logo, dark logo, favicon and email letterhead branding assets.

## Implementation Summary

The branding uploader now explicitly accepts SVG files for branding assets.

The upload API now permits `image/svg+xml` only for exact branding upload folders:

```text
branding/light-logo
branding/dark-logo
branding/favicon
branding/email-letterhead
```

General uploads do not receive broad SVG permission.

SVG files bypass raster image normalisation so they remain vector files.

Branding upload size limits are enforced server-side:

- logos and email letterhead: 2MB;
- favicon: 100KB.

## Files Changed

App repo:

- `src/components/settings/BrandingAssetUploader.tsx`
- `src/app/api/upload/route.ts`
- `docs/2026-IsoStack-Docs/Core/branding/branding.md`

Docs repo:

- `docs/modules/branding/2026-06-29-svg-branding-asset-upload-confirmation.md`

## Explicit Boundaries

No changes were made to:

- Prisma schema;
- migrations;
- database;
- R2 storage model;
- authentication;
- tenant scoping;
- branding database fields;
- FUND application code;
- Project Intake schema;
- services or routers outside the upload API.

No `db:push`, seed or reset commands were run.

## Checks

Completed:

```text
npm run type-check
npm run verify
git diff --check
```

Results:

- `npm run type-check` passed.
- `npm run verify` initially hit the known sandbox IPC restriction from `tsx`; rerun outside the sandbox passed.
- `git diff --check` passed.

## Review Checklist

Before promotion:

1. Upload an SVG tenant logo through `/settings/branding`.
2. Upload an SVG favicon through `/settings/branding`.
3. Upload an SVG P1 Platform Core logo through Platform settings.
4. Upload an SVG module logo through Platform module branding settings.
5. Confirm the uploaded SVG renders in the header/preview where applicable.
6. Confirm a general non-branding upload does not gain broad SVG permission.

## Recommendation

Proceed with review and commit if SVG logo/favicon uploads work in the branding UI for tenant and P1 branding contexts.
