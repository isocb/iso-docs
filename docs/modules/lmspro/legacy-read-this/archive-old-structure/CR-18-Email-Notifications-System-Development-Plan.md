# CR #18: Unified Email System - Development Plan

**Change Request ID:** `cmjb88krq00044j7l0xv2fr1a`  
**Created:** 2025-12-18  
**Status:** Planning  
**Priority:** High  
**Estimated Duration:** 8-10 weeks (11 phases)

---

## Executive Summary

Build a **unified email system** with two entry points:

### 1. Automated Meta-Emails (System-Triggered)
- Template-based with shortcode variables
- Triggered by system events (issue created, user invited, etc.)
- P1 defines platform defaults in **Platform Settings → Email**
- C1/C2 customize org-scoped copies in **Module Settings → [Mod Name] Emails**
- Cascading lookup: Org Override → Platform Default

### 2. User Communication Emails (Manual Broadcast)
- Rich text composer with attachments
- Initiated from **Module Dashboard → Users** page
- Filtered recipient selection (module-specific metadata)
- Archive in **Communications** tab (audit-log style)
- No drafts (compose → send → archive)

**Architecture:** One database schema, one email service (Resend batch API), two UI entry points.

---

## Key Requirements from Issues

### Issue #46: Module Email Framework
- Modules reference centralized email system
- Avoid hardcoding email content in modules
- HTML templates with variable shortcodes
- Generic by default, org-customizable (scoped copies)
- Examples: Billing lifecycle emails, Issue Tracker notifications

### Issue #23: Support Ticket Email Routing
- Category-based email routing
- Cascading fallback: Org Override → Platform Default
- Include metadata: description, timestamps, target resolution date
- Role and module-dependent content

### NEW: User Communication System
- Broadcast emails to filtered module users
- Module-specific metadata filtering (e.g., DJFL: Team Manager, Age Group U7, Division)
- Instant UI feedback (background batch processing)
- Communications tab for sent email archive

---

## Architecture Overview

### Unified Database Schema

**Two Email Types, One Infrastructure:**

1. **Meta-Emails:** System-triggered, template-based (EmailTemplate → EmailLog)
2. **Communication Emails:** User-initiated, broadcast (UserEmail → EmailRecipientLog)

```prisma
// ========================================
// META-EMAILS (Automated Notifications)
// ========================================

model EmailTemplate {
  id             String   @id @default(cuid())
  name           String   // Human-readable name
  templateKey    String   // Code reference (e.g., "issue_created")
  subject        String   // Email subject line with shortcodes
  bodyHtml       String   @db.Text // HTML template with shortcodes
  description    String?  // What this template is for
  
  // Scoping (Org Override OR Platform Default)
  scope          EmailTemplateScope
  moduleSlug     String?  // For module-specific templates
  organizationId String?  // Org-specific copy (overrides platform)
  
  // Role targeting
  targetRoles    Role[]   // Which roles should receive this
  
  // Categorization
  category       String?  // Support, Billing, Issues, etc.
  
  // Metadata
  active         Boolean  @default(true)
  isCustomized   Boolean  @default(false) // True if org edited platform template
  platformTemplateId String? // Reference to platform original (for reset)
  createdAt      DateTime @default(now())
  updatedAt      DateTime @updatedAt
  createdById    String
  
  @@index([templateKey, organizationId])
  @@index([moduleSlug, organizationId])
  @@index([category])
  @@unique([templateKey, organizationId]) // One template per org per key
}

enum EmailTemplateScope {
  PLATFORM       // Platform-wide default (P1 only)
  ORGANIZATION   // Org-scoped copy (C1/C2 customized)
}

model EmailRecipient {
  id             String   @id @default(cuid())
  name           String   // Contact name
  email          String   // Email address
  category       String   // Support, Billing, Issues, etc.
  signature      String?  @db.Text // Email signature
  
  // Scoping
  scope          EmailRecipientScope
  moduleSlug     String?  // For module-specific recipients
  organizationId String?  // For org-specific recipients
  
  // Metadata
  active         Boolean  @default(true)
  isPrimary      Boolean  @default(false) // Default for category
  createdAt      DateTime @default(now())
  updatedAt      DateTime @updatedAt
  
  @@index([category, organizationId])
  @@index([moduleSlug, organizationId])
}

enum EmailRecipientScope {
  PLATFORM       // Platform-wide
  ORGANIZATION   // Organization-specific
}

model EmailLog {
  id             String   @id @default(cuid())
  templateKey    String   // Which template was used
  recipient      String   // Email address(es)
  subject        String
  bodyHtml       String   @db.Text
  
  // Context
  triggerEvent   String   // What triggered the email
  entityType     String?  // Issue, Ticket, Invoice, etc.
  entityId       String?
  
  // Status
  status         EmailStatus
  error          String?  @db.Text
  sentAt         DateTime?
  
  // Metadata
  organizationId String?
  userId         String?
  createdAt      DateTime @default(now())
  
  @@index([templateKey])
  @@index([status])
  @@index([entityType, entityId])
  @@index([organizationId, createdAt])
}

// ========================================
// COMMUNICATION EMAILS (User Broadcasts)
// ========================================

model UserEmail {
  id             String   @id @default(cuid())
  
  // Email Content
  title          String   // Internal reference (e.g., "Q4 Module Update")
  subject        String   // Actual email subject line
  bodyHtml       String   @db.Text // Rich text content
  
  // Recipient Context
  recipientCount Int      // How many users received
  recipientFilter Json    // Filter criteria used (for audit)
  
  // Module Context
  moduleSlug     String   // Which module this was sent from
  
  // Attachments (via R2)
  attachments    Json?    // Array of { fileId, fileName, fileUrl }
  
  // Delivery Tracking
  status         EmailStatus // SENDING, SENT, FAILED
  sentAt         DateTime?
  deliveryStats  Json?    // { sent: 120, delivered: 115, failed: 5 }
  
  // Scoping
  organizationId String
  organization   Organization @relation(fields: [organizationId], references: [id])
  sentById       String
  sentBy         User     @relation(fields: [sentById], references: [id])
  
  // Timestamps
  createdAt      DateTime @default(now())
  updatedAt      DateTime @updatedAt
  
  // Relations
  recipientLogs  EmailRecipientLog[] // Individual delivery tracking
  
  @@index([organizationId, moduleSlug])
  @@index([sentById])
  @@index([status])
  @@index([createdAt])
}

model EmailRecipientLog {
  id             String   @id @default(cuid())
  
  // Email Reference
  emailId        String
  email          UserEmail @relation(fields: [emailId], references: [id], onDelete: Cascade)
  
  // Recipient Info
  recipientEmail String
  recipientName  String?
  userId         String?  // If recipient is a platform user
  
  // Delivery Status (minimal tracking)
  status         EmailDeliveryStatus
  sentAt         DateTime?
  error          String?  @db.Text
  
  createdAt      DateTime @default(now())
  
  @@index([emailId])
  @@index([recipientEmail])
  @@index([status])
}

enum EmailDeliveryStatus {
  QUEUED         // Waiting in batch
  SENT           // Delivered to Resend
  FAILED         // Resend rejected
}

enum EmailStatus {
  PENDING        // Not yet processed
  SENDING        // Batch in progress
  SENT           // All delivered
  FAILED         // Batch failed
  PARTIAL        // Some succeeded, some failed
}
```

### Shortcode System (Meta-Emails Only)

**Note:** User Communication Emails use Mantine RichTextEditor (no shortcodes - freeform composition).

**Standard Shortcodes (Available in all meta-email templates):**
```
{{user.name}}              - Recipient name
{{user.email}}             - Recipient email
{{user.role}}              - User role label
{{platform.name}}          - Platform name
{{platform.url}}           - Platform URL
{{organization.name}}      - Organization name
{{date.today}}             - Today's date formatted
{{date.time}}              - Current time formatted
```

**Entity-Specific Shortcodes (Context-dependent):**

**Issue/Ticket:**
```
{{issue.number}}           - Issue #123
{{issue.title}}            - Issue title
{{issue.description}}      - Full description
{{issue.category}}         - Bug/Feature/etc
{{issue.priority}}         - Low/Medium/High/Critical
{{issue.status}}           - Draft/Pending/etc
{{issue.url}}              - Direct link to issue
{{issue.createdAt}}        - Creation date/time
{{issue.targetDate}}       - Anticipated resolution date
{{issue.createdBy.name}}   - Creator name
{{issue.loggedInRole}}     - Role context
```

**Support Ticket:**
```
{{ticket.number}}          - Ticket #456
{{ticket.subject}}         - Ticket subject
{{ticket.category}}        - Support category
{{ticket.priority}}        - Priority level
{{ticket.url}}             - Link to ticket
{{ticket.createdBy.name}}  - Reporter name
```

**Billing:**
```
{{invoice.number}}         - Invoice #789
{{invoice.amount}}         - Total amount
{{invoice.dueDate}}        - Payment due date
{{invoice.url}}            - Link to invoice
```

---

## Phase-Based Implementation

### Phase 1: Database Schema & Core Models (Week 1)

**Goal:** Establish foundation for email system

**Tasks:**
1. Add `EmailTemplate`, `EmailRecipient`, `EmailLog` models to schema
2. Add enums: `EmailTemplateScope`, `EmailRecipientScope`, `EmailStatus`
3. Run migration: `npx prisma migrate dev --name add_email_notification_system`
4. Create seed data for default templates
5. Test schema in Prisma Studio

**Deliverables:**
- ✅ Schema updated and migrated
- ✅ 3-5 default templates seeded (support ticket, issue created, etc.)
- ✅ Test data in database

**Acceptance Criteria:**
- Schema validates with `npm run type-check`
- Prisma Studio shows all tables correctly
- Seed script creates sample templates

---

### Phase 2: Template Engine & Shortcode Parser (Week 1-2)

**Goal:** Build template rendering engine

**File:** `src/lib/email/template-engine.ts`

**Core Functions:**
```typescript
/**
 * Parse and replace shortcodes in template
 */
export function renderTemplate(
  template: string,
  variables: Record<string, any>
): string;

/**
 * Get available shortcodes for template type
 */
export function getAvailableShortcodes(
  templateType: string
): ShortcodeDefinition[];

/**
 * Validate template syntax
 */
export function validateTemplate(
  template: string
): { valid: boolean; errors: string[] };

/**
 * Extract shortcodes from template
 */
export function extractShortcodes(template: string): string[];
```

**Implementation:**
```typescript
// Simple regex-based shortcode parser
const SHORTCODE_PATTERN = /\{\{([a-zA-Z0-9._]+)\}\}/g;

export function renderTemplate(
  template: string,
  variables: Record<string, any>
): string {
  return template.replace(SHORTCODE_PATTERN, (match, path) => {
    const value = getNestedValue(variables, path);
    return value !== undefined ? String(value) : match;
  });
}

function getNestedValue(obj: any, path: string): any {
  return path.split('.').reduce((current, key) => current?.[key], obj);
}
```

**Tests:**
- Unit tests for shortcode parsing
- Edge cases: nested objects, missing values, invalid syntax
- Performance test with 50+ shortcodes

