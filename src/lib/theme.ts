// Mirrors the semantic tokens in tailwind.config.js for use in StyleSheet.create()
// when className is not sufficient (e.g. dynamic style props).
export const colors = {
  // Named palette
  ink:       '#1A1A1A',
  paper:     '#FFFFFF',
  bone:      '#F5F5F2',
  stone:     '#6B6B66',
  ash:       '#D4D2CC',
  vermilion: '#8B3A2F',
  // Semantic tokens
  background:          '#FFFFFF',
  foreground:          '#1A1A1A',
  primary:             '#1A1A1A',
  primaryForeground:   '#FFFFFF',
  muted:               '#F5F5F2',
  mutedForeground:     '#6B6B66',
  border:              '#D4D2CC',
  destructive:         '#8B3A2F',
  destructiveForeground: '#FFFFFF',
} as const;

export type ColorToken = keyof typeof colors;

export const theme = { colors };
