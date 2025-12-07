# IsoStack Security Implementation Plan

**Version:** 1.0  
**Last Updated:** December 2025  
**Target Completion:** Q2 2026 (16 weeks)  
**Compliance Goals:** GDPR, ISO 27001, NHS Digital Standards, Post-Quantum Ready

---

## Executive Summary

This document outlines a phased approach to implement enterprise-grade security across IsoStack, addressing:
- Multi-tenant data isolation (Row-Level Security)
- End-to-end encryption (AES-256-GCM)
- Immutable audit trails (hash-chained logs)
- Platform admin impersonation (with compliance controls)
- GDPR compliance features
- Post-quantum cryptography readiness

**Current State:** ~40% security features implemented (NextAuth, basic audit logging, UUID scoping)  
**Target State:** 95% compliance with ISO 27001 and GDPR requirements  
**Estimated Cost:** $11-15/month in external services

---

## External Dependencies & Tools

| Tool | Purpose | Cost | Priority |
|------|---------|------|----------|
| **@noble/ciphers** | AES-256-GCM encryption | Free | 🔴 Critical |
| **@noble/hashes** | Argon2id key derivation | Free | 🔴 Critical |
| **Upstash Redis** | Rate limiting | $10/mo | 🟡 High |
| **@simplewebauthn** | WebAuthn (MFA) | Free | 🟡 High |
| **AWS KMS** (optional) | Key management | ~$1/mo | 🟢 Medium |
| **pqc-kyber** (future) | Post-quantum crypto | Free (experimental) | 🟢 Low |

**Total Monthly Cost:** ~$11-15 (minimal)

---

## Phase 1: Critical Security Foundations (Weeks 1-2)

**Goal:** Close the most critical security gaps - data isolation, encryption, and audit integrity.

### 1.1 Row-Level Security (RLS) Implementation

**Priority:** 🔴 CRITICAL  
**Effort:** 3-5 days  
**Dependencies:** None

**Problem:** Queries rely on application-level `organizationId` filtering. If middleware fails or a query omits the filter, cross-tenant data leaks occur.

**Solution:** Enforce tenant isolation at the **database level** using PostgreSQL RLS.

**Implementation Steps:**

1. **Enable RLS on all tenant-scoped tables**
   - Apply `ALTER TABLE ... ENABLE ROW LEVEL SECURITY` to all tables with `organizationId`
   - Create policies: `USING (organization_id = current_setting('app.current_tenant', TRUE)::uuid)`
   - Apply to: users, issues, change_requests, tooltips, tags, modules, audit_logs, etc.
   - Exception: tooltips with `organization_id IS NULL` (global tooltips)

2. **Create middleware to set tenant context**
   - Update `src/middleware.ts` to get session and set PostgreSQL session variable
   - Set `app.current_tenant` header for RLS enforcement
   - Apply to all routes except static files

3. **Update Prisma client with session variable helpers**
   - Create `withTenantContext()` helper function in `src/lib/prisma.ts`
   - Executes `SET LOCAL app.current_tenant = '<organizationId>'`
   - Automatically resets after query execution
   - Handles transaction boundaries correctly

4. **Update tRPC context for tenant-scoped queries**
   - Add `prismaWithTenant` helper to tRPC context
   - Automatically applies tenant context to all queries
   - Throws UNAUTHORIZED if no organizationId in session

5. **Create platform admin exception policy**
   - SQL: `CREATE POLICY platform_admin_bypass ON users TO platform_admin_role USING (true)`
   - Create `platform_admin_role` in PostgreSQL
   - Assign role to platform admin connections

6. **Write comprehensive RLS tests**
   - Test: queries without tenant context return empty results
   - Test: queries with correct tenant context return data
   - Test: cross-tenant update attempts are blocked
   - Test: platform admins can bypass RLS

**Deliverables:**
- ✅ RLS enabled on 30+ tables
- ✅ Middleware sets tenant context
- ✅ Helper functions for tenant-scoped queries
- ✅ Platform admin bypass policy
- ✅ Test suite validates isolation

---

### 1.2 Encryption Service for Secrets

**Priority:** 🔴 CRITICAL  
**Effort:** 5-7 days  
**Dependencies:** None

