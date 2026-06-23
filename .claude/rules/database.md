# Database Conventions (Drizzle + expo-sqlite)

## IDs
- Always UUIDs as `text` — generated client-side (never auto-increment integers)

## Required columns on every table
```ts
id: text('id').primaryKey(),
created_at: integer('created_at', { mode: 'timestamp_ms' }).notNull().default(sql`(unixepoch() * 1000)`),
updated_at: integer('updated_at', { mode: 'timestamp_ms' }).notNull().default(sql`(unixepoch() * 1000)`),
deleted_at: integer('deleted_at', { mode: 'timestamp_ms' }), // soft delete — always nullable
```

## Column types
- Timestamps: `integer({ mode: 'timestamp_ms' })`
- Booleans: `integer({ mode: 'boolean' })`
- Enums: `text({ enum: ['value1', 'value2'] })` for type safety

## File locations
- Table definitions: `src/db/schema.ts`
- Database instance (drizzle wrapper): `src/db/index.ts` — exports `db`
- Migrations: `src/db/drizzle/` — generated files, never edit manually
- Repositories: `src/db/repositories/[entity]-repository.ts`

## Access pattern
Features → repositories → drizzle queries. **Never access `db` directly from components or feature hooks.**

## Migrations
- Generate: `pnpm run db:generate` (uses drizzle-kit)
- Inspect: `pnpm run db:studio`
- Never edit committed migration files — always create a new migration

## Reactivity
Use `useLiveQuery` from `drizzle-orm/expo-sqlite` for auto-updating queries in components.

## `recorded_at` vs `created_at`
- `created_at`: when the DB row was inserted
- `recorded_at`: when the event actually occurred (used on WearSession, Impression — user may log after the fact)
