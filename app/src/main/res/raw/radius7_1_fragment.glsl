precision mediump float;
 uniform sampler2D luminanceTex;
 const int N = 15;
 varying vec2 blurCoords[N];

void main()
{
    float sum = 0.0;
    sum += texture2D(luminanceTex,blurCoords[0]).r*0.0571;
    sum += texture2D(luminanceTex,blurCoords[1]).r*0.0609;
    sum += texture2D(luminanceTex,blurCoords[2]).r*0.0644;
    sum += texture2D(luminanceTex,blurCoords[3]).r*0.0673;
    sum += texture2D(luminanceTex,blurCoords[4]).r*0.0697;
    sum += texture2D(luminanceTex,blurCoords[5]).r*0.0715;
    sum += texture2D(luminanceTex,blurCoords[6]).r*0.0726;
    sum += texture2D(luminanceTex,blurCoords[7]).r*0.0729;
    sum += texture2D(luminanceTex,blurCoords[8]).r*0.0726;
    sum += texture2D(luminanceTex,blurCoords[9]).r*0.0715;
    sum += texture2D(luminanceTex,blurCoords[10]).r*0.0697;
    sum += texture2D(luminanceTex,blurCoords[11]).r*0.0673;
    sum += texture2D(luminanceTex,blurCoords[12]).r*0.0644;
    sum += texture2D(luminanceTex,blurCoords[13]).r*0.0609;
    sum += texture2D(luminanceTex,blurCoords[14]).r*0.0571;
    gl_FragColor = vec4(sum,0.0,0.0,1.0);
}