precision mediump float;
 uniform sampler2D luminanceTex;
 uniform sampler2D chrominanceTex;
 varying vec2 coords;
 const mat3 coeffs = mat3(
 1.164,  1.164,  1.164,
 1.596, -0.813,  0.0,
 0.0  , -0.391,  2.018 );
 const vec3 offset = vec3(0.0625, 0.5, 0.5);
void main()
{
    float lum = texture2D(luminanceTex,coords).r;
    vec3 rgb_color = coeffs*(vec3(lum,texture2D(chrominanceTex,coords).ra) - offset);

    gl_FragColor = vec4(rgb_color,1.0);

}