**Problem:** API keys, tokens, and sensitive data stored in plaintext in database.

**Solution:** AES-256-GCM encryption with per-tenant key derivation (Argon2id).

**Implementation Steps:**

1. **Install cryptography libraries**
   - Add: `@noble/ciphers` and `@noble/hashes` to package.json
   - These are audited, pure TypeScript, no native dependencies

2. **Create encryption service class**
   - File: `src/lib/encryption/service.ts`
   - Methods: `encrypt()`, `decrypt()`, `rotateKey()`
   - Use AES-256-GCM with 12-byte nonce
   - Derive tenant-specific keys using Argon2id (master key + tenant ID)
   - Return: `{ ciphertext, nonce, authTag, algorithm, keyVersion }`

3. **Update Prisma schema for encrypted secrets**
   - Add `EncryptedSecret` model with fields:
     - `organizationId`, `module`, `key` (unique together)
     - `ciphertext`, `nonce`, `authTag` (Base64 strings)
     - `algorithm`, `keyVersion`, `rotatedAt`, `expiresAt`

4. **Create secrets vault tRPC router**
   - File: `src/server/core/routers/secrets.router.ts`
   - Endpoints: `set`, `get`, `list`, `delete`
   - `set`: encrypt value and upsert to database
   - `get`: decrypt and return value (server-side only)
   - `list`: return metadata only (no values)
   - All operations require ADMIN or OWNER role

5. **Set up environment variables**
   - `ENCRYPTION_MASTER_KEY` (64 hex characters = 32 bytes)
   - Generate with: `node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"`
   - Store in AWS Secrets Manager / Google Secret Manager in production

6. **Write encryption tests**
   - Test: encrypt and decrypt correctly
   - Test: fail decryption with wrong tenant ID
   - Test: detect tampering (auth tag mismatch)
   - Test: key rotation preserves plaintext

**Deliverables:**
- ✅ Encryption service with AES-256-GCM
- ✅ Argon2id key derivation (per-tenant)
- ✅ EncryptedSecret model and tRPC router
- ✅ Master key stored in environment
- ✅ Test suite validates encryption/decryption

---

### 1.3 Hash-Chained Audit Logs

**Priority:** 🔴 CRITICAL  
**Effort:** 3-4 days  
**Dependencies:** None

**Problem:** Current audit logs can be modified or deleted without detection (not immutable).

**Solution:** Implement hash-chained logs (each entry references previous hash, like blockchain).

**Implementation Steps:**

1. **Update AuditLog schema**
   - Add fields: `sequenceNum` (auto-increment), `previousHash`, `currentHash`
   - Index: `[organizationId, sequenceNum]` for chain verification

2. **Create audit log service**
   - File: `src/lib/audit/service.ts`
   - Method: `createLog()` - creates hash-chained entry
   - Method: `verifyChain()` - validates entire chain integrity
   - Method: `getEntityHistory()` - fetches audit trail for entity

3. **Implement hash chaining logic**
   - Fetch last log entry for tenant
   - Create payload: `{ action, entityType, entityId, metadata, userId, timestamp }`
   - Calculate: `currentHash = SHA256(previousHash + payload)`
   - Store with `previousHash` reference (or null for first entry)

4. **Update all audit log calls**
   - Find all `prisma.auditLog.create()` calls
   - Replace with `auditLogService.createLog()`
   - Ensure all significant actions are logged

5. **Create admin verification interface**
   - tRPC endpoint: `verifyAuditChain({ organizationId? })`
   - Returns: `{ valid, brokenAt?, totalEntries }`
   - Admin UI to trigger verification and view results

6. **Set up scheduled chain verification**
   - Cron job: `/api/cron/verify-audit-chain`
   - Runs daily at 2 AM
   - Verifies global + each tenant's chain
   - Alerts if tampering detected

7. **Write chain integrity tests**
   - Test: chained entries link correctly
   - Test: tampering detected (modified metadata)
   - Test: deleted entry breaks chain
   - Test: verification passes for valid chain

**Deliverables:**
- ✅ Hash-chained audit log schema
- ✅ AuditLogService with chain verification
- ✅ Updated all audit log calls to use service
- ✅ Admin interface for verification
- ✅ Daily cron job to verify integrity
- ✅ Test suite validates chain integrity

