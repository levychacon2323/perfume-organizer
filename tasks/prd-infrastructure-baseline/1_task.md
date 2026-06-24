# Tarefa 1.0: Instalar `@expo-google-fonts/geist` e corrigir `tailwind.config.js`

## Visão geral

Instala o pacote de fontes Geist e atualiza `tailwind.config.js` com os tokens de cor exatos do DESIGN.md, a família tipográfica Geist nos três pesos do design system, e os tokens de `letterSpacing`. É o passo fundacional — nenhuma tela pode ser validada visualmente antes desta tarefa.

<skills>
### Conformidade com skills

Nenhuma skill externa se aplica diretamente (configuração pura, sem componentes React Native).
</skills>

<requirements>

- `@expo-google-fonts/geist` instalado como dependência
- `tailwind.config.js` com tokens semânticos de cor idênticos ao DESIGN.md
- Paleta nomeada (`ink`, `paper`, `bone`, `stone`, `ash`, `vermilion`) disponível como aliases
- `fontFamily` configurado com três pesos Geist: `light`, `sans`, `medium`
- Tokens de `letterSpacing` do design system adicionados: `tightest`, `tighter`, `tight`, `label`
- `fontFamily.sans: ['System']` do template removido
- Valor warm-brown `#FAF7F2` e `#1A1410` eliminados do config

</requirements>

## Subtarefas

- [ ] 1.1 Instalar `@expo-google-fonts/geist` via `pnpm add @expo-google-fonts/geist`
- [ ] 1.2 Atualizar `colors` no `tailwind.config.js` — tokens semânticos + paleta nomeada (ver techspec.md § "Principais interfaces")
- [ ] 1.3 Atualizar `fontFamily` — substituir `['System']` por `{ light, sans, medium }` mapeando para os nomes Expo registrados
- [ ] 1.4 Adicionar `letterSpacing` — `tightest`, `tighter`, `tight`, `label` conforme DESIGN.md
- [ ] 1.5 Verificar que nenhum valor warm-brown (`#FAF7F2`, `#1A1410`, `#F0EAE0`, `#6B5D52`, `#E0D6C8`, `#B23A48`) permanece no arquivo

## Detalhes de implementação

Ver `techspec.md` § "Principais interfaces" (bloco `tailwind.config.js`) e § "Principais decisões" (item fontFamily NativeWind).

Ponto de atenção: `fontFamily.light` e `fontFamily.medium` sobrescrevem intencionalmente as utilities de font-weight do Tailwind — correto para React Native/NativeWind onde font-weight standalone não funciona.

## Critérios de sucesso

- `grep -E "#FAF7F2|#1A1410|#F0EAE0|#B23A48|System" tailwind.config.js` retorna vazio
- Cada hex em `tailwind.config.js` bate com o correspondente em `DESIGN.md`
- `npx expo start` não quebra após a instalação do pacote

## Testes da tarefa

> Esta baseline não inclui arquivos `.test.tsx` (ver PRD § "Fora do Escopo").

- [ ] **Verificação visual:** abrir qualquer tela no simulador e confirmar que `bg-background` exibe `#FFFFFF` (não warm-white)
- [ ] **Verificação de package:** `cat package.json | grep geist` confirma a dependência instalada
- [ ] **Verificação de config:** diff manual entre `tailwind.config.js` e a tabela de cores de `DESIGN.md`

## Arquivos relevantes

**Instalar:**
- `@expo-google-fonts/geist` (nova dependência em `package.json`)

**Modificar:**
- `tailwind.config.js`
