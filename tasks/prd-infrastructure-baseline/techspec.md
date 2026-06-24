# Especificação Técnica
## Infrastructure Baseline — Perfume Organizer

---

## Resumo executivo

A baseline é um conjunto de seis grupos de mudanças coordenadas que não produzem novas features visíveis, mas eliminam todos os bloqueadores para o desenvolvimento de produto. O trabalho concentra-se em três pontos de integração: `app/_layout.tsx` (providers e fontes), `tailwind.config.js` (tokens visuais) e `src/lib/` (constantes tipadas). Nenhuma tabela Drizzle é criada ou alterada. A única dependência nova é `@expo-google-fonts/geist`.

A estratégia de implementação é de fora para dentro: configuração Tailwind e `src/lib/` primeiro (sem risco de quebrar o app), depois `_layout.tsx` (substituição de fontes + adição de QueryClientProvider + remoção de dark mode), depois as tabs definitivas, e por último a limpeza de resíduos — garantindo que o app seja testável em cada etapa.

---

## Arquitetura do sistema

### Visão dos componentes

**Componentes modificados:**

| Arquivo | Mudança |
|---|---|
| `app/_layout.tsx` | Substitui `SpaceMono` por Geist (3 pesos), adiciona `QueryClientProvider`, remove `ThemeProvider`/`useColorScheme` |
| `app/(tabs)/_layout.tsx` | Tabs definitivas (Coleção, Catálogo, Wishlist), remove `Colors`/`useColorScheme`/`useClientOnlyValue` |
| `app/(tabs)/index.tsx` | Placeholder Coleção em NativeWind puro |
| `app/modal.tsx` | Substituído por placeholder NativeWind (remove `Themed` e `EditScreenInfo`) |
| `tailwind.config.js` | Tokens de cor corrigidos, `fontFamily` Geist, `letterSpacing` do design system |

**Componentes criados:**

| Arquivo | Responsabilidade |
|---|---|
| `app/(tabs)/catalogo.tsx` | Placeholder tela Catálogo |
| `app/(tabs)/wishlist.tsx` | Placeholder tela Wishlist |
| `src/lib/theme.ts` | Objeto de cores TypeScript para uso em `StyleSheet` |
| `src/lib/env.ts` | Variáveis de ambiente tipadas via `expo-constants` |
| `src/lib/constants.ts` | Constantes globais (`DATABASE_NAME`, `APP_NAME`, timeouts) |

**Componentes deletados:**

| Arquivo | Motivo |
|---|---|
| `app/(tabs)/two.tsx` | Template — substituído por rotas definitivas |
| `src/shared/components/EditScreenInfo.tsx` | Template — padrões `StyleSheet` + `Colors.ts` legados |
| `src/shared/components/Themed.tsx` | Template — componentes `Text`/`View` com dark mode hardcoded |
| `src/shared/components/StyledText.tsx` | Template — depende de `Themed` e `SpaceMono` |
| `src/shared/components/ExternalLink.tsx` | Sem uso real após remoção de `EditScreenInfo` |
| `src/lib/Colors.ts` | Template — substituído por `src/lib/theme.ts` e tokens Tailwind |
| `src/shared/hooks/useColorScheme.ts` + `.web.ts` | Dark mode removido da baseline |
| `src/shared/hooks/useClientOnlyValue.ts` + `.web.ts` | Workaround web não necessário para app mobile-first |

**Fluxo de dados no boot (após baseline):**

```
[App abre] → SplashScreen preventAutoHideAsync()
  → useFonts({ Geist_300Light, Geist_400Regular, Geist_500Medium })
  → useDatabaseMigrations()   ← src/db/migrate.ts (inalterado)
  → ambos prontos → SplashScreen.hideAsync()
  → QueryClientProvider > Stack > (tabs)
```

---

## Design de implementação

### Principais interfaces

**`app/_layout.tsx` — estrutura após mudanças:**
```ts
// Providers aninhados (exterior → interior):
// QueryClientProvider(client) > Stack Navigator
// Sem ThemeProvider — app always-light
// useFonts carrega os 3 pesos Geist; SpaceMono removido
// Condição de splash: fontsLoaded && dbReady
```

**`tailwind.config.js` — seções relevantes:**
```js
colors: {
  // Paleta nomeada (aliases diretos)
  ink: '#1A1A1A', paper: '#FFFFFF', bone: '#F5F5F2',
  stone: '#6B6B66', ash: '#D4D2CC', vermilion: '#8B3A2F',
  // Tokens semânticos
  background: '#FFFFFF',        // paper
  foreground: '#1A1A1A',        // ink
  primary: { DEFAULT: '#1A1A1A', foreground: '#FFFFFF' },
  muted: { DEFAULT: '#F5F5F2', foreground: '#6B6B66' },
  border: '#D4D2CC',            // ash
  destructive: { DEFAULT: '#8B3A2F', foreground: '#FFFFFF' },
},
fontFamily: {
  light:  ['Geist_300Light'],   // → className="font-light"
  sans:   ['Geist_400Regular'], // → className="font-sans" (padrão)
  medium: ['Geist_500Medium'],  // → className="font-medium"
},
letterSpacing: {
  tightest: '-0.04em', // display
  tighter:  '-0.02em', // heading
  tight:    '-0.015em',// subheading
  label:    '0.2em',   // ALL CAPS labels
},
```