---

## Phase 2: Enhanced Platform Admin Controls (Weeks 3-4)

**Goal:** Secure impersonation feature with compliance controls and improve rate limiting.

### 2.1 Secure Impersonation Implementation

**Priority:** 🔴 CRITICAL  
**Effort:** 5-7 days  
**Dependencies:** Phase 1.3 (audit logs)

**Problem:** Platform admins need to impersonate users for support, but this must be secure and compliant.

**Solution:** Implement impersonation with audit trails, time limits, visual warnings, and email notifications.

**Implementation Steps:**

1. **Update session type definition**
   - Add `impersonation` field to NextAuth session type
   - Fields: `isImpersonating`, `originalUserId`, `originalEmail`, `startedAt`, `reason`

2. **Create impersonation schema**
   - Add `ImpersonationSession` model
   - Fields: `adminId`, `impersonatedId`, `reason`, `startedAt`, `endedAt`, `duration`
   - Additional: `ipAddress`, `userAgent`, `actionsPerformed[]`

3. **Create impersonation tRPC router**
   - Endpoint: `start({ userId, reason })` - requires 20+ char justification
   - Endpoint: `end()` - ends impersonation session
   - Endpoint: `getActiveSessions()` - lists all active impersonations
   - Endpoint: `getHistory({ userId? })` - impersonation audit trail

4. **Implement audit logging**
   - Log `IMPERSONATION_STARTED` with admin, target user, reason
   - Log `IMPERSONATION_ENDED` with duration
   - Include metadata: organization, IP address, user agent

5. **Create visual warning banner**
   - Component: `ImpersonationBanner.tsx`
   - Always visible at top of screen (red alert, high z-index)
   - Shows: admin email, target user, reason, time remaining
   - Button: "End Impersonation"

6. **Implement time limits**
   - Max duration: 1 hour
   - Middleware checks session age
   - Auto-expires and redirects to platform dashboard
   - Shows countdown timer in banner

7. **Add action restrictions**
   - Block destructive actions during impersonation:
     - User/organization deletion
     - Billing changes
     - API key generation
     - Permission changes
     - GDPR data exports
   - Helper: `checkImpersonationRestrictions(session, action)`

8. **Send email notifications**
   - Template: `ImpersonationNotice.tsx` (React Email)
   - Sent after impersonation ends
   - Contains: admin email, duration, reason, timestamp
   - GDPR compliance requirement

9. **Write impersonation tests**
   - Test: impersonation session created with reason
   - Test: audit logs created on start/end
   - Test: banner visible during impersonation
   - Test: session auto-expires after 1 hour
   - Test: destructive actions blocked

**Compliance Alignment:**

| Requirement | Implementation |
|-------------|----------------|
| **Audit Trail** (Section 8) | Log start/end with justification |
| **User Notification** (GDPR Art. 13) | Email after impersonation |
| **Time Limits** (ISO 27001 A.9.3.1) | 1-hour auto-expire |
| **Least Privilege** (Section 4.1) | Block destructive actions |
| **Visual Indication** (UX best practice) | Persistent warning banner |

**Deliverables:**
- ✅ Impersonation session tracking
- ✅ Visual warning banner (always visible)
- ✅ Time limits (1 hour max, auto-expire)
- ✅ Action restrictions (blocks destructive operations)
- ✅ Audit logging (start/end with justification)
- ✅ User email notifications (GDPR compliance)
- ✅ Admin interface to view active sessions

---

### 2.2 Rate Limiting with Upstash Redis

**Priority:** 🟡 HIGH  
**Effort:** 3-4 days  
**Dependencies:** None

**Problem:** No rate limiting exposes platform to abuse and DDoS attacks.

**Solution:** Multi-tier rate limiting using Upstash Redis (serverless).

**Implementation Steps:**

1. **Install Upstash Redis client**
   - Add: `@upstash/ratelimit` and `@upstash/redis`
   - Sign up for Upstash account (free tier: 10K requests/day)
   - Create Redis database, copy REST URL and token

2. **Configure environment variables**
   - `UPSTASH_REDIS_REST_URL`
   - `UPSTASH_REDIS_REST_TOKEN`

