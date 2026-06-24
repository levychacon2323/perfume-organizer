/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/**/*.{js,jsx,ts,tsx}',
    './src/**/*.{js,jsx,ts,tsx}',
  ],
  presets: [require('nativewind/preset')],
  theme: {
    extend: {
      colors: {
        // Named palette
        ink:       '#1A1A1A',
        paper:     '#FFFFFF',
        bone:      '#F5F5F2',
        stone:     '#6B6B66',
        ash:       '#D4D2CC',
        vermilion: '#8B3A2F',
        // Semantic tokens
        background: '#FFFFFF',
        foreground: '#1A1A1A',
        primary: {
          DEFAULT:    '#1A1A1A',
          foreground: '#FFFFFF',
        },
        muted: {
          DEFAULT:    '#F5F5F2',
          foreground: '#6B6B66',
        },
        border: '#D4D2CC',
        destructive: {
          DEFAULT:    '#8B3A2F',
          foreground: '#FFFFFF',
        },
      },
      fontFamily: {
        light:  ['Geist_300Light'],
        sans:   ['Geist_400Regular'],
        medium: ['Geist_500Medium'],
      },
      letterSpacing: {
        tightest: '-0.04em',
        tighter:  '-0.02em',
        tight:    '-0.015em',
        label:    '0.2em',
      },
      borderRadius: {
        DEFAULT: '8px',
        lg:      '12px',
        xl:      '16px',
      },
    },
  },
  plugins: [],
};
