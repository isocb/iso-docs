# LMSPro Marketing Site & C1 League Registration Plan

**Created:** 17 February 2026  
**Status:** Planning  
**Priority:** High

---

## 1. Overview

### Current State
- `/auth/signup` creates a new IsoStack organization (generic)
- `/register/club?org=<slug>` is the C2 (club) registration form for a specific league
- No dedicated LMSPro marketing site exists
- No dedicated C1 (league owner) registration flow

### Target State
- **LMSPro Marketing Site** at `/lmspro` (public) - Features, Pricing, About, Contact
- **C1 League Registration** at `/lmspro/register` - League owner signup for LMSPro
- **C2 Club Registration** remains at `/register/club?org=<slug>` (already working)

---

## 2. Architecture

### Route Structure

```
/lmspro                    # Marketing homepage (public)
├── /features              # Feature showcase
├── /pricing               # Pricing tiers
├── /about                 # About LMSPro
├── /contact               # Contact form
└── /register              # C1 League Registration form
    └── /success           # Registration confirmation
```

### File Structure

```
src/app/(public)/lmspro/
├── page.tsx               # Marketing homepage
├── layout.tsx             # LMSPro-branded layout
├── features/
│   └── page.tsx
├── pricing/
│   └── page.tsx
├── about/
│   └── page.tsx
├── contact/
│   └── page.tsx
└── register/
    ├── page.tsx           # C1 League Registration form
    └── success/
        └── page.tsx       # Confirmation page
```

---

## 3. Phase Breakdown

### Phase 1: LMSPro Layout & Navigation (30 min)
**Goal:** Create the marketing site shell with LMSPro branding

**Tasks:**
1. Create `/src/app/(public)/lmspro/layout.tsx`
   - Fetch LMSPro module branding from `ModuleCatalogue`
   - Header with LMSPro logo, navigation links
   - Footer with "Powered by IsoStack"
2. Create navigation component for marketing pages
3. Apply LMSPro color scheme (primary/secondary colors)

**Test:** Navigate to `/lmspro` - should show branded header/footer

---

### Phase 2: Marketing Homepage (30 min)
**Goal:** Create the main landing page

**Tasks:**
1. Create `/src/app/(public)/lmspro/page.tsx`
   - Hero section with tagline
   - Key features overview (cards)
   - CTA buttons: "Get Started" → `/lmspro/register`
   - Testimonials placeholder
2. Mobile-responsive design using Mantine

**Content:**
- **Tagline:** "League Management Made Simple"
- **Subtitle:** "The complete platform for running youth football leagues"
- **Key Features:**
  - Season & Competition Management
  - Club Registration & Team Management
  - Age Group Configuration
  - Fixtures & Results
  - Communications Hub

**Test:** Visit `/lmspro` - should show professional marketing page

---

### Phase 3: Features Page (20 min)
**Goal:** Detailed feature showcase

**Tasks:**
1. Create `/src/app/(public)/lmspro/features/page.tsx`
   - Feature sections with icons and descriptions
   - Screenshots/mockups placeholders
   - CTA to register

**Feature Categories:**
1. **Season Management** - Create seasons, set dates, manage competitions
2. **Club & Team Registration** - Online applications, approval workflow, team allocation
3. **Age Groups & Competitions** - Flexible age group configuration, multiple formats
4. **Fixtures & Results** - Match scheduling, result entry, standings
5. **Communications** - Email notifications, announcements, document sharing
6. **Reporting & Analytics** - Registration stats, participation metrics

**Test:** Navigate to `/lmspro/features` - should show feature details

---

### Phase 4: Pricing Page (20 min)
**Goal:** Display pricing tiers

**Tasks:**
1. Create `/src/app/(public)/lmspro/pricing/page.tsx`
   - Pricing cards (Starter, Professional, Enterprise)
   - Feature comparison table
   - CTA buttons per tier

**Pricing Tiers (placeholder - confirm with business):**

| Feature | Starter | Professional | Enterprise |
|---------|---------|--------------|------------|
| Seasons | 1 | Unlimited | Unlimited |
| Clubs | Up to 20 | Up to 100 | Unlimited |
| Teams | Up to 50 | Up to 500 | Unlimited |
| Custom Branding | ❌ | ✅ | ✅ |
| Custom Domain | ❌ | ❌ | ✅ |
| API Access | ❌ | ❌ | ✅ |
| Support | Email | Priority | Dedicated |
| Price | Free | £49/mo | Custom |

**Test:** Navigate to `/lmspro/pricing` - should show pricing cards

---

### Phase 5: About & Contact Pages (20 min)
**Goal:** Standard marketing pages

**Tasks:**
1. Create `/src/app/(public)/lmspro/about/page.tsx`
   - Company/product story
   - Mission statement
   - Team (if applicable)

2. Create `/src/app/(public)/lmspro/contact/page.tsx`
   - Contact form (name, email, subject, message)
   - Email to `support@lmspro.app` or platform support
   - FAQ section placeholder

**Test:** Navigate to both pages - should show content and working form

---

### Phase 6: C1 League Registration Form (45 min)
**Goal:** Dedicated league owner signup flow

**Tasks:**
1. Create `/src/app/(public)/lmspro/register/page.tsx`
   - Multi-step form similar to club registration
   - LMSPro branding throughout

**Form Fields:**

**Step 1: League Information**
- League Name (required)
- League Short Name (for URLs, e.g., "djfl")
- League Type (dropdown: Youth Football, Adult Football, Other)
- Region/County
- Estimated number of clubs
- Estimated number of teams

**Step 2: Primary Contact**
- Full Name (required)
- Email (required) - becomes the OWNER account
- Phone Number
- Role/Title (e.g., "League Secretary")

