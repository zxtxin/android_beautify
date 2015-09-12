 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;

 varying vec2 coords;

 void main()
 {
     gl_Position = position;
     coords =  inputTextureCoordinate.xy;
 }