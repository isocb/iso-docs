# Marketing Website Setup Guide

> **Complete guide for creating module marketing websites with Astro + Decap CMS + Cloudflare OAuth**

This guide covers the full workflow from initial setup to deployment, based on the LMSPro website (seasonpro.co.uk).

---

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Phase 1: Project Setup](#phase-1-project-setup)
4. [Phase 2: Content Structure](#phase-2-content-structure)
5. [Phase 3: Decap CMS Setup](#phase-3-decap-cms-setup)
6. [Phase 4: Cloudflare OAuth Worker](#phase-4-cloudflare-oauth-worker)
7. [Phase 5: Deployment to Render](#phase-5-deployment-to-render)
8. [Phase 6: Domain & DNS](#phase-6-domain--dns)
9. [Content Management](#content-management)
10. [Maintenance](#maintenance)

---

## Overview

### Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         User's Browser                          │
└─────────────────────────────────────────────────────────────────┘
                                │
                ┌───────────────┴───────────────┐
                ▼                               ▼
┌───────────────────────────┐     ┌───────────────────────────┐
│   seasonpro.co.uk         │     │   seasonpro.co.uk/admin   │
│   (Astro Static Site)     │     │   (Decap CMS)             │
│   Hosted on Render        │     │   Edits content via Git   │
└───────────────────────────┘     └───────────────────────────┘
                                               │
                                               ▼
                               ┌───────────────────────────────┐
                               │   Cloudflare Worker (OAuth)   │
                               │   decap-cms-oauth.*.workers.dev│
                               └───────────────────────────────┘
                                               │
                                               ▼
                               ┌───────────────────────────────┐
                               │   GitHub OAuth + Repo         │
                               │   isocb/Website-ModuleName    │
                               └───────────────────────────────┘
```

### Tech Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| Static Site Generator | Astro 5.x | Fast, SEO-friendly pages |
| Styling | Tailwind CSS 4.x | Utility-first CSS |
| CMS | Decap CMS | Git-based content management |
| OAuth | Cloudflare Workers | GitHub authentication |
| Hosting | Render | Static site hosting |
| DNS | Cloudflare | Domain management |

---

## Prerequisites

### Accounts Required

- [ ] GitHub account with access to `isocb` organization
- [ ] Cloudflare account (free tier works)
- [ ] Render account
- [ ] Domain registered (managed via Cloudflare DNS)

### Tools Required

```bash
# Node.js 18+ 
node --version  # Should be 18.x or higher

# npm or pnpm
npm --version

# Wrangler (Cloudflare CLI) - use via npx
npx wrangler --version
```

---

## Phase 1: Project Setup

### 1.1 Create New Repository

```bash
# Create directory
mkdir website-modulename
cd website-modulename

# Initialize git
git init
```

### 1.2 Initialize Astro Project

```bash
# Create Astro project
npm create astro@latest . -- --template minimal --typescript strict

# Install dependencies
npm install

# Add Tailwind CSS
npm install tailwindcss @tailwindcss/vite

# Add sitemap for SEO
npm install @astrojs/sitemap
```

### 1.3 Configure Astro

**astro.config.mjs:**
```javascript
// @ts-check
import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://your-domain.co.uk',  // UPDATE THIS
  vite: {
    plugins: [tailwindcss()]
  },
  integrations: [sitemap()],
  trailingSlash: 'always',
});
```

### 1.4 Project Structure

```
website-modulename/
├── public/
│   ├── favicon.ico
│   └── images/
├── src/
│   ├── components/         # Reusable components
│   │   ├── Header.astro
│   │   ├── Footer.astro
│   │   ├── Hero.astro
│   │   ├── Features.astro
│   │   ├── Pricing.astro
│   │   ├── Testimonials.astro
│   │   └── FAQ.astro
│   ├── content/            # CMS-managed content
│   │   ├── config.ts       # Content schemas
│   │   ├── settings/
│   │   │   └── site.json
│   │   ├── features/
│   │   │   └── all.json
│   │   ├── pricing/
│   │   │   └── plans.json
│   │   ├── testimonials/
│   │   │   └── all.json
│   │   └── faqs/
│   │       └── all.json
│   ├── layouts/
│   │   └── BaseLayout.astro
│   ├── pages/
│   │   ├── index.astro
│   │   ├── admin.astro     # Decap CMS (inline config)
│   │   ├── features.astro
│   │   ├── pricing.astro
│   │   └── contact.astro
│   └── styles/
│       └── global.css
├── oauth-worker/           # Cloudflare OAuth worker
│   ├── worker.js
│   ├── wrangler.toml
│   └── README.md
├── astro.config.mjs
├── package.json
├── tsconfig.json
└── README.md
```

### 1.5 Base Styles

**src/styles/global.css:**
```css
@import "tailwindcss";

/* Brand colors - UPDATE THESE */
:root {
  --color-primary: #1E3A5F;      /* Deep Blue */
  --color-secondary: #4CAF50;    /* Grass Green */
  --color-accent: #FF6B35;       /* Action Orange */
  --color-background: #F8FAFC;
  --color-text: #1E293B;
}
```

---

## Phase 2: Content Structure

### 2.1 Content Schema

**src/content/config.ts:**
```typescript
import { defineCollection, z } from 'astro:content';

// Site settings
const settings = defineCollection({
  type: 'data',
  schema: z.object({
    siteName: z.string(),
    tagline: z.string(),
    description: z.string(),
    contactEmail: z.string().email(),
    salesEmail: z.string().email(),
    supportEmail: z.string().email(),
    registrationUrl: z.string().url(),
    loginUrl: z.string().url(),
    stats: z.array(z.object({
      value: z.string(),
      label: z.string(),
    })),
  }),
});

// Features
const features = defineCollection({
  type: 'data',
  schema: z.object({
    items: z.array(z.object({
      title: z.string(),
      description: z.string(),
      icon: z.string(),
      category: z.string(),
      order: z.number().default(0),
    })),
  }),
});

// Pricing plans
const pricing = defineCollection({
  type: 'data',
  schema: z.object({
    items: z.array(z.object({
      name: z.string(),
      price: z.string(),
      period: z.string().optional(),
      description: z.string(),
      features: z.array(z.string()),
      highlighted: z.boolean().default(false),
      ctaText: z.string().default('Get Started'),
      ctaUrl: z.string().optional(),
    })),
  }),
});

// Testimonials
const testimonials = defineCollection({
  type: 'data',
  schema: z.object({
    items: z.array(z.object({
      quote: z.string(),
      author: z.string(),
      role: z.string(),
      organization: z.string(),
      rating: z.number().min(1).max(5).default(5),
      featured: z.boolean().default(false),
    })),
  }),
});

// FAQs
const faqs = defineCollection({
  type: 'data',
  schema: z.object({
    items: z.array(z.object({
      question: z.string(),
      answer: z.string(),
      category: z.enum(['pricing', 'general', 'features', 'support']).default('general'),
      order: z.number().default(0),
    })),
  }),
});

export const collections = {
  settings,
  features,
  pricing,
  testimonials,
  faqs,
};
```

### 2.2 Initial Content Files

**src/content/settings/site.json:**
```json
{
  "siteName": "ModuleName",
  "tagline": "Your Compelling Tagline Here",
  "description": "SEO description for the module - what problem does it solve?",
  "contactEmail": "hello@isostack.co.uk",
  "salesEmail": "sales@isostack.co.uk",
  "supportEmail": "support@isostack.co.uk",
  "registrationUrl": "https://app.isostack.co.uk/modulename/register",
  "loginUrl": "https://app.isostack.co.uk/auth/signin",
  "stats": [
    { "value": "100+", "label": "Organizations" },
    { "value": "5,000+", "label": "Active Users" },
    { "value": "99.9%", "label": "Uptime" }
  ]
}
```

**src/content/features/all.json:**
```json
{
  "items": [
    {
      "title": "Feature One",
      "description": "Description of what this feature does and why it matters.",
      "icon": "chart",
      "category": "core",
      "order": 1
    }
  ]
}
```

**src/content/pricing/plans.json:**
```json
{
  "items": [
    {
      "name": "Starter",
      "price": "Free",
      "description": "Perfect for getting started",
      "features": [
        "Up to 5 users",
        "Basic features",
        "Email support"
      ],
      "highlighted": false,
      "ctaText": "Start Free"
    },
    {
      "name": "Professional",
      "price": "£49",
      "period": "/month",
      "description": "For growing organizations",
      "features": [
        "Unlimited users",
        "All features",
        "Priority support",
        "API access"
      ],
      "highlighted": true,
      "ctaText": "Get Started"
    }
  ]
}
```

---

## Phase 3: Decap CMS Setup

### 3.1 Create Admin Page (Astro)

**IMPORTANT:** Use an Astro page with inline JavaScript config instead of a static HTML + YAML file. This avoids MIME type issues with YAML files on some hosting providers.

**src/pages/admin.astro:**
```astro
---
// Decap CMS Admin Page
// Config is inlined to avoid YAML content-type issues
---
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta name="robots" content="noindex" />
  <title>Content Manager | ModuleName</title>
</head>
<body>
  <script is:inline>
    // Enable manual init to use JavaScript config
    window.CMS_MANUAL_INIT = true;
  </script>
  <script is:inline src="https://unpkg.com/decap-cms@^3.0.0/dist/decap-cms.js"></script>
  <script is:inline>
    CMS.init({
      config: {
        backend: {
          name: 'github',
          repo: 'isocb/Website-ModuleName',  // UPDATE THIS
          branch: 'main',
          base_url: 'https://decap-cms-oauth.YOUR-ACCOUNT.workers.dev',  // UPDATE THIS
          auth_endpoint: '/auth'
        },
        local_backend: false,
        media_folder: 'public/images',
        public_folder: '/images',
        site_url: 'https://www.your-domain.co.uk',  // UPDATE THIS
        display_url: 'https://www.your-domain.co.uk',
        logo_url: '/favicon.svg',
        collections: [
          {
            name: 'settings',
            label: 'Site Settings',
            files: [
              {
                name: 'site',
                label: 'General Settings',
                file: 'src/content/settings/site.json',
                fields: [
                  { name: 'siteName', label: 'Site Name', widget: 'string' },
                  { name: 'tagline', label: 'Tagline', widget: 'string' },
                  { name: 'description', label: 'Site Description', widget: 'text' },
                  { name: 'contactEmail', label: 'Contact Email', widget: 'string' },
                  { name: 'salesEmail', label: 'Sales Email', widget: 'string' },
                  { name: 'supportEmail', label: 'Support Email', widget: 'string' },
                  { name: 'registrationUrl', label: 'Registration URL', widget: 'string' },
                  { name: 'loginUrl', label: 'Login URL', widget: 'string' },
                  {
                    name: 'stats',
                    label: 'Homepage Stats',
                    widget: 'list',
                    fields: [
                      { name: 'value', label: 'Value', widget: 'string' },
                      { name: 'label', label: 'Label', widget: 'string' }
                    ]
                  }
                ]
              }
            ]
          },
          {
            name: 'testimonials',
            label: 'Testimonials',
            label_singular: 'Testimonial',
            folder: 'src/content/testimonials',
            format: 'json',
            create: false,
            slug: '{{slug}}',
            fields: [
              {
                name: 'items',
                label: 'Testimonials',
                widget: 'list',
                fields: [
                  { name: 'quote', label: 'Quote', widget: 'text' },
                  { name: 'author', label: 'Author Name', widget: 'string' },
                  { name: 'role', label: 'Role/Title', widget: 'string' },
                  { name: 'organization', label: 'Organization', widget: 'string' },
                  { name: 'rating', label: 'Rating (1-5)', widget: 'number', min: 1, max: 5, default: 5 },
                  { name: 'featured', label: 'Featured?', widget: 'boolean', default: false }
                ]
              }
            ]
          },
          {
            name: 'faqs',
            label: 'FAQs',
            label_singular: 'FAQ',
            folder: 'src/content/faqs',
            format: 'json',
            create: false,
            fields: [
              {
                name: 'items',
                label: 'FAQs',
                widget: 'list',
                fields: [
                  { name: 'question', label: 'Question', widget: 'string' },
                  { name: 'answer', label: 'Answer', widget: 'text' },
                  {
                    name: 'category',
                    label: 'Category',
                    widget: 'select',
                    options: [
                      { label: 'General', value: 'general' },
                      { label: 'Pricing', value: 'pricing' },
                      { label: 'Features', value: 'features' },
                      { label: 'Support', value: 'support' }
                    ]
                  },
                  { name: 'order', label: 'Display Order', widget: 'number', default: 0 }
                ]
              }
            ]
          },
          {
            name: 'pricing',
            label: 'Pricing Plans',
            folder: 'src/content/pricing',
            format: 'json',
            create: false,
            fields: [
              {
                name: 'items',
                label: 'Plans',
                widget: 'list',
                fields: [
                  { name: 'name', label: 'Plan Name', widget: 'string' },
                  { name: 'price', label: 'Price', widget: 'string', hint: 'e.g., FREE, £49, Custom' },
                  { name: 'period', label: 'Period', widget: 'string', required: false, hint: 'e.g., /month' },
                  { name: 'description', label: 'Short Description', widget: 'string' },
                  {
                    name: 'features',
                    label: 'Included Features',
                    widget: 'list',
                    field: { name: 'feature', label: 'Feature', widget: 'string' }
                  },
                  {
                    name: 'notIncluded',
                    label: 'Not Included Features',
                    widget: 'list',
                    required: false,
                    field: { name: 'feature', label: 'Feature', widget: 'string' }
                  },
                  { name: 'ctaText', label: 'Button Text', widget: 'string' },
                  { name: 'ctaUrl', label: 'Button URL', widget: 'string' },
                  { name: 'popular', label: 'Mark as Popular?', widget: 'boolean', default: false },
                  { name: 'order', label: 'Display Order', widget: 'number', default: 0 }
                ]
              }
            ]
          },
          {
            name: 'features',
            label: 'Features',
            files: [
              {
                name: 'all',
                label: 'All Features',
                file: 'src/content/features/all.json',
                fields: [
                  {
                    name: 'items',
                    label: 'Features',
                    widget: 'list',
                    fields: [
                      { name: 'title', label: 'Title', widget: 'string' },
                      { name: 'description', label: 'Description', widget: 'text' },
                      { name: 'icon', label: 'Icon Name', widget: 'string' },
                      { name: 'category', label: 'Category', widget: 'string' },
                      { name: 'order', label: 'Sort Order', widget: 'number', default: 0 }
                    ]
                  }
                ]
              }
            ]
          }
        ]
      }
    });
  </script>
</body>
</html>
```

### 3.2 Key Points

1. **Use `is:inline`** on all script tags to prevent Astro from bundling them
2. **Use `CMS_MANUAL_INIT = true`** to enable JavaScript-based config
3. **Config is a JavaScript object** not a YAML file - avoids MIME type issues
4. **No need for `public/admin/config.yml`** - the config is inlined

### 3.3 Why Not YAML?

Some hosting providers (including Render with Cloudflare proxy) serve `.yml` files with `Content-Type: binary/octet-stream` instead of `text/yaml`. Combined with `X-Content-Type-Options: nosniff`, this causes Decap CMS to fail loading the config.

The JavaScript inline approach:
- ✅ Always works regardless of server MIME type settings
- ✅ Faster (no additional HTTP request for config)
- ✅ Easier to template with Astro variables if needed
- ❌ Slightly more verbose than YAML

---

## Phase 4: Cloudflare OAuth Worker

### 4.1 Create Worker Files

**oauth-worker/worker.js:**
```javascript
/**
 * Decap CMS OAuth Worker for GitHub
 * Deploy to Cloudflare Workers
 * 
 * Required environment variables (set in Cloudflare Dashboard):
 * - GITHUB_CLIENT_ID: Your GitHub OAuth App client ID
 * - GITHUB_CLIENT_SECRET: Your GitHub OAuth App client secret
 * - ALLOWED_ORIGINS: Comma-separated list of allowed origins
 */

const GITHUB_AUTHORIZE_URL = 'https://github.com/login/oauth/authorize';
const GITHUB_TOKEN_URL = 'https://github.com/login/oauth/access_token';

function renderHTML(content, status = 200) {
  return new Response(content, {
    status,
    headers: { 'Content-Type': 'text/html;charset=UTF-8' },
  });
}

async function handleAuth(request, env) {
  const url = new URL(request.url);
  const scope = url.searchParams.get('scope') || 'repo,user';
  
  const authUrl = new URL(GITHUB_AUTHORIZE_URL);
  authUrl.searchParams.set('client_id', env.GITHUB_CLIENT_ID);
  authUrl.searchParams.set('redirect_uri', `${url.origin}/callback`);
  authUrl.searchParams.set('scope', scope);
  authUrl.searchParams.set('state', crypto.randomUUID());
  
  return Response.redirect(authUrl.toString(), 302);
}

async function handleCallback(request, env) {
  const url = new URL(request.url);
  const code = url.searchParams.get('code');
  const error = url.searchParams.get('error');
  
  if (error) {
    return renderHTML(`<h1>Error: ${error}</h1>`, 400);
  }
  
  if (!code) {
    return renderHTML('<h1>Error: No authorization code</h1>', 400);
  }
  
  const tokenResponse = await fetch(GITHUB_TOKEN_URL, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: JSON.stringify({
      client_id: env.GITHUB_CLIENT_ID,
      client_secret: env.GITHUB_CLIENT_SECRET,
      code,
    }),
  });
  
  const tokenData = await tokenResponse.json();
  
  if (tokenData.error) {
    return renderHTML(`<h1>Error: ${tokenData.error}</h1>`, 400);
  }
  
  const token = tokenData.access_token;
  
  return renderHTML(`
    <!DOCTYPE html>
    <html>
      <head><title>Success</title></head>
      <body>
        <script>
          (function() {
            window.opener && window.opener.postMessage(
              'authorization:github:success:' + JSON.stringify({ token: "${token}", provider: "github" }),
              '*'
            );
            setTimeout(() => window.close(), 1000);
          })();
        </script>
        <p>Authentication successful. This window will close.</p>
      </body>
    </html>
  `);
}

export default {
  async fetch(request, env) {
    const path = new URL(request.url).pathname;
    
    if (request.method === 'OPTIONS') {
      return new Response(null, { status: 204 });
    }
    
    switch (path) {
      case '/auth':
        return handleAuth(request, env);
      case '/callback':
        return handleCallback(request, env);
      default:
        return new Response(JSON.stringify({ status: 'ok' }), {
          headers: { 'Content-Type': 'application/json' },
        });
    }
  },
};
```

**oauth-worker/wrangler.toml:**
```toml
name = "decap-cms-oauth"
main = "worker.js"
compatibility_date = "2024-01-01"
```

### 4.2 Deploy OAuth Worker

```bash
# Navigate to worker directory
cd oauth-worker

# Login to Cloudflare
npx wrangler login

# Deploy
npx wrangler deploy
# Note the URL: https://decap-cms-oauth.YOUR-ACCOUNT.workers.dev
```

### 4.3 Create GitHub OAuth App

1. Go to: **https://github.com/settings/applications/new**

2. Fill in:
   | Field | Value |
   |-------|-------|
   | Application name | `ModuleName CMS` |
   | Homepage URL | `https://your-domain.co.uk` |
   | Callback URL | `https://decap-cms-oauth.YOUR-ACCOUNT.workers.dev/callback` |

3. Register and copy **Client ID** and **Client Secret**

### 4.4 Set Worker Environment Variables

In **Cloudflare Dashboard** → **Workers** → `decap-cms-oauth` → **Settings** → **Variables**:

| Variable | Type | Value |
|----------|------|-------|
| `GITHUB_CLIENT_ID` | Text | Your Client ID |
| `GITHUB_CLIENT_SECRET` | Secret | Your Client Secret |
| `ALLOWED_ORIGINS` | Text | `https://your-domain.co.uk` |

### 4.5 Update CMS Config

Update the `base_url` in `src/pages/admin.astro`:
```javascript
backend: {
  name: 'github',
  repo: 'isocb/Website-ModuleName',
  branch: 'main',
  base_url: 'https://decap-cms-oauth.YOUR-ACCOUNT.workers.dev',  // Your actual worker URL
  auth_endpoint: '/auth'
},
```

---

## Phase 5: Deployment to Render

### 5.1 Create GitHub Repository

```bash
# Push to GitHub
git remote add origin https://github.com/isocb/Website-ModuleName.git
git branch -M main
git push -u origin main
```

### 5.2 Create Render Static Site

1. Go to **https://dashboard.render.com**
2. Click **New** → **Static Site**
3. Connect your GitHub repo
4. Configure:

| Setting | Value |
|---------|-------|
| Name | `website-modulename` |
| Branch | `main` |
| Build Command | `npm run build` |
| Publish Directory | `dist` |
| Auto-Deploy | Yes |

5. Click **Create Static Site**

### 5.3 render.yaml (Optional)

**render.yaml:**
```yaml
services:
  - type: web
    name: website-modulename
    runtime: static
    buildCommand: npm run build
    staticPublishPath: ./dist
    envVars: []
    headers:
      - path: /*
        name: X-Frame-Options
        value: DENY
      - path: /*
        name: X-Content-Type-Options
        value: nosniff
```

---

## Phase 6: Domain & DNS

### 6.1 Add Custom Domain in Render

1. In Render Dashboard → Your site → **Settings** → **Custom Domains**
2. Add: `your-domain.co.uk` and `www.your-domain.co.uk`
3. Copy the Render URL (e.g., `website-modulename.onrender.com`)

### 6.2 Configure Cloudflare DNS

1. In Cloudflare → Your domain → **DNS**
2. Add records:

| Type | Name | Target | Proxy |
|------|------|--------|-------|
| CNAME | `@` | `website-modulename.onrender.com` | Proxied |
| CNAME | `www` | `website-modulename.onrender.com` | Proxied |

3. In **SSL/TLS** → Set to **Full (strict)**

### 6.3 Verify

After DNS propagation (usually minutes):
- Site: `https://your-domain.co.uk`
- CMS: `https://your-domain.co.uk/admin/`

---

## Content Management

### Local Development

```bash
# Start Astro dev server
npm run dev

# In another terminal, start local CMS
npx decap-server

# Access CMS at http://localhost:4321/admin/
```

### Production CMS

1. Go to `https://your-domain.co.uk/admin/`
2. Click **Login with GitHub**
3. Authorize the app
4. Edit content → Save → Automatically commits to GitHub → Auto-deploys

### Content Workflow

```
Edit in CMS → Commits to GitHub → Render auto-deploys → Live in ~2 mins
```

---

## Maintenance

### Updating Dependencies

```bash
npm update
npm audit fix
```

### Adding New Content Types

1. Add schema in `src/content/config.ts`
2. Create JSON file in `src/content/`
3. Add collection in `public/admin/config.yml`
4. Create component in `src/components/`
5. Use in pages

### Common Issues

| Issue | Solution |
|-------|----------|
| CMS login fails | Check OAuth callback URL matches worker URL |
| CMS "Failed to load config.yml" | Use inline JS config (see Phase 3) - don't use YAML file |
| Content not updating | Check Render build logs |
| Local CMS not working | Run `npx decap-server` (only works with YAML config) |
| 404 on admin | Ensure `src/pages/admin.astro` exists |
| www redirect issues | Use `www.` prefix in all URLs consistently |

---

## Checklist for New Module Website

- [ ] Create GitHub repo: `isocb/Website-ModuleName`
- [ ] Clone template or create from scratch
- [ ] Update `astro.config.mjs` with site URL
- [ ] Update brand colors in `global.css`
- [ ] Update content in `src/content/`
- [ ] Create `src/pages/admin.astro` with inline CMS config
- [ ] Deploy OAuth worker to Cloudflare (can reuse existing)
- [ ] Create GitHub OAuth App (or add domain to existing)
- [ ] Set worker environment variables (add new domain to ALLOWED_ORIGINS)
- [ ] Update admin.astro with OAuth URL and repo name
- [ ] Create Render static site
- [ ] Configure custom domain (use www. prefix)
- [ ] Test CMS login
- [ ] Test content editing flow

---

## Reference: LMSPro Implementation

| Component | Value |
|-----------|-------|
| Repo | `isocb/Website-LMSPro` |
| Domain | `www.seasonpro.co.uk` |
| Render | `website-lmspro.onrender.com` |
| OAuth Worker | `decap-cms-oauth.chris-43e.workers.dev` |
| CMS | `https://www.seasonpro.co.uk/admin/` |
| Config Method | Inline JavaScript (not YAML) |

---

## Reusing the OAuth Worker

The same Cloudflare Worker can authenticate multiple sites. Just:

1. **Add the new domain to `ALLOWED_ORIGINS`:**
   ```
   https://www.seasonpro.co.uk,https://www.newsite.co.uk
   ```

2. **Use the same `base_url`** in each site's admin.astro config

3. **Add the new callback URL** to the GitHub OAuth App:
   - GitHub now supports multiple callback URLs
   - Or create a separate OAuth App per site

---

*Last Updated: February 2026*
