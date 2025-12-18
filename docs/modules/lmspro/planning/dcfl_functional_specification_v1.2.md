

# Derby Junior Football League

**Functional Specification – Version 1.2 (Draft for Discussion)**<br>(Working draft for discussion and augmentation with DJFL stakeholders)<br><br>
**Date:** 20/10/2025
**Prepared by:** Isoblue Limited: 
 Chris Bampton<br>


---

## 1  Introduction

### 1.1  Background

The Derby Junior Football League (DJFL) has, for more than 15 years, operated a bespoke administration system developed jointly by **Mike Torrance**, one of the League’s founders, supported by **Isoblue Limited**.

The original system was a **FileMaker-based desktop application** designed to handle the full scope of League operations, including **player registration**, club management, and fixture coordination. Following the Football Association’s introduction of national player-registration systems, player registration responsibilities transferred to the FA. The League’s internal system subsequently evolved to focus on **League-level administration** covering club membership, team registration, age-group management, internal communication, and financial administration.

SN & CB have worked to adapt and maintain the system for a number of years, but after more than a decade of incremental adaptation, the platform has become complex, difficult to maintain and fragmented. A new system is required to:

* Simplify management and reduce redundancy.
* Support knowledge transfer and ensure institutional resilience.
* Provide a robust foundation for future consolidation, merger, or structural alignment with other leagues.
* Maintain separation from FA data systems while complementing their functions.

---

## 2  System Overview

The new **League Management System (LMS)** will manage the membership and operations of the League, including:

* League governance and season administration.
* Club membership lifecycle.
* Team registration, grouping, and waiting lists.
* Venue and contact management.
* Referee records (secure and compliant handling).
* Billing integration via Xero.
* Role-based communication and notifications.

The system will not replicate FA functions such as player registration, match results; instead it will complement those systems by managing the League’s organisational, administrative, and communication framework.

---

## 3  Stakeholders and User Roles

The LMS serves multiple tiers of users and external providers, each with defined responsibilities, permissions, and visibility.

### 3.1  League Stakeholders

| Role                      | Description                                                                      | Example Users                                                                 |
| ------------------------- | -------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| **League Committee**      | Provides overall governance and policy direction.                                | Chair, League Secretary, Assistant Secretary, Treasurer, Safeguarding Officer |
| **Age Group Managers**    | Manage team allocation, waiting lists, and AGGs for their assigned age group(s). | Under 7 – Under 13 Managers                                                   |
| **Venue Coordinators**    | Maintain venue profiles and contacts; oversee pitch information.                 | Appointed League Officials                                                    |
| **Referee Coordinator**   | Manages the secure list of registered referees and allocations.                  | Referee Secretary                                                             |
| **System Administrators** | Manage user roles, permissions, parameters, and seasonal configuration.          | League Admins / Technical Support                                             |

---

### 3.2  Club Officials

| Role                           | Description                                                                                                                 |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------- |
| **Club Secretary (Mandatory)** | Primary liaison with the League; responsible for club data, team registrations, and management of team-manager information. |
| **Club Treasurer**             | Manages financial matters between Club and League.                                                                          |
| **Club Welfare Officer**       | Ensures safeguarding compliance within the Club.                                                                            |
| **Additional Roles**           | May include Fixture Secretary, Covid Officer, or other duties defined by League rules.                                      |

> Team and Team-Manager information are controlled by the Club Secretary. Team Managers are not independent system users.

---

### 3.3  Team Managers (Data Entities)

Team Managers are stored as data records managed by Club Officials.
The League requires only: First Name, Last Name, Mobile Number, and Primary Email Address.
This information is used for League notifications (e.g. match-day updates, cancellations) and remains under the Club Secretary’s control.

---

### 3.4  External Providers

| Category                          | Description                                                                                                     |
| --------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| **Venues**                        | External organisations providing pitches and facilities, maintained by Venue Coordinators.                      |
| **Referees**                      | Independent individuals, sometimes minors, whose data are securely held and managed by the Referee Coordinator. |
| **System Administration Support** | Technical providers responsible for infrastructure, upgrades, and security on behalf of the League.             |

---

## 4  Functional Requirements

### 4.1  League and Season Management

* Define and maintain League parameters per season (critical dates, Age Group and AGG capacities, eligibility ranges, Club limits).
* Allow season roll-over while retaining relevant data.
* Maintain audit trails for all data changes (user, date, time).

---

### 4.2  Club Management

