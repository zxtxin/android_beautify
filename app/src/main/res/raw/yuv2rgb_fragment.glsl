precision mediump float;
 uniform sampler2D luminanceTex;
 uniform sampler2D rawLumTex;
 uniform sampler2D chrominanceTex;
 varying vec2 coords;
 const mat3 coeffs = mat3(
 1.164,  1.164,  1.164,
 1.596, -0.813,  0.0,
 0.0  , -0.391,  2.018 );
 const vec3 offset = vec3(0.0625, 0.5, 0.5);
bool ifFace(float Cr,float Cb)
{
    bool ret;
    if(Cr>=133.0/256.0&&Cr<=173.0/256.0&&Cb>=77.0/256.0&&Cb<=127.0/256.0)
        ret = true;
    else
        ret = false;
    return ret;
}
void main()
{
//    float lum = ifFace(texture2D(chrominanceTex,coords).r,texture2D(chrominanceTex,coords).a)?texture2D(luminanceTex,coords).r:texture2D(rawLumTex,coords).r;
    float lum = texture2D(luminanceTex,coords).r;
    vec3 rgb_color = coeffs*(vec3(lum,texture2D(chrominanceTex,coords).ra) - offset);

    gl_FragColor = vec4(rgb_color,1.0);

}
