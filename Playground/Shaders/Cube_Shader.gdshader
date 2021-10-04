shader_type spatial;
render_mode specular_toon;

uniform float height_scale = 0.5;
uniform sampler2D noise;
uniform sampler2D normalmap;

varying vec2 tex_position;

void vertex() {
  tex_position = VERTEX.xz / 4.0 + 0.5;
  float height = texture(noise, tex_position).x;
  VERTEX.y += height * height_scale;
}

void fragment() {
	NORMALMAP = texture(normalmap, tex_position).xyz;
	
	float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));
	RIM = 0.25;
	METALLIC = 0.0;
	ROUGHNESS = 0.01 * (1.0 - fresnel);
	ALBEDO = vec3(0.1, 0.3, 0.5) + (0.1 * fresnel);
	ALBEDO *= 0.01;
	ALPHA = 0.5;
}
