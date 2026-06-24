# Documento de Requisitos do Produto (PRD)
## Infrastructure Baseline — Perfume Organizer

## Visão Geral

O Perfume Organizer tem infraestrutura de build funcionando (Expo 54, Drizzle,
NativeWind v4, migrations ativas), mas apresenta gaps que bloqueiam o
desenvolvimento de qualquer feature de produto: a fonte do design system não
está instalada, o provider de cache/queries não foi inicializado, os tokens de
cor divergem do DESIGN.md, e resíduos do template Expo poluem a base de código.

Esta feature resolve esses bloqueadores antes de qualquer feature de produto ser
construída, garantindo que Design System, Catalog e features de coleção partam
de uma base correta e consistente — sem retrabalho de cor, tipografia ou
arquitetura de providers.

---

## Objetivos

- O app executa sem erros de runtime relativos a providers ausentes (TanStack Query)
- A tipografia Geist (pesos 300/400/500) carrega e aparece corretamente em todas as telas
- Todos os tokens de cor em `tailwind.config.js` correspondem exatamente ao DESIGN.md
- A estrutura de navegação definitiva (tabs finais) está implementada, mesmo que com telas placeholder
- Nenhum arquivo de código do template Expo persiste no projeto
- `src/lib/` tem `theme.ts`, `env.ts` e `constants.ts` com conteúdo inicial útil

**Critérios de sucesso mensuráveis:**
- `npx expo start` roda sem warnings de provider ou fonte
- Cada token de cor em `tailwind.config.js` bate com o hex correspondente em DESIGN.md
- Zero arquivos do template Expo nos diretórios `app/`, `src/shared/` e `src/lib/`
- Estrutura de tabs reflete as seções reais do produto

---

## Histórias de Usuário

**Desenvolvedor implementando features de produto:**
- Como desenvolvedor, quero usar `useQuery()` em qualquer componente sem configurar providers adicionais, para que as features de TanStack Query funcionem imediatamente.
- Como desenvolvedor, quero aplicar `className="bg-primary text-foreground"` e obter as cores exatas do DESIGN.md, para que os componentes do design system sejam visualmente corretos desde o início.
- Como desenvolvedor, quero importar de `src/lib/constants` e obter constantes tipadas do app, para não usar magic strings espalhadas no código.
- Como desenvolvedor, quero que a base de código não contenha componentes do template Expo (Themed.tsx, EditScreenInfo.tsx), para não herdar padrões legados ao criar novos componentes.

**Usuário abrindo o app:**
- Como usuário, quero ver a tipografia correta (Geist) ao abrir o app, não uma fonte monospace genérica.
- Como usuário, quero navegar entre as seções principais do app usando tabs, mesmo que o conteúdo de cada tab seja temporário.

---

## Principais Funcionalidades

### RF-01 — Instalação e carregamento da fonte Geist

O app carrega `@expo-google-fonts/geist` com os três pesos do design system:
Geist_300Light, Geist_400Regular e Geist_500Medium. A fonte é registrada no
`_layout.tsx` via `useFonts()`. `tailwind.config.js` passa a usar Geist como
`fontFamily.sans`. SpaceMono é removido.

**Por que:** Geist é a fonte do design system (DESIGN.md). Sem ela, toda
tipografia futura estará errada por padrão.

**Requisitos funcionais:**
1. `@expo-google-fonts/geist` instalado como dependência
2. Três pesos carregados no layout root: Light (300), Regular (400), Medium (500)
3. `fontFamily.sans` em `tailwind.config.js` aponta para Geist
4. SpaceMono removido dos assets carregados e da configuração

---

### RF-02 — Inicialização do QueryClientProvider

TanStack Query passa a ter um `QueryClient` configurado e um `QueryClientProvider`
envolvendo o app no `_layout.tsx`, antes do Stack Navigator.

**Por que:** Qualquer hook `useQuery()` ou `useMutation()` falha em runtime sem
o provider. É um bloqueador de qualquer feature que use dados remotos ou cache.

**Requisitos funcionais:**
5. `QueryClient` instanciado com configurações padrão adequadas para mobile
6. `QueryClientProvider` envolve o app antes do Stack Navigator no `_layout.tsx`
7. Provider inicializado antes do primeiro render de telas de produto

---

### RF-03 — Alinhamento de tokens de cor com DESIGN.md

`tailwind.config.js` é atualizado para usar os valores hexadecimais exatos do
DESIGN.md. Os tokens semânticos (primary, background, muted, border, destructive)
são mantidos, e os tokens de paleta (ink, paper, bone, stone, ash, vermilion)
são adicionados como aliases para uso explícito.

