# Task 5.0: Remove Expo template residues and clean `app/modal.tsx`

## Overview

Removes the 10 Expo template files that use legacy patterns (hardcoded StyleSheet, Colors.ts, dark mode), replaces `app/modal.tsx` with a NativeWind placeholder, and verifies that zero broken imports remain after the cleanup.

**Dependency:** Tasks 3 and 4 completed — `_layout.tsx` and `(tabs)/_layout.tsx` must no longer import any of the files to be deleted before this task.

<skills>
### Skills compliance

No external skill applies (file deletion and import cleanup).
</skills>

<requirements>

- None of the 10 listed files exist after the task
- `app/modal.tsx` replaced by a NativeWind placeholder (no `StyleSheet`, no `Themed`, no `EditScreenInfo`)
- Zero broken imports in any file under `app/` or `src/`
- `src/shared/components/` contains only components that follow NativeWind

</requirements>

## Subtasks

- [ ] 5.1 **Verify dependencies before deleting** — run the safety greps below to confirm no file outside the list still imports the files to remove
- [ ] 5.2 Delete `app/(tabs)/two.tsx`
- [ ] 5.3 Delete `src/shared/components/EditScreenInfo.tsx`
- [ ] 5.4 Delete `src/shared/components/Themed.tsx`
- [ ] 5.5 Delete `src/shared/components/StyledText.tsx`
- [ ] 5.6 Delete `src/shared/components/ExternalLink.tsx`
- [ ] 5.7 Delete `src/lib/Colors.ts`
- [ ] 5.8 Delete `src/shared/hooks/useColorScheme.ts` and `useColorScheme.web.ts`
- [ ] 5.9 Delete `src/shared/hooks/useClientOnlyValue.ts` and `useClientOnlyValue.web.ts`
- [ ] 5.10 Replace `app/modal.tsx` with a minimal NativeWind placeholder (label "Modal", `bg-background`, no `StyleSheet`)

## Implementation details

See `techspec.md` § "Relevant and Dependent Files" (full delete list) and § "Known Risks" (recommended safety greps).

**Safety greps to run before each deletion:**
```bash
grep -r "from '@/lib/Colors'" app/ src/
grep -r "from '@/shared/components/Themed'" app/ src/
grep -r "from '@/shared/components/EditScreenInfo'" app/ src/
grep -r "from '@/shared/components/ExternalLink'" app/ src/
grep -r "from '@/shared/hooks/useColorScheme'" app/ src/
grep -r "from '@/shared/hooks/useClientOnlyValue'" app/ src/
```
Each grep must return empty before deleting the corresponding file.

**Placeholder for `app/modal.tsx`:**
```tsx
// flex-1 bg-background centered View
// "Modal" label in text-primary
// No custom StatusBar, no StyleSheet
```

**`app/(tabs)/two.tsx`** has no registered route after Task 4 — can be deleted without navigation impact.

## Success criteria

- `find src/ app/ -name "Colors.ts" -o -name "Themed.tsx" -o -name "EditScreenInfo.tsx" -o -name "StyledText.tsx" -o -name "ExternalLink.tsx"` returns empty
- `find src/shared/hooks -name "useColorScheme*" -o -name "useClientOnlyValue*"` returns empty
- `npx expo start` without errors after cleanup
- `grep -r "StyleSheet" app/modal.tsx` returns empty

## Task tests

> This baseline does not include `.test.tsx` files (see PRD § "Out of Scope").

- [ ] **Absence check:** `find src/ app/ -name "two.tsx" -o -name "EditScreenInfo.tsx" -o -name "Themed.tsx"` returns empty
- [ ] **Import check:** `grep -rn "Colors\|EditScreenInfo\|Themed\|StyledText\|ExternalLink\|useClientOnlyValue" app/ src/` returns empty
- [ ] **Simulator check:** open the app and navigate the 3 tabs — no crashes or blank screens

## Relevant files

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

**Modify:**
- `app/modal.tsx` — replaced by NativeWind placeholder
