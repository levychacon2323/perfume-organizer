# State Management Conventions

## Regra geral — onde cada tipo de estado vai

| Tipo de estado | Solução | Exemplo |
|---|---|---|
| Dados persistidos (user data) | Drizzle + `useLiveQuery` | Lista de perfumes, sessões de uso |
| Dados derivados / cache | TanStack Query | Estatísticas, contagens, dados combinados |
| Estado de UI (modais, seleções, filtros) | Zustand store | Modal aberto, filtro ativo, aba selecionada |
| Estado de formulário | react-hook-form | Campos, validação, submissão |

## Drizzle + useLiveQuery
Fonte primária de verdade para dados do usuário.
```ts
// Em hooks de feature — nunca diretamente no componente
const { data: perfumes } = useLiveQuery(
  db.select().from(perfumesTable).where(isNull(perfumesTable.deleted_at))
);
```

## TanStack Query
Para dados derivados, agregações, ou quando precisar de cache inteligente.
```ts
const { data: stats } = useQuery({
  queryKey: ['collection-stats'],
  queryFn: () => collectionRepository.getStats(),
});
```

## Zustand
Apenas para estado client-side sem persistência (UI state).
```ts
// stores ficam em features/<feature>/hooks/ ou shared/hooks/
const usePerfumeStore = create<PerfumeStore>((set) => ({
  activeFilter: null,
  setActiveFilter: (filter) => set({ activeFilter: filter }),
}));
```

## Catálogo
Estado do catálogo (`src/catalog/store.ts`) é Zustand carregado uma vez no boot — read-only.

## Anti-patterns
- **Nunca Redux**
- Nunca consultar `db` diretamente de componentes — sempre via hooks/repositories
- Nunca misturar estado de formulário com Zustand
- Nunca usar TanStack Query para dados que já vêm do `useLiveQuery` (duplicação)
