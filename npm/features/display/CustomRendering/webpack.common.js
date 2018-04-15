const path = require ('path');

module.exports = {
	entry: "./build.hxml",
	output: {
		path: path.resolve (__dirname, "dist"),
		filename: "app.js"
	},
	resolve: {
		alias: {
			"openfl": path.resolve (__dirname, "node_modules/openfl/lib/openfl")
		}
	},
	module: {
		rules: [
			{
				test: /\.hxml$/,
				loader: 'haxe-loader',
			}
		]
	}
};