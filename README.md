# Perfume Organizer

A mobile app to organize, track, and journal your perfume collection. Log bottles, record impressions over time, track wear sessions, and manage your wishlist — all offline, with your data on your device.

---

## Screenshots

> Coming soon — design system and first screens are in progress.

---

## Features

- **Collection management** — catalog your bottles with brand, concentration, bottle size, fill level, purchase details, and photos
- **Impression journal** — log free-form, dated observations about how a perfume evolves over time
- **Wear sessions** — structured logs with occasion, weather, longevity, projection, and sillage ratings
- **Catalog search** — search from a curated database of popular perfumes to auto-fill details when adding a new bottle
- **Wishlist** — track perfumes you want to acquire, with priority and target price
- **Samples & decants** — separate tracking for small formats, with verdict system
- **Tagging** — free-form tags across your collection

---

## Tech stack

| Layer | Technology |
|---|---|
| Framework | Expo SDK 54 (managed) + Expo Router |
| Language | TypeScript (strict) |
| Database | expo-sqlite + Drizzle ORM |
| State | Zustand + TanStack Query |
| Forms | react-hook-form + zod |
| Styling | NativeWind v4 (Tailwind for RN) + cva |
| Images | expo-image |
| Search | Fuse.js (fuzzy, in-memory) |
| Package manager | pnpm |

---

## Architecture

Feature-based architecture with offline-first data layer.

```
src/
├── app/          # Expo Router routes (thin layer)
├── features/     # Self-contained feature modules
├── shared/       # Design system, shared components, hooks, utils
├── catalog/      # Bundled perfume catalog (read-only, in-memory JSON)
├── db/           # Drizzle schema, migrations, repositories
└── lib/          # Global config, constants, theme
```

Each feature is self-contained with its own components, hooks, screens, and schemas. Features communicate only through their public `index.ts` API — never via internal imports.

The data layer separates two concerns deliberately:
- **Catalog** (read-only, JSON bundled in app): reference data for ~500 curated perfumes
- **User data** (read-write, SQLite via Drizzle): the user's personal collection, impressions, sessions

This split keeps storage technology matched to data lifecycle and keeps the codebase sync-ready for Phase 2.

---

## Getting started

### Prerequisites

- Node.js 20+
- pnpm (`npm install -g pnpm`)
- Xcode 16+ (for iOS builds)
- Android Studio (for Android builds)

### Install

```bash
git clone https://github.com/levychacon/perfume-organizer
cd perfume-organizer
pnpm install
```

### Run (Metro only, no native build)

```bash
npx expo start --clear
```

### Build and run on device/simulator

```bash
# iOS (requires Mac + Xcode)
npx expo run:ios

# Android
npx expo run:android
```

> **Note:** This app uses `expo-sqlite` which requires a native build. Expo Go is not supported. Use a Dev Build or run via `expo run:*`.

---

## Database

The app uses Drizzle ORM with expo-sqlite for local-first persistence.

```bash
# Generate migrations after schema changes
pnpm db:generate

# Open Drizzle Studio (visual DB inspector)
pnpm db:studio
```

Migrations live in `src/db/drizzle/` and are committed to version control. Schema is defined in `src/db/schema.ts`.

---

## Key architectural decisions

**Why Drizzle + expo-sqlite instead of WatermelonDB**

WatermelonDB was the original choice for its reactive observables, but hit incompatibility issues with Expo SDK's new architecture — the community plugin was in beta and caused JSI conflicts. Switched to expo-sqlite (Expo first-party, zero config) with Drizzle ORM. Reactivity is handled via `useLiveQuery` from `drizzle-orm/expo-sqlite`. For a personal collection app, performance is equivalent.

**Why Expo SDK 54 instead of the latest**

SDK 56 requires Swift 6.2 which ships with Xcode 26 (beta). Local dev uses Xcode 16.4 (Swift 6.1). SDK 54 is stable, mature, and fully compatible. Upgrading is a future task once Xcode 26 reaches stable.

**Why offline-first**

Phase 1 ships a fully functional local app. The schema is designed sync-ready (UUIDs, timestamps, soft delete) so Phase 2 — a Nest.js backend with user sync — is additive, not destructive.

---

## Roadmap

### Phase 1 — Offline MVP (current)
- [ ] Design system base (typography, color tokens, primitives)
- [ ] Complete DB schema (all 8 tables)
- [ ] Perfume CRUD with catalog search
- [ ] Impression journal
- [ ] Wear session logging
- [ ] Wishlist and samples
- [ ] Tag system
- [ ] Curated catalog JSON (~500 perfumes)

### Phase 2 — Backend sync
- [ ] Nest.js API
- [ ] Auth (Clerk)
- [ ] Catalog sync from server
- [ ] User data sync (last-write-wins)

### Phase 3 — Community (maybe)
- [ ] Sharing collections
- [ ] Discovery features
- [ ] Barcode/batch code scanner

---

## Project structure

```
perfume-organizer/
├── app/                        # Expo Router (file-based routes)
│   ├── (tabs)/
│   └── _layout.tsx
├── src/
│   ├── features/
│   │   ├── collection/         # Acervo listing
│   │   ├── perfume/            # Perfume CRUD
│   │   ├── catalog-search/     # Search bundled catalog
│   │   ├── impressions/        # Impression journal
│   │   ├── wear-sessions/      # Wear logging
│   │   ├── wishlist/
│   │   └── samples/
│   ├── shared/
│   │   ├── ui/                 # Design system primitives
│   │   ├── components/
│   │   ├── hooks/
│   │   └── utils/
│   ├── catalog/
│   │   └── data/perfumes.json
│   ├── db/
│   │   ├── schema.ts
│   │   ├── index.ts
│   │   ├── migrate.ts
│   │   ├── drizzle/            # Generated SQL migrations
│   │   └── repositories/
│   └── lib/
├── CLAUDE.md                   # AI context and project conventions
├── drizzle.config.ts
├── tailwind.config.js
└── babel.config.js
```

---

## License

MIT
