shader_type sky;

uniform vec3 up_color: source_color;
uniform vec3 down_color: source_color;

void sky() {

    float gradient_factor = dot(EYEDIR, vec3(0.0, 1.0, 0.0)); // Dot product com a direção 'up'
    gradient_factor = clamp(gradient_factor, 0.0, 1.0);       // Limita o fator entre 0 e 1

    vec3 final_color = mix(down_color, up_color, gradient_factor); // Interpolação linear

    COLOR = final_color;
}
