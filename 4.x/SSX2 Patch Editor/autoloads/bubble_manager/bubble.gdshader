shader_type canvas_item;


uniform vec4 color: source_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform float inner_ring: hint_range(0.0, 0.5, 0.01) = 0.3;
uniform float outer_ring: hint_range(0.0, 0.5, 0.01) = 0.5;


void fragment() {
	float distance_to_middle = distance(UV, vec2(0.5, 0.5));

	if (inner_ring < distance_to_middle && distance_to_middle < outer_ring) {

		COLOR.a = 1.0;
	} else {
		COLOR.a = 0.0;
	}
	COLOR.rgb = color.rgb;
}