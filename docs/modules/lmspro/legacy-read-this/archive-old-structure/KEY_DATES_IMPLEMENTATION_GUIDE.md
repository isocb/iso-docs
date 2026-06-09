# Key Dates Implementation Guide

**Status:** Implementation Plan  
**Date:** January 2026  
**Target:** LMSPro Seasonal Workflows Refactor

---

## Overview

This guide provides step-by-step instructions for implementing the Key Dates architecture to replace the current fixed-field seasonal workflow system.

---

## Phase 1: Database Schema Changes

### Step 1.1: Update `schema.prisma`

**File:** `prisma/schema.prisma`

#### Add LMSProKeyDate Model

```prisma
model LMSProKeyDate {
  id              String   @id @default(cuid())
  name            String   // User-friendly name (e.g., "Club Team Registration Window")
  description     String?  @db.Text
  activeFrom      DateTime // Start date/time (00:00 default)
  activeFromTime  String   @default("00:00") // HH:MM format
  activeTo        DateTime // End date/time (23:59 default)
  activeToTime    String   @default("23:59") // HH:MM format
  
  // Relationships
  seasonId        String
  season          LMSProSeason @relation(fields: [seasonId], references: [id], onDelete: Cascade)
  organizationId  String
  organization    Organization @relation(fields: [organizationId], references: [id], onDelete: Cascade)
  
  // Metadata
  createdAt       DateTime @default(now())
  updatedAt       DateTime @updatedAt
  createdBy       String?
  createdByUser   User?    @relation("KeyDateCreatedBy", fields: [createdBy], references: [id])
  
  // Reverse relations
  visibilityRules VisibilityRule[] @relation("KeyDateVisibilityRules")
  
  @@unique([seasonId, name, organizationId])
  @@index([seasonId])
  @@index([organizationId])
  @@map("lmspro_key_dates")
}
```

#### Update VisibilityRule Model

**Find this in schema.prisma and modify:**

```prisma
model VisibilityRule {
  id                  String   @id @default(cuid())
  
  // CHANGE: Only one type now
  type                String   @default("KEY_DATE_RANGE") // Fixed to KEY_DATE_RANGE
  
  // REMOVE: Old absolute date fields
  // activeFrom          DateTime?
  // activeTo            DateTime?
  
  // REMOVE: Old season date field reference
  // seasonDateField     String?
  
  // ADD: Key Date Reference
  keyDateId           String?
  keyDate             LMSProKeyDate? @relation("KeyDateVisibilityRules", fields: [keyDateId], references: [id], onDelete: Cascade)
  
  // KEEP: Offset configuration
  offsetDays          Int?
  offsetFromStart     Boolean  @default(true)
  
  // CHANGE: From exemptRoles (String[]) to exemptRoleIds
  exemptRoleIds       String[] @default([]) // Module role UUIDs
  
  // REMOVE: Old exemptRoles field
  // exemptRoles         String[]
  
  // KEEP: Existing fields
  componentId         String
  component           ComponentDefinition @relation(fields: [componentId], references: [id], onDelete: Cascade)
  organizationId      String
  organization        Organization @relation(fields: [organizationId], references: [id], onDelete: Cascade)
  createdAt           DateTime @default(now())
  updatedAt           DateTime @updatedAt
  
  @@index([componentId])
  @@index([keyDateId])
  @@map("visibility_rules")
}
```

#### Remove Fixed Date Fields from LMSProSeason

**Find LMSProSeason model and DELETE these fields:**

```prisma
model LMSProSeason {
  id              String   @id @default(cuid())
  name            String
  startDate       DateTime
  endDate         DateTime
  isActive        Boolean  @default(false)
  
  // DELETE ALL THESE FIELDS:
  // leagueAgeGroupsConfirms              DateTime?
  // leagueCreateAggsBy                   DateTime?
  // leagueAllocateTeamsToAggs            DateTime?
  // leagueAggsLocked                     DateTime?
  // leagueNewClubRegistrationOpens       DateTime?
  // leagueNewClubRegistrationCloses      DateTime?
  // leagueNewClubCreationDeadline        DateTime?
  // clubArchiveTeams                     DateTime?
  // clubSeasonMembershipConfirmation     DateTime?
  // clubConfirmOfficials                 DateTime?
  // clubTeamArchive                      DateTime?
  // clubConfirmExistingTeams             DateTime?
  // clubConfirmNewTeamAdditions          DateTime?
  // clubConfirmTeamManagers              DateTime?
  // clubFinaliseTeamNamesAgeGroups       DateTime?
  // clubTeamsLocked                      DateTime?
  
  // ADD: Reverse relation to key dates
  keyDates        LMSProKeyDate[]
  
  // KEEP: All other existing fields
  organizationId  String
  organization    Organization @relation(fields: [organizationId], references: [id], onDelete: Cascade)
  // ... etc
}
```