**Deliverables:**
- ✅ Template engine library
- ✅ Shortcode registry
- ✅ Validation functions
- ✅ Unit tests (>90% coverage)

---

### Phase 3: Email Template CRUD (Server Actions) (Week 2)

**File:** `src/server/actions/email-templates.ts`

**Server Actions:**
```typescript
// Get templates with filtering
export async function getEmailTemplates(filters: {
  scope?: EmailTemplateScope;
  moduleSlug?: string;
  category?: string;
  active?: boolean;
}): Promise<EmailTemplate[]>;

// Get single template
export async function getEmailTemplate(id: string): Promise<EmailTemplate | null>;

// Get template by key with fallback
export async function getTemplateByKey(
  templateKey: string,
  moduleSlug?: string
): Promise<EmailTemplate | null>;

// Create template (P1 only)
export async function createEmailTemplate(
  data: CreateEmailTemplateInput
): Promise<EmailTemplate>;

// Update template (P1 only)
export async function updateEmailTemplate(
  id: string,
  data: UpdateEmailTemplateInput
): Promise<EmailTemplate>;

// Delete template (P1 only)
export async function deleteEmailTemplate(id: string): Promise<void>;

// Preview template with test data
export async function previewEmailTemplate(
  templateId: string,
  testData: Record<string, any>
): Promise<{ subject: string; bodyHtml: string }>;
```

**Cascading Lookup Logic:**
```typescript
export async function getTemplateByKey(
  templateKey: string,
  moduleSlug?: string,
  organizationId?: string
): Promise<EmailTemplate | null> {
  // 1. Try module-specific template
  if (moduleSlug) {
    const moduleTemplate = await prisma.emailTemplate.findFirst({
      where: { 
        templateKey, 
        scope: 'MODULE', 
        moduleSlug,
        active: true,
      },
    });
    if (moduleTemplate) return moduleTemplate;
  }
  
  // 2. Try organization override (future)
  if (organizationId) {
    const orgTemplate = await prisma.emailTemplate.findFirst({
      where: { 
        templateKey, 
        scope: 'TENANT', 
        organizationId,
        active: true,
      },
    });
    if (orgTemplate) return orgTemplate;
  }
  
  // 3. Fall back to platform default
  return await prisma.emailTemplate.findFirst({
    where: { 
      templateKey, 
      scope: 'PLATFORM',
      active: true,
    },
  });
}
```

**Deliverables:**
- ✅ CRUD server actions
- ✅ Cascading template lookup
- ✅ Preview functionality
- ✅ Permission checks (P1 only)

---

### Phase 4: Email Recipient Management (Server Actions) (Week 2)

**File:** `src/server/actions/email-recipients.ts`

**Server Actions:**
```typescript
// Get recipients
export async function getEmailRecipients(filters: {
  category?: string;
  scope?: EmailRecipientScope;
  moduleSlug?: string;
  active?: boolean;
}): Promise<EmailRecipient[]>;

// Create recipient
export async function createEmailRecipient(
  data: CreateEmailRecipientInput
): Promise<EmailRecipient>;

// Update recipient
export async function updateEmailRecipient(
  id: string,
  data: UpdateEmailRecipientInput
): Promise<EmailRecipient>;

// Delete recipient
export async function deleteEmailRecipient(id: string): Promise<void>;

// Get recipient for category with fallback
export async function getRecipientForCategory(
  category: string,
  moduleSlug?: string
): Promise<EmailRecipient | null>;
```

**Cascading Recipient Logic:**
```typescript
export async function getRecipientForCategory(
  category: string,
  moduleSlug?: string
): Promise<EmailRecipient | null> {
  // 1. Try module-specific recipient for category
  if (moduleSlug) {
    const moduleRecipient = await prisma.emailRecipient.findFirst({
      where: { 
        category, 
        scope: 'MODULE', 
        moduleSlug,
        active: true,
      },
      orderBy: { isPrimary: 'desc' },
    });
    if (moduleRecipient) return moduleRecipient;
  }
  
  // 2. Try platform recipient for category
  const platformRecipient = await prisma.emailRecipient.findFirst({
    where: { 
      category, 
      scope: 'PLATFORM',
      active: true,
    },
    orderBy: { isPrimary: 'desc' },
  });
  if (platformRecipient) return platformRecipient;
  
  // 3. Fall back to default platform recipient
  return await prisma.emailRecipient.findFirst({
    where: { 
      scope: 'PLATFORM',
      active: true,
      isPrimary: true,
    },
  });
}
```

**Deliverables:**
- ✅ Recipient CRUD actions
- ✅ Cascading recipient lookup
- ✅ Category-based routing

---

### Phase 5: Email Sending Service (Week 3)

**File:** `src/lib/email/send-notification.ts`

**Core Service:**
```typescript
export interface SendNotificationOptions {
  templateKey: string;
  recipient: string | string[];
  variables: Record<string, any>;
  
  // Optional overrides
  category?: string;
  moduleSlug?: string;
  organizationId?: string;
  
  // Context for logging
  triggerEvent: string;
  entityType?: string;
  entityId?: string;
  userId?: string;
}

export async function sendNotification(
  options: SendNotificationOptions
): Promise<{ success: boolean; emailLogId: string; error?: string }> {
  try {
    // 1. Get template with cascading lookup
    const template = await getTemplateByKey(
      options.templateKey, 
      options.moduleSlug,
      options.organizationId
    );
    
    if (!template) {
      throw new Error(`Template not found: ${options.templateKey}`);
    }
    
    // 2. Render subject and body
    const subject = renderTemplate(template.subject, options.variables);
    const bodyHtml = renderTemplate(template.bodyHtml, options.variables);
    
    // 3. Get recipient(s)
    const recipients = Array.isArray(options.recipient) 
      ? options.recipient 
      : [options.recipient];
    
    // 4. Send via Resend
    const { data, error } = await resend.emails.send({
      from: 'IsoStack <noreply@isostack.app>',
      to: recipients,
      subject,
      html: bodyHtml,
    });
    
    // 5. Log email
    const emailLog = await prisma.emailLog.create({
      data: {
        templateKey: options.templateKey,
        recipient: recipients.join(', '),
        subject,
        bodyHtml,
        triggerEvent: options.triggerEvent,
        entityType: options.entityType,
        entityId: options.entityId,
        organizationId: options.organizationId,
        userId: options.userId,
        status: error ? 'FAILED' : 'SENT',
        error: error?.message,
        sentAt: error ? null : new Date(),
      },
    });
    
    return { 
      success: !error, 
      emailLogId: emailLog.id,
      error: error?.message,
    };
    
  } catch (error: any) {
    // Log failed attempt
    const emailLog = await prisma.emailLog.create({
      data: {
        templateKey: options.templateKey,
        recipient: Array.isArray(options.recipient) ? options.recipient.join(', ') : options.recipient,
        subject: 'Failed to render',
        bodyHtml: error.message,
        triggerEvent: options.triggerEvent,
        entityType: options.entityType,
        entityId: options.entityId,
        status: 'FAILED',
        error: error.message,
      },
    });
    
    return { 
      success: false, 
      emailLogId: emailLog.id,
      error: error.message,
    };
  }
}
```

**Helper Functions:**
```typescript
// Build standard variables for any email
export function buildStandardVariables(
  user?: User,
  organization?: Organization
): Record<string, any> {
  return {
    user: user ? {
      name: user.name,
      email: user.email,
      role: getRoleLabel(user.role),
    } : null,
    organization: organization ? {
      name: organization.name,
    } : null,
    platform: {
      name: 'IsoStack',
      url: process.env.NEXT_PUBLIC_APP_URL,
    },
    date: {
      today: new Date().toLocaleDateString(),
      time: new Date().toLocaleTimeString(),
    },
  };
}
```

**Deliverables:**
- ✅ Email sending service
- ✅ Template rendering integration
- ✅ Email logging
- ✅ Error handling with fallback
- ✅ Resend API integration

---

### Phase 6: Platform Settings UI (Email Management) (Week 3-4)

**File:** `src/app/(app)/platform/settings/email/page.tsx`

**UI Components:**

1. **Email Templates Tab:**
   - DataTable with templates (name, key, scope, category, active)
   - Create/Edit template modal
   - Rich text editor for HTML body
   - Shortcode picker/helper
   - Preview pane with test data
   - Duplicate template function
   - Activate/Deactivate toggle

2. **Email Recipients Tab:**
   - DataTable with recipients (name, email, category, scope)
   - Create/Edit recipient modal
   - Category selector
   - Signature editor
   - Set as primary checkbox
   - Test email function

3. **Email Logs Tab:**
   - DataTable with email logs (date, recipient, template, status)
   - Filter by status, template, date range
   - View sent email (subject + body preview)
   - Retry failed emails
   - Export to CSV

**Files Structure:**
```
src/app/(app)/platform/settings/email/
├── page.tsx                          # Main page with tabs
├── components/
│   ├── TemplatesTab.tsx              # Template management
│   ├── RecipientsTab.tsx             # Recipient management
│   ├── EmailLogsTab.tsx              # Email history
│   ├── TemplateEditor.tsx            # Template CRUD modal
│   ├── RecipientEditor.tsx           # Recipient CRUD modal
│   ├── ShortcodePicker.tsx           # Shortcode helper
│   └── EmailPreview.tsx              # Preview rendered email
```

**Key Features:**
- 📝 Rich text editor (TipTap or Mantine RichTextEditor)
- 🔍 Shortcode autocomplete
- 👁️ Live preview as you type
- 📧 Send test email to yourself
- 📋 Template duplication
- 🎨 Syntax highlighting for shortcodes

**Deliverables:**
- ✅ Complete email settings UI
- ✅ Template CRUD interface
- ✅ Recipient CRUD interface
- ✅ Email log viewer
- ✅ Test email functionality

---

### Phase 7: Module Settings UI (Email Recipients) (Week 4)

**File:** `src/app/(app)/[module]/settings/email/page.tsx`

**UI Components:**

1. **Module Email Recipients Section:**
   - Show platform defaults (read-only)
   - Add module-specific recipients
   - Category-based organization
   - Override platform defaults toggle
   - Test email routing

**Features:**
- View platform defaults with "Override" button
- Module-specific recipient management
- Visual indicator: Platform (gray badge) vs Module (blue badge)
- Category routing preview

**Deliverables:**
- ✅ Module email settings page
- ✅ Recipient management for modules
- ✅ Platform default display
- ✅ Override functionality

---

### Phase 8: Integration with Existing Features (Week 5-6)

**Goal:** Wire up email notifications to existing events

#### 8.1 Issue Tracker Emails

**File:** `src/server/actions/issues.ts`

**Events to trigger:**
1. **Issue Created** (`issue_created`)
2. **Issue Updated** (`issue_updated`)
3. **Issue Status Changed** (`issue_status_changed`)
4. **Issue Assigned to CR** (`issue_assigned_to_cr`)
5. **Issue Completed** (`issue_completed`)

