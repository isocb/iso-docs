# LMSPro Visual Design & Asset Guide

**Purpose:** Guide for creating visual assets for the LMSPro marketing site

---

## Brand Identity

### Primary Logo
**File needed:** `lmspro-logo-primary.svg`

- LMSPro wordmark
- Can include football/shield icon element
- Primary use: Header, hero sections, emails

### Secondary Logo
**File needed:** `lmspro-logo-icon.svg`

- Icon only version
- For favicon, social media avatars, app icons

### Logo Usage Rules
- Minimum clear space: Height of "L" character
- Minimum size: 100px wide (web)
- Never stretch, rotate, or modify colours
- Always use on solid backgrounds (white or brand primary)

---

## Colour Palette

### Primary Colours

**LMSPro Blue (Primary)**
- Hex: `#1E3A5F`
- RGB: 30, 58, 95
- Use: Headers, CTAs, primary buttons

**Grass Green (Secondary)**
- Hex: `#4CAF50`
- RGB: 76, 175, 80
- Use: Success states, football association, growth

**Action Orange (Accent)**
- Hex: `#FF6B35`
- RGB: 255, 107, 53
- Use: CTAs, highlights, urgent actions

### Supporting Colours

**Light Background**
- Hex: `#F8FAFC`
- Use: Page backgrounds, cards

**Text Dark**
- Hex: `#1F2937`
- Use: Body text, headings

**Text Light**
- Hex: `#6B7280`
- Use: Secondary text, captions

**Border/Divider**
- Hex: `#E5E7EB`
- Use: Borders, dividers, subtle separations

### Colour Accessibility
- All text must meet WCAG AA contrast (4.5:1 minimum)
- Links clearly distinguishable from body text
- Never use colour alone to convey information

---

## Typography

### Primary Font: Inter (or similar clean sans-serif)
- Available: Google Fonts
- Weights: 400 (regular), 500 (medium), 600 (semibold), 700 (bold)

### Type Scale

| Element | Size | Weight | Line Height |
|---------|------|--------|-------------|
| H1 (Hero) | 48-56px | Bold | 1.1 |
| H2 (Section) | 36-40px | Semibold | 1.2 |
| H3 (Subsection) | 24-28px | Semibold | 1.3 |
| H4 (Card title) | 20px | Semibold | 1.4 |
| Body Large | 18px | Regular | 1.6 |
| Body | 16px | Regular | 1.6 |
| Small | 14px | Regular | 1.5 |
| Caption | 12px | Regular | 1.4 |

### Mobile Adjustments
- H1: Scale down to 32-36px
- H2: Scale down to 28-32px
- Body remains 16px minimum for readability

---

## Imagery Guidelines

### Photography Style

**Subject Matter:**
- Youth football matches (diverse, inclusive)
- Grassroots pitches (real, not professional stadiums)
- Volunteer administrators working (laptops, tablets)
- Parents on touchlines
- Award ceremonies, team photos
- Football equipment (balls, goalposts, bibs)

**Treatment:**
- Natural, authentic feeling (not overly posed)
- Bright, optimistic lighting
- UK setting recognisable (weather, pitches, kit)
- Diverse representation (age, gender, ethnicity)

**Avoid:**
- Professional/elite football imagery
- Stock photos that feel generic
- Images without clear connection to grassroots football
- Low quality or heavily filtered images

### Illustration Style

**Icon Style:**
- Line icons, 2px stroke
- Rounded corners
- Single colour or two-colour max
- Consistent stroke weight throughout

**Suggested Icon Set:**
- Heroicons (https://heroicons.com)
- Phosphor Icons (https://phosphoricons.com)
- Lucide (https://lucide.dev)

**Custom Illustrations:**
- Flat design, limited colour palette
- Football-themed elements
- Friendly, approachable style
- Avoid overly technical or complex

---

## UI Components

### Buttons

**Primary Button**
- Background: LMSPro Blue (`#1E3A5F`)
- Text: White
- Border radius: 8px
- Padding: 12px 24px
- Font: 16px, Semibold
- Hover: Darken background 10%

**Secondary Button**
- Background: Transparent
- Border: 2px solid LMSPro Blue
- Text: LMSPro Blue
- Hover: Light blue background tint

**CTA Button (Orange)**
- Background: Action Orange (`#FF6B35`)
- Text: White
- Use sparingly for primary conversion actions

### Cards

**Feature Card**
- Background: White
- Border: 1px solid `#E5E7EB`
- Border radius: 12px
- Padding: 24px
- Shadow: `0 1px 3px rgba(0,0,0,0.1)`
- Hover: Subtle lift with increased shadow

**Pricing Card**
- Same as feature card
- Highlight card (most popular): Border in Grass Green

**Testimonial Card**
- Light background (`#F8FAFC`)
- Quotation marks in light green
- Avatar/photo on left or top
- Star rating in gold/yellow

### Forms

**Input Fields**
- Border: 1px solid `#D1D5DB`
- Border radius: 8px
- Padding: 12px 16px
- Focus: Border in LMSPro Blue, subtle glow
- Error: Border in red, error message below

**Labels**
- Font: 14px, Medium
- Colour: Text Dark
- Margin below: 4px

---

## Layout Patterns

### Header
- White background with subtle shadow
- Logo left, navigation center or right
- CTA button ("Get Started") in header
- Mobile: Hamburger menu

### Hero Section
- Full width
- Large headline, supporting text
- CTA buttons prominent
- Image/illustration on right (desktop) or below (mobile)

### Feature Sections
- Alternating layout (text left/image right, then reverse)
- Clear section headings
- Feature cards in 3-column grid

### Footer
- Dark background (LMSPro Blue or dark grey)
- Multi-column link layout
- Social icons
- Copyright and legal links

---

## Responsive Breakpoints

| Breakpoint | Width | Use |
|------------|-------|-----|
| Mobile | < 640px | Single column, stacked layout |
| Tablet | 640-1024px | Two columns, adjusted spacing |
| Desktop | 1024-1280px | Full layout |
| Large Desktop | > 1280px | Max-width container, centered |

### Container Max Width
- Content: 1200px max, centered
- Full-bleed sections: Edge to edge
- Padding: 24px (mobile), 48px (desktop)

---

## Animation Guidelines

### General Principles
- Subtle, purposeful animations
- 200-300ms duration for micro-interactions
- Ease-out for elements entering
- Ease-in for elements leaving

### Suggested Animations
- Button hover: Scale 1.02, shadow increase
- Card hover: Translate Y -4px, shadow increase
- Page transitions: Fade in from bottom (subtle)
- Number counters: Animate on scroll into view
- Image reveal: Subtle fade-in on load

### Avoid
- Excessive motion
- Auto-playing video backgrounds
- Distracting animations that slow reading
- Any animation that blocks interaction

---

## Screenshot Requirements

### Dashboard Screenshots
**File needed:** `screenshot-dashboard.png`
- Full dashboard view
- Show registration stats, pending items, recent activity
- Real-looking but anonymised data
- Clean browser frame or none

### Registration Screenshots
**File needed:** `screenshot-club-registration.png`
- Club registration list view
- Show various statuses (pending, approved, etc.)
- Filter/search visible

### Team Management Screenshots
**File needed:** `screenshot-teams.png`
- Teams list with age group filters
- Show team details visible
- Status badges prominent

### Mobile Screenshots
**File needed:** `screenshot-mobile.png`
- Mobile view of dashboard or key feature
- Shown in device frame (iPhone mockup)
- Portrait orientation

### Screenshot Guidelines
- Use consistent, realistic demo data
- Remove any actual personal data
- 2x resolution for retina displays
- PNG format, optimised for web
- Add subtle shadow/device frame for polish

---

## Favicon & App Icons

### Favicon
**Files needed:**
- `favicon.ico` (16x16, 32x32 multi-size)
- `favicon-16x16.png`
- `favicon-32x32.png`
- `apple-touch-icon.png` (180x180)

### Open Graph / Social Sharing
**Files needed:**
- `og-image.png` (1200x630)
- `twitter-card.png` (1200x600)

**Content for social images:**
- LMSPro logo
- Tagline: "League Management Made Simple"
- Brand colours background
- Optional: Football/pitch imagery

---

## Asset Checklist

### Essential (Must Have)
- [ ] Primary logo (SVG, PNG)
- [ ] Icon logo (SVG, PNG)
- [ ] Favicon set
- [ ] Social sharing images
- [ ] Hero image/illustration
- [ ] Feature icons (10-15)
- [ ] 3-5 photography images
- [ ] Screenshot mockups (3-5)

### Nice to Have
- [ ] Custom illustrations for each feature
- [ ] Team/founder photos
- [ ] Video testimonials
- [ ] League logo carousel
- [ ] Animation assets (Lottie)
- [ ] Mobile device mockups

---

## File Delivery Format

### For Web
- Images: WebP (with PNG fallback)
- Icons: SVG preferred
- Maximum file sizes:
  - Hero images: <200KB
  - Feature images: <100KB
  - Icons: <10KB

### For Design Tools
- Figma source file (if applicable)
- SVG exports
- 2x PNG exports for documentation
