const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    '../public/*.html',
    '../app/helpers/**/*.rb',
    '../app/javascript/*.{vue,js,ts,jsx,tsx}',
    '../app/javascript/**/*.{vue,js,ts,jsx,tsx}',
    '../app/javascript/components/**/*.{vue,js,ts,jsx,tsx}',
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
  ]
}
