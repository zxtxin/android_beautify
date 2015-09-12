precision mediump float;
 uniform sampler2D intermediateTex;
 uniform sampler2D chrominanceTex;
 uniform float beta;
 const int N = 15;
 varying vec2 blurCoords[N];
 uniform float texelWidth;
 uniform float texelHeight;
 const mat3 coeffs = mat3(
 1.164,  1.164,  1.164,
 1.596, -0.813,  0.0,
 0.0  , -0.391,  2.018 );
 const vec3 offset = vec3(0.0625, 0.5, 0.5);
void main()
{
    float sum = 0.0;
    sum += texture2D(intermediateTex,blurCoords[0]).r*0.0571;
    sum += texture2D(intermediateTex,blurCoords[1]).r*0.0609;
    sum += texture2D(intermediateTex,blurCoords[2]).r*0.0644;
    sum += texture2D(intermediateTex,blurCoords[3]).r*0.0673;
    sum += texture2D(intermediateTex,blurCoords[4]).r*0.0697;
    sum += texture2D(intermediateTex,blurCoords[5]).r*0.0715;
    sum += texture2D(intermediateTex,blurCoords[6]).r*0.0726;
    sum += texture2D(intermediateTex,blurCoords[7]).r*0.0729;
    sum += texture2D(intermediateTex,blurCoords[8]).r*0.0726;
    sum += texture2D(intermediateTex,blurCoords[9]).r*0.0715;
    sum += texture2D(intermediateTex,blurCoords[10]).r*0.0697;
    sum += texture2D(intermediateTex,blurCoords[11]).r*0.0673;
    sum += texture2D(intermediateTex,blurCoords[12]).r*0.0644;
    sum += texture2D(intermediateTex,blurCoords[13]).r*0.0609;
    sum += texture2D(intermediateTex,blurCoords[14]).r*0.0571;

    float lum= log(sum*(beta-1.0)+1.0)/log(beta);

    vec3 rgb_color = coeffs*(vec3(lum,texture2D(chrominanceTex,blurCoords[N/2]).ra) - offset);
    gl_FragColor = vec4(rgb_color,1.0);

}