module.exports = {
  content: ["./**/*.{html,js,R,Rmd}"],
  theme: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/aspect-ratio'),
	require('@tailwindcss/line-clamp')
  ],
}
