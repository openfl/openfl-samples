package shaders;

import openfl.display.Shader;
import openfl.display.Shader.GLShaderPrecision;

/**
 * @author felixturner / http://airtight.cc/
 *
 * RGB Shift Shader
 * Shifts red and blue channels from center in opposite directions
 * Ported from http://kriss.cx/tom/2009/05/rgb-shift/
 * by Tom Butterworth / http://kriss.cx/tom/
 *
 * amount: shift distance (1 is width of input)
 * angle: shift angle in radians
 */
class RGBShiftShader extends Shader {
	
	// https://github.com/mrdoob/three.js/blob/master/examples/js/shaders/RGBShiftShader.js
	@fragment var code = [

		'uniform float amount;',
		'uniform float angle;',

		'void main() {',
			'vec2 offset = amount * vec2( cos(angle), sin(angle));',
			'vec4 cr = texture2D(${Shader.uSampler}, ${Shader.vTexCoord} + offset);',
			'vec4 cga = texture2D(${Shader.uSampler}, ${Shader.vTexCoord});',
			'vec4 cb = texture2D(${Shader.uSampler}, ${Shader.vTexCoord} - offset);',
			'gl_FragColor = vec4(cr.r, cga.g, cb.b, cga.a);',
		'}'
	];
	
	public function new() {
		super();
		
		amount = 0.005;
		angle = 1.0;
	}
}