# Task 3.0: Update `app/_layout.tsx` — Geist fonts, QueryClientProvider, remove dark mode

## Overview

The central point of the baseline. Replaces SpaceMono with Geist in three weights, initializes `QueryClientProvider` before the Stack Navigator, and removes all dark mode infrastructure (ThemeProvider, useColorScheme). The splash screen behavior (wait for font + DB) is preserved.

**Dependency:** Task 1 (`@expo-google-fonts/geist` package installed).

<skills>
### Skills compliance

- `tanstack-query-best-practices` — `QueryClient` configuration and `QueryClientProvider` placement
- `vercel-react-native-skills` — font loading with `useFonts` and splash screen gate
</skills>

<requirements>

- `useFonts` loads `Geist_300Light`, `Geist_400Regular`, `Geist_500Medium` — SpaceMono removed
- `QueryClient` instantiated outside the component (avoids re-creation on each render)
- `QueryClientProvider` wraps the `Stack` (and any other inner provider)
- `ThemeProvider` from `@react-navigation/native` completely removed
- Imports of `DarkTheme`, `DefaultTheme`, `useColorScheme` removed
- Splash screen condition maintained: `fontsLoaded && dbReady` before `SplashScreen.hideAsync()`
- `fontError` continues to be thrown in `useEffect` (current behavior preserved)
- `useDatabaseMigrations` from `src/db/migrate.ts` is not touched

</requirements>

## Subtasks

- [ ] 3.1 Replace the `useFonts` import and add the three Geist weight imports from `@expo-google-fonts/geist`
- [ ] 3.2 Update the object passed to `useFonts` — remove `SpaceMono`, add `Geist_300Light`, `Geist_400Regular`, `Geist_500Medium`
- [ ] 3.3 Instantiate `QueryClient` outside the component (module level)
- [ ] 3.4 Remove `ThemeProvider`, `DarkTheme`, `DefaultTheme`, and the `useColorScheme` import
- [ ] 3.5 Wrap `<Stack>` with `<QueryClientProvider client={queryClient}>`
- [ ] 3.6 Simplify `RootLayoutNav` — remove the `colorScheme` reference and return `QueryClientProvider > Stack` directly

## Implementation details

See `techspec.md` § "Component Overview" (boot flow) and § "Key Decisions" (dark mode removed, QueryClient defaults).

Provider order in `RootLayoutNav`:
```
QueryClientProvider(client)
  └─ Stack
       └─ Stack.Screen name="(tabs)"
       └─ Stack.Screen name="modal"
```

`QueryClient` with TanStack Query defaults — no `staleTime` or `retry` customization in this baseline.

## Success criteria

- `npx expo start` without font or provider warnings in the Metro console
- Splash screen disappears only after DB migrated + fonts loaded
- Home screen displays Geist (verify visually — no longer generic monospace)
- A `useQuery({ queryKey: ['test'], queryFn: () => null })` in any screen does not throw "No QueryClient set"

## Task tests

> This baseline does not include `.test.tsx` files (see PRD § "Out of Scope").

- [ ] **Simulator check:** open the app and confirm Geist typography on the Collection screen
- [ ] **Provider check:** temporarily add `useQuery({ queryKey: ['x'], queryFn: () => 'ok' })` in `app/(tabs)/index.tsx` and confirm it does not throw
- [ ] **Splash check:** kill and reopen the app — splash disappears only after full boot (DB + font)

## Relevant files

**Modify:**
- `app/_layout.tsx`

**Consult (do not modify):**
- `src/db/migrate.ts` — `useDatabaseMigrations` hook (preserved)
- `package.json` — confirm `@expo-google-fonts/geist` is already installed (Task 1)
