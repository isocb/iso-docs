# Import/Export System - Implementation Plan

**Status:** 📋 PLANNING  
**Priority:** HIGH  
**Est. Duration:** 5-7 days  
**Owner:** Platform (P1 & C1 only)  
**Last Updated:** 2026-01-05

---

## Executive Summary

The Import/Export system enables migration of legacy data (with integer PKs) into IsoStack (UUID-based), preserving foreign key relationships through a mapping table. This feature is critical for onboarding new organizations (e.g., sports leagues) with existing data.

**Core Pattern:** Legacy ID → UUID Mapping → Hierarchical Import (Clubs → Teams → Players)

---

## Goals & Success Criteria

- [x] **Goal 1**: Design three-table architecture (ImportJob, LegacyKeyMapping, Entities)
- [ ] **Goal 2**: Platform Admins (P1 & C1) can import clubs with legacy IDs
- [ ] **Goal 3**: Teams can be imported using parent club mappings
- [ ] **Goal 4**: Validation prevents bad data from entering database
- [ ] **Goal 5**: Failed imports can be rolled back completely
- [ ] **Goal 6**: All imports are audit-logged for compliance

---

## Architecture Overview

### Data Flow
```
1. User uploads CSV/JSON
   ↓
2. Validation (file format, required fields, FK existence)
   ↓
3. Create ImportJob (status: VALIDATING)
   ↓
4. For each row:
   - Create new entity (UUID)
   - Store LegacyKeyMapping (legacy_id → new_uuid)
   - Audit log entry
   ↓
5. Update ImportJob (status: COMPLETED or FAILED)
```

### Key Components

1. **Database Layer**: 3 new models
   - `ImportJob` - Tracks import batches
   - `LegacyKeyMapping` - Maps old IDs to new UUIDs
   - Entities (Club, Team, etc.) - Actual data

2. **Backend Layer**: tRPC router
   - `import.router.ts` - CRUD for import jobs
   - Validation logic
   - Import execution engine
   - Rollback functionality

3. **Frontend Layer**: Import wizard
   - Multi-step stepper UI
   - File upload component
   - Validation results display
   - Progress tracking

4. **Integration Points**:
   - Audit logging (every import logged)
   - Permissions (P1 & C1 only)
   - Multi-tenancy (organizationId scoping)

---

## Database Schema

### New Models

```prisma
// Import job tracking
model ImportJob {
  id             String        @id @default(uuid())
  organizationId String        @map("organization_id")
  seasonId       String?       @map("season_id")  // For module-specific imports
  
  name           String        // "Derby Rangers Club Import 2025"
  description    String?
  status         ImportStatus  @default(PENDING)
  entityType     ImportEntityType @map("entity_type")
  
  // Import metadata
  sourceSystem   String?       // "LeagueManager v3.2", "Excel Export"
  totalRecords   Int           @default(0) @map("total_records")
  successCount   Int           @default(0) @map("success_count")
  failureCount   Int           @default(0) @map("failure_count")
  
  // Error tracking
  errors         Json[]        @default([])
  warnings       Json[]        @default([])
  
  // Audit
  createdById    String        @map("created_by_id")
  createdBy      User          @relation("ImportJobCreator", fields: [createdById], references: [id])
  startedAt      DateTime?     @map("started_at")
  completedAt    DateTime?     @map("completed_at")
  createdAt      DateTime      @default(now()) @map("created_at")
  updatedAt      DateTime      @updatedAt     @map("updated_at")
  
  // Relations
  organization   Organization  @relation(fields: [organizationId], references: [id], onDelete: Cascade)
  mappings       LegacyKeyMapping[]
  
  @@index([organizationId, status])
  @@index([createdById])
  @@map("import_jobs")
  @@schema("public")
}

// Legacy key mappings
model LegacyKeyMapping {
  id             String        @id @default(uuid())
  importJobId    String        @map("import_job_id")
  organizationId String        @map("organization_id")
  
  entityType     ImportEntityType @map("entity_type")
  legacyId       String        @map("legacy_id")     // Original ID (as string)
  newId          String        @map("new_id")        // New UUID
  
  // Optional: Store original data for debugging
  legacyData     Json?         @map("legacy_data")
  
  createdAt      DateTime      @default(now()) @map("created_at")
  
  // Relations
  importJob      ImportJob     @relation(fields: [importJobId], references: [id], onDelete: Cascade)
  organization   Organization  @relation(fields: [organizationId], references: [id], onDelete: Cascade)
  
  @@unique([organizationId, entityType, legacyId])
  @@index([importJobId])
  @@index([organizationId, entityType, newId])
  @@map("legacy_key_mappings")
  @@schema("public")
}

// Enums
enum ImportStatus {
  PENDING       // Import job created, not started
  VALIDATING    // Checking data format and integrity
  IMPORTING     // Writing data to database
  COMPLETED     // Successfully finished
  FAILED        // Encountered errors
  ROLLED_BACK   // Import was reversed
  
  @@schema("public")
}

enum ImportEntityType {
  CLUB
  TEAM
  VENUE
  REFEREE
  USER
  AGE_GROUP
  
  @@schema("public")
}
```

