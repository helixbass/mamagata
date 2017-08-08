module.exports = {
  test: /\.coffee(\.erb)?$/,
  loader: ['babel-loader', 'eslint-loader', 'coffee-jsxy-loader'],
}
