shader_type canvas_item;

// Painterly post-process: Kuwahara filter + posterization + paper grain.
// Applied as a fullscreen ColorRect on a CanvasLayer above the 3D viewport.
// Performance: ~25 texture samples per pixel — fine on desktop, tune RADIUS down on mobile.

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

uniform float strength : hint_range(0.0, 1.0) = 0.85;
uniform int radius : hint_range(1, 4) = 2;
uniform float posterize_levels : hint_range(2.0, 32.0) = 12.0;
uniform float grain_strength : hint_range(0.0, 0.4) = 0.06;
uniform float saturation : hint_range(0.5, 1.5) = 1.05;

// Hash for grain
float hash(vec2 p) {
	p = fract(p * vec2(443.897, 441.423));
	p += dot(p, p.yx + 19.19);
	return fract((p.x + p.y) * p.x);
}

// Compute mean and variance of a square sub-region
void region_stats(vec2 uv, vec2 px_size, ivec2 lo, ivec2 hi, out vec3 mean, out float var_sum) {
	vec3 m = vec3(0.0);
	vec3 m2 = vec3(0.0);
	float n = 0.0;
	for (int y = lo.y; y <= hi.y; y++) {
		for (int x = lo.x; x <= hi.x; x++) {
			vec3 c = texture(screen_texture, uv + vec2(float(x), float(y)) * px_size).rgb;
			m += c;
			m2 += c * c;
			n += 1.0;
		}
	}
	m /= n;
	m2 /= n;
	mean = m;
	vec3 v = m2 - m * m;
	var_sum = v.r + v.g + v.b;
}

void fragment() {
	vec2 px_size = SCREEN_PIXEL_SIZE;
	vec3 original = texture(screen_texture, SCREEN_UV).rgb;

	// Four quadrants of the neighbourhood
	vec3 m_tl; float v_tl;
	vec3 m_tr; float v_tr;
	vec3 m_bl; float v_bl;
	vec3 m_br; float v_br;
	region_stats(SCREEN_UV, px_size, ivec2(-radius, -radius), ivec2(0, 0), m_tl, v_tl);
	region_stats(SCREEN_UV, px_size, ivec2(0, -radius), ivec2(radius, 0), m_tr, v_tr);
	region_stats(SCREEN_UV, px_size, ivec2(-radius, 0), ivec2(0, radius), m_bl, v_bl);
	region_stats(SCREEN_UV, px_size, ivec2(0, 0), ivec2(radius, radius), m_br, v_br);

	// Pick the quadrant with the lowest variance (smooth area)
	vec3 painted = m_tl;
	float min_v = v_tl;
	if (v_tr < min_v) { painted = m_tr; min_v = v_tr; }
	if (v_bl < min_v) { painted = m_bl; min_v = v_bl; }
	if (v_br < min_v) { painted = m_br; min_v = v_br; }

	// Posterize for painted-band look
	painted = floor(painted * posterize_levels + 0.5) / posterize_levels;

	// Saturation lift
	float lum = dot(painted, vec3(0.299, 0.587, 0.114));
	painted = mix(vec3(lum), painted, saturation);

	// Subtle paper grain
	float grain = hash(SCREEN_UV * vec2(1920.0, 1080.0)) - 0.5;
	painted += grain * grain_strength;

	// Blend with original by strength
	vec3 final_col = mix(original, painted, strength);
	COLOR = vec4(final_col, 1.0);
}