**Implementation:**
```typescript
export async function createIssue(data: CreateIssueInput) {
  // ... existing code ...
  
  const issue = await prisma.issue.create({ /* ... */ });
  
  // Send notification
  const recipient = await getRecipientForCategory('Issues');
  if (recipient) {
    await sendNotification({
      templateKey: 'issue_created',
      recipient: recipient.email,
      variables: {
        ...buildStandardVariables(user, organization),
        issue: {
          number: issue.number,
          title: issue.title,
          description: issue.description,
          category: issue.category,
          priority: issue.priority,
          status: issue.status,
          url: `${process.env.NEXT_PUBLIC_APP_URL}/platform/issues/${issue.id}`,
          createdAt: issue.createdAt.toLocaleString(),
          targetDate: issue.anticipatedResolutionDate?.toLocaleDateString(),
          createdBy: { name: user.name },
          loggedInRole: issue.loggedInRole,
        },
      },
      category: 'Issues',
      triggerEvent: 'issue_created',
      entityType: 'Issue',
      entityId: issue.id,
      userId: user.id,
      organizationId: user.organizationId,
    });
  }
  
  return issue;
}
```

**Role-Specific Templates:**
- `issue_created_platform` - For P1 (technical details)
- `issue_created_client` - For C1/C2 (reassurance + progress)
- `issue_status_changed_platform` - Status updates to P1
- `issue_status_changed_client` - Status updates to C1/C2

#### 8.2 Support Ticket Emails

**File:** `src/server/actions/support-tickets.ts` (if exists)

**Events:**
1. **Ticket Created** (`support_ticket_created`)
2. **Ticket Assigned** (`support_ticket_assigned`)
3. **Ticket Replied** (`support_ticket_replied`)
4. **Ticket Resolved** (`support_ticket_resolved`)

**Category Routing:**
```typescript
// Get recipient based on ticket category
const recipient = await getRecipientForCategory(
  ticket.category, // 'Technical', 'Billing', 'General', etc.
  ticket.moduleSlug
);
```

#### 8.3 Billing Emails (Future)

**Events:**
1. **Invoice Created** (`invoice_created`)
2. **Payment Received** (`payment_received`)
3. **Payment Failed** (`payment_failed`)
4. **Subscription Expiring** (`subscription_expiring`)

**Deliverables:**
- ✅ Issue Tracker email integration
- ✅ Support Ticket email integration
- ✅ Role-specific template variants
- ✅ Category-based routing
- ✅ Comprehensive testing

---

## Default Email Templates

### Template 1: Issue Created (Platform Admin)

**Key:** `issue_created_platform`  
**Scope:** Platform  
**Target Roles:** Platform Admin

**Subject:**
```
[IsoStack] New Issue #{{issue.number}}: {{issue.title}}
```

**Body:**
```html
<h2>New Issue Created</h2>

<p><strong>Issue #{{issue.number}}</strong> has been created in IsoStack.</p>

<table style="border-collapse: collapse; width: 100%; margin: 20px 0;">
  <tr>
    <td style="padding: 10px; border: 1px solid #ddd; width: 150px;"><strong>Title</strong></td>
    <td style="padding: 10px; border: 1px solid #ddd;">{{issue.title}}</td>
  </tr>
  <tr>
    <td style="padding: 10px; border: 1px solid #ddd;"><strong>Category</strong></td>
    <td style="padding: 10px; border: 1px solid #ddd;">{{issue.category}}</td>
  </tr>
  <tr>
    <td style="padding: 10px; border: 1px solid #ddd;"><strong>Priority</strong></td>
    <td style="padding: 10px; border: 1px solid #ddd;">{{issue.priority}}</td>
  </tr>
  <tr>
    <td style="padding: 10px; border: 1px solid #ddd;"><strong>Status</strong></td>
    <td style="padding: 10px; border: 1px solid #ddd;">{{issue.status}}</td>
  </tr>
  <tr>
    <td style="padding: 10px; border: 1px solid #ddd;"><strong>Logged by</strong></td>
    <td style="padding: 10px; border: 1px solid #ddd;">{{issue.loggedInRole}}</td>
  </tr>
  <tr>
    <td style="padding: 10px; border: 1px solid #ddd;"><strong>Created</strong></td>
    <td style="padding: 10px; border: 1px solid #ddd;">{{issue.createdAt}}</td>
  </tr>
  <tr>
    <td style="padding: 10px; border: 1px solid #ddd;"><strong>Target Resolution</strong></td>
    <td style="padding: 10px; border: 1px solid #ddd;">{{issue.targetDate}}</td>
  </tr>
</table>

<h3>Description</h3>
<div style="background: #f5f5f5; padding: 15px; border-left: 4px solid #228be6;">
  {{issue.description}}
</div>

<p style="margin-top: 30px;">
  <a href="{{issue.url}}" style="background: #228be6; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px;">View Issue in IsoStack</a>
</p>

<hr style="margin: 30px 0; border: none; border-top: 1px solid #ddd;">

<p style="color: #666; font-size: 12px;">
  This email was sent from IsoStack Platform.<br>
  You're receiving this because you're a Platform Administrator.
</p>
```

### Template 2: Issue Created (Client Admin)

**Key:** `issue_created_client`  
**Scope:** Platform  
**Target Roles:** Client Super Admin, Client Admin

**Subject:**
```
Issue Reported: {{issue.title}}
```

**Body:**
```html
<h2>Thank you for reporting this issue</h2>

<p>We've received your issue report and our team will review it shortly.</p>

<table style="border-collapse: collapse; width: 100%; margin: 20px 0;">
  <tr>
    <td style="padding: 10px; border: 1px solid #ddd; width: 150px;"><strong>Issue Number</strong></td>
    <td style="padding: 10px; border: 1px solid #ddd;">#{{issue.number}}</td>
  </tr>
  <tr>
    <td style="padding: 10px; border: 1px solid #ddd;"><strong>Title</strong></td>
    <td style="padding: 10px; border: 1px solid #ddd;">{{issue.title}}</td>
  </tr>
  <tr>
    <td style="padding: 10px; border: 1px solid #ddd;"><strong>Priority</strong></td>
    <td style="padding: 10px; border: 1px solid #ddd;">{{issue.priority}}</td>
  </tr>
  <tr>
    <td style="padding: 10px; border: 1px solid #ddd;"><strong>Expected Resolution</strong></td>
    <td style="padding: 10px; border: 1px solid #ddd;">{{issue.targetDate}}</td>
  </tr>
</table>

<h3>What happens next?</h3>
<ol>
  <li>Our team will review your issue within 24 hours</li>
  <li>You'll receive updates as we make progress</li>
  <li>We'll notify you when the issue is resolved</li>
</ol>

<p style="margin-top: 30px;">
  <a href="{{issue.url}}" style="background: #228be6; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px;">Track Progress</a>
</p>

<hr style="margin: 30px 0; border: none; border-top: 1px solid #ddd;">

<p style="color: #666; font-size: 12px;">
  Need urgent assistance? Contact us at support@isostack.app<br>
  Reference: Issue #{{issue.number}}
</p>
```

### Template 3: Support Ticket Created

**Key:** `support_ticket_created`  
**Scope:** Platform  
**Category:** Support

**Subject:**
```
[Support] Ticket #{{ticket.number}}: {{ticket.subject}}
```

**Body:**
```html
<h2>New Support Ticket</h2>

<p>A new support ticket has been created.</p>

<table style="border-collapse: collapse; width: 100%; margin: 20px 0;">
  <tr>
    <td style="padding: 10px; border: 1px solid #ddd; width: 150px;"><strong>Ticket</strong></td>
    <td style="padding: 10px; border: 1px solid #ddd;">#{{ticket.number}}</td>
  </tr>
  <tr>
    <td style="padding: 10px; border: 1px solid #ddd;"><strong>Subject</strong></td>
    <td style="padding: 10px; border: 1px solid #ddd;">{{ticket.subject}}</td>
  </tr>
  <tr>
    <td style="padding: 10px; border: 1px solid #ddd;"><strong>Category</strong></td>
    <td style="padding: 10px; border: 1px solid #ddd;">{{ticket.category}}</td>
  </tr>
  <tr>
    <td style="padding: 10px; border: 1px solid #ddd;"><strong>Priority</strong></td>
    <td style="padding: 10px; border: 1px solid #ddd;">{{ticket.priority}}</td>
  </tr>
  <tr>
    <td style="padding: 10px; border: 1px solid #ddd;"><strong>Submitted by</strong></td>
    <td style="padding: 10px; border: 1px solid #ddd;">{{ticket.createdBy.name}}</td>
  </tr>
</table>

<h3>Message</h3>
<div style="background: #f5f5f5; padding: 15px; border-left: 4px solid #fa5252;">
  {{ticket.message}}
</div>

<p style="margin-top: 30px;">
  <a href="{{ticket.url}}" style="background: #fa5252; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px;">View Ticket</a>
</p>
```

---

## Testing Strategy

### Unit Tests
- Template engine shortcode parsing
- Cascading template lookup
- Cascading recipient lookup
- Variable substitution edge cases

### Integration Tests
- Email sending end-to-end
- Template rendering with real data
- Recipient routing by category
- Email logging

### Manual Testing Checklist
- [ ] Create template via UI
- [ ] Edit template with shortcodes
- [ ] Preview template with test data
- [ ] Send test email
- [ ] Verify email received correctly
- [ ] Create recipient with category
- [ ] Test category-based routing
- [ ] Test module → platform fallback
- [ ] Create issue and verify email sent
- [ ] Update issue status and verify email sent
- [ ] Check email logs show sent emails
- [ ] Retry failed email from logs
- [ ] Test role-specific templates (P1 vs C1)

---

## Security Considerations

### Multi-Tenant Data Isolation (CRITICAL)
**All email operations MUST be scoped by `organizationId`:**

```typescript
// ✅ CORRECT - Scoped to user's organization
const templates = await prisma.emailTemplate.findMany({
  where: { 
    organizationId: user.organizationId,
    scope: EmailTemplateScope.ORGANIZATION
  }
});

// ❌ WRONG - Returns templates from ALL organizations
const templates = await prisma.emailTemplate.findMany({});
```

**Validation Rules:**
- User can only send emails to users in their organization
- C1/C2 can only customize templates for their organization
- EmailLog and UserEmail records scoped to organizationId
- Background batch processor validates organizationId for each job

### Role-Based Access Control

**Meta-Email Templates (Platform Settings):**
- **P1 (Platform Admin):** Full CRUD for platform defaults
- **C1/C2 (Org Admin/Owner):** Can customize org-scoped copies only
- **C3 (Member):** Read-only (cannot customize templates)

**Communication Emails (User Manager):**
- **P1:** Can send to any organization (support use case)
- **C1/C2:** Can send to users in their organization only
- **C3:** Cannot access email broadcast feature
- **Middleware:** `requireRole([Role.ADMIN, Role.OWNER])` for send endpoints

**Implementation:**
```typescript
// In tRPC router
export const emailRouter = router({
  sendCommunication: requireRole([Role.ADMIN, Role.OWNER])
    .input(z.object({ 
      recipientIds: z.array(z.string()),
      subject: z.string(),
      content: z.string() 
    }))
    .mutation(async ({ ctx, input }) => {
      // Validate all recipients belong to user's org
      const recipients = await ctx.prisma.user.findMany({
        where: { 
          id: { in: input.recipientIds },
          organizationId: ctx.session.user.organizationId
        }
      });
      
      if (recipients.length !== input.recipientIds.length) {
        throw new TRPCError({ 
          code: 'FORBIDDEN', 
          message: 'Cannot send to users outside your organization' 
        });
      }
      
      // Proceed with send...
    })
});
```

