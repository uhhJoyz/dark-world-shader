// --------- lighting adjustments ------------

// time info:
// day : 0
// noon : 6000
// evening : 12000
// night : 18000

// adjust the lightmap from torch illumination
float adjustLightmapTorch(in float torch) {
	const float K = 4.0f;
	const float P = 5.06f;
	return K * pow(torch, P);
}

// adjust the lightmap from sky illumination
float adjustLightmapSky(in float sky) {
	float sky_2 = sky * sky;
	return sky_2 * sky_2;
}

// use the above adjust functions
vec2 adjustLightmap(in vec2 lightmap) {
	vec2 new_lightmap;
	new_lightmap.x = adjustLightmapTorch(lightmap.x);
	new_lightmap.y = adjustLightmapSky(lightmap.y);
	return new_lightmap;
}

// get the color resulting from the lightmap
vec3 getLightmapColor(in vec2 lightmap) {
	// adjust lightmap
	lightmap = adjustLightmap(lightmap);

	const vec3 torch_color = vec3(1.0f, 0.4f, 0.15f);
	vec3 sky_color = vec3(0.05f, 0.15f, 0.3f);
	
	// multiply the lightmap with its corresponding color
	vec3 torch_lighting = lightmap.x * torch_color;
	vec3 sky_lighting = lightmap.y * sky_color;
	
	// add lighting together to get the total lightmap
	vec3 lightmap_lighting = torch_lighting + 25.0f * sky_lighting;
	
	return lightmap_lighting;
}