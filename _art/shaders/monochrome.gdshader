shader_type canvas_item;

uniform vec4 color : source_color;

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	float brightness = (pixelColor.r + pixelColor.g + pixelColor.b) / 3.0;
	vec4 grayScale = vec4(brightness, brightness, brightness, pixelColor.a);
	COLOR = grayScale * color;
}