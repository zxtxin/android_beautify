package xintianzhang.beautify;

import android.app.Activity;
import android.graphics.ImageFormat;
import android.hardware.Camera;
import android.opengl.GLSurfaceView;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.GestureDetector;
import android.view.Menu;
import android.view.MenuItem;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;
import android.widget.SeekBar;
import android.widget.Toast;

import java.io.IOException;
import android.view.ViewGroup.LayoutParams;
import android.widget.ToggleButton;

public class MainActivity extends Activity implements SurfaceHolder.Callback, Camera.PreviewCallback{

    private GLSurfaceView glSurfaceView;
    private GLRenderer renderer;
    private Camera mCamera;
    private Camera.Parameters params;
    private Camera.Size previewSize;
    private int pixelAmounts;
    private int callbackBufferSize;
    private byte[] mCallbackBuffer;
    private SurfaceView surfaceView;
    private SurfaceHolder mHolder;
    private SeekBar seekBar;
    private ToggleButton toggleButton;





    protected void onCreate(Bundle savedInstanceState) {
        Log.i("Activity", "---------->>onCreate");
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_main);
        RelativeLayout top=(RelativeLayout)findViewById(R.id.relative_layout);
        surfaceView = (SurfaceView)findViewById(R.id.surfaceView);
        glSurfaceView = (GLSurfaceView)findViewById(R.id.glSurfaceView);
   //     radioGroup = (RadioGroup)findViewById(R.id.radio_group);
        mHolder = surfaceView.getHolder();
        mHolder.addCallback(this);

        Initialize_1();
        renderer = new GLRenderer(this,previewSize,pixelAmounts);



//        frameData = ByteBuffer.allocateDirect(callbackBufferSize);

        glSurfaceView.setEGLContextClientVersion(2);
        glSurfaceView.setRenderer(renderer);
        glSurfaceView.setRenderMode(GLSurfaceView.RENDERMODE_WHEN_DIRTY);
 /*       radioGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                switch (checkedId) {
                    case R.id.radioButton0:
                        renderer.setRawFilter();
                        break;
                    case R.id.radioButton1:
                        renderer.setGaussianSigma1Filter();
                        break;
                    case R.id.radioButton2:
                        renderer.setGaussianSigma3Filter();
                        break;
                    case R.id.radioButton3:
                        renderer.setGaussianSigma10Filter();
                        break;
                    default:
                }
            }
        });*/
        seekBar = (SeekBar)findViewById(R.id.seekBar);
        seekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                    renderer.setAlpha(progress/100f);
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        });
        toggleButton = (ToggleButton)findViewById(R.id.toggleButton);
        toggleButton.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(isChecked)
                    renderer.setWhiten(1);
                else
                    renderer.setWhiten(0);
            }
        });

        top.setKeepScreenOn(true);

    }

    public void Initialize_1()
    {
        mCamera = Camera.open(1);
        params = mCamera.getParameters();
  //      params.setPreviewSize(640,360);
  //      params.setPreviewFpsRange(30000,30000);
        params.setPreviewFormat(ImageFormat.NV21);
        previewSize = params.getPreviewSize();
        pixelAmounts = previewSize.height*previewSize.width;
        mCamera.setParameters(params);
        callbackBufferSize = pixelAmounts * 3/2;
        mCallbackBuffer = new byte[callbackBufferSize];
 //       mCamera.setDisplayOrientation(90);


    }




    protected void onResume() {
        Log.i("Activity", "---------->>onResume");
        super.onResume();
        glSurfaceView.onResume();
        if (mCamera == null) {
            Initialize_1();

        }
    }


    protected void onPause() {
        Log.i("Activity", "---------->>onPause");
        super.onPause();
        glSurfaceView.onPause();
        if(mCamera!= null) {
            mCamera.setPreviewCallback(null);
            mCamera.stopPreview();
            mCallbackBuffer = null;
            mCamera.release();
            mCamera = null;
        }

    }


    protected void onDestroy() {
        Log.i("Activity", "---------->>onDestroy");
        super.onDestroy();
    }


    public void surfaceCreated(SurfaceHolder holder) {

    }


    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
        try {
            mCamera.setPreviewDisplay(holder);
        } catch (IOException e) {
            e.printStackTrace();
        }
        mCamera.setPreviewCallbackWithBuffer(this);
        mCamera.addCallbackBuffer(mCallbackBuffer);
        mCamera.startPreview();
        mCamera.setDisplayOrientation(90);
        mCamera.startFaceDetection();
    }


    public void surfaceDestroyed(SurfaceHolder holder) {

    }

    public void onPreviewFrame(byte[] data, Camera camera) {
   //     Log.i("FaceDetection", "" + params.getMaxNumDetectedFaces());
//        frameData.position(0);
//        frameData.put(data);
        renderer.setCapturedData(data);
        glSurfaceView.requestRender();
        mCamera.addCallbackBuffer(mCallbackBuffer);
    }




}