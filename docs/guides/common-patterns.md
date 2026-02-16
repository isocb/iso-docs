# Common UI Patterns

Reusable patterns and components for consistent UX across IsoStack.

---

## Clickable Contact Links

Phone numbers and email addresses should always be clickable to improve mobile UX and user convenience.

### Components

| Component | Location | Purpose |
|-----------|----------|---------|
| `PhoneLink` | `src/components/ui/PhoneLink.tsx` | Clickable `tel:` link |
| `EmailLink` | `src/components/ui/EmailLink.tsx` | Clickable `mailto:` link |

### PhoneLink

Renders a phone number as a clickable link. On mobile devices, tapping opens the dialer.

```tsx
import { PhoneLink } from '@/components/ui/PhoneLink';

// Basic usage
<PhoneLink phone="07123 456789" />

// With options
<PhoneLink 
  phone={contact.phone} 
  size="xs" 
  fallback="No phone" 
/>
```

**Props:**

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `phone` | `string \| null \| undefined` | — | Phone number to display |
| `fallback` | `string` | `"—"` | Text shown when phone is null |
| `size` | `'xs' \| 'sm' \| 'md' \| 'lg' \| 'xl'` | `'sm'` | Mantine text size |
| `inheritColor` | `boolean` | `false` | Inherit parent color instead of link blue |

**UK Number Handling:**

The component automatically converts UK numbers starting with `0` to international format (`+44`) for better mobile compatibility:

- Input: `07123 456789`
- Tel href: `tel:+447123456789`

### EmailLink

Renders an email address as a clickable `mailto:` link.

```tsx
import { EmailLink } from '@/components/ui/EmailLink';

// Basic usage
<EmailLink email="manager@club.com" />

// With options
<EmailLink 
  email={team.managerEmail} 
  size="xs" 
  color="blue" 
/>
```

**Props:**

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `email` | `string \| null \| undefined` | — | Email address to display |
| `fallback` | `string` | `"—"` | Text shown when email is null |
| `size` | `'xs' \| 'sm' \| 'md' \| 'lg' \| 'xl'` | `'sm'` | Mantine text size |
| `color` | `'dimmed' \| 'blue' \| 'inherit'` | `'dimmed'` | Link color |

### Where to Use

Apply these components wherever contact information is displayed:

- Club contact details
- Team manager information
- Venue contact cards
- User profiles
- Referee listings

### Before/After Example

```tsx
// ❌ Before - plain text, not clickable
<Text size="xs" c="dimmed">{team.managerEmail}</Text>
<Text size="xs" c="dimmed">{club.phone}</Text>

// ✅ After - clickable links
<EmailLink email={team.managerEmail} size="xs" />
<PhoneLink phone={club.phone} size="xs" />
```

---

## Additional Patterns

*More patterns will be documented here as they are standardized.*
