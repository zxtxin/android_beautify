precision mediump float;
 uniform sampler2D luminanceTex;
 uniform sampler2D chrominanceTex;
 uniform sampler2D rawLumTex;
 uniform float alpha;
 uniform int whiten;
 varying vec2 coords;
 const mat3 coeffs = mat3(
 1.164,  1.164,  1.164,
 1.596, -0.813,  0.0,
 0.0  , -0.391,  2.018 );
 const vec3 offset = vec3(0.0625, 0.5, 0.5);
 vec3 brightness(vec3 color, float brightness) {
 	float scaled = brightness / 2.0;
 	if (scaled < 0.0) {
 		return color * (1.0 + scaled);
 	} else {
 		return color + (1.0 - color) * scaled;
 	}
 }

 vec3 contrast(vec3 color, float contrast) {
 	const float PI = 3.14159265;
 	return min(vec3(1.0), ((color - 0.5) * (tan((contrast + 1.0) * PI / 4.0) ) + 0.5));
 }
const vec3 W = vec3(0.2125, 0.7154, 0.0721);
vec3 saturation(vec3 color, float sat) {
	float luminance = dot(color, W);
	vec3 gray = vec3(luminance, luminance, luminance);

	vec3 satColor = mix(gray, color, sat+1.0);
	return satColor;
}

void main()
{


    float lum= mix(texture2D(rawLumTex,coords).r,texture2D(luminanceTex,coords).r,alpha);
 //
   //     lum = log(lum*9.0+1.0)/log(10.0);
    vec3 rgb_color = coeffs*(vec3(lum,texture2D(chrominanceTex,coords).ra) - offset);
    if(whiten==1){
       rgb_color = contrast(rgb_color,0.25);
       rgb_color = saturation(rgb_color,-0.15);
       rgb_color = brightness(rgb_color,0.65);

    }
    gl_FragColor = vec4(rgb_color,1.0);

}