* Store and manage Club records: name, short name, FA affiliation number, address, contacts.
* Track key roles: Secretary, Treasurer, Welfare Officer, etc.
* Permit Club Officials to update details and manage Teams.
* Support new-club onboarding with status workflow (Pending → Approved → Active).

---

### 4.3  Team Management

* Enable Clubs to register Teams each season.
* Manage Team lifecycle (Waiting List → Active → Withdrawn / Archived).
* Allow Age Group Managers to approve Teams, reallocate between AGGs, and manage waiting lists.
* Preserve Team status and history across seasons.

---

### 4.4  Age Groups and Groups (AGGs)

* Define Age Groups (U7–U13) and subdivide each into Groups (AGGs).
* Configure capacity per AGG; provide visual allocation and waiting-list views.
* Allow export for use in FA fixture systems.

---

### 4.5  Team Manager Information

* Record minimal data (name, mobile, email).
* Entered and maintained by Club Secretary.
* Team Managers have no direct login rights.

---

### 4.6  Venue Management

* Maintain Venue register including name, address, map link, pitch summary, and three contacts (Primary, Financial, Emergency/Maintenance – each with landline, mobile, email).
* Read-only access for Age Group Managers and Referee Coordinator.

---

### 4.7  Referee Management (Sensitive Data)

* Secure storage of Referee records (name, ID, qualification, encrypted contact and emergency details).
* Restricted visibility to authorised roles only.
* Contact data hidden in UI; accessible only for controlled system functions.
* Encryption and obfuscation for under-18 Referees.

---

### 4.8  Billing and Finance

* Integrate with **Xero** via API.
* Support routine (annual fees), event-based (new Teams, late entries), and ad hoc (fines) billing.
* Allow manual invoice creation with categorisation and status tracking.
* Provide Treasurer and Secretary dashboards.

---

### 4.9  Communication

* Integrated email service with stored metadata.
* Support ad hoc and scheduled messages to dynamic lists (e.g. specific Age Groups, Clubs, Committees).
* CC/BCC options and full logging (sender, recipients, subject, attachments).
* Maintain communication history per Club, Age Group, and Season.

---

### 4.10  System Roles and Permissions

The system uses **Role-Based Access Control (RBAC)** so that each user’s permissions match their League or Club responsibilities. Role permissions are configurable by System Administrators.

#### User Identification and Authentication

Each **individual user** is identified by a **unique username**, which for practical and security reasons is the user’s **email address**.

* Every email address is unique to a single user record.
* Emails sent to that address form part of the system’s security and verification process; therefore **shared or group email addresses are strongly discouraged**.
* An email address will only ever be stored once in the system.
* If a person holds multiple roles (for example at League and Club level), those roles are associated with the same user account.

  * On login, the user sees all data and functions relevant to their roles across League and Club contexts.

This approach ensures accountability, secure role separation, simplified onboarding, and avoids duplicate or shared credentials.

---

### 4.11  Data and Audit

Each table includes: UUID, sequential ID, Created/Updated timestamps, Created by/Updated by fields, and change history for traceability and compliance.

---

## 5  Non-Functional Requirements

| Category             | Requirement                                                                                                                                                                    |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Security**         | Single verified email per user account (enforced uniqueness); shared addresses discouraged; encrypted credential storage; role-based permissions; comprehensive audit logging. |
| **Compliance**       | GDPR-compliant data handling and retention.                                                                                                                                    |
| **Availability**     | ≥ 99 % uptime during active season periods.                                                                                                                                    |
| **Usability**        | Responsive design for desktop and mobile interfaces.                                                                                                                           |
| **Performance**      | Page load under two seconds for core operations.                                                                                                                               |
| **Integration**      | Xero API connection; future readiness for FA integration.                                                                                                                      |
| **Data Portability** | Export to CSV/Excel for Clubs, Teams, and AGGs.                                                                                                                                |

---

## 6  Future Enhancements (To Be Discussed)

* Online payment portal for Clubs.
* Public read-only fixtures calendar.
* Weather alerts and pitch closure integration.
* API for inter-League data sharing.
* League-wide news and announcement dashboard.

---

## 7  Next Steps

1. Review and validate this draft with League stakeholders.
2. Clarify outstanding points: team roll-over logic, billing/Xero mapping, referee data retention.
3. Develop **Technical Specification and UI Wireframes (Phase 2)**.
4. Prepare **Development and Implementation Plan (Phase 3)**.

---

**End of Document**
*Derby Junior Football League – Functional Specification Version 1.2 (Draft for Discussion)*

