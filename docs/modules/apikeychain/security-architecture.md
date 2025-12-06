


# ✅ **APIKeyChain — Security Architecture**

**Status:** Draft v1.0
**Module:** APIKeyChain
**Author:** Isoblue / IsoStack
**Purpose:** Define the complete security model for per-tenant API proxying, secret storage, public asset generation, and secure request execution.

---

# 1. **Security Principles**

APIKeyChain follows IsoStack Core principles:

### ● **Zero-Trust-by-Default**

No client or origin is trusted until proven, authenticated, or cryptographically authorised.

### ● **Least Privilege**

Keys, routes, user roles, domains, and transforms operate with the minimum rights required.

### ● **Defence in Depth**

Multiple independent safeguards prevent escalation, leakage, or misuse.

### ● **Tenant Isolation**

Strict database-level, storage-level, and runtime-level isolation guarantee no tenant can access another tenant’s keys, routes, assets, or logs.

### ● **Secure-by-Design**

All defaults favour safety:

* No wildcard CORS
* No default enabled routes
* No public assets unless explicitly uploaded
* No proxy activity unless domains are authorised

---

# 2. **Threat Model**

APIKeyChain is designed to protect tenants against:

### **2.1 Credential Exposure**

Accidental or malicious disclosure of:

* API keys
* App IDs
* Tokens
* Auth headers

### **2.2 Request Tampering**

An attacker modifying:

* Parameters
* Routes
* Target URLs
* Query strings
* Headers

### **2.3 Origin Spoofing**

Attempts to:

* Call proxy from an unapproved domain
* Replay requests
* Circumvent CORS

### **2.4 Abuse & Overuse Attacks**

Including:

* DDoS
* Rate spikes
* Script injection
* Asset misuse
* Credential stuffing via proxied endpoints

### **2.5 Multi-Tenant Data Leakage**

Ensuring:

* No cross-tenant reads
* No cross-tenant proxying
* No shared keys
* No shared storage paths

---

# 3. **Key Storage & Encryption Model**

API secrets are stored using a **multi-layer encryption strategy**:

## 3.1 **AES-256-GCM Encryption-at-Rest**

All secrets are encrypted using:

* **AES-256-GCM**
* Unique per-project salt
* Nonce generated per write
* Encrypted value + authentication tag stored together

## 3.2 **Key Derivation**

Encryption keys derived via:

* **Argon2id** (preferred)
* Or PBKDF2-SHA512 fallback
* Tenant-specific secret strengthens brute-force resistance

## 3.3 **Envelope Encryption with Platform KMS**

IsoStack's platform-level KMS (Key Management System) encrypts:

* The per-project master key
* The derived encryption key
* Key rotation metadata

Regular rotation ensures forward secrecy.

## 3.4 **Zero-Knowledge Option (Future)**

For high-security clients, APIKeyChain can be configured such that:

* Secrets are encrypted client-side before upload
* IsoStack cannot decrypt them without tenant’s master key

---

# 4. **Secrets in Transit**

### 4.1 HTTPS Everywhere

All transport occurs over **TLS 1.3**, including:

* Asset downloads
* Proxy calls
* Admin dashboard
* Service ↔ database

### 4.2 Strict No-Secrets-To-Browser Rule

No APIKeyChain secret ever flows into:

* React props
* Client state
* Browser localStorage/sessionStorage
* Public routes

### 4.3 Enforced HSTS + Secure Cookies

Platform-level controls ensure:

* HSTS enabled
* SameSite=Lax or Strict
* Secure flag always set

---

# 5. **CORS & Domain Whitelisting**

### 5.1 Allow-List Only

Each project defines **explicit allowed domains**.

### 5.2 No Wildcards

“*” is never permitted in production.

### 5.3 Dynamic Response Headers

For allowed origins:

```
Access-Control-Allow-Origin: <origin>
Access-Control-Allow-Credentials: true
Access-Control-Allow-Methods: GET, OPTIONS
Access-Control-Allow-Headers: Content-Type, X-Iso-User
Vary: Origin
```

