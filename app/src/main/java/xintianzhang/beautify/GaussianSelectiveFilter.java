package xintianzhang.beautify;

import android.hardware.Camera;
import android.opengl.GLES20;

import java.nio.ByteBuffer;
import java.nio.FloatBuffer;

/**
 * Created by Administrator on 2015/9/10.
 */
public class GaussianSelectiveFilter extends FilterBase{
    private final int guassian5x5_program;
    private final int[] tex;
    private final FloatBuffer vertexBuffer;
    private final FloatBuffer textureCoordinateBuffer;
    private final int positionAttr;
    private final int texCoordAttr;
    private final int widthUniform;
    private final int heightUniform;
    private final int luminanceTexUniform;
    private final int chrominanceTextureUniform;
    private final int betaUniform;
    private final int thresholdUniform;

    public GaussianSelectiveFilter(OpenGLESSupervisor instance) {
        super(instance);
        guassian5x5_program = glInstance.buildShaderProgram(R.raw.gaussian_selective_vertex, R.raw.gaussian_selective_fragment);
        tex = glInstance.getTex();
        vertexBuffer = glInstance.getVertexBuffer();
        textureCoordinateBuffer = glInstance.getTextureCoordinatesBuffer();
        positionAttr = GLES20.glGetAttribLocation(guassian5x5_program, "position");
        texCoordAttr = GLES20.glGetAttribLocation(guassian5x5_program, "inputTextureCoordinate");
        widthUniform =GLES20.glGetUniformLocation(guassian5x5_program, "texelWidth");
        heightUniform =GLES20.glGetUniformLocation(guassian5x5_program, "texelHeight");
        luminanceTexUniform = GLES20.glGetUniformLocation(guassian5x5_program, "luminanceTex");
        chrominanceTextureUniform =  GLES20.glGetUniformLocation(guassian5x5_program, "chrominanceTex");
        betaUniform = GLES20.glGetUniformLocation(guassian5x5_program, "beta");
        thresholdUniform = GLES20.glGetUniformLocation(guassian5x5_program, "threshold");
    }

    @Override
    public void draw(byte[] frameData_byte, Camera.Size size, int pixelAmounts, float beta, float threshold) {
        ByteBuffer frameData = ByteBuffer.wrap(frameData_byte);
        frameData.position(0);
        GLES20.glUseProgram(guassian5x5_program);
        GLES20.glVertexAttribPointer(positionAttr, COORDS_PER_VERTEX, GLES20.GL_FLOAT, false, 0, vertexBuffer);
        GLES20.glEnableVertexAttribArray(positionAttr);
        GLES20.glVertexAttribPointer(texCoordAttr, COORDS_PER_VERTEX, GLES20.GL_FLOAT, false, 0, textureCoordinateBuffer);
        GLES20.glEnableVertexAttribArray(texCoordAttr);
        GLES20.glActiveTexture(GLES20.GL_TEXTURE0);
        GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, tex[1]);
        GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_LUMINANCE, size.width, size.height, 0, GLES20.GL_LUMINANCE, GLES20.GL_UNSIGNED_BYTE, frameData);
        GLES20.glUniform1i(luminanceTexUniform, 0);
        frameData.position(pixelAmounts);
        GLES20.glActiveTexture(GLES20.GL_TEXTURE2);
        GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, tex[2]);
        GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_LUMINANCE_ALPHA, size.width / 2, size.height / 2, 0, GLES20.GL_LUMINANCE_ALPHA, GLES20.GL_UNSIGNED_BYTE, frameData);
        GLES20.glUniform1i(chrominanceTextureUniform, 2);
        GLES20.glUniform1f(betaUniform, beta);
        GLES20.glUniform1f(thresholdUniform, threshold);
        GLES20.glUniform1f(widthUniform, 1.0f / size.width);
        GLES20.glUniform1f(heightUniform, 1.0f / size.height);
        GLES20.glDrawArrays(GLES20.GL_TRIANGLE_FAN, 0, 4);
        GLES20.glDisableVertexAttribArray(positionAttr);
        GLES20.glDisableVertexAttribArray(texCoordAttr);
    }
}
