var bourbon = require('node-bourbon').includePaths;
module.exports = {
  entry: "./src/main.js",
  output: {
    path: "./www",
    filename: "bundle.js"
  }, module: {
    loaders: [
      {test: /\.js$/, exclude: /node_modules/, loader: "babel?optional[]=runtime,stage=1"},
      {test: /\.css$/, loader: "style!css!autoprefixer"},
      {test: /\.scss$/, loader: "style!css!sass?sourceMap&includePaths[]=" + bourbon}
    ]
  }
};
