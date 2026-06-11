# Table CRUD Pattern - Enforcement Guide

**Version:** 1.1  
**Authority:** isostack-ux-ui-standard.md Section 7.1  
**Status:** MANDATORY for all table interfaces

## Overview

All table-to-CRUD interfaces MUST follow the "Click-to-View-and-Edit" pattern defined in Section 7.1 of the UX/UI Standard. This ensures consistent user experience with large click targets and no tiny icon buttons.

## Core Principles

### ✅ DO THIS

1. **Entire row is clickable** - Opens modal in edit mode
2. **Delete button in modal footer** - Bottom-left, red, outline variant
3. **Large click targets** - No sub-16px interactive elements
4. **Cursor feedback** - `cursor: 'pointer'` on DataTable
5. **Sortable columns default as standard** - all sortable headers are click targets, first click sorts asc, second click reverses

### ❌ NEVER DO THIS

1. **ActionIcon buttons in table rows** - Violates "no tiny targets" rule
2. **Inline delete buttons** - Delete must be in modal footer
3. **Edit icon buttons** - Row click handles edit
4. **Tooltips wrapping icon buttons** - Indicates wrong pattern

## Implementation Template

### DataTable Structure

```tsx
import { IconSelector, IconChevronUp, IconChevronDown } from '@tabler/icons-react';

type SortDirection = 'asc' | 'desc';

const [sortStatus, setSortStatus] = useState<{ columnAccessor: string; direction: SortDirection }>({
  columnAccessor: 'name',
  direction: 'asc',
});

const handleSort = (columnAccessor: string) => {
  setSortStatus((current) => ({
    columnAccessor,
    direction:
      current.columnAccessor === columnAccessor && current.direction === 'asc'
        ? 'desc'
        : 'asc',
  }));
};

const renderSortHeader = (columnAccessor: string, label: string) => {
  const active = sortStatus.columnAccessor === columnAccessor;
  const SortIcon = active
    ? sortStatus.direction === 'asc'
      ? IconChevronUp
      : IconChevronDown
    : IconSelector;
  const iconColor = active ? 'var(--mantine-color-gray-6)' : 'var(--mantine-color-gray-3)';

  return (
    <Table.Th aria-sort={active ? (sortStatus.direction === 'asc' ? 'ascending' : 'descending') : 'none'}>
      <UnstyledButton onClick={() => handleSort(columnAccessor)} style={{ width: '100%' }}>
        <Group gap={4} wrap="nowrap">
          <Text span size="sm" fw={600}>{label}</Text>
          <SortIcon size={14} stroke={1.8} color={iconColor} />
        </Group>
      </UnstyledButton>
    </Table.Th>
  );
};

<DataTable
  records={sortedItems}
  fetching={isLoading}
  onRowClick={(item: any) => handleOpenEdit(item?.record ?? item)}
  style={{ cursor: 'pointer' }}
  columns={[
    {
      accessor: 'name',
      title: () => renderSortHeader('name', 'Name'),
      render: (item: any) => <Text>{item.name}</Text>,
    },
    {
      accessor: 'status',
      title: () => renderSortHeader('status', 'Status'),
      render: (item: any) => <Text>{item.status}</Text>,
    },
    // Add more data columns (NO actions column)
  ]}
  noRecordsText="No items found"
/>
```

<!-- Tip: `sortedItems` should be produced by applying `sortStatus` before passing to DataTable, or by server-side sort keys. -->

### Modal Footer with Delete

```tsx
<Group justify="space-between" mt="md">
  {editingItem ? (
    <Button
      color="red"
      variant="outline"
      leftSection={<IconTrash size={16} />}
      onClick={() => {
        if (confirm(`Are you sure you want to delete "${editingItem.name}"?`)) {
          handleDelete(editingItem.id);
        }
      }}
    >
      Delete
    </Button>
  ) : (
    <div /> {/* Empty space when creating */}
  )}
  <Group>
    <Button variant="subtle" onClick={closeModal}>
      Cancel
    </Button>
    <Button onClick={handleSubmit} loading={createMutation.isPending || updateMutation.isPending}>
      {editingItem ? 'Update' : 'Create'}
    </Button>
  </Group>
</Group>
```

## Checklist for Code Reviews

When reviewing table interfaces, verify:

