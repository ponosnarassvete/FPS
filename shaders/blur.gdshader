shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float amount: hint_range(0.0, 5.0);
uniform sampler2D vignette;

void fragment() {
	COLOR.rgb = textureLod(SCREEN_TEXTURE, SCREEN_UV, amount).rgb;

	vec3 vignette_color = texture(vignette, UV).rgb;
	// Screen texture stores gaussian blurred copies on mipmaps.
	COLOR.rgb = textureLod(SCREEN_TEXTURE, SCREEN_UV, (1.0 - vignette_color.r) * 2.0).rgb;
	COLOR.rgb *= texture(vignette, UV).rgb;
}