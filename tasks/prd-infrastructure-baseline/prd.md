# Product Requirements Document (PRD)
## Infrastructure Baseline — Perfume Organizer

## Overview

The Perfume Organizer has a working build infrastructure (Expo 54, Drizzle,
NativeWind v4, active migrations), but has gaps that block the development of
any product feature: the design system font is not installed, the cache/query
provider has not been initialized, the color tokens diverge from DESIGN.md, and
Expo template residues pollute the codebase.

This feature resolves these blockers before any product feature is built,
ensuring that the Design System, Catalog, and collection features start from a
correct and consistent base — no rework on color, typography, or provider
architecture.

---

## Goals

- The app runs without runtime errors related to missing providers (TanStack Query)
- Geist typography (weights 300/400/500) loads and displays correctly on all screens
- All color tokens in `tailwind.config.js` match DESIGN.md exactly
- The final navigation structure (definitive tabs) is implemented, even with placeholder screens
- No Expo template code files remain in the project
- `src/lib/` has `theme.ts`, `env.ts`, and `constants.ts` with useful initial content

**Measurable success criteria:**
- `npx expo start` runs without provider or font warnings
- Every color token in `tailwind.config.js` matches the corresponding hex in DESIGN.md
- Zero Expo template files in `app/`, `src/shared/`, and `src/lib/` directories
- Tab structure reflects the real product sections

---

## User Stories

**Developer implementing product features:**
- As a developer, I want to use `useQuery()` in any component without configuring additional providers, so that TanStack Query features work immediately.
- As a developer, I want to apply `className="bg-primary text-foreground"` and get the exact colors from DESIGN.md, so that design system components are visually correct from the start.
- As a developer, I want to import from `src/lib/constants` and get typed app constants, so I don't use magic strings scattered throughout the code.
- As a developer, I want the codebase to not contain Expo template components (Themed.tsx, EditScreenInfo.tsx), so I don't inherit legacy patterns when creating new components.

**User opening the app:**
- As a user, I want to see the correct typography (Geist) when opening the app, not a generic monospace font.
- As a user, I want to navigate between the main sections of the app using tabs, even if the content of each tab is temporary.

---

## Key Features

### RF-01 — Geist font installation and loading

The app loads `@expo-google-fonts/geist` with the three design system weights:
Geist_300Light, Geist_400Regular, and Geist_500Medium. The font is registered in
`_layout.tsx` via `useFonts()`. `tailwind.config.js` switches to using Geist as
`fontFamily.sans`. SpaceMono is removed.

**Why:** Geist is the design system font (DESIGN.md). Without it, all future
typography will be wrong by default.

**Functional requirements:**
1. `@expo-google-fonts/geist` installed as a dependency
2. Three weights loaded in the root layout: Light (300), Regular (400), Medium (500)
3. `fontFamily.sans` in `tailwind.config.js` points to Geist
4. SpaceMono removed from loaded assets and configuration

---

### RF-02 — QueryClientProvider initialization

TanStack Query gets a configured `QueryClient` and a `QueryClientProvider`
wrapping the app in `_layout.tsx`, before the Stack Navigator.

**Why:** Any `useQuery()` or `useMutation()` hook fails at runtime without the
provider. It is a blocker for any feature that uses remote data or cache.

**Functional requirements:**
5. `QueryClient` instantiated with suitable default settings for mobile
6. `QueryClientProvider` wraps the app before the Stack Navigator in `_layout.tsx`
7. Provider initialized before the first render of product screens

---

### RF-03 — Color token alignment with DESIGN.md

`tailwind.config.js` is updated to use the exact hex values from DESIGN.md.
The semantic tokens (primary, background, muted, border, destructive) are kept,
and the palette tokens (ink, paper, bone, stone, ash, vermilion) are added as
aliases for explicit use.