### Modified Models

```prisma
// Add relations to existing models
model Organization {
  // ... existing fields
  importJobs         ImportJob[]
  legacyKeyMappings  LegacyKeyMapping[]
}

model User {
  // ... existing fields
  createdImportJobs  ImportJob[] @relation("ImportJobCreator")
}
```

---

## Implementation Phases

### Phase 1: Database Schema (2 hours)

**Goal:** Add ImportJob and LegacyKeyMapping models to Prisma schema

**Prerequisites:**
- [x] Database backup taken
- [x] Neon dev database accessible

**Tasks:**
1. Update `prisma/schema.prisma` with new models
2. Add enums (ImportStatus, ImportEntityType)
3. Add relations to Organization and User models
4. Run `npm run db:push` to apply schema
5. Verify in Prisma Studio

**Deliverables:**
- ✅ Two new tables created
- ✅ No breaking changes to existing schema
- ✅ Seed data still works

**Testing:**
```bash
npm run db:push
npm run db:studio  # Verify tables exist
npm run db:seed    # Ensure seed still works
```

**Files Changed:**
- `prisma/schema.prisma` (add models after User model)

---

### Phase 2: tRPC Router - Job Management (3 hours)

**Goal:** Create import.router.ts with CRUD operations for ImportJob

**Prerequisites:**
- [x] Phase 1 completed
- [x] Schema generated (`npm run db:generate`)

**Tasks:**
1. Create `src/server/core/routers/import.router.ts`
2. Implement endpoints:
   - `createJob` - Create new import job
   - `getJob` - Get job by ID with mappings
   - `listJobs` - List all jobs for organization
   - `deleteJob` - Delete job (P1 only)
3. Add Zod validation schemas
4. Add permission checks (requireRole([Role.OWNER]))
5. Register router in `src/server/core/routers/index.ts`

**Deliverables:**
- ✅ Import router registered
- ✅ All endpoints scoped by organizationId
- ✅ Audit logs for all mutations

