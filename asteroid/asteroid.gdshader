shader_type spatial;

render_mode unshaded, wireframe, depth_test_disabled;
 
uniform float border_width : hint_range(-1,1,0.001);

void vertex() {
	VERTEX = (VERTEX * border_width) + VERTEX;
}

void fragment() {
	vec3 warningGridColor;
	warningGridColor.r =  (sin(TIME * 15.0) + 1.0) * 0.5;
	warningGridColor.g = 0.1;
	warningGridColor.b = 0.1;
	ALBEDO = warningGridColor;
}

void light() {
	// Called for every pixel for every light affecting the material.
}