### Background Job Security

**Job Validation:**
- Each batch job stores `organizationId` in job metadata
- Worker validates organization exists before processing
- Failed jobs retry 3 times then alert P1 via Slack/email
- Job queue access restricted to background worker service

**Rate Limiting:**
- Per-organization send limits (future): 1000 emails/hour
- Resend API rate limits: 2 requests/second (enforced by batch processor)
- Prevent abuse: Monitor EmailLog for suspicious patterns

**Error Handling:**
- Never expose Resend API keys in client code
- Log failures without exposing recipient PII
- Sanitize error messages displayed to users

### Template Security

**Shortcode Validation (Meta-Emails):**
- Whitelist allowed shortcodes (prevent arbitrary code execution)
- Escape HTML in user-provided template content
- Validate JSON structure before parsing
- Preview mode uses test data (no real user data exposed)

**Rich Text Editor (Communication Emails):**
- Mantine RichTextEditor sanitizes HTML automatically
- Block `<script>` tags, `onerror` attributes, external resources
- Content Security Policy headers on email preview routes

### Audit Trail

**All email operations logged to `AuditLog` table:**
```typescript
await ctx.prisma.auditLog.create({
  data: {
    action: 'EMAIL_SENT',
    entityType: 'UserEmail',
    entityId: email.id,
    metadata: { 
      recipientCount: recipients.length,
      subject: input.subject,
      moduleContext: input.moduleContext 
    },
    userId: ctx.session.user.id,
    organizationId: ctx.session.user.organizationId,
    ipAddress: ctx.req?.ip,
    userAgent: ctx.req?.headers['user-agent']
  }
});
```

**What gets logged:**
- Meta-email template customizations (create/update/delete)
- Meta-email sends (trigger, recipient category, template used)
- Communication email sends (recipient count, title, sender)
- Background job failures (error type, affected organization)

### Privacy & Compliance

**GDPR Considerations:**
- Email logs retained for 90 days (configurable)
- Users can request email history export
- Delete user cascade removes EmailRecipientLog records
- Unsubscribe mechanism (Phase 12 - future)

**NHS/Healthcare Compliance:**
- No patient data in email subject lines
- Encrypted transport (Resend uses TLS)
- Audit trail for all communications
- Data retention policies enforced

---

## Module Metadata Filtering Architecture

### Overview
Modules define filterable user metadata to enable targeted email broadcasts. Metadata is registered in `module.config.ts` and dynamically rendered as filter panels in User Manager.

### Module Configuration Pattern

**File:** `src/modules/[module]/module.config.ts`
```typescript
import { ModuleConfig } from '@/types/module';

export const djflModuleConfig: ModuleConfig = {
  key: 'djfl',
  name: 'Don Johnstone Football League',
  description: 'Team and fixture management',
  routes: [...],
  
  // NEW: User metadata filters for email targeting
  userMetadataFilters: [
    {
      key: 'moduleRole',
      label: 'Module Role',
      type: 'select',
      options: [
        { value: 'team_manager', label: 'Team Manager' },
        { value: 'coach', label: 'Coach' },
        { value: 'parent', label: 'Parent' },
        { value: 'player', label: 'Player' }
      ]
    },
    {
      key: 'ageGroup',
      label: 'Age Group',
      type: 'multiselect',
      options: [
        { value: 'u7', label: 'Under 7' },
        { value: 'u8', label: 'Under 8' },
        { value: 'u9', label: 'Under 9' },
        { value: 'u10', label: 'Under 10' },
        { value: 'u11', label: 'Under 11' },
        { value: 'u12', label: 'Under 12' },
        { value: 'u13', label: 'Under 13' },
        { value: 'u14', label: 'Under 14' }
      ]
    },
    {
      key: 'division',
      label: 'Division',
      type: 'multiselect',
      options: [
        { value: '1', label: 'Division 1' },
        { value: '2', label: 'Division 2' },
        { value: '3', label: 'Division 3' }
      ]
    },
    {
      key: 'status',
      label: 'User Status',
      type: 'select',
      options: [
        { value: 'active', label: 'Active' },
        { value: 'inactive', label: 'Inactive' }
      ]
    }
  ]
};
```

**TypeScript Interface:**
```typescript
export interface UserMetadataFilter {
  key: string;                    // Metadata field name
  label: string;                  // Display label in UI
  type: 'select' | 'multiselect'; // Filter UI component
  options: Array<{                // Available values
    value: string;
    label: string;
  }>;
}

export interface ModuleConfig {
  key: string;
  name: string;
  description: string;
  routes: ModuleRoute[];
  userMetadataFilters?: UserMetadataFilter[]; // Optional - not all modules need filtering
}
```

### Database Schema for Module Metadata

**User Metadata Storage:**
Modules store user-specific metadata in their own schemas. DJFL example:

```prisma
model DJFLUserProfile {
  id             String   @id @default(cuid())
  userId         String   @unique
  user           User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  organizationId String
  organization   Organization @relation(fields: [organizationId], references: [id])
  
  // Module-specific metadata (filterable fields)
  moduleRole     String   // 'team_manager', 'coach', 'parent', 'player'
  ageGroup       String[] // ['u7', 'u8', 'u9']
  division       String[] // ['1', '2']
  status         String   @default("active") // 'active', 'inactive'
  
  createdAt      DateTime @default(now())
  updatedAt      DateTime @updatedAt
  
  @@index([organizationId])
  @@index([userId])
}
```

### Filter Query Builder

**Helper Function:** `src/lib/email/get-filtered-module-users.ts`
```typescript
import { prisma } from '@/lib/prisma';
import { getModuleConfig } from '@/modules/module.registry';

interface FilterCriteria {
  moduleKey: string;
  organizationId: string;
  filters: Record<string, string | string[]>; // { moduleRole: 'coach', ageGroup: ['u7', 'u8'] }
}

export async function getFilteredModuleUsers(criteria: FilterCriteria) {
  const moduleConfig = getModuleConfig(criteria.moduleKey);
  
  if (!moduleConfig?.userMetadataFilters) {
    throw new Error(`Module ${criteria.moduleKey} does not define user metadata filters`);
  }
  
  // Build dynamic query based on module schema
  const whereClause: any = {
    organizationId: criteria.organizationId
  };
  
  // Apply each filter
  for (const [key, value] of Object.entries(criteria.filters)) {
    if (Array.isArray(value)) {
      // Multi-select: value IN array
      whereClause[key] = { hasSome: value };
    } else {
      // Single select: exact match
      whereClause[key] = value;
    }
  }
  
  // Dynamic query to module-specific table
  const tableName = `${criteria.moduleKey}UserProfile`; // e.g., 'djflUserProfile'
  const profiles = await (prisma as any)[tableName].findMany({
    where: whereClause,
    include: {
      user: {
        select: {
          id: true,
          email: true,
          name: true,
          status: true
        }
      }
    }
  });
  
  return profiles.map(p => p.user);
}
```

### UI Integration (User Manager)

**Filter Panel Component:** `src/app/(app)/[module]/users/FilterPanel.tsx`
```typescript
'use client';
import { Select, MultiSelect, Stack, Button, Group } from '@mantine/core';
import { useModuleConfig } from '@/core/hooks/useModuleConfig';

interface FilterPanelProps {
  moduleKey: string;
  onFilterChange: (filters: Record<string, string | string[]>) => void;
}

export function FilterPanel({ moduleKey, onFilterChange }: FilterPanelProps) {
  const moduleConfig = useModuleConfig(moduleKey);
  const [filters, setFilters] = useState<Record<string, string | string[]>>({});
  
  if (!moduleConfig?.userMetadataFilters) {
    return null; // Module doesn't support filtering
  }
  
  const handleFilterChange = (key: string, value: string | string[]) => {
    const newFilters = { ...filters, [key]: value };
    setFilters(newFilters);
    onFilterChange(newFilters);
  };
  
  return (
    <Stack gap="md">
      {moduleConfig.userMetadataFilters.map(filter => (
        <div key={filter.key}>
          {filter.type === 'select' ? (
            <Select
              label={filter.label}
              placeholder={`Select ${filter.label}`}
              data={filter.options}
              value={filters[filter.key] as string}
              onChange={(value) => handleFilterChange(filter.key, value || '')}
              clearable
            />
          ) : (
            <MultiSelect
              label={filter.label}
              placeholder={`Select ${filter.label}`}
              data={filter.options}
              value={filters[filter.key] as string[]}
              onChange={(value) => handleFilterChange(filter.key, value)}
              clearable
            />
          )}
        </div>
      ))}
      
      <Group>
        <Button onClick={() => { setFilters({}); onFilterChange({}); }}>
          Clear Filters
        </Button>
        <Button variant="filled">
          Apply Filters
        </Button>
      </Group>
    </Stack>
  );
}
```

**User Manager Page with Email Button:**
```typescript
// src/app/(app)/[module]/users/page.tsx
'use client';
import { FilterPanel } from './FilterPanel';
import { useState } from 'react';
import { trpc } from '@/lib/trpc/client';
import { Button, Group } from '@mantine/core';

export default function ModuleUsersPage({ params }: { params: { module: string } }) {
  const [filters, setFilters] = useState({});
  const [selectedUsers, setSelectedUsers] = useState<string[]>([]);
  
  const { data: users } = trpc.modules.users.list.useQuery({
    moduleKey: params.module,
    filters
  });
  
  const handleEmailClick = () => {
    // Open RecipientPreviewModal with selectedUsers
  };
  
  return (
    <div>
      <Group justify="space-between">
        <h1>{params.module} Users</h1>
        <Button 
          onClick={handleEmailClick}
          disabled={selectedUsers.length === 0}
        >
          Email Selected ({selectedUsers.length})
        </Button>
      </Group>
      
      <FilterPanel 
        moduleKey={params.module}
        onFilterChange={setFilters}
      />
      
      {/* User table with checkboxes */}
    </div>
  );
}
```

### Example: DJFL Module Email Use Case

**Scenario:** Send training update to all U7 and U8 coaches

**User Flow:**
1. Navigate to DJFL → Users
2. Apply filters:
   - Module Role: Coach
   - Age Group: [Under 7, Under 8]
3. Click "Email Selected (12)" button
4. Preview modal shows 12 recipients
5. Click "Compose Email"
6. Email composer opens with pre-filled recipients
7. Write subject: "U7/U8 Training Schedule Update"
8. Write content using rich text editor
9. Click "Send Email"
10. Background batch processor sends to 12 recipients
11. Success notification: "Email queued for 12 recipients"

**Backend Query:**
```typescript
const users = await getFilteredModuleUsers({
  moduleKey: 'djfl',
  organizationId: user.organizationId,
  filters: {
    moduleRole: 'coach',
    ageGroup: ['u7', 'u8']
  }
});
// Returns 12 users matching criteria
```

### Testing Module Metadata

