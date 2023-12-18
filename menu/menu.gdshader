shader_type canvas_item;

void vertex() {
}

float rand(vec2 st) {
	// Get a random float for a position x,y which is always the same. Like a hash
	// https://stackoverflow.com/questions/12964279/whats-the-origin-of-this-glsl-rand-one-liner
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
	float color = 0.0;

	if (rand(SCREEN_UV.xy) < 0.001) {
		color = 0.5 + sin(TIME*0.8);
	} else if (rand(SCREEN_UV.xy) < 0.002) {
		color = sin(5.0 + TIME*0.8) + 0.1;
	}
	
	COLOR = vec4(vec3(color),1.0);
}

void light() {
}
