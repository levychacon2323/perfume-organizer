# Tarefa 2.0: Criar `src/lib/` — `theme.ts`, `env.ts` e `constants.ts`

## Visão geral

Cria os três arquivos de infraestrutura em `src/lib/` que eliminam magic strings e valores hardcoded do código de features. Pode ser feita em paralelo com a Tarefa 1 — não tem dependências externas.

<skills>
### Conformidade com skills

Nenhuma skill externa se aplica (arquivos de configuração TypeScript puros).
</skills>

<requirements>

- `src/lib/theme.ts` exporta objeto de cores compatível com `StyleSheet.create()`, espelhando os tokens semânticos do `tailwind.config.js`
- `src/lib/env.ts` exporta variáveis de ambiente tipadas via `expo-constants`, com fallbacks seguros
- `src/lib/constants.ts` exporta pelo menos `DATABASE_NAME`, `APP_NAME` e `QUERY_STALE_TIME`
- Todos os arquivos seguem TypeScript strict (sem `any`)
- Nenhum valor hex hardcoded nos arquivos — apenas reexportar/mapear os tokens

</requirements>

## Subtarefas

- [ ] 2.1 Criar `src/lib/theme.ts` — objeto plano de cores com os mesmos tokens semânticos do Tailwind, para uso em `style={{ color: theme.colors.foreground }}` quando `className` não é suficiente
- [ ] 2.2 Criar `src/lib/env.ts` — importar `Constants` de `expo-constants` e exportar `env` com `appVersion`, `isDev`, e campos expandíveis para Phase 2
- [ ] 2.3 Criar `src/lib/constants.ts` — exportar `DATABASE_NAME` (nome do arquivo SQLite), `APP_NAME`, `QUERY_STALE_TIME` (ms)

## Detalhes de implementação

Ver `techspec.md` § "Principais interfaces" (blocos `theme.ts`, `env.ts`, `constants.ts`).

`DATABASE_NAME` deve ser o mesmo valor atualmente hardcoded em `src/db/index.ts` — verificar antes de criar.

## Critérios de sucesso

- `tsc --noEmit` passa sem erros nos três novos arquivos
- Importar `DATABASE_NAME` de `src/lib/constants` em outro arquivo TypeScript funciona com tipagem correta
- `theme.colors.background` retorna `'#FFFFFF'`

## Testes da tarefa

> Esta baseline não inclui arquivos `.test.tsx` (ver PRD § "Fora do Escopo").

- [ ] **Verificação de tipos:** `npx tsc --noEmit` sem erros
- [ ] **Verificação de importação:** adicionar temporariamente um `console.log(env.isDev)` em `_layout.tsx` e confirmar que Metro não reporta erro de tipo

## Arquivos relevantes

**Criar:**
- `src/lib/theme.ts`
- `src/lib/env.ts`
- `src/lib/constants.ts`

**Consultar (não modificar):**
- `src/db/index.ts` — verificar o nome atual do banco de dados para usar em `DATABASE_NAME`
- `tailwind.config.js` — tokens de cor a espelhar em `theme.ts`
