#version 120

varying vec2 texcoords;
varying vec3 normal;
varying vec4 color;

varying vec2 lightmap_coords;

// texture atlas
uniform sampler2D texture;

void main() {
	// sample from texture atlas and account for biome color and ambient occlusion	
	vec4 albedo = texture2D(texture, texcoords) * color;
	/* DRAWBUFFERS:012 */
	gl_FragData[0] = albedo;
	gl_FragData[1] = vec4(normal * 0.5f + 0.5f, 1.0f);
	gl_FragData[2] = vec4(lightmap_coords, 0.0f, 1.0f);
}
