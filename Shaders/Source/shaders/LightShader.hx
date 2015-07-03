package shaders;
import openfl.display.Shader;

class LightShader extends Shader {

	// based on https://github.com/mattdesl/lwjgl-basics/wiki/ShaderLesson6
	@fragment var fragment = [
		'uniform vec3 uLightPos;',
		'uniform vec4 uLightColor;',
		'uniform vec4 uAmbientColor;',
		'uniform vec3 uFalloff;',
		'uniform vec2 uResolution;',
		'uniform sampler2D uSamplerN;',
		
		'void main(void) {',
		'	vec4 dc = texture2D(${Shader.uSampler}, ${Shader.vTexCoord});',
		'	vec3 nc = texture2D(uSamplerN, ${Shader.vTexCoord}).rgb;',
		
		'	vec3 ld = vec3((uLightPos.xy/uResolution.xy) - ${Shader.vTexCoord}, uLightPos.z);',
		'	ld.x   *= uResolution.x / uResolution.y;',
		
		'	float D = length(ld);',
		'	vec3  N = normalize(nc * 2.0 - 1.0);',
		'	vec3  L = normalize(ld);',
		
		'	vec3 diffuse = (uLightColor.rgb * uLightColor.a) * max(dot(N, L), 0.0);',
		'	vec3 ambient = uAmbientColor.rgb * uAmbientColor.a;',
		
		'	float attenuation = 1.0 / ( uFalloff.x + (uFalloff.y*D) + (uFalloff.z*D*D) );',
		'	vec3  intensity   = ambient + diffuse * attenuation;',
		'	vec3  finalColor  = dc.rgb * intensity;',
		
		'	gl_FragColor = colorTransform(vec4(finalColor, dc.a), ${Shader.vColor}, ${Shader.uColorMultiplier}, ${Shader.uColorOffset});',
		'}',
	];
	
	public function new() {
		super();
	}
}