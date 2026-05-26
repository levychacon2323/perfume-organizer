# Perfume Organizer — Project Context

Personal project to organize a perfume collection. Built as portfolio piece while
returning to the market at mid-to-senior React Native level. Offline-first now,
sync-ready for future Nest.js backend (Phase 2).

## Stack

- **Runtime:** Expo (managed workflow) + Expo Router (file-based routing)
- **Language:** TypeScript (strict mode)
- **Database:** WatermelonDB (offline-first local DB, sync-ready)
- **State:** Zustand (client/UI state) + TanStack Query (cache/mutations/derived data)
- **Forms:** react-hook-form + zod (always together)
- **Styling:** NativeWind v4 (Tailwind for RN) + cva (class-variance-authority) for variants
- **Images:** expo-image (caching + performance)
- **Catalog search:** Fuse.js (fuzzy search on in-memory JSON)
- **Dates:** date-fns

## Architecture

Feature-based architecture. Each feature is self-contained under `src/features/`.

```
src/
├── app/                  # Expo Router routes (thin, only imports screens)
├── features/             # Self-contained feature modules
│   └── <feature>/
│       ├── components/   # Feature-specific components
│       ├── hooks/        # Feature-specific hooks
│       ├── screens/      # Screen components
│       ├── schemas/      # Zod schemas
│       └── index.ts      # PUBLIC API of the feature (only entry point)
├── shared/
│   ├── ui/               # Design system primitives (Button, Input, Card, etc)
│   ├── components/       # Shared non-UI components (EmptyState, ErrorBoundary)
│   ├── hooks/            # Cross-cutting hooks (useTheme, useDebounce)
│   ├── utils/            # Pure utility functions
│   └── types/            # Cross-cutting types
├── catalog/              # Bundled perfume catalog (read-only, in-memory)
│   ├── data/             # perfumes.json (curated)
│   ├── types.ts
│   ├── schema.ts         # Zod validation for catalog entries
│   ├── store.ts          # Zustand store loading catalog on init
│   ├── search.ts         # Fuse.js setup
│   └── index.ts
├── db/                   # WatermelonDB (user data, mutable)
│   ├── models/           # Model classes with decorators
│   ├── repositories/     # Data access abstraction (Nest migration friendly)
│   ├── migrations/
│   ├── schema.ts
│   └── index.ts          # Database instance
└── lib/                  # Global config
    ├── theme.ts          # Theme tokens
    ├── env.ts            # Typed env vars
    └── constants.ts
```

### Architectural principles

- **Routes are thin.** `app/` only imports screens from features. No business logic.
- **Features are self-contained.** Internal files are private; the only entry point
  for other features is `index.ts`.
- **Catalog vs Acervo separation.** Catalog (read-only, JSON in-memory) is separate
  from user data (read-write, WatermelonDB). Different storage for different
  lifecycles.
- **Repository pattern over DB.** Features access data via repositories, never
  WatermelonDB directly. This isolates persistence for Phase 2 (Nest backend).
- **Sync-ready from day 1.** UUIDs as PKs, timestamps everywhere, soft delete,
  even though sync is Phase 2.

## Core conventions

### Naming
- Component files: PascalCase (`PerfumeCard.tsx`)
- Hook/util files: camelCase (`usePerfumes.ts`)
- Folders: kebab-case (`wear-sessions/`)
- Hooks: prefix with `use` (`usePerfumes`)
- Zod schemas: suffix with `Schema` (`perfumeSchema`)
- Inferred types: PascalCase (`PerfumeFormData`)
- Repositories: kebab-case (`perfume-repository.ts`)

### Database (WatermelonDB)
- **IDs:** UUIDs (strings), generated client-side
- **Required columns on every table:** `created_at`, `updated_at`, `deleted_at` (soft delete)
- **Decorators:** `@text` (strings), `@field` (numbers/booleans), `@date` (dates),
  `@json` (arrays/objects), `@relation` (belongs-to), `@children` (has-many),
  `@readonly` for auto-managed timestamps
- **Schema location:** `src/db/schema.ts`
- **Models location:** `src/db/models/`
- **Access pattern:** features → repositories → models. Never features → models directly.
- **Migrations:** every schema change bumps version + migration file

### Features
- Each feature **must** have an `index.ts` exporting its public API
- Other features import **only** from another feature's `index.ts`, never reach internals
- Screens live in `features/<feature>/screens/`, routes in `app/` only import them
- Add new top-level folders only after discussion

### Forms
- Always **react-hook-form + zod** (together, no exceptions)
- Zod schemas in `features/<feature>/schemas/`
- Use `Controller` for non-native inputs
- Validation messages in **Brazilian Portuguese**
- Always export both schema and inferred type:
  ```typescript
  export const perfumeSchema = z.object({ ... });
  export type PerfumeFormData = z.infer<typeof perfumeSchema>;
  ```

