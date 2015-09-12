 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;

 varying vec2 texCoords;
 void main()
 {
     gl_Position = position;
     texCoords = inputTextureCoordinate.xy;

 }