#### Update Organization Model

**Add reverse relation:**

```prisma
model Organization {
  // ... existing fields
  
  // ADD:
  lmsproKeyDates  LMSProKeyDate[]
  
  // ... rest of fields
}
```

#### Update User Model

**Add reverse relation:**

```prisma
model User {
  // ... existing fields
  
  // ADD:
  createdKeyDates LMSProKeyDate[] @relation("KeyDateCreatedBy")
  
  // ... rest of fields
}
```

### Step 1.2: Create Migration

```bash
npx prisma migrate dev --name add_key_dates_system
```

**This will:**
1. Create `lmspro_key_dates` table
2. Add `key_date_id` column to `visibility_rules`
3. Add `exempt_role_ids` column to `visibility_rules`
4. Drop old season date fields from `lmspro_seasons`
5. Drop `exempt_roles` column from `visibility_rules`

### Step 1.3: Data Migration Script

**Create:** `scripts/migrate-season-dates-to-key-dates.ts`

```typescript
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const FIELD_MAPPINGS: Record<string, string> = {
  leagueAgeGroupsConfirms: 'League Confirms Age Groups',
  leagueCreateAggsBy: 'League Creates AGGs Deadline',
  leagueAllocateTeamsToAggs: 'League Allocates Teams to AGGs Deadline',
  leagueAggsLocked: 'League Locks AGGs',
  leagueNewClubRegistrationOpens: 'New Club Registration Opens',
  leagueNewClubRegistrationCloses: 'New Club Registration Closes',
  leagueNewClubCreationDeadline: 'New Club Creation Deadline',
  clubArchiveTeams: 'Club Archives Previous Season Teams',
  clubSeasonMembershipConfirmation: 'Club Season Membership Confirmation',
  clubConfirmOfficials: 'Club Confirms Officials',
  clubTeamArchive: 'Club Archives Teams',
  clubConfirmExistingTeams: 'Club Confirms Existing Teams',
  clubConfirmNewTeamAdditions: 'Club Confirms New Team Additions',
  clubConfirmTeamManagers: 'Club Confirms Team Managers',
  clubFinaliseTeamNamesAgeGroups: 'Club Finalizes Team Names and Age Groups',
  clubTeamsLocked: 'Club Teams Locked',
};

async function migrateSeasonDates() {
  console.log('Starting migration of season dates to key dates...');

  const seasons = await prisma.lMSProSeason.findMany({
    include: { organization: true }
  });

  console.log(`Found ${seasons.length} seasons to migrate`);

  let keyDatesCreated = 0;

  for (const season of seasons) {
    console.log(`\nMigrating season: ${season.name} (${season.id})`);

    for (const [fieldName, keyDateName] of Object.entries(FIELD_MAPPINGS)) {
      const dateValue = (season as any)[fieldName];
      
      if (dateValue && dateValue instanceof Date) {
        try {
          await prisma.lMSProKeyDate.create({
            data: {
              name: keyDateName,
              description: `Migrated from ${fieldName}`,
              activeFrom: dateValue,
              activeFromTime: '00:00',
              activeTo: dateValue,
              activeToTime: '23:59',
              seasonId: season.id,
              organizationId: season.organizationId,
            }
          });
          keyDatesCreated++;
          console.log(`  ✅ Created key date: ${keyDateName}`);
        } catch (error) {
          console.error(`  ❌ Failed to create key date: ${keyDateName}`, error);
        }
      }
    }
  }

  console.log(`\n✅ Migration complete! Created ${keyDatesCreated} key dates`);
}

migrateSeasonDates()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
```

**Run migration:**
```bash
npx ts-node scripts/migrate-season-dates-to-key-dates.ts
```

---

## Phase 2: Backend Changes

### Step 2.1: Create Key Dates Router

**Create:** `src/modules/lmspro/routers/key-dates.router.ts`

