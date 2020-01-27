shader_type spatial;
render_mode blend_add, unshaded, cull_disabled;

uniform vec3 impactLocation;
uniform vec3 impactDirection;
uniform float showTime;

void fragment() {
	// float shieldViewNormalLength = length(NORMAL.xy);
	float shieldViewNormalLength = 1. - dot(NORMAL, VIEW);
	ALPHA = min(1., shieldViewNormalLength * shieldViewNormalLength * showTime); // Rim-ish effect
	//ALPHA = 1. - dot(NORMAL, VIEW);
}