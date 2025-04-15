shader_type canvas_item;

uniform sampler2D map: repeat_enable;
uniform vec2 player_pos;
uniform float player_angle;
uniform float screen_size_h;
uniform float val1 = 1.1;
uniform float val2 = 0.4;

void fragment() {
	if (UV.y < 0.5){
		COLOR = vec4(0.0, 0.749, 1.0, 1.0);
	} else {
		vec2 temp_uv = UV;
		temp_uv.y -= 0.5;
		
		vec2 world_pos = temp_uv-0.5;
		float c = cos(-player_angle+PI/2.0);
		float s = sin(-player_angle+PI/2.0);
		mat2 rotation_mat = mat2(vec2(c, -s), vec2(s, c));
		world_pos = rotation_mat * world_pos;
		
		float z = -(temp_uv.y+val1)*val2;
		world_pos.x = world_pos.x/z;
		world_pos.y = world_pos.y/z;
		
		world_pos += player_pos/screen_size_h;
		
		COLOR = texture(map, world_pos);
	};
}
