# LMSPro Marketing Site Brief

**For:** Gamma.io / External Marketing Platform  
**Created:** 17 February 2026  
**Product:** LMSPro - League Management System Pro

---

## Project Overview

LMSPro is a comprehensive SaaS platform designed specifically for **youth football league administrators**. It streamlines season management, club registration, team allocation, communications, and administrative tasks that currently rely on spreadsheets, emails, and manual processes.

### Target Audience

**Primary:** Youth football league secretaries and administrators
- Typically 40-65 years old
- Volunteer or part-time roles
- Managing leagues with 20-200+ teams
- Currently using Excel, paper forms, email chains
- Pain points: time-consuming admin, chasing clubs for data, manual communications

**Secondary:** Club secretaries who interact with league systems
- Need to register teams, submit information
- Want easy self-service portal

---

## Brand Guidelines

### Voice & Tone
- **Professional** but approachable
- **Reassuring** - we understand their challenges
- **Clear** - no jargon, simple explanations
- **Supportive** - we're here to help

### Key Messages
1. "League Management Made Simple"
2. "Reclaim your weekends"
3. "Focus on football, not paperwork"
4. "Everything in one place"
5. "Built for grassroots football"

### Color Palette
- **Primary:** Deep Blue (#1E3A5F) - Trust, professionalism
- **Secondary:** Grass Green (#4CAF50) - Football, growth
- **Accent:** Vibrant Orange (#FF6B35) - Energy, CTAs
- **Neutrals:** White, Light Grey (#F5F5F5), Dark Grey (#333)

### Typography
- **Headlines:** Bold, modern sans-serif
- **Body:** Clean, readable sans-serif
- **Minimum font size:** 16px for body text (older demographic)

---

## Site Structure

```
Homepage           → /
Features           → /features
Pricing            → /pricing
About              → /about
Contact            → /contact
Get Started        → /register (links to IsoStack platform)
```

---

## Content Documents

| Document | Description |
|----------|-------------|
| `01-HOMEPAGE.md` | Main landing page content |
| `02-FEATURES.md` | Detailed feature showcase |
| `03-PRICING.md` | Pricing tiers and comparison |
| `04-ABOUT.md` | Company story and mission |
| `05-CONTACT.md` | Contact information and FAQ |
| `06-TESTIMONIALS.md` | Customer quotes (placeholders) |

---

## Technical Notes for Gamma.io

### Call-to-Action Links
All "Get Started", "Register Now", "Start Free" buttons should link to:
```
https://app.isostack.co.uk/lmspro/register
```

### Contact Form
Contact form submissions should email:
```
hello@lmspro.app
```

### Footer Links
- Privacy Policy: `https://isostack.co.uk/privacy`
- Terms of Service: `https://isostack.co.uk/terms`
- "Powered by IsoStack": `https://isostack.co.uk`

### Social Links (if applicable)
- Twitter/X: @lmspro (placeholder)
- LinkedIn: /company/lmspro (placeholder)

---

## Design Requirements

1. **Mobile-first** - Many users will view on phones
2. **Large touch targets** - Buttons minimum 44px height
3. **High contrast** - Clear text readability
4. **Fast loading** - Optimise images, minimal animations
5. **Professional imagery** - Football pitches, grassroots football, admin work

### Suggested Imagery
- Youth football matches (diverse, inclusive)
- Volunteer administrators at laptops
- Football pitches from above
- Parents on sidelines
- Trophy presentations, team photos
- Abstract football patterns/icons

---

# LMSPro Marketing Site - Complete Page Structure

**Purpose:** Quick reference for site structure and page relationships

---

## Site Map

```
lmspro.app (or marketing subdomain)
│
├── / (Homepage)
│   ├── Hero Section
│   ├── Social Proof Stats
│   ├── Problem Statement
│   ├── Solution Overview (Feature Cards)
│   ├── How It Works (3 Steps)
│   ├── Testimonials
│   ├── Pricing Preview
│   ├── Trust Section
│   └── Final CTA
│
├── /features
│   ├── Hero
│   ├── Season Management
│   ├── Club Registration
│   ├── Team Management
│   ├── Age Groups & Divisions
│   ├── Communications
│   ├── Dashboard & Reporting
│   ├── Coming Soon
│   ├── Comparison Table
│   └── Final CTA
│
├── /pricing
│   ├── Hero
│   ├── Pricing Cards (Starter, Professional, Enterprise)
│   ├── Feature Comparison Table
│   ├── FAQ Section
│   ├── Trust Badges
│   ├── Testimonial
│   └── Final CTA
│
├── /about
│   ├── Hero
│   ├── Our Story
│   ├── Mission Statement
│   ├── Values (4 cards)
│   ├── Team Section (optional)
│   ├── Social Proof (stats, logos)
│   └── Final CTA
│
├── /contact
│   ├── Hero
│   ├── Contact Methods (3 cards)
│   ├── Contact Form
│   ├── FAQ Section
│   ├── Demo Booking
│   └── Final CTA
│
└── /register → Redirects to app.isostack.co.uk/lmspro/register
```

---

## Document Index

| # | Document | Content | Pages Used |
|---|----------|---------|------------|
| 00 | `00-BRIEF.md` | Project overview, audience, brand guidelines | All |
| 01 | `01-HOMEPAGE.md` | Full homepage content | `/` |
| 02 | `02-FEATURES.md` | Detailed feature descriptions | `/features` |
| 03 | `03-PRICING.md` | Pricing tiers, comparison, FAQ | `/pricing` |
| 04 | `04-ABOUT.md` | Company story, mission, team | `/about` |
| 05 | `05-CONTACT.md` | Contact info, form, FAQ | `/contact` |
| 06 | `06-TESTIMONIALS.md` | Customer quotes, case study | All pages |
| 07 | `07-DESIGN-ASSETS.md` | Visual design specifications | Design |

---

## Key Messages Summary

### Primary Tagline
**"League Management Made Simple"**

### Supporting Messages
1. Save time – reduce admin hours by 75%
2. Reduce stress – no more spreadsheet chaos
3. Focus on football – not paperwork
4. Free to start – no credit card required
5. UK-built – understands grassroots football

---

## Call-to-Action Hierarchy

### Primary CTA
- **Text:** "Start Free Today" or "Get Started Free"
- **Link:** `https://app.isostack.co.uk/lmspro/register`
- **Style:** Orange button (`#FF6B35`)

### Secondary CTAs
- "See How It Works" → `/features`
- "Compare Plans" → `/pricing`
- "Contact Us" → `/contact`
- "Book a Demo" → `/contact?demo=true`

---

## Technical Integration Points

### External Links (to IsoStack Platform)
| Link | Destination |
|------|-------------|
| Get Started / Register | `https://app.isostack.co.uk/lmspro/register` |
| Login (if shown) | `https://app.isostack.co.uk/auth/signin` |
| Privacy Policy | `https://isostack.co.uk/privacy` |
| Terms of Service | `https://isostack.co.uk/terms` |

### Contact Form Submissions
- Email to: `hello@lmspro.app`
- Consider: Form service like Formspree, Netlify Forms, or similar

### Analytics
- Google Analytics 4 recommended
- Track: Page views, CTA clicks, form submissions
- Goals: Registration starts, demo bookings

---

## SEO Checklist

### Each Page Must Have:
- [ ] Unique title tag (60 chars max)
- [ ] Meta description (155 chars max)
- [ ] H1 heading
- [ ] Logical heading hierarchy (H1 → H2 → H3)
- [ ] Image alt text
- [ ] Internal links to other pages
- [ ] CTA with clear link

### Technical SEO:
- [ ] Mobile-responsive design
- [ ] Fast loading (<3 seconds)
- [ ] HTTPS enabled
- [ ] XML sitemap
- [ ] Robots.txt
- [ ] Open Graph meta tags

---
# LMSPro Features Page Content

**Page URL:** `/features`  
**Purpose:** Detailed feature showcase to convert interested visitors

---

## Hero Section

### Headline
**Powerful Features. Simple Experience.**

### Subheadline
Everything you need to run your youth football league efficiently. No complexity, no steep learning curve – just tools that work.

### Hero CTA
- "Start Free Today" → `/register`

---

## Feature Categories Navigation

### Sticky Navigation (desktop) / Dropdown (mobile)
- Season Management
- Club Registration
- Team Management
- Age Groups & Divisions
- Communications
- Dashboard & Reporting

---

## Feature Category 1: Season Management

### Section Headline
**Season Management**

### Section Subheadline
Plan your entire season from one place. Set dates, configure structure, and keep everything on track.

### Features Grid

**📅 Season Setup**
Create new seasons with start/end dates, registration windows, and key milestones. Clone from previous seasons to save time.

**🔒 Registration Windows**
Open and close registration automatically. Set different windows for different stages – early bird, standard, late.

**📆 Key Dates Calendar**
Define all important dates in one place. Automatic reminders keep clubs informed of upcoming deadlines.

**🔄 Season Rollover**
When a new season starts, rollover clubs and contacts from the previous year. Start fresh without starting from scratch.

**⚙️ Season Settings**
Configure age group structure, fee schedules, and league rules per season. Different seasons can have different rules.

### Feature Screenshot
*Placeholder: Season management dashboard showing calendar, key dates, and registration status*

---

## Feature Category 2: Club Registration

### Section Headline
**Club & Team Registration**

### Section Subheadline
Say goodbye to paper forms and email chains. Online registration that clubs actually want to use.

### Features Grid

**📝 Online Application Forms**
Custom registration forms for your league. Clubs apply online – no PDFs, no printing, no scanning.

**✅ Approval Workflow**
Review applications, request changes, approve or reject with one click. Track every application's status.

**📤 Club Self-Service Portal**
Clubs log in to submit information, update contacts, and register teams. They manage their data, you approve it.

**📋 Required Documents**
Request constitution documents, insurance certificates, safeguarding policies. Clubs upload, you verify.

**🔔 Automated Reminders**
Clubs get automatic reminders for incomplete registrations, missing information, and upcoming deadlines.

**📊 Registration Progress**
See at a glance which clubs have registered, which are pending, and who's missing. No more chasing.

### Feature Screenshot
*Placeholder: Club applications list with status filters and approval buttons*

---

## Feature Category 3: Team Management

### Section Headline
**Team Management**

### Section Subheadline
From registration to allocation, manage every team in your league with ease.

### Features Grid

**👥 Team Registration**
Clubs register teams with name, age group, manager contact. All details captured consistently.

**📧 Manager Contacts**
Store team manager details separately from club contacts. Send communications direct to the pitch.

**🏷️ Team Status Tracking**
Active, inactive, withdrawn. Track team status throughout the season with full history.

**🔄 Age Group Allocation**
Assign teams to age groups. Move teams between groups when needed. Automatic validation prevents errors.

**📊 Team Capacity**
Set maximum teams per age group. Wait list management when groups are full.

**📝 Team Notes**
Add internal notes to any team record. Track conversations, issues, and special requirements.

### Feature Screenshot
*Placeholder: Teams list filtered by age group with status badges*

---

## Feature Category 4: Age Groups & Divisions

### Section Headline
**Age Groups & Divisions**

### Section Subheadline
Flexible configuration for any league structure. U7s to U18s, single divisions to multiple leagues.

### Features Grid

**🎂 Age Group Configuration**
Define which age groups your league runs. U7, U8, U9... all the way up. Enable/disable per season.

**🏆 Division Structure**
Create divisions within age groups. Division 1, Division 2, or call them whatever you like.

**👤 Age Group Managers**
Assign volunteer managers to each age group. Give them visibility over their teams.

**📦 Team Allocation**
Allocate teams to divisions. Drag-and-drop interface makes reorganisation simple.

**📊 Capacity Management**
Set maximum teams per division. Visualise fill rates and availability.

**🔢 Display Order**
Control how age groups and divisions appear throughout the system. Youngest first, oldest first – your choice.

### Feature Screenshot
*Placeholder: Age groups page showing divisions and allocated teams*

---

## Feature Category 5: Communications

### Section Headline
**Communications Hub**

### Section Subheadline
Keep everyone informed without the email chaos. Targeted communications that reach the right people.

### Features Grid

**📣 Announcements**
Create league-wide announcements. Important news reaches all clubs instantly.

**📧 Email Campaigns**
Send targeted emails to all clubs, specific age groups, or individual teams. Track delivery and opens.

**📝 Email Templates**
Create reusable templates for common communications. Season welcome, deadline reminders, rule updates.

**👥 Recipient Groups**
Target communications precisely. All club secretaries, all U10 team managers, specific clubs only.

**📎 Document Sharing**
Attach league documents, rulebooks, and forms to communications. Everything in one place.

**📜 Communication History**
Full record of all communications sent. Never wonder "did we send that email?"

### Feature Screenshot
*Placeholder: Communications dashboard showing sent announcements and email stats*

---

## Feature Category 6: Dashboard & Reporting

### Section Headline
**Dashboard & Reporting**

### Section Subheadline
Real-time visibility into your league. No more spreadsheet gymnastics.

### Features Grid

**📊 Admin Dashboard**
At-a-glance overview of registrations, approvals pending, and recent activity. Know your league's status instantly.

**📈 Registration Reports**
Track registration progress over time. Compare to previous seasons. Identify trends.

**📋 Club Reports**
Export club lists, team lists, contact directories. Perfect for committee meetings.

**🔍 Search & Filter**
Find any club, team, or person instantly. Powerful filters narrow down large datasets.

**📤 Data Export**
Export any data to CSV or Excel. Your data, your way. No vendor lock-in.

**📱 Mobile Access**
Check your dashboard from anywhere. Full functionality on tablets and phones.

### Feature Screenshot
*Placeholder: Admin dashboard with charts, stats, and recent activity feed*

---

## Coming Soon Section

### Section Headline
**Coming Soon**

### Section Subheadline
We're constantly improving LMSPro based on feedback from leagues like yours.

### Roadmap Items

**💰 Payment Integration**
Collect registration fees online. Automated invoicing and receipts. *Q3 2026*

**💼 Accounting System Integration**
Integrate with popular accounting software for seamless financial management. *Q4 2026*

**📋 Referee Management**
Referee database, match allocation, availability tracking. *Q4 2026*

---

## Comparison Section

### Section Headline
**Why LMSPro vs Spreadsheets?**

| Feature | Spreadsheets | LMSPro |
|---------|--------------|--------|
| Online registration | ❌ Manual entry | ✅ Self-service |
| Club self-service | ❌ Email back & forth | ✅ Club portal |
| Automatic reminders | ❌ Manual emails | ✅ Automated |
| Approval workflow | ❌ Track manually | ✅ Built-in |
| Contact management | ❌ Multiple lists | ✅ Centralised |
| Version control | ❌ v2_final_FINAL | ✅ Always current |
| Mobile access | ❌ Limited | ✅ Full access |
| Audit trail | ❌ None | ✅ Complete history |

---

## Final CTA Section

### Headline
**Ready to Transform Your League Administration?**

### Subtext
Join the growing number of leagues using LMSPro to save time and reduce stress.

### CTA Buttons
- **Primary:** "Start Free Today" → `/register`
- **Secondary:** "Contact Us" → `/contact`

---

## SEO Metadata

### Title Tag
LMSPro Features | League Management Software for Youth Football

### Meta Description
Explore LMSPro features: season management, online registration, club portals, communications, and real-time reporting. Built for grassroots football leagues.

### Keywords
- football league management features
- online registration for football clubs
- youth football administration software
- club registration portal
- league communications platform


## Content Completion Status

| Document | Status | Notes |
|----------|--------|-------|
| 00-BRIEF.md | ✅ Complete | |
| 01-HOMEPAGE.md | ✅ Complete | |
| 02-FEATURES.md | ✅ Complete | |
| 03-PRICING.md | ✅ Complete | Confirm pricing with business |
| 04-ABOUT.md | ✅ Complete | Add real team photos/bios |
| 05-CONTACT.md | ✅ Complete | Confirm email addresses |
| 06-TESTIMONIALS.md | ✅ Complete | Replace with real testimonials |
| 07-DESIGN-ASSETS.md | ✅ Complete | Create actual assets |

---

## Next Steps for Gamma.io Build

1. **Review all content documents** – Confirm messaging accuracy
2. **Gather real testimonials** – Replace placeholder quotes
3. **Confirm pricing** – Verify tiers with business
4. **Create visual assets** – Logo, screenshots, photography
5. **Build in Gamma.io** – Use documents as content source
6. **Connect CTAs** – Link to IsoStack registration
7. **Test mobile experience** – Ensure responsive
8. **Add analytics** – GA4 tracking
9. **Launch and iterate** – Gather feedback, improve

---

## Questions for Stakeholder Review

Before finalising:

1. **Pricing:** Are the tiers (Free, £49/mo, Custom) correct?
2. **Features:** Any features missing from the list?
3. **Testimonials:** Can we reach out to leagues for real quotes?
4. **Team page:** Include founder/team information?
5. **Contact emails:** Confirm `hello@lmspro.app`, `support@lmspro.app`
6. **Domain:** Will marketing site be at `lmspro.app` or subdomain?
7. **Legal:** Privacy policy and terms URLs correct?
8. **Demo booking:** Use Calendly or another tool?

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 17 Feb 2026 | Initial creation of all marketing documents |


## Success Metrics

The marketing site should:
1. Clearly explain what LMSPro does within 5 seconds
2. Show value proposition before any scroll
3. Have clear CTA visible on all pages
4. Load in under 3 seconds
5. Work perfectly on mobile devices
6. Generate league registration enquiries
