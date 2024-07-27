shader_type spatial;

uniform vec4 albedo_color: source_color;
uniform sampler2D albedo_texture: filter_nearest;
uniform vec2 scale;
uniform float amplitude: hint_range(0.0, 1.0) = 0.1;
uniform float frequency: hint_range(0.0, 10.0) = 1.0;
uniform vec2 uv_speed = vec2(0.1, 0.1);

void vertex() {
    // Deslocamento de vértice baseado em uma onda senoidal
    VERTEX.y += sin(VERTEX.x * frequency + TIME) * amplitude;
	VERTEX.y += sin(VERTEX.x * frequency + TIME) * amplitude;
    VERTEX.z += sin(VERTEX.z * frequency + TIME) * amplitude;
}

void fragment() {
    // Deslocamento de UV baseado em uma onda senoidal
    vec2 displaced_uv = UV + vec2(sin(UV.y * frequency + TIME), cos(UV.x * frequency + TIME)) * amplitude * uv_speed;

    vec4 final_color = albedo_color * texture(albedo_texture, displaced_uv * scale) * COLOR;
    ALBEDO = final_color.rgb;
}