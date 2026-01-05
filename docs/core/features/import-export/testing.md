# Import/Export System - Testing Plan

**Document Version:** 1.0  
**Last Updated:** 2026-01-05  
**Status:** 📋 READY FOR IMPLEMENTATION

---

## 1. Test Strategy Overview

### Testing Pyramid

```
         ┌────────────────┐
         │   E2E Tests    │ ← Full import workflows
         │   (Manual)     │
         ├────────────────┤
         │ Integration    │ ← API + Database
         │   Tests        │
         ├────────────────┤
         │  Unit Tests    │ ← Validation logic, parsers
         └────────────────┘
```

### Test Coverage Goals
- **Unit Tests:** 80%+ (validation, parsing, mapping logic)
- **Integration Tests:** Key workflows (import, rollback)
- **E2E Tests:** Happy path + critical error scenarios

---

## 2. Unit Tests

### 2.1 Validation Logic

**File:** `src/lib/import/validation.test.ts`

```typescript
import { describe, it, expect } from 'vitest';
import { validateClubData, validateTeamData } from './validation';

describe('Club Validation', () => {
  it('should pass with valid club data', () => {
    const data = {
      club_id: '1',
      club_name: 'Derby Rangers',
      short_name: 'Rangers'
    };
    
    const result = validateClubData(data);
    expect(result.valid).toBe(true);
    expect(result.errors).toHaveLength(0);
  });
  
  it('should fail if club_id is missing', () => {
    const data = {
      club_name: 'Derby Rangers'
    };
    
    const result = validateClubData(data);
    expect(result.valid).toBe(false);
    expect(result.errors).toContainEqual(
      expect.objectContaining({ field: 'club_id' })
    );
  });
  
  it('should fail if club_name is missing', () => {
    const data = {
      club_id: '1'
    };
    
    const result = validateClubData(data);
    expect(result.valid).toBe(false);
    expect(result.errors).toContainEqual(
      expect.objectContaining({ field: 'club_name' })
    );
  });
  
  it('should warn on duplicate club_id', () => {
    const data = [
      { club_id: '1', club_name: 'Club A' },
      { club_id: '1', club_name: 'Club B' }
    ];
    
    const result = validateClubData(data);
    expect(result.warnings).toContainEqual(
      expect.objectContaining({ warning: expect.stringContaining('Duplicate') })
    );
  });
  
  it('should validate email format', () => {
    const data = {
      club_id: '1',
      club_name: 'Rangers',
      contact_email: 'invalid-email'
    };
    
    const result = validateClubData(data);
    expect(result.errors).toContainEqual(
      expect.objectContaining({ field: 'contact_email' })
    );
  });
});

describe('Team Validation', () => {
  it('should fail if parent club not found', async () => {
    const data = {
      team_id: '101',
      club_id: '999',  // Non-existent club
      team_name: 'U9 Rangers'
    };
    
    const result = await validateTeamData(data, mockContext);
    expect(result.errors).toContainEqual(
      expect.objectContaining({ 
        field: 'club_id',
        error: expect.stringContaining('not found')
      })
    );
  });
});
```

---

### 2.2 CSV Parser

**File:** `src/lib/import/parser.test.ts`

```typescript
import { describe, it, expect } from 'vitest';
import { parseCSV } from './parser';

describe('CSV Parser', () => {
  it('should parse standard CSV', () => {
    const csv = `club_id,club_name
1,Derby Rangers
2,Nottingham United`;
    
    const result = parseCSV(csv);
    expect(result).toHaveLength(2);
    expect(result[0]).toEqual({ club_id: '1', club_name: 'Derby Rangers' });
  });
  
  it('should handle quoted fields with commas', () => {
    const csv = `club_id,club_name
1,"Rangers, Derby"`;
    
    const result = parseCSV(csv);
    expect(result[0].club_name).toBe('Rangers, Derby');
  });
  
  it('should trim whitespace', () => {
    const csv = `club_id, club_name
1  , Derby Rangers  `;
    
    const result = parseCSV(csv);
    expect(result[0].club_name).toBe('Derby Rangers');
  });
  
  it('should handle UTF-8 BOM', () => {
    const csv = '\uFEFFclub_id,club_name\n1,Rangers';
    
    const result = parseCSV(csv);
    expect(result).toHaveLength(1);
  });
});
```

---

### 2.3 Legacy Key Mapper

**File:** `src/lib/import/mapper.test.ts`