```typescript
import { z } from 'zod';
import { router, protectedProcedure, requireRole } from '@/server/trpc';
import { TRPCError } from '@trpc/server';
import { Role } from '@prisma/client';

export const keyDatesRouter = router({
  list: protectedProcedure
    .input(z.object({ seasonId: z.string() }))
    .query(async ({ ctx, input }) => {
      return await ctx.prisma.lMSProKeyDate.findMany({
        where: {
          seasonId: input.seasonId,
          organizationId: ctx.session.user.organizationId,
        },
        orderBy: { activeFrom: 'asc' },
      });
    }),

  create: requireRole([Role.ADMIN, Role.OWNER])
    .input(
      z.object({
        name: z.string().min(1).max(100),
        description: z.string().optional(),
        activeFrom: z.date(),
        activeFromTime: z.string().regex(/^\d{2}:\d{2}$/),
        activeTo: z.date(),
        activeToTime: z.string().regex(/^\d{2}:\d{2}$/),
        seasonId: z.string(),
      })
    )
    .mutation(async ({ ctx, input }) => {
      // Validate: activeTo >= activeFrom
      if (input.activeTo < input.activeFrom) {
        throw new TRPCError({
          code: 'BAD_REQUEST',
          message: 'End date must be after start date',
        });
      }

      const keyDate = await ctx.prisma.lMSProKeyDate.create({
        data: {
          ...input,
          organizationId: ctx.session.user.organizationId,
          createdBy: ctx.session.user.id,
        },
      });

      // Audit log
      await ctx.prisma.auditLog.create({
        data: {
          action: 'KEY_DATE_CREATED',
          entityType: 'LMSProKeyDate',
          entityId: keyDate.id,
          metadata: { name: keyDate.name, seasonId: input.seasonId },
          userId: ctx.session.user.id,
          organizationId: ctx.session.user.organizationId,
        },
      });

      return keyDate;
    }),

  update: requireRole([Role.ADMIN, Role.OWNER])
    .input(
      z.object({
        id: z.string(),
        name: z.string().min(1).max(100),
        description: z.string().optional(),
        activeFrom: z.date(),
        activeFromTime: z.string().regex(/^\d{2}:\d{2}$/),
        activeTo: z.date(),
        activeToTime: z.string().regex(/^\d{2}:\d{2}$/),
      })
    )
    .mutation(async ({ ctx, input }) => {
      // Validate: activeTo >= activeFrom
      if (input.activeTo < input.activeFrom) {
        throw new TRPCError({
          code: 'BAD_REQUEST',
          message: 'End date must be after start date',
        });
      }

      const keyDate = await ctx.prisma.lMSProKeyDate.update({
        where: {
          id: input.id,
          organizationId: ctx.session.user.organizationId,
        },
        data: {
          name: input.name,
          description: input.description,
          activeFrom: input.activeFrom,
          activeFromTime: input.activeFromTime,
          activeTo: input.activeTo,
          activeToTime: input.activeToTime,
        },
      });

      // Audit log
      await ctx.prisma.auditLog.create({
        data: {
          action: 'KEY_DATE_UPDATED',
          entityType: 'LMSProKeyDate',
          entityId: keyDate.id,
          metadata: { name: keyDate.name },
          userId: ctx.session.user.id,
          organizationId: ctx.session.user.organizationId,
        },
      });

      return keyDate;
    }),

  delete: requireRole([Role.ADMIN, Role.OWNER])
    .input(z.object({ id: z.string() }))
    .mutation(async ({ ctx, input }) => {
      // Check if any visibility rules reference this key date
      const rulesCount = await ctx.prisma.visibilityRule.count({
        where: { keyDateId: input.id },
      });

      if (rulesCount > 0) {
        throw new TRPCError({
          code: 'PRECONDITION_FAILED',
          message: `Cannot delete key date: ${rulesCount} visibility rule(s) reference it`,
        });
      }

      const keyDate = await ctx.prisma.lMSProKeyDate.delete({
        where: {
          id: input.id,
          organizationId: ctx.session.user.organizationId,
        },
      });

      // Audit log
      await ctx.prisma.auditLog.create({
        data: {
          action: 'KEY_DATE_DELETED',
          entityType: 'LMSProKeyDate',
          entityId: keyDate.id,
          metadata: { name: keyDate.name },
          userId: ctx.session.user.id,
          organizationId: ctx.session.user.organizationId,
        },
      });

      return keyDate;
    }),
});
```

### Step 2.2: Register Router

**File:** `src/modules/lmspro/routers/index.ts`

```typescript
import { router } from '@/server/trpc';
import { seasonsRouter } from './seasons.router';
import { teamsRouter } from './teams.router';
// ... other imports
import { keyDatesRouter } from './key-dates.router'; // ADD THIS

export const lmsproRouter = router({
  seasons: seasonsRouter,
  teams: teamsRouter,
  // ... other routers
  keyDates: keyDatesRouter, // ADD THIS
});
```

### Step 2.3: Update Visibility Rules Types

**File:** `src/core/features/components/visibility-rules.types.ts`

**REPLACE ENTIRE FILE:**

