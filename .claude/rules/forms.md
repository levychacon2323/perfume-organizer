# Forms Conventions

## Stack
Always `react-hook-form` + `zod` together — no exceptions. Never use one without the other.

## Schema location
`src/features/<feature>/schemas/<entity>Schema.ts`

## Always export both schema and inferred type
```ts
export const perfumeSchema = z.object({ ... });
export type PerfumeFormData = z.infer<typeof perfumeSchema>;
```

## Validation messages
Always in **Brazilian Portuguese** (`pt-BR`).
```ts
z.string().min(1, 'Nome é obrigatório')
z.number().positive('Valor deve ser positivo')
```

## Non-native inputs
Use `Controller` from react-hook-form for any input not directly supported by RN's `<TextInput>`.

## Anti-patterns to avoid
- Do not use uncontrolled inputs without react-hook-form
- Do not validate outside of zod schemas
- Do not write error messages in English