**Step 3: Additional Details**
- How did you hear about us?
- Expected start date
- Any specific requirements? (textarea)
- Terms & Conditions checkbox
- Marketing opt-in checkbox

2. Create tRPC endpoint `lmspro.leagueRegistration.submit`
   - Creates Organization with `defaultModuleSlug: 'lmspro'`
   - Creates User with OWNER role
   - Assigns LMSPro module (Starter tier initially)
   - Sends welcome email
   - Creates audit log entry

3. Create `/src/app/(public)/lmspro/register/success/page.tsx`
   - Confirmation message
   - Next steps instructions
   - Link to sign in

**Test:** 
- Complete registration form
- Verify organization created with correct module
- Verify user created as OWNER
- Verify welcome email sent

---

### Phase 7: Backend - League Registration tRPC (30 min)
**Goal:** Server-side registration logic

**Tasks:**
1. Create `src/server/modules/lmspro/routers/leagueRegistration.router.ts`

```typescript
// Pseudocode structure
export const leagueRegistrationRouter = router({
  submit: publicProcedure
    .input(z.object({
      // League info
      leagueName: z.string().min(3),
      shortName: z.string().min(2).max(20).regex(/^[a-z0-9-]+$/),
      leagueType: z.enum(['youth_football', 'adult_football', 'other']),
      region: z.string().optional(),
      estimatedClubs: z.number().optional(),
      estimatedTeams: z.number().optional(),
      
      // Contact info
      contactName: z.string().min(2),
      contactEmail: z.string().email(),
      contactPhone: z.string().optional(),
      contactRole: z.string().optional(),
      
      // Additional
      hearAboutUs: z.string().optional(),
      expectedStartDate: z.string().optional(),
      requirements: z.string().optional(),
      acceptTerms: z.boolean(),
      marketingOptIn: z.boolean().default(false),
    }))
    .mutation(async ({ ctx, input }) => {
      // 1. Check if shortName (slug) is available
      // 2. Create Organization
      // 3. Create User as OWNER
      // 4. Assign LMSPro Starter product
      // 5. Send welcome email with magic link
      // 6. Create audit log
      // 7. Return success
    }),
    
  checkSlugAvailable: publicProcedure
    .input(z.object({ slug: z.string() }))
    .query(async ({ input }) => {
      // Check if org slug is available
    }),
});
```

2. Create email template `src/lib/email/templates/lmspro-welcome.tsx`
   - Welcome to LMSPro
   - Getting started guide links
   - Magic link to sign in

**Test:**
- Submit form → Organization created
- User receives welcome email
- Can sign in and access LMSPro

---

### Phase 8: Integration & Polish (30 min)
**Goal:** Connect all pieces, add finishing touches

**Tasks:**
1. Update `/auth/signup` to redirect to `/lmspro/register` for LMSPro signups
2. Add meta tags and SEO optimization to all pages
3. Add loading states and error handling
4. Add form validation messages
5. Test full flow end-to-end
6. Mobile responsiveness check

**Test:**
- Full user journey: Landing → Features → Pricing → Register → Success → Sign In → Dashboard

---

## 4. Database Considerations

### No Schema Changes Required
The existing schema supports this:
- `Organization` - stores league info
- `User` - stores owner account
- `OrganizationProduct` - links to LMSPro product
- `OrganisationModule` - grants LMSPro access

### Slug Uniqueness
- `Organization.slug` is already unique
- Add real-time slug availability check in form

---

## 5. Email Templates

### Welcome Email Content

**Subject:** Welcome to LMSPro - Let's get your league set up!

**Body:**
```
Hi {contactName},

Welcome to LMSPro! Your league "{leagueName}" has been created.

Here's how to get started:

1. Sign in to your dashboard: [Sign In Link]
2. Complete your league profile
3. Set up your first season
4. Invite clubs to register

Need help? Check out our getting started guide or contact support.

Best regards,
The LMSPro Team
```

---

## 6. Success Metrics

- **Conversion Rate:** Marketing page visitors → Registration starts
- **Completion Rate:** Registration starts → Registration completes
- **Activation Rate:** Registrations → First season created

---

## 7. Future Enhancements (Out of Scope)

- [ ] Live chat widget on marketing pages
- [ ] Demo video embeds
- [ ] Case studies / testimonials (real data)
- [ ] A/B testing on pricing page
- [ ] Referral program integration
- [ ] Self-serve plan upgrades

---

## 8. Dependencies

- LMSPro module branding configured in `ModuleCatalogue`
- LMSPro Starter product defined in `ProductPackage`
- Email service (Resend) configured

---

## 9. Estimated Timeline

| Phase | Description | Time |
|-------|-------------|------|
| 1 | Layout & Navigation | 30 min |
| 2 | Homepage | 30 min |
| 3 | Features Page | 20 min |
| 4 | Pricing Page | 20 min |
| 5 | About & Contact | 20 min |
| 6 | Registration Form | 45 min |
| 7 | Backend/tRPC | 30 min |
| 8 | Integration | 30 min |
| **Total** | | **~4 hours** |

---

## 10. Acceptance Criteria

- [ ] `/lmspro` shows professional marketing landing page
- [ ] `/lmspro/features` details all LMSPro capabilities
- [ ] `/lmspro/pricing` shows tier comparison
- [ ] `/lmspro/register` allows league owners to sign up
- [ ] Registration creates org, user, and assigns LMSPro module
- [ ] Welcome email sent with sign-in link
- [ ] User can sign in and access LMSPro dashboard
- [ ] Mobile-responsive design throughout
- [ ] LMSPro branding consistent across all pages

---

## 11. Related Documentation

- `/docs/modules/lmspro/README.md` - LMSPro module overview
- `/docs/00-overview/branding.md` - Branding architecture
- `/docs/guides/auth-flows.md` - Authentication flows

