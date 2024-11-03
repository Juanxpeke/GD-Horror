shader_type canvas_item;

uniform float frequency = 4.0;

uniform float speed_y = 4.0;
uniform float speed_x = 2.0;

void vertex() {
	VERTEX.y += sin((frequency * UV.x) + speed_y * TIME);
	VERTEX.x += sin((frequency * UV.x) + speed_x * TIME);
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
