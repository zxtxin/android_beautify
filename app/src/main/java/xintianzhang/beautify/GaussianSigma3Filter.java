package xintianzhang.beautify;

import android.hardware.Camera;
import android.opengl.GLES20;

import java.nio.ByteBuffer;
import java.nio.FloatBuffer;

/**
 * Created by Administrator on 2015/9/10.
 */
public class GaussianSigma3Filter extends FilterBase{

    private final int[] tex;
    private final FloatBuffer vertexBuffer;
    private final FloatBuffer textureCoordinateBuffer;
    private final int positionAttr;
    private final int texCoordAttr;
    private final int widthUniform;
    private final int heightUniform;
    private final int luminanceTexUniform;
    private final int chrominanceTextureUniform;

    private final int thresholdUniform;
    private final FloatBuffer firstProgramtextureCoordinateBuffer;
    private final int program;
    private final int procedure_2;
    private final int positionAttr_2;
    private final int texCoordAttr_2;

    private final int luminanceTexUniform_2;
    private final int[] fbo;
    private final int dirUniform;

    public GaussianSigma3Filter(OpenGLESSupervisor instance) {
        super(instance);
        fbo = glInstance.getFBO();
        program = glInstance.buildShaderProgram(R.raw.gaussian_vertex, R.raw.gaussian_sigma3_fragment);
        tex = glInstance.getTex();
        vertexBuffer = glInstance.getVertexBuffer();
        textureCoordinateBuffer = glInstance.getTextureCoordinatesBuffer();
        positionAttr = GLES20.glGetAttribLocation(program, "position");
        texCoordAttr = GLES20.glGetAttribLocation(program, "inputTextureCoordinate");
        widthUniform =GLES20.glGetUniformLocation(program, "texelWidth");
        heightUniform =GLES20.glGetUniformLocation(program, "texelHeight");
        luminanceTexUniform = GLES20.glGetUniformLocation(program, "luminanceTex");
        dirUniform = GLES20.glGetUniformLocation(program, "dir");

        thresholdUniform = GLES20.glGetUniformLocation(program, "threshold");

        firstProgramtextureCoordinateBuffer = glInstance.getFirstProgramtextureCoordinateBuffer();

        procedure_2 = glInstance.buildShaderProgram(R.raw.yuv2rgb_vertex, R.raw.yuv2rgb_fragment);
        positionAttr_2 = GLES20.glGetAttribLocation(procedure_2, "position");
        texCoordAttr_2 = GLES20.glGetAttribLocation(procedure_2, "inputTextureCoordinate");

        luminanceTexUniform_2 = GLES20.glGetUniformLocation(procedure_2, "luminanceTex");
        chrominanceTextureUniform =  GLES20.glGetUniformLocation(procedure_2, "chrominanceTex");

    }

    @Override
    public void draw(byte[] frameData_byte, Camera.Size size, int pixelAmounts, float threshold, float alpha, int whiten) {
        ByteBuffer frameData = ByteBuffer.wrap(frameData_byte);
        GLES20.glClear(GLES20.GL_COLOR_BUFFER_BIT);
        GLES20.glViewport(0, 0, size.width, size.height);
        frameData.position(0);
        GLES20.glUseProgram(program);

        GLES20.glVertexAttribPointer(positionAttr, COORDS_PER_VERTEX, GLES20.GL_FLOAT, false, 0, vertexBuffer);
        GLES20.glEnableVertexAttribArray(positionAttr);
        GLES20.glVertexAttribPointer(texCoordAttr, COORDS_PER_VERTEX, GLES20.GL_FLOAT, false, 0, firstProgramtextureCoordinateBuffer);
        GLES20.glEnableVertexAttribArray(texCoordAttr);

        GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, tex[0]);
        GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_RGBA, size.width, size.height, 0, GLES20.GL_RGBA, GLES20.GL_UNSIGNED_BYTE, null);
        GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, fbo[0]);
        GLES20.glFramebufferTexture2D(GLES20.GL_FRAMEBUFFER, GLES20.GL_COLOR_ATTACHMENT0, GLES20.GL_TEXTURE_2D, tex[0], 0);

        GLES20.glActiveTexture(GLES20.GL_TEXTURE0);
        GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, tex[1]);
        GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_LUMINANCE, size.width, size.height, 0, GLES20.GL_LUMINANCE, GLES20.GL_UNSIGNED_BYTE, frameData);
        GLES20.glUniform1i(luminanceTexUniform, 0);
        GLES20.glUniform1f(thresholdUniform, threshold);
        GLES20.glUniform1f(widthUniform, 1.0f / size.width);
        GLES20.glUniform1f(heightUniform, 1.0f / size.height);
        GLES20.glUniform1i(dirUniform, 0);

        GLES20.glDrawArrays(GLES20.GL_TRIANGLE_FAN, 0, 4);

        GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, tex[1]);
        GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_RGBA, size.width, size.height, 0, GLES20.GL_RGBA, GLES20.GL_UNSIGNED_BYTE, null);
        GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, fbo[1]);
        GLES20.glFramebufferTexture2D(GLES20.GL_FRAMEBUFFER, GLES20.GL_COLOR_ATTACHMENT0, GLES20.GL_TEXTURE_2D, tex[1], 0);
 //       GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, 0);
        GLES20.glActiveTexture(GLES20.GL_TEXTURE1);
        GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, tex[0]);
        GLES20.glUniform1i(luminanceTexUniform, 1);
        GLES20.glUniform1i(dirUniform, 1);

        GLES20.glDrawArrays(GLES20.GL_TRIANGLE_FAN, 0, 4);
        GLES20.glDisableVertexAttribArray(positionAttr);
        GLES20.glDisableVertexAttribArray(texCoordAttr);

        GLES20.glViewport(0, 0, viewWidth, viewHeight);
        GLES20.glUseProgram(procedure_2);
        GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, 0);
        GLES20.glVertexAttribPointer(positionAttr_2, COORDS_PER_VERTEX, GLES20.GL_FLOAT, false, 0, vertexBuffer);
        GLES20.glEnableVertexAttribArray(positionAttr_2);
        GLES20.glVertexAttribPointer(texCoordAttr_2, COORDS_PER_VERTEX, GLES20.GL_FLOAT, false, 0, textureCoordinateBuffer);
        GLES20.glEnableVertexAttribArray(texCoordAttr_2);
        GLES20.glActiveTexture(GLES20.GL_TEXTURE0);
        GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, tex[1]);
        GLES20.glUniform1i(luminanceTexUniform_2, 0);
        frameData.position(pixelAmounts);
        GLES20.glActiveTexture(GLES20.GL_TEXTURE2);
        GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, tex[2]);
        GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_LUMINANCE_ALPHA, size.width / 2, size.height / 2, 0, GLES20.GL_LUMINANCE_ALPHA, GLES20.GL_UNSIGNED_BYTE, frameData);
        GLES20.glUniform1i(chrominanceTextureUniform, 2);


        GLES20.glDrawArrays(GLES20.GL_TRIANGLE_FAN, 0, 4);
        GLES20.glDisableVertexAttribArray(positionAttr_2);
        GLES20.glDisableVertexAttribArray(texCoordAttr_2);
    }
}