```typescript
import { describe, it, expect } from 'vitest';
import { getLegacyMapping, createMapping } from './mapper';

describe('Legacy Key Mapper', () => {
  it('should find existing mapping', async () => {
    const mapping = await getLegacyMapping({
      organizationId: 'org-123',
      entityType: 'CLUB',
      legacyId: '42'
    });
    
    expect(mapping).toBeDefined();
    expect(mapping.newId).toMatch(/^[a-f0-9-]{36}$/);  // UUID format
  });
  
  it('should return null if mapping not found', async () => {
    const mapping = await getLegacyMapping({
      organizationId: 'org-123',
      entityType: 'CLUB',
      legacyId: '999'
    });
    
    expect(mapping).toBeNull();
  });
  
  it('should create new mapping', async () => {
    const mapping = await createMapping({
      importJobId: 'job-123',
      organizationId: 'org-123',
      entityType: 'CLUB',
      legacyId: '50',
      newId: 'new-uuid-123'
    });
    
    expect(mapping.legacyId).toBe('50');
    expect(mapping.newId).toBe('new-uuid-123');
  });
  
  it('should prevent duplicate mappings', async () => {
    // Try to create same mapping twice
    await createMapping({
      organizationId: 'org-123',
      entityType: 'CLUB',
      legacyId: '42',
      newId: 'uuid-1'
    });
    
    await expect(
      createMapping({
        organizationId: 'org-123',
        entityType: 'CLUB',
        legacyId: '42',
        newId: 'uuid-2'
      })
    ).rejects.toThrow('Unique constraint violation');
  });
});
```

---

## 3. Integration Tests

### 3.1 Club Import (Happy Path)

**File:** `src/server/core/routers/import.router.test.ts`

```typescript
import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import { createCallerFactory } from '@/server/core/trpc';
import { importRouter } from './import.router';
import { prisma } from '@/lib/prisma';

describe('Import Router - Club Import', () => {
  let caller: any;
  let testOrgId: string;
  let testUserId: string;
  let testSeasonId: string;
  
  beforeEach(async () => {
    // Setup test organization, user, season
    const org = await prisma.organization.create({
      data: { name: 'Test Org', slug: 'test-org' }
    });
    testOrgId = org.id;
    
    const user = await prisma.user.create({
      data: {
        email: 'test@example.com',
        organizationId: testOrgId,
        role: 'OWNER'
      }
    });
    testUserId = user.id;
    
    const season = await prisma.lMSProSeason.create({
      data: {
        organizationId: testOrgId,
        name: 'Test Season',
        startDate: new Date(),
        endDate: new Date()
      }
    });
    testSeasonId = season.id;
    
    // Create tRPC caller with test context
    const createCaller = createCallerFactory(importRouter);
    caller = createCaller({
      session: {
        user: {
          id: testUserId,
          organizationId: testOrgId,
          role: 'OWNER'
        }
      },
      prisma
    });
  });
  
  afterEach(async () => {
    // Cleanup test data
    await prisma.legacyKeyMapping.deleteMany({ where: { organizationId: testOrgId } });
    await prisma.importJob.deleteMany({ where: { organizationId: testOrgId } });
    await prisma.lMSProClub.deleteMany({ where: { organizationId: testOrgId } });
    await prisma.lMSProSeason.deleteMany({ where: { organizationId: testOrgId } });
    await prisma.user.deleteMany({ where: { organizationId: testOrgId } });
    await prisma.organization.delete({ where: { id: testOrgId } });
  });
  
  it('should create import job', async () => {
    const job = await caller.createJob({
      name: 'Test Import',
      entityType: 'CLUB',
      seasonId: testSeasonId
    });
    
    expect(job).toBeDefined();
    expect(job.organizationId).toBe(testOrgId);
    expect(job.status).toBe('PENDING');
  });
  
  it('should validate club data', async () => {
    const job = await caller.createJob({
      name: 'Test Import',
      entityType: 'CLUB',
      seasonId: testSeasonId
    });
    
    const data = [
      { club_id: '1', club_name: 'Derby Rangers', short_name: 'Rangers' },
      { club_id: '2', club_name: 'Nottingham United', short_name: 'United' }
    ];
    
    const validation = await caller.validateData({
      importJobId: job.id,
      data
    });
    
    expect(validation.valid).toBe(true);
    expect(validation.errors).toHaveLength(0);
  });
  
  it('should import clubs successfully', async () => {
    const job = await caller.createJob({
      name: 'Test Import',
      entityType: 'CLUB',
      seasonId: testSeasonId
    });
    
    const data = [
      { club_id: '1', club_name: 'Derby Rangers', short_name: 'Rangers' },
      { club_id: '2', club_name: 'Nottingham United', short_name: 'United' }
    ];
    
    const result = await caller.executeImport({
      importJobId: job.id,
      data
    });
    
    expect(result.successCount).toBe(2);
    expect(result.failureCount).toBe(0);
    
    // Verify clubs created
    const clubs = await prisma.lMSProClub.findMany({
      where: { organizationId: testOrgId }
    });
    expect(clubs).toHaveLength(2);
    
    // Verify mappings created
    const mappings = await prisma.legacyKeyMapping.findMany({
      where: { importJobId: job.id }
    });
    expect(mappings).toHaveLength(2);
    expect(mappings[0].legacyId).toBe('1');
    expect(mappings[1].legacyId).toBe('2');
  });
  
  it('should handle partial failures gracefully', async () => {
    const job = await caller.createJob({
      name: 'Test Import',
      entityType: 'CLUB',
      seasonId: testSeasonId
    });
    
    const data = [
      { club_id: '1', club_name: 'Derby Rangers', short_name: 'Rangers' },
      { club_id: '2', club_name: '', short_name: 'United' },  // Invalid: empty name
      { club_id: '3', club_name: 'Leicestershire FC', short_name: 'LCFC' }
    ];
    
    const result = await caller.executeImport({
      importJobId: job.id,
      data
    });
    
    expect(result.successCount).toBe(2);  // #1 and #3 succeed
    expect(result.failureCount).toBe(1);  // #2 fails
    expect(result.errors).toHaveLength(1);
  });
});
```

