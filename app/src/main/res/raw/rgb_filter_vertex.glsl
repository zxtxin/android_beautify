 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;

 uniform float texelWidth;
 uniform float texelHeight;

 varying vec2 top_line_1[3];
 varying vec2 central_line[3];
 varying vec2 bottom_line_1[3];

 void main()
 {
     gl_Position = position;

     vec2 widthStep = vec2(texelWidth, 0.0);
     vec2 heightStep = vec2(0.0, texelHeight);
     vec2 widthHeightStep = vec2(texelWidth, texelHeight);
     vec2 widthNegativeHeightStep = vec2(texelWidth, -texelHeight);

     central_line[1] = inputTextureCoordinate.xy;
     central_line[0] = inputTextureCoordinate.xy - widthStep;
     central_line[2] = inputTextureCoordinate.xy + widthStep;

     top_line_1[1] = inputTextureCoordinate.xy - heightStep;
     top_line_1[0] = inputTextureCoordinate.xy - widthHeightStep;
     top_line_1[2] = inputTextureCoordinate.xy + widthNegativeHeightStep;

     bottom_line_1[1] = inputTextureCoordinate.xy + heightStep;
     bottom_line_1[0] = inputTextureCoordinate.xy - widthNegativeHeightStep;
     bottom_line_1[2] = inputTextureCoordinate.xy + widthHeightStep;
 }