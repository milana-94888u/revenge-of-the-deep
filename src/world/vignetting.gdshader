shader_type canvas_item;


void fragment() {
	vec2 modifiers = cos(SCREEN_UV - vec2(0.5));
	COLOR.a = 1.0 - pow(modifiers.x * modifiers.y, 1.5 + cos(TIME) * 0.5);
}