const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    '../public/*.html',
    '../app/helpers/**/*.rb',
    '../app/frontend/*.{vue,js,ts,jsx,tsx}',
    '../app/frontend/**/*.{vue,js,ts,jsx,tsx}',
    '../app/frontend/components/**/*.{vue,js,ts,jsx,tsx}',
    '../app/assets/tailwind/**/*.css',
    '../app/views/**/*.{html,html.erb,erb,slim,html.slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ],
  darkMode: 'class',
}
