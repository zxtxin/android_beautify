precision mediump float;
 uniform sampler2D rawTex;
 uniform sampler2D abTex;
 uniform sampler2D chrominanceTex;
 uniform float beta;
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
    mat3 a;
    a[0][0] = texture2D(abTex,topLeftTextureCoordinate).r;
    a[0][1] = texture2D(abTex,topTextureCoordinate).r;
    a[0][2] = texture2D(abTex,topRightTextureCoordinate).r;
    a[1][0] = texture2D(abTex,leftTextureCoordinate).r;
    a[1][1] = texture2D(abTex,textureCoordinate).r;
    a[1][2] = texture2D(abTex,rightTextureCoordinate).r;
    a[2][0] = texture2D(abTex,bottomLeftTextureCoordinate).r;
    a[2][1] = texture2D(abTex,bottomTextureCoordinate).r;
    a[2][2] = texture2D(abTex,bottomRightTextureCoordinate).r;
    mat3 b;
    b[0][0] = texture2D(abTex,topLeftTextureCoordinate).a;
    b[0][1] = texture2D(abTex,topTextureCoordinate).a;
    b[0][2] = texture2D(abTex,topRightTextureCoordinate).a;
    b[1][0] = texture2D(abTex,leftTextureCoordinate).a;
    b[1][1] = texture2D(abTex,textureCoordinate).a;
    b[1][2] = texture2D(abTex,rightTextureCoordinate).a;
    b[2][0] = texture2D(abTex,bottomLeftTextureCoordinate).a;
    b[2][1] = texture2D(abTex,bottomTextureCoordinate).a;
    b[2][2] = texture2D(abTex,bottomRightTextureCoordinate).a;
    float mean_a;
    mean_a = (a[0][0]+a[0][1]+a[0][2]+a[1][0]+a[1][1]+a[1][2]+a[2][0]+a[2][1]+a[2][2])/9.0;
    float mean_b;
    mean_b = (b[0][0]+b[0][1]+b[0][2]+b[1][0]+b[1][1]+b[1][2]+b[2][0]+b[2][1]+b[2][2])/9.0;
    float filter_output= texture2D(rawTex,textureCoordinate).r*mean_a+mean_b;
    float lum= log(filter_output*(beta-1.0)+1.0)/log(beta);

    vec3 rgb_color = coeffs*(vec3(lum,texture2D(chrominanceTex,textureCoordinate).ra) - offset);
    gl_FragColor = vec4(rgb_color,1.0);
 }