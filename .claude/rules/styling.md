# Styling Conventions

> Fonte de verdade visual: `DESIGN.md`. Este arquivo resume as regras para uso nas skills.

## Stack
- **NativeWind v4**: classes Tailwind via prop `className` em componentes React Native
- **cva** (class-variance-authority): variantes de componentes — nunca strings condicionais de className
- **tailwind-merge**: merge de classes conflitantes

## Tokens obrigatórios — nunca hardcode

### Paleta semântica
| Token | Valor | Uso |
|---|---|---|
| `background` | `#FFFFFF` (paper) | Background de telas |
| `foreground` | `#1A1A1A` (ink) | Texto principal |
| `primary` | `#1A1A1A` (ink) | Ações primárias |
| `primary-foreground` | `#FFFFFF` (paper) | Texto sobre primary |
| `muted` | `#F5F5F2` (bone) | Superfícies secundárias |
| `muted-foreground` | `#6B6B66` (stone) | Texto secundário |
| `border` | `#D4D2CC` (ash) | Bordas e divisores |
| `destructive` | `#8B3A2F` (vermilion) | Ações destrutivas + favoritos ativos |

### Regra do vermilion
Vermilion aparece em **apenas dois contextos**: ícone de favorito ativo e ações destrutivas.
**Nunca** usar decorativamente.

## Tipografia — Geist (3 pesos apenas)
| Variante | Tamanho | Peso | Tracking | Cor |
|---|---|---|---|---|
| `display` | 40–56px | 300 | -0.04em | ink |
| `heading` | 24px | 500 | -0.02em | ink |
| `subheading` | 16px | 500 | -0.015em | ink |
| `body` | 16px | 400 | 0 | ink |
| `label` | 9–10px | 500 | +0.2em | stone |
| `caption` | 11–12px | 400 | 0 | stone |

- Labels **sempre em CAIXA ALTA** com tracking generoso
- Peso máximo: 500 Medium — **sem bold/700**
- Hierarquia via tamanho e tracking, não peso

## Padrões de componentes
- Cantos retos (`rounded-none`) em componentes internos
- Cantos de tela/modal: `rounded-3xl` (24px)
- **Sem sombras** (`shadow-none`) — não cabem no Editorial Modern
- Bordas: 1px, cor `border` (ash) — preferir `border-b` sobre box completo em inputs
- Componentes base em `src/shared/ui/`, exportados por `src/shared/ui/index.ts`

## Anti-patterns
```tsx
// ERRADO — nunca hardcode hex
<View style={{ backgroundColor: '#1a1a1a' }} />
<View className="bg-[#1a1a1a]" />
<View className="bg-zinc-900" />

// CORRETO
<View className="bg-primary" />
```

## Variantes com cva
```ts
const buttonVariants = cva('base-classes', {
  variants: {
    variant: { primary: '...', secondary: '...', ghost: '...' },
    size: { sm: '...', md: '...', lg: '...' },
  },
  defaultVariants: { variant: 'primary', size: 'md' },
});
```
