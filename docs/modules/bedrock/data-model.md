# Bedrock Data Model (Conceptual)

**Version:** 3.0  
**Status:** Conceptual – For Schema Design

This document describes the **conceptual entities** in Bedrock 3.0. It is not a Prisma schema, but it informs the actual implementation in `bedrock.schema.prisma`.

---

## 1. Tenancy Context

Bedrock always runs inside an IsoStack tenant (organisation).

- `Organisation` (core)  
  - Owns many `BedrockProject` records  
  - Determines branding and high-level permissions
- `User` (core)  
  - Belongs to an `Organisation`  
  - May administer Bedrock projects or view Bedrock views depending on role

Bedrock entities always carry an `organisationId` to support RLS and isolation.

---

## 2. Projects

### 2.1 BedrockProject

Represents one logical reporting project for a tenant.

**Key fields (conceptual):**

- `id`
- `organisationId` (FK to core)
- `name`
- `description`
- `isActive`
- `defaultCurrencySettings`
- `createdAt`, `updatedAt`

**Relations:**

- Has many `Sheets`
- Has many `Relationships`
- Has many `VirtualColumns`
- Has many `ViewDefinitions`

---

## 3. Layer 1 – Ingestion Entities

### 3.1 Sheet

Represents a single imported source (e.g. a Google Sheet tab or another table-like source).

**Key fields:**

- `id`
- `projectId`
- `connectorType` (e.g. `google_sheets`)
- `sourceIdentifier` (e.g. spreadsheet ID + tab name)
- `displayName`
- `schemaHash` (to detect changes)
- `lastSyncedAt`
- `rowCount`, `columnCount`
- Status fields (e.g. `isAccessible`, `lastError`)

### 3.2 SheetColumn

Represents a physical column in a sheet.

**Key fields:**

- `id`
- `sheetId`
- `columnIndex`
- `columnName` (raw)
- `dataType` (text, number, date, boolean, currency)
- Flags:
  - `isPrimaryKey`
  - `isForeignKey`
  - `isEmailColumn`
- Legacy-like display hints (for reference only; not used for v3.0 config)

### 3.3 SheetRow / SheetData

Represents one row of data as a JSON object.

**Key fields:**

- `id`
- `sheetId`
- `rowIndex`
- `rowData` (JSON: key = `columnName`, value = raw value)
- `syncedAt`

---

## 4. Layer 2 – Modelling Entities

### 4.1 Relationship

Represents a master-detail relationship between two sheets inside a project.

**Key fields:**

- `id`
- `projectId`
- `masterSheetId`
- `detailSheetId`
- `masterColumnId`
- `detailColumnId`
- `name`
- Optional “join behaviour” (e.g. what to do when keys are missing)

Relationships are **technical**, not visual. Display of related data is handled per `ViewDefinition`.

### 4.2 VirtualColumn

Defines a computed column.

**Key fields:**

- `id`
- `projectId`
- `sheetId` (optional – may be global to project or tied to one sheet)
- `name` (internal identifier)
- `displayName` (default label)
- `dataType` (output type)
- `kind` (formula, regex, concatenation, currency, date, width)
- configuration payload (expression, sourceColumnIds, etc.)
- `isActive`

Virtual columns are attachable to one or more views in Layer 3.

---

## 5. Layer 3 – View & Analysis Entities

### 5.1 ViewDefinition

Represents one logical “view” that can be rendered.

**Key fields:**

- `id`
- `projectId`
- `name`
- `slug` (URL segment)
- `baseType`:
  - single sheet, or
  - relationship
- `baseSheetId` or `relationshipId`
- `visibility`:
  - `public`
  - `private`
  - `email_filtered`
- `isDefault` (for project-level default view)
- `createdAt`, `updatedAt`

### 5.2 ViewFieldConfig

Defines which fields appear in a view and how.

**Key fields:**

- `id`
- `viewId`
- `sourceType`:
  - `sheet_column`
  - `virtual_column`
- `sourceId` (FK to `SheetColumn` or `VirtualColumn`)
- `displayLabel`
- `orderIndex`
- `visible`
- `alignment` (left, centre, right)
- Flags:
  - `isGroupingKey`
  - `isSortable`
  - `includeInExport`

### 5.3 ViewAnalysisConfig

Defines grouping, sorting, and aggregation rules for a view.

**Key fields:**

- `id`
- `viewId`
- `groupBy` (ordered list of field identifiers)
- `sortOrder` (list of {field, direction})
- `aggregations` (list of operations: sum, count, avg, min, max)
- Optional:
  - `currencySymbol`
  - `decimalPlaces`
  - `thousandsSeparator`

### 5.4 ViewFilterConfig (Optional / Later Phase)

Potential future entity to model reusable filters. For v3.0, filtering may be represented directly as part of the view config JSON.

---

## 6. Visibility & Email Filtering

Visibility is modelled at the `ViewDefinition` level:

- `visibility = public`  
  - Anyone with the URL can see the view.
- `visibility = private`  
  - Only signed-in users of the organisation can see it.
- `visibility = email_filtered`  
  - Same as private, but rows are limited by matching user email to a configured email column.

Email filtering depends on:

- One or more `SheetColumn` entries marked as `isEmailColumn = true`
- View-level configuration that points to the relevant sheet/column

---

## 7. Connectors

Conceptually, connectors are:

- `BedrockConnector`:
  - `organisationId`
  - `type` (google_sheets, knack, etc.)
  - `config` (JSON blob for credentials and options)
  - status fields

For Bedrock 3.0, only the **Google Sheets (public / service account)** scenario is required. Others can be stubbed or added later.

---
