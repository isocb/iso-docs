I'll analyze the codebase to explain how features, bundles, and modules work together. Let me start by examining the database schema and then trace through the implementation.

Read schema.prisma, lines 1 to 100

Read schema.prisma, lines 200 to 350

Read schema.prisma, lines 365 to 520

Read schema.prisma, lines 630 to 680

Now let me check how these are used in the code:

Now let me look at how features are checked and how they relate to modules:

Read featureBundles.router.ts, lines 1 to 100

Read featureBundles.router.ts, lines 240 to 297

Now let me look at how organizations get their module access and bundles:

Read modules.router.ts, lines 1 to 150

Perfect! Now let me create a comprehensive explanation document. Let me read one more critical piece about how feature bundles work with organizations:

Now I have a complete picture. Let me create a comprehensive explanation for you:

IsoStack Feature, Bundle & Module Architecture - Complete Explanation
Based on my analysis of the codebase, here's how the subscription/feature system currently works:

1. The Three-Layer Architecture
Layer 1: Module Catalogue (Platform-Wide Offerings)
Location: module_catalogue table
Purpose: Defines ALL modules available in the IsoStack platform
Examples: Bedrock, API KeyChain, TailorAID, EmberBox
Contains:
Module metadata (name, slug, description, icon)
Module branding (logos, colors for that module)
Routes (platform/tenant/user paths)
Enabled/Premium/Trial flags
Layer 2: Feature Bundle Definitions (Pricing Tiers)
Location: feature_bundle_definitions table
Purpose: Defines WHAT features come with each pricing tier
Bundles: BASIC, PRO, ENTERPRISE (standardized names)
Scope: Can be module-specific OR global
Module-specific: "Bedrock ENTERPRISE bundle includes X, Y, Z"
Global: "ENTERPRISE tier includes White Label across ALL modules"
Key Fields:

Layer 3: Organization Module Access (Client Subscriptions)
Location: organisation_modules table (join table)
Purpose: Tracks WHICH modules each organization has access to
Pricing Assignment: Each org-module relationship has a featureBundle field
Key Fields:

2. How Features Are Resolved
Example: White Label Feature
Scenario: Client "Acme Corp" subscribes to Bedrock at ENTERPRISE tier.

Resolution Flow:

Query: organisation_modules WHERE organizationId = "acme" AND moduleId = "bedrock"
Result: featureBundle = "ENTERPRISE"
Lookup: feature_bundle_definitions WHERE name = "ENTERPRISE" AND (moduleId = "bedrock" OR moduleId IS NULL)
Priority: Module-specific bundle overrides global bundle
Result: { whiteLabel: true, sso: true, apiAccess: true, ... }
Code Reference:

3. Current White Label / Custom Branding Implementation
Feature Definitions:
Custom Branding (PRO Tier):

Upload logo, favicon, colors
Branding shows in application header
Does NOT affect auth pages
Does NOT support custom domains
Module branding still visible in some contexts
White Label (ENTERPRISE Tier):

Everything in Custom Branding, PLUS:
Custom auth pages with org branding
Custom domain support (app.yourcompany.com)
Complete brand override (no IsoStack visible)
Branded system emails
How Branding Is Applied:
Branding Resolution Priority (from branding.ts):

Critical Code:

4. Key Questions Answered
Q: What happens when a feature is "Client Branded" or "White Label"?
A: It applies to ALL modules the client has access to.

Here's why:

White Label/Custom Branding is stored in the Organization table (NOT per-module)
Branding fields: lightLogoUrl, darkLogoUrl, faviconUrl, primaryColor, etc.
Feature flag check: organization.featureFlags.features.whiteLabel === true
When enabled, the branding resolution logic applies this to every module the user accesses
Code Evidence:

Q: How does this relate to module access?
A: There's a commercial decision point here:

Option A: Per-Module Bundle Assignment (CURRENT)

Client subscribes to Bedrock ENTERPRISE + API KeyChain BASIC
Bedrock gets White Label features
API KeyChain does NOT get White Label (only BASIC features)
Issue: Organization branding is global, but bundles are per-module
Option B: Organization-Wide Bundle (CLEANER)

