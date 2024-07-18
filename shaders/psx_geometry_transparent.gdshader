shader_type spatial;

uniform vec4 albedo_color: source_color;
uniform sampler2D albedo_texture: filter_nearest;



void vertex() {
	
}

void fragment() {
	
	vec4 final_color = albedo_color * texture(albedo_texture, UV) * COLOR;
	ALBEDO = final_color.rgb;
    ALPHA = final_color.a;

}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
