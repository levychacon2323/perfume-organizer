# Perfume Organizer — Project Context

Personal project to organize a perfume collection. Built as portfolio piece while
returning to the market at mid-to-senior React Native level. Offline-first now,
sync-ready for future Nest.js backend (Phase 2).

## Stack

- **Runtime:** Expo SDK 54 (managed workflow) + Expo Router (file-based routing)
- **Language:** TypeScript (strict mode)
- **Database:** expo-sqlite + Drizzle ORM (offline-first local DB, sync-ready)
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
├── db/                   # Drizzle + expo-sqlite (user data, mutable)
│   ├── schema.ts         # Drizzle table definitions
│   ├── index.ts          # Database instance (drizzle wrapper)
│   ├── migrate.ts        # useMigrations hook
│   ├── drizzle/          # Generated SQL migrations (drizzle-kit output)
│   │   ├── 0000_*.sql    # Migration files
│   │   ├── migrations.js # Auto-generated migrations bundle
│   │   └── meta/         # Drizzle metadata
│   └── repositories/     # Data access abstraction (Nest migration friendly)
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
  from user data (read-write, SQLite via Drizzle). Different storage for different
  lifecycles.
- **Repository pattern over DB.** Features access data via repositories, never
  Drizzle directly. This isolates persistence for Phase 2 (Nest backend).
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

### Database (Drizzle + expo-sqlite)
- **IDs:** UUIDs (text/string), generated client-side
- **Required columns on every table:** `created_at`, `updated_at`, `deleted_at` (soft delete)
- **Schema location:** `src/db/schema.ts` (Drizzle table definitions)
- **Database instance:** `src/db/index.ts` exports `db`
- **Migrations:** generated via `npm run db:generate` (uses drizzle-kit)
- **Migration files:** versioned in `src/db/drizzle/` and committed to Git
- **Access pattern:** features → repositories → drizzle queries. Never features → db directly.
- **Reactivity:** `useLiveQuery` from `drizzle-orm/expo-sqlite` for auto-updating queries
- **Visualization:** `npm run db:studio` opens Drizzle Studio for inspection
- **Timestamps:** stored as `integer({ mode: 'timestamp_ms' })`, defaulted via SQL
  `(unixepoch() * 1000)`
- **Booleans:** stored as `integer({ mode: 'boolean' })`
- **Enums:** stored as `text({ enum: [...] })` for type safety

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
- Typography: design system to be finalized (Editorial Moderno is a strong candidate)

### State management
- **Persisted data:** Drizzle queries via repositories/hooks
- **Reactive data:** `useLiveQuery` from Drizzle for auto-updating UI
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
| `Perfume` | SQLite (Drizzle) | A specific bottle the user owns |
| `Impression` | SQLite (Drizzle) | Free-form dated observations about a perfume |
| `WearSession` | SQLite (Drizzle) | Structured wear log (longevity, projection, sillage) |
| `PerfumePhoto` | SQLite (Drizzle) | User photos of their bottles |
| `Sample` | SQLite (Drizzle) | Small format (samples, decants), separate from Perfume |
| `WishlistItem` | SQLite (Drizzle) | Desired perfumes |
| `Tag` + `PerfumeTag` | SQLite (Drizzle) | Free-form tagging system |

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

## Architectural decisions log

Key technical decisions taken and why. New decisions should be appended here
with rationale.

### Why Drizzle + expo-sqlite (not WatermelonDB)
Originally planned to use WatermelonDB for its reactive observables. Hit
incompatibility issues with Expo SDK new architecture — WatermelonDB still
relies on a community config plugin (`@morrowdigital/watermelondb-expo-plugin`)
in beta status, and the new architecture introduced JSI conflicts that required
multiple workarounds.

Switched to expo-sqlite (Expo first-party, zero config) + Drizzle ORM
(type-safe, SQL migrations versioned in Git, modern DX). Reactivity is handled
via `useLiveQuery` from `drizzle-orm/expo-sqlite`, which fulfills the same role
as WatermelonDB observables. For a personal collection app with hundreds-to-low-
thousands of records, performance is equivalent.

Trade-offs: Drizzle has less "name recognition" than WatermelonDB in some
circles, but appears much more in 2026 job listings. SQL migrations as files
also create a clearer schema history in Git, which is portfolio-positive.

### Why Expo SDK 54 (not the latest 56)
SDK 56 requires Swift 6.2, which only ships with Xcode 26 (currently in beta as
of project start). Local dev environment uses Xcode 16.4 (Swift 6.1). Production
projects typically run 1-2 SDKs behind latest; SDK 54 is stable, mature, and
fully compatible. Upgrading to 56 is a future task once Xcode 26 reaches stable.

### Why offline-first first, sync later
Phase 1 ships a fully functional local app to validate product. Phase 2 adds
Nest.js backend with sync. Schema is designed sync-ready (UUIDs, timestamps,
soft delete) so Phase 2 is additive, not destructive.