**Por que:** O tailwind.config.js atual tem valores warm-brown (#FAF7F2, #1A1410)
que diferem do design system (neutros: #FFFFFF, #1A1A1A). Qualquer componente
construído antes da correção terá cores erradas.

**Requisitos funcionais:**
8. `background`: `#FFFFFF` (paper)
9. `foreground` e `primary.DEFAULT`: `#1A1A1A` (ink)
10. `muted.DEFAULT`: `#F5F5F2` (bone)
11. `muted-foreground`: `#6B6B66` (stone)
12. `border`: `#D4D2CC` (ash)
13. `destructive.DEFAULT`: `#8B3A2F` (vermilion)
14. Aliases de paleta disponíveis: `ink`, `paper`, `bone`, `stone`, `ash`, `vermilion`

---

### RF-04 — Criação de `src/lib/`

Três arquivos com conteúdo inicial útil, não stubs vazios:

- `theme.ts` — constantes TypeScript espelhando os tokens de cor do tailwind.config.js, para uso em StyleSheet quando className não é suficiente
- `env.ts` — variáveis de ambiente tipadas com valores padrão seguros
- `constants.ts` — constantes globais (nome do banco de dados, versão do app, timeouts)

**Por que:** Evita magic strings e valores hardcoded espalhados no código de features.

**Requisitos funcionais:**
15. `theme.ts` exporta objeto de cores compatível com StyleSheet
16. `env.ts` exporta variáveis tipadas com Expo Constants
17. `constants.ts` exporta pelo menos `DATABASE_NAME` e `APP_NAME`

---

### RF-05 — Remoção de resíduos do template Expo

Arquivos do template Expo são removidos. Imports órfãos são limpos.

**Arquivos a remover:**
- `app/(tabs)/two.tsx`
- `src/shared/components/EditScreenInfo.tsx`
- `src/shared/components/Themed.tsx`
- `src/shared/components/StyledText.tsx`
- `src/lib/Colors.ts`
- `src/shared/components/ExternalLink.tsx` (se sem uso real no projeto)

**Por que:** Esses arquivos usam padrões legados (StyleSheet hardcoded, Colors.ts)
incompatíveis com NativeWind/cva. Mantê-los cria confusão sobre qual padrão seguir.

**Requisitos funcionais:**
18. Nenhum dos arquivos listados existe após a feature
19. Nenhum import quebrado após a remoção
20. `src/shared/components/` contém apenas componentes que seguem NativeWind

---

### RF-06 — Estrutura de navegação definitiva

A estrutura de tabs é redesenhada para refletir as seções reais do produto,
substituindo o template genérico ("Tab One", "Tab Two"). Cada tab recebe uma
tela placeholder mínima em NativeWind (não template Expo), com label indicando
a feature em desenvolvimento.

**Seções esperadas** (a confirmar durante implementação): Coleção, Catálogo, e
uma terceira seção (ex: Perfil ou Amostras).

**Por que:** A estrutura de navegação é fundação para todas as features. Definir
agora evita refatoração de rotas ao lançar cada feature.

**Requisitos funcionais:**
21. `app/(tabs)/_layout.tsx` define as tabs reais do produto (não "Tab One/Two")
22. Cada tab tem seu arquivo de rota em `app/(tabs)/`
23. Telas placeholder usam NativeWind (`className="flex-1 bg-background"`) sem StyleSheet
24. `app/(tabs)/two.tsx` removido (substituído pelas rotas definitivas)

---

## Experiência do Usuário

**Persona primária:** Desenvolvedor implementando features do Perfume Organizer.
Necessidade: base limpa, padrões corretos, sem herança de template.

**Persona secundária:** Usuário final nos primeiros builds. Necessidade: app que
abre e navega sem erros ou tipografia estranha.

**Fluxo principal:**
`Abrir app → Splash screen → DB migrado → Telas com Geist, cores corretas do DESIGN.md, tabs definitivas`

**Restrições de UX:**
- Telas placeholder devem ser austeras: `bg-background` + label de seção em `text-primary`
- Nenhuma tela placeholder deve parecer um error state
- A splash screen só é ocultada quando fonte + DB estão prontos (comportamento atual do `_layout.tsx` mantido)

---

## Restrições Técnicas de Alto Nível

- Expo SDK 54 gerenciado — fonte Geist via `@expo-google-fonts/geist`, não auto-hospedada
- NativeWind v4 — `tailwind.config.js` é a única fonte de verdade para tokens de cor e tipografia
- `src/db/` não é tocado — migrations e schema existentes são preservados integralmente
- TypeScript strict mantido — novos arquivos em `src/lib/` seguem strict mode

---

## Fora do Escopo

- `src/db/repositories/` — tratado nos PRDs de cada feature de produto
- Componentes de design system (Button, Input, Card, Tag, Rating) — PRD separado
- `src/catalog/` (perfumes.json, store Zustand, busca Fuse.js) — PRD separado
- Features de produto (Collection, Perfume, WearSession, etc.) — PRDs separados
- Testes unitários ou de integração — nenhum arquivo `.test.tsx` nesta baseline
- Zustand stores de feature — inicializados nos PRDs de cada feature
- Animações, gestos ou transições de navegação customizadas
