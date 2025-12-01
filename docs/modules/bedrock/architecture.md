# Bedrock Module Architecture

**Version:** 2.0 (Migrating from Floot-Bedrock)  
**Last Updated:** December 2025  
**Status:** Active Development  
**Source Schema:** Neon PostgreSQL (Floot-Bedrock 1.0)

---

## Overview

Bedrock is an IsoStack module that enables **spreadsheet data aggregation, transformation, and analysis**. It uses the existing Floot-Bedrock database schema with a clarified **three-layer conceptual model**.

**Source of Truth:** `/Users/chris/Documents/GitHub/Floot-Bedrock/helpers/schema.tsx`

---

## Core Design Principle

**"Sheets are raw, Virtual Columns transform, Relationships display"**

This separation ensures:
- **Clean data ingestion** - `project_sheets` + `sheet_columns` store raw data
- **Reusable transformations** - `virtual_columns` transform without modifying source
- **Flexible presentation** - `sheet_relationships` + `project_analysis_config` handle all display/analysis

### Data Source vs Display (CRITICAL)

**Data Source (Layers 1 & 2):**
- What columns exist (`sheet_columns.columnName` = "cust_id")
- What transformations exist (`virtual_columns.sourceName` = "vf_fullName")
- What the data type is (`dataType` = "number", "text", etc.)
- Technical identifiers that never change

**Display (Layer 3 - Display Manager):**
- How columns are labeled (`displayLabel` = "Customer ID", "Full Name")
- Which columns are visible (`isVisible` = true/false)
- What order they appear (`orderIndex` = 1, 2, 3...)
- User-friendly presentation that can change per relationship

**Rule:** Never use `sheet_columns.displayName` or `sheet_columns.visible` for display. Always use `sheet_relationships.fieldDisplayConfig`.

---

## Three-Layer Architecture (Using Existing Tables)

