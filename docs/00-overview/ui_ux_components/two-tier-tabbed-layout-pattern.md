# Two-Tier Tabbed Layout Pattern

**Version:** 1.0  
**Created:** 17 February 2026  
**Status:** Standard Pattern

---

## Purpose

This document defines the standard pattern for implementing two-tier navigation layouts in IsoStack. Use this pattern when content needs to be organised into:

1. **Top-level sections** (e.g., Personal vs Organisation)
2. **Sub-tabs within each section** (e.g., Profile, Security Keys within Personal)

---

## When to Use

- Settings pages with personal/organisation separation
- Admin panels with multiple logical groupings
- Any layout requiring hierarchical tab navigation
- Role-based content separation (e.g., user tabs vs admin-only tabs)

---

## Visual Structure

```
┌─────────────────────────────────────────────────────────┐
│  Title (e.g., "Settings")                               │
├─────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────┐               │
│  │ [👤 Personal] [🏢 Organisation]      │  ← Tier 1     │
│  │     (pill-style toggle)              │    (SegmentedControl)
│  └──────────────────────────────────────┘               │
├─────────────────────────────────────────────────────────┤
│  ┌────────┬──────────┬──────────┐                       │
│  │ Tab 1  │  Tab 2   │  Tab 3   │          ← Tier 2     │
│  └────────┴──────────┴──────────┘            (Tabs.List)│
├─────────────────────────────────────────────────────────┤
│                                                         │
│                    Content Area                         │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Implementation

### Tier 1: Section Toggle (SegmentedControl)

Use Mantine's `SegmentedControl` with these specifications:

| Property | Value | Rationale |
|----------|-------|-----------|
| `size` | `"md"` | Readable without being dominant |
| `radius` | `"xl"` | Pill-style appearance |
| `position` | Left-aligned under title | Not competing with content |
| `width` | `fit-content` | Only as wide as content needs |

#### Code Pattern

```tsx
import { SegmentedControl, Group, Stack, Title } from '@mantine/core';
import { IconUser, IconBuilding } from '@tabler/icons-react';

<Stack gap="sm">
  <Title order={2}>Settings</Title>
  
  <SegmentedControl
    value={mainSection}
    onChange={handleMainSectionChange}
    size="md"
    radius="xl"
    styles={{
      root: {
        width: 'fit-content',
        backgroundColor: 'var(--mantine-color-gray-1)',
      },
    }}
    data={[
      {
        value: 'personal',
        label: (
          <Group gap={6} wrap="nowrap" px="xs">
            <IconUser size={18} />
            <span>Personal</span>
          </Group>
        ),
      },
      {
        value: 'organisation',
        label: (
          <Group gap={6} wrap="nowrap" px="xs">
            <IconBuilding size={18} />
            <span>Organisation</span>
          </Group>
        ),
      },
    ]}
  />
</Stack>
```

#### Critical Details

1. **`wrap="nowrap"`** - Prevents icon and text from stacking vertically
2. **`gap={6}`** - Tight spacing between icon and text
3. **`px="xs"`** - Horizontal padding for breathing room
4. **`<span>` not `<Text>`** - Simpler, inherits SegmentedControl styling
5. **Icon size `18`** - Balanced with medium control size

### Tier 2: Sub-Tabs (Mantine Tabs)

Standard Mantine Tabs positioned below the SegmentedControl:

```tsx
import { Tabs } from '@mantine/core';

<Tabs value={activeTab} onChange={handleSubTabChange}>
  <Tabs.List>
    {currentTabs.map((tab) => (
      <Tabs.Tab key={tab.value} value={tab.value}>
        {tab.label}
      </Tabs.Tab>
    ))}
  </Tabs.List>
</Tabs>
```

---

## State Management

### Section Detection from URL

Determine which section is active based on the current pathname:

```tsx
const isInPersonalSection = personalTabs.some((tab) => pathname === tab.path);
const isInOrgSection = organisationTabs.some((tab) => pathname === tab.path);

const [mainSection, setMainSection] = useState<'personal' | 'organisation'>(
  isInOrgSection ? 'organisation' : 'personal'
);

// Sync state when URL changes
useEffect(() => {
  if (isInPersonalSection) {
    setMainSection('personal');
  } else if (isInOrgSection) {
    setMainSection('organisation');
  }
}, [pathname, isInPersonalSection, isInOrgSection]);
```

### Section Change Handler

Navigate to first tab of new section when switching:

```tsx
const handleMainSectionChange = (value: string) => {
  const newSection = value as 'personal' | 'organisation';
  setMainSection(newSection);
  
  const firstTab = newSection === 'personal' ? personalTabs[0] : organisationTabs[0];
  if (firstTab) {
    router.push(firstTab.path);
  }
};
```

---

## Role-Based Tab Visibility

Show Organisation tabs only to admins/owners:

```tsx
const isAdmin = profile?.role === 'ADMIN' || profile?.role === 'OWNER';

// Only render SegmentedControl if user has access to both sections
{isAdmin && (
  <SegmentedControl ... />
)}

// Define organisation tabs conditionally
const organisationTabs: TabConfig[] = isAdmin
  ? [
      { value: 'team', label: 'Team', path: '/settings/team' },
      { value: 'branding', label: 'Branding', path: '/settings/branding' },
      // ... more tabs
    ]
  : [];
```

---

## Reference Implementation

**File:** `src/app/(app)/settings/layout.tsx`

This is the canonical implementation of this pattern.

---

## Anti-Patterns to Avoid

| ❌ Don't | ✅ Do |
|----------|-------|
| Position toggle on the right | Left-align under title |
| Use small icons (`14px`) | Use `18px` icons for `md` size |
| Allow wrapping with `<Text>` | Use `<span>` with `wrap="nowrap"` |
| Use default gap | Use tight `gap={6}` |
| Omit background styling | Add subtle `gray-1` background |
| Use rounded rectangles (`radius="md"`) | Use pill style (`radius="xl"`) |

---

## Accessibility

- SegmentedControl is keyboard navigable (arrow keys)
- Focus states are automatically handled by Mantine
- Icons should be decorative (no `aria-label` needed when text is present)

---

## Related Patterns

- **Table CRUD Pattern** - See `docs/guides/table-crud-pattern.md`
- **Modal Pattern** - Standard modal footer layout
- **Breadcrumb Pattern** - Navigation hierarchy display

---

*Last Updated: 17 February 2026*