### Styling
- NativeWind classes via `className` prop
- Component variants via `cva`
- Theme tokens defined in `tailwind.config.js` — **no magic values**
- Use semantic tokens (`bg-primary`, `text-foreground`), not raw colors (`bg-[#123]`)
- Typography: serif for headings (perfume identity), sans-serif for body

### State management
- **Persisted data:** WatermelonDB observables (via repositories/hooks)
- **Derived/computed data:** TanStack Query
- **UI state (modals, selections, filters):** Zustand stores
- **Form state:** react-hook-form
- **Never:** Redux

### Testing
- Co-located with source files (`Component.tsx` + `Component.test.tsx`)
- Jest + React Native Testing Library
- Priority: forms, repositories, hooks with business logic
- E2E (later): Maestro

## Domain context

The app organizes user perfume collections. Key entities:

| Entity | Storage | Purpose |
|---|---|---|
| `CatalogPerfume` | JSON in-memory | Read-only reference (Sauvage, Bleu, etc) |
| `Perfume` | WatermelonDB | A specific bottle the user owns |
| `Impression` | WatermelonDB | Free-form dated observations about a perfume |
| `WearSession` | WatermelonDB | Structured wear log (longevity, projection, sillage) |
| `PerfumePhoto` | WatermelonDB | User photos of their bottles |
| `Sample` | WatermelonDB | Small format (samples, decants), separate from Perfume |
| `WishlistItem` | WatermelonDB | Desired perfumes |
| `Tag` + `PerfumeTag` | WatermelonDB | Free-form tagging system |

### Important domain modeling decisions

- **Catalog fields denormalized into Perfume:** `name`, `brand`, `year`, etc. are
  duplicated when user picks from catalog. Reason: independence (catalog can
  change), performance (no joins), and supports manual entries (when `catalogId`
  is null).
- **Impression vs WearSession are separate:** qualitative (free-form, mood) vs
  quantitative (structured, performance metrics). Different mental models.
- **Sample is separate from Perfume:** different lifecycle (consumable),
  different fields (`verdict`, `source`, `is_finished`), different UX.
- **`recorded_at` vs `created_at`:** events can be logged after they happened.
  `recorded_at` is when it occurred, `created_at` is when the row was inserted.
- **`fill_level` is manual input:** not computed from wear sessions (atomizers
  vary, users forget to log, complexity not worth it).

## Skills usage policy

The project uses external skills (technical quality) and custom skills (project
conventions). Both live in `.claude/skills/`.

### External skills

| Skill | Source | When it applies |
|---|---|---|
| `react-native-best-practices` | Callstack | Performance, threading, bundle size, native modules, Hermes, TTI |
| `react-native-testing` | Callstack | Writing or reviewing tests with React Native Testing Library |
| `vercel-react-native-skills` | Vercel Labs | List rendering, animations, mobile UX optimization |

### Custom skills (project-specific)

| Skill | When it applies |
|---|---|
| `feature-creator` | Scaffold new feature modules |
| `db-model-creator` | New WatermelonDB models and schema changes |
| `form-builder` | react-hook-form + zod form creation |

### Conflict resolution

When external and custom skills give different guidance:

- **Custom skills win on structure and conventions:** where files go, how features
  are organized, naming, exports, what `index.ts` exposes.
- **External skills win on implementation details:** how to make a list performant,
  how to write a test, how to optimize re-renders, how to animate correctly.

If a conflict is ambiguous, surface it to the user instead of choosing silently.

## What NOT to do

- Don't put business logic in route files (`app/`); keep them as thin imports
- Don't query the DB directly from components; always go through hooks/repositories
- Don't create new top-level folders without discussing first
- Don't add dependencies without justification
- Don't use `any` — use `unknown` and narrow, or define proper types
- Don't skip TypeScript strict types
- Don't import from another feature's internals (only from its `index.ts`)
- Don't use Redux
- Don't hardcode colors, spacings, or font sizes (use theme tokens)
- Don't skip soft delete columns on new tables
- Don't use auto-increment IDs (always UUIDs)
- Don't mix catalog data with user data in the same storage

## When in doubt

- Prefer composition over inheritance
- Prefer explicit over clever
- Prefer small functions over big ones
- Prefer co-locating tests next to source files
- Prefer denormalization when it simplifies consumption (with documented reason)
- Surface trade-offs to the user instead of choosing silently on architectural matters

## Phase roadmap

- **Phase 1 (current):** Offline-first MVP with WatermelonDB. Bundled catalog.
  All features working locally. Publishable to stores.
- **Phase 2 (future):** Nest.js backend. Auth (likely Clerk). Catalog sync from
  server. User data sync with last-write-wins strategy. App becomes Nest API
  client with WatermelonDB as local cache.
- **Phase 3 (maybe):** Community features (sharing, reviews), advanced analytics,
  scanner, integrations.