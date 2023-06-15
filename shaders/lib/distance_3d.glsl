float distance3D(void) {
	lp = gbufferModelViewInverse * lp;
	
	float displacement = lp.y * lp.y + lp.z * lp.z + lp.x * lp.x;
	
	lp = gbufferModelView * lp;
	return displacement;
}