---

### 3.2 Team Import (With Parent Mapping)

```typescript
describe('Import Router - Team Import', () => {
  it('should import teams using club mappings', async () => {
    // First: Import clubs
    const clubJob = await caller.createJob({
      name: 'Club Import',
      entityType: 'CLUB',
      seasonId: testSeasonId
    });
    
    const clubData = [
      { club_id: '1', club_name: 'Derby Rangers', short_name: 'Rangers' }
    ];
    
    await caller.executeImport({
      importJobId: clubJob.id,
      data: clubData
    });
    
    // Second: Import teams
    const teamJob = await caller.createJob({
      name: 'Team Import',
      entityType: 'TEAM',
      seasonId: testSeasonId
    });
    
    const teamData = [
      { team_id: '101', club_id: '1', team_name: 'U9 Rangers', age_group: 'U9' }
    ];
    
    const result = await caller.executeImport({
      importJobId: teamJob.id,
      data: teamData
    });
    
    expect(result.successCount).toBe(1);
    
    // Verify team has correct clubId (UUID, not legacy ID)
    const team = await prisma.lMSProTeam.findFirst({
      where: { organizationId: testOrgId }
    });
    
    expect(team).toBeDefined();
    expect(team.clubId).toMatch(/^[a-f0-9-]{36}$/);  // UUID format
    
    // Verify team.clubId matches club's UUID
    const clubMapping = await prisma.legacyKeyMapping.findFirst({
      where: { entityType: 'CLUB', legacyId: '1' }
    });
    
    expect(team.clubId).toBe(clubMapping.newId);
  });
  
  it('should fail if parent club not imported', async () => {
    const teamJob = await caller.createJob({
      name: 'Team Import',
      entityType: 'TEAM',
      seasonId: testSeasonId
    });
    
    const teamData = [
      { team_id: '101', club_id: '999', team_name: 'U9 Rangers', age_group: 'U9' }
    ];
    
    const validation = await caller.validateData({
      importJobId: teamJob.id,
      data: teamData
    });
    
    expect(validation.valid).toBe(false);
    expect(validation.errors).toContainEqual(
      expect.objectContaining({
        field: 'club_id',
        error: expect.stringContaining('not found')
      })
    );
  });
});
```

---

### 3.3 Rollback Test

```typescript
describe('Import Router - Rollback', () => {
  it('should rollback import completely', async () => {
    // Import clubs
    const job = await caller.createJob({
      name: 'Test Import',
      entityType: 'CLUB',
      seasonId: testSeasonId
    });
    
    const data = [
      { club_id: '1', club_name: 'Derby Rangers' },
      { club_id: '2', club_name: 'Nottingham United' }
    ];
    
    await caller.executeImport({ importJobId: job.id, data });
    
    // Verify data exists
    let clubs = await prisma.lMSProClub.findMany({
      where: { organizationId: testOrgId }
    });
    expect(clubs).toHaveLength(2);
    
    let mappings = await prisma.legacyKeyMapping.findMany({
      where: { importJobId: job.id }
    });
    expect(mappings).toHaveLength(2);
    
    // Rollback
    const result = await caller.rollback({ importJobId: job.id });
    
    expect(result.success).toBe(true);
    expect(result.deletedCount).toBe(2);
    
    // Verify data deleted
    clubs = await prisma.lMSProClub.findMany({
      where: { organizationId: testOrgId }
    });
    expect(clubs).toHaveLength(0);
    
    mappings = await prisma.legacyKeyMapping.findMany({
      where: { importJobId: job.id }
    });
    expect(mappings).toHaveLength(0);
    
    // Verify job status updated
    const updatedJob = await prisma.importJob.findUnique({
      where: { id: job.id }
    });
    expect(updatedJob.status).toBe('ROLLED_BACK');
  });
});
```