### 5.4 OPTIONS Preflight Enforcement

Non-approved domains receive:

```
HTTP 403 Forbidden
```

---

# 6. **Proxy Engine Security**

### 6.1 Strict Input Validation

All parameters passed to target APIs are validated by:

* Zod schemas
* Provider-specific sanitizers

### 6.2 No Dynamic Hostnames

Target base URLs must match the project’s registered provider.

### 6.3 Request Signing (Optional Tier)

Clients may include:

```
x-signature: HMAC_SHA256(payload)
x-timestamp: <epoch>
```

APIKeyChain verifies:

* signature integrity
* timestamp window (< 30 seconds)
* replay attack prevention

### 6.4 Ephemeral API Keys (Optional Tier)

APIKeyChain rotates secrets every:

* 24–72 hours (configurable)
* Immediately upon anomaly detection

---

# 7. **Public Asset Security (JS/CSS)**

Tenant-uploaded assets (gallery scripts, widgets, etc.) are stored in **Cloudflare R2 with encryption**.

### 7.1 Integrity Hashing

Generated assets include SHA-256 hash:

```
Content-SHA256: <hash>
```

### 7.2 Optional Subresource Integrity (SRI)

Future version:

```
integrity="sha256-abc123…"
crossorigin="anonymous"
```

### 7.3 Asset Tokenisation (Optional)

URLs can expire:

```
/api/apikeychain/:projectId/js?token=4h-expiry
```

---

# 8. **Rate Limiting & Abuse Prevention**

APIKeyChain implements:

### 8.1 Per-Project Rate Limits

Protects tenants from traffic floods.

### 8.2 Behaviour-Based Limits

AI-assisted rules detect unusual patterns:

* Geographic anomalies
* Parameter anomalies
* High failure rates
* Non-whitelisted origins

Triggers:

* Temporary suspension
* Key rotation
* Tenant alert

---

# 9. **Audit Logging**

APIKeyChain logs every sensitive action:

### 9.1 Admin Log Events

* Creating a project
* Updating keys
* Adding a domain
* Uploading assets

### 9.2 Proxy Log Events

* Target URL
* Duration
* Status code
* Result size

### 9.3 Tamper-Evident Hashing

All logs can be chained using:

```
entry_hash = SHA256(previous_hash + log_payload)
```

Provides forensic integrity.

---

# 10. **Tenant Isolation Strategy**

APIKeyChain uses a multi-layer isolation mechanism:

### 10.1 Database-Level Isolation

Each module schema is separate (`apikeychain`), with:

* RLS policies
* Tenant ID enforcement
* No cross-tenant queries

### 10.2 Storage Isolation

R2 prefixes:

```
r2://apikeychain/<tenantId>/<projectId>/
```

### 10.3 Runtime Isolation

Proxy routes dynamically load configuration *only* for the matching tenant.

---

# 11. **Future Security Enhancements**

### ● Post-quantum hybrid encryption

AES-256 + Kyber/Dilithium.

### ● Device-bound admin accounts

Requires a verified device key.

### ● QR-code confirmation

Approving sensitive actions via mobile.

### ● Automatic anomaly-based key rotation.

### ● Browser-side encryption for secret uploads.

---

# 12. **Compliance Mapping**

APIKeyChain supports alignment with:

### GDPR

Keys are pseudonymised and encrypted; logs avoid personal data.

### ISO 27001

Meets requirements for:

* cryptographic controls
* access management
* operational security

### NIST SP 800-63

Supports multi-factor and risk-based authentication.

---

# **Appendix A — Security Defaults**

| Setting          | Default                     | Purpose                  |
| ---------------- | --------------------------- | ------------------------ |
| CORS wildcard    | Disabled                    | Prevents off-site access |
| Secret retention | 72h rotation                | Limits exposure          |
| Proxy enabled    | Off                         | Zero-trust               |
| Upload allowed   | Off until project creation  | Prevents abuse           |
| JS/CSS served    | Only with correct projectId | Prevents leakage         |

---

# END OF DOCUMENT
