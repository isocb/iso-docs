# Middleware Domain Pattern Matching

**Location in document:** Insert after Section 4.2 (Middleware)  
**Date:** 9 December 2025

---

## 4.3 Reserved Hostname Patterns

IsoStack middleware must distinguish between:
- **Platform subdomains** (`*.isostack.app`) - Standard IsoStack functionality
- **Deployment domains** (`*.onrender.com`, `*.vercel.app`) - Staging/preview environments  
- **Custom tenant domains** (`portal.acmehealth.co.uk`) - White Label organizations

### Pattern Matching Implementation

The `isReservedHostname()` function uses programmatic pattern matching (not DNS wildcards):

```typescript
/**
 * Check if hostname should skip organization lookup
 * Matches:
 * - Reserved hostnames (localhost, www, api, etc.)
 * - All IsoStack subdomains (*.isostack.app)
 * - All deployment platform domains (*.onrender.com, *.vercel.app, etc.)
 */
function isReservedHostname(hostname: string): boolean {
  const normalizedHostname = hostname.toLowerCase().split(':')[0]; // Remove port
  
  // Check exact matches
  const RESERVED_HOSTNAMES = [
    'localhost',
    '127.0.0.1',
    'www',
    'api',
    'cdn',
    'admin',
  ];
  
  if (RESERVED_HOSTNAMES.includes(normalizedHostname)) {
    return true;
  }
  
  // IsoStack platform subdomains - effectively matches *.isostack.app
  if (normalizedHostname.endsWith('.isostack.app') || normalizedHostname === 'isostack.app') {
    return true;
  }
  
  // Deployment platform domains
  const deploymentPatterns = [
    /\.onrender\.com$/,      // Render deployments
    /\.vercel\.app$/,        // Vercel deployments
    /\.netlify\.app$/,       // Netlify deployments
    /\.railway\.app$/,       // Railway deployments
  ];
  
  return deploymentPatterns.some(pattern => pattern.test(normalizedHostname));
}
```

### Hostname Resolution Logic

```typescript
export async function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;
  const hostname = request.headers.get('host') || 'localhost';
  
  // Skip middleware for API auth routes
  if (pathname.startsWith('/api/auth')) {
    return NextResponse.next();
  }

  // Custom domain handling (skip for reserved hostnames)
  if (!isReservedHostname(hostname)) {
    return await handleCustomDomain(request, hostname, pathname);
  }

  // Standard platform flow for reserved hostnames
  const session = await auth();
  
  // ... standard auth redirects
}
```

### Reserved Hostname Behavior

| Hostname Pattern | Example | Behavior |
|------------------|---------|----------|
| `*.isostack.app` | `staging.isostack.app` | ✅ Standard IsoStack (no org lookup) |
| | `app.isostack.app` | ✅ Standard IsoStack |
| | `dev.isostack.app` | ✅ Standard IsoStack |
| | `api.isostack.app` | ✅ Standard IsoStack |
| `*.onrender.com` | `sating-isostack.onrender.com` | ✅ Standard IsoStack (staging) |
| | `preview-pr-123.onrender.com` | ✅ Standard IsoStack (PR preview) |
| `*.vercel.app` | `isostack-preview.vercel.app` | ✅ Standard IsoStack (Vercel preview) |
| Custom domains | `portal.acmehealth.co.uk` | 🔍 Lookup organization in database |
| | `acme.customdomain.com` | 🔍 Lookup organization in database |

### Why This Pattern?

**Advantages:**
- ✅ **Future-proof** - New IsoStack subdomains work automatically
- ✅ **Scalable** - Add `docs.isostack.app`, `status.isostack.app` without code changes
- ✅ **Development-friendly** - All deployment preview URLs work out-of-box
- ✅ **Clear separation** - Platform domains vs. client white-label domains

**Equivalent to DNS Wildcards:**
```
Reserved domains:
- *.isostack.app       (all IsoStack subdomains)
- isostack.app         (apex domain)
- *.onrender.com       (all Render preview deploys)
- *.vercel.app         (all Vercel preview deploys)
```

The `endsWith('.isostack.app')` check is **functionally equivalent** to a DNS wildcard pattern but implemented in JavaScript middleware.

### Error Handling

**Before this implementation:**
```
User visits: https://staging.isostack.app
Middleware: Treats as potential custom domain
Database: No organization found for "staging.isostack.app"
Result: ❌ "Tenant Not Found" error page
```

**After this implementation:**
```
User visits: https://staging.isostack.app
Middleware: Recognized as reserved IsoStack subdomain
Result: ✅ Standard login/dashboard flow
```

### Custom Domain Flow

Only external domains trigger organization lookup:

```
User visits: https://portal.acmehealth.co.uk
Middleware: NOT a reserved hostname
Database: Query organization_domain table
  WHERE hostname = 'portal.acmehealth.co.uk'
  AND isActive = true
Result: Load organization branding and modules
```

### Testing Reserved Patterns

```bash
# Should work (reserved hostnames):
https://isostack.app
https://staging.isostack.app
https://app.isostack.app
https://dev.isostack.app
https://preview-pr-42.isostack.app
https://sating-isostack.onrender.com

# Should trigger org lookup (custom domains):
https://portal.acmehealth.co.uk
https://acme.customdomain.com
https://client.theirsite.org
```

### Environment-Specific Configuration

For multi-region deployments, you may want configurable patterns:

```typescript
// .env
PLATFORM_DOMAIN=isostack.app
RESERVED_DOMAIN_PATTERNS=*.isostack.app,*.onrender.com,*.vercel.app

// middleware.ts
function isReservedHostname(hostname: string): boolean {
  const platformDomain = process.env.PLATFORM_DOMAIN || 'isostack.app';
  
  // Match platform subdomains
  if (hostname.endsWith(`.${platformDomain}`) || hostname === platformDomain) {
    return true;
  }
  
  // Match deployment patterns from env
  const patterns = process.env.RESERVED_DOMAIN_PATTERNS?.split(',') || [];
  return patterns.some(pattern => {
    if (pattern.startsWith('*.')) {
      const domain = pattern.slice(2);
      return hostname.endsWith(`.${domain}`);
    }
    return hostname === pattern;
  });
}
```

This allows different reserved patterns for development, staging, and production environments.

---

## Implementation Status

✅ **Implemented** (Dec 9, 2025)
- `isReservedHostname()` pattern matching function
- Wildcard support for `*.isostack.app`
- Deployment platform exclusions
- Middleware integration

🔜 **Pending** (Phase 8)
- Custom domain verification (TXT records)
- SSL readiness checks
- Domain activation workflow
- Cloudflare integration

---

## Related Documentation

- **Phase 8:** Custom Domain Verification Workflow
- **Phase 9:** Branded Authentication Pages
- **Section 6:** Security Considerations (subdomain enumeration)
- **Section 9:** Custom Domain Verification

---

**File:** `src/middleware.ts` (Lines 9-44)  
**Commit:** `6207cfa` - "fix: exclude all *.isostack.app subdomains from custom domain check"  
**Status:** Production-ready ✅
