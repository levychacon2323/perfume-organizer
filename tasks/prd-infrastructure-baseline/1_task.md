# Task 1.0: Install `@expo-google-fonts/geist` and fix `tailwind.config.js`

## Overview

Installs the Geist font package and updates `tailwind.config.js` with the exact color tokens from DESIGN.md, the Geist type family in the three design system weights, and the `letterSpacing` tokens. This is the foundational step — no screen can be visually validated before this task.

<skills>
### Skills compliance

No external skill applies directly (pure configuration, no React Native components).
</skills>

<requirements>

- `@expo-google-fonts/geist` installed as a dependency
- `tailwind.config.js` with semantic color tokens identical to DESIGN.md
- Named palette (`ink`, `paper`, `bone`, `stone`, `ash`, `vermilion`) available as aliases
- `fontFamily` configured with three Geist weights: `light`, `sans`, `medium`
- Design system `letterSpacing` tokens added: `tightest`, `tighter`, `tight`, `label`
- Template's `fontFamily.sans: ['System']` removed
- Warm-brown values `#FAF7F2` and `#1A1410` eliminated from config

</requirements>

## Subtasks

- [ ] 1.1 Install `@expo-google-fonts/geist` via `pnpm add @expo-google-fonts/geist`
- [ ] 1.2 Update `colors` in `tailwind.config.js` — semantic tokens + named palette (see techspec.md § "Key Interfaces")
- [ ] 1.3 Update `fontFamily` — replace `['System']` with `{ light, sans, medium }` mapping to Expo-registered names
- [ ] 1.4 Add `letterSpacing` — `tightest`, `tighter`, `tight`, `label` per DESIGN.md
- [ ] 1.5 Verify no warm-brown value (`#FAF7F2`, `#1A1410`, `#F0EAE0`, `#6B5D52`, `#E0D6C8`, `#B23A48`) remains in the file

## Implementation details

See `techspec.md` § "Key Interfaces" (tailwind.config.js block) and § "Key Decisions" (fontFamily NativeWind).

Important: `fontFamily.light` and `fontFamily.medium` intentionally override Tailwind's font-weight utilities — correct for React Native/NativeWind where standalone font-weight doesn't work.

## Success criteria

- `grep -E "#FAF7F2|#1A1410|#F0EAE0|#B23A48|System" tailwind.config.js` returns empty
- Every hex in `tailwind.config.js` matches the corresponding value in `DESIGN.md`
- `npx expo start` does not break after package installation

## Task tests

> This baseline does not include `.test.tsx` files (see PRD § "Out of Scope").

- [ ] **Visual check:** open any screen in the simulator and confirm `bg-background` shows `#FFFFFF` (not warm-white)
- [ ] **Package check:** `cat package.json | grep geist` confirms the installed dependency
- [ ] **Config check:** manual diff between `tailwind.config.js` and the color table in `DESIGN.md`

## Relevant files

**Install:**
- `@expo-google-fonts/geist` (new dependency in `package.json`)

**Modify:**
- `tailwind.config.js`
