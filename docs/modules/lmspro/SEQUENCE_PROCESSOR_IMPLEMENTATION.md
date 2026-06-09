# Sequence Processor Implementation Plan

**Date:** 3 February 2026  
**Status:** PLANNED  
**Approach:** Option A - Render Cron + DB-backed job runner

## Overview

Implement a robust background job system for processing email sequences (drip campaigns) and future scheduled tasks (Pulse reminders, etc.). Uses Render Cron Jobs with PostgreSQL-based locking for multi-tenant safety.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     Render Cron Job                              │
│                   (Every 1-5 minutes)                            │
│                         │                                        │
│                         ▼                                        │
│              ┌─────────────────────┐                            │
│              │  npm run jobs:tick  │                            │
│              │  (Job Runner Entry) │                            │
│              └──────────┬──────────┘                            │
│                         │                                        │
│         ┌───────────────┼───────────────┐                       │
│         ▼               ▼               ▼                       │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐                │
│  │ Sequence   │  │ Reminders  │  │ Digest     │                │
│  │ Processor  │  │ (Future)   │  │ (Future)   │                │
│  └─────┬──────┘  └────────────┘  └────────────┘                │
│        │                                                         │
│        ▼                                                         │
│  ┌─────────────────────────────────────────┐                    │
│  │           PostgreSQL (Neon)              │                    │
│  │                                          │                    │
│  │  FOR UPDATE SKIP LOCKED                  │                    │
│  │  (prevents double-processing)            │                    │
│  └─────────────────────────────────────────┘                    │
└─────────────────────────────────────────────────────────────────┘
```

## Guarantees Provided

| Guarantee | Implementation |
|-----------|----------------|
| **Idempotency** | Each step execution creates an `Email` record with unique constraint on `(sequenceId, stepId, enrollmentId)` |
| **Dedupe** | `FOR UPDATE SKIP LOCKED` ensures only one worker claims each enrollment |
| **Retries/Backoff** | `retryCount`, `lastError`, `nextRetryAt` fields with exponential backoff (1m, 5m, 15m, 1h) |
| **Exactly-once-ish** | Transaction wraps claim → process → update; rollback on failure |
| **Multi-tenant** | All queries scoped by `organizationId` via sequence relation |

---

## Phase 1: Schema Updates (Migration)

**Goal:** Add retry/backoff fields to SequenceEnrollment

**File:** `prisma/schema.prisma`

**Changes to SequenceEnrollment model:**
```prisma
model SequenceEnrollment {
  // ... existing fields ...
  
  // NEW: Retry/backoff fields
  retryCount    Int       @default(0) @map("retry_count")
  lastError     String?   @map("last_error")
  nextRetryAt   DateTime? @map("next_retry_at")
  lockedAt      DateTime? @map("locked_at")      // For distributed locking
  lockedBy      String?   @map("locked_by")      // Worker ID that claimed it
  
  // ... rest of model ...
}
```

**Migration command:**
```bash
npm run db:migrate:dev -- --name add_sequence_retry_fields
```

**Test:** 
- Verify migration applies cleanly
- Check fields exist in Prisma Studio

---

## Phase 2: Job Runner Entrypoint

**Goal:** Create clean entrypoint that loads env and dispatches to job processors

**File:** `scripts/jobs/run.ts`

```typescript
/**
 * Job Runner Entrypoint
 * 
 * Called by Render Cron: npm run jobs:tick
 * 
 * Responsibilities:
 * 1. Load environment (same as web server)
 * 2. Initialize Prisma client
 * 3. Run all due job processors
 * 4. Log results and exit cleanly
 */

import { PrismaClient } from '@prisma/client';
import { processSequences } from './processors/sequences';
// Future: import { processReminders } from './processors/reminders';

const prisma = new PrismaClient();
const WORKER_ID = `worker-${process.pid}-${Date.now()}`;

