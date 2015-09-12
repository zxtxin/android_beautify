package xintianzhang.beautify;

import android.hardware.Camera;
import android.opengl.GLES20;
import android.util.Log;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;

/**
 * Created by zxtxin on 2014/12/3.
 */
public class RGBFilter extends FilterBase{

    private final FloatBuffer vertexBuffer;
    private final FloatBuffer textureCoordinateBuffer;
    private final FloatBuffer firstProgramtextureCoordinateBuffer;
  /*  private final int local_stat_program;
    private final int positionAttr;
    private final int texCoordAttr;
    private final int widthUniform;
    private final int heightUniform;
    private final int rawTexUniform;
    private final int epsilonUniform;
    private final int betaUniform;
    private final int chrominanceTextureUniform;*/
    /*    private final int rgbProgram;
        private final int positionAttr_rgb;
        private final int texCoordAttr_rgb;
        private final int tex0Uniform_rgb;
        private final int tex1Uniform_rgb;
        private final int Uniform_beta;
        private final int widthUniform;
        private final int heightUniform;
        private final int photometricVarianceUniform;
        private final int spatialVarianceUniform;*/
    private final int firstProgram;
    private final int secondProgram;
    private final int positionAttr_first;
    private final int texCoordAttr_first;
    private final int widthUniform_first;
    private final int heightUniform_first;
    private final int rawTexUniform_first;
    private final int epsilonUniform_first;
    private final int positionAttr_second;
    private final int texCoordAttr_second;
    private final int widthUniform_second;
    private final int heightUniform_second;
    private final int rawTexUniform_second;
    private final int abTextureUniform_second;
    private final int chrominanceTextureUniform_second;
    private final int betaUniform_second;
    private int[] fbo;
    private int[] tex;
    static final float firstProgramTextureCoords[] = {
            0.0f,1.0f,
            0.0f,0.0f,
            1.0f,0.0f,
            1.0f,1.0f,

    };

    public RGBFilter(OpenGLESSupervisor instance) {
        super(instance);
  //      rgbProgram = glInstance.buildShaderProgram(R.raw.rgb_filter_vertex, R.raw.rgb_filter_fragment);
//        rgbProgram = glInstance.buildShaderProgram(R.raw.template5x5_vertex, R.raw.template5x5_fragment);
        firstProgram = glInstance.buildShaderProgram(R.raw.guidedfilter_first_vertex, R.raw.guidedfilter_first_fragment);
        secondProgram = glInstance.buildShaderProgram(R.raw.guidedfilter_second_vertex, R.raw.guidedfilter_second_fragment);
 //       local_stat_program = glInstance.buildShaderProgram(R.raw.local_statistics_filter_vertex, R.raw.local_statistics_filter_fragment);
        tex = glInstance.getTex();
        fbo = glInstance.getFBO();
        vertexBuffer = glInstance.getVertexBuffer();
        textureCoordinateBuffer = glInstance.getTextureCoordinatesBuffer();
        ByteBuffer tmp = ByteBuffer.allocateDirect(firstProgramTextureCoords.length * 4);
        tmp.order(ByteOrder.nativeOrder());
        firstProgramtextureCoordinateBuffer = tmp.asFloatBuffer();
        firstProgramtextureCoordinateBuffer.put(firstProgramTextureCoords).position(0);
  /*      positionAttr = GLES20.glGetAttribLocation(local_stat_program, "position");
        texCoordAttr = GLES20.glGetAttribLocation(local_stat_program, "inputTextureCoordinate");
        widthUniform=GLES20.glGetUniformLocation(local_stat_program, "texelWidth");
        heightUniform=GLES20.glGetUniformLocation(local_stat_program, "texelHeight");
        rawTexUniform = GLES20.glGetUniformLocation(local_stat_program, "rawTex");
        chrominanceTextureUniform =  GLES20.glGetUniformLocation(local_stat_program, "chrominanceTex");
        epsilonUniform =  GLES20.glGetUniformLocation(local_stat_program, "epsilon");
        betaUniform = GLES20.glGetUniformLocation(local_stat_program, "beta");*/

        positionAttr_first = GLES20.glGetAttribLocation(firstProgram, "position");
        texCoordAttr_first = GLES20.glGetAttribLocation(firstProgram, "inputTextureCoordinate");
        widthUniform_first=GLES20.glGetUniformLocation(firstProgram, "texelWidth");
        heightUniform_first=GLES20.glGetUniformLocation(firstProgram, "texelHeight");
        rawTexUniform_first = GLES20.glGetUniformLocation(firstProgram, "rawTex");
        epsilonUniform_first =  GLES20.glGetUniformLocation(firstProgram, "epsilon");

        positionAttr_second = GLES20.glGetAttribLocation(secondProgram, "position");
        texCoordAttr_second = GLES20.glGetAttribLocation(secondProgram, "inputTextureCoordinate");
        widthUniform_second =GLES20.glGetUniformLocation(secondProgram, "texelWidth");
        heightUniform_second =GLES20.glGetUniformLocation(secondProgram, "texelHeight");
        rawTexUniform_second = GLES20.glGetUniformLocation(secondProgram, "rawTex");
        abTextureUniform_second = GLES20.glGetUniformLocation(secondProgram, "abTex");
        chrominanceTextureUniform_second =  GLES20.glGetUniformLocation(secondProgram, "chrominanceTex");
        betaUniform_second = GLES20.glGetUniformLocation(secondProgram, "beta");
 /*       Uniform_beta = GLES20.glGetUniformLocation(rgbProgram, "beta");
        positionAttr_rgb = GLES20.glGetAttribLocation(rgbProgram, "position");
        texCoordAttr_rgb = GLES20.glGetAttribLocation(rgbProgram, "inputTextureCoordinate");
        tex0Uniform_rgb = GLES20.glGetUniformLocation(rgbProgram, "u_Texture0");
        tex1Uniform_rgb = GLES20.glGetUniformLocation(rgbProgram, "u_Texture1");
        widthUniform=GLES20.glGetUniformLocation(rgbProgram,"texelWidth");
        heightUniform=GLES20.glGetUniformLocation(rgbProgram,"texelHeight");
        photometricVarianceUniform = GLES20.glGetUniformLocation(rgbProgram,"photometricVariance");
        spatialVarianceUniform = GLES20.glGetUniformLocation(rgbProgram,"spatialVariance");*/


    }

