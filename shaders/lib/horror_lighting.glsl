attribute vec4 mc_Entity;

vec4 horrorLighting() {
	float displacement = distance3D();

	float inner_distance = 20.0f;	
	float outer_distance = 300.0f;
	
	if (worldTime >= 11000) {
		inner_distance = 20.0f - 10.0f * (float(worldTime) - 11000.0f)/1000.0f;
		outer_distance = 300.0f - 100.0f * (float(worldTime) - 11000.0f)/1000.0f;
	}
	if (worldTime >= 12000) {
		inner_distance = 10.0f;
		outer_distance = 200.0f;
	}
	if (worldTime >= 23000) {
		inner_distance = 10.0f + 10.0f * (float(worldTime) - 23000.0f)/1000.0f;
		outer_distance = 200.0f + 100.0f * (float(worldTime) - 23000.0f)/1000.0f;
	}
	color.xyz = gl_Color.xyz * 0.8125f + 0.1875;
	color.w = gl_Color.w;

	if (mc_Entity.x != 50 && mc_Entity.x != 76 && mc_Entity.x != 89) {
		color = gl_Color * 0.8125f + 0.1875 * ((inner_distance - displacement) / inner_distance);
	}

	float feather = (outer_distance - inner_distance)/4.0f;

	if (displacement > inner_distance) {
		float offset = displacement - inner_distance;
		if (mc_Entity.x != 50 && mc_Entity.x != 76 && mc_Entity.x != 89) {	
			color.xyz = (gl_Color * (0.8125f * (1.0f - offset/feather))).xyz;
			color.w = gl_Color.w;
		}
	}
	
	if (displacement > outer_distance) {
		if (mc_Entity.x != 50 && mc_Entity.x != 76 && mc_Entity.x != 89) {	
			color = vec4(vec3(0.0f), 1.0f);
		}
	}

	return color;
}