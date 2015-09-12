 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;
 const int N = 15;
 varying vec2 blurCoords[N];
 uniform float texelWidth;
 uniform float texelHeight;

 void main()
 {
     gl_Position = position;
     vec2 widthStep = vec2(texelWidth, 0.0);
     vec2 heightStep = vec2(0.0, texelHeight);
     for(int i=0;i<N;i++)
         blurCoords[i] = inputTextureCoordinate.xy - float(N/2-i)*widthStep;

 }