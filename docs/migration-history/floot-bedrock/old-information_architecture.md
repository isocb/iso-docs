# Bedrock Information Architecture
**Version:** 2.0  
**Date:** 2025-11-18  
**Status:** Archived
**Author:** Chris (BA/Product Owner)

---

## Overview

This document defines the conceptual model and information architecture for how Bedrock handles data from input through to display. It establishes a clear, linear flow that eliminates confusion and redundancy.  Here Google sheets is used as a metaphor for the data source.  Bedrock is the reporting engine of Isostack and is the first application of IsoStack.  Bedrock is to become the IsoStack Module.  Bedrock functions will be a switchable function in the owner dashboard ie it will be possible for the owner to switch all of the bedrock functionality off in the owner dashboard and enable or disable it per tenant.

- Bedrock 3.0 reuses concepts from Bedrock 2.0 but has a new schema, new flow, and new UI.
- Note: Bedrock 3.0 is inspired by Bedrock 1.0 and Bedrock 2.0, but its data structures, UI, and workflow are redesigned to align with IsoStack’s module architecture. Bedrock 2.0’s database is reference-only.

- Bedrock stores its configuration in its own database schema (e.g. bedrock.*) within IsoStack, enabling clean separation and modularity.


---

## Design Principles

1. **Single Source of Truth** - Each configuration should exist in only one place
2. **Clear Data Flow** Selcet Soure - Input → Transform → Configure → Output
3. **Read vs. Write Separation** - Distinguish between "what we received" vs. "what we're doing with it"
4. **Progressive Disclosure** - Simple first, complexity when needed
5. **Explicit State** - Users should always know what data has been detected and validated

## Project Visibility:

- Public Display → viewable by link, no login
- Private Display → requires IsoStack user permission
- Email filtering - only display data belonging to the email address of looged in user


---

## Information Architecture




### The Data Journey: The 'Project'

A client may have many projects.  A project defines the three layers: Ingest source, Virtual Columns and Display Configuration

```
┌─────────────────────────┐
│  Data Connector         │ (Internal / External source)
└────────┬────────────────┘
         │
         ↓
┌─────────────────┐
│  1. SHEETS TAB  │ (Read-only validation): "Layer 1 – Sheet Ingestion (Raw Data)"
│  "Data Input"   │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│  2. VIRTUAL     │ (Optional transformations) "Layer 2 – Virtual Columns (Data Transformation)"
│     COLUMNS     │
│  "Manipulation" │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│  3. DISPLAY &   │ (Configuration for output) "Layer 3 – Display & Analysis (Visual Definition & Analysis)"
│     ANALYSIS    │
│  "Output Setup" │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│   End User      │
│   Data View     │
└─────────────────┘
```

---

## Tab 1: Layer 1 – Sheet Ingestion (Raw Data)



### Purpose
Show users what data Bedrock has successfully read from their Google Sheets/ Internal Source. This is a **confirmation and validation** screen, not a configuration screen.

### User Mental Model
*"These are the sheets/Tables I've connected. This is what Bedrock found in them. Everything looks correct."*

### Layout Structure



#### Accordion Format
- **Accordion Header (Collapsed State):**
  - Sheet name (e.g., "Customer Data 2024")
  - Status indicator (✓ Synced, ⚠ Warning, ✗ Error)
  - Last sync timestamp
  - Column count badge (e.g., "12 columns detected")
  - Row count (e.g., "1,247 rows")

- **Accordion Content (Expanded State):**
  - **Column List Table** (read-only)
    - Column name (as it appears in Table/Google Sheet)
    - Detected data type (text, number, date, currency, boolean)
    - Sample values (first 3 non-empty values)
    - Nullable indicator (if column has empty cells)
  
  - **Sheet Metadata Section:**
    - Google Sheet ID
    - Sheet tab name
    - Connected date
    - Last updated timestamp
    - Data range (e.g., "A1:Z1247")
  
  - **Sync Controls:**
    - "Refresh Now" button (manual sync)
    - Auto-sync toggle (if enabled)
    - "View in Google Sheets" link

### What Users CANNOT Do Here
- ❌ Rename columns for display
- ❌ Hide/show columns
- ❌ Change data types
- ❌ Reorder columns
- ❌ Delete columns