    @Override
    public void draw(byte[] frameData_byte, Camera.Size size, int pixelAmounts, float beta,float epsilon) {
        ByteBuffer frameData = ByteBuffer.wrap(frameData_byte);
        frameData.position(0);
/*        GLES20.glUseProgram(local_stat_program);
        GLES20.glVertexAttribPointer(positionAttr, COORDS_PER_VERTEX, GLES20.GL_FLOAT, false, 0, vertexBuffer);
        GLES20.glEnableVertexAttribArray(positionAttr);
        GLES20.glVertexAttribPointer(texCoordAttr, COORDS_PER_VERTEX, GLES20.GL_FLOAT, false, 0, textureCoordinateBuffer);
        GLES20.glEnableVertexAttribArray(texCoordAttr);
    //    GLES20.glClear(GLES20.GL_DEPTH_BUFFER_BIT | GLES20.GL_COLOR_BUFFER_BIT);
        GLES20.glActiveTexture(GLES20.GL_TEXTURE0);
        GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, tex[1]);
        GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_LUMINANCE, size.width, size.height, 0, GLES20.GL_LUMINANCE, GLES20.GL_UNSIGNED_BYTE, frameData);
        GLES20.glUniform1i(rawTexUniform, 0);
        frameData.position(pixelAmounts);
        GLES20.glActiveTexture(GLES20.GL_TEXTURE2);
        GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, tex[2]);
        GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_LUMINANCE_ALPHA, size.width / 2, size.height / 2, 0, GLES20.GL_LUMINANCE_ALPHA, GLES20.GL_UNSIGNED_BYTE, frameData);
        GLES20.glUniform1i(chrominanceTextureUniform, 2);
        GLES20.glUniform1f(epsilonUniform, epsilon);
        GLES20.glUniform1f(widthUniform, 1.0f / size.width);
        GLES20.glUniform1f(heightUniform, 1.0f / size.height);
        GLES20.glUniform1f(betaUniform, beta);
        GLES20.glDrawArrays(GLES20.GL_TRIANGLE_FAN, 0, 4);*/
        GLES20.glViewport(0, 0, size.width, size.height);
        GLES20.glUseProgram(firstProgram);
        GLES20.glVertexAttribPointer(positionAttr_first, COORDS_PER_VERTEX, GLES20.GL_FLOAT, false, 0, vertexBuffer);
        GLES20.glEnableVertexAttribArray(positionAttr_first);
        GLES20.glVertexAttribPointer(texCoordAttr_first, COORDS_PER_VERTEX, GLES20.GL_FLOAT, false, 0, firstProgramtextureCoordinateBuffer);
        GLES20.glEnableVertexAttribArray(texCoordAttr_first);
        GLES20.glClear(GLES20.GL_DEPTH_BUFFER_BIT | GLES20.GL_COLOR_BUFFER_BIT);
        GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, tex[0]);
        GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_RGBA, size.width, size.height, 0, GLES20.GL_RGBA, GLES20.GL_UNSIGNED_BYTE, null);
        GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, fbo[0]);
        GLES20.glFramebufferTexture2D(GLES20.GL_FRAMEBUFFER, GLES20.GL_COLOR_ATTACHMENT0, GLES20.GL_TEXTURE_2D, tex[0], 0);


        GLES20.glActiveTexture(GLES20.GL_TEXTURE0);
        GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, tex[1]);
        GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_LUMINANCE, size.width , size.height, 0, GLES20.GL_LUMINANCE, GLES20.GL_UNSIGNED_BYTE, frameData);
        GLES20.glUniform1i(rawTexUniform_first, 0);
        GLES20.glUniform1f(epsilonUniform_first, epsilon);
        GLES20.glUniform1f(widthUniform_first, 1.0f / size.width);
        GLES20.glUniform1f(heightUniform_first, 1.0f / size.height);
        GLES20.glDrawArrays(GLES20.GL_TRIANGLE_FAN, 0, 4);
        GLES20.glDisableVertexAttribArray(positionAttr_first);
        GLES20.glDisableVertexAttribArray(texCoordAttr_first);
        frameData.position(0);
        GLES20.glUseProgram(secondProgram);
        GLES20.glVertexAttribPointer(positionAttr_second, COORDS_PER_VERTEX, GLES20.GL_FLOAT, false, 0, vertexBuffer);
        GLES20.glEnableVertexAttribArray(positionAttr_second);
        GLES20.glVertexAttribPointer(texCoordAttr_second, COORDS_PER_VERTEX, GLES20.GL_FLOAT, false, 0, textureCoordinateBuffer);
        GLES20.glEnableVertexAttribArray(texCoordAttr_second);
  //      GLES20.glClear(GLES20.GL_DEPTH_BUFFER_BIT | GLES20.GL_COLOR_BUFFER_BIT);
        GLES20.glViewport(0, 0, viewWidth, viewHeight);
        GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, 0);
        GLES20.glActiveTexture(GLES20.GL_TEXTURE0);
        GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, tex[1]);
        GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_LUMINANCE, size.width, size.height, 0, GLES20.GL_LUMINANCE, GLES20.GL_UNSIGNED_BYTE, frameData);
        GLES20.glUniform1i(rawTexUniform_second, 0);
        GLES20.glActiveTexture(GLES20.GL_TEXTURE1);
        GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, tex[0]);
        GLES20.glUniform1i(abTextureUniform_second, 1);
        frameData.position(pixelAmounts);
        GLES20.glActiveTexture(GLES20.GL_TEXTURE2);
        GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, tex[2]);
        GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_LUMINANCE_ALPHA, size.width / 2, size.height / 2, 0, GLES20.GL_LUMINANCE_ALPHA, GLES20.GL_UNSIGNED_BYTE, frameData);
        GLES20.glUniform1i(chrominanceTextureUniform_second, 2);
        GLES20.glUniform1f(betaUniform_second, beta);
        GLES20.glUniform1f(widthUniform_second, 1.0f / size.width);
        GLES20.glUniform1f(heightUniform_second, 1.0f / size.height);
        GLES20.glClear(GLES20.GL_DEPTH_BUFFER_BIT | GLES20.GL_COLOR_BUFFER_BIT);
        GLES20.glDrawArrays(GLES20.GL_TRIANGLE_FAN, 0, 4);
        GLES20.glDisableVertexAttribArray(positionAttr_second);
        GLES20.glDisableVertexAttribArray(texCoordAttr_second);
