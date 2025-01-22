shader_type canvas_item;

uniform float time_multiplier : hint_range(0.0, 5.0) = 1.0;
uniform float intensity : hint_range(0.0, 1.0) = 0.1;

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
    vec2 uv = UV;

    // Calculate the distance from the center (normalized)
    float dist_from_center = length(uv - vec2(0.5));

    // Invert and scale the distance so the effect is strongest at the center
    float effect_strength = 1.0 - smoothstep(0.0, 0.5, dist_from_center);

    // Apply warp effect based on distance from center
    uv.x += sin(uv.y * 10.0 + TIME * time_multiplier) * intensity * effect_strength;
    uv.y += cos(uv.x * 10.0 + TIME * time_multiplier) * intensity * effect_strength;

    // Calculate color hue based on UV coordinates
    float hue = mod(uv.x + TIME * time_multiplier, 1.0);
    vec3 color = hsv2rgb(vec3(hue, 0.2, 1.0));

    // Sample the texture and combine with the color
    vec4 tex = texture(TEXTURE, uv);
    COLOR = vec4(color.rgb * tex.a, tex.a);
}