**Why:** The current tailwind.config.js has warm-brown values (#FAF7F2, #1A1410)
that differ from the design system (neutrals: #FFFFFF, #1A1A1A). Any component
built before the fix will have incorrect colors.

**Functional requirements:**
8. `background`: `#FFFFFF` (paper)
9. `foreground` and `primary.DEFAULT`: `#1A1A1A` (ink)
10. `muted.DEFAULT`: `#F5F5F2` (bone)
11. `muted-foreground`: `#6B6B66` (stone)
12. `border`: `#D4D2CC` (ash)
13. `destructive.DEFAULT`: `#8B3A2F` (vermilion)
14. Palette aliases available: `ink`, `paper`, `bone`, `stone`, `ash`, `vermilion`

---

### RF-04 — Creation of `src/lib/`

Three files with useful initial content, not empty stubs:

- `theme.ts` — TypeScript constants mirroring the color tokens from tailwind.config.js, for use in StyleSheet when className is not sufficient
- `env.ts` — typed environment variables with safe default values
- `constants.ts` — global constants (database name, app version, timeouts)

**Why:** Avoids magic strings and hardcoded values scattered throughout feature code.

**Functional requirements:**
15. `theme.ts` exports a color object compatible with StyleSheet
16. `env.ts` exports typed variables with Expo Constants
17. `constants.ts` exports at least `DATABASE_NAME` and `APP_NAME`

---

### RF-05 — Expo template residue removal

Expo template files are removed. Orphaned imports are cleaned up.

**Files to remove:**
- `app/(tabs)/two.tsx`
- `src/shared/components/EditScreenInfo.tsx`
- `src/shared/components/Themed.tsx`
- `src/shared/components/StyledText.tsx`
- `src/lib/Colors.ts`
- `src/shared/components/ExternalLink.tsx` (no real usage in the project)

**Why:** These files use legacy patterns (hardcoded StyleSheet, Colors.ts)
incompatible with NativeWind/cva. Keeping them creates confusion about which
pattern to follow.

**Functional requirements:**
18. None of the listed files exist after the feature
19. No broken imports after removal
20. `src/shared/components/` contains only components that follow NativeWind

---

### RF-06 — Final navigation structure

The tab structure is redesigned to reflect the real product sections,
replacing the generic template ("Tab One", "Tab Two"). Each tab gets a
minimal placeholder screen in NativeWind (not Expo template), with a label
indicating the feature under development.

**Expected sections** (confirmed during clarification): Collection, Catalog, Wishlist.

**Why:** The navigation structure is the foundation for all features. Defining it
now avoids route refactoring when each feature launches.

**Functional requirements:**
21. `app/(tabs)/_layout.tsx` defines the real product tabs (not "Tab One/Two")
22. Each tab has its route file in `app/(tabs)/`
23. Placeholder screens use NativeWind (`className="flex-1 bg-background"`) without StyleSheet
24. `app/(tabs)/two.tsx` removed (replaced by the definitive routes)

---

## User Experience

**Primary persona:** Developer implementing Perfume Organizer features.
Need: clean base, correct patterns, no template inheritance.

**Secondary persona:** End user in early builds. Need: app that opens and
navigates without errors or strange typography.

**Main flow:**
`Open app → Splash screen → DB migrated → Screens with Geist, correct DESIGN.md colors, definitive tabs`

**UX constraints:**
- Placeholder screens must be austere: `bg-background` + section label in `text-primary`
- No placeholder screen should look like an error state
- The splash screen is only hidden when both font + DB are ready (current `_layout.tsx` behavior maintained)

---

## High-Level Technical Constraints

- Expo SDK 54 managed — Geist font via `@expo-google-fonts/geist`, not self-hosted
- NativeWind v4 — `tailwind.config.js` is the single source of truth for color and typography tokens
- `src/db/` is not touched — existing migrations and schema are fully preserved
- TypeScript strict maintained — new files in `src/lib/` follow strict mode

---

## Out of Scope

- `src/db/repositories/` — handled in each product feature's PRD
- Design system components (Button, Input, Card, Tag, Rating) — separate PRD
- `src/catalog/` (perfumes.json, Zustand store, Fuse.js search) — separate PRD
- Product features (Collection, Perfume, WearSession, etc.) — separate PRDs
- Unit or integration tests — no `.test.tsx` files in this baseline
- Feature Zustand stores — initialized in each feature's PRD
- Custom animations, gestures, or navigation transitions
