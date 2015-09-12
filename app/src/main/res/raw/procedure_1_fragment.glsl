precision mediump float;
 uniform sampler2D luminanceTex;
 const int N = 11;
 varying vec2 blurCoords[N];

void main()
{
    float sum = 0.0;
    sum += texture2D(luminanceTex,blurCoords[0]).r*0.0088;
    sum += texture2D(luminanceTex,blurCoords[1]).r*0.0271;
    sum += texture2D(luminanceTex,blurCoords[2]).r*0.0651;
    sum += texture2D(luminanceTex,blurCoords[3]).r*0.1216;
    sum += texture2D(luminanceTex,blurCoords[4]).r*0.1770;
    sum += texture2D(luminanceTex,blurCoords[5]).r*0.2006;
    sum += texture2D(luminanceTex,blurCoords[6]).r*0.1770;
    sum += texture2D(luminanceTex,blurCoords[7]).r*0.1216;
    sum += texture2D(luminanceTex,blurCoords[8]).r*0.0651;
    sum += texture2D(luminanceTex,blurCoords[9]).r*0.0271;
    sum += texture2D(luminanceTex,blurCoords[10]).r*0.0088;
    gl_FragColor = vec4(sum,0.0,0.0,1.0);
}