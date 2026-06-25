# Technical Specification
## Infrastructure Baseline — Perfume Organizer

---

## Executive Summary

The baseline is a set of six coordinated change groups that produce no new visible features, but eliminate all blockers for product development. The work is concentrated in three integration points: `app/_layout.tsx` (providers and fonts), `tailwind.config.js` (visual tokens), and `src/lib/` (typed constants). No Drizzle tables are created or altered. The only new dependency is `@expo-google-fonts/geist`.

The implementation strategy is outside-in: Tailwind config and `src/lib/` first (no risk of breaking the app), then `_layout.tsx` (font replacement + QueryClientProvider + dark mode removal), then the definitive tabs, and finally the cleanup — ensuring the app is testable at each step.

---

## System Architecture

### Component Overview

**Modified components:**

| File | Change |
|---|---|
| `app/_layout.tsx` | Replaces `SpaceMono` with Geist (3 weights), adds `QueryClientProvider`, removes `ThemeProvider`/`useColorScheme` |
| `app/(tabs)/_layout.tsx` | Definitive tabs (Collection, Catalog, Wishlist), removes `Colors`/`useColorScheme`/`useClientOnlyValue` |
| `app/(tabs)/index.tsx` | Collection NativeWind placeholder |
| `app/modal.tsx` | Replaced by NativeWind placeholder (removes `Themed` and `EditScreenInfo`) |
| `tailwind.config.js` | Corrected color tokens, Geist `fontFamily`, design system `letterSpacing` |

**Created components:**

| File | Responsibility |
|---|---|
| `app/(tabs)/catalogo.tsx` | Catalog placeholder screen |
| `app/(tabs)/wishlist.tsx` | Wishlist placeholder screen |
| `src/lib/theme.ts` | TypeScript color object for use in `StyleSheet` |
| `src/lib/env.ts` | Typed environment variables via `expo-constants` |
| `src/lib/constants.ts` | Global constants (`DATABASE_NAME`, `APP_NAME`, timeouts) |

**Deleted components:**

| File | Reason |
|---|---|
| `app/(tabs)/two.tsx` | Template — replaced by definitive routes |
| `src/shared/components/EditScreenInfo.tsx` | Template — legacy `StyleSheet` + `Colors.ts` patterns |
| `src/shared/components/Themed.tsx` | Template — `Text`/`View` components with hardcoded dark mode |
| `src/shared/components/StyledText.tsx` | Template — depends on `Themed` and `SpaceMono` |
| `src/shared/components/ExternalLink.tsx` | No real usage after `EditScreenInfo` removal |
| `src/lib/Colors.ts` | Template — replaced by `src/lib/theme.ts` and Tailwind tokens |
| `src/shared/hooks/useColorScheme.ts` + `.web.ts` | Dark mode removed from baseline |
| `src/shared/hooks/useClientOnlyValue.ts` + `.web.ts` | Web workaround not needed for mobile-first app |

**Boot data flow (after baseline):**

```
[App opens] → SplashScreen.preventAutoHideAsync()
  → useFonts({ Geist_300Light, Geist_400Regular, Geist_500Medium })
  → useDatabaseMigrations()   ← src/db/migrate.ts (unchanged)
  → both ready → SplashScreen.hideAsync()
  → QueryClientProvider > Stack > (tabs)
```

---

## Implementation Design

### Key Interfaces

**`app/_layout.tsx` — structure after changes:**
```ts
// Nested providers (outer → inner):
// QueryClientProvider(client) > Stack Navigator
// No ThemeProvider — app is always-light
// useFonts loads the 3 Geist weights; SpaceMono removed
// Splash condition: fontsLoaded && dbReady
```

**`tailwind.config.js` — relevant sections:**
```js
colors: {
  // Named palette (direct aliases)
  ink: '#1A1A1A', paper: '#FFFFFF', bone: '#F5F5F2',
  stone: '#6B6B66', ash: '#D4D2CC', vermilion: '#8B3A2F',
  // Semantic tokens
  background: '#FFFFFF',        // paper
  foreground: '#1A1A1A',        // ink
  primary: { DEFAULT: '#1A1A1A', foreground: '#FFFFFF' },
  muted: { DEFAULT: '#F5F5F2', foreground: '#6B6B66' },
  border: '#D4D2CC',            // ash
  destructive: { DEFAULT: '#8B3A2F', foreground: '#FFFFFF' },
},
fontFamily: {
  light:  ['Geist_300Light'],   // → className="font-light"
  sans:   ['Geist_400Regular'], // → className="font-sans" (default)
  medium: ['Geist_500Medium'],  // → className="font-medium"
},
letterSpacing: {
  tightest: '-0.04em', // display
  tighter:  '-0.02em', // heading
  tight:    '-0.015em',// subheading
  label:    '0.2em',   // ALL CAPS labels
},
```