```typescript
/**
 * Visibility Rules Engine Types
 * Enables time-sensitive component display based on key dates and user roles
 */

/**
 * Rule type for card visibility (simplified to single type)
 */
export type VisibilityRuleType = 'KEY_DATE_RANGE';

/**
 * A single visibility rule for a component
 */
export interface VisibilityRule {
  type: VisibilityRuleType; // Always 'KEY_DATE_RANGE'

  /**
   * Reference to LMSProKeyDate
   */
  keyDateId: string;

  /**
   * Optional offset from key date
   * Positive = shift forward, Negative = shift backward
   */
  offsetDays?: number;

  /**
   * Whether offset applies to start date (true) or end date (false)
   */
  offsetFromStart?: boolean;

  /**
   * Module role UUIDs that are exempt from this rule
   * Users with these roles always see the card
   */
  exemptRoleIds?: string[];

  /**
   * Cascade configuration
   * If true, rule applies to all child components
   */
  cascade?: boolean;
}

/**
 * Context for evaluating visibility rules
 */
export interface RuleEvaluationContext {
  userId: string;
  organizationId: string;
  seasonId?: string;
  now?: Date; // Current time (for testing)
}

/**
 * Result of visibility evaluation
 */
export interface CardVisibilityResult {
  isVisible: boolean;
  reason: string;
  borderColor?: 'green' | 'red' | 'amber';
}

/**
 * Key date data structure (from database)
 */
export interface KeyDate {
  id: string;
  name: string;
  description?: string;
  activeFrom: Date;
  activeFromTime: string;
  activeTo: Date;
  activeToTime: string;
}
```

### Step 2.4: Update Visibility Engine

**File:** `src/core/features/components/visibility-rules.engine.ts`

**REPLACE evaluateCardVisibility function:**

```typescript
import { VisibilityRule, RuleEvaluationContext, CardVisibilityResult, KeyDate } from './visibility-rules.types';
import { prisma } from '@/server/db';
import { addDays } from 'date-fns';

export async function evaluateCardVisibility(
  rule: VisibilityRule,
  context: RuleEvaluationContext
): Promise<CardVisibilityResult> {
  // 1. Check role exemptions (Module Role UUIDs)
  if (rule.exemptRoleIds && rule.exemptRoleIds.length > 0) {
    const userRoles = await getUserModuleRoles(context.userId, context.organizationId);
    const hasExemptRole = userRoles.some((role) => rule.exemptRoleIds!.includes(role.id));

    if (hasExemptRole) {
      return {
        isVisible: true,
        reason: 'Exempt role - always visible',
        borderColor: 'amber',
      };
    }
  }

  // 2. Fetch key date
  const keyDate = await prisma.lMSProKeyDate.findUnique({
    where: { id: rule.keyDateId },
    select: {
      name: true,
      activeFrom: true,
      activeFromTime: true,
      activeTo: true,
      activeToTime: true,
    },
  });

  if (!keyDate) {
    return {
      isVisible: false,
      reason: 'Key date not found',
      borderColor: 'red',
    };
  }

  // 3. Combine date + time
  const startDateTime = combineDateAndTime(keyDate.activeFrom, keyDate.activeFromTime);
  const endDateTime = combineDateAndTime(keyDate.activeTo, keyDate.activeToTime);

  // 4. Apply offset if configured
  let effectiveStart = startDateTime;
  let effectiveEnd = endDateTime;

  if (rule.offsetDays) {
    if (rule.offsetFromStart) {
      effectiveStart = addDays(startDateTime, rule.offsetDays);
    } else {
      effectiveEnd = addDays(endDateTime, rule.offsetDays);
    }
  }

  // 5. Check if current time falls within range
  const now = context.now || new Date();
  const isVisible = now >= effectiveStart && now <= effectiveEnd;

  return {
    isVisible,
    reason: isVisible ? `Active: ${keyDate.name}` : `Outside window: ${keyDate.name}`,
    borderColor: isVisible ? 'green' : 'red',
  };
}

/**
 * Combine date and time strings into a single Date object
 */
function combineDateAndTime(date: Date, time: string): Date {
  const [hours, minutes] = time.split(':').map(Number);
  const combined = new Date(date);
  combined.setHours(hours, minutes, 0, 0);
  return combined;
}

/**
 * Get user's module roles
 */
async function getUserModuleRoles(userId: string, organizationId: string) {
  const userModules = await prisma.userModule.findMany({
    where: {
      userId,
      module: { organizationId },
    },
    include: {
      role: true,
    },
  });

  return userModules.map((um) => um.role);
}
```