/*        GLES20.glActiveTexture(GLES20.GL_TEXTURE0);
        GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, tex[0]);
        GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_LUMINANCE, size.width, size.height, 0, GLES20.GL_LUMINANCE, GLES20.GL_UNSIGNED_BYTE, frameData);
        GLES20.glUniform1i(tex0Uniform_rgb, 0);
        GLES20.glUniform1f(widthUniform, 1.0f / size.width);
        GLES20.glUniform1f(heightUniform, 1.0f / size.height);
        frameData.position(pixelAmounts);
        GLES20.glActiveTexture(GLES20.GL_TEXTURE1);
        GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, tex[1]);
        GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_LUMINANCE_ALPHA, size.width / 2, size.height / 2, 0, GLES20.GL_LUMINANCE_ALPHA, GLES20.GL_UNSIGNED_BYTE, frameData);
        GLES20.glUniform1i(tex1Uniform_rgb, 1);
        GLES20.glUniform1f(Uniform_beta, beta);
        GLES20.glUniform1f(photometricVarianceUniform,photometricVariance);
        GLES20.glUniform1f(spatialVarianceUniform, spatialVariance);
        Log.i("params", "beta:"+beta + ",photometricVariance:"+photometricVariance + ",spatialVariance:" + spatialVariance);

        // added
        GLES20.glClear(GLES20.GL_DEPTH_BUFFER_BIT | GLES20.GL_COLOR_BUFFER_BIT);

        GLES20.glDrawArrays(GLES20.GL_TRIANGLE_FAN, 0, 4);

        // added
        GLES20.glViewport(viewOrigin_X, viewOrigin_Y, viewWidth, viewHeight);
*/

 /*       GLES20.glDisableVertexAttribArray(positionAttr_rgb);
        GLES20.glDisableVertexAttribArray(texCoordAttr_rgb);*/
    }
}
