var webpack = require('webpack');
var vue = require('vue-loader');
var bourbon = require('node-bourbon');

var jsLoader = 'babel?optional[]=runtime,stage=1';
var cssLoader = "style!css!autoprefixer";
var scssLoader = 'style!css!sass?sourceMap&includePaths[]=' + bourbon.includePaths;

module.exports = {
	entry: "./src/main.js",
	output: {
		path: "./dist",
		publicPath: '/dist/',
		filename: "build.js"
	}, 
	module: {
		loaders: [
			{
				test: /\.js$/, 
				exclude: /node_modules/, 
				loader: jsLoader
			},
			{
				test: /\.css$/, 
				loader: cssLoader
			},
			{
				test: /\.scss$/, 
				loader: scssLoader
			},
			{
				test: /\.vue$/,
				loader: vue.withLoaders({
					js: jsLoader,
					css: cssLoader,
					scss: scssLoader
				})
			}
		]
	}
};

if (process.env.NODE_ENV === 'production') {
	module.exports.plugins = [
		new webpack.DefinePlugin({
			'process.env': {
				NODE_ENV: '"production"'
			}
		}),
		new webpack.optimize.UglifyJsPlugin({
			compress: {
				warnings: false
			}
		}),
		new webpack.optimize.OccurenceOrderPlugin()
	]
} else {
	module.exports.devtool = '#source-map'
}