3. **Create rate limit service**
   - File: `src/lib/rate-limit/service.ts`
   - Define limiters:
     - **Tenant**: 100 requests/minute
     - **User**: 20 requests/minute
     - **API Key**: 1000 requests/hour
     - **Auth**: 5 attempts/15 minutes

4. **Create tRPC middleware**
   - `rateLimitMiddleware` - checks tenant and user limits
   - Throws `TOO_MANY_REQUESTS` error with retry time
   - Export `rateLimitedProcedure` for applying to routes

5. **Apply to sensitive routes**
   - User create/update operations
   - Issue create/update operations
   - All mutations (optional, for maximum security)

6. **Rate limit auth endpoints**
   - Apply to signin/signup routes
   - Limit by email address (prevent brute force)
   - Return 429 status with retry-after header

7. **Add rate limit headers**
   - Middleware sets response headers:
     - `X-RateLimit-Limit`
     - `X-RateLimit-Remaining`
     - `X-RateLimit-Reset`
   - Helps clients implement exponential backoff

8. **Test rate limiting**
   - Test: user can make 20 requests/minute
   - Test: 21st request returns 429 error
   - Test: reset time is accurate
   - Test: different users have independent limits

**Deliverables:**
- ✅ Upstash Redis integration
- ✅ Multi-tier rate limiting (tenant, user, API key, auth)
- ✅ tRPC middleware for automatic enforcement
- ✅ Rate limit headers in responses
- ✅ Graceful error messages with retry times

---

### 2.3 CORS & Domain Controls

**Priority:** 🟡 HIGH  
**Effort:** 2-3 days  
**Dependencies:** None

**Problem:** No CORS controls allow unauthorized cross-origin requests.

**Solution:** Per-tenant domain whitelisting with middleware enforcement.

**Implementation Steps:**

1. **Update Organization schema**
   - Add fields: `allowedDomains[]`, `corsEnabled`, `ipWhitelist[]`, `mfaRequired`

2. **Create CORS middleware**
   - Check request origin against tenant's `allowedDomains`
   - Support wildcard subdomains (`*.example.com`)
   - Return 403 if origin not whitelisted
   - Set CORS headers if allowed:
     - `Access-Control-Allow-Origin`
     - `Access-Control-Allow-Credentials`
     - `Access-Control-Allow-Methods`
     - `Access-Control-Allow-Headers`

3. **Create CORS management UI**
   - Page: `src/app/(app)/settings/security/page.tsx`
   - Toggle: Enable/disable CORS
   - Form: Add domain to whitelist
   - List: Show and remove whitelisted domains

4. **Create security settings tRPC router**
   - Endpoint: `updateSecurity({ allowedDomains?, corsEnabled? })`
   - Requires ADMIN or OWNER role
   - Updates organization settings

5. **Test CORS enforcement**
   - Test: request from whitelisted domain succeeds
   - Test: request from non-whitelisted domain returns 403
   - Test: wildcard subdomains work correctly
   - Test: CORS disabled allows all origins

**Deliverables:**
- ✅ CORS configuration per tenant
- ✅ Domain whitelist with wildcard support
- ✅ Middleware enforcement
- ✅ Admin UI for managing allowed domains

---

## Phase 3: GDPR Compliance & Advanced Features (Weeks 5-8)

**Goal:** Implement GDPR requirements and prepare for future enhancements.

### 3.1 GDPR Right to Access (Data Export)

**Priority:** 🟢 MEDIUM  
**Effort:** 4-5 days  
**Dependencies:** Phase 1.2 (encryption)

**Problem:** Users have legal right to export their personal data (GDPR Article 15).

**Solution:** Automated data export in machine-readable format (JSON + ZIP).

**Implementation Steps:**

1. **Install JSZip library**
   - Add: `jszip` for creating ZIP archives

2. **Create data export service**
   - File: `src/lib/gdpr/export-service.ts`
   - Method: `exportUserData(userId)` - exports all user data
   - Method: `exportOrganizationData(orgId)` - exports all org data (owners only)

3. **Collect exportable data**
   - User profile (name, email, role)
   - Audit logs (all actions by user)
   - Created issues (with tags, modules)
   - Comments/discussions
   - Settings/preferences
   - File uploads (if applicable)

