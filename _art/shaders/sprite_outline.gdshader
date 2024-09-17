shader_type canvas_item;
 
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec4 line_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float line_thickness : hint_range(0, 10) = 1.0;
uniform float alpha: hint_range(0.0, 1.0) = 1;
 
const vec2 OFFSETS[4] = {
	vec2(-1, 0), vec2(0, -1), vec2(0, 1), vec2(1, 0)
};

void fragment() {
	vec2 size = SCREEN_PIXEL_SIZE * line_thickness;
	float outline = 0.0;
 
	for (int i = 0; i < OFFSETS.length(); i++) {
		//texture_color.a = texture(TEXTURE, SCREEN_UV + size * OFFSETS[i]).a;
		outline += texture(screen_texture, SCREEN_UV + size * OFFSETS[i]).a;
	}
	outline = min(outline, 1.0);
 
	vec4 color = texture(screen_texture, SCREEN_UV);
	COLOR = mix(color, line_color, outline - color.a);
}
