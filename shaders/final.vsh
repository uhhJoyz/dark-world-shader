#version 120

varying vec2 texcoords;
uniform mat4 gbufferModelViewInverse;

void main() {
	gl_Position = ftransform();
	texcoords = gl_MultiTexCoord0.st;
}
