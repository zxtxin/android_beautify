precision mediump float;
 uniform sampler2D intermediateTex;
 uniform sampler2D chrominanceTex;
 uniform float beta;
 const int N = 11;
 varying vec2 blurCoords[N];
 const mat3 coeffs = mat3(
 1.164,  1.164,  1.164,
 1.596, -0.813,  0.0,
 0.0  , -0.391,  2.018 );
 const vec3 offset = vec3(0.0625, 0.5, 0.5);
void main()
{
    float sum = 0.0;
    sum += texture2D(intermediateTex,blurCoords[0]).r*0.0088;
    sum += texture2D(intermediateTex,blurCoords[1]).r*0.0271;
    sum += texture2D(intermediateTex,blurCoords[2]).r*0.0651;
    sum += texture2D(intermediateTex,blurCoords[3]).r*0.1216;
    sum += texture2D(intermediateTex,blurCoords[4]).r*0.1770;
    sum += texture2D(intermediateTex,blurCoords[5]).r*0.2006;
    sum += texture2D(intermediateTex,blurCoords[6]).r*0.1770;
    sum += texture2D(intermediateTex,blurCoords[7]).r*0.1216;
    sum += texture2D(intermediateTex,blurCoords[8]).r*0.0651;
    sum += texture2D(intermediateTex,blurCoords[9]).r*0.0271;
    sum += texture2D(intermediateTex,blurCoords[10]).r*0.0088;
    float lum= log(sum*(beta-1.0)+1.0)/log(beta);

    vec3 rgb_color = coeffs*(vec3(lum,texture2D(chrominanceTex,blurCoords[N/2]).ra) - offset);
    gl_FragColor = vec4(rgb_color,1.0);

}