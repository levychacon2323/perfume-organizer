# Tarefa 4.0: Implementar navegação definitiva — tabs Coleção / Catálogo / Wishlist

## Visão geral

Substitui as tabs genéricas do template ("Tab One", "Tab Two") pelas três seções reais do produto. Cada tab recebe uma tela placeholder mínima em NativeWind. Remove todas as dependências de `Colors`, `useColorScheme` e `useClientOnlyValue` do layout de tabs.

**Dependência:** Tarefa 1 (tokens Tailwind corrigidos, para que `bg-background` já funcione nos placeholders).

<skills>
### Conformidade com skills

- `vercel-react-native-skills` — padrões de navegação com Expo Router e tab navigator
</skills>

<requirements>

- `app/(tabs)/_layout.tsx` define exatamente 3 tabs: Coleção, Catálogo, Wishlist
- Nenhum import de `Colors`, `useColorScheme` ou `useClientOnlyValue` em `_layout.tsx`
- `tabBarActiveTintColor` usa valor fixo do design system (ink = `#1A1A1A`) — sem referência a `colorScheme`
- Cada tab tem ícone via `expo-symbols` (`SymbolView`) com variantes `ios`/`android`
- `headerShown` é valor estático (sem `useClientOnlyValue`) — `false` para app mobile-first
- Telas placeholder usam apenas NativeWind (`className`) — zero `StyleSheet`
- Placeholders exibem label da seção em `text-primary`, fundo `bg-background`

</requirements>

## Subtarefas

- [ ] 4.1 Reescrever `app/(tabs)/_layout.tsx`:
  - Remover imports de `Colors`, `useColorScheme`, `useClientOnlyValue`, `Link`, `Pressable`
  - Definir `tabBarActiveTintColor: '#1A1A1A'` (ink) fixo
  - Registrar 3 `Tabs.Screen`: `index` (Coleção), `catalogo` (Catálogo), `wishlist` (Wishlist)
  - Ícones: Coleção → `house`/`home`, Catálogo → `magnifyingglass`/`search`, Wishlist → `heart`/`favorite`
- [ ] 4.2 Atualizar `app/(tabs)/index.tsx` — substituir conteúdo atual por placeholder Coleção
- [ ] 4.3 Criar `app/(tabs)/catalogo.tsx` — placeholder Catálogo
- [ ] 4.4 Criar `app/(tabs)/wishlist.tsx` — placeholder Wishlist

**Estrutura de cada placeholder:**
```tsx
// View flex-1 bg-background, centralizada
// Text em text-primary com o nome da seção
// Sem StyleSheet, sem Text/View de Themed
```

## Detalhes de implementação

Ver `techspec.md` § "Visão dos componentes" (tabela de componentes modificados/criados) e § "Conformidade com rules" (item feature-architecture e styling).

`headerShown: false` — headers são gerenciados pelo Stack Navigator em `_layout.tsx`, não pelos tabs.

O `Link` para `/modal` e o botão de info no header da Tab One são removidos nesta baseline (template). Podem ser reintroduzidos em features específicas.

## Critérios de sucesso

- Navegar entre Coleção, Catálogo e Wishlist no simulador sem erros
- Ícone correto e label correto em cada tab
- Tab ativa exibe tintColor ink (`#1A1A1A`)
- `grep -r "Colors\|useColorScheme\|useClientOnlyValue" app/(tabs)/_layout.tsx` retorna vazio
- Nenhum `StyleSheet` nos 3 arquivos placeholder

## Testes da tarefa

> Esta baseline não inclui arquivos `.test.tsx` (ver PRD § "Fora do Escopo").

- [ ] **Verificação no simulador iOS:** navegar entre as 3 tabs; confirmar label, ícone e tintColor corretos
- [ ] **Verificação no simulador Android:** repetir navegação; confirmar ícones Android (`home`, `search`, `favorite`)
- [ ] **Verificação de imports:** `grep -rn "Colors\|useClientOnlyValue\|useColorScheme" app/\(tabs\)/` retorna vazio

## Arquivos relevantes

**Modificar:**
- `app/(tabs)/_layout.tsx`
- `app/(tabs)/index.tsx`

**Criar:**
- `app/(tabs)/catalogo.tsx`
- `app/(tabs)/wishlist.tsx`
