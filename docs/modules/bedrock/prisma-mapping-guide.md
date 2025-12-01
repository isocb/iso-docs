# Bedrock Prisma Mapping Guide

**Version:** 2.0  
**Last Updated:** December 2025  
**Status:** Step 0 - Lock in DB shape (read-only)

---

## Overview

This guide documents how to create Prisma models that map 1:1 to the **existing Floot-Bedrock Neon database**. The database is treated as **read-only** initially—we adapt to it, not mutate it.

**Source of Truth:** `/Users/chris/Documents/GitHub/Floot-Bedrock/helpers/schema.tsx` (Kysely types)

---

## Critical Rules

❌ **DON'T "improve" the schema** - Map 1:1 to existing tables  
❌ **DON'T add new fields** - Use exactly what exists  
❌ **DON'T rename columns** - Use `@map()` to match snake_case  
❌ **DON'T create migrations** - This is read-only mapping phase

✅ **DO use PascalCase model names** - `ProjectSheet`, `VirtualColumn`  
✅ **DO use @@map("table_name")** - Map to actual table names  
✅ **DO use @map("column_name")** - Map to actual column names  
✅ **DO preserve all fields** - Even if they seem redundant/legacy

---

## Database Structure

### Existing Tables (from Floot-Bedrock)

**Multi-Tenant:**
- `clients` - Organization equivalent
- `owners` - Platform level (owns multiple clients)
- `users` - User accounts (snake_case: `client_id`, `owner_id`, `role`)
- `plans` - Subscription plans
- `plan_metrics` - Plan limits/features

**Auth:**
- `user_passwords` - Password hashes
- `sessions` - Active sessions
- `oauth_accounts` - OAuth tokens
- `oauth_states` - OAuth flow states
- `magic_links` - Magic link tokens
- `password_reset_tokens` - Reset tokens
- `user_invitations` - Pending invites
- `login_attempts` - Login audit trail

**Bedrock Layer 1 (Data Source):**
- `projects` - Project container
- `project_sheets` - Sheet metadata (snake_case: `sheet_url`, `sheet_name`, `schema_hash`)
- `sheet_columns` - Physical columns (snake_case: `column_name`, `data_type`, `is_primary_key`)
- `sheet_data` - Row data (JSON)
- `sheet_sync_status` - Sync state

**Bedrock Layer 2 (Transformations):**
- `virtual_columns` - Data transformations (snake_case: `display_name`, `column_type`, `concat_column_ids`)

**Bedrock Layer 3 (Display Manager):**
- `sheet_relationships` - FK/PK linking + display config (snake_case: `pk_sheet_id`, `fk_sheet_id`, `field_display_config`)
- `project_analysis_config` - Analysis operations (snake_case: `analysis_type`, `group_by`, `sort_order`)
- `project_email_filters` - Email filtering (snake_case: `project_id`, `sheet_id`, `column_id`)

**Additional:**
- `data_connectors` - OAuth connectors
- `project_charts` - Chart configurations

---

## Existing IsoStack Schema Issues

### Problem 1: Wrong Models Already Added

The current `schema.prisma` has **incorrect Bedrock models** that don't match the existing database:

```prisma
// ❌ WRONG - These don't exist in Floot-Bedrock DB
model BedrockProject { ... }
model BedrockSheet { ... }
model BedrockVirtualField { ... }
model BedrockRelationship { ... }
model BedrockRelationshipColumn { ... }
model BedrockAnalysisConfig { ... }
model BedrockEmailFilter { ... }
model GoogleOAuthToken { ... }
```

**These need to be REMOVED and replaced with correct mappings.**

### Problem 2: Naming Doesn't Match Database

IsoStack uses PascalCase + "Bedrock" prefix, but database uses snake_case without prefix:
- Database: `project_sheets`, `sheet_columns`, `virtual_columns`
- Current wrong models: `BedrockSheet`, `BedrockVirtualField`

**Solution:** Use `@@map()` to match actual table names.

---

## Correct Prisma Mapping

### Step 1: Remove Existing Bedrock Models