```
┌─────────────────────────────────────────────────────────────┐
│         LAYER 3: RELATIONSHIPS (Display & Analysis)         │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Tables: sheet_relationships                         │  │
│  │          + project_analysis_config                   │  │
│  │          + project_email_filters                     │  │
│  │                                                       │  │
│  │  • Column Labels (via fieldDisplayConfig JSON)       │  │
│  │  • Visibility Flags (displayFields JSON)             │  │
│  │  • FK/PK Linking (pkColumnId, fkColumnId)            │  │
│  │  • Analysis Operations (groupBy, sortOrder, filters) │  │
│  │  • Email Filtering (project_email_filters)           │  │
│  │  • Calculations (operations JSON)                    │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              ↑
                              │ References
                              ↓
┌─────────────────────────────────────────────────────────────┐
│              LAYER 2: VIRTUAL COLUMNS (Transform)            │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Table: virtual_columns                              │  │
│  │                                                       │  │
│  │  • Concatenation (concatColumnIds + separator)       │  │
│  │  • Formula (expression field)                        │  │
│  │  • Regex (regexPattern + regexReplacement)           │  │
│  │  • Currency (currencySymbol, decimals, thousands)    │  │
│  │  • Date Format (dateFormatPreset, dateFormatCustom)  │  │
│  │  • Width (widthMode, widthLength, padChar)           │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              ↑
                              │ Reads from
                              ↓
┌─────────────────────────────────────────────────────────────┐
│              LAYER 1: SHEETS (Raw Data Ingest)               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Tables: project_sheets + sheet_columns + sheet_data│  │
│  │                                                       │  │
│  │  • Public Google Sheets URL (sheetUrl)               │  │
│  │  • Raw column names (sheet_columns.columnName)       │  │
│  │  • Schema detection (schemaHash)                     │  │
│  │  • Data storage (sheet_data.rowData JSON)            │  │
│  │  • Key flags (isPrimaryKey, isForeignKey)            │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## Layer 1: Sheets (Raw Data)

**Tables:** `project_sheets` + `sheet_columns` + `sheet_data`  
**Purpose:** Pure data ingestion from public Google Sheets  

### Critical Rules

❌ **NO per-project Google API** - Use public sheet URLs  
❌ **NO analysis operations at this layer** - Pure data import  
❌ **NO display logic** - Raw column names only  
❌ **NEVER read displayName/visible/isTitle from sheet_columns** - Use Layer 3 fieldDisplayConfig

✅ **DO detect schema changes** - Track column additions/removals via `schemaHash`  
✅ **DO support multiple sources** - `sourceType` supports google_sheets, knack  
✅ **DO mark key columns** - `isPrimaryKey`, `isForeignKey` for Layer 3 relationships  
✅ **DO use metadata flags** - `isPrimaryKey`, `isForeignKey`, `isEmailColumn` inform Layer 3

**Remember:** `sheet_columns` defines WHAT data exists, not HOW it's displayed.

---

### Table: `project_sheets`

**Purpose:** Container for each imported spreadsheet/tab

```typescript
interface ProjectSheets {
  id: number;                      // Primary key
  projectId: number;               // Foreign key to projects
  sheetUrl: string;                // Public Google Sheets URL
  sheetName: string;               // Tab name (e.g., "Customers", "Orders")
  schemaHash: string | null;       // Detects column changes (MD5/SHA hash)
  sourceType: 'google_sheets' | 'knack'; // Data source type
  dataConnectorId: number | null;  // For OAuth sources (future)
  lastSchemaCheck: Date;           // Last validation timestamp
  createdAt: Date;
  updatedAt: Date;
}
```

**Example:**
```json
{
  "id": 1,
  "projectId": 10,
  "sheetUrl": "https://docs.google.com/spreadsheets/d/ABC123/edit",
  "sheetName": "Customer_Orders",
  "schemaHash": "a1b2c3d4e5f6",
  "sourceType": "google_sheets",
  "dataConnectorId": null,
  "lastSchemaCheck": "2025-12-01T10:00:00Z"
}
```

---

### Table: `sheet_columns`

**Purpose:** Physical columns detected from the sheet

```typescript
interface SheetColumns {
  id: number;                      // Primary key
  sheetId: number;                 // Foreign key to project_sheets
  columnIndex: number;             // Position in sheet (0-indexed)
  columnName: string;              // RAW column name from sheet (e.g., "cust_id")
  dataType: string;                // Detected type: text, number, date, boolean
  
  // Metadata flags (used by Layer 3 for relationships/filtering)
  isPrimaryKey: boolean;           // Identifies primary key for relationships
  isForeignKey: boolean;           // Identifies foreign key for relationships
  isEmailColumn: boolean;          // Identifies email columns for filtering
  
  // Legacy display hints (deprecated - use Layer 3 fieldDisplayConfig)
  displayName: string | null;      // Legacy: user-friendly label
  isTitle: boolean;                // Legacy: display priority hint
  isSubtitle: boolean;             // Legacy: display priority hint
  visible: boolean;                // Legacy: visibility hint
  
