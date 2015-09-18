precision mediump float;
 uniform sampler2D luminanceTex;
 uniform float threshold;
 const int N = 13;
 varying vec2 blurCoords[N];

void main()
{
    float val[N];
    float weight[N];
    val[0]   = texture2D(luminanceTex,blurCoords[0]).r;
    val[1]   = texture2D(luminanceTex,blurCoords[1]).r;
    val[2]   = texture2D(luminanceTex,blurCoords[2]).r;
    val[3]   = texture2D(luminanceTex,blurCoords[3]).r;
    val[4]   = texture2D(luminanceTex,blurCoords[4]).r;
    val[5]   = texture2D(luminanceTex,blurCoords[5]).r;
    val[6]   = texture2D(luminanceTex,blurCoords[6]).r;
    val[7]   = texture2D(luminanceTex,blurCoords[7]).r;
    val[8]   = texture2D(luminanceTex,blurCoords[8]).r;
    val[9]   = texture2D(luminanceTex,blurCoords[9]).r;
    val[10]  = texture2D(luminanceTex,blurCoords[10]).r;
    val[11]  = texture2D(luminanceTex,blurCoords[11]).r;
    val[12]  = texture2D(luminanceTex,blurCoords[12]).r;

    weight[0]  = abs(val[0]-val[7])<threshold ? 0.0000 : 0.0;
    weight[1]  = abs(val[1]-val[7])<threshold ? 0.0000 : 0.0;
    weight[2]  = abs(val[2]-val[7])<threshold ? 0.0001 : 0.0;
    weight[3]  = abs(val[3]-val[7])<threshold ? 0.0044 : 0.0;
    weight[4]  = abs(val[4]-val[7])<threshold ? 0.0540 : 0.0;
    weight[5]  = abs(val[5]-val[7])<threshold ? 0.2420 : 0.0;
    weight[6]  = abs(val[6]-val[7])<threshold ? 0.3989 : 0.0;
    weight[7]  = abs(val[7]-val[7])<threshold ? 0.2420 : 0.0;
    weight[8]  = abs(val[8]-val[7])<threshold ? 0.0540 : 0.0;
    weight[9]  = abs(val[9]-val[7])<threshold ? 0.0044 : 0.0;
    weight[10]  = abs(val[10]-val[7])<threshold ? 0.0001 : 0.0;
    weight[11]  = abs(val[11]-val[7])<threshold ? 0.0000 : 0.0;
    weight[12]  = abs(val[12]-val[7])<threshold ? 0.0000 : 0.0;

    float sum = (   val[0]*weight[0]+
                    val[1]*weight[1]+
                    val[2]*weight[2]+
                    val[3]*weight[3]+
                    val[4]*weight[4]+
                    val[5]*weight[5]+
                    val[6]*weight[6]+
                    val[7]*weight[7]+
                    val[8]*weight[8]+
                    val[9]*weight[9]+
                    val[10]*weight[10]+
                    val[11]*weight[11]+
                    val[12]*weight[12]

                )/
                (   weight[0] +
                    weight[1] +
                    weight[2] +
                    weight[3] +
                    weight[4] +
                    weight[5] +
                    weight[6] +
                    weight[7] +
                    weight[8] +
                    weight[9] +
                    weight[10] +
                    weight[11] +
                    weight[12]


                );

    gl_FragColor = vec4(sum,sum,sum,1.0);
}