4. **Create ZIP archive**
   - Separate JSON file for each data type
   - Include README.txt explaining contents
   - Add metadata.json with export timestamp

5. **Create GDPR tRPC router**
   - Endpoint: `requestDataExport()` - queues export job
   - Endpoint: `getExportStatus({ requestId })` - checks progress
   - Endpoint: `downloadExport({ requestId })` - returns download URL

6. **Generate signed download URLs**
   - Use Cloudflare R2 or S3 signed URLs
   - Expire after 24 hours
   - Require authentication to access

7. **Create data export UI**
   - Settings page: "Download Your Data"
   - Button: "Request Data Export"
   - Shows progress: "Processing... (estimated 2 minutes)"
   - Download link when ready

8. **Log data export requests**
   - Audit log: `DATA_EXPORT_REQUESTED`
   - Metadata: user, timestamp, file size
   - Retention: keep logs for 7 years (compliance)

9. **Test data export**
   - Test: export contains all user data
   - Test: export excludes other users' data
   - Test: ZIP file is valid and readable
   - Test: download URL expires correctly

**Deliverables:**
- ✅ Data export service
- ✅ ZIP archive generation
- ✅ GDPR router with export endpoints
- ✅ Signed download URLs
- ✅ User-facing export UI
- ✅ Audit logging

---

### 3.2 GDPR Right to Erasure (Data Deletion)

**Priority:** 🟢 MEDIUM  
**Effort:** 4-5 days  
**Dependencies:** Phase 3.1

**Problem:** Users have legal right to delete their personal data (GDPR Article 17).

**Solution:** Soft delete + anonymization with scheduled hard delete.

**Implementation Steps:**

1. **Update User schema**
   - Add fields: `deletedAt`, `deletionScheduledFor`, `anonymized`