Client purchases ENTERPRISE tier
ALL modules they access inherit ENTERPRISE features
Simpler: one subscription level applies everywhere
Issue: Less flexible pricing (can't mix tiers)
Q: What's the current implementation?
A: Hybrid (and potentially inconsistent):

Branding: Organization-level (applies to all modules)
Feature Bundles: Per-module (Bedrock can be PRO, API KeyChain can be BASIC)
Feature Resolution: Checks bundle per module
Problem Scenario:

Client has Bedrock ENTERPRISE (White Label enabled)
Client adds API KeyChain BASIC (no White Label in BASIC bundle)
Result: White Label branding shows in API KeyChain header because branding is org-level, but API KeyChain BASIC bundle doesn't include whiteLabel: true
Inconsistency: Client sees their branding but technically doesn't have the feature for that module
5. Recommendations for E-Commerce Design
Option 1: Unified Subscription Level
Example:

ENTERPRISE tier: $299/mo (includes White Label, SSO, etc.)
Bedrock module: $50/mo
API KeyChain module: $30/mo
Total: $379/mo for ENTERPRISE + 2 modules
Pros:

Consistent feature access across all modules
Simple to understand and implement
Branding works correctly (org-level)
Cons:

Less flexible (can't have cheap module without upgrading everything)
Option 2: Module-Specific Bundles (Enhanced)
Example:

Bedrock ENTERPRISE: $149/mo
API KeyChain BASIC: $30/mo
Constraint: White Label requires ENTERPRISE on ALL modules OR org-wide upgrade
Pros:

Flexible pricing per module
Clients can start small and upgrade selectively
Cons:

Complex feature resolution logic
Need to prevent "branding without bundle" scenarios
Option 3: Two-Tier System (RECOMMENDED)
Example:

Organization ENTERPRISE tier: $199/mo (White Label, SSO, custom domain)
Bedrock module: $50/mo (includes all Bedrock features)
API KeyChain module: $30/mo (includes all API KeyChain features)
Total: $279/mo for ENTERPRISE org + 2 modules
Pros:

Clean separation: org features vs. module features
Branding logic is simple (always check org tier)
Module features don't conflict with org features
Cons:

Pricing structure change required
Need to migrate existing bundle definitions
6. Current Database Schema Issues
Problem 1: Ambiguous Bundle Scope

Solution: Split into two tables:

Problem 2: Feature Storage Format

Features stored as JSON blob: { whiteLabel: true, sso: false }
No type safety, no validation, no constraints
Hard to query "which orgs have White Label enabled?"
Solution: Dedicated feature tables or typed columns

7. Your Specific Question: How Does It Currently Work?
White Label Feature Today:
Platform Owner creates bundle definitions:

/platform → Features Tab
Creates "ENTERPRISE" bundle with { whiteLabel: true, sso: true }
Can create global OR module-specific bundles
Client Admin (you) gets module access:

Platform Owner assigns Bedrock ENTERPRISE to your org
Record created: organisation_modules with featureBundle = "ENTERPRISE"
Feature Check (when you customize branding):

Your organization checks: featureFlags.features.whiteLabel
PROBLEM: This is checked at ORG level, but bundle is per-module
Current: Feature flags are manually set in feature_flags table, independent of bundles
Branding Resolution (when you use the app):

App checks: organization.featureFlags.features.whiteLabel === true
If true: shows your branding on ALL modules
If false: shows module branding
The Disconnect:
Bundles are defined with features
Organizations have module access with bundle assignments
But: Feature flags are checked separately, not derived from bundles
Result: Platform Owner must manually sync feature flags with bundle assignments
8. Next Steps for E-Commerce Design
Decision Points:
Should branding be org-wide or module-specific?

Recommendation: Org-wide (simpler, makes sense conceptually)
Should bundle tiers apply to entire org or per module?

Recommendation: Org-wide tier + per-module access
Separates "platform features" from "module features"
How to prevent "bundle without feature flag" inconsistency?

Recommendation: Derive feature flags FROM bundle assignments
Remove manual feature flag management
Auto-calculate: If ANY module has ENTERPRISE → enable org-wide features
Implementation Roadmap:
Phase 1: Schema Clarification

Split FeatureBundleDefinition into OrganizationTier and ModuleFeatures
Add organizationTier field to Organization table
Deprecate manual feature flags in favor of computed flags
Phase 2: Feature Resolution Logic

Create service: getOrganizationFeatures(orgId) that computes from tier
Update all feature checks to use this service
Remove hardcoded featureFlags.features.whiteLabel checks
Phase 3: E-Commerce Integration

Define pricing for org tiers (BASIC/PRO/ENTERPRISE)
Define pricing for module access (per-module or bundled)
Create checkout flow that assigns tier + modules atomically
Phase 4: Migration

Migrate existing bundle assignments to new structure
Set organization tiers based on highest module bundle
Validate no clients lose access during migration
Would you like me to:

Draft a detailed specification for the recommended architecture?
Create database migration scripts for the changes?
Analyze impact on existing clients during transition?
Design the e-commerce purchasing flow UI/UX?