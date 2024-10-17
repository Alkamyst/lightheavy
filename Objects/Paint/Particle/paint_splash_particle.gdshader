shader_type canvas_item;

uniform vec4 color : source_color;

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	
	COLOR.rgb = textureLod(TEXTURE, UV, 0.0).rgb;
	COLOR = mix(pixelColor, color, 0.5);
	COLOR.a *= pixelColor.a;
}
