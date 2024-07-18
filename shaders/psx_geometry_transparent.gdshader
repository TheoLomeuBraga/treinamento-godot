shader_type spatial;

uniform vec4 color: source_color;
uniform sampler2D tex: filter_nearest;

void vertex() {
	
}

void fragment() {
	
	vec4 final_color = color * texture(tex, UV) * COLOR;
	ALBEDO = final_color.rgb;
    ALPHA = final_color.a;

}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
