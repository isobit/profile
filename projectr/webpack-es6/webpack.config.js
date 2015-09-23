module.exports = {
  entry: "./src/main.js",
  output: {
    path: "./www",
    filename: "bundle.js"
  }, module: {
    loaders: [
      { test: /\.js$/, exclude: /node_modules/, loader: "babel?optional[]=runtime"},
      { test: /\.css$/, loader: "style!css!autoprefixer" }
    ]
  }
};
