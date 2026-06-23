# Naming Conventions

## Files
- Component files: PascalCase (`PerfumeCard.tsx`)
- Hook/util files: camelCase (`usePerfumes.ts`, `formatDate.ts`)
- Folders: kebab-case (`wear-sessions/`, `perfume-photos/`)
- Repository files: kebab-case (`perfume-repository.ts`)

## Code
- React components: PascalCase (`PerfumeCard`, `WearSessionForm`)
- Hooks: prefix `use` (`usePerfumes`, `useWearSessions`)
- Zod schemas: suffix `Schema` (`perfumeSchema`, `wearSessionSchema`)
- Inferred types from Zod: PascalCase (`PerfumeFormData`, `WearSessionFormData`)
- Zustand stores: camelCase with `use` prefix (`usePerfumeStore`)
- Drizzle table variables: camelCase plural (`perfumes`, `wearSessions`)

## Feature modules
- Feature folder names: kebab-case (`catalog-search/`, `wear-sessions/`)
- Public API file: always `index.ts` at feature root
- Screens: PascalCase with `Screen` suffix (`CollectionScreen.tsx`)
