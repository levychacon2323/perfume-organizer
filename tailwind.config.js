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
        primary: {
          DEFAULT: '#1A1410',
          foreground: '#FFFFFF',
        },
        background: '#FAF7F2',
        foreground: '#1A1410',
        card: '#FFFFFF',
        muted: '#F0EAE0',
        'muted-foreground': '#6B5D52',
        border: '#E0D6C8',
        destructive: {
          DEFAULT: '#B23A48',
          foreground: '#FFFFFF',
        },
      },
      fontFamily: {
        sans: ['System'],
      },
      borderRadius: {
        DEFAULT: '8px',
        lg: '12px',
        xl: '16px',
      },
    },
  },
  plugins: [],
};
