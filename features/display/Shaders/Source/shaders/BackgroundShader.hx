package shaders;

import openfl.display.Shader;

class BackgroundShader extends Shader {

	// Created by inigo quilez - iq/2015
	// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
	// https://www.shadertoy.com/view/Ml2GWy
	@fragment var code = [
	'uniform float uZoom;',
	'uniform float uGlobalTime;',
	'uniform vec2 uMovement;',
	'uniform sampler2D uSampler1;',
	'void main() {',
	'    vec2 pos = 256.0*gl_FragCoord.xy/uZoom;',
	'    pos -= uMovement;',
	'    vec3 col = vec3(0.0);',
	'    for( int i=0; i<6; i++ ) ',
	'    {',
	'        vec2 a = floor(pos);',
	'        vec2 b = fract(pos);',
	'        vec4 w = fract((sin(a.x*7.0+31.0*a.y + 0.01*uGlobalTime)+vec4(0.035,0.01,0.0,0.7))*13.545317); // randoms',
	'        col += w.xyz *                                   // color',
	'               smoothstep(0.45,0.55,w.w) *               // intensity',
	'               sqrt( 16.0*b.x*b.y*(1.0-b.x)*(1.0-b.y) ); // pattern',
	'        pos /= 2.0; // lacunarity',
	'        col /= 2.0; // attenuate high frequencies',
	'    }',
	'    col = pow( 2.5*col, vec3(1.0,1.0,0.7) );    // contrast and color shape',
	'    vec4 final = vec4( col, 1.0 ) * texture2D(uSampler1, ${Shader.vTexCoord});',
	'    gl_FragColor = colorTransform(final, ${Shader.vColor}, ${Shader.uColorMultiplier}, ${Shader.uColorOffset});',
	'}',
	];
	
	public function new() {
		super();
		// default values
		uZoom = 800;
		// we can access the automatically created GLShaderParamenter to change some values we can't change with the public property
		__uSampler1.smooth = true;
	}
	
}