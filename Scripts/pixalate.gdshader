shader_type canvas_item;

uniform vec2 pixel_size : hint_range(1, 64); // Controls the size of the pixels

void fragment() {
    // Get the UV coordinates
    vec2 uv = UV;
    
    // Pixelate the UV coordinates
    uv = floor(uv * pixel_size) / pixel_size;
    
    // Sample the texture using the pixelated UV
    vec4 color = texture(TEXTURE, uv);
    
    // Apply the color
    COLOR = color;
}
