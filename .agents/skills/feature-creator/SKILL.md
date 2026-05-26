---
name: feature-creator
description: Scaffolds a new feature module under src/features/<name>/ with the standard folder structure (components, hooks, screens, schemas, index.ts). Use when the user says "create a feature for X", "add a new module", or wants to scaffold a feature.
metadata:
  tags: expo, react-native, architecture, feature, scaffold
---

# Feature Creator

## Overview

Generates the standard feature folder structure for this project. All features follow a public API pattern through `index.ts`.

## When to Apply

- User says "create a feature for X"
- User says "add a new module"
- User wants to scaffold a feature folder structure

## Steps

1. Confirm feature name with user (kebab-case)
2. Create folder structure under `src/features/<name>/`:
   - `components/`
   - `hooks/`
   - `screens/`
   - `schemas/`
   - `index.ts` (with header comment explaining feature scope)
3. Create placeholder `index.ts` exporting nothing yet, with comment listing what will be exported
4. If the feature needs DB access, remind user to create repositories in `src/db/repositories/`
5. Confirm structure created and ask what to build first

## Conventions

- Feature folder uses kebab-case
- All exports go through `index.ts` (public API)
- Internal files (utils, types) stay private to the feature
- Screens are imported into `app/` routes, never the other way around

## index.ts Template

```typescript
// <feature-name> feature
// Exports: (list what will be exported here)
```

## Anti-patterns to Avoid

- Don't create features without `index.ts`
- Don't create deeply nested folders inside features
- Don't import from another feature's internals (only from its `index.ts`)