### What Users CAN Do Here
- ✅ See confirmation that data was read correctly
- ✅ Verify data types are detected accurately
- ✅ Spot errors in source data (wrong formats, missing values)
- ✅ Manually trigger a refresh
- ✅ View sample data to confirm content
- ✅ Jump to Google Sheet to fix source issues

### Design Notes
- **Read-only** - All fields are displayed as text, not inputs
- **Diagnostic** - Help users troubleshoot connection issues
- **Reassurance** - "Your data is here and we understand it"

---

## Tab 2: Layer 2 – Relationships & Virtual Columns (Data Transformation)

### Purpose
- Create relationships between sheets if needed
- Create calculated, transformed, or combined columns based on the incoming data from Sheets. These are **new columns** that don't exist in Google Sheets.

### User Mental Model
*" I have a sheet of products and a sheet of orders and I want to analyse product sales"
*"I need to create a 'Full Name' column by combining First Name and Last Name"* or *"I want to calculate a discount percentage based on two price columns."*

### Section 1: Master-Detail Relationships 

**What It Does:**
**Table & Sheet** in Google spreadsheets there is a filename, and a sheet selector  

- Define which sheet is "master" (e.g., Teams) 
- Define which sheet is "detail" (e.g., Players)
- Specify join column (e.g., Team ID)

**Configuration:**
- Master sheet selection
- Detail sheet selection
- Join column (foreign key)
- Relationship name/label
- Single Sheet Projects have a single Display Row in the Accordion

---

### Section 2: Virtual Columns (Data Transformation)

**Virtual Column Types:**
1. **Formula** - Mathematical operations (+, -, *, /, %)
2. **Regex** - Pattern matching and text extraction
3. **Concatenation** - Combining multiple columns with separators
4. **Currency Formatter** - Format numbers as currency or extract amounts
5. **Date Formatter** - Reformat dates to different display formats

**Configuration Per Virtual Column:**
- Column name/label
- Data type (output type)
- Calculator type (formula, regex, concat, etc.)
- Source columns (which incoming columns to use)
- Calculation rules/formula
- Text alignment (for display)

### Relationship to Other Tabs
- **Input:** Uses columns from Sheets tab
- **Output:** Virtual columns appear in Display & Analysis tab alongside real columns
- Virtual columns can be included/excluded, reordered, and relabeled just like real columns

### Design Notes
- Virtual columns are **computed at query time** (not stored in Google Sheets)
- Changes to source data automatically update virtual columns
- Virtual columns can reference other virtual columns (if dependencies are clear)



---

## “Tab 3: Display & Analysis (View Definitions)"

### **"Display & Analysis"** (renamed from "Relationships")

### Purpose
This is the **single source of truth** for how data appears to end users. It controls:
1. Which sheets have relationships (master-detail)
2. Which columns to show/hide
3. What order columns appear
4. What labels columns display as
5. How data is grouped
6. What analysis/aggregations to show

### User Mental Model
*"This is where I configure what my users will see and how they'll interact with the data."*

---





### Section 3: Display - Grouping, Analysis & Sorting Configuration

#### **Left and Right Panel Column Selector**

**All Available Columns List (Left Panel):**
- Grouped by Sheet Accordion for multiple sheets
- Shows ALL sheet columns per accordion (real grouped by sourse sheet + virtual)
- Source indicator (which sheet or "Virtual")
- Data type badge

**Selected Columns List (Right Panel - This is what users will see):**
 
- List of selected columns
- Drag and Drop order (Crucial driver of Grouping Order, Sort Oder as well as display order)

####**Column Editor Modal**

**Edit Chosen Column Display modal Configuration:**
- **Include/Exclude** - Checkbox (visual on/off toggle)
- **Display Order** - Drag-and-drop position
- **Display Label** - Editable text field (rename for users)
- **Text Alignment** - Left/Center/Right (for tables)
- **Show Field Name** - Toggle (show label or not in master-detail)
- **Grouping** - Set as grouping column (radio button)

**Per-Group Analysis:**
- Select columns to sum
- Select columns to count
- Select columns to average
- Display format for results

**Overall Analysis:**
- Same options as per-group
- Displayed at top level when multiple records exist

**Column Rows have icons idicating:**
- Display Name override
- Sorting
- Grouping
- Analysis 

