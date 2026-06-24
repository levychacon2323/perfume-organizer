# Tarefa 3.0: Atualizar `app/_layout.tsx` — fontes Geist, QueryClientProvider, remover dark mode

## Visão geral

Ponto central da baseline. Substitui SpaceMono por Geist nos três pesos, inicializa o `QueryClientProvider` antes do Stack Navigator, e remove toda a infraestrutura de dark mode (ThemeProvider, useColorScheme). O comportamento de splash screen (aguardar fonte + DB) é preservado.

**Dependência:** Tarefa 1 (pacote `@expo-google-fonts/geist` instalado).

<skills>
### Conformidade com skills

- `tanstack-query-best-practices` — configuração do `QueryClient` e posicionamento do `QueryClientProvider`
- `vercel-react-native-skills` — carregamento de fontes com `useFonts` e splash screen gate
</skills>

<requirements>

- `useFonts` carrega `Geist_300Light`, `Geist_400Regular`, `Geist_500Medium` — SpaceMono removido
- `QueryClient` instanciado fora do componente (evita re-criação a cada render)
- `QueryClientProvider` envolve o `Stack` (e qualquer outro provider interno)
- `ThemeProvider` de `@react-navigation/native` removido completamente
- Imports de `DarkTheme`, `DefaultTheme`, `useColorScheme` removidos
- Condição de splash screen mantida: `fontsLoaded && dbReady` antes de `SplashScreen.hideAsync()`
- `fontError` continua sendo lançado no `useEffect` (comportamento atual preservado)
- `useDatabaseMigrations` de `src/db/migrate.ts` não é tocado

</requirements>

## Subtarefas

- [ ] 3.1 Substituir o import de `useFonts` e adicionar os imports dos três pesos Geist de `@expo-google-fonts/geist`
- [ ] 3.2 Atualizar o objeto passado a `useFonts` — remover `SpaceMono`, adicionar `Geist_300Light`, `Geist_400Regular`, `Geist_500Medium`
- [ ] 3.3 Instanciar `QueryClient` fora do componente (nível de módulo)
- [ ] 3.4 Remover `ThemeProvider`, `DarkTheme`, `DefaultTheme` e o import de `useColorScheme`
- [ ] 3.5 Envolver `<Stack>` com `<QueryClientProvider client={queryClient}>`
- [ ] 3.6 Simplificar `RootLayoutNav` — remover a referência a `colorScheme` e retornar diretamente `QueryClientProvider > Stack`

## Detalhes de implementação

Ver `techspec.md` § "Visão dos componentes" (fluxo de boot) e § "Principais decisões" (dark mode removido, QueryClient defaults).

Ordem dos providers em `RootLayoutNav`:
```
QueryClientProvider(client)
  └─ Stack
       └─ Stack.Screen name="(tabs)"
       └─ Stack.Screen name="modal"
```

`QueryClient` com defaults do TanStack Query — sem customização de `staleTime` ou `retry` nesta baseline.

## Critérios de sucesso

- `npx expo start` sem warnings de font ou provider no console do Metro
- Splash screen some apenas após DB migrado + fontes carregadas
- Tela inicial exibe Geist (verificar visualmente — não mais monospace genérica)
- Um `useQuery({ queryKey: ['test'], queryFn: () => null })` em qualquer screen não lança erro de "No QueryClient set"

## Testes da tarefa

> Esta baseline não inclui arquivos `.test.tsx` (ver PRD § "Fora do Escopo").

- [ ] **Verificação no simulador:** abrir o app e confirmar tipografia Geist na tela de Coleção
- [ ] **Verificação de provider:** adicionar temporariamente `useQuery({ queryKey: ['x'], queryFn: () => 'ok' })` em `app/(tabs)/index.tsx` e confirmar que não lança erro
- [ ] **Verificação de splash:** matar e reabrir o app — splash some somente após o boot completo (DB + fonte)

## Arquivos relevantes

**Modificar:**
- `app/_layout.tsx`

**Consultar (não modificar):**
- `src/db/migrate.ts` — `useDatabaseMigrations` hook (preservado)
- `package.json` — confirmar que `@expo-google-fonts/geist` já está instalado (Tarefa 1)