2. **Implement soft delete**
   - Mark user as deleted (don't actually delete)
   - Anonymize PII: replace name with "Deleted User", hash email
   - Preserve: audit logs (anonymized), issue history (anonymized)
   - Delete: profile photo, preferences, API keys

3. **Create anonymization service**
   - File: `src/lib/gdpr/anonymization-service.ts`
   - Method: `anonymizeUser(userId)`
   - Replace: name, email, phone with anonymized values
   - Keep: user ID (for foreign key integrity)

4. **Schedule hard delete**
   - After 30 days of soft delete, permanently remove
   - Cron job: `/api/cron/delete-expired-users`
   - Cascade delete: all user-owned data
   - Exception: audit logs (keep for compliance)

5. **Create GDPR deletion router**
   - Endpoint: `requestAccountDeletion({ password })` - requires password confirmation
   - Endpoint: `cancelAccountDeletion()` - undo within 30 days
   - Endpoint: `getAccountDeletionStatus()` - shows countdown

6. **Create account deletion UI**
   - Settings page: "Delete Account" section
   - Warning: "This action cannot be undone after 30 days"
   - Requires: password confirmation + checkbox agreement
   - Shows: 30-day countdown if deletion scheduled

7. **Send confirmation emails**
   - Email 1: "Account deletion requested" (immediate)
   - Email 2: "7 days until permanent deletion" (reminder)
   - Email 3: "Account permanently deleted" (after 30 days)

8. **Test deletion flow**
   - Test: soft delete anonymizes data correctly
   - Test: user can cancel within 30 days
   - Test: hard delete removes all data after 30 days
   - Test: audit logs preserved (anonymized)

**Deliverables:**
- ✅ Soft delete implementation
- ✅ Anonymization service
- ✅ Scheduled hard delete (30 days)
- ✅ Deletion router and UI
- ✅ Email notifications
- ✅ Test suite

---

### 3.3 WebAuthn / Device-Bound Authentication

**Priority:** 🟡 HIGH  
**Effort:** 7-10 days  
**Dependencies:** None

**Problem:** Password-only authentication is vulnerable to phishing.

**Solution:** WebAuthn (Face ID, Touch ID, YubiKey) for platform admin accounts.

**Implementation Steps:**

1. **Install SimpleWebAuthn libraries**
   - Add: `@simplewebauthn/server` and `@simplewebauthn/browser`

2. **Update User schema**
   - Add: `WebAuthnCredential` model
   - Fields: `credentialID`, `publicKey`, `counter`, `deviceType`

3. **Create WebAuthn registration flow**
   - Generate registration options (challenge)
   - Browser prompts for biometric/security key
   - Verify and store credential

4. **Create WebAuthn authentication flow**
   - Generate authentication options (challenge)
   - Browser prompts for biometric/security key
   - Verify signature and update counter

5. **Create WebAuthn tRPC router**
   - Endpoint: `generateRegistrationOptions()`
   - Endpoint: `verifyRegistration({ credential })`
   - Endpoint: `generateAuthenticationOptions()`
   - Endpoint: `verifyAuthentication({ credential })`
   - Endpoint: `listCredentials()` - show registered devices
   - Endpoint: `deleteCredential({ id })` - remove device

6. **Create WebAuthn UI**
   - Settings page: "Security Keys"
   - Button: "Register New Device"
   - List: Show all registered devices with icons (Face ID, YubiKey, etc.)
   - Delete button per device

7. **Require WebAuthn for sensitive actions**
   - Platform admin actions (module activation, tenant deletion)
   - Billing changes
   - API key generation
   - Prompt for re-authentication before action

8. **Test WebAuthn flow**
   - Test: registration with Face ID (macOS/iOS)
   - Test: registration with Touch ID (Windows Hello)
   - Test: registration with YubiKey
   - Test: authentication works across devices
   - Test: deleted credential cannot authenticate

**Deliverables:**
- ✅ WebAuthn registration and authentication
- ✅ Credential storage in database
- ✅ Settings UI for managing devices
- ✅ Required for platform admin actions
- ✅ Multi-device support

---

### 3.4 Post-Quantum Cryptography Preparation

**Priority:** 🟢 LOW (Future-Proofing)  
**Effort:** 10-14 days (experimental)  
**Dependencies:** None

**Problem:** Quantum computers will break current encryption (RSA, ECDSA) in 10-20 years.

**Solution:** Prepare for post-quantum transition using hybrid encryption (classical + PQC).

**Status:** ⚠️ **Not production-ready yet** (NIST standardization in progress, finalized 2026)

**Implementation Steps:**

1. **Research current PQC standards**
   - NIST finalists: Kyber (encryption), Dilithium (signatures)
   - Monitor NIST announcements for final specifications

2. **Install experimental PQC libraries**
   - Evaluate: `pqc-kyber`, `pqc-dilithium` (when available)
   - Or wait for official implementations from NIST/OpenSSL

3. **Design hybrid encryption architecture**
   - Encrypt data with both classical (AES-256) and PQC (Kyber)
   - Store both ciphertexts (overhead: ~2x storage)
   - Decrypt using both keys (requires both to match)

4. **Create PQC service**
   - File: `src/lib/encryption/pqc-service.ts`
   - Method: `hybridEncrypt()` - AES-256 + Kyber
   - Method: `hybridDecrypt()` - verify both decryptions match

5. **Document migration plan**
   - Phase 1: Add PQC alongside current encryption (2026)
   - Phase 2: Migrate all secrets to hybrid encryption (2027)
   - Phase 3: Remove classical encryption when quantum threat is real (2030+)

6. **Create feature flag**
   - `ENABLE_PQC_ENCRYPTION` (default: false)
   - Allows gradual rollout and testing

7. **Test hybrid encryption**
   - Test: encrypt and decrypt with both algorithms
   - Test: tampering detected in either ciphertext
   - Test: fallback to classical if PQC unavailable

**Recommendation:** **Wait until 2026** when NIST finalizes standards and production-ready libraries are available. For now, document the architecture and monitor developments.

**Deliverables:**
- ✅ PQC research documentation
- ✅ Hybrid encryption architecture design
- ✅ Migration plan (3-phase, 2026-2030)
- ✅ Feature flag for gradual rollout
- ⏳ Implementation (when standards finalized)

---

## Phase 4: Continuous Monitoring & Compliance (Weeks 9-16)

**Goal:** Implement monitoring, alerting, and compliance reporting.

### 4.1 Security Monitoring Dashboard

**Priority:** 🟡 HIGH  
**Effort:** 5-7 days  
**Dependencies:** All previous phases

**Implementation Steps:**

1. **Create security metrics service**
   - Track: failed login attempts, rate limit violations, RLS policy violations
   - Track: impersonation sessions, data exports, account deletions
   - Track: encryption errors, audit chain breaks

2. **Create monitoring dashboard**
   - Platform admin page: "Security Monitor"
   - Charts: login attempts over time, rate limit violations
   - Alerts: audit chain broken, unusual impersonation activity
   - Logs: recent security events (last 100)

3. **Implement real-time alerts**
   - Email alerts for critical events
   - Slack/Discord webhooks (optional)
   - Log aggregation (e.g., Sentry, LogRocket)

4. **Create security report generator**
   - Weekly summary: login attempts, impersonations, data exports
   - Monthly summary: compliance status, vulnerabilities patched
   - Quarterly summary: ISO 27001 audit preparation

**Deliverables:**
- ✅ Security metrics tracking
- ✅ Monitoring dashboard for platform admins
- ✅ Real-time alerting for critical events
- ✅ Automated security reports

---

### 4.2 Compliance Documentation

**Priority:** 🟢 MEDIUM  
**Effort:** 3-5 days  
**Dependencies:** All previous phases

**Implementation Steps:**

1. **Create compliance checklist**
   - GDPR: Right to access, right to erasure, consent management
   - ISO 27001: Access controls, audit logging, encryption
   - NHS Digital: Data protection, staff vetting, incident management

2. **Document security controls**
   - Encryption: algorithm, key length, key derivation
   - Access control: roles, permissions, RLS policies
   - Audit logging: retention, immutability, verification

3. **Create evidence collection system**
   - Export audit logs for compliance review
   - Screenshot security settings for documentation
   - Generate compliance reports on demand

4. **Prepare for external audits**
   - ISO 27001 certification readiness
   - GDPR compliance assessment
   - NHS Digital assessment (if applicable)

**Deliverables:**
- ✅ Compliance checklist (GDPR, ISO 27001, NHS)
- ✅ Security controls documentation
- ✅ Evidence collection system
- ✅ Audit preparation materials

---

### 4.3 Penetration Testing Preparation

**Priority:** 🟢 MEDIUM  
**Effort:** 2-3 days  
**Dependencies:** All previous phases

**Implementation Steps:**

1. **Create security testing guide**
   - Document: attack vectors to test
   - Document: expected behavior for each test
   - Document: how to verify security controls

2. **Set up staging environment**
   - Isolated database with test data
   - Separate API keys and credentials
   - Monitoring enabled to catch attacks

3. **Run automated security scans**
   - OWASP ZAP or Burp Suite
   - npm audit for dependency vulnerabilities
   - Snyk or Socket.dev for supply chain attacks

4. **Schedule external penetration test**
   - Hire security firm (e.g., HackerOne, Bugcrowd)
   - Provide: scope, credentials, rules of engagement
   - Review: findings, remediation plan, re-test

**Deliverables:**
- ✅ Security testing guide
- ✅ Staging environment for testing
- ✅ Automated security scan results
- ✅ External penetration test scheduled

---

## Implementation Timeline

### Fast Track (8 weeks - Minimum Viable Security)

| Week | Phase | Focus |
|------|-------|-------|
| 1 | Phase 1 | RLS Implementation |
| 2 | Phase 1 | Encryption Service + Audit Logs |
| 3 | Phase 2 | Impersonation Controls |
| 4 | Phase 2 | Rate Limiting + CORS |
| 5 | Phase 3 | GDPR Data Export |
| 6 | Phase 3 | GDPR Data Deletion |
| 7 | Phase 4 | Security Monitoring |
| 8 | Phase 4 | Compliance Documentation |

**Result:** 70% security compliance, production-ready for initial launch

---

### Full Compliance (16 weeks - Enterprise-Grade)

| Week | Phase | Focus |
|------|-------|-------|
| 1-2 | Phase 1 | RLS, Encryption, Audit Logs |
| 3-4 | Phase 2 | Impersonation, Rate Limiting, CORS |
| 5-6 | Phase 3 | GDPR Export + Deletion |
| 7-8 | Phase 3 | WebAuthn / Device-Bound Auth |
| 9-10 | Phase 4 | Security Monitoring Dashboard |
| 11-12 | Phase 4 | Compliance Documentation |
| 13-14 | Phase 4 | Penetration Testing |
| 15-16 | Phase 4 | Remediation + Final Audit |

**Result:** 95% security compliance, ISO 27001 ready, NHS Digital approved

---

## AI Development Instructions

When implementing these security features, follow these guidelines:

### 1. **Start with Schema Changes**
Always update `prisma/schema.prisma` first, then run `npm run db:push` before writing application code.

### 2. **Multi-File Edits**
For large features (e.g., RLS implementation), break work into testable phases:
- Phase A: Schema + Migration (test with Prisma Studio)
- Phase B: Service Layer (test with unit tests)
- Phase C: tRPC Router (test with Postman/tRPC client)
- Phase D: UI Components (test in browser)

### 3. **Security-First Approach**
- Always assume user input is malicious (validate with Zod)
- Always scope queries by `organizationId` (use RLS helpers)
- Always log security-relevant actions (use audit service)
- Always encrypt sensitive data (use encryption service)

### 4. **Testing Requirements**
Every security feature must include:
- Unit tests (service layer)
- Integration tests (tRPC endpoints)
- E2E tests (browser automation with Playwright)
- Security tests (attempt to bypass controls)

### 5. **Documentation Standards**
Every security implementation must document:
- What problem it solves
- How it works (architecture)
- How to use it (API reference)
- How to test it (verification steps)

### 6. **Incremental Delivery**
Deliver features in working increments:
- Don't merge half-finished implementations
- Each commit should be deployable (behind feature flag if needed)
- Tag releases with semantic versioning

### 7. **Backward Compatibility**
When adding new security controls:
- Provide migration scripts for existing data
- Support gradual rollout (feature flags)
- Don't break existing functionality

---

## Success Criteria

### Phase 1 Complete When:
- ✅ RLS blocks cross-tenant queries (verified by tests)
- ✅ Secrets encrypted in database (verified with Prisma Studio)
- ✅ Audit chain verification passes for all tenants

### Phase 2 Complete When:
- ✅ Impersonation sessions visible to users (banner shows)
- ✅ Rate limiting returns 429 after threshold exceeded
- ✅ CORS blocks unauthorized origins

### Phase 3 Complete When:
- ✅ Users can export their data (ZIP download works)
- ✅ Users can request account deletion (30-day flow works)
- ✅ WebAuthn registration works on all platforms

### Phase 4 Complete When:
- ✅ Security dashboard shows real-time metrics
- ✅ Compliance reports can be generated on demand
- ✅ Penetration test finds no critical vulnerabilities

---

## Risk Mitigation

### High-Risk Areas:
1. **RLS Implementation** - Risk: breaking all queries if misconfigured
   - Mitigation: Test on staging first, gradual rollout per table
   
2. **Encryption Service** - Risk: data loss if keys corrupted
   - Mitigation: Backup master key in 3 locations, test recovery procedure
   
3. **Audit Log Chains** - Risk: performance impact on high-traffic sites
   - Mitigation: Index optimization, async logging, batching

### Rollback Plan:
Every phase has a rollback strategy:
- Phase 1: Disable RLS policies (queries revert to app-level filtering)
- Phase 2: Disable rate limiting (remove middleware)
- Phase 3: Disable GDPR endpoints (hide UI, keep data)
- Phase 4: Disable monitoring (no functional impact)

---

## Post-Implementation

### Ongoing Maintenance:
- **Weekly:** Review security logs for anomalies
- **Monthly:** Verify audit chains, rotate encryption keys
- **Quarterly:** Security team review, update dependencies
- **Annually:** External penetration test, compliance audit

### Future Enhancements:
- Anomaly detection (ML-based threat detection)
- Zero-trust architecture (continuous verification)
- Hardware security modules (HSM for key storage)
- Post-quantum cryptography (when standards finalized)

---

**End of Document**

For questions or clarifications during implementation, refer to:
- `/docs/00-overview/isostack-platform-security-architecture` (architectural reference)
- `/docs/00-overview/work-method.md` (development workflow)
- `/docs/00-overview/ai-ruleset.md` (AI collaboration guidelines)