**`src/lib/theme.ts` — interface:**
```ts
// Objeto plano de cores compatível com StyleSheet.create()
// Espelha os tokens semânticos do tailwind.config.js
// Uso: quando className não é suficiente (ex: prop style dinâmico)
export const colors: Record<string, string>
export const theme = { colors }
```

**`src/lib/env.ts` — interface:**
```ts
// Variáveis tipadas com fallbacks seguros
// Fonte: expo-constants (Constants.expoConfig)
export const env = {
  appVersion: string,
  isDev: boolean,
  // expandir conforme Phase 2 (backend URL, etc.)
}
```

**`src/lib/constants.ts` — interface:**
```ts
export const DATABASE_NAME: string   // nome do arquivo SQLite
export const APP_NAME: string
export const QUERY_STALE_TIME: number // ms
```

### Modelos de dados

Nenhuma entidade Drizzle é criada ou alterada. `src/db/schema.ts`, `src/db/index.ts` e `src/db/migrate.ts` permanecem intactos.

### Endpoints da API

Não aplicável — infraestrutura local, sem chamadas de rede nesta baseline.

---

## Pontos de integração

**`@expo-google-fonts/geist` (novo pacote):**
- Instalação via `pnpm add @expo-google-fonts/geist`
- O pacote registra as fontes como assets Expo automaticamente; não requer `expo install` adicional
- Três exports consumidos: `Geist_300Light`, `Geist_400Regular`, `Geist_500Medium`
- `useFonts` do `expo-font` (já instalado) carrega os três; retorna `[loaded, error]`

**Sem outras integrações externas.** TanStack Query (`@tanstack/react-query`) já está no `package.json` — apenas o `QueryClientProvider` precisa ser inicializado.

---

## Abordagem de testes

O PRD explicita que **nenhum arquivo `.test.tsx`** é criado nesta baseline. A verificação é manual:

### Verificação manual (critérios do PRD)

| Critério | Como verificar |
|---|---|
| `npx expo start` sem warnings de provider ou fonte | Console do Metro Bundler |
| Geist visível nas telas | Inspecionar visualmente qualquer tela placeholder |
| Tokens de cor corretos | Comparar `tailwind.config.js` vs DESIGN.md hex a hex |
| Zero arquivos de template | `find src/ app/ -name "*.tsx" -o -name "*.ts"` |
| Tabs definitivas | Navegar entre as 3 tabs no simulador |

### Testes unitários

Não aplicável nesta baseline.

### Testes de integração

Não aplicável nesta baseline.

### Testes E2E

Não aplicável nesta baseline. Maestro será introduzido nos PRDs de features de produto.

---

## Sequenciamento do desenvolvimento

### Ordem de construção

1. **Instalar `@expo-google-fonts/geist`** — bloqueador para RF-01 e para qualquer validação de tipografia
2. **Atualizar `tailwind.config.js`** (RF-03 + letterSpacing) — sem dependências, valida tokens imediatamente com hot reload
3. **Criar `src/lib/`** (RF-04: `theme.ts`, `env.ts`, `constants.ts`) — sem dependências, pode ser feito em paralelo com (2)
4. **Atualizar `app/_layout.tsx`** (RF-01 fontes + RF-02 QueryClientProvider + remoção de dark mode) — depende de (1)
5. **Implementar tabs definitivas** (RF-06: `(tabs)/_layout.tsx` + rotas placeholder) — depende de (2) para usar tokens corretos
6. **Remover resíduos do template** (RF-05) — por último, após (4) e (5) já não dependerem dos arquivos legados

### Dependências técnicas

- `@expo-google-fonts/geist` deve ser instalado antes de qualquer mudança em `_layout.tsx`
- `app/(tabs)/two.tsx` só pode ser removido depois que `(tabs)/_layout.tsx` não referenciar mais a rota `two`
- `src/shared/hooks/useColorScheme.ts` só pode ser removido depois que `(tabs)/_layout.tsx` e `_layout.tsx` não o importarem

---

## Monitoramento e observabilidade

**Durante desenvolvimento:**
- Metro Bundler console: warnings de font não carregada aparecem imediatamente
- React Query Devtools não é instalado nesta baseline (adicionar opcionalmente em PRD futuro)
- `npx expo-doctor` valida compatibilidade de versões após instalação do pacote Geist

**Debugging de tokens:**
- `pnpm run db:studio` não é afetado (infra de DB inalterada)
- Para validar cores: abrir qualquer tela placeholder no simulador com o inspector de UI do Expo

---

## Considerações técnicas

### Principais decisões

**fontFamily no Tailwind: nomes `light`/`sans`/`medium`**

