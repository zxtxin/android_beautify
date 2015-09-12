precision mediump float;
 uniform sampler2D luminanceTex;
 uniform sampler2D chrominanceTex;
 uniform float beta;
 uniform float threshold;
 uniform float texelWidth;
 uniform float texelHeight;
 varying vec2 texcoord;
 vec2 coords[49];
 const mat3 coeffs = mat3(
 1.164,  1.164,  1.164,
 1.596, -0.813,  0.0,
 0.0  , -0.391,  2.018 );
 const vec3 offset = vec3(0.0625, 0.5, 0.5);
 void main()
 {
     vec2 widthStep = vec2(texelWidth, 0.0);
     vec2 heightStep = vec2(0.0, texelHeight);
     coords[0]  = texcoord.xy - 2.0*   widthStep - 2.0*    heightStep;
     coords[1]  = texcoord.xy -        widthStep - 2.0*    heightStep;
     coords[2]  = texcoord.xy                    - 2.0*    heightStep;
     coords[3]  = texcoord.xy +        widthStep - 2.0*    heightStep;
     coords[4]  = texcoord.xy + 2.0*   widthStep - 2.0*    heightStep;
     coords[5]  = texcoord.xy - 2.0*   widthStep -         heightStep;
     coords[6]  = texcoord.xy -        widthStep -         heightStep;
     coords[7]  = texcoord.xy                    -         heightStep;
     coords[8]  = texcoord.xy +        widthStep -         heightStep;
     coords[9]  = texcoord.xy + 2.0*   widthStep -         heightStep;
     coords[10] = texcoord.xy - 2.0*   widthStep                     ;
     coords[11] = texcoord.xy - 1.0*   widthStep                     ;
     coords[12] = texcoord.xy                                        ;
     coords[24] = texcoord.xy + 2.0*   widthStep + 2.0*    heightStep;
     coords[23] = texcoord.xy +        widthStep + 2.0*    heightStep;
     coords[22] = texcoord.xy                    + 2.0*    heightStep;
     coords[21] = texcoord.xy -        widthStep + 2.0*    heightStep;
     coords[20] = texcoord.xy - 2.0*   widthStep + 2.0*    heightStep;
     coords[19] = texcoord.xy + 2.0*   widthStep +         heightStep;
     coords[18] = texcoord.xy +        widthStep +         heightStep;
     coords[17] = texcoord.xy                    +         heightStep;
     coords[16] = texcoord.xy -        widthStep +         heightStep;
     coords[15] = texcoord.xy - 2.0*   widthStep +         heightStep;
     coords[14] = texcoord.xy + 2.0*   widthStep                     ;
     coords[13] = texcoord.xy + 1.0*   widthStep                     ;
    float guassian_selective_output;
    float center_lum = texture2D(luminanceTex,coords[13]).r;
    float left_lum = texture2D(luminanceTex,coords[12]).r;
    float right_lum = texture2D(luminanceTex,coords[14]).r;
    float top_lum = texture2D(luminanceTex,coords[8]).r;
    float left_top_lum = texture2D(luminanceTex,coords[7]).r;
    float right_top_lum = texture2D(luminanceTex,coords[9]).r;
    float bottom_lum = texture2D(luminanceTex,coords[18]).r;
    float left_bottom_lum = texture2D(luminanceTex,coords[17]).r;
    float right_bottom_lum = texture2D(luminanceTex,coords[19]).r;
    float edge = left_lum + right_lum + top_lum + left_top_lum + right_top_lum + bottom_lum + left_bottom_lum + right_bottom_lum - 8.0*center_lum;
    if(edge<1.0)
    {
        float sum = 0.0;
        sum += texture2D(luminanceTex,coords[0]).r/273.0*1.0   ;
        sum += texture2D(luminanceTex,coords[1]).r/273.0*4.0   ;
        sum += texture2D(luminanceTex,coords[2]).r/273.0*7.0   ;
        sum += texture2D(luminanceTex,coords[3]).r/273.0*4.0   ;
        sum += texture2D(luminanceTex,coords[4]).r/273.0*1.0   ;
        sum += texture2D(luminanceTex,coords[5]).r/273.0*4.0   ;
        sum += texture2D(luminanceTex,coords[6]).r/273.0*16.0  ;
        sum += texture2D(luminanceTex,coords[7]).r/273.0*26.0  ;
        sum += texture2D(luminanceTex,coords[8]).r/273.0*16.0  ;
        sum += texture2D(luminanceTex,coords[9]).r/273.0*4.0   ;
        sum += texture2D(luminanceTex,coords[10]).r/273.0*7.0  ;
        sum += texture2D(luminanceTex,coords[11]).r/273.0*26.0 ;
        sum += texture2D(luminanceTex,coords[12]).r/273.0*41.0 ;
        sum += texture2D(luminanceTex,coords[13]).r/273.0*26.0 ;
        sum += texture2D(luminanceTex,coords[14]).r/273.0*7.0  ;
        sum += texture2D(luminanceTex,coords[15]).r/273.0*4.0  ;
        sum += texture2D(luminanceTex,coords[16]).r/273.0*16.0 ;
        sum += texture2D(luminanceTex,coords[17]).r/273.0*26.0 ;
        sum += texture2D(luminanceTex,coords[18]).r/273.0*16.0 ;
        sum += texture2D(luminanceTex,coords[19]).r/273.0*4.0  ;
        sum += texture2D(luminanceTex,coords[20]).r/273.0*1.0  ;
        sum += texture2D(luminanceTex,coords[21]).r/273.0*4.0  ;
        sum += texture2D(luminanceTex,coords[22]).r/273.0*7.0  ;
        sum += texture2D(luminanceTex,coords[23]).r/273.0*4.0  ;
        sum += texture2D(luminanceTex,coords[24]).r/273.0*1.0  ;
        guassian_selective_output = sum;
    }
    else
    {
        guassian_selective_output = center_lum;
    }
    float lum= log(guassian_selective_output*(beta-1.0)+1.0)/log(beta);
    vec3 rgb_color = coeffs*(vec3(lum,texture2D(chrominanceTex,coords[13]).ra) - offset);
//    vec3 rgb_color = coeffs*(vec3(edge,texture2D(chrominanceTex,coords[13]).ra) - offset);
    gl_FragColor = vec4(rgb_color,1.0);
 }