## Skills usage policy

The project uses external skills (technical quality) and custom skills (project
conventions). All live in `.agents/skills/`; a subset is symlinked into `.claude/skills/`.

### External skills

| Skill | Source | When it applies |
|---|---|---|
| `react-native-best-practices` | Callstack | Performance, threading, bundle size, native modules, Hermes, TTI |
| `react-native-testing` | Callstack | Writing or reviewing tests with React Native Testing Library (RNTL v13/v14) |
| `vercel-react-native-skills` | Vercel Labs | List rendering, animations, mobile UX, images, native modals |
| `tanstack-query-best-practices` | TanStack | Data fetching, cache strategy, mutations, query keys, optimistic updates |
| `javascript-typescript-jest` | Community | Jest: test structure, mocking strategies, async patterns, snapshots |
| `zustand` | LobeHub | Zustand store conventions: public/internal action hierarchy, selectors, optimistic updates |

### Custom skills (project-specific)

| Skill | When it applies |
|---|---|
| `feature-creator` | Scaffold new feature modules under `src/features/` |
| `db-model-creator` | New Drizzle tables, migrations, and repository scaffolding |
| `form-builder` | react-hook-form + zod form creation with PT-BR validation messages |

### Conflict resolution

When external and custom skills give different guidance:

- **Custom skills win on structure and conventions:** where files go, how features
  are organized, naming, exports, what `index.ts` exposes.
- **External skills win on implementation details:** how to make a list performant,
  how to write a test, how to optimize re-renders, how to animate correctly.

If a conflict is ambiguous, surface it to the user instead of choosing silently.

## Spec-driven development

New features follow a three-phase workflow before any implementation begins:

```
PRD → Tech Spec → Tasks → Implementation
```

### Artefatos por feature

Each feature lives under `tasks/prd-[feature-name]/`:

| Arquivo | Gerado por | Conteúdo |
|---|---|---|
| `prd.md` | `prd-creator` workflow | O quê e por quê (requisitos, histórias, escopo) |
| `techspec.md` | `techspec-creator` workflow | Como (arquitetura, componentes, interfaces, testes) |
| `tasks.md` | `task-generator` workflow | Lista de tarefas de alto nível |
| `N_task.md` | `task-generator` workflow | Detalhamento de cada tarefa com subtarefas e testes |

### Prompts de referência

Workflows estão em `.claude/workflows/` como documentos de referência. Para iniciar cada fase, copie o prompt do arquivo correspondente e cole em uma nova conversa.

| Workflow | Arquivo | Quando usar |
|---|---|---|
| PRD Creator | `.claude/workflows/prd-creator.md` | Ao definir uma nova feature |
| Tech Spec Creator | `.claude/workflows/techspec-creator.md` | Após o PRD aprovado |
| Task Generator | `.claude/workflows/task-generator.md` | Após PRD + Tech Spec aprovados |

### Convenções do projeto para as specs

As rules em `.claude/rules/` são a referência granular usada pelos workflows:
- `naming.md` — convenções de nomenclatura
- `database.md` — Drizzle + expo-sqlite
- `feature-architecture.md` — estrutura de features e domínio
- `forms.md` — react-hook-form + zod
- `styling.md` — NativeWind + cva + design tokens (ver também `DESIGN.md`)
- `state-management.md` — Zustand, TanStack Query, Drizzle

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
- Don't use auto-increment IDs (always UUIDs as text)
- Don't mix catalog data with user data in the same storage
- Don't edit migration files manually after they've been committed; create a new
  migration via `npm run db:generate`

## When in doubt

- Prefer composition over inheritance
- Prefer explicit over clever
- Prefer small functions over big ones
- Prefer co-locating tests next to source files
- Prefer denormalization when it simplifies consumption (with documented reason)
- Surface trade-offs to the user instead of choosing silently on architectural matters

## Useful commands

```bash
# Development
npx expo start                    # Start Metro bundler
npx expo run:ios                  # Build and run on iOS simulator
npx expo run:android              # Build and run on Android emulator

# Database
pnpm run db:generate               # Generate new migration from schema changes
pnpm run db:studio                 # Open Drizzle Studio (visual DB inspector)

# Validation
npx expo-doctor                   # Check project health
npx expo install --check          # Verify Expo package versions
```

## Phase roadmap

- **Phase 1 (current):** Offline-first MVP with Drizzle + expo-sqlite. Bundled
  catalog. All features working locally. Publishable to stores.
- **Phase 2 (future):** Nest.js backend. Auth (likely Clerk). Catalog sync from
  server. User data sync with last-write-wins strategy. App becomes Nest API
  client with SQLite as local cache.
- **Phase 3 (maybe):** Community features (sharing, reviews), advanced analytics,
  scanner, integrations.