### Step 2.5: Update Components Router

**File:** `src/modules/lmspro/routers/components.router.ts`

**Update listForUser procedure:**

```typescript
listForUser: protectedProcedure
  .input(
    z.object({
      seasonId: z.string().optional(),
    })
  )
  .query(async ({ ctx, input }) => {
    const components = await ctx.prisma.componentDefinition.findMany({
      where: { organizationId: ctx.session.user.organizationId },
      include: {
        visibilityRules: {
          include: {
            keyDate: true, // CHANGE: Include key date data
          },
        },
      },
    });

    // Filter by component access
    const accessibleComponents = [];

    for (const component of components) {
      const hasAccess = await hasComponentAccess({
        userId: ctx.session.user.id,
        componentKey: component.componentKey,
        organizationId: ctx.session.user.organizationId,
      });

      if (!hasAccess) continue;

      // Evaluate visibility rules
      let isVisible = true;
      let visibilityReason = 'Always visible';
      let borderColor: 'green' | 'red' | 'amber' | undefined;

      if (component.visibilityRules.length > 0) {
        // All rules must pass for card to be visible
        for (const rule of component.visibilityRules) {
          const result = await evaluateCardVisibility(rule, {
            userId: ctx.session.user.id,
            organizationId: ctx.session.user.organizationId,
            seasonId: input.seasonId,
          });

          if (!result.isVisible) {
            isVisible = false;
            visibilityReason = result.reason;
            borderColor = result.borderColor;
            break;
          }
        }
      }

      // Only return visible components
      if (isVisible) {
        accessibleComponents.push({
          ...component,
          visibility: {
            isVisible,
            reason: visibilityReason,
            borderColor,
          },
        });
      }
    }

    return accessibleComponents;
  }),
```

---

## Phase 3: Frontend Changes

### Step 3.1: Create KeyDatesTab Component

**Create:** `src/app/(app)/app/lmspro/admin/seasons/[seasonId]/_components/KeyDatesTab.tsx`

