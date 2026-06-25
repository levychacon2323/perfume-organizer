# Task 2.0: Create `src/lib/` — `theme.ts`, `env.ts`, and `constants.ts`

## Overview

Creates the three infrastructure files in `src/lib/` that eliminate magic strings and hardcoded values from feature code. Can be done in parallel with Task 1 — no external dependencies.

<skills>
### Skills compliance

No external skill applies (pure TypeScript configuration files).
</skills>

<requirements>

- `src/lib/theme.ts` exports a color object compatible with `StyleSheet.create()`, mirroring the semantic tokens from `tailwind.config.js`
- `src/lib/env.ts` exports typed environment variables via `expo-constants`, with safe fallbacks
- `src/lib/constants.ts` exports at least `DATABASE_NAME`, `APP_NAME`, and `QUERY_STALE_TIME`
- All files follow TypeScript strict mode (no `any`)
- No hardcoded hex values in the files — only re-export/map the tokens

</requirements>

## Subtasks

- [ ] 2.1 Create `src/lib/theme.ts` — flat color object with the same semantic tokens as Tailwind, for use in `style={{ color: theme.colors.foreground }}` when `className` is not sufficient
- [ ] 2.2 Create `src/lib/env.ts` — import `Constants` from `expo-constants` and export `env` with `appVersion`, `isDev`, and fields expandable for Phase 2
- [ ] 2.3 Create `src/lib/constants.ts` — export `DATABASE_NAME` (SQLite filename), `APP_NAME`, `QUERY_STALE_TIME` (ms)

## Implementation details

See `techspec.md` § "Key Interfaces" (`theme.ts`, `env.ts`, `constants.ts` blocks).

`DATABASE_NAME` should match the value currently hardcoded in `src/db/index.ts` — verify before creating.

## Success criteria

- `tsc --noEmit` passes without errors on the three new files
- Importing `DATABASE_NAME` from `src/lib/constants` in another TypeScript file works with correct typing
- `theme.colors.background` returns `'#FFFFFF'`

## Task tests

> This baseline does not include `.test.tsx` files (see PRD § "Out of Scope").

- [ ] **Type check:** `npx tsc --noEmit` without errors
- [ ] **Import check:** temporarily add `console.log(env.isDev)` in `_layout.tsx` and confirm Metro reports no type error

## Relevant files

**Create:**
- `src/lib/theme.ts`
- `src/lib/env.ts`
- `src/lib/constants.ts`

**Consult (do not modify):**
- `src/db/index.ts` — verify the current database name to use in `DATABASE_NAME`
- `tailwind.config.js` — color tokens to mirror in `theme.ts`
