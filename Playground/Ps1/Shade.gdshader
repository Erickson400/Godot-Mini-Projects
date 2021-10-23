shader_type spatial;
render_mode specular_toon, unshaded;

uniform vec4 color:hint_color;

void fragment(){
	float prod = dot(NORMAL, VIEW);
	ALBEDO = color.rgb * prod; //dot(NORMAL, VIEW)
}