Delete these models from `schema.prisma` (lines ~400-644):
- `BedrockProject`
- `BedrockSheet`
- `BedrockVirtualField`
- `BedrockRelationship`
- `BedrockRelationshipColumn`
- `BedrockAnalysisConfig`
- `BedrockEmailFilter`
- `GoogleOAuthToken`
- Enums: `VirtualFieldType`, `ColumnSourceType`, `EmailFilterMode`

Keep only IsoStack core models (Organization, User, Tooltip, etc.).

---

### Step 2: Add Correct Enums

```prisma
// Enums (match existing database exactly)
enum AnalysisType {
  calculation
  filtering
  grouping
  sorting
}

enum DataSourceType {
  google_sheets
  knack
}

enum BedrockDataType {
  boolean
  currency
  date
  number
  text
}

enum ProjectType {
  related_sheets
  unlinked_spreadsheets
}

enum BedrockUserRole {
  clientAdmin
  clientUser
  ownerAdmin
}

enum ConnectorType {
  airtable
  google_sheets
  knack
}

enum ChartType {
  area
  bar
  line
  pie
}

enum ChartDataSourceType {
  relationship
  sheet
}
```

**Note:** Prefix with "Bedrock" where needed to avoid conflicts with existing enums (e.g., `DataType` already exists).

---

### Step 3: Add Multi-Tenant Models

```prisma
model BedrockClient {
  id          String   @id @default(uuid())
  name        String
  email       String
  description String?
  ownerId     String   @map("owner_id")
  planId      String?  @map("plan_id")
  apiKey      String?  @map("api_key")
  
  // Branding
  logoUrl           String? @map("logo_url")
  logoWidth         Int?    @map("logo_width") @default(100)
  primaryColor      String? @map("primary_color")
  secondaryColor    String? @map("secondary_color")
  showCompanyName   Boolean? @map("show_company_name") @default(true)
  
  // Magic link settings
  magicLinkEnabled            Boolean? @map("magic_link_enabled") @default(false)
  magicLinkExpirationMinutes  Int?     @map("magic_link_expiration_minutes") @default(15)
  
  // Features
  defaultCanExport    Boolean @map("default_can_export") @default(false)
  maxUserImportLimit  Int     @map("max_user_import_limit") @default(100)
  
  // Status
  isActive        Boolean?  @map("is_active") @default(true)
  planExpiryDate  DateTime? @map("plan_expiry_date")
  
  createdAt DateTime? @map("created_at") @default(now())
  updatedAt DateTime? @map("updated_at") @updatedAt
  
  // Relations
  owner       BedrockOwner   @relation(fields: [ownerId], references: [id])
  plan        BedrockPlan?   @relation(fields: [planId], references: [id])
  users       BedrockUser[]
  projects    BedrockProject[]

  @@map("clients")
}

model BedrockOwner {
  id          String   @id @default(uuid())
  name        String
  email       String
  description String?
  isActive    Boolean? @map("is_active") @default(true)
  
  createdAt DateTime? @map("created_at") @default(now())
  updatedAt DateTime? @map("updated_at") @updatedAt
  
  // Relations
  clients BedrockClient[]
  plans   BedrockPlan[]

  @@map("owners")
}

model BedrockUser {
  id        String           @id @default(uuid())
  email     String
  displayName String         @map("display_name")
  clientId  String           @map("client_id")
  ownerId   String           @map("owner_id")
  role      BedrockUserRole  @default(clientUser)
  authMethod String          @map("auth_method") @default("email")
  
  // Email filtering
  emailFilteringEnabled Boolean @map("email_filtering_enabled") @default(false)
  
  // Branding (user-level overrides)
  avatarUrl         String?  @map("avatar_url")
  logoUrl           String?  @map("logo_url")
  logoWidth         Int?     @map("logo_width") @default(100)
  primaryColor      String?  @map("primary_color")
  secondaryColor    String?  @map("secondary_color")
  showCompanyName   Boolean? @map("show_company_name") @default(true)
  
  // Permissions
  canExport Boolean? @map("can_export")
  
  // Feature flags
  featureFlagLevel String? @map("feature_flag_level")
  selectedClientId String? @map("selected_client_id")
  
  // Password
  passwordLastSetAt  DateTime? @map("password_last_set_at")
  passwordSetMethod  String?   @map("password_set_method")
  
  // Status
  isActive    Boolean?  @map("is_active") @default(true)
  lastLoginAt DateTime? @map("last_login_at")
  createdBy   String?   @map("created_by")
  
  createdAt DateTime? @map("created_at") @default(now())
  updatedAt DateTime? @map("updated_at") @updatedAt
  
  // Relations
  client BedrockClient @relation(fields: [clientId], references: [id])

  @@map("users")
}
```