```typescript
'use client';

import { useState } from 'react';
import { Stack, Group, Title, Button, Modal, TextInput, Textarea, Alert } from '@mantine/core';
import { DatePickerInput, TimeInput } from '@mantine/dates';
import { useForm } from '@mantine/form';
import { DataTable } from 'mantine-datatable';
import { IconPlus, IconTrash, IconAlertCircle } from '@tabler/icons-react';
import { trpc } from '@/lib/trpc/client';
import { notifications } from '@mantine/notifications';
import { format } from 'date-fns';

interface KeyDatesTabProps {
  seasonId: string;
}

export function KeyDatesTab({ seasonId }: KeyDatesTabProps) {
  const [opened, setOpened] = useState(false);
  const [editingKeyDate, setEditingKeyDate] = useState<any>(null);

  const { data: keyDates, isLoading } = trpc.lmspro.keyDates.list.useQuery({ seasonId });
  const createMutation = trpc.lmspro.keyDates.create.useMutation();
  const updateMutation = trpc.lmspro.keyDates.update.useMutation();
  const deleteMutation = trpc.lmspro.keyDates.delete.useMutation();

  const form = useForm({
    initialValues: {
      name: '',
      description: '',
      activeFrom: null,
      activeFromTime: '00:00',
      activeTo: null,
      activeToTime: '23:59',
    },
  });

  const handleOpenEdit = (keyDate: any) => {
    setEditingKeyDate(keyDate);
    form.setValues({
      name: keyDate.name,
      description: keyDate.description || '',
      activeFrom: new Date(keyDate.activeFrom),
      activeFromTime: keyDate.activeFromTime,
      activeTo: new Date(keyDate.activeTo),
      activeToTime: keyDate.activeToTime,
    });
    setOpened(true);
  };

  const handleAddKeyDate = () => {
    setEditingKeyDate(null);
    form.reset();
    setOpened(true);
  };

  const handleSubmit = async (values: any) => {
    try {
      if (editingKeyDate) {
        await updateMutation.mutateAsync({
          id: editingKeyDate.id,
          ...values,
        });
        notifications.show({
          title: 'Success',
          message: 'Key date updated',
          color: 'green',
        });
      } else {
        await createMutation.mutateAsync({
          ...values,
          seasonId,
        });
        notifications.show({
          title: 'Success',
          message: 'Key date created',
          color: 'green',
        });
      }
      setOpened(false);
      trpc.useContext().lmspro.keyDates.list.invalidate();
    } catch (error: any) {
      notifications.show({
        title: 'Error',
        message: error.message,
        color: 'red',
      });
    }
  };

  const handleDelete = async () => {
    if (!editingKeyDate) return;

    try {
      await deleteMutation.mutateAsync({ id: editingKeyDate.id });
      notifications.show({
        title: 'Success',
        message: 'Key date deleted',
        color: 'green',
      });
      setOpened(false);
      trpc.useContext().lmspro.keyDates.list.invalidate();
    } catch (error: any) {
      notifications.show({
        title: 'Error',
        message: error.message,
        color: 'red',
      });
    }
  };

  const formatDateTime = (date: Date, time: string) => {
    return `${format(new Date(date), 'dd MMM yyyy')} ${time}`;
  };

  const getKeyDateStatusBadge = (keyDate: any) => {
    const now = new Date();
    const start = new Date(keyDate.activeFrom);
    const end = new Date(keyDate.activeTo);

    if (now < start) {
      return <Badge color="blue">Upcoming</Badge>;
    } else if (now > end) {
      return <Badge color="gray">Expired</Badge>;
    } else {
      return <Badge color="green">Active</Badge>;
    }
  };

  return (
    <Stack>
      <Group justify="space-between">
        <Title order={3}>Key Dates</Title>
        <Button leftSection={<IconPlus size={16} />} onClick={handleAddKeyDate}>
          Add Key Date
        </Button>
      </Group>

      <DataTable
        records={keyDates || []}
        onRowClick={(keyDate) => handleOpenEdit(keyDate)}
        style={{ cursor: 'pointer' }}
        fetching={isLoading}
        columns={[
          { accessor: 'name', title: 'Key Date Name', width: 250 },
          { accessor: 'description', title: 'Description', width: 300 },
          {
            accessor: 'activeFrom',
            title: 'Start',
            render: (kd) => formatDateTime(kd.activeFrom, kd.activeFromTime),
          },
          {
            accessor: 'activeTo',
            title: 'End',
            render: (kd) => formatDateTime(kd.activeTo, kd.activeToTime),
          },
          {
            accessor: 'status',
            title: 'Status',
            render: (kd) => getKeyDateStatusBadge(kd),
          },
        ]}
        noRecordsText="No key dates configured for this season"
      />

      <Modal
        opened={opened}
        onClose={() => setOpened(false)}
        title={editingKeyDate ? 'Edit Key Date' : 'Add Key Date'}
        size="lg"
      >
        <form onSubmit={form.onSubmit(handleSubmit)}>
          <Stack>
            <TextInput
              label="Key Date Name"
              placeholder="e.g., Club Team Registration Window"
              required
              {...form.getInputProps('name')}
            />

            <Textarea
              label="Description"
              placeholder="Optional: Explain when this date applies"
              {...form.getInputProps('description')}
            />

            <Group grow>
              <DatePickerInput
                label="Start Date"
                placeholder="Select start date"
                required
                {...form.getInputProps('activeFrom')}
              />
              <TimeInput
                label="Start Time"
                {...form.getInputProps('activeFromTime')}
              />
            </Group>

            <Group grow>
              <DatePickerInput
                label="End Date"
                placeholder="Select end date"
                required
                {...form.getInputProps('activeTo')}
              />
              <TimeInput label="End Time" {...form.getInputProps('activeToTime')} />
            </Group>

            {form.values.activeFrom &&
              form.values.activeTo &&
              form.values.activeTo < form.values.activeFrom && (
                <Alert color="red" icon={<IconAlertCircle />}>
                  End date must be after start date
                </Alert>
              )}
          </Stack>

          <Group justify="space-between" mt="md">
            {editingKeyDate && (
              <Button
                color="red"
                variant="outline"
                leftSection={<IconTrash size={16} />}
                onClick={handleDelete}
              >
                Delete
              </Button>
            )}
            <Group ml="auto">
              <Button variant="subtle" onClick={() => setOpened(false)}>
                Cancel
              </Button>
              <Button
                type="submit"
                disabled={
                  !form.values.activeFrom ||
                  !form.values.activeTo ||
                  form.values.activeTo < form.values.activeFrom
                }
              >
                Save
              </Button>
            </Group>
          </Group>
        </form>
      </Modal>
    </Stack>
  );
}
```

### Step 3.2: Add Key Dates Tab to Season Page

**File:** `src/app/(app)/app/lmspro/admin/seasons/[seasonId]/page.tsx`

