# Task 4.0: Implement final navigation — Collection / Catalog / Wishlist tabs

## Overview

Replaces the generic template tabs ("Tab One", "Tab Two") with the three real product sections. Each tab gets a minimal NativeWind placeholder screen. Removes all dependencies on `Colors`, `useColorScheme`, and `useClientOnlyValue` from the tab layout.

**Dependency:** Task 1 (Tailwind tokens corrected, so `bg-background` works correctly in placeholders).

<skills>
### Skills compliance

- `vercel-react-native-skills` — navigation patterns with Expo Router and tab navigator
</skills>

<requirements>

- `app/(tabs)/_layout.tsx` defines exactly 3 tabs: Collection, Catalog, Wishlist
- No imports of `Colors`, `useColorScheme`, or `useClientOnlyValue` in `_layout.tsx`
- `tabBarActiveTintColor` uses a fixed design system value (ink = `#1A1A1A`) — no `colorScheme` reference
- Each tab has an icon via `expo-symbols` (`SymbolView`) with `ios`/`android` variants
- `headerShown` is a static value (without `useClientOnlyValue`) — `false` for mobile-first app
- Placeholder screens use only NativeWind (`className`) — zero `StyleSheet`
- Placeholders display the section label in `text-primary` on `bg-background`

</requirements>

## Subtasks

- [ ] 4.1 Rewrite `app/(tabs)/_layout.tsx`:
  - Remove imports of `Colors`, `useColorScheme`, `useClientOnlyValue`, `Link`, `Pressable`
  - Set `tabBarActiveTintColor: '#1A1A1A'` (ink) as a fixed value
  - Register 3 `Tabs.Screen`: `index` (Collection), `catalogo` (Catalog), `wishlist` (Wishlist)
  - Icons: Collection → `house`/`home`, Catalog → `magnifyingglass`/`search`, Wishlist → `heart`/`favorite`
- [ ] 4.2 Update `app/(tabs)/index.tsx` — replace current content with Collection placeholder
- [ ] 4.3 Create `app/(tabs)/catalogo.tsx` — Catalog placeholder
- [ ] 4.4 Create `app/(tabs)/wishlist.tsx` — Wishlist placeholder

**Each placeholder structure:**
```tsx
// flex-1 bg-background View, centered
// text-primary Text with section name
// No StyleSheet, no Text/View from Themed
```

## Implementation details

See `techspec.md` § "Component Overview" (modified/created components table) and § "Rules Compliance" (feature-architecture and styling).

`headerShown: false` — headers are managed by the Stack Navigator in `_layout.tsx`, not by the tabs.

The `Link` to `/modal` and the info button in Tab One's header are removed in this baseline (template). They can be reintroduced in specific features.

## Success criteria

- Navigate between Collection, Catalog, and Wishlist in the simulator without errors
- Correct icon and label on each tab
- Active tab shows ink tintColor (`#1A1A1A`)
- `grep -r "Colors\|useColorScheme\|useClientOnlyValue" app/(tabs)/_layout.tsx` returns empty
- No `StyleSheet` in the 3 placeholder files

## Task tests

> This baseline does not include `.test.tsx` files (see PRD § "Out of Scope").

- [ ] **iOS simulator check:** navigate between 3 tabs; confirm correct label, icon, and tintColor
- [ ] **Android simulator check:** repeat navigation; confirm Android icons (`home`, `search`, `favorite`)
- [ ] **Import check:** `grep -rn "Colors\|useClientOnlyValue\|useColorScheme" app/\(tabs\)/` returns empty

## Relevant files

**Modify:**
- `app/(tabs)/_layout.tsx`
- `app/(tabs)/index.tsx`

**Create:**
- `app/(tabs)/catalogo.tsx`
- `app/(tabs)/wishlist.tsx`