---

## 4. End-to-End Tests (Manual)

### Scenario 1: Happy Path - Club Import

**Steps:**
1. Login as OWNER (e.g., `owner@acme.com`)
2. Navigate to `/app/admin/import`
3. Click "Start Import"
4. Select entity type: "Clubs"
5. Upload CSV file: `test-clubs.csv`
   ```csv
   club_id,club_name,short_name,fa_number
   1,Derby Rangers,Rangers,FA12345
   2,Nottingham United,United,FA67890
   ```
6. Click "Validate Data"
7. Verify: "Validation passed - 2 records ready"
8. Click "Execute Import"
9. Wait for completion
10. Verify: "Import complete - 2 clubs imported"

**Expected Results:**
- ✅ Import job created with status COMPLETED
- ✅ 2 clubs visible in `/app/lmspro/clubs`
- ✅ 2 mappings in `LegacyKeyMapping` table
- ✅ Audit logs created for import

**Verification:**
```sql
-- Check clubs created
SELECT * FROM lmspro_clubs WHERE organization_id = '<org-id>';

-- Check mappings
SELECT * FROM legacy_key_mappings WHERE import_job_id = '<job-id>';

-- Check audit logs
SELECT * FROM audit_logs WHERE action LIKE 'CLUB_%' ORDER BY created_at DESC;
```

---

### Scenario 2: Validation Failure

**Steps:**
1. Upload CSV with missing required field:
   ```csv
   club_id,short_name
   1,Rangers
   ```
2. Click "Validate Data"

**Expected Results:**
- ❌ Validation fails
- ❌ Error shown: "Row 1: club_name is required"
- ❌ Import button disabled
- ❌ No data written to database

---

### Scenario 3: Partial Success

**Steps:**
1. Upload CSV with mix of valid/invalid rows:
   ```csv
   club_id,club_name,short_name
   1,Derby Rangers,Rangers
   2,,United
   3,Leicestershire FC,LCFC
   ```
2. Validate → Pass (warnings shown)
3. Execute import

**Expected Results:**
- ✅ Import job status: COMPLETED
- ✅ successCount: 2 (rows 1 and 3)
- ✅ failureCount: 1 (row 2)
- ✅ Errors array contains row 2 details
- ✅ 2 clubs created (not 3)

---

### Scenario 4: Hierarchical Import (Clubs → Teams)

**Steps:**
1. Import clubs first:
   ```csv
   club_id,club_name
   1,Derby Rangers
   ```
2. Verify: 1 club imported
3. Import teams:
   ```csv
   team_id,club_id,team_name,age_group
   101,1,U9 Rangers,U9
   102,1,U10 Rangers,U10
   ```
4. Verify: 2 teams imported

**Expected Results:**
- ✅ Teams have correct `clubId` (UUID, not "1")
- ✅ `clubId` matches club's UUID from mapping table
- ✅ Navigating to club shows 2 teams

---

### Scenario 5: Rollback

**Steps:**
1. Import clubs (2 records)
2. Verify: 2 clubs visible
3. Navigate to `/app/admin/import/jobs`
4. Click "Rollback" on import job
5. Confirm rollback

**Expected Results:**
- ✅ Confirmation modal shown
- ✅ After confirm: clubs deleted
- ✅ Mappings deleted
- ✅ Job status: ROLLED_BACK
- ✅ Audit log: IMPORT_ROLLED_BACK

---

### Scenario 6: Permission Check (MEMBER Role)

**Steps:**
1. Login as MEMBER (`member@acme.com`)
2. Attempt to navigate to `/app/admin/import`

**Expected Results:**
- ❌ Access denied (403 Forbidden)
- ❌ OR redirected to dashboard
- ❌ No import UI visible

---

### Scenario 7: Tenant Isolation

**Steps:**
1. Login as OWNER of Organization A
2. Import clubs for Org A
3. Login as OWNER of Organization B
4. Navigate to `/app/admin/import/jobs`

**Expected Results:**
- ❌ Organization B cannot see Org A's import jobs
- ❌ Organization B cannot view Org A's imported clubs
- ✅ Tenant scoping enforced