**Note:** Auth models (sessions, passwords, oauth_accounts) can be added later if needed.

---

### Step 4: Add Layer 1 Models (Data Source)

```prisma
model BedrockProject {
  id             String       @id @default(uuid())
  name           String
  description    String?
  clientId       String       @map("client_id")
  projectType    ProjectType? @map("project_type") @default(related_sheets)
  emailFiltering Boolean      @map("email_filtering") @default(false)
  isActive       Boolean?     @map("is_active") @default(true)
  
  createdAt DateTime? @map("created_at") @default(now())
  updatedAt DateTime? @map("updated_at") @updatedAt
  
  // Relations
  client          BedrockClient                 @relation(fields: [clientId], references: [id])
  sheets          BedrockProjectSheet[]
  virtualColumns  BedrockVirtualColumn[]
  relationships   BedrockSheetRelationship[]
  analysisConfigs BedrockProjectAnalysisConfig[]
  emailFilters    BedrockProjectEmailFilter[]

  @@map("projects")
}

model BedrockProjectSheet {
  id                   String         @id @default(uuid())
  projectId            String         @map("project_id")
  sheetUrl             String         @map("sheet_url")
  sheetName            String         @map("sheet_name")
  displayName          String?        @map("display_name")
  sheetRange           String?        @map("sheet_range")
  sourceType           DataSourceType @map("source_type") @default(google_sheets)
  dataConnectorId      String?        @map("data_connector_id")
  schemaHash           String?        @map("schema_hash")
  orderIndex           Int?           @map("order_index") @default(0)
  
  // Knack-specific fields
  knackAppId           String? @map("knack_app_id")
  knackObjectKey       String? @map("knack_object_key")
  knackObjectName      String? @map("knack_object_name")
  knackApiKeyEncrypted String? @map("knack_api_key_encrypted")
  
  // Status
  isAccessible      Boolean?  @map("is_accessible") @default(true)
  lastSchemaCheck   DateTime? @map("last_schema_check")
  lastDataAccessAt  DateTime? @map("last_data_access_at")
  
  createdAt DateTime? @map("created_at") @default(now())
  updatedAt DateTime? @map("updated_at") @updatedAt
  
  // Relations
  project         BedrockProject              @relation(fields: [projectId], references: [id])
  columns         BedrockSheetColumn[]
  data            BedrockSheetData[]
  virtualColumns  BedrockVirtualColumn[]
  pkRelationships BedrockSheetRelationship[]  @relation("PKSheet")
  fkRelationships BedrockSheetRelationship[]  @relation("FKSheet")

  @@map("project_sheets")
}

model BedrockSheetColumn {
  id            String          @id @default(uuid())
  sheetId       String          @map("sheet_id")
  columnIndex   Int             @map("column_index")
  columnName    String          @map("column_name")
  dataType      BedrockDataType @map("data_type")
  
  // Legacy display fields (deprecated - use Layer 3 fieldDisplayConfig)
  displayName   String?  @map("display_name")
  displayOrder  Int?     @map("display_order") @default(0)
  visible       Boolean  @default(true)
  isTitle       Boolean? @map("is_title") @default(false)
  isSubtitle    Boolean? @map("is_subtitle") @default(false)
  titleLabel    String?  @map("title_label")
  subtitleLabel String?  @map("subtitle_label")
  technicalName String?  @map("technical_name")
  
  // Metadata flags (used by Layer 3)
  isPrimaryKey  Boolean? @map("is_primary_key") @default(false)
  isForeignKey  Boolean? @map("is_foreign_key") @default(false)
  isEmailColumn Boolean  @map("is_email_column") @default(false)
  
  isActive Boolean? @map("is_active") @default(true)
  
  createdAt DateTime? @map("created_at") @default(now())
  updatedAt DateTime? @map("updated_at") @updatedAt
  
  // Relations
  sheet BedrockProjectSheet @relation(fields: [sheetId], references: [id])

  @@map("sheet_columns")
}

model BedrockSheetData {
  id       String @id @default(uuid())
  sheetId  String @map("sheet_id")
  rowIndex Int    @map("row_index")
  rowData  Json   @map("row_data")
  
  createdAt DateTime? @map("created_at") @default(now())
  updatedAt DateTime? @map("updated_at") @updatedAt
  
  // Relations
  sheet BedrockProjectSheet @relation(fields: [sheetId], references: [id])

  @@map("sheet_data")
}
```

---

### Step 5: Add Layer 2 Model (Transformations)

```prisma
model BedrockVirtualColumn {
  id             String          @id @default(uuid())
  projectId      String          @map("project_id")
  sheetId        String          @map("sheet_id")
  displayName    String          @map("display_name") // NOTE: To be renamed to sourceName in future
  expression     String?
  dataType       BedrockDataType @map("data_type")
  columnType     String?         @map("column_type")
  sourceColumnId String?         @map("source_column_id")
  
  // Display (legacy - to be removed)
  displayOrder Int?     @map("display_order")
  visible      Boolean? @default(true)
  textAlign    String?  @map("text_align")
  
  // Concatenation
  concatColumnIds Json?   @map("concat_column_ids") // Array of column IDs
  concatPrefix    String? @map("concat_prefix")
  concatSeparator String? @map("concat_separator")
  concatSuffix    String? @map("concat_suffix")
  
  // Regex
  regexPattern     String? @map("regex_pattern")
  regexReplacement String? @map("regex_replacement")
  regexFlags       String? @map("regex_flags")
  
  // Currency
  currencyMode         String? @map("currency_mode")
  currencySymbol       String? @map("currency_symbol")
  currencyPosition     String? @map("currency_position")
  currencyDecimals     Int?    @map("currency_decimals")
  currencyThousandsSep String? @map("currency_thousands_sep")
  
  // Date
  dateFormatPreset String? @map("date_format_preset")
  dateFormatCustom String? @map("date_format_custom")
  
  // Width
  widthMode    String? @map("width_mode")
  widthLength  Int?    @map("width_length")
  widthPadChar String? @map("width_pad_char")
  widthPadSide String? @map("width_pad_side")
  
  // Status
  isActive     Boolean? @map("is_active") @default(true)
  errorMessage String?  @map("error_message")
  
  createdAt DateTime? @map("created_at") @default(now())
  updatedAt DateTime? @map("updated_at") @updatedAt
  
  // Relations
  project BedrockProject      @relation(fields: [projectId], references: [id])
  sheet   BedrockProjectSheet @relation(fields: [sheetId], references: [id])

  @@map("virtual_columns")
}
```

---

### Step 6: Add Layer 3 Models (Display Manager)

```prisma
model BedrockSheetRelationship {
  id                   String  @id @default(uuid())
  projectId            String  @map("project_id")
  pkSheetId            String  @map("pk_sheet_id")
  fkSheetId            String  @map("fk_sheet_id")
  pkColumnId           String  @map("pk_column_id")
  fkColumnId           String  @map("fk_column_id")
  name                 String?
  description          String?
  
  // Display configuration (Layer 3 - Display Manager)
  fieldDisplayConfig   Json?   @map("field_display_config")
  displayFields        Json?   @map("display_fields")
  fkDisplayFields      String? @map("fk_display_fields")
  
  // Filtering
  masterFilterColumnId String? @map("master_filter_column_id")
  detailFilterColumnId String? @map("detail_filter_column_id")
  
  // Cascade behavior
  cascadeAction String? @map("cascade_action") @default("restrict")
  
  createdAt DateTime? @map("created_at") @default(now())
  updatedAt DateTime? @map("updated_at") @updatedAt
  
  // Relations
  project BedrockProject      @relation(fields: [projectId], references: [id])
  pkSheet BedrockProjectSheet @relation("PKSheet", fields: [pkSheetId], references: [id])
  fkSheet BedrockProjectSheet @relation("FKSheet", fields: [fkSheetId], references: [id])

  @@map("sheet_relationships")
}

model BedrockProjectAnalysisConfig {
  id                         String       @id @default(uuid())
  projectId                  String       @map("project_id")
  analysisType               AnalysisType @map("analysis_type")
  configuration              Json         @default("{}")
  operations                 Json?
  groupBy                    Json?        @map("group_by")
  sortOrder                  Json?        @map("sort_order")
  searchConfig               Json?        @map("search_config")
  
  // Currency formatting for calculations
  currencySymbol             String? @map("currency_symbol")
  currencyDecimalPlaces      Int?    @map("currency_decimal_places") @default(2)
  currencyThousandsSeparator String? @map("currency_thousands_separator") @default(",")
  
  isActive Boolean? @map("is_active") @default(true)
  
  createdAt DateTime? @map("created_at") @default(now())
  updatedAt DateTime? @map("updated_at") @updatedAt
  
  // Relations
  project BedrockProject @relation(fields: [projectId], references: [id])

  @@map("project_analysis_config")
}

model BedrockProjectEmailFilter {
  id        String   @id @default(uuid())
  projectId String   @map("project_id")
  sheetId   String   @map("sheet_id")
  columnId  String   @map("column_id")
  isActive  Boolean? @map("is_active") @default(true)
  
  createdAt DateTime? @map("created_at") @default(now())
  updatedAt DateTime? @map("updated_at") @updatedAt
  
  // Relations
  project BedrockProject @relation(fields: [projectId], references: [id])

  @@map("project_email_filters")
}
```

---

## Expected Result

After applying these changes, you should be able to:

```typescript
// Query existing Bedrock database (read-only)
const sheets = await prisma.bedrockProjectSheet.findMany({
  where: { projectId: 'some-uuid' },
  include: {
    columns: true,
    virtualColumns: true,
    data: { take: 10 }
  }
});

// Query virtual columns
const virtualCols = await prisma.bedrockVirtualColumn.findMany({
  where: { 
    projectId: 'some-uuid',
    columnType: 'concatenation'
  }
});

// Query relationships (Layer 3 - Display Manager)
const relationships = await prisma.bedrockSheetRelationship.findMany({
  where: { projectId: 'some-uuid' },
  include: {
    pkSheet: { include: { columns: true } },
    fkSheet: { include: { columns: true } }
  }
});

// Query analysis config
const analysisConfig = await prisma.bedrockProjectAnalysisConfig.findMany({
  where: { projectId: 'some-uuid' }
});
```

**NO migrations needed** - this is pure TypeScript type mapping to existing database.

---

## Validation Checklist

✅ All table names match via `@@map("table_name")`  
✅ All column names match via `@map("column_name")`  
✅ All enums match existing database values  
✅ All relations match existing foreign keys  
✅ No new fields added  
✅ No migrations generated  
✅ PascalCase model names (BedrockProjectSheet)  
✅ snake_case table/column names (project_sheets, sheet_name)

---

## Next Steps

1. ✅ Remove incorrect Bedrock models from `schema.prisma`
2. ✅ Add correct Bedrock models with proper `@@map()` and `@map()`
3. ✅ Run `npx prisma generate` to create TypeScript types
4. ✅ Test queries against existing Neon database
5. ⏸ Wait for approval before any schema mutations

---

**Status:** Ready for implementation  
**Phase:** Step 0 - Lock in DB shape (read-only)  
**Next Phase:** Create tRPC routers using these models