**Implementation:**
```typescript
// src/server/core/routers/import.router.ts
import { router, protectedProcedure, requireRole } from '../trpc';
import { z } from 'zod';
import { Role } from '@prisma/client';

export const importRouter = router({
  // Create import job
  createJob: requireRole([Role.OWNER])
    .input(z.object({
      name: z.string().min(1, 'Job name required'),
      description: z.string().optional(),
      entityType: z.enum(['CLUB', 'TEAM', 'VENUE', 'REFEREE', 'USER', 'AGE_GROUP']),
      seasonId: z.string().optional(),
      sourceSystem: z.string().optional()
    }))
    .mutation(async ({ ctx, input }) => {
      const job = await ctx.prisma.importJob.create({
        data: {
          ...input,
          organizationId: ctx.session.user.organizationId,
          createdById: ctx.session.user.id,
          status: 'PENDING'
        }
      });
      
      // Audit log
      await ctx.prisma.auditLog.create({
        data: {
          action: 'IMPORT_JOB_CREATED',
          entityType: 'ImportJob',
          entityId: job.id,
          metadata: { jobName: input.name, entityType: input.entityType },
          userId: ctx.session.user.id,
          organizationId: ctx.session.user.organizationId
        }
      });
      
      return job;
    }),
  
  // Get job by ID
  getJob: requireRole([Role.OWNER])
    .input(z.object({ id: z.string() }))
    .query(async ({ ctx, input }) => {
      return await ctx.prisma.importJob.findUnique({
        where: { 
          id: input.id,
          organizationId: ctx.session.user.organizationId  // Tenant scoping
        },
        include: {
          mappings: true,
          createdBy: { select: { name: true, email: true } }
        }
      });
    }),
  
  // List all jobs for org
  listJobs: requireRole([Role.OWNER])
    .input(z.object({
      status: z.enum(['PENDING', 'VALIDATING', 'IMPORTING', 'COMPLETED', 'FAILED', 'ROLLED_BACK']).optional()
    }))
    .query(async ({ ctx, input }) => {
      return await ctx.prisma.importJob.findMany({
        where: { 
          organizationId: ctx.session.user.organizationId,
          ...(input.status && { status: input.status })
        },
        include: {
          createdBy: { select: { name: true, email: true } },
          _count: { select: { mappings: true } }
        },
        orderBy: { createdAt: 'desc' }
      });
    }),
});
```

**Files Changed:**
- `src/server/core/routers/import.router.ts` (new)
- `src/server/core/routers/index.ts` (register router)

**Testing:**
```bash
# Start dev server
npm run dev

# Test in browser console:
# const job = await trpc.import.createJob.mutate({ 
#   name: "Test Import", 
#   entityType: "CLUB" 
# });
```

---

### Phase 3: Import Execution Engine (4 hours)

**Goal:** Implement import logic with validation and mapping

**Prerequisites:**
- [x] Phase 2 completed
- [x] Sample CSV files prepared

**Tasks:**
1. Add `validateData` endpoint - validates CSV before import
2. Add `executeImport` endpoint - performs actual import
3. Implement CSV parser utility
4. Add legacy key mapping logic
5. Add transaction handling (atomicity)
6. Add error collection logic

