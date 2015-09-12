precision mediump float;
 uniform sampler2D u_Texture0;
 uniform sampler2D u_Texture1;
 uniform float beta;
 uniform float photometricVariance;
 uniform float spatialVariance;
 varying vec2 top_line_1[3];
 varying vec2 central_line[3];
 varying vec2 bottom_line_1[3];
 const mat3 coeffs = mat3(
 1.164,  1.164,  1.164,
 1.596, -0.813,  0.0,
 0.0  , -0.391,  2.018 );
 const vec3 offset = vec3(0.0625, 0.5, 0.5);
 void main()
 {
    float weight_top_1[3];
    float weight_central[3];
    float weight_bottom_1[3];
    float val_top_1[3];
    float val_central[3];
    float val_bottom_1[3];
    val_top_1[0]=texture2D(u_Texture0,top_line_1[0]).r;
    val_top_1[1]=texture2D(u_Texture0,top_line_1[1]).r;
    val_top_1[2]=texture2D(u_Texture0,top_line_1[2]).r;
    val_central[0]=texture2D(u_Texture0,central_line[0]).r;
    val_central[1]=texture2D(u_Texture0,central_line[1]).r;
    val_central[2]=texture2D(u_Texture0,central_line[2]).r;
    val_bottom_1[0]=texture2D(u_Texture0,bottom_line_1[0]).r;
    val_bottom_1[1]=texture2D(u_Texture0,bottom_line_1[1]).r;
    val_bottom_1[2]=texture2D(u_Texture0,bottom_line_1[2]).r;
    float center = val_central[1];
    weight_top_1[0]=exp(-1.0/spatialVariance-0.5*(center-val_top_1[0])*(center-val_top_1[0])/photometricVariance);
    weight_top_1[1]=exp(-0.5/spatialVariance-0.5*(center-val_top_1[1])*(center-val_top_1[1])/photometricVariance);
    weight_top_1[2]=exp(-1.0/spatialVariance-0.5*(center-val_top_1[2])*(center-val_top_1[2])/photometricVariance);
    weight_central[0]=exp(-0.5/spatialVariance-0.5*(center-val_central[0])*(center-val_central[0])/photometricVariance);
    weight_central[1]=1.0;
    weight_central[2]=exp(-0.5/spatialVariance-0.5*(center-val_central[2])*(center-val_central[2])/photometricVariance);
    weight_bottom_1[0]=exp(-1.0/spatialVariance-0.5*(center-val_bottom_1[0])*(center-val_bottom_1[0])/photometricVariance);
    weight_bottom_1[1]=exp(-0.5/spatialVariance-0.5*(center-val_bottom_1[1])*(center-val_bottom_1[1])/photometricVariance);
    weight_bottom_1[2]=exp(-1.0/spatialVariance-0.5*(center-val_bottom_1[2])*(center-val_bottom_1[2])/photometricVariance);
    float bilateral_lum = ( val_top_1[0]*weight_top_1[0]+
                            val_top_1[1]*weight_top_1[1]+
                            val_top_1[2]*weight_top_1[2]+
                            val_central[0]*weight_central[0]+
                            val_central[1]*weight_central[1]+
                            val_central[2]*weight_central[2]+
                            val_bottom_1[0]*weight_bottom_1[0]+
                            val_bottom_1[1]*weight_bottom_1[1]+
                            val_bottom_1[2]*weight_bottom_1[2]
    )/( weight_top_1[0]+
        weight_top_1[1]+
        weight_top_1[2]+
        weight_central[0]+
        weight_central[1]+
        weight_central[2]+
        weight_bottom_1[0]+
        weight_bottom_1[1]+
        weight_bottom_1[2]
    );
    float lum= log(bilateral_lum*(beta-1.0)+1.0)/log(beta);

    vec3 rgb_color = coeffs*(vec3(lum,texture2D(u_Texture1,central_line[1]).ra) - offset);
    gl_FragColor = vec4(rgb_color,1.0);
 }