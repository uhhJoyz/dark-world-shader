#version 120

varying vec2 texcoords;
varying vec3 normal;
varying vec4 color;

varying vec2 lightmap_coords;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferModelView;

uniform vec3 cameraPosition;

varying vec3 world_position;

vec4 lp = gl_ModelViewMatrix * gl_Vertex;

uniform int worldTime;

#include "/lib/deform.glsl"

#include "/lib/distance_3d.glsl"

#include "/lib/horror_lighting.glsl"

void main() {
	texcoords = gl_MultiTexCoord0.st;

	vec4 view_position = gbufferModelViewInverse * gl_ModelViewMatrix * gl_Vertex;
	vec4 position = view_position;

	world_position = view_position.xyz + cameraPosition.xyz;
	
	position.xyz = deform(position.xyz);
	
	gl_Position = gl_ProjectionMatrix * gbufferModelView * position;
	
	normal = gl_NormalMatrix * gl_Normal;
	
	color = horrorLighting();
	
	lightmap_coords = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.st;
	lightmap_coords = (lightmap_coords * 33.05f / 32.0f) - (1.05f /32.0f);
}