```typescript
import { KeyDatesTab } from './_components/KeyDatesTab';

// In the Tabs component:
<Tabs defaultValue="details">
  <Tabs.List>
    <Tabs.Tab value="details">Details</Tabs.Tab>
    <Tabs.Tab value="age-groups">Age Groups</Tabs.Tab>
    <Tabs.Tab value="key-dates">Key Dates</Tabs.Tab> {/* ADD THIS */}
  </Tabs.List>

  <Tabs.Panel value="details">
    <SeasonDetailsTab seasonId={seasonId} />
  </Tabs.Panel>

  <Tabs.Panel value="age-groups">
    <AgeGroupsTab seasonId={seasonId} />
  </Tabs.Panel>

  <Tabs.Panel value="key-dates"> {/* ADD THIS */}
    <KeyDatesTab seasonId={seasonId} />
  </Tabs.Panel>
</Tabs>
```

### Step 3.3: Update Visibility Rules Editor

**File:** `src/app/(app)/app/lmspro/admin/seasonal-workflows/components/VisibilityRulesEditor.tsx`

**Replace rule configuration section:**

```typescript
// Remove: Rule type selector (now always KEY_DATE_RANGE)
// Remove: Absolute date pickers
// Remove: Season date field selector

// ADD: Key date selector
<Select
  label="Key Date"
  placeholder="Select a key date from this season"
  required
  data={keyDates.map((kd) => ({
    value: kd.id,
    label: kd.name,
    description: `${formatDate(kd.activeFrom)} - ${formatDate(kd.activeTo)}`,
  }))}
  {...form.getInputProps('keyDateId')}
/>

// KEEP: Offset configuration
<Checkbox label="Apply date offset" {...form.getInputProps('useOffset')} />

{form.values.useOffset && (
  <>
    <NumberInput
      label="Offset Days"
      description="Positive shifts forward, negative shifts backward"
      placeholder="e.g., -7 for one week before"
      {...form.getInputProps('offsetDays')}
    />
    <SegmentedControl
      label="Offset From"
      data={[
        { value: 'start', label: 'Start Date' },
        { value: 'end', label: 'End Date' },
      ]}
      {...form.getInputProps('offsetFromStart')}
    />
  </>
)}

// CHANGE: Exempt roles to module roles
<MultiSelect
  label="Exempt Roles"
  description="Users with these module roles will always see this card"
  data={moduleRoles.map((role) => ({
    value: role.id, // UUID not string
    label: role.name,
  }))}
  {...form.getInputProps('exemptRoleIds')}
/>
```

---

## Phase 4: Testing

### Step 4.1: Unit Tests

**Create:** `src/core/features/components/visibility-rules.engine.test.ts`

```typescript
import { describe, it, expect, beforeEach } from 'vitest';
import { evaluateCardVisibility } from './visibility-rules.engine';
import { prisma } from '@/server/db';

describe('Key Date Visibility Engine', () => {
  let keyDateId: string;
  let userId: string;
  let organizationId: string;

  beforeEach(async () => {
    // Setup test data
    const org = await prisma.organization.create({
      data: { name: 'Test Org' },
    });
    organizationId = org.id;

    const user = await prisma.user.create({
      data: {
        email: 'test@example.com',
        organizationId,
      },
    });
    userId = user.id;

    const season = await prisma.lMSProSeason.create({
      data: {
        name: 'Test Season',
        startDate: new Date('2026-01-01'),
        endDate: new Date('2026-12-31'),
        organizationId,
      },
    });

    const keyDate = await prisma.lMSProKeyDate.create({
      data: {
        name: 'Test Window',
        activeFrom: new Date('2026-06-01'),
        activeFromTime: '00:00',
        activeTo: new Date('2026-06-30'),
        activeToTime: '23:59',
        seasonId: season.id,
        organizationId,
      },
    });
    keyDateId = keyDate.id;
  });

  it('should show card when current time within key date range', async () => {
    const result = await evaluateCardVisibility(
      {
        type: 'KEY_DATE_RANGE',
        keyDateId,
      },
      {
        userId,
        organizationId,
        now: new Date('2026-06-15'), // Within range
      }
    );

    expect(result.isVisible).toBe(true);
    expect(result.borderColor).toBe('green');
  });

  it('should hide card when outside key date range', async () => {
    const result = await evaluateCardVisibility(
      {
        type: 'KEY_DATE_RANGE',
        keyDateId,
      },
      {
        userId,
        organizationId,
        now: new Date('2026-07-15'), // After range
      }
    );

    expect(result.isVisible).toBe(false);
    expect(result.borderColor).toBe('red');
  });

  it('should show card for exempt role regardless of date', async () => {
    // Create module role
    const role = await prisma.moduleRole.create({
      data: {
        name: 'League Admin',
        organizationId,
        moduleKey: 'lmspro',
      },
    });

    // Assign user to role
    await prisma.userModule.create({
      data: {
        userId,
        moduleKey: 'lmspro',
        roleId: role.id,
      },
    });

    const result = await evaluateCardVisibility(
      {
        type: 'KEY_DATE_RANGE',
        keyDateId,
        exemptRoleIds: [role.id],
      },
      {
        userId,
        organizationId,
        now: new Date('2026-12-25'), // Outside range
      }
    );

    expect(result.isVisible).toBe(true);
    expect(result.reason).toContain('Exempt role');
  });

  it('should apply offset correctly', async () => {
    const result = await evaluateCardVisibility(
      {
        type: 'KEY_DATE_RANGE',
        keyDateId,
        offsetDays: -7, // One week before
        offsetFromStart: true,
      },
      {
        userId,
        organizationId,
        now: new Date('2026-05-25'), // One week before June 1
      }
    );

    expect(result.isVisible).toBe(true);
  });
});
```

