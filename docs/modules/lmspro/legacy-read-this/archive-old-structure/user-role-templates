Platform Templates Explained
What Are Platform Templates?
Platform templates are pre-built, reusable role definitions seeded at the platform level (not tied to any specific organization). They serve as:

Starting points for tenant admins to quickly set up roles
Best practice blueprints that reflect real-world use cases (League Secretary, Treasurer, Club Secretary, etc.)
Read-only defaults that organizations cannot modify directly but can clone and customize
Database Structure
Key distinguishing fields:

organizationId: null → Platform template (shared across all orgs)
isSystemDefault: true → Marks it as a platform-seeded template
organizationId: <uuid> → Tenant's custom role
YES, They Are In Use! 🎯
Platform templates are actively used in LMSPro right now:

1. Seeded During Setup
Two scripts create platform templates:

Development seed (seed.ts):

Production-safe seeder (seed-system-roles.ts):

Idempotent (safe to run multiple times)
Creates 17 LMSPro role templates:
League roles: League Administrator, League Secretary, Assistant Secretary, Treasurer
Specialist roles: Safeguarding Officer, Venue Coordinator, Referee Coordinator
Age group roles: U7-U13 Age Group Managers (7 roles)
Club roles: Club Secretary, Club Treasurer, Welfare Officer, Fixture Secretary
2. Displayed in UI
Located at: /app/lmspro/admin/roles

The Roles Management page has two tabs:

"Platform Templates" tab:

Shows all 17 platform templates
Marked with blue "Template" badge
Read-only (can't edit or delete)
Has "Clone" button (📋 icon)
"Custom Roles" tab:

Shows organization's custom roles
Can edit, delete, and assign to users
Can create from scratch or clone templates
3. Clone Workflow (Most Common Use Case)
When a C1 (OWNER) or C2 (ADMIN) user wants to customize a role:

View template: Click "Platform Templates" tab → see "League Secretary" role
Clone it: Click clone icon → Opens modal pre-filled with template data
Customize: Change name to "Assistant League Secretary", remove some permissions
Save: Creates new role with organizationId: <tenant-uuid>, isSystemDefault: false
tRPC endpoint:

4. Auto-Assignment to Organization Owners
When an organization gets LMSPro access:

Yes - users can be assigned platform template roles directly! They don't have to clone them first.

How They're Used in Practice
Example: DJFL Organization Gets LMSPro
P1 (Platform Admin) enables LMSPro for DJFL organization
System auto-assigns "League Administrator" template role to DJFL owner (C1 user)
C1 user logs in → sees full LMSPro dashboard (all 20+ components granted by League Administrator)
C1 wants custom role for their Assistant Secretary:
Goes to /app/lmspro/admin/roles
Clicks "Platform Templates" tab
Clicks clone on "Assistant Secretary" template
Modifies: removes seasons.manage, adds clubs.welfare.view
Saves as "DJFL Assistant Secretary" (organizationId: djfl-uuid)
C1 assigns new custom role to another user via /app/lmspro/admin/users
Example: Club Secretary Role
Platform template includes:

Tenant A uses it as-is (assigns template directly to club secretaries)
Tenant B clones it, removes clubs.finances.view → Creates "Junior Club Secretary"
Tenant C clones it, adds clubs.welfare.view → Creates "Head Club Secretary"

Protection Rules (Enforced in tRPC Router)
UI reinforces this:

Template roles show "Clone" button only (no Edit/Delete)
Clicking edit shows notification: "Platform templates are read-only. Clone to customize."
Benefits of This System
Fast onboarding: New organizations get 17 ready-to-use roles immediately
Consistency: All leagues start with same baseline roles (easier for support)
Flexibility: Organizations can use templates as-is OR customize them
Best practices: Platform owner controls what "good" looks like
Evolution: Platform owner can add new templates without affecting existing custom roles
Audit trail: Can track which custom roles were cloned from which templates
Current Platform Templates (17 Total)
League-Level Roles (7):

League Administrator (full access - auto-assigned to C1 owners)
League Secretary
Assistant Secretary
Treasurer
Safeguarding Officer
Venue Coordinator
Referee Coordinator
Age Group Roles (7):

U7-U13 Age Group Managers (one for each age group)
Club-Level Roles (4):

Club Secretary
Club Treasurer
Welfare Officer
Fixture Secretary
Where to Find Them
In Database:

In UI: /app/lmspro/admin/roles → "Platform Templates" tab

In Code:

Seeded: seed.ts lines 1127-1359
Production seeder: seed-system-roles.ts
tRPC router: roles.router.ts
UI component: page.tsx
TL;DR: Platform templates are heavily used - they're the foundation of LMSPro's role system. Every organization starts with 17 pre-built roles they can use directly or clone/customize. C1 owners get "League Administrator" template auto-assigned when LMSPro is enabled.