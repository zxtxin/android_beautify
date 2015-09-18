package xintianzhang.beautify;

import android.content.Context;
import android.hardware.Camera;
import android.opengl.GLSurfaceView;
import android.util.Log;
import android.view.WindowManager;

import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.opengles.GL10;

import static android.opengl.GLES20.glClearColor;
import static android.opengl.GLES20.glViewport;

/**
 * Created by zxtxin on 2014/11/25.
 */
public class GLRenderer implements GLSurfaceView.Renderer {

    private final int pixelAmounts;
    private final Camera.Size mPreviewSize;
    private Context context;
    public FilterBase filter;

    OpenGLESSupervisor glesInstance;
    private byte[] rawData;
    private boolean drawFrameFinished = false;
    int[] mScreenSize;// 屏幕尺寸
    // 视野窗口位置及尺寸
    int mLeft, mTop, mWidth, mHeight;
    private float threshold = 21f/255;
    private GaussianSigma3Filter gaussianSigma3Filter;
    private GaussianSigma1Filter gaussianSigma1Filter;
    private GaussianSigma10Filter gaussianSigma10Filter;
    private RawFilter rawFilter;
    private boolean filterSetting = false;
    private int whiten =0;
    private float alpha = 0.0f;

    public GLRenderer(Context context, Camera.Size size, int pixelAmounts) {
        this.context = context;
        this.mPreviewSize = size;
        this.pixelAmounts = pixelAmounts;
    }

    @Override
    public void onSurfaceCreated(GL10 gl, EGLConfig config) {
        glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
        glesInstance = new OpenGLESSupervisor(context);
        gaussianSigma10Filter = new GaussianSigma10Filter(glesInstance);
   //     gaussianSigma1Filter = new GaussianSigma1Filter(glesInstance);
    //    gaussianSigma3Filter = new GaussianSigma3Filter(glesInstance);
     //   rawFilter = new RawFilter(glesInstance);
        filter = gaussianSigma10Filter;
        mScreenSize = getScreenSize(context);// 获取屏幕尺寸
        setViewPortSize(0, 0, 100);// 设置初始视野窗口位置及尺寸
    }

    @Override
    public void onSurfaceChanged(GL10 gl, int width, int height) {
        glViewport(0, 0, width, height);
        if(filter!= null)
            filter.setViewPort(0, 0, width,height);
    }
    public void setCapturedData(byte[] rawData) {
        this.rawData = rawData;
    }

    @Override
    public void onDrawFrame(GL10 gl) {
        if(rawData!=null) {
            drawFrameFinished = false;
            while(filterSetting==true);

//            long startTime, endTime;
//            startTime=System.nanoTime();// 获取开始时间
            filter.draw(rawData,mPreviewSize ,pixelAmounts, threshold, alpha,whiten);
//            endTime=System.nanoTime();// 获取结束时间
//            Log.i("onDrawFrame运行时间：", (endTime - startTime) + "ns");
            drawFrameFinished = true;
        }
    }

    public int[] getScreenSize(Context context)
    {
        //获取屏幕尺寸
        int[] screenSize = new int[2];
        WindowManager wm=(WindowManager)context.getSystemService(Context.WINDOW_SERVICE);
        screenSize[0] = wm.getDefaultDisplay().getWidth();// 屏幕宽度
        screenSize[1] = wm.getDefaultDisplay().getHeight();// 屏幕高度
        Log.i("screenWidth * screenHeight", "" + screenSize[0] + " * " + screenSize[1]);
        return screenSize;
    }

    public void setRawFilter()
    {
        while (drawFrameFinished==false);
        filterSetting = true;
        filter = rawFilter;
        filter.setViewPort(mLeft, mTop, mWidth, mHeight);
        filterSetting = false;

    }
    public void setGaussianSigma1Filter()
    {
        while (drawFrameFinished==false);
        filterSetting = true;
        filter = gaussianSigma1Filter;
        filter.setViewPort(mLeft, mTop, mWidth, mHeight);
        filterSetting = false;
    }
    public void setGaussianSigma3Filter()
    {
        while (drawFrameFinished==false);
        filterSetting = true;
        filter =gaussianSigma3Filter;
        filter.setViewPort(mLeft, mTop, mWidth, mHeight);
        filterSetting = false;
    }
    public void setGaussianSigma10Filter()
    {
        while (drawFrameFinished==false);
        filterSetting = true;
        filter = gaussianSigma10Filter;
        filter.setViewPort(mLeft, mTop, mWidth, mHeight);
        filterSetting = false;
    }

    public void setViewPortSize(int viewX, int viewY, int percentageOfSize)
    {
        float ratioOfSize = percentageOfSize/100.0f;
        mWidth = (int)(ratioOfSize * mScreenSize[0]);
        mHeight = (int)(ratioOfSize * mScreenSize[1]);
        mLeft = viewX;
        mTop = mScreenSize[1] - mHeight - viewY;
        filter.setViewPort(mLeft, mTop, mWidth, mHeight);
    }


    public void setAlpha(float alpha) {
        this.alpha = alpha;
    }
    public void setWhiten(int whiten){ this.whiten = whiten;}

}