**Seed Data:** `prisma/seed.ts` should populate test metadata
```typescript
// Seed DJFL user profiles with diverse metadata
await prisma.dJFLUserProfile.createMany({
  data: [
    { userId: user1.id, organizationId: org.id, moduleRole: 'coach', ageGroup: ['u7'], division: ['1'], status: 'active' },
    { userId: user2.id, organizationId: org.id, moduleRole: 'coach', ageGroup: ['u8'], division: ['1'], status: 'active' },
    { userId: user3.id, organizationId: org.id, moduleRole: 'team_manager', ageGroup: ['u7', 'u8'], division: ['1', '2'], status: 'active' },
    // ... more test data
  ]
});
```

**Validation Tests:**
- ✅ Filter returns correct user count
- ✅ Multi-select combines filters with OR logic (ageGroup: ['u7', 'u8'] → users in EITHER group)
- ✅ Organization scoping enforced (cannot query other orgs' metadata)
- ✅ Module without userMetadataFilters returns all org users

---

## Migration Strategy

### Existing Email Sending Code
Identify all current email sends:
```bash
grep -r "resend.emails.send" src/
grep -r "sendEmail" src/
```

### Migration Approach
1. Keep existing email functions working
2. Add new notification system alongside
3. Gradually migrate each use case to new system
4. Deprecate old functions once migrated
5. Remove old code in final cleanup

### Backward Compatibility
- Existing hardcoded emails continue to work
- New features use notification system by default
- Provide migration utility to convert existing emails to templates

---

## Success Metrics

### Meta-Email System (Automated Notifications)
**Adoption Metrics:**
- [ ] P1 creates 10+ platform default templates (Issue Tracker, User onboarding, etc.)
- [ ] 50% of C1/C2 organizations customize at least 1 template
- [ ] 80% of Issue Tracker events trigger meta-email notifications within 5 seconds

**Technical Metrics:**
- [ ] 99.5% email delivery success rate (via Resend)
- [ ] <2 second template rendering time (shortcode parsing + data fetch)
- [ ] <5 second average send latency (trigger → Resend API call)
- [ ] 0 multi-tenant data leaks (all queries scoped by organizationId)

**User Satisfaction:**
- [ ] C1/C2 report satisfaction >4/5 with template customization UI
- [ ] <5% support tickets about email configuration
- [ ] C3 users receive relevant, timely notifications (measured by click-through rate)

### User Communication System (Manual Broadcasts)
**Adoption Metrics:**
- [ ] 60% of C1/C2 organizations send at least 1 communication email per month
- [ ] Average 50 recipients per communication email
- [ ] 30% of broadcasts use module metadata filtering (vs sending to all users)

**Technical Metrics:**
- [ ] 99.5% batch processing success rate (queued → sent)
- [ ] <30 second batch send time for 100 recipients
- [ ] <10 minute batch send time for 1000 recipients
- [ ] Background job failure rate <1% (with automatic retry)

**User Satisfaction:**
- [ ] C1/C2 report satisfaction >4/5 with email composer and filtering
- [ ] <10% support tickets about communication email usage
- [ ] 70% of emails opened within 24 hours (industry standard: 20-40%)

### System Health
- [ ] <1 hour downtime per quarter (Resend + IsoStack uptime)
- [ ] <5% email bounce rate (invalid addresses)
- [ ] 100% audit trail compliance (all sends logged)
- [ ] <1% spam complaint rate

---

## Future Enhancements (Post-MVP)

### Phase 12: Advanced Recipient Management (1 week)
- **Unsubscribe System:** User-controlled email preferences
- **Email Categories:** Marketing, Transactional, System (separate opt-in/out)
- **Frequency Limiting:** Prevent email fatigue (max 5 emails/day per user)

### Phase 13: Template Library & Marketplace (2 weeks)
- **Industry Templates:** Pre-built templates for specific sectors (sports, education, healthcare)
- **Template Sharing:** C1/C2 share custom templates with other organizations (opt-in)
- **Template Marketplace:** Platform-approved templates available for purchase/free

### Phase 14: Advanced Analytics (1 week)
- **Open Rate Tracking:** Pixel-based tracking (privacy-compliant)
- **Click-Through Tracking:** Link click analytics
- **Engagement Dashboard:** Per-template and per-organization metrics
- **A/B Testing:** Test subject lines and content variations

### Phase 15: Email Automation Workflows (3 weeks)
- **Trigger Chains:** "User joined → Send welcome email → Wait 3 days → Send onboarding checklist"
- **Conditional Logic:** IF user hasn't logged in THEN send reminder
- **Schedule Delays:** Send at specific time/date (not immediate)
- **Visual Workflow Builder:** Drag-and-drop automation designer

### Phase 16: Multi-Channel Notifications (2 weeks)
- **SMS Integration:** Twilio for urgent notifications
- **Push Notifications:** Web + Mobile app push
- **Slack/Teams:** Workspace integrations
- **Unified Notification Center:** In-app notification hub

### Phase 17: Advanced Template Features (1 week)
- **Dynamic Content Blocks:** Show/hide sections based on recipient data
- **Personalization Engine:** ML-based content recommendations
- **Multi-Language Support:** Translate templates per user preference
- **Attachment Management:** Attach files from Cloudflare R2

### Phase 18: Compliance & Security Enhancements (1 week)
- **GDPR Consent Tracking:** Record explicit opt-in for marketing emails
- **Right to be Forgotten:** Automated data deletion workflow
- **Encryption at Rest:** Encrypt email content in database
- **Advanced Audit Logs:** Include email content snapshots, retention policies

---

## Resources & Dependencies

### External Services
- **Resend API:** Email delivery (already integrated)
- **Prisma:** Database ORM
- **React Email:** Template builder (optional)

### Internal Dependencies
- Issue Tracker (existing)
- Support Centre (future)
- Billing System (future)

### Development Tools
- Prisma Studio (database management)
- Postman/Thunder Client (API testing)
- Email preview tools (Litmus, Email on Acid)

---

## Phase-Based Implementation (REVISED)

### Phase 1: Database Schema & Core Models (Week 1 - 3 days)

**Goal:** Establish unified email system foundation

**Tasks:**
1. Add all models to `prisma/schema.prisma`:
   - `EmailTemplate` (meta-emails)
   - `EmailRecipient` (recipient routing)
   - `EmailLog` (meta-email audit)
   - `UserEmail` (communication emails)
   - `EmailRecipientLog` (delivery tracking)
2. Add enums: `EmailTemplateScope`, `EmailRecipientScope`, `EmailStatus`, `EmailDeliveryStatus`
3. Run migration: `npx prisma migrate dev --name add_unified_email_system`
4. Create seed data for default meta-email templates
5. Test schema in Prisma Studio

**Deliverables:**
- ✅ Schema updated and migrated
- ✅ 5-7 default meta-email templates seeded (issue created, user invited, etc.)
- ✅ Test data in database

**Acceptance Criteria:**
- Schema validates with `npm run type-check`
- Prisma Studio shows all tables correctly
- Seed script creates sample templates

---

### Phase 2: Template Engine & Shortcode Parser (Week 1-2 - 4 days)

**Goal:** Build template rendering engine for meta-emails

**File:** `src/lib/email/template-engine.ts`

**Core Functions:**
```typescript
/**
 * Parse and replace shortcodes in meta-email templates
 */
export function renderTemplate(
  template: string,
  variables: Record<string, any>
): string;

/**
 * Get available shortcodes for template type
 */
export function getAvailableShortcodes(
  templateType: string
): ShortcodeDefinition[];

/**
 * Validate template syntax
 */
export function validateTemplate(
  template: string
): { valid: boolean; errors: string[] };

/**
 * Extract shortcodes from template
 */
export function extractShortcodes(template: string): string[];
```

**Implementation:**
```typescript
// Simple regex-based shortcode parser
const SHORTCODE_PATTERN = /\{\{([a-zA-Z0-9._]+)\}\}/g;

export function renderTemplate(
  template: string,
  variables: Record<string, any>
): string {
  return template.replace(SHORTCODE_PATTERN, (match, path) => {
    const value = getNestedValue(variables, path);
    return value !== undefined ? String(value) : match;
  });
}

function getNestedValue(obj: any, path: string): any {
  return path.split('.').reduce((current, key) => current?.[key], obj);
}
```

**Tests:**
- Unit tests for shortcode parsing
- Edge cases: nested objects, missing values, invalid syntax
- Performance test with 50+ shortcodes

**Deliverables:**
- ✅ Template engine library
- ✅ Shortcode registry
- ✅ Validation functions
- ✅ Unit tests (>90% coverage)

---

### Phase 3: Meta-Email Template CRUD (Week 2 - 3 days)

**File:** `src/server/actions/email-templates.ts`

**Server Actions:**
```typescript
// Get templates with filtering
export async function getEmailTemplates(filters: {
  scope?: EmailTemplateScope;
  moduleSlug?: string;
  organizationId?: string;
  active?: boolean;
}): Promise<EmailTemplate[]>;

// Get single template
export async function getEmailTemplate(id: string): Promise<EmailTemplate | null>;

// Get template by key with cascading lookup
export async function getTemplateByKey(
  templateKey: string,
  organizationId: string
): Promise<EmailTemplate | null>;

// Create platform template (P1 only)
export async function createPlatformTemplate(
  data: CreateEmailTemplateInput
): Promise<EmailTemplate>;

// Customize org template (C1/C2 - creates org-scoped copy)
export async function customizeTemplate(
  platformTemplateId: string,
  organizationId: string,
  data: CustomizeTemplateInput
): Promise<EmailTemplate>;

// Reset to platform default (C1/C2 - deletes org copy)
export async function resetToDefault(
  templateId: string,
  organizationId: string
): Promise<void>;

// Update template
export async function updateEmailTemplate(
  id: string,
  data: UpdateEmailTemplateInput
): Promise<EmailTemplate>;

// Delete platform template (P1 only - marks inactive)
export async function deleteEmailTemplate(id: string): Promise<void>;

// Preview template with test data
export async function previewEmailTemplate(
  templateId: string,
  testData: Record<string, any>
): Promise<{ subject: string; bodyHtml: string }>;
```

**Cascading Lookup Logic:**
```typescript
export async function getTemplateByKey(
  templateKey: string,
  organizationId: string
): Promise<EmailTemplate | null> {
  // 1. Try organization-specific copy (C1/C2 customized)
  const orgTemplate = await prisma.emailTemplate.findFirst({
    where: { 
      templateKey, 
      scope: 'ORGANIZATION',
      organizationId,
      active: true,
    },
  });
  if (orgTemplate) return orgTemplate;
  
  // 2. Fall back to platform default (P1 created)
  return await prisma.emailTemplate.findFirst({
    where: { 
      templateKey, 
      scope: 'PLATFORM',
      active: true,
    },
  });
}
```

**Deliverables:**
- ✅ CRUD server actions for meta-email templates
- ✅ Cascading template lookup (Org → Platform)
- ✅ Org customization workflow (copy platform template)
- ✅ Reset to default functionality
- ✅ Preview functionality
- ✅ Permission checks (P1 for platform, C1/C2 for org)

---

### Phase 4: Email Recipient Management (Week 2 - 2 days)

**File:** `src/server/actions/email-recipients.ts`

**Server Actions:**
```typescript
// Get recipients
export async function getEmailRecipients(filters: {
  category?: string;
  scope?: EmailRecipientScope;
  organizationId?: string;
  active?: boolean;
}): Promise<EmailRecipient[]>;

// Create recipient (P1 or C1/C2 for their org)
export async function createEmailRecipient(
  data: CreateEmailRecipientInput
): Promise<EmailRecipient>;

// Update recipient
export async function updateEmailRecipient(
  id: string,
  data: UpdateEmailRecipientInput
): Promise<EmailRecipient>;

// Delete recipient
export async function deleteEmailRecipient(id: string): Promise<void>;

// Get recipient for category with fallback
export async function getRecipientForCategory(
  category: string,
  organizationId?: string
): Promise<EmailRecipient | null>;
```

**Cascading Recipient Logic:**
```typescript
export async function getRecipientForCategory(
  category: string,
  organizationId?: string
): Promise<EmailRecipient | null> {
  // 1. Try organization-specific recipient
  if (organizationId) {
    const orgRecipient = await prisma.emailRecipient.findFirst({
      where: { 
        category, 
        scope: 'ORGANIZATION',
        organizationId,
        active: true,
      },
      orderBy: { isPrimary: 'desc' },
    });
    if (orgRecipient) return orgRecipient;
  }
  
  // 2. Fall back to platform default
  return await prisma.emailRecipient.findFirst({
    where: { 
      category,
      scope: 'PLATFORM',
      active: true,
      isPrimary: true,
    },
  });
}
```

**Deliverables:**
- ✅ Recipient CRUD actions
- ✅ Cascading recipient lookup (Org → Platform)
- ✅ Category-based routing

---

### Phase 5: Unified Email Sending Service (Week 3 - 5 days)

**Files:**
- `src/lib/email/send-meta-email.ts` (automated notifications)
- `src/lib/email/send-communication-email.ts` (user broadcasts)
- `src/lib/email/resend-batch.ts` (background batch processor)

#### 5.1 Meta-Email Service

**File:** `src/lib/email/send-meta-email.ts`

```typescript
export interface SendMetaEmailOptions {
  templateKey: string;
  recipient: string | string[];
  variables: Record<string, any>;
  
  // Context for logging
  triggerEvent: string;
  entityType?: string;
  entityId?: string;
  userId?: string;
  organizationId?: string;
}

export async function sendMetaEmail(
  options: SendMetaEmailOptions
): Promise<{ success: boolean; emailLogId: string; error?: string }> {
  try {
    // 1. Get template with cascading lookup
    const template = await getTemplateByKey(
      options.templateKey,
      options.organizationId
    );
    
    if (!template) {
      throw new Error(`Template not found: ${options.templateKey}`);
    }
    
    // 2. Render subject and body
    const subject = renderTemplate(template.subject, options.variables);
    const bodyHtml = renderTemplate(template.bodyHtml, options.variables);
    
    // 3. Get recipient(s)
    const recipients = Array.isArray(options.recipient) 
      ? options.recipient 
      : [options.recipient];
    
    // 4. Send via Resend (single or small batch)
    const { data, error } = await resend.emails.send({
      from: 'IsoStack <noreply@isostack.app>',
      to: recipients,
      subject,
      html: bodyHtml,
    });
    
    // 5. Log email
    const emailLog = await prisma.emailLog.create({
      data: {
        templateKey: options.templateKey,
        recipient: recipients.join(', '),
        subject,
        bodyHtml,
        triggerEvent: options.triggerEvent,
        entityType: options.entityType,
        entityId: options.entityId,
        organizationId: options.organizationId,
        userId: options.userId,
        status: error ? 'FAILED' : 'SENT',
        error: error?.message,
        sentAt: error ? null : new Date(),
      },
    });
    
    return { 
      success: !error, 
      emailLogId: emailLog.id,
      error: error?.message,
    };
    
  } catch (error: any) {
    // Log failed attempt
    const emailLog = await prisma.emailLog.create({
      data: {
        templateKey: options.templateKey,
        recipient: Array.isArray(options.recipient) ? options.recipient.join(', ') : options.recipient,
        subject: 'Failed to render',
        bodyHtml: error.message,
        triggerEvent: options.triggerEvent,
        entityType: options.entityType,
        entityId: options.entityId,
        organizationId: options.organizationId,
        status: 'FAILED',
        error: error.message,
      },
    });
    
    return { 
      success: false, 
      emailLogId: emailLog.id,
      error: error.message,
    };
  }
}
```

#### 5.2 Communication Email Service

**File:** `src/lib/email/send-communication-email.ts`

```typescript
export interface SendCommunicationEmailOptions {
  title: string;              // Internal reference
  subject: string;            // Actual subject line
  bodyHtml: string;           // Rich text content
  recipients: Array<{         // Filtered users
    email: string;
    name: string;
    userId: string;
  }>;
  moduleSlug: string;
  organizationId: string;
  sentById: string;
  recipientFilter: any;       // Filter criteria for audit
  attachments?: Array<{       // R2 file references
    fileId: string;
    fileName: string;
    fileUrl: string;
  }>;
}

export async function sendCommunicationEmail(
  options: SendCommunicationEmailOptions
): Promise<{ success: boolean; emailId: string; error?: string }> {
  try {
    // 1. Create UserEmail record
    const userEmail = await prisma.userEmail.create({
      data: {
        title: options.title,
        subject: options.subject,
        bodyHtml: options.bodyHtml,
        recipientCount: options.recipients.length,
        recipientFilter: options.recipientFilter,
        moduleSlug: options.moduleSlug,
        organizationId: options.organizationId,
        sentById: options.sentById,
        attachments: options.attachments || null,
        status: 'SENDING',
      },
    });
    
    // 2. Create recipient logs
    await prisma.emailRecipientLog.createMany({
      data: options.recipients.map(r => ({
        emailId: userEmail.id,
        recipientEmail: r.email,
        recipientName: r.name,
        userId: r.userId,
        status: 'QUEUED',
      })),
    });
    
    // 3. Queue background batch job
    await queueEmailBatch({
      emailId: userEmail.id,
      recipients: options.recipients,
      subject: options.subject,
      bodyHtml: options.bodyHtml,
      attachments: options.attachments,
    });
    
    // 4. Return immediately (batch processes in background)
    return {
      success: true,
      emailId: userEmail.id,
    };
    
  } catch (error: any) {
    return {
      success: false,
      emailId: '',
      error: error.message,
    };
  }
}
```

#### 5.3 Resend Batch Processor

**File:** `src/lib/email/resend-batch.ts`

```typescript
interface BatchJob {
  emailId: string;
  recipients: Array<{ email: string; name: string; userId: string }>;
  subject: string;
  bodyHtml: string;
  attachments?: any[];
}

/**
 * Background batch processor for large email sends
 * Respects Resend rate limits: 2 requests/second, 100 emails/batch
 */
export async function queueEmailBatch(job: BatchJob): Promise<void> {
  // Queue implementation (simple in-memory queue for MVP)
  // Future: Use Redis/Bull queue or Render background workers
  
  try {
    const batches = chunkArray(job.recipients, 100); // Resend batch limit
    let successCount = 0;
    let failCount = 0;
    
    for (const batch of batches) {
      // Send batch
      const { data, error } = await resend.batch.send(
        batch.map(recipient => ({
          from: 'IsoStack <noreply@isostack.app>',
          to: recipient.email,
          subject: job.subject,
          html: job.bodyHtml,
        }))
      );
      
      // Update recipient logs
      if (!error) {
        successCount += batch.length;
        await prisma.emailRecipientLog.updateMany({
          where: {
            emailId: job.emailId,
            recipientEmail: { in: batch.map(r => r.email) },
          },
          data: {
            status: 'SENT',
            sentAt: new Date(),
          },
        });
      } else {
        failCount += batch.length;
        await prisma.emailRecipientLog.updateMany({
          where: {
            emailId: job.emailId,
            recipientEmail: { in: batch.map(r => r.email) },
          },
          data: {
            status: 'FAILED',
            error: error.message,
          },
        });
      }
      
      // Rate limit: 2 requests/second = 500ms between batches
      if (batches.indexOf(batch) < batches.length - 1) {
        await sleep(500);
      }
    }
    
    // Update UserEmail status
    await prisma.userEmail.update({
      where: { id: job.emailId },
      data: {
        status: failCount === 0 ? 'SENT' : (successCount === 0 ? 'FAILED' : 'PARTIAL'),
        sentAt: new Date(),
        deliveryStats: {
          sent: successCount + failCount,
          delivered: successCount,
          failed: failCount,
        },
      },
    });
    
  } catch (error: any) {
    // Mark entire batch as failed
    await prisma.userEmail.update({
      where: { id: job.emailId },
      data: {
        status: 'FAILED',
        deliveryStats: { error: error.message },
      },
    });
  }
}

function chunkArray<T>(array: T[], size: number): T[][] {
  const chunks: T[][] = [];
  for (let i = 0; i < array.length; i += size) {
    chunks.push(array.slice(i, i + size));
  }
  return chunks;
}

function sleep(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}
```

**Deliverables:**
- ✅ Meta-email sending service (automated notifications)
- ✅ Communication email service (user broadcasts)
- ✅ Resend batch processor (background, rate-limited)
- ✅ Email logging for both types
- ✅ Error handling with fallback
- ✅ Resend API integration (single + batch endpoints)

---

### Phase 6: Platform Settings UI (Meta-Email Management) (Week 3-4 - 5 days)

**File:** `src/app/(app)/platform/settings/email/page.tsx`

**UI Components (3 Tabs):**

1. **Email Templates Tab:**
   - DataTable with platform templates
   - Columns: Name, Key, Module, Category, Active, Last Updated
   - Actions: [Create] [Edit] [Duplicate] [Deactivate]
   - Create/Edit modal with:
     - Rich text editor for HTML body
     - Shortcode picker/helper
     - Preview pane with test data
     - Role targeting selector

2. **Email Recipients Tab:**
   - DataTable with recipients
   - Columns: Name, Email, Category, Scope, Primary, Active
   - Actions: [Add Recipient] [Edit] [Delete]
   - Create/Edit modal with:
     - Category selector
     - Signature editor
     - Set as primary checkbox
     - Test email button

3. **Email Logs Tab:**
   - DataTable with meta-email logs
   - Columns: Date, Template, Recipient, Status, Event, Entity
   - Filters: Status, Template, Date Range, Entity Type
   - Actions: [View Details] [Export CSV]
   - View modal shows full email preview

**Files Structure:**
```
src/app/(app)/platform/settings/email/
├── page.tsx                          # Main page with 3 tabs
├── components/
│   ├── TemplatesTab.tsx              # Platform template management
│   ├── RecipientsTab.tsx             # Recipient management
│   ├── EmailLogsTab.tsx              # Meta-email history
│   ├── TemplateEditor.tsx            # Template CRUD modal
│   ├── RecipientEditor.tsx           # Recipient CRUD modal
│   ├── ShortcodePicker.tsx           # Shortcode helper
│   └── EmailPreview.tsx              # Preview rendered email
```

**Key Features:**
- 📝 Rich text editor (Mantine RichTextEditor)
- 🔍 Shortcode autocomplete
- 👁️ Live preview as you type
- 📧 Send test email to yourself
- 📋 Template duplication
- 🎨 Syntax highlighting for shortcodes

**Deliverables:**
- ✅ Complete platform email settings UI
- ✅ Template CRUD interface (P1 only)
- ✅ Recipient CRUD interface
- ✅ Email log viewer
- ✅ Test email functionality

---

### Phase 7: Module Settings UI (Meta-Email Customization) (Week 4 - 3 days)

**File:** `src/app/(app)/[module]/settings/page.tsx` (add Email tab)

**UI Components:**

**Module Settings → [Mod Name] Emails Tab:**
- Card-based layout (one card per template)
- Each card shows:
  - Template name
  - Badge: "Platform Default" (gray) or "Customized" (blue)
  - Preview: Subject line + first 50 chars of body
  - Actions: [Customize] or [Edit] + [Reset to Default]

**Customization Flow:**
1. Click "Customize" on platform default card
2. Modal opens with platform template content pre-filled
3. C1/C2 edits subject/body/shortcodes
4. Save creates org-scoped copy (isCustomized = true)
5. Card badge changes to "Customized" (blue)
6. "Reset to Default" button deletes org copy

**Customize Modal:**
```
┌─── Customize Email Template: Issue Created ────────────┐
│                                                         │
│ Platform Default: [View Original] (read-only modal)    │
│                                                         │
│ Subject: [Input with shortcodes]                       │
│ {{issue.number}}, {{issue.title}}                      │
│                                                         │
│ Body: [Mantine RichTextEditor]                         │
│ <h2>Issue Created</h2>                                 │
│ <p>Issue #{{issue.number}} reported...</p>             │
│                                                         │
│ [Shortcode Picker ▼]                                   │
│                                                         │
│ [Preview with Test Data]                               │
│                                                         │
├─────────────────────────────────────────────────────────┤
│ [Reset to Default] (left)  [Cancel] [Save Custom] (right)│
└─────────────────────────────────────────────────────────┘
```

**Files Structure:**
```
src/app/(app)/[module]/settings/
├── page.tsx                          # Add Email tab
├── components/
│   ├── EmailTemplatesTab.tsx         # Module email customization
│   ├── EmailTemplateCard.tsx         # Card per template
│   └── CustomizeTemplateModal.tsx    # Edit org-scoped copy
```

**Deliverables:**
- ✅ Module email settings tab
- ✅ Card-based template list
- ✅ Customization modal (C1/C2)
- ✅ Reset to platform default functionality
- ✅ Visual distinction (Platform vs Customized)

---

### Phase 8: User Manager Integration (Communication Emails) (Week 5-6 - 6 days)

**Goal:** Add email broadcast capability to module user management

**Location:** `src/app/(app)/[module]/users/page.tsx` (or create if not exists)

#### 8.1 User Manager Page Enhancement

**New Components:**
```
Module Dashboard → Users
├─ [Search + Sort] (existing pattern)
├─ [Filter Panel] (module-specific metadata)
│  ├─ Role filter (e.g., Team Manager, Coach)
│  ├─ Metadata filters (e.g., Age Group, Division)
│  └─ [Apply Filters] button
├─ [Email Button] ← NEW (top-right)
└─ DataTable (filtered users)
```

**Filter Panel Example (DJFL Module):**
```typescript
// Module-specific metadata fields (defined in module.config.ts)
export const moduleConfig = {
  id: 'djfl',
  name: 'DJFL',
  // ...
  userMetadataFilters: [
    {
      key: 'moduleRole',
      label: 'Module Role',
      type: 'multiselect',
      options: ['Team Manager', 'Coach', 'Assistant Coach', 'Admin']
    },
    {
      key: 'ageGroup',
      label: 'Age Group',
      type: 'multiselect',
      options: ['U7', 'U8', 'U9', 'U10', 'U11', 'U12', 'U13', 'U14']
    },
    {
      key: 'division',
      label: 'Division',
      type: 'multiselect',
      options: ['Division 1', 'Division 2', 'Division 3']
    },
    {
      key: 'status',
      label: 'Status',
      type: 'select',
      options: ['Active', 'Inactive', 'Pending']
    }
  ]
};
```

#### 8.2 Email Composer Modal

**Triggered by:** "Email" button (top-right of Users page)

**Two-Step Flow (Option A - per Q4):**

**Step 1: Recipient Preview Modal**
```
┌─── Email Recipients Preview ────────────────────────────┐
│                                                         │
│ 📊 Audience Summary                                     │
│ 127 users match your current filters                   │
│                                                         │
│ Applied Filters:                                        │
│ • Module Role: Team Manager, Coach                     │
│ • Age Group: U7, U8                                     │
│ • Status: Active                                        │
│                                                         │
│ [View Full List (127)] [Export CSV]                    │
│                                                         │
│ ⚠️ Warning: Email will be sent to all filtered users   │
│ Review your filters carefully before proceeding.        │
│                                                         │
├─────────────────────────────────────────────────────────┤
│                          [Cancel] [Proceed to Compose]  │
└─────────────────────────────────────────────────────────┘
```

**Step 2: Email Composer Modal**
```
┌─── Compose Email ────────────────────────────────────────┐
│                                                          │
│ 📧 Sending to 127 filtered users [View List]            │
│                                                          │
│ Title (Internal): [Q4 Training Updates]                 │
│                                                          │
│ Subject: [Important: New Training Schedule]             │
│                                                          │
│ Body:                                                    │
│ [Mantine RichTextEditor - Full WYSIWYG]                 │
│ • Bold, Italic, Underline                               │
│ • Links, Images (R2 upload)                             │
│ • Lists, Quotes                                          │
│ • Color, Alignment                                       │
│                                                          │
│ 📎 Attachments:                                          │
│ [Upload from R2 or local]                               │
│ • Training_Schedule.pdf (1.2 MB) [x Remove]             │
│                                                          │
│ ⚠️ No drafts - send immediately or discard              │
│                                                          │
├──────────────────────────────────────────────────────────┤
│                          [Cancel] [Send Email] (primary) │
└──────────────────────────────────────────────────────────┘
```

**Recipient List Modal (Click "View List"):**
```
┌─── Recipients (127 Users) ───────────────────────────────┐
│                                                          │
│ [Search...]                                              │
│                                                          │
│ ✓ John Smith (john@example.com)                         │
│   Role: Team Manager | Age Group: U7 | Division 1       │
│                                                          │
│ ✓ Jane Doe (jane@example.com)                           │
│   Role: Coach | Age Group: U7 | Division 1              │
│                                                          │
│ ... (showing 20 of 127) [Load More]                     │
│                                                          │
│ [Export Full List CSV]                   [Close]        │
└──────────────────────────────────────────────────────────┘
```

#### 8.3 Communications Tab (Email Archive)

**Location:** `src/app/(app)/[module]/communications/page.tsx`

**UI Layout:**
```
Module Dashboard → Communications
├─ [Search + Sort] (by title, subject, date)
├─ DataTable:
│  ├─ Columns:
│  │  • Date Sent
│  │  • Title (internal)
│  │  • Subject (actual)
│  │  • Recipients (count)
│  │  • Status (Sent/Failed/Partial)
│  │  • Delivery Rate (115/120)
│  │  • Actions: [View] [Copy]
└─ Pagination
```

**View Email Modal (Read-Only):**
```
┌─── Email Details: Q4 Training Updates ──────────────────┐
│                                                          │
│ Sent: December 18, 2025, 3:45 PM                        │
│ Sent by: Chris Thompson                                 │
│ Recipients: 127 users (125 delivered, 2 failed)         │
│                                                          │
│ Subject: Important: New Training Schedule               │
│                                                          │
│ Body:                                                    │
│ [Rendered HTML preview - read-only]                     │
│ <h2>Training Schedule Changes</h2>                      │
│ <p>Dear Team Managers and Coaches...</p>                │
│                                                          │
│ Attachments:                                             │
│ • Training_Schedule.pdf (1.2 MB) [Download]             │
│                                                          │
│ Delivery Details: [View All Recipients]                 │
│                                                          │
├──────────────────────────────────────────────────────────┤
│ [Copy Content] (copies to clipboard)        [Close]     │
└──────────────────────────────────────────────────────────┘
```

**Files Structure:**
```
src/app/(app)/[module]/
├── users/
│   ├── page.tsx                      # Add Email button
│   ├── components/
│   │   ├── UserFilterPanel.tsx       # Module metadata filters
│   │   ├── RecipientPreviewModal.tsx # Step 1: Preview filtered users
│   │   └── EmailComposerModal.tsx    # Step 2: Compose email
│   └── actions.ts                    # Server action: sendCommunicationEmail
│
└── communications/
    ├── page.tsx                      # Communications archive
    └── components/
        ├── CommunicationsTable.tsx   # DataTable of sent emails
        └── ViewEmailModal.tsx        # Read-only email viewer
```

**Server Actions:**
```typescript
// src/app/(app)/[module]/users/actions.ts

export async function sendCommunicationEmail(
  data: {
    title: string;
    subject: string;
    bodyHtml: string;
    recipientFilter: any;
    attachments?: any[];
  }
): Promise<{ success: boolean; emailId?: string; error?: string }> {
  const session = await getServerSession();
  
  // 1. Permission check (C1/C2 only, not C3)
  if (!['OWNER', 'ADMIN'].includes(session.user.role)) {
    return { success: false, error: 'Unauthorized' };
  }
  
  // 2. Get filtered users (module-specific metadata query)
  const recipients = await getFilteredModuleUsers({
    organizationId: session.user.organizationId,
    moduleSlug: data.moduleSlug,
    filters: data.recipientFilter,
  });
  
  // 3. Send via communication email service
  return await sendCommunicationEmail({
    title: data.title,
    subject: data.subject,
    bodyHtml: data.bodyHtml,
    recipients,
    moduleSlug: data.moduleSlug,
    organizationId: session.user.organizationId,
    sentById: session.user.id,
    recipientFilter: data.recipientFilter,
    attachments: data.attachments,
  });
}
```

**Deliverables:**
- ✅ User Manager filter panel (module metadata)
- ✅ Email button + recipient preview modal
- ✅ Email composer modal (Mantine RichTextEditor)
- ✅ Communications tab (sent email archive)
- ✅ View email modal (read-only with copy)
- ✅ Server actions for sending
- ✅ Background batch processing

---

### Phase 9: Meta-Email Integration (Issue Tracker) (Week 6-7 - 4 days)

**Goal:** Wire up meta-emails to existing Issue Tracker events

**File:** `src/server/actions/issues.ts`

**Events to trigger:**
1. **Issue Created** (`issue_created`)
2. **Issue Updated** (`issue_updated`)
3. **Issue Status Changed** (`issue_status_changed`)
4. **Issue Assigned to CR** (`issue_assigned_to_cr`)
5. **Issue Completed** (`issue_completed`)

**Implementation:**
```typescript
export async function createIssue(data: CreateIssueInput) {
  // ... existing code ...
  
  const issue = await prisma.issue.create({ /* ... */ });
  
  // Send meta-email notification
  const recipient = await getRecipientForCategory(
    'Issues',
    user.organizationId
  );
  
  if (recipient) {
    await sendMetaEmail({
      templateKey: 'issue_created',
      recipient: recipient.email,
      variables: {
        ...buildStandardVariables(user, organization),
        issue: {
          number: issue.number,
          title: issue.title,
          description: issue.description,
          category: issue.category,
          priority: issue.priority,
          status: issue.status,
          url: `${process.env.NEXT_PUBLIC_APP_URL}/platform/issues/${issue.id}`,
          createdAt: issue.createdAt.toLocaleString(),
          targetDate: issue.anticipatedResolutionDate?.toLocaleDateString(),
          createdBy: { name: user.name },
          loggedInRole: issue.loggedInRole,
        },
      },
      triggerEvent: 'issue_created',
      entityType: 'Issue',
      entityId: issue.id,
      userId: user.id,
      organizationId: user.organizationId,
    });
  }
  
  return issue;
}
```

**Role-Specific Templates:**
- `issue_created_platform` - For P1 (technical details)
- `issue_created_client` - For C1/C2 (reassurance + progress)
- `issue_status_changed` - Status updates
- `issue_assigned_to_cr` - CR assignment notification
- `issue_completed` - Resolution confirmation

**Deliverables:**
- ✅ Issue Tracker meta-email integration
- ✅ 5 default templates for issue events
- ✅ Role-specific template variants
- ✅ Comprehensive testing

---

### Phase 10: Module-Specific Metadata System (Week 7 - 3 days)

**Goal:** Enable modules to define filterable user metadata

**File:** `src/modules/[module]/module.config.ts`

**Module Config Extension:**
```typescript
export const moduleConfig: ModuleConfig = {
  // ... existing config ...
  
  // NEW: User metadata filters for email targeting
  userMetadataFilters: [
    {
      key: 'moduleRole',
      label: 'Module Role',
      type: 'multiselect',
      options: async (organizationId: string) => {
        // Dynamic options from database
        return await getModuleRoles(organizationId);
      },
      // OR static options:
      options: ['Team Manager', 'Coach', 'Admin']
    },
    {
      key: 'ageGroup',
      label: 'Age Group',
      type: 'multiselect',
      options: ['U7', 'U8', 'U9', 'U10', 'U11', 'U12']
    },
    {
      key: 'division',
      label: 'Division',
      type: 'select',
      options: ['Division 1', 'Division 2', 'Division 3']
    },
    {
      key: 'status',
      label: 'Status',
      type: 'select',
      options: ['Active', 'Inactive', 'Pending']
    }
  ],
};
```

**Helper Function:**
```typescript
// src/lib/modules/get-filtered-module-users.ts

export async function getFilteredModuleUsers(params: {
  organizationId: string;
  moduleSlug: string;
  filters: Record<string, any>;
}): Promise<Array<{ email: string; name: string; userId: string }>> {
  // 1. Get module config
  const moduleConfig = await getModuleConfig(params.moduleSlug);
  
  // 2. Build query based on module-specific schema
  // Example for DJFL module with users in `djfl.team_members` table
  const query = buildModuleUserQuery(
    params.moduleSlug,
    params.organizationId,
    params.filters
  );
  
  // 3. Execute query
  const users = await prisma.$queryRaw`${query}`;
  
  return users.map(u => ({
    email: u.email,
    name: u.name,
    userId: u.userId,
  }));
}
```

**Deliverables:**
- ✅ Module config extension for metadata filters
- ✅ Filter panel component (dynamic from config)
- ✅ Helper function to query filtered users
- ✅ Example implementation in DJFL module

---

### Phase 11: Testing & Polish (Week 8 - 5 days)

**Goal:** Comprehensive testing and UX refinement

**Testing Checklist:**

**Meta-Emails:**
- [ ] Create platform template via Platform Settings
- [ ] Customize org template via Module Settings
- [ ] Reset to platform default
- [ ] Preview template with test data
- [ ] Send test email
- [ ] Verify cascading lookup (Org → Platform)
- [ ] Trigger issue created → verify email sent
- [ ] Check EmailLog for delivery status

**Communication Emails:**
- [ ] Apply module metadata filters
- [ ] Preview filtered recipients
- [ ] Compose email with rich text
- [ ] Upload attachment to R2
- [ ] Send email → verify batch job queued
- [ ] Check Communications tab for sent email
- [ ] View sent email (read-only)
- [ ] Copy email content to clipboard
- [ ] Verify delivery stats (sent/failed counts)
- [ ] Check EmailRecipientLog for individual tracking

**Permissions:**
- [ ] P1 can create/edit platform templates
- [ ] C1/C2 can customize org templates
- [ ] C3 cannot access email composer
- [ ] C1 can send to all org users
- [ ] C2 can send only to their module users

**Performance:**
- [ ] Batch processing respects Resend rate limits
- [ ] UI remains responsive during send (background job)
- [ ] Email logs paginate correctly (1000+ records)
- [ ] Template preview renders in <1 second

**Deliverables:**
- ✅ Full test suite executed
- ✅ All bugs fixed
- ✅ Performance optimization complete
- ✅ Documentation updated
- ✅ Demo video recorded

---

## Timeline Summary

| Phase | Duration | Start | End | Focus |
|-------|----------|-------|-----|-------|
| Phase 1: Schema | 3 days | Week 1 | Week 1 | Database foundation |
| Phase 2: Template Engine | 4 days | Week 1 | Week 2 | Shortcode parser |
| Phase 3: Meta-Email CRUD | 3 days | Week 2 | Week 2 | Template management |
| Phase 4: Recipients | 2 days | Week 2 | Week 2 | Routing logic |
| Phase 5: Email Services | 5 days | Week 3 | Week 3 | Unified sending + batch |
| Phase 6: Platform UI | 5 days | Week 3 | Week 4 | P1 email settings |
| Phase 7: Module UI | 3 days | Week 4 | Week 4 | C1/C2 customization |
| Phase 8: User Manager | 6 days | Week 5 | Week 6 | Communication emails |
| Phase 9: Issue Integration | 4 days | Week 6 | Week 7 | Meta-email triggers |
| Phase 10: Metadata System | 3 days | Week 7 | Week 7 | Module filters |
| Phase 11: Testing | 5 days | Week 8 | Week 8 | QA + polish |

**Total Duration:** 8 weeks (43 working days)

---

## Risk Assessment

### High Risk
- **Email Deliverability:** Resend API limits/downtime
  - **Mitigation:** Background batch processor respects rate limits, implement retry logic with exponential backoff, monitor Resend status page, have backup provider plan (SendGrid)

- **Background Job Failures:** Batch processor crashes mid-send
  - **Mitigation:** Transaction-safe status updates, resumable jobs (track progress in EmailRecipientLog), alert P1 if job stalled >10 minutes

### Medium Risk
- **Template Complexity:** C1/C2 create invalid meta-email templates
  - **Mitigation:** Template validation before save, preview with test data required, "Reset to Default" always available, P1 can review org customizations

- **Module Metadata Inconsistency:** Modules define incompatible filter schemas
  - **Mitigation:** Enforce ModuleConfig TypeScript interface, validate filter definitions at registration, provide helper function examples, require module testing

- **Performance:** Large recipient lists (1000+ users) delay UI
  - **Mitigation:** Background batch processing (UI returns immediately), show progress indicator, limit preview list to 100 users (full list exportable to CSV)

### Low Risk
- **User Adoption:** C1/C2 prefer manual email clients
  - **Mitigation:** Clear documentation, demo video, highlight benefits (audit trail, metadata filtering, attachment storage), provide training during onboarding

- **Spam Complaints:** Recipients mark IsoStack emails as spam
  - **Mitigation:** Clear unsubscribe mechanism (future), sender reputation monitoring via Resend, require C1/C2 to include context in emails, limit broadcast frequency (future: throttling)

---

## Dependencies on Other Work

### Requires (Completed)
- ✅ Issue Tracker (existing - ready for meta-email integration)
- ✅ Mantine RichTextEditor (existing - used in multiple components)
- ✅ Cloudflare R2 (existing - file storage for attachments)
- ✅ Resend API (existing - email delivery infrastructure)

### Requires (In Progress)
- ⏳ Module User Management pages (some modules incomplete)
- ⏳ Module-specific schemas with user metadata (per module)

### Enables (Unlocked by This Work)
- 📧 Email-based issue notifications (P1 to C1/C2)
- 📧 User onboarding emails (welcome, verification)
- 📧 Module-specific broadcasts (training updates, announcements)
- 📧 Billing lifecycle emails (invoices, payment reminders - future)
- 📧 Support ticket routing (categorized notifications - future)
- 📧 White label email branding per organization

---

## Answers to Questions (Finalized)

| # | Question | Answer | Rationale |
|---|----------|--------|-----------|
| Q1 | Template customization | **Option C:** Org-scoped copy | C1/C2 edit copy, can reset to platform default, prevents breaking changes |
| Q2 | Module metadata filtering | **Option A:** Modules register in config | Consistent with IsoStack module pattern, type-safe, discoverable |
| Q3 | Title vs Subject | **Separate fields** | Title = internal reference, Subject = actual email recipient sees |
| Q4 | Recipient preview flow | **Option A:** Two-step | Prevents accidental sends, allows filter review before committing |
| Q5 | Draft saving | **Option C:** No drafts | Filter-driven flow reduces need, avoids wrong-audience sends |
| Q6 | Send permissions | **C1/C2 yes, C3 no** | Aligns with IsoStack role model, C3 are consumers not broadcasters |
| Q7 | Resend batch strategy | **Background service** | Respects 2 req/sec limit, batches of 100, 500ms delays |
| Q8 | Delivery tracking | **Minimal (MVP)** | Status + count sufficient, individual tracking if needed via logs |
| Q9 | "Send Again" | **Copy content only** | User reviews/edits, applies new filters, avoids accidental duplicate sends |
| Q10 | Module Settings layout | **[Mod Name] Emails** | Card per template, modal for customization, consistent with module patterns |

---

## Approval & Sign-off

**Prepared By:** GitHub Copilot AI  
**Prepared For:** Chris (Platform Owner)  
**Date:** 2025-12-18  
**Status:** Planning - Ready for Review  

**Specification Clarity:** ✅ All 10 questions answered, design finalized

**Approvals:**
- [ ] Technical Architecture Review (P1)
- [ ] Security Review (P1)
- [ ] UX/UI Review (P1)
- [ ] Module Integration Plan Review (P1)
- [ ] Platform Owner Final Approval (P1)

**Next Steps:**
1. Review unified plan with stakeholders
2. Prioritize Phase 1-5 for immediate development (meta-emails MVP)
3. Plan Phase 8 timing based on module completion status
4. Begin schema design and seed data preparation

---

**Change Request:** CR #18  
**Related Issues:** #46, #23  
**Priority:** High  
**Estimated Effort:** 8 weeks / 344 hours  
**System Type:** Unified (Two Entry Points, One Infrastructure)  
**Key Innovation:** Module metadata-driven communication targeting
