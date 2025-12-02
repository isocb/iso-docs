# Bedrock Module – Overview

**Module:** Bedrock  
**Version:** 3.0 (IsoStack Module 001)  
**Status:** In Development  
**Owner:** Isoblue / IsoStack Platform

---

## What Is Bedrock?

Bedrock is the **reporting and analysis engine** for IsoStack.

It allows tenant organisations to:

- Connect spreadsheet-like data sources (initially Google Sheets, later others)
- Transform and enrich that data without changing the original source
- Define reusable views for end users with grouping, sorting, and simple analysis
- Publish those views either privately (behind login) or publicly (shareable links)

Bedrock’s first priority is to give existing Bedrock 1.0/2.0 clients a **familiar home** on the new IsoStack platform, while establishing a clean, modular foundation for future apps (e.g. LMSPro, TailorAid).

---

## Why Bedrock Exists

Bedrock solves a recurring problem for charities, SMEs, and agencies:

> “We have data in spreadsheets, but we need **reliable views**, basic analysis, and secure sharing, without building a full blown BI stack.”

Key goals:

- Turn messy but familiar spreadsheets into structured, repeatable views
- Avoid “spreadsheet-email hell” when sharing reports
- Provide a **simple, explainable** layer of analysis (totals, averages, counts)
- Make it easy to spin up new reporting projects for different clients

---

## High-Level Concepts

Bedrock revolves around three core ideas:

1. **Projects**  
   A project belongs to a tenant and groups together:
   - One or more data sources (sheets/tables)
   - Optional relationships between those sources
   - Optional virtual columns
   - One or more View Definitions

2. **Three-Layer Data Flow**  
   Bedrock strictly separates:
   - **Layer 1 – Sheet Ingestion (read-only)**
   - **Layer 2 – Relationships & Virtual Columns (data modelling)**
   - **Layer 3 – Display & Analysis (view definitions)**

3. **Views**  
   Each project can have multiple views, each with its own:
   - Display configuration (columns, labels, grouping, analysis)
   - Visibility (public, private, email-filtered)
   - URL and layout

---

## Position in IsoStack

- Bedrock is an **IsoStack module**, not a standalone app.
- IsoStack core provides:
  - Authentication and organisations
  - Tenant-level branding and tooltips
  - Storage (Cloudflare R2) and logging
- Bedrock provides:
  - The data ingestion, transformation, and view-definition engine
  - A module-specific UI for owners, tenant admins, and tenant users

Bedrock can be **switched on or off** per tenant via the owner dashboard and will be the pattern-setter for future modules (e.g. LMSPro).

---
