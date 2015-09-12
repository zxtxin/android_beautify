precision mediump float;
 uniform sampler2D rawTex;
 uniform float epsilon;
 varying vec2 textureCoordinate;
 varying vec2 leftTextureCoordinate;
 varying vec2 rightTextureCoordinate;

 varying vec2 topTextureCoordinate;
 varying vec2 topLeftTextureCoordinate;
 varying vec2 topRightTextureCoordinate;

 varying vec2 bottomTextureCoordinate;
 varying vec2 bottomLeftTextureCoordinate;
 varying vec2 bottomRightTextureCoordinate;

 void main()
 {
    mat3 rawLum;
    rawLum[0][0] = texture2D(rawTex,topLeftTextureCoordinate).r;
    rawLum[0][1] = texture2D(rawTex,topTextureCoordinate).r;
    rawLum[0][2] = texture2D(rawTex,topRightTextureCoordinate).r;
    rawLum[1][0] = texture2D(rawTex,leftTextureCoordinate).r;
    rawLum[1][1] = texture2D(rawTex,textureCoordinate).r;
    rawLum[1][2] = texture2D(rawTex,rightTextureCoordinate).r;
    rawLum[2][0] = texture2D(rawTex,bottomLeftTextureCoordinate).r;
    rawLum[2][1] = texture2D(rawTex,bottomTextureCoordinate).r;
    rawLum[2][2] = texture2D(rawTex,bottomRightTextureCoordinate).r;
    mat3 rawLum2;
    rawLum2 = matrixCompMult(rawLum, rawLum);
    float mean;
    mean = (rawLum[0][0]+rawLum[0][1]+rawLum[0][2]+rawLum[1][0]+rawLum[1][1]+rawLum[1][2]+rawLum[2][0]+rawLum[2][1]+rawLum[2][2])/9.0;
    float corr;
    corr = (rawLum2[0][0]+rawLum2[0][1]+rawLum2[0][2]+rawLum2[1][0]+rawLum2[1][1]+rawLum2[1][2]+rawLum2[2][0]+rawLum2[2][1]+rawLum2[2][2])/9.0;
    float var;
    var = corr - mean*mean;
    float a;
    a = var/(var+epsilon);
    float b;
    b = mean -a*mean;
    gl_FragColor = vec4(a,0.0,0.0,b);
 }