---

## 5. Performance Tests

### 5.1 Large Import Test

**Objective:** Verify system handles 1000+ row imports

**Setup:**
- Generate CSV with 1000 clubs
- Monitor import duration and memory usage

**Success Criteria:**
- ✅ Import completes in < 5 minutes
- ✅ No timeout errors
- ✅ Memory usage stays under 512MB
- ✅ Database remains responsive

**Test Script:**
```bash
# Generate 1000-row CSV
node scripts/generate-test-data.js --rows 1000 --entity clubs

# Monitor import
npm run dev
# Navigate to import UI, upload file
# Watch server logs for performance metrics
```

---

### 5.2 Concurrent Import Test

**Objective:** Verify system handles multiple simultaneous imports

**Setup:**
- 3 different users
- Each imports 100 rows
- All start within 10 seconds

**Success Criteria:**
- ✅ All imports complete successfully
- ✅ No data corruption
- ✅ Correct tenant scoping maintained

---

## 6. Security Tests

### 6.1 SQL Injection Test

**Objective:** Verify input sanitization

**Test:**
```typescript
const maliciousData = [
  { 
    club_id: "1'; DROP TABLE clubs; --",
    club_name: "Evil Club"
  }
];

// Should fail validation or be safely escaped
```

**Expected:** No database damage, import fails gracefully

---

### 6.2 Cross-Tenant Access Test

**Objective:** Verify tenant isolation

**Test:**
```typescript
// User from Org A tries to import into Org B
const job = await prisma.importJob.create({
  data: {
    organizationId: 'org-b-id',  // Different org
    // ... other fields
  }
});

// Should fail with authorization error
```

**Expected:** Permission denied error

---

## 7. Test Data Sets

### 7.1 Minimal Valid CSV (Clubs)
```csv
club_id,club_name
1,Test Club
```

### 7.2 Full Valid CSV (Clubs)
```csv
club_id,club_name,short_name,fa_number,contact_name,contact_email,contact_phone
1,Derby Rangers FC,Rangers,FA12345,John Smith,john@rangers.com,07700900000
2,Nottingham United,United,FA67890,Jane Doe,jane@united.com,07700900001
```

### 7.3 Invalid CSV (Missing Required Field)
```csv
club_id,short_name
1,Rangers
```

### 7.4 CSV with Duplicates
```csv
club_id,club_name
1,Derby Rangers
1,Nottingham United
```

### 7.5 Hierarchical CSV (Teams)
```csv
team_id,club_id,team_name,age_group
101,1,U9 Rangers,U9
102,1,U10 Rangers,U10
103,2,U9 United,U9
```

---

## 8. Regression Tests

After any changes to import system:

- [ ] Run full unit test suite (`npm run test`)
- [ ] Test club import (happy path)
- [ ] Test team import (with mapping lookup)
- [ ] Test validation failure
- [ ] Test rollback
- [ ] Test permission checks
- [ ] Test tenant isolation

---

## 9. Bug Tracking

### Known Issues

| Issue # | Description | Severity | Status | Workaround |
|---------|-------------|----------|--------|------------|
| #1 | CSV with UTF-8 BOM fails parsing | Medium | Open | Strip BOM manually |
| #2 | Large imports (>1000 rows) timeout | High | Planned | Split into batches |
| #3 | Email validation too strict | Low | Won't Fix | Use standard regex |

---

## 10. Test Automation

### CI/CD Integration

```yaml
# .github/workflows/test-import.yml
name: Import System Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
      - run: npm install
      - run: npm run test -- import.router.test.ts
      - run: npm run test -- validation.test.ts
      - run: npm run test -- parser.test.ts
```

---

## 11. Acceptance Criteria Checklist

Before marking feature as complete:

- [ ] All unit tests pass (80%+ coverage)
- [ ] All integration tests pass
- [ ] Manual E2E scenarios tested (Scenarios 1-7)
- [ ] Performance tests pass (1000+ rows)
- [ ] Security tests pass (SQL injection, tenant isolation)
- [ ] Rollback functionality verified
- [ ] Permission checks enforced (P1 & C1 only)
- [ ] Audit logging working
- [ ] User documentation written
- [ ] API documentation updated
- [ ] No critical bugs remaining

---

## Summary

This testing plan ensures the Import/Export system is robust, secure, and performs well under various conditions. Priority should be given to tenant isolation tests and rollback functionality, as these are critical for data integrity in a multi-tenant SaaS platform.

**Next Steps:**
- Implement unit tests during Phase 2-3
- Run integration tests during Phase 4
- Conduct manual E2E testing during Phase 6
- Performance testing before production deployment
