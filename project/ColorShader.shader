shader_type canvas_item;

uniform vec4 bg_color : hint_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 fg_color : hint_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment(){
  vec4 tex_color = texture(SCREEN_TEXTURE, SCREEN_UV);
  if ((tex_color.r + tex_color.g + tex_color.b)/3.0 <= .5){
	COLOR = bg_color;
  }
  else{
	COLOR = fg_color;
  }
}