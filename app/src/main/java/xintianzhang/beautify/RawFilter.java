package xintianzhang.beautify;

import android.hardware.Camera;
import android.opengl.GLES20;

import java.nio.ByteBuffer;
import java.nio.FloatBuffer;

/**
 * Created by Administrator on 2015/9/16.
 */
public class RawFilter extends FilterBase{

    private final int[] tex;
    private final FloatBuffer vertexBuffer;
    private final FloatBuffer textureCoordinateBuffer;

    private final int chrominanceTextureUniform;


    private final int procedure_2;
    private final int positionAttr_2;
    private final int texCoordAttr_2;

    private final int luminanceTexUniform_2;
    private final int[] fbo;


    public RawFilter(OpenGLESSupervisor instance) {
        super(instance);
        fbo = glInstance.getFBO();
        tex = glInstance.getTex();
        vertexBuffer = glInstance.getVertexBuffer();
        textureCoordinateBuffer = glInstance.getTextureCoordinatesBuffer();
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
        frameData.position(0);
        GLES20.glViewport(0, 0, viewWidth, viewHeight);
        GLES20.glUseProgram(procedure_2);
        GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, 0);
        GLES20.glVertexAttribPointer(positionAttr_2, COORDS_PER_VERTEX, GLES20.GL_FLOAT, false, 0, vertexBuffer);
        GLES20.glEnableVertexAttribArray(positionAttr_2);
        GLES20.glVertexAttribPointer(texCoordAttr_2, COORDS_PER_VERTEX, GLES20.GL_FLOAT, false, 0, textureCoordinateBuffer);
        GLES20.glEnableVertexAttribArray(texCoordAttr_2);
        GLES20.glActiveTexture(GLES20.GL_TEXTURE0);
        GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, tex[1]);
        GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_LUMINANCE, size.width, size.height, 0, GLES20.GL_LUMINANCE, GLES20.GL_UNSIGNED_BYTE, frameData);
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