**`src/lib/theme.ts` — interface:**
```ts
// Flat color object compatible with StyleSheet.create()
// Mirrors the semantic tokens from tailwind.config.js
// Usage: when className is not sufficient (e.g. dynamic style prop)
export const colors: Record<string, string>
export const theme = { colors }
```

**`src/lib/env.ts` — interface:**
```ts
// Typed variables with safe fallbacks
// Source: expo-constants (Constants.expoConfig)
export const env = {
  appVersion: string,
  isDev: boolean,
  // expand as needed for Phase 2 (backend URL, etc.)
}
```

**`src/lib/constants.ts` — interface:**
```ts
export const DATABASE_NAME: string   // SQLite filename
export const APP_NAME: string
export const QUERY_STALE_TIME: number // ms
```

### Data Models

No Drizzle entities are created or altered. `src/db/schema.ts`, `src/db/index.ts`, and `src/db/migrate.ts` remain untouched.

### API Endpoints

Not applicable — local infrastructure only, no network calls in this baseline.

---

## Integration Points

**`@expo-google-fonts/geist` (new package):**
- Install via `pnpm add @expo-google-fonts/geist`
- The package registers fonts as Expo assets automatically; no additional `expo install` needed
- Three exports consumed: `Geist_300Light`, `Geist_400Regular`, `Geist_500Medium`
- `useFonts` from `expo-font` (already installed) loads the three; returns `[loaded, error]`

**No other external integrations.** TanStack Query (`@tanstack/react-query`) is already in `package.json` — only the `QueryClientProvider` needs to be initialized.

---

## Testing Approach

The PRD explicitly states that **no `.test.tsx` files** are created in this baseline. Verification is manual:

### Manual Verification (PRD criteria)

| Criterion | How to verify |
|---|---|
| `npx expo start` without provider or font warnings | Metro Bundler console |
| Geist visible on screens | Visual inspection of any placeholder screen |
| Correct color tokens | Compare `tailwind.config.js` vs DESIGN.md hex by hex |
| Zero template files | `find src/ app/ -name "*.tsx" -o -name "*.ts"` |
| Definitive tabs | Navigate between the 3 tabs in the simulator |

### Unit Tests

Not applicable in this baseline.

### Integration Tests

Not applicable in this baseline.

### E2E Tests

Not applicable in this baseline. Maestro will be introduced in product feature PRDs.

---

## Development Sequencing

### Build Order

1. **Install `@expo-google-fonts/geist`** — blocker for RF-01 and for any typography validation
2. **Update `tailwind.config.js`** (RF-03 + letterSpacing) — no dependencies, validates tokens immediately with hot reload
3. **Create `src/lib/`** (RF-04: `theme.ts`, `env.ts`, `constants.ts`) — no dependencies, can be done in parallel with (2)
4. **Update `app/_layout.tsx`** (RF-01 fonts + RF-02 QueryClientProvider + dark mode removal) — depends on (1)
5. **Implement definitive tabs** (RF-06: `(tabs)/_layout.tsx` + placeholder routes) — depends on (2) to use correct tokens
6. **Remove template residues** (RF-05) — last, after (4) and (5) no longer depend on the legacy files

### Technical Dependencies

- `@expo-google-fonts/geist` must be installed before any changes to `_layout.tsx`
- `app/(tabs)/two.tsx` can only be removed after `(tabs)/_layout.tsx` no longer references the `two` route
- `src/shared/hooks/useColorScheme.ts` can only be removed after `(tabs)/_layout.tsx` and `_layout.tsx` no longer import it

---

## Monitoring and Observability

**During development:**
- Metro Bundler console: font-not-loaded warnings appear immediately
- React Query Devtools not installed in this baseline (optionally add in a future PRD)
- `npx expo-doctor` validates version compatibility after Geist package installation

**Token debugging:**
- `pnpm run db:studio` is unaffected (DB infrastructure unchanged)
- To validate colors: open any placeholder screen in the simulator with Expo's UI inspector

---

## Technical Considerations

### Key Decisions

**fontFamily in Tailwind: `light`/`sans`/`medium` names**

Tailwind has `font-weight` utilities (`font-light`, `font-medium`) and `font-family` utilities (`font-{key}`). In React Native, font-weight as a CSS property is ignored — each weight requires the registered font file. By defining `fontFamily.light`, `fontFamily.sans`, `fontFamily.medium` in `tailwind.config.js`, the generated utilities (`font-light`, `font-sans`, `font-medium`) map to `fontFamily: 'Geist_300Light'` etc., aligning with the DESIGN.md pattern. The name collision with font-weight is intentional in the React Native/NativeWind context, where standalone font-weight doesn't work.

**Dark mode completely removed**

DESIGN.md defines an exclusively light visual system (paper/ink). `ThemeProvider` from `@react-navigation/native`, `useColorScheme`, and `useClientOnlyValue` are Expo template residues, not product decisions. Removing them now prevents future features from inheriting the pattern. Reverting, if needed, requires a dedicated dark mode baseline with tokens defined in DESIGN.md.

**QueryClient with TanStack Query defaults**

In Phase 1 (offline-first), `useQuery` will be used for derived/computed data, without network calls. TanStack Query defaults (`staleTime: 0`, `retry: 3`, `gcTime: 5min`) are adequate. Default customization is deferred until real endpoints exist (Phase 2).

**letterSpacing in the baseline**

Included to prevent any text component created before the design system PRD from needing hardcoded values. The cost is zero (just lines in `tailwind.config.js`); the benefit is that `tracking-tightest`, `tracking-label`, etc. work from the very first component.

**`muted` as `{ DEFAULT, foreground }` object**

Allows `bg-muted` (surface) and `text-muted-foreground` (text on surface), following the same pattern as `primary` and `destructive`. The current config had `muted` and `muted-foreground` as separate keys — unified to an object.

### Known Risks

| Risk | Mitigation |
|---|---|
| `@expo-google-fonts/geist` incompatible with Expo SDK 54 | Verify with `npx expo install --check` after installation |
| Splash screen never hides if `useFonts` fails silently | `fontError` already throws in `useEffect` — keep this behavior |
| Deleted files still imported somewhere not listed | `grep -r "from '@/lib/Colors'" src/ app/` before deleting each file |
| `app/modal.tsx` uses `StyleSheet` — missed in cleanup | Modal is in RF-05 scope, replaced by NativeWind placeholder |

### Rules Compliance

| Rule | Application |
|---|---|
| `naming.md` | Routes in kebab-case (`catalogo.tsx`, `wishlist.tsx`); lib files in camelCase |
| `styling.md` | Semantic tokens in Tailwind; no hardcoded hex in components; `rounded-none` on placeholders |
| `feature-architecture.md` | `app/` stays thin (imports only); no business logic in routes |
| `state-management.md` | `QueryClientProvider` before Stack; `useLiveQuery` for Drizzle data (unchanged) |
| `database.md` | `src/db/` untouched; `DATABASE_NAME` exported from `constants.ts` to avoid magic string |

### Skills Compliance

No external skills apply directly to this baseline (no components, no tests, no animations, no lists). Skills will be activated in feature PRDs.

### Relevant and Dependent Files

**Create:**
- `app/(tabs)/catalogo.tsx`
- `app/(tabs)/wishlist.tsx`
- `src/lib/theme.ts`
- `src/lib/env.ts`
- `src/lib/constants.ts`

**Modify:**
- `app/_layout.tsx`
- `app/(tabs)/_layout.tsx`
- `app/(tabs)/index.tsx`
- `app/modal.tsx`
- `tailwind.config.js`

**Delete:**
- `app/(tabs)/two.tsx`
- `src/shared/components/EditScreenInfo.tsx`
- `src/shared/components/Themed.tsx`
- `src/shared/components/StyledText.tsx`
- `src/shared/components/ExternalLink.tsx`
- `src/lib/Colors.ts`
- `src/shared/hooks/useColorScheme.ts`
- `src/shared/hooks/useColorScheme.web.ts`
- `src/shared/hooks/useClientOnlyValue.ts`
- `src/shared/hooks/useClientOnlyValue.web.ts`

**Unchanged (do not touch):**
- `src/db/` (schema, index, migrate, drizzle/)
- `assets/fonts/SpaceMono-Regular.ttf` (asset can stay; only remove from `useFonts`)
- `app/+not-found.tsx`, `app/+html.tsx`
- `drizzle.config.ts`, `metro.config.js`, `babel.config.js`