async function main() {
  console.log(`[${new Date().toISOString()}] Job tick started (${WORKER_ID})`);
  
  try {
    // Process email sequences
    const sequenceResults = await processSequences(prisma, WORKER_ID);
    console.log(`Sequences: ${sequenceResults.processed} processed, ${sequenceResults.errors} errors`);
    
    // Future job processors here
    // const reminderResults = await processReminders(prisma, WORKER_ID);
    
  } catch (error) {
    console.error('Job tick failed:', error);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
  
  console.log(`[${new Date().toISOString()}] Job tick completed`);
  process.exit(0);
}

main();
```

**Add to package.json:**
```json
{
  "scripts": {
    "jobs:tick": "tsx scripts/jobs/run.ts"
  }
}
```

**Test:**
- Run `npm run jobs:tick` locally
- Should complete with "0 processed" if no due enrollments

---

## Phase 3: Sequence Processor

**Goal:** Process due sequence enrollments with all guarantees

**File:** `scripts/jobs/processors/sequences.ts`

```typescript
/**
 * Sequence Processor
 * 
 * Processes due email sequence enrollments with:
 * - Row-level locking (FOR UPDATE SKIP LOCKED)
 * - Idempotent email creation
 * - Exponential backoff on failure
 * - Transaction safety
 */

import { PrismaClient, Prisma } from '@prisma/client';
import { sendEmail } from '@/lib/email';

const BATCH_SIZE = 50;
const MAX_RETRIES = 4;
const BACKOFF_MINUTES = [1, 5, 15, 60]; // Exponential backoff

interface ProcessResult {
  processed: number;
  errors: number;
}

export async function processSequences(
  prisma: PrismaClient,
  workerId: string
): Promise<ProcessResult> {
  let processed = 0;
  let errors = 0;

  // Claim due enrollments with row locking
  // This raw query uses FOR UPDATE SKIP LOCKED to prevent double-processing
  const dueEnrollments = await prisma.$queryRaw<Array<{ id: string }>>`
    UPDATE "public"."sequence_enrollments"
    SET 
      "locked_at" = NOW(),
      "locked_by" = ${workerId}
    WHERE id IN (
      SELECT id FROM "public"."sequence_enrollments"
      WHERE 
        status = 'active'
        AND next_send_at <= NOW()
        AND (locked_at IS NULL OR locked_at < NOW() - INTERVAL '5 minutes')
        AND (next_retry_at IS NULL OR next_retry_at <= NOW())
        AND retry_count < ${MAX_RETRIES}
      ORDER BY next_send_at ASC
      LIMIT ${BATCH_SIZE}
      FOR UPDATE SKIP LOCKED
    )
    RETURNING id
  `;

  for (const { id } of dueEnrollments) {
    try {
      await processEnrollment(prisma, id);
      processed++;
    } catch (error) {
      errors++;
      await handleFailure(prisma, id, error);
    }
  }

  // Release stale locks (in case of crashes)
  await prisma.$executeRaw`
    UPDATE "public"."sequence_enrollments"
    SET locked_at = NULL, locked_by = NULL
    WHERE locked_at < NOW() - INTERVAL '10 minutes'
  `;

  return { processed, errors };
}

async function processEnrollment(
  prisma: PrismaClient,
  enrollmentId: string
): Promise<void> {
  await prisma.$transaction(async (tx) => {
    // Get enrollment with sequence and current step
    const enrollment = await tx.sequenceEnrollment.findUnique({
      where: { id: enrollmentId },
      include: {
        sequence: {
          include: {
            steps: {
              orderBy: { stepOrder: 'asc' },
            },
          },
        },
      },
    });

    if (!enrollment || enrollment.status !== 'active') {
      return; // Already processed or cancelled
    }

    const currentStep = enrollment.sequence.steps[enrollment.currentStep];
    if (!currentStep) {
      // No more steps - complete the sequence
      await tx.sequenceEnrollment.update({
        where: { id: enrollmentId },
        data: {
          status: 'completed',
          completedAt: new Date(),
          lockedAt: null,
          lockedBy: null,
        },
      });
      return;
    }

    // Check for existing email (idempotency)
    const existingEmail = await tx.email.findFirst({
      where: {
        sequenceId: enrollment.sequenceId,
        metadata: {
          path: ['stepId'],
          equals: currentStep.id,
        },
        recipients: {
          some: { email: enrollment.email },
        },
      },
    });

    if (!existingEmail) {
      // Create and send email
      const email = await tx.email.create({
        data: {
          organizationId: enrollment.sequence.organizationId,
          moduleKey: enrollment.sequence.moduleKey,
          templateId: currentStep.templateId,
          subject: currentStep.subject || 'Sequence Email',
          bodyHtml: currentStep.bodyHtml || '',
          status: 'SENDING',
          sequenceId: enrollment.sequenceId,
          metadata: {
            stepId: currentStep.id,
            enrollmentId: enrollment.id,
          },
          recipients: {
            create: {
              email: enrollment.email,
              name: enrollment.name,
              entityType: enrollment.entityType,
              entityId: enrollment.entityId,
            },
          },
        },
      });

      // Send via Resend
      await sendEmail({
        to: enrollment.email,
        subject: currentStep.subject || 'Sequence Email',
        html: currentStep.bodyHtml || '',
      });

      // Mark as sent
      await tx.email.update({
        where: { id: email.id },
        data: { 
          status: 'SENT',
          sentAt: new Date(),
        },
      });
    }

    // Calculate next step timing
    const nextStepIndex = enrollment.currentStep + 1;
    const nextStep = enrollment.sequence.steps[nextStepIndex];

    if (nextStep) {
      // Schedule next step
      const nextSendAt = new Date();
      nextSendAt.setMinutes(nextSendAt.getMinutes() + (nextStep.delayMinutes || 0));

      await tx.sequenceEnrollment.update({
        where: { id: enrollmentId },
        data: {
          currentStep: nextStepIndex,
          nextSendAt,
          retryCount: 0,
          lastError: null,
          nextRetryAt: null,
          lockedAt: null,
          lockedBy: null,
        },
      });
    } else {
      // Sequence complete
      await tx.sequenceEnrollment.update({
        where: { id: enrollmentId },
        data: {
          status: 'completed',
          completedAt: new Date(),
          lockedAt: null,
          lockedBy: null,
        },
      });
    }
  });
}

async function handleFailure(
  prisma: PrismaClient,
  enrollmentId: string,
  error: unknown
): Promise<void> {
  const errorMessage = error instanceof Error ? error.message : String(error);
  
  const enrollment = await prisma.sequenceEnrollment.findUnique({
    where: { id: enrollmentId },
  });

  if (!enrollment) return;

  const newRetryCount = enrollment.retryCount + 1;
  
  if (newRetryCount >= MAX_RETRIES) {
    // Max retries exceeded - mark as failed
    await prisma.sequenceEnrollment.update({
      where: { id: enrollmentId },
      data: {
        status: 'failed',
        lastError: errorMessage,
        retryCount: newRetryCount,
        lockedAt: null,
        lockedBy: null,
      },
    });
  } else {
    // Schedule retry with exponential backoff
    const backoffMinutes = BACKOFF_MINUTES[newRetryCount - 1] || 60;
    const nextRetryAt = new Date();
    nextRetryAt.setMinutes(nextRetryAt.getMinutes() + backoffMinutes);

    await prisma.sequenceEnrollment.update({
      where: { id: enrollmentId },
      data: {
        retryCount: newRetryCount,
        lastError: errorMessage,
        nextRetryAt,
        lockedAt: null,
        lockedBy: null,
      },
    });
  }

  console.error(`Enrollment ${enrollmentId} failed (attempt ${newRetryCount}): ${errorMessage}`);
}
```

**Test:**
- Create test sequence with steps
- Enroll a test email
- Run `npm run jobs:tick`
- Verify email sent and enrollment advanced

---

## Phase 4: Update render.yaml

**Goal:** Add cron job definition for each environment

**File:** `render.yaml`

**Add after services section:**
```yaml
# Cron Jobs
cronJobs:
  - name: isostack-jobs
    env: node
    region: frankfurt
    schedule: "*/5 * * * *"  # Every 5 minutes
    buildCommand: npm ci && npm run build
    startCommand: npm run jobs:tick
    envVars:
      - key: DATABASE_URL
        fromService:
          type: web
          name: isostack-bedrock
          envVarKey: DATABASE_URL
      - key: RESEND_API_KEY
        fromService:
          type: web
          name: isostack-bedrock
          envVarKey: RESEND_API_KEY
      - key: EMAIL_FROM
        fromService:
          type: web
          name: isostack-bedrock
          envVarKey: EMAIL_FROM
```

**Note:** Each Render environment (TechTest, Staging, Production) will have its own cron job instance pointing to its own database.

**Test:**
- Deploy to TechTest
- Check Render dashboard for cron job execution logs
- Verify jobs run every 5 minutes

---

## Phase 5: Integration Testing

**Goal:** End-to-end test of the full system

**Test Scenarios:**

1. **Happy Path**
   - Create sequence with 3 steps (0min, 1min, 2min delays)
   - Enroll test@example.com
   - Wait for 3 cron ticks
   - Verify: 3 emails sent, enrollment status = 'completed'

2. **Idempotency**
   - Manually run jobs:tick twice in quick succession
   - Verify: Only 1 email per step (no duplicates)

3. **Failure & Retry**
   - Configure invalid RESEND_API_KEY temporarily
   - Run jobs:tick
   - Verify: retryCount incremented, nextRetryAt set
   - Fix API key, wait for retry
   - Verify: Email eventually sent

4. **Concurrent Workers**
   - Run two `npm run jobs:tick` processes simultaneously
   - Verify: Each enrollment processed only once (no race conditions)

5. **Multi-Tenant Isolation**
   - Create sequences in two different organizations
   - Verify: Each org's emails sent correctly, no cross-contamination

---

## Files to Create/Modify

| File | Action | Description |
|------|--------|-------------|
| `prisma/schema.prisma` | MODIFY | Add retry fields to SequenceEnrollment |
| `prisma/migrations/xxx_add_sequence_retry_fields/` | CREATE | Migration for retry fields |
| `scripts/jobs/run.ts` | CREATE | Job runner entrypoint |
| `scripts/jobs/processors/sequences.ts` | CREATE | Sequence processor with guarantees |
| `scripts/jobs/processors/index.ts` | CREATE | Export all processors |
| `package.json` | MODIFY | Add `jobs:tick` script |
| `render.yaml` | MODIFY | Add cronJobs section |

---

## Rollback Plan

If issues arise:

1. **Disable cron job** in Render dashboard (pause, don't delete)
2. **Reset stuck enrollments:**
   ```sql
   UPDATE "public"."sequence_enrollments"
   SET locked_at = NULL, locked_by = NULL, status = 'active'
   WHERE status = 'active' AND locked_at IS NOT NULL;
   ```
3. **Revert migration** if schema issues (create down migration)

---

## Future Extensions

Once this foundation is in place, adding new job types is simple:

1. **Pulse Reminders** - `scripts/jobs/processors/reminders.ts`
2. **Digest Emails** - `scripts/jobs/processors/digests.ts`
3. **Cleanup Tasks** - `scripts/jobs/processors/cleanup.ts`

Each processor follows the same pattern:
- Claim work with `FOR UPDATE SKIP LOCKED`
- Process in transaction
- Handle failures with backoff

---

## Estimated Effort

| Phase | Time | Complexity |
|-------|------|------------|
| Phase 1: Schema | 10 min | Low |
| Phase 2: Entrypoint | 15 min | Low |
| Phase 3: Processor | 45 min | Medium |
| Phase 4: render.yaml | 10 min | Low |
| Phase 5: Testing | 30 min | Medium |
| **Total** | **~2 hours** | |

---

## Approval Checklist

Before implementation:

- [ ] Plan reviewed and approved
- [ ] Confirm TechTest database backup available
- [ ] Confirm Resend API key is valid in all environments
- [ ] Confirm render.yaml changes won't affect existing deployments

---

**Ready to proceed?** Reply with "proceed with Phase 1" to start.
