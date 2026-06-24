# Tarefa 5.0: Remover resíduos do template Expo e limpar `app/modal.tsx`

## Visão geral

Remove os 10 arquivos do template Expo que usam padrões legados (StyleSheet hardcoded, Colors.ts, dark mode), substitui `app/modal.tsx` por um placeholder NativeWind, e verifica que zero imports quebrados existem após a limpeza.

**Dependência:** Tarefas 3 e 4 concluídas — `_layout.tsx` e `(tabs)/_layout.tsx` não podem mais importar nenhum dos arquivos a deletar antes desta tarefa.

<skills>
### Conformidade com skills

Nenhuma skill externa se aplica (remoção de arquivos e limpeza de imports).
</skills>

<requirements>

- Nenhum dos 10 arquivos listados existe após a tarefa
- `app/modal.tsx` substituído por placeholder NativeWind (sem `StyleSheet`, sem `Themed`, sem `EditScreenInfo`)
- Zero imports quebrados em qualquer arquivo de `app/` ou `src/`
- `src/shared/components/` contém apenas componentes que seguem NativeWind

</requirements>

## Subtarefas

- [ ] 5.1 **Verificar dependências antes de deletar** — executar os greps de segurança abaixo para confirmar que nenhum arquivo fora da lista ainda importa os arquivos a remover
- [ ] 5.2 Deletar `app/(tabs)/two.tsx`
- [ ] 5.3 Deletar `src/shared/components/EditScreenInfo.tsx`
- [ ] 5.4 Deletar `src/shared/components/Themed.tsx`
- [ ] 5.5 Deletar `src/shared/components/StyledText.tsx`
- [ ] 5.6 Deletar `src/shared/components/ExternalLink.tsx`
- [ ] 5.7 Deletar `src/lib/Colors.ts`
- [ ] 5.8 Deletar `src/shared/hooks/useColorScheme.ts` e `useColorScheme.web.ts`
- [ ] 5.9 Deletar `src/shared/hooks/useClientOnlyValue.ts` e `useClientOnlyValue.web.ts`
- [ ] 5.10 Substituir `app/modal.tsx` por placeholder NativeWind mínimo (label "Modal", `bg-background`, sem `StyleSheet`)

## Detalhes de implementação

Ver `techspec.md` § "Arquivos relevantes e dependentes" (lista completa de arquivos a deletar) e § "Riscos conhecidos" (grep de segurança recomendado).

**Greps de segurança a executar antes de cada deleção:**
```bash
grep -r "from '@/lib/Colors'" app/ src/
grep -r "from '@/shared/components/Themed'" app/ src/
grep -r "from '@/shared/components/EditScreenInfo'" app/ src/
grep -r "from '@/shared/components/ExternalLink'" app/ src/
grep -r "from '@/shared/hooks/useColorScheme'" app/ src/
grep -r "from '@/shared/hooks/useClientOnlyValue'" app/ src/
```
Cada grep deve retornar vazio antes de deletar o arquivo correspondente.

**Placeholder para `app/modal.tsx`:**
```tsx
// View flex-1 bg-background centralizada
// Text "Modal" em text-primary
// Sem StatusBar customizada, sem StyleSheet
```

**`app/(tabs)/two.tsx`** já não tem rota registrada após a Tarefa 4 — pode ser deletado sem impacto na navegação.

## Critérios de sucesso

- `find src/ app/ -name "Colors.ts" -o -name "Themed.tsx" -o -name "EditScreenInfo.tsx" -o -name "StyledText.tsx" -o -name "ExternalLink.tsx"` retorna vazio
- `find src/shared/hooks -name "useColorScheme*" -o -name "useClientOnlyValue*"` retorna vazio
- `npx expo start` sem erros após a limpeza
- `grep -r "StyleSheet" app/modal.tsx` retorna vazio

## Testes da tarefa

> Esta baseline não inclui arquivos `.test.tsx` (ver PRD § "Fora do Escopo").

- [ ] **Verificação de ausência:** `find src/ app/ -name "two.tsx" -o -name "EditScreenInfo.tsx" -o -name "Themed.tsx"` retorna vazio
- [ ] **Verificação de imports:** `grep -rn "Colors\|EditScreenInfo\|Themed\|StyledText\|ExternalLink\|useClientOnlyValue" app/ src/` retorna vazio
- [ ] **Verificação no simulador:** abrir o app e navegar nas 3 tabs — sem crashes ou tela em branco

## Arquivos relevantes

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

**Modificar:**
- `app/modal.tsx` — substituído por placeholder NativeWind
