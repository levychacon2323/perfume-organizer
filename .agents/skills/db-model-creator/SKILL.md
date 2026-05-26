---
name: db-model-creator
description: Adds new tables/models to WatermelonDB. Handles schema updates, model class creation with decorators, migrations, and repository scaffolding. Use when the user wants to add a new entity to the database, says "create a model for X", or needs to extend the data layer.
metadata:
  tags: expo, react-native, watermelondb, database, model, migration
---

# DB Model Creator

## Overview

Handles the full lifecycle of adding a new WatermelonDB model: schema, model class, migration, and repository.

## When to Apply

- User wants to add a new entity to the database
- User says "create a model for X"
- User needs to extend the data layer

## Required Steps (in order)

1. Add table definition to `src/db/schema.ts` — always include `created_at`, `updated_at`, `deleted_at` columns
2. Bump schema version number
3. Create model file at `src/db/models/<Name>.ts` with proper decorators
4. Register model in `src/db/index.ts` modelClasses array
5. Create migration in `src/db/migrations/` if not first version
6. Create repository at `src/db/repositories/<name>-repository.ts`
7. Export types and enums from the model file

## Model Template

```typescript
import { Model } from '@nozbe/watermelondb';
import { date, field, readonly, text } from '@nozbe/watermelondb/decorators';

export class ExampleModel extends Model {
  static table = 'examples';

  @readonly @date('created_at') createdAt!: Date;
  @readonly @date('updated_at') updatedAt!: Date;
  @date('deleted_at') deletedAt?: Date;

  @text('name') name!: string;
  @field('is_active') isActive!: boolean;
}
```

## Decorator Reference

| Decorator  | Use for                        |
|------------|--------------------------------|
| `@text`    | strings                        |
| `@field`   | numbers / booleans             |
| `@date`    | dates                          |
| `@json`    | arrays / objects               |
| `@relation`| belongs-to relationships       |
| `@children`| has-many relationships         |

## Anti-patterns

- Never use auto-increment IDs (use UUIDs)
- Never skip soft delete column (`deleted_at`)
- Never query the model directly from features — always via repository
