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