Tailwind tem utilities de `font-weight` (`font-light`, `font-medium`) e utilities de `font-family` (`font-{key}`). Em React Native, font-weight como propriedade CSS é ignorado — cada peso requer o arquivo de fonte registrado. Ao definir `fontFamily.light`, `fontFamily.sans`, `fontFamily.medium` no `tailwind.config.js`, as utilities geradas (`font-light`, `font-sans`, `font-medium`) mapeiam para `fontFamily: 'Geist_300Light'` etc., alinhando com o padrão do DESIGN.md. A colisão de nomes com font-weight é intencional no contexto React Native/NativeWind, onde font-weight standalone não funciona.

**Dark mode removido completamente**

DESIGN.md define um sistema visual exclusivamente light (paper/ink). `ThemeProvider` do `@react-navigation/native`, `useColorScheme` e `useClientOnlyValue` são resíduos do template Expo, não decisões de produto. Removê-los agora evita que features futuras herdem o padrão. A reversão, se necessária, requer uma baseline específica de dark mode com tokens definidos no DESIGN.md.

**QueryClient com defaults do TanStack Query**

Na Phase 1 (offline-first), `useQuery` será usado para dados derivados/computados, sem chamadas de rede. Os defaults do TanStack Query (`staleTime: 0`, `retry: 3`, `gcTime: 5min`) são adequados. Customização de defaults é adiada para quando houver endpoints reais (Phase 2).

**letterSpacing na baseline**

Incluído para evitar que qualquer componente de texto criado antes do PRD de design system precise de valores hardcoded. O custo é zero (só linhas no `tailwind.config.js`); o benefício é que `tracking-tightest`, `tracking-label` etc. já funcionam desde o primeiro componente.

**`muted` como objeto `{ DEFAULT, foreground }`**

Permite `bg-muted` (superfície) e `text-muted-foreground` (texto sobre superfície), seguindo o mesmo padrão de `primary` e `destructive`. O config atual tinha `muted` e `muted-foreground` como chaves separadas — unificado para objeto.

### Riscos conhecidos

| Risco | Mitigação |
|---|---|
| `@expo-google-fonts/geist` incompatível com Expo SDK 54 | Verificar com `npx expo install --check` após instalação |
| Splash screen não oculta se `useFonts` falhar silenciosamente | `fontError` já lança no `useEffect` — manter esse comportamento |
| Arquivos deletados ainda importados em algum lugar não listado | `grep -r "from '@/lib/Colors'" src/ app/` antes de deletar cada arquivo |
| `app/modal.tsx` usa `StyleSheet` — esquecido na limpeza | Modal está no escopo do RF-05 (cleanup), substituído por placeholder NativeWind |

### Conformidade com rules

| Rule | Aplicação |
|---|---|
| `naming.md` | Rotas em kebab-case (`catalogo.tsx`, `wishlist.tsx`); arquivos lib em camelCase |
| `styling.md` | Tokens semânticos no Tailwind; sem hex hardcoded nos componentes; `rounded-none` nos placeholders |
| `feature-architecture.md` | `app/` permanece thin (só imports de screens); nenhuma lógica de negócio nas rotas |
| `state-management.md` | `QueryClientProvider` antes do Stack; `useLiveQuery` para dados do Drizzle (inalterado) |
| `database.md` | `src/db/` não tocado; `DATABASE_NAME` exportado de `constants.ts` para evitar magic string |

### Conformidade com skills

Nenhuma skill externa se aplica diretamente a esta baseline (sem componentes, sem testes, sem animações, sem listas). As skills serão acionadas nos PRDs de features.

### Arquivos relevantes e dependentes

**Criar:**
- `app/(tabs)/catalogo.tsx`
- `app/(tabs)/wishlist.tsx`
- `src/lib/theme.ts`
- `src/lib/env.ts`
- `src/lib/constants.ts`

**Modificar:**
- `app/_layout.tsx`
- `app/(tabs)/_layout.tsx`
- `app/(tabs)/index.tsx`
- `app/modal.tsx`
- `tailwind.config.js`

**Deletar:**
- `app/(tabs)/two.tsx`
- `src/shared/components/EditScreenInfo.tsx`
- `src/shared/components/Themed.tsx`
- `src/shared/components/StyledText.tsx`
- `src/shared/components/ExternalLink.tsx`
- `src/lib/Colors.ts`
- `src/shared/hooks/useColorScheme.ts`
- `src/shared/hooks/useColorScheme.web.ts`
- `src/shared/hooks/useClientOnlyValue.ts`
- `src/shared/hooks/useClientOnlyValue.web.ts`

**Inalterado (não tocar):**
- `src/db/` (schema, index, migrate, drizzle/)
- `assets/fonts/SpaceMono-Regular.ttf` (asset pode permanecer; apenas remover do `useFonts`)
- `app/+not-found.tsx`, `app/+html.tsx`
- `drizzle.config.ts`, `metro.config.js`, `babel.config.js`
