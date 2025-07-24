package;

import openfl.filters.BitmapFilterShader;
import openfl.utils.ByteArray;

// Extends https://github.com/openfl/openfl/blob/develop/src/openfl/filters/BitmapFilterShader.hx
class CustomBitmapFilterShader extends BitmapFilterShader
{
	@:glVertexHeader("uniform vec4 vertexMultiplier;")
	@:glVertexBody("gl_Position *= vertexMultiplier;")
	@:glFragmentHeader("uniform vec4 fragmentMultiplier;")
	@:glFragmentBody("gl_FragColor *= fragmentMultiplier;")
	public function new(code:ByteArray = null)
	{
		super(code);
	}
}
