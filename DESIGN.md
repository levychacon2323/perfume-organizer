# Perfume Organizer — Design System

Complete record of visual direction, design decisions, and component specifications
for the Perfume Organizer app.

---

## Visual Direction

### Chosen aesthetic: Editorial Modern

**References:** Byredo, COS, Aesop

**Core concept:** The user's collection treated as a museum archive — curated,
catalogued, displayed with editorial confidence. Typography does the heavy
lifting. Color is scarce and intentional.

**What this means in practice:**
- A single typeface in three weights (no mixing families)
- Five neutrals + one accent color — the accent appears rarely, so when it does,
  it means something
- Straight or near-straight corners on internal elements; rounding only on screen
  containers
- Thin 1px borders and line separators instead of boxed cards
- Generous whitespace — space is a design element, not empty space
- Labels always in ALL CAPS with generous letter-spacing
- No decorative shadows (doesn't fit the style)

**Directions considered and not chosen:**
- Boutique Classic Luxury (Le Labo, Frederic Malle) — serif-heavy, amber palette,
  warmer. Rejected in favor of more contemporary feel.
- Apothecary/Artisanal — textural, earthy tones, handcrafted feel. Considered
  seriously but Editorial Modern communicates more technical maturity for portfolio.
- Tech Minimalist (Notion-like) — too neutral, not enough identity for a
  perfume app.

---

## Color Palette

### Named colors

| Token | Hex | Name | Role |
|---|---|---|---|
| `paper` | `#FFFFFF` | White | Base background, cards |
| `bone` | `#F5F5F2` | Off-white | Secondary surfaces |
| `ash` | `#D4D2CC` | Warm gray | Borders, dividers |
| `stone` | `#6B6B66` | Mid gray | Secondary/muted text |
| `ink` | `#1A1A1A` | Near-black | Primary text, buttons, main color |
| `vermilion` | `#8B3A2F` | Deep red | Single accent |

### Semantic tokens (map to named colors above)

| Token | Value | Use |
|---|---|---|
| `background` | `#FFFFFF` (paper) | Screen background |
| `foreground` | `#1A1A1A` (ink) | Default text |
| `primary.DEFAULT` | `#1A1A1A` (ink) | Primary actions |
| `primary.foreground` | `#FFFFFF` (paper) | Text on primary |
| `muted.DEFAULT` | `#F5F5F2` (bone) | Muted surfaces |
| `muted.foreground` | `#6B6B66` (stone) | Muted text |
| `border` | `#D4D2CC` (ash) | Default borders |
| `destructive.DEFAULT` | `#8B3A2F` (vermilion) | Destructive actions |
| `destructive.foreground` | `#FFFFFF` (paper) | Text on destructive |

### The vermilion rule

Vermilion is the **only accent color**. It appears in exactly two contexts:
1. **Favorites** — heart icon when active
2. **Destructive actions** — delete buttons, error states

In a full screen of perfumes, 90% should be mono (paper/bone/ink). When
vermilion appears, it earns attention by scarcity. Never use it decoratively.

---

## Typography

### Chosen typeface: Geist

**Source:** `@expo-google-fonts/geist`
**Why Geist over Inter:** More condensed and geometric, giving a slightly more
technical and contemporary feel that fits "curated archive" better than Inter's
neutrality. Both are free; Geist is more distinctive.

### Weights used (three only)

| Weight | Font name | CSS equivalent | Role |
|---|---|---|---|
| 300 | `Geist_300Light` | Light | Display, contemplative large text |
| 400 | `Geist_400Regular` | Regular | Body text, descriptions |
| 500 | `Geist_500Medium` | Medium | Hierarchy, emphasis, buttons |

**No 700 (Bold).** Editorial Modern achieves hierarchy through size and tracking,
not heavy weight. Medium (500) is the maximum.

### Type scale

| Variant | Size | Weight | Tracking | Color | Use |
|---|---|---|---|---|---|
| `display` | 40–56px | 300/500 mix | -0.04em | ink | Screen headers, perfume names |
| `heading` | 24px | 500 | -0.02em | ink | Section headings, H2 |
| `subheading` | 16px | 500 | -0.015em | ink | Subsections |
| `body` | 16px | 400 | 0 | ink | Descriptions, impressions |
| `label` | 9–10px | 500 | +0.2em | stone | ALL CAPS labels above fields |
| `caption` | 11–12px | 400 | 0 | stone | Metadata, secondary info |

### Letter-spacing tokens

```js
letterSpacing: {
  tightest: '-0.04em',  // display — large headings
  tighter:  '-0.02em',  // heading
  tight:    '-0.015em', // subheading
  label:    '0.2em',    // ALL CAPS labels
}
```

### Typography rules

- Sentence case everywhere **except** labels, which are ALL CAPS
- Display text at top of detail screens: name on one line light, rest medium,
  tight tracking — creates the "magazine spread" effect
- Numbers (price, ml, year) use mono fallback for alignment:
  `font-family: 'SF Mono', Menlo, monospace`

---

## Component Specifications

### Shared principles for all components

- `cva` (class-variance-authority) manages variants — never conditional className strings
- NativeWind classes via `className` prop
- Semantic tokens only — never raw hex values in components
- All components exported from `src/shared/ui/index.ts`
- Properly typed with TypeScript — no `any`
- Straight corners on all internal components (border-radius: 0 or minimal)
- Screen/modal containers may use border-radius: 24px

---

### Component: Text

Foundation of all typographic elements. Every text in the app goes through this.

**Variants:** `display` | `heading` | `subheading` | `body` | `label` | `caption`

**Props:**
- `variant` — required
- `color` — optional, defaults to `foreground`
- `children` — required
- All standard React Native Text props via spread

**Implementation pattern:**
```tsx
const textVariants = cva('', {
  variants: {
    variant: {
      display:    'font-light text-5xl tracking-tightest text-foreground',
      heading:    'font-medium text-2xl tracking-tighter text-foreground',
      subheading: 'font-medium text-base tracking-tight text-foreground',
      body:       'font-sans text-base text-foreground',
      label:      'font-medium text-[10px] tracking-label uppercase text-stone',
      caption:    'font-sans text-xs text-stone',
    },
  },
});
```

---

### Component: Button

Three variants covering all action contexts.

**Variants:** `primary` | `secondary` | `ghost`

**Sizes:** `sm` | `md` | `lg`

**States:** default | disabled | loading

**Visual rules:**
- Text always in ALL CAPS with tracking
- `primary`: ink background, paper text
- `secondary`: transparent background, ink border (1px)
- `ghost`: no background, no border, ink text
- Straight corners (border-radius: 0)
- Loading state shows ActivityIndicator in text color

---

### Component: Input

Text field with editorial styling.

**States:** default | focused | error | disabled

**Visual rules:**
- Label in ALL CAPS above the field (Text variant="label")
- Bottom border only (`border-b`) — not a full box
- Default border: `ash`
- Focused border: `ink`
- Error border: `vermilion` + error message below in vermilion/caption
- No background on the field itself (inherits surface)
- forwardRef for react-hook-form Controller compatibility

---

### Component: Card

Contained surface for grouping related content.

**Variants:** `default` | `flat`

**Visual rules:**
- `default`: white background, 1px `ash` border
- `flat`: bone background, no border
- No shadow (shadows don't fit Editorial Modern)
- Configurable padding via prop
- Children accept any content

---

### Component: Tag

Compact chip for fragrance notes, categories, occasions.

**Variants:** `filled` | `outline`

**Visual rules:**
- `filled`: ink background, paper text
- `outline`: transparent background, ink border
- Text in ALL CAPS with moderate tracking
- Straight corners
- Optional `onPress` for interactive/selectable tags
- Compact horizontal padding

**Usage contexts:**
- Olfactory pyramid (top/heart/base notes) — outline
- Occasion on wear session — filled for selected, outline for options
- User-defined tags — outline

---

### Component: Rating

Bar-based indicator (not stars). Used for longevity, projection, sillage.

**Variants:** `readonly` | `interactive`

**Visual rules:**
- Thin horizontal bars (height: 4px)
- Filled bar: `ink`
- Empty bar: `ash`
- Gap of 2px between bars
- Optional label to the right (Text variant="caption")
- Interactive variant: bars are Pressable, selecting N fills 1→N

**Usage:**
```tsx
<Rating value={4} max={5} label="Longevity" />
<Rating value={projectionRating} max={5} onChange={setProjectionRating} />
```

---

## Layout Patterns

### List screens (collection, wishlist, samples)

Editorial Modern lists use **line separators**, not cards.

- Items separated by 1px `ash` border-bottom
- No card background per item
- Brand in ALL CAPS label above the name
- Name in heading/subheading weight
- Metadata (ml, concentration) in caption/stone
- Favorite icon on the right — stone when inactive, vermilion when active
- Empty state: centered, heading + body text, no illustration (editorial)

### Detail screens (perfume detail)

- **Header section:** dark background (ink), large display text in paper/white,
  concentration and year in label/stone. This is the signature "magazine spread"
  of the app.
- **Stats block:** three columns (longevity, projection, sillage) with monospaced
  number + label below
- **Content sections:** white background, each section separated by 1px ash border
- **Timeline entries** (impressions): left border in ink (2px), date in label,
  body in body text

### Forms

Multi-step where needed (perfume entry is 3 steps: identification, bottle, purchase).

- Step indicator: small caps label "Step N / N"
- Each field: label (ALL CAPS) → input (bottom border)
- Segmented selectors (concentration, gender): horizontal row of outline tags,
  selected one becomes filled
- Primary action button at the bottom: full width, ink
- Straight corners throughout

---

## Motion and Interaction

Kept minimal to match the editorial restraint.

- **List item press:** slight opacity change (0.7) on press, no scale
- **Screen transitions:** default Expo Router (slide) — don't customize yet
- **Loading states:** ActivityIndicator in ink color, no spinners or skeleton screens
- **Confirmation dialogs:** native Alert for destructive actions (delete)
- No bounce, no spring, no complex animations in MVP

---

## Showcase Screen

A dev-only route (`app/showcase.tsx`) renders all components for visual inspection.

Purpose: catch inconsistencies between components before they appear in features.
Acts as a living style guide during development.

Not shipped in production — conditionally rendered only in `__DEV__` mode,
or removed before store submission.

---

## Decisions Log

| Decision | Rationale |
|---|---|
| Editorial Modern over Apothecary | More technical maturity for portfolio; better fit for "cataloguing" mental model |
| Geist over Inter | More distinctive; contemporary feel; both free |
| Three weights only (300/400/500) | Restriction is intentional — hierarchy via size/tracking, not weight |
| Bars over stars for ratings | Stars feel casual; bars fit editorial precision |
| Lines over cards for lists | Cards "enclose" items; lines let the list breathe editorially |
| Straight corners on components | Rounded corners are friendly/casual; straight corners are precise/editorial |
| Single accent (vermilion) | Scarcity makes the accent meaningful; more colors = less impact per color |
| No shadows | Shadows add depth/warmth that conflicts with the flat editorial aesthetic |
| Dark header on detail screens | Creates a "cover page" moment that editorial magazines use |