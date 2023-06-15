#version 120

varying vec2 texcoords;
uniform sampler2D colortex0;

uniform int worldTime;

#include "/lib/Settings.glsl"

// a method that adjusts the colors to fit into 5 stages
vec3 retroColor(in vec3 color) {
	
	// set up 5 color stages
	const vec3 c1 = vec3(16.0f/255.0f, 0.0f/255.0f, 43.0f/255.0f);
	const vec3 c2 = vec3(60.0f/255.0f, 9.0f/255.0f, 108.0f/255.0f);
	const vec3 c3 = vec3(90.0f/255.0f, 24.0f/255.0f, 154.0f/255.0f);
	const vec3 c4 = vec3(157.0f/255.0f, 78.0f/255.0f, 221.0f/255.0f);
	const vec3 c5 = vec3(224.0f/255.0f, 170.0f/255.0f, 255.0f/255.0f);
	
	// find the grayscale
	float grayscale = dot(color.rgb, vec3(0.33f));
	grayscale = min(1.0f, grayscale);
	vec3 final_color;

	const float color_count = 12.0f;

	#ifndef WINDOWS_11

	grayscale = pow(grayscale, 1.5f);

	if (worldTime >= 11000 && worldTime < 12000) {
		grayscale = pow(grayscale, 1.5f + (2.5f * (float(worldTime) - 11000.0f)/1000.0f)) - 0.07f * (float(worldTime) - 11000.0f)/1000.0f;
	}
	else if (worldTime >= 12000 && worldTime < 23000) {
		grayscale = pow(grayscale, 1.5f + 2.5f);
	}
	else if (worldTime >= 23000) {
		grayscale = pow(grayscale, 4.0f - (2.5f * (float(worldTime) - 23000.0f)/1000.0f)) - 0.07f * (1.0f-(float(worldTime) - 23000.0f)/1000.0f);
	}
	#endif
	
	#ifdef WINDOWS_11

	grayscale = pow(grayscale, 0.25f);

	#endif
	grayscale = color_count * grayscale;
	grayscale = float(round(grayscale))/color_count;
	
	// select the proper color based on the grayscale
	if (grayscale > 0.8f) {
		final_color = vec3(grayscale) * c5;
	} else if (grayscale > 0.6f) {
		final_color = vec3(grayscale) * c4;
	} else if (grayscale > 0.4f) {
		final_color = vec3(grayscale) * c3;
	} else if (grayscale > 0.2f) {
		final_color = vec3(grayscale) * c2;
	} else {
		final_color = vec3(grayscale) * c1;
	}

	return final_color;
}

// pixelation method based on lawlessc's olive retro shader on github
vec2 pixelate(in float dx, in float dy) {
	return vec2(dx * floor(texcoords.x/dx), dy * floor(texcoords.y/dy));
}

// --------------- gaussian blur ----------------
// unused
const float pi2 = 6.2831853f;

vec3 blur(in vec2 texcoord) {
	vec3 blr = texture2D(colortex0, texcoord).rgb * 0.125f;
	const float radius = 8.0f;
	const vec2 offset_x = vec2(0.0024f, 0.0f);
	const vec2 offset_y = vec2(0.0f, 0.0024f);

	for (float fl = 1.0f; fl <= radius; fl++) {
		blr += texture2D(colortex0, texcoord + fl * offset_x).rgb * 1.0f/(2.0f*radius);
		blr += texture2D(colortex0, texcoord - fl * offset_x).rgb * 1.0f/(2.0f*radius);

		blr += texture2D(colortex0, texcoord + fl * offset_y).rgb * 1.0f/(2.0f*radius);
		blr += texture2D(colortex0, texcoord - fl * offset_y).rgb * 1.0f/(2.0f*radius);
	}
	return blr;
}

// -------------- main method ------------------
void main() {
	// set pixel sizes
	const float dx = 0.00859375f*0.5f;
	const float dy = 0.00483396f*0.5f;
	vec2 coordinates = pixelate(dx, dy);

	//vec3 color = texture2D(colortex0, texcoords).rgb;
	vec3 color = texture2D(colortex0, coordinates).rgb;
	color = retroColor(color);
	gl_FragColor = vec4(color, 1.0f);
}