- Row edited by modal 

**Overview**
- Sheet Columns as Rows in an accordion
- Sheets sections in an accordion
- All ingested columns are available for selection (Left Panel)

- Settings ar all in the column row

**Selection**
- Display Check Box
- Unchecked 'Display' greys the row out
- Drag and drop rows of all rows (selected or not)

**Display Name**
- Default 'display name' is the ingested Column name
- Display name can be overridden

**Grouping:**
- Each column displayed as a row in an accordion with controls
- Select which columns to group by (checkbox)
- Group order (ascending/descending)
- Show group analysis (sum/count/avg)
- Drag and drop order defines group priority

**Sorting:**
- Sort column column (check box)
- Drag and Drop Column order defines sort order
- sort direction
- Multi-level sorting defined by column position

---


### Section 6: Currency & Formatting (Project-Level)

**Currency Settings:**
- Currency symbol (£, $, €, etc.)
- Thousands separator (, or .)
- Decimal places (0-4)

**Date Settings:**
- Default date format
- Timezone handling

---


## User Experience Flow

### New Project Setup Flow

1. **Step 1: Connect a Sheet**
   - User adds Google Sheet URL
   - Bedrock fetches data
   - User sees "Sheets" tab populate with accordion column items
   - User expands accordion to confirm columns detected correctly

2. **Step 2: (Optional) Create Virtual Columns**
   - User switches to "Virtual Columns" tab
   - Creates calculated fields as needed
   - Virtual columns now available for selection

3. **Step 3: Configure Display**
   - User switches to "Display & Analysis" tab 3
   - Defines master-detail relationships (if needed)
   - Selects which columns to show
   - Reorders columns with drag-and-drop
   - Renames columns for end-user clarity
   - Configures grouping and analysis

4. **Step 4: Preview & Publish**
   - User can preview how data will look
   - End users access the configured view
   - End users can Resort the view 
   - End users can filter the view

---

## Benefits of This Architecture

### 1. Eliminates Confusion
- **Before:** "I changed the name in Columns tab but it didn't update in my view!"
- **After:** "Display & Analysis is where I configure output. That's the only place to rename."

### 2. Clear Purpose Per Tab
- **Sheets:** Confirmation (did we read it right?)
- **Virtual Columns:** Transformation (add calculated fields)
- **Display & Analysis:** Configuration (how should it look?)

### 3. Matches User Mental Model
- Linear flow from left to right in tabs
- Each step builds on the previous
- No circular dependencies

### 4. Easier to Build & Maintain
- Single source of truth for display config
- No duplicate code for column management
- Clear database schema (one config location)

### 5. Better for Future Features
- Want to add column filtering? Goes in Display & Analysis
- Want to add conditional formatting? Goes in Display & Analysis
- Want to add permissions per column? Goes in Display & Analysis

---

## Implementation Notes

### Phase 1: Planning & Design (Current Stage)
- Document information architecture (this document)
- Get stakeholder approval
- Define detailed UI mockups
- Map out database migration strategy

### Phase 2: Backend Refactor
- Deprecate `project_columns` display configuration
- Consolidate into `sheet_relationships.fieldDisplayConfig`
- Update all GET endpoints to use new source
- Add migration script for existing data

### Phase 3: Frontend Refactor
- Rename "Relationships" → "Display & Analysis"
- Make "Sheets" tab read-only
- Move column configuration UI to Display & Analysis
- Add prettier checkboxes and drag-and-drop
- Update all components to read from single source

### Phase 4: Testing & Validation
- Test with existing projects
- Verify data migration
- User acceptance testing
- Fix any issues

### Phase 5: Cleanup
- Remove old "Columns" tab editing features
- Update documentation
- Archive deprecated code

---

## Revision History

| Version | Date       | Author | Changes |
|---------|------------|--------|---------|
| 2.0     | 2025-11-18 | Chris  | Complete IA redesign based on user feedback |
| 1.0     | (Previous) | System | Original implementation (AI-generated) |

---

## Approval

- [ ] Product Owner Approved
- [ ] Technical Lead Reviewed
- [ ] UX Design Reviewed
- [ ] Ready for Implementation

---

**Next Steps:** Review this document, provide feedback, then create detailed UI mockups before beginning implementation.