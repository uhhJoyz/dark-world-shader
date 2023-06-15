vec3 deform(in vec3 position) {
	lp = gbufferModelViewInverse * lp;
	
	float displacement = lp.z * lp.z + lp.x * lp.x;

	// daytime curvature is 45, nighttime is 25 at its lowest
	// lower is stronger curves
	const float day_curvature = 50.0f;
	const float night_curvature = 10.0f;
	const float curv_diff = day_curvature - night_curvature;
	float curvature = day_curvature;

	if (worldTime >= 11000) {
		curvature = day_curvature - curv_diff * (worldTime - 11000.0f)/1000.0f;
	}
	if (worldTime >= 12000) {
		curvature = night_curvature;
	}
	if (worldTime >= 23000) {
		curvature = night_curvature + curv_diff * (worldTime - 23000.0f)/1000.0f;
	}

	position.y -= displacement / curvature;
	
	lp = gbufferModelView * lp;
	return position;
}