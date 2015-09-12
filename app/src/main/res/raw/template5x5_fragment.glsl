precision mediump float;
 uniform sampler2D u_Texture0;
 uniform sampler2D u_Texture1;

 uniform float texelWidth;
 uniform float texelHeight;
 uniform float beta;
 uniform float photometricVariance;
 uniform float spatialVariance;
 varying vec2 texCoords;
 const mat3 coeffs = mat3(
 1.164,  1.164,  1.164,
 1.596, -0.813,  0.0,
 0.0  , -0.391,  2.018 );
 const vec3 offset = vec3(0.0625, 0.5, 0.5);
 void main()
 {
    vec2 top_line_2[5];
    vec2 top_line_1[5];
    vec2 central_line[5];
    vec2 bottom_line_1[5];
    vec2 bottom_line_2[5];

     vec2 widthStep = vec2(texelWidth, 0.0);
     vec2 heightStep = vec2(0.0, texelHeight);

     central_line[2] = texCoords.xy;
     central_line[0] = texCoords.xy - 2.0*widthStep;
     central_line[1] = texCoords.xy - widthStep;
     central_line[3] = texCoords.xy + widthStep;
     central_line[4] = texCoords.xy + 2.0*widthStep;

     top_line_2[2] = texCoords.xy - 2.0*heightStep;
     top_line_2[0] = texCoords.xy - 2.0*widthStep - 2.0*heightStep;
     top_line_2[1] = texCoords.xy - widthStep - 2.0*heightStep;
     top_line_2[3] = texCoords.xy + widthStep - 2.0*heightStep;
     top_line_2[4] = texCoords.xy + 2.0*widthStep - 2.0*heightStep;

     top_line_1[2] = texCoords.xy - heightStep;
     top_line_1[0] = texCoords.xy - 2.0*widthStep - heightStep;
     top_line_1[1] = texCoords.xy - widthStep - heightStep;
     top_line_1[3] = texCoords.xy + widthStep - heightStep;
     top_line_1[4] = texCoords.xy + 2.0*widthStep - heightStep;

     bottom_line_1[2] = texCoords.xy + heightStep;
     bottom_line_1[0] = texCoords.xy + heightStep - 2.0*widthStep;
     bottom_line_1[1] = texCoords.xy + heightStep - widthStep;
     bottom_line_1[3] = texCoords.xy + heightStep + widthStep;
     bottom_line_1[4] = texCoords.xy + heightStep + 2.0*widthStep;

     bottom_line_2[2] = texCoords.xy + 2.0*heightStep;
     bottom_line_2[0] = texCoords.xy + 2.0*heightStep - 2.0*widthStep;
     bottom_line_2[1] = texCoords.xy + 2.0*heightStep - widthStep;
     bottom_line_2[3] = texCoords.xy + 2.0*heightStep + widthStep;
     bottom_line_2[4] = texCoords.xy + 2.0*heightStep + 2.0*widthStep;

    float weight_top_2[5];
    float weight_top_1[5];
    float weight_central[5];
    float weight_bottom_1[5];
    float weight_bottom_2[5];

    float val_top_2[5];
    float val_top_1[5];
    float val_central[5];
    float val_bottom_1[5];
    float val_bottom_2[5];

    val_top_2[0]=texture2D(u_Texture0,top_line_2[0]).r;
    val_top_2[1]=texture2D(u_Texture0,top_line_2[1]).r;
    val_top_2[2]=texture2D(u_Texture0,top_line_2[2]).r;
    val_top_2[3]=texture2D(u_Texture0,top_line_2[3]).r;
    val_top_2[4]=texture2D(u_Texture0,top_line_2[4]).r;

    val_top_1[0]=texture2D(u_Texture0,top_line_1[0]).r;
    val_top_1[1]=texture2D(u_Texture0,top_line_1[1]).r;
    val_top_1[2]=texture2D(u_Texture0,top_line_1[2]).r;
    val_top_1[3]=texture2D(u_Texture0,top_line_1[3]).r;
    val_top_1[4]=texture2D(u_Texture0,top_line_1[4]).r;

    val_central[0]=texture2D(u_Texture0,central_line[0]).r;
    val_central[1]=texture2D(u_Texture0,central_line[1]).r;
    val_central[2]=texture2D(u_Texture0,central_line[2]).r;
    val_central[3]=texture2D(u_Texture0,central_line[3]).r;
    val_central[4]=texture2D(u_Texture0,central_line[4]).r;

    val_bottom_1[0]=texture2D(u_Texture0,bottom_line_1[0]).r;
    val_bottom_1[1]=texture2D(u_Texture0,bottom_line_1[1]).r;
    val_bottom_1[2]=texture2D(u_Texture0,bottom_line_1[2]).r;
    val_bottom_1[3]=texture2D(u_Texture0,bottom_line_1[3]).r;
    val_bottom_1[4]=texture2D(u_Texture0,bottom_line_1[4]).r;

    val_bottom_2[0]=texture2D(u_Texture0,bottom_line_2[0]).r;
    val_bottom_2[1]=texture2D(u_Texture0,bottom_line_2[1]).r;
    val_bottom_2[2]=texture2D(u_Texture0,bottom_line_2[2]).r;
    val_bottom_2[3]=texture2D(u_Texture0,bottom_line_2[3]).r;
    val_bottom_2[4]=texture2D(u_Texture0,bottom_line_2[4]).r;

    float center = val_central[2];

    weight_top_2[0]=exp(-4.0/spatialVariance-0.5*(center-val_top_2[0])*(center-val_top_2[0])/photometricVariance);
    weight_top_2[1]=exp(-2.5/spatialVariance-0.5*(center-val_top_2[1])*(center-val_top_2[1])/photometricVariance);
    weight_top_2[2]=exp(-2.0/spatialVariance-0.5*(center-val_top_2[2])*(center-val_top_2[2])/photometricVariance);
    weight_top_2[3]=exp(-2.5/spatialVariance-0.5*(center-val_top_2[3])*(center-val_top_2[3])/photometricVariance);
    weight_top_2[4]=exp(-4.0/spatialVariance-0.5*(center-val_top_2[4])*(center-val_top_2[4])/photometricVariance);

    weight_top_1[0]=exp(-2.5/spatialVariance-0.5*(center-val_top_1[0])*(center-val_top_1[0])/photometricVariance);
    weight_top_1[1]=exp(-1.0/spatialVariance-0.5*(center-val_top_1[1])*(center-val_top_1[1])/photometricVariance);
    weight_top_1[2]=exp(-0.5/spatialVariance-0.5*(center-val_top_1[2])*(center-val_top_1[2])/photometricVariance);
    weight_top_1[3]=exp(-1.0/spatialVariance-0.5*(center-val_top_1[3])*(center-val_top_1[3])/photometricVariance);
    weight_top_1[4]=exp(-2.5/spatialVariance-0.5*(center-val_top_1[4])*(center-val_top_1[4])/photometricVariance);

    weight_central[0]=exp(-2.0/spatialVariance-0.5*(center-val_central[0])*(center-val_central[0])/photometricVariance);
    weight_central[1]=exp(-0.5/spatialVariance-0.5*(center-val_central[1])*(center-val_central[1])/photometricVariance);
    weight_central[2]=1.0;
    weight_central[3]=exp(-0.5/spatialVariance-0.5*(center-val_central[3])*(center-val_central[3])/photometricVariance);
    weight_central[4]=exp(-2.0/spatialVariance-0.5*(center-val_central[4])*(center-val_central[4])/photometricVariance);

    weight_bottom_1[0]=exp(-2.5/spatialVariance-0.5*(center-val_bottom_1[0])*(center-val_bottom_1[0])/photometricVariance);
    weight_bottom_1[1]=exp(-1.0/spatialVariance-0.5*(center-val_bottom_1[1])*(center-val_bottom_1[1])/photometricVariance);
    weight_bottom_1[2]=exp(-0.5/spatialVariance-0.5*(center-val_bottom_1[2])*(center-val_bottom_1[2])/photometricVariance);
    weight_bottom_1[3]=exp(-1.0/spatialVariance-0.5*(center-val_bottom_1[3])*(center-val_bottom_1[3])/photometricVariance);
    weight_bottom_1[4]=exp(-2.5/spatialVariance-0.5*(center-val_bottom_1[4])*(center-val_bottom_1[4])/photometricVariance);

    weight_bottom_2[0]=exp(-4.0/spatialVariance-0.5*(center-val_bottom_2[0])*(center-val_bottom_2[0])/photometricVariance);
    weight_bottom_2[1]=exp(-2.5/spatialVariance-0.5*(center-val_bottom_2[1])*(center-val_bottom_2[1])/photometricVariance);
    weight_bottom_2[2]=exp(-2.0/spatialVariance-0.5*(center-val_bottom_2[2])*(center-val_bottom_2[2])/photometricVariance);
    weight_bottom_2[3]=exp(-2.5/spatialVariance-0.5*(center-val_bottom_2[3])*(center-val_bottom_2[3])/photometricVariance);
    weight_bottom_2[4]=exp(-4.0/spatialVariance-0.5*(center-val_bottom_2[4])*(center-val_bottom_2[4])/photometricVariance);

    float bilateral_lum = ( val_top_2[0]*weight_top_2[0]+
                            val_top_2[1]*weight_top_2[1]+
                            val_top_2[2]*weight_top_2[2]+
                            val_top_2[3]*weight_top_2[3]+
                            val_top_2[4]*weight_top_2[4]+
                            val_top_1[0]*weight_top_1[0]+
                            val_top_1[1]*weight_top_1[1]+
                            val_top_1[2]*weight_top_1[2]+
                            val_top_1[3]*weight_top_1[3]+
                            val_top_1[4]*weight_top_1[4]+
                            val_central[0]*weight_central[0]+
                            val_central[1]*weight_central[1]+
                            val_central[2]*weight_central[2]+
                            val_central[3]*weight_central[3]+
                            val_central[4]*weight_central[4]+
                            val_bottom_1[0]*weight_bottom_1[0]+
                            val_bottom_1[1]*weight_bottom_1[1]+
                            val_bottom_1[2]*weight_bottom_1[2]+
                            val_bottom_1[3]*weight_bottom_1[3]+
                            val_bottom_1[4]*weight_bottom_1[4]+
                            val_bottom_2[0]*weight_bottom_2[0]+
                            val_bottom_2[1]*weight_bottom_2[1]+
                            val_bottom_2[2]*weight_bottom_2[2]+
                            val_bottom_2[3]*weight_bottom_2[3]+
                            val_bottom_2[4]*weight_bottom_2[4]
    )/(
        weight_top_2[0]+
        weight_top_2[1]+
        weight_top_2[2]+
        weight_top_2[3]+
        weight_top_2[4]+
        weight_top_1[0]+
        weight_top_1[1]+
        weight_top_1[2]+
        weight_top_1[3]+
        weight_top_1[4]+
        weight_central[0]+
        weight_central[1]+
        weight_central[2]+
        weight_central[3]+
        weight_central[4]+
        weight_bottom_1[0]+
        weight_bottom_1[1]+
        weight_bottom_1[2]+
        weight_bottom_1[3]+
        weight_bottom_1[4]+
        weight_bottom_2[0]+
        weight_bottom_2[1]+
        weight_bottom_2[2]+
        weight_bottom_2[3]+
        weight_bottom_2[4]

    );
    float lum= log(bilateral_lum*(beta-1.0)+1.0)/log(beta);

    vec3 rgb_color = coeffs*(vec3(lum,texture2D(u_Texture1,central_line[2]).ra) - offset);
    gl_FragColor = vec4(rgb_color,1.0);
 }