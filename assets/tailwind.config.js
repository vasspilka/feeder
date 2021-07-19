module.exports = {
  mode: 'jit',
  purge: [
    '../lib/**/*.ex',
    '../lib/**/*.eex',
    '../lib/**/*.heex',
    '../lib/**/*.leex',
    './js/**/*.js'
  ],
  theme: {
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
