shader_type canvas_item;

uniform vec4 bg_color : hint_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 fg_color : hint_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment(){
	vec4 tex_color = texture(SCREEN_TEXTURE, SCREEN_UV);
	COLOR.rgb = mix(fg_color.rgb, bg_color.rgb, tex_color.r);
}