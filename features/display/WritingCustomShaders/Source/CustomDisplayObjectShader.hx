package;

import openfl.display.DisplayObjectShader;
import openfl.utils.ByteArray;

// Extends https://github.com/openfl/openfl/blob/develop/src/openfl/display/DisplayObjectShader.hx
class CustomDisplayObjectShader extends DisplayObjectShader
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