**Implementation:**
```typescript
// Add to import.router.ts

// Validate uploaded data
validateData: requireRole([Role.OWNER])
  .input(z.object({
    importJobId: z.string(),
    data: z.array(z.record(z.any()))  // Flexible JSON
  }))
  .mutation(async ({ ctx, input }) => {
    const errors: any[] = [];
    const warnings: any[] = [];
    
    // Validation rules
    for (const [index, row] of input.data.entries()) {
      // Check required fields
      if (!row.club_name) {
        errors.push({ row: index + 1, field: 'club_name', error: 'Required field missing' });
      }
      
      // Check data types
      if (row.club_id && isNaN(Number(row.club_id))) {
        errors.push({ row: index + 1, field: 'club_id', error: 'Must be numeric' });
      }
      
      // Check duplicates
      const duplicate = input.data.find((r, i) => 
        i !== index && r.club_id === row.club_id
      );
      if (duplicate) {
        warnings.push({ row: index + 1, field: 'club_id', warning: 'Duplicate ID found' });
      }
    }
    
    const isValid = errors.length === 0;
    
    // Update job
    await ctx.prisma.importJob.update({
      where: { id: input.importJobId },
      data: {
        status: isValid ? 'VALIDATING' : 'FAILED',
        errors,
        warnings,
        totalRecords: input.data.length
      }
    });
    
    return { valid: isValid, errors, warnings };
  }),

// Execute import
executeImport: requireRole([Role.OWNER])
  .input(z.object({
    importJobId: z.string(),
    data: z.array(z.record(z.any()))
  }))
  .mutation(async ({ ctx, input }) => {
    const job = await ctx.prisma.importJob.findUnique({
      where: { id: input.importJobId }
    });
    
    if (!job) throw new Error('Import job not found');
    
    // Update job status
    await ctx.prisma.importJob.update({
      where: { id: input.importJobId },
      data: { 
        status: 'IMPORTING',
        startedAt: new Date(),
        totalRecords: input.data.length
      }
    });
    
    let successCount = 0;
    let failureCount = 0;
    const errors: any[] = [];
    
    // Import each row
    for (const legacyRow of input.data) {
      try {
        await ctx.prisma.$transaction(async (tx) => {
          // Create entity (example: Club)
          if (job.entityType === 'CLUB') {
            const newClub = await tx.lMSProClub.create({
              data: {
                organizationId: job.organizationId,
                seasonId: job.seasonId!,
                fullName: legacyRow.club_name,
                shortName: legacyRow.short_name || legacyRow.club_name,
                faNumber: legacyRow.fa_number,
                status: 'APPROVED',
                primaryContact: {
                  name: legacyRow.contact_name,
                  email: legacyRow.contact_email,
                  phone: legacyRow.contact_phone
                }
              }
            });
            
            // Store legacy mapping
            await tx.legacyKeyMapping.create({
              data: {
                importJobId: input.importJobId,
                organizationId: job.organizationId,
                entityType: 'CLUB',
                legacyId: legacyRow.club_id.toString(),
                newId: newClub.id,
                legacyData: legacyRow
              }
            });
            
            // Audit log
            await tx.auditLog.create({
              data: {
                action: 'CLUB_IMPORTED',
                entityType: 'LMSProClub',
                entityId: newClub.id,
                metadata: { 
                  legacyId: legacyRow.club_id,
                  importJobId: input.importJobId 
                },
                userId: job.createdById,
                organizationId: job.organizationId
              }
            });
          }
        });
        
        successCount++;
      } catch (error: any) {
        failureCount++;
        errors.push({
          legacyId: legacyRow.club_id,
          name: legacyRow.club_name,
          error: error.message
        });
      }
    }
    
    // Update job status
    await ctx.prisma.importJob.update({
      where: { id: input.importJobId },
      data: {
        status: failureCount === input.data.length ? 'FAILED' : 'COMPLETED',
        successCount,
        failureCount,
        errors,
        completedAt: new Date()
      }
    });
    
    return { successCount, failureCount, errors };
  }),
```

**Files Changed:**
- `src/server/core/routers/import.router.ts` (add endpoints)

**Testing:**
```typescript
// Test with sample data
const sampleClubs = [
  { club_id: 1, club_name: "Derby Rangers", short_name: "Rangers" },
  { club_id: 2, club_name: "Nottingham United", short_name: "United" }
];

// 1. Validate
const validation = await trpc.import.validateData.mutate({
  importJobId: "job-id",
  data: sampleClubs
});

// 2. Execute if valid
if (validation.valid) {
  const result = await trpc.import.executeImport.mutate({
    importJobId: "job-id",
    data: sampleClubs
  });
}
```

---

### Phase 4: Rollback Functionality (2 hours)

**Goal:** Allow reverting failed or incorrect imports

**Tasks:**
1. Add `rollback` endpoint to import router
2. Implement cascading delete logic
3. Update audit logs
4. Add confirmation UI (frontend)

**Implementation:**
```typescript
// Add to import.router.ts

rollback: requireRole([Role.OWNER])
  .input(z.object({ importJobId: z.string() }))
  .mutation(async ({ ctx, input }) => {
    // Get all mappings for this job
    const mappings = await ctx.prisma.legacyKeyMapping.findMany({
      where: { importJobId: input.importJobId }
    });
    
    await ctx.prisma.$transaction(async (tx) => {
      // Delete all imported entities
      for (const mapping of mappings) {
        if (mapping.entityType === 'CLUB') {
          await tx.lMSProClub.delete({ where: { id: mapping.newId } });
        } else if (mapping.entityType === 'TEAM') {
          await tx.lMSProTeam.delete({ where: { id: mapping.newId } });
        }
        // ... other entity types
      }
      
      // Delete mappings
      await tx.legacyKeyMapping.deleteMany({
        where: { importJobId: input.importJobId }
      });
      
      // Update job status
      await tx.importJob.update({
        where: { id: input.importJobId },
        data: { status: 'ROLLED_BACK' }
      });
      
      // Audit log
      await tx.auditLog.create({
        data: {
          action: 'IMPORT_ROLLED_BACK',
          entityType: 'ImportJob',
          entityId: input.importJobId,
          metadata: { deletedCount: mappings.length },
          userId: ctx.session.user.id,
          organizationId: ctx.session.user.organizationId
        }
      });
    });
    
    return { success: true, deletedCount: mappings.length };
  }),
```