### Step 4.2: Integration Tests

**Create:** `src/modules/lmspro/routers/key-dates.router.test.ts`

```typescript
import { describe, it, expect } from 'vitest';
import { createCaller } from '@/server/trpc/test-utils';

describe('Key Dates Router', () => {
  it('should create key date', async () => {
    const caller = await createCaller();
    const season = await createTestSeason();

    const result = await caller.lmspro.keyDates.create({
      name: 'Test Window',
      activeFrom: new Date('2026-06-01'),
      activeFromTime: '09:00',
      activeTo: new Date('2026-06-30'),
      activeToTime: '17:00',
      seasonId: season.id,
    });

    expect(result.name).toBe('Test Window');
    expect(result.activeFromTime).toBe('09:00');
  });

  it('should reject end date before start date', async () => {
    const caller = await createCaller();
    const season = await createTestSeason();

    await expect(
      caller.lmspro.keyDates.create({
        name: 'Invalid',
        activeFrom: new Date('2026-06-30'),
        activeTo: new Date('2026-06-01'),
        activeFromTime: '00:00',
        activeToTime: '23:59',
        seasonId: season.id,
      })
    ).rejects.toThrow('End date must be after start date');
  });

  it('should prevent deleting key date referenced by rules', async () => {
    const caller = await createCaller();
    const keyDate = await createTestKeyDate();
    await createTestVisibilityRule({ keyDateId: keyDate.id });

    await expect(
      caller.lmspro.keyDates.delete({ id: keyDate.id })
    ).rejects.toThrow('Cannot delete key date');
  });
});
```

---

## Phase 5: Deployment

### Step 5.1: Pre-Deployment Checklist

- [ ] All TypeScript compilation errors resolved
- [ ] All tests passing (`npm run test`)
- [ ] Migration created and reviewed
- [ ] Data migration script tested on development database
- [ ] Backup of production database created
- [ ] Rollback plan documented

### Step 5.2: Deploy to TechTest

```bash
# 1. Commit all changes
git add -A
git commit -m "FEATURE: Implement Key Dates system for seasonal workflows"

# 2. Push to dev
git push origin dev

# 3. Merge to techtest
git checkout techtest
git merge dev
git push origin techtest

# 4. SSH into Render shell
# 5. Run migration
npm run db:migrate

# 6. Run data migration script
npx ts-node scripts/migrate-season-dates-to-key-dates.ts

# 7. Verify key dates created
npx prisma studio

# 8. Test in browser
```

### Step 5.3: Post-Deployment Verification

- [ ] Key Dates tab appears in Season page
- [ ] Can create/edit/delete key dates
- [ ] Table CRUD pattern working (row click to edit)
- [ ] Delete button in modal footer
- [ ] Visibility rules reference key dates correctly
- [ ] Cards show/hide based on key date ranges
- [ ] Module role exemptions working
- [ ] No console errors
- [ ] Audit logs created for all operations

---

## Phase 6: Cleanup

### Step 6.1: Remove Old Files

```bash
# These files are no longer needed:
rm src/core/features/components/visibility-rules.engine.OLD.ts
rm src/core/features/components/visibility-rules.types.OLD.ts
```

### Step 6.2: Update Documentation

- [ ] Update README.md with Key Dates section
- [ ] Update API documentation
- [ ] Create user guide video
- [ ] Update changelog

---

## Summary

This implementation guide provides:

- ✅ Complete database schema changes
- ✅ Backend router and visibility engine updates
- ✅ Frontend UI components following Table CRUD pattern
- ✅ Comprehensive testing strategy
- ✅ Deployment and verification procedures
- ✅ Rollback plan

**Estimated Implementation Time:** 10-12 days

**Next Step:** Begin Phase 1 - Database Schema Changes
