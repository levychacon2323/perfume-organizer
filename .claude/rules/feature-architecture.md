# Feature Architecture

## Feature module structure
```
src/features/<feature-name>/
├── components/   # Feature-specific UI components
├── hooks/        # Feature-specific hooks (business logic, queries)
├── screens/      # Screen components (imported by app/ routes)
├── schemas/      # Zod validation schemas
└── index.ts      # PUBLIC API — only export what other features need
```

## Rules
- `app/` routes are **thin**: only import screens from features, zero business logic
- Other features import **only** from `features/<name>/index.ts`, never from internals
- `index.ts` is the contract; everything else is private implementation
- Add new top-level `src/` folders only after discussion

## Catalog vs. Acervo (user collection)
- **Catalog** (`src/catalog/`): read-only, JSON in-memory, Fuse.js search — never write here
- **User data** (`src/db/`): read-write, SQLite via Drizzle — all mutable state goes here
- Never mix the two in the same storage or repository

## Domain entities
| Entity | Storage | Notes |
|---|---|---|
| `CatalogPerfume` | JSON in-memory | Reference data (brand, name, year) |
| `Perfume` | SQLite | User-owned bottle; catalog fields denormalized |
| `Impression` | SQLite | Qualitative free-form observations |
| `WearSession` | SQLite | Quantitative wear log (longevity, projection, sillage) |
| `PerfumePhoto` | SQLite | User bottle photos |
| `Sample` | SQLite | Samples/decants (separate lifecycle from Perfume) |
| `WishlistItem` | SQLite | Desired perfumes |
| `Tag` + `PerfumeTag` | SQLite | Free-form tagging |

## Denormalization rule
Catalog fields (`name`, `brand`, `year`, etc.) are **copied** into `Perfume` at creation time.
Reason: independence from catalog changes, no joins needed, supports manual entries (`catalogId` is nullable).