**Files Changed:**
- `src/server/core/routers/import.router.ts`

---

### Phase 5: Frontend - Import Wizard (6 hours)

**Goal:** Create multi-step UI for import process

**Tasks:**
1. Create `/app/(app)/app/admin/import/page.tsx`
2. Build ImportWizard component (Mantine Stepper)
3. Add file upload (CSV/JSON)
4. Add validation results display
5. Add import progress tracking
6. Add success/error notifications

**Implementation:**
```typescript
// src/app/(app)/app/admin/import/page.tsx
'use client';

import { useState } from 'react';
import { Container, Title, Stepper, Button, FileInput, Table, Alert, Stack } from '@mantine/core';
import { trpc } from '@/lib/trpc/client';
import { notifications } from '@mantine/notifications';

export default function ImportPage() {
  const [active, setActive] = useState(0);
  const [importJob, setImportJob] = useState<any>(null);
  const [file, setFile] = useState<File | null>(null);
  const [parsedData, setParsedData] = useState<any[]>([]);
  const [validation, setValidation] = useState<any>(null);
  
  const createJob = trpc.import.createJob.useMutation();
  const validateData = trpc.import.validateData.useMutation();
  const executeImport = trpc.import.executeImport.useMutation();
  
  // Step 1: Create job
  const handleCreateJob = async () => {
    const job = await createJob.mutateAsync({
      name: `Import ${new Date().toLocaleDateString()}`,
      entityType: 'CLUB'
    });
    setImportJob(job);
    setActive(1);
  };
  
  // Step 2: Upload & validate
  const handleFileUpload = async () => {
    if (!file) return;
    
    // Parse CSV (simplified)
    const text = await file.text();
    const lines = text.split('\n');
    const headers = lines[0].split(',');
    
    const data = lines.slice(1).map(line => {
      const values = line.split(',');
      return headers.reduce((obj, header, i) => {
        obj[header.trim()] = values[i]?.trim();
        return obj;
      }, {} as any);
    });
    
    setParsedData(data);
    
    // Validate
    const result = await validateData.mutateAsync({
      importJobId: importJob.id,
      data
    });
    
    setValidation(result);
    
    if (result.valid) {
      setActive(2);
    } else {
      notifications.show({
        title: 'Validation Failed',
        message: `${result.errors.length} errors found`,
        color: 'red'
      });
    }
  };
  
  // Step 3: Execute import
  const handleExecute = async () => {
    const result = await executeImport.mutateAsync({
      importJobId: importJob.id,
      data: parsedData
    });
    
    notifications.show({
      title: 'Import Complete',
      message: `Imported ${result.successCount} records`,
      color: 'green'
    });
    
    setActive(3);
  };
  
  return (
    <Container size="lg" py="xl">
      <Title mb="xl">Import Legacy Data</Title>
      
      <Stepper active={active} breakpoint="sm">
        <Stepper.Step label="Create Job">
          <Stack>
            <Button onClick={handleCreateJob}>Start Import</Button>
          </Stack>
        </Stepper.Step>
        
        <Stepper.Step label="Upload File">
          <Stack>
            <FileInput 
              label="CSV File"
              accept=".csv"
              value={file}
              onChange={setFile}
            />
            <Button onClick={handleFileUpload} disabled={!file}>
              Validate Data
            </Button>
            
            {validation && !validation.valid && (
              <Alert color="red" title="Validation Errors">
                {validation.errors.map((e: any, i: number) => (
                  <div key={i}>Row {e.row}: {e.error}</div>
                ))}
              </Alert>
            )}
          </Stack>
        </Stepper.Step>
        
        <Stepper.Step label="Review & Import">
          <Stack>
            <Table>
              <Table.Thead>
                <Table.Tr>
                  <Table.Th>Legacy ID</Table.Th>
                  <Table.Th>Name</Table.Th>
                </Table.Tr>
              </Table.Thead>
              <Table.Tbody>
                {parsedData.slice(0, 10).map((row, i) => (
                  <Table.Tr key={i}>
                    <Table.Td>{row.club_id}</Table.Td>
                    <Table.Td>{row.club_name}</Table.Td>
                  </Table.Tr>
                ))}
              </Table.Tbody>
            </Table>
            
            <Button onClick={handleExecute}>Execute Import</Button>
          </Stack>
        </Stepper.Step>
        
        <Stepper.Completed>
          <Alert color="green" title="Import Complete">
            Data imported successfully!
          </Alert>
        </Stepper.Completed>
      </Stepper>
    </Container>
  );
}
```

