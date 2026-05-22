// Procedural Stained-Glass
// Source: https://godotshaders.com/shader/procedural-stained-glass-shader/
// Author: arlez80 (Yui Kinomoto)
// Licence: MIT
shader_type spatial;

uniform vec2 pixel_size = vec2( 0.001, 0.001 );
uniform float scale = 20.0;
uniform float shift = 0.05;
uniform float seed = 0.0;
uniform float alpha = 0.6;

vec3 hsv2rgb( float h, float s, float v )
{
	return (
		(
			clamp(
				abs( fract( h + vec3( 0.0, 2.0, 1.0 ) / 3.0 ) * 6.0 - 3.0 ) - 1.0
			,	0.0
			,	1.0
			) - 1.0
		) * s + 1.0
	) * v;
}

vec2 random( vec2 pos )
{
	return fract(
		sin(
			vec2(
				dot(pos, vec2(12.9898,78.233))
			,	dot(pos, vec2(-148.998,-65.233))
			)
		) * 43758.5453
	);
}

vec2 value_noise( vec2 pos )
{
	vec2 p = floor( pos );
	vec2 f = fract( pos );

	vec2 v00 = random( p + vec2( 0.0, 0.0 ) );
	vec2 v10 = random( p + vec2( 1.0, 0.0 ) );
	vec2 v01 = random( p + vec2( 0.0, 1.0 ) );
	vec2 v11 = random( p + vec2( 1.0, 1.0 ) );

	vec2 u = f * f * ( 3.0 - 2.0 * f );

	return mix( mix( v00, v10, u.x ), mix( v01, v11, u.x ), u.y );
}

vec2 glass( vec2 uv )
{
	vec2 v = uv * scale + vec2( seed, seed );
	vec2 v_floor = floor( v );
	vec2 v_fract = fract( v );

	vec2 min_p = vec2( 0.0, 0.0 );
	float min_dist = 2.0;

	for( int y = -1; y <= 1; y ++ ) {
		for( int x = -1; x <= 1; x ++ ) {
			vec2 n = vec2( float( x ), float( y ) );
			vec2 p = random( v_floor + n );
			float d = distance( v_fract, p + n );

			min_p = mix( min_p, p, float( d < min_dist ) );
			min_dist = min( min_dist, d );
		}
	}

	return min_p;
}

void fragment( )
{
	vec2 sobel[9];

	for( int y=0; y<3; y ++ ) {
		for( int x=0; x<3; x ++ ) {
			vec2 uv = UV + vec2( float( x-1 ), float( y-1 ) ) * pixel_size;
			sobel[y*3+x] = glass( uv );
		}
	}

	vec2 sobel_src_x = (
		sobel[0] * -1.0
	+	sobel[3] * -2.0
	+	sobel[6] * -1.0
	+	sobel[2] * 1.0
	+	sobel[5] * 2.0
	+	sobel[8] * 1.0
	);
	vec2 sobel_src_y = (
		sobel[0] * -1.0
	+	sobel[1] * -2.0
	+	sobel[2] * -1.0
	+	sobel[6] * 1.0
	+	sobel[7] * 2.0
	+	sobel[8] * 1.0
	);
	float sobel_result = length( sqrt( sobel_src_x * sobel_src_x + sobel_src_y * sobel_src_y ) );

	ALBEDO = hsv2rgb( sobel[4].x, 1.0, 1.0 ) * float( sobel_result == 0.0 );
	ALPHA = mix( 1.0, alpha, float( sobel_result == 0.0 ) );

	vec2 nv = (
		value_noise( UV * 300.0 ) * 0.25
	+	value_noise( UV * 500.0 ) * 0.25
	+	value_noise( UV * 1000.0 ) * 0.25
	+	value_noise( UV * 2100.0 ) * 0.25
	);
	NORMALMAP = normalize( vec3( nv.x, 1.0, nv.y ) );
}
