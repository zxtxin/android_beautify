precision mediump float;
 uniform sampler2D rawTex;
 uniform sampler2D chrominanceTex;
 uniform float beta;
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
 const mat3 coeffs = mat3(
 1.164,  1.164,  1.164,
 1.596, -0.813,  0.0,
 0.0  , -0.391,  2.018 );
 const vec3 offset = vec3(0.0625, 0.5, 0.5);
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
    float mean;
    mean = (rawLum[0][0]+rawLum[0][1]+rawLum[0][2]+rawLum[1][0]+rawLum[1][1]+rawLum[1][2]+rawLum[2][0]+rawLum[2][1]+rawLum[2][2])/9.0;
    mat3 deviation;
    deviation[0][0] = rawLum[0][0] - mean;
    deviation[0][1] = rawLum[0][1] - mean;
    deviation[0][2] = rawLum[0][2] - mean;
    deviation[1][0] = rawLum[1][0] - mean;
    deviation[1][1] = rawLum[1][1] - mean;
    deviation[1][2] = rawLum[1][2] - mean;
    deviation[2][0] = rawLum[2][0] - mean;
    deviation[2][1] = rawLum[2][1] - mean;
    deviation[2][2] = rawLum[2][2] - mean;
    deviation = matrixCompMult(deviation, deviation);
    float var;
    var = (deviation[0][0]+deviation[0][1]+deviation[0][2]+deviation[1][0]+deviation[1][1]+deviation[1][2]+deviation[2][0]+deviation[2][1]+deviation[2][2])/9.0;
    float k;
    k = var/(var+epsilon);
    float filter_output = (1.0-k)*mean+k*rawLum[1][1];
    float lum= log(filter_output*(beta-1.0)+1.0)/log(beta);

    vec3 rgb_color = coeffs*(vec3(lum,texture2D(chrominanceTex,textureCoordinate).ra) - offset);
    gl_FragColor = vec4(rgb_color,1.0);
 }