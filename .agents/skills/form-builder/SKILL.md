---
name: form-builder
description: Creates forms using react-hook-form + zod. Ensures schemas live in the correct feature folder, types are inferred from schema, and components follow design system conventions. Use when the user wants a form, mentions a screen with input fields, or needs form validation.
metadata:
  tags: expo, react-native, form, zod, react-hook-form, validation
---

# Form Builder

## Overview

Standardizes form creation using `react-hook-form` + `zod`. Schemas live in the feature's `schemas/` folder and are the single source of truth for types.

## When to Apply

- User wants to create a form (cadastro, edição, etc.)
- User mentions a screen with input fields
- User wants form validation

## Steps

1. Create zod schema in `features/<feature>/schemas/<name>-schema.ts`
2. Export both schema and inferred type:

```typescript
export const perfumeSchema = z.object({ ... });
export type PerfumeFormData = z.infer<typeof perfumeSchema>;
```

3. Create form component using `useForm` with `zodResolver`
4. Use design system inputs from `src/shared/ui/`
5. Wrap non-native inputs in `Controller`
6. Handle submission with proper error states
7. Show validation errors inline below each field

## Standard Form Structure

```typescript
const {
  control,
  handleSubmit,
  formState: { errors, isSubmitting },
} = useForm<FormData>({
  resolver: zodResolver(schema),
  defaultValues: { ... },
});
```

## Conventions

- Schema lives in `schemas/` folder of the feature
- Always use `zodResolver(schema)`
- Always infer types from schema — never define types separately
- Error messages in zod schema must be in Portuguese (user-facing)

## Anti-patterns

- Don't define TypeScript types that duplicate the zod schema
- Don't put schema files outside the feature's `schemas/` folder
- Don't use uncontrolled inputs for non-native components — wrap in `Controller`