- [ ] DataTable has `onRowClick` handler
- [ ] DataTable has `cursor: 'pointer'` style
- [ ] NO `actions` column in columns array
- [ ] NO `ActionIcon` components in table rows
- [ ] Delete button is in modal footer, not inline
- [ ] Delete button is red, outline variant, bottom-left
- [ ] No `<Tooltip>` wrapping edit/delete actions
- [ ] Sort icon appears on sortable headers
- [ ] First click sorts ascending and second click reverses
- [ ] Active sort icon is darker gray; inactive sort icons are light gray

## Migration Guide

### Before (❌ Anti-pattern)

```tsx
// DON'T: ActionIcon buttons in actions column
columns={[
  {
    accessor: 'actions',
    title: 'Actions',
    render: (item: any) => (
      <Group>
        <ActionIcon onClick={() => openEdit(item)}>
          <IconEdit size={16} />
        </ActionIcon>
        <ActionIcon color="red" onClick={() => handleDelete(item.id)}>
          <IconTrash size={16} />
        </ActionIcon>
      </Group>
    ),
  },
]}
```

### After (✅ Correct pattern)

```tsx
// DO: Row click + modal delete
<DataTable
  onRowClick={(item: any) => openEdit(item)}
  style={{ cursor: 'pointer' }}
  columns={[
    // Only data columns, no actions column
  ]}
/>

// In modal footer:
<Group justify="space-between">
  {editingItem && (
    <Button color="red" variant="outline" onClick={confirmDelete}>
      Delete
    </Button>
  )}
  <Group>
    <Button variant="subtle" onClick={closeModal}>Cancel</Button>
    <Button onClick={handleSubmit}>Save</Button>
  </Group>
</Group>
```

## Exceptions

**When to use inline actions** (Section 7.3):
- Quick actions that don't open modals (e.g., toggle status)
- Non-destructive operations only
- Must use `stopPropagation()` to prevent row click
- Must appear on far right
- Must be visually smaller than row

Example:
```tsx
{
  accessor: 'status',
  title: 'Status',
  render: (item: any) => (
    <Switch
      checked={item.isActive}
      onClick={(e) => e.stopPropagation()}
      onChange={() => toggleStatus(item.id)}
    />
  ),
}
```

## ESLint Rule (Proposed)

Add to `.eslintrc.json`:

```json
{
  "rules": {
    "no-action-icons-in-tables": {
      "message": "Use onRowClick instead of ActionIcon buttons in tables. See docs/guides/table-crud-pattern.md"
    }
  }
}
```

## Component Library

Consider creating reusable wrapper:

```tsx
// src/core/components/patterns/CRUDTable.tsx
interface CRUDTableProps<T> {
  items: T[];
  columns: DataTableColumn<T>[];
  onEdit: (item: T) => void;
  onDelete?: (item: T) => void;
  loading?: boolean;
}

export function CRUDTable<T>({ items, columns, onEdit, loading }: CRUDTableProps<T>) {
  return (
    <DataTable
      records={items}
      fetching={loading}
      onRowClick={onEdit}
      style={{ cursor: 'pointer' }}
      columns={columns}
    />
  );
}
```

## Examples in Codebase

**Correct implementations:**
- `src/app/(platform)/platform/_components/FeatureSetsTab.tsx`
- `src/app/(platform)/platform/_components/ProductsTab.tsx`

**Historical anti-patterns (now fixed):**
- Early versions of FeatureSetsTab (had ActionIcon buttons)
- Early versions of ProductsTab (had ActionIcon buttons)

## Testing

Manual verification:
1. Click anywhere on row → Modal opens in edit mode ✓
2. No tiny icon buttons visible in table ✓
3. Delete button in modal footer, bottom-left ✓
4. Cursor changes to pointer on row hover ✓
5. Sortable headers are visible and clickable ✓
6. First click on header sorts ascending; second click sorts descending ✓
7. Active sort icon appears darker than inactive icon state ✓

## References

- **Authority:** `/docs/00-overview/isostack-ux-ui-standard.md` Section 7.1
- **Implementation:** See FeatureSetsTab.tsx and ProductsTab.tsx
- **Related:** Section 8.2 (CRUD Modal Rules), Section 7.3 (Inline Quick Actions)

## Enforcement Strategy

1. **Code Reviews** - Reviewer checks this document
2. **Component Templates** - Start from correct boilerplate
3. **AI Instructions** - Update system prompts to reference this guide
4. **ESLint** - Custom rule (when available)
5. **Pull Request Template** - Add UX compliance checklist

---

**Last Updated:** 11 June 2026  
**Maintained by:** Platform Team  
**Questions:** Refer to isostack-ux-ui-standard.md
