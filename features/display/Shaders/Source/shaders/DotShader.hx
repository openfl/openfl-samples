package shaders;

import openfl.display.Shader;

/**
 * @author alteredq / http://alteredqualia.com/
 *
 * Dot screen shader
 * based on glfx.js sepia shader
 * https://github.com/evanw/glfx.js
 */
class DotShader extends Shader {
	
	// https://github.com/mrdoob/three.js/blob/master/examples/js/shaders/DotScreenShader.js
	@fragment var fragment = [

		'uniform vec2 center;',
		'uniform float angle;',
		'uniform float scale;',

		'float pattern() {',
			'float s = sin( angle ), c = cos( angle );',
			'vec2 tex = ${Shader.vTexCoord} * ${Shader.uTextureSize} - center;',
			'vec2 point = vec2( c * tex.x - s * tex.y, s * tex.x + c * tex.y ) * scale;',
			'return ( sin( point.x ) * sin( point.y ) ) * 4.0;',
		'}',

		'void main() {',
			'vec4 color = texture2D( ${Shader.uSampler}, ${Shader.vTexCoord} );',
			'float average = ( color.r + color.g + color.b ) / 3.0;',
			'float p = pattern();',
			'gl_FragColor = vec4(vec3( average * 10.0 - 5.0 + p ), color.a);',
		'}'
	];
	
	public function new() {
		super();
		
		//default values
		scale = 0.5;
		angle = 1.57;
		center = [0.5, 0.5];
	}
	
}