using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EdgeDetectNormalsAndDepth : PostEffectsBase{
   public Shader edgeDetectShader;
	private Material edgeDetectMaterial = null;
	public Material material {  
		get {
			edgeDetectMaterial = CheckShaderAndCreateMaterial(edgeDetectShader, edgeDetectMaterial);
			return edgeDetectMaterial;
		}  
	}
    //提供调整边缘线强度，描边颜色以及背景颜色的参数，控制采样距离和对深度和法线进行边缘检测时的灵敏度参数
	[Range(0.0f, 1.0f)]
	public float edgesOnly = 0.0f;

	public Color edgeColor = Color.black;

	public Color backgroundColor = Color.white;

	public float sampleDistance = 1.0f;

	public float sensitivityDepth = 1.0f;

	public float sensitivityNormals = 1.0f;
	
	void OnEnable() {
		GetComponent<Camera>().depthTextureMode |= DepthTextureMode.DepthNormals;
	}

    [ImageEffectOpaque] //控制仅对不透明物体进行描边
	void OnRenderImage (RenderTexture src, RenderTexture dest) {
		if (material != null) {
			material.SetFloat("_EdgeOnly", edgesOnly);
			material.SetColor("_EdgeColor", edgeColor);
			material.SetColor("_BackgroundColor", backgroundColor);
			material.SetFloat("_SampleDistance", sampleDistance);
			material.SetVector("_Sensitivity", new Vector4(sensitivityNormals, sensitivityDepth, 0.0f, 0.0f));

			Graphics.Blit(src, dest, material);
		} else {
			Graphics.Blit(src, dest);
		}
	}

}