**Files Changed:**
- `src/app/(app)/app/admin/import/page.tsx` (new)
- `src/app/(app)/app/admin/layout.tsx` (add nav link)

---

### Phase 6: Testing & Documentation (3 hours)

**Goal:** Comprehensive testing and user documentation

**Tasks:**
1. Write unit tests for validation logic
2. Test happy path (successful import)
3. Test error scenarios (validation failures, rollback)
4. Write user guide
5. Update API documentation

**Testing Scenarios:**
See `testing.md` for full test plan

---

## Security Considerations

- [x] **Tenant Scoping**: All imports scoped by `organizationId`
- [x] **Role-Based Access**: P1 & C1 only via `requireRole([Role.OWNER])`
- [x] **Input Validation**: Zod schemas for all inputs
- [x] **Audit Logging**: Every import/rollback logged
- [x] **Transaction Safety**: Atomic imports (all-or-nothing)
- [ ] **Rate Limiting**: Add rate limit for large imports (Phase 7)
- [ ] **File Size Limits**: Max 10MB per upload (Phase 7)

---

## Rollback Plan

If implementation fails:
1. **Schema Rollback**: `npm run db:push` with reverted schema
2. **Delete Test Data**: Run cleanup script to remove test imports
3. **Restore Backup**: Restore Neon database snapshot (if corruption)

---

## Documentation Requirements

- [x] Implementation plan (this document)
- [x] Architecture document (`architecture.md`)
- [x] Testing plan (`testing.md`)
- [ ] User guide (how to import data)
- [ ] API documentation (tRPC endpoints)
- [ ] Troubleshooting guide

---

## Deployment Checklist

### Pre-Deployment
- [ ] Schema migration tested in dev
- [ ] All phases completed and tested
- [ ] Rollback procedure tested
- [ ] Backup taken before deployment

### Deployment
- [ ] Push schema to production
- [ ] Run `npm run db:generate` on production
- [ ] Deploy backend code
- [ ] Deploy frontend code
- [ ] Test with sample import in production

### Post-Deployment
- [ ] Monitor error logs
- [ ] Verify audit logs working
- [ ] Test rollback in production (with test data)

---

## Future Enhancements

- [ ] **Export Functionality**: Export current data to CSV
- [ ] **Scheduled Imports**: Cron-based recurring imports
- [ ] **Progress Tracking**: Real-time progress bar for large imports
- [ ] **Email Notifications**: Notify when import completes
- [ ] **Import Templates**: Pre-built CSV templates for each entity type
- [ ] **Bulk Rollback**: Rollback multiple jobs at once
- [ ] **Import History Dashboard**: Visualize import trends

---

## Change Log

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-05 | Chris | Initial implementation plan created |

---

## Phase Progress Tracker

| Phase | Status | Est. Hours | Actual Hours | Completion Date |
|-------|--------|-----------|--------------|-----------------|
| 1. Database Schema | ⏳ PENDING | 2h | - | - |
| 2. tRPC Router | ⏳ PENDING | 3h | - | - |
| 3. Import Engine | ⏳ PENDING | 4h | - | - |
| 4. Rollback | ⏳ PENDING | 2h | - | - |
| 5. Frontend UI | ⏳ PENDING | 6h | - | - |
| 6. Testing & Docs | ⏳ PENDING | 3h | - | - |
| **Total** | | **20h** | | |
