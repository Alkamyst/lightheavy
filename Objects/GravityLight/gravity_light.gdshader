shader_type canvas_item;

uniform vec2 shadow_offset;

void fragment() {
	float baseHeight = shadow_offset.y + (VERTEX.x - shadow_offset.x) * 0.5;
	
	SHADOW_VERTEX.y = baseHeight;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