  createdAt: Date;
  updatedAt: Date;
}
```

**Example:**
```json
[
  {
    "id": 1,
    "sheetId": 1,
    "columnIndex": 0,
    "columnName": "cust_id",
    "dataType": "number",
    "isPrimaryKey": true,
    "isForeignKey": false,
    "isEmailColumn": false,
    "displayName": null,
    "isTitle": false,
    "isSubtitle": false,
    "visible": true
  },
  {
    "id": 2,
    "sheetId": 1,
    "columnIndex": 1,
    "columnName": "first_name",
    "dataType": "text",
    "isPrimaryKey": false,
    "isForeignKey": false,
    "isEmailColumn": false,
    "displayName": null,
    "isTitle": false,
    "isSubtitle": false,
    "visible": true
  },
  {
    "id": 3,
    "sheetId": 1,
    "columnIndex": 2,
    "columnName": "last_name",
    "dataType": "text",
    "isPrimaryKey": false,
    "isForeignKey": false,
    "isEmailColumn": false,
    "displayName": null,
    "isTitle": false,
    "isSubtitle": false,
    "visible": true
  },
  {
    "id": 4,
    "sheetId": 1,
    "columnIndex": 3,
    "columnName": "order_amt",
    "dataType": "number",
    "isPrimaryKey": false,
    "isForeignKey": false,
    "isEmailColumn": false,
    "displayName": null,
    "isTitle": false,
    "isSubtitle": false,
    "visible": true
  }
]
```

---

**⚠️ CRITICAL: Display Fields Are Legacy**

`sheet_columns` contains legacy display fields (`displayName`, `isTitle`, `isSubtitle`, `visible`) that are **deprecated**.

- **sheet_columns** = Data source metadata (what columns exist, their types, PK/FK flags)
- **Layer 3 Display Manager** = Authoritative display configuration (labels, visibility, ordering)

**Rule:** Never use `sheet_columns.displayName` for display purposes. Always read from `sheet_relationships.fieldDisplayConfig` in Layer 3.

These legacy fields may be removed in future versions.

---

### Table: `sheet_data`

**Purpose:** Actual row data stored as JSON

```typescript
interface SheetData {
  id: number;                      // Primary key
  sheetId: number;                 // Foreign key to project_sheets
  rowIndex: number;                // Position in sheet (0-indexed)
  rowData: Json;                   // Actual row data as JSON object
  createdAt: Date;
  updatedAt: Date;
}
```

**Example:**
```json
{
  "id": 1,
  "sheetId": 1,
  "rowIndex": 0,
  "rowData": {
    "cust_id": 1001,
    "first_name": "John",
    "last_name": "Smith",
    "order_amt": 150.00,
    "order_date": "2025-01-15"
  }
}
```

---

### Layer 1 Flow

```
Google Sheet (Public URL)
    ↓
  Fetch Data
    ↓
  Detect Columns → sheet_columns (columnName, dataType, isPrimaryKey)
    ↓
  Generate schemaHash → project_sheets (schemaHash)
    ↓
  Store Rows → sheet_data (rowData JSON)
```

**Key Point:** NO display labels, NO analysis, NO transformations at this layer. Just raw data ingestion.

---

## Layer 2: Virtual Columns (Data Transformation)

**Table:** `virtual_columns`  
**Purpose:** Transform raw sheet data without modifying the source

### Transformation Types

Virtual columns support **six transformation categories**:

1. **Concatenation** - Combine multiple columns
2. **Formula** - Mathematical operations
3. **Regex** - Text extraction/transformation
4. **Currency** - Number formatting with currency symbols
5. **Date** - Date formatting (presets or custom)
6. **Width** - Column width control with padding

---

### Table: `virtual_columns`

**Purpose:** Define data transformations

```typescript
interface VirtualColumns {
  id: number;                      // Primary key
  projectId: number;               // Foreign key to projects
  sheetId: number | null;          // Optional: restrict to specific sheet
  sourceName: string;              // Technical identifier (e.g., "vf_fullName", "calc_totalVAT")
  expression: string | null;       // Formula expression (for FORMULA type)
  dataType: string;                // Output type: text, number, date, boolean
  columnType: string;              // Type: concatenation, formula, regex, currency, date, width
  sourceColumnId: number | null;   // For single-column transformations
  
  // Concatenation fields
  concatColumnIds: number[] | null; // Array of column IDs to concatenate
  concatPrefix: string | null;     // Prefix text (e.g., "Mr. ")
  concatSeparator: string | null;  // Separator (e.g., " ", ", ")
  concatSuffix: string | null;     // Suffix text (e.g., " Jr.")
  
  // Regex fields
  regexPattern: string | null;     // Regex pattern
  regexReplacement: string | null; // Replacement text
  regexFlags: string | null;       // Flags: g, i, m, s
  
  // Currency fields
  currencyMode: string | null;     // Mode: symbol, code, name
  currencySymbol: string | null;   // Symbol: £, $, €
  currencyPosition: string | null; // Position: before, after
  currencyDecimals: number | null; // Decimal places (0-4)
  currencyThousandsSep: string | null; // Thousands separator: ,, ., space
  
  // Date fields
  dateFormatPreset: string | null; // Preset: iso, us, uk, eu
  dateFormatCustom: string | null; // Custom: DD/MM/YYYY, MM-DD-YYYY
  
  // Width fields
  widthMode: string | null;        // Mode: truncate, pad
  widthLength: number | null;      // Target length
  widthPadChar: string | null;     // Padding character (e.g., "0", " ")
  widthPadSide: string | null;     // Side: left, right
  
  createdAt: Date;
  updatedAt: Date;
}
```

---

### Transformation Examples

#### 1. Concatenation: Full Name

```json
{
  "id": 1,
  "sourceName": "vf_fullName",
  "columnType": "concatenation",
  "dataType": "text",
  "concatColumnIds": [2, 3],
  "concatSeparator": " ",
  "concatPrefix": null,
  "concatSuffix": null
}
```

**Input:**
- `first_name` = "John"
- `last_name` = "Smith"

**Output:** "John Smith"

---

#### 2. Formula: Order Total with VAT

```json
{
  "id": 2,
  "sourceName": "calc_totalWithVAT",
  "columnType": "formula",
  "dataType": "number",
  "expression": "{order_amt} * 1.20"
}
```

**Input:**
- `order_amt` = 100.00

**Output:** 120.00

---

#### 3. Regex: Extract Postcode

```json
{
  "id": 3,
  "sourceName": "extract_postcode",
  "columnType": "regex",
  "dataType": "text",
  "sourceColumnId": 10,
  "regexPattern": "[A-Z]{1,2}[0-9]{1,2} [0-9][A-Z]{2}",
  "regexReplacement": null,
  "regexFlags": "i"
}
```

**Input:**
- `address` = "123 Main St, London, SW1A 1AA, UK"

**Output:** "SW1A 1AA"

---

#### 4. Currency: Formatted Price

```json
{
  "id": 4,
  "sourceName": "fmt_priceGBP",
  "columnType": "currency",
  "dataType": "number",
  "sourceColumnId": 4,
  "currencyMode": "symbol",
  "currencySymbol": "£",
  "currencyPosition": "before",
  "currencyDecimals": 2,
  "currencyThousandsSep": ","
}
```

**Input:**
- `order_amt` = 1234.56

**Output (displayed):** "£1,234.56"  
**Output (stored):** 1234.56 (numeric)

---

#### 5. Date: UK Date Format

```json
{
  "id": 5,
  "sourceName": "date_orderUK",
  "columnType": "date",
  "dataType": "date",
  "sourceColumnId": 5,
  "dateFormatPreset": "uk",
  "dateFormatCustom": null
}
```

**Input:**
- `order_date` = "2025-01-15T10:30:00Z"

**Output:** "15/01/2025"

---

#### 6. Width: Padded Customer ID

```json
{
  "id": 6,
  "sourceName": "pad_custId",
  "columnType": "width",
  "dataType": "text",
  "sourceColumnId": 1,
  "widthMode": "pad",
  "widthLength": 8,
  "widthPadChar": "0",
  "widthPadSide": "left"
}
```

**Input:**
- `cust_id` = "123"

**Output:** "00000123"

---

### Layer 2 Key Points

- ✅ Virtual columns **read from Layer 1** (sheet_columns or other virtual_columns)
- ✅ Transformations are **computed on-demand** (no storage overhead)
- ✅ Currency formats **display as text but store as numbers**
- ✅ Virtual columns are **reusable** across multiple relationships (Layer 3)
- ✅ Virtual columns use **sourceName** (technical identifier like "vf_fullName")
- ❌ Virtual columns do **NOT have displayName** - display labels are defined in Layer 3 Display Manager

---

## Layer 3: Relationships (Display & Analysis) - THE DISPLAY MANAGER

**Tables:** `sheet_relationships` + `project_analysis_config` + `project_email_filters`  
**Purpose:** **The Display Manager** - ALL presentation, labeling, and analysis logic lives here

### What Layer 3 Manages

**Column Display:**
- User-friendly labels for sheet columns (e.g., "cust_id" → "Customer ID")
- User-friendly labels for virtual columns (e.g., "vf_fullName" → "Full Name")
- Visibility flags (show/hide columns)
- Display ordering (1, 2, 3...)
- Column formatting hints

**Sheet Relationships:**
- FK/PK linking between sheets
- Master-detail filtering
- Related data display

**Analysis Operations:**
- Filtering (show only rows matching criteria)
- Grouping (aggregate by columns)
- Sorting (order by columns)
- Calculations (sum, count, average)

**User-Specific Views:**
- Email-based filtering (user sees only their data)
- Role-based column visibility

---

### Table: `sheet_relationships`

**Purpose:** Link sheets with FK/PK and configure display

```typescript
interface SheetRelationships {
  id: number;                      // Primary key
  projectId: number;               // Foreign key to projects
  pkSheetId: number;               // Primary key sheet (e.g., "Customers")
  fkSheetId: number;               // Foreign key sheet (e.g., "Orders")
  pkColumnId: number;              // PK column (e.g., "customer_id")
  fkColumnId: number;              // FK column (e.g., "customer_id" in orders)
  fieldDisplayConfig: Json | null; // JSON config for display labels
  displayFields: Json | null;      // JSON array of visible fields
  fkDisplayFields: Json | null;    // JSON array of FK display fields
  masterFilterColumnId: number | null; // Master filter column
  detailFilterColumnId: number | null; // Detail filter column
  createdAt: Date;
  updatedAt: Date;
}
```

---

### `fieldDisplayConfig` Structure (Display Manager Configuration)

This JSON field is **the authoritative source** for how columns are displayed.

**It defines:**
- Display labels for both sheet columns AND virtual columns
- Visibility (show/hide)
- Ordering (1, 2, 3...)
- Source references (where the data comes from)

```json
{
  "columns": [
    {
      "sourceType": "SHEET",
      "sourceColumnId": 1,           // References sheet_columns.id
      "displayLabel": "Customer ID",  // User-friendly label
      "isVisible": true,
      "orderIndex": 1
    },
    {
      "sourceType": "VIRTUAL_COLUMN",
      "virtualColumnId": 1,          // References virtual_columns.id
      "displayLabel": "Full Name",    // User-friendly label (not in virtual_columns!)
      "isVisible": true,
      "orderIndex": 2
    },
    {
      "sourceType": "SHEET",
      "sourceColumnId": 4,
      "displayLabel": "Order Amount",
      "isVisible": true,
      "orderIndex": 3
    }
  ]
}
```

**Critical Understanding:**
- `sheet_columns.columnName` = "cust_id" (data source - never changes)
- `virtual_columns.sourceName` = "vf_fullName" (transformation identifier - never changes)
- `fieldDisplayConfig[].displayLabel` = "Customer ID" / "Full Name" (display label - can change per relationship)

**This allows:**
- Same column displayed with different labels in different views
- Same virtual column displayed with different labels in different relationships
- Complete control over what users see without modifying source data

---

### Example: Customer Orders Relationship

**Scenario:** Link "Customers" sheet (PK) to "Orders" sheet (FK)

```json
{
  "id": 1,
  "projectId": 10,
  "pkSheetId": 1,
  "fkSheetId": 2,
  "pkColumnId": 1,
  "fkColumnId": 5,
  "fieldDisplayConfig": {
    "columns": [
      {
        "sourceType": "SHEET",
        "sourceColumnId": 1,
        "displayLabel": "Customer ID",
        "isVisible": true,
        "orderIndex": 1
      },
      {
        "sourceType": "VIRTUAL_COLUMN",
        "virtualColumnId": 1,
        "displayLabel": "Customer Name",
        "isVisible": true,
        "orderIndex": 2
      },
      {
        "sourceType": "SHEET",
        "sourceColumnId": 6,
        "displayLabel": "Order Total",
        "isVisible": true,
        "orderIndex": 3
      }
    ]
  },
  "displayFields": [1, 2, 6],
  "masterFilterColumnId": 1,
  "detailFilterColumnId": 5
}
```

**Result:**
- When user clicks Customer ID "1001" in Customers sheet
- System filters Orders sheet where `customer_id` = 1001
- Displays columns: Customer ID, Customer Name (virtual column), Order Total

---

### Table: `project_analysis_config`

**Purpose:** Define analysis operations (filter, group, sort, calculate)

```typescript
interface ProjectAnalysisConfig {
  id: number;                      // Primary key
  projectId: number;               // Foreign key to projects
  analysisType: string;            // Type: filtering, grouping, sorting, calculation
  configuration: Json;             // Analysis configuration
  operations: Json | null;         // Operations array
  groupBy: Json | null;            // Group by columns
  sortOrder: Json | null;          // Sort order
  searchConfig: Json | null;       // Search configuration
  currencySymbol: string | null;   // Currency symbol for calculations
  currencyDecimals: number | null; // Currency decimals
  currencyThousandsSep: string | null; // Thousands separator
  createdAt: Date;
  updatedAt: Date;
}
```

---

### Analysis Examples

#### 1. Grouping & Sum Calculation

```json
{
  "id": 1,
  "projectId": 10,
  "analysisType": "calculation",
  "groupBy": ["customer_id"],
  "operations": [
    {
      "type": "sum",
      "column": "order_amt",
      "label": "Total Revenue"
    },
    {
      "type": "count",
      "column": "order_id",
      "label": "Number of Orders"
    },
    {
      "type": "avg",
      "column": "order_amt",
      "label": "Average Order Value"
    }
  ],
  "currencySymbol": "£",
  "currencyDecimals": 2,
  "currencyThousandsSep": ","
}
```

**Result:**
| Customer ID | Total Revenue | Number of Orders | Average Order Value |
|------------|--------------|-----------------|-------------------|
| 1001       | £1,250.00    | 5               | £250.00           |
| 1002       | £3,450.00    | 12              | £287.50           |

---

#### 2. Filtering

```json
{
  "id": 2,
  "projectId": 10,
  "analysisType": "filtering",
  "configuration": {
    "filters": [
      {
        "column": "order_date",
        "operator": ">=",
        "value": "2025-01-01"
      },
      {
        "column": "status",
        "operator": "equals",
        "value": "completed"
      }
    ]
  }
}
```

**Result:** Show only orders from 2025 with status "completed"

---

#### 3. Sorting

```json
{
  "id": 3,
  "projectId": 10,
  "analysisType": "sorting",
  "sortOrder": [
    {
      "column": "order_amt",
      "direction": "desc"
    },
    {
      "column": "order_date",
      "direction": "asc"
    }
  ]
}
```

**Result:** Sort by order amount (highest first), then by date (oldest first)

---

### Table: `project_email_filters`

**Purpose:** Filter data by user's email address

```typescript
interface ProjectEmailFilters {
  id: number;                      // Primary key
  projectId: number;               // Foreign key to projects
  sheetId: number;                 // Sheet to filter
  columnId: number;                // Email column to match against
  filterMode: string;              // Mode: exact, domain, pattern
  createdAt: Date;
  updatedAt: Date;
}
```

---

### Email Filtering Example

```json
{
  "id": 1,
  "projectId": 10,
  "sheetId": 1,
  "columnId": 7,
  "filterMode": "exact"
}
```

**Scenario:**
- User logs in with: `john@example.com`
- System checks `sheet_columns` where `id = 7` → finds `customer_email` column
- Filters `sheet_data` to show only rows where `customer_email = "john@example.com"`

**Result:** User sees only their own orders (data isolation per user)

---

## Authentication Model

### **No Per-Project Google API**

Authentication Model
Primary (today): Public Google Sheets (no OAuth) using service account configuration at platform level.
Secondary (planned): Optional client-level OAuth via data_connectors for private sheets. The dataConnectorId field is present but not required for the public-sheet path.

---

### Table: `oauth_accounts`

**Purpose:** Store OAuth tokens for accessing private sheets (if needed)

```typescript
interface OauthAccounts {
  id: number;                      // Primary key
  userId: number;                  // Foreign key to users
  provider: string;                // Provider: google, microsoft, etc.
  providerAccountId: string;       // Provider's user ID
  accessToken: string;             // OAuth access token
  refreshToken: string | null;     // OAuth refresh token
  expiresAt: Date | null;          // Token expiration
  scopes: string | null;           // OAuth scopes granted
  createdAt: Date;
  updatedAt: Date;
}
```

---

### Access Pattern

**Primary:** Public Google Sheets (no auth required)

```typescript
// Fetch public sheet - NO OAUTH
const publicSheetUrl = "https://docs.google.com/spreadsheets/d/ABC123/edit";
const data = await fetchPublicGoogleSheet(publicSheetUrl);
```

**Secondary:** Client-level OAuth (for private sheets)

```typescript
// User-level OAuth token (if needed)
const token = await prisma.oauthAccounts.findFirst({
  where: { 
    userId: session.user.id,
    provider: 'google'
  }
});

const privateData = await fetchPrivateGoogleSheet(sheetUrl, token.accessToken);
```

---

## Benefits of This Architecture

### 1. **Separation of Concerns**
- Raw data import (`project_sheets` + `sheet_columns`) is independent of display logic
- Virtual fields (`virtual_columns`) are reusable across multiple views
- Relationships (`sheet_relationships`) can reference the same virtual fields

### 2. **Flexibility**
- Same sheet can power multiple views with different configurations
- Add new virtual fields without changing sheets
- Modify display labels without touching data

### 3. **Performance**
- Virtual fields are computed on-demand (no storage overhead)
- Raw sheet data is cached and reused
- Analysis operations are optimized per-relationship

### 4. **Security**
Security
Public sheets require no authentication
Email filtering ensures data isolation per user
Multi-tenant scoping currently via owner_id + client_id (future IsoStack mapping: Organization)
…and maybe in the header you already have:
Source Schema: Neon PostgreSQL (Floot-Bedrock 1.0)
Note: Interfaces below are logical TypeScript shapes used in the app. Actual PostgreSQL columns use snake_case (see Neon schema / Prisma models).
So readers know this is “current DB, later mapped into IsoStack Organization

### 5. **Maintainability**
- Clear layer boundaries
- Easy to debug (check each layer independently)
- Type-safe with Prisma + tRPC

---

## Key Differences from Legacy Floot-Bedrock

| Aspect | Legacy Floot-Bedrock | New IsoStack Bedrock |
|--------|---------------------|---------------------|
| **Google API** | Per-project OAuth | Client-level OAuth (or public sheets) |
| **Sheet Access** | Google Sheets API v4 | Public sheet URLs (primary) |
| **Data Labeling** | Mixed across layers | Exclusively in `sheet_relationships` |
| **Analysis** | Mixed across layers | Exclusively in `project_analysis_config` |
| **Virtual Fields** | Separate `virtual_columns` | Same (preserved) |
| **Backend** | Hono + Kysely | tRPC + Prisma |
| **Frontend** | Radix UI | Mantine 7 |
| **Auth** | Custom JWT | NextAuth.js v5 |
| **Multi-Tenancy** | `clientId` | `organizationId` |
| **Database** | Supabase PostgreSQL | Neon PostgreSQL |

---

## Next Steps

### ✅ Completed
- [x] Document three-layer architecture using ACTUAL tables
- [x] Map Floot-Bedrock schema to conceptual layers
- [x] Document all table structures with TypeScript interfaces
- [x] Provide complete data flow examples

### 🚧 In Progress
- [ ] Update `.github/copilot-instructions.md` with Bedrock architecture section

### 📋 Todo
- [ ] Create Prisma models that map to existing tables
- [ ] Implement tRPC routers (sheets, virtual-columns, relationships, analysis)
- [ ] Build frontend components (Mantine-based UI)
- [ ] Google Sheets integration (public sheet fetching)
- [ ] Virtual field calculator (execute transformation formulas)
- [ ] Relationship engine (apply analysis, filtering, grouping)
- [ ] Email filtering implementation
- [ ] Data migration script (Floot → IsoStack)

---

**Status:** Architecture documentation complete ✅  
**Next Phase:** Update copilot-instructions.md  
**Owner:** Isoblue Engineering Team  
**Last Updated:** December 2025
