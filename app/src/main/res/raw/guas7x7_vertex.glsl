 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;

 varying vec2 texcoord;


 void main()
 {
     gl_Position = position;
     texcoord = inputTextureCoordinate.xy;

 }