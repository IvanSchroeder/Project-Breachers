shader_type canvas_item;

uniform bool active = false;
uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_nearest;
/**
 * The color of the flashing effect
 */
uniform vec4 flash_color: source_color = vec4(1.0);
/**
 * The amount of flashing, like alpha
 */
uniform float flash_modifier: hint_range(0.0, 1.0) = 1;
/**
 * The alpha of the sprite
 */
uniform float alpha: hint_range(0.0, 1.0) = 1;

uniform float pixelate_amount: hint_range(0.1, 1) = 1;

void fragment() {
	// Pixelation
	vec2 pixelNumber = vec2(textureSize(TEXTURE, 0)) * pixelate_amount;
	vec2 grid_uv = (floor(UV * pixelNumber) + 0.5) / pixelNumber;

	vec4 texture_color = texture(TEXTURE, grid_uv);
	vec4 screen_color = texture(screen_texture, SCREEN_UV);

	// Flash Effect
	if (active) {
		if (texture_color.a != 0.0)
			texture_color.a = alpha;
			texture_color.rgb = mix(texture_color.rgb, flash_color.rgb, flash_modifier);
		COLOR = texture_color;
	}
	else COLOR = texture_color;
}
