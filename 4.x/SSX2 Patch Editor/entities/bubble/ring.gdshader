shader_type spatial;
render_mode depth_test_disabled, unshaded;


uniform float size: hint_range(0.0, 0.5, 0.001) = 0.1;
uniform vec4 color: source_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform float inner_ring: hint_range(0.0, 0.5, 0.01) = 0.3;
uniform float outer_ring: hint_range(0.0, 0.5, 0.01) = 0.5;


void vertex() {
	float distance_from_cam = distance(NODE_POSITION_WORLD, CAMERA_POSITION_WORLD);
	mat4 billboard = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	MODELVIEW_MATRIX = billboard;
	VERTEX *= vec3(distance_from_cam * size);
}


void fragment() {
	float distance_to_middle = distance(UV, vec2(0.5, 0.5));

	if (inner_ring < distance_to_middle && distance_to_middle < outer_ring) {
		ALPHA = 1.0;
	} else {
		ALPHA = 0.0;
	}
	ALBEDO = color.rgb;
}
