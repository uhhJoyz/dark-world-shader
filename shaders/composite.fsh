#version 120

varying vec2 texcoords;

uniform vec3 sunPosition;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D depthtex0;

/*
const int colortex0Format = RGBA16;
const int colortex1Format = RGB16;
const int colortex2Format = RGB16;
*/

uniform float dist3D;

const float sunRotation = -40.0f;

const float ambient = 0.0f;

uniform vec3 skyColor;

uniform int worldTime;

#include "/lib/lighting_calculations.glsl"

void main() {
	// account for gamma correction
	vec3 albedo = pow(texture2D(colortex0, texcoords).rgb, vec3(0.9f));

	// --------- fix sky -------------
	// without this, the sky is a normal color, which we can't have
	float depth = texture2D(depthtex0, texcoords).r;
	if (depth == 1.0f) {
		/* DRAWBUFFERS:0 */
		gl_FragData[0] = vec4(vec3(0.0f), 1.0f);
		return;
	}
	
	// get the normal
	vec3 normal = normalize(texture2D(colortex1, texcoords).rgb * 2.0f - 1.0f);

	// do lighting calculations
	vec2 lightmap = texture2D(colortex2, texcoords).rg;
	lightmap.r = pow(lightmap.r, 2.0f);
	lightmap = lightmap * 1.2f;
	
	// get lightmap color
	vec3 lightmap_color = getLightmapColor(lightmap) + 0.15f;
	
	// compute cos of angle between normal and sun directions
	float NdotL = max(dot(normal, normalize(sunPosition)), 0.0f);

	// compute diffuse value
	vec3 diffuse = albedo * (lightmap_color + NdotL + ambient);
	
	// write the diffuse color
	/* DRAWBUFFERS:0 */
	gl_FragData[0] = vec4(diffuse, 1.0f);
}	
