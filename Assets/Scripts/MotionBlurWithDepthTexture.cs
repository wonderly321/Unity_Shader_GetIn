using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MotionBlurWithDepthTexture : PostEffectsBase {
    public Shader motionBlurShader;
    private Material motionBlurMaterial = null;
    public Material material {
        get {
            motionBlurMaterial = CheckShaderAndCreateMaterial(motionBlurShader, motionBlurMaterial);
            return motionBlurMaterial;
        }
    }
    
    private Camera myCamera;
    public Camera camera {
        get {
            if(myCamera == null) {
                myCamera = GetComponent<Camera>();
            }
            return myCamera;
        }
    }

    //定义模糊运动模糊时模糊图像使用的大小
    [Range(0.0f, 1.0f)]
    public float blurSize = 0.5f;

    private Matrix4x4 previousViewProjectionMatrix;

    void OnEnable() {
        GetComponent<Camera>().depthTextureMode |= DepthTextureMode.Depth;
        previousViewProjectionMatrix = GetComponent<Camera>().projectionMatrix * GetComponent<Camera>().worldToCameraMatrix;
    }
    void OnRenderImage (RenderTexture src, RenderTexture dest) {
        if(material != null) {
            material.SetFloat("_BlurSize", blurSize);

            material.SetMatrix("_PreviousViewProjectionMatrix", previousViewProjectionMatrix);
            Matrix4x4 currentViewProjectionMatrix = GetComponent<Camera>().projectionMatrix * GetComponent<Camera>().worldToCameraMatrix;
            Matrix4x4 currentViewProjectionInverseMatrix = currentViewProjectionMatrix.inverse;
            material.SetMatrix("_CurrentViewProjectionInverseMatrix", currentViewProjectionInverseMatrix);
            previousViewProjectionMatrix = currentViewProjectionMatrix;

            Graphics.Blit(src, dest, material);
        }
        else {
            Graphics.Blit(src, dest);
        }
